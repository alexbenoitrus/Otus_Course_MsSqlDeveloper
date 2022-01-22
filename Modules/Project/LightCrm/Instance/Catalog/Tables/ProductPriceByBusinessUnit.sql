CREATE TABLE [Catalog].[ProductPriceByBusinessUnit] (
    [Id]             BIGINT       IDENTITY (1, 1) NOT NULL,
    [ProductId]      BIGINT       NOT NULL,
    [BusinessUnitId] BIGINT       NOT NULL,
    [Price]          DECIMAL (18) NOT NULL,
    [IsActive]       BIT          NOT NULL,
    CONSTRAINT [PK_Catalog_ProductPriceByBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Catalog_ProductPriceByBusinessUnit_BusinessUnit] FOREIGN KEY ([BusinessUnitId]) REFERENCES [Org].[BusinessUnit] ([Id]),
    CONSTRAINT [FK_Catalog_ProductPriceByBusinessUnit_Product] FOREIGN KEY ([ProductId]) REFERENCES [Catalog].[Product] ([Id]),
    CONSTRAINT [UQ_Catalog_ProductPriceByBusinessUnit_ProductId_BusinessUnitId] UNIQUE NONCLUSTERED ([ProductId] ASC, [BusinessUnitId] ASC)
);




GO



GO



GO
CREATE NONCLUSTERED INDEX [IX_Catalog_ProductPriceByBusinessUnit_Price]
    ON [Catalog].[ProductPriceByBusinessUnit]([Price] ASC)
    INCLUDE([ProductId], [BusinessUnitId]);


GO
CREATE NONCLUSTERED INDEX [FKIDX_Catalog_ProductPriceByBusinessUnit_ProductId]
    ON [Catalog].[ProductPriceByBusinessUnit]([ProductId] ASC)
    INCLUDE([Price]);


GO
CREATE NONCLUSTERED INDEX [FKIDX_Catalog_ProductPriceByBusinessUnit_BusinessUnitId]
    ON [Catalog].[ProductPriceByBusinessUnit]([BusinessUnitId] ASC)
    INCLUDE([Price]);

