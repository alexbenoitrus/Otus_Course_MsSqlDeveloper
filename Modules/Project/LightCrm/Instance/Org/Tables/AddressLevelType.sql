CREATE TABLE [Org].[AddressLevelType] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (300) NOT NULL,
    [IsActive]    BIT            NOT NULL,
    [IsDefault]   BIT            NULL,
    CONSTRAINT [PK_Org_AddressLevelType] PRIMARY KEY CLUSTERED ([Id] ASC)
);








GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Org_AddressLevelType_Name]
    ON [Org].[AddressLevelType]([Name] ASC) WHERE ([Name] IS NOT NULL);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Org_AddressLevelType_IsDefault]
    ON [Org].[AddressLevelType]([IsDefault] ASC) WHERE ([IsDefault] IS NOT NULL);

