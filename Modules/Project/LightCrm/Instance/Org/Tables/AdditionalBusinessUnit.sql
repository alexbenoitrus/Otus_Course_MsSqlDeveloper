CREATE TABLE [Org].[AdditionalBusinessUnit] (
    [Id]             BIGINT IDENTITY (1, 1) NOT NULL,
    [BusinessUnitId] BIGINT NOT NULL,
    [PersonId]       BIGINT NOT NULL,
    CONSTRAINT [PK_AdditionalBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_AdditionalBusinessUnit_BusinessUnit] FOREIGN KEY ([BusinessUnitId]) REFERENCES [Org].[BusinessUnit] ([Id]),
    CONSTRAINT [FK_AdditionalBusinessUnit_Person] FOREIGN KEY ([PersonId]) REFERENCES [Org].[Person] ([Id]),
    CONSTRAINT [UQ_AdditionalBusinessUnit_PersonId_BusinessUnitId] UNIQUE NONCLUSTERED ([PersonId] ASC, [BusinessUnitId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [fkIdx_AdditionalBusinessUnit_BusinessUnitId]
    ON [Org].[AdditionalBusinessUnit]([BusinessUnitId] ASC);


GO
CREATE NONCLUSTERED INDEX [fkIdx_AdditionalBusinessUnit_PersonId]
    ON [Org].[AdditionalBusinessUnit]([PersonId] ASC);

