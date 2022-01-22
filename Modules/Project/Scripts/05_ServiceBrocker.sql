
-------- Enable SB --------

--ALTER DATABASE Otus_Project_2 SET ENABLE_BROKER; 
use Otus_Project_2
alter database Otus_Project_2 set enable_broker with rollback immediate;
ALTER DATABASE Otus_Project_2 SET TRUSTWORTHY ON;
ALTER AUTHORIZATION ON DATABASE::Otus_Project_2 TO [sa];
GO

-------- Create Messages and Contracts --------

-- Create order report
CREATE MESSAGE TYPE [//WWI/SB/CreateOrderReportRequestMessage] VALIDATION=WELL_FORMED_XML;
CREATE MESSAGE TYPE [//WWI/SB/CreateOrderReportReplyMessage] VALIDATION=WELL_FORMED_XML; 
CREATE CONTRACT [//WWI/SB/CreateOrderReportContract]
(
	  [//WWI/SB/CreateOrderReportRequestMessage] SENT BY INITIATOR
	, [//WWI/SB/CreateOrderReportReplyMessage] SENT BY TARGET
);
GO

-------- Create Queue and Services --------

-- Create order report
CREATE QUEUE CreateOrderReportTargetQueueWWI;
CREATE SERVICE [//WWI/SB/CreateOrderReportTargetService]
       ON QUEUE CreateOrderReportTargetQueueWWI ([//WWI/SB/CreateOrderReportContract]);
GO

CREATE QUEUE CreateOrderReportInitiatorQueueWWI;
CREATE SERVICE [//WWI/SB/CreateOrderReportInitiatorService]
       ON QUEUE CreateOrderReportInitiatorQueueWWI ([//WWI/SB/CreateOrderReportContract]);
GO

-------- Subscribe SP to Queue --------

-- Create order report
ALTER QUEUE [dbo].[CreateOrderReportTargetQueueWWI] 
	  WITH STATUS = ON 
	, RETENTION = OFF 
	, POISON_MESSAGE_HANDLING (STATUS = OFF)
	, ACTIVATION 
		(  
			STATUS = ON 
			, PROCEDURE_NAME = [SB].[p_OrderReport_Create_Recieve]
			, MAX_QUEUE_READERS = 1
			, EXECUTE AS OWNER
		); 
GO

ALTER QUEUE [dbo].[CreateOrderReportInitiatorQueueWWI] 
	  WITH STATUS = ON 
	, RETENTION = OFF 
	, POISON_MESSAGE_HANDLING (STATUS = OFF) 
	, ACTIVATION 
		( 
			 STATUS = ON 
			, PROCEDURE_NAME = [SB].[p_OrderReport_Create_Confirm]
			, MAX_QUEUE_READERS = 1
			, EXECUTE AS OWNER
		); 
GO