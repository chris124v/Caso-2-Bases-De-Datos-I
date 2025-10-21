# Documentacion Caso #2
### Bases de Datos I  

**Integrantes:**  
- Dylan Chacón Berrocal, 2023171126  
- Christopher Daniel Vargas Villalta, 2024108443  
- Miguel Agüero Mata, 2020100846  
- Luan Chaves Bermúdez, 2019157253  
- Lindsay Marín Sánchez, 2024163904  

---

## Introducción

En este documento realizaremos la documentacion de PromptSales, Prompt Content, Prompt Ads y Prompt CRM. Incluiremos la entidades de cada diseno de la BD para cada subempresa y como funciona el modelo en general. Asimismo detallaremos como se cumple la vision tecnica de promt sales y los requerimientos no funcionales, y los aspectos documentales de los scripts de llenado y como funcionan.

---

## Tecnologias Utilizadas.
- Prompt Sales = PostgreSQL, Diseñador = Pg Admin 4
- Prompt Content = MongoDB, Diseñador = Mongo Compass y Pymongo
- Prompt Ads = SQL Server
- Prompt CRM = SQL Server
- Redis = Redis Insight


---

## Prompt Sales

### Diseño de la BD

En los diseños de las entidades de Prompt Sales seguiremos este formato.

Ejemplo: PS (Prompt Sales)
- Nombre Tabla = PSUsers
- Nombre PK = IdUser
- Nombre FK = IdUser

Listado de Entidades:

En el listado de entidades, primeramente establecemos todo esto por modulos, es decir, las tablas de usuarios, roles y permisos pertenecen al modulo de Profiles. Importante mencionar que las entidades son los nombres de las tablas, no ponemos PSUsers porque ya establecimos la terminologia que se usa en la BD, aqui lo dejamos normal "Users" para no repetir tanto. Ademas hay que recalcar que para los campos y nombres de tablas todo sera en ingles. Esta clarificacion de formato para la lista de entidades solo se hace aqui, el resto de apartados adaptan el formato. Se veria algo asi el listado de entidades: 

- Profiles: User and Access Control (Descripcion del modulo)
  * Users (Descripcion de la tabla)
  * Roles (Descripcion de la tabla)
  * Permissions (Descripcion de la tabla)

### Scripts

### Vision Tecnica de Prompt Sales

---

## Prompt Ads

### Diseño de la BD

En los diseños de las entidades de Prompt Ads seguiremos este formato.

Ejemplo: PA (Prompt Ads)
- Nombre Tabla = PAUsers
- Nombre PK = IdUser
- Nombre FK = IdUser

Listado de Entidades:

- Profiles: User and Access Control (Descripcion del modulo)
  * Users (Descripcion de la tabla)
  * Roles (Descripcion de la tabla)
  * Permissions (Descripcion de la tabla)


### Scripts

---

## Prompt Content

### Diseño de la BD

En los diseños de las colecciones de Prompt Content seguiremos este formato.

Ejemplo: PC (Prompt Content)
- Nombre Tabla = PCUsers
- Nombre PK = IdUser
- Nombre FK = IdUser

Listado de colecciones:

- PCUsers:
  * Almacena información de todos los usuarios que acceden al sistema PromptContent 
- PCExternal_Services:
  * Registra todos los servicios externos (APIs de terceros) con los que PromptContent se integra, como OpenAI, Canva, Adobe, etc.
- PCApi_Call_Logs_
  * Bitácora completa de TODAS las llamadas realizadas a servicios externos.
- PCAi_Models_Catalog:
  * Catálogo de los modelos de IA PROPIOS de PromptContent (no externos). Define qué modelos IA están disponibles, sus versiones y configuraciones.
- PCAi_Model_Logs:
  * Bitácora de TODAS las veces que se usa un modelo de IA propio. Similar a api_call_logs pero para modelos internos.
- PC_Content_Types:
  * Define los tipos de contenido que PromptContent puede crear (texto, imagen, video, audio, etc.) y sus especificaciones técnicas.
- PCimages:
  * Almacena todas las imágenes creadas con sus descripciones amplias, hashtags y vectores para búsqueda avanzada.
- PC_Content_Requests:
  * Registra solicitudes de clientes para generar contenido
- PC_Clients:
  * Almacena información de los clientes de PromptContent (las empresas/personas que contratan el servicio).
- PCSubscription_Plans:
  * Define los planes de suscripción disponibles (Básico, Premium, Enterprise) con sus características y precios.
- PCFeatures:
  * Catálogo maestro de todas las características/funcionalidades que PromptContent ofrece. Los planes hacen referencia a estas features.
- PCPayment_Methods:
  * Define los métodos de pago aceptados por PromptContent (tarjetas de crédito, PayPal, transferencias).
- PCPayment_Schedules:
  * Programa/calendario de pagos futuros para cada suscripción. Define CUÁNDO se debe cobrar a cada cliente.
- PCPayment_Transactions:
  * Registro histórico de TODAS las transacciones de pago ejecutadas.
- PCCampaigns:
  * Almacena las campañas de contenido creadas. Agrupa múltiples imágenes/textos bajo una misma campaña con versiones y aprobaciones.

### Scripts

- 001-creacion-colecciones.py:
  * Este script se encarga, utilizando pymongo, de crear las 15 colecciones de la BD de promptcontent

## Prompt CRM

### Diseño de la BD

En los diseños de las entidades de Prompt CRM (Client Response Management) seguiremos este formato.

Ejemplo: PCR (Prompt CRM)
- Nombre Tabla = PCRUsers
- Nombre PK = IdUser
- Nombre FK = IdUser

Listado de Entidades:

- Profiles: User and Access Control (Descripcion del modulo)
  * Users (Descripcion de la tabla)
  * Roles (Descripcion de la tabla)
  * Permissions (Descripcion de la tabla)

### Scripts

---

## BD Redis

### Diseño de la BD

En los diseños de las entidades de Redis seguiremos este formato.

Ejemplo: R (Redis)
- Nombre Tabla = RUsers
- Nombre PK = IdUser
- Nombre FK = IdUser

Listado de Entidades:

- Profiles: User and Access Control (Descripcion del modulo)
  * Users (Descripcion de la tabla)
  * Roles (Descripcion de la tabla)
  * Permissions (Descripcion de la tabla)

### Scripts

---

## Requerimientos No Funcionales






