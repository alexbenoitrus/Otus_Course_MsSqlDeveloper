CREATE TABLE [Report].[Order] (
    [id]                    BIGINT          NOT NULL,
    [Date]                  DATETIME2 (7)   NOT NULL,
    [Sum]                   DECIMAL (18, 2) NOT NULL,
    [Discount]              DECIMAL (18, 2) NOT NULL,
    [SellerId]              BIGINT          NOT NULL,
    [SellerBusinesUnitId]   BIGINT          NOT NULL,
    [SellerFullName]        NVARCHAR (300)  NOT NULL,
    [SellerBusinesUnitName] NVARCHAR (100)  NOT NULL,
    [ClientId]              BIGINT          NOT NULL,
    [ClientBusinesUnitId]   BIGINT          NOT NULL,
    [ClientFullName]        NVARCHAR (300)  NOT NULL,
    [ClientBusinesUnitName] NVARCHAR (100)  NOT NULL,
    CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_Order_ClientBusinesUnitId] FOREIGN KEY ([SellerBusinesUnitId]) REFERENCES [Org].[BusinessUnit] ([Id]),
    CONSTRAINT [FK_Order_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [Org].[Person] ([Id]),
    CONSTRAINT [FK_Order_SellerBusinesUnitId] FOREIGN KEY ([SellerBusinesUnitId]) REFERENCES [Org].[BusinessUnit] ([Id]),
    CONSTRAINT [FK_Order_SellerId] FOREIGN KEY ([SellerId]) REFERENCES [Org].[Person] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [fkIdx_Order_ClientId]
    ON [Report].[Order]([ClientId] ASC);


GO
CREATE NONCLUSTERED INDEX [fkIdx_Order_SellerId]
    ON [Report].[Order]([SellerId] ASC);

