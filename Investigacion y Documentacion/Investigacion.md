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
- Datos de campañas: mensajes, medios, tiempos, presupuestos, métricas de rendimiento. (?)  
- Datos de contenido: materiales creados, formatos, versiones aprobadas, derechos de uso. (?)  
- Datos de interacción: leads, historial de comunicación, respuestas automáticas, comportamiento del usuario. (?)  
- Datos de integración: conexiones API, autenticaciones, sincronización de datos entre sistemas externos. (?)  
- Módulos de IA: generación de contenido, predicción de intención de compra, optimización de anuncios, análisis de sentimiento y ranking de rendimiento. (?)

---

## Preguntas sobre la visión técnica de Prompt Sales

1. Interconexión entre subempresas: ¿Qué son los MCP (Model Context Protocol)?  
2. Despliegue, orquestación y mantenimiento: ¿Qué es Kubernetes?  
3. Integración de servicios externos o internos: ¿Usamos API o servidores MCP?  
4. Aplicaciones web y paneles administrativos: ¿Qué es Vercel? ¿Qué sistema de despliegue continuo (CI/CD) se usa?  
5. Bases de datos en la nube: ¿Qué es Redis? ¿Qué es una base de datos centralizada?

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
d. Auditoría y logging centralizado con retención de 90 días. Como configuro esto?
e. Cumplimiento con estándares internacionales de protección de datos (GDPR, CCPA) y principio de mínimo privilegio. Como cumplo con estos estandares y que son?

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
5. Mantener una bitácora de uso de IA que incluya, como mantengo dicha bitacora:
   - Fecha y hora  
   - Nombre del estudiante  
   - Prompt  
   - Resultado  
   - Método de validación  
   - Optimizaciones y medidas contra hardcoding

---

## Anotaciones de clase

### Dylan:
Un proceso de ventas efectivo tendría al menos un 7% de conversión.  
PromptContent maneja el proceso creativo de campañas, integraciones con plataformas (tablas: nombres, URLs, métodos, autenticación, configuración REST o MCP).  
PromptAds gestiona campañas y su optimización.  
PromptCRM da seguimiento a leads y cierre de ventas.  
Todo se conecta mediante servidores MCP.  
Indexación de descripciones con IA, monitoreo de rendimiento de consultas, y uso de plantillas predefinidas para procedimientos transaccionales.

### Luan:
- Al final del semestre habrá una entrevista laboral (vale 8%).  
- “Leads” son los datos para definir la demografía objetivo.  
- PromptContent requiere: nombres, URLs, métodos, auths, parámetros y configuración REST.  
- Para PromptAds se investigarán campaign managers (LinkedIn, Facebook, Instagram).  
- Creación de una base de datos en Redis.

### Lindsay:
**PromptContent**
- Genera descripciones de anuncios y propuestas revisadas.  
- Tablas: pedidos de usuario, URLs adjuntas, resultados IA.  

**AdContent**
- Maneja campañas publicitarias, estadísticas, población clave, tablas de resultados y de ventas.  

**CRM**
- Gestiona interesados, tiempo de visualización, comentarios, conversiones e intereses comunes.

### Miguel:
- Crear BD en Redis para consultas recurrentes y disminuir uso de APIs.  
- Minimizar uso de tokens de IA.  
- Investigar Vercel para despliegue web.  
- Crear base PromptAds con todas sus tablas.  
- Almacenar imágenes, videos y audios del contenido creado en PromptContent.

### Christopher:
- El diseno de Mongo no hay diagrama fisico, solo Json, podemos usar moongosee o pymongo.
- Buscae lugares para disenar en Postgre Sql como Supa base o pg admin,
- n8n es para crear servidores MCP.
- Usar linked in campaign manager y trade desk como ejemplos a seguir.
- El resto de anotaciones esta en el canal de where-wolves-5.

---


