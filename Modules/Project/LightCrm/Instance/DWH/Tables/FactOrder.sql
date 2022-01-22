CREATE TABLE [DWH].[FactOrder] (
    [id]                   BIGINT          NOT NULL,
    [Sum]                  DECIMAL (18, 2) NOT NULL,
    [Discount]             DECIMAL (18, 2) NOT NULL,
    [DateId]               BIGINT          NOT NULL,
    [SellerId]             BIGINT          NOT NULL,
    [SellerBusinessUnitId] BIGINT          NOT NULL,
    [ClientId]             BIGINT          NOT NULL,
    [ClientBusinessUnitId] BIGINT          NOT NULL,
    CONSTRAINT [PK_DWH_FactOrder] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_DWH_FactOrder_ClientBusinessUnitId] FOREIGN KEY ([ClientBusinessUnitId]) REFERENCES [DWH].[DimBusinessUnit] ([Id]),
    CONSTRAINT [FK_DWH_FactOrder_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [DWH].[DimPerson] ([Id]),
    CONSTRAINT [FK_DWH_FactOrder_DateId] FOREIGN KEY ([DateId]) REFERENCES [DWH].[DimDate] ([Id]),
    CONSTRAINT [FK_DWH_FactOrder_SellerBusinessUnitId] FOREIGN KEY ([SellerBusinessUnitId]) REFERENCES [DWH].[DimBusinessUnit] ([Id]),
    CONSTRAINT [FK_DWH_FactOrder_SellerId] FOREIGN KEY ([SellerId]) REFERENCES [DWH].[DimPerson] ([Id])
);





