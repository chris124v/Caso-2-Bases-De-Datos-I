-- Pruebas del Job Local 

-- Limpiar tablas para prueba limpia
DELETE FROM "PSContentUsage";
DELETE FROM "PSPublishedAds";
DELETE FROM "PSLeadsSumarry";

-- Resetear fechas de control para que cargue todo
UPDATE public."PSETLDelta"
SET "lastInput" = '2024-01-01 00:00:00'::timestamp;

-- Verificar que quedo limpio
SELECT 'PSContentUsage' AS tabla, COUNT(*) AS filas FROM "PSContentUsage"
UNION ALL
SELECT 'PSPublishedAds', COUNT(*) FROM "PSPublishedAds"
UNION ALL
SELECT 'PSLeadsSummary', COUNT(*) FROM "PSLeadsSumarry";

-- Ver que se cargaron los datos
SELECT 
    'PSContentUsage' AS Tabla, 
    COUNT(*) AS Filas,
    MAX("createdAt") AS UltimaCarga
FROM "PSContentUsage"
UNION ALL
SELECT 'PSPublishedAds', COUNT(*), MAX("createdAt")
FROM "PSPublishedAds"
UNION ALL
SELECT 'PSLeadsSummary', COUNT(*), MAX("createdAt")
FROM "PSLeadsSumarry";


SELECT COUNT(*) FROM public."PSCampaigns";
SELECT COUNT(*) FROM public."PSPublishedAds";
SELECT COUNT(*) FROM public."PSLeadsSumarry";
SELECT COUNT(*) FROM public."PSContentUsage";

SELECT * FROM "PSContentUsage";
SELECT * FROM "PSPublishedAds";

ALTER TABLE "PSContentUsage" ALTER COLUMN "IdContentUsage" RESTART WITH 1;

