# Caso #2 Bases De Datos I

## Profesor

- Rodrigo Nuñez Nuñez

## Integrantes

- Dylan Chacón Berrocal, 2023171126
- Christopher Daniel Vargas Villalta, 2024108443
- Miguel Aguero Mata, 2020100846
- Luan Chaves Bermudez, 2019157253
- Lindsay Marín Sánchez, 2024163904

---

## Descripcion del Proyecto

SolidNY es una empresa radicada en Nueva York con 15 años de experiencia en mercadeo digital. Con el propósito de expandir su alcance y aprovechar el potencial de la inteligencia artificial, la compañía lanza una nueva marca llamada PromptSales, cuyo enfoque es cerrar ventas de forma eficiente y medible. Su criterio principal de éxito radica en la cantidad y el monto de las ventas logradas, utilizando una combinación de automatización, análisis de datos e inteligencia artificial aplicada a todas las etapas del embudo de ventas.

PromptSales está conformada por un ecosistema de subempresas interconectadas, cada una especializada en una etapa diferente del proceso de mercadeo y ventas. Aunque pueden operar de forma independiente, todas se integran en un flujo automatizado que cubre desde la creación de contenido hasta el cierre de ventas.

Las subempresas son:

### PromptContent

- Se encarga de generar contenido creativo para campañas de mercadeo. Sus productos y servicios incluyen:

- Creación de contenido textual, audiovisual e imágenes para redes sociales, anuncios y sitios web.
- Generación de material adaptable a resultados de motores de búsqueda y respuestas de inteligencia artificial.
- Uso de herramientas propias de IA para creación automatizada de contenido optimizado para distintos públicos meta.
- Integración con plataformas externas como Canva, Adobe, Meta Business Suite y OpenAI API, etc

### PromptAds

- Responsable de la ejecución y optimización de campañas publicitarias.

- Diseño, segmentación y publicación de anuncios en redes sociales, email marketing, SMS, LinkedIn e influencers.
- Análisis en tiempo real del rendimiento de campañas.
- Generación automática de campañas a partir de datos de públicos meta y objetivos de venta.
- Integración con plataformas externas como Google Ads, Meta Ads, TikTok for Business, Mailchimp y plataformas de CRM.

### PromptCrm

- Gestiona el seguimiento de los clientes potenciales hasta el cierre de la venta.

- Registro y clasificación automática de leads provenientes de distintas fuentes.
- Implementación de chatbots, voicebots y flujos automatizados de atención.
- Seguimiento de compradores y predicción de intención de compra mediante IA.
- Integración con plataformas como HubSpot, Salesforce, Zendesk, WhatsApp Business API, entre otras

---

## Tecnologias Utilizadas

Para la elaboracion de el proyecto se emplearon distintas tecnologias tales como bases de datos relacionales(SQL Server, PostgreSQL) y no relacionales(MongoDB).

Implementación de MCP Servers para conectar con las bases de datos y realizar consultas directamente por medio de lenguaje natural.

Se indexo mediante Pinecone descripciones de archivos tipo media que estaban almacenados en PromptContent para asi poder realizar busquedas rapidas usando IA a través de los MCP.

Tambienn se utilizaron los Microsoft Integration Services para crear/realizar un ETL(Extract, Transform, Load) en PromptSales para reunir información almacenada en las demas bases(CRM, ADS, etc) para poder analizar y generar reportes con dicha información.

## Diseño de las Bases de Datos

### PromptSales

[PromptSales](https://github.com/chris124v/Caso-2-Bases-De-Datos-I/tree/main/BasesDeDatos/PromptSales/Disenos "Diseño de la base de datos")

[PromptContent](https://github.com/chris124v/Caso-2-Bases-De-Datos-I/tree/main/BasesDeDatos/PromptContent/Disenos "Diseño de la base de datos")

[PromptCrm](https://github.com/chris124v/Caso-2-Bases-De-Datos-I/tree/main/BasesDeDatos/PromptCRM/Disenos "Diseño de la base de datos")

[PromptAds](https://github.com/chris124v/Caso-2-Bases-De-Datos-I/tree/main/BasesDeDatos/PromptAds/Disenos "Diseño de la base de datos")

## Arquitectura
