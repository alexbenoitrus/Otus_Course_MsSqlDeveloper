CREATE TABLE [Event].[ProductOnEvent] (
    [Id]        BIGINT       IDENTITY (1, 1) NOT NULL,
    [ProductId] BIGINT       NOT NULL,
    [EventId]   BIGINT       NOT NULL,
    [Price]     DECIMAL (18) NOT NULL,
    [Quantity]  DECIMAL (18) NOT NULL,
    CONSTRAINT [PK_ProductOnEvent] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductOnEvent_Event] FOREIGN KEY ([EventId]) REFERENCES [Event].[Event] ([Id]),
    CONSTRAINT [FK_ProductOnEvent_Product] FOREIGN KEY ([ProductId]) REFERENCES [Catalog].[Product] ([Id]),
    CONSTRAINT [UQ_ProductOnEvent_EventId_ProductId] UNIQUE NONCLUSTERED ([EventId] ASC, [ProductId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [fkIdx_ProductOnEvent_ProductId]
    ON [Event].[ProductOnEvent]([ProductId] ASC)
    INCLUDE([Price]);


GO
CREATE NONCLUSTERED INDEX [fkIdx_ProductOnEvent_EventId]
    ON [Event].[ProductOnEvent]([EventId] ASC)
    INCLUDE([Price]);

