CREATE TABLE [Log].[Error] (
    [Id]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [ProcedureName] NVARCHAR (300) NOT NULL,
    [ErrorCode]     INT            NOT NULL,
    [Parameters]    NVARCHAR (MAX) NOT NULL,
    [ErrorMessage]  NVARCHAR (MAX) NOT NULL,
    [DateTime]      DATETIME2 (7)  NOT NULL,
    CONSTRAINT [PK_Log_Error] PRIMARY KEY CLUSTERED ([Id] ASC)
);






GO



GO
CREATE NONCLUSTERED INDEX [IX_Log_Error_ProcedureName]
    ON [Log].[Error]([ProcedureName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Log_Error_ErrorCode]
    ON [Log].[Error]([ErrorCode] ASC);

