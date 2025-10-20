#### Carpeta de Namespaces

Contiene todos los archivos YAML que crean los namespaces


#### ¿Qué es un namespace?

Es como una "carpeta virtual" dentro de Kubernetes, sirve para separar y organizar recursos evita que las cosas se mezclen.

Analogía:

- Disco duro = Kubernetes
- Carpetas (C:\Documentos, C:\Descargas, etc.) = Namespaces

En el proyecto seria algo asi: 

- Namespace promptsales = Todo lo relacionado con PromptSales (PostgreSQL)
- Namespace promptads = Todo lo relacionado con PromptAds (SQL Server Ads)
- Namespace promptcontent = Todo lo relacionado con PromptContent (MongoDB)
- Namespace promptcrm = Todo lo relacionado con PromptCRM (SQL Server CRM)
- Namespace redis = Todo lo relacionado con Redis

Así cada base de datos vive en su propio "espacio" sin mezclarse con el resto digamos. 

