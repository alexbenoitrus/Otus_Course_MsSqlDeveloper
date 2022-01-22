CREATE TABLE [Org].[AddressLevel] (
    [Id]         BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]       NVARCHAR (100) NOT NULL,
    [TypeId]     BIGINT         NOT NULL,
    [ExternalId] NVARCHAR (50)  NOT NULL,
    [ParentId]   BIGINT         NULL,
    CONSTRAINT [PK_Org_AddressLevel] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Org_AddressLevel_AddressLevel] FOREIGN KEY ([ParentId]) REFERENCES [Org].[AddressLevel] ([Id]),
    CONSTRAINT [FK_Org_AddressLevel_AddressLevelType] FOREIGN KEY ([TypeId]) REFERENCES [Org].[AddressLevelType] ([Id]),
    CONSTRAINT [UQ_Org_AddressLevel_ExternalId] UNIQUE NONCLUSTERED ([ExternalId] ASC),
    CONSTRAINT [UQ_Org_AddressLevel_Name_ParentId] UNIQUE NONCLUSTERED ([Name] ASC, [ParentId] ASC)
);




GO



GO



GO
CREATE NONCLUSTERED INDEX [IX_Org_AddressLevel_Name]
    ON [Org].[AddressLevel]([Name] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Org_AddressLevel_ExternalId]
    ON [Org].[AddressLevel]([ExternalId] ASC);


GO
CREATE NONCLUSTERED INDEX [FKIDX_Org_AddressLevel_ParentId]
    ON [Org].[AddressLevel]([ParentId] ASC)
    INCLUDE([Name]);

