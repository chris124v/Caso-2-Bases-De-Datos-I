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
- Prompt Sales = PostgreSQL, Diseñador =
- Prompt Content = MongoDB, Diseñador =
- Prompt Ads = SQL Server
- Prompt CRM = SQL Server

Faltan varios aqui 

---

## Prompt Sales

### Diseño de la BD

En los diseños de las entidades seguiremos este formato.

Ejemplo: PS (Prompt Sales)
- Nombre Tabla = PSUsers
- Nombre PK = PSIdUser
- Nombre FK = PSIDUserFK

Listado de Entidades:

En el listado de entidades, primeramente establecemos todo esto por modulos, es decir, las tablas de usuarios, roles y permisos pertenecen al modulo de Profiles. Importante mencionar que las entidades son los nombres de las tablas, no ponemos PSUsers porque ya establecimos la terminologia que se usa en la BD, aqui lo dejamos normal "Users" para no repetir tanto. Ademas hay que recalcar que para los campos y nombres de tablas todo sera en ingles. Se veria algo asi el listado de entidades: 

- Profiles: User and Access Control
  * Users
  * Roles
  * Permissions

### Scripts

### Vision Tecnica de Prompt Sales

---

## Prompt Ads

### Diseño de la BD

### Scripts

---

## Prompt Content

### Diseño de la BD

### Scripts

---

## Prompt CRM

### Diseño de la BD

### Scripts

---

## BD Redis

### Diseño de la BD

### Scripts

---

## Requerimientos No Funcionales






