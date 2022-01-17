CREATE TABLE [Catalog].[ProductPriceByBusinessUnit] (
    [Id]             BIGINT       IDENTITY (1, 1) NOT NULL,
    [ProductId]      BIGINT       NOT NULL,
    [BusinessUnitId] BIGINT       NOT NULL,
    [Price]          DECIMAL (18) NOT NULL,
    [IsActive]       BIT          NOT NULL,
    CONSTRAINT [PK_ProductPriceByBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductPriceByBusinessUnit_BusinessUnit] FOREIGN KEY ([BusinessUnitId]) REFERENCES [Org].[BusinessUnit] ([Id]),
    CONSTRAINT [FK_ProductPriceByBusinessUnit_Product] FOREIGN KEY ([ProductId]) REFERENCES [Catalog].[Product] ([Id]),
    CONSTRAINT [UQ_ProductPriceByBusinessUnit_ProductId_BusinessUnitId] UNIQUE NONCLUSTERED ([ProductId] ASC, [BusinessUnitId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [fkIdx_ProductPriceByBusinessUnit_ProductId]
    ON [Catalog].[ProductPriceByBusinessUnit]([ProductId] ASC)
    INCLUDE([Price]);


GO
CREATE NONCLUSTERED INDEX [fkIdx_ProductPriceByBusinessUnit_BusinessUnitId]
    ON [Catalog].[ProductPriceByBusinessUnit]([BusinessUnitId] ASC)
    INCLUDE([Price]);


GO
CREATE NONCLUSTERED INDEX [ix_ProductPriceByBusinessUnit_Price]
    ON [Catalog].[ProductPriceByBusinessUnit]([Price] ASC)
    INCLUDE([ProductId], [BusinessUnitId]);

