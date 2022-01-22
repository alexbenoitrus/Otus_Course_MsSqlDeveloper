CREATE TABLE [Extension].[NoteAssign] (
    [Id]       BIGINT IDENTITY (1, 1) NOT NULL,
    [TableId]  INT    NOT NULL,
    [NoteId]   BIGINT NOT NULL,
    [EntityId] BIGINT NOT NULL,
    CONSTRAINT [PK_Extension_NoteAssign] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Extension_NoteAssign_Note] FOREIGN KEY ([NoteId]) REFERENCES [Extension].[Note] ([Id]),
    CONSTRAINT [UQ_Extension_NoteAssign_TableId_NoteId_EntityId] UNIQUE NONCLUSTERED ([TableId] ASC, [NoteId] ASC, [EntityId] ASC)
);




GO



GO
CREATE NONCLUSTERED INDEX [IX_Extension_NoteAssign_TableIdEntityId]
    ON [Extension].[NoteAssign]([TableId] ASC, [EntityId] ASC)
    INCLUDE([NoteId]);


GO
CREATE NONCLUSTERED INDEX [IX_Extension_NoteAssign_HashtagIdTableIdEntityId]
    ON [Extension].[NoteAssign]([NoteId] ASC, [TableId] ASC, [EntityId] ASC);

