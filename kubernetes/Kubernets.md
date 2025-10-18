### Estructura Visual del Entorno de Kubernetes

Contiene las **subcarpetas de cada base de datos**.

Cada subcarpeta tiene los archivos YAML que definen:
1. **Como crear la base de datos** (Deployment)
2. **Donde guardar los datos** (PVC - Persistent Volume Claim)
3. **Como acceder a ella** (Service)

**Estructura:**
```
databases/
├── postgresql/         ← Archivos para crear PostgreSQL
├── mongodb/           ← Archivos para crear MongoDB
├── sqlserver-ads/     ← Archivos para crear SQL Server Ads
├── sqlserver-crm/     ← Archivos para crear SQL Server CRM
└── redis/             ← Archivos para crear Redis
```

Cada carpeta es independiente, así alguien puede trabajar en `mongodb/` mientras yo trabajo en `postgresql/` sin conflictos algunos.

---

## Resumen visual:

```
kubernetes/               → Carpeta organizativa del proyecto
│
├── namespaces/          → "Carpetas virtuales" para separar recursos
│   └── all-namespaces.yaml   (crea: promptsales, promptads, etc.)
│
├── secrets/             → Contraseñas y datos sensibles
│   └── all-secrets.yaml      (usuarios y passwords de cada BD)
│
└── databases/           → Configuración de cada base de datos
    ├── postgresql/      → 3 archivos: PVC, Deployment, Service
    ├── mongodb/         → 3 archivos: PVC, Deployment, Service
    ├── sqlserver-ads/   → 3 archivos: PVC, Deployment, Service
    ├── sqlserver-crm/   → 3 archivos: PVC, Deployment, Service
    └── redis/           → 3 archivos: ConfigMap, Deployment, Service


Tipos de Kind:
- Namespace = Espacio de nombres
- Secret = Credenciales
- PersistentVolumeClaim = Solicitud de almacenamiento
- Deployment = Cómo correr un contenedor
- Service = Cómo exponer un contenedor a la red
- ConfigMap = Archivo de configuración

Comando para probar conexion con cada BD: 

### PostgreSQL

```
# Entrar al contenedor de PostgreSQL
kubectl exec -it -n promptsales $(kubectl get pod -n promptsales -l app=postgresql -o jsonpath='{.items[0].metadata.name}') -- bash

# Una vez dentro, conectarse a psql
psql -U postgres -d promptsales

# Ejecutar queries
SELECT * FROM test_connection;

# Salir
\q
exit
```

### MongoDB

```
# Entrar al contenedor de MongoDB
kubectl exec -it -n promptcontent $(kubectl get pod -n promptcontent -l app=mongodb -o jsonpath='{.items[0].metadata.name}') -- bash

# Conectarse a mongosh
mongosh -u mongouser -p mongo123 --authenticationDatabase admin

# Usar la base de datos
use promptcontent

# Ver colecciones
show collections

# Ver documentos
db.Users.find()

# Salir
exit
exit

```

### SQL Server PromptAds

Seria lo mismo para CRM pero cambiando el nombre

```
# Verificar datos en PromptAds
kubectl exec -n promptads deployment/sqlserver-ads -- /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourStrong!Passw0rd' -C -d promptads -Q "SELECT * FROM test_connection"

# Ver todas las bases de datos
kubectl exec -n promptads deployment/sqlserver-ads -- /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourStrong!Passw0rd' -C -Q "SELECT name FROM sys.databases"

Desde el contenedor

# Conectarse al contenedor
kubectl exec -it -n promptads deployment/sqlserver-ads -- /bin/bash

# Una vez dentro, conectarse a SQL Server
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourStrong!Passw0rd' -C 

# Luego ejecutar comandos SQL
USE promptads;
GO
SELECT * FROM test_connection;
GO
EXIT

# Salir del contenedor
exit

```

### SQL Server PromptCRM

```
# Verificar datos en PromptCRM
kubectl exec -n promptcrm deployment/sqlserver-crm -- /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourStrong!Passw0rd' -C -d promptcrm -Q "SELECT * FROM test_connection"

# Ver todas las bases de datos
kubectl exec -n promptcrm deployment/sqlserver-crm -- /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourStrong!Passw0rd' -C -Q "SELECT name FROM sys.databases"

Desde el contenedor

# Conectarse al contenedor
kubectl exec -it -n promptcrm deployment/sqlserver-crm -- /bin/bash

# Una vez dentro, conectarse a SQL Server
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourStrong!Passw0rd' -C

# Luego ejecutar comandos SQL
USE promptcrm;
GO
SELECT * FROM test_connection;
GO
EXIT

# Salir del contenedor
exit

```
