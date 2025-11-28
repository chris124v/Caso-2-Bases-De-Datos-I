"""
Script para registrar Groq AI API en PCExternal_Services
"""
from pymongo import MongoClient
from datetime import datetime
import os
from dotenv import load_dotenv

load_dotenv()

MONGO_URL = "mongodb://mongouser:mongo123@localhost:30017/promptcontent?authSource=admin"
DATABASE_NAME = "promptcontent"
GROQ_API_KEY = os.getenv('GROQ_API_KEY', 'tu-api-key')

client = MongoClient(MONGO_URL)
db = client[DATABASE_NAME]

groq_service = {
    "serviceId": "SRV_GROQ_001",
    "name": "Groq AI API",
    "baseUrl": "https://api.groq.com/openai/v1",
    "authMethod": "post_bearer_token",  # ← POST AUTH
    "apiKey": GROQ_API_KEY,
    "configuration": {
        "endpoint": "/chat/completions",
        "method": "POST",  
        "headers": {
            "Authorization": "Bearer {apiKey}",
            "Content-Type": "application/json"
        }
    },
    "status": "active",
    "createdAt": datetime.now(datetime.UTC)
}

result = db.PCExternal_Services.update_one(
    {"serviceId": "SRV_GROQ_001"},
    {"$set": groq_service},
    upsert=True
)

print("Groq registrado en PCExternal_Services")
client.close()