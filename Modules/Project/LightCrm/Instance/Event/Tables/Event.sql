CREATE TABLE [Event].[Event] (
    [Id]                      BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]                    NVARCHAR (100) NOT NULL,
    [PreviosEventId]          BIGINT         NULL,
    [StatusId]                BIGINT         NOT NULL,
    [TypeId]                  BIGINT         NOT NULL,
    [Desctiption]             NVARCHAR (MAX) NOT NULL,
    [StartOn]                 DATETIME2 (7)  NOT NULL,
    [EndOn]                   DATETIME2 (7)  NOT NULL,
    [IsPlanned]               BIT            NOT NULL,
    [BusinessDirectionTypeId] BIGINT         NOT NULL,
    CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Event_BusinessDirectionType] FOREIGN KEY ([BusinessDirectionTypeId]) REFERENCES [Org].[BusinessDirectionType] ([Id]),
    CONSTRAINT [FK_Event_Event] FOREIGN KEY ([PreviosEventId]) REFERENCES [Event].[Event] ([Id]),
    CONSTRAINT [FK_Event_EventStatus] FOREIGN KEY ([StatusId]) REFERENCES [Event].[EventStatus] ([Id]),
    CONSTRAINT [FK_Event_EventType] FOREIGN KEY ([TypeId]) REFERENCES [Event].[EventType] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [fkIdx_Event_PreviosEventId]
    ON [Event].[Event]([PreviosEventId] ASC)
    INCLUDE([Name]);


GO
CREATE NONCLUSTERED INDEX [ix_Event_Name]
    ON [Event].[Event]([Name] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_Event_StartOn]
    ON [Event].[Event]([StartOn] ASC)
    INCLUDE([Name]);


GO
CREATE NONCLUSTERED INDEX [ix_Event_EndOn]
    ON [Event].[Event]([EndOn] ASC)
    INCLUDE([Name]);

