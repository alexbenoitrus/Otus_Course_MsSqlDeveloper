CREATE TABLE [Catalog].[ProductCatalogLevel] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [ParentId]    BIGINT         NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (300) NOT NULL,
    [Icon]        NVARCHAR (MAX) NULL,
    [ExternalId]  NVARCHAR (50)  NULL,
    CONSTRAINT [PK_Catalog_ProductCatalogLevel] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Catalog_ProductCatalogLevel_ProductCatalogLevel] FOREIGN KEY ([ParentId]) REFERENCES [Catalog].[ProductCatalogLevel] ([Id]),
    CONSTRAINT [UQ_Catalog_ProductCatalogLevel_Name_ParentId] UNIQUE NONCLUSTERED ([Name] ASC, [ParentId] ASC)
);






GO



GO



GO
CREATE NONCLUSTERED INDEX [IX_Catalog_ProductCatalogLevel_Name]
    ON [Catalog].[ProductCatalogLevel]([Name] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Catalog_ProductCatalogLevel_ExtenalId]
    ON [Catalog].[ProductCatalogLevel]([ExternalId] ASC)
    INCLUDE([Name]);


GO
CREATE NONCLUSTERED INDEX [FKIDX_Catalog_ProductCatalogLevel_ParendId]
    ON [Catalog].[ProductCatalogLevel]([ParentId] ASC)
    INCLUDE([Name]);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Catalog_ProductCatalogLevel_ExternalId]
    ON [Catalog].[ProductCatalogLevel]([ExternalId] ASC) WHERE ([ExternalId] IS NOT NULL);

