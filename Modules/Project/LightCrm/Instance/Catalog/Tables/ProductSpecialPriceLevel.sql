CREATE TABLE [Catalog].[ProductSpecialPriceLevel] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Description] NVARCHAR (MAX) NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_ProductSpecialPriceLevel] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_ProductSpecialPriceLevel_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);

