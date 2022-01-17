CREATE TABLE [Org].[PersonStatus] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (300) NOT NULL,
    [IsActive]    BIT            NOT NULL,
    [IsDefault]   BIT            NULL,
    CONSTRAINT [PK_PersonStatus] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_PersonStatus_IsDefault] UNIQUE NONCLUSTERED ([IsDefault] ASC),
    CONSTRAINT [UQ_PersonStatus_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);

