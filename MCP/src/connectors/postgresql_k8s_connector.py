import os
import asyncpg
from typing import List, Dict, Any
from .base_connector import BaseDatabaseConnector
from .k8s_aware_connector import KubernetesAwareConnector

class PostgreSQLK8sConnector(BaseDatabaseConnector, KubernetesAwareConnector):
    def __init__(self, service_name: str, database: str, username: str, password: str,
               namespace: str = "default", use_k8s_service: bool = True):
        KubernetesAwareConnector.__init__(self)

        if use_k8s_service:
            endpoint = self.get_service_endpoint(service_name, namespace)
            host, port = endpoint.split(":")
        else:
            host = service_name
            port = "5432"


        self.connection_string = f"postgresql://{username}:{password}@{host}:{port}/{database}"
        self.database = database

    async def execute_query(self, query: str, params: Dict = None) -> List[Dict]:
        try:
            conn = await asyncpg.connect(self.connection_string)
            result = await conn.fetch(query, *(params or {}).values())
            await conn.close()

            return [dict(record) for record in result]
        except Exception as e:
            raise Exception(f"PostgreSQL error: {str(e)}")
        
    async def get_schema(self, table_name: str = None) -> Dict:
        if table_name:
            query = """
                SELECT column_name, data_type, is_nullable
                FROM information_schema.columns
                WHERE table_name = $1
                ORDER BY ordinal_position;
            """
            results = await self.execute_query(query, {"table_name": table_name})
            return {"table": table_name, "columns": results}
        else:
            query = """
                SELECT table_name 
                FROM information_schema.tables 
                WHERE table_schema = 'public';
            """
            results = await self.execute_query(query)
            return {"tables": [row["table_name"] for row in results]}
        
    async def test_connection(self) -> bool:
        try:
            conn = await asyncpg.connect(self.connection_string)
            await conn.close()
            return True
        except:
            return False