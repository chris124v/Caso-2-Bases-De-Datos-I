USE [promptcrm]
GO

-- Eliminar vista si existe
DROP VIEW IF EXISTS [dbo].[vw_LeadsSummary_Delta];
GO

-- Vista Delta para Leads Summary

CREATE VIEW [dbo].[vw_LeadsSummary_Delta]
AS
SELECT 
    -- Identificadores
    c.IdCampaign,
    o.OrganizationName,
    c.CampaignCode,
    
    -- Fecha del resumen
    CAST(GETDATE() AS DATE) AS summaryDate,
    
    -- Conteos de leads por estado asi calculos los datos 
    COUNT(DISTINCT l.IdLead) AS totalLeads,
    COUNT(DISTINCT CASE WHEN l.IdStatus IN (1,2,3) THEN l.IdLead END) AS currentLeads,
    COUNT(DISTINCT CASE WHEN l.IdStatus = 3 THEN l.IdLead END) AS qualifiedLeads,
    COUNT(DISTINCT CASE WHEN l.IdStatus = 4 THEN l.IdLead END) AS convertedLeads,
    COUNT(DISTINCT CASE WHEN l.IdStatus = 5 THEN l.IdLead END) AS rejectedLeads,
    
    -- Clientes y revenue
    COUNT(DISTINCT cli.IdClient) AS TotalClients,
    CAST(ISNULL(SUM(s.SaleTotal), 0) AS DECIMAL(18,2)) AS TotalRevenue,
    COUNT(DISTINCT e.IdEvent) AS TotalInteractions,
    
    -- Tasas de conversion
    CAST(
        CASE 
            WHEN COUNT(DISTINCT l.IdLead) > 0 
            THEN (CAST(COUNT(DISTINCT CASE WHEN l.IdStatus = 3 THEN l.IdLead END) AS FLOAT) / COUNT(DISTINCT l.IdLead)) * 100
            ELSE 0 
        END AS DECIMAL(5,2)
    ) AS qualificationRate,
    
    CAST(
        CASE 
            WHEN COUNT(DISTINCT l.IdLead) > 0 
            THEN (CAST(COUNT(DISTINCT CASE WHEN l.IdStatus = 4 THEN l.IdLead END) AS FLOAT) / COUNT(DISTINCT l.IdLead)) * 100
            ELSE 0 
        END AS DECIMAL(5,2)
    ) AS conversionRate,
    
    -- Canales
    'Multiple Channels' AS leadChannels,
    
    -- Fechas de campana
    c.CreatedAt AS CampaignStartDate,
    ISNULL(MAX(l.UpdatedAt), c.UpdatedAt) AS LastActivity,
    c.CreatedAt,
    GETDATE() AS UpdatedAt,
    
    -- Delta: Fecha mas reciente
    ISNULL(MAX(l.UpdatedAt), c.UpdatedAt) AS maxUpdatedAt
    
FROM PCRCampaigns c
INNER JOIN PCROrganizations o ON c.IdOrganization = o.IdOrganization
LEFT JOIN PCRLeads l ON c.IdCampaign = l.IdCampaign
LEFT JOIN PCRClientsPerCampaigns cpc ON c.IdCampaign = cpc.IdCampaign
LEFT JOIN PCRClients cli ON cpc.IdClient = cli.IdClient
LEFT JOIN PCRSalesHistory s ON cli.IdClient = s.IdClient
LEFT JOIN PCREvents e ON l.IdLead = e.IdLead
GROUP BY 
    c.IdCampaign, 
    o.OrganizationName, 
    c.CampaignCode,
    c.CreatedAt,
    c.UpdatedAt;
GO

-- Verificar que funciona
SELECT 
    CampaignCode,
    totalLeads,
    convertedLeads,
    TotalRevenue,
    maxUpdatedAt
FROM [dbo].[vw_LeadsSummary_Delta]
ORDER BY maxUpdatedAt DESC;
GO
