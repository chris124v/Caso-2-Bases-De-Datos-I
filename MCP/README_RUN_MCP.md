## Ejecutar los MCP servers (local / pruebas)

Este documento explica cómo preparar el entorno, instalar dependencias y verificar las conexiones a las bases de datos desde los conectores MCP en este repositorio.

### Resumen rápido

- Requisitos: Python 3.10+ (o 3.11), `pip`, y en hosts que usen SQL Server localmente el driver ODBC (msodbcsql17/18).
- Para pruebas locales contra los servicios en Kubernetes puedes usar NodePort (ya configurado) o `kubectl port-forward`.
- Archivos útiles:
  - `MCP/local_runner.py` — runner interactivo local (dev)
  - `MCP/test_all_connectors_local.py` — script que ejecuta `test_connection()` y obtiene esquemas
  - `MCP/local_config.yaml` — muestra los endpoints/credenciales usados por el runner/tests

---

## 1) Prerrequisitos

- Tener Python 3.10+ instalado.
- Tener `kubectl` configurado apuntando al cluster donde corren las bases (si vas a probar contra k8s).
- Para SQL Server (cuando `pyodbc` se ejecuta en la máquina local) instalar el driver ODBC de Microsoft:

- Windows (instalador GUI / MSI): descargar "Microsoft ODBC Driver for SQL Server" (17 o 18) desde Microsoft.
- Ubuntu/Debian (ejemplo):

```powershell
# En Ubuntu/Debian (ejecutar en WSL o VM Linux, no en PowerShell de Windows)
sudo su -
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
apt-get update
ACCEPT_EULA=Y apt-get install -y msodbcsql18 unixodbc-dev
exit
```

Nota: en Windows normalmente no necesitas pasos adicionales — sólo asegúrate de que el driver está instalado y reinicia si es necesario.

## 2) Crear y activar un entorno Python

Recomendado (Windows PowerShell):

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install --upgrade pip
pip install -r MCP/requirements.txt
```

Si prefieres usar conda o otra herramienta, ajusta en consecuencia.

## 3) Archivos de configuración

- `MCP/local_config.yaml` contiene ejemplos de cómo definir `postgresql`, `mongodb`, y `sqlserver` con host/puerto/usuario/contraseña. Si usas NodePort, pon `service_name: localhost:31433` (o el puerto que corresponda) y `use_k8s_service: false`.
- Para pruebas dentro del cluster, monta los `ConfigMap` y `Secrets` con las credenciales; el `server_k8s.py` lee esos secretos en ejecución en k8s.

## 4) Probar las conexiones (modo local)

1. Asegúrate que los servicios en k8s son accesibles (NodePort o port-forward):

```powershell
# listar servicios y NodePorts
kubectl get svc -A

# opción: port-forward (en otra terminal)
kubectl port-forward -n promptsales svc/postgresql-service 30432:5432
kubectl port-forward -n promptcontent svc/mongodb-service 30017:27017
kubectl port-forward -n promptads svc/sqlserver-ads-service 31433:1433
kubectl port-forward -n promptcrm svc/sqlserver-crm-service 32433:1433
```

2. Ejecutar el script de pruebas - desde la raíz del repo (PowerShell):

```powershell
set PYTHONPATH=%CD%\MCP\src; python MCP/test_all_connectors_local.py
```

Salida esperada: cada conector imprime `test_connection True` cuando puede conectarse. El script también intentará obtener esquema (Postgres/Mongo/SQLServer) y mostrará tracebacks útiles si hay error.

## 5) Ejecutar el MCP server (opciones)

- Local dev (sin Docker): usar `local_runner.py` o `server_k8s.py` directamente apuntando a las credenciales en `MCP/local_config.yaml`.

```powershell
# ejemplo: ejecutar el runner interactivo
set PYTHONPATH=%CD%\MCP\src; python MCP/local_runner.py

# ejecutar el server_k8s en modo local (lee ConfigMaps/Secrets si tiene acceso k8s)
set PYTHONPATH=%CD%\MCP\src; python MCP/src/server_k8s.py
```

- En-cluster: aplicar los manifests en `kubernetes/mcp/` (ConfigMap, Secret, Deployment, RBAC). El pod debe poder acceder a los servicios por su DNS dentro del cluster: `<svc>.<ns>.svc.cluster.local:port`.

## 6) Recomendaciones adicionales

- Automatizar la creación de DBs: agregar un `Job` o `initContainer` en los `deployment.yaml` de SQL Server que ejecute los `CREATE DATABASE` necesarios.
- Añadir un script de provisión (SQL) en `kubernetes/configmap` que se ejecute en el primer arranque.
- Añadir pruebas pequeñas unitarias para los conectores que se puedan ejecutar localmente (mocked) o en un entorno de integración.

## 7) Referencias rápidas

- `MCP/test_all_connectors_local.py` — script de verificación.
- `MCP/local_config.yaml.example` — plantilla de configuración.
- `kubernetes/secrets/all-secrets.yaml` — ejemplo de Secrets con `sa_password` y credenciales de Mongo/Postgres.

---

Si quieres, puedo: (A) añadir un `Job`/`initContainer` que cree `promptads`/`promptcrm` automáticamente en los deployments `kubernetes/databases/sqlserver-*`, o (B) añadir la sección exacta que ejecutaste al `kubernetes/Kubernets.md` y a `MCP/README_DEPLOY_MCP.md`. Dime cuál prefieres y lo agrego.
