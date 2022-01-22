CREATE TABLE [Org].[GenderType] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (300) NOT NULL,
    [IsActive]    BIT            NOT NULL,
    [IsDefault]   BIT            NULL,
    CONSTRAINT [PK_Org_GenderType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_Org_GenderType_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);





