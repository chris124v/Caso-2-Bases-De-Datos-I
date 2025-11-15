USE [promptads]
GO
-- Primero, eliminar la vista si existe
DROP VIEW IF EXISTS [dbo].[vw_PublishedAds_Delta];
GO

-- Vista Delta para Published Ads
-- Proposito: Extraer solo ads modificados desde ultima ejecucion

CREATE VIEW [dbo].[vw_PublishedAds_Delta]
AS
SELECT 

    -- Aqui seleccionamos columnas para los anuncios publicados

    -- IDs
    pa.IdPublishedAd,
    ca.IdCampaign,
    
    -- Canal información
    ISNULL(ch.name, 'Unknown') AS channelName,

    -- Clasificacion del algunos channels
    CASE 
        WHEN ch.name IN ('Instagram', 'Facebook', 'TikTok') THEN 'Social Media'
        WHEN ch.name = 'LinkedIn' THEN 'Professional Network'
        WHEN ch.name = 'YouTube' THEN 'Video Platform'
        ELSE 'Other'
    END AS channelType,
    
    -- Ad información
    ISNULL(adt.name, 'Unknown') AS adType,
    
    -- Influencer información
    ISNULL(inf.username, 'Direct') AS influencerName,
    ISNULL(inf.followers, 0) AS influencerFollowers,
    
    -- Contenido
    SUBSTRING(ISNULL(pa.body, ''), 1, 4000) AS body,
    SUBSTRING(ISNULL(pa.redirectURL, ''), 1, 500) AS redirectURL,
    
    -- Performance metrics
    CAST(ISNULL(perf.budget, 0.00) AS DECIMAL(12,2)) AS budget,
    CAST(ISNULL(perf.expenses, 0.00) AS DECIMAL(12,2)) AS expenses,
    ISNULL(sent.name, 'Neutral') AS adSentiment,
    
    -- Estado y fechas
    ISNULL(st.name, 'Unknown') AS adStatus,
    pa.createdAt AS publishedAt,
    pa.createdAt,
    ISNULL(pa.updatedAt, pa.createdAt) AS updatedAt,
    
    -- Uso del delta: Usar solo pa.updatedAt o createdAt
    ISNULL(pa.updatedAt, pa.createdAt) AS maxUpdatedAt
   
FROM PAPublishedAds pa
INNER JOIN PACampaignAds ca ON pa.IdCampaignAd = ca.IdCampaignAd
LEFT JOIN PAOrganizationContacts oc ON pa.IdOrganizationContact = oc.IdOrganizationContact
LEFT JOIN PAChannels ch ON oc.IdChannel = ch.IdChannel
LEFT JOIN PAAdTypes adt ON ca.IdAdType = adt.IdAdType
LEFT JOIN PAAdStatus st ON pa.IdAdStatus = st.IdAdStatus
LEFT JOIN PAInfluencerContacts ic ON pa.IdInfluencerContact = ic.IdInfluencerContact
LEFT JOIN PAInfluencers inf ON ic.IdInfluencer = inf.IdInfluencer
LEFT JOIN (
    SELECT 
        IdPublishedAd, 
        budget, 
        expenses, 
        IdAdSentiment,
        createdAt
    FROM PAAdPerformances
    WHERE isCurrent = 1
) perf ON pa.IdPublishedAd = perf.IdPublishedAd
LEFT JOIN PAAdSentiments sent ON perf.IdAdSentiment = sent.IdAdSentiment
WHERE pa.IdPublishedAd IS NOT NULL;
GO

-- Verificar que la vista funciona
SELECT TOP 5 
    IdPublishedAd,
    channelName,
    budget,
    expenses,
    maxUpdatedAt
FROM [dbo].[vw_PublishedAds_Delta]
ORDER BY maxUpdatedAt DESC;
GO
