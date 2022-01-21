CREATE TABLE [DWH].[DimPerson] (
    [Id]         BIGINT         IDENTITY (1, 1) NOT NULL,
    [FirstName]  NVARCHAR (100) NOT NULL,
    [LastName]   NVARCHAR (100) NULL,
    [MiddleName] NVARCHAR (100) NULL,
    [Icon]       NVARCHAR (MAX) NULL,
    [ExternalId] NVARCHAR (50)  NULL,
    CONSTRAINT [PK_DWH_DimPerson] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_DWH_DimExternalId] UNIQUE NONCLUSTERED ([ExternalId] ASC)
);

