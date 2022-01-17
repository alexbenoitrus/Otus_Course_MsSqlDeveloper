CREATE TABLE [Communication].[Channel] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (50)  NOT NULL,
    [Description] NVARCHAR (300) NOT NULL,
    [Icon]        NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Channel] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_Channel_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);

