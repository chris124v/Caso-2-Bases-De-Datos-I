-- Archivo de Creacion del Job cada 11 min 

USE msdb; -- Base donde se gestionan los jobs 
GO

-- 1. Crear el Job
EXEC dbo.sp_add_job -- Archivo de nuevo job 
    @job_name = N'PromptSales_ETL_Every11Minutes',
    @enabled = 1,
    @description = N'ETL que consolida datos de PromptContent, PromptAds y PromptCRM hacia PromptSales cada 11 minutos',
    @category_name = N'Data Collector';
GO

-- 2. Agregar el paso que ejecuta el paquete SSIS
EXEC dbo.sp_add_jobstep
    @job_name = N'PromptSales_ETL_Every11Minutes',
    @step_name = N'Execute_SSIS_Package',
    @subsystem = N'SSIS',
    @command = N'/ISSERVER "\SSISDB\PromptSalesETL\PromptSalesETL\Package.dtsx" /SERVER "localhost" /Par "$ServerOption::LOGGING_LEVEL(Int16)";1 /Par "$ServerOption::SYNCHRONIZED(Boolean)";True /CALLERINFO SQLAGENT /REPORTING E',
    @database_name = N'master',
    @retry_attempts = 2,
    @retry_interval = 1,
    @on_success_action = 1,
    @on_fail_action = 2; -- Si falla detiene el job y lo marca como fallido 
GO

-- 3. Crear schedule cada 11 minutos
EXEC dbo.sp_add_schedule
    @schedule_name = N'Every11Minutes',
    @enabled = 1,
    @freq_type = 4,              -- Diario
    @freq_interval = 1,          -- Cada dia
    @freq_subday_type = 4,       -- Minutos
    @freq_subday_interval = 11,  -- Cada 11 minutos
    @active_start_date = 20251114,  -- Hoy
    @active_start_time = 000000;    -- Desde medianoche
GO

-- 4. Asociar el schedule al job
EXEC dbo.sp_attach_schedule
    @job_name = N'PromptSales_ETL_Every11Minutes',
    @schedule_name = N'Every11Minutes';
GO

-- 5. Asignar el job al servidor local
EXEC dbo.sp_add_jobserver
    @job_name = N'PromptSales_ETL_Every11Minutes',
    @server_name = N'(LOCAL)';
GO

PRINT 'Job creado exitosamente';
PRINT 'El ETL se ejecutará cada 11 minutos automáticamente';
GO

-- Verificacion del Job 

SELECT 
    j.name AS NombreJob,
    j.enabled AS Habilitado,
    j.date_created AS FechaCreacion,
    s.name AS NombreSchedule,
    s.freq_subday_interval AS CadaCuantosMinutos,
    CASE j.enabled 
        WHEN 1 THEN 'Activo' 
        ELSE 'Inactivo' 
    END AS Estado
FROM msdb.dbo.sysjobs j
INNER JOIN msdb.dbo.sysjobschedules js ON j.job_id = js.job_id
INNER JOIN msdb.dbo.sysschedules s ON js.schedule_id = s.schedule_id
WHERE j.name = 'PromptSales_ETL_Every11Minutes';
GO

-- Prueba Manual de la Ejecucion del Job

-- Ejecutar el job una vez manualmente (sin esperar 11 minutos)
EXEC msdb.dbo.sp_start_job @job_name = N'PromptSales_ETL_Every11Minutes';
GO

-- Esperar 15 segundos
WAITFOR DELAY '00:00:15';

-- Ver el resultado
SELECT TOP 1
    j.name AS Job,
    h.run_date AS Fecha,
    h.run_time AS Hora,
    CASE h.run_status
        WHEN 0 THEN 'Falló'
        WHEN 1 THEN 'Exitoso'
        WHEN 2 THEN 'Reintentar'
        WHEN 3 THEN 'Cancelado'
        WHEN 4 THEN 'En progreso'
    END AS Estado,
    h.run_duration AS Duracion,
    h.message AS Mensaje
FROM msdb.dbo.sysjobs j
INNER JOIN msdb.dbo.sysjobhistory h ON j.job_id = h.job_id
WHERE j.name = 'PromptSales_ETL_Every11Minutes'
    AND h.step_id = 0  -- 0 = resultado del job completo
ORDER BY h.run_date DESC, h.run_time DESC;
GO

-- Historial de las 20 Ejecuciones mas recientes

-- Ver todas las ejecuciones del job
SELECT TOP 20
    h.run_date AS Fecha,
    h.run_time AS Hora,
    CASE h.run_status
        WHEN 1 THEN 'Exitoso'
        WHEN 0 THEN 'Falló'
    END AS Estado,
    h.run_duration AS Duracion_Segundos
FROM msdb.dbo.sysjobs j
INNER JOIN msdb.dbo.sysjobhistory h ON j.job_id = h.job_id
WHERE j.name = 'PromptSales_ETL_Every11Minutes'
    AND h.step_id = 0
ORDER BY h.run_date DESC, h.run_time DESC;
GO

