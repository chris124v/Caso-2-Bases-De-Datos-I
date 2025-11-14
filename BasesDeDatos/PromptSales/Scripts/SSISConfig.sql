USE master;
GO

-- Verificar si ya existe SSISDB
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'SSISDB')
BEGIN
    PRINT 'SSISDB ya existe';
END
ELSE
BEGIN
    PRINT 'Creando SSISDB...';
    
    -- Habilitar CLR (ya debería estar habilitado)
    EXEC sp_configure 'clr enabled', 1;
    RECONFIGURE;
    
    -- Crear el catálogo SSISDB
    EXEC catalog.catalog_create @password = N'TuPasswordSegura123!';
    
    PRINT '? SSISDB creado exitosamente';
END
GO

-- Verificar
SELECT name, create_date 
FROM sys.databases 
WHERE name = 'SSISDB';
GO

SELECT 
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS Version,
    SERVERPROPERTY('ProductLevel') AS ServicePack;
GO

SELECT 
    servicename,
    status_desc,
    startup_type_desc
FROM sys.dm_server_services
WHERE servicename LIKE '%Integration%';
GO

USE master;
GO

-- Habilitar CLR
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

EXEC sp_configure 'clr enabled', 1;
RECONFIGURE;
GO

-- Crear SSISDB (ahora debería funcionar)
EXEC catalog.catalog_create @password = N'TuPasswordSegura123!';
GO

-- Verificar
SELECT name FROM sys.databases WHERE name = 'SSISDB';
GO

SELECT @@VERSION;

USE master;
GO

-- Ver configuración actual de CLR
EXEC sp_configure 'clr enabled';
GO

-- Si run_value es 0, necesitas habilitarlo
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE WITH OVERRIDE;
GO

EXEC sp_configure 'clr enabled', 1;
RECONFIGURE WITH OVERRIDE;
GO

-- Verificar nuevamente
EXEC sp_configure 'clr enabled';
GO

SELECT 
    name,
    clr_name,
    permission_set_desc
FROM sys.assemblies
WHERE name LIKE '%SSIS%' OR name LIKE '%catalog%';
GO

-- Registrar el ensamblado SSISDB manualmente
USE master;
GO

-- Ruta típica del DLL de SSIS
DECLARE @assemblyPath NVARCHAR(500) = 
    'C:\Program Files\Microsoft SQL Server\160\DTS\Binn\Microsoft.SqlServer.IntegrationServices.Server.dll';

-- Verificar que existe
EXEC xp_fileexist @assemblyPath;
GO

EXEC sp_configure 'clr strict security', 0;
RECONFIGURE;
GO

-- Crear el ensamblado
CREATE ASSEMBLY [Microsoft.SqlServer.IntegrationServices.Server]
FROM 'C:\Program Files\Microsoft SQL Server\160\DTS\Binn\Microsoft.SqlServer.IntegrationServices.Server.dll'
WITH PERMISSION_SET = UNSAFE;
GO





USE master;
GO

-- Obtener el hash del ensamblado
DECLARE @assemblyPath NVARCHAR(500) = 
    'C:\Program Files\Microsoft SQL Server\160\DTS\Binn\Microsoft.SqlServer.IntegrationServices.Server.dll';

DECLARE @hash VARBINARY(64);
DECLARE @clrName NVARCHAR(4000) = 'Microsoft.SqlServer.IntegrationServices.Server';

-- Leer el archivo y calcular su hash
SELECT @hash = HASHBYTES('SHA2_512', BulkColumn)
FROM OPENROWSET(BULK 'C:\Program Files\Microsoft SQL Server\160\DTS\Binn\Microsoft.SqlServer.IntegrationServices.Server.dll', SINGLE_BLOB) AS assembly_data(BulkColumn);

-- Agregar el ensamblado como trusted
EXEC sp_add_trusted_assembly 
    @hash = @hash,
    @description = N'Microsoft.SqlServer.IntegrationServices.Server';

PRINT 'Ensamblado agregado como trusted';
GO

USE master;
GO

-- Ahora crear el ensamblado (debería funcionar)
CREATE ASSEMBLY [Microsoft.SqlServer.IntegrationServices.Server]
FROM 'C:\Program Files\Microsoft SQL Server\160\DTS\Binn\Microsoft.SqlServer.IntegrationServices.Server.dll'
WITH PERMISSION_SET = UNSAFE;
GO

USE master;
GO

EXEC catalog.catalog_create @password = N'TuPasswordSegura123!';
GO

-- Verificar
SELECT name FROM sys.databases WHERE name = 'SSISDB';
GO

USE master;
GO

EXEC catalog.catalog_create @password = N'TuPasswordSegura123!';
GO

SELECT 
    name,
    clr_name,
    permission_set_desc,
    is_visible
FROM sys.assemblies
WHERE name LIKE '%Integration%';
GO

USE master;
GO

-- Verificar si el schema catalog existe
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'catalog')
BEGIN
    CREATE SCHEMA catalog;
    PRINT 'Schema catalog creado';
END
GO

-- Ahora intentar crear el catálogo
EXEC catalog.catalog_create @password = N'TuPasswordSegura123!';
GO