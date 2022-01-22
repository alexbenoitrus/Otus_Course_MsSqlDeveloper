CREATE TABLE [Report].[OrderLine] (
    [Id]         BIGINT          IDENTITY (1, 1) NOT NULL,
    [Name]       NVARCHAR (100)  NOT NULL,
    [Externalid] NVARCHAR (50)   NULL,
    [OrderId]    BIGINT          NOT NULL,
    [ProductId]  BIGINT          NOT NULL,
    [Count]      DECIMAL (18, 3) NOT NULL,
    [Price]      DECIMAL (18, 2) NOT NULL,
    [Sum]        DECIMAL (18, 2) NOT NULL,
    [Discount]   DECIMAL (18, 2) NOT NULL,
    CONSTRAINT [PK_Report_OrderLine] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Report_OrderLine_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [Report].[Order] ([id]),
    CONSTRAINT [FK_Report_OrderLine_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Catalog].[Product] ([Id])
);






GO



GO



GO
CREATE NONCLUSTERED INDEX [FKIDX_Report_OrderLine_ProductId]
    ON [Report].[OrderLine]([ProductId] ASC);


GO
CREATE NONCLUSTERED INDEX [FKIDX_Report_OrderLine_OrderId]
    ON [Report].[OrderLine]([OrderId] ASC);


GO
CREATE NONCLUSTERED INDEX [FKIDX_Report_OrderLine_Externalid]
    ON [Report].[OrderLine]([Externalid] ASC);

