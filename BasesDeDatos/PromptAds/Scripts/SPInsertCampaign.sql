use promptads;

/*
- This file contains the SP to insert a campaign with N ads, that have N targetPublics and are transmitted in N channels. 
- The SP uses TVP to send various rows of information
- A requirement is that no ad in the same campaign has the same name
- The insertion goes as follow: 
- Campaign --> Ads --> Budgets --> Publishing Channels --> Schedules --> Publics
- If the schedule or public does not exist, the procedure will create a new one

- We are using Tables in Memory to reduce the number of inner joins inside procedures
- They will save IDs

*/

CREATE TYPE dbo.AdData AS TABLE (
    adTitle VARCHAR(80),
    adDescription VARCHAR(200),
    adType VARCHAR(20),
	budget DECIMAL(16,2),
	currency VARCHAR(50)
);
CREATE TYPE dbo.ChannelData AS TABLE (
    adTitle VARCHAR(80),
    contactValue VARCHAR(80),
    contactChannel VARCHAR(30),
	body TEXT,
	redirectURL VARCHAR(255),
	scheduleName VARCHAR(30),
	startDate DATE NULL,
	endDate DATE NULL,
	startHours TIME NULL,
	endHours TIME NULL,
	recurrency VARCHAR(30) NULL
);
CREATE TYPE dbo.TargetPublicData AS TABLE (
    adTitle VARCHAR(80),
	targetName VARCHAR(80),
	targetDesc VARCHAR(200) NULL,
    featureName VARCHAR(30) NULL
);
--------------------------------
-- SP for campaign insertion
--------------------------------
-- We retrieve IDs during the transaction to make sure they are accurate
GO
CREATE PROCEDURE [dbo].[PA_SPInsertCampaign]
    @organizationName VARCHAR(60),
    @campaignName VARCHAR(60),
    @campaignDesc VARCHAR(200),
	@campaignCity VARCHAR(60),
	@campaignStartDate DATE,
	@campaignEndDate DATE,
	@adData dbo.AdData READONLY,
	@channelData dbo.ChannelData READONLY,
	@targetPublicData dbo.TargetPublicData READONLY
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT
	-- ----------------
	DECLARE @IdOrganization INT
	DECLARE @IdCampaign INT
	DECLARE @IdCity INT
	DECLARE @IdCampaignStatus TINYINT
	DECLARE @IdAdStatus TINYINT
	DECLARE @IdLogLevel INT
	DECLARE @IdLogType INT
	DECLARE @IdLogSource INT
	DECLARE @IdLogLevelErr INT

	-- We create two tables in memory to manage Ids faster
	DECLARE @AdIds TABLE (
		IdAd BIGINT NULL,
		IdTarget INT NULL,
		adTitle VARCHAR(80),
		targetName VARCHAR(80)
	)
	DECLARE @PublishedAdIds TABLE (
		IdPublishedAd BIGINT NULL,
		IdSchedule INT NULL,	
		IdOrganizationContact INT NULL,		
		IdInfluencerContact INT NULL,		
		adTitle VARCHAR(80),
		scheduleName VARCHAR(30),
		contactValue VARCHAR(80),
		contactChannel VARCHAR(30)
	)

	DECLARE @uniqueTitles INT
	DECLARE @totalTitles INT
	-- ----------------
	SELECT @IdOrganization = IdOrganization
	FROM PAOrganizations 
	WHERE name = @organizationName

	SELECT @IdAdStatus = IdAdStatus
	FROM PAAdStatus
	WHERE name = 'Paused'

	SELECT @IdCampaignStatus = IdCampaignStatus
	FROM PACampaignStatus
	WHERE name = 'Paused'

	SELECT @IdLogLevel = IdLogLevel
	FROM PALogLevels
	WHERE name = 'Info'

	SELECT @IdLogLevelErr = IdLogLevel
	FROM PALogLevels
	WHERE name = 'Error'

	SELECT @IdLogSource = IdLogSource
	FROM PALogSources
	WHERE name = 'Database'

	SELECT @IdLogType = IdLogType
	FROM PALogTypes
	WHERE name = 'Insert campaign'

	SELECT @IdCity = IdCity 
	FROM PACities
	WHERE name = @campaignCity

	-- We move the ad titles to a table that will help organize their IDs
	INSERT INTO @AdIds (adTitle, targetName)
	SELECT ad.adTitle, td.targetName
	FROM @adData ad
	INNER JOIN @targetPublicData td ON td.adTitle = ad.adTitle

	-- We move the ad channel information to a table that will help organize their IDs
	INSERT INTO @PublishedAdIds (adTitle, scheduleName, contactValue, contactChannel)
	SELECT adTitle, scheduleName, contactValue, contactChannel
	FROM @channelData

	-- UPDATE SELECT: We use it to update the IDs on every row with the corresponding contacts
	UPDATE id
	SET id.IdOrganizationContact = o.IdOrganizationContact
	FROM @PublishedAdIds id
	INNER JOIN PAOrganizationContacts o ON o.value = id.contactValue
	INNER JOIN PAChannels c ON c.name = id.contactChannel

	-- UPDATE SELECT: We use it to update the IDs on every row with the corresponding contacts
	UPDATE id
	SET id.IdInfluencerContact = i.IdInfluencerContact
	FROM @PublishedAdIds id
	INNER JOIN PAInfluencerContacts i ON i.value = id.contactValue
	INNER JOIN PAChannels c ON c.IdChannel = i.IdChannel

	-- If there is a different amount of totalTitles to distinct titles, it means some are repeated and the operation will be aborted
	SELECT @uniqueTitles = COUNT(DISTINCT adTitle), @totalTitles = COUNT(1)
	FROM @adData;
	IF @uniqueTitles <> @totalTitles
	BEGIN
		RAISERROR('Cannot insert ads with the same name in one campaign', 16, 1)
	END

	-- If the target already exists, it uses that ID
	UPDATE id
	SET id.IdTarget = tp.IdTargetPublic
	FROM @AdIds id
	INNER JOIN PATargetPublics tp ON tp.name = id.targetName

	-- If the schedule already exists, it uses that ID
	UPDATE id
	SET id.IdSchedule = s.IdSchedule
	FROM @PublishedAdIds id
	INNER JOIN PASchedules s ON s.name = id.scheduleName

	-- *************** BEGIN TRANSACTION ******************
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED		-- In order to read accurate table data
		BEGIN TRANSACTION		
	END
	BEGIN TRY
		SET @CustomError = 2001
		-- We insert a campaign 
		INSERT INTO PACampaigns (IdOrganization, name, description, IdCity, startsAt, endsAt, IdCampaignStatus) VALUES 
		(@IdOrganization, @campaignName, @campaignDesc, @IdCity, @campaignStartDate, @campaignEndDate, @IdCampaignStatus)

		-- We retrieve the last ID inserted in THIS session
		SET @IdCampaign = SCOPE_IDENTITY()

		-- We insert the information for the ads
		INSERT INTO PACampaignAds (IdCampaign, title, description, IdAdType)
		SELECT @IdCampaign, ad.adTitle, ad.adDescription, [at].IdAdType 
		FROM @adData ad
		INNER JOIN PAAdTypes [at] ON [ad].adType = [at].name 

		-- We use an update... select to retrieve the Ids of the inserted ads
		UPDATE id
		SET id.IdAd = ca.IdCampaignAd
		FROM @AdIds id
		INNER JOIN PACampaignAds ca ON ca.title = id.adTitle
		WHERE ca.IdCampaign = @IdCampaign
		
		-- First budget value for the individual ads
		INSERT INTO PAAdBudgets (IdCampaignAd, amount, IdCurrency, isCurrent)
		SELECT ca.IdCampaignAd, ad.budget, c.IdCurrency, 1
		FROM @adData ad
		INNER JOIN PACampaignAds ca ON ca.title = ad.adTitle
		INNER JOIN PACurrencies c ON c.isoCode = ad.currency
		
		-- If the contact was from an organization, the IdInfluencerContact will be NULL, the same idea applies when the contact is from an influencer 
		INSERT INTO PAPublishedAds (IdCampaignAd, IdOrganizationContact, IdInfluencerContact, body, redirectURL, IdAdStatus)
		SELECT ca.IdCampaignAd, id.IdOrganizationContact, id.IdInfluencerContact, cd.body, cd.redirectURL, @IdAdStatus
		FROM @channelData cd
		INNER JOIN PACampaignAds ca ON ca.title = cd.adTitle
		LEFT JOIN @PublishedAdIds id ON id.adTitle = cd.adTitle AND id.contactChannel = cd.contactChannel

		-- We use an update... select to retrieve the Ids of the inserted ad channels
		UPDATE id
		SET id.IdPublishedAd = pa.IdPublishedAd
		FROM @PublishedAdIds id
		INNER JOIN PACampaignAds ca ON ca.title = id.adTitle
		INNER JOIN PAPublishedAds pa ON pa.IdCampaignAd = ca.IdCampaignAd
		WHERE (id.IdOrganizationContact = pa.IdOrganizationContact OR id.IdInfluencerContact = pa.IdInfluencerContact)
			AND ca.IdCampaign = @IdCampaign

		-- SCHEDULES (optional if the schedule has already been stablished)
		INSERT INTO PASchedules (name, IdScheduleRecurrency, startDate, endDate, startHours, endHours, nextExecute, createdAt)
		SELECT cd.scheduleName, sr.IdScheduleRecurrency, cd.startDate, cd.endDate, cd.startHours, cd.endHours, '2025-01-01 00:00:00', GETDATE()
		FROM @channelData cd
		INNER JOIN PAScheduleRecurrencies sr ON cd.recurrency = sr.name
		INNER JOIN @PublishedAdIds id ON id.adTitle = cd.adTitle
		WHERE id.IdSchedule IS NULL AND id.contactChannel = cd.contactChannel 

		-- We update the ID for schedules inserted, (optional if the schedule has already been stablished)
		UPDATE id
		SET id.IdSchedule = s.IdSchedule
		FROM @PublishedAdIds id
		INNER JOIN PASchedules s ON s.name = id.scheduleName 
		WHERE id.IdSchedule IS NULL
		
		-- AdSchedules
		INSERT INTO PAAdSchedules (IdPublishedAd, IdSchedule)
		SELECT IdPublishedAd, IdSchedule
		FROM @PublishedAdIds
		-- ----------------- 

		-- TARGET PUBLIC (optional if the TargetPublic has already been stablished)
		-- We use distinct to obtain only the publics with different name
		INSERT INTO PATargetPublics (name, description)			
		SELECT DISTINCT td.targetName, td.targetDesc
		FROM @targetPublicData td
		INNER JOIN @AdIds id ON id.adTitle = td.adTitle 
		WHERE id.IdTarget IS NULL
		
		-- Target configuration will relate Features with the newly created public, (optional if the TargetPublic has already been stablished)
		-- The group by makes sure the public values get grouped to the target public with the same name
		INSERT INTO PATargetConfigurations (IdTargetPublic, IdPublicValue)
		SELECT tp.IdTargetPublic, pv.IdPublicValue
		FROM @targetPublicData td
		INNER JOIN PAPublicValues pv ON pv.name = td.featureName
		INNER JOIN PATargetPublics tp ON tp.name = td.targetName
		INNER JOIN @AdIds id ON id.adTitle = td.adTitle 
		WHERE id.IdTarget IS NULL
		GROUP BY tp.IdTargetPublic, pv.IdPublicValue

		-- We update the ID for the targetPublics inserted  (optional if the TargetPublic has already been stablished)
		UPDATE id
		SET id.IdTarget = tp.IdTargetPublic
		FROM @AdIds id
		INNER JOIN PATargetPublics tp ON tp.name = id.targetName
		WHERE id.IdTarget IS NULL

		INSERT INTO PAAdPublics (IdCampaignAd, IdTargetPublic)
		SELECT id.IdAd, id.IdTarget
		FROM @AdIds id
		
		-- We create an info Log registering the succesful insert of a campaign
		INSERT INTO PALogs (description, computer, username, IdRef1, value1, IdLogType, IdLogLevel, IdLogSource) VALUES
		(CONCAT('Inserted the new campaign ', @campaignName, ' from the organization ', @organizationName), 'computer', 'username', @IdCampaign, @campaignName, @IdLogType, @IdLogLevel, @IdLogSource)
		
		IF @InicieTransaccion=1 BEGIN
			COMMIT
		END
	END TRY
	BEGIN CATCH
		
		SET @ErrorNumber = ERROR_NUMBER()
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorState = ERROR_STATE()
		SET @Message = ERROR_MESSAGE()
		
		IF @InicieTransaccion=1 BEGIN
			ROLLBACK
		END
		-- We create an error Log
		INSERT INTO PALogs (description, computer, username, value1, IdLogType, IdLogLevel, IdLogSource) VALUES
		(CONCAT('Failure while inserting the campaign ', @campaignName, ' from the organization ', @organizationName), 'computer', 'username', @campaignName, @IdLogType, @IdLogLevelErr, @IdLogSource)

		RAISERROR('%s - Error Number: %i', 
			@ErrorSeverity, @ErrorState, @Message, @CustomError) -- hay que sustituir el @message por un error personalizado bonito, lo ideal es sacarlo de sys.messages 
		-- en la tabla de sys.messages se pueden insertar mensajes personalizados de error, los cuales se les hace match con el numero en @CustomError
	END CATCH	
END
RETURN 0
GO


/*	PARAMETERS:
    @organizationName VARCHAR(60),
    @campaignName VARCHAR(60),
    @campaignDesc VARCHAR(200),
	@campaignCity VARCHAR(60),
	@campaignStartDate DATE,
	@campaignEndDate DATE,
	@adData dbo.AdData READONLY,
	@channelData dbo.ChannelData READONLY,
	@targetPublicData dbo.TargetPublicData READONLY
*/

DECLARE @adTVP dbo.AdData
DECLARE @channelTVP dbo.ChannelData
DECLARE @targetPublicTVP dbo.TargetPublicData

INSERT INTO @adTVP (adTitle, adDescription, adType, budget, currency) VALUES
('Anuncio 1', 'Descripcion anuncio 1', 'Pop-up', 900.00, 'USD'),
('Anuncio 2', 'Descripcion anuncio 2', 'Pop-up', 1600.00, 'USD'),
('Anuncio 3', 'Descripcion anuncio 3', 'Pop-up', 800.00, 'USD')

INSERT INTO @channelTVP (adTitle, contactValue, contactChannel, body, redirectURL, scheduleName, startDate, endDate, startHours, endHours, recurrency) VALUES
('Anuncio 1', 'epicfoundation5647@gmail.com', 'Gmail', 'Cuerpo de anuncio 1 por Gmail', 'URL', 'Horario 1', NULL, NULL, NULL, NULL, NULL),
('Anuncio 1', '@epicfoundation_official', 'TikTok', 'Cuerpo de anuncio 1 por TikTok', 'URL', 'Horario 2', '2025-11-01', '2025-12-01', '17:00:00', '21:00:00', 'Weekly'),
('Anuncio 1', 'linkedin.com/in/epicfoundation-official', 'LinkedIn', 'Cuerpo de anuncio 1 por LinkedIn', 'URL', 'Horario 1', NULL, NULL, NULL, NULL, NULL),
('Anuncio 2', '@epicfoundation_official', 'TikTok', 'Cuerpo de anuncio 2 por TikTok', 'URL', 'Horario 4', '2025-11-15', '2025-11-20', '18:00:00', '20:00:00', 'Daily'),
('Anuncio 3', '@epicfoundation_official', 'TikTok', 'Cuerpo de anuncio 3 por TikTok', 'URL', 'Horario 5', '2025-11-18', '2025-11-20', '18:00:00', '20:00:00', 'Daily')

INSERT INTO @targetPublicTVP (adTitle, targetName, targetDesc, featureName) VALUES
('Anuncio 1', 'Poblacion 1', 'Descripcion de la poblacion 1', 'Ages from: 30 to 46'),
('Anuncio 1', 'Poblacion 1', 'Descripcion de la poblacion 1', 'gender: Male'),
('Anuncio 1', 'Poblacion 1', 'Descripcion de la poblacion 1', 'interests: gardening'),
('Anuncio 2', 'Ages from: 68 to 77 interests: cooking', NULL, NULL),
('Anuncio 3', 'Ages from: 64 to 80 occupation: Chef', NULL, NULL)

EXEC [dbo].[PA_SPInsertCampaign] 'Epic Foundation', 'Campanna Prueba', 'Descripcion', 'San Diego', '2025-11-01', '2025-12-01', @adTVP, @channelTVP, @targetPublicTVP

DROP PROCEDURE dbo.PA_SPInsertCampaign
DROP TYPE dbo.AdData
DROP TYPE dbo.ChannelData
DROP TYPE dbo.TargetPublicData

SELECT * FROM PACampaigns ORDER BY IdCampaign DESC
SELECT * FROM PACampaignAds ORDER BY IdCampaignAd DESC
SELECT * FROM PAPublishedAds ORDER BY IdPublishedAd DESC
SELECT * FROM PATargetPublics ORDER BY IdTargetPublic DESC
SELECT * FROM PATargetConfigurations ORDER BY IdTargetConfiguration DESC
SELECT * FROM PASchedules ORDER BY IdSchedule DESC
SELECT * FROM PAAdSchedules ORDER BY IdAdSchedule DESC
SELECT * FROM PAAdPublics ORDER BY IdCampaignPublic DESC
SELECT * FROM PAAdBudgets ORDER BY IdAdBudget DESC
SELECT * FROM PALogs


DELETE FROM PAAdPublics WHERE IdCampaignPublic > 4000
DELETE FROM PAAdSchedules
DELETE FROM PAPublishedAds WHERE IdPublishedAd > 20000
DELETE FROM PASchedules
DELETE FROM PAAdBudgets
DELETE FROM PACampaignAds WHERE IdCampaignAd > 5000
DELETE FROM PACampaigns WHERE IdCampaign > 2000
DELETE FROM PATargetConfigurations WHERE IdTargetPublic > 700
DELETE FROM PATargetPublics WHERE IdTargetPublic > 700


SELECT * FROM PAPublicValues
-- insert into PASchedules (name, IdScheduleRecurrency, startDate, endDate, startHours, endHours, nextExecute, createdAt) VALUES ('Horario 1', 1, '2025-11-01', '2025-12-01', '12:00:00', '23:00:00', '2025-11-01', GETDATE())