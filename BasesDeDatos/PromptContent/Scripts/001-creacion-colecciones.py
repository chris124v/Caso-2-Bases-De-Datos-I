"""
Script para crear todas las colecciones de MongoDB para PromptContent
Incluye validaciones de esquema y creación de índices
"""

from pymongo import MongoClient, ASCENDING, DESCENDING, TEXT
from pymongo.errors import CollectionInvalid
import sys

# ============================================
# CONFIGURACIÓN DE CONEXIÓN
# ============================================
MONGO_URL = "mongodb://mongouser:mongo123@localhost:30017/promptcontent?authSource=admin"
DATABASE_NAME = "promptcontent"

def create_database_and_collections():
    """Crea la base de datos y todas las colecciones con sus validaciones"""
    
    try:
        # Conectar a MongoDB
        client = MongoClient(MONGO_URL)
        db = client[DATABASE_NAME]
        
        print(f"✓ Conectado a MongoDB")
        print(f"✓ Base de datos: {DATABASE_NAME}")
        print("-" * 60)
        
        # ============================================
        # 1. COLECCIÓN: users
        # ============================================
        try:
            db.create_collection("users", validator={
                "$jsonSchema": {
                    "bsonType": "object",
                    "required": ["userId", "email", "name", "role", "createdAt"],
                    "properties": {
                        "userId": {"bsonType": "string"},
                        "email": {"bsonType": "string"},
                        "name": {"bsonType": "string"},
                        "role": {"bsonType": "string", "enum": ["admin", "marketer", "agent", "client"]},
                        "platform": {"bsonType": "string", "enum": ["promptcontent", "promptads", "promptcrm", "web"]},
                        "createdAt": {"bsonType": "date"},
                        "lastLogin": {"bsonType": "date"},
                        "status": {"bsonType": "string", "enum": ["active", "inactive", "suspended"]}
                    }
                }
            })
            print("✓ Colección 'users' creada")
        except CollectionInvalid:
            print("⚠ Colección 'users' ya existe")
        
        # Crear índices para users, mejora la velocidad de consulta y se asegura de que 
        # los valores de ID y email sean únicos 
        db.users.create_index([("userId", ASCENDING)], unique=True)
        db.users.create_index([("email", ASCENDING)], unique=True)
        db.users.create_index([("role", ASCENDING)])
        print("  → Índices creados para 'users'")
        
        # ============================================
        # 2. COLECCIÓN: external_services
        # ============================================
        try:
            db.create_collection("external_services", validator={
                "$jsonSchema": {
                    "bsonType": "object",
                    "required": ["serviceId", "name", "baseUrl", "authMethod", "createdAt"],
                    "properties": {
                        "serviceId": {"bsonType": "string"},
                        "name": {"bsonType": "string"},
                        "baseUrl": {"bsonType": "string"},
                        "authMethod": {"bsonType": "string", "enum": ["OAuth2", "API_KEY", "Bearer", "Basic", "Custom"]},
                        "encryptedCredentials": {"bsonType": "string"},
                        "secretKey": {"bsonType": "string"},
                        "apiKey": {"bsonType": "string"},
                        "status": {"bsonType": "string", "enum": ["active", "inactive", "testing"]},
                        "lastTestedAt": {"bsonType": "date"},
                        "createdAt": {"bsonType": "date"},
                        "updatedAt": {"bsonType": "date"}
                    }
                }
            })
            print("✓ Colección 'external_services' creada")
        except CollectionInvalid:
            print("⚠ Colección 'external_services' ya existe")
        
        db.external_services.create_index([("serviceId", ASCENDING)], unique=True)
        db.external_services.create_index([("name", ASCENDING)])
        print("  → Índices creados para 'external_services'")
        
        # ============================================
        # 3. COLECCIÓN: api_call_logs
        # ============================================
        try:
            db.create_collection("api_call_logs", validator={
                "$jsonSchema": {
                    "bsonType": "object",
                    "required": ["logId", "serviceId", "timestamp"],
                    "properties": {
                        "logId": {"bsonType": "string"},
                        "serviceId": {"bsonType": "string"},
                        "endpoint": {"bsonType": "string"},
                        "method": {"bsonType": "string"},
                        "request": {"bsonType": "object"},
                        "response": {"bsonType": "object"},
                        "statusCode": {"bsonType": "int"},
                        "responseTime": {"bsonType": "int"},
                        "result": {"bsonType": "string"},
                        "userId": {"bsonType": "string"},
                        "platform": {"bsonType": "string"},
                        "timestamp": {"bsonType": "date"},
                        "processedAt": {"bsonType": "date"},
                        "errorDetails": {"bsonType": "string"}
                    }
                }
            })
            print("✓ Colección 'api_call_logs' creada")
        except CollectionInvalid:
            print("⚠ Colección 'api_call_logs' ya existe")
        
        db.api_call_logs.create_index([("logId", ASCENDING)], unique=True)
        db.api_call_logs.create_index([("serviceId", ASCENDING)])
        db.api_call_logs.create_index([("timestamp", DESCENDING)])
        db.api_call_logs.create_index([("userId", ASCENDING)])
        print("  → Índices creados para 'api_call_logs'")
        
        # ============================================
        # 4. COLECCIÓN: ai_models_catalog
        # ============================================
        try:
            db.create_collection("ai_models_catalog", validator={
                "$jsonSchema": {
                    "bsonType": "object",
                    "required": ["modelId", "name", "version", "createdAt"],
                    "properties": {
                        "modelId": {"bsonType": "string"},
                        "name": {"bsonType": "string"},
                        "description": {"bsonType": "string"},
                        "createdAt": {"bsonType": "date"},
                        "updatedAt": {"bsonType": "date"}
                    }
                }
            })
            print("✓ Colección 'ai_models_catalog' creada")
        except CollectionInvalid:
            print("⚠ Colección 'ai_models_catalog' ya existe")
        
        db.ai_models_catalog.create_index([("modelId", ASCENDING)], unique=True)
        db.ai_models_catalog.create_index([("name", ASCENDING)])
        print("  → Índices creados para 'ai_models_catalog'")
        
        # ============================================
        # 5. COLECCIÓN: ai_model_logs
        # ============================================
        try:
            db.create_collection("ai_model_logs", validator={
                "$jsonSchema": {
                    "bsonType": "object",
                    "required": ["logId", "modelId", "timestamp"],
                    "properties": {
                        "logId": {"bsonType": "string"},
                        "modelId": {"bsonType": "string"},
                        "versionId": {"bsonType": "string"},
                        "input": {"bsonType": "string"},
                        "output": {"bsonType": "object"},
                        "parameters": {"bsonType": "object"},
                        "userId": {"bsonType": "string"},
                        "timestamp": {"bsonType": "date"},
                        "processingTime": {"bsonType": "int"},
                        "status": {"bsonType": "string"},
                        "mcpServerUsed": {"bsonType": "bool"},
                        "mcpServerName": {"bsonType": "string"}
                    }
                }
            })
            print("✓ Colección 'ai_model_logs' creada")
        except CollectionInvalid:
            print("⚠ Colección 'ai_model_logs' ya existe")
        
        db.ai_model_logs.create_index([("logId", ASCENDING)], unique=True)
        db.ai_model_logs.create_index([("modelId", ASCENDING)])
        db.ai_model_logs.create_index([("timestamp", DESCENDING)])
        print("  → Índices creados para 'ai_model_logs'")
        
        # ============================================
        # 6. COLECCIÓN: content_types
        # ============================================
        try:
            db.create_collection("content_types", validator={
                "$jsonSchema": {
                    "bsonType": "object",
                    "required": ["contentTypeId", "name", "createdAt"],
                    "properties": {
                        "contentTypeId": {"bsonType": "string"},
                        "name": {"bsonType": "string", "enum": ["text", "image", "video", "audio", "carousel", "story"]},
                        "description": {"bsonType": "string"},
                        "supportedPlatforms": {"bsonType": "array"},
                        "createdAt": {"bsonType": "date"}
                    }
                }
            })
            print("✓ Colección 'content_types' creada")
        except CollectionInvalid:
            print("⚠ Colección 'content_types' ya existe")
        
        db.content_types.create_index([("contentTypeId", ASCENDING)], unique=True)
        db.content_types.create_index([("name", ASCENDING)])
        print("  → Índices creados para 'content_types'")
        
        # ============================================
        # 7. COLECCIÓN: images
        # ============================================
        try:
            db.create_collection("images", validator={
                "$jsonSchema": {
                    "bsonType": "object",
                    "required": ["imageId", "imageUrl", "description", "hashtags", "createdAt"],
                    "properties": {
                        "imageId": {"bsonType": "string"},
                        "imageUrl": {"bsonType": "string"},
                        "fileName": {"bsonType": "string"},
                        "format": {"bsonType": "string", "enum": ["jpg", "png", "gif", "webp"]},
                        "size": {"bsonType": "int"},
                        "description": {"bsonType": "string"},
                        "hashtags": {"bsonType": "array"},
                        "category": {"bsonType": "string", "enum": ["social", "ads", "web", "email", "other"]},
                        "platform": {"bsonType": "array"},
                        "vectorEmbedding": {"bsonType": "array"},
                        "createdAt": {"bsonType": "date"},
                        "updatedAt": {"bsonType": "date"},
                        "status": {"bsonType": "string", "enum": ["draft", "approved", "archived"]},
                        "usageCount": {"bsonType": "int"},
                        "rights": {"bsonType": "string"}
                    }
                }
            })
            print("✓ Colección 'images' creada")
        except CollectionInvalid:
            print("⚠ Colección 'images' ya existe")
        
        db.images.create_index([("imageId", ASCENDING)], unique=True)
        db.images.create_index([("hashtags", ASCENDING)])
        db.images.create_index([("description", TEXT)])
        db.images.create_index([("createdAt", DESCENDING)])
        db.images.create_index([("status", ASCENDING)])
        print("  → Índices creados para 'images'")
        
        # ============================================
        # 8. COLECCIÓN: content_requests
        # ============================================
        try:
            db.create_collection("content_requests", validator={
                "$jsonSchema": {
                    "bsonType": "object",
                    "required": ["requestId", "clientId", "contentType", "createdAt"],
                    "properties": {
                        "requestId": {"bsonType": "string"},
                        "clientId": {"bsonType": "string"},
                        "contentType": {"bsonType": "string"},
                        "description": {"bsonType": "string"},
                        "targetAudience": {"bsonType": "string"},
                        "campaignDescription": {"bsonType": "string"},
                        "generatedContent": {"bsonType": "array"},
                        "status": {"bsonType": "string", "enum": ["pending", "processing", "completed", "failed"]},
                        "createdAt": {"bsonType": "date"},
                        "completedAt": {"bsonType": "date"},
                        "processingTime": {"bsonType": "int"}
                    }
                }
            })
            print("✓ Colección 'content_requests' creada")
        except CollectionInvalid:
            print("⚠ Colección 'content_requests' ya existe")
        
        db.content_requests.create_index([("requestId", ASCENDING)], unique=True)
        db.content_requests.create_index([("clientId", ASCENDING)])
        db.content_requests.create_index([("createdAt", DESCENDING)])
        print("  → Índices creados para 'content_requests'")
        
        # ============================================
        # 9. COLECCIÓN: clients
        # ============================================
        try:
            db.create_collection("clients", validator={
                "$jsonSchema": {
                    "bsonType": "object",
                    "required": ["clientId", "email", "name", "createdAt"],
                    "properties": {
                        "clientId": {"bsonType": "string"},
                        "email": {"bsonType": "string"},
                        "name": {"bsonType": "string"},
                        "company": {"bsonType": "string"},
                        "phone": {"bsonType": "string"},
                        "createdAt": {"bsonType": "date"},
                        "updatedAt": {"bsonType": "date"},
                        "status": {"bsonType": "string", "enum": ["active", "inactive", "suspended"]}
                    }
                }
            })
            print("✓ Colección 'clients' creada")
        except CollectionInvalid:
            print("⚠ Colección 'clients' ya existe")
        
        db.clients.create_index([("clientId", ASCENDING)], unique=True)
        db.clients.create_index([("email", ASCENDING)], unique=True)
        print("  → Índices creados para 'clients'")
        
        # ============================================
        # 10. COLECCIÓN: subscription_plans
        # ============================================
        try:
            db.create_collection("subscription_plans", validator={
                "$jsonSchema": {
                    "bsonType": "object",
                    "required": ["planId", "name", "price", "createdAt"],
                    "properties": {
                        "planId": {"bsonType": "string"},
                        "name": {"bsonType": "string"},
                        "description": {"bsonType": "string"},
                        "price": {"bsonType": "double"},
                        "currency": {"bsonType": "string"},
                        "billingCycle": {"bsonType": "string", "enum": ["monthly", "quarterly", "annual"]},
                        "status": {"bsonType": "string", "enum": ["active", "discontinued"]},
                        "createdAt": {"bsonType": "date"},
                        "updatedAt": {"bsonType": "date"}
                    }
                }
            })
            print("✓ Colección 'subscription_plans' creada")
        except CollectionInvalid:
            print("⚠ Colección 'subscription_plans' ya existe")
        
        db.subscription_plans.create_index([("planId", ASCENDING)], unique=True)
        db.subscription_plans.create_index([("name", ASCENDING)])
        print("  → Índices creados para 'subscription_plans'")
        
        # ============================================
        # 11. COLECCIÓN: features
        # ============================================
        try:
            db.create_collection("features", validator={
                "$jsonSchema": {
                    "bsonType": "object",
                    "required": ["featureId", "name", "createdAt"],
                    "properties": {
                        "featureId": {"bsonType": "string"},
                        "name": {"bsonType": "string"},
                        "description": {"bsonType": "string"},
                        "metricsTracked": {"bsonType": "array"},
                        "createdAt": {"bsonType": "date"}
                    }
                }
            })
            print("✓ Colección 'features' creada")
        except CollectionInvalid:
            print("⚠ Colección 'features' ya existe")
        
        db.features.create_index([("featureId", ASCENDING)], unique=True)
        print("  → Índices creados para 'features'")
        
        # ============================================
        # 12. COLECCIÓN: payment_methods
        # ============================================
        try:
            db.create_collection("payment_methods", validator={
                "$jsonSchema": {
                    "bsonType": "object",
                    "required": ["methodId", "name", "type", "createdAt"],
                    "properties": {
                        "methodId": {"bsonType": "string"},
                        "name": {"bsonType": "string", "enum": ["credit_card", "debit_card", "paypal", "stripe", "wire_transfer"]},
                        "type": {"bsonType": "string"},
                        "description": {"bsonType": "string"},
                        "isActive": {"bsonType": "bool"},
                        "createdAt": {"bsonType": "date"}
                    }
                }
            })
            print("✓ Colección 'payment_methods' creada")
        except CollectionInvalid:
            print("⚠ Colección 'payment_methods' ya existe")
        
        db.payment_methods.create_index([("methodId", ASCENDING)], unique=True)
        print("  → Índices creados para 'payment_methods'")
        
        # ============================================
        # 13. COLECCIÓN: payment_schedules
        # ============================================
        try:
            db.create_collection("payment_schedules", validator={
                "$jsonSchema": {
                    "bsonType": "object",
                    "required": ["scheduleId", "subscriptionId", "amount", "dueDate"],
                    "properties": {
                        "scheduleId": {"bsonType": "string"},
                        "subscriptionId": {"bsonType": "string"},
                        "amount": {"bsonType": "double"},
                        "currency": {"bsonType": "string"},
                        "dueDate": {"bsonType": "date"},
                        "status": {"bsonType": "string", "enum": ["pending", "paid", "overdue", "cancelled"]},
                        "paymentMethodId": {"bsonType": "string"},
                        "createdAt": {"bsonType": "date"}
                    }
                }
            })
            print("✓ Colección 'payment_schedules' creada")
        except CollectionInvalid:
            print("⚠ Colección 'payment_schedules' ya existe")
        
        db.payment_schedules.create_index([("scheduleId", ASCENDING)], unique=True)
        db.payment_schedules.create_index([("subscriptionId", ASCENDING)])
        db.payment_schedules.create_index([("dueDate", ASCENDING)])
        print("  → Índices creados para 'payment_schedules'")
        
        # ============================================
        # 14. COLECCIÓN: payment_transactions
        # ============================================
        try:
            db.create_collection("payment_transactions", validator={
                "$jsonSchema": {
                    "bsonType": "object",
                    "required": ["transactionId", "subscriptionId", "amount", "timestamp"],
                    "properties": {
                        "transactionId": {"bsonType": "string"},
                        "subscriptionId": {"bsonType": "string"},
                        "clientId": {"bsonType": "string"},
                        "amount": {"bsonType": "double"},
                        "currency": {"bsonType": "string"},
                        "paymentMethodId": {"bsonType": "string"},
                        "status": {"bsonType": "string", "enum": ["success", "failed", "pending", "refunded"]},
                        "externalTransactionId": {"bsonType": "string"},
                        "details": {"bsonType": "object"},
                        "timestamp": {"bsonType": "date"},
                        "processedAt": {"bsonType": "date"},
                        "errorMessage": {"bsonType": "string"}
                    }
                }
            })
            print("✓ Colección 'payment_transactions' creada")
        except CollectionInvalid:
            print("⚠ Colección 'payment_transactions' ya existe")
        
        db.payment_transactions.create_index([("transactionId", ASCENDING)], unique=True)
        db.payment_transactions.create_index([("subscriptionId", ASCENDING)])
        db.payment_transactions.create_index([("clientId", ASCENDING)])
        db.payment_transactions.create_index([("timestamp", DESCENDING)])
        print("  → Índices creados para 'payment_transactions'")
        
        # ============================================
        # 15. COLECCIÓN: campaigns
        # ============================================
        try:
            db.create_collection("campaigns", validator={
                "$jsonSchema": {
                    "bsonType": "object",
                    "required": ["campaignId", "name", "description", "createdAt"],
                    "properties": {
                        "campaignId": {"bsonType": "string"},
                        "name": {"bsonType": "string"},
                        "description": {"bsonType": "string"},
                        "targetAudience": {"bsonType": "string"},
                        "campaignMessage": {"bsonType": "string"},
                        "contentVersions": {"bsonType": "array"},
                        "usedImages": {"bsonType": "array"},
                        "status": {"bsonType": "string", "enum": ["draft", "active", "completed", "archived"]},
                        "startDate": {"bsonType": "date"},
                        "endDate": {"bsonType": "date"},
                        "createdAt": {"bsonType": "date"},
                        "updatedAt": {"bsonType": "date"}
                    }
                }
            })
            print("✓ Colección 'campaigns' creada")
        except CollectionInvalid:
            print("⚠ Colección 'campaigns' ya existe")
        
        db.campaigns.create_index([("campaignId", ASCENDING)], unique=True)
        db.campaigns.create_index([("createdAt", DESCENDING)])
        db.campaigns.create_index([("status", ASCENDING)])
        print("  → Índices creados para 'campaigns'")
        
        # ============================================
        # RESUMEN FINAL
        # ============================================
        print("-" * 60)
        print(f"✓ Base de datos '{DATABASE_NAME}' configurada exitosamente")
        print(f"✓ Total de colecciones creadas: 15")
        
        # Listar todas las colecciones
        collections = db.list_collection_names()
        print(f"\nColecciones disponibles:")
        for i, col in enumerate(collections, 1):
            print(f"  {i}. {col}")
        
        client.close()
        print("\n✓ Conexión cerrada")
        
    except Exception as e:
        print(f"\n✗ Error: {e}")
        sys.exit(1)

if 1 == 1:
    print("=" * 60)
    print("CREACIÓN DE BASE DE DATOS - PROMPTCONTENT")
    print("=" * 60)
    create_database_and_collections()
    print("\n¡Script completado exitosamente!")