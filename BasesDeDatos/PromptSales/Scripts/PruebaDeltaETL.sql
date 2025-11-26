-- Inicializar Tabla de Control ETL Delta
-- Intentamos: Registrar la ultima ejecución exitosa de cada fuente

-- Inicializar Tabla de Control ETL Delta

-- 1. Ver si ya existen registros
SELECT * FROM public."PSETLDelta";

-- 2. Eliminar registros existentes (si los hay)
DELETE FROM public."PSETLDelta" 
WHERE view IN ('PCImages', 'vw_PublishedAds_Delta', 'vw_LeadsSummary_Delta');

-- 4. Insertar registros iniciales
INSERT INTO public."PSETLDelta" ( "database",view, "lastInput", "createdAt")
VALUES 
    -- MongoDB - PromptContent
    ('Prompt Content', 'PCImages', '2024-01-01 00:00:00'::timestamp, NOW()),
    
    -- SQL Server - PromptAds
    ('Prompt Ads', 'vw_PublishedAds_Delta', '2024-01-01 00:00:00'::timestamp, NOW()),
    
    -- SQL Server - PromptCRM
    ('Prompt CRM', 'vw_LeadsSummary_Delta', '2024-01-01 00:00:00'::timestamp, NOW());


-- Hacer null lo que siempre da problemas
ALTER TABLE "PSETLDelta" 
ALTER COLUMN "IdRunLog" DROP NOT NULL;

-- 5. Verificar que se insertaron correctamente
SELECT 
    "IdETLDelta",
    view,
    "lastInput",
    AGE(NOW(), "lastInput") AS tiempo_desde_ultima_carga,
    "createdAt",
    "IdRunLog"
FROM public."PSETLDelta"
ORDER BY view;

-- 6. Mostrar resumen
SELECT 
    COUNT(*) AS total_fuentes_configuradas,
    MIN("lastInput") AS fecha_inicial,
    MAX("lastInput") AS ultima_actualizacion
FROM public."PSETLDelta";



