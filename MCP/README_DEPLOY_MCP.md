# Despliegue del MCP server que usa bases en Kubernetes

Este README describe cómo preparar y desplegar el MCP server para usar las bases de datos que tienes montadas en Kubernetes.

Requisitos previos

- Un cluster Kubernetes accesible (minikube, kind o un cluster en la nube).
- `kubectl` configurado para apuntar al cluster.
- Imagen Docker que contenga el código del MCP y las dependencias (ver `MCP/requirements.txt`).

Pasos resumidos

1. Construir la imagen del MCP
2. Aplicar ConfigMap y Secrets con las credenciales y nombres de servicios
3. Aplicar RBAC (ServiceAccount, Role, RoleBinding)
4. Desplegar el Deployment del MCP
5. Verificar logs y probar consultas

Construir y subir la imagen (ejemplo PowerShell)

```powershell
# desde la raíz del repo
docker build -t your-registry/mcp-server:latest -f MCP/Dockerfile .
docker push your-registry/mcp-server:latest
```

Aplicar ConfigMap y Secrets (ejemplo)

```powershell
kubectl apply -f kubernetes/mcp/mcp-config-examples.yaml
```

Aplicar RBAC

```powershell
kubectl apply -f kubernetes/mcp/mcp-rbac.yaml
```

Desplegar el servidor MCP

```powershell
kubectl apply -f kubernetes/mcp/mcp-deployment.yaml
```

Verificar estado del Pod

```powershell
kubectl get pods -l app=mcp-server -n default
kubectl logs -l app=mcp-server -n default --follow
```

Pruebas

- Revisa que el Pod loguee que pudo leer los Secrets/ConfigMap y que los conectores se inicializaron.
- Si todo correcto, desde el Pod o desde tu cliente que hable con el MCP, ejecuta una petición que invoque `execute_query` sobre alguna de las DBs.

Notas y recomendaciones

- Ajusta `mcp-deployment.yaml` para usar `readinessProbe`/`livenessProbe` más adecuadas si tu servidor expone un endpoint HTTP.
- Asegúrate de que los Services de las bases estén creados en el namespace indicado por el ConfigMap.
- Si deseas acceder a las DBs fuera del cluster para pruebas locales, puedes modificar `server_k8s.py` o iniciar conectores con `use_k8s_service=False` apuntando a `localhost`.
- Si usas `psycopg2` o `pyodbc`, recuerda instalar dependencias del sistema en la imagen Docker (libpq-dev, unixodbc-dev, etc.).

Siguiente pasos automáticos que puedo hacer por ti

- Generar un `MCP/Dockerfile` de ejemplo para empaquetar la aplicación.
- Añadir un Job/Probe que valide la conectividad a las DBs al iniciar.
- Crear manifests para NetworkPolicy o Service de tipo ClusterIP/Headless si lo necesitas.

Si quieres que cree también el `MCP/Dockerfile` y lo incluya en el repositorio ahora, dime y lo añado.
