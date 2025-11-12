# server.py
from mcp.server import Server
import mcp.types as types

from connectors.mongo_connector import MongoDBConnector
from connectors.sqlserver_connector import SQLServerConnector
from connectors.postgresql_connector import PostgreSQLConnector
from config.config_manager import ConfigManager

class DatabaseMCPServer:
    def __init__(self):
        self.server = Server("database-mcp-server")
        self.connectors = {}
        self.config_manager = ConfigManager()
        self.setup_handlers()

    def setup_handlers(self):
        @self.server.list_tools()
        async def handle_list_tools() -> list[types.Tool]:
            return [
                types.Tool(
                    name="execute_query",
                    description="Execute query on database",
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "database": {
                                "type": "string",
                                "enum": ["mongodb", "sqlserver1", "sqlserver2", "postgresql"]
                            },
                            "query": {"type": "string"},
                            "parameters": {"type": "object"}
                        },
                        "required": ["database", "query"]
                    }
                ),
                types.Tool(
                    name="get_schema",
                    description="Get database schema",
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "database": {
                                "type": "string",
                                "enum": ["mongodb", "sqlserver1", "sqlserver2", "postgresql"]
                            },
                            "table": {"type": "string"}
                        },
                        "required": ["database"]
                    }
                )
            ]
        
        @self.server.call_tool()
        async def handle_call_tool(name: str, arguments: dict):
            if name == "execute_query":
                return await self._execute_query(**arguments)
            elif name == "get_schema":
                return await self._get_schema(**arguments)

    async def initialize_from_config(self):
        """Inicializar conectores desde YAML"""
        
        db_configs = self.config_manager.get_all_databases()
        
        # PostgreSQL
        pg_config = db_configs["postgresql"]
        self.connectors["postgresql"] = PostgreSQLConnector(
            host=pg_config["host"],
            port=pg_config["port"],
            database=pg_config["database"],
            username=pg_config["username"],
            password=pg_config["password"]
        )

        # MongoDB
        mongo_config = db_configs["mongodb"]
        self.connectors["mongodb"] = MongoDBConnector(
            host=mongo_config["host"],
            port=mongo_config["port"],
            database=mongo_config["database"],
            username=mongo_config.get("username"),  # Opcional
            password=mongo_config.get("password")   # Opcional
        )

        # SQL Server 1
        sql1_config = db_configs["sqlserver1"]
        self.connectors["sqlserver1"] = SQLServerConnector(
            host=sql1_config["host"],
            port=sql1_config["port"],
            database=sql1_config["database"],
            username=sql1_config["username"],
            password=sql1_config["password"]
        )

        # SQL Server 2
        sql2_config = db_configs["sqlserver2"]
        self.connectors["sqlserver2"] = SQLServerConnector(
            host=sql2_config["host"],
            port=sql2_config["port"],
            database=sql2_config["database"],
            username=sql2_config["username"],
            password=sql2_config["password"]
        )

    async def _execute_query(self, database: str, query: str, parameters: dict = None):
        connector = self.connectors.get(database)
        if not connector:
            return [types.TextContent(type="text", text=f"Database {database} not found")]
        
        try:
            results = await connector.execute_query(query, parameters or {})
            return [types.TextContent(type="text", text=str(results))]
        except Exception as e:
            return [types.TextContent(type="text", text=f"Error: {str(e)}")]

    async def _get_schema(self, database: str, table: str = None):
        connector = self.connectors.get(database)
        if not connector:
            return [types.TextContent(type="text", text=f"Database {database} not found")]
        
        try:
            schema = await connector.get_schema(table)
            return [types.TextContent(type="text", text=str(schema))]
        except Exception as e:
            return [types.TextContent(type="text", text=f"Error: {str(e)}")]

async def create_server():
    server_instance = DatabaseMCPServer()
    await server_instance.initialize_from_config()
    return server_instance.server