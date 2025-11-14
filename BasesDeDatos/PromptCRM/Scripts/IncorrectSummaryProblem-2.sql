/* 
 -------------------
 Incorrect summary problem (parallel query)
 -------------------
*/

GO
CREATE OR ALTER PROCEDURE [dbo].SP_Insert4000Sale
	@clientcode VARCHAR(30)
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	DECLARE @idclient INT

	SELECT @idclient = IdClient
	FROM PCRClients
	WHERE ClientCode = @clientcode

    -- TRANSACTION BEGINS
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1

		-- The isolation level will be read uncommitted in order to make queries quicker
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		INSERT INTO PCRSalesHistory (IdClient, SaleTotal, CreatedAt, UpdatedAt, [Checksum]) 
		VALUES (@idclient, 4000, GETDATE(), GETDATE(), 1)

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


EXEC [dbo].SP_Insert4000Sale @clientcode = '10010458'
