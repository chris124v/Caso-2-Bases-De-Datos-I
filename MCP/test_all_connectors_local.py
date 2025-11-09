import os
import sys
import asyncio
import yaml
import traceback
from typing import Dict, Any

# Ensure MCP/src is importable
ROOT = os.path.join(os.path.dirname(__file__), "src")
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from local_runner import load_config, build_connectors_from_config

CONFIG_PATH = os.path.join(os.path.dirname(__file__), "local_config.yaml")

async def main():
    cfg = load_config(CONFIG_PATH)
    if not cfg:
        example = os.path.join(os.path.dirname(__file__), "local_config.yaml.example")
        print(f"No local config found at {CONFIG_PATH}. You can copy the example from {example} and edit it.")
        # still try loading example to give at least a default
        cfg = load_config(example)
        if not cfg:
            print("No configuration available; exiting.")
            return

    connectors = await build_connectors_from_config(cfg)
    if not connectors:
        print("No connectors configured. Check your local_config.yaml")
        return

    results: Dict[str, Dict[str, Any]] = {}

    for name, conn in connectors.items():
        print(f"Testing connector: {name}")
        try:
            # call test_connection
            ok = await conn.test_connection()
            results[name] = {"ok": bool(ok), "error": None}
            print(f" - test_connection: {ok}")
            # If test_connection returned False (no exception), try a debug execute to get the underlying error
            if not ok:
                try:
                    if hasattr(conn, 'execute_query'):
                        try:
                            debug_res = await conn.execute_query("SELECT 1")
                            print(f" - debug execute_query returned: {debug_res}")
                        except Exception as de:
                            print(f" - debug execute_query error: {de}")
                            print(traceback.format_exc())
                except Exception:
                    pass
            # if ok and connector has get_schema, try a quick schema call
            get_schema = getattr(conn, "get_schema", None)
            if ok and get_schema is not None:
                try:
                    schema = await conn.get_schema()
                    results[name]["schema"] = schema
                    print(f" - schema: {schema if schema is not None else 'None'}")
                except Exception as e:
                    results[name]["schema_error"] = str(e)
                    print(f" - error retrieving schema: {e}")
                    print(traceback.format_exc())
        except Exception as e:
            results[name] = {"ok": False, "error": str(e)}
            print(f" - connection error: {e}")
            print(traceback.format_exc())
            # Extra debug: try a simple execute_query to surface driver errors (may fail for non-SQL connectors)
            try:
                if hasattr(conn, 'execute_query'):
                    try:
                        # attempt a small query to force the underlying driver to raise a detailed exception
                        debug_res = await conn.execute_query("SELECT 1")
                        print(f" - debug execute_query returned: {debug_res}")
                    except Exception as de:
                        print(f" - debug execute_query error: {de}")
                        print(traceback.format_exc())
            except Exception:
                pass

    print("\nSummary:")
    for name, r in results.items():
        print(f" - {name}: ok={r.get('ok')} error={r.get('error')}")

    # Close pools if any
    closing = []
    for conn in connectors.values():
        close = getattr(conn, "close", None)
        if close and asyncio.iscoroutinefunction(close):
            closing.append(close())
    if closing:
        await asyncio.gather(*closing)

if __name__ == '__main__':
    asyncio.run(main())
