-- ETL 

-- Primero verifica que exista el connection
SELECT * FROM public."PSServiceConnectionConfig" WHERE "IdConnection" = 1;

-- Si no existe, créalo primero
-- (asumiendo que ya tienes PSServices con IdService=1,2,3)

-- Luego inserta en PSETLConfig
INSERT INTO public."PSETLConfig" (
    "IdConnection",
    "schedule",
    "connectionString",
    "priority",
    "enabled",
    "createdAt",
    "updatedAt"
) VALUES (
    1,  -- IdConnection (debe existir en PSServiceConnectionConfig)
    'Every 11 minutes',
    'Server=localhost,31433;Database=promptads;',
    1,
    TRUE,
    NOW(),
    NOW()
)
ON CONFLICT ("IdConfig") DO NOTHING;

SELECT * FROM "PSETLConfig";

SELECT * FROM "PSRawData";

ALTER TABLE "PSRawData" ALTER COLUMN "IdRawData" RESTART WITH 1;

DELETE FROM "PSRawData";

-- Data Flow de PA Campaigns 

-- 1. Ver cuantos registros se insertaron
SELECT COUNT(*) 
FROM public."PSRawData" 
WHERE "sourceTable" = 'PACampaigns';

SELECT * FROM "PSRawData";

-- 2. Ver los registros
SELECT 
    "IdRawData",
    "sourceService",
    "sourceTable",
    "sourceRecordID",
    "isProcessed",
    "createdAt",
	"rawData"
FROM public."PSRawData"
WHERE "sourceTable" = 'PACampaigns'
ORDER BY "IdRawData" DESC
LIMIT 10;

-- Nos permite Procesar el RawData
CREATE OR REPLACE FUNCTION public.sp_ProcessRawCampaigns()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public."PSCampaigns" (
        "IdOrganization",
        "campaignName",
        "startDate",
        "endDate",
        "IdCampaignStatus",
        "totalBudget",
        "totalSpent",
        "totalRevenue",
        "ROI",
        "createdAt",
        "updatedAt",
        "lastETLupdate",
        "sourceServiceId",
        "sourceServiceName",
        "IdCurrency",
        "IdRunLog"
    )
    SELECT 
        1,
        'Campaign ' || "sourceRecordID",
        NOW(),
        NOW() + INTERVAL '30 days',
        1,
        0.00,
        0.00,
        0.00,
        0.0000,
        "createdAt",
        "updateAt",
        NOW(),
        1,
        1,
        1,
        "IdRunLog"
    FROM public."PSRawData"
    WHERE "sourceTable" = 'PACampaigns'
      AND "isProcessed" = FALSE;
    
    UPDATE public."PSRawData"
    SET "isProcessed" = TRUE
    WHERE "sourceTable" = 'PACampaigns'
      AND "isProcessed" = FALSE;
END;
$$;

-- Ejecutar
SELECT public.sp_ProcessRawCampaigns();

-- Verificar campañas insertadas
SELECT COUNT(*) FROM public."PSCampaigns";

-- Ver las primeras 10
SELECT * FROM public."PSCampaigns" 
ORDER BY "IdCampaign" 
LIMIT 10;

SELECT public.sp_ProcessRawCampaigns();
SELECT COUNT(*) FROM public."PSCampaigns";

SELECT * FROM "PSETLRunLog";


