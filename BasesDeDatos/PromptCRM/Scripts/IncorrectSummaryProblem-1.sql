/* 
 -------------------
 Incorrect summary problem
 -------------------
 -- The incorrect summary problem displays an inconsistency of summarized data provoked by phantom reads
 -- A query with uncommitted read, committed read or repeatable reads may show this problem
*/

use promptcrm;


GO
CREATE OR ALTER PROCEDURE [dbo].SP_ConsultClientExpenses
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

    -- TRANSACTION BEGINS
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1

		-- The isolation level will be read committed in order to make queries quicker and only check committed information
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		SELECT c.IdClient, c.ClientCode, s.StatusDescription, SUM(h.SaleTotal) AS totalExpenses,
			CASE 
				WHEN SUM(h.SaleTotal) < 8000 THEN 'Low'
				WHEN SUM(h.SaleTotal) < 12000 THEN 'Medium'
				ELSE 'High'
		    END AS ExpenseLevel
		FROM PCRClients c
		INNER JOIN PCRClientStatuses s ON s.IdStatus = c.IdStatus
		INNER JOIN PCRSalesHistory h ON c.IdClient = h.IdClient
		GROUP BY c.IdClient, c.ClientCode, s.StatusDescription
		ORDER BY c.ClientCode

		-- we use a delay to simulate the concurrency that produces the incorrect summary problem
		-- an insert operation is made in between both
		WAITFOR DELAY '00:00:05'

		SELECT c.IdClient, c.ClientCode, SUM(h.SaleTotal) AS totalExpenses,
			CASE 
				WHEN SUM(h.SaleTotal) < 8000 THEN 'Low'
				WHEN SUM(h.SaleTotal) < 12000 THEN 'Medium'
				ELSE 'High'
		    END AS ExpenseLevel
		FROM PCRClients c
		INNER JOIN PCRSalesHistory h ON c.IdClient = h.IdClient
		GROUP BY c.IdClient, c.ClientCode
		ORDER BY c.ClientCode

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

EXEC [dbo].SP_ConsultClientExpenses

/* 
 -------------------
 Incorrect summary problem (SOLUTION)
 -------------------
 -- To fix this problem, use SERIALIZABLE
 -- Any modification SP over these rows will occur AFTER this SP, thus assuring no modification is made while reading
*/

GO
CREATE OR ALTER PROCEDURE [dbo].SP_ConsultClientExpenses
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

    -- TRANSACTION BEGINS
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1

		-- The best way to avoid this problem is using a SERIALIZABLE isolation level
		-- This will block other transactions
		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		SELECT c.IdClient, c.ClientCode, s.StatusDescription, SUM(h.SaleTotal) AS totalExpenses,
			CASE 
				WHEN SUM(h.SaleTotal) < 8000 THEN 'Low'
				WHEN SUM(h.SaleTotal) < 12000 THEN 'Medium'
				ELSE 'High'
		    END AS ExpenseLevel
		FROM PCRClients c
		INNER JOIN PCRClientStatuses s ON s.IdStatus = c.IdStatus
		INNER JOIN PCRSalesHistory h ON c.IdClient = h.IdClient
		GROUP BY c.IdClient, c.ClientCode, s.StatusDescription
		ORDER BY c.ClientCode

		-- we use a delay to simulate the concurrency that produces the incorrect summary problem
		-- an insert operation is made in between both
		WAITFOR DELAY '00:00:05'

		SELECT c.IdClient, c.ClientCode, SUM(h.SaleTotal) AS totalExpenses,
			CASE 
				WHEN SUM(h.SaleTotal) < 8000 THEN 'Low'
				WHEN SUM(h.SaleTotal) < 12000 THEN 'Medium'
				ELSE 'High'
		    END AS ExpenseLevel
		FROM PCRClients c
		INNER JOIN PCRSalesHistory h ON c.IdClient = h.IdClient
		GROUP BY c.IdClient, c.ClientCode
		ORDER BY c.ClientCode

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

EXEC [dbo].SP_ConsultClientExpenses

/*

SELECT * FROM dbo.PCRFeatureTypes
SELECT * FROM dbo.PCRClientStatuses
SELECT * FROM PCRFeaturesPerClients
SELECT * FROM dbo.PCRClients
SELECT * FROM dbo.PCRSalesHistory



DECLARE @i INT = 0
WHILE @i < 5000
BEGIN
	DECLARE @j INT = 0
	DECLARE @rand INT = CAST(RAND() + (10) AS INT)
	WHILE @j < @rand
	BEGIN
		INSERT INTO PCRSalesHistory (IdClient, SaleTotal, CreatedAt, UpdatedAt, [Checksum]) VALUES (@i, CAST(RAND() * (1900) + 100 AS DECIMAL(10,2)), GETDATE(), GETDATE(), 1)
		SET @j = @j + 1
	END
	SET @i = @i + 1
END

*/