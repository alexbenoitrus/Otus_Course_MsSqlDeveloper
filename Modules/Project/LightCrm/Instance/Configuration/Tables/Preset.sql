CREATE TABLE [Configuration].[Preset] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [TypeId]      BIGINT         NOT NULL,
    [Name]        NVARCHAR (50)  NOT NULL,
    [Description] NVARCHAR (300) NOT NULL,
    [TableName]   NVARCHAR (100) NOT NULL,
    [EntityId]    BIGINT         NOT NULL,
    [Data]        NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_Preset] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Preset_PresetType] FOREIGN KEY ([TypeId]) REFERENCES [Configuration].[PresetType] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [fkIdx_Preset_TypeId]
    ON [Configuration].[Preset]([TypeId] ASC)
    INCLUDE([Name]);

