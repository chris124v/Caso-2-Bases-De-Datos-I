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
        
        print(f"Conectado a MongoDB")
        print(f"Base de datos: {DATABASE_NAME}")
        print("-" * 60)
        
        # ============================================
        # 1. COLECCIÓN: PCUsers
        # ============================================
        try:
            db.create_collection("PCUsers", validator={
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
            print("Colección 'PCUsers' creada")
        except CollectionInvalid:
            print("Colección 'PCUsers' ya existe")
        
        # ÍNDICES
        # SIRVEN PARA MEJORAR EL TIEMPO DE CONSULTA DE ALGUNOS VALORES Y
        # PARA ASEGURARSE DE QUE LOS VALORES QUE DEBEN SER ÚNICOS EN LA BD, NO SE REPITAN 
        db.PCUsers.create_index([("userId", ASCENDING)], unique=True)
        db.PCUsers.create_index([("email", ASCENDING)], unique=True)
        db.PCUsers.create_index([("role", ASCENDING)])
        print("  → Índices creados para 'PCPCUsers'")
        
        # ============================================
        # 2. COLECCIÓN: PCExternal_Services
        # ============================================
        try:
            db.create_collection("PCExternal_Services", validator={
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
            print("Colección 'PCExternal_Services' creada")
        except CollectionInvalid:
            print("Colección 'PCExternal_Services' ya existe")
        
        # ÍNDICES
        db.PCExternal_Services.create_index([("serviceId", ASCENDING)], unique=True)
        db.PCExternal_Services.create_index([("name", ASCENDING)])
        print("  → Índices creados para 'PCExternal_Services'")
        
        # ============================================
        # 3. COLECCIÓN: PCApi_Call_Logs
        # ============================================
        try:
            db.create_collection("PCApi_Call_Logs", validator={
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
            print("Colección 'PCApi_Call_Logs' creada")
        except CollectionInvalid:
            print("Colección 'PCApi_Call_Logs' ya existe")
        
        # ÍNDICES
        db.PCApi_Call_Logs.create_index([("logId", ASCENDING)], unique=True)
        db.PCApi_Call_Logs.create_index([("serviceId", ASCENDING)])
        db.PCApi_Call_Logs.create_index([("timestamp", DESCENDING)])
        db.PCApi_Call_Logs.create_index([("userId", ASCENDING)])
        print("  → Índices creados para 'PCApi_Call_Logs'")
        
        # ============================================
        # 4. COLECCIÓN: PCAi_Models_Catalog
        # ============================================
        try:
            db.create_collection("PCAi_Models_Catalog", validator={
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
            print("Colección 'PCAi_Models_Catalog' creada")
        except CollectionInvalid:
            print("Colección 'PCAi_Models_Catalog' ya existe")
        
        # ÍNDICES
        db.PCAi_Models_Catalog.create_index([("modelId", ASCENDING)], unique=True)
        db.PCAi_Models_Catalog.create_index([("name", ASCENDING)])
        print("  → Índices creados para 'PCAi_Models_Catalog'")
        
        # ============================================
        # 5. COLECCIÓN: PCAi_Model_Logs
        # ============================================
        try:
            db.create_collection("PCAi_Model_Logs", validator={
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
            print("Colección 'PCAi_Model_Logs' creada")
        except CollectionInvalid:
            print("Colección 'PCAi_Model_Logs' ya existe")
        
        # ÍNDICES
        db.PCAi_Model_Logs.create_index([("logId", ASCENDING)], unique=True)
        db.PCAi_Model_Logs.create_index([("modelId", ASCENDING)])
        db.PCAi_Model_Logs.create_index([("timestamp", DESCENDING)])
        print("  → Índices creados para 'PCAi_Model_Logs'")
        
        # ============================================
        # 6. COLECCIÓN: PC_Content_Types
        # ============================================
        try:
            db.create_collection("PC_Content_Types", validator={
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
            print("Colección 'PC_Content_Types' creada")
        except CollectionInvalid:
            print("Colección 'PC_Content_Types' ya existe")
        
        # ÍNDICES
        db.PC_Content_Types.create_index([("contentTypeId", ASCENDING)], unique=True)
        db.PC_Content_Types.create_index([("name", ASCENDING)])
        print("  → Índices creados para 'PC_Content_Types'")
        
        # ============================================
        # 7. COLECCIÓN: PCimages
        # ============================================
        try:
            db.create_collection("PCimages", validator={
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
            print("Colección 'PCimages' creada")
        except CollectionInvalid:
            print("Colección 'PCimages' ya existe")
        
        # ÍNDICES
        db.PCimages.create_index([("imageId", ASCENDING)], unique=True)
        db.PCimages.create_index([("hashtags", ASCENDING)])
        db.PCimages.create_index([("description", TEXT)])
        db.PCimages.create_index([("createdAt", DESCENDING)])
        db.PCimages.create_index([("status", ASCENDING)])
        print("  → Índices creados para 'PCimages'")
        
        # ============================================
        # 8. COLECCIÓN: PC_Content_Requests
        # ============================================
        try:
            db.create_collection("PC_Content_Requests", validator={
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
            print("✓ Colección 'PC_Content_Requests' creada")
        except CollectionInvalid:
            print("Colección 'PC_Content_Requests' ya existe")
        
        # ÍNDICES
        db.PC_Content_Requests.create_index([("requestId", ASCENDING)], unique=True)
        db.PC_Content_Requests.create_index([("clientId", ASCENDING)])
        db.PC_Content_Requests.create_index([("createdAt", DESCENDING)])
        print("  → Índices creados para 'PC_Content_Requests'")
        
        # ============================================
        # 9. COLECCIÓN: PC_Clients
        # ============================================
        try:
            db.create_collection("PC_Clients", validator={
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
            print("Colección 'PC_Clients' creada")
        except CollectionInvalid:
            print("Colección 'PC_Clients' ya existe")
        
        # ÍNDICES
        db.PC_Clients.create_index([("clientId", ASCENDING)], unique=True)
        db.PC_Clients.create_index([("email", ASCENDING)], unique=True)
        print("  → Índices creados para 'PC_Clients'")
        
        # ============================================
        # 10. COLECCIÓN: PCSubscription_Plans
        # ============================================
        try:
            db.create_collection("PCSubscription_Plans", validator={
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
            print("Colección 'PCSubscription_Plans' creada")
        except CollectionInvalid:
            print("Colección 'PCSubscription_Plans' ya existe")
        
        # ÍNDICES
        db.PCSubscription_Plans.create_index([("planId", ASCENDING)], unique=True)
        db.PCSubscription_Plans.create_index([("name", ASCENDING)])
        print("  → Índices creados para 'PCSubscription_Plans'")
        
        # ============================================
        # 11. COLECCIÓN: PCFeatures
        # ============================================
        try:
            db.create_collection("PCFeatures", validator={
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
            print("Colección 'PCFeatures' creada")
        except CollectionInvalid:
            print("Colección 'PCFeatures' ya existe")
        
        # ÍNDICES
        db.PCFeatures.create_index([("featureId", ASCENDING)], unique=True)
        print("  → Índices creados para 'PCFeatures'")
        
        # ============================================
        # 12. COLECCIÓN: PCPayment_Methods
        # ============================================
        try:
            db.create_collection("PCPayment_Methods", validator={
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
            print("Colección 'PCPayment_Methods' creada")
        except CollectionInvalid:
            print("Colección 'PCPayment_Methods' ya existe")
        
        # ÍNDICES
        db.PCPayment_Methods.create_index([("methodId", ASCENDING)], unique=True)
        print("  → Índices creados para 'PCPayment_Methods'")
        
        # ============================================
        # 13. COLECCIÓN: PCPayment_Schedules
        # ============================================
        try:
            db.create_collection("PCPayment_Schedules", validator={
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
            print("Colección 'PCPayment_Schedules' creada")
        except CollectionInvalid:
            print("Colección 'PCPayment_Schedules' ya existe")
        
        # ÍNDICES
        db.PCPayment_Schedules.create_index([("scheduleId", ASCENDING)], unique=True)
        db.PCPayment_Schedules.create_index([("subscriptionId", ASCENDING)])
        db.PCPayment_Schedules.create_index([("dueDate", ASCENDING)])
        print("  → Índices creados para 'PCPayment_Schedules'")
        
        # ============================================
        # 14. COLECCIÓN: PCPayment_Transactions
        # ============================================
        try:
            db.create_collection("PCPayment_Transactions", validator={
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
            print("Colección 'PCPayment_Transactions' creada")
        except CollectionInvalid:
            print("Colección 'PCPayment_Transactions' ya existe")
        
        # ÍNDICES
        db.PCPayment_Transactions.create_index([("transactionId", ASCENDING)], unique=True)
        db.PCPayment_Transactions.create_index([("subscriptionId", ASCENDING)])
        db.PCPayment_Transactions.create_index([("clientId", ASCENDING)])
        db.PCPayment_Transactions.create_index([("timestamp", DESCENDING)])
        print("  → Índices creados para 'PCPayment_Transactions'")
        
        # ============================================
        # 15. COLECCIÓN: PCCampaigns
        # ============================================
        try:
            db.create_collection("PCCampaigns", validator={
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
            print("Colección 'PCCampaigns' creada")
        except CollectionInvalid:
            print("Colección 'PCCampaigns' ya existe")
        
        # ÍNDICES
        db.PCCampaigns.create_index([("campaignId", ASCENDING)], unique=True)
        db.PCCampaigns.create_index([("createdAt", DESCENDING)])
        db.PCCampaigns.create_index([("status", ASCENDING)])
        print("  → Índices creados para 'PCCampaigns'")
        
        # ============================================
        # RESUMEN FINAL
        # ============================================
        print("-" * 60)
        print(f" Base de datos '{DATABASE_NAME}' configurada exitosamente")
        print(f" Total de colecciones creadas: 15")
        
        # Listar todas las colecciones
        collections = db.list_collection_names()
        print(f"\nColecciones disponibles:")
        for i, col in enumerate(collections, 1):
            print(f"  {i}. {col}")
        
        client.close()
        print("\n Conexión cerrada")
        
    except Exception as e:
        print(f"\n Error: {e}")
        sys.exit(1)

#Ejecutamos el script
if 1 == 1:
    print("=" * 60)
    print("CREACIÓN DE BASE DE DATOS - PROMPTCONTENT")
    print("=" * 60)
    create_database_and_collections()
    print("\n¡Script completado exitosamente!")