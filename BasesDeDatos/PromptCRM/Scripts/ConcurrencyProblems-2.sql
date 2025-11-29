USE promptcrm

GO
CREATE OR ALTER PROCEDURE [dbo].[SPDirtyRead2]
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	DECLARE @CurrentQty INT


	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		BEGIN TRANSACTION		
	END

	BEGIN TRY
		SET @CustomError = 2001

		-- Lee los datos actualizados antes del rollback del otro cliente
		SELECT @CurrentQty = Quantity FROM dbo.##ProductsTest
		WHERE IdProduct = 3

		IF @CurrentQty = 0
		BEGIN
			;THROW 50002, 'No hay productos', 1
		END

		UPDATE dbo.##ProductsTest
		SET Quantity = Quantity - 3
		WHERE IdProduct = 3
					
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
		RAISERROR('%s - Error Number: %i', 
			@ErrorSeverity, @ErrorState, @Message, @CustomError)
	END CATCH	
END
RETURN 0
GO

GO
CREATE OR ALTER PROCEDURE [dbo].[SPIncorrectSummary2]
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	DECLARE @CurrTime DATETIME = CURRENT_TIMESTAMP


	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		-- actualiza los datos mientras el otro sp esta en media lectura

		INSERT INTO dbo.##ProductsTest (ProductName, Price, Quantity, CreatedAt, UpdatedAt)
		VALUES
			('Galletas Chiky', 2000, 5, @CurrTime, @CurrTime)
					
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
		RAISERROR('%s - Error Number: %i', 
			@ErrorSeverity, @ErrorState, @Message, @CustomError)
	END CATCH	
END
RETURN 0
GO

GO
CREATE OR ALTER PROCEDURE [dbo].[SPLostUpdate2]
AS 
BEGIN	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT
	

	DECLARE @ProductQuantity INT


	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		-- lee los mismos datos que SP1
		SELECT @ProductQuantity = Quantity FROM dbo.##ProductsTest
		WHERE IdProduct = 2

		WAITFOR DELAY '00:00:10'

		-- sobreescribe el update de SP1
		UPDATE dbo.##ProductsTest
		SET Quantity = @ProductQuantity + 5
		WHERE IdProduct = 2
					
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
		RAISERROR('%s - Error Number: %i', 
			@ErrorSeverity, @ErrorState, @Message, @CustomError)
	END CATCH	
END
RETURN 0
GO

/*
EXEC dbo.SPDirtyRead2
EXEC dbo.SPIncorrectSummary2
EXEC dbo.SPLostUpdate2
*/

/*
SELECT * FROM dbo.##ProductsTest
SELECT SUM(Quantity), SUM(Quantity * Price) FROM dbo.##ProductsTest
*/