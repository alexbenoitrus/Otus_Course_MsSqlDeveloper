CREATE TABLE [Event].[InviteStatus] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (300) NOT NULL,
    [IsActive]    BIT            NOT NULL,
    [IsDefault]   BIT            NULL,
    CONSTRAINT [PK_Event_InviteStatus] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_Event_InviteStatus_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Event_InviteStatus_IsDefault]
    ON [Event].[InviteStatus]([IsDefault] ASC) WHERE ([IsDefault] IS NOT NULL);

