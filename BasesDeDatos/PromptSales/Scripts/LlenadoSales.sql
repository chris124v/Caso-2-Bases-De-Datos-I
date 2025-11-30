-- Scripts de llenado 

-- Primero inserta los datos base necesarios
INSERT INTO public."PSCampaignStatus" ("statusName", description, "isActive")
VALUES ('Active', 'Campaign is currently active', true)
ON CONFLICT DO NOTHING;

INSERT INTO public."PSOrganizations" (name, enabled, "cedulaJuridica", "sociedadAnonima", "addressNoFiscal")
VALUES ('Test Organization', true, '123456789', 'Test SA', 'Test Address')
ON CONFLICT DO NOTHING;

INSERT INTO public."PSCountries" (name)
VALUES ('United States')
ON CONFLICT DO NOTHING;

INSERT INTO public."PSCurrencies" (name, "isoCode", "currencySymbol", "createdAt", "IdCountry")
VALUES ('US Dollar', 'USD', '$', NOW(), 1)
ON CONFLICT DO NOTHING;

SELECT * FROM "PSCampaignStatus";

-- 5. Service Types
INSERT INTO public."PSServiceTypes" (name, description, "createdAt")
VALUES ('Database', 'Database service', NOW())
ON CONFLICT ("IdServiceType") DO NOTHING;

SELECT * FROM "PSServiceTypes";

-- 6. Services (sin especificar IdService porque es SERIAL)
INSERT INTO public."PSServices" (
    "serviceName", 
    "IdServiceType", 
    description, 
    "databaseType", 
    "primaryURL", 
    enabled, 
    "currentVersion", 
    "createdAt", 
    "updatedAt"
)
VALUES 
('PromptAds', 1, 'PromptAds Database', 'SQL Server', 'localhost:31433', true, '1.0', NOW(), NOW()),
('PromptCRM', 1, 'PromptCRM Database', 'SQL Server', 'localhost:32433', true, '1.0', NOW(), NOW()),
('PromptContent', 1, 'PromptContent Database', 'MongoDB', 'localhost:30017', true, '1.0', NOW(), NOW())
RETURNING "IdService";

-- 7. Service Connection Config 
INSERT INTO public."PSServiceConnectionConfig" (
    "connectionName", 
    "connectionType", 
    credentials, 
    endpoint, 
    metadata, 
    enabled, 
    "createdAt", 
    "updatedAt", 
    "IdSourceService", 
    "IdTargetService"
)
VALUES (
    'PromptAds to PromptSales', 
    'SQL Server', 
    'sa:YourStrong!Passw0rd', 
    'localhost:31433', 
    '{}', 
    true, 
    NOW(), 
    NOW(), 
    1,  -- IdSourceService (PromptAds)
    1   -- IdTargetService (PromptAds)
)
RETURNING "IdConnection";
-- Anota el IdConnection que te devuelve (probablemente será 1)

-- 8. ETL Config (sin especificar IdConfig porque es SERIAL)
INSERT INTO public."PSETLConfig" (
    "IdConnection",
    schedule,
    "connectionString",
    priority,
    enabled,
    "createdAt",
    "updatedAt"
)
VALUES (
    1,  -- usa el IdConnection de arriba
    'Every 11 minutes',
    'Server=localhost,31433;Database=promptads;User Id=sa;Password=YourStrong!Passw0rd;',
    1,
    true,
    NOW(),
    NOW()
)
RETURNING "IdConfig";
-- Anota el IdConfig que te devuelve (probablemente será 1)

-- 9. ETL Run Log
INSERT INTO public."PSETLRunLog" (
    "IdConfig", 
    "runStart", 
    "runEnd", 
    "rowsProcessed", 
    message, 
    "lastProcessedID", 
    "recordsFailed", 
    "recordsInserted", 
    "createdAt"
)
VALUES (
    1,  -- usa el IdConfig de arriba
    NOW(), 
    NOW(), 
    0, 
    'Initial dummy run', 
    0, 
    0, 
    0, 
    NOW()
)
RETURNING "IdRunLog";
-- Anota el IdRunLog que te devuelve (probablemente será 1)

-- 10. Campaign
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
VALUES (
    1,
    'Test Campaign',
    NOW(),
    NOW() + INTERVAL '30 days',
    1,
    10000.00,
    5000.00,
    8000.00,
    0.60,
    NOW(),
    NOW(),
    NOW(),
    1,
    1,
    1,
    1  -- usa el IdRunLog de arriba
);

-- Verificacion
SELECT * FROM public."PSCampaigns" WHERE "IdCampaign" = 1;
SELECT * FROM public."PSServices";
SELECT * FROM public."PSETLConfig";
SELECT * FROM public."PSETLRunLog";


-- Borrado Extremo

-- Truncar todas las tablas del esquema public
DO
$$
DECLARE
    r RECORD;
    truncate_sql TEXT := '';
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        -- Usar format con %I para evitar doble comillas y concatenar con coma
        truncate_sql := truncate_sql || format('%I, ', r.tablename);
    END LOOP;

    -- Remover la última coma y espacio al final
    truncate_sql := left(truncate_sql, length(truncate_sql) - 2);

    -- Ejecutar TRUNCATE con CASCADE
    EXECUTE format('TRUNCATE TABLE %s CASCADE;', truncate_sql);
END;
$$;

-- Reiniciar las columnas IDENTITY para todas las tablas del esquema público
DO
$$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN 
        SELECT table_name, column_name
        FROM information_schema.columns
        WHERE table_schema = 'public' 
          AND is_identity = 'YES'
    LOOP
        EXECUTE format('ALTER TABLE %I ALTER COLUMN %I RESTART WITH 1;', rec.table_name, rec.column_name);
    END LOOP;
END;
$$;