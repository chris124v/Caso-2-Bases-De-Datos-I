# Investigación Caso #2
### Bases de Datos I  

**Integrantes:**  
- Dylan Chacón Berrocal, 2023171126  
- Christopher Daniel Vargas Villalta, 2024108443  
- Miguel Agüero Mata, 2020100846  
- Luan Chaves Bermúdez, 2019157253  
- Lindsay Marín Sánchez, 2024163904  

---

## Introducción

En este documento realizaremos la división de los roles, la investigación del caso y la clarificación de dudas.

---

## Prompt Sales

Prompt Sales es una subempresa de SolidNY, cuyo objetivo es cerrar ventas de forma eficiente y medible.  
Sus métricas se basan en la cantidad y el monto de las ventas logradas.  
Esta sería la base principal del sistema, con subempresas conectadas que gestionan los procesos de mercadeo y ventas.  
Trabaja **end-to-end**.

**Áreas principales:**
- Automatización  
- Análisis de datos  
- Inteligencia artificial  

Se estudiará el embudo de ventas.

### End to end

Cuando se dice que PromptSales trabaja end-to-end, significa que la empresa gestiona todo el proceso de ventas de principio a fin, sin dejar ninguna etapa fuera. Es decir:

- Inicio (End 1): Desde la creación del contenido y estrategia de marketing
- Medio: Pasando por la ejecución de campañas publicitarias
- Final (End 2): Hasta el cierre de la venta y seguimiento del cliente

En lugar de especializarse solo en una parte (por ejemplo, solo hacer anuncios), PromptSales cubre la experiencia completa del cliente. Esto les da:

- Control total sobre cada fase
- Mejor integración entre las diferentes etapas
- Responsabilidad directa sobre los resultados finales (las ventas)

### Embudo de Ventas

El embudo de ventas es un modelo que representa el recorrido que hace un cliente potencial desde que conoce un producto hasta que realiza la compra. Se llama "embudo" porque en cada etapa va disminuyendo el número de personas.

1. Conciencia/Descubrimiento: El cliente potencial conoce la marca o producto
2. Interés: Muestra interés activo, visita el sitio web, sigue en redes sociales
3. Consideración: Evalúa el producto, compara opciones, hace preguntas
4. Decisión/Compra: Realiza la compra

En el caso de PromptSales, cada subempresa maneja diferentes partes del embudo:

- PromptContent: Crea el contenido para atraer atención (parte superior del embudo)
- PromptAds: Ejecuta campañas para generar interés y consideración (parte media)
- PromptCRM: Da seguimiento a los leads y cierra ventas (parte inferior del embudo)


---

## Subempresas

Las subempresas trabajan de forma interconectada pero son independientes entre sí:

- **Prompt Content:** Creación de contenido creativo para las campañas.  
- **Prompt Ads:** Responsable de la ejecución y optimización de campañas publicitarias.  
- **Prompt CRM (Client Response Manager):** Gestiona el seguimiento de los clientes potenciales hasta el cierre de la venta.

---

## Portal Web Unificado

El portal unificado de Prompt Sales funciona como el centro de control donde los mercadólogos y agentes gestionan todas las actividades del ecosistema.  
Desde esta plataforma se diseñan estrategias completas que abarcan campañas, contenido, audiencias, medios y tiempos.

---

## Sección de investigación para Prompt Sales (Chris y Miguel)

- Datos de clientes: información de empresas, productos, objetivos de venta, presupuestos y contactos. (?)  

* Empresas Clientes: Nombre, industria, tamano, ubicacion

* Productos/Servicios: Que vende cada cliente

* Objetivo de Venta: Metas numericas para conseguir nuevos clientes o mas ventas.

* Presupuestos: Cuanto dinero tienen disponible para la campana de marketing 

* Contactos: Usuarios puede referirse aqui, contact types y demas. 


- Datos de campañas: mensajes, medios, tiempos, presupuestos, métricas de rendimiento. (?)

Info sobre cada campana de marketing que haya. A mi parecer esto seria de prompts ads. 

* Mensajes: El texto o contenido de la campana.

* Medios: Donde se publica podrian ser los chanels que usamos en prompt ads.

* Presupuestos: Cuanto se invierte en cada campana. 

* Metricas: Resultados clicks, conversiones ventas. 


- Datos de contenido: materiales creados, formatos, versiones aprobadas, derechos de uso. (?) 

Esta claramente seria para prompt content, me parece que cada pregunta va guida a cada BD. 

* Materiales: Imagenes, videos, textos y audios. 

* Formato: jpg, png, mp4, txt etc ..

* Versiones: Seria basicamente el historial de cambios

* Aprobaciones: Quien aprobo el contenido generado. 

* Derechos de uso: Licencias, restricciones etc .. 


- Datos de interacción: leads, historial de comunicación, respuestas automáticas, comportamiento del usuario. (?) 

Esto seria justamente para la base de prompt CRM. 

* Leads: Personas interesadas, nombre, gmail, telefono, etc .. 

* Historial: Registro de emails enviados llamadas y mensajes

* Respuestas automaticas: Chat bots, emails automaticos

* Comportamientos: Que paginas visito, que links clico, cuanto tiempo estuvo etc .. 


- Datos de integración: conexiones API, autenticaciones, sincronización de datos entre sistemas externos. (?) 

Esto seria mas que todo para la conexion con sistemas externos, creo que esto deberia ser aplicado a todas las tablas. 

* Apis conectadas: Cosas como google ads, meta ads y demas

* Autenticaciones: Tokens, api keys etc .. 

* Sincronizacion: Esto a mi parecer se refiere a los datos interconectados enter BDs y demas. 

* Logs de integracion: Registro de exitos y errores.  


- Módulos de IA: generación de contenido, predicción de intención de compra, optimización de anuncios, análisis de sentimiento y ranking de rendimiento. (?)

* Generación de contenido: Prompts usados, resultados generados

* Predicción de compra: Score de probabilidad de que un lead compre

* Optimización: Recomendaciones de IA para mejorar anuncios

* Analisis de sentimiento: Positivo/negativo/neutral de comentarios

* Ranking: Clasificación de campañas/contenidos por rendimiento

---

## Preguntas sobre la visión técnica de Prompt Sales

1. Interconexión entre subempresas: ¿Qué son los MCP (Model Context Protocol)?

MCP es un protocolo de comunicación creado por Anthropic (la empresa que creó Claude) para permitir que modelos de IA se conecten de forma estandarizada con diferentes fuentes de datos y herramientas.

Piensa en MCP como un "traductor universal" entre:

- Modelos de IA (como Claude, GPT, etc.)
- Bases de datos
- APIs externas
- Herramientas y servicios

Para que sirven los MCPs.

Problema que resuelve:
Antes de MCP, si querías que una IA accediera a:

- Una base de datos
- Una API de Google Ads
- Un sistema CRM
- Archivos en un servidor

Tenías que programar conexiones específicas para cada caso, sin un estándar común.

Solución con MCP:
MCP proporciona un protocolo estándar donde:

- Defines "tools" (herramientas) que la IA puede usar
- La IA puede descubrir qué herramientas están disponibles
- La IA puede ejecutar esas herramientas de forma segura
- Todo bajo un mismo protocolo de comunicación

Estos serian los componentes de todo MCP:

1. **MCP Client** (Cliente):
   - La aplicación o IA que **consume** las herramientas
   - Ejemplo: Claude Desktop, tu portal web

2. **MCP Server** (Servidor):
   - El programa que **expone** las herramientas
   - Tú lo programas para conectarse a tus bases de datos
   - Define qué puede hacer la IA

3. **Tools** (Herramientas):
   - Funciones específicas que la IA puede ejecutar
   - Ejemplo: `buscarCampaña`, `obtenerLeads`, `generarReporte`

4. **Resources** (Recursos):
   - Datos que el servidor puede proveer
   - Ejemplo: esquemas de base de datos, archivos, documentos


¿Por qué usar MCP para interconectar las bases de datos?

Sin MCP: IA → Acceso directo a PostgreSQL = (la IA podría hacer DROP TABLE, DELETE, etc.)

Con MCP: IA → MCP Server → PostgreSQL = (el servidor controla QUÉ puede hacer la IA)


### Interoperabilidad entre diferentes bases de datos

```
MCP Server de PromptSales puede:
- Consultar PostgreSQL (PromptSales)
- Consultar MongoDB (PromptContent)
- Consultar SQL Server (PromptAds)
- Consultar SQL Server (PromptCRM)
- Consultar Redis (caché)

Todo bajo el MISMO protocolo

```
### Consultas en lenguaje natural

```
Usuario: "¿Cuál fue el ROI de las campañas de diciembre?"

IA (usando MCP):
1. Entiende la pregunta
2. Llama al tool adecuado del MCP Server
3. Recibe los datos
4. Genera una respuesta en lenguaje natural

```

### ¿Por qué interconectar mediante servidores MCP?

### 1. Cada subempresa tiene su propio MCP Server:

```
PromptContent → MCP Server Content
PromptAds → MCP Server Ads  
PromptCRM → MCP Server CRM
PromptSales → MCP Server Sales (centralizado)

```

### 2. El MCP Server de PromptSales puede:
- Consultar su propia base (PostgreSQL)
- **Llamar a otros MCP Servers** (Content, Ads, CRM) cuando necesite datos detallados
- Mantener todo bajo el mismo protocolo


### 3. Beneficios de esta arquitectura:

- Seguridad: Cada servidor controla su propio acceso
- Modularidad: Cada subempresa es independiente
- Escalabilidad: Se pueden agregar más servidores fácilmente
- Mantenibilidad: Cambios en una base no afectan a las otras
- IA-Ready: Cualquier IA puede consultar mediante MCP

En resumen 

MCP es el protocolo que permite:

- Que la IA acceda a las bases de datos de forma segura y controlada
- Que las 4 subempresas se comuniquen bajo un estándar común
- Que el sistema responda consultas en lenguaje natural
- Que sea escalable y modular

En realidad todo se puede hacer con APIS rest pero teoricamente es mejor con MCPs dado al modelado de la IA. 


2. Despliegue, orquestación y mantenimiento: ¿Qué es Kubernetes?

Kubernetes (K8s) es una plataforma de orquestación de contenedores de código abierto que automatiza el despliegue, escalado y gestión de aplicaciones containerizadas. Es como un "director de orquesta" que coordina múltiples contenedores (como Docker) en un clúster de máquinas.

#### ¿Cómo funciona Kubernetes?
Arquitectura básica:

#### Control Plane (Plano de Control)

- API Server: punto de entrada para todas las operaciones
- Scheduler: decide dónde ejecutar los pods
- Controller Manager: mantiene el estado deseado del sistema
- etcd: base de datos que almacena toda la configuración

#### Worker Nodes (Nodos de Trabajo)

kubelet: agente que ejecuta en cada nodo
Container Runtime: Docker, containerd, etc.
kube-proxy: maneja la red entre pods

#### Conceptos clave:

- Pod: La unidad más pequeña en K8s. Contiene uno o más contenedores que comparten red y almacenamiento. Para tu proyecto, cada base de datos será un pod.
- Deployment: Define cómo desplegar y actualizar tus pods. Maneja réplicas y actualizaciones automáticas.
- Service: Expone tus pods a la red, permitiendo que se comuniquen entre sí.
- Persistent Volume (PV) y Persistent Volume Claim (PVC): Almacenamiento persistente para tus bases de datos.
- ConfigMap y Secrets: Almacenan configuración y datos sensibles (contraseñas, etc.)
- Namespace: Aísla recursos, útil para separar PromptSales, PromptAds, PromptContent, PromptCRM.

#### Para que sirve en el proyecto Kubernetes: 

1. Escalabilidad automática: K8s puede aumentar o disminuir réplicas según la carga
2. Alta disponibilidad: Si un pod falla, K8s lo reinicia automáticamente
3. Balanceo de carga: Distribuye tráfico entre réplicas
4. Rolling updates: Actualiza sin tiempo de inactividad
5. Autocuración: Detecta y reemplaza pods no saludables
6. Orquestación compleja: Maneja dependencias entre servicios

Cumple los requerimientos no funcionales:

Rendimiento: Cacheo con Redis, balanceo de carga
Escalabilidad: Horizontal Pod Autoscaler (HPA) basado en CPU/memoria
Tolerancia a fallos: Reinicio automático, réplicas, failover
Seguridad: Network Policies, Secrets encriptados, RBAC

#### Diferencias con Docker

- Docker: Es la tecnología que crea los contenedores (las "cajas" donde vive tu PostgreSQL, MongoDB, etc.)
- Kubernetes: Es el orquestador que gestiona esos contenedores de Docker

- Docker = los contenedores individuales (como cajas)
- Kubernetes = el sistema de gestión de almacén que mueve, organiza y cuida esas cajas

Kubernetes usa Docker (u otro container runtime) por debajo. No reemplaza a Docker, lo complementa.

#### Escalabilidad

¿Qué significa escalabilidad automática?
- Escalabilidad = la capacidad de manejar más trabajo
- Automática = sin que tú hagas nada manualmente

Ejemplo práctico:
Imagina que PromptAds tiene 100 usuarios consultando campañas:
- 1 pod de SQL Server maneja las peticiones tranquilamente
- De repente llegan 5,000 usuarios simultáneos (tu proyecto dice hasta 100,000 operaciones por minuto):

Kubernetes detecta automáticamente que el CPU está al 80%
- Crea automáticamente 4 pods más de SQL Server (réplicas)
- Ahora hay 5 pods distribuyendo el trabajo
- Cuando la carga baja, elimina automáticamente los pods extras

Tú no tienes que hacer nada. Kubernetes lo hace solo basándose en reglas que defines (como "si el CPU pasa del 70%, agrega más pods").

#### Tipos de escalabilidad:

- Horizontal: Agregar más pods (más copias de la BD) = De 1 pod → 5 pods → 10 pods

- Vertical: Darle más recursos a un pod = De 512MB RAM → 2GB RAM

#### Depolyment
Un Deployment es una declaración de cómo quieres que se ejecute tu aplicación.

Analogía:
Es como una receta de cocina que le das a Kubernetes:
Receta: "PostgreSQL de PromptSales"
- Ingrediente: imagen de postgres:16
- Cantidad: quiero 2 copias (réplicas)
- Condimentos: necesita estas variables de ambiente (usuario, password, DB)
- Recipiente: guárdalo en este disco (PVC)
- Temperatura: necesita 512MB de RAM y 500m de CPU
- Si se quema: hazlo de nuevo automáticamente
Kubernetes lee esa receta y:

Descarga la imagen de PostgreSQL
Crea 2 pods idénticos
Les inyecta las variables de ambiente
Les conecta el almacenamiento
Los monitorea constantemente
Si uno falla, lo reinicia
Si actualizas la receta, actualiza los pods sin apagarlos todos

#### Deployment vs Pod

- Pod: Una instancia corriendo en un momento dado = "Hay un contenedor de PostgreSQL ejecutándose AHORA"

- Deployment: La definición de cómo deben existir los pods = "SIEMPRE debe haber 2 PostgreSQL corriendo, y si uno muere, créalo de nuevo"

#### ¿Por qué no crear Pods directamente?
Porque los Deployments tienen superpoderes:

- Autocuración: Si un pod muere, el Deployment crea uno nuevo automáticamente
- Actualizaciones sin downtime: Puedes actualizar la imagen de PostgreSQL y Kubernetes va reemplazando pods uno por uno (rolling update)
- Rollback: Si la actualización falla, vuelve a la versión anterior automáticamente
- Escalado: Cambias replicas: 2 a replicas: 5 y Kubernetes crea 3 pods más

#### Resumen

- Kubernetes: Gerente que organiza contenedores de Docker
- Pod: Contenedor(es) corriendo en un momento dado
- Deployment: Instrucciones permanentes de cómo deben existir los pods
- Escalabilidad automática: Kubernetes crea/elimina pods según la carga



Comandos para Kubernetes: 

```
- Ver información del cluster
kubectl cluster-info

- Ver todos los pods en todos los namespaces
kubectl get pods --all-namespaces

- Ver servicios
kubectl get services --all-namespaces

- Aplicar un archivo YAML (crear recursos)
kubectl apply -f archivo.yaml

- Ver logs de un pod
kubectl logs nombre-del-pod -n namespace

- Eliminar recursos
kubectl delete -f archivo.yaml
```

3. Integración de servicios externos o internos: ¿Usamos API o servidores MCP?  

En realidad los MCPs es lo mismo que las APIs rest solo que los MCPs son mas nuevos y estandarizados para IAs. Por ejemplo, los mcps descubren automatica las capacidades osea los tools disponibles para interactuar con las bases de datos.

Usar API REST cuando:

- Necesitas acceso público/web tradicional
- Clientes diversos (web, mobile, third-party)
- Operaciones CRUD estándar
- No hay IA involucrada primordialmente

Usa MCP cuando:

- La IA es el consumidor principal
- Necesitas consultas en lenguaje natural
- Quieres minimizar tokens de IA
- Necesitas descubrimiento automático de capacidades
- Operaciones complejas que requieren múltiples pasos

Como tal el portal web no existe. Nosotros disenamos las tablas y ya.

Beneficios que da usar MCPs. 

- Está específicamente requerido en el caso
- Es más eficiente para IA (menos tokens, más rápido)
- Es la tecnología moderna para sistemas AI-first
- Permite consultas en lenguaje natural de forma nativa
- Cumple mejor con los requerimientos no funcionales de rendimiento


4. Aplicaciones web y paneles administrativos: ¿Qué es Vercel? ¿Qué sistema de despliegue continuo (CI/CD) se usa?  

Vercel es una plataforma de hosting y despliegue en la nube, especializada en aplicaciones web modernas, especialmente front end y full stack. 

Carateristicas: 

1. Hosting optimizado para frameworks modernos

2. Despliegue automático desde Git

3. Serverless Functions: Crear apis sin servidor

4. Edge Network (CDN global)

Tu aplicación se replica en múltiples servidores alrededor del mundo para menor latencia.

- Usuario en Costa Rica → Servidor en Miami (20ms)
- Usuario en Japón → Servidor en Tokio (15ms)
- Usuario en Europa → Servidor en Frankfurt (18ms)

Ventajas:

- Facil de usar
- Previews automaticos = Cada Pull Request en GitHub genera una **URL de preview**:
- Integracion con bases de datos conectarse al kluster de Kubernetes.
- Variables de entorno sencillas para el dashboard en vercel.
- Analytics integrado = metricas de tiempo de carga, visitas, core web vitals y errores. 

### Que es CI/CD? 

**CI/CD** significa **Continuous Integration / Continuous Deployment** (Integración Continua / Despliegue Continuo).

Es una metodología de desarrollo que automatiza todo el proceso desde que escribes código hasta que está en producción.

### CI - Integracion Continua 

Definición: Integrar código frecuentemente (varias veces al día) y verificar automáticamente que funcione.

**Flujo sin CI:**
```
Developer 1: Trabaja 2 semanas en su rama
Developer 2: Trabaja 2 semanas en su rama
Developer 3: Trabaja 2 semanas en su rama

Al final:
Intentan juntar todo → CONFLICTOS MASIVOS
Código incompatible entre ramas
Toma días resolver problemas
```

### **Flujo con CI:**
```
Cada desarrollador:
1. Escribe código
2. Hace commit
3. Push a GitHub
   ↓
4. Sistema automático:
    Ejecuta tests
    Verifica que compile
    Verifica estándares de código
    Integra con el código principal
   
Si algo falla → Notifica inmediatamente
```

### CD - Despliegue continuo 

Definición: Cada cambio que pasa los tests se despliega automáticamente a producción.

### **Flujo sin CD:**
```
1. Developer termina feature
2. Hace pull request
3. Code review
4. Merge a main
5. Alguien manualmente:
   - SSH al servidor
   - git pull
   - npm install
   - npm run build
   - Reiniciar servidor
   - Rezar que funcione
```

### **Flujo con CD:**
```
1. Developer termina feature
2. Hace pull request
3. Code review
4. Merge a main
   ↓
5. Automáticamente:
   - Vercel detecta cambio
   - Build automático
   - Tests automáticos
   - Deploy a producción
   - Health check
   - Rollback si falla
```

Importane mencionar que CI/CD esta integrado de forma nativa en Vercel.



5. Bases de datos en la nube: ¿Qué es Redis? ¿Qué es una base de datos centralizada?

Redis significa REmote DIctionary Server (Servidor de Diccionario Remoto).Es una base de datos en memoria (RAM) ultra-rápida que almacena datos en formato clave-valor. Todo el almacenamiento se hace en RAM, el modelo clave valor es como un hashmap. El usar Redis nos ayuda a reducir la cantidad de llamadas a apis y mcps, esto ademas de que minimiza los tokens de la ia y aumenta la velocidad de respuesta. 

```
## Redis: Implementación Local vs Nube

### Decisión:
Implementamos Redis localmente en Kubernetes por:
- Propósitos académicos
- Costo cero
- Mayor control y aprendizaje

### Diferencias con Redis en la nube:
| Aspecto | Local (actual) | Nube (producción) |
|---------|----------------|-------------------|
| Costo | $0 | $50-100/mes |
| Disponibilidad | 99% (cuando PC encendida) | 99.99% |
| Escalabilidad | 512MB fijo | Hasta TBs |
| Backups | Manual | Automáticos |

### Para producción real se recomienda:
- Redis Cloud o AWS ElastiCache
- Replicación multi-región
- Backups automáticos cada hora
- Monitoreo con alertas

```

---

## Preguntas sobre requerimientos no funcionales

### 1. Rendimiento
a. Promedio de respuesta del portal web: 2.5 segundos en operaciones estándar. ¿Cómo se logra?  

b. Consultas cacheadas mediante Redis: resultados en menos de 400 milisegundos. ¿Cómo se logra?  

c. ¿Cómo conseguir que la generación automática dure menos de 7 segundos y la IA compleja menos de 20 segundos?

### 2. Escalabilidad
a. La arquitectura debe soportar hasta 10 veces la carga base sin degradación perceptible, que significa esto?  

b. Kubernetes debe permitir autoescalado horizontal basado en CPU, memoria y número de solicitudes concurrentes, que significa esto?

### 3. Tolerancia a fallos
a. Disponibilidad mínima del sistema: 99.9% mensual, que significa? 

b. Los contenedores críticos deben reiniciarse automáticamente ante fallas, quee significa?

c. Redis y las bases de datos deben contar con replicación en tiempo real y failover automático, que significa esto?

### 4. Seguridad
a. Autenticación y autorización mediante OAuth 2.0. Que es esto y como se aplica? 

b. Comunicación cifrada entre servicios con TLS 1.3. Que es esto y qee significa? 

c. Cifrado de datos en reposo con AES-256. Como logro este cifrado de datos?
Esto seria simplemente el cifrado de datos con VARBINARY o similares con informacion sensible.

AES = Advanced Encryption Standard, 256 = Tamaño de la clave (bits) - muy seguro. Es un algoritmo de cifrado simetrico. 

d. Auditoría y logging centralizado con retención de 90 días. Como configuro esto?
Esto es basicamente llevar el registro de logs para la auditorias, con la tabla de logs ya se ejemplifica bien. 

e. Cumplimiento con estándares internacionales de protección de datos (GDPR, CCPA) y principio de mínimo privilegio. Como cumplo con estos estandares y que son?

Reglamento General de Protección de Datos (GDPR)

- Qué es: Una ley de la Unión Europea para proteger la privacidad de los datos de los individuos dentro de la UE. 

- Alcance: Afecta a todas las empresas que procesan datos de residentes de la UE, independientemente de su ubicación.

- Propósito: Reforzar y unificar la protección de datos para todas las personas en la UE. 
Dato clave: Requiere una base legal para procesar datos antes de hacerlo. 

Ley de Privacidad del Consumidor de California (CCPA)

- Qué es: Una ley del estado de California que entró en vigor en 2020 y otorga a los residentes más control sobre su información personal. 

- Alcance: Se aplica a empresas que hacen negocios en California, particularmente aquellas con ingresos anuales brutos superiores a \$25 millones. 

- Propósito: Dar a los residentes de California derechos como conocer qué datos se recopilan, solicitarlos, y oponerse a su venta. 

- Dato clave: Permite a los consumidores demandar a las empresas en caso de incumplimiento. 

Basicamente GDPR requiere poder eliminar datos de usuarios, se debe permitir digamos el derecho al olvido. Esto no creo que sea tan necesario porque los disenos siempre se mantienen parecidos pero es importante denotarlo. 

Esto me parece importante para las tablas de usuarios. Tabla de consentimientos. 

```
CREATE TABLE PSClients (
    id_client SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    gdpr_consent BOOLEAN DEFAULT FALSE,
    gdpr_consent_date TIMESTAMP,
    data_retention_until DATE
);

CREATE TABLE Purchases (
    id_purchase SERIAL PRIMARY KEY,
    id_client INT REFERENCES PSClients(id_client) 
        ON DELETE CASCADE, -- Elimina compras si eliminas cliente
    amount DECIMAL(10,2)
);

-- O si necesitas mantener registros históricos:
CREATE TABLE Purchases (
    id_purchase SERIAL PRIMARY KEY,
    id_client INT REFERENCES PSClients(id_client) 
        ON DELETE SET NULL, -- Anonimiza manteniendo el registro
    amount DECIMAL(10,2)
);
```

---

## Actividades a realizar (División de trabajo)

### 1. Diseño de bases de datos

Buscar para el caso de Redis, MongoDB y PostgreSQL diseñadores gráficos.

**Recomendaciones del profes:**  
- MongoDB: usar Mongoose o PyMongo  
- PostgreSQL: usar Supabase o PgAdmin  

**Distribución:**  
a. Redis (?)  
b. Prompt Content en MongoDB (Dylan)  
c. Prompt Ads en SQL Server (Lindsay)  
d. Prompt CRM en SQL Server (Luan)  
e. Prompt Sales en PostgreSQL (Chris y Miguel)

---

### 2. Generación de scripts y preguntas

#### a. Prompt Content (?)
- ¿Qué significa indexar las descripciones usando una base de datos vectorial como Pinecone, Faiss o pgvector?

#### b. Prompt Ads (?)
- ¿Qué son los TVPs y para qué sirven en los procedimientos almacenados (SP)?  
- ¿Cómo monitorear el rendimiento de las consultas?

#### c. Prompt CRM (?)
- ¿Qué significa generación algorítmica (no usar datos alambrados)?  
- ¿Cómo asegurar que los montos de ventas coincidan con Prompt Ads?  
- ¿Qué es configurar un link server para consultas cruzadas?  
- ¿Cómo se cifra información sensible usando un certificado X.509? ¿Qué es? 


- ¿Cómo demostrar que el backup y restore en otro servidor mantiene los datos cifrados?  
- ¿Qué son CTE, Partition y Rank en consultas agrupadas?

#### d. Prompt Sales (?)
- ¿Qué es un ETL y cómo crear uno que se ejecute cada 11 minutos actualizando solo valores delta?  
- ¿Qué herramienta de diseño visual de pipelines se puede usar (no pandas)?  
- ¿Qué son triggers, cursores, interbloqueos, extracción de metadata, monitoreo de consultas, coalesce, case, joins, y control de permisos mediante grant y revoke?

---

## Otros aspectos

1. Todo el despliegue se realizará con Kubernetes, pudiendo montarse local o por VPN distribuida. Que es esto y como lo hago?  
2. ¿Qué es un pod separado?  
3. No se desarrollará el portal web, solo bases de datos e integraciones MCP.  
4. ¿Qué es N8N?  

N8N es una herramienta de automatización visual (como Zapier pero open-source) que puedes usar para:

Crear flujos de trabajo
Conectar diferentes servicios
Crear MCP Servers sin programar desde cero


5. Mantener una bitácora de uso de IA que incluya, como mantengo dicha bitacora:
   - Fecha y hora  
   - Nombre del estudiante  
   - Prompt  
   - Resultado  
   - Método de validación  
   - Optimizaciones y medidas contra hardcoding




