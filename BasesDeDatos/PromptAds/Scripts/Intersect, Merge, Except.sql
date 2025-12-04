<<<<<<< HEAD
use promptads;

-- EXCEPT: Using the already made SP for negative campaigns, we make a procedure to get positive campaigns
GO
CREATE OR ALTER PROCEDURE [dbo].[PA_SPCheckPositiveAds]
    @startDate DATE,
	@endDate DATE
AS 
BEGIN
	
	SET NOCOUNT ON;

	-- We use a CTE to reduce the range of elegible campaigns
	WITH FilteredCampaigns AS
	(
		SELECT c.IdCampaign, c.name AS CampaignName,c.startsAt,c.endsAt
		FROM PACampaigns c
		WHERE c.startsAt > @startDate AND c.endsAt < @endDate
	),
	NegativeAds AS
	(
		SELECT ap.IdPublishedAd, s.name, ap.isCurrent
		FROM PAAdPerformances ap
		INNER JOIN PAAdSentiments s ON s.IdAdSentiment = ap.IdAdSentiment
		WHERE s.name IN ('Hostile', 'Negative') AND ap.isCurrent = 1
	),
	ChannelInformation AS
	(
		SELECT pa.IdPublishedAd, pa.IdCampaignAd, oc.value AS OrganizationContact, ic.value AS InfluencerContact, COALESCE(i.username, 'NO') AS Influencer, COALESCE(oc.IdChannel, ic.IdChannel) AS IdChannel
		FROM PAPublishedAds pa
		LEFT JOIN PAOrganizationContacts oc ON oc.IdOrganizationContact = pa.IdOrganizationContact
		LEFT JOIN PAInfluencerContacts ic ON ic.IdInfluencerContact = pa.IdInfluencerContact
		LEFT JOIN PAInfluencers i ON i.IdInfluencer = ic.IdInfluencer
		WHERE COALESCE(oc.IdChannel, ic.IdChannel) IS NOT NULL
	)
	-- This select gets all performances from all ads
	SELECT fc.CampaignName, ca.title AS AdTitle, fc.startsAt AS StartingDate, fc.endsAt AS EndDate, ci.Influencer, ch.name AS Channel, s.name AS Sentiment
	FROM FilteredCampaigns fc
	INNER JOIN PACampaignAds ca ON ca.IdCampaign = fc.IdCampaign
	INNER JOIN ChannelInformation ci ON ca.IdCampaignAd = ci.IdCampaignAd
	INNER JOIN PAChannels ch ON ch.IdChannel = ci.IdChannel
	INNER JOIN PAAdPerformances ap ON ap.IdPublishedAd = ci.IdPublishedAd
	INNER JOIN PAAdSentiments s ON s.IdAdSentiment = ap.IdAdSentiment
	WHERE ap.isCurrent = 1
	
	EXCEPT
	-- This select gets performances with the CTE for NegativeAds
	SELECT fc.CampaignName, ca.title AS AdTitle, fc.startsAt AS StartingDate, fc.endsAt AS EndDate, ci.Influencer, ch.name AS Channel, na.name AS Sentiment
	FROM FilteredCampaigns fc
	INNER JOIN PACampaignAds ca ON ca.IdCampaign = fc.IdCampaign
	INNER JOIN ChannelInformation ci ON ca.IdCampaignAd = ci.IdCampaignAd
	INNER JOIN PAChannels ch ON ch.IdChannel = ci.IdChannel
	INNER JOIN NegativeAds na ON na.IdPublishedAd = ci.IdPublishedAd
	ORDER BY fc.CampaignName		-- We group by same campaign
	
END
RETURN 0
GO

EXEC dbo.PA_SPCheckPositiveAds '2025-02-05', '2026-02-05'

-- ****************************

/*
INSERT INTO PAInfluencers (username, followers, bio) VALUES
('Influencer 1', 100000, 'bio')
INSERT INTO PAInfluencerContacts (IdInfluencer, IdChannel, value) VALUES
(1, 1, 'contacto unico de influencer')


INSERT INTO PAInfluencerContacts (IdInfluencer, IdChannel, value)
SELECT 1, o.IdChannel, o.value
FROM PAOrganizationContacts o
WHERE IdOrganizationCOntact = 220
*/

-- INTERSECT: With this, we can check overlapping contacts that are both from an influencer and an organization
SELECT [value], IdChannel
FROM PAOrganizationContacts oc

INTERSECT

SELECT [value], IdChannel
FROM PAInfluencerContacts ic

-- ****************************

-- Merge: Use it to perform operations depending on matches between tables

MERGE INTO PAInfluencerContacts AS [Target]
USING (
	SELECT [value], IdChannel
	FROM PAOrganizationContacts
) AS Base
ON Base.[value] = [Target].[value] AND Base.IdChannel = [Target].IdChannel
WHEN MATCHED THEN
    DELETE;

SELECT [value], IdChannel
=======
use promptads;

-- EXCEPT: Using the already made SP for negative campaigns, we make a procedure to get positive campaigns
GO
CREATE OR ALTER PROCEDURE [dbo].[PA_SPCheckPositiveAds]
    @startDate DATE,
	@endDate DATE
AS 
BEGIN
	
	SET NOCOUNT ON;

	-- We use a CTE to reduce the range of elegible campaigns
	WITH FilteredCampaigns AS
	(
		SELECT c.IdCampaign, c.name AS CampaignName,c.startsAt,c.endsAt
		FROM PACampaigns c
		WHERE c.startsAt > @startDate AND c.endsAt < @endDate
	),
	NegativeAds AS
	(
		SELECT ap.IdPublishedAd, s.name, ap.isCurrent
		FROM PAAdPerformances ap
		INNER JOIN PAAdSentiments s ON s.IdAdSentiment = ap.IdAdSentiment
		WHERE s.name IN ('Hostile', 'Negative') AND ap.isCurrent = 1
	),
	ChannelInformation AS
	(
		SELECT pa.IdPublishedAd, pa.IdCampaignAd, oc.value AS OrganizationContact, ic.value AS InfluencerContact, COALESCE(i.username, 'NO') AS Influencer, COALESCE(oc.IdChannel, ic.IdChannel) AS IdChannel
		FROM PAPublishedAds pa
		LEFT JOIN PAOrganizationContacts oc ON oc.IdOrganizationContact = pa.IdOrganizationContact
		LEFT JOIN PAInfluencerContacts ic ON ic.IdInfluencerContact = pa.IdInfluencerContact
		LEFT JOIN PAInfluencers i ON i.IdInfluencer = ic.IdInfluencer
		WHERE COALESCE(oc.IdChannel, ic.IdChannel) IS NOT NULL
	)
	-- This select gets all performances from all ads
	SELECT fc.CampaignName, ca.title AS AdTitle, fc.startsAt AS StartingDate, fc.endsAt AS EndDate, ci.Influencer, ch.name AS Channel, s.name AS Sentiment
	FROM FilteredCampaigns fc
	INNER JOIN PACampaignAds ca ON ca.IdCampaign = fc.IdCampaign
	INNER JOIN ChannelInformation ci ON ca.IdCampaignAd = ci.IdCampaignAd
	INNER JOIN PAChannels ch ON ch.IdChannel = ci.IdChannel
	INNER JOIN PAAdPerformances ap ON ap.IdPublishedAd = ci.IdPublishedAd
	INNER JOIN PAAdSentiments s ON s.IdAdSentiment = ap.IdAdSentiment
	WHERE ap.isCurrent = 1
	
	EXCEPT
	-- This select gets performances with the CTE for NegativeAds
	SELECT fc.CampaignName, ca.title AS AdTitle, fc.startsAt AS StartingDate, fc.endsAt AS EndDate, ci.Influencer, ch.name AS Channel, na.name AS Sentiment
	FROM FilteredCampaigns fc
	INNER JOIN PACampaignAds ca ON ca.IdCampaign = fc.IdCampaign
	INNER JOIN ChannelInformation ci ON ca.IdCampaignAd = ci.IdCampaignAd
	INNER JOIN PAChannels ch ON ch.IdChannel = ci.IdChannel
	INNER JOIN NegativeAds na ON na.IdPublishedAd = ci.IdPublishedAd
	ORDER BY fc.CampaignName		-- We group by same campaign
	
END
RETURN 0
GO

EXEC dbo.PA_SPCheckPositiveAds '2025-02-05', '2026-02-05'

-- ****************************

/*
INSERT INTO PAInfluencers (username, followers, bio) VALUES
('Influencer 1', 100000, 'bio')
INSERT INTO PAInfluencerContacts (IdInfluencer, IdChannel, value) VALUES
(1, 1, 'contacto unico de influencer')


INSERT INTO PAInfluencerContacts (IdInfluencer, IdChannel, value)
SELECT 1, o.IdChannel, o.value
FROM PAOrganizationContacts o
WHERE IdOrganizationCOntact = 220
*/

-- INTERSECT: With this, we can check overlapping contacts that are both from an influencer and an organization
SELECT [value], IdChannel
FROM PAOrganizationContacts oc

INTERSECT

SELECT [value], IdChannel
FROM PAInfluencerContacts ic

-- ****************************

-- Merge: Use it to perform operations depending on matches between tables

MERGE INTO PAInfluencerContacts AS [Target]
USING (
	SELECT [value], IdChannel
	FROM PAOrganizationContacts
) AS Base
ON Base.[value] = [Target].[value] AND Base.IdChannel = [Target].IdChannel
WHEN MATCHED THEN
    DELETE;

SELECT [value], IdChannel
>>>>>>> 936362de32185c7094e234121e57c23fafd0b2c7
FROM PAInfluencerContacts ic