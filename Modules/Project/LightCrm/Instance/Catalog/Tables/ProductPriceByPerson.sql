CREATE TABLE [Catalog].[ProductPriceByPerson] (
    [Id]        BIGINT       IDENTITY (1, 1) NOT NULL,
    [PersonId]  BIGINT       NOT NULL,
    [ProductId] BIGINT       NOT NULL,
    [Price]     DECIMAL (18) NOT NULL,
    [IsActive]  BIT          NOT NULL,
    CONSTRAINT [PK_ProductPriceByPerson] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductPriceByPerson_Person] FOREIGN KEY ([PersonId]) REFERENCES [Org].[Person] ([Id]),
    CONSTRAINT [FK_ProductPriceByPerson_Product] FOREIGN KEY ([ProductId]) REFERENCES [Catalog].[Product] ([Id]),
    CONSTRAINT [UQ_ProductPriceByPerson_ProductId_PersonId] UNIQUE NONCLUSTERED ([ProductId] ASC, [PersonId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [fkIdx_ProductPriceByPerson_PersonId]
    ON [Catalog].[ProductPriceByPerson]([PersonId] ASC)
    INCLUDE([Price]);


GO
CREATE NONCLUSTERED INDEX [fkIdx_ProductPriceByPerson_ProductId]
    ON [Catalog].[ProductPriceByPerson]([ProductId] ASC)
    INCLUDE([Price]);


GO
CREATE NONCLUSTERED INDEX [ix_ProductPriceByPerson_Price]
    ON [Catalog].[ProductPriceByPerson]([Price] ASC)
    INCLUDE([ProductId], [PersonId]);

