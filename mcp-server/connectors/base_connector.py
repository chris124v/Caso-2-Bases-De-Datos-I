from abc import ABC, abstractmethod
from typing import Any, Dict, List, Optional

class BaseDatabaseConnector(ABC):
    #Clase base para todos los conectores de las bases

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