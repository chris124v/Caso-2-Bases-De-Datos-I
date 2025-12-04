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
 -- To fix this problem, use a temporary table
 -- Any summary made will be made with the same information read inside the transaction
*/

GO
CREATE OR ALTER PROCEDURE [dbo].SP_ConsultClientExpenses
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	-- Temporary table
	CREATE TABLE #TempSales (
		IdSale INT,
		IdClient INT,
		SaleTotal DECIMAL(16,2)
	);
	-- We get the values for the transaction before starting
	INSERT INTO #TempSales (IdSale, IdClient, SaleTotal)
	SELECT IdSale, IdClient, SaleTotal
	FROM PCRSalesHistory

    -- TRANSACTION BEGINS
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		SELECT c.IdClient, c.ClientCode, s.StatusDescription, SUM(ts.SaleTotal) AS totalExpenses,
			CASE 
				WHEN SUM(ts.SaleTotal) < 8000 THEN 'Low'
				WHEN SUM(ts.SaleTotal) < 12000 THEN 'Medium'
				ELSE 'High'
		    END AS ExpenseLevel
		FROM PCRClients c
		INNER JOIN PCRClientStatuses s ON s.IdStatus = c.IdStatus
		INNER JOIN #TempSales ts ON c.IdClient =ts.IdClient
		GROUP BY c.IdClient, c.ClientCode, s.StatusDescription
		ORDER BY c.ClientCode

		-- we use a delay to simulate the concurrency that produces the incorrect summary problem
		-- an insert operation is made in between both
		WAITFOR DELAY '00:00:05'

		SELECT c.IdClient, c.ClientCode, SUM(ts.SaleTotal) AS totalExpenses,
			CASE 
				WHEN SUM(ts.SaleTotal) < 8000 THEN 'Low'
				WHEN SUM(ts.SaleTotal) < 12000 THEN 'Medium'
				ELSE 'High'
		    END AS ExpenseLevel
		FROM PCRClients c
		INNER JOIN #TempSales ts ON c.IdClient =ts.IdClient
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
SELECT * FROM dbo.PCRUTMData


INSERT INTO PCRUTMData (UTMSource, UTMMedium, UTMCampaign, UTMTerm, UTMContent, CreatedAt) VALUES
('google', 'cpc', 'black_friday_sale', 'running+shoes', 'banner', GETDATE()),
('facebook', 'social', 'holiday_promo', 'gift+ideas', 'pop-up', GETDATE())

DECLARE @i INT = 1
WHILE @i < 5000
BEGIN
	DECLARE @j INT = 0
	DECLARE @rand INT = CAST(RAND() + (10) AS INT)
	WHILE @j < @rand
	BEGIN
		INSERT INTO PCRSalesHistory (IdClient, SaleTotal, CreatedAt, UpdatedAt, [Checksum], IdUTM) VALUES (@i, CAST(RAND() * (1900) + 100 AS DECIMAL(10,2)), GETDATE(), GETDATE(), 1, 2)
		SET @j = @j + 1
	END
	SET @i = @i + 1
END

*/