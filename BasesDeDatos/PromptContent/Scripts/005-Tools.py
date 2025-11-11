"""
Función getContent() para MCP Server
Busca imágenes en Pinecone basándose en la colección PCmedia de MongoDB
"""

from pinecone import Pinecone
from pymongo import MongoClient

# ============================================
# CONFIGURACIÓN
# ============================================

# MongoDB
MONGO_URL = "mongodb://mongouser:mongo123@localhost:30017/promptcontent?authSource=admin"
DATABASE_NAME = "promptcontent"

# Pinecone
PINECONE_API_KEY = "pcsk_4eQyKL_JsDiByJXLDbFbt8RZE5StEFGXGxvEs3C4op2tpRm4Q6Swjh6r7e7veFWsVTBn6H"
INDEX_NAME = "promptcontent-images"

# Inicializar clientes 
pc = Pinecone(api_key=PINECONE_API_KEY)
pinecone_index = pc.Index(INDEX_NAME)
mongo_client = MongoClient(MONGO_URL)
db = mongo_client[DATABASE_NAME]

# ============================================
# FUNCIÓN getContent()
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
                "top_k": top_k * 2,  # Pedimos el doble para tener margen
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
                "_id": 0  # No incluir el _id de MongoDB
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
# EJEMPLO DE USO
# ============================================

if __name__ == "__main__":
    # Ejemplo 1: Buscar laptops
    print("Búsqueda 1: 'telefono moderno'")
    print("=" * 80)
    resultados = getContent("telefono moderno", top_k=3)
    
    for i, img in enumerate(resultados, 1):
        print(f"\n{i}. {img['mediaId']} (score: {img['score']})")
        print(f"   Descripción: {img['description'][:70]}...")
        print(f"   Hashtags: {', '.join(img['hashtags'][:5])}")
        print(f"   URL: {img['mediaUrl']}")
    
    print("\n" + "=" * 80)
    
    # Ejemplo 2: Buscar comida
    print("\nBúsqueda 2: 'paisajes lindos'")
    print("=" * 80)
    resultados = getContent("paisajes lindos", top_k=3)
    
    for i, img in enumerate(resultados, 1):
        print(f"\n{i}. {img['mediaId']} (score: {img['score']})")
        print(f"   Descripción: {img['description'][:70]}...")
        print(f"   Hashtags: {', '.join(img['hashtags'][:5])}")
        print(f"   URL: {img['mediaUrl']}")