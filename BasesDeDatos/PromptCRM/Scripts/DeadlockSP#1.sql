use PromptCrm
IF OBJECT_ID('tempdb.dbo.##ProductsTest') IS NOT NULL DROP TABLE ##ProductsTest
CREATE TABLE ##ProductsTest (
	IdProduct INT PRIMARY KEY IDENTITY(1,1),
	ProductName VARCHAR(30),
	Price DECIMAL(16,2),
	Quantity INT,
	CreatedAt DATETIME,
	UpdatedAt DATETIME
)

GO
CREATE OR ALTER PROCEDURE [dbo].[SPDeadlock1]
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT


	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		UPDATE dbo.##ProductsTest
		SET
			Quantity = 22,
			UpdatedAt = CURRENT_TIMESTAMP
		WHERE IdProduct = 2;

		WAITFOR DELAY '00:00:02'

		EXEC dbo.SPDeadlock2

					
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

CREATE OR ALTER PROCEDURE [dbo].[SPDeadlock2]
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT
	
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		UPDATE dbo.##ProductsTest
		SET
			Price = 800,
			UpdatedAt = CURRENT_TIMESTAMP
		WHERE IdProduct = 3;

		WAITFOR DELAY '00:00:02'

		EXEC dbo.SPDeadlock3

					
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

CREATE OR ALTER PROCEDURE [dbo].[SPDeadlock3]
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		UPDATE dbo.##ProductsTest
		SET
			Quantity = 18,
			UpdatedAt = CURRENT_TIMESTAMP
		WHERE IdProduct = 2;

		EXEC dbo.SPDeadlock1
				
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



DELETE FROM dbo.##ProductsTest
DBCC CHECKIDENT('tempdb.dbo.##ProductsTest', reseed, 0)
DECLARE @CurrTime DATETIME = CURRENT_TIMESTAMP
INSERT INTO dbo.##ProductsTest (ProductName, Price, Quantity, CreatedAt, UpdatedAt)
VALUES
	('Salsa Lizano', 1200, 23, @CurrTime, @CurrTime),
	('Cepillo de Dientes', 2000, 15, @CurrTime, @CurrTime),
	('Detergente', 3500, 10, @CurrTime, @CurrTime)

SELECT * FROM dbo.##ProductsTest

EXEC dbo.SPDeadlock1