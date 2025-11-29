USE promptcrm

IF OBJECT_ID('tempdb.dbo.##ProductsTest') IS NOT NULL DROP TABLE ##ProductsTest
CREATE TABLE ##ProductsTest (
	IdProduct INT PRIMARY KEY IDENTITY(1,1),
	ProductName VARCHAR(30),
	Price DECIMAL(16,2),
	Quantity INT,
	CreatedAt DATETIME,
	UpdatedAt DATETIME
)

-- Se soluciona con Read Committed
GO
CREATE OR ALTER PROCEDURE [dbo].[SPDirtyRead1]
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT


	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		-- Actualiza los datos pero luego hace rollback
		UPDATE dbo.##ProductsTest
		SET Quantity = 0
		WHERE IdProduct = 3

		WAITFOR DELAY '00:00:15'

		;THROW 50001, 'Compra fallida', 1
					
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

-- Se soluciona con repeatable read o con operacion atomica
GO
CREATE OR ALTER PROCEDURE [dbo].[SPIncorrectSummary1]
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	DECLARE @TotalStock INT
	DECLARE @TotalStockValue DECIMAL(16,2)


	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		BEGIN TRANSACTION		
	END

	
	
	BEGIN TRY
		SET @CustomError = 2001

		-- lee una columna, espera y lee la otra
		SELECT @TotalStock = SUM(Quantity) FROM dbo.##ProductsTest
		WAITFOR DELAY '00:00:10'
		SELECT @TotalStockValue = SUM(Quantity * Price) FROM dbo.##ProductsTest
		SELECT @TotalStock TotalStock, @TotalStockValue PredictedValue
					
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


-- Se soluciona con repeatable read o con un select/update atomico
GO
CREATE OR ALTER PROCEDURE [dbo].[SPLostUpdate1]
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

		-- lee los datos y espera
		SELECT @ProductQuantity = Quantity FROM dbo.##ProductsTest
		WHERE IdProduct = 2

		WAITFOR DELAY '00:00:10'

		-- los actualiza luego de que SP2 los lee
		UPDATE dbo.##ProductsTest
		SET Quantity = @ProductQuantity + 15
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

DELETE FROM dbo.##ProductsTest
DBCC CHECKIDENT('tempdb.dbo.##ProductsTest', reseed, 1)
DECLARE @CurrTime DATETIME = CURRENT_TIMESTAMP
INSERT INTO dbo.##ProductsTest (ProductName, Price, Quantity, CreatedAt, UpdatedAt)
VALUES
	('Salsa Lizano', 1200, 23, @CurrTime, @CurrTime),
	('Cepillo de Dientes', 2000, 15, @CurrTime, @CurrTime),
	('Detergente', 3500, 10, @CurrTime, @CurrTime)

/*
EXEC dbo.SPDirtyRead1
EXEC dbo.SPIncorrectSummary1
EXEC dbo.SPLostUpdate1
*/

/*
SELECT * FROM dbo.##ProductsTest
SELECT SUM(Quantity), SUM(Quantity * Price) FROM dbo.##ProductsTest
*/