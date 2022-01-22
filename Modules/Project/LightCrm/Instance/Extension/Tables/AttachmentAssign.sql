CREATE TABLE [Extension].[AttachmentAssign] (
    [Id]           BIGINT IDENTITY (1, 1) NOT NULL,
    [TableId]      INT    NOT NULL,
    [AttachmentId] BIGINT NOT NULL,
    [EntityId]     BIGINT NOT NULL,
    CONSTRAINT [PK_Extension_AttachmentAssign] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Extension_AttachmentAssign_Attachment] FOREIGN KEY ([AttachmentId]) REFERENCES [Extension].[Attachment] ([Id]),
    CONSTRAINT [UQ_Extension_AttachmentAssign_TableId_AttachmentId_EntityId] UNIQUE NONCLUSTERED ([TableId] ASC, [AttachmentId] ASC, [EntityId] ASC)
);




GO
CREATE NONCLUSTERED INDEX [FKIDX_Extension_AttachmentAssign_AttachmentId]
    ON [Extension].[AttachmentAssign]([AttachmentId] ASC);

