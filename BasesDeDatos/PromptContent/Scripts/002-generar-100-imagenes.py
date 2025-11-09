"""
Script para generar 100 imágenes algorítmicamente en MongoDB
Con Unsplash API para obtener imágenes reales relacionadas
Con descripciones amplias, coherentes y hashtags clasificadores
"""

import pymongo
import random
import requests
import time
from datetime import datetime, timedelta

# ============================================
# CONFIGURACIÓN
# ============================================
MONGO_URL = "mongodb://mongouser:mongo123@localhost:30017/promptcontent?authSource=admin"
DATABASE_NAME = "promptcontent"
TOTAL_IMAGENES = 100

# LLave de acceso que nos permite acceder a las imágenes en UNPLASH
UNSPLASH_ACCESS_KEY = "PTgVrbtcNmHoTZrfKCExQ3URmMRHIWhFFWpmQpwg9wQ"  

# ============================================
# CATEGORÍAS Y DATOS BASE
# ============================================
CATEGORIAS = {
    "tech_products": {
        "keywords": ["smartphone", "laptop", "tablet", "smartwatch", "headphones", "camera", "drone", "gaming"],
        "estilos": ["minimalista", "moderno", "elegante", "futurista", "profesional", "premium"],
        "colores": ["azul", "negro", "blanco", "gris", "plateado", "dorado"]
    },
    "fashion": {
        "keywords": ["clothing", "shoes", "accessories", "bag", "watch", "sunglasses", "jewelry", "perfume"],
        "estilos": ["casual", "formal", "deportivo", "vintage", "urbano", "elegante"],
        "colores": ["negro", "blanco", "beige", "rojo", "azul", "pastel"]
    },
    "food": {
        "keywords": ["food", "drink", "dessert", "gourmet", "coffee", "smoothie", "salad", "burger"],
        "estilos": ["gourmet", "casero", "saludable", "vegano", "tradicional", "fusion"],
        "colores": ["colorido", "natural", "vibrante", "rústico", "elegante", "fresco"]
    },
    "travel": {
        "keywords": ["beach", "mountain", "city", "landscape", "architecture", "hotel", "resort", "adventure"],
        "estilos": ["panorámico", "urbano", "natural", "aventura", "cultural", "exótico"],
        "colores": ["azul cielo", "verde", "dorado", "nocturno", "atardecer", "tropical"]
    },
    "business": {
        "keywords": ["office", "meeting", "presentation", "workspace", "team", "conference", "startup", "coworking"],
        "estilos": ["corporativo", "profesional", "moderno", "colaborativo", "minimalista", "innovador"],
        "colores": ["neutro", "azul corporativo", "gris", "blanco", "madera", "industrial"]
    },
    "fitness": {
        "keywords": ["gym", "yoga", "running", "exercise", "sport", "training", "crossfit", "pilates"],
        "estilos": ["energético", "motivacional", "dinámico", "saludable", "activo", "intenso"],
        "colores": ["negro", "azul", "verde", "naranja", "rojo", "neón"]
    },
    "home": {
        "keywords": ["living room", "kitchen", "bedroom", "garden", "decoration", "bathroom", "terrace", "interior"],
        "estilos": ["acogedor", "moderno", "minimalista", "rústico", "escandinavo", "industrial"],
        "colores": ["blanco", "beige", "gris", "madera", "verde", "neutro"]
    },
    "nature": {
        "keywords": ["flowers", "trees", "animals", "water", "sky", "forest", "ocean", "mountain"],
        "estilos": ["natural", "salvaje", "tranquilo", "vibrante", "sereno", "majestuoso"],
        "colores": ["verde", "azul", "dorado", "multicolor", "pastel", "tierra"]
    },
    "art": {
        "keywords": ["painting", "illustration", "design", "abstract", "sculpture", "graffiti", "digital art", "mural"],
        "estilos": ["moderno", "abstracto", "minimalista", "colorido", "conceptual", "contemporáneo"],
        "colores": ["vibrante", "monocromático", "pastel", "neón", "tierra", "bold"]
    },
    "events": {
        "keywords": ["wedding", "party", "celebration", "concert", "festival", "birthday", "graduation", "gala"],
        "estilos": ["festivo", "elegante", "alegre", "nocturno", "íntimo", "espectacular"],
        "colores": ["dorado", "plateado", "colorido", "blanco", "iluminado", "brillante"]
    }
}

# Hashtags base por categoría
HASHTAGS_BASE = {
    "tech_products": ["#tech", "#technology", "#gadgets", "#innovation", "#digital", "#electronics"],
    "fashion": ["#fashion", "#style", "#ootd", "#trendy", "#design", "#look"],
    "food": ["#food", "#foodie", "#delicious", "#yummy", "#instafood", "#foodporn"],
    "travel": ["#travel", "#wanderlust", "#explore", "#adventure", "#vacation", "#tourism"],
    "business": ["#business", "#professional", "#corporate", "#workspace", "#entrepreneur", "#success"],
    "fitness": ["#fitness", "#workout", "#health", "#gym", "#motivation", "#fitlife"],
    "home": ["#home", "#interior", "#decor", "#homedecor", "#design", "#interiordesign"],
    "nature": ["#nature", "#natural", "#outdoors", "#wildlife", "#landscape", "#earth"],
    "art": ["#art", "#creative", "#design", "#artistic", "#illustration", "#artwork"],
    "events": ["#event", "#celebration", "#party", "#special", "#memorable", "#occasion"]
}

# ============================================
# FUNCIONES DE GENERACIÓN
# ============================================

def obtener_imagen_unsplash(keyword, orientacion):
    
    url = "https://api.unsplash.com/photos/random"
    params = {
        "query": keyword,
        "orientation": orientacion,
        "client_id": UNSPLASH_ACCESS_KEY
    }
    
    try:
        response = requests.get(url, params=params, timeout=10)
        
        if response.status_code == 200:
            data = response.json()
            return {
                "url": data["urls"]["regular"], 
                "url_full": data["urls"]["full"],
                "width": data["width"],
                "height": data["height"],
                "photographer": data["user"]["name"],
                "unsplash_id": data["id"]
            }
        elif response.status_code == 403:
            print(f"    ⚠️  Rate limit alcanzado (403) - usando placeholder")
            return None
        else:
            print(f"    ⚠️  Error {response.status_code} - usando placeholder")
            return None
            
    except requests.exceptions.Timeout:
        print(f"    ⚠️  Timeout - usando placeholder")
        return None
    except Exception as e:
        print(f"    ⚠️  Error: {e} - usando placeholder")
        return None


def generar_url_placeholder(index, width=1920, height=1080):
    """Genera URL de imagen placeholder como plan de emergencia"""
    return f"https://picsum.photos/id/{index}/{width}/{height}"


def generar_descripcion(categoria, keyword, estilo, color, keyword_es):
    """Genera una descripción amplia y coherente usando templates"""
    
    iluminaciones = ["natural", "de estudio", "dramática", "suave", "difusa", "lateral"]
    fondos = ["degradado", "sólido", "texturizado", "bokeh", "abstracto", "geométrico"]
    tipografias = ["moderna sans-serif", "elegante serif", "bold", "minimalista", "handwritten", "display"]
    plataformas = ["redes sociales", "anuncios digitales", "campañas de email", "banners web", "stories", "posts"]
    enfoques = ["producto", "ambiente", "textura", "detalles", "composición", "concepto"]
    composiciones = ["centrada", "asimétrica", "regla de tercios", "minimalista", "dinámica", "equilibrada"]
    publicos = ["millennial", "gen-z", "profesional", "familiar", "joven", "adulto"]
    formatos = ["cuadrado 1:1", "vertical 9:16", "horizontal 16:9", "story", "banner", "thumbnail"]
    
    # 5 templates diferentes para variedad
    templates = [
        f"Banner publicitario de {keyword_es} con estilo {estilo}, dominado por tonos {color}. "
        f"Composición profesional con iluminación {random.choice(iluminaciones)}, "
        f"fondo {random.choice(fondos)} y tipografía {random.choice(tipografias)}. "
        f"Ideal para {random.choice(plataformas)}, target audiencia {random.choice(publicos)}.",
        
        f"Imagen de {keyword_es} con diseño {estilo}, destacando elementos {color}. "
        f"Fotografía de alta resolución con enfoque en {random.choice(enfoques)}. "
        f"Composición {random.choice(composiciones)} con iluminación {random.choice(iluminaciones)}, "
        f"perfecta para público {random.choice(publicos)} en formato {random.choice(formatos)}.",
        
        f"Diseño visual de {keyword_es} estilo {estilo} en paleta de colores {color}. "
        f"Layout {random.choice(['limpio', 'dinámico', 'equilibrado', 'audaz'])} "
        f"con elementos {random.choice(['geométricos', 'orgánicos', 'abstractos', 'realistas'])}. "
        f"Optimizado para {random.choice(['Instagram', 'Facebook', 'LinkedIn', 'TikTok'])} "
        f"con fondo {random.choice(fondos)} y tipografía {random.choice(tipografias)}.",
        
        f"Contenido visual premium de {keyword_es} con enfoque {estilo} y tonalidad {color}. "
        f"Producción {random.choice(['editorial', 'comercial', 'publicitaria', 'conceptual'])} "
        f"con iluminación {random.choice(iluminaciones)} y composición {random.choice(composiciones)}. "
        f"Diseñado para {random.choice(plataformas)} targeting {random.choice(publicos)}.",
        
        f"Fotografía profesional de {keyword_es} en estilo {estilo}, paleta {color}. "
        f"Escena {random.choice(['minimalista', 'elaborada', 'natural', 'producida'])} "
        f"con fondo {random.choice(fondos)}, iluminación {random.choice(iluminaciones)}. "
        f"Formato {random.choice(formatos)} para {random.choice(plataformas)}."
    ]
    
    return random.choice(templates)


def generar_hashtags(categoria, keyword, estilo, color, num_hashtags=10):
    """Genera hashtags relevantes y coherentes"""
    
    hashtags = []
    
    # Hashtags base de la categoría (3-4)
    hashtags.extend(random.sample(HASHTAGS_BASE.get(categoria, []), min(4, len(HASHTAGS_BASE.get(categoria, [])))))
    
    # Hashtags específicos
    hashtags.append(f"#{keyword.replace(' ', '')}")
    hashtags.append(f"#{estilo}")
    hashtags.append(f"#{color.replace(' ', '')}")
    
    # Hashtags generales de marketing
    generales = ["#contentcreation", "#marketing", "#branding", "#visualcontent", 
                 "#socialmedia", "#digitalmarketing", "#creative", "#advertising"]
    hashtags.extend(random.sample(generales, 3))
    
    # Eliminar duplicados y limitar
    hashtags_unicos = list(dict.fromkeys(hashtags))
    
    return hashtags_unicos[:num_hashtags]


# Mapeo de keywords en inglés a español para descripciones
KEYWORD_ES_MAP = {
    "smartphone": "smartphone", "laptop": "laptop", "tablet": "tablet", "smartwatch": "smartwatch",
    "headphones": "auriculares", "camera": "cámara", "drone": "drone", "gaming": "gaming",
    "clothing": "ropa", "shoes": "zapatos", "accessories": "accesorios", "bag": "bolso",
    "watch": "reloj", "sunglasses": "gafas de sol", "jewelry": "joyería", "perfume": "perfume",
    "food": "comida", "drink": "bebida", "dessert": "postre", "gourmet": "plato gourmet",
    "coffee": "café", "smoothie": "smoothie", "salad": "ensalada", "burger": "hamburguesa",
    "beach": "playa", "mountain": "montaña", "city": "ciudad", "landscape": "paisaje",
    "architecture": "arquitectura", "hotel": "hotel", "resort": "resort", "adventure": "aventura",
    "office": "oficina", "meeting": "reunión", "presentation": "presentación", "workspace": "workspace",
    "team": "equipo", "conference": "conferencia", "startup": "startup", "coworking": "coworking",
    "gym": "gimnasio", "yoga": "yoga", "running": "running", "exercise": "ejercicio",
    "sport": "deporte", "training": "entrenamiento", "crossfit": "crossfit", "pilates": "pilates",
    "living room": "sala", "kitchen": "cocina", "bedroom": "dormitorio", "garden": "jardín",
    "decoration": "decoración", "bathroom": "baño", "terrace": "terraza", "interior": "interior",
    "flowers": "flores", "trees": "árboles", "animals": "animales", "water": "agua",
    "sky": "cielo", "forest": "bosque", "ocean": "océano", 
    "painting": "pintura", "illustration": "ilustración", "design": "diseño", "abstract": "abstracto",
    "sculpture": "escultura", "graffiti": "graffiti", "digital art": "arte digital", "mural": "mural",
    "wedding": "boda", "party": "fiesta", "celebration": "celebración", "concert": "concierto",
    "festival": "festival", "birthday": "cumpleaños", "graduation": "graduación", "gala": "gala"
}


def generar_100_imagenes():
    """
    Función principal que genera 100 imágenes con toda su metadata
    """
    # Conectar a MongoDB
    print("🔌 Conectando a MongoDB...")
    client = pymongo.MongoClient(MONGO_URL)
    db = client[DATABASE_NAME]
    
    # Verificar que la colección existe
    if "PCmedia" not in db.list_collection_names():
        print("❌ Error: La colección 'PCmedia' no existe. Ejecuta primero el script de creación de colecciones.")
        return
    
    print(f"Conectado a base de datos: {DATABASE_NAME}")
    print(f"Generando {TOTAL_IMAGENES} imágenes con Unsplash API...\n")
    print("Esto puede tardar unos minutos debido al rate limit de Unsplash (50/hora)\n")
    
    imagenes_generadas = []
    contador = 1
    imagenes_unsplash = 0
    imagenes_placeholder = 0
    
    # Generar 10 imágenes por cada categoría
    for categoria, config in CATEGORIAS.items():
        print(f"Categoría: {categoria.upper()}")
        
        for i in range(1):  # 10 imágenes por categoría
            # Seleccionar elementos aleatorios
            keyword = random.choice(config["keywords"])
            keyword_es = KEYWORD_ES_MAP.get(keyword, keyword)
            estilo = random.choice(config["estilos"])
            color = random.choice(config["colores"])
            
            # Generar descripción amplia
            descripcion = generar_descripcion(categoria, keyword, estilo, color, keyword_es)
            
            # Generar hashtags clasificadores
            hashtags = generar_hashtags(categoria, keyword, estilo, color)
            
            # Orientación aleatoria
            orientacion = random.choice(["landscape", "portrait", "squarish"])
            
            # Intentar obtener imagen de Unsplash
            print(f"  🔍 {contador:3d}/100: Buscando '{keyword}' en Unsplash...", end=" ")
            imagen_data = obtener_imagen_unsplash(keyword, orientacion)
            
            # Determinar deliveryStatus según la fuente de la imagen
            if imagen_data:
                # Imagen de Unsplash obtenida - DELIVERED
                image_url = imagen_data["url"]
                width = imagen_data["width"]
                height = imagen_data["height"]
                delivery_status = "Delivered"  # ← Unsplash = Delivered
                print(f"✅ Unsplash → Delivered")
                imagenes_unsplash += 1
            else:
                # Fallback a placeholder - PROCESSING
                width, height = (1920, 1080) if orientacion == "landscape" else (1080, 1920)
                image_url = generar_url_placeholder(contador, width, height)
                delivery_status = "Processing"  # ← Placeholder = Processing
                print(f"📦 Placeholder → Processing")
                imagenes_placeholder += 1
            # Crear documento completo
            PCmedia = {
                # Campos requeridos
                "clientId": f"CLIENT_{random.randint(1, 20):03d}", #Este campo no será random al final
                "requestDescription": descripcion, #Este campo se debe corregir cuando se conecte este código con el de PC_Content_Requests
                "hashtags": hashtags,
                "deliveryStatus": delivery_status,
                "format": random.choice(["jpg", "png", "webp"]),
                
                "mediaId": f"IMG_{contador:03d}",
                "mediaUrl": image_url,
                "fileName": f"image_{contador:03d}.jpg",
                "size": random.randint(200000, 5000000),
                "description": descripcion,
                "category": "ads",
                "platform": random.choice(["Youtube", "Instagram", "Facebook", "Tiktok", "other"]),
                "userId": f"USER_{random.randint(1, 20):03d}", #Este campo no será random al final
                
                #Faltan requestId, adId y campaignId
                
                
                # Fechas variadas
                "createdAt": datetime.utcnow() - timedelta(days=random.randint(1, 180)),
                "updatedAt": datetime.utcnow() - timedelta(days=random.randint(0, 30)),
                
                
                "usageCount": random.randint(0, 50),
                "rights": random.choice(["proprietary", "CC0", "CC-BY", "CC-BY-SA"]),
            }
            
            imagenes_generadas.append(PCmedia)
            contador += 1
            
            # Pequeña pausa para no saturar la API (opcional, pero recomendado)
            time.sleep(0.5)
        
        print()
    
    # Insertar todas las imágenes en MongoDB
    print(f"\n💾 Insertando {len(imagenes_generadas)} imágenes en MongoDB...")
    try:
        result = db.PCmedia.insert_many(imagenes_generadas)
        print(f"✅ {len(result.inserted_ids)} imágenes insertadas exitosamente")
        
        # Estadísticas
        print(f"\nEstadísticas:")
        print(f"  • Imágenes de Unsplash: {imagenes_unsplash}")
        print(f"  • Imágenes placeholder: {imagenes_placeholder}")
        print(f"  • Total: {len(imagenes_generadas)}")
        
        # Verificar inserción
        total_en_db = db.PCmedia.count_documents({})
        print(f"\nTotal de imágenes en la base de datos: {total_en_db}")
        
        # Distribución por status
        print("\nDistribución por status:")
        for deliveryStatus in ["Pending", "Delivered", "Processing"]:
            count = db.PCmedia.count_documents({"deliveryStatus": deliveryStatus}),
            print(f"  • {deliveryStatus}: {count} imágenes")
        
        print("\n¡Generación completada exitosamente!")

        
    except Exception as e:
        print(f"❌ Error al insertar imágenes: {e}")
    
    finally:
        client.close()
        print("\nConexión cerrada")


# ============================================
# EJECUCIÓN
# ============================================
if __name__ == "__main__":
    print("=" * 70)
    print("GENERACIÓN DE 100 IMÁGENES CON UNSPLASH API - PROMPTCONTENT")
    print("=" * 70)
    print()
    
    # Ejecutar generación
    generar_100_imagenes()
    
    print("\n" + "=" * 70)
    print("FIN DEL SCRIPT")
    print("=" * 70)