CREATE TABLE [Org].[Person] (
    [Id]                BIGINT         IDENTITY (1, 1) NOT NULL,
    [StatusId]          BIGINT         NOT NULL,
    [FirstName]         NVARCHAR (100) NOT NULL,
    [LastName]          NVARCHAR (100) NULL,
    [MiddleName]        NVARCHAR (100) NULL,
    [GenderTypeId]      BIGINT         NULL,
    [BusinessUnitId]    BIGINT         NULL,
    [Description]       NVARCHAR (MAX) NULL,
    [TypeId]            BIGINT         NOT NULL,
    [AddressLevelId]    BIGINT         NULL,
    [AddressAdditional] NVARCHAR (100) NULL,
    [Icon]              NVARCHAR (MAX) NULL,
    [ExternalId]        NVARCHAR (50)  NULL,
    [BirthDay]          DATETIME2 (7)  NULL,
    [RegisterOn]        DATETIME2 (7)  NOT NULL,
    CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CH_Person_BirthDay] CHECK ([BirthDay]<getdate()),
    CONSTRAINT [CH_Person_RegisterOn] CHECK ([RegisterOn]<=getdate()),
    CONSTRAINT [FK_Person_AddressLevel] FOREIGN KEY ([AddressLevelId]) REFERENCES [Org].[AddressLevel] ([Id]),
    CONSTRAINT [FK_Person_BusinessUnit] FOREIGN KEY ([BusinessUnitId]) REFERENCES [Org].[BusinessUnit] ([Id]),
    CONSTRAINT [FK_Person_GenderType] FOREIGN KEY ([GenderTypeId]) REFERENCES [Org].[GenderType] ([Id]),
    CONSTRAINT [FK_Person_PersonStatus] FOREIGN KEY ([StatusId]) REFERENCES [Org].[PersonStatus] ([Id]),
    CONSTRAINT [FK_Person_PersonType] FOREIGN KEY ([TypeId]) REFERENCES [Org].[PersonType] ([Id]),
    CONSTRAINT [UQ_Person_ExternalId] UNIQUE NONCLUSTERED ([ExternalId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [fkIdx_Person_BusinessUnitId]
    ON [Org].[Person]([BusinessUnitId] ASC)
    INCLUDE([FirstName], [LastName], [MiddleName]);


GO
CREATE NONCLUSTERED INDEX [fkIdx_Person_AddressLevelId]
    ON [Org].[Person]([AddressLevelId] ASC)
    INCLUDE([FirstName], [LastName], [MiddleName]);


GO
CREATE NONCLUSTERED INDEX [ix_Person_BirthDay]
    ON [Org].[Person]([BirthDay] ASC)
    INCLUDE([FirstName], [LastName], [MiddleName]);


GO
CREATE NONCLUSTERED INDEX [ix_Person_RegisterOn]
    ON [Org].[Person]([RegisterOn] ASC)
    INCLUDE([FirstName], [LastName], [MiddleName]);


GO
CREATE NONCLUSTERED INDEX [ix_Person_FirstName]
    ON [Org].[Person]([FirstName] ASC)
    INCLUDE([LastName], [MiddleName]);


GO
CREATE NONCLUSTERED INDEX [ix_Person_LastName]
    ON [Org].[Person]([LastName] ASC)
    INCLUDE([FirstName], [MiddleName]);


GO
CREATE NONCLUSTERED INDEX [ix_Person_MiddleName]
    ON [Org].[Person]([MiddleName] ASC)
    INCLUDE([FirstName], [LastName]);


GO
CREATE NONCLUSTERED INDEX [ix_Person_ExternalId]
    ON [Org].[Person]([ExternalId] ASC)
    INCLUDE([FirstName], [LastName], [MiddleName]);

