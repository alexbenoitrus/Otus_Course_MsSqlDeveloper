CREATE TABLE [Catalog].[ProductCatalogLevel] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [ParentId]    BIGINT         NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (300) NOT NULL,
    [Icon]        NVARCHAR (MAX) NULL,
    [ExternalId]  NVARCHAR (50)  NULL,
    CONSTRAINT [PK_ProductCatalogLevel] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductCatalogLevel_ProductCatalogLevel] FOREIGN KEY ([ParentId]) REFERENCES [Catalog].[ProductCatalogLevel] ([Id]),
    CONSTRAINT [UQ_ProductCatalogLevel_ExternalId] UNIQUE NONCLUSTERED ([ExternalId] ASC),
    CONSTRAINT [UQ_ProductCatalogLevel_Name_ParentId] UNIQUE NONCLUSTERED ([Name] ASC, [ParentId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [fkIdx_ProductCatalogLevel_ParendId]
    ON [Catalog].[ProductCatalogLevel]([ParentId] ASC)
    INCLUDE([Name]);


GO
CREATE NONCLUSTERED INDEX [ix_ProductCatalogLevel_Name]
    ON [Catalog].[ProductCatalogLevel]([Name] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_ProductCatalogLevel_ExtenalId]
    ON [Catalog].[ProductCatalogLevel]([ExternalId] ASC)
    INCLUDE([Name]);

