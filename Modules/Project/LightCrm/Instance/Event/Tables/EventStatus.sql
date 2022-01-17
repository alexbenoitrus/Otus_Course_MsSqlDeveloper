CREATE TABLE [Event].[EventStatus] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (300) NOT NULL,
    [IsActive]    BIT            NOT NULL,
    [IsDefault]   BIT            NULL,
    CONSTRAINT [PK_EventStatus] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_EventStatus_IsDefault] UNIQUE NONCLUSTERED ([IsDefault] ASC),
    CONSTRAINT [UQ_EventStatus_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);

