CREATE TABLE [Configuration].[BasePreset] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (50)  NOT NULL,
    [Description] NVARCHAR (300) NOT NULL,
    [TableName]   NVARCHAR (100) NOT NULL,
    [EntityId]    BIGINT         NOT NULL,
    [Data]        NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_BasePreset] PRIMARY KEY CLUSTERED ([Id] ASC)
);

