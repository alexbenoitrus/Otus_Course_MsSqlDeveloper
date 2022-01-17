CREATE TABLE [Event].[EventInviteStatusType] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (300) NOT NULL,
    [IsActive]    BIT            NOT NULL,
    [IsDefault]   BIT            NULL,
    CONSTRAINT [PK_EventInviteStatusType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_EventInviteStatusType_IsDefault] UNIQUE NONCLUSTERED ([IsDefault] ASC),
    CONSTRAINT [UQ_EventInviteStatusType_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);

