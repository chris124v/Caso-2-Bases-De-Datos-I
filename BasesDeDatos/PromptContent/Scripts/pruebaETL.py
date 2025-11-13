"""
Script de Llenado de Datos de Prueba - PromptContent (MongoDB)
Objetivo: Alimentar PSContentUsage en PromptSales via ETL
Datos mínimos pero suficientes para prueba de concepto
"""

from pymongo import MongoClient
from datetime import datetime, timedelta
import sys

# ============================================
# CONFIGURACIÓN DE CONEXIÓN
# ============================================
MONGO_URL = "mongodb://mongouser:mongo123@localhost:30017/promptcontent?authSource=admin"
DATABASE_NAME = "promptcontent"

def seed_mongodb():
    """Llena MongoDB con datos de prueba"""
    
    try:
        # Conectar a MongoDB
        client = MongoClient(MONGO_URL)
        db = client[DATABASE_NAME]
        
        print("=" * 60)
        print("LLENADO DE DATOS - PROMPTCONTENT")
        print("=" * 60)
        print(f"Conectado a: {DATABASE_NAME}")
        print("-" * 60)
        
        # ============================================
        # 1. USUARIOS
        # ============================================
        print("\n1. Insertando usuarios...")
        
        users = [
            {
                "userId": "USER-001",
                "email": "marketer1@techgadgets.com",
                "name": "Sarah Johnson",
                "role": "marketer",
                "authMethod": "oauth_google",
                "twoFactorEnabled": True,
                "createdAt": datetime(2024, 7, 1),
                "lastLogin": datetime(2024, 11, 20),
                "status": "active"
            },
            {
                "userId": "USER-002",
                "email": "designer@fashionhub.com",
                "name": "Carlos Martinez",
                "role": "marketer",
                "authMethod": "local",
                "passwordHash": "hashed_password_123",
                "twoFactorEnabled": False,
                "createdAt": datetime(2024, 8, 15),
                "lastLogin": datetime(2024, 11, 18),
                "status": "active"
            },
            {
                "userId": "USER-003",
                "email": "content@healthylife.com",
                "name": "Ana Silva",
                "role": "marketer",
                "authMethod": "oauth_microsoft",
                "twoFactorEnabled": True,
                "createdAt": datetime(2024, 9, 10),
                "lastLogin": datetime(2024, 12, 15),
                "status": "active"
            }
        ]
        
        # Limpiar colección si existe
        db.PCUsers.delete_many({})
        result = db.PCUsers.insert_many(users)
        print(f"   OK - {len(result.inserted_ids)} usuarios insertados")
        
        # ============================================
        # 2. CAMPAÑAS
        # ============================================
        print("\n2. Insertando campañas...")
        
        campaigns = [
            {
                "campaignId": "CAMP-001",
                "name": "Black Friday 2024 - Tech",
                "description": "Promoción de gadgets para Black Friday",
                "targetAudience": "Tech enthusiasts, age 25-45",
                "campaignMessage": "Amazing tech deals - up to 50% off!",
                "contentVersions": ["v1.0", "v1.1"],
                "usedImages": ["IMG-001", "IMG-002", "IMG-003"],
                "status": "active",
                "startDate": datetime(2024, 11, 20),
                "endDate": datetime(2024, 11, 30),
                "createdAt": datetime(2024, 10, 15),
                "updatedAt": datetime(2024, 11, 20)
            },
            {
                "campaignId": "CAMP-002",
                "name": "New Year Tech Deals",
                "description": "Ofertas de tecnología para año nuevo",
                "targetAudience": "Young professionals, tech savvy",
                "campaignMessage": "Start 2025 with the best tech",
                "contentVersions": ["v1.0"],
                "usedImages": ["IMG-004", "IMG-005"],
                "status": "active",
                "startDate": datetime(2024, 12, 26),
                "endDate": datetime(2025, 1, 15),
                "createdAt": datetime(2024, 11, 20),
                "updatedAt": datetime(2024, 11, 20)
            },
            {
                "campaignId": "CAMP-003",
                "name": "Winter Fashion Collection",
                "description": "Colección de moda de invierno",
                "targetAudience": "Fashion-conscious women, 20-35",
                "campaignMessage": "Stay stylish this winter",
                "contentVersions": ["v1.0", "v2.0"],
                "usedImages": ["IMG-006", "IMG-007", "IMG-008", "IMG-009"],
                "status": "completed",
                "startDate": datetime(2024, 11, 1),
                "endDate": datetime(2024, 12, 31),
                "createdAt": datetime(2024, 10, 1),
                "updatedAt": datetime(2024, 12, 1)
            },
            {
                "campaignId": "CAMP-004",
                "name": "New Year Wellness",
                "description": "Productos de salud para año nuevo",
                "targetAudience": "Health-conscious adults, 30-50",
                "campaignMessage": "Transform your health in 2025",
                "contentVersions": ["v1.0"],
                "usedImages": ["IMG-010", "IMG-011"],
                "status": "active",
                "startDate": datetime(2024, 12, 15),
                "endDate": datetime(2025, 1, 31),
                "createdAt": datetime(2024, 11, 25),
                "updatedAt": datetime(2024, 11, 25)
            }
        ]
        
        db.PCCampaigns.delete_many({})
        result = db.PCCampaigns.insert_many(campaigns)
        print(f"   OK - {len(result.inserted_ids)} campañas insertadas")
        
        # ============================================
        # 3. IMÁGENES
        # ============================================
        print("\n3. Insertando imágenes...")
        
        images = [
            # Black Friday Tech Campaign
            {
                "imageId": "IMG-001",
                "campaignId": "CAMP-001",
                "filename": "smartwatch_promo.jpg",
                "url": "https://cdn.promptcontent.com/images/smartwatch_promo.jpg",
                "description": "Premium smartwatch on sale - sleek black design with fitness tracking features",
                "hashtags": ["#tech", "#smartwatch", "#blackfriday", "#deals", "#wearables"],
                "width": 1920,
                "height": 1080,
                "fileSize": 245000,
                "mimeType": "image/jpeg",
                "altText": "Black smartwatch with fitness display",
                "usageCount": 5,
                "lastUsedAt": datetime(2024, 11, 25),
                "createdAt": datetime(2024, 10, 16),
                "updatedAt": datetime(2024, 11, 25)
            },
            {
                "imageId": "IMG-002",
                "campaignId": "CAMP-001",
                "filename": "laptop_deals.jpg",
                "url": "https://cdn.promptcontent.com/images/laptop_deals.jpg",
                "description": "Ultra-thin laptop with vibrant display - perfect for work and entertainment",
                "hashtags": ["#laptop", "#tech", "#productivity", "#blackfriday", "#deals"],
                "width": 1920,
                "height": 1080,
                "fileSize": 312000,
                "mimeType": "image/jpeg",
                "altText": "Silver laptop with colorful screen",
                "usageCount": 4,
                "lastUsedAt": datetime(2024, 11, 22),
                "createdAt": datetime(2024, 10, 16),
                "updatedAt": datetime(2024, 11, 22)
            },
            {
                "imageId": "IMG-003",
                "campaignId": "CAMP-001",
                "filename": "wireless_earbuds.jpg",
                "url": "https://cdn.promptcontent.com/images/wireless_earbuds.jpg",
                "description": "Wireless earbuds with premium sound quality and noise cancellation",
                "hashtags": ["#audio", "#wireless", "#earbuds", "#blackfriday", "#music"],
                "width": 1920,
                "height": 1080,
                "fileSize": 198000,
                "mimeType": "image/jpeg",
                "altText": "White wireless earbuds in charging case",
                "usageCount": 3,
                "lastUsedAt": datetime(2024, 11, 23),
                "createdAt": datetime(2024, 10, 17),
                "updatedAt": datetime(2024, 11, 23)
            },
            
            # New Year Tech Campaign
            {
                "imageId": "IMG-004",
                "campaignId": "CAMP-002",
                "filename": "tech_bundle_2025.jpg",
                "url": "https://cdn.promptcontent.com/images/tech_bundle_2025.jpg",
                "description": "Complete tech bundle for the new year - laptop, tablet, and accessories",
                "hashtags": ["#newyear", "#tech", "#bundle", "#2025", "#deals"],
                "width": 1920,
                "height": 1080,
                "fileSize": 389000,
                "mimeType": "image/jpeg",
                "altText": "Tech devices arranged elegantly",
                "usageCount": 2,
                "lastUsedAt": datetime(2024, 12, 27),
                "createdAt": datetime(2024, 11, 21),
                "updatedAt": datetime(2024, 12, 27)
            },
            {
                "imageId": "IMG-005",
                "campaignId": "CAMP-002",
                "filename": "tablet_productivity.jpg",
                "url": "https://cdn.promptcontent.com/images/tablet_productivity.jpg",
                "description": "Revolutionary tablet for work and creativity",
                "hashtags": ["#tablet", "#productivity", "#creative", "#newyear", "#tech"],
                "width": 1920,
                "height": 1080,
                "fileSize": 267000,
                "mimeType": "image/jpeg",
                "altText": "Tablet with stylus and keyboard",
                "usageCount": 1,
                "lastUsedAt": datetime(2024, 12, 28),
                "createdAt": datetime(2024, 11, 22),
                "updatedAt": datetime(2024, 12, 28)
            },
            
            # Winter Fashion Campaign
            {
                "imageId": "IMG-006",
                "campaignId": "CAMP-003",
                "filename": "winter_jacket_collection.jpg",
                "url": "https://cdn.promptcontent.com/images/winter_jacket_collection.jpg",
                "description": "Stylish winter jackets - warm and fashionable for cold weather",
                "hashtags": ["#fashion", "#winter", "#jacket", "#style", "#clothing"],
                "width": 1920,
                "height": 1080,
                "fileSize": 421000,
                "mimeType": "image/jpeg",
                "altText": "Model wearing elegant winter jacket",
                "usageCount": 7,
                "lastUsedAt": datetime(2024, 11, 30),
                "createdAt": datetime(2024, 10, 2),
                "updatedAt": datetime(2024, 11, 30)
            },
            {
                "imageId": "IMG-007",
                "campaignId": "CAMP-003",
                "filename": "fashion_show_backstage.jpg",
                "url": "https://cdn.promptcontent.com/images/fashion_show_backstage.jpg",
                "description": "Behind the scenes of winter collection fashion show",
                "hashtags": ["#fashion", "#backstage", "#winter", "#collection", "#exclusive"],
                "width": 1920,
                "height": 1080,
                "fileSize": 356000,
                "mimeType": "image/jpeg",
                "altText": "Fashion show preparation",
                "usageCount": 4,
                "lastUsedAt": datetime(2024, 11, 10),
                "createdAt": datetime(2024, 10, 5),
                "updatedAt": datetime(2024, 11, 10)
            },
            {
                "imageId": "IMG-008",
                "campaignId": "CAMP-003",
                "filename": "winter_accessories.jpg",
                "url": "https://cdn.promptcontent.com/images/winter_accessories.jpg",
                "description": "Complete your winter look with stylish accessories",
                "hashtags": ["#accessories", "#winter", "#fashion", "#style", "#trends"],
                "width": 1920,
                "height": 1080,
                "fileSize": 289000,
                "mimeType": "image/jpeg",
                "altText": "Winter scarves and accessories",
                "usageCount": 5,
                "lastUsedAt": datetime(2024, 11, 15),
                "createdAt": datetime(2024, 10, 8),
                "updatedAt": datetime(2024, 11, 15)
            },
            {
                "imageId": "IMG-009",
                "campaignId": "CAMP-003",
                "filename": "winter_boots_collection.jpg",
                "url": "https://cdn.promptcontent.com/images/winter_boots_collection.jpg",
                "description": "Stylish and comfortable winter boots for any occasion",
                "hashtags": ["#boots", "#winter", "#fashion", "#footwear", "#style"],
                "width": 1920,
                "height": 1080,
                "fileSize": 334000,
                "mimeType": "image/jpeg",
                "altText": "Elegant winter boots display",
                "usageCount": 3,
                "lastUsedAt": datetime(2024, 11, 20),
                "createdAt": datetime(2024, 10, 10),
                "updatedAt": datetime(2024, 11, 20)
            },
            
            # New Year Wellness Campaign
            {
                "imageId": "IMG-010",
                "campaignId": "CAMP-004",
                "filename": "vitamin_supplements.jpg",
                "url": "https://cdn.promptcontent.com/images/vitamin_supplements.jpg",
                "description": "Premium vitamin supplements for your health journey",
                "hashtags": ["#health", "#vitamins", "#wellness", "#newyear", "#supplements"],
                "width": 1920,
                "height": 1080,
                "fileSize": 276000,
                "mimeType": "image/jpeg",
                "altText": "Vitamin bottles arranged on table",
                "usageCount": 4,
                "lastUsedAt": datetime(2024, 12, 17),
                "createdAt": datetime(2024, 11, 26),
                "updatedAt": datetime(2024, 12, 17)
            },
            {
                "imageId": "IMG-011",
                "campaignId": "CAMP-004",
                "filename": "fitness_equipment.jpg",
                "url": "https://cdn.promptcontent.com/images/fitness_equipment.jpg",
                "description": "Home workout essentials for your fitness goals",
                "hashtags": ["#fitness", "#workout", "#health", "#newyear", "#exercise"],
                "width": 1920,
                "height": 1080,
                "fileSize": 402000,
                "mimeType": "image/jpeg",
                "altText": "Home gym equipment setup",
                "usageCount": 2,
                "lastUsedAt": datetime(2024, 12, 18),
                "createdAt": datetime(2024, 11, 27),
                "updatedAt": datetime(2024, 12, 18)
            }
        ]
        
        db.PCImages.delete_many({})
        result = db.PCImages.insert_many(images)
        print(f"   OK - {len(result.inserted_ids)} imágenes insertadas")
        
        # ============================================
        # 4. LOGS DE GENERACIÓN AI
        # ============================================
        print("\n4. Insertando logs de generación AI...")
        
        ai_logs = [
            {
                "logId": "AILOG-001",
                "modelId": "gpt-4",
                "prompt": "Create a compelling Black Friday tech promotion message",
                "response": "Amazing tech deals - up to 50% off!",
                "tokensUsed": 85,
                "cost": 0.0042,
                "userId": "USER-001",
                "campaignId": "CAMP-001",
                "timestamp": datetime(2024, 10, 15, 14, 30),
                "executionTime": 1.2
            },
            {
                "logId": "AILOG-002",
                "modelId": "gpt-4",
                "prompt": "Generate winter fashion campaign description",
                "response": "Stay stylish this winter with our exclusive collection",
                "tokensUsed": 92,
                "cost": 0.0046,
                "userId": "USER-002",
                "campaignId": "CAMP-003",
                "timestamp": datetime(2024, 10, 1, 10, 15),
                "executionTime": 1.5
            },
            {
                "logId": "AILOG-003",
                "modelId": "gpt-4",
                "prompt": "Create wellness campaign message for new year",
                "response": "Transform your health in 2025",
                "tokensUsed": 78,
                "cost": 0.0039,
                "userId": "USER-003",
                "campaignId": "CAMP-004",
                "timestamp": datetime(2024, 11, 25, 9, 0),
                "executionTime": 1.1
            }
        ]
        
        db.PCAi_Generation_Logs.delete_many({})
        result = db.PCAi_Generation_Logs.insert_many(ai_logs)
        print(f"   OK - {len(result.inserted_ids)} logs AI insertados")
        
        # ============================================
        # RESUMEN FINAL
        # ============================================
        print("\n" + "=" * 60)
        print("RESUMEN DE DATOS INSERTADOS")
        print("=" * 60)
        print(f"OK - Usuarios: 3")
        print(f"OK - Campañas: 4")
        print(f"OK - Imágenes: 11")
        print(f"OK - Logs AI: 3")
        print("\nDATOS POR CAMPAÑA:")
        print("  - Black Friday Tech: 3 imágenes, 15 usos totales")
        print("  - New Year Tech: 2 imágenes, 3 usos totales")
        print("  - Winter Fashion: 4 imágenes, 19 usos totales")
        print("  - New Year Wellness: 2 imágenes, 6 usos totales")
        print("\n" + "=" * 60)
        print("Datos listos para ETL hacia PromptSales.PSContentUsage")
        print("=" * 60)
        
        # Verificación
        print("\nVERIFICACIÓN:")
        for campaign in db.PCCampaigns.find():
            images = list(db.PCImages.find({"campaignId": campaign["campaignId"]}))
            total_usage = sum(img.get("usageCount", 0) for img in images)
            print(f"  {campaign['name']}: {len(images)} imágenes, {total_usage} usos")
        
        client.close()
        print("\nOK - Conexión cerrada exitosamente")
        
    except Exception as e:
        print(f"\nERROR: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

# Ejecutar el script
if __name__ == "__main__":
    seed_mongodb()
    print("\n¡Script completado exitosamente!")