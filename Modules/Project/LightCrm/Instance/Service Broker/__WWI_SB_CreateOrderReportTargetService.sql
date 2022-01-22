CREATE SERVICE [//WWI/SB/CreateOrderReportTargetService]
    AUTHORIZATION [dbo]
    ON QUEUE [dbo].[CreateOrderReportTargetQueueWWI]
    ([//WWI/SB/CreateOrderReportContract]);

