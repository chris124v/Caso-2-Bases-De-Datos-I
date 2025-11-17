import yaml
import os
from typing import Dict, Any

class ConfigManager:
    def __init__(self, config_path: str = None):
        self.config_path = config_path or os.path.join(
            os.path.dirname(__file__), 'databases.yaml'
        )
        self.config = self._load_config()
    
    def _load_config(self) -> Dict[str, Any]:
        """Cargar configuración desde YAML"""
        try:
            with open(self.config_path, 'r') as file:
                return yaml.safe_load(file)
        except Exception as e:
            raise Exception(f"Error loading config from {self.config_path}: {str(e)}")
    
    def get_database_config(self, database_name: str) -> Dict[str, Any]:
        """Obtener configuración específica de base de datos"""
        config = self.config.get(database_name)
        if not config:
            raise ValueError(f"Database configuration not found: {database_name}")
        return config
    
    def get_all_databases(self) -> Dict[str, Any]:
        """Obtener todas las configuraciones de bases de datos"""
        return self.config