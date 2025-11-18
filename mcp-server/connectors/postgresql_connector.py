import asyncpg
from .base_connector import BaseDatabaseConnector

class PostgreSQLConnector(BaseDatabaseConnector):
    def __init__(self, host: str, database: str, username: str, password: str, port: int = 5432):
        self.connection_string = f"postgresql://{username}:{password}@{host}:{port}/{database}"
        self.database = database
    

    
    async def test_connection(self) -> bool:
        try:
            conn = await asyncpg.connect(self.connection_string)
            await conn.close()
            return True
        except:
            return False