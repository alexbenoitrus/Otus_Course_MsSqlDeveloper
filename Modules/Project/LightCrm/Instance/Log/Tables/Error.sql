CREATE TABLE [Log].[Error] (
    [Id]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [ProcedureName] NVARCHAR (300) NOT NULL,
    [ErrorCode]     INT            NOT NULL,
    [Parameters]    NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_Error] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ix_Error_ProcedureName]
    ON [Log].[Error]([ProcedureName] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_Error_ErrorCode]
    ON [Log].[Error]([ErrorCode] ASC);

