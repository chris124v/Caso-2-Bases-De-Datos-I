from abc import ABC, abstractmethod
from typing import Any, Dict, List, Optional

class BaseDatabaseConnector(ABC):
    #Clase base para todos los conectores de las bases

    @abstractmethod
    async def execute_query(self, query: str, params: Dict = None)-> List[Dict]:

        """TAca taca taca 
            unq query
            cuando haya
        
        """
        pass


    @abstractmethod
    async def get_schema(self, table_name: str = None) -> Dict:
        """
        Obtiene el esquema de la base de datos o tabla específica
        
        Args:
            table_name: Nombre de la tabla (opcional)
            
        Returns:
            Diccionario con información del esquema
        """
        pass

    @abstractmethod
    async def test_connection(self) -> bool:
        """
        Verifica si la conexión a la base de datos funciona
        
        Returns:
            True si la conexión es exitosa, False en caso contrario
        """
        pass
    
    async def get_tables(self) -> List[str]:
        """
        Obtiene lista de tablas en la base de datos (implementación opcional)
        
        Returns:
            Lista de nombres de tablas
        """
        schema = await self.get_schema()
        return schema.get("tables", [])