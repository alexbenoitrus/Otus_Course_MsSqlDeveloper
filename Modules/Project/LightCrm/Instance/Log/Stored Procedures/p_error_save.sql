CREATE PROCEDURE [Log].[p_error_save]
(	
	@ProcedureName nvarchar(300)
	, @ErrorCode int
    , @Parameters nvarchar(max)
)
AS
BEGIN
	BEGIN TRY
		DECLARE @ErrorMessage nvarchar(max) = ERROR_MESSAGE();

		INSERT INTO [Log].[Error]
           ([ProcedureName], [ErrorCode], [ErrorMessage], [Parameters], [Datetime])
		VALUES
           (@ProcedureName, @ErrorCode, @ErrorMessage, @Parameters, GETDATE())
	END TRY
	BEGIN CATCH
	END CATCH
END