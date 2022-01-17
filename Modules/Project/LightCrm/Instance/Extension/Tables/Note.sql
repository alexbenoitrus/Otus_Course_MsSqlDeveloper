﻿CREATE TABLE [Extension].[Note] (
    [Id]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name] NVARCHAR (300) NOT NULL,
    [Body] NTEXT          NOT NULL,
    CONSTRAINT [PK_Note] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ix_Note_Name]
    ON [Extension].[Note]([Name] ASC);

