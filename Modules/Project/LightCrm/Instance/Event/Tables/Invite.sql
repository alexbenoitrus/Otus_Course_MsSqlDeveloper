CREATE TABLE [Event].[Invite] (
    [Id]         BIGINT IDENTITY (1, 1) NOT NULL,
    [EventId]    BIGINT NOT NULL,
    [TypeId]     BIGINT NOT NULL,
    [StatusId]   BIGINT NOT NULL,
    [PersonId]   BIGINT NOT NULL,
    [IsRequired] BIT    NOT NULL,
    CONSTRAINT [PK_Event_Invite] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Event_Invite_Event] FOREIGN KEY ([EventId]) REFERENCES [Event].[Event] ([Id]),
    CONSTRAINT [FK_Event_Invite_EventInviteStatus] FOREIGN KEY ([StatusId]) REFERENCES [Event].[InviteStatus] ([Id]),
    CONSTRAINT [FK_Event_Invite_Person] FOREIGN KEY ([PersonId]) REFERENCES [Org].[Person] ([Id]),
    CONSTRAINT [FK_Event_Invite_Type] FOREIGN KEY ([TypeId]) REFERENCES [Event].[InviteType] ([Id]),
    CONSTRAINT [UQ_Event_Invite_EventId_PersonId] UNIQUE NONCLUSTERED ([EventId] ASC, [PersonId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [FKIDX_Event_Invite_StatusTypeId]
    ON [Event].[Invite]([TypeId] ASC);


GO
CREATE NONCLUSTERED INDEX [FKIDX_Event_Invite_PersonId]
    ON [Event].[Invite]([PersonId] ASC);


GO
CREATE NONCLUSTERED INDEX [FKIDX_Event_Invite_EventId]
    ON [Event].[Invite]([EventId] ASC);


GO
CREATE NONCLUSTERED INDEX [FKIDX_Event_Invite_TypeId]
    ON [Event].[Invite]([TypeId] ASC);

