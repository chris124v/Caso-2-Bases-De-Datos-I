use promptads;

GO
CREATE OR ALTER FUNCTION [dbo].PA_FNPercentageDiff(@IdPublishedAd BIGINT)
RETURNS DECIMAL(16,2)
BEGIN
	
	DECLARE @Percentage DECIMAL(16,2)	-- Percentages might excede a 100%
	DECLARE @IdLastPerformance BIGINT
	DECLARE @IdNewPerformance BIGINT
	DECLARE @LastReactionValue BIGINT
	DECLARE @NewReactionValue BIGINT

	SELECT @IdLastPerformance = IdLastAdPerformance, @IdNewPerformance = IdAdPerformance
	FROM PAAdPerformances
	WHERE isCurrent = 1 AND IdPublishedAd = @IdPublishedAd

	SELECT @LastReactionValue = SUM(r.reactionNumber * t.reactionWeight)
	FROM PAReactionsPerAd r
	INNER JOIN PAReactionTypes t ON t.IdReactionType = r.IdReactionType
	WHERE r.IdAdPerformance = @IdLastPerformance

	SELECT @NewReactionValue = SUM(r.reactionNumber * t.reactionWeight)
	FROM PAReactionsPerAd r
	INNER JOIN PAReactionTypes t ON t.IdReactionType = r.IdReactionType
	WHERE r.IdAdPerformance = @IdNewPerformance

	-- Simulates a prior performance to compare to
	-- SET @LastReactionValue = -2000040

	-- Formula to get the percentage difference
	SET @Percentage = COALESCE(((@NewReactionValue - @LastReactionValue) / ABS(@LastReactionValue)) * 100, 100.00)
	
	RETURN @Percentage
END


GO
CREATE OR ALTER PROCEDURE [dbo].[PA_SPCheckNegativeAds]
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
	SELECT fc.CampaignName, ca.title AS AdTitle, fc.startsAt AS StartingDate, fc.endsAt AS EndDate, ci.Influencer, ch.name AS Channel, 
		na.name AS Sentiment, [dbo].PA_FNPercentageDiff(na.IdPublishedAd) AS DropPercentage
	FROM FilteredCampaigns fc
	INNER JOIN PACampaignAds ca ON ca.IdCampaign = fc.IdCampaign
	INNER JOIN ChannelInformation ci ON ca.IdCampaignAd = ci.IdCampaignAd
	INNER JOIN PAChannels ch ON ch.IdChannel = ci.IdChannel
	INNER JOIN NegativeAds na ON na.IdPublishedAd = ci.IdPublishedAd
	ORDER BY fc.IdCampaign		-- We group by same campaign
	
END
RETURN 0
GO

EXEC dbo.PA_SPCheckNegativeAds '2025-02-05', '2026-02-05'
