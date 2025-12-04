"""
Script 003: Llenado completo de todas las colecciones de PromptContent
Genera datos de prueba coherentes y relacionados entre colecciones
"""

import pymongo
import random
import hashlib
from datetime import datetime, timedelta
from faker import Faker

# ============================================
# CONFIGURACIÓN
# ============================================
MONGO_URL = "mongodb://mongouser:mongo123@localhost:30017/promptcontent?authSource=admin"
DATABASE_NAME = "promptcontent"

# Inicializar Faker para generar datos realistas
fake = Faker(['es_ES', 'en_US'])

# ============================================
# DATOS BASE PARA GENERACIÓN
# ============================================

# Proveedores de IA
AI_PROVIDERS = ["openai", "anthropic", "google", "huggingface", "aws_bedrock", "azure_openai"]

# Servicios externos comunes
EXTERNAL_SERVICES_DATA = [
    {"name": "OpenAI API", "baseUrl": "https://api.openai.com/v1", "authMethod": "Bearer"},
    {"name": "Anthropic Claude", "baseUrl": "https://api.anthropic.com", "authMethod": "API_KEY"},
    {"name": "Canva API", "baseUrl": "https://api.canva.com", "authMethod": "OAuth2"},
    {"name": "Adobe Creative Cloud", "baseUrl": "https://api.adobe.io", "authMethod": "OAuth2"},
    {"name": "Unsplash API", "baseUrl": "https://api.unsplash.com", "authMethod": "API_KEY"},
    {"name": "Pexels API", "baseUrl": "https://api.pexels.com", "authMethod": "API_KEY"},
    {"name": "Google Vision AI", "baseUrl": "https://vision.googleapis.com", "authMethod": "OAuth2"},
    {"name": "Stripe Payments", "baseUrl": "https://api.stripe.com", "authMethod": "Bearer"},
]

# Tipos de contenido
CONTENT_TYPES_DATA = [
    {"name": "text", "description": "Contenido textual para posts, blogs, emails", "platforms": ["Instagram", "Facebook", "LinkedIn", "Twitter"]},
    {"name": "image", "description": "Imágenes estáticas para redes sociales", "platforms": ["Instagram", "Facebook", "TikTok", "Pinterest"]},
    {"name": "video", "description": "Videos cortos y largos", "platforms": ["Youtube", "TikTok", "Instagram", "Facebook"]},
    {"name": "audio", "description": "Podcasts y audio content", "platforms": ["Youtube", "other"]},
    {"name": "carousel", "description": "Múltiples imágenes en secuencia", "platforms": ["Instagram", "Facebook", "LinkedIn"]},
    {"name": "story", "description": "Contenido efímero vertical", "platforms": ["Instagram", "Facebook", "TikTok"]},
]

# Features disponibles
FEATURES_DATA = [
    {"name": "AI Image Generation", "description": "Generación de imágenes con IA", "unit": "images"},
    {"name": "AI Text Generation", "description": "Generación de texto con IA", "unit": "words"},
    {"name": "Content Requests", "description": "Solicitudes de contenido mensuales", "unit": "requests"},
    {"name": "Campaign Management", "description": "Gestión de campañas", "unit": "campaigns"},
    {"name": "Priority Support", "description": "Soporte prioritario 24/7", "unit": "unlimited"},
    {"name": "API Access", "description": "Acceso a API de PromptContent", "unit": "calls"},
    {"name": "Advanced Analytics", "description": "Analítica avanzada de campañas", "unit": "reports"},
    {"name": "Team Collaboration", "description": "Herramientas de colaboración", "unit": "users"},
    {"name": "Custom Branding", "description": "Personalización de marca", "unit": "unlimited"},
    {"name": "Storage", "description": "Almacenamiento de contenido", "unit": "GB"},
]

CAMPAIGN_DATA = [
    {
        "description": "Lanzamiento de nueva línea de productos tecnológicos de alto rendimiento",
        "audiences": ["jóvenes profesionales tech", "early adopters", "entusiastas de tecnología"]
    },
    {
        "description": "Promoción de temporada con descuentos en ropa deportiva premium",
        "audiences": ["deportistas", "fitness enthusiasts", "atletas amateur"]
    },
    {
        "description": "Campaña de concientización sobre alimentación saludable y vida balanceada",
        "audiences": ["padres de familia", "profesionales ocupados", "personas health-conscious"]
    },
    {
        "description": "Lanzamiento de app móvil para gestión de finanzas personales",
        "audiences": ["millennials", "jóvenes profesionales", "emprendedores"]
    },
    {
        "description": "Promoción de destinos turísticos en playas de Costa Rica",
        "audiences": ["familias", "parejas", "viajeros aventureros"]
    },
    {
        "description": "Campaña de productos orgánicos para el cuidado de la piel",
        "audiences": ["mujeres 25-45", "personas con piel sensible", "eco-conscious consumers"]
    },
    {
        "description": "Lanzamiento de servicio de streaming de contenido educativo infantil",
        "audiences": ["padres", "maestros", "cuidadores de niños"]
    },
    {
        "description": "Promoción de cursos online de programación y desarrollo web",
        "audiences": ["estudiantes universitarios", "career changers", "autodidactas tech"]
    },
    {
        "description": "Campaña de productos gaming para PC y consolas de nueva generación",
        "audiences": ["gamers hardcore", "jóvenes 16-30", "streamers"]
    },
    {
        "description": "Lanzamiento de servicio de entrega de comida saludable a domicilio",
        "audiences": ["profesionales ocupados", "personas fitness", "familias modernas"]
    },
    {
        "description": "Promoción de laptops gaming de alto rendimiento con RTX 4090",
        "audiences": ["gamers profesionales", "content creators", "estudiantes de diseño"]
    },
    {
        "description": "Campaña de productos para mascotas premium y orgánicos",
        "audiences": ["dueños de mascotas", "pet lovers", "familias con perros/gatos"]
    },
    {
        "description": "Lanzamiento de servicio de consultoría financiera para pymes",
        "audiences": ["emprendedores", "dueños de pequeños negocios", "startups"]
    },
    {
        "description": "Promoción de retiros de yoga y meditación en zonas naturales",
        "audiences": ["personas estresadas", "practicantes de yoga", "buscadores de bienestar"]
    },
    {
        "description": "Campaña de artículos festivos para celebraciones de cumpleaños y aniversarios",
        "audiences": ["jóvenes", "adultos mayores", "padres organizadores de fiestas"]
    }
]

# Planes de suscripción
SUBSCRIPTION_PLANS_DATA = [
    {
        "name": "Basic",
        "description": "Plan básico para emprendedores",
        "price": 29.99,
        "billingCycle": "monthly",
        "features": [
            {"featureId": "FEAT_001", "limit": 50},    # 50 imágenes
            {"featureId": "FEAT_002", "limit": 10000}, # 10k palabras
            {"featureId": "FEAT_003", "limit": 20},    # 20 requests
            {"featureId": "FEAT_010", "limit": 5},     # 5 GB storage
        ]
    },
    {
        "name": "Professional",
        "description": "Plan profesional para pequeñas empresas",
        "price": 79.99,
        "billingCycle": "monthly",
        "features": [
            {"featureId": "FEAT_001", "limit": 200},
            {"featureId": "FEAT_002", "limit": 50000},
            {"featureId": "FEAT_003", "limit": 100},
            {"featureId": "FEAT_004", "limit": 20},
            {"featureId": "FEAT_006", "limit": 10000},
            {"featureId": "FEAT_010", "limit": 25},
        ]
    },
    {
        "name": "Business",
        "description": "Plan business para empresas medianas",
        "price": 199.99,
        "billingCycle": "monthly",
        "features": [
            {"featureId": "FEAT_001", "limit": 500},
            {"featureId": "FEAT_002", "limit": 150000},
            {"featureId": "FEAT_003", "limit": 500},
            {"featureId": "FEAT_004", "limit": 50},
            {"featureId": "FEAT_005", "limit": -1},  # unlimited
            {"featureId": "FEAT_006", "limit": 50000},
            {"featureId": "FEAT_007", "limit": -1},
            {"featureId": "FEAT_008", "limit": 10},
            {"featureId": "FEAT_010", "limit": 100},
        ]
    },
    {
        "name": "Enterprise",
        "description": "Plan enterprise con todo ilimitado",
        "price": 499.99,
        "billingCycle": "monthly",
        "features": [
            {"featureId": "FEAT_001", "limit": -1},
            {"featureId": "FEAT_002", "limit": -1},
            {"featureId": "FEAT_003", "limit": -1},
            {"featureId": "FEAT_004", "limit": -1},
            {"featureId": "FEAT_005", "limit": -1},
            {"featureId": "FEAT_006", "limit": -1},
            {"featureId": "FEAT_007", "limit": -1},
            {"featureId": "FEAT_008", "limit": -1},
            {"featureId": "FEAT_009", "limit": -1},
            {"featureId": "FEAT_010", "limit": -1},
        ]
    },
]

# Métodos de pago
PAYMENT_METHODS_DATA = [
    {"name": "credit_card", "type": "card", "description": "Tarjeta de crédito Visa/Mastercard", "isActive": True},
    {"name": "debit_card", "type": "card", "description": "Tarjeta de débito", "isActive": True},
    {"name": "paypal", "type": "digital_wallet", "description": "PayPal payments", "isActive": True},
    {"name": "wire_transfer", "type": "bank_transfer", "description": "Transferencia bancaria", "isActive": False},
]

# ============================================
# FUNCIONES DE LLENADO
# ============================================

def llenar_usuarios(db, cantidad=30):
    """Genera usuarios del sistema"""
    print(f"\n Generando {cantidad} usuarios...")
    usuarios = []
    
    roles = ["admin", "marketer", "agent", "client"]
    auth_methods = ["local", "oauth_google", "oauth_microsoft"]
    
    for i in range(1, cantidad + 1):
        usuario = {
            "userId": f"USER_{i:03d}",
            "email": fake.email(),
            "name": fake.name(),
            "role": random.choice(roles),
            "status": random.choice(["active"] * 8 + ["inactive"] * 2),
            "authMethod": random.choice(auth_methods),
            "createdAt": datetime.utcnow() - timedelta(days=random.randint(30, 365)),
            "lastLogin": datetime.utcnow() - timedelta(days=random.randint(0, 30)),
        }
        
        # Solo usuarios locales tienen passwordHash
        if usuario["authMethod"] == "local":
            usuario["passwordHash"] = hashlib.sha256(f"password{i}".encode()).hexdigest()
            usuario["lastPasswordChange"] = datetime.utcnow() - timedelta(days=random.randint(0, 180))
        
        usuario["twoFactorEnabled"] = random.choice([True, False])
        usuario["failedLoginAttempts"] = 0 if usuario["status"] == "active" else random.randint(0, 5)
        
        usuarios.append(usuario)
    
    result = db.PCUsers.insert_many(usuarios)
    print(f" {len(result.inserted_ids)} usuarios insertados")
    return usuarios


def llenar_servicios_externos(db):
    """Genera servicios externos"""
    print(f"\n Generando {len(EXTERNAL_SERVICES_DATA)} servicios externos...")
    servicios = []
    
    for i, servicio_data in enumerate(EXTERNAL_SERVICES_DATA, 1):
        servicio = {
            "serviceId": f"SRV_{i:03d}",
            "name": servicio_data["name"],
            "baseUrl": servicio_data["baseUrl"],
            "authMethod": servicio_data["authMethod"],
            "status": random.choice(["active"] * 8 + ["testing"] * 2),
            "encryptedCredentials": f"ENCRYPTED_{fake.uuid4()}",
            "configuration": {
                "timeout": random.randint(5000, 30000),
                "maxRetries": random.randint(2, 5),
                "apiVersion": f"v{random.randint(1, 3)}"
            },
            "rateLimits": {
                "requestsPerMinute": random.choice([50, 100, 200, 500]),
                "requestsPerDay": random.choice([5000, 10000, 50000, 100000])
            },
            "createdAt": datetime.utcnow() - timedelta(days=random.randint(90, 365)),
            "lastTestedAt": datetime.utcnow() - timedelta(days=random.randint(0, 7)),
        }
        servicios.append(servicio)
    
    result = db.PCExternal_Services.insert_many(servicios)
    print(f"✅ {len(result.inserted_ids)} servicios externos insertados")
    return servicios


def llenar_api_call_logs(db, servicios, usuarios, cantidad=500):
    """Genera logs de llamadas API"""
    print(f"\n Generando {cantidad} API call logs...")
    logs = []
    
    service_ids = [s["serviceId"] for s in servicios]
    user_ids = [u["userId"] for u in usuarios]
    
    for i in range(1, cantidad + 1):
        log = {
            "logId": f"LOG_{i:06d}",
            "serviceId": random.choice(service_ids),
            "endpoint": random.choice(["/generate", "/chat/completions", "/images/create", "/analyze"]),
            "method": random.choice(["POST"] * 7 + ["GET"] * 3),
            "request": {"prompt": fake.sentence(), "model": "gpt-4"},
            "response": {"status": "success", "data": fake.text()},
            "requestHeaders": {"Content-Type": "application/json"},
            "responseHeaders": {"Content-Type": "application/json"},
            "statusCode": random.choice([200] * 8 + [400, 500, 503]),
            "responseTime": random.randint(100, 5000),
            "result": random.choice(["success"] * 8 + ["error", "timeout"]),
            "userId": random.choice(user_ids),
            "platform": "promptcontent",
            "ipAddress": fake.ipv4(),
            "userAgent": fake.user_agent(),
            "processType": random.choice(["user_request", "background_job", "scheduled_task"]),
            "timestamp": datetime.utcnow() - timedelta(days=random.randint(0, 90)),
            "processedAt": datetime.utcnow() - timedelta(days=random.randint(0, 90)),
        }
        logs.append(log)
    
    result = db.PCApi_Call_Logs.insert_many(logs)
    print(f" {len(result.inserted_ids)} API call logs insertados")


def llenar_modelos_ia(db, cantidad=8):
    """Genera catálogo de modelos IA"""
    print(f"\n Generando {cantidad} modelos IA...")
    modelos = []
    
    modelos_base = ["gpt-4", "gpt-3.5-turbo", "claude-3-opus", "claude-3-sonnet", "gemini-pro", "llama-2-70b"]
    versiones_base = ["v1", "v2", "v3"]

    for i in range(1, cantidad + 1):
        modelo = {
            "modelId": f"MDL_{i:03d}",
            "name": f"Content Generator Model v{i}",
            "provider": random.choice(AI_PROVIDERS),
            "baseModel": random.choice(modelos_base),
            "modelEndpoint": f"https://api.provider.com/v1/models/model-{i}",
            "isFineTuned": random.choice([True, False]),
            "version": random.choice(versiones_base),
            "status": random.choice(["active"] * 7 + ["testing", "inactive"]),
            "createdAt": datetime.utcnow() - timedelta(days=random.randint(30, 365)),
        }
        
        if modelo["isFineTuned"]:
            modelo["fineTunedModelId"] = f"ft:{modelo['baseModel']}:promptcontent:v{i}"
            modelo["fineTunedAt"] = datetime.utcnow() - timedelta(days=random.randint(10, 180))
        
        modelos.append(modelo)
    
    result = db.PCAi_Models_Catalog.insert_many(modelos)
    print(f" {len(result.inserted_ids)} modelos IA insertados")
    return modelos


def llenar_model_logs(db, modelos, usuarios, cantidad=300):
    """Genera logs de uso de modelos IA"""
    print(f"\n Generando {cantidad} model logs...")
    logs = []
    
    model_ids = [m["modelId"] for m in modelos]
    user_ids = [u["userId"] for u in usuarios]
    
    for i in range(1, cantidad + 1):
        log = {
            "logId": f"AILOG_{i:06d}",
            "modelId": random.choice(model_ids),
            "input": fake.sentence(),
            "output": {"text": fake.text(), "confidence": random.uniform(0.7, 0.99)},
            "parameters": {"temperature": random.uniform(0.5, 1.0), "max_tokens": random.randint(100, 2000)},
            "userId": random.choice(user_ids),
            "ipAddress": fake.ipv4(),
            "processType": random.choice(["user_request"] * 7 + ["background_job"] * 3),
            "timestamp": datetime.utcnow() - timedelta(days=random.randint(0, 90)),
            "processingTime": random.randint(500, 5000),
            "status": random.choice(["success"] * 9 + ["error"]),
            "tokensUsed": {
                "inputTokens": random.randint(50, 500),
                "outputTokens": random.randint(100, 1000),
                "totalTokens": random.randint(150, 1500)
            },
            "cost": round(random.uniform(0.01, 0.50), 4),
            "mcpServerUsed": random.choice([True, False]),
        }
        logs.append(log)
    
    result = db.PCAi_Model_Logs.insert_many(logs)
    print(f" {len(result.inserted_ids)} model logs insertados")


def llenar_content_types(db):
    """Genera tipos de contenido"""
    print(f"\n Generando {len(CONTENT_TYPES_DATA)} tipos de contenido...")
    content_types = []
    
    for i, ct_data in enumerate(CONTENT_TYPES_DATA, 1):
        content_type = {
            "contentTypeId": f"CT_{i:03d}",
            "name": ct_data["name"],
            "description": ct_data["description"],
            "supportedPlatforms": ct_data["platforms"],
            "createdAt": datetime.utcnow() - timedelta(days=random.randint(180, 730)),
        }
        content_types.append(content_type)
    
    result = db.PCContent_Types.insert_many(content_types)
    print(f" {len(result.inserted_ids)} tipos de contenido insertados")
    return content_types


def llenar_features(db):
    """Genera features disponibles"""
    print(f"\n  Generando {len(FEATURES_DATA)} features...")
    features = []
    
    for i, feat_data in enumerate(FEATURES_DATA, 1):
        feature = {
            "featureId": f"FEAT_{i:03d}",
            "name": feat_data["name"],
            "description": feat_data["description"],
            "metricsTracked": ["usage_count", "success_rate", "avg_processing_time"],
            "unitOfMeasure": feat_data["unit"],
            "createdAt": datetime.utcnow() - timedelta(days=random.randint(180, 730)),
        }
        features.append(feature)
    
    result = db.PCFeatures.insert_many(features)
    print(f" {len(result.inserted_ids)} features insertadas")
    return features


def llenar_subscription_plans(db):
    """Genera planes de suscripción"""
    print(f"\n Generando {len(SUBSCRIPTION_PLANS_DATA)} planes de suscripción...")
    plans = []
    
    for i, plan_data in enumerate(SUBSCRIPTION_PLANS_DATA, 1):
        plan = {
            "planId": f"PLAN_{i:03d}",
            "name": plan_data["name"],
            "description": plan_data["description"],
            "price": plan_data["price"],
            "currency": "USD",
            "billingCycle": plan_data["billingCycle"],
            "status": "active",
            "features": [
                {
                    "featureId": f["featureId"],
                    "featureName": FEATURES_DATA[int(f["featureId"].split('_')[1]) - 1]["name"],
                    "limit": f["limit"],
                    "value": "Unlimited" if f["limit"] == -1 else str(f["limit"]),
                    "isConfigurable": False
                }
                for f in plan_data["features"]
            ],
            "createdAt": datetime.utcnow() - timedelta(days=random.randint(180, 730)),
        }
        plans.append(plan)
    
    result = db.PCSubscription_Plans.insert_many(plans)
    print(f" {len(result.inserted_ids)} planes insertados")
    return plans


def llenar_clientes(db, planes, cantidad=50):
    """Genera clientes con suscripciones"""
    print(f"\n Generando {cantidad} clientes...")
    clientes = []
    
    plan_ids = [p["planId"] for p in planes]
    
    for i in range(1, cantidad + 1):
        # Algunos clientes tienen múltiples suscripciones
        num_subscriptions = random.choices([1, 2, 3], weights=[70, 25, 5])[0]
        
        subscriptions = []
        for j in range(num_subscriptions):
            subscription = {
                "subscriptionId": f"SUB_{i:03d}_{j+1:02d}",
                "planId": random.choice(plan_ids),
                "planName": random.choice([p["name"] for p in planes]),
                "status": random.choice(["active"] * 8 + ["paused", "cancelled"]),
                "startDate": datetime.utcnow() - timedelta(days=random.randint(30, 365)),
                "endDate": datetime.utcnow() + timedelta(days=random.randint(30, 365)),
                "renewalDate": datetime.utcnow() + timedelta(days=random.randint(1, 30)),
                "paymentStatus": random.choice(["paid"] * 8 + ["pending", "failed"]),
                "usageTracking": {
                    "FEAT_001": {"used": random.randint(0, 100), "limit": 200, "resetDate": datetime.utcnow() + timedelta(days=15)},
                    "FEAT_002": {"used": random.randint(0, 5000), "limit": 10000, "resetDate": datetime.utcnow() + timedelta(days=15)},
                }
            }
            subscriptions.append(subscription)
        
        cliente = {
            "clientId": f"CLIENT_{i:03d}",
            "email": fake.company_email(),
            "name": fake.company(),
            "company": fake.company(),
            "phone": fake.phone_number(),
            "status": random.choice(["active"] * 9 + ["inactive"]),
            "createdAt": datetime.utcnow() - timedelta(days=random.randint(30, 730)),
            "updatedAt": datetime.utcnow() - timedelta(days=random.randint(0, 30)),
            "subscriptions": subscriptions
        }
        clientes.append(cliente)
    
    result = db.PCClients.insert_many(clientes)
    print(f" {len(result.inserted_ids)} clientes insertados")
    return clientes


def llenar_payment_methods(db):
    """Genera métodos de pago"""
    print(f"\n Generando {len(PAYMENT_METHODS_DATA)} métodos de pago...")
    methods = []
    
    for i, method_data in enumerate(PAYMENT_METHODS_DATA, 1):
        method = {
            "methodId": f"PM_{i:03d}",
            "name": method_data["name"],
            "type": method_data["type"],
            "description": method_data["description"],
            "isActive": method_data["isActive"],
            "createdAt": datetime.utcnow() - timedelta(days=random.randint(365, 1095)),
        }
        methods.append(method)
    
    result = db.PCPayment_Methods.insert_many(methods)
    print(f" {len(result.inserted_ids)} métodos de pago insertados")
    return methods


def llenar_payment_schedules(db, clientes, methods, cantidad=150):
    """Genera schedules de pagos"""
    print(f"\n Generando {cantidad} payment schedules...")
    schedules = []
    
    active_clients = [c for c in clientes if c["status"] == "active"]
    method_ids = [m["methodId"] for m in methods if m["isActive"]]
    
    for i in range(1, cantidad + 1):
        client = random.choice(active_clients)
        subscription = random.choice(client["subscriptions"])
        
        schedule = {
            "scheduleId": f"SCH_{i:04d}",
            "subscriptionId": subscription["subscriptionId"],
            "amount": random.choice([29.99, 79.99, 199.99, 499.99]),
            "currency": "USD",
            "dueDate": datetime.utcnow() + timedelta(days=random.randint(-30, 60)),
            "status": random.choice(["pending", "paid", "overdue"]),
            "paymentMethodId": random.choice(method_ids),
            "createdAt": datetime.utcnow() - timedelta(days=random.randint(0, 90)),
        }
        schedules.append(schedule)
    
    result = db.PCPayment_Schedules.insert_many(schedules)
    print(f" {len(result.inserted_ids)} schedules insertados")


def llenar_payment_transactions(db, clientes, methods, cantidad=250):
    """Genera transacciones de pago"""
    print(f"\n Generando {cantidad} payment transactions...")
    transactions = []
    
    active_clients = [c for c in clientes if c["status"] == "active"]
    method_ids = [m["methodId"] for m in methods if m["isActive"]]
    
    for i in range(1, cantidad + 1):
        client = random.choice(active_clients)
        subscription = random.choice(client["subscriptions"])
        
        transaction = {
            "transactionId": f"TXN_{i:06d}",
            "subscriptionId": subscription["subscriptionId"],
            "clientId": client["clientId"],
            "amount": random.choice([29.99, 79.99, 199.99, 499.99]),
            "currency": "USD",
            "paymentMethodId": random.choice(method_ids),
            "status": random.choice(["success"] * 8 + ["failed", "pending"]),
            "externalTransactionId": f"ext_{fake.uuid4()}",
            "details": {"last4": f"{random.randint(1000, 9999)}", "brand": random.choice(["Visa", "Mastercard", "Amex"])},
            "timestamp": datetime.utcnow() - timedelta(days=random.randint(0, 180)),
            "processedAt": datetime.utcnow() - timedelta(days=random.randint(0, 180)),
        }
        transactions.append(transaction)
    
    result = db.PCPayment_Transactions.insert_many(transactions)
    print(f" {len(result.inserted_ids)} transacciones insertadas")


def llenar_content_requests(db, clientes, cantidad=50):
    """Genera solicitudes de contenido COHERENTES"""
    print(f"\n📝 Generando {cantidad} content requests coherentes...")
    
    # Limpiar antes de insertar
    db.PCContent_Requests.delete_many({})
    
    requests = []
    active_clients = [c for c in clientes if c["status"] == "active"]
    
    for i in range(1, cantidad + 1):
        client = random.choice(active_clients)
        datetime.utcnow()
        # Elegir una campaña coherente
        campaign_data = random.choice(CAMPAIGN_DATA)
        campaign_desc = campaign_data["description"]
        audiences = campaign_data["audiences"]
        content_type = random.choice(["campaign_messages", "campaign_slogans", "social_post"])
        
        # Status realista (80% processing, 20% failed)
        status_choice = random.choices(
            ["processing", "failed"],
            weights=[80, 20]
        )[0]
        
        created_at = datetime.utcnow() - timedelta(days=random.randint(1, 180))
        
        request = {
            "requestId": f"REQ_{i:04d}",
            "clientId": client["clientId"],
            "contentType": content_type,
            "description": campaign_desc,
            "targetAudience": ", ".join(audiences[:2]),  # Primeras 2 audiencias
            "campaignDescription": campaign_desc,
            "httpMethod": "POST",
            "requestHeaders": {"Content-Type": "application/json"},
            "requestBody": {
                "campaignDescription": campaign_desc,
                "targetAudiences": audiences[:2]
            },
            "ipAddress": f"192.168.{random.randint(1,255)}.{random.randint(1,255)}",
            "status": status_choice,
            "createdAt": created_at,
        }
        
        # Si está completado, agregar fechas y contenido generado
        if status_choice == "completed":
            processing_time = random.randint(2000, 15000)  # 2-15 segundos
            request["completedAt"] = created_at + timedelta(milliseconds=processing_time)
            request["processingTime"] = processing_time
            
            # Simular contenido generado
            num_items = 3 * len(audiences[:2])  # 3 mensajes por audiencia
            request["generatedContent"] = [
                {
                    "contentId": f"MSG_REQ_{i:04d}_{j:02d}",
                    "contentType": content_type,
                    "metadata": {"targetAudience": audiences[j % len(audiences[:2])]}
                }
                for j in range(1, num_items + 1)
            ]
        elif status_choice == "failed":
            request["errorMessage"] = random.choice([
                "API rate limit exceeded",
                "Invalid campaign description",
                "Timeout error"
            ])
        
        requests.append(request)
    
    result = db.PCContent_Requests.insert_many(requests)
    print(f"✅ {len(result.inserted_ids)} requests insertados")
    print(f"   - Completados: {sum(1 for r in requests if r['status'] == 'completed')}")
    print(f"   - En proceso: {sum(1 for r in requests if r['status'] == 'processing')}")
    print(f"   - Fallidos: {sum(1 for r in requests if r['status'] == 'failed')}")
    
    return requests


def llenar_campaigns(db, clientes, cantidad=20):
    """Genera campañas COHERENTES basadas en las descripciones reales"""
    print(f"\n📢 Generando {cantidad} campaigns coherentes...")
    
    # Limpiar antes de insertar
    db.PCCampaigns.delete_many({})
    
    campaigns = []
    active_clients = [c for c in clientes if c["status"] == "active"]
    
    for i in range(1, cantidad + 1):
        # Elegir cliente para esta campaña
        client = random.choice(active_clients)
        
        campaign_data = random.choice(CAMPAIGN_DATA)
        campaign_desc = campaign_data["description"]
        audiences = campaign_data["audiences"]
        
        # Status realista
        status = random.choices(
            ["active", "completed", "draft", "archived"],
            weights=[30, 50, 10, 10]
        )[0]
        
        created_at = datetime.utcnow() - timedelta(days=random.randint(30, 365))
        
        campaign = {
            "campaignId": f"CAMP_{i:04d}",
            "clientId": client["clientId"],
            "name": campaign_desc[:50],  # Primeras 50 chars como nombre
            "description": campaign_desc,
            "targetAudience": ", ".join(audiences),
            "campaignMessage": f"Mensaje principal: {campaign_desc}",
            "contentVersions": [f"v{j}" for j in range(1, random.randint(2, 5))],
            "usedImages": [f"IMG_{random.randint(1,100):03d}" for _ in range(random.randint(3, 10))],
            "status": status,
            "startDate": created_at,
            "endDate": created_at + timedelta(days=random.randint(30, 180)),
            "createdAt": created_at,
            "updatedAt": datetime.utcnow() - timedelta(days=random.randint(0, 30))
        }
        
        campaigns.append(campaign)
    
    result = db.PCCampaigns.insert_many(campaigns)
    print(f"✅ {len(result.inserted_ids)} campaigns insertadas")
    print(f"   - Activas: {sum(1 for c in campaigns if c['status'] == 'active')}")
    print(f"   - Completadas: {sum(1 for c in campaigns if c['status'] == 'completed')}")
    
    return campaigns


# ============================================
# FUNCIÓN PRINCIPAL
# ============================================

def llenar_todas_colecciones():
    """
    Función principal que llena todas las colecciones en orden
    """
    print("=" * 70)
    print("LLENADO COMPLETO DE COLECCIONES - PROMPTCONTENT")
    print("=" * 70)
    
    # Conectar a MongoDB
    print("\n Conectando a MongoDB...")
    client = pymongo.MongoClient(MONGO_URL)
    db = client[DATABASE_NAME]
    
    print(f" Conectado a base de datos: {DATABASE_NAME}")
    
    # Verificar colecciones existentes
    colecciones = db.list_collection_names()
    print(f"\n Colecciones disponibles: {len(colecciones)}")
    
    # Llenado en orden (respetando dependencias)
    print("\n" + "=" * 70)
    print("INICIANDO LLENADO DE DATOS")
    print("=" * 70)
    
    try:
        # 1. Datos independientes (no tienen dependencias)
        usuarios = llenar_usuarios(db, cantidad=30)
        servicios = llenar_servicios_externos(db)
        content_types = llenar_content_types(db)
        features = llenar_features(db)
        
        # 2. Planes de suscripción 
        planes = llenar_subscription_plans(db)
        
        # 3. Clientes 
        clientes = llenar_clientes(db, planes, cantidad=50)
        
        # 4. Métodos de pago
        payment_methods = llenar_payment_methods(db)
        
        # 5. Modelos IA
        modelos = llenar_modelos_ia(db, cantidad=8)
        
        # 6. Logs y transacciones
        llenar_api_call_logs(db, servicios, usuarios, cantidad=500)
        llenar_model_logs(db, modelos, usuarios, cantidad=300)
        llenar_payment_schedules(db, clientes, payment_methods, cantidad=150)
        llenar_payment_transactions(db, clientes, payment_methods, cantidad=250)
        
        # 7. Content requests
        llenar_content_requests(db, clientes, cantidad=200)
        
        # 8. Campañas
        llenar_campaigns(db, clientes, cantidad=40)
        
        # Resumen final
        print("\n" + "=" * 70)
        print("RESUMEN FINAL")
        print("=" * 70)
        
        totales = {
            "PCUsers": db.PCUsers.count_documents({}),
            "PCExternal_Services": db.PCExternal_Services.count_documents({}),
            "PCApi_Call_Logs": db.PCApi_Call_Logs.count_documents({}),
            "PCAi_Models_Catalog": db.PCAi_Models_Catalog.count_documents({}),
            "PCAi_Model_Logs": db.PCAi_Model_Logs.count_documents({}),
            "PCContent_Types": db.PCContent_Types.count_documents({}),
            "PCmedia": db.PCmedia.count_documents({}),
            "PCContent_Requests": db.PCContent_Requests.count_documents({}),
            "PCClients": db.PCClients.count_documents({}),
            "PCSubscription_Plans": db.PCSubscription_Plans.count_documents({}),
            "PCFeatures": db.PCFeatures.count_documents({}),
            "PCPayment_Methods": db.PCPayment_Methods.count_documents({}),
            "PCPayment_Schedules": db.PCPayment_Schedules.count_documents({}),
            "PCPayment_Transactions": db.PCPayment_Transactions.count_documents({}),
            "PCCampaigns": db.PCCampaigns.count_documents({}),
        }
        
        print("\n Registros por colección:")
        total_registros = 0
        for coleccion, cantidad in totales.items():
            print(f"  • {coleccion:30s}: {cantidad:5d} documentos")
            total_registros += cantidad
        
        print(f"\n Total de documentos insertados: {total_registros}")
        
        # Verificar relaciones
        print("\n Verificando relaciones:")
        clients_con_subs = db.PCClients.count_documents({"subscriptions": {"$exists": True, "$ne": []}})
        print(f"  • Clientes con suscripciones: {clients_con_subs}/{totales['PCClients']}")
        
        completed_requests = db.PCContent_Requests.count_documents({"status": "completed"})
        print(f"  • Content requests completados: {completed_requests}/{totales['PCContent_Requests']}")
        
        active_campaigns = db.PCCampaigns.count_documents({"status": "active"})
        print(f"  • Campañas activas: {active_campaigns}/{totales['PCCampaigns']}")
        
        success_transactions = db.PCPayment_Transactions.count_documents({"status": "success"})
        print(f"  • Transacciones exitosas: {success_transactions}/{totales['PCPayment_Transactions']}")
        
        print("\n ¡Llenado completado exitosamente!")
        
    except Exception as e:
        print(f"\n Error durante el llenado: {e}")
        import traceback
        traceback.print_exc()
    
    finally:
        client.close()
        print("\n Conexión cerrada")


# ============================================
# EJECUCIÓN
# ============================================
if __name__ == "__main__":
    # Verificar que faker está instalado
    try:
        from faker import Faker
    except ImportError:
        print(" Error: Necesitas instalar Faker")
        print("   Ejecuta: pip install faker")
        exit(1)
    
    print("\n  ADVERTENCIA:")
    print("   Este script llenará TODAS las colecciones con datos de prueba.")
    print("   Si ya tienes datos, se agregarán más registros.")
    print()
    
    respuesta = input("¿Deseas continuar? (s/n): ")
    if respuesta.lower() == 's':
        llenar_todas_colecciones()
    else:
        print("Operación cancelada.")
    
    print("\n" + "=" * 70)
    print("FIN DEL SCRIPT")
    print("=" * 70)