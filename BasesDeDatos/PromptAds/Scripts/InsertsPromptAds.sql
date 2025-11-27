use promptads;

-- ********************************
--    NON ALGORITHMICAL INSERTS
-- ********************************

INSERT INTO PACampaignStatus (name) VALUES 
('Active'),
('Paused'),
('Finished');

INSERT INTO PAOrganizationStatus (name) VALUES
('Verified'),
('Pending_Verification'),
('Disabled');

INSERT INTO PAChannels (name) VALUES 
('Facebook'),
('WhatsApp'),
('Instagram'),
('YouTube'),
('Twitch'),
('X'),
('TikTok'),
('LinkedIn'),
('Gmail'),
('SMS');

INSERT INTO PAAdSentiments (name) VALUES 
('Overwhelmingly_Positive'),
('Mildly_Positive'),
('Neutral'),
('Negative'),
('Hostile');

INSERT INTO PAReactionTypes (name, reactionWeight) VALUES
('Views',1),
('Message_Received',1),
('Likes',3),
('Dislikes',-3),
('Positive_Comments',5),
('Negative_Comments',-5),
('Neutral_Comments',1),
('Shares',3),
('Follows',5),
('Love',5),
('Haha',3),
('Wow',3),
('Sad',-3),
('Angry',-5);

INSERT INTO PAAdTypes (name) VALUES
('Banner'),
('Pop-up'),
('Story'),
('In-feed'),
('Mid-roll');

INSERT INTO PAAdStatus (name) VALUES
('Active'),
('Paused'),
('Cancelled'),
('Finished');

INSERT INTO PACountries (name) VALUES
('United States'),
('Costa Rica');

INSERT INTO PAStates (name, IdCountry) VALUES
('New York',1),
('California',1),
('San Jose',2);

INSERT INTO PACities (name, IdState) VALUES
('New York', 1),
('San Diego',2),
('Escazú',3);

INSERT INTO PAPublicFeatures (name, dataType) VALUES
('age','INT'),
('gender','VARCHAR'),
('occupation','VARCHAR'),
('interests','VARCHAR'),
('frequency_of_purchases_a_month','INT');

INSERT INTO PALogLevels (name) VALUES
('Info'),('Warning'),('Error'),('Critical')

INSERT INTO PALogSources (name) VALUES
('Database'), ('MCP server')

INSERT INTO PALogTypes (name) VALUES
('Login'), ('Logout'), ('Insert campaign')

INSERT INTO PACurrencies (name, isoCode, currencySymbol, IdCountry) VALUES
('US Dollar','USD','$',1),('Costa Rican Colon', 'CRC', '₡',2)

INSERT INTO PAScheduleRecurrencies (name, intervalDays) VALUES
('Daily', 1),('Weekly',7),('Monthly', 30)


GO
-- ********************************
--       CREATE TABLE TYPES
-- ********************************
CREATE TYPE dbo.OrganizationAdjectivesMockup AS TABLE (
	IdOrganizationName INT IDENTITY(1,1) PRIMARY KEY,
	organizationName VARCHAR(30)
)
CREATE TYPE dbo.OrganizationNameMockup AS TABLE (
	IdOrganizationName INT IDENTITY(1,1) PRIMARY KEY,
	organizationName VARCHAR(30)
)
CREATE TYPE dbo.OrganizationLegalNameMockup AS TABLE (
	IdOrganizationName INT IDENTITY(1,1) PRIMARY KEY,
	organizationName VARCHAR(30)
)
CREATE TYPE dbo.CampaignStarterMockup AS TABLE (
	IdCampaignTitle INT IDENTITY(1,1) PRIMARY KEY,
	sentence VARCHAR(30),
	category VARCHAR(30)
)
CREATE TYPE dbo.CampaignAdjectiveProductMockup AS TABLE (
	IdCampaignTitle INT IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(30),
	category VARCHAR(30)
)
CREATE TYPE dbo.CampaignProductMockup AS TABLE (
	IdCampaignTitle INT IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(30),
	category VARCHAR(30)
)
CREATE TYPE dbo.PublicValues AS TABLE (
	IdPublicValue INT IDENTITY(1,1) PRIMARY KEY,
	[value] VARCHAR(80),
	category VARCHAR(30)
)
CREATE TYPE dbo.ChannelReactions AS TABLE (
	channelName VARCHAR(80),
	reactionName VARCHAR(40)
)

-- ********************************
--    STORED PROCEDURE INSERTS
-- ********************************
-- These insert procedures are not a transaction since they only fill the database with test data

-- --------------------------
-- SP Insert Organization Contacts
-- ------------------------
-- SHOWCASE: LOWER and FLOOR
GO
CREATE OR ALTER PROCEDURE dbo.PA_SPInsertOrganizationContacts
	@IdOrganization INT
AS
BEGIN
	SET NOCOUNT ON
	-- ----
	DECLARE @randChannel SMALLINT
	DECLARE @newContact VARCHAR(80)

	DECLARE @numContacts INT
	DECLARE @organizationName VARCHAR(60)
	DECLARE @repeat BIT
	DECLARE @channelName VARCHAR(20)

	DECLARE @i INT = 1
	-- ----

	SELECT @organizationName = name
	FROM PAOrganizations
	WHERE IdOrganization = @IdOrganization

	SELECT @organizationName = REPLACE(@organizationName, ' ', '') -- We change blank spaces to '' 

	-- All organizations will have at least one email
	SELECT @randChannel = IdChannel
	FROM PAChannels
	WHERE name = 'Gmail'
	-- LOWER: Changes text to lowercase, most social media contacts use this format
	SET @newContact = CONCAT(LOWER(@organizationName),CAST(FLOOR((RAND()*8999)+1) AS VARCHAR(8)),'@gmail.com')
	-- Now we insert the new contact
	INSERT INTO PAOrganizationContacts (IdOrganization,IdChannel,[value],createdAt) VALUES
	(@IdOrganization,@randChannel,@newContact,GETDATE())

	-- As extras, we insert from 3 to 8 more contacts
	SET @numContacts = FLOOR(RAND() * 8) + 3

	WHILE @i <= @numContacts
	BEGIN

		-- We select a random channel from the 10 that are in the test data. We use FLOOR to get an INT
		SET @randChannel = FLOOR(RAND() * 10) + 1

		-- We check if there is already a contact on this channel, we use select 1 because we are only focused on finding a match,
		-- and we don't care about the information this row has.
		IF NOT EXISTS (SELECT 1 FROM PAOrganizationContacts WHERE IdChannel = @randChannel AND IdOrganization = @IdOrganization)
		BEGIN

			SELECT @channelName = name
			FROM PAChannels
			WHERE IdChannel = @randChannel

			-- LOWER: Changes text to lowercase, most social media contacts use this format
			SELECT @newContact =
			CASE
				WHEN @channelName = 'Facebook' OR @channelName = 'Instagram' OR @channelName = 'X' OR @channelName = 'TikTok' THEN 
					CONCAT('@', LOWER(@organizationName), '_official')
				WHEN @channelName = 'Whatsapp' OR @channelName = 'SMS' THEN 
					CONCAT('+ 1 ', CAST(FLOOR((RAND()*8999)+1000) AS VARCHAR(10)),' ',CAST(FLOOR((RAND()*8999)+1000) AS VARCHAR(10))) -- We generate a random phone number
				WHEN @channelName = 'Youtube' THEN CONCAT(@organizationName, 'YT')
				WHEN @channelName = 'LinkedIn' THEN CONCAT('linkedin.com/in/', LOWER(@organizationName), '-', 'official')
				ELSE CONCAT(@organizationName, ' OFFICIAL') -- Default contact
			END;

			INSERT INTO PAOrganizationContacts (IdOrganization,IdChannel,[value],createdAt) VALUES
			(@IdOrganization,@randChannel,@newContact,GETDATE())
		END
	
		SET @i = @i + 1
	END
END
-- --------------------------
-- SP Insert Organizations
-- --------------------------
GO
CREATE OR ALTER PROCEDURE dbo.PA_SPInsertOrganizations
	@numInserts INT,
	@organizationAdjectives dbo.OrganizationAdjectivesMockup READONLY,
	@organizationNames dbo.OrganizationNameMockup READONLY,
	@organizationLegalNames dbo.OrganizationLegalNameMockup READONLY
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @IdOrganization INT
	DECLARE @adjective VARCHAR(60)
	DECLARE @name VARCHAR(60)
	DECLARE @legalName VARCHAR(60)
	DECLARE @email VARCHAR(80)
	DECLARE @IdStatus TINYINT

	DECLARE @randNum INT
	DECLARE @maxRowsAdj INT
	DECLARE @maxRowsName INT
	DECLARE @maxRowsLegalName INT
	DECLARE @IdChannel SMALLINT

	DECLARE @i INT = 1
	-- ---------
	SELECT @maxRowsAdj = COUNT(1) 
	FROM @organizationAdjectives;

	SELECT @maxRowsName = COUNT(1) 
	FROM @organizationNames;

	SELECT @maxRowsLegalName = COUNT(1) 
	FROM @organizationLegalNames

	SELECT @IdChannel = IdChannel 
	FROM PAChannels
	WHERE name = 'Gmail'

	WHILE @i <= @numInserts		-- We insert as many organizations as indicated by the call
	BEGIN
		
		-- We select a random adjective, name, and legal termination for the name of our organization
		SET @randNum = FLOOR(RAND() * @maxRowsAdj) + 1
		SELECT @adjective = organizationName
		FROM @organizationAdjectives
		WHERE IdOrganizationName = @randNum

		SET @randNum = FLOOR(RAND() * @maxRowsName) + 1
		SELECT @name = organizationName
		FROM @organizationNames
		WHERE IdOrganizationName = @randNum

		SET @randNum = FLOOR(RAND() * @maxRowsLegalname) + 1
		SELECT @legalName = organizationName
		FROM @organizationLegalNames
		WHERE IdOrganizationName = @randNum

		-- We choose a random number between 1 and 20 to make the chances of Status = Active better
		SET @randNum = FLOOR(RAND() * 20) + 1
		SELECT @IdStatus =
		CASE
			WHEN @randNum = 1 THEN 2
			WHEN @randNum = 2 THEN 3
			ELSE 1
		END;

		INSERT INTO PAOrganizations (name, legalName, createdAt, IdOrganizationStatus) VALUES
		(CONCAT(@adjective, ' ', @name), CONCAT(@adjective, ' ', @name, ' ', @legalName),GETDATE(),@IdStatus)

		SELECT @IdOrganization = SCOPE_IDENTITY() -- We retrieve the last inserted

		EXEC dbo.PA_SPInsertOrganizationContacts @IdOrganization;

		SELECT @email = [value]
		FROM PAOrganizationContacts
		WHERE IdOrganization = @IdOrganization AND IdChannel = @IdChannel

		UPDATE PAOrganizations 
		SET email = @email
		WHERE IdOrganization = @IdOrganization

		SET @i = @i + 1
	END
END
-- --------------------------
-- SP Insert Public Values
-- --------------------------
GO
CREATE OR ALTER PROCEDURE dbo.PA_SPInsertPublicValues
	@PublicValue dbo.PublicValues READONLY
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @IdPublicFeature SMALLINT
	DECLARE @name VARCHAR(30)
	DECLARE @minValue VARCHAR(80)
	DECLARE @maxValue VARCHAR(80)

	DECLARE @numValue INT
	DECLARE @i INT = 1

	SELECT @IdPublicFeature = IdPublicFeature
	FROM PAPublicFeatures
	WHERE name = 'age'

	-- We will insert 100 age ranges/values
	WHILE @i <= 100
	BEGIN
		
		SET @numValue = FLOOR(RAND() * 81 + 10) -- Ages from 10 to 80
		SET @minValue = CAST(@numValue AS varchar(80))

		SET @numValue = @numValue + FLOOR(RAND() * 21)
		SET @maxValue = CAST(@numValue AS varchar(80))

		SET @name = CONCAT('Ages from: ', @minValue, ' to ', @maxValue)

		INSERT INTO PAPublicValues (IdPublicFeature, name, minValue, maxValue) VALUES
		(@IdPublicFeature, @name, @minValue, @maxValue)

		SET @i = @i + 1
	END
	-- We will insert 20 frequency of purchase ranges/values
	SELECT @IdPublicFeature = IdPublicFeature
	FROM PAPublicFeatures
	WHERE name = 'frequency_of_purchases_a_month'

	SET @i = 1

	WHILE @i <= 20
	BEGIN
		
		SET @numValue = FLOOR(RAND() * 9 + 1) -- Purchases from 1 to 8
		SET @minValue = CAST(@numValue AS varchar(80))

		SET @numValue = @numValue + FLOOR(RAND() * 9)
		SET @maxValue = CAST(@numValue AS varchar(80))

		SET @name = CONCAT('Purchases: ', @minValue, ' to ', @maxValue)

		INSERT INTO PAPublicValues (IdPublicFeature, name, minValue, maxValue) VALUES
		(@IdPublicFeature, @name, @minValue, @maxValue)
		
		SET @i = @i + 1
	END

	-- The other values will come from the TVP
	INSERT INTO PAPublicValues (IdPublicFeature, name, [value])
    SELECT pf.IdPublicFeature, CONCAT(pv.category, ': ', pv.[value]), pv.[value] 
	FROM @PublicValue pv
	INNER JOIN PAPublicFeatures pf ON pf.name = pv.category  

END
-- -------------------------
-- SP Insert Target Publics
-- -------------------------
-- This procedure will help us create a bunch of target publics for our ads
GO
CREATE OR ALTER PROCEDURE dbo.PA_SPInsertTargetPublics
	@numInserts INT
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @IdTargetPublic INT
	DECLARE @name VARCHAR(80) = ' '
	DECLARE @description VARCHAR(200)

	DECLARE @IdPublicValue INT
	DECLARE @publicValueName VARCHAR(80)

	DECLARE @numFeatures INT
	DECLARE @i INT = 1
	DECLARE @j INT = 1

	WHILE @i <= @numInserts
	BEGIN

		INSERT INTO PATargetPublics (name, description) VALUES ('name', 'description')		-- We fill it with default data

		SELECT @IdTargetPublic = SCOPE_IDENTITY() -- We retrieve the last inserted

		SET @numFeatures = FLOOR(RAND()*2) + 1 -- We can add 1 or 2 features for this example
		SET @name = ' '
		SET @j = 1

		WHILE @j <= @numFeatures
		BEGIN

			SELECT TOP 1 @IdPublicValue = IdPublicValue, @publicValueName = name
			FROM PAPublicValues
			ORDER BY NEWID()

			INSERT INTO PATargetConfigurations (IdTargetPublic, IdPublicValue) VALUES (@IdTargetPublic, @IdPublicValue)

			SET @name = CONCAT(@name, ' ', @publicValueName)

			SET @j = @j + 1
		END

		-- We use LTRIM to erase the blank spaces to the left
		SET @name = LTRIM(@name)
		SET @description = CONCAT('Target public with the atributes: ', @name)

		-- We update with the new information
		UPDATE PATargetPublics
		SET name = @name, description = @description
		WHERE IdTargetPublic = @IdTargetPublic

		SET @i = @i + 1
	END
END
-- --------------------------
-- SP Insert Reactions
-- --------------------------
GO
CREATE OR ALTER PROCEDURE dbo.PA_SPInsertReactions
	@IdAdPerformance BIGINT,
	@ChannelReactions dbo.ChannelReactions READONLY
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @channelName VARCHAR(40)
	DECLARE @IdReactionType SMALLINT
	DECLARE @reactionNum BIGINT

	DECLARE @i INT = 1 

	-- We create a temporary table to order the results and insert them
	CREATE TABLE #TempReactionsPerAd
	(
		TempIdAdPerformance BIGINT,
		TempIdReactionType SMALLINT, 
		TempReactionNum BIGINT
	);
	-- First we get the channel where the ad is being transmited
	SELECT @channelName = c.name
	FROM PAAdPerformances ap 
	INNER JOIN PAPublishedAds pa ON pa.IdPublishedAd = ap.IdPublishedAd
	INNER JOIN PAOrganizationContacts o ON o.IdOrganizationContact = pa.IdOrganizationContact
	INNER JOIN PAChannels c ON c.IdChannel = o.IdChannel 
	-- We prepare the insert by selecting the data in the temporary table
	INSERT INTO #TempReactionsPerAd (TempIdAdPerformance, TempIdReactionType, TempReactionNum)
	SELECT @IdAdPerformance, t.IdReactionType, FLOOR(RAND()* 10000000) + 500
	FROM @ChannelReactions r
	INNER JOIN PAReactionTypes t ON r.reactionName = t.name
	WHERE channelName = @channelName

	INSERT INTO PAReactionsPerAd (IdAdPerformance, IdReactionType, reactionNumber)
	SELECT TempIdAdPerformance, TempIdReactionType, TempReactionNum
	FROM #TempReactionsPerAd

END
-- --------------------------
-- SP Insert Ad Performance
-- --------------------------
GO
CREATE OR ALTER PROCEDURE dbo.PA_SPInsertAdPerformance
	@IdPublishedAd BIGINT,
	@ChannelReactions dbo.ChannelReactions READONLY
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @IdAdPerformance BIGINT
	DECLARE @reach BIGINT
	DECLARE @budget DECIMAL(16,2)
	DECLARE @expenses DECIMAL(16,2)
	DECLARE @revenue DECIMAL(16,2)
	DECLARE @createDate DATETIME
	DECLARE @IdAdSentiment TINYINT

	DECLARE @maxRows INT 
	DECLARE @weight BIGINT
	DECLARE @i INT = 1
	-- --------------------

	SET @budget = RAND() * 20000 + 5000
	SET @expenses = RAND() * 25000 + 5000
	SET @revenue = RAND() * 32000 + 2000 + (@budget - @expenses)

	SELECT @createDate = createdAt
	FROM PAPublishedAds
	WHERE IdPublishedAd = @IdPublishedAd

	-- We use default values that we will later update
	INSERT INTO PAAdPerformances (IdPublishedAd, reach, budget, expenses, revenue, IdAdSentiment, createdAt) VALUES
	(@IdPublishedAd,0,@budget,@expenses,@revenue,1,@createDate)

	SELECT @IdAdPerformance = SCOPE_IDENTITY() -- We retrieve the last inserted

	EXEC dbo.PA_SPInsertReactions @IdAdPerformance, @ChannelReactions; -- Add random reactions depending on the channel

	-- We calculate reach by getting the SUM of all reactions from this add
	SELECT @reach = SUM(reactionNumber)
	FROM PAReactionsPerAd r
	WHERE IdAdPerformance = @IdAdPerformance

	SELECT @weight = SUM(r.reactionNumber * t.reactionWeight)
	FROM PAReactionsPerAd r
	INNER JOIN PAReactionTypes t ON t.IdReactionType = r.IdReactionType
	WHERE IdAdPerformance = @IdAdPerformance

	SELECT @IdAdSentiment =
	CASE
		WHEN @weight>(@reach * 3) THEN 1
		WHEN @weight>(@reach * 2) THEN 2
		WHEN @weight>(@reach * 1) THEN 3
		WHEN @weight>(@reach * 0.5) THEN 4
		ELSE 5
	END

	-- Finally we update the reach and sentiment with the data aggregated from the reaction tables
	UPDATE PAAdPerformances
	SET reach = @reach, IdAdSentiment = @IdAdSentiment
	WHERE IdAdPerformance = @IdAdPerformance

END
-- --------------------------
-- SP Insert PublishedAds
-- --------------------------
GO
CREATE OR ALTER PROCEDURE dbo.PA_SPInsertPublishedAds
	@IdCampaignAd BIGINT,
	@ChannelReactions dbo.ChannelReactions READONLY
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @IdPublishedAd BIGINT
	DECLARE @IdOrganizationContact INT
	DECLARE @redirectURL VARCHAR(255)
	DECLARE @createDate DATETIME
	DECLARE @IdStatus tinyint

	DECLARE @IdOrganization INT

	SELECT @IdOrganization = c.IdOrganization, @createDate= c.createdAt  
	FROM PACampaignAds ca
	INNER JOIN  PACampaigns c ON c.IdCampaign = ca.IdCampaign 

	SELECT @IdStatus = IdAdStatus
	FROM PAAdStatus
	WHERE name = 'Finished'

	INSERT INTO PAPublishedAds (IdCampaignAd, IdOrganizationContact, redirectURL, createdAt ,IdAdStatus)
	SELECT @IdCampaignAd, IdOrganizationContact,'[Insert your redirect link here]', @createDate, @IdStatus 
	FROM PAOrganizationContacts
	WHERE IdOrganization = @IdOrganization

	SELECT @IdPublishedAd = SCOPE_IDENTITY() -- We retrieve the last inserted

	EXEC dbo.PA_SPInsertAdPerformance @IdPublishedAd, @ChannelReactions;

END
-- --------------------------
-- SP Insert Ads
-- --------------------------
GO
CREATE OR ALTER PROCEDURE dbo.PA_SPInsertAdsConfig
	@IdCampaign INT,
	@ChannelReactions dbo.ChannelReactions READONLY
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @IdAd BIGINT
	DECLARE @title VARCHAR(50)
	DECLARE @description VARCHAR(200)
	DECLARE @IdAdType TINYINT
	DECLARE @checksum VARBINARY(255)
	DECLARE @createDate DATETIME

	DECLARE @campaignName VARCHAR(60)
	DECLARE @numAds INT
	DECLARE @IdTargetPublic INT

	DECLARE @i INT = 1
	-- ------------
	SELECT @createDate = createdAt, @campaignName = name
	FROM PACampaigns
	WHERE IdCampaign = @IdCampaign

	SET @numAds = FLOOR(RAND()*5) + 1

	WHILE @i <= @numAds
	BEGIN

			SELECT TOP 1 @IdAdType = IdAdType
			FROM PAAdTypes
			ORDER BY NEWID()

			SELECT TOP 1 @IdTargetPublic = IdTargetPublic 
			FROM PATargetPublics
			ORDER BY NEWID()

			SET @title = CONCAT('Ad', @i, ': ', @campaignName)
			SET @description = CONCAT('This is the description of Ad ', @i, ', from the campaign ', @campaignName)

			INSERT INTO PACampaignAds (IdCampaign, title, description, IdAdType, createdAt, updatedAt) VALUES
			(@IdCampaign, @title, @description, @IdAdType, @createDate, DATEADD(DAY, FLOOR(RAND()*16), @createDate))

			SELECT @IdAd = SCOPE_IDENTITY() -- We retrieve the last inserted

			INSERT INTO PAAdPublics (IdCampaignAd, IdTargetPublic, createdAt) VALUES
			(@IdAd, @IdTargetPublic, @createDate)

			EXEC dbo.PA_SPInsertPublishedAds @IdAd, @ChannelReactions;

		SET @i = @i + 1
	END
END
-- --------------------------
-- SP Insert Campaigns
-- --------------------------
-- SHOWCASE: CEILING
GO
CREATE OR ALTER PROCEDURE dbo.PA_SPInsertCampaigns
	@numInserts INT,
	@campaignStarters dbo.CampaignStarterMockup READONLY,
	@campaignAdjectiveProducts dbo.CampaignAdjectiveProductMockup READONLY,
	@campaignProducts dbo.CampaignProductMockup READONLY,
	@ChannelReactions dbo.ChannelReactions READONLY
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @IdCampaign INT
	DECLARE @IdOrganization INT
	DECLARE @campaignName VARCHAR(60)
	DECLARE @description VARCHAR(200)
	DECLARE @IdCity INT
	DECLARE @createDate DATETIME
	DECLARE @updateDate DATETIME
	DECLARE @startDate DATE
	DECLARE @endDate DATE
	DECLARE @IdStatus TINYINT
	DECLARE @checksum VARBINARY(255)

	DECLARE @category VARCHAR(30)
	DECLARE @campaignNameStarter VARCHAR(60)
	DECLARE @campaignNameAdjective VARCHAR(60)
	DECLARE @campaignNameProduct VARCHAR(60)

	DECLARE @numFinishedCampaigns INT
	DECLARE @numActiveCampaigns INT
	DECLARE @randNum INT
	DECLARE @maxDate DATE

	DECLARE @i INT = 1
	-- -------
	-- We use CEILING to get an integer number that represents 70% of the finished campaigns and 30% of the active ones.
	-- This way, regardless of the number of inserts, result will always be an integer.
	SET @numFinishedCampaigns = CEILING(@numInserts*0.7)
	SET @numActiveCampaigns = CEILING(@numInserts*0.3)

	SELECT @IdStatus = IdCampaignStatus
	FROM PACampaignStatus
	WHERE name = 'Finished'

	WHILE @i <= @numFinishedCampaigns		
	BEGIN

		-- To get random values from other tables, we use ORDER BY NEWID(), which will generate a unique number for every row in the select query
		-- The top 1 will guarantee only one result
		SELECT TOP 1 @IdOrganization = IdOrganization
		FROM PAOrganizations
		WHERE IdOrganizationStatus = 1 -- Active organizations
		ORDER BY NEWID()

		SELECT TOP 1 @campaignNameStarter = sentence, @category = category
		FROM @campaignStarters
		ORDER BY NEWID()

		SELECT TOP 1 @campaignNameAdjective = name
		FROM @campaignAdjectiveProducts
		WHERE category = @category
		ORDER BY NEWID()

		SELECT TOP 1 @campaignNameProduct = name
		FROM @campaignProducts
		WHERE category = @category
		ORDER BY NEWID()

		SELECT TOP 1 @IdCity = IdCity
		FROM PACities
		ORDER BY NEWID()

		-- Between july 2024 and january 2026 there are 549 days
		-- Most campaigns will occur around november, december and january, around 70% of them
		SET @startDate = '2024-07-01'
		SET @maxDate = '2026-01-30' 

		SET @randNum = FLOOR(RAND()*10)+1
		SELECT @startDate =
		CASE 
			WHEN @randNum = 1 THEN '2024-11-01'
			WHEN @randNum = 2 OR @randNum = 3 THEN '2024-12-01'
			WHEN @randNum = 4 OR @randNum = 5 THEN '2025-01-01'
			WHEN @randNum = 6 OR @randNum = 7 THEN '2025-11-01'
			ELSE DATEADD(DAY, FLOOR(RAND()*300), @startDate)
		END
	
		SET @startDate = DATEADD(DAY, FLOOR(RAND()*15), @startDate)		
		SET @createDate = DATEADD(DAY, - FLOOR(RAND()*60), @startDate)	-- Value between 0 and 59 (its a substraction)
		SET @endDate = DATEADD(DAY, FLOOR(RAND()*40)+10, @startDate)	-- Value between 10 and 39
		-- This will make sure we dont go over january 2026
		SELECT @endDate =
		CASE
			WHEN @endDate > @maxDate THEN @maxDate
			ELSE @endDate
		END
		-- Using the three parts obtained from the TVP, we create a title and description for the campaign
		SET @campaignName = CONCAT(@campaignNameStarter,' ',@campaignNameAdjective,' ',@campaignNameProduct)
		SET @description = CONCAT('This ad campaign is all about ', @campaignName)

		INSERT INTO PACampaigns (IdOrganization,name,description,IdCity,createdAt,updatedAt,startsAt,endsAt,IdCampaignStatus) VALUES
		(@IdOrganization, @campaignName, @description, @IdCity, @createDate, @startDate, @startDate, @endDate, @IdStatus)
		
		SELECT @IdCampaign = SCOPE_IDENTITY() -- We retrieve the last inserted

		EXEC dbo.PA_SPInsertAdsConfig @IdCampaign, @ChannelReactions

		SET @i = @i + 1
	END

	SET @i = 1

	SELECT @IdStatus = IdCampaignStatus
	FROM PACampaignStatus
	WHERE name = 'Active'
	-- -------
	WHILE @i <= @numActiveCampaigns	
	BEGIN
		
		-- To get random values from other tables, we use ORDER BY NEWID(), which will generate a unique number for every row in the select query
		-- The top 1 will guarantee only one result
		SELECT TOP 1 @IdOrganization = IdOrganization
		FROM PAOrganizations
		WHERE IdOrganizationStatus = 1 -- Active organizations
		ORDER BY NEWID()

		SELECT TOP 1 @campaignNameStarter = sentence, @category = category
		FROM @campaignStarters
		ORDER BY NEWID()

		SELECT TOP 1 @campaignNameAdjective = name
		FROM @campaignAdjectiveProducts
		WHERE category = @category
		ORDER BY NEWID()

		SELECT TOP 1 @campaignNameProduct = name
		FROM @campaignProducts
		WHERE category = @category
		ORDER BY NEWID()

		SELECT TOP 1 @IdCity = IdCity
		FROM PACities
		ORDER BY NEWID()

		-- For active campaigns, they are more recent
		SET @startDate = '2025-10-01'
		SET @maxDate = '2026-01-30' 

		SET @randNum = FLOOR(RAND()*10)+1
		SELECT @startDate =
		CASE 
			WHEN @randNum <= 2 THEN '2025-11-01'
			WHEN @randNum <= 5 THEN '2025-12-01'
			WHEN @randNum <= 7 THEN '2026-01-01'
			ELSE DATEADD(DAY, FLOOR(RAND()*90), @startDate)
		END
	
		SET @startDate = DATEADD(DAY, FLOOR(RAND()*15), @startDate)		
		SET @createDate = DATEADD(DAY, - FLOOR(RAND()*60), @startDate)	-- Value between 0 and 59 (its a substraction)
		SET @endDate = DATEADD(DAY, FLOOR(RAND()*40)+10, @startDate)	-- Value between 10 and 39
		-- This will make sure we dont go over january 2026
		SELECT @endDate =
		CASE
			WHEN @endDate > @maxDate THEN @maxDate
			ELSE @endDate
		END

		-- Using the three parts obtained from the TVP, we create a title and description for the campaign
		SET @campaignName = CONCAT(@campaignNameStarter,' ',@campaignNameAdjective,' ',@campaignNameProduct)
		SET @description = CONCAT('This ad campaign is all about ', @campaignName)

		INSERT INTO PACampaigns (IdOrganization,name,description,IdCity,createdAt,updatedAt,startsAt,endsAt,IdCampaignStatus) VALUES
		(@IdOrganization, @campaignName, @description, @IdCity, @createDate, @startDate, @startDate, @endDate, @IdStatus)

		SELECT @IdCampaign = SCOPE_IDENTITY() -- We retrieve the last inserted

		EXEC dbo.PA_SPInsertAdsConfig @IdCampaign, @ChannelReactions

		SET @i = @i + 1
	END
END

-- ********************************
--      Table Value Parameter
-- ********************************
-- We will use these to pass a large list of data and create names algorithmically

GO
DECLARE @OrganizationAdjectivesTVP AS dbo.OrganizationAdjectivesMockup
INSERT INTO @OrganizationAdjectivesTVP (organizationName) VALUES
('Bright'),('Global'),('Dynamic'),('Creative'),('Future'),('Vision'),('Green'),('Next'),('Prime'),('Blue'),
('Silver'),('Golden'),('Rapid'),('Smart'),('True'),('Unity'),('Open'),('Clear'),('Strong'),('Infinite'),
('Nova'),('Urban'),('Modern'),('Agile'),('Bold'),('Epic'),('Pure'),('Vital'),('Quantum'),('Solid'),
('Grand'),('Fresh'),('Peak'),('Brightest'),('Hyper'),('Ultra'),('Mega'),('Neo'),('Core'),
('Alpha'),('Beta'),('Omega'),('First'),('Main'),('Central'),('North'),('South'),('East'),('West'),
('United'),('Universal'),('NextGen'),('Visionary');


DECLARE @OrganizationNamesTVP AS dbo.OrganizationNameMockup
INSERT INTO @OrganizationNamesTVP (organizationName) VALUES
('Solutions'),('Systems'),('Group'),('Network'),('Labs'),('Partners'),('Ventures'),('Capital'),('Foundation'),('Alliance'),
('Studio'),('Enterprises'),('Technologies'),('Consulting'),('Industries'),('Holdings'),('Corporation'),('Services'),('Works'),('Dynamics'),
('Innovation'),('Concepts'),('Designs'),('Projects'),('Resources'),('Global'),('International'),('Collective'),('Union'),('Circle'),
('Matrix'),('Edge'),('Point'),('Bridge'),('Path'),('Vision'),('Future'),('Logic'),('Strategy'),('Impact')


DECLARE @OrganizationLegalNamesTVP AS dbo.OrganizationLegalNameMockup
INSERT INTO @OrganizationLegalNamesTVP (organizationName) VALUES
('Inc.'),('Corp'),('Corporation'),('Ltd.'),('LLC'),('PLC'),('LLP'),('Co.'),('Company'),
('S.A.'),('S.A.S.'),('GmbH'),('AG'),('BV'),('NV'),('Oy'),('AB'),('AS'),('SpA'),('K.K.'),
('Foundation'),('Association'),('Cooperative'),('Partnership'),('Enterprises'),('Holdings'),('International')


DECLARE @CampaignStartersTVP AS dbo.CampaignStarterMockup
INSERT INTO @CampaignStartersTVP (sentence, category) VALUES
('Buy the new', 'appliance'), ('Shop the best deals for', 'appliance'), ('Grab your discount', 'appliance'), 
('Claim your offer today', 'appliance'), ('Save more now', 'appliance'), ('Try the new', 'appliance'),
('Savor the moment','food'), ('Indulge yourself with the','food'),('Try the new','food'),
('Claim your offer today','food'),('Buy the new','food'),
('Watch the new', 'entertainment'), ('Stream the latest', 'entertainment'), ('Discover the show', 'entertainment'),
('Catch the premiere:', 'entertainment'), ('Enjoy the music live:', 'entertainment'),
('Join the movement on', 'action'), ('Act now,', 'action'), ('Start your journey,', 'action'), 
('Unlock the future,', 'action'), ('Don’t miss out on', 'action')


DECLARE @CampaignAdjectiveProductsTVP AS dbo.CampaignAdjectiveProductMockup
INSERT INTO @CampaignAdjectiveProductsTVP (name, category) VALUES
('Smart','appliance'),('Wireless','appliance'),('Portable','appliance'),('High-Tech','appliance'),('Eco-Friendly','appliance'),
('Energy-Saving','appliance'),('Compact','appliance'),('Durable','appliance'),('Advanced','appliance'),('Innovative','appliance'),
('Next-Gen','appliance'),('Premium','appliance'),('Ultra','appliance'),('Digital','appliance'),('Modern','appliance'),
('Delicious','food'),('Tasty','food'),('Spicy','food'),('Savory','food'),('Sweet','food'),('Crispy','food'),('Juicy','food'),
('Smoky','food'),('Cheesy','food'),('Tender','food'),('Crunchy','food'),('Golden','food'),('Fresh','food'),('Hot','food'),
('Teriyaki','food'),('BBQ','food'),('Garlic','food'),('Chili','food'),('Honey','food'),('Pepper','food'), 
('Exciting','entertainment'),('Thrilling','entertainment'),('Epic','entertainment'),('Unforgettable','entertainment'),
('Exclusive','entertainment'),('Legendary','entertainment'),('Spectacular','entertainment'),('New','entertainment'),
('Fresh','entertainment'),('Ultimate','entertainment'),('Grand','entertainment'),('Special','entertainment'),
('Limited','entertainment'),('Blockbuster','entertainment'),('Premiere','entertainment'),
('Beach','action'),('Mountain','action'),('Forest','action'),('Desert','action'),('City','action'),('Global','action'),
('Eco','action'),('Wildlife','action'),('Cultural','action'),('Outdoor','action'),('Sustainable','action'),('Unity','action'),
('Collective','action'),('Visionary','action'),('Adventure','action')


DECLARE @CampaignProductsTVP AS dbo.CampaignProductMockup
INSERT INTO @CampaignProductsTVP (name, category) VALUES
('Smartphone','appliance'),('Laptop','appliance'),('Tablet','appliance'),('Smart TV','appliance'),('Bluetooth Speaker','appliance'),
('Headphones','appliance'),('Gaming Console','appliance'),('Camera','appliance'),('Microwave Oven','appliance'),('Refrigerator','appliance'),
('Washing Machine','appliance'),('Air Conditioner','appliance'),('Vacuum Cleaner','appliance'),('Coffee Maker','appliance'),
('Smartwatch','appliance'),
('Burger','food'), ('Pizza','food'), ('Sandwich','food'), ('Taco','food'), ('Wrap','food'), ('Noodles','food'),
('Soup','food'), ('Salad','food'), ('Steak','food'), ('Sushi','food'), ('Curry','food'), ('Rice','food'),
('Hotdog','food'), ('Dumpling','food'), ('Pasta','food'),
('Show Season 2','entertainment'),('Movie Premiere','entertainment'),('Concert Live','entertainment'),
('Series Finale','entertainment'),('Drama Special','entertainment'),('Comedy Night','entertainment'),
('Action Saga','entertainment'),('Fantasy World','entertainment'),('Documentary Release','entertainment'),
('Musical Tour','entertainment'),('Film Festival','entertainment'),('Episode Launch','entertainment'),
('Adventure Story','entertainment'),('Romance Feature','entertainment'),('Sci-Fi Journey','entertainment'),
('Expedition','action'),('Trip','action'),('Journey','action'),('Safari','action'),('Tour','action'),('Mission','action'),
('Quest','action'),('Challenge','action'),('Campaign','action'),('Experience','action'),('Path','action'),('Movement','action'),
('Project','action'),('Story','action'),('Adventure','action')


DECLARE @PublicValuesTVP AS dbo.PublicValues
INSERT INTO @PublicValuesTVP ([value], category) VALUES
('Male','gender'), ('Female','gender'), ('Other','gender'), ('Any','gender'),
('Medical Doctor','occupation'),('Lawyer','occupation'),('Architect','occupation'),('Civil Engineer','occupation'),
('Mechanical Engineer','occupation'),('Electrical Engineer','occupation'),('Software Engineer','occupation'),('Data Engineer','occupation'),
('University Professor','occupation'),('School Teacher','occupation'),('Research Scientist','occupation'),('Pharmacist','occupation'),
('Accountant','occupation'),('Business Manager','occupation'),('Project Manager','occupation'),('Graphic Designer','occupation'),
('Software Developer','occupation'),('Chef','occupation'),('Airline Pilot','occupation'),('Writer','occupation'),
('Musician','occupation'),('Psychologist','occupation'),('Marketing Specialist','occupation'),('Financial Analyst','occupation'),
('hiking','interests'),('running','interests'),('playing videogames','interests'),('going to the beach','interests'),
('reading books','interests'),('watching movies','interests'),('traveling','interests'),('cooking','interests'),
('cycling','interests'),('swimming','interests'),('painting','interests'),('listening to music','interests'),
('playing guitar','interests'),('gardening','interests'),('photography','interests')


DECLARE @ChannelReactionTVP AS dbo.ChannelReactions
INSERT INTO @ChannelReactionTVP (channelName, reactionName) VALUES
('Facebook','Likes'),('Facebook','Shares'),('Facebook','Love'),('Facebook','Sad'),('Facebook','Angry'),
('WhatsApp','Message_Received'),('Instagram','Likes'),('Instagram','Follows'),
('YouTube','Views'),('YouTube','Likes'),('YouTube','Dislikes'),('YouTube','Positive_Comments'),
('YouTube','Negative_Comments'),('YouTube','Shares'),('Twitch','Views'),('Twitch','Follows'),
('X','Likes'),('X','Shares'),('X','Positive_Comments'),('X','Negative_Comments'),('TikTok','Views'),
('TikTok','Likes'),('TikTok','Shares'),('LinkedIn','Views'),('LinkedIn','Positive_Comments'),
('LinkedIn','Shares'),('LinkedIn','Follows'),('Gmail','Message_Received'),('SMS','Message_Received')



-- ********************************
--         EXECUTE SP
-- ********************************
EXEC dbo.PA_SPInsertOrganizations 500, @OrganizationAdjectivesTVP, @OrganizationNamesTVP, @OrganizationLegalNamesTVP
EXEC dbo.PA_SPInsertPublicValues @PublicValuesTVP
EXEC dbo.PA_SPInsertTargetPublics 600
EXEC dbo.PA_SPInsertCampaigns 1100, @CampaignStartersTVP, @CampaignAdjectiveProductsTVP, @CampaignProductsTVP, @ChannelReactionTVP



-- ********************************
--         DROP TABLE TYPES
-- ********************************
-- We erase unnecesary table types
/*
DROP PROCEDURE dbo.PA_SPInsertAdPerformance
DROP PROCEDURE dbo.PA_SPInsertAdsConfig
DROP PROCEDURE dbo.PA_SPInsertCampaigns
DROP PROCEDURE dbo.PA_SPInsertOrganizationContacts
DROP PROCEDURE dbo.PA_SPInsertOrganizations
DROP PROCEDURE dbo.PA_SPInsertPublicValues
DROP PROCEDURE dbo.PA_SPInsertPublishedAds
DROP PROCEDURE dbo.PA_SPInsertReactions
DROP PROCEDURE dbo.PA_SPInsertTargetPublics

DROP TYPE dbo.OrganizationAdjectivesMockup;
DROP TYPE dbo.OrganizationNameMockup;
DROP TYPE dbo.OrganizationLegalNameMockup;
DROP TYPE dbo.CampaignStarterMockup;
DROP TYPE dbo.CampaignAdjectiveProductMockup;
DROP TYPE dbo.CampaignProductMockup;
DROP TYPE dbo.PublicValues;
DROP TYPE dbo.ChannelReactions;

SELECT * FROM PAOrganizations
SELECT * FROM PAOrganizationContacts
SELECT * FROM PACampaigns
SELECT * FROM PAPublicValues
SELECT * FROM PATargetConfigurations
SELECT * FROM PATargetPublics
SELECT * FROM PACampaignAds
SELECT * FROM PAPublishedAds
SELECT * FROM PAAdPerformances
SELECT * FROM PAReactionsPerAd

SELECT * FROM PACampaignStatus
SELECT * FROM PAOrganizationStatus
SELECT * FROM PAChannels
SELECT * FROM PAAdSentiments
SELECT * FROM PAReactionTypes
SELECT * FROM PAAdTypes
SELECT * FROM PACountries
SELECT * FROM PAStates
SELECT * FROM PACities
SELECT * FROM PAPublicFeatures

*/



/*
-------------
RESET TABLES
-------------

DELETE FROM PAReactionsPerAd;
DBCC CHECKIDENT ('PAReactionsPerAd', RESEED, 0)
DELETE FROM PAAdPublics;
DBCC CHECKIDENT ('PAAdPublics', RESEED, 0)
DELETE FROM PAAdPerformances
DBCC CHECKIDENT ('PAAdPerformances', RESEED, 0)
DELETE FROM PAPublishedAds;
DBCC CHECKIDENT ('PAPublishedAds', RESEED, 0)
DELETE FROM PACampaignAds;
DBCC CHECKIDENT ('PACampaignAds', RESEED, 0)


DELETE FROM PATargetConfigurations;
DBCC CHECKIDENT ('PATargetConfigurations', RESEED, 0)
DELETE FROM PATargetPublics;
DBCC CHECKIDENT ('PATargetPublics', RESEED, 0)
DELETE FROM PAPublicValues;
DBCC CHECKIDENT ('PAPublicValues', RESEED, 0)
DELETE FROM PACampaigns;
DBCC CHECKIDENT ('PACampaigns', RESEED, 0)
DELETE FROM PAOrganizationContacts;
DBCC CHECKIDENT ('PAOrganizationContacts', RESEED, 0)
DELETE FROM PAOrganizations;
DBCC CHECKIDENT ('PAOrganizations', RESEED, 0)

DELETE FROM PACurrencies
DBCC CHECKIDENT ('PACurrencies', RESEED, 0);
DELETE FROM PAScheduleRecurrencies
DBCC CHECKIDENT ('PAScheduleRecurrencies', RESEED, 0);
DELETE FROM PALogLevels
DBCC CHECKIDENT ('PALogLevels', RESEED, 0);
DELETE FROM PALogSources
DBCC CHECKIDENT ('PALogSources', RESEED, 0);
DELETE FROM PALogTypes
DBCC CHECKIDENT ('PALogTypes', RESEED, 0);
DELETE FROM PAPublicFeatures;
DBCC CHECKIDENT ('PAPublicFeatures', RESEED, 0)
DELETE FROM PACities;
DBCC CHECKIDENT ('PACities', RESEED, 0);
DELETE FROM PAStates;
DBCC CHECKIDENT ('PAStates', RESEED, 0);
DELETE FROM PACountries;
DBCC CHECKIDENT ('PACountries', RESEED, 0);
DELETE FROM PAAdStatus;
DBCC CHECKIDENT ('PAAdStatus', RESEED, 0);
DELETE FROM PAAdTypes;
DBCC CHECKIDENT ('PAAdTypes', RESEED, 0);

DELETE FROM PAReactionTypes;
DBCC CHECKIDENT ('PAReactionTypes', RESEED, 0);
DELETE FROM PAAdSentiments;
DBCC CHECKIDENT ('PAAdSentiments', RESEED, 0);
DELETE FROM PAChannels;
DBCC CHECKIDENT ('PAChannels', RESEED, 0);
DELETE FROM PAOrganizationStatus;
DBCC CHECKIDENT ('PAOrganizationStatus', RESEED, 0);
DELETE FROM PACampaignStatus;
DBCC CHECKIDENT ('PACampaignStatus', RESEED, 0);

*/
