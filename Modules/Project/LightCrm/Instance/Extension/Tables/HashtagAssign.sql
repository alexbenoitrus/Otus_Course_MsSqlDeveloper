CREATE TABLE [Extension].[HashtagAssign] (
    [Id]        BIGINT IDENTITY (1, 1) NOT NULL,
    [TableId]   INT    NOT NULL,
    [HashtagId] BIGINT NOT NULL,
    [EntityId]  BIGINT NOT NULL,
    CONSTRAINT [PK_HashtagAssign] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_HashtagAssign_Hashtag] FOREIGN KEY ([HashtagId]) REFERENCES [Extension].[Hashtag] ([Id]),
    CONSTRAINT [UQ_HashtagAssign_TableId_HashtagId_EntityId] UNIQUE NONCLUSTERED ([TableId] ASC, [HashtagId] ASC, [EntityId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ix_HashtagAssign_HashtagIdTableIdEntityId]
    ON [Extension].[HashtagAssign]([HashtagId] ASC, [TableId] ASC, [EntityId] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_HashtagAssign_TableIdEntityId]
    ON [Extension].[HashtagAssign]([TableId] ASC, [EntityId] ASC)
    INCLUDE([HashtagId]);

