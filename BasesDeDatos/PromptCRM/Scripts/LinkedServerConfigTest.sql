
-- LINKED SERVER: PromptCRM a PromptAds
-- Lo realizamos mediante codigo porque en la interfaz visual no deja configurarlo correctamente

USE master;
GO

-- Paso 1: Eliminar si existe
IF EXISTS (SELECT * FROM sys.servers WHERE name = 'PROMPTADS_LINK')
BEGIN
    PRINT 'Eliminando linked server existente';
    EXEC sp_dropserver @server = 'PROMPTADS_LINK', @droplogins = 'droplogins';
    PRINT ' Eliminado';
END
ELSE
BEGIN
    PRINT 'No existe linked server previo';
END
GO

-- Paso 2: Crear linked server (con IP literal de mi compu)
PRINT 'Creando linked server...';

EXEC sp_addlinkedserver 
    @server = 'PROMPTADS_LINK',
    @srvproduct = '',
    @provider = 'MSOLEDBSQL',
    @datasrc = '192.168.1.112,31433';  -- Mi IP y el puerto de ads

-- Verificar que se creo
IF EXISTS (SELECT * FROM sys.servers WHERE name = 'PROMPTADS_LINK')
    PRINT '  Linked server creado correctamente'
ELSE
BEGIN
    PRINT ' ERROR: No se pudo crear el linked server';
    RAISERROR('Creacion de linked server falló', 16, 1);
END
GO

-- Paso 3: Configurar credenciales
PRINT 'Configurando credenciales...';

EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = 'PROMPTADS_LINK',
    @useself = 'FALSE',
    @locallogin = NULL,
    @rmtuser = 'sa',
    @rmtpassword = 'YourStrong!Passw0rd';

PRINT 'Credenciales configuradas';
GO

-- Paso 4: Configurar opciones
PRINT 'Configurando opciones...';

EXEC sp_serveroption 'PROMPTADS_LINK', 'rpc out', 'true';
EXEC sp_serveroption 'PROMPTADS_LINK', 'rpc', 'true';
EXEC sp_serveroption 'PROMPTADS_LINK', 'data access', 'true';
EXEC sp_serveroption 'PROMPTADS_LINK', 'collation compatible', 'true';
EXEC sp_serveroption 'PROMPTADS_LINK', 'connect timeout', '15';
EXEC sp_serveroption 'PROMPTADS_LINK', 'query timeout', '0';

PRINT 'Opciones configuradas';
GO

-- Paso 5: Probar conexion
PRINT '';
PRINT 'Probando conexion';
PRINT '';

BEGIN TRY
    -- Test de conectividad básica
    EXEC sp_testlinkedserver 'PROMPTADS_LINK';
    PRINT ' Test de conexión OK';
    
    -- Contar campañas
    DECLARE @Count INT;
    SELECT @Count = COUNT(*) 
    FROM PROMPTADS_LINK.promptads.dbo.PACampaigns;
    
    PRINT ' Campañas encontradas: ' + CAST(@Count AS VARCHAR(10));
    PRINT '';
    
    -- Mostrar datos
    PRINT 'Top 5 Campañas:';
    PRINT '?????????????????????????????????????????????????????';
    
    SELECT TOP 5 
        IdCampaign,
        name AS CampaignName,
        CONVERT(VARCHAR(10), createdAt, 120) AS Created
    FROM PROMPTADS_LINK.promptads.dbo.PACampaigns
    ORDER BY createdAt DESC;
    
    PRINT '';
    PRINT 'LINKED SERVER FUNCIONANDO CORRECTAMENTE!';
    
END TRY
BEGIN CATCH
    PRINT '';
    PRINT 'ERROR al probar conexión:';
    PRINT '   ' + ERROR_MESSAGE();
    PRINT '';
    PRINT 'Verificar:';
    PRINT '   1. PromptAds está corriendo:';
    PRINT '      kubectl get pods -n promptads';
    PRINT '';
    PRINT '   2. Puedes conectarte directamente desde Windows:';
    PRINT '      sqlcmd -S localhost,31433 -U sa -P YourStrong!Passw0rd -C -Q "SELECT @@SERVERNAME"';
    PRINT '';
END CATCH
GO

-- Mostrar configuración final
PRINT '';
PRINT 'Configuración del linked server:';
SELECT 
    name AS [Linked Server],
    data_source AS [Data Source],
    provider AS [Provider],
    is_data_access_enabled AS [Data Access],
    is_rpc_out_enabled AS [RPC Out]
FROM sys.servers 
WHERE name = 'PROMPTADS_LINK';
GO


-- Probar Linked Server Creado

USE master;
GO

PRINT 'Probando conexion a PROMPTADS_LINK...';
PRINT '';

BEGIN TRY
    -- Test 1: Contar campañas
    DECLARE @Count INT;
    SELECT @Count = COUNT(*) 
    FROM PROMPTADS_LINK.promptads.dbo.PACampaigns;
    
    PRINT ' Conexión exitosa!';
    PRINT ' Campañas encontradas: ' + CAST(@Count AS VARCHAR(10));
    PRINT '';
    
    -- Test 2: Mostrar datos
    PRINT ' Top 5 Campañas de PromptAds:';
    PRINT '?????????????????????????????????????????????????????????????';
    
    SELECT TOP 5 
        IdCampaign,
        name AS CampaignName,
        description,
        CONVERT(VARCHAR(19), createdAt, 120) AS CreatedAt
    FROM PROMPTADS_LINK.promptads.dbo.PACampaigns
    ORDER BY createdAt DESC;
    
    PRINT '';
    PRINT '?????????????????????????????????????????????????????????????';
    PRINT ' LINKED SERVER FUNCIONANDO CORRECTAMENTE!';
    PRINT '?????????????????????????????????????????????????????????????';
    
END TRY
BEGIN CATCH
    PRINT '';
    PRINT ' ERROR al conectar:';
    PRINT '   ' + ERROR_MESSAGE();
    PRINT '';
    PRINT ' El linked server existe pero no puede conectarse.';
    PRINT '   Verifica que PromptAds esté corriendo:';
    PRINT '   kubectl get pods -n promptads';
    PRINT '';
END CATCH
GO

select * from [PROMPTADS_LINK].[promptads].[dbo].[PACampaigns]