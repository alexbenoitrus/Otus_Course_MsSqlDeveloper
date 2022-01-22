
CREATE PROCEDURE [SB].[p_OrderReport_Create_Confirm]
AS
BEGIN
	BEGIN TRY
		DECLARE 
			  @InitiatorReplyDlgHandle UNIQUEIDENTIFIER
			, @ReplyReceivedMessage NVARCHAR(1000) 
		
		BEGIN TRAN; 

			RECEIVE TOP(1)
				  @InitiatorReplyDlgHandle = Conversation_Handle
				, @ReplyReceivedMessage = Message_Body
			FROM 
				dbo.CreateOrderReportInitiatorQueueWWI; 
			
			END CONVERSATION @InitiatorReplyDlgHandle; 

		COMMIT TRAN; 

	END TRY
	BEGIN CATCH

		DECLARE
			@ErrorNumber   int = error_number()
			, @ErrorSeverity int = error_severity()
			, @ErrorState    int = error_state();
			
		EXEC [Log].[p_error_save] '[SB].[p_OrderReport_Create_Confirm]', @@ERROR, NULL
		raiserror(@ErrorNumber, @ErrorSeverity, @ErrorState);

	END CATCH
END