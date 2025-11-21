use promptcrm

INSERT INTO dbo.PCRCampaignStatuses (StatusDescription)
VALUES ('Vigente'), ('Acabada')

CREATE TYPE dbo.CampaignsFromAds AS TABLE (
	IdCampaign INT IDENTITY(1,1) PRIMARY KEY,
	CampaignName VARCHAR(MAX),
	StartsAt DATETIME,
	EndsAt DATETIME
)

INSERT INTO dbo.CampaignsFromAds (CampaignName, StartsAt, EndsAt)
SELECT name, StartsAt, EndsAt
FROM [DESKTOP-65RRTMG\LINKEDSERVERTEST].[promptads].[dbo].[PACampaigns]
WHERE deleted = 0;

CREATE TYPE dbo.UTMMediums AS TABLE (
	IdMedium INT IDENTITY(1,1) PRIMARY KEY,
	MediumName VARCHAR(MAX)
)

INSERT INTO dbo.UTMMediums (MediumName)
VALUES ('Ad'),('Video'),('Social'),('Email'),('Referral')

CREATE TYPE dbo.UTMSources AS TABLE (
	IdSource INT IDENTITY(1,1) PRIMARY KEY,
	SourceName VARCHAR(MAX)
)

INSERT INTO dbo.UTMSources (SourceName)
VALUES ('Google'),('Newsletter'),('Facebook'),('Youtube'),('Yahoo'),('Reddit'),('Twitter')


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

		INSERT INTO dbo.PCRUTMData (UTMCampaign, UTMMedium, UTMSource)
		VALUES (@RandomCampaign, @RandomMedium, @RandomSource)

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