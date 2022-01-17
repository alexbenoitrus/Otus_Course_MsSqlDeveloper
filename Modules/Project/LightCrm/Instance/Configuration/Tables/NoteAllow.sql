CREATE TABLE [Configuration].[NoteAllow] (
    [Id]      BIGINT NOT NULL,
    [TableId] INT    NOT NULL,
    CONSTRAINT [PK_NoteAllow] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_NoteAllow_TableId] UNIQUE NONCLUSTERED ([TableId] ASC)
);

