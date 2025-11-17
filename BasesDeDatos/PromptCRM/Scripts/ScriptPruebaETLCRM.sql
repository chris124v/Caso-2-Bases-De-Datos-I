USE [promptcrm]
GO

-- Script de Llenado de Datos de Prueba - PromptCRM
-- Objetivo: Alimentar PSLeadsSummary en PromptSales via ETL
-- Estructuras verificadas del schema real

-- 1. Catalogos base

-- Países
SET IDENTITY_INSERT [dbo].[PCRCountries] ON
INSERT INTO [dbo].[PCRCountries] ([IdCountry], [CountryName])
VALUES 
    (1, 'United States'),
    (2, 'Costa Rica'),
    (3, 'Mexico')
SET IDENTITY_INSERT [dbo].[PCRCountries] OFF

-- Estados
SET IDENTITY_INSERT [dbo].[PCRStates] ON
INSERT INTO [dbo].[PCRStates] ([IdState], [StateName], [IdCountry])
VALUES 
    (1, 'New York', 1),
    (2, 'California', 1),
    (3, 'San José', 2),
    (4, 'Jalisco', 3)
SET IDENTITY_INSERT [dbo].[PCRStates] OFF

-- Ciudades
SET IDENTITY_INSERT [dbo].[PCRCities] ON
INSERT INTO [dbo].[PCRCities] ([IdCity], [CityName], [IdState])
VALUES 
    (1, 'New York City', 1),
    (2, 'Los Angeles', 2),
    (3, 'Cartago', 3),
    (4, 'Guadalajara', 4)
SET IDENTITY_INSERT [dbo].[PCRCities] OFF

-- Direcciones
SET IDENTITY_INSERT [dbo].[PCRAddresses] ON
INSERT INTO [dbo].[PCRAddresses] ([IdAddress], [Directions1], [Directions2], [zipCode], [Geolocation], [IdCity])
VALUES 
    (1, '123 Tech Street', 'Suite 100', '10001', NULL, 1),
    (2, '456 Fashion Ave', NULL, '90001', NULL, 2),
    (3, '789 Health Blvd', 'Floor 2', '30101', NULL, 3)
SET IDENTITY_INSERT [dbo].[PCRAddresses] OFF

-- Status de Campaign
SET IDENTITY_INSERT [dbo].[PCRCampaignStatuses] ON
INSERT INTO [dbo].[PCRCampaignStatuses] ([IdStatus], [StatusDescription])
VALUES 
    (1, 'Active'),
    (2, 'Paused'),
    (3, 'Completed'),
    (4, 'Cancelled')
SET IDENTITY_INSERT [dbo].[PCRCampaignStatuses] OFF

-- Status de Cliente
SET IDENTITY_INSERT [dbo].[PCRClientStatuses] ON
INSERT INTO [dbo].[PCRClientStatuses] ([IdStatus], [StatusDescription])
VALUES 
    (1, 'Active'),
    (2, 'Inactive'),
    (3, 'Churned')
SET IDENTITY_INSERT [dbo].[PCRClientStatuses] OFF

-- Status de Lead
SET IDENTITY_INSERT [dbo].[PCRLeadStatuses] ON
INSERT INTO [dbo].[PCRLeadStatuses] ([IdStatus], [StatusDescription])
VALUES 
    (1, 'New'),
    (2, 'Contacted'),
    (3, 'Qualified'),
    (4, 'Converted'),
    (5, 'Lost')
SET IDENTITY_INSERT [dbo].[PCRLeadStatuses] OFF

-- Event Types
SET IDENTITY_INSERT [dbo].[PCREventTypes] ON
INSERT INTO [dbo].[PCREventTypes] ([IdEventType], [TypeName])
VALUES 
    (1, 'Email Open'),
    (2, 'Email Click'),
    (3, 'Form Submit'),
    (4, 'Phone Call'),
    (5, 'Meeting'),
    (6, 'Purchase')
SET IDENTITY_INSERT [dbo].[PCREventTypes] OFF

-- Event Sources
SET IDENTITY_INSERT [dbo].[PCREventSources] ON
INSERT INTO [dbo].[PCREventSources] ([IdEventSource], [SourceName])
VALUES 
    (1, 'Website'),
    (2, 'Email Campaign'),
    (3, 'Social Media'),
    (4, 'Direct Outreach'),
    (5, 'Referral')
SET IDENTITY_INSERT [dbo].[PCREventSources] OFF

-- Event Mediums
SET IDENTITY_INSERT [dbo].[PCREventMediums] ON
INSERT INTO [dbo].[PCREventMediums] ([IdEventMedium], [MediumName])
VALUES 
    (1, 'Email'),
    (2, 'Phone'),
    (3, 'Chat'),
    (4, 'In-Person'),
    (5, 'Video Call')
SET IDENTITY_INSERT [dbo].[PCREventMediums] OFF

-- Feature Types
SET IDENTITY_INSERT [dbo].[PCRFeatureTypes] ON
INSERT INTO [dbo].[PCRFeatureTypes] ([IdFeatureType], [TypeName])
VALUES 
    (1, 'Age'),
    (2, 'Gender'),
    (3, 'Income Range'),
    (4, 'Interest'),
    (5, 'Job Title')
SET IDENTITY_INSERT [dbo].[PCRFeatureTypes] OFF

-- 2. Organizaciones

SET IDENTITY_INSERT [dbo].[PCROrganizations] ON
INSERT INTO [dbo].[PCROrganizations] ([IdOrganization], [OrganizationName], [Website], [PhoneNumber], [Industry], [Description], [IdAddress], [CreatedAt], [UpdatedAt])
VALUES 
    (1, 'TechGadgets Inc', 'techgadgets.com', '+1-555-0101', 'Technology', 'Consumer electronics retailer', 1, '2024-07-01', '2024-07-01'),
    (2, 'FashionHub Store', 'fashionhub.com', '+1-555-0202', 'Retail', 'Fashion and apparel store', 2, '2024-08-15', '2024-08-15'),
    (3, 'HealthyLife Products', 'healthylife.com', '+1-555-0303', 'Health & Wellness', 'Health supplements and products', 3, '2024-09-10', '2024-09-10')
SET IDENTITY_INSERT [dbo].[PCROrganizations] OFF


-- 3. Campanas

SET IDENTITY_INSERT [dbo].[PCRCampaigns] ON
INSERT INTO [dbo].[PCRCampaigns] ([IdCampaign], [CampaignCode], [IdOrganization], [IdStatus], [CreatedAt], [UpdatedAt])
VALUES 
    -- TechGadgets Campaigns
    (1, 'TECH-BF2024', 1, 1, '2024-10-15', '2024-11-20'),
    (2, 'TECH-NY2025', 1, 1, '2024-11-20', '2024-11-20'),
    
    -- FashionHub Campaigns
    (3, 'FASH-WIN2024', 2, 1, '2024-10-01', '2024-11-01'),
    
    -- HealthyLife Campaigns
    (4, 'HLTH-NYW2025', 3, 1, '2024-11-25', '2024-11-25')
SET IDENTITY_INSERT [dbo].[PCRCampaigns] OFF

-- 4. Clientes

SET IDENTITY_INSERT [dbo].[PCRClients] ON
INSERT INTO [dbo].[PCRClients] ([IdClient], [ClientCode], [IdStatus], [CreatedAt], [UpdatedAt])
VALUES 
    (1, 'CLI-00001', 1, '2024-11-21', '2024-11-21'),
    (2, 'CLI-00002', 1, '2024-11-21', '2024-11-21'),
    (3, 'CLI-00003', 1, '2024-11-22', '2024-11-22'),
    (4, 'CLI-00004', 1, '2024-11-23', '2024-11-23'),
    (5, 'CLI-00005', 1, '2024-11-02', '2024-11-02'),
    (6, 'CLI-00006', 1, '2024-11-10', '2024-11-10'),
    (7, 'CLI-00007', 1, '2024-12-16', '2024-12-16')
SET IDENTITY_INSERT [dbo].[PCRClients] OFF

-- Relación Clientes-Campañas
INSERT INTO [dbo].[PCRClientsPerCampaigns] ([IdCampaign], [IdClient], [CreatedAt], [UpdatedAt], [Enabled])
VALUES 
    -- Campaign 1 (Black Friday) - 4 clients
    (1, 1, '2024-11-21', '2024-11-21', 1),
    (1, 2, '2024-11-21', '2024-11-21', 1),
    (1, 3, '2024-11-22', '2024-11-22', 1),
    (1, 4, '2024-11-23', '2024-11-23', 1),
    
    -- Campaign 3 (Winter Fashion) - 2 clients
    (3, 5, '2024-11-02', '2024-11-02', 1),
    (3, 6, '2024-11-10', '2024-11-10', 1),
    
    -- Campaign 4 (New Year Wellness) - 1 client
    (4, 7, '2024-12-16', '2024-12-16', 1)

-- Features de Clientes (datos demográficos)
INSERT INTO [dbo].[PCRFeaturesPerClients] ([IdClient], [IdFeatureType], [FeatureValue], [CreatedAt], [UpdatedAt], [Enabled])
VALUES 
    (1, 1, '28-35', '2024-11-21', '2024-11-21', 1), -- Age
    (1, 2, 'Male', '2024-11-21', '2024-11-21', 1),  -- Gender
    (1, 3, '$50k-$75k', '2024-11-21', '2024-11-21', 1), -- Income
    
    (2, 1, '36-45', '2024-11-21', '2024-11-21', 1),
    (2, 2, 'Female', '2024-11-21', '2024-11-21', 1),
    (2, 3, '$75k-$100k', '2024-11-21', '2024-11-21', 1),
    
    (3, 1, '25-30', '2024-11-22', '2024-11-22', 1),
    (3, 2, 'Male', '2024-11-22', '2024-11-22', 1),
    
    (5, 1, '22-28', '2024-11-02', '2024-11-02', 1),
    (5, 2, 'Female', '2024-11-02', '2024-11-02', 1),
    (5, 4, 'Fashion', '2024-11-02', '2024-11-02', 1), -- Interest
    
    (7, 1, '30-40', '2024-12-16', '2024-12-16', 1),
    (7, 4, 'Health', '2024-12-16', '2024-12-16', 1)

-- 5. Leads

SET IDENTITY_INSERT [dbo].[PCRLeads] ON
INSERT INTO [dbo].[PCRLeads] ([IdLead], [LeadCode], [IdCampaign], [IdStatus], [CreatedAt], [UpdatedAt], [Enabled])
VALUES 
    -- Campaign 1 (Black Friday) - 8 leads, 4 converted
    (1, 'LEAD-BF-001', 1, 4, '2024-11-20 09:00:00', '2024-11-21 15:30:00', 1), -- Converted to Client 1
    (2, 'LEAD-BF-002', 1, 4, '2024-11-20 10:30:00', '2024-11-21 16:00:00', 1), -- Converted to Client 2
    (3, 'LEAD-BF-003', 1, 4, '2024-11-20 14:00:00', '2024-11-22 10:00:00', 1), -- Converted to Client 3
    (4, 'LEAD-BF-004', 1, 4, '2024-11-21 08:00:00', '2024-11-23 11:00:00', 1), -- Converted to Client 4
    (5, 'LEAD-BF-005', 1, 3, '2024-11-21 12:00:00', '2024-11-23 09:00:00', 1), -- Qualified
    (6, 'LEAD-BF-006', 1, 2, '2024-11-22 10:00:00', '2024-11-23 14:00:00', 1), -- Contacted
    (7, 'LEAD-BF-007', 1, 5, '2024-11-22 15:00:00', '2024-11-24 10:00:00', 1), -- Lost
    (8, 'LEAD-BF-008', 1, 1, '2024-11-23 11:00:00', '2024-11-23 11:00:00', 1), -- New
    
    -- Campaign 2 (New Year Tech) - 3 leads, 0 converted (too new)
    (9, 'LEAD-NY-001', 2, 2, '2024-12-26 08:00:00', '2024-12-27 10:00:00', 1),
    (10, 'LEAD-NY-002', 2, 1, '2024-12-27 14:00:00', '2024-12-27 14:00:00', 1),
    (11, 'LEAD-NY-003', 2, 1, '2024-12-28 09:00:00', '2024-12-28 09:00:00', 1),
    
    -- Campaign 3 (Winter Fashion) - 6 leads, 2 converted
    (12, 'LEAD-WIN-001', 3, 4, '2024-11-01 10:00:00', '2024-11-02 15:00:00', 1), -- Converted to Client 5
    (13, 'LEAD-WIN-002', 3, 4, '2024-11-05 11:00:00', '2024-11-10 16:00:00', 1), -- Converted to Client 6
    (14, 'LEAD-WIN-003', 3, 3, '2024-11-08 09:00:00', '2024-11-15 10:00:00', 1), -- Qualified
    (15, 'LEAD-WIN-004', 3, 2, '2024-11-12 14:00:00', '2024-11-20 11:00:00', 1), -- Contacted
    (16, 'LEAD-WIN-005', 3, 5, '2024-11-15 10:00:00', '2024-11-25 09:00:00', 1), -- Lost
    (17, 'LEAD-WIN-006', 3, 1, '2024-11-20 12:00:00', '2024-11-20 12:00:00', 1), -- New
    
    -- Campaign 4 (New Year Wellness) - 4 leads, 1 converted
    (18, 'LEAD-NYW-001', 4, 4, '2024-12-15 08:00:00', '2024-12-16 14:00:00', 1), -- Converted to Client 7
    (19, 'LEAD-NYW-002', 4, 3, '2024-12-16 10:00:00', '2024-12-18 15:00:00', 1), -- Qualified
    (20, 'LEAD-NYW-003', 4, 2, '2024-12-18 09:00:00', '2024-12-20 11:00:00', 1), -- Contacted
    (21, 'LEAD-NYW-004', 4, 1, '2024-12-20 14:00:00', '2024-12-20 14:00:00', 1)  -- New
SET IDENTITY_INSERT [dbo].[PCRLeads] OFF

-- Features de Leads
INSERT INTO [dbo].[PCRFeaturesPerLeads] ([IdLead], [IdFeatureType], [FeatureValue], [CreatedAt], [UpdatedAt], [Enabled])
VALUES 
    -- Lead 5 (Qualified)
    (5, 1, '25-35', '2024-11-21', '2024-11-21', 1),
    (5, 4, 'Gaming', '2024-11-21', '2024-11-21', 1),
    
    -- Lead 14 (Qualified)
    (14, 1, '30-40', '2024-11-08', '2024-11-08', 1),
    (14, 2, 'Female', '2024-11-08', '2024-11-08', 1),
    (14, 4, 'Fashion', '2024-11-08', '2024-11-08', 1),
    
    -- Lead 19 (Qualified)
    (19, 1, '40-50', '2024-12-16', '2024-12-16', 1),
    (19, 4, 'Fitness', '2024-12-16', '2024-12-16', 1)

-- 6. Eventos

SET IDENTITY_INSERT [dbo].[PCREvents] ON
INSERT INTO [dbo].[PCREvents] ([IdEvent], [IdEventType], [IdEventSources], [IdEventMedium], [EventRefID], [EventDate], [CreatedAt], [UpdatedAt], [IdLead])
VALUES 
    -- Lead 1 (Converted)
    (1, 1, 2, 1, 'EV-001', '2024-11-20 09:00:00', '2024-11-20 09:00:00', '2024-11-20 09:00:00', 1),
    (2, 2, 2, 1, 'EV-002', '2024-11-20 09:15:00', '2024-11-20 09:15:00', '2024-11-20 09:15:00', 1),
    (3, 4, 4, 2, 'EV-003', '2024-11-21 10:00:00', '2024-11-21 10:00:00', '2024-11-21 10:00:00', 1),
    (4, 6, 1, 1, 'EV-004', '2024-11-21 15:30:00', '2024-11-21 15:30:00', '2024-11-21 15:30:00', 1),
    
    -- Lead 2 (Converted)
    (5, 1, 3, 1, 'EV-005', '2024-11-20 10:30:00', '2024-11-20 10:30:00', '2024-11-20 10:30:00', 2),
    (6, 3, 1, 1, 'EV-006', '2024-11-20 11:00:00', '2024-11-20 11:00:00', '2024-11-20 11:00:00', 2),
    (7, 4, 4, 2, 'EV-007', '2024-11-21 14:00:00', '2024-11-21 14:00:00', '2024-11-21 14:00:00', 2),
    (8, 6, 1, 1, 'EV-008', '2024-11-21 16:00:00', '2024-11-21 16:00:00', '2024-11-21 16:00:00', 2),
    
    -- Lead 5 (Qualified - multiple interactions)
    (9, 1, 2, 1, 'EV-009', '2024-11-21 12:00:00', '2024-11-21 12:00:00', '2024-11-21 12:00:00', 5),
    (10, 2, 2, 1, 'EV-010', '2024-11-21 12:30:00', '2024-11-21 12:30:00', '2024-11-21 12:30:00', 5),
    (11, 4, 4, 2, 'EV-011', '2024-11-22 15:00:00', '2024-11-22 15:00:00', '2024-11-22 15:00:00', 5),
    (12, 5, 4, 5, 'EV-012', '2024-11-23 09:00:00', '2024-11-23 09:00:00', '2024-11-23 09:00:00', 5),
    
    -- Lead 12 (Converted - Fashion)
    (13, 1, 3, 1, 'EV-013', '2024-11-01 10:00:00', '2024-11-01 10:00:00', '2024-11-01 10:00:00', 12),
    (14, 4, 4, 2, 'EV-014', '2024-11-01 16:00:00', '2024-11-01 16:00:00', '2024-11-01 16:00:00', 12),
    (15, 6, 1, 1, 'EV-015', '2024-11-02 15:00:00', '2024-11-02 15:00:00', '2024-11-02 15:00:00', 12),
    
    -- Lead 18 (Converted - Wellness)
    (16, 1, 2, 1, 'EV-016', '2024-12-15 08:00:00', '2024-12-15 08:00:00', '2024-12-15 08:00:00', 18),
    (17, 2, 2, 1, 'EV-017', '2024-12-15 08:30:00', '2024-12-15 08:30:00', '2024-12-15 08:30:00', 18),
    (18, 4, 4, 2, 'EV-018', '2024-12-16 10:00:00', '2024-12-16 10:00:00', '2024-12-16 10:00:00', 18),
    (19, 6, 1, 1, 'EV-019', '2024-12-16 14:00:00', '2024-12-16 14:00:00', '2024-12-16 14:00:00', 18)
SET IDENTITY_INSERT [dbo].[PCREvents] OFF

-- 7. Ventas

SET IDENTITY_INSERT [dbo].[PCRSalesHistory] ON
INSERT INTO [dbo].[PCRSalesHistory] ([IdSale], [IdClient], [SaleTotal], [CreatedAt], [UpdatedAt], [Checksum])
VALUES 
    -- Client 1 (from Campaign 1)
    (1, 1, 1250.00, '2024-11-21 15:30:00', '2024-11-21 15:30:00', 12345),
    
    -- Client 2 (from Campaign 1)
    (2, 2, 890.00, '2024-11-21 16:00:00', '2024-11-21 16:00:00', 23456),
    
    -- Client 3 (from Campaign 1)
    (3, 3, 2100.00, '2024-11-22 10:00:00', '2024-11-22 10:00:00', 34567),
    
    -- Client 4 (from Campaign 1)
    (4, 4, 750.00, '2024-11-23 11:00:00', '2024-11-23 11:00:00', 45678),
    
    -- Client 5 (from Campaign 3)
    (5, 5, 450.00, '2024-11-02 15:00:00', '2024-11-02 15:00:00', 56789),
    
    -- Client 6 (from Campaign 3)
    (6, 6, 680.00, '2024-11-10 16:00:00', '2024-11-10 16:00:00', 67890),
    
    -- Client 7 (from Campaign 4)
    (7, 7, 320.00, '2024-12-16 14:00:00', '2024-12-16 14:00:00', 78901)
SET IDENTITY_INSERT [dbo].[PCRSalesHistory] OFF

GO

-- Verificar datos
SELECT 
    org.OrganizationName,
    camp.CampaignCode,
    COUNT(DISTINCT l.IdLead) AS TotalLeads,
    COUNT(DISTINCT CASE WHEN l.IdStatus = 4 THEN l.IdLead END) AS ConvertedLeads,
    COUNT(DISTINCT cli.IdClient) AS TotalClients,
    ISNULL(SUM(s.SaleTotal), 0) AS TotalRevenue
FROM [dbo].[PCRCampaigns] camp
INNER JOIN [dbo].[PCROrganizations] org ON camp.IdOrganization = org.IdOrganization
LEFT JOIN [dbo].[PCRLeads] l ON camp.IdCampaign = l.IdCampaign
LEFT JOIN [dbo].[PCRClientsPerCampaigns] cpc ON camp.IdCampaign = cpc.IdCampaign
LEFT JOIN [dbo].[PCRClients] cli ON cpc.IdClient = cli.IdClient
LEFT JOIN [dbo].[PCRSalesHistory] s ON cli.IdClient = s.IdClient
GROUP BY org.OrganizationName, camp.CampaignCode
ORDER BY org.OrganizationName, camp.CampaignCode

GO