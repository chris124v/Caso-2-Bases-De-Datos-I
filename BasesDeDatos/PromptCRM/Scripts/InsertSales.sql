USE promptcrm

INSERT INTO PCREventTypes (TypeName)
VALUES
	('Purchase'), ('Click'), ('Download')
INSERT INTO PCRLeadStatuses (StatusDescription)
VALUES
	('New'), ('AttemptedContact'), ('Qualified'), ('Converted')
GO
CREATE OR ALTER PROCEDURE dbo.PCRSP_InsertSales
	@ClientID INT,
	@UTMID INT,
	@CampaignID INT = 1
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT
	
	-- Declaracion de otras variables
	
	DECLARE @AmountPaid DECIMAL(16,2)
	DECLARE @StartTime DATETIME
	DECLARE @CurrentTime DATETIME
	DECLARE @SecondsDiff INT
	DECLARE @RandomSeconds INT
	DECLARE @RandomTime DATETIME
	DECLARE @Checksum INT
	DECLARE @LeadCode VARCHAR(20)
	DECLARE @EventRefID VARCHAR(20)
	DECLARE @NewLeadID INT
	
	-- Operaciones de select que no tengan que ser bloqueadas
	SET @AmountPaid = RAND() * (50000 - 1000) + 1000
	SELECT @StartTime = CreatedAt FROM dbo.PCRUTMData
	WHERE IdUTM = @UTMID
	SET @CurrentTime = CURRENT_TIMESTAMP
	SET @SecondsDiff = DATEDIFF(SECOND, @StartTime, @CurrentTime)
	SET @RandomSeconds = ROUND(((@SecondsDiff - 1) * RAND()), 0)
	SET @RandomTime = DATEADD(SECOND, @RandomSeconds, @StartTime)
	SET @Checksum = CHECKSUM(@ClientID, @AmountPaid, @RandomTime, @UTMID)
	SET @LeadCode = CAST(CONVERT(VARCHAR(255), NEWID()) AS VARCHAR(20))
	SET @EventRefId = CAST(CONVERT(VARCHAR(255), NEWID()) AS VARCHAR(20))
	
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
		INSERT INTO PCRLeads (LeadCode, IdCampaign, IdStatus, CreatedAt, UpdatedAt, Enabled)
		VALUES
			(@LeadCode, @CampaignID, 4, @RandomTime, @RandomTime, 1)
		SET @NewLeadID = SCOPE_IDENTITY()
		INSERT INTO PCREvents (IdEventType, EventRefID, EventDate, CreatedAt, UpdatedAt, IdLead, IdUTM)
		VALUES
			(1, @EventRefID, @RandomTime, @RandomTime, @RandomTime, @NewLeadID, @UTMID)
		INSERT INTO dbo.PCRSalesHistory (IdClient, SaleTotal, CreatedAt, UpdatedAt, Checksum, IdUTM)
		VALUES
			(@ClientID, @AmountPaid, @RandomTime, @RandomTime, @Checksum, @UTMID)
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

DECLARE @MAXClientID INT
DECLARE @RandomClientID INT
DECLARE @MAXUTMID INT
DECLARE @RandomSalesAmount INT
SELECT @MAXClientID = MAX(IdClient) FROM dbo.PCRClients
SELECT @MAXUTMID = MAX(IdUTM) FROM dbo.PCRUTMData
DECLARE @UTMID INT = 1

WHILE @UTMID <= @MAXUTMID
BEGIN
	SET @RandomSalesAmount = FLOOR(RAND() * (1000 - 400)) + 400
	DECLARE @i INT = 0
	WHILE @i < @RandomSalesAmount
	BEGIN
		SET @RandomClientID = FLOOR(RAND()*@MAXClientID) + 1
		EXEC dbo.PCRSP_InsertSales @RandomClientID, @UTMID, 1
		SET @i = @i + 1
	END
	SET @UTMID = @UTMID + 1
END

USE promptcrm
GO


-- Borrar datos del script para pruebas

-- 1. Primero eliminar PCRSalesHistory (depende de PCRClients y PCRUTMData)
DELETE FROM dbo.PCRSalesHistory;

-- 2. Eliminar PCREvents (depende de PCRLeads, PCREventTypes, PCRUTMData)
DELETE FROM dbo.PCREvents;

-- 3. Eliminar PCRLeads (depende de PCRLeadStatuses)
DELETE FROM dbo.PCRLeads;

-- 4. Eliminar los registros de las tablas de cat�logo
DELETE FROM dbo.PCREventTypes 
WHERE TypeName IN ('Purchase', 'Click', 'Download');

DELETE FROM dbo.PCRLeadStatuses 
WHERE StatusDescription IN ('New', 'AttemptedContact', 'Qualified', 'Converted');

-- 5. Opcional: Borrar el stored procedure
DROP PROCEDURE IF EXISTS dbo.PCRSP_InsertSales;

-- Reseteamos las Identitys

-- Solo ejecuta esto si quieres que los IDs vuelvan a empezar desde 1
DBCC CHECKIDENT ('PCRSalesHistory', RESEED, 0);
DBCC CHECKIDENT ('PCREvents', RESEED, 0);
DBCC CHECKIDENT ('PCRLeads', RESEED, 0);
DBCC CHECKIDENT ('PCREventTypes', RESEED, 0);
DBCC CHECKIDENT ('PCRLeadStatuses', RESEED, 0);

-- Verificacion

SELECT COUNT(*) AS SalesHistory FROM dbo.PCRSalesHistory;
SELECT COUNT(*) AS Events FROM dbo.PCREvents;
SELECT COUNT(*) AS Leads FROM dbo.PCRLeads;
SELECT COUNT(*) AS EventTypes FROM dbo.PCREventTypes;
SELECT COUNT(*) AS LeadStatuses FROM dbo.PCRLeadStatuses; 

SELECT * FROM PCRSalesHistory;