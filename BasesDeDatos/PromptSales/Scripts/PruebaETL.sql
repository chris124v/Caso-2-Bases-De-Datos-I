-- Comandos para borrar todos los datos de la BD si necesito 
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

-- Prueba de Insercion del ETL en la tabla de Mongo

-- Ver cuantas filas se insertaron
SELECT COUNT(*) FROM "PSContentUsage";

-- Ver los datos
SELECT 
    "IdContentUsage",
    "contentId",
    "IdCampaign",
    "contentType",
    "usageCount",
	"hashtags",
	"channel",
	"contentTitle",
	"contentURL",
	"usedInAds",
	"updatedAt",
	"createdAt"
FROM "PSContentUsage"
ORDER BY "IdContentUsage";

-- Comando para borrar nulos porque las bds no estan llenas 
ALTER TABLE "PSContentUsage" 
ALTER COLUMN "IdCampaign" DROP NOT NULL;

-- Borre los datos de ContentUsage para probar nuevamente el ETL
DELETE FROM "PSContentUsage";
DELETE FROM "PSPublishedAds";
DELETE FROM "PSLeadsSumarry";

-- Prueba del ETL para la tabla de PromptAds
SELECT COUNT(*) FROM "PSPublishedAds";

-- Ver los datos
SELECT 
    "IdPublishedAd",
    "IdCampaign",
    "channelName",
    "influencerName",
    "influencerFollowers",
	body,
	"redirectURL",
	budget,
	expenses,
	"adSentiment",
	"adStatus",
	"publishedAt", 
	"createdAt"
FROM "PSPublishedAds"
ORDER BY "IdPublishedAd";

-- Prueba del ETL para la tabla de PromptCRM
SELECT COUNT(*) FROM "PSLeadsSumarry";

-- Ver los datos
SELECT 
    "IdLeadSumarry",
    "IdCampaign",
    "sumarryDate",
    "totalLeads",
    "currentLeads",
    "qualifiedLeads",
    "convertedLeads",
    "rejectedLeads",
    "qualificationRate",
    "conversionRate",
    "leadChannels",
    "createdAt",
    "updatedAt"
FROM "PSLeadsSumarry"
ORDER BY "IdLeadSumarry";

-- Cambiar conversionRate
ALTER TABLE "PSLeadsSumarry" 
ALTER COLUMN "conversionRate" TYPE NUMERIC(5,2);

-- Cambiar qualificationRate
ALTER TABLE "PSLeadsSumarry" 
ALTER COLUMN "qualificationRate" TYPE NUMERIC(5,2);

-- Hacer null lo que siempre da problemas
ALTER TABLE "PSLeadsSumarry" 
ALTER COLUMN "IdCampaign" DROP NOT NULL;

-- Actualizacion de fechas del Delta
SELECT 
    view,
    "lastInput",
    AGE(NOW(), "lastInput") as hace_cuanto,
    "createdAt"
FROM public."PSETLDelta"
ORDER BY "lastInput" DESC;

-- Reestablecer para pruebas

-- Resetear fechas de control
UPDATE public."PSETLDelta"
SET "lastInput" = '2024-01-01 00:00:00'::timestamp;

-- Contar registros actuales
SELECT 'PSContentUsage' AS tabla, COUNT(*) AS filas FROM "PSContentUsage"
UNION ALL
SELECT 'PSPublishedAds', COUNT(*) FROM "PSPublishedAds"
UNION ALL
SELECT 'PSLeadsSummarry', COUNT(*) FROM "PSLeadsSumarry";



