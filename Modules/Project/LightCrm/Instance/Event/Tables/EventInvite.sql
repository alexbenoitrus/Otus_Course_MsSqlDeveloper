CREATE TABLE [Event].[EventInvite] (
    [Id]           BIGINT IDENTITY (1, 1) NOT NULL,
    [EventId]      BIGINT NOT NULL,
    [StatusTypeId] BIGINT NOT NULL,
    [PersonId]     BIGINT NOT NULL,
    [IsRequired]   BIT    NOT NULL,
    CONSTRAINT [PK_EventInvite] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EventInvite_Event] FOREIGN KEY ([EventId]) REFERENCES [Event].[Event] ([Id]),
    CONSTRAINT [FK_EventInvite_EventInviteStatusType] FOREIGN KEY ([StatusTypeId]) REFERENCES [Event].[EventInviteStatusType] ([Id]),
    CONSTRAINT [FK_EventInvite_Person] FOREIGN KEY ([PersonId]) REFERENCES [Org].[Person] ([Id]),
    CONSTRAINT [UQ_EventInvite_EventId_PersonId] UNIQUE NONCLUSTERED ([EventId] ASC, [PersonId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [fkIdx_EventInvite_EventId]
    ON [Event].[EventInvite]([EventId] ASC);


GO
CREATE NONCLUSTERED INDEX [fkIdx_EventInvite_PersonId]
    ON [Event].[EventInvite]([PersonId] ASC);


GO
CREATE NONCLUSTERED INDEX [fkIdx_EventInvite_StatusTypeId]
    ON [Event].[EventInvite]([StatusTypeId] ASC);

