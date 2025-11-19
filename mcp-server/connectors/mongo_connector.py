from motor.motor_asyncio import AsyncIOMotorClient
from .base_connector import BaseDatabaseConnector

class MongoDBConnector(BaseDatabaseConnector):
    def __init__(self, host: str, port: int, database: str, username: str = None, password: str = None, authSource: str = "admin"):
        # Construir connection string con autenticación
        if username and password:
            self.connection_string = f"mongodb://{username}:{password}@{host}:{port}/{database}?authSource={authSource}"
        else:
            self.connection_string = f"mongodb://{host}:{port}/{database}"
            
        self.client = AsyncIOMotorClient(self.connection_string)
        self.db = self.client[database]
        self.database_name = database


        
    async def test_connection(self) -> bool:
        try:
            await self.client.admin.command('ping')
            return True
        except Exception as e:
            print(f"MongoDB connection test failed: {e}")
            return False