# Bitacora

Este documento lleva un historial de las reuniones y avances del proyecto, esto aparte de los commits de github,

---

## Avances Grupales

### Primera Reunion 

Avance Grupal: Fecha 15/10/2025

Descripcion: Durante esta fecha se realizo la creacion del repo de github. Ademas de esto se realizaron los documentos de investigacion y documentacion.
Investigacion: Documento para realizar la investigacion de cuestiones pertinentes al caso 2. Incluyo muchas preguntas sobre cada seccion del caso y la division de trabajo para empezar el diseño. Asi se distribuyo:
- Prompt Sales (Miguel y Christopher)
- Prompt Content (Dylan)
- Prompt Ads (Lindsay)
- Prompt CRM (Luan)
Documentacion: Se establecio un formato a seguir para el nombre de las tablas en cada BD y como se documentan las entidades de cada BD.

Notas: Esta reunion se llevo a cabo mediante discord a las 9:00 pm el 15/10/2025, se envio este mensaje un dia despues dado a que se nos olvido realizar la bitacora. El siguiente paso seria realizar los diseños de las BD.

---

### Segunda Reunion 

Avance Grupal: Fecha 19/10/2025
Descripcion: Durante esta fecha se realizo la instalacion local de Kubernetes en todas las compus del equipo.  El entorno de Kubernetes se fue trabajando desde la reunion del 15 de octubre y hoy ya quedo listo y en todas las compus. Ademas de ello discutimos las herramientas de diseno en Mongo y Postgre, para mongo seria pymongo y mongo compass y postegre seria pg admin. Lindsay y Luan tenian tanto Ads como CRM casi listo entonces revisamos los disenos. Los siguientes pasos seria entonces hacer prompt sales y content. Posteriormente realizaremos la revision con el profe.

Documentacion: Se acordo documentar todos los disenos una vez listos o en el proceso.

Investigacion: Se explico Kubernetes en investigacion y se crearon archivos.md para explicar cada parte del entorno de Kubernetes.

Bitacora: Creacion de archivo de bitacora propiamente en el github. 

Notas: No hay observaciones el dia de hoy.

---


---

## Avances Individuales

---

#### Dylan

Avance individual jueves 16
Se instaló todo el entorno necesario para MongoDB y se creó la base de datos con la que se va a trabajar.
Se investigó sobre las características que debe tener la BD de PromptContent

---

Avance individual:

Se agregó un script que crea 15 colecciones nuevas para la DB de promptcontent, documentación de colecciones pendiente en git y en el archivo, se realizará en las siguientes horas 

---

---

#### Chris

Avance 18 de Octubre
Creacion de todo el entorno de Kubernetes, esto no se documento en el canal de disc pero se puede comprobar mediante los commits de github.

Avance Miguel y Chris: Fecha 20/10/2025
Descripcion: Iniciamos el diseno de promt sales y terminamos con las tablas generales. Ahora tocaria estudiar mcp servers y el resto del caso para realizar el diseno completo.

Documentacion: Formato PK Y FK.

Investigacion: Nada se investigo hoy.

Bitacora: Se agrego esto a la bitacora.

Notas. No hay notas

---


---

#### Lindsay

Avance 19 de octubre de 2025
Se crearon 42 tablas preliminares para la base de datos relacional PromptAds. A continuación se describen las funcionalidades que abarca el diseño actual.
Tablas para usuarios, roles y permisos
Tablas para crear organizaciones
Tablas para crear campañas publicitarias
Tabla de calendario para organizar las campañas
Tablas para crear públicos meta. Estas tablas permiten añadir características para describir la población objetivo según edad, género, nacionalidad, gustos, entre otros.
Tablas para enumerar reacciones. Se pueden enumerar likes, dislikes, compartidos, según el canal de distribución.
Se agrega una tabla para listar influencers disponibles para promocionar la marca. Incluye listas de seguidores, username, plataforma, seguidores, entre otros.
Tablas para manejar gastos de las campañas.
Tablas para manejar inversiones en las campañas.
Tablas para manejar suscripciones y sus características. Los límites varían según grado de suscripción
Quedan algunos aspectos pendientes antes de la primera revisión, entre ellos están:
Verificación de publicación correcta
Seguridad con KYT y KYC
Requests y responses que sirven como bitácora para las APIs.
Tablas de analiticas

---

#### Miguel

Avance Miguel y Chris: Fecha 20/10/2025
Descripcion: Iniciamos el diseno de promt sales y terminamos con las tablas generales. Ahora tocaria estudiar mcp servers y el resto del caso para realizar el diseno completo.

Documentacion: Formato PK Y FK.

Investigacion: Nada se investigo hoy.

Bitacora: Se agrego esto a la bitacora.

Notas. No hay notas

---



---

#### Luan

---

Avance 19 de octubre

Diseno preliminar de la base de prompts crm con todas sus caracteristicas generales. Esto no se documento en el chat de disc pero se puede comprobar en los commits.