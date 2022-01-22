CREATE TABLE [Event].[ProductOnEvent] (
    [Id]        BIGINT       IDENTITY (1, 1) NOT NULL,
    [ProductId] BIGINT       NOT NULL,
    [EventId]   BIGINT       NOT NULL,
    [Price]     DECIMAL (18) NOT NULL,
    [Quantity]  DECIMAL (18) NOT NULL,
    CONSTRAINT [PK_Event_ProductOnEvent] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Event_ProductOnEvent_Event] FOREIGN KEY ([EventId]) REFERENCES [Event].[Event] ([Id]),
    CONSTRAINT [FK_Event_ProductOnEvent_Product] FOREIGN KEY ([ProductId]) REFERENCES [Catalog].[Product] ([Id]),
    CONSTRAINT [UQ_Event_ProductOnEvent_EventId_ProductId] UNIQUE NONCLUSTERED ([EventId] ASC, [ProductId] ASC)
);




GO



GO
CREATE NONCLUSTERED INDEX [FKIDX_Event_ProductOnEvent_ProductId]
    ON [Event].[ProductOnEvent]([ProductId] ASC)
    INCLUDE([Price]);


GO
CREATE NONCLUSTERED INDEX [FKIDX_Event_ProductOnEvent_EventId]
    ON [Event].[ProductOnEvent]([EventId] ASC)
    INCLUDE([Price]);

