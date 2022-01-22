
CREATE PROCEDURE [SB].[p_OrderReport_Create_Send]
(	
	@EventId BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		  @InitDlgHandle UNIQUEIDENTIFIER
		, @RequestMessage NVARCHAR(4000);
	
	BEGIN TRY
		BEGIN TRAN
		
			SELECT @RequestMessage = 
				(
					SELECT @EventId AS EventId
					FOR XML PATH('RequestMessage')
				); 
		
			BEGIN DIALOG @InitDlgHandle
			FROM SERVICE [//WWI/SB/CreateOrderReportInitiatorService]
			TO SERVICE '//WWI/SB/CreateOrderReportTargetService'
			ON CONTRACT	[//WWI/SB/CreateOrderReportContract]
			WITH ENCRYPTION=OFF; 

			SEND ON CONVERSATION @InitDlgHandle 
			MESSAGE TYPE [//WWI/SB/CreateOrderReportRequestMessage] (@RequestMessage);
		COMMIT TRAN 
		
	END TRY
	BEGIN CATCH

		DECLARE
			@ErrorNumber   int = error_number()
			, @ErrorSeverity int = error_severity()
			, @ErrorState    int = error_state();
			
		EXEC [Log].[p_error_save] '[SB].[p_OrderReport_Create_Send]', @@ERROR, Null
		raiserror(@ErrorNumber, @ErrorSeverity, @ErrorState);

	END CATCH
END