CREATE TABLE [DWH].[DimBusinessUnit] (
    [Id]         BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]       NVARCHAR (100) NOT NULL,
    [Icon]       NVARCHAR (MAX) NULL,
    [ExternalId] NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_DWH_DimBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_DWH_DimBusinessUnit_ExternalId]
    ON [DWH].[DimBusinessUnit]([ExternalId] ASC) WHERE ([ExternalId] IS NOT NULL);

