CREATE TABLE [History].[PersonType] (
    [Id]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [PersonId]  BIGINT         NOT NULL,
    [ChangerId] BIGINT         NOT NULL,
    [OldTypeId] BIGINT         NOT NULL,
    [NewTypeId] BIGINT         NOT NULL,
    [Reason]    NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_History_PersonType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_History_PersonType_Person] FOREIGN KEY ([PersonId]) REFERENCES [Org].[Person] ([Id]),
    CONSTRAINT [FK_History_PersonType_Person_Changer] FOREIGN KEY ([ChangerId]) REFERENCES [Org].[Person] ([Id]),
    CONSTRAINT [FK_History_PersonType_TypeNew] FOREIGN KEY ([NewTypeId]) REFERENCES [Org].[PersonType] ([Id]),
    CONSTRAINT [FK_History_PersonType_TypeOld] FOREIGN KEY ([OldTypeId]) REFERENCES [Org].[PersonType] ([Id])
);




GO
CREATE NONCLUSTERED INDEX [fkIdx_History_PersonType_PersonId]
    ON [History].[PersonType]([PersonId] ASC);


GO
CREATE NONCLUSTERED INDEX [fkIdx_History_PersonType_ChangerId]
    ON [History].[PersonType]([ChangerId] ASC);

