CREATE TABLE [Catalog].[ProductSpecialPrice] (
    [Id]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [Price]     DECIMAL (18)   NOT NULL,
    [LevelId]   BIGINT         NOT NULL,
    [ProductId] BIGINT         NOT NULL,
    [StartOn]   DATETIME2 (7)  NOT NULL,
    [EndOn]     DATETIME2 (7)  NOT NULL,
    [Reason]    NVARCHAR (MAX) NOT NULL,
    [Name]      NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_ProductSpecialPrice] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductSpecialPrice_Product] FOREIGN KEY ([ProductId]) REFERENCES [Catalog].[Product] ([Id]),
    CONSTRAINT [FK_ProductSpecialPrice_ProductSpecialPriceLevel] FOREIGN KEY ([LevelId]) REFERENCES [Catalog].[ProductSpecialPriceLevel] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [fkIdx_ProductSpecialPrice_ProductId]
    ON [Catalog].[ProductSpecialPrice]([ProductId] ASC)
    INCLUDE([Name]);


GO
CREATE NONCLUSTERED INDEX [fkIdx_ProductSpecialPrice_LevelId]
    ON [Catalog].[ProductSpecialPrice]([LevelId] ASC)
    INCLUDE([Name]);


GO
CREATE NONCLUSTERED INDEX [ix_ProductSpecialPrice_Price]
    ON [Catalog].[ProductSpecialPrice]([Price] ASC)
    INCLUDE([Name]);


GO
CREATE NONCLUSTERED INDEX [ix_ProductSpecialPrice_StartOn]
    ON [Catalog].[ProductSpecialPrice]([StartOn] ASC)
    INCLUDE([Name]);


GO
CREATE NONCLUSTERED INDEX [ix_ProductSpecialPrice_EndOn]
    ON [Catalog].[ProductSpecialPrice]([EndOn] ASC)
    INCLUDE([Name]);

