# Guia de Configuracion del Entorno Local - PromptSales

**Caso #2 - Bases de Datos I**

Esta guia te llevará desde cero hasta tener todo el ambiente de desarrollo funcionando en tu computadora.

---

## Tabla de Contenidos

1. [Instalaciones Necesarias](#instalaciones-necesarias)
2. [Clonar el Repositorio](#clonar-el-repositorio)
3. [Configurar y Desplegar Kubernetes](#configurar-y-desplegar-kubernetes)
4. [Conectarse a las Bases de Datos](#conectarse-a-las-bases-de-datos)
5. [Flujo de Trabajo con Git y Scripts](#flujo-de-trabajo-con-git-y-scripts)
6. [Diseño Gráfico de Bases de Datos](#diseño-gráfico-de-bases-de-datos)
7. [Comandos Útiles](#comandos-útiles)
8. [Solución de Problemas](#solución-de-problemas)

---

## Instalaciones Necesarias

### 1. Git
```powershell
# Verificar si ya está instalado
git --version

# Si no está instalado, descargar de:
# https://git-scm.com/download/win
```

### 2. Docker Desktop (incluye Kubernetes)

**Descargar:**  
https://www.docker.com/products/docker-desktop/

**Instalación:**
1. Ejecutar el instalador
2. Reiniciar la computadora
3. Abrir Docker Desktop
4. Ir a **Settings** → **General**
5. Verificar que **"Use WSL 2 based engine"** esté marcado

**Habilitar Kubernetes:**
1. Ir a **Settings** → **Kubernetes**
2. Marcar **"Enable Kubernetes"**
3. Click en **"Apply & Restart"**
4. Esperar 2-3 minutos hasta que aparezca verde en "Kubernetes is running"

### 3. kubectl (CLI de Kubernetes)

```powershell
# Descargar kubectl
curl.exe -LO "https://dl.k8s.io/release/v1.28.0/bin/windows/amd64/kubectl.exe"

# Mover a una carpeta en el PATH (ejemplo: C:\Windows\System32)
Move-Item .\kubectl.exe C:\Windows\System32\

# Verificar instalación
kubectl version --client
```

### 4. Herramientas Gráficas para Bases de Datos

Estas solo son recomendadas pero es como para tener una idea de como se conectan. 

#### pgAdmin 4 (PostgreSQL) - PromptSales
- **Descargar:** https://www.pgadmin.org/download/
- Instalar versión Windows

#### MongoDB Compass (MongoDB) - PromptContent
- **Descargar:** https://www.mongodb.com/try/download/compass
- Instalar versión Windows

#### SQL Server Management Studio (SSMS) - PromptAds & PromptCRM
- **Descargar:** https://aka.ms/ssmsfullsetup
- Instalar versión completa

#### RedisInsight (Redis)
- **Descargar:** https://redis.io/insight/
- Instalar versión Desktop

### 5. Visual Studio Code (Es para todo el repo)

- **Descargar:** https://code.visualstudio.com/
- **Extensiones recomendadas:**
  - Kubernetes (Microsoft)
  - PostgreSQL (Chris Kolkman)
  - MongoDB for VS Code

---

## Clonar el Repositorio

### 1. Configurar Git (si es primera vez)

```powershell
# Configurar tu nombre
git config --global user.name "Tu Nombre"

# Configurar tu email de GitHub
git config --global user.email "tuemail@ejemplo.com"
```

### 2. Clonar el repositorio

```powershell
# Ir a la carpeta donde quieres el proyecto
cd C:\Users\TuUsuario\Documents

# Clonar el repositorio (reemplaza con la URL real de tu repo)
git clone https://github.com/tu-usuario/Caso-2-Bases-De-Datos-I.git

# Entrar a la carpeta
cd Caso-2-Bases-De-Datos-I
```

### 3. Verificar la estructura

```powershell
# Ver la estructura del proyecto
tree /F

# Deberías ver algo como:
# ├── kubernetes/
# │   ├── scripts/
# │   ├── namespaces/
# │   ├── secrets/
# │   └── databases/
# ├── PromptSales/
# │   └── Scripts/
# ├── PromptAds/
# │   └── Scripts/
# ├── PromptContent/
# │   └── Scripts/
# ├── PromptCRM/
# │   └── Scripts/
# └── Redis/
#     └── Scripts/
```

---

## Configurar y Desplegar Kubernetes

### 1. Verificar que Kubernetes está corriendo

```powershell
# Verificar estado de Kubernetes
kubectl cluster-info

# Deberías ver:
# Kubernetes control plane is running at https://kubernetes.docker.internal:6443
```

### 2. Ir a la carpeta de scripts de Kubernetes

```powershell
cd kubernetes/scripts
```

### 3. Desplegar todas las bases de datos

```powershell
# Ejecutar el script de despliegue
.\deploy-all.ps1

# El script hará:
# Crear 5 namespaces
# Crear secretos con contraseñas
# Desplegar PostgreSQL (PromptSales)
# Desplegar MongoDB (PromptContent)
# Desplegar SQL Server Ads (PromptAds)
# Desplegar SQL Server CRM (PromptCRM)
# Desplegar Redis (Caché)
```

### 4. Esperar a que los pods estén listos

```powershell
# Verificar estado de todos los pods
kubectl get pods --all-namespaces

# Espera hasta que todos muestren "Running" y "1/1" o "2/2"
# Esto puede tomar 1-3 minutos
```

### 5. Verificar el estado completo

```powershell
# Ejecutar el script de verificación
.\status-check.ps1

# Te mostrará:
# - Estado de namespaces
# - Estado de pods
# - Puertos y credenciales de cada BD
```

---

## Conectarse a las Bases de Datos

Ahora que Kubernetes está corriendo, se puede conectar a cada base de datos con sus herramientas gráficas. Obvio son recomendaciones pero si. En el caso de SSMS esta bien. 

### PostgreSQL (PromptSales) - pgAdmin

1. Abrir **pgAdmin 4**
2. Click derecho en **Servers** → **Register** → **Server**
3. **Pestaña General:**
   - Name: `PromptSales Local`
4. **Pestaña Connection:**
   - Host: `localhost`
   - Port: `30432`
   - Maintenance database: `postgres`
   - Username: `postgres`
   - Password: `postgres123`
5. **Save**

**Crear la base de datos:**
```sql
CREATE DATABASE promptsales;
```

---

### MongoDB (PromptContent) - MongoDB Compass

1. Abrir **MongoDB Compass**
2. En "New Connection" usar:
   ```
   mongodb://mongouser:mongo123@localhost:30017/promptcontent?authSource=admin
   ```
3. Click **Connect**

---

### 🗄️ SQL Server Ads (PromptAds) - SSMS

1. Abrir **SSMS**
2. **Server name:** `localhost,31433` ( usar **coma**, no dos puntos)
3. **Authentication:** SQL Server Authentication
4. **Login:** `sa`
5. **Password:** `YourStrong!Passw0rd`
6. **Encryption:** Cambiar de "Mandatory" a **"Optional"**  IMPORTANTE
7. Click **Connect**

**Crear la base de datos:**
```sql
CREATE DATABASE promptads;
GO
```

---

### SQL Server CRM (PromptCRM) - SSMS

1. Abrir **SSMS** (nueva ventana)
2. **Server name:** `localhost,32433` ( usar **coma**)
3. **Authentication:** SQL Server Authentication
4. **Login:** `sa`
5. **Password:** `YourStrong!Passw0rd`
6. **Encryption:** Cambiar de "Mandatory" a **"Optional"**
7. Click **Connect**

**Crear la base de datos:**
```sql
CREATE DATABASE promptcrm;
GO
```

---

### Redis - RedisInsight

1. Abrir **RedisInsight**
2. Click **"Add Redis Database"**
3. **Host:** `localhost`
4. **Port:** `30379`
5. **Password:** `redis123`
6. **Alias:** `PromptSales Cache`
7. Click **Add**

---

## Flujo de Trabajo con Git y Scripts

### Concepto Importante:

**Kubernetes NO sincroniza datos entre computadoras.**  
Cada persona tiene su propia base de datos local corriendo en Kubernetes.

Para compartir **schemas** (tablas, colecciones) y **datos**, usamos **scripts SQL/MongoDB** en GitHub.

---

### Cuando un alguien sube un script nuevo

**Ejemplo:** Dylan crea tablas en PostgreSQL y sube el script a GitHub.

**En tu computadora debes:**

```powershell
# 1. Descargar los cambios de GitHub
git pull origin main

# 2. Ver qué archivos nuevos hay
git log --oneline -5

# Supongamos que hay un nuevo archivo:
# PromptSales/Scripts/001-create-users-table.sql
```

**Ahora tienes 3 opciones para ejecutar el script:**

#### **Opción 1: pgAdmin (MÁS FÁCIL - RECOMENDADO)**

1. Abrir **pgAdmin**
2. Conectarse a `PromptSales Local`
3. Click derecho en base de datos `promptsales` → **Query Tool**
4. **File** → **Open** → Seleccionar `PromptSales/Scripts/001-create-users-table.sql`
5. Click en ** Execute**

#### Opción 2: Desde PowerShell directo

```powershell
# Ir a la raíz del proyecto
cd C:\Users\TuUsuario\Documents\Caso-2-Bases-De-Datos-I

# Ejecutar el script
Get-Content PromptSales/Scripts/001-create-users-table.sql | kubectl exec -i -n promptsales deployment/postgresql -- psql -U postgres -d promptsales
```

#### Opción 3: Copiar al pod y ejecutar

```powershell
# Copiar el script al pod
kubectl cp PromptSales/Scripts/001-create-users-table.sql promptsales/$(kubectl get pod -n promptsales -l app=postgresql -o jsonpath='{.items[0].metadata.name}'):/tmp/script.sql

# Ejecutar
kubectl exec -n promptsales deployment/postgresql -- psql -U postgres -d promptsales -f /tmp/script.sql
```

---

### Cuando tu creas un script nuevo

**Ejemplo:** Creas una tabla nueva en MongoDB.

```powershell
# 1. Crear tu script (con tu editor favorito o VS Code)
# Archivo: PromptContent/Scripts/001-create-campaigns-collection.js

# Contenido del archivo:
# db.campaigns.insertOne({
#   name: "Test Campaign",
#   status: "active"
# });

# 2. Agregar el archivo a Git
git add PromptContent/Scripts/001-create-campaigns-collection.js

# 3. Hacer commit con mensaje descriptivo
git commit -m "feat(PromptContent): agregar colección de campañas"

# 4. Subir a GitHub
git push origin main
```

**Ahora tus compañeros podrán hacer `git pull` y ejecutar tu script.**

---

### Convencion de nombres de scripts

Para mantener orden, usar este formato:

```
001-descripcion-corta.sql
002-otra-tabla.sql
003-stored-procedures.sql
```

**Numeracion por base de datos:**

- **PromptSales:** `001-create-users.sql`, `002-create-campaigns.sql`
- **PromptAds:** `001-create-ads-table.sql`, `002-seed-data.sql`
- **PromptContent:** `001-create-collections.js`
- **PromptCRM:** `001-create-clients-table.sql`

---

## Diseño Gráfico de Bases de Datos

Cada base de datos usa herramientas diferentes para diseñar visualmente, son recomendaciones:

### PostgreSQL (PromptSales)

**Opciones:**

#### **Opción 1: Supabase (Recomendado por el profesor)**
1. Crear cuenta gratuita en https://supabase.com
2. Crear nuevo proyecto
3. Ir a **Table Editor**
4. Diseñar tablas visualmente
5. Copiar el SQL generado a tus scripts locales

#### **Opción 2: pgAdmin 4 ERD Tool**
1. Abrir **pgAdmin**
2. Click derecho en `promptsales` → **ERD For Database**
3. Diseñar tablas arrastrando elementos
4. **File** → **Generate SQL** → Copiar a script

#### **Opción 3: DBeaver (Gratis)**
- Descargar: https://dbeaver.io/
- Soporta diseño visual de PostgreSQL

---

### MongoDB (PromptContent)

**Opciones:**

#### **Opción 1: Mongoose (Recomendado por el profe)**
```javascript
// Definir schema en código JavaScript/TypeScript
const campaignSchema = new mongoose.Schema({
  name: String,
  status: String,
  createdAt: Date
});
```

#### **Opción 2: PyMongo (Python)**
```python
# Definir estructura en Python
from pymongo import MongoClient

client = MongoClient('mongodb://mongouser:mongo123@localhost:30017')
db = client.promptcontent
```

#### **Opción 3: MongoDB Compass (GUI)**
1. Abrir **MongoDB Compass**
2. Conectarse a `promptcontent`
3. Click en **"Create Collection"**
4. Agregar documentos de ejemplo
5. MongoDB NO requiere schema fijo, pero puedes documentar la estructura en JSON

** Importante:** MongoDB NO tiene "diagrama físico" tradicional como SQL.  
Documentas la estructura en archivos JSON o con código (Mongoose/PyMongo).

---

### SQL Server (PromptAds & PromptCRM)

**Opciones:**

#### **Opción 1: SSMS Database Diagrams**
1. Abrir **SSMS**
2. Conectarse a `localhost,31433` (PromptAds) o `localhost,32433` (PromptCRM)
3. Expandir base de datos → Click derecho en **"Database Diagrams"**
4. **"New Database Diagram"**
5. Diseñar tablas visualmente
6. Click derecho → **Generate Change Script** → Copiar a archivo

#### **Opción 2: SQL Server Data Tools (SSDT)**
- Incluido en Visual Studio
- Diseño visual más avanzado

#### **Opción 3: dbdiagram.io (Online, gratis)**
- https://dbdiagram.io/
- Diseñar visualmente y exportar SQL para SQL Server

---

### Redis

**Redis NO tiene diseñador gráfico** porque usa estructura clave-valor simple.

**Documentar en Markdown:**
```markdown
# Estructura de Redis

## Keys para caché de campañas:
- `campaign:{id}` → JSON con datos de campaña
- `user:{id}:sessions` → Lista de sesiones activas

## TTL (Time To Live):
- Campañas: 3600 segundos (1 hora)
- Sesiones: 1800 segundos (30 minutos)
```

---

## Comandos Útiles

### Ver estado del cluster

```powershell
# Ver todos los pods
kubectl get pods --all-namespaces

# Ver servicios y puertos
kubectl get services --all-namespaces

# Ver logs de un pod (si hay error)
kubectl logs -n promptsales deployment/postgresql
```

### Conectarse directamente a las bases de datos desde PowerShell

```powershell
# PostgreSQL
kubectl exec -it -n promptsales deployment/postgresql -- psql -U postgres -d promptsales

# MongoDB
kubectl exec -it -n promptcontent deployment/mongodb -- mongosh -u mongouser -p mongo123 --authenticationDatabase admin promptcontent

# SQL Server Ads
kubectl exec -it -n promptads deployment/sqlserver-ads -- /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourStrong!Passw0rd' -C

# SQL Server CRM
kubectl exec -it -n promptcrm deployment/sqlserver-crm -- /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourStrong!Passw0rd' -C

# Redis
kubectl exec -it -n redis deployment/redis -- redis-cli -a redis123
```

### Reiniciar un pod

```powershell
# Eliminar el pod (Kubernetes lo recreará automáticamente)
kubectl delete pod -n promptsales <nombre-del-pod>
```

### Eliminar TODO y empezar de cero

```powershell
# ESTO ELIMINA TODOS LOS DATOS
cd kubernetes/scripts
.\delete-all.ps1

# Volver a desplegar
.\deploy-all.ps1
```

---

## Solución de Problemas

### Problema: "kubectl no se reconoce como comando"

**Solución:**
```powershell
# Verificar que kubectl.exe está en C:\Windows\System32
Get-Command kubectl

# Si no está, volver a la sección de instalación
```

---

### Problema: Pods en estado "Pending" o "CrashLoopBackOff"

**Solución:**
```powershell
# Ver qué está pasando
kubectl describe pod -n <namespace> <nombre-pod>

# Ver logs
kubectl logs -n <namespace> <nombre-pod>

# Común: Falta de recursos RAM
# Ve a Docker Desktop → Settings → Resources
# Aumentar Memory a mínimo 8GB
```

---

### Problema: No puedo conectarme a SQL Server en SSMS

**Soluciones:**

1. **Verificar que usas coma:** `localhost,31433` (NO dos puntos)
2. **Cambiar Encryption:** De "Mandatory" a **"Optional"**
3. **Verificar que el pod está corriendo:**
   ```powershell
   kubectl get pods -n promptads
   ```

---

### Problema: Git pide usuario y contraseña cada vez

**Solución:**
```powershell
# Configurar cache de credenciales
git config --global credential.helper wincred
```

---

### Problema: "Error: port is already allocated"

**Solución:**
```powershell
# Ver qué está usando el puerto
netstat -ano | findstr :30432

# Matar el proceso (reemplaza <PID> con el número que aparece)
taskkill /PID <PID> /F

# O cambiar el puerto en el archivo service.yaml
```

---


