﻿CREATE TABLE [Org].[AddressLevelType] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (300) NOT NULL,
    [IsActive]    BIT            NOT NULL,
    [IsDefault]   BIT            NULL,
    CONSTRAINT [PK_AddressLevelType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_AddressLevelType_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);



