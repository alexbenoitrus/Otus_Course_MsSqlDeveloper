CREATE TABLE [Report].[Order] (
    [id]                     BIGINT          NOT NULL,
    [Date]                   DATETIME2 (7)   NOT NULL,
    [Sum]                    DECIMAL (18, 2) NOT NULL,
    [Discount]               DECIMAL (18, 2) NOT NULL,
    [SellerId]               BIGINT          NOT NULL,
    [SellerBusinessUnitId]   BIGINT          NOT NULL,
    [SellerFullName]         NVARCHAR (300)  NOT NULL,
    [SellerBusinessUnitName] NVARCHAR (100)  NOT NULL,
    [ClientId]               BIGINT          NOT NULL,
    [ClientBusinessUnitId]   BIGINT          NOT NULL,
    [ClientFullName]         NVARCHAR (300)  NOT NULL,
    [ClientBusinessUnitName] NVARCHAR (100)  NOT NULL,
    CONSTRAINT [PK_Report_Order] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_Report_Order_ClientBusinessUnitId] FOREIGN KEY ([ClientBusinessUnitId]) REFERENCES [Org].[BusinessUnit] ([Id]),
    CONSTRAINT [FK_Report_Order_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [Org].[Person] ([Id]),
    CONSTRAINT [FK_Report_Order_SellerBusinessUnitId] FOREIGN KEY ([SellerBusinessUnitId]) REFERENCES [Org].[BusinessUnit] ([Id]),
    CONSTRAINT [FK_Report_Order_SellerId] FOREIGN KEY ([SellerId]) REFERENCES [Org].[Person] ([Id])
);




GO



GO
CREATE NONCLUSTERED INDEX [FKIDX_Report_Order_SellerId]
    ON [Report].[Order]([SellerId] ASC);


GO
CREATE NONCLUSTERED INDEX [FKIDX_Report_Order_ClientId]
    ON [Report].[Order]([ClientId] ASC);

