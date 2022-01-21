CREATE TABLE [DWH].[FactOrder] (
    [id]                  BIGINT          NOT NULL,
    [Sum]                 DECIMAL (18, 2) NOT NULL,
    [Discount]            DECIMAL (18, 2) NOT NULL,
    [DateId]              BIGINT          NOT NULL,
    [SellerId]            BIGINT          NOT NULL,
    [SellerBusinesUnitId] BIGINT          NOT NULL,
    [ClientId]            BIGINT          NOT NULL,
    [ClientBusinesUnitId] BIGINT          NOT NULL,
    CONSTRAINT [PK_DWH_FactOrder] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_DWH_FactOrder_ClientBusinesUnitId] FOREIGN KEY ([SellerBusinesUnitId]) REFERENCES [DWH].[DimBusinessUnit] ([Id]),
    CONSTRAINT [FK_DWH_FactOrder_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [DWH].[DimPerson] ([Id]),
    CONSTRAINT [FK_DWH_FactOrder_DateId] FOREIGN KEY ([DateId]) REFERENCES [DWH].[DimDate] ([Id]),
    CONSTRAINT [FK_DWH_FactOrder_SellerBusinesUnitId] FOREIGN KEY ([SellerBusinesUnitId]) REFERENCES [DWH].[DimBusinessUnit] ([Id]),
    CONSTRAINT [FK_DWH_FactOrder_SellerId] FOREIGN KEY ([SellerId]) REFERENCES [DWH].[DimPerson] ([Id])
);



