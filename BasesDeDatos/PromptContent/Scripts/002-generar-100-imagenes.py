"""
Script para generar 100 imágenes algorítmicamente en MongoDB
Con Unsplash API para obtener imágenes reales relacionadas
Con descripciones amplias, coherentes y hashtags clasificadores
"""

import pymongo
import random
import requests
import time
import os
from datetime import datetime, timedelta

# ============================================
# CONFIGURACIÓN
# ============================================
MONGO_URL = "mongodb://mongouser:mongo123@localhost:30017/promptcontent?authSource=admin"
DATABASE_NAME = "promptcontent"
TOTAL_IMAGENES = 100

# API de Imágenes
PIXABAY_API_KEY = "53186043-03d471fac4bce3d4ea7b8a2f7" 

# IA para generar descripciones 
AI_PROVIDER = "groq"

<<<<<<< HEAD
# API Keys - CADA UNO DEBE PONER LA API KEY DE GROQ AQUÍ (ESTÁ ANCLADA EN EL GRUPO DE WPP)   
GROQ_API_KEY = ""          
=======
# API Keys - CADA UNO DEBE PONER SU API KEY DE GROQ AQUÍ https://console.groq.com/keys   
GROQ_API_KEY = "AQUI"          
>>>>>>> parent of e2fa5a1 (Listas ambas tools promptContent)


# ============================================
# INICIALIZAR CLIENTE DE IA
# ============================================

AI_CLIENT = None
AI_DISPONIBLE = False

if AI_PROVIDER == "groq":
    try:
        from groq import Groq
        AI_CLIENT = Groq(api_key=GROQ_API_KEY)
        AI_DISPONIBLE = True
        print("✅ Groq (Llama 3) inicializado")
    except Exception as e:
        print(f"⚠️  Error con Groq: {e}")
        
else:
    print("ℹ️  Modo sin IA - usando descripciones simples")


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
# FUNCIONES DE IA - MULTI-PROVIDER
# ============================================

def llamar_ia(prompt):
    """
    Función universal que llama a cualquier proveedor de IA
    """
    if not AI_DISPONIBLE:
        return None
    
    try:
        if AI_PROVIDER == "gemini":
            # Google Gemini
            response = AI_CLIENT.generate_content(prompt)
            return response.text.strip()
            
        elif AI_PROVIDER == "groq":
            # Groq (Llama 3)
            response = AI_CLIENT.chat.completions.create(
                model="llama-3.3-70b-versatile",
                messages=[{"role": "user", "content": prompt}],
                max_tokens=200,
                temperature=0.7
            )
            return response.choices[0].message.content.strip()
            
        elif AI_PROVIDER == "anthropic":
            # Anthropic Claude
            response = AI_CLIENT.messages.create(
                model="claude-3-5-sonnet-20241022",
                max_tokens=200,
                messages=[{"role": "user", "content": prompt}]
            )
            return response.content[0].text.strip()
            
    except Exception as e:
        print(f"    ⚠️  Error con IA: {e}")
        return None


def generar_keywords_secundarios(keyword_principal, categoria, estilo, color):
    """Genera 1-2 keywords secundarios usando IA"""
    if not AI_DISPONIBLE:
        return [estilo]
    
    prompt = f"""Genera 1-2 keywords cortos en inglés relacionados con: "{keyword_principal}"
Contexto: categoría={categoria}, estilo={estilo}, color={color}

Responde SOLO con los keywords separados por comas, sin explicaciones.
Ejemplo: "modern, sleek" o "vintage"
"""
    
    resultado = llamar_ia(prompt)
    
    if resultado:
        keywords_extra = resultado.split(',')
        keywords_extra = [k.strip() for k in keywords_extra if k.strip()]
        return keywords_extra[:2]
    
    return []


def enriquecer_descripcion_con_ia(metadata_pixabay, keyword_principal, categoria, estilo, color):
    """Enriquece descripción usando metadata real de Pixabay + IA"""
    tags_pixabay = metadata_pixabay.get("tags", [])
    
    if AI_DISPONIBLE:
        tags_str = ", ".join(tags_pixabay) if tags_pixabay else "no disponibles"
        
        prompt = f"""Crea una descripción profesional en español para marketing de esta imagen:

DATOS REALES DE LA IMAGEN (PIXABAY):
- Tags: {tags_str}
- Keyword buscado: {keyword_principal}
- Categoría: {categoria}
- Estilo: {estilo}
- Color: {color}

REQUISITOS:
1. Máximo 50 palabras
2. DEBE mencionar el keyword "{keyword_principal}"
3. DEBE basarse en los tags reales de la imagen
4. Enfoque en uso para campañas de marketing digital
5. Descripción profesional y atractiva

Responde SOLO con la descripción, sin títulos ni explicaciones adicionales."""

        resultado = llamar_ia(prompt)
        
        if resultado:
            # Validar que el keyword aparezca
            if keyword_principal.lower() not in resultado.lower():
                resultado = f"Imagen de {keyword_principal}: {resultado}"
            return resultado
    
    # Fallback sin IA
    return generar_descripcion_simple(tags_pixabay, keyword_principal, estilo, color)


def generar_descripcion_simple(tags, keyword, estilo, color):
    """Fallback sin IA: descripción simple pero coherente"""
    if tags and len(tags) > 0:
        base = f"imagen con {', '.join(tags[:3])}"
    else:
        base = f"contenido visual de {keyword}"
    
    descripcion = f"Contenido visual profesional: {base}. "
    descripcion += f"Diseño {estilo} con paleta de colores {color}, "
    descripcion += f"ideal para campañas de marketing digital en redes sociales. "
    descripcion += f"Recurso visual optimizado para {keyword} y contenido publicitario."
    
    return descripcion


# ============================================
# FUNCIONES DE PIXABAY
# ============================================

def obtener_imagen_pixabay_mejorada(keyword_principal, keywords_secundarios, orientacion):
    """Obtiene imagen de Pixabay con metadata"""
    query_parts = [keyword_principal] + keywords_secundarios
    query = " ".join(query_parts)
    
    url = "https://pixabay.com/api/"
    
    orientacion_map = {
        "landscape": "horizontal",
        "portrait": "vertical",
        "squarish": "all"
    }
    
    params = {
        "key": PIXABAY_API_KEY,
        "q": query,
        "image_type": "photo",
        "orientation": orientacion_map.get(orientacion, "all"),
        "per_page": 3,
        "safesearch": "true"
    }
    
    try:
        response = requests.get(url, params=params, timeout=10)
        
        if response.status_code == 200:
            data = response.json()
            
            if data.get("hits") and len(data["hits"]) > 0:
                hit = random.choice(data["hits"])
                
                tags_string = hit.get("tags", "")
                tags_list = [tag.strip() for tag in tags_string.split(",") if tag.strip()]
                
                return {
                    "url": hit["webformatURL"],
                    "url_full": hit["largeImageURL"],
                    "width": hit["imageWidth"],
                    "height": hit["imageHeight"],
                    "photographer": hit["user"],
                    "pixabay_id": hit["id"],
                    "tags": tags_list,
                    "views": hit.get("views", 0),
                    "likes": hit.get("likes", 0),
                    "downloads": hit.get("downloads", 0)
                }
            else:
                print(f"No results")
                return None
        else:
            print(f"Error {response.status_code}")
            return None
            
    except Exception as e:
        print(f"Error: {e}")
        return None


def generar_hashtags_mejorados(categoria, keyword, tags_pixabay):
    """Genera hashtags combinando base + tags reales"""
    hashtags = []
    
    hashtags.extend(random.sample(HASHTAGS_BASE.get(categoria, []), min(3, len(HASHTAGS_BASE.get(categoria, [])))))
    hashtags.append(f"#{keyword.replace(' ', '').lower()}")
    
    if tags_pixabay:
        for tag in tags_pixabay[:3]:
            hashtag = f"#{tag.replace(' ', '').replace('-', '').lower()}"
            if hashtag not in hashtags:
                hashtags.append(hashtag)
    
    hashtags = list(set(hashtags))
    random.shuffle(hashtags)
    return hashtags[:random.randint(8, 12)]



# ============================================
# FUNCIÓN PRINCIPAL
# ============================================

def generar_100_imagenes():
    """Genera 100 imágenes con Pixabay + Multi-IA"""
    
    print("🔌 Conectando a MongoDB...")
    client = pymongo.MongoClient(MONGO_URL)
    db = client[DATABASE_NAME]
    
    if "PCmedia" not in db.list_collection_names():
        print("❌ Error: La colección 'PCmedia' no existe.")
        return
    
    print(f"✅ Conectado a base de datos: {DATABASE_NAME}")
    print(f"🎨 Generando {TOTAL_IMAGENES} imágenes")
    print(f"📸 Proveedor de imágenes: PIXABAY (5000/hora)")
    print(f"🤖 Proveedor de IA: {AI_PROVIDER.upper() if AI_DISPONIBLE else 'NINGUNO (fallback)'}\n")
    
    imagenes_generadas = []
    contador = 1
    imagenes_pixabay = 0
    imagenes_placeholder = 0
    
    for categoria, config in CATEGORIAS.items():
        print(f"\n📁 Categoría: {categoria.upper()}")
        
        for i in range(10):
            keyword = random.choice(config["keywords"])
            estilo = random.choice(config["estilos"])
            color = random.choice(config["colores"])
            
            print(f"  🔍 {contador:3d}/100: '{keyword}' ({estilo}, {color})", end="")
            
            keywords_secundarios = generar_keywords_secundarios(keyword, categoria, estilo, color)
            if keywords_secundarios:
                print(f" +[{', '.join(keywords_secundarios)}]", end="")
            
            orientacion = random.choice(["landscape", "portrait", "squarish"])
            imagen_data = obtener_imagen_pixabay_mejorada(keyword, keywords_secundarios, orientacion)
            
            if imagen_data:
                descripcion = enriquecer_descripcion_con_ia(imagen_data, keyword, categoria, estilo, color)
                hashtags = generar_hashtags_mejorados(categoria, keyword, imagen_data.get("tags", []))
                
                image_url = imagen_data["url"]
                width = imagen_data["width"]
                height = imagen_data["height"]
                delivery_status = "Delivered"
                print(f" → ✅ Pixabay")
                imagenes_pixabay += 1
            else:
                descripcion = generar_descripcion_simple([], keyword, estilo, color)
                hashtags = generar_hashtags_mejorados(categoria, keyword, [])
                
                width, height = (1920, 1080) if orientacion == "landscape" else (1080, 1920)
                image_url = " "
                delivery_status = "Processing"
                print(f" → 📦 Placeholder")
                imagenes_placeholder += 1
            
            PCmedia = {
                "clientId": f"CLIENT_{random.randint(1, 20):03d}",
                "requestDescription": descripcion,
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
                "userId": f"USER_{random.randint(1, 20):03d}",
                
                "createdAt": datetime.utcnow() - timedelta(days=random.randint(1, 180)),
                "updatedAt": datetime.utcnow() - timedelta(days=random.randint(0, 30)),
                
                "usageCount": random.randint(0, 50),
                "rights": random.choice(["proprietary", "CC0", "CC-BY", "CC-BY-SA"]),
            }
            
            imagenes_generadas.append(PCmedia)
            contador += 1
            time.sleep(0.3)
    
    print(f"\n\n💾 Insertando {len(imagenes_generadas)} imágenes en MongoDB...")
    try:
        result = db.PCmedia.insert_many(imagenes_generadas)
        print(f"✅ {len(result.inserted_ids)} imágenes insertadas")
        
        print(f"\n📊 Estadísticas:")
        print(f"  • Imágenes de Pixabay: {imagenes_pixabay}")
        print(f"  • Imágenes placeholder: {imagenes_placeholder}")
        print(f"  • Total: {len(imagenes_generadas)}")
        print(f"  • Tasa de éxito: {(imagenes_pixabay/len(imagenes_generadas)*100):.1f}%")
        print(f"  • Proveedor IA: {AI_PROVIDER if AI_DISPONIBLE else 'Ninguno'}")
        
        print("\n✨ ¡Generación completada!")
        
    except Exception as e:
        print(f"❌ Error: {e}")
    finally:
        client.close()

# ============================================
# EJECUCIÓN
# ============================================
if __name__ == "__main__":
    print("=" * 80)
    print("GENERACIÓN DE 100 IMÁGENES - PIXABAY + MULTI-IA")
    print("=" * 80)
    print()

    generar_100_imagenes()
    
    print("\n" + "=" * 80)


