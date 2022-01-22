CREATE TYPE [TVP].[ProductList] AS TABLE (
    [Id]       INT             NOT NULL,
    [Quantity] DECIMAL (18, 3) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC));

