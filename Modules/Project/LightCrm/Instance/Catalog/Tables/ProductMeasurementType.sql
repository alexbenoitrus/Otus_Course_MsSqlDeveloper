CREATE TABLE [Catalog].[ProductMeasurementType] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (300) NOT NULL,
    [IsActive]    BIT            NOT NULL,
    [IsDefault]   BIT            NULL,
    CONSTRAINT [PK_Catalog_ProductMeasurementType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_Catalog_ProductMeasurementType_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);






GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Catalog_ProductMeasurementType_IsDefault]
    ON [Catalog].[ProductMeasurementType]([IsDefault] ASC) WHERE ([IsDefault] IS NOT NULL);

