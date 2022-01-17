CREATE TABLE [UI].[Session] (
    [id]         BIGINT           IDENTITY (1, 1) NOT NULL,
    [UserId]     BIGINT           NOT NULL,
    [Key]        UNIQUEIDENTIFIER NOT NULL,
    [IP]         NVARCHAR (39)    NOT NULL,
    [User-Agent] NVARCHAR (100)   NOT NULL,
    [DeviceId]   NVARCHAR (100)   NOT NULL,
    [LogOn]      DATETIME2 (7)    NOT NULL,
    [LogOut]     DATETIME2 (7)    NULL,
    CONSTRAINT [PK_Session] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_Session_User] FOREIGN KEY ([UserId]) REFERENCES [UI].[User] ([id]),
    CONSTRAINT [UQ_Session_Key] UNIQUE NONCLUSTERED ([Key] ASC)
);


GO
CREATE NONCLUSTERED INDEX [fkIdx_Session_User]
    ON [UI].[Session]([UserId] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_Session_Key]
    ON [UI].[Session]([Key] ASC);

