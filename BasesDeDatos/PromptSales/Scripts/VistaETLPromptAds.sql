-- Vista para PromptAds
-- Contiene TODOS los datos necesarios para PromptSales

CREATE VIEW vw_ETL_MasterData AS
SELECT 
    
    -- Campaign Base
    
    c.IdCampaign,
    c.IdOrganization,
    c.name AS campaignName,
    c.createdAt AS campaignStartDate,
    c.endsAt AS campaignEndDate,
    c.enabled AS campaignEnabled,
    c.deleted AS campaignDeleted,
    c.updatedAt AS campaignUpdatedAt,
    

    -- Campaign Ads

    ca.IdCampaignAd,
    ca.title AS campaignAdTitle,
    ca.description AS campaignAdDescription,
    ca.IdAdType,
    adt.name AS adTypeName,
    ca.createdAt AS campaignAdCreatedAt,
    ca.updatedAt AS campaignAdUpdatedAt,
    
    -- Published Ads
    pa.IdPublishedAd,
    pa.body AS adBody,
    pa.redirectURL,
    pa.createdAt AS publishedAt,
    pa.updatedAt AS adUpdatedAt,
    pa.IdAdStatus,
    ast.name AS adStatusName,
    
    
    -- Canales de los Ads

    ch.IdChannel,
    ch.name AS channelName,
    CASE 
        WHEN oc.IdOrganizationContact IS NOT NULL THEN 'organization'
        WHEN ic.IdInfluencerContact IS NOT NULL THEN 'influencer'
        ELSE NULL
    END AS channelType,
    
    -- Canal Organization
    oc.IdOrganizationContact,
    oc.value AS organizationContactValue,
    
    -- Canal Influencer
    ic.IdInfluencerContact,
    ic.value AS influencerContactValue,
    

    -- INFLUENCER (si es que hay)
    inf.IdInfluencer,
    inf.username AS influencerName,
    inf.followers AS influencerFollowers,
    inf.bio AS influencerBio,
    
 
    -- Performance Financiera
    ab.IdAdBudget,
    ab.amount AS adBudget,
    ab.IdCurrency AS budgetCurrency,
    ab.isCurrent AS budgetIsCurrent,
    
    ap.IdAdPerformance,
    ap.budget AS performanceBudget,
    ap.expenses AS adExpenses,
    ap.IdAdSentiment,
    ap.isCurrent AS performanceIsCurrent,
    

    -- Sentiment
    sent.name AS adSentiment,
    
    -- Reacciones
    rpa.IdReaction,
    rpa.IdReactionType,
    rt.name AS reactionTypeName,
    rpa.reactionNumber,
    
    -- Transacciones
    ct.IdCampaignTransaction,
    ct.amount AS transactionAmount,
    ct.IdCurrency AS transactionCurrency,
    ct.IdCampaignTransactionType,
    ctt.name AS transactionTypeName,
    ct.createdAt AS transactionDate

FROM PACampaigns c

-- Ads de la campaña
LEFT JOIN PACampaignAds ca ON c.IdCampaign = ca.IdCampaign
    AND ca.deleted = 0
LEFT JOIN PAAdTypes adt ON ca.IdAdType = adt.IdAdType

-- Ads publicados
LEFT JOIN PAPublishedAds pa ON ca.IdCampaignAd = pa.IdCampaignAd
LEFT JOIN PAAdStatus ast ON pa.IdAdStatus = ast.IdAdStatus

-- Budget
LEFT JOIN PAAdBudgets ab ON ca.IdCampaignAd = ab.IdCampaignAd 
    AND ab.isCurrent = 1

-- Performance actual
LEFT JOIN PAAdPerformances ap ON pa.IdPublishedAd = ap.IdPublishedAd 
    AND ap.isCurrent = 1

-- Sentiment
LEFT JOIN PAAdSentiments sent ON ap.IdAdSentiment = sent.IdAdSentiment

-- Canal - Organization
LEFT JOIN PAOrganizationContacts oc ON pa.IdOrganizationContact = oc.IdOrganizationContact
    AND oc.enabled = 1 
    AND oc.deleted = 0

-- Canal - Influencer
LEFT JOIN PAInfluencerContacts ic ON pa.IdInfluencerContact = ic.IdInfluencerContact
    AND ic.enabled = 1 
    AND ic.deleted = 0
LEFT JOIN PAInfluencers inf ON ic.IdInfluencer = inf.IdInfluencer

-- Canal name
LEFT JOIN PAChannels ch ON COALESCE(oc.IdChannel, ic.IdChannel) = ch.IdChannel

-- Reacciones (puede generar múltiples filas por ad)
LEFT JOIN PAReactionsPerAd rpa ON ap.IdAdPerformance = rpa.IdAdPerformance
LEFT JOIN PAReactionTypes rt ON rpa.IdReactionType = rt.IdReactionType

-- Transacciones de campaña
LEFT JOIN PACampaignTransactions ct ON ca.IdCampaignAd = ct.IdCampaignAd
LEFT JOIN PACampaignTransactionTypes ctt ON ct.IdCampaignTransactionType = ctt.IdCampaignTransactionType

WHERE c.updatedAt > @lastETLDate
   OR pa.updatedAt > @lastETLDate
   OR ap.createdAt > @lastETLDate
   OR ct.createdAt > @lastETLDate;