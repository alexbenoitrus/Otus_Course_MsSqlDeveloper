CREATE TABLE [Org].[PersonType] (
    [Id]                      BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]                    NVARCHAR (100) NOT NULL,
    [Description]             NVARCHAR (300) NOT NULL,
    [IsActive]                BIT            NOT NULL,
    [IsDefault]               BIT            NULL,
    [BusinessDirectionTypeId] BIGINT         NOT NULL,
    CONSTRAINT [PK_Org_PersonType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Org_PersonType_BusinessDirectionType] FOREIGN KEY ([BusinessDirectionTypeId]) REFERENCES [Org].[BusinessDirectionType] ([Id]),
    CONSTRAINT [UQ_Org_PersonType_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);






GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Org_PersonType_IsDefault]
    ON [Org].[PersonType]([IsDefault] ASC) WHERE ([IsDefault] IS NOT NULL);

