"""
Tools para MCP Server de PromptContent
1. getContent() - Busca imágenes en Pinecone basándose en PCmedia
2. generateCampaignMessages() - Genera mensajes de campaña por audiencia
"""

from pinecone import Pinecone
from pymongo import MongoClient
from datetime import datetime
import uuid
import random
from dotenv import load_dotenv
import os

load_dotenv()

# Usar las variables
PINECONE_API_KEY = os.getenv('PINECONE_API_KEY')
GROQ_API_KEY = os.getenv('GROQ_API_KEY')
AI_PROVIDER = os.getenv('AI_PROVIDER', 'groq')  # Valor por defecto

# ============================================
# CONFIGURACIÓN
# ============================================

# MongoDB
MONGO_URL = "mongodb://mongouser:mongo123@localhost:30017/promptcontent?authSource=admin"
DATABASE_NAME = "promptcontent"

# Pinecone
INDEX_NAME = "promptcontent-images"


# Inicializar clientes MongoDB y Pinecone
pc = Pinecone(api_key=PINECONE_API_KEY)
pinecone_index = pc.Index(INDEX_NAME)
mongo_client = MongoClient(MONGO_URL)
db = mongo_client[DATABASE_NAME]

# Inicializar IA
AI_CLIENT = None
AI_DISPONIBLE = False

if AI_PROVIDER == "groq":
    try:
        from groq import Groq
        AI_CLIENT = Groq(api_key=GROQ_API_KEY)
        AI_DISPONIBLE = True
        print("  IA inicializada: Groq")
    except Exception as e:
        print(f"   Groq no disponible: {e}")


# ============================================
# FUNCIÓN AUXILIAR: Llamar IA
# ============================================

def llamar_ia(prompt, user_id="USER_SYSTEM"):
    """Función universal para llamar a cualquier proveedor de IA CON LOGGING"""
    if not AI_DISPONIBLE:
        return None
    
    timestamp_inicio = datetime.now(datetime.UTC)
    log_id = f"LOG_{uuid.uuid4().hex[:8].upper()}"
    
    try:
        if AI_PROVIDER == "groq":
            # Preparar request
            request_data = {
                "model": "llama-3.3-70b-versatile",
                "messages": [{"role": "user", "content": prompt}],
                "max_tokens": 500,
                "temperature": 0.7
            }
            
            # Llamar a Groq
            response = AI_CLIENT.chat.completions.create(**request_data)
            resultado = response.choices[0].message.content.strip()
            
            timestamp_fin = datetime.now(datetime.UTC)
            response_time = int((timestamp_fin - timestamp_inicio).total_seconds() * 1000)
            
            # REGISTRAR EN PCApi_Call_Logs

            log = {
                "logId": log_id,
                "serviceId": "SRV_GROQ_001",  # Conecta con PCExternal_Services
                "endpoint": "/chat/completions",
                "method": "POST",  #Método POST
                "request": request_data,
                "response": {
                    "content": resultado[:500],
                    "model": response.model,
                    "usage": {
                        "prompt_tokens": response.usage.prompt_tokens,
                        "completion_tokens": response.usage.completion_tokens,
                        "total_tokens": response.usage.total_tokens
                    }
                },
                "statusCode": 200,
                "responseTime": response_time,
                "result": "success",
                "userId": user_id,
                "platform": "PromptContent",
                "ipAddress": "127.0.0.1",
                "processType": "ai_text_generation",
                "timestamp": timestamp_inicio,
                "processedAt": timestamp_fin
            }
            
            db.PCApi_Call_Logs.insert_one(log)
            # ============================================
            
            return resultado
            
    except Exception as e:
        print(f"Error en IA: {e}")
        
        # Registrar error
        db.PCApi_Call_Logs.insert_one({
            "logId": log_id,
            "serviceId": "SRV_GROQ_001",
            "method": "POST",
            "statusCode": 500,
            "errorDetails": str(e),
            "timestamp": timestamp_inicio,
            "userId": user_id,
            "platform": "PromptContent",
            "ipAddress": "127.0.0.1"
        })
        
        return None


# ============================================
# TOOL 1: getContent()
# ============================================

def getContent(descripcion_textual, top_k=5):
    """
    Busca imágenes que coinciden con una descripción textual
    """
    
    try:
        # 1. Buscar en Pinecone usando búsqueda semántica
        results = pinecone_index.search(
            namespace="__default__",
            query={
                "top_k": top_k * 2,
                "inputs": {
                    'text': descripcion_textual
                }
            },
            rerank={
                "model": "bge-reranker-v2-m3",
                "top_n": top_k,
                "rank_fields": ["text"]
            }
        )
        
        # 2. Extraer IDs de las imágenes encontradas
        if not results or 'result' not in results or 'hits' not in results['result']:
            return []
        
        hits = results['result']['hits']
        
        if len(hits) == 0:
            return []
        
        # 3. Obtener IDs de las imágenes
        media_ids = [hit['_id'] for hit in hits]
        
        # 4. Buscar información completa en MongoDB
        imagenes = list(db.PCmedia.find(
            {"mediaId": {"$in": media_ids}},
            {
                "mediaId": 1,
                "description": 1,
                "hashtags": 1,
                "mediaUrl": 1,
                "category": 1,
                "platform": 1,
                "_id": 0
            }
        ))
        
        # 5. Crear diccionario para mapear scores
        scores_map = {hit['_id']: hit['_score'] for hit in hits}
        
        # 6. Combinar información de MongoDB con scores de Pinecone
        resultados = []
        for imagen in imagenes:
            media_id = imagen['mediaId']
            resultado = {
                "mediaId": media_id,
                "description": imagen.get('description', ''),
                "hashtags": imagen.get('hashtags', []),
                "mediaUrl": imagen.get('mediaUrl', ''),
                "category": imagen.get('category', ''),
                "platform": imagen.get('platform', ''),
                "score": round(scores_map.get(media_id, 0), 3)
            }
            resultados.append(resultado)
        
        # 7. Ordenar por score (de mayor a menor)
        resultados.sort(key=lambda x: x['score'], reverse=True)
        
        return resultados
        
    except Exception as e:
        print(f"Error en getContent: {e}")
        return []




# ============================================
# TOOL 2: generateCampaignMessages()
# ============================================

def generateCampaignMessages(campaign_description, target_audiences, client_id="CLIENT_DEFAULT"):
    """
    Genera mensajes de campaña personalizados por audiencia

    """
    
    try:
        # 1. Generar IDs únicos
        request_id = f"REQ_{uuid.uuid4().hex[:8].upper()}"
        timestamp = datetime.now(datetime.UTC)
        
        # 2. Registrar solicitud en PCContent_Requests
        request_doc = {
            "requestId": request_id,
            "clientId": client_id,
            "contentType": "campaign_messages",
            "description": campaign_description,
            "targetAudience": ", ".join(target_audiences),
            "campaignDescription": campaign_description,
            "httpMethod": "POST",
            "requestHeaders": {"Content-Type": "application/json"},
            "requestBody": {
                "campaignDescription": campaign_description,
                "targetAudiences": target_audiences
            },
            "ipAddress": "127.0.0.1",  # Placeholder
            "status": "processing",
            "createdAt": timestamp
        }
        
        db.PCContent_Requests.insert_one(request_doc)
        print(f"  Solicitud registrada: {request_id}")
        
        # 3. Generar mensajes para cada audiencia
        mensajes_por_audiencia = {}
        media_ids_generados = []
        contador_mensajes = 1
        
        for audiencia in target_audiences:
            print(f"  Generando mensajes para audiencia: {audiencia}")
            
            # Generar 3 mensajes para esta audiencia
            mensajes = []
            
            for i in range(3):
                mensaje = generar_mensaje_individual(
                    campaign_description, 
                    audiencia, 
                    i + 1,
                    client_id
                )
                mensajes.append(mensaje)
                
                # Guardar cada mensaje en PCmedia
                media_id = f"MSG_{request_id}_{contador_mensajes:03d}"
                
                # Generar hashtags basados en audiencia y campaña
                hashtags = generar_hashtags_campana(campaign_description, audiencia)
                hashtags.append("#campaignmessage")  # Siempre incluir este hashtag
                
                media_doc = {
                    "mediaId": media_id,
                    "clientId": client_id,
                    "requestId": request_id,
                    "requestDescription": campaign_description,
                    "description": mensaje,
                    "hashtags": hashtags,
                    "deliveryStatus": "Delivered",
                    "format": "text",
                    "category": "social",
                    "platform": "other",
                    "mediaUrl": "",  # Los mensajes de texto no tienen URL
                    "fileName": f"{media_id}.txt",
                    "size": len(mensaje),
                    "userId": f"USER_SYSTEM",
                    "createdAt": timestamp,
                    "updatedAt": timestamp,
                    "usageCount": 0,
                    "rights": "proprietary",
                    # Metadata adicional para mensajes de campaña
                    "campaignMetadata": {
                        "targetAudience": audiencia,
                        "messageNumber": i + 1,
                        "campaignDescription": campaign_description
                    }
                }
                
                db.PCmedia.insert_one(media_doc)
                media_ids_generados.append(media_id)
                contador_mensajes += 1
            
            mensajes_por_audiencia[audiencia] = mensajes
            print(f"     {len(mensajes)} mensajes generados para {audiencia}")
        
        # 4. Actualizar solicitud a completada
        db.PCContent_Requests.update_one(
            {"requestId": request_id},
            {
                "$set": {
                    "status": "completed",
                    "completedAt": datetime.now(datetime.UTC),
                    "generatedContent": [
                        {
                            "contentId": media_id,
                            "contentType": "campaign_message",
                            "metadata": {"targetAudience": aud}
                        }
                        for media_id, aud in zip(media_ids_generados, 
                                                  [a for a in target_audiences for _ in range(3)])
                    ]
                }
            }
        )
        
        print(f"  Campaña completada: {len(media_ids_generados)} mensajes generados")
        
        # 5. Retornar resultado
        return {
            "requestId": request_id,
            "status": "completed",
            "campaignDescription": campaign_description,
            "targetAudiences": target_audiences,
            "messagesGenerated": mensajes_por_audiencia,
            "mediaIds": media_ids_generados,
            "totalMessages": len(media_ids_generados)
        }
        
    except Exception as e:
        print(f"  Error en generateCampaignMessages: {e}")
        
        # Actualizar solicitud a fallida si existe
        if 'request_id' in locals():
            db.PCContent_Requests.update_one(
                {"requestId": request_id},
                {"$set": {"status": "failed", "errorMessage": str(e)}}
            )
        
        return {
            "status": "failed",
            "error": str(e)
        }


# ============================================
# FUNCIONES AUXILIARES PARA GENERACIÓN
# ============================================

def generar_mensaje_individual(campaign_description, audiencia, numero_mensaje, user_id="USER_SYSTEM"):
    """Genera un mensaje individual para una audiencia específica"""
    
    if AI_DISPONIBLE:
        # Usar IA para generar mensaje personalizado
        prompt = f"""Crea un mensaje de campaña de marketing en español para la siguiente audiencia.

DESCRIPCIÓN DE CAMPAÑA:
{campaign_description}

AUDIENCIA OBJETIVO:
{audiencia}

REQUISITOS:
- Mensaje corto y atractivo (máximo 150 palabras)
- Adaptado específicamente para {audiencia}
- Tono apropiado para la audiencia
- Incluir call-to-action si es relevante
- Enfoque en beneficios para la audiencia
- Intenta no mencionar directamente el nombre de la audiencia en general ({audiencia})

Responde SOLO con el mensaje, sin títulos ni explicaciones adicionales.
Este es el mensaje #{numero_mensaje} de 3 para esta audiencia, hazlo único."""

        mensaje = llamar_ia(prompt, user_id)
        
        if mensaje:
            return mensaje
    
    # Fallback: mensaje de plantilla
    plantillas = [
        f"¡Atención {audiencia}! {campaign_description}. Descubre cómo esto puede cambiar tu experiencia. ¡No te lo pierdas!",
        f"Para {audiencia} que buscan lo mejor: {campaign_description}. Una oportunidad única diseñada pensando en ti.",
        f"{campaign_description} - Creado especialmente para {audiencia}. Únete a esta experiencia increíble hoy."
    ]
    
    return plantillas[numero_mensaje - 1]


def generar_hashtags_campana(campaign_description, audiencia):
    """Genera hashtags relevantes para la campaña"""
    
    # Hashtags base
    hashtags_base = ["#marketing", "#campaign", "#socialmedia"]
    
    # Extraer palabras clave de la descripción
    palabras = campaign_description.lower().split()
    palabras_clave = [p for p in palabras if len(p) > 4][:2]
    hashtags_campana = [f"#{p.replace(' ', '')}" for p in palabras_clave]
    
    # Hashtag de audiencia
    hashtag_audiencia = f"#{audiencia.replace(' ', '').replace('-', '')}"
    
    # Combinar y limitar a 6-8 hashtags
    todos_hashtags = hashtags_base + hashtags_campana + [hashtag_audiencia]
    
    # Eliminar duplicados y retornar
    return list(dict.fromkeys(todos_hashtags))[:6]


# ============================================
# EJEMPLOS DE USO
# ============================================

if __name__ == "__main__":
    print("=" * 80)
    print("TOOLS DE PROMPTCONTENT - EJEMPLOS")
    print("=" * 80)
    print()
    
    # ========================================
    # EJEMPLO 1: getContent()
    # ========================================
    print("TOOL 1: getContent()")
    print("-" * 80)
    print("Búsqueda: 'Comida'")
    print()
    
    resultados = getContent("comida", top_k=3)
    
    if resultados:
        for i, img in enumerate(resultados, 1):
            print(f"{i}. {img['mediaId']} (score: {img['score']})")
            print(f"   Descripción: {img['description'][:60]}...")
            print(f"   Hashtags: {', '.join(img['hashtags'][:4])}")
            print(f"   URL: {img["mediaUrl"]}")
            print()
    else:
        print("No se encontraron resultados")
    
    print("=" * 80)
    print()
    
    # ========================================
    # EJEMPLO 2: generateCampaignMessages()
    # ========================================
    print("  TOOL 2: generateCampaignMessages()")
    print("-" * 80)
    print("Campaña: Lanzamiento de nueva laptop gaming")
    print("Audiencias: estudiantes, programadores, diseñadores gráficos")
    print()
    
    resultado_campana = generateCampaignMessages(
        campaign_description="genera una campaña de articulos festivos para celebraciones de cumpleaños y aniversarios",
        target_audiences=["jovenes", "adultos mayores", "padres"],
        client_id="CLIENT_001"
    )
    
    if resultado_campana['status'] == 'completed':
        print(f"  Request ID: {resultado_campana['requestId']}")
        print(f"  Total mensajes: {resultado_campana['totalMessages']}")
        print()
        
        for audiencia, mensajes in resultado_campana['messagesGenerated'].items():
            print(f"  Mensajes para {audiencia}:")
            for i, mensaje in enumerate(mensajes, 1):
                print(f"   {i}. {mensaje[:80]}...")
            print()
    else:
        print(f"  Error: {resultado_campana.get('error', 'Unknown error')}")
    
    print("=" * 80)