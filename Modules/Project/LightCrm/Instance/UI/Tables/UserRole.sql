CREATE TABLE [UI].[UserRole] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (300) NOT NULL,
    [IsActive]    BIT            NOT NULL,
    [IsDefault]   BIT            NULL,
    CONSTRAINT [PK_UI_UserRole] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_UI_UserRole_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);








GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_UI_UserRole_IsDefault]
    ON [UI].[UserRole]([IsDefault] ASC) WHERE ([IsDefault] IS NOT NULL);

