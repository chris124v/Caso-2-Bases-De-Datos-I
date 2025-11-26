GO
CREATE OR ALTER PROCEDURE [dbo].[PCRSP_RegisterLog]
    @LogDescription    VARCHAR(50),
    @RefID             BIGINT,
    @Checksum          VARBINARY(30),
    @IdType            INT,
    @IdLevel           INT,
    @IdSource          INT,

    @IdUser            INT = NULL,
    @Computer          VARCHAR(20) = NULL,
    @CreatedAt         DATETIME = NULL
AS 
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	-- Otras declaraciones


	-- Selects / Sets

	IF @CreatedAt IS NULL
		SET @CreatedAt = GETDATE()

	IF @Computer IS NULL
		SET @Computer = HOST_NAME()

	SET @InicieTransaccion = 0
	IF @@TRANCOUNT = 0
	BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		BEGIN TRANSACTION
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		-- Insert / Update

		INSERT INTO dbo.PCRLogs (
			LogDescription,
			RefID,
			Checksum,
			IdType,
			IdLevel,
			IdSource,
			IdUser,
			Computer,
			CreatedAt,
			UpdatedAt
		)
		VALUES (
			@LogDescription,
			@RefID,
			@Checksum,
			@IdType,
			@IdLevel,
			@IdSource,
			@IdUser,
			@Computer,
			@CreatedAt,
			@CreatedAt
		)

		IF @InicieTransaccion = 1
			COMMIT
	END TRY

	BEGIN CATCH
		SET @ErrorNumber = ERROR_NUMBER()
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorState = ERROR_STATE()
		SET @Message = ERROR_MESSAGE()
		
		IF @InicieTransaccion = 1
			ROLLBACK;

		RAISERROR('%s - Error Number: %i', 
				  @ErrorSeverity, @ErrorState,
				  @Message, @CustomError)
	END CATCH
END
RETURN 0
GO