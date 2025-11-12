# test_connections.py
import asyncio
import sys
import os

# Agregar src al path
sys.path.append(os.path.join(os.path.dirname(__file__), 'src'))

async def test_all_connections():
    """Probar todas las conexiones a bases de datos"""
    from config.config_manager import ConfigManager
    from connectors.postgresql_connector import PostgreSQLConnector
    from connectors.mongo_connector import MongoDBConnector
    from connectors.sqlserver_connector import SQLServerConnector
    
    print("🔍 Probando conexiones a bases de datos...")
    
    config_manager = ConfigManager()
    db_configs = config_manager.get_all_databases()
    
    results = {}
    
    # Probar PostgreSQL
    try:
        pg_config = db_configs["postgresql"]
        pg_connector = PostgreSQLConnector(
            host=pg_config["host"],
            port=pg_config["port"],
            database=pg_config["database"],
            username=pg_config["username"],
            password=pg_config["password"]
        )
        pg_ok = await pg_connector.test_connection()
        results["PostgreSQL"] = "✅ CONEXIÓN EXITOSA" if pg_ok else "❌ FALLÓ"
        print(f"PostgreSQL: {results['PostgreSQL']}")
    except Exception as e:
        results["PostgreSQL"] = f"❌ ERROR: {str(e)}"
        print(f"PostgreSQL: {results['PostgreSQL']}")
    
    # Probar MongoDB
    try:
        mongo_config = db_configs["mongodb"]
        mongo_connector = MongoDBConnector(
            host=mongo_config["host"],
            port=mongo_config["port"],
            database=mongo_config["database"],
            username=mongo_config.get("username"),
            password=mongo_config.get("password")
        )
        mongo_ok = await mongo_connector.test_connection()
        results["MongoDB"] = "✅ CONEXIÓN EXITOSA" if mongo_ok else "❌ FALLÓ"
        print(f"MongoDB: {results['MongoDB']}")
    except Exception as e:
        results["MongoDB"] = f"❌ ERROR: {str(e)}"
        print(f"MongoDB: {results['MongoDB']}")
    
    # Probar SQL Server 1
    try:
        sql1_config = db_configs["sqlserver1"]
        sql1_connector = SQLServerConnector(
            host=sql1_config["host"],
            port=sql1_config["port"],
            database=sql1_config["database"],
            username=sql1_config["username"],
            password=sql1_config["password"]
        )
        sql1_ok = await sql1_connector.test_connection()
        results["SQL Server 1"] = "✅ CONEXIÓN EXITOSA" if sql1_ok else "❌ FALLÓ"
        print(f"SQL Server 1: {results['SQL Server 1']}")
    except Exception as e:
        results["SQL Server 1"] = f"❌ ERROR: {str(e)}"
        print(f"SQL Server 1: {results['SQL Server 1']}")
    
    # Probar SQL Server 2
    try:
        sql2_config = db_configs["sqlserver2"]
        sql2_connector = SQLServerConnector(
            host=sql2_config["host"],
            port=sql2_config["port"],
            database=sql2_config["database"],
            username=sql2_config["username"],
            password=sql2_config["password"]
        )
        sql2_ok = await sql2_connector.test_connection()
        results["SQL Server 2"] = "✅ CONEXIÓN EXITOSA" if sql2_ok else "❌ FALLÓ"
        print(f"SQL Server 2: {results['SQL Server 2']}")
    except Exception as e:
        results["SQL Server 2"] = f"❌ ERROR: {str(e)}"
        print(f"SQL Server 2: {results['SQL Server 2']}")
    
    # Resumen
    print("\n" + "="*50)
    print("📊 RESUMEN DE CONEXIONES:")
    for db, result in results.items():
        print(f"  {db}: {result}")
    
    # Verificar si todas las conexiones son exitosas
    all_connected = all("✅" in result for result in results.values())
    if all_connected:
        print("\n🎉 ¡TODAS LAS CONEXIONES FUNCIONAN!")
    else:
        print("\n⚠️  Algunas conexiones fallaron. Revisa la configuración.")

if __name__ == "__main__":
    asyncio.run(test_all_connections())