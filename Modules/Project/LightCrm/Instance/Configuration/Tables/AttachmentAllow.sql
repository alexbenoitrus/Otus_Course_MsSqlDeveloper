CREATE TABLE [Configuration].[AttachmentAllow] (
    [Id]      BIGINT IDENTITY (1, 1) NOT NULL,
    [TableId] INT    NOT NULL,
    CONSTRAINT [PK_Configuration_AttachmentAllow] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_Configuration_AttachmentAllow_TableId] UNIQUE NONCLUSTERED ([TableId] ASC)
);



