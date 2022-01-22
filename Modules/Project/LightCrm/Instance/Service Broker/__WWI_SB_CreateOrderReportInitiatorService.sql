CREATE SERVICE [//WWI/SB/CreateOrderReportInitiatorService]
    AUTHORIZATION [dbo]
    ON QUEUE [dbo].[CreateOrderReportInitiatorQueueWWI]
    ([//WWI/SB/CreateOrderReportContract]);

