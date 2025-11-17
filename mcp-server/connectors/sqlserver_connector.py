import pyodbc
from .base_connector import BaseDatabaseConnector

class SQLServerConnector(BaseDatabaseConnector):
    def __init__(self, host: str, port: int, database: str, username: str, password: str):
        self.connection_string = (
            f"DRIVER={{ODBC Driver 17 for SQL Server}};"
            f"SERVER={host},{port};"  # Incluir puerto
            f"DATABASE={database};"
            f"UID={username};"
            f"PWD={password}"
        )

    async def execute_query(self, query: str, params: dict = None) -> list[dict]:
        import asyncio

        def sync_execute():
            conn = pyodbc.connect(self.connection_string)
            cursor = conn.cursor()
            
            # Convertir parámetros dict a tupla si es necesario
            param_values = tuple(params.values()) if params else ()
            cursor.execute(query, param_values)
            
            # Obtener column names
            if cursor.description:
                columns = [column[0] for column in cursor.description]
                results = [dict(zip(columns, row)) for row in cursor.fetchall()]
            else:
                results = []
                
            conn.close()
            return results
        
        return await asyncio.to_thread(sync_execute)
    
    async def get_schema(self, table_name: str = None) -> dict:
        if table_name:
            query = """
            SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = ?
            ORDER BY ORDINAL_POSITION
            """
            results = await self.execute_query(query, {"table_name": table_name})
            return {"table": table_name, "columns": results}
        else:
            query = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'"
            results = await self.execute_query(query)
            return {"tables": [row["TABLE_NAME"] for row in results]}
        
    async def test_connection(self) -> bool:
        try:
            conn = pyodbc.connect(self.connection_string)
            conn.close()
            return True
        except Exception as e:
            print(f"SQL Server connection error: {e}")
            return False