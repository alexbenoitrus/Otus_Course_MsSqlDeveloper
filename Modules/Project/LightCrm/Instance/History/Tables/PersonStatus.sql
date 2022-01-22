CREATE TABLE [History].[PersonStatus] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [PersonId]    BIGINT         NOT NULL,
    [ChangerId]   BIGINT         NOT NULL,
    [OldStatusId] BIGINT         NOT NULL,
    [NewStatusId] BIGINT         NOT NULL,
    [Reason]      NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_History_PersonStatus] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_History_PersonStatus_Person] FOREIGN KEY ([PersonId]) REFERENCES [Org].[Person] ([Id]),
    CONSTRAINT [FK_History_PersonStatus_Person_Changer] FOREIGN KEY ([ChangerId]) REFERENCES [Org].[Person] ([Id]),
    CONSTRAINT [FK_History_PersonStatus_StatusNew] FOREIGN KEY ([NewStatusId]) REFERENCES [Org].[PersonStatus] ([Id]),
    CONSTRAINT [FK_History_PersonStatus_StatusOld] FOREIGN KEY ([OldStatusId]) REFERENCES [Org].[PersonStatus] ([Id])
);




GO
CREATE NONCLUSTERED INDEX [fkIdx_History_PersonStatus_PersonId]
    ON [History].[PersonStatus]([PersonId] ASC);


GO
CREATE NONCLUSTERED INDEX [fkIdx_History_PersonStatus_ChangerId]
    ON [History].[PersonStatus]([ChangerId] ASC);

