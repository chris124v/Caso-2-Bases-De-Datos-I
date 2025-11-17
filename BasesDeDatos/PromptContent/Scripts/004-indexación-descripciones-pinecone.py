"""
Script para indexar las descripciones de las 100 imágenes de PCmedia en Pinecone
Permite búsqueda semántica de imágenes por descripción textual
"""

from pinecone import Pinecone
from pymongo import MongoClient
import uuid
import os

# ============================================
# CONFIGURACIÓN
# ============================================

# MongoDB
MONGO_URL = "mongodb://mongouser:mongo123@localhost:30017/promptcontent?authSource=admin"
DATABASE_NAME = "promptcontent"

# Pinecone
PINECONE_API_KEY = os.getenv('PINECONE_API_KEY')
INDEX_NAME = "promptcontent-images"

# ============================================
# 1. CONECTAR A MONGODB
# ============================================

print("=" * 80)
print("INDEXACIÓN DE IMÁGENES EN PINECONE")
print("=" * 80)
print()

print("🔌 Conectando a MongoDB...")
try:
    mongo_client = MongoClient(MONGO_URL)
    db = mongo_client[DATABASE_NAME]
    
    # Verificar que la colección existe
    if "PCmedia" not in db.list_collection_names():
        print("Error: La colección 'PCmedia' no existe.")
        print("   Ejecuta primero el script de generación de imágenes.")
        exit(1)
    
    print("Conectado a MongoDB")
    
    # Contar imágenes
    total_imagenes = db.PCmedia.count_documents({})
    print(f"  Total de imágenes en PCmedia: {total_imagenes}")
    
    if total_imagenes == 0:
        print("No hay imágenes para indexar.")
        print("Ejecuta primero el script de generación de imágenes.")
        exit(1)
    
except Exception as e:
    print(f"Error conectando a MongoDB: {e}")
    exit(1)

print()

# ============================================
# 2. INICIALIZAR PINECONE
# ============================================

print("Inicializando Pinecone...")
try:
    pc = Pinecone(api_key=PINECONE_API_KEY)
    print("  Pinecone inicializado")
except Exception as e:
    print(f"Error inicializando Pinecone: {e}")
    exit(1)

# ============================================
# 3. CREAR O CONECTAR AL ÍNDICE
# ============================================

print(f"Verificando índice '{INDEX_NAME}'...")

# Verificar si el índice ya existe
if not pc.has_index(INDEX_NAME):
    print(f"   Índice no existe. Creando índice '{INDEX_NAME}'...")
    try:
        pc.create_index_for_model(
            name=INDEX_NAME,
            cloud="aws",
            region="us-east-1",
            embed={
                "model": "llama-text-embed-v2",
                "field_map": {"text": "chunk_text"}
            }
        )
        print(f"  Índice '{INDEX_NAME}' creado exitosamente")
    except Exception as e:
        print(f"Error creando índice: {e}")
        exit(1)
else:
    print(f"  Índice '{INDEX_NAME}' ya existe")

# Conectar al índice
try:
    dense_index = pc.Index(INDEX_NAME)
    print("  Conectado al índice")
except Exception as e:
    print(f"Error conectando al índice: {e}")
    exit(1)

print()

# ============================================
# 4. LEER IMÁGENES DE MONGODB
# ============================================

print("Leyendo imágenes de MongoDB...")
try:
    # Obtener todas las imágenes de PCmedia
    imagenes = list(db.PCmedia.find({}))
    print(f"{len(imagenes)} imágenes obtenidas de MongoDB")
except Exception as e:
    print(f"Error leyendo de MongoDB: {e}")
    exit(1)

print()

# ============================================
# 5. PREPARAR REGISTROS PARA PINECONE
# ============================================

print("Preparando registros para Pinecone...")

records = []
errores = 0

for i, imagen in enumerate(imagenes, 1):
    try:
        # Extraer campos necesarios
        media_id = imagen.get("mediaId", f"IMG_{i:03d}")
        description = imagen.get("description", "")
        hashtags = imagen.get("hashtags", [])
        media_url = imagen.get("mediaUrl", "")
        
        # Validar que haya descripción
        if not description or description.strip() == "":
            print(f"Imagen {media_id} sin descripción, usando placeholder")
            description = f"Imagen {media_id}"
        
        # Crear registro para Pinecone
        record = {
            "_id": media_id,                    # ID único
            "text": description,                # Texto para búsqueda semántica
            "hashtags": hashtags,               # Hashtags
            "imageURL": media_url,              # URL de la imagen
            "mediaId": media_id,                # ID adicional (metadata)
            "category": imagen.get("category", "ads"),
            "platform": imagen.get("platform", "other")
        }
        
        records.append(record)
        
        # Mostrar progreso cada 25 imágenes
        if i % 25 == 0:
            print(f"   Procesadas: {i}/{len(imagenes)}")
        
    except Exception as e:
        print(f"Error procesando imagen {i}: {e}")
        errores += 1

print(f"{len(records)} registros preparados")
if errores > 0:
    print(f"{errores} errores durante la preparación")

print()

# ============================================
# 6. INSERTAR EN PINECONE (UPSERT)
# ============================================

print("Insertando registros en Pinecone...")
print("   (Esto puede tardar unos minutos...)")

# Pinecone tiene límite de 96 registros por batch
# Usamos 50 para no alcanzar ese límite y repetimos
BATCH_SIZE = 50

try:
    exitos = 0
    fallos = 0
    total_batches = (len(records) + BATCH_SIZE - 1) // BATCH_SIZE
    
    print(f"   Total de registros: {len(records)}")
    print(f"   Tamaño de lote: {BATCH_SIZE}")
    print(f"   Total de lotes: {total_batches}")
    print()
    
    for i in range(0, len(records), BATCH_SIZE):
        batch = records[i:i+BATCH_SIZE]
        batch_num = i // BATCH_SIZE + 1
        
        try:
            dense_index.upsert_records(
                namespace="__default__",
                records=batch
            )
            exitos += len(batch)
            print(f"     Lote {batch_num}/{total_batches}: {len(batch)} registros insertados ({exitos}/{len(records)})")
            
        except Exception as e:
            fallos += len(batch)
            print(f"     Lote {batch_num}/{total_batches}: Error - {str(e)[:100]}")
    
    print()
    print(f"  Resultado:")
    print(f"     Exitosos: {exitos}/{len(records)}")
    print(f"     Fallidos: {fallos}/{len(records)}")
    
    if exitos > 0:
        print(f"\n  Indexación completada con éxito")
    else:
        print(f"\nNo se pudo indexar ningún registro")
    
except Exception as e:
    print(f"Error inesperado: {e}")

print()

# ============================================
# 7. VERIFICAR INDEXACIÓN
# ============================================

print("  Verificando indexación...")
try:
    # Hacer una búsqueda de prueba
    test_query = "montaña"
    print(f"   Búsqueda de prueba: '{test_query}'")
    
    results = dense_index.search(
        namespace="__default__",
        query={
            "top_k": 3,
            "inputs": {
                'text': test_query
            }
        }
    )
    
    if results and 'result' in results and 'hits' in results['result']:
        hits = results['result']['hits']
        print(f"  Búsqueda exitosa: {len(hits)} resultados encontrados")
        
        if len(hits) > 0:
            print("\n   Primeros resultados:")
            for hit in hits[:3]:
                print(f"   • ID: {hit['_id']}")
                print(f"     Score: {round(hit['_score'], 3)}")
                print(f"     Texto: {hit['fields']['text'][:60]}...")
                print()
    else:
        print("   Búsqueda completada pero sin resultados")
        
except Exception as e:
    print(f"  Error en búsqueda de prueba: {e}")

# ============================================
# 8. RESUMEN FINAL
# ============================================

print("=" * 80)
print("  INDEXACIÓN COMPLETADA")
print("=" * 80)
print(f"""
  Resumen:
   • Imágenes en MongoDB: {len(imagenes)}
   • Registros indexados: {len(records)}
   • Índice: {INDEX_NAME}

""")

# Cerrar conexiones
mongo_client.close()
print("  Conexión a MongoDB cerrada")
print()