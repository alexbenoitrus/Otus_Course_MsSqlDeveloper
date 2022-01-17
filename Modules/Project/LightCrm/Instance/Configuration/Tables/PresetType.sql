CREATE TABLE [Configuration].[PresetType] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (300) NOT NULL,
    [IsActive]    BIT            NOT NULL,
    [IsDefault]   BIT            NULL,
    CONSTRAINT [PK_PresetType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_PresetType_IsDefault] UNIQUE NONCLUSTERED ([IsDefault] ASC)
);

