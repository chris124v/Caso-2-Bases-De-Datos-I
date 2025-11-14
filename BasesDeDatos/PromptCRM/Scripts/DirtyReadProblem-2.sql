/* 
 -------------------
 Dirty read problem
 -------------------
 -- To demonstrate this problem, we made a function that adds a specific number to a client's age
 -- Due to dirty reads, SP_AddToClientAge might display inconsistent data
 -- This is caused by READ UNCOMMITTED
*/

use promptcrm

GO
CREATE OR ALTER PROCEDURE [dbo].SP_AddToClientAge
	@clientcode VARCHAR(30),
	@addToAge VARCHAR(50)
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	-- Variables for the SP
	DECLARE @idclient INT
	DECLARE @idFeatureType VARCHAR(20)
	DECLARE @newAgeValue VARCHAR(50)
	
	-- Queries before the execution
	SELECT @idclient = IdClient
	FROM PCRClients
	WHERE ClientCode = @clientcode

	SELECT @idFeatureType = IdFeatureType
	FROM PCRFeatureTypes
	WHERE TypeName = 'Age'

	-- Validation for the parameter @addToAge
	IF TRY_CAST(@addToAge AS INT) IS NULL
	BEGIN
		RAISERROR('The value to add is not a number', 16, 1)
	END

    -- TRANSACTION BEGINS
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
 
		-- The READ UNCOMMITTED isolation level is what causes the dirty reads
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		-- It reads the dirty value
		SELECT @newAgeValue = FeatureValue 
		FROM PCRFeaturesPerClients
		WHERE @idclient = IdClient AND IdFeatureType = @idFeatureType

		SET @newAgeValue = CAST(CAST(@newAgeValue AS INT) + @addToAge AS varchar(50))

		-- And modifies it despite SP_ChangeClientFeature may fail
		UPDATE PCRFeaturesPerClients
		SET FeatureValue = @newAgeValue,
			UpdatedAt = GETDATE()
		WHERE IdClient = @idclient AND IdFeatureType = @idFeatureType
		
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

EXEC [dbo].SP_AddToClientAge @clientcode = '10010458', @addToAge = '10'

-- It will use the data from the uncommitted SP_ChangeClientFeature query
SELECT * FROM PCRFeaturesPerClients WHERE IdClient = '4375'


/* 
 -------------------
 Dirty read problem (SOLUTION)
 -------------------
 -- To fix the issue, we change the isolation level from READ UNCOMMITTED to READ COMMITTED 
 -- You can notice that this transaction waits for the other to finish
*/

GO
CREATE OR ALTER PROCEDURE [dbo].SP_AddToClientAgeFIXED
	@clientcode VARCHAR(30),
	@addToAge VARCHAR(50)
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	-- Variables for the SP
	DECLARE @idclient INT
	DECLARE @idFeatureType VARCHAR(20)
	DECLARE @newAgeValue VARCHAR(50)
	
	-- Queries before the execution
	SELECT @idclient = IdClient
	FROM PCRClients
	WHERE ClientCode = @clientcode

	SELECT @idFeatureType = IdFeatureType
	FROM PCRFeatureTypes
	WHERE TypeName = 'Age'

	-- Validation for the parameter @addToAge
	IF TRY_CAST(@addToAge AS INT) IS NULL
	BEGIN
		RAISERROR('The value to add is not a number', 16, 1)
	END

    -- TRANSACTION BEGINS
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
 
		-- We fix it with READ COMMITTED, or any isolation level above
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		-- This read will always be on a committed row
		SELECT @newAgeValue = FeatureValue 
		FROM PCRFeaturesPerClients
		WHERE @idclient = IdClient AND IdFeatureType = @idFeatureType

		SET @newAgeValue = CAST(CAST(@newAgeValue AS INT) + @addToAge AS varchar(50))

		UPDATE PCRFeaturesPerClients
		SET FeatureValue = @newAgeValue,
			UpdatedAt = GETDATE()
		WHERE IdClient = @idclient AND IdFeatureType = @idFeatureType
		
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

-- It will use prior data instead of information coming from the uncommitted SP_ChangeClientFeature query
EXEC [dbo].SP_AddToClientAgeFIXED @clientcode = '10010458', @addToAge = '10'

SELECT * FROM PCRFeaturesPerClients WHERE IdClient = '4375'

