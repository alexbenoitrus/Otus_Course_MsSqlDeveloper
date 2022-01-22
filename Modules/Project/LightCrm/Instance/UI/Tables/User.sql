CREATE TABLE [UI].[User] (
    [id]       BIGINT         IDENTITY (1, 1) NOT NULL,
    [Login]    NVARCHAR (30)  NOT NULL,
    [PersonId] BIGINT         NOT NULL,
    [RoleId]   BIGINT         NOT NULL,
    [Password] NVARCHAR (100) NOT NULL,
    [Salt]     NVARCHAR (10)  NOT NULL,
    CONSTRAINT [PK_UI_User] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_UI_User_Person] FOREIGN KEY ([PersonId]) REFERENCES [Org].[Person] ([Id]),
    CONSTRAINT [FK_UI_User_UserRole] FOREIGN KEY ([RoleId]) REFERENCES [UI].[UserRole] ([Id]),
    CONSTRAINT [UQ_UI_User_Login] UNIQUE NONCLUSTERED ([Login] ASC),
    CONSTRAINT [UQ_UI_User_PersonId] UNIQUE NONCLUSTERED ([PersonId] ASC)
);




GO
CREATE NONCLUSTERED INDEX [FKIDX_UI_User_PersonId]
    ON [UI].[User]([PersonId] ASC)
    INCLUDE([Login]);

