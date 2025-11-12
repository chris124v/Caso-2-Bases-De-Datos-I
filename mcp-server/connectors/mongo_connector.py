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

    async def execute_query(self, query: dict, collection: str) -> list[dict]:
        """
        Para MongoDB, query es un diccionario y se necesita especificar la colección
        """
        try:
            cursor = self.db[collection].find(query)
            return await cursor.to_list(length=1000)
        except Exception as e:
            raise Exception(f"MongoDB query error: {str(e)}")
    
    async def get_schema(self, collection: str = None) -> dict:
        try:
            if collection:
                # Obtener un documento de muestra
                sample = await self.db[collection].find_one()
                
                # Obtener información de índices
                indexes = await self.db[collection].index_information()
                
                # Contar documentos
                count = await self.db[collection].estimated_document_count()
                
                # Analizar estructura
                schema_analysis = {}
                if sample:
                    for key, value in sample.items():
                        schema_analysis[key] = {
                            "type": type(value).__name__,
                            "sample_value": str(value)[:100] if value else None
                        }
                
                return {
                    "collection": collection,
                    "document_count": count,
                    "sample_schema": schema_analysis,
                    "indexes": list(indexes.keys())
                }
            else:
                collections = await self.db.list_collection_names()
                
                # Obtener stats de cada colección
                collections_info = []
                for coll_name in collections:
                    try:
                        count = await self.db[coll_name].estimated_document_count()
                        collections_info.append({
                            "name": coll_name,
                            "document_count": count
                        })
                    except:
                        collections_info.append({
                            "name": coll_name,
                            "document_count": "unknown"
                        })
                
                return {
                    "database": self.database_name,
                    "collections": collections_info
                }
        except Exception as e:
            raise Exception(f"MongoDB schema error: {str(e)}")
        
    async def test_connection(self) -> bool:
        try:
            await self.client.admin.command('ping')
            return True
        except Exception as e:
            print(f"MongoDB connection test failed: {e}")
            return False