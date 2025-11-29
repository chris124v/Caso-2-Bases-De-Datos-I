use promptcrm

CREATE TYPE dbo.CampaignsFromAds AS TABLE (
	IdCampaign INT IDENTITY(1,1) PRIMARY KEY,
	CampaignName VARCHAR(MAX),
	StartsAt DATETIME,
	EndsAt DATETIME
)

CREATE TYPE dbo.UTMMediums AS TABLE (
	IdMedium INT IDENTITY(1,1) PRIMARY KEY,
	MediumName VARCHAR(MAX)
)

CREATE TYPE dbo.UTMSources AS TABLE (
	IdSource INT IDENTITY(1,1) PRIMARY KEY,
	SourceName VARCHAR(MAX)
)

GO
CREATE OR ALTER PROCEDURE dbo.PCRSP_InsertUTM
	@Campaigns dbo.CampaignsFromAds READONLY,
	@Mediums dbo.UTMMediums READONLY,
	@Sources dbo.UTMSources READONLY
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	-- Declaracion de otras variables
	DECLARE @MaxCampaignID INT
	DECLARE @MaxMediumID INT
	DECLARE @MaxSourceID INT

	DECLARE @RandomCampaignID INT
	DECLARE @RandomMediumID INT
	DECLARE @RandomSourceID INT

	DECLARE @RandomCampaign VARCHAR(MAX)
	DECLARE @RandomMedium VARCHAR(MAX)
	DECLARE @RandomSource VARCHAR(MAX)

	DECLARE @StartTime DATETIME
	DECLARE @CurrentTime DATETIME
	DECLARE @RandomTime DATETIME
	DECLARE @SecondsDiff INT
	DECLARE @RandomSeconds INT

	-- Operaciones de select que no tengan que ser bloqueadas

	SELECT @MaxCampaignID = MAX(IdCampaign) FROM @Campaigns
	SELECT @MaxMediumID = MAX(IdMedium) FROM @Mediums
	SELECT @MaxSourceID = MAX(IdSource) FROM @Sources

	SET @RandomCampaignID = FLOOR(RAND() * @MaxCampaignID) + 1
	SET @RandomMediumID = FLOOR(RAND() * @MaxMediumID) + 1
	SET @RandomSourceID = FLOOR(RAND() * @MaxSourceID) + 1

	SELECT @RandomCampaign = CampaignName FROM @Campaigns WHERE IdCampaign = @RandomCampaignID
	SELECT @RandomMedium = MediumName FROM @Mediums WHERE IdMedium = @RandomMediumID
	SELECT @RandomSource = SourceName FROM @Sources WHERE IdSource = @RandomSourceID

	SET @StartTime = '2020-01-01 00:00:00'
	SET @CurrentTime = CURRENT_TIMESTAMP

	SET @SecondsDiff = DATEDIFF(SECOND, @StartTime, @CurrentTime)
	SET @RandomSeconds = ROUND(((@SecondsDiff - 1) * RAND()), 0)
	SET @RandomTime = DATEADD(SECOND, @RandomSeconds, @StartTime)

	-- Inicio de la transaccion
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		-- A lo que vinimos

		INSERT INTO dbo.PCRUTMData (UTMCampaign, UTMMedium, UTMSource, CreatedAt)
		VALUES (@RandomCampaign, @RandomMedium, @RandomSource, @RandomTime)

		IF @InicieTransaccion=1 BEGIN
			COMMIT
		END
	END TRY
	BEGIN CATCH
		-- en esencia, lo que hay  que hacer es registrar el error real, y enviar para arriba un error custom 
		SET @ErrorNumber = ERROR_NUMBER()
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorState = ERROR_STATE()
		SET @Message = ERROR_MESSAGE()
		
		IF @InicieTransaccion=1 BEGIN
			ROLLBACK
		END
		-- el error original lo inserte en la tabla de logs, pero retorno a la capa superior un error en "bonito"
		RAISERROR('%s - Error Number: %i', 
			@ErrorSeverity, @ErrorState, @Message, @CustomError) -- hay que sustituir el @message por un error personalizado bonito, lo ideal es sacarlo de sys.messages 
		-- en la tabla de sys.messages se pueden insertar mensajes personalizados de error, los cuales se les hace match con el numero en @CustomError
	END CATCH	
END
RETURN 0
GO

DECLARE @CampaignNamesTVP AS dbo.CampaignsFromAds
DECLARE @UTMMediumsTVP AS dbo.UTMMediums
DECLARE @UTMSourcesTVP AS dbo.UTMSources

-- El FROM... hay que reemplazar el path por el nuevo linked server
INSERT INTO @CampaignNamesTVP (CampaignName, StartsAt, EndsAt)
SELECT name, StartsAt, EndsAt
FROM [DESKTOP-65RRTMG\LINKEDSERVERTEST].[promptads].[dbo].[PACampaigns]
WHERE deleted = 0;

INSERT INTO @UTMMediumsTVP (MediumName)
VALUES ('Ad'),('Video'),('Social'),('Email'),('Referral')

INSERT INTO @UTMSourcesTVP (SourceName)
VALUES ('Google'),('Newsletter'),('Facebook'),('Youtube'),('Yahoo'),('Reddit'),('Twitter')

DECLARE @i INT = 0
WHILE @i < 500
BEGIN
	EXEC dbo.PCRSP_InsertUTM @CampaignNamesTVP, @UTMMediumsTVP, @UTMSourcesTVP
	SET @i = @i + 1
END