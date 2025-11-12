from motor.motor_asyncio import AsyncIOMotorClient
from .base_connector import BaseDatabaseConnector

class MongoDBConnector(BaseDatabaseConnector):
    def __init__(self, host: str, port: int, database: str, username: str = None, password: str = None):
        # Construir connection string
        if username and password:
            self.connection_string = f"mongodb://{username}:{password}@{host}:{port}/{database}"
        else:
            self.connection_string = f"mongodb://{host}:{port}/{database}"
            
        self.client = AsyncIOMotorClient(self.connection_string)
        self.db = self.client[database]

    async def execute_query(self, query: dict, collection: str) -> list[dict]:
        """
        Para MongoDB, query es un diccionario y se necesita especificar la colección
        """
        cursor = self.db[collection].find(query)
        return await cursor.to_list(length=1000)
    
    async def get_schema(self, collection: str = None) -> dict:
        if collection:
            sample = await self.db[collection].find_one() 
            return {"collection": collection, "sample_schema": sample}
        else:
            collections = await self.db.list_collection_names()
            return {"collections": collections}
        
    async def test_connection(self) -> bool:
        try:
            await self.client.admin.command('ping')
            return True
        except:
            return False