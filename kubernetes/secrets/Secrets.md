#### Carpeta de Secretos 

Contiene los archivos YAML con contraseñas y datos sensibles.

#### ¿Qué es un Secret?

Es un objeto de Kubernetes que guarda información confidencial
- Contraseñas de bases de datos
- Usuarios
- Tokens de API
- Certificados

#### ¿Por qué separar los secrets?

- Seguridad: puedes excluirlos de Git con .gitignore
- Organización: todos los datos sensibles en un solo lugar
- Facil de cambiar contraseñas sin tocar otros archivos

Por ejemplo algo como:

username: postgres
password: postgres123

Estos secrets se "inyectan" en los contenedores cuando se crean, para que las bases de datos tengan sus credenciales.

