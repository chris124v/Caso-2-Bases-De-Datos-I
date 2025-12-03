# server.py
from mcp.server import Server
import mcp.types as types
import sys
import io
import os
from dotenv import load_dotenv

load_dotenv()

from connectors.mongo_connector import MongoDBConnector
from connectors.sqlserver_connector import SQLServerConnector
from connectors.postgresql_connector import PostgreSQLConnector
from config.config_manager import ConfigManager

# FORZAR CODIFICACIÓN UTF-8 A NIVEL DEL SISTEMA PARA RESOLVER PROBLEMA DE EMOJIS Y CARACTERES ESPECIALES
if sys.stdout.encoding != 'utf-8':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='ignore')
if sys.stderr.encoding != 'utf-8':
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='ignore')

print("✅ Codificación forzada a UTF-8")

class DatabaseMCPServer:
    def __init__(self):
        self.server = Server("database-mcp-server")
        self.connectors = {}
        self.config_manager = ConfigManager()
        self.setup_handlers()

    def setup_handlers(self):
        @self.server.list_tools()
        async def handle_list_tools() -> list[types.Tool]:
            return [
                types.Tool(
                    name="get_content",
                    description="BUSCADOR DE IMÁGENES DE MARKETING: Encuentra imágenes, fotos y contenido visual para campañas publicitarias usando descripciones en español. Perfecto para: 'necesito imágenes de deportes', 'busca fotos de productos', 'contenido para redes sociales'. Devuelve URLs directas, descripciones y hashtags listos para usar.",
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "descripcion": {"type": "string",
                                            "description":"Describe lo que buscas en español o ingles: 'imágenes de playa', 'fotos de comida saludable', 'contenido deportivo', 'paisajes naturales'"},
                            "top_k": {"type": "integer", "default": 5}
                        },
                        "required": ["descripcion"]
                    }
                ),
                types.Tool(
                name="generate_campaign_messages",
                description="GENERADOR DE MENSAJES DE CAMPAÑA: Crea mensajes de campaña adecuados para la tematica indicada y dirigida a los publicos meta que se indiquen, se generan 3 versiones de la campaña para ofrecer mas opciones al usuario y asi cumplir con el objetivo de forma mas eficiente y satisfactoria",
                inputSchema={
                    "type": "object",
                        "properties": {
                            "campaign_description": {"type": "string"},
                            "target_audiences": {
                                "type": "array",
                                "items": {"type": "string"},
                                "description": "Lista de audiencias objetivo"
                            },
                            "client_id": {
                                "type": "string", 
                                "default": "CLIENT_DEFAULT"
                            }
                        },
                    "required": ["campaign_description", "target_audiences"]
                }
            )
            ]
        
        @self.server.call_tool()
        async def handle_call_tool(name: str, arguments: dict):
            if name == "get_content":
                return await self._get_content(**arguments)
            elif name == "generate_campaign_messages":  
                return await self._generate_campaign_messages(**arguments)

    # async def initialize_from_config(self):
    #     """Inicializar conectores desde YAML"""
        
    #     db_configs = self.config_manager.get_all_databases()
        
    #     # PostgreSQL
    #     pg_config = db_configs["postgresql"]
    #     self.connectors["postgresql"] = PostgreSQLConnector(
    #         host=pg_config["host"],
    #         port=pg_config["port"],
    #         database=pg_config["database"],
    #         username=pg_config["username"],
    #         password=pg_config["password"]
    #     )

    #     # MongoDB
    #     mongo_config = db_configs["mongodb"]
    #     self.connectors["mongodb"] = MongoDBConnector(
    #         host=mongo_config["host"],
    #         port=mongo_config["port"],
    #         database=mongo_config["database"],
    #         username=mongo_config.get("username"),
    #         password=mongo_config.get("password"),
    #         authSource=mongo_config.get("authSource", "admin")
    #     )

    #     # SQL Server 1
    #     sql1_config = db_configs["sqlserver1"]
    #     self.connectors["sqlserver1"] = SQLServerConnector(
    #         host=sql1_config["host"],
    #         port=sql1_config["port"],
    #         database=sql1_config["database"],
    #         username=sql1_config["username"],
    #         password=sql1_config["password"]
    #     )

    #     # SQL Server 2
    #     sql2_config = db_configs["sqlserver2"]
    #     self.connectors["sqlserver2"] = SQLServerConnector(
    #         host=sql2_config["host"],
    #         port=sql2_config["port"],
    #         database=sql2_config["database"],
    #         username=sql2_config["username"],
    #         password=sql2_config["password"]
    #     )

    async def _get_content(self, descripcion: str, top_k: int = 5):
        """
        Maneja las llamadas al tool get_content
        """
        try:
            # Obtener ruta desde variable de entorno
            ruta_base = os.getenv('PROJECT_ROOT')
            sys.path.append(ruta_base) 
            from BasesDeDatos.PromptContent.Scripts.contentTools import getContent
                    
            resultados = getContent(descripcion, top_k)
            
            # Formatear la respuesta para MCP - SIN encode/decode
            if resultados:
                texto_resultado = f"Se encontraron {len(resultados)} imágenes:\n\n"
                for i, img in enumerate(resultados, 1):
                    texto_resultado += f"{i}. {img.get('mediaId', '')} (score: {img.get('score', 0)})\n"
                    texto_resultado += f"   Descripción: {img.get('description', '')}\n"
                    texto_resultado += f"   Hashtags: {', '.join(img.get('hashtags', []))}\n"
                    texto_resultado += f"   URL: {img.get('mediaUrl', 'N/A')}\n\n"
            else:
                texto_resultado = "No se encontraron imágenes para esa descripción"
            
            return [types.TextContent(type="text", text=texto_resultado)]
            
        except Exception as e:
            return [types.TextContent(type="text", text=f"Error en get_content: {str(e)}")]
        
    async def _generate_campaign_messages(self, campaign_description: str, target_audiences: list, client_id: str = "CLIENT_DEFAULT"):
        """
        Maneja las llamadas al tool generate_campaign_messages
        """
        try:
            ruta_base = os.getenv('PROJECT_ROOT')
            sys.path.append(ruta_base) 
            from BasesDeDatos.PromptContent.Scripts.contentTools import getContent
            
            # Llamar a la función existente
            resultado = generateCampaignMessages(campaign_description, target_audiences, client_id)
            
            # Formatear la respuesta para MCP
            if resultado.get('status') == 'completed':
                texto_resultado = f"✅ Campaña generada exitosamente!\n\n"
                texto_resultado += f"📋 Request ID: {resultado['requestId']}\n"
                texto_resultado += f"🎯 Audiencias: {', '.join(resultado['targetAudiences'])}\n"
                texto_resultado += f"📝 Total mensajes: {resultado['totalMessages']}\n\n"
                
                texto_resultado += "📢 Mensajes generados por audiencia:\n"
                for audiencia, mensajes in resultado['messagesGenerated'].items():
                    texto_resultado += f"\n👥 {audiencia}:\n"
                    for i, mensaje in enumerate(mensajes, 1):
                        texto_resultado += f"   {i}. {mensaje}\n"
            
            else:
                texto_resultado = f"❌ Error al generar campaña: {resultado.get('error', 'Error desconocido')}"
            
            return [types.TextContent(type="text", text=texto_resultado)]
            
        except Exception as e:
            return [types.TextContent(type="text", text=f"Error en generate_campaign_messages: {str(e)}")]

async def create_server():
    server_instance = DatabaseMCPServer()
    await server_instance.initialize_from_config()
    return server_instance.server

# Al final de server.py, reemplaza o agrega:
if __name__ == "__main__":
    import asyncio
    from mcp.server.stdio import stdio_server
    
    async def main():
        server_instance = DatabaseMCPServer()
        #await server_instance.initialize_from_config()
        
        async with stdio_server() as (read_stream, write_stream):
            await server_instance.server.run(
                read_stream, 
                write_stream, 
                server_instance.server.create_initialization_options()
            )
    
    asyncio.run(main())