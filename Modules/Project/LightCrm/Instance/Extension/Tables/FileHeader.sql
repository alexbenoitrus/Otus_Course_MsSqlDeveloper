CREATE TABLE [Extension].[FileHeader] (
    [Id]          BIGINT          IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100)  NOT NULL,
    [FileId]      VARBINARY (MAX) NOT NULL,
    [Description] NVARCHAR (MAX)  NOT NULL,
    CONSTRAINT [PK_FileHeader] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ix_FileHeader_Name]
    ON [Extension].[FileHeader]([Name] ASC);

