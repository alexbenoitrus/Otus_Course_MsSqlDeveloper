CREATE TABLE [Org].[BusinessUnit] (
    [Id]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [ParentId]       BIGINT         NULL,
    [AddressLevelId] BIGINT         NULL,
    [TypeId]         BIGINT         NOT NULL,
    [Name]           NVARCHAR (100) NOT NULL,
    [Description]    NVARCHAR (100) NULL,
    [Icon]           NVARCHAR (MAX) NULL,
    [ExternalId]     NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_BusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_BusinessUnit_AddressLevel] FOREIGN KEY ([AddressLevelId]) REFERENCES [Org].[AddressLevel] ([Id]),
    CONSTRAINT [FK_BusinessUnit_BusinessUnit] FOREIGN KEY ([ParentId]) REFERENCES [Org].[BusinessUnit] ([Id]),
    CONSTRAINT [FK_BusinessUnit_BusinessUnitType] FOREIGN KEY ([TypeId]) REFERENCES [Org].[BusinessUnitType] ([Id]),
    CONSTRAINT [UQ_BusinessUnit_ExternalId] UNIQUE NONCLUSTERED ([ExternalId] ASC),
    CONSTRAINT [UQ_BusinessUnit_Name_ParentId] UNIQUE NONCLUSTERED ([Name] ASC, [ParentId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [fkIdx_BusinessUnit_ParentId]
    ON [Org].[BusinessUnit]([ParentId] ASC)
    INCLUDE([Name]);


GO
CREATE NONCLUSTERED INDEX [fkIdx_BusinessUnit_AddressLevelId]
    ON [Org].[BusinessUnit]([AddressLevelId] ASC)
    INCLUDE([Name]);


GO
CREATE NONCLUSTERED INDEX [ix_BusinessUnit_Name]
    ON [Org].[BusinessUnit]([Name] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_BusinessUnit_ExternalId]
    ON [Org].[BusinessUnit]([ExternalId] ASC)
    INCLUDE([Name]);

