-- ETL 

-- Primero verifica que exista la conexion
SELECT * FROM public."PSServiceConnectionConfig" WHERE "IdConnection" = 1;

SELECT * FROM "PSServiceConnectionConfig";
SELECT * FROM "PSETLConfig";
SELECT * FROM ""

-- Si no existe la conexion la creamos
-- (asumiendo que ya tienes PSServices con IdService=1,2,3)

SELECT * FROM "PSServices";

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

-- Extracciones del ETL

-- Revisamos que tenga PSRawData

SELECT * FROM "PSRawData";

DELETE FROM "PSRawData";

ALTER TABLE "PSRawData" ALTER COLUMN "IdRawData" RESTART WITH 1;

-- Extraccion de Organizations

ALTER TABLE "PSOrganizations" 
ALTER COLUMN "addressNoFiscal" DROP NOT NULL;

ALTER TABLE "PSOrganizations"
ALTER COLUMN "sociedadAnonima" TYPE varchar(80);

DELETE FROM "PSOrganizations";

ALTER TABLE "PSOrganizations" ALTER COLUMN "IdOrganization" RESTART WITH 1;

SELECT * FROM "PSOrganizations";

-- Procedure que pasa los datos en Raw a la tabla de Organizations

-- Crear como PROCEDURE
DROP PROCEDURE IF EXISTS public.sp_ProcessRawOrganizations();

CREATE OR REPLACE PROCEDURE public.sp_ProcessRawOrganizations()
LANGUAGE plpgsql
AS $$
DECLARE
    v_IdService INTEGER;
    v_ServiceName VARCHAR(50);
BEGIN
    -- Obtener servicio
    SELECT "IdService", "serviceName" 
    INTO v_IdService, v_ServiceName
    FROM public."PSServices"
    WHERE "serviceName" = 'PromptAds'
    LIMIT 1;
    
    IF v_IdService IS NULL THEN
        v_IdService := 1;
        v_ServiceName := 'PromptAds';
    END IF;

    -- Insertar organizaciones con datos reales del JSON
    INSERT INTO public."PSOrganizations" (
        name,
        enabled,
        "cedulaJuridica",
        "sociedadAnonima",
        "addressNoFiscal"
    )
    SELECT 
        -- Extraer name del JSON, usar fallback si es NULL o vacío
        COALESCE(
            NULLIF(TRIM(raw."rawData"::json->>'name'), ''),
            'Organization ' || raw."sourceRecordID"
        ),
        TRUE,
        -- Usar legalName si existe, sino generar
        COALESCE(
            NULLIF(TRIM(raw."rawData"::json->>'legalName'), ''),
            'Legal-' || raw."sourceRecordID"
        ),
        'S.A.',
        -- Usar email como dirección temporal
        COALESCE(
            'Contact: ' || NULLIF(TRIM(raw."rawData"::json->>'email'), ''),
            'No contact info'
        )
    FROM public."PSRawData" raw
    WHERE raw."sourceTable" = 'PAOrganizations'
      AND raw."isProcessed" = FALSE
    ON CONFLICT DO NOTHING;
    
    -- Marcar como procesado
    UPDATE public."PSRawData"
    SET "isProcessed" = TRUE
    WHERE "sourceTable" = 'PAOrganizations'
      AND "isProcessed" = FALSE;
      
    RAISE NOTICE 'Organizations processed successfully';
END;
$$;


-- Extraccion de Campaigns 

-- Nos permite Procesar el Raw Data a la tabla de Campaigns

-- Primero eliminar la función antigua si existe
DROP FUNCTION IF EXISTS public.sp_ProcessRawCampaigns();

-- Crear como PROCEDURE
CREATE OR REPLACE PROCEDURE public.sp_ProcessRawCampaigns()
LANGUAGE plpgsql
AS $$
DECLARE
    v_IdService INTEGER;
    v_ServiceName VARCHAR(50);
    v_RecordsProcessed INTEGER := 0;
BEGIN
    -- Obtener información del servicio PromptAds
    SELECT "IdService", "serviceName" 
    INTO v_IdService, v_ServiceName
    FROM public."PSServices"
    WHERE "serviceName" = 'PromptAds'
    LIMIT 1;
    
    IF v_IdService IS NULL THEN
        v_IdService := 1;
        v_ServiceName := 'PromptAds';
    END IF;
    
    -- Insertar campaigns con IdOrganization correcto
    INSERT INTO public."PSCampaigns" (
        "IdOrganization", "campaignName",
        "startDate", "endDate", "IdCampaignStatus",
        "totalBudget", "totalSpent", "totalRevenue", "ROI",
        "createdAt", "updatedAt", "lastETLupdate",
        "sourceServiceId", "sourceServiceName",
        "IdCurrency", "IdRunLog"
    )
    SELECT 
        -- BUSCAR IdOrganization real en PSOrganizations
        -- Estrategia: Tomar el IdOrganization de origen del campaign,
        -- buscarlo en PSRawData de organizations, y obtener el IdOrganization destino
        COALESCE(
            (
                SELECT org."IdOrganization"
                FROM public."PSOrganizations" org
                WHERE EXISTS (
                    SELECT 1 
                    FROM public."PSRawData" raw_org
                    WHERE raw_org."sourceTable" = 'PAOrganizations'
                      AND raw_org."sourceRecordID" = (raw_camp."rawData"::json->>'IdOrganization')
                      AND raw_org."isProcessed" = TRUE
                      -- Asumimos que el name debe coincidir
                      AND org.name = TRIM(raw_org."rawData"::json->>'name')
                )
                LIMIT 1
            ),
            1  -- Fallback a organization 1 si no encuentra
        ) AS "IdOrganization",
        
        -- NOMBRE REAL de la campaña desde JSON
        COALESCE(
            NULLIF(TRIM(raw_camp."rawData"::json->>'name'), ''),
            'Campaign ' || raw_camp."sourceRecordID"
        ) AS "campaignName",
        
        -- FECHA INICIO real desde JSON
        COALESCE(
            TO_TIMESTAMP(raw_camp."rawData"::json->>'startsAt', 'YYYY-MM-DD'),
            NOW()
        ) AS "startDate",
        
        -- FECHA FIN real desde JSON
        COALESCE(
            TO_TIMESTAMP(raw_camp."rawData"::json->>'endsAt', 'YYYY-MM-DD'),
            NOW() + INTERVAL '30 days'
        ) AS "endDate",
        
        1 AS "IdCampaignStatus",  -- Default: Active
        
        -- Budgets y revenue en 0 - se calculan después con otras tablas
        0.00 AS "totalBudget",
        0.00 AS "totalSpent",
        0.00 AS "totalRevenue",
        0.0000 AS "ROI",
        
        raw_camp."createdAt",
        raw_camp."updateAt",
        NOW() AS "lastETLupdate",
        v_IdService AS "sourceServiceId",
        v_ServiceName AS "sourceServiceName",
        1 AS "IdCurrency",  -- Default: USD
        raw_camp."IdRunLog"
    FROM public."PSRawData" raw_camp
    WHERE raw_camp."sourceTable" = 'PACampaigns'
      AND raw_camp."isProcessed" = FALSE;
    
    GET DIAGNOSTICS v_RecordsProcessed = ROW_COUNT;
    
    -- Marcar como procesados
    UPDATE public."PSRawData"
    SET "isProcessed" = TRUE
    WHERE "sourceTable" = 'PACampaigns'
      AND "isProcessed" = FALSE;
      
    RAISE NOTICE 'Campaigns processed: % records with real Organization IDs and data', v_RecordsProcessed;
END;
$$;


-- Extraccion de PublishedAds

CREATE OR REPLACE PROCEDURE public.sp_ProcessRawPublishedAds()
LANGUAGE plpgsql
AS $$
DECLARE
    v_campaign_name TEXT;
    v_found_id INTEGER;
BEGIN
    -- Iterar por cada PublishedAd no procesado
    FOR v_campaign_name IN 
        SELECT DISTINCT TRIM(raw_pub."rawData"::json->>'campaignName')
        FROM public."PSRawData" raw_pub
        WHERE raw_pub."sourceTable" = 'PAPublishedAds'
          AND raw_pub."isProcessed" = FALSE
    LOOP
        -- Buscar el IdCampaign en PSCampaigns
        SELECT c."IdCampaign" INTO v_found_id
        FROM public."PSCampaigns" c 
        WHERE c."campaignName" = v_campaign_name
        LIMIT 1;
        
        -- Log para debug
        RAISE NOTICE 'Campaign Name: %, Found ID: %', v_campaign_name, COALESCE(v_found_id::TEXT, 'NULL');
    END LOOP;
    
    -- Ahora sí hacemos el INSERT
    INSERT INTO public."PSPublishedAds" (
        "IdCampaign", "channelName", "channelType",
        "influencerName", "influencerFollowers",
        body, "redirectURL", budget, expenses,
        "adSentiment", "publishedAt", "adStatus",
        "createdAt", "updatedAt"
    )
    SELECT 
        (SELECT c."IdCampaign" 
         FROM public."PSCampaigns" c 
         WHERE c."campaignName" = TRIM(raw_pub."rawData"::json->>'campaignName')
         LIMIT 1),
        raw_pub."rawData"::json->>'channelName',
        raw_pub."rawData"::json->>'channelType',
        NULLIF(raw_pub."rawData"::json->>'influencerName', ''),
        (raw_pub."rawData"::json->>'influencerFollowers')::bigint,
        raw_pub."rawData"::json->>'body',
        raw_pub."rawData"::json->>'redirectURL',
        (raw_pub."rawData"::json->>'budget')::numeric,
        (raw_pub."rawData"::json->>'expenses')::numeric,
        raw_pub."rawData"::json->>'adSentiment',
        raw_pub."createdAt",
        raw_pub."rawData"::json->>'adStatus',
        raw_pub."createdAt",
        raw_pub."updateAt"
    FROM public."PSRawData" raw_pub
    WHERE raw_pub."sourceTable" = 'PAPublishedAds'
      AND raw_pub."isProcessed" = FALSE;
    
    UPDATE public."PSRawData"
    SET "isProcessed" = TRUE
    WHERE "sourceTable" = 'PAPublishedAds'
      AND "isProcessed" = FALSE;
END;
$$;

-- Extraccion de PSLeadsSummary

ALTER TABLE "PSLeadsSumarry" 
ADD CONSTRAINT unique_campaign_date 
UNIQUE ("IdCampaign", "sumarryDate");

-- 2. Stored Procedure corregido
CREATE OR REPLACE PROCEDURE sp_ProcessRawLeads()
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO "PSLeadsSumarry" (
        "IdCampaign", "sumarryDate", "totalLeads", 
        "currentLeads", "qualifiedLeads", "convertedLeads",
        "rejectedLeads", "qualificationRate", "conversionRate",
        "createdAt", "updatedAt"
    )
    SELECT 
        1 AS "IdCampaign",  
        CURRENT_DATE,
        COUNT(*) AS totalLeads,
        COUNT(*) FILTER (WHERE (raw."rawData"::json->>'IdStatus')::INT = 1) AS currentLeads,
        COUNT(*) FILTER (WHERE (raw."rawData"::json->>'IdStatus')::INT = 4) AS qualifiedLeads,  -- ✅ Status 4 = Qualified
        COUNT(*) FILTER (WHERE (raw."rawData"::json->>'IdStatus')::INT = 3) AS convertedLeads,  -- ✅ Status 3 = Converted
        COUNT(*) FILTER (WHERE (raw."rawData"::json->>'IdStatus')::INT = 2) AS rejectedLeads,   -- ✅ Status 2 = Rejected
        ROUND(
            COUNT(*) FILTER (WHERE (raw."rawData"::json->>'IdStatus')::INT = 4)::NUMERIC / 
            NULLIF(COUNT(*), 0), 4
        ) AS qualificationRate,
        ROUND(
            COUNT(*) FILTER (WHERE (raw."rawData"::json->>'IdStatus')::INT = 3)::NUMERIC / 
            NULLIF(COUNT(*), 0), 4
        ) AS conversionRate,
        NOW(), NOW()
    FROM "PSRawData" raw
    WHERE raw."sourceTable" = 'PCRLeads' 
      AND raw."isProcessed" = FALSE
    ON CONFLICT ("IdCampaign", "sumarryDate") 
    DO UPDATE SET
        "totalLeads" = EXCLUDED."totalLeads",
        "currentLeads" = EXCLUDED."currentLeads",
        "qualifiedLeads" = EXCLUDED."qualifiedLeads",
        "convertedLeads" = EXCLUDED."convertedLeads",
        "rejectedLeads" = EXCLUDED."rejectedLeads",
        "qualificationRate" = EXCLUDED."qualificationRate",
        "conversionRate" = EXCLUDED."conversionRate",
        "updatedAt" = NOW();
    
    UPDATE "PSRawData"
    SET "isProcessed" = TRUE
    WHERE "sourceTable" = 'PCRLeads' 
      AND "isProcessed" = FALSE;
END;
$$;

-- Extraccion de PSContentUsage

ALTER TABLE "PSContentUsage" 
ADD CONSTRAINT unique_campaign_content_channel 
UNIQUE ("IdCampaign", "contentId", "contentType", "channel");

CREATE OR REPLACE PROCEDURE sp_ProcessRawContent()
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO "PSContentUsage" (
        "IdCampaign", "contentId", "contentType", "contentTitle", "channel",
        "hashtags", "contentURL", "usageCount", "createdAt", "updatedAt"
    )
    SELECT 
        (raw."rawData"::json->>'cmpId')::INTEGER,
        raw."rawData"::json->>'cId',
        'image',
        raw."rawData"::json->>'title',
        raw."rawData"::json->>'ch',
        raw."rawData"::json->>'ht',
        raw."rawData"::json->>'url',
        (raw."rawData"::json->>'cnt')::INTEGER,
        NOW(), NOW()
    FROM "PSRawData" raw
    WHERE raw."sourceTable" = 'PCmedia' 
      AND raw."isProcessed" = FALSE
    ON CONFLICT ("IdCampaign", "contentId", "contentType", "channel")
    DO UPDATE SET
        "contentTitle" = EXCLUDED."contentTitle",
        "hashtags" = EXCLUDED."hashtags",
        "contentURL" = EXCLUDED."contentURL",
        "usageCount" = EXCLUDED."usageCount",
        "updatedAt" = NOW();
    
    UPDATE "PSRawData"
    SET "isProcessed" = TRUE
    WHERE "sourceTable" = 'PCmedia' 
      AND "isProcessed" = FALSE;
END;
$$;

-- Orden de Borrado

DELETE FROM "PSContentUsage";

ALTER TABLE "PSContentUsage" ALTER COLUMN "IdContentUsage" RESTART WITH 1;

DELETE FROM "PSLeadsSumarry";

ALTER TABLE "PSLeadsSumarry" ALTER COLUMN "IdLeadSumarry" RESTART WITH 1;

DELETE FROM "PSPublishedAds";

ALTER TABLE "PSPublishedAds" ALTER COLUMN "IdPublishedAd" RESTART WITH 1;

DELETE FROM "PSCampaigns";

ALTER TABLE "PSCampaigns" ALTER COLUMN "IdCampaign" RESTART WITH 1;

DELETE FROM "PSOrganizations";

ALTER TABLE "PSOrganizations" ALTER COLUMN "IdOrganization" RESTART WITH 1;

DELETE FROM "PSRawData";

ALTER TABLE "PSRawData" ALTER COLUMN "IdRawData" RESTART WITH 1;

UPDATE public."PSRawData"
SET "isProcessed" = FALSE
WHERE "sourceTable" = 'PAPublishedAds';


-- Orden Vista

SELECT * FROM "PSRawData";

SELECT * FROM "PSOrganizations";

SELECT * FROM "PSCampaigns";

SELECT * FROM "PSPublishedAds";

SELECT * FROM "PSLeadsSumarry";

SELECT * FROM "PSContentUsage";

SELECT * FROM "PSOrganizations"
WHERE "IdOrganization" = 322;

SELECT *
FROM "PSRawData"
WHERE "sourceTable" = 'PAPublishedAds';









