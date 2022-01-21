CREATE TABLE [DWH].[DimBusinessUnit] (
    [Id]         BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]       NVARCHAR (100) NOT NULL,
    [Icon]       NVARCHAR (MAX) NULL,
    [ExternalId] NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_DWH_DimBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_DWH_DimBusinessUnit_ExternalId] UNIQUE NONCLUSTERED ([ExternalId] ASC)
);

