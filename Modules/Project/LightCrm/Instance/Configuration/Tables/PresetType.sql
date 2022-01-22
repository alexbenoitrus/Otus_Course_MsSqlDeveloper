CREATE TABLE [Configuration].[PresetType] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (300) NOT NULL,
    [IsActive]    BIT            NOT NULL,
    [IsDefault]   BIT            NULL,
    CONSTRAINT [PK_Configuration_PresetType] PRIMARY KEY CLUSTERED ([Id] ASC)
);






GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Configuration_PresetType_IsDefault]
    ON [Configuration].[PresetType]([IsDefault] ASC) WHERE ([IsDefault] IS NOT NULL);

