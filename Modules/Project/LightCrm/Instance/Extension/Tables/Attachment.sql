CREATE TABLE [Extension].[Attachment] (
    [Id]          BIGINT          IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100)  NOT NULL,
    [Body]        VARBINARY (MAX) NOT NULL,
    [Description] NVARCHAR (MAX)  NOT NULL,
    CONSTRAINT [PK_Attachment] PRIMARY KEY CLUSTERED ([Id] ASC)
);

