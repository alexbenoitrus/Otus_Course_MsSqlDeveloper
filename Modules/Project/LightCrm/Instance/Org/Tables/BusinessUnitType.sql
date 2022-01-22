CREATE TABLE [Org].[BusinessUnitType] (
    [Id]                      BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]                    NVARCHAR (100) NOT NULL,
    [Description]             NVARCHAR (300) NOT NULL,
    [IsActive]                BIT            NOT NULL,
    [IsDefault]               BIT            NULL,
    [BusinessDirectionTypeId] BIGINT         NOT NULL,
    CONSTRAINT [PK_Org_BusinessUnitType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Org_BusinessUnitType_BusinessDirectionType] FOREIGN KEY ([BusinessDirectionTypeId]) REFERENCES [Org].[BusinessDirectionType] ([Id]),
    CONSTRAINT [UQ_Org_BusinessUnitType_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);





