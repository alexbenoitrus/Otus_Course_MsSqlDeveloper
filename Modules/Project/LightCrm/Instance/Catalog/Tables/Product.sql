CREATE TABLE [Catalog].[Product] (
    [Id]                      BIGINT         IDENTITY (1, 1) NOT NULL,
    [Price]                   DECIMAL (18)   NOT NULL,
    [CatalogLevelId]          BIGINT         NULL,
    [MeasurementTypeId]       BIGINT         NOT NULL,
    [Name]                    NVARCHAR (100) NOT NULL,
    [Description]             NVARCHAR (300) NOT NULL,
    [IsActive]                BIT            NOT NULL,
    [Icon]                    NVARCHAR (MAX) NULL,
    [ExternalId]              NVARCHAR (50)  NULL,
    [BusinessDirectionTypeId] BIGINT         NOT NULL,
    CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Product_BusinessDirectionType] FOREIGN KEY ([BusinessDirectionTypeId]) REFERENCES [Org].[BusinessDirectionType] ([Id]),
    CONSTRAINT [FK_Product_ProductCatalogLevel] FOREIGN KEY ([CatalogLevelId]) REFERENCES [Catalog].[ProductCatalogLevel] ([Id]),
    CONSTRAINT [FK_Product_ProductMeasurementType] FOREIGN KEY ([MeasurementTypeId]) REFERENCES [Catalog].[ProductMeasurementType] ([Id]),
    CONSTRAINT [UQ_Product_ExternalId] UNIQUE NONCLUSTERED ([ExternalId] ASC),
    CONSTRAINT [UQ_Product_Name_ParentId_BusinessDirectionTypeId_MeasurementTypeId] UNIQUE NONCLUSTERED ([Name] ASC, [CatalogLevelId] ASC, [BusinessDirectionTypeId] ASC, [MeasurementTypeId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [fkIdx_Product_CatalogLevelId]
    ON [Catalog].[Product]([CatalogLevelId] ASC)
    INCLUDE([Name]);


GO
CREATE NONCLUSTERED INDEX [ix_Product_Name]
    ON [Catalog].[Product]([Name] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_Product_ExtenalId]
    ON [Catalog].[Product]([ExternalId] ASC)
    INCLUDE([Name]);


GO
CREATE NONCLUSTERED INDEX [ix_Product_Price]
    ON [Catalog].[Product]([Price] ASC)
    INCLUDE([Name]);

