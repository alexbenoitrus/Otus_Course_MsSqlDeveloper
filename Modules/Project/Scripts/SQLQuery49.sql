USE [Otus_Project_2]


exec [Report].[p_OrderReport_Create] 7
	
	select * FROM [Report].[Order]
	select * FROM [Report].[OrderLine]

GO



SELECT * FROM sys.service_contract_message_usages; 
SELECT * FROM sys.service_contract_usages;
SELECT * FROM sys.service_queue_usages;