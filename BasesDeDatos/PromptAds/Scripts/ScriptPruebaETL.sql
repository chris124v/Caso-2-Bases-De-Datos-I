USE [promptads]
GO

-- Script de Llenado de Datos de Prueba - PromptAds
-- VERSIÓN FINAL CORREGIDA - Todas las estructuras verificadas


-- 1. Catalagos Base

select * from PACountries;

-- Países
SET IDENTITY_INSERT [dbo].[PACountries] ON
INSERT INTO [dbo].[PACountries] ([IdCountry], [name])
VALUES 
    (1, 'United States'),
    (2, 'Costa Rica'),
    (3, 'Mexico')
SET IDENTITY_INSERT [dbo].[PACountries] OFF

-- Estados
SET IDENTITY_INSERT [dbo].[PAStates] ON
INSERT INTO [dbo].[PAStates] ([IdState], [name], [IdCountry])
VALUES 
    (1, 'New York', 1),
    (2, 'California', 1),
    (3, 'San José', 2),
    (4, 'Jalisco', 3)
SET IDENTITY_INSERT [dbo].[PAStates] OFF

-- Ciudades
SET IDENTITY_INSERT [dbo].[PACities] ON
INSERT INTO [dbo].[PACities] ([IdCity], [name], [IdState])
VALUES 
    (1, 'New York City', 1),
    (2, 'Los Angeles', 2),
    (3, 'Cartago', 3),
    (4, 'Guadalajara', 4)
SET IDENTITY_INSERT [dbo].[PACities] OFF

-- Monedas
SET IDENTITY_INSERT [dbo].[PACurrencies] ON
INSERT INTO [dbo].[PACurrencies] ([IdCurrency], [name], [isoCode], [currencySymbol], [IdCountry])
VALUES 
    (1, 'US Dollar', 'USD', '$', 1),
    (2, 'Costa Rican Colón', 'CRC', '?', 2),
    (3, 'Mexican Peso', 'MXN', '$', 3)
SET IDENTITY_INSERT [dbo].[PACurrencies] OFF

-- Canales
SET IDENTITY_INSERT [dbo].[PAChannels] ON
INSERT INTO [dbo].[PAChannels] ([IdChannel], [name])
VALUES 
    (1, 'Instagram'),
    (2, 'Facebook'),
    (3, 'TikTok'),
    (4, 'LinkedIn'),
    (5, 'YouTube')
SET IDENTITY_INSERT [dbo].[PAChannels] OFF

-- Tipos de Ads
SET IDENTITY_INSERT [dbo].[PAAdTypes] ON
INSERT INTO [dbo].[PAAdTypes] ([IdAdType], [name])
VALUES 
    (1, 'Image'),
    (2, 'Video'),
    (3, 'Carousel')
SET IDENTITY_INSERT [dbo].[PAAdTypes] OFF

-- Status de Ads
SET IDENTITY_INSERT [dbo].[PAAdStatus] ON
INSERT INTO [dbo].[PAAdStatus] ([IdAdStatus], [name])
VALUES 
    (1, 'Draft'),
    (2, 'Scheduled'),
    (3, 'Active'),
    (4, 'Paused'),
    (5, 'Completed')
SET IDENTITY_INSERT [dbo].[PAAdStatus] OFF

-- Sentimientos
SET IDENTITY_INSERT [dbo].[PAAdSentiments] ON
INSERT INTO [dbo].[PAAdSentiments] ([IdAdSentiment], [name])
VALUES 
    (1, 'Very Positive'),
    (2, 'Positive'),
    (3, 'Neutral'),
    (4, 'Negative')
SET IDENTITY_INSERT [dbo].[PAAdSentiments] OFF

-- Tipos de Reacciones
SET IDENTITY_INSERT [dbo].[PAReactionTypes] ON
INSERT INTO [dbo].[PAReactionTypes] ([IdReactionType], [name])
VALUES 
    (1, 'Like'),
    (2, 'Love'),
    (3, 'Comment'),
    (4, 'Share'),
    (5, 'View'),
    (6, 'Click')
SET IDENTITY_INSERT [dbo].[PAReactionTypes] OFF

select * from PAReactionTypes;

-- Status de Organizaciones
SET IDENTITY_INSERT [dbo].[PAOrganizationStatus] ON
INSERT INTO [dbo].[PAOrganizationStatus] ([IdOrganizationStatus], [name])
VALUES 
    (1, 'Active'),
    (2, 'Inactive')
SET IDENTITY_INSERT [dbo].[PAOrganizationStatus] OFF


-- 2. Organizaciones

SET IDENTITY_INSERT [dbo].[PAOrganizations] ON
INSERT INTO [dbo].[PAOrganizations] ([IdOrganization], [name], [organizationStatus], [createdAt])
VALUES 
    (1, 'TechGadgets Inc', 1, '2024-07-01'),
    (2, 'FashionHub Store', 1, '2024-08-15'),
    (3, 'HealthyLife Products', 1, '2024-09-10')
SET IDENTITY_INSERT [dbo].[PAOrganizations] OFF

select * from PAOrganizations;

-- Contactos de Organizaciones
-- Columnas reales: IdOrganizationContact, IdOrganization, IdChannel, value, createdAt, enabled, deleted
SET IDENTITY_INSERT [dbo].[PAOrganizationContacts] ON
INSERT INTO [dbo].[PAOrganizationContacts] ([IdOrganizationContact], [IdOrganization], [IdChannel], [value], [createdAt], [enabled], [deleted])
VALUES 
    (1, 1, 1, '@techgadgets', '2024-07-01', 1, 0),
    (2, 1, 2, 'techgadgets.official', '2024-07-01', 1, 0),
    (3, 2, 1, '@fashionhub', '2024-08-15', 1, 0),
    (4, 2, 3, '@fashionhub_tiktok', '2024-08-15', 1, 0),
    (5, 3, 2, 'healthylifeproducts', '2024-09-10', 1, 0),
    (6, 3, 5, 'HealthyLifeTV', '2024-09-10', 1, 0)
SET IDENTITY_INSERT [dbo].[PAOrganizationContacts] OFF

-- 3. Influencers

-- Columnas reales: IdInfluencer, username, followers, bio
SET IDENTITY_INSERT [dbo].[PAInfluencers] ON
INSERT INTO [dbo].[PAInfluencers] ([IdInfluencer], [username], [followers], [bio])
VALUES 
    (1, 'TechMaria', 250000, 'Tech reviewer and gadget enthusiast'),
    (2, 'StyleCarlos', 180000, 'Fashion influencer from Mexico'),
    (3, 'FitAna', 150000, 'Health and wellness coach')
SET IDENTITY_INSERT [dbo].[PAInfluencers] OFF

-- Contactos de Influencers
-- Columnas reales: IdInfluencerContact, IdInfluencer, IdChannel, value, createdAt, enabled, deleted
SET IDENTITY_INSERT [dbo].[PAInfluencerContacts] ON
INSERT INTO [dbo].[PAInfluencerContacts] ([IdInfluencerContact], [IdInfluencer], [IdChannel], [value], [createdAt], [enabled], [deleted])
VALUES 
    (1, 1, 1, '@techmaria_official', '2024-06-01', 1, 0),
    (2, 1, 5, 'TechMaria_Reviews', '2024-06-01', 1, 0),
    (3, 2, 1, '@stylecarlos', '2024-06-15', 1, 0),
    (4, 2, 3, '@stylecarlos_tiktok', '2024-06-15', 1, 0),
    (5, 3, 1, '@fitana_cr', '2024-07-01', 1, 0),
    (6, 3, 2, 'FitAna.Page', '2024-07-01', 1, 0)
SET IDENTITY_INSERT [dbo].[PAInfluencerContacts] OFF


-- 4. Campanas

SET IDENTITY_INSERT [dbo].[PACampaigns] ON
INSERT INTO [dbo].[PACampaigns] ([IdCampaign], [IdOrganization], [name], [description], [createdAt], [updatedAt], [endsAt], [enabled], [deleted], [checksum])
VALUES 
    (1, 1, 'Black Friday 2024', 'Promoción de gadgets tecnológicos para Black Friday', '2024-10-15', NULL, '2024-11-30', 1, 0, NULL),
    (2, 1, 'New Year Tech Deals', 'Ofertas de año nuevo en tecnología', '2024-11-20', NULL, '2025-01-15', 1, 0, NULL),
    (3, 2, 'Winter Collection 2024', 'Lanzamiento de colección de invierno', '2024-10-01', NULL, '2024-12-31', 1, 0, NULL),
    (4, 3, 'New Year Wellness', 'Productos para año nuevo saludable', '2024-11-25', NULL, '2025-01-31', 1, 0, NULL)
SET IDENTITY_INSERT [dbo].[PACampaigns] OFF

select * from PACampaigns;

-- 5. CAMPAIGN ADS

SET IDENTITY_INSERT [dbo].[PACampaignAds] ON
INSERT INTO [dbo].[PACampaignAds] ([IdCampaignAd], [IdCampaign], [title], [description], [IdAdType], [createdAt], [updatedAt], [checksum])
VALUES 
    (1, 1, 'Smartwatch Deal', 'Get 40% off on premium smartwatches', 1, '2024-10-16', NULL, NULL),
    (2, 1, 'Laptop Promo Video', 'Ultra-thin laptops at unbeatable prices', 2, '2024-10-16', NULL, NULL),
    (3, 1, 'Earbuds Special', 'Wireless earbuds - Limited time offer', 1, '2024-10-17', NULL, NULL),
    (4, 2, 'New Year Bundle', 'Start 2025 with the latest tech', 3, '2024-11-21', NULL, NULL),
    (5, 3, 'Winter Jackets', 'Stay warm with our new collection', 1, '2024-10-02', NULL, NULL),
    (6, 3, 'Fashion Show', 'Behind the scenes of our winter line', 2, '2024-10-05', NULL, NULL),
    (7, 4, 'Vitamins Bundle', 'Start your health journey today', 1, '2024-11-26', NULL, NULL)
SET IDENTITY_INSERT [dbo].[PACampaignAds] OFF

-- 6. PUBLISHED ADS

SET IDENTITY_INSERT [dbo].[PAPublishedAds] ON
INSERT INTO [dbo].[PAPublishedAds] ([IdPublishedAd], [IdCampaignAd], [IdOrganizationContact], [IdInfluencerContact], [body], [redirectURL], [createdAt], [updatedAt], [IdAdStatus])
VALUES 
    (1, 1, 1, NULL, 'Check out our amazing smartwatch deals!', 'https://techgadgets.com/smartwatch', '2024-11-20 08:00:00', NULL, 3),
    (2, 1, 2, 1, 'Premium smartwatches at incredible prices', 'https://techgadgets.com/smartwatch', '2024-11-20 09:00:00', NULL, 3),
    (3, 2, 1, 2, 'Best laptop deals of the year', 'https://techgadgets.com/laptops', '2024-11-21 10:00:00', '2024-11-27 23:59:59', 5),
    (4, 3, 2, NULL, 'Wireless earbuds - Limited offer', 'https://techgadgets.com/earbuds', '2024-11-22 07:00:00', NULL, 3),
    (5, 5, 3, 3, 'Winter fashion collection 2024', 'https://fashionhub.com/winter', '2024-11-01 06:00:00', '2024-11-30 23:59:59', 5),
    (6, 5, 4, NULL, 'Stay stylish this winter', 'https://fashionhub.com/winter', '2024-11-05 08:00:00', NULL, 3),
    (7, 7, 5, 5, 'Start your wellness journey', 'https://healthylife.com/vitamins', '2024-12-15 07:00:00', NULL, 3)
SET IDENTITY_INSERT [dbo].[PAPublishedAds] OFF

-- 7. Ad Performances

SET IDENTITY_INSERT [dbo].[PAAdPerformances] ON
INSERT INTO [dbo].[PAAdPerformances] ([IdAdPerformance], [IdPublishedAd], [budget], [expenses], [revenue], [IdAdSentiment], [createdAt], [IdLastAdPerformance], [isCurrent])
VALUES 
    (1, 1, 5000.00, 4200.00, 12500.00, 2, '2024-11-20 08:00:00', NULL, 0),
    (2, 1, 5000.00, 4500.00, 15800.00, 1, '2024-11-25 10:00:00', 1, 1),
    (3, 2, 8000.00, 7200.00, 22000.00, 2, '2024-11-20 09:00:00', NULL, 0),
    (4, 2, 8000.00, 7800.00, 28500.00, 1, '2024-11-26 12:00:00', 3, 1),
    (5, 3, 6000.00, 5900.00, 18200.00, 2, '2024-11-20 08:00:00', NULL, 0),
    (6, 3, 6000.00, 5950.00, 19500.00, 2, '2024-11-27 23:59:59', 5, 1),
    (7, 4, 4000.00, 3600.00, 10200.00, 2, '2024-11-22 07:00:00', NULL, 1),
    (8, 5, 10000.00, 9800.00, 35000.00, 1, '2024-11-01 06:00:00', NULL, 0),
    (9, 5, 10000.00, 9950.00, 38500.00, 1, '2024-11-30 23:59:59', 8, 1),
    (10, 6, 7000.00, 6200.00, 21000.00, 2, '2024-11-05 08:00:00', NULL, 1),
    (11, 7, 6000.00, 4800.00, 14000.00, 2, '2024-12-15 07:00:00', NULL, 1)
SET IDENTITY_INSERT [dbo].[PAAdPerformances] OFF

-- 8. REACCIONES

SET IDENTITY_INSERT [dbo].[PAReactionsPerAd] ON
INSERT INTO [dbo].[PAReactionsPerAd] ([IdReaction], [IdAdPerformance], [IdReactionType], [reactionNumber])
VALUES 
    -- Performance 2 (Smartwatch Current)
    (1, 2, 1, 1250), -- Likes
    (2, 2, 2, 320),  -- Loves
    (3, 2, 3, 185),  -- Comments
    (4, 2, 4, 95),   -- Shares
    (5, 2, 5, 8500), -- Views
    (6, 2, 6, 520),  -- Clicks
    
    -- Performance 4 (Smartwatch + Influencer)
    (7, 4, 1, 2100),
    (8, 4, 2, 580),
    (9, 4, 3, 340),
    (10, 4, 4, 210),
    (11, 4, 5, 15000),
    (12, 4, 6, 890),
    
    -- Performance 6 (Laptop Final)
    (13, 6, 1, 1800),
    (14, 6, 2, 420),
    (15, 6, 3, 225),
    (16, 6, 5, 12000),
    (17, 6, 6, 650),
    
    -- Performance 7 (Earbuds)
    (18, 7, 1, 980),
    (19, 7, 2, 240),
    (20, 7, 5, 6800),
    (21, 7, 6, 410),
    
    -- Performance 9 (Winter Final)
    (22, 9, 1, 3500),
    (23, 9, 2, 890),
    (24, 9, 3, 520),
    (25, 9, 4, 380),
    (26, 9, 5, 25000),
    (27, 9, 6, 1450),
    
    -- Performance 10 (Winter TikTok)
    (28, 10, 1, 2800),
    (29, 10, 2, 650),
    (30, 10, 3, 380),
    (31, 10, 5, 18000),
    
    -- Performance 11 (Vitamins)
    (32, 11, 1, 1100),
    (33, 11, 2, 280),
    (34, 11, 3, 150),
    (35, 11, 5, 9000),
    (36, 11, 6, 520)
SET IDENTITY_INSERT [dbo].[PAReactionsPerAd] OFF

select * from PAAdPerformances;

GO


-- Verificacion con un select
SELECT 
    o.name AS Organization,
    c.name AS Campaign,
    ca.title AS Ad_Title,
    pa.IdPublishedAd,
    st.name AS Status,
    perf.budget,
    perf.revenue
FROM [dbo].[PAPublishedAds] pa
INNER JOIN [dbo].[PACampaignAds] ca ON pa.IdCampaignAd = ca.IdCampaignAd
INNER JOIN [dbo].[PACampaigns] c ON ca.IdCampaign = c.IdCampaign
INNER JOIN [dbo].[PAOrganizations] o ON c.IdOrganization = o.IdOrganization
INNER JOIN [dbo].[PAAdStatus] st ON pa.IdAdStatus = st.IdAdStatus
LEFT JOIN (
    SELECT IdPublishedAd, budget, revenue
    FROM [dbo].[PAAdPerformances]
    WHERE isCurrent = 1
) perf ON pa.IdPublishedAd = perf.IdPublishedAd
ORDER BY o.name, c.name

GO
