CREATE TABLE [Extension].[Hashtag] (
    [Id]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [Name] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Extension_Hashtag] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_Extension_Hashtag_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_Extension_HashTag_Name]
    ON [Extension].[Hashtag]([Name] ASC);

