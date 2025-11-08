from mcp.server import Server
import mcp.types as types
import os

from connectors.mongo_k8s_connector import MongoDBK8sConnector
from connectors.sqlserver_k8s_connector import SQLServerK8sConnector
from connectors.postgresql_k8s_connector import PostgreSQLK8sConnector
from config.k8s_config_manager import K8sConfigManager

class K8sDatabaseMCPServer:
    def __init__(self):
        self.server = Server("k8s-database-mcp-server")
        self.connectors = {}
        self.config_manager = K8sConfigManager()
        self.setup_handlers()

    async def initialize_from_k8s(self):
        #Inicializar conectores desde los secrets y condigMaps de k8s
        #Sacar la config del configMap
        db_config = self.config_manager.get_config_map("database-connections")

        #Start SQL Server 1
        sql1_secret = self.config_manager.get_secret("sqlserver1-credentials")
        self.connectors["sql1"] = SQLServerK8sConnector(
            service_name = db_config.get("SQL1_SERVICE", "sqlserver1-service"),
            database = sql1_secret.get("database"),
            username = sql1_secret.get("username"),
            password = sql1_secret.get("password"),
            namespace = db_config.get("SQL1_NAMESPACE", "default")
        )

        #Start SQL Server 2
        sql2_secret = self.config_manager.get_secret("sqlserver2-credentials")
        self.connectors["sql2"] = SQLServerK8sConnector(
            service_name = db_config.get("SQL2_SERVICE", "sqlserver2-service"),
            database = sql2_secret.get("database"),
            username = sql2_secret.get("username"),
            password = sql2_secret.get("password"),
            namespace = db_config.get("SQL2_NAMESPACE", "default")
        )

        #Start MongoDB
        mongodb_secret = self.config_manager.get_secret("mongodb-credentials")
        self.connectors["mongodb"] = MongoDBK8sConnector(
            service_name = db_config.get("MONGODB_SERVICE", "mongodb-service"),
            database = mongodb_secret.get("database"),
            username = mongodb_secret.get("username"),
            password = mongodb_secret.get("password"),
            namespace = db_config.get("MONGODB_NAMESPACE", "default")
        )
        #Start PostgreSQL
        postgresql_secret = self.config_manager.get_secret("postgresql-credentials")
        self.connectors["postgresql"] = PostgreSQLK8sConnector(
            service_name = db_config.get("POSTGRESQL_SERVICE", "postgresql-service"),
            database = postgresql_secret.get("database"),
            username = postgresql_secret.get("username"),
            password = postgresql_secret.get("password"),
            namespace = db_config.get("POSTGRESQL_NAMESPACE", "default")
        )

    async def _execute_query(self, database: str, query: str):
        connector = self.connectors.get(database)
        if not connector:
            return [types.TextContent(type = "text", text = f"Database {database} not dounf")]
        
        try:
            results = await connector.execute_query(query)
            return [types.TextContent(type = "text", text = str(results))]
        except Exception as e:
            return [types.TextContent(type = "text", text = f"Error; {str(e)}")]
        

async def create_server():
    server_instance = K8sDatabaseMCPServer()
    await server_instance.initialize_from_k8s()
    return server_instance.server