CREATE TABLE [UI].[Session] (
    [id]         BIGINT           IDENTITY (1, 1) NOT NULL,
    [UserId]     BIGINT           NOT NULL,
    [Key]        UNIQUEIDENTIFIER NOT NULL,
    [IP]         NVARCHAR (39)    NOT NULL,
    [User-Agent] NVARCHAR (100)   NOT NULL,
    [DeviceId]   NVARCHAR (100)   NOT NULL,
    [LogOn]      DATETIME2 (7)    NOT NULL,
    [LogOut]     DATETIME2 (7)    NULL,
    CONSTRAINT [PK_UI_Session] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_UI_Session_User] FOREIGN KEY ([UserId]) REFERENCES [UI].[User] ([id]),
    CONSTRAINT [UQ_UI_Session_Key] UNIQUE NONCLUSTERED ([Key] ASC)
);




GO



GO
CREATE NONCLUSTERED INDEX [IX_UI_Session_Key]
    ON [UI].[Session]([Key] ASC);


GO
CREATE NONCLUSTERED INDEX [FKIDX_UI_Session_User]
    ON [UI].[Session]([UserId] ASC);

