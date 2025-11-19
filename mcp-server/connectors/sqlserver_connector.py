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
        
    async def test_connection(self) -> bool:
        try:
            conn = pyodbc.connect(self.connection_string)
            conn.close()
            return True
        except Exception as e:
            print(f"SQL Server connection error: {e}")
            return False