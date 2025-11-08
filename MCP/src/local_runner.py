import os
import sys
import asyncio
import yaml
from typing import Any, Dict

# Ensure the connectors package is importable when running this module as a script
# (when PYTHONPATH is not set). If you run with PYTHONPATH=/path/to/MCP/src this is not needed.
ROOT = os.path.dirname(os.path.dirname(__file__))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from connectors.postgresql_k8s_connector import PostgreSQLK8sConnector
from connectors.mongo_k8s_connector import MongoDBK8sConnector
from connectors.sqlserver_k8s_connector import SQLServerK8sConnector


DEFAULT_CONFIG_PATH = os.path.join(os.path.dirname(os.path.dirname(__file__)), "local_config.yaml")


def load_config(path: str) -> Dict[str, Any]:
    if not os.path.exists(path):
        return {}
    with open(path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f) or {}


async def interactive_repl(connectors: Dict[str, Any]):
    print("Local MCP runner — modo interactivo")
    print("Conectores disponibles:")
    for k in connectors:
        print(f" - {k}")

    while True:
        db = input("Selecciona conector (o 'exit' para salir): ").strip()
        if not db or db.lower() in ("exit", "quit"):
            break
        connector = connectors.get(db)
        if not connector:
            print("Conector no encontrado. Intenta de nuevo.")
            continue

        query = input("Introduce la consulta (para MongoDB puede ser JSON, para SQL p. ej. SELECT ...): ").strip()
        if not query:
            print("Consulta vacía — cancelada")
            continue

        try:
            # execute_query is async
            results = await connector.execute_query(query)
            print("Resultados:")
            for row in results:
                print(row)
        except Exception as e:
            print(f"Error ejecutando la consulta: {e}")


async def build_connectors_from_config(cfg: Dict[str, Any]) -> Dict[str, Any]:
    connectors: Dict[str, Any] = {}

    # PostgreSQL
    pg_cfg = cfg.get("postgresql")
    if pg_cfg:
        connectors["postgresql"] = PostgreSQLK8sConnector(
            service_name=pg_cfg.get("service_name", "localhost"),
            database=pg_cfg.get("database", "postgres"),
            username=pg_cfg.get("username", "postgres"),
            password=pg_cfg.get("password", ""),
            namespace=pg_cfg.get("namespace", "default"),
            use_k8s_service=bool(pg_cfg.get("use_k8s_service", False)),
        )

    # MongoDB
    mongo_cfg = cfg.get("mongodb")
    if mongo_cfg:
        connectors["mongodb"] = MongoDBK8sConnector(
            service_name=mongo_cfg.get("service_name", "localhost"),
            database=mongo_cfg.get("database", "admin"),
            username=mongo_cfg.get("username", ""),
            password=mongo_cfg.get("password", ""),
            namespace=mongo_cfg.get("namespace", "default"),
            use_k8s_service=bool(mongo_cfg.get("use_k8s_service", False)),
        )

    # SQL Server
    sql_cfg = cfg.get("sqlserver")
    if sql_cfg:
        connectors["sqlserver"] = SQLServerK8sConnector(
            service_name=sql_cfg.get("service_name", "localhost"),
            database=sql_cfg.get("database", "master"),
            username=sql_cfg.get("username", "sa"),
            password=sql_cfg.get("password", ""),
            namespace=sql_cfg.get("namespace", "default"),
            use_k8s_service=bool(sql_cfg.get("use_k8s_service", False)),
        )

    return connectors


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Local runner for MCP connectors (development)")
    parser.add_argument("--config", "-c", dest="config", default=DEFAULT_CONFIG_PATH,
                        help="Path to local YAML config (defaults to MCP/local_config.yaml)")
    args = parser.parse_args()

    cfg = load_config(args.config)
    if not cfg:
        print(f"No se encontró configuración en {args.config}. Puedes crear {args.config} o usar variables de entorno.")

    connectors = asyncio.run(build_connectors_from_config(cfg))
    if not connectors:
        print("No se encontraron conectores configurados. Crea un archivo de ejemplo 'MCP/local_config.yaml.example' o pasa parámetros.")
        return

    try:
        asyncio.run(interactive_repl(connectors))
    finally:
        # cerrar pools si existen
        closing_tasks = []
        for conn in connectors.values():
            close = getattr(conn, "close", None)
            if close and asyncio.iscoroutinefunction(close):
                closing_tasks.append(close())
        if closing_tasks:
            asyncio.run(asyncio.gather(*closing_tasks))


if __name__ == "__main__":
    main()
