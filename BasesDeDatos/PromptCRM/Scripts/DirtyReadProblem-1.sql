use promptcrm

GO
CREATE OR ALTER PROCEDURE [dbo].SP_ChangeClientFeature
	@clientcode VARCHAR(30),
	@featureName VARCHAR(20),
	@newValue VARCHAR(50)
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	-- Variables for the SP
	DECLARE @idclient INT
	DECLARE @idfeatureType INT

	-- Queries before the execution
	SELECT @idclient = IdClient
	FROM PCRClients
	WHERE ClientCode = @clientcode

	SELECT @idfeatureType = IdFeatureType
	FROM PCRFeatureTypes
	WHERE TypeName = @featureName

    -- TRANSACTION BEGINS
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
 
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		UPDATE PCRFeaturesPerClients
		SET FeatureValue = @newValue,
		    updatedAt = GETDATE()
		WHERE IdClient = @idclient AND IdFeatureType = @idfeatureType

		WAITFOR DELAY '00:00:04'

		-- This validation would be better placed before the Transactions starts, however
		-- to show the dirty read problem, we will have the validation here
		IF @featureName = 'Age' AND CAST(@newValue AS INT) < 18
		BEGIN
			RAISERROR('The client can not be under 18 years old', 16, 1)
		END

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
		-- Error messages from the transaction
		RAISERROR('%s - Error Number: %i', 
			@ErrorSeverity, @ErrorState, @Message, @CustomError)
	END CATCH	
END
RETURN 0
GO

EXEC [dbo].SP_ChangeClientFeature @clientcode = '10010458', @featureName = 'Age', @newValue = '20'

-- Waits for the other transaction to finish
WAITFOR DELAY '00:00:01'
SELECT * FROM PCRFeaturesPerClients WHERE IdClient = '4375'
