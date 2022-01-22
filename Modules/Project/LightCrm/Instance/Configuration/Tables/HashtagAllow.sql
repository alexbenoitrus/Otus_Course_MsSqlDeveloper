CREATE TABLE [Configuration].[HashtagAllow] (
    [Id]      BIGINT IDENTITY (1, 1) NOT NULL,
    [TableId] INT    NOT NULL,
    CONSTRAINT [PK_Configuration_HashtagAllow] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_Configuration_HashtagAllow_TableId] UNIQUE NONCLUSTERED ([TableId] ASC)
);



