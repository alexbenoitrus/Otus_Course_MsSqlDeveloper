CREATE TABLE [Extension].[File] (
    [Id]   BIGINT          IDENTITY (1, 1) NOT NULL,
    [Body] VARBINARY (MAX) NOT NULL,
    CONSTRAINT [PK_File] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO


