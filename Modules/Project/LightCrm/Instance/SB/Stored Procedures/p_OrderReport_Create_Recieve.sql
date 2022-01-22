
CREATE PROCEDURE [SB].[p_OrderReport_Create_Recieve]
AS
BEGIN
	BEGIN TRY

		DECLARE 
			  @TargetDlgHandle UNIQUEIDENTIFIER
			, @EventId BIGINT
			, @Message NVARCHAR(4000)
			, @MessageType Sysname
			, @ReplyMessage NVARCHAR(4000)
			, @ReplyMessageName Sysname
			, @Xml XML; 
		
		BEGIN TRAN; 

		--Receive
		RECEIVE TOP(1)
			@TargetDlgHandle = Conversation_Handle,
			@Message = Message_Body,
			@MessageType = Message_Type_Name
		FROM 
			dbo.CreateOrderReportTargetQueueWWI; 

		-- Parse
		
		SET @Xml = CAST(@Message AS XML);

		SELECT 
			@EventId = R.Iv.value('@EventId','BIGINT')
		FROM 
			@Xml.nodes('/RequestMessage/EventId') as R(Iv);

		-- Process
		EXEC [Report].[p_OrderReport_Create] @EventId;

		-- Confirm
		IF @MessageType=N'//WWI/SB/CreateOrderReportRequestMessage'
		BEGIN
			SELECT @ReplyMessage = 
				(
					SELECT 0 AS ResultCode
					FOR XML PATH('ResponseMessage')
				); 
		
			SEND ON CONVERSATION @TargetDlgHandle
			MESSAGE TYPE [//WWI/SB/CreateOrderReportReplyMessage] (@ReplyMessage);
			END CONVERSATION @TargetDlgHandle;
		END 

		COMMIT TRAN;

	END TRY
	BEGIN CATCH

		DECLARE
			@ErrorNumber   int = error_number()
			, @ErrorSeverity int = error_severity()
			, @ErrorState    int = error_state();
			
		EXEC [Log].[p_error_save] '[SB].[p_OrderReport_Create_Recieve]', @@ERROR, NULL
		raiserror(@ErrorNumber, @ErrorSeverity, @ErrorState);

	END CATCH
END