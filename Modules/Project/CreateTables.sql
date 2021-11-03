CREATE SCHEMA [Catalog];
GO
CREATE SCHEMA [Communication];
GO
CREATE SCHEMA [Configuration];
GO
CREATE SCHEMA [Event];
GO
CREATE SCHEMA [History];
GO
CREATE SCHEMA [Log];
GO
CREATE SCHEMA [Org];
GO
CREATE SCHEMA [Sales];
GO
CREATE SCHEMA [UI];
GO
CREATE SCHEMA [Localization]
GO
CREATE SCHEMA [Extension]
GO

----------------------------------------------------------------

CREATE TABLE [Org].[AddressLevelType]
(
 [Id]          bigint NOT NULL ,
 [Name]        nvarchar(100) NOT NULL ,
 [Description] nvarchar(300) NOT NULL ,
 [IsActive]    bit NOT NULL ,
 [IsDefault]   bit NULL ,

 CONSTRAINT [PK_AddressLevelType] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Org].[AddressLevel]
(
 [Id]         bigint NOT NULL ,
 [Name]       nvarchar(100) NOT NULL ,
 [TypeId]     bigint NOT NULL ,
 [ExternalId] nvarchar(50) NOT NULL ,
 [ParentId]	  bigint,

 CONSTRAINT [PK_AddressLevel] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_AddressLevel_AddressLevelType] FOREIGN KEY ([TypeId])  REFERENCES [Org].[AddressLevelType]([Id]),
 CONSTRAINT [FK_AddressLevel_AddressLevel] FOREIGN KEY ([ParentId]) REFERENCES [Org].[AddressLevel]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_AddressLevel_TypeId] ON [Org].[AddressLevel] ([TypeId] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [fkIdx_AddressLevel_ParentId] ON [Org].[AddressLevel] ([ParentId] ASC) INCLUDE ([Name])
GO

----------------------------------------------------------------

CREATE TABLE [Org].[BusinessDirectionType]
(
 [Id]          bigint NOT NULL ,
 [Name]        nvarchar(100) NOT NULL ,
 [Description] nvarchar(300) NOT NULL ,
 [IsActive]    bit NOT NULL ,
 [IsDefault]   bit NULL ,

 CONSTRAINT [PK_BusinessDirectionType] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Org].[BusinessUnitType]
(
 [Id]						bigint NOT NULL ,
 [Name]						nvarchar(100) NOT NULL ,
 [Description]				nvarchar(300) NOT NULL ,
 [IsActive]					bit NOT NULL ,
 [IsDefault]				bit NULL ,
 [BusinessDirectionTypeId]	bigint NOT NULL

 CONSTRAINT [PK_BusinessUnitType] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_BusinessUnit_BusinessDirectionType] FOREIGN KEY ([BusinessDirectionTypeId])  REFERENCES [Org].[BusinessDirectionType]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_BusinessUnit_BusinessDirectionTypeId] ON [Org].[BusinessUnitType] ([BusinessDirectionTypeId] ASC) INCLUDE ([Name])
GO

----------------------------------------------------------------

CREATE TABLE [Org].[BusinessUnit]
(
 [ParentId]					bigint NULL ,
 [AddressLevelId]			bigint NULL ,
 [TypeId]					bigint NOT NULL ,
 [Name]						nvarchar(100) NOT NULL ,
 [Description]				nvarchar(100) NULL ,
 [Icon]						nvarchar(max) NULL ,
 [ExternalId]				nvarchar(50) NOT NULL ,
 [Id]						bigint NOT NULL ,

 CONSTRAINT [PK_BusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_BusinessUnit_BusinessUnit] FOREIGN KEY ([ParentId])  REFERENCES [Org].[BusinessUnit]([Id]),
 CONSTRAINT [FK_BusinessUnit_AddressLevel] FOREIGN KEY ([AddressLevelId])  REFERENCES [Org].[AddressLevel]([Id]),
 CONSTRAINT [FK_BusinessUnit_BusinessUnitType] FOREIGN KEY ([TypeId])  REFERENCES [Org].[BusinessUnitType]([Id]),
);

CREATE NONCLUSTERED INDEX [fkIdx_BusinessUnit_ParentId] ON [Org].[BusinessUnit] ([ParentId] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [fkIdx_BusinessUnit_AddressLevelId] ON [Org].[BusinessUnit] ([AddressLevelId] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [fkIdx_BusinessUnit_TypeId] ON [Org].[BusinessUnit] ([TypeId] ASC) INCLUDE ([Name])
GO

----------------------------------------------------------------

CREATE TABLE [Org].[PersonStatus]
(
 [Id]          bigint NOT NULL ,
 [Name]        nvarchar(100) NOT NULL ,
 [Description] nvarchar(300) NOT NULL ,
 [IsActive]    bit NOT NULL ,
 [IsDefault]   bit NULL ,

 CONSTRAINT [PK_PersonStatus] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Org].[PersonType]
(
 [Id]						bigint NOT NULL ,
 [Name]						nvarchar(100) NOT NULL ,
 [Description]				nvarchar(300) NOT NULL ,
 [IsActive]					bit NOT NULL ,
 [IsDefault]				bit NULL ,
 [BusinessDirectionTypeId]	bigint NOT NULL ,

 CONSTRAINT [PK_PersonType] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_PersonType_BusinessDirectionType] FOREIGN KEY ([BusinessDirectionTypeId])  REFERENCES [Org].[BusinessDirectionType]([Id])
);

 CREATE NONCLUSTERED INDEX [fkIdx_PersonType_BusinessDirectionTypeId] ON [Org].[PersonType] ([BusinessDirectionTypeId] ASC) INCLUDE ([Name])
GO

----------------------------------------------------------------

CREATE TABLE [Org].[GenderType]
(
 [Id]          bigint NOT NULL ,
 [Name]        nvarchar(100) NOT NULL ,
 [Description] nvarchar(300) NOT NULL ,
 [IsActive]    bit NOT NULL ,
 [IsDefault]   bit NULL ,

 CONSTRAINT [PK_GenderType] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Org].[Person]
(
 [Id]                bigint NOT NULL ,
 [FirstName]         nvarchar(100) NOT NULL ,
 [StatusId]          bigint NOT NULL ,
 [BusinessUnitId]    bigint NULL ,
 [GenderTypeId]      bigint NULL ,
 [LastName]          nvarchar(100) NOT NULL ,
 [MiddleName]        nvarchar(100) NOT NULL ,
 [Description]       nvarchar(max) NOT NULL ,
 [TypeId]            bigint NOT NULL ,
 [AddressLevelId]    bigint NULL ,
 [AddressAdditional] nvarchar(100) NULL ,
 [Icon]              nvarchar(max) NULL ,
 [ExternalId]        nvarchar(50) NULL ,

 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_Person_BusinessUnit] FOREIGN KEY ([BusinessUnitId])  REFERENCES [Org].[BusinessUnit]([Id]),
 CONSTRAINT [FK_Person_PersonStatus] FOREIGN KEY ([StatusId])  REFERENCES [Org].[PersonStatus]([Id]),
 CONSTRAINT [FK_Person_PersonType] FOREIGN KEY ([TypeId])  REFERENCES [Org].[PersonType]([Id]),
 CONSTRAINT [FK_Person_AddressLevel] FOREIGN KEY ([AddressLevelId])  REFERENCES [Org].[AddressLevel]([Id]),
 CONSTRAINT [FK_Person_GenderType] FOREIGN KEY ([GenderTypeId]) REFERENCES [Org].[GenderType] ([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_Person_BusinessUnitId] ON [Org].[Person] ([BusinessUnitId] ASC) INCLUDE ([FirstName], [LastName], [MiddleName])
CREATE NONCLUSTERED INDEX [fkIdx_Person_StatusId] ON [Org].[Person] ([StatusId] ASC) INCLUDE ([FirstName], [LastName], [MiddleName])
CREATE NONCLUSTERED INDEX [fkIdx_Person_TypeId] ON [Org].[Person] ([TypeId] ASC) INCLUDE ([FirstName], [LastName], [MiddleName])
CREATE NONCLUSTERED INDEX [fkIdx_Person_AddressLevelId] ON [Org].[Person] ([AddressLevelId] ASC) INCLUDE ([FirstName], [LastName], [MiddleName])
CREATE NONCLUSTERED INDEX [fkIdx_Person_GenderTypeId] ON [Org].[Person] ([GenderTypeId] ASC) INCLUDE ([FirstName], [LastName], [MiddleName])
GO

----------------------------------------------------------------

CREATE TABLE [Org].[AdditionalBusinessUnit]
(
 [BusinessUnitId] bigint NOT NULL ,
 [PersonId]       bigint NOT NULL ,
 [Id]             bigint NOT NULL ,

 CONSTRAINT [PK_AdditionalBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_AdditionalBusinessUnit_BusinessUnit] FOREIGN KEY ([BusinessUnitId])  REFERENCES [Org].[BusinessUnit]([Id]),
 CONSTRAINT [FK_AdditionalBusinessUnit_Person] FOREIGN KEY ([PersonId])  REFERENCES [Org].[Person]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_AdditionalBusinessUnit_BusinessUnitId] ON [Org].[AdditionalBusinessUnit] ([BusinessUnitId] ASC)
CREATE NONCLUSTERED INDEX [fkIdx_AdditionalBusinessUnit_PersonId] ON [Org].[AdditionalBusinessUnit] ([PersonId] ASC)
GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[ProductMeasurementType]
(
 [Id]          bigint NOT NULL ,
 [Name]        nvarchar(100) NOT NULL ,
 [Description] nvarchar(300) NOT NULL ,
 [IsActive]    bit NOT NULL ,
 [IsDefault]   bit NULL ,

 CONSTRAINT [PK_ProductMeasurementType] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[ProductCatalogLevel]
(
 [ParendId]    bigint NULL ,
 [Name]        nvarchar(100) NOT NULL ,
 [Description] nvarchar(300) NOT NULL ,
 [Icon]        nvarchar(max) NULL ,
 [ExternalId]  nvarchar(50) NULL ,
 [Id]          bigint NOT NULL ,


 CONSTRAINT [PK_ProductCatalogLevel] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_ProductCatalogLevel_ProductCatalogLevel] FOREIGN KEY ([ParendId])  REFERENCES [Catalog].[ProductCatalogLevel]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_ProductCatalogLevel_ParendId] ON [Catalog].[ProductCatalogLevel] ([ParendId] ASC) INCLUDE ([Name])
GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[Product]
(
 [Price]					decimal(18,0) NOT NULL ,
 [CatalogLevelId]			bigint NULL ,
 [MeasurementTypeId]		bigint NOT NULL ,
 [Name]						nvarchar(100) NOT NULL ,
 [Description]				nvarchar(300) NOT NULL ,
 [IsActive]					bit NOT NULL ,
 [Icon]						nvarchar(max) NULL ,
 [ExternalId]				nvarchar(50) NULL ,
 [Id]						bigint NOT NULL ,
 [BusinessDirectionTypeId]	bigint NOT NULL,

 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_Product_ProductMeasurementType] FOREIGN KEY ([MeasurementTypeId])  REFERENCES [catalog].[ProductMeasurementType]([Id]),
 CONSTRAINT [FK_Product_ProductCatalogLevel] FOREIGN KEY ([CatalogLevelId])  REFERENCES [catalog].[ProductCatalogLevel]([Id]),
 CONSTRAINT [FK_Product_BusinessDirectionType] FOREIGN KEY ([BusinessDirectionTypeId])  REFERENCES [Org].[BusinessDirectionType]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_Product_MeasurementTypeId] ON [catalog].[Product] ([MeasurementTypeId] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [fkIdx_Product_CatalogLevelId] ON [catalog].[Product] ([CatalogLevelId] ASC) INCLUDE ([Name]) 
CREATE NONCLUSTERED INDEX [fkIdx_Product_BusinessDirectionTypeId] ON [catalog].[Product] ([BusinessDirectionTypeId] ASC) INCLUDE ([Name])
GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[ProductPriceByBusinessUnit]
(
 [Id]             bigint NOT NULL ,
 [ProductId]      bigint NOT NULL ,
 [BusinessUnitId] bigint NOT NULL ,
 [Price]          decimal(18,0) NOT NULL ,
 [IsActive]       bit NOT NULL ,

 CONSTRAINT [PK_ProductPriceByBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_ProductPriceByBusinessUnit_Product] FOREIGN KEY ([ProductId])  REFERENCES [Catalog].[Product]([Id]),
 CONSTRAINT [FK_ProductPriceByBusinessUnit_BusinessUnit] FOREIGN KEY ([BusinessUnitId])  REFERENCES [Org].[BusinessUnit]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_ProductPriceByBusinessUnit_ProductId] ON [Catalog].[ProductPriceByBusinessUnit] ([ProductId] ASC) INCLUDE ([Price])
CREATE NONCLUSTERED INDEX [fkIdx_ProductPriceByBusinessUnit_BusinessUnitId] ON [Catalog].[ProductPriceByBusinessUnit] ([BusinessUnitId] ASC) INCLUDE ([Price])
GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[ProductPriceByPerson]
(
 [PersonId]  bigint NOT NULL ,
 [ProductId] bigint NOT NULL ,
 [Price]     decimal NOT NULL ,
 [IsActive]  bit NOT NULL ,
 [Id]        bigint NOT NULL ,

 CONSTRAINT [PK_ProductPriceByPerson] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_ProductPriceByPerson_Person] FOREIGN KEY ([PersonId])  REFERENCES [Org].[Person]([Id]),
 CONSTRAINT [FK_ProductPriceByPerson_Product] FOREIGN KEY ([ProductId])  REFERENCES [Catalog].[Product]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_ProductPriceByPerson_PersonId] ON [Catalog].[ProductPriceByPerson] ([PersonId] ASC) INCLUDE ([Price])
CREATE NONCLUSTERED INDEX [fkIdx_ProductPriceByPerson_ProductId] ON [Catalog].[ProductPriceByPerson] ([ProductId] ASC) INCLUDE ([Price])
GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[ProductSpecialPriceLevel]
(
 [Id]          bigint NOT NULL ,
 [Description] nvarchar(max) NOT NULL ,
 [Name]        nvarchar(100) NOT NULL ,

 CONSTRAINT [PK_ProductSpecialPriceLevel] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[ProductSpecialPrice]
(
 [Id]        bigint NOT NULL ,
 [Price]     decimal(18,0) NOT NULL ,
 [LevelId]   bigint NOT NULL ,
 [ProductId] bigint NOT NULL ,
 [StartOn]   datetime2(7) NOT NULL ,
 [EndOn]     datetime2(7) NOT NULL ,
 [Reason]    nvarchar(max) NOT NULL ,
 [Name]      nvarchar(100) NOT NULL ,

 CONSTRAINT [PK_ProductSpecialPrice] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_ProductSpecialPrice_Product] FOREIGN KEY ([ProductId])  REFERENCES [Catalog].[Product]([Id]),
 CONSTRAINT [FK_ProductSpecialPrice_ProductSpecialPriceLevel] FOREIGN KEY ([LevelId])  REFERENCES [Catalog].[ProductSpecialPriceLevel]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_ProductSpecialPrice_ProductId] ON [Catalog].[ProductSpecialPrice] ([ProductId] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [fkIdx_ProductSpecialPrice_LevelId] ON [Catalog].[ProductSpecialPrice] ([LevelId] ASC) INCLUDE ([Name])
GO

----------------------------------------------------------------

CREATE TABLE [Communication].[Channel]
(
 [Id]          bigint NOT NULL ,
 [Name]        nvarchar(50) NOT NULL ,
 [Description] nvarchar(300) NOT NULL ,
 [Icon]        nvarchar(max) NULL ,

 CONSTRAINT [PK_Channel] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Communication].[ChannelIdentificatorForBusinessUnit]
(
 [BusinessUnitId] bigint NOT NULL ,
 [ChannelId]      bigint NOT NULL ,
 [lIdentificator] nvarchar(max) NOT NULL ,
 [IsAppruved]     bit NOT NULL ,
 [IsVoiceAllowed] bit NOT NULL ,
 [IsTextAllowed]  bit NOT NULL ,
 [Id]             bigint NOT NULL ,

 CONSTRAINT [PK_ChannelIdentificatorForBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_ChannelIdentificatorForBusinessUnit_BusinessUnit] FOREIGN KEY ([BusinessUnitId])  REFERENCES [Org].[BusinessUnit]([Id]),
 CONSTRAINT [FK_ChannelIdentificatorForBusinessUnit_Channel] FOREIGN KEY ([ChannelId])  REFERENCES [Communication].[Channel]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_ChannelIdentificatorForBusinessUnit_BusinessUnitId] ON [Communication].[ChannelIdentificatorForBusinessUnit] ([BusinessUnitId] ASC)
CREATE NONCLUSTERED INDEX [fkIdx_ChannelIdentificatorForBusinessUnit_ChannelId] ON [Communication].[ChannelIdentificatorForBusinessUnit] ([ChannelId] ASC)
GO

----------------------------------------------------------------

CREATE TABLE [Communication].[ChannelIdentificatorForPerson]
(
 [ChannelId]      bigint NOT NULL ,
 [PersonId]       bigint NOT NULL ,
 [lIdentificator] nvarchar(max) NOT NULL ,
 [IsAppruved]     bit NOT NULL ,
 [IsVoiceAllowed] bit NOT NULL ,
 [IsTextAllowed]  bit NOT NULL ,
 [Id]             bigint NOT NULL ,

 CONSTRAINT [PK_ChannelIdentificatorForPerson] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_ChannelIdentificatorForPerson_Channel] FOREIGN KEY ([ChannelId])  REFERENCES [Communication].[Channel]([Id]),
 CONSTRAINT [FK_ChannelIdentificatorForPerson_Person] FOREIGN KEY ([PersonId])  REFERENCES [Org].[Person]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_ChannelIdentificatorForPerson_ChannelId] ON [Communication].[ChannelIdentificatorForPerson] ([ChannelId] ASC) 
CREATE NONCLUSTERED INDEX [fkIdx_ChannelIdentificatorForPerson_PersonId] ON [Communication].[ChannelIdentificatorForPerson] ([PersonId] ASC) 
GO

----------------------------------------------------------------

CREATE TABLE [Configuration].[AttachmentAllow]
(
 [Id]      bigint NOT NULL ,
 [TableId] int NOT NULL ,

 CONSTRAINT [PK_AttachmentAllow] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Configuration].[BasePreset]
(
 [Id]          bigint NOT NULL ,
 [Name]        nvarchar(50) NOT NULL ,
 [Description] nvarchar(300) NOT NULL ,
 [TableName]   nvarchar(100) NOT NULL ,
 [EntityId]    bigint NOT NULL ,
 [Data]        nvarchar(max) NOT NULL ,

 CONSTRAINT [PK_BasePreset] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Configuration].[HashtagAllow]
(
 [Id]      bigint NOT NULL ,
 [TableId] int NOT NULL ,

 CONSTRAINT [PK_HashtagAllow] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Configuration].[NoteAllow]
(
 [Id]      bigint NOT NULL ,
 [TableId] int NOT NULL ,

 CONSTRAINT [PK_NoteAllow] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Configuration].[PresetType]
(
 [Id]          bigint NOT NULL ,
 [Name]        nvarchar(100) NOT NULL ,
 [Description] nvarchar(300) NOT NULL ,
 [IsActive]    bit NOT NULL ,
 [IsDefault]   bit NULL ,

 CONSTRAINT [PK_PresetType] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Configuration].[Preset]
(
 [Id]          bigint NOT NULL ,
 [TypeId]      bigint NOT NULL ,
 [Name]        nvarchar(50) NOT NULL ,
 [Description] nvarchar(300) NOT NULL ,
 [TableName]   nvarchar(100) NOT NULL ,
 [EntityId]    bigint NOT NULL ,
 [Data]        nvarchar(max) NOT NULL ,

 CONSTRAINT [PK_Preset] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_Preset_PresetType] FOREIGN KEY ([TypeId])  REFERENCES [Configuration].[PresetType]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_Preset_TypeId] ON [Configuration].[Preset] ([TypeId] ASC) INCLUDE ([Name])
GO

----------------------------------------------------------------

CREATE TABLE [Extension].[Attachment]
(
 [Id]          bigint NOT NULL ,
 [Name]        nvarchar(100) NOT NULL ,
 [Body]        varbinary(max) NOT NULL ,
 [Description] nvarchar(max) NOT NULL ,

 CONSTRAINT [PK_Attachment] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Extension].[AttachmentAssign]
(
 [Id]           bigint NOT NULL ,
 [TableId]      int NOT NULL ,
 [AttachmentId] bigint NOT NULL ,
 [EntityId]     bigint NOT NULL ,

 CONSTRAINT [PK_AttachmentAssign] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_AttachmentAssign_Attachment] FOREIGN KEY ([AttachmentId])  REFERENCES [Extension].[Attachment]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_AttachmentAssign_AttachmentId] ON [Extension].[AttachmentAssign] ([AttachmentId] ASC)
GO

----------------------------------------------------------------

CREATE TABLE [Extension].[File]
(
 [Id]          bigint NOT NULL ,
 [Name]        nvarchar(100) NOT NULL ,
 [Body]        varbinary(max) NOT NULL ,
 [Description] nvarchar(max) NOT NULL ,

 CONSTRAINT [PK_File] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Extension].[Hashtag]
(
 [Id]    bigint NOT NULL ,
 [Value] nvarchar(50) NOT NULL ,

 CONSTRAINT [PK_Hashtag] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Extension].[HashtagAssign]
(
 [Id]        bigint NOT NULL ,
 [TableId]   int NOT NULL ,
 [HashtagId] bigint NOT NULL ,
 [EntityId]  bigint NOT NULL ,

 CONSTRAINT [PK_HashtagAssign] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_HashtagAssign_Hashtag] FOREIGN KEY ([HashtagId])  REFERENCES [Extension].[Hashtag]([Id])
);

----------------------------------------------------------------

CREATE NONCLUSTERED INDEX [fkIdx_HashtagAssign_HashtagId] ON [Extension].[HashtagAssign] ([HashtagId] ASC) 
GO

CREATE TABLE [Extension].[Note]
(
 [Id]     bigint NOT NULL ,
 [Header] nvarchar(100) NOT NULL ,
 [Body]   ntext NOT NULL ,

 CONSTRAINT [PK_Note] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Extension].[NoteAssign]
(
 [Id]       bigint NOT NULL ,
 [TableId]  int NOT NULL ,
 [NoteId]   bigint NOT NULL ,
 [EntityId] bigint NOT NULL ,


 CONSTRAINT [PK_NoteAssign] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_NoteAssign_Note] FOREIGN KEY ([NoteId])  REFERENCES [Extension].[Note]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_NoteAssign_NoteId] ON [Extension].[NoteAssign] ([NoteId] ASC)
GO

----------------------------------------------------------------

CREATE TABLE [Event].[EventStatus]
(
 [Id]          bigint NOT NULL ,
 [Name]        nvarchar(100) NOT NULL ,
 [Description] nvarchar(300) NOT NULL ,
 [IsActive]    bit NOT NULL ,
 [IsDefault]   bit NULL ,
 
 CONSTRAINT [PK_EventStatus] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Event].[EventType]
(
 [Id]          bigint NOT NULL ,
 [Name]        nvarchar(100) NOT NULL ,
 [Description] nvarchar(300) NOT NULL ,
 [IsActive]    bit NOT NULL ,
 [IsDefault]   bit NULL ,

 CONSTRAINT [PK_EventType] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Event].[Event]
(
 [Name]						nvarchar(100) NOT NULL ,
 [PreviosEventId]			bigint NULL ,
 [StatusId]					bigint NOT NULL ,
 [TypeId]					bigint NOT NULL ,
 [Desctiption]				nvarchar(max) NOT NULL ,
 [StartOn]					datetime2(7) NOT NULL ,
 [EndOn]					datetime2(7) NOT NULL ,
 [IsPlanned]				bit NOT NULL ,
 [Id]						bigint NOT NULL ,
 [BusinessDirectionTypeId]	bigint NOT NULL

 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_Event_EventType] FOREIGN KEY ([TypeId])  REFERENCES [Event].[EventType]([Id]),
 CONSTRAINT [FK_Event_EventStatus] FOREIGN KEY ([StatusId])  REFERENCES [Event].[EventStatus]([Id]),
 CONSTRAINT [FK_Event_Event] FOREIGN KEY ([PreviosEventId])  REFERENCES [Event].[Event]([Id]),
 CONSTRAINT [FK_Event_BusinessDirectionType] FOREIGN KEY ([BusinessDirectionTypeId])  REFERENCES [Org].[BusinessDirectionType]([Id])

);

CREATE NONCLUSTERED INDEX [fkIdx_Event_TypeId] ON [Event].[Event] ([TypeId] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [fkIdx_Event_StatusId] ON [Event].[Event] ([StatusId] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [fkIdx_Event_PreviosEventId] ON [Event].[Event] ([PreviosEventId] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [fkIdx_Event_BusinessDirectionTypeId] ON [Event].[Event] ([BusinessDirectionTypeId] ASC) INCLUDE ([Name])
GO

----------------------------------------------------------------

CREATE TABLE [Event].[EventInviteStatusType]
(
 [Id]          bigint NOT NULL ,
 [Name]        nvarchar(100) NOT NULL ,
 [Description] nvarchar(300) NOT NULL ,
 [IsActive]    bit NOT NULL ,
 [IsDefault]   bit NULL ,

 CONSTRAINT [PK_EventInviteStatusType] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Event].[EventInvite]
(
 [Id]           bigint NOT NULL ,
 [EventId]      bigint NOT NULL ,
 [StatusTypeId] bigint NOT NULL ,
 [PersonId]     bigint NOT NULL ,
 [IsRequired]   bit NOT NULL ,

 CONSTRAINT [PK_EventInvite] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_EventInvite_Event] FOREIGN KEY ([EventId])  REFERENCES [Event].[Event]([Id]),
 CONSTRAINT [FK_EventInvite_Person] FOREIGN KEY ([PersonId])  REFERENCES [Org].[Person]([Id]),
 CONSTRAINT [FK_EventInvite_EventInviteStatusType] FOREIGN KEY ([StatusTypeId])  REFERENCES [Event].[EventInviteStatusType]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_EventInvite_EventId] ON [Event].[EventInvite] ([EventId] ASC) 
CREATE NONCLUSTERED INDEX [fkIdx_EventInvite_PersonId] ON [Event].[EventInvite] ([PersonId] ASC) 
CREATE NONCLUSTERED INDEX [fkIdx_EventInvite_StatusTypeId] ON [Event].[EventInvite] ([StatusTypeId] ASC) 
GO

----------------------------------------------------------------

CREATE TABLE [Event].[ProductOnEvent]
(
 [Id]        bigint NOT NULL ,
 [ProductId] bigint NOT NULL ,
 [EventId]   bigint NOT NULL ,
 [Price]     decimal(18,0) NOT NULL ,
 [Quantity]  decimal(18,0) NOT NULL ,

 CONSTRAINT [PK_ProductOnEvent] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_ProductOnEvent_Product] FOREIGN KEY ([ProductId])  REFERENCES [Catalog].[Product]([Id]),
 CONSTRAINT [FK_ProductOnEvent_Event] FOREIGN KEY ([EventId])  REFERENCES [Event].[Event]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_ProductOnEvent_ProductId] ON [Event].[ProductOnEvent] ([ProductId] ASC) INCLUDE ([Price])
CREATE NONCLUSTERED INDEX [fkIdx_ProductOnEvent_EventId] ON [Event].[ProductOnEvent] ([EventId] ASC) INCLUDE ([Price])
GO

----------------------------------------------------------------

CREATE TABLE [Log].[Error]
(
 [Id]            bigint NOT NULL ,
 [ProcedureName] nvarchar(max) NOT NULL ,
 [ErrorCode]     int NOT NULL ,
 [Parameters]    nvarchar(max) NOT NULL ,

 CONSTRAINT [PK_Error] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [UI].[UserRole]
(
 [Id]          bigint NOT NULL ,
 [Name]        nvarchar(100) NOT NULL ,
 [Description] nvarchar(300) NOT NULL ,
 [IsActive]    bit NOT NULL ,
 [IsDefault]   bit NULL ,

 CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [UI].[User]
(
 [id]       bigint NOT NULL ,
 [Login]    nvarchar(30) NOT NULL ,
 [PersonId] bigint NOT NULL ,
 [RoleId]   bigint NOT NULL ,
 [Password] nvarchar(100) NOT NULL ,
 [Salt]     nvarchar(10) NOT NULL ,

 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_User_UserRole] FOREIGN KEY ([RoleId])  REFERENCES [UI].[UserRole]([Id]),
 CONSTRAINT [FK_User_Person] FOREIGN KEY ([PersonId])  REFERENCES [Org].[Person]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_User_RoleId] ON [UI].[User] ([RoleId] ASC) INCLUDE ([Login])
CREATE NONCLUSTERED INDEX [fkIdx_User_PersonId] ON [UI].[User] ([PersonId] ASC) INCLUDE ([Login])
GO

----------------------------------------------------------------

CREATE TABLE [UI].[Session]
(
 [id]         bigint NOT NULL ,
 [UserId]     bigint NOT NULL ,
 [Key]        uniqueidentifier NOT NULL ,
 [IP]         nvarchar(39) NOT NULL ,
 [User-Agent] nvarchar(100) NOT NULL ,
 [DeviceId]   nvarchar(100) NOT NULL ,
 [LogOn]      datetime2(7) NOT NULL ,
 [LogOut]     datetime2(7) NULL ,

 CONSTRAINT [PK_Session] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_Session_User] FOREIGN KEY ([UserId])  REFERENCES [UI].[User]([id])
);

CREATE NONCLUSTERED INDEX [fkIdx_Session_User] ON [UI].[Session] ([UserId] ASC)
GO

------------------------------------------------------------------

--CREATE TABLE [Localization].[Language]
--(
--	[Id]	bigint,
--	[Code]	int,
--	[Name]	nvarchar(30)

--	CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED ([Id] ASC)
--)

------------------------------------------------------------------


---------------------------- SALES --------------------------------------

 -- ¬ œ–Œ–¿¡Œ“ ≈

--CREATE TABLE [Sales].[OrderStatus]
--(
-- [Id]          bigint NOT NULL ,
-- [Name]        nvarchar(100) NOT NULL ,
-- [Description] nvarchar(300) NOT NULL ,
-- [IsActive]    bit NOT NULL ,
-- [IsDefault]   bit NULL ,


-- CONSTRAINT [PK_187] PRIMARY KEY CLUSTERED ([Id] ASC)
--);
--GO

--CREATE TABLE [Sales].[Order]
--(
-- [id]        bigint NOT NULL ,
-- [Date]      datetime2(7) NOT NULL ,
-- [Sum]       decimal(18,0) NOT NULL ,
-- [Positions] nvarchar(max) NOT NULL ,
-- [StatusId]  bigint NOT NULL ,


-- CONSTRAINT [PK_388] PRIMARY KEY CLUSTERED ([id] ASC),
-- CONSTRAINT [FK_425] FOREIGN KEY ([StatusId])  REFERENCES [Sales].[OrderStatus]([Id])
--);
--GO


--CREATE NONCLUSTERED INDEX [fkIdx_427] ON [Sales].[Order] 
-- (
--  [StatusId] ASC
-- )

--GO

--CREATE TABLE [Sales].[OrderMemberType]
--(
-- [Id]          bigint NOT NULL ,
-- [Name]        nvarchar(100) NOT NULL ,
-- [Description] nvarchar(300) NOT NULL ,
-- [IsActive]    bit NOT NULL ,
-- [IsDefault]   bit NULL ,


-- CONSTRAINT [PK_187] PRIMARY KEY CLUSTERED ([Id] ASC)
--);
--GO

--CREATE TABLE [Sales].[OrderMember]
--(
-- [PersonId] bigint NOT NULL ,
-- [OrderId]  bigint NOT NULL ,
-- [TypeId]   bigint NOT NULL ,
-- [Id]       bigint NOT NULL ,


-- CONSTRAINT [PK_410] PRIMARY KEY CLUSTERED ([Id] ASC),
-- CONSTRAINT [FK_411] FOREIGN KEY ([PersonId])  REFERENCES [Org].[BusinessUnit]([Id]),
-- CONSTRAINT [FK_414] FOREIGN KEY ([OrderId])  REFERENCES [Sales].[Order]([id]),
-- CONSTRAINT [FK_442] FOREIGN KEY ([TypeId])  REFERENCES [Sales].[OrderMemberType]([Id])
--);
--GO


--CREATE NONCLUSTERED INDEX [fkIdx_413] ON [Sales].[OrderMember] 
-- (
--  [PersonId] ASC
-- )

--GO

--CREATE NONCLUSTERED INDEX [fkIdx_416] ON [Sales].[OrderMember] 
-- (
--  [OrderId] ASC
-- )

--GO

--CREATE NONCLUSTERED INDEX [fkIdx_444] ON [Sales].[OrderMember] 
-- (
--  [TypeId] ASC
-- )

--GO

--CREATE TABLE [Sales].[Purchase]
--(
-- [Date]      datetime2(7) NOT NULL ,
-- [PurcaseId] bigint NOT NULL ,
-- [Sum]       decimal(18,0) NOT NULL ,
-- [Positions] nvarchar(max) NOT NULL ,
-- [id]        bigint NOT NULL ,


-- CONSTRAINT [PK_388] PRIMARY KEY CLUSTERED ([id] ASC),
-- CONSTRAINT [FK_399] FOREIGN KEY ([PurcaseId])  REFERENCES [Sales].[Order]([id])
--);
--GO


--CREATE NONCLUSTERED INDEX [fkIdx_401] ON [Sales].[Purchase] 
-- (
--  [PurcaseId] ASC
-- )

--GO
