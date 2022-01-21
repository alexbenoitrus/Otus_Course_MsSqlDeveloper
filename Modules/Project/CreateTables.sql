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
CREATE SCHEMA [Report];
GO
CREATE SCHEMA [UI];
GO
CREATE SCHEMA [Localization]
GO
CREATE SCHEMA [Extension]
GO
----------------------------------------------------------------

CREATE FULLTEXT CATALOG [DefaultCatalog]
	AS DEFAULT
	AUTHORIZATION [dbo]
GO

----------------------------------------------------------------

CREATE TABLE [Org].[AddressLevelType]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_AddressLevelType] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_AddressLevelType_IsDefault] UNIQUE ([IsDefault]),
 CONSTRAINT [UQ_AddressLevelType_Name] UNIQUE ([Name])
);
GO

----------------------------------------------------------------

CREATE TABLE [Org].[AddressLevel]
(
 [Id]         BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]       NVARCHAR(100) NOT NULL ,
 [TypeId]     BIGINT NOT NULL ,
 [ExternalId] NVARCHAR(50) NOT NULL ,
 [ParentId]	  BIGINT ,

 CONSTRAINT [PK_AddressLevel] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_AddressLevel_AddressLevelType] FOREIGN KEY ([TypeId])  REFERENCES [Org].[AddressLevelType]([Id]),
 CONSTRAINT [FK_AddressLevel_AddressLevel] FOREIGN KEY ([ParentId]) REFERENCES [Org].[AddressLevel]([Id]),

 CONSTRAINT [UQ_AddressLevel_Name_ParentId] UNIQUE ([Name], [ParentId]),
 CONSTRAINT [UQ_AddressLevel_ExternalId] UNIQUE ([ExternalId])
);

CREATE NONCLUSTERED INDEX [fkIdx_AddressLevel_ParentId] ON [Org].[AddressLevel] ([ParentId] ASC) INCLUDE ([Name])

CREATE NONCLUSTERED INDEX [ix_AddressLevel_Name] ON [Org].[AddressLevel] ([Name] ASC)
CREATE NONCLUSTERED INDEX [ix_AddressLevel_ExternalId] ON [Org].[AddressLevel] ([ExternalId] ASC)

CREATE FULLTEXT INDEX ON [Org].[AddressLevel]([Name], [ExternalId]) KEY INDEX [PK_AddressLevel] WITH (CHANGE_TRACKING AUTO)
GO

----------------------------------------------------------------

CREATE TABLE [Org].[BusinessDirectionType]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_BusinessDirectionType] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_BusinessDirectionType_Name] UNIQUE ([Name])
);
GO

----------------------------------------------------------------

CREATE TABLE [Org].[BusinessUnitType]
(
 [Id]						BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]						NVARCHAR(100) NOT NULL ,
 [Description]				NVARCHAR(300) NOT NULL ,
 [IsActive]					BIT NOT NULL ,
 [IsDefault]				BIT ,
 [BusinessDirectionTypeId]	BIGINT NOT NULL

 CONSTRAINT [PK_BusinessUnitType] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_BusinessUnitType_BusinessDirectionType] FOREIGN KEY ([BusinessDirectionTypeId])  REFERENCES [Org].[BusinessDirectionType]([Id]),

 CONSTRAINT [UQ_BusinessUnitType_Name] UNIQUE ([Name])
);

GO

----------------------------------------------------------------

CREATE TABLE [Org].[BusinessUnit]
(
 [Id]						BIGINT IDENTITY(1,1) NOT NULL ,
 [ParentId]					BIGINT ,
 [AddressLevelId]			BIGINT ,
 [TypeId]					BIGINT NOT NULL ,
 [Name]						NVARCHAR(100) NOT NULL ,
 [Description]				NVARCHAR(100) ,
 [Icon]						NVARCHAR(MAX) ,
 [ExternalId]				NVARCHAR(50) NOT NULL ,

 CONSTRAINT [PK_BusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_BusinessUnit_BusinessUnit] FOREIGN KEY ([ParentId])  REFERENCES [Org].[BusinessUnit]([Id]),
 CONSTRAINT [FK_BusinessUnit_AddressLevel] FOREIGN KEY ([AddressLevelId])  REFERENCES [Org].[AddressLevel]([Id]),
 CONSTRAINT [FK_BusinessUnit_BusinessUnitType] FOREIGN KEY ([TypeId])  REFERENCES [Org].[BusinessUnitType]([Id]),

 CONSTRAINT [UQ_BusinessUnit_Name_ParentId] UNIQUE ([Name], [ParentId]),
 CONSTRAINT [UQ_BusinessUnit_ExternalId] UNIQUE ([ExternalId])
);

CREATE NONCLUSTERED INDEX [fkIdx_BusinessUnit_ParentId] ON [Org].[BusinessUnit] ([ParentId] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [fkIdx_BusinessUnit_AddressLevelId] ON [Org].[BusinessUnit] ([AddressLevelId] ASC) INCLUDE ([Name])

CREATE NONCLUSTERED INDEX [ix_BusinessUnit_Name] ON [Org].[BusinessUnit] ([Name] ASC)
CREATE NONCLUSTERED INDEX [ix_BusinessUnit_ExternalId] ON [Org].[BusinessUnit] ([ExternalId] ASC) INCLUDE ([Name])

CREATE FULLTEXT INDEX ON [Org].[BusinessUnit]([Name], [ExternalId]) KEY INDEX [PK_BusinessUnit] WITH (CHANGE_TRACKING AUTO)
GO

----------------------------------------------------------------

CREATE TABLE [Org].[PersonStatus]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_PersonStatus] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_PersonStatus_Name] UNIQUE ([Name])
);
GO

----------------------------------------------------------------

CREATE TABLE [Org].[PersonType]
(
 [Id]						BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]						NVARCHAR(100) NOT NULL ,
 [Description]				NVARCHAR(300) NOT NULL ,
 [IsActive]					BIT NOT NULL ,
 [IsDefault]				BIT ,
 [BusinessDirectionTypeId]	BIGINT NOT NULL ,

 CONSTRAINT [PK_PersonType] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_PersonType_BusinessDirectionType] FOREIGN KEY ([BusinessDirectionTypeId])  REFERENCES [Org].[BusinessDirectionType]([Id]),
 
 CONSTRAINT [UQ_PersonType_Name] UNIQUE ([Name]),
);

GO

----------------------------------------------------------------

CREATE TABLE [Org].[GenderType]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_GenderType] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_GenderType_Name] UNIQUE ([Name])
);

GO

----------------------------------------------------------------

CREATE TABLE [Org].[Person]
(
 [Id]                BIGINT IDENTITY(1,1) NOT NULL ,
 [StatusId]          BIGINT NOT NULL ,
 [FirstName]         NVARCHAR(100) NOT NULL ,
 [LastName]          NVARCHAR(100) ,
 [MiddleName]        NVARCHAR(100) ,
 [GenderTypeId]      BIGINT ,
 [BusinessUnitId]    BIGINT NOT NULL,
 [Description]       NVARCHAR(MAX) ,
 [TypeId]            BIGINT NOT NULL ,
 [AddressLevelId]    BIGINT ,
 [AddressAdditional] NVARCHAR(100) ,
 [Icon]              NVARCHAR(MAX) ,
 [ExternalId]        NVARCHAR(50) ,
 [BirthDay]			 DATETIME2(7) ,
 [RegisterOn]		 DATETIME2(7) NOT NULL 

 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Person_BusinessUnit] FOREIGN KEY ([BusinessUnitId])  REFERENCES [Org].[BusinessUnit]([Id]),
 CONSTRAINT [FK_Person_PersonStatus] FOREIGN KEY ([StatusId])  REFERENCES [Org].[PersonStatus]([Id]),
 CONSTRAINT [FK_Person_PersonType] FOREIGN KEY ([TypeId])  REFERENCES [Org].[PersonType]([Id]),
 CONSTRAINT [FK_Person_AddressLevel] FOREIGN KEY ([AddressLevelId])  REFERENCES [Org].[AddressLevel]([Id]),
 CONSTRAINT [FK_Person_GenderType] FOREIGN KEY ([GenderTypeId]) REFERENCES [Org].[GenderType] ([Id]),

 CONSTRAINT [UQ_Person_ExternalId] UNIQUE ([ExternalId]),

 CONSTRAINT [CH_Person_BirthDay] CHECK ([BirthDay] < GETDATE()),
 CONSTRAINT [CH_Person_RegisterOn] CHECK ([RegisterOn] <= GETDATE())
);

CREATE NONCLUSTERED INDEX [fkIdx_Person_BusinessUnitId] ON [Org].[Person] ([BusinessUnitId] ASC) INCLUDE ([FirstName], [LastName], [MiddleName])
CREATE NONCLUSTERED INDEX [fkIdx_Person_AddressLevelId] ON [Org].[Person] ([AddressLevelId] ASC) INCLUDE ([ExternalId])

CREATE NONCLUSTERED INDEX [ix_Person_BirthDay] ON [Org].[Person] ([BirthDay] ASC) INCLUDE ([FirstName], [LastName], [MiddleName])
CREATE NONCLUSTERED INDEX [ix_Person_RegisterOn] ON [Org].[Person] ([RegisterOn] ASC) INCLUDE ([FirstName], [LastName], [MiddleName])
CREATE NONCLUSTERED INDEX [ix_Person_FirstName] ON [Org].[Person] ([FirstName] ASC) INCLUDE ([LastName], [MiddleName])
CREATE NONCLUSTERED INDEX [ix_Person_LastName] ON [Org].[Person] ([LastName] ASC) INCLUDE ([FirstName], [MiddleName])
CREATE NONCLUSTERED INDEX [ix_Person_MiddleName] ON [Org].[Person] ([MiddleName] ASC) INCLUDE ([FirstName], [LastName])
CREATE NONCLUSTERED INDEX [ix_Person_ExternalId] ON [Org].[Person] ([ExternalId] ASC) INCLUDE ([FirstName], [LastName], [MiddleName])

CREATE FULLTEXT INDEX ON [Org].[Person]([FirstName], [LastName], [MiddleName], [ExternalId]) KEY INDEX [PK_Person] WITH (CHANGE_TRACKING AUTO)
GO

----------------------------------------------------------------

CREATE TABLE [Org].[AdditionalBusinessUnit]
(
 [Id]             BIGINT IDENTITY(1,1) NOT NULL ,
 [BusinessUnitId] BIGINT NOT NULL ,
 [PersonId]       BIGINT NOT NULL ,

 CONSTRAINT [PK_AdditionalBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_AdditionalBusinessUnit_BusinessUnit] FOREIGN KEY ([BusinessUnitId])  REFERENCES [Org].[BusinessUnit]([Id]),
 CONSTRAINT [FK_AdditionalBusinessUnit_Person] FOREIGN KEY ([PersonId])  REFERENCES [Org].[Person]([Id]),

 CONSTRAINT [UQ_AdditionalBusinessUnit_PersonId_BusinessUnitId] UNIQUE ([PersonId], [BusinessUnitId])
);

CREATE NONCLUSTERED INDEX [fkIdx_AdditionalBusinessUnit_BusinessUnitId] ON [Org].[AdditionalBusinessUnit] ([BusinessUnitId] ASC)
CREATE NONCLUSTERED INDEX [fkIdx_AdditionalBusinessUnit_PersonId] ON [Org].[AdditionalBusinessUnit] ([PersonId] ASC)
GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[ProductMeasurementType]
(
 [Id]          BIGINT IDENTITY(1,1)  NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_ProductMeasurementType] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_ProductMeasurementType_Name] UNIQUE ([Name])
);
GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[ProductCatalogLevel]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [ParentId]    BIGINT ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [Icon]        NVARCHAR(MAX) ,
 [ExternalId]  NVARCHAR(50) ,

 CONSTRAINT [PK_ProductCatalogLevel] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_ProductCatalogLevel_ProductCatalogLevel] FOREIGN KEY ([ParentId])  REFERENCES [Catalog].[ProductCatalogLevel]([Id]),
 
 CONSTRAINT [UQ_ProductCatalogLevel_Name_ParentId] UNIQUE ([Name], [ParentId]),
 CONSTRAINT [UQ_ProductCatalogLevel_ExternalId] UNIQUE ([ExternalId])
);

CREATE NONCLUSTERED INDEX [fkIdx_ProductCatalogLevel_ParendId] ON [Catalog].[ProductCatalogLevel] ([ParentId] ASC) INCLUDE ([Name])

CREATE NONCLUSTERED INDEX [ix_ProductCatalogLevel_Name] ON [Catalog].[ProductCatalogLevel] ([Name] ASC)
CREATE NONCLUSTERED INDEX [ix_ProductCatalogLevel_ExtenalId] ON [Catalog].[ProductCatalogLevel] ([ExternalId] ASC) INCLUDE ([Name])

CREATE FULLTEXT INDEX ON [Catalog].[ProductCatalogLevel]([Name], [ExternalId]) KEY INDEX [PK_ProductCatalogLevel] WITH (CHANGE_TRACKING AUTO)
GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[Product]
(
 [Id]						BIGINT IDENTITY(1,1) NOT NULL ,
 [Price]					DECIMAL(18,0) NOT NULL ,
 [CatalogLevelId]			BIGINT ,
 [MeasurementTypeId]		BIGINT NOT NULL ,
 [Name]						NVARCHAR(100) NOT NULL ,
 [Description]				NVARCHAR(300) NOT NULL ,
 [IsActive]					BIT NOT NULL ,
 [Icon]						NVARCHAR(MAX) ,
 [ExternalId]				NVARCHAR(50) ,
 [BusinessDirectionTypeId]	BIGINT NOT NULL ,

 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Product_ProductMeasurementType] FOREIGN KEY ([MeasurementTypeId])  REFERENCES [catalog].[ProductMeasurementType]([Id]),
 CONSTRAINT [FK_Product_ProductCatalogLevel] FOREIGN KEY ([CatalogLevelId])  REFERENCES [catalog].[ProductCatalogLevel]([Id]),
 CONSTRAINT [FK_Product_BusinessDirectionType] FOREIGN KEY ([BusinessDirectionTypeId])  REFERENCES [Org].[BusinessDirectionType]([Id]),
 
 CONSTRAINT [UQ_Product_Name_ParentId_BusinessDirectionTypeId_MeasurementTypeId] UNIQUE ([Name], [CatalogLevelId], [BusinessDirectionTypeId], [MeasurementTypeId]),
 CONSTRAINT [UQ_Product_ExternalId] UNIQUE ([ExternalId])
);

CREATE NONCLUSTERED INDEX [fkIdx_Product_CatalogLevelId] ON [catalog].[Product] ([CatalogLevelId] ASC) INCLUDE ([Name]) 

CREATE NONCLUSTERED INDEX [ix_Product_Name] ON [Catalog].[Product] ([Name] ASC)
CREATE NONCLUSTERED INDEX [ix_Product_ExtenalId] ON [Catalog].[Product] ([ExternalId] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [ix_Product_Price] ON [Catalog].[Product] ([Price] ASC) INCLUDE ([Name])

CREATE FULLTEXT INDEX ON [Catalog].[Product]([Name], [ExternalId]) KEY INDEX [PK_Product] WITH (CHANGE_TRACKING AUTO)
GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[ProductPriceByBusinessUnit]
(
 [Id]             BIGINT IDENTITY(1,1) NOT NULL ,
 [ProductId]      BIGINT NOT NULL ,
 [BusinessUnitId] BIGINT NOT NULL ,
 [Price]          DECIMAL(18,0) NOT NULL ,
 [IsActive]       BIT NOT NULL ,

 CONSTRAINT [PK_ProductPriceByBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_ProductPriceByBusinessUnit_Product] FOREIGN KEY ([ProductId])  REFERENCES [Catalog].[Product]([Id]),
 CONSTRAINT [FK_ProductPriceByBusinessUnit_BusinessUnit] FOREIGN KEY ([BusinessUnitId])  REFERENCES [Org].[BusinessUnit]([Id]),

 CONSTRAINT [UQ_ProductPriceByBusinessUnit_ProductId_BusinessUnitId] UNIQUE ([ProductId], [BusinessUnitId])
);

CREATE NONCLUSTERED INDEX [fkIdx_ProductPriceByBusinessUnit_ProductId] ON [Catalog].[ProductPriceByBusinessUnit] ([ProductId] ASC) INCLUDE ([Price])
CREATE NONCLUSTERED INDEX [fkIdx_ProductPriceByBusinessUnit_BusinessUnitId] ON [Catalog].[ProductPriceByBusinessUnit] ([BusinessUnitId] ASC) INCLUDE ([Price])

CREATE NONCLUSTERED INDEX [ix_ProductPriceByBusinessUnit_Price] ON [Catalog].[ProductPriceByBusinessUnit] ([Price] ASC) INCLUDE ([ProductId], [BusinessUnitId])
GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[ProductPriceByPerson]
(
 [Id]        BIGINT IDENTITY(1,1) NOT NULL ,
 [PersonId]  BIGINT NOT NULL ,
 [ProductId] BIGINT NOT NULL ,
 [Price]     DECIMAL NOT NULL ,
 [IsActive]  BIT NOT NULL ,

 CONSTRAINT [PK_ProductPriceByPerson] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_ProductPriceByPerson_Person] FOREIGN KEY ([PersonId])  REFERENCES [Org].[Person]([Id]),
 CONSTRAINT [FK_ProductPriceByPerson_Product] FOREIGN KEY ([ProductId])  REFERENCES [Catalog].[Product]([Id]),
 
 CONSTRAINT [UQ_ProductPriceByPerson_ProductId_PersonId] UNIQUE ([ProductId], [PersonId])
);

CREATE NONCLUSTERED INDEX [fkIdx_ProductPriceByPerson_PersonId] ON [Catalog].[ProductPriceByPerson] ([PersonId] ASC) INCLUDE ([Price])
CREATE NONCLUSTERED INDEX [fkIdx_ProductPriceByPerson_ProductId] ON [Catalog].[ProductPriceByPerson] ([ProductId] ASC) INCLUDE ([Price])

CREATE NONCLUSTERED INDEX [ix_ProductPriceByPerson_Price] ON [Catalog].[ProductPriceByPerson] ([Price] ASC) INCLUDE ([ProductId], [PersonId])
GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[ProductSpecialPriceLevel]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Description] NVARCHAR(MAX) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,

 CONSTRAINT [PK_ProductSpecialPriceLevel] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_ProductSpecialPriceLevel_Name] UNIQUE ([Name])
);

GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[ProductSpecialPrice]
(
 [Id]        BIGINT IDENTITY(1,1) NOT NULL ,
 [Price]     DECIMAL(18,0) NOT NULL ,
 [LevelId]   BIGINT NOT NULL ,
 [ProductId] BIGINT NOT NULL ,
 [StartOn]   DATETIME2(7) NOT NULL ,
 [EndOn]     DATETIME2(7) NOT NULL ,
 [Reason]    NVARCHAR(MAX) NOT NULL ,
 [Name]      NVARCHAR(100) NOT NULL ,

 CONSTRAINT [PK_ProductSpecialPrice] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_ProductSpecialPrice_Product] FOREIGN KEY ([ProductId])  REFERENCES [Catalog].[Product]([Id]),
 CONSTRAINT [FK_ProductSpecialPrice_ProductSpecialPriceLevel] FOREIGN KEY ([LevelId])  REFERENCES [Catalog].[ProductSpecialPriceLevel]([Id]),
);

CREATE NONCLUSTERED INDEX [fkIdx_ProductSpecialPrice_ProductId] ON [Catalog].[ProductSpecialPrice] ([ProductId] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [fkIdx_ProductSpecialPrice_LevelId] ON [Catalog].[ProductSpecialPrice] ([LevelId] ASC) INCLUDE ([Name])

CREATE NONCLUSTERED INDEX [ix_ProductSpecialPrice_Price] ON [Catalog].[ProductSpecialPrice] ([Price] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [ix_ProductSpecialPrice_StartOn] ON [Catalog].[ProductSpecialPrice] ([StartOn] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [ix_ProductSpecialPrice_EndOn] ON [Catalog].[ProductSpecialPrice] ([EndOn] ASC) INCLUDE ([Name])

CREATE FULLTEXT INDEX ON [Catalog].[ProductSpecialPrice]([Name]) KEY INDEX [PK_ProductSpecialPrice] WITH (CHANGE_TRACKING AUTO)
GO

----------------------------------------------------------------

CREATE TABLE [Communication].[Channel]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(50) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [Icon]        NVARCHAR(MAX) ,

 CONSTRAINT [PK_Channel] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_Channel_Name] UNIQUE ([Name])
);
GO

----------------------------------------------------------------

CREATE TABLE [Communication].[ChannelIdentificatorForBusinessUnit]
(
 [Id]					BIGINT IDENTITY(1,1) NOT NULL ,
 [BusinessUnitId]		BIGINT NOT NULL ,
 [ChannelId]			BIGINT NOT NULL ,
 [Identificator]		NVARCHAR(200) NOT NULL ,
 [IsAppruved]			BIT NOT NULL ,
 [IsVoiceAllowed]		BIT NOT NULL ,
 [IsTextAllowed]		BIT NOT NULL ,
 [IsPriorityForChannel] BIT ,
 [IsMain]				BIT

 CONSTRAINT [PK_ChannelIdentificatorForBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC)

 CONSTRAINT [FK_ChannelIdentificatorForBusinessUnit_BusinessUnit] FOREIGN KEY ([BusinessUnitId])  REFERENCES [Org].[BusinessUnit]([Id]),
 CONSTRAINT [FK_ChannelIdentificatorForBusinessUnit_Channel] FOREIGN KEY ([ChannelId])  REFERENCES [Communication].[Channel]([Id]),

 CONSTRAINT [UQ_ChannelIdentificatorForBusinessUnit_BusinessUnitId_ChannelId_Identificator] UNIQUE ([BusinessUnitId], [ChannelId], [Identificator]),
 CONSTRAINT [UQ_ChannelIdentificatorForBusinessUnit_BusinessUnitId_ChannelId_IsPriorityForChannel] UNIQUE ([BusinessUnitId], [ChannelId], [IsPriorityForChannel]),
 CONSTRAINT [UQ_ChannelIdentificatorForBusinessUnit_BusinessUnitId_IsMain] UNIQUE ([BusinessUnitId], [IsMain])
);

CREATE NONCLUSTERED INDEX [fkIdx_ChannelIdentificatorForBusinessUnit_BusinessUnitId] ON [Communication].[ChannelIdentificatorForBusinessUnit] ([BusinessUnitId] ASC)

CREATE NONCLUSTERED INDEX [ix_ChannelIdentificatorForBusinessUnit_Identificator] ON [Communication].[ChannelIdentificatorForBusinessUnit] ([Identificator] ASC)

CREATE FULLTEXT INDEX ON [Communication].[ChannelIdentificatorForBusinessUnit]([Identificator]) KEY INDEX [PK_ChannelIdentificatorForBusinessUnit] WITH (CHANGE_TRACKING AUTO)
GO

----------------------------------------------------------------

CREATE TABLE [Communication].[ChannelIdentificatorForPerson]
(
 [Id]					BIGINT IDENTITY(1,1) NOT NULL ,
 [ChannelId]			BIGINT NOT NULL ,
 [PersonId]				BIGINT NOT NULL ,
 [Identificator]		NVARCHAR(200) NOT NULL ,
 [IsAppruved]			BIT NOT NULL ,
 [IsVoiceAllowed]		BIT NOT NULL ,
 [IsTextAllowed]		BIT NOT NULL ,
 [IsPriorityForChannel] BIT ,
 [IsMain]				BIT

 CONSTRAINT [PK_ChannelIdentificatorForPerson] PRIMARY KEY CLUSTERED ([Id] ASC),
 
 CONSTRAINT [FK_ChannelIdentificatorForPerson_Channel] FOREIGN KEY ([ChannelId])  REFERENCES [Communication].[Channel]([Id]),
 CONSTRAINT [FK_ChannelIdentificatorForPerson_Person] FOREIGN KEY ([PersonId])  REFERENCES [Org].[Person]([Id]),

 CONSTRAINT [UQ_ChannelIdentificatorForPerson_BusinessUnitId_ChannelId_Identificator] UNIQUE ([PersonId], [ChannelId], [Identificator]),
 CONSTRAINT [UQ_ChannelIdentificatorForPerson_BusinessUnitId_ChannelId_IsPriorityForChannel] UNIQUE ([PersonId], [ChannelId], [IsPriorityForChannel]),
 CONSTRAINT [UQ_ChannelIdentificatorForPerson_BusinessUnitId_IsMain] UNIQUE ([PersonId], [IsMain])
);

CREATE NONCLUSTERED INDEX [fkIdx_ChannelIdentificatorForPerson_ChannelId] ON [Communication].[ChannelIdentificatorForPerson] ([ChannelId] ASC) 

CREATE NONCLUSTERED INDEX [ix_ChannelIdentificatorForPerson_Identificator] ON [Communication].[ChannelIdentificatorForPerson] ([Identificator] ASC)

CREATE FULLTEXT INDEX ON [Communication].[ChannelIdentificatorForPerson]([Identificator]) KEY INDEX [PK_ChannelIdentificatorForPerson] WITH (CHANGE_TRACKING AUTO)
GO

----------------------------------------------------------------

CREATE TABLE [Configuration].[AttachmentAllow]
(
 [Id]      BIGINT IDENTITY(1,1) NOT NULL ,
 [TableId] INT NOT NULL ,

 CONSTRAINT [PK_AttachmentAllow] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_AttachmentAllow_TableId] UNIQUE ([TableId])
);
GO

----------------------------------------------------------------

CREATE TABLE [Configuration].[BasePreset]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(50) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [TableName]   NVARCHAR(100) NOT NULL ,
 [EntityId]    BIGINT NOT NULL ,
 [Data]        NVARCHAR(MAX) NOT NULL ,

 CONSTRAINT [PK_BasePreset] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Configuration].[HashtagAllow]
(
 [Id]      BIGINT IDENTITY(1,1) NOT NULL ,
 [TableId] INT NOT NULL ,

 CONSTRAINT [PK_HashtagAllow] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_HashtagAllow_TableId] UNIQUE ([TableId])
);
GO

----------------------------------------------------------------

CREATE TABLE [Configuration].[NoteAllow]
(
 [Id]      BIGINT NOT NULL ,
 [TableId] INT NOT NULL ,

 CONSTRAINT [PK_NoteAllow] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_NoteAllow_TableId] UNIQUE ([TableId])
);
GO

----------------------------------------------------------------

CREATE TABLE [Configuration].[PresetType]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_PresetType] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

----------------------------------------------------------------

CREATE TABLE [Configuration].[Preset]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [TypeId]      BIGINT NOT NULL ,
 [Name]        NVARCHAR(50) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [TableName]   NVARCHAR(100) NOT NULL ,
 [EntityId]    BIGINT NOT NULL ,
 [Data]        NVARCHAR(MAX) NOT NULL ,

 CONSTRAINT [PK_Preset] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Preset_PresetType] FOREIGN KEY ([TypeId])  REFERENCES [Configuration].[PresetType]([Id])
);

CREATE NONCLUSTERED INDEX [fkIdx_Preset_TypeId] ON [Configuration].[Preset] ([TypeId] ASC) INCLUDE ([Name])
GO

----------------------------------------------------------------

CREATE TABLE [Extension].[Attachment]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Body]        VARBINARY(MAX) NOT NULL ,
 [Description] NVARCHAR(MAX) NOT NULL ,

 CONSTRAINT [PK_Attachment] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE FULLTEXT INDEX ON [Extension].[Attachment]([Name]) KEY INDEX [PK_Attachment] WITH (CHANGE_TRACKING AUTO)
GO

----------------------------------------------------------------

CREATE TABLE [Extension].[AttachmentAssign]
(
 [Id]           BIGINT IDENTITY(1,1) NOT NULL ,
 [TableId]      INT NOT NULL ,
 [AttachmentId] BIGINT NOT NULL ,
 [EntityId]     BIGINT NOT NULL ,

 CONSTRAINT [PK_AttachmentAssign] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_AttachmentAssign_Attachment] FOREIGN KEY ([AttachmentId])  REFERENCES [Extension].[Attachment]([Id]),

 CONSTRAINT [UQ_AttachmentAssign_TableId_AttachmentId_EntityId] UNIQUE ([TableId], [AttachmentId], [EntityId])
);

CREATE NONCLUSTERED INDEX [fkIdx_AttachmentAssign_AttachmentId] ON [Extension].[AttachmentAssign] ([AttachmentId] ASC)
GO
----------------------------------------------------------------

CREATE TABLE [Extension].[FileHeader]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [FileId]      VARBINARY(MAX) NOT NULL ,
 [Description] NVARCHAR(MAX) NOT NULL ,

 CONSTRAINT [PK_FileHeader] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE NONCLUSTERED INDEX [ix_FileHeader_Name] ON [Extension].[FileHeader] ([Name] ASC)

CREATE FULLTEXT INDEX ON [Extension].[FileHeader]([Name]) KEY INDEX [PK_FileHeader] WITH (CHANGE_TRACKING AUTO)
GO

----------------------------------------------------------------

CREATE TABLE [Extension].[File]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Body]        VARBINARY(MAX) NOT NULL ,

 CONSTRAINT [PK_File] PRIMARY KEY CLUSTERED ([Id] ASC)
);

----------------------------------------------------------------

CREATE TABLE [Extension].[Hashtag]
(
 [Id]    BIGINT IDENTITY(1,1) NOT NULL ,
 [Name] NVARCHAR(50) NOT NULL ,

 CONSTRAINT [PK_Hashtag] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_Hashtag_Name] UNIQUE ([Name])
);

CREATE NONCLUSTERED INDEX [ix_HashTag_Name] ON [Extension].[Hashtag] ([Name] ASC)

CREATE FULLTEXT INDEX ON [Extension].[Hashtag]([Name]) KEY INDEX [PK_Hashtag] WITH (CHANGE_TRACKING AUTO)
GO

----------------------------------------------------------------

CREATE TABLE [Extension].[HashtagAssign]
(
 [Id]        BIGINT IDENTITY(1,1) NOT NULL ,
 [TableId]   INT NOT NULL ,
 [HashtagId] BIGINT NOT NULL ,
 [EntityId]  BIGINT NOT NULL ,

 CONSTRAINT [PK_HashtagAssign] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_HashtagAssign_Hashtag] FOREIGN KEY ([HashtagId])  REFERENCES [Extension].[Hashtag]([Id]),

 CONSTRAINT [UQ_HashtagAssign_TableId_HashtagId_EntityId] UNIQUE ([TableId], [HashtagId], [EntityId])
);

CREATE NONCLUSTERED INDEX [ix_HashtagAssign_HashtagIdTableIdEntityId] ON [Extension].[HashtagAssign] ([HashtagId] ASC, [TableId] ASC, [EntityId] ASC) 
CREATE NONCLUSTERED INDEX [ix_HashtagAssign_TableIdEntityId] ON [Extension].[HashtagAssign] ([TableId] ASC, [EntityId] ASC) INCLUDE ([HashtagId]) 
GO

----------------------------------------------------------------

CREATE TABLE [Extension].[Note]
(
 [Id]     BIGINT IDENTITY(1,1) NOT NULL ,
 [Name] NVARCHAR(300) NOT NULL ,
 [Body]   ntext NOT NULL ,

 CONSTRAINT [PK_Note] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE NONCLUSTERED INDEX [ix_Note_Name] ON [Extension].[Note] ([Name] ASC)

CREATE FULLTEXT INDEX ON [Extension].[Note]([Name]) KEY INDEX [PK_Note] WITH (CHANGE_TRACKING AUTO)
GO

----------------------------------------------------------------

CREATE TABLE [Extension].[NoteAssign]
(
 [Id]       BIGINT IDENTITY(1,1) NOT NULL ,
 [TableId]  INT NOT NULL ,
 [NoteId]   BIGINT NOT NULL ,
 [EntityId] BIGINT NOT NULL ,


 CONSTRAINT [PK_NoteAssign] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_NoteAssign_Note] FOREIGN KEY ([NoteId])  REFERENCES [Extension].[Note]([Id]),

 CONSTRAINT [UQ_NoteAssign_TableId_NoteId_EntityId] UNIQUE ([TableId], [NoteId], [EntityId])
);

CREATE NONCLUSTERED INDEX [ix_NoteAssign_HashtagIdTableIdEntityId] ON [Extension].[NoteAssign] ([NoteId] ASC, [TableId] ASC, [EntityId] ASC) 
CREATE NONCLUSTERED INDEX [ix_NoteAssign_TableIdEntityId] ON [Extension].[NoteAssign] ([TableId] ASC, [EntityId] ASC) INCLUDE ([NoteId]) 
GO

----------------------------------------------------------------

CREATE TABLE [Event].[EventStatus]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,
 
 CONSTRAINT [PK_EventStatus] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_EventStatus_Name] UNIQUE ([Name])
);
GO

----------------------------------------------------------------

CREATE TABLE [Event].[EventType]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_EventType] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_EventType_Name] UNIQUE ([Name])
);
GO

----------------------------------------------------------------

CREATE TABLE [Event].[Event]
(
 [Id]						BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]						NVARCHAR(100) NOT NULL ,
 [PreviosEventId]			BIGINT ,
 [StatusId]					BIGINT NOT NULL ,
 [TypeId]					BIGINT NOT NULL ,
 [Desctiption]				NVARCHAR(MAX) NOT NULL ,
 [StartOn]					DATETIME2(7) NOT NULL ,
 [EndOn]					DATETIME2(7) NOT NULL ,
 [IsPlanned]				BIT NOT NULL ,
 [BusinessDirectionTypeId]	BIGINT NOT NULL

 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Event_EventType] FOREIGN KEY ([TypeId])  REFERENCES [Event].[EventType]([Id]),
 CONSTRAINT [FK_Event_EventStatus] FOREIGN KEY ([StatusId])  REFERENCES [Event].[EventStatus]([Id]),
 CONSTRAINT [FK_Event_Event] FOREIGN KEY ([PreviosEventId])  REFERENCES [Event].[Event]([Id]),
 CONSTRAINT [FK_Event_BusinessDirectionType] FOREIGN KEY ([BusinessDirectionTypeId])  REFERENCES [Org].[BusinessDirectionType]([Id]),
);

CREATE NONCLUSTERED INDEX [fkIdx_Event_PreviosEventId] ON [Event].[Event] ([PreviosEventId] ASC) INCLUDE ([Name])

CREATE NONCLUSTERED INDEX [ix_Event_Name] ON [Event].[Event] ([Name] ASC)
CREATE NONCLUSTERED INDEX [ix_Event_StartOn] ON [Event].[Event] ([StartOn] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [ix_Event_EndOn] ON [Event].[Event] ([EndOn] ASC) INCLUDE ([Name])

CREATE FULLTEXT INDEX ON [Event].[Event]([Name]) KEY INDEX [PK_Event] WITH (CHANGE_TRACKING AUTO)
GO

----------------------------------------------------------------

CREATE TABLE [Event].[EventInviteStatusType]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_EventInviteStatusType] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_EventInviteStatusType_Name] UNIQUE ([Name])
);
GO

----------------------------------------------------------------

CREATE TABLE [Event].[EventInvite]
(
 [Id]           BIGINT IDENTITY(1,1) NOT NULL ,
 [EventId]      BIGINT NOT NULL ,
 [StatusTypeId] BIGINT NOT NULL ,
 [PersonId]     BIGINT NOT NULL ,
 [IsRequired]   BIT NOT NULL ,

 CONSTRAINT [PK_EventInvite] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_EventInvite_Event] FOREIGN KEY ([EventId])  REFERENCES [Event].[Event]([Id]),
 CONSTRAINT [FK_EventInvite_Person] FOREIGN KEY ([PersonId])  REFERENCES [Org].[Person]([Id]),
 CONSTRAINT [FK_EventInvite_EventInviteStatusType] FOREIGN KEY ([StatusTypeId])  REFERENCES [Event].[EventInviteStatusType]([Id]),

 CONSTRAINT [UQ_EventInvite_EventId_PersonId] UNIQUE ([EventId], [PersonId])
);

CREATE NONCLUSTERED INDEX [fkIdx_EventInvite_EventId] ON [Event].[EventInvite] ([EventId] ASC) 
CREATE NONCLUSTERED INDEX [fkIdx_EventInvite_PersonId] ON [Event].[EventInvite] ([PersonId] ASC) 
CREATE NONCLUSTERED INDEX [fkIdx_EventInvite_StatusTypeId] ON [Event].[EventInvite] ([StatusTypeId] ASC) 
GO

----------------------------------------------------------------

CREATE TABLE [Event].[ProductOnEvent]
(
 [Id]        BIGINT IDENTITY(1,1) NOT NULL ,
 [ProductId] BIGINT NOT NULL ,
 [EventId]   BIGINT NOT NULL ,
 [Price]     DECIMAL(18,0) NOT NULL ,
 [Quantity]  DECIMAL(18,0) NOT NULL ,

 CONSTRAINT [PK_ProductOnEvent] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_ProductOnEvent_Product] FOREIGN KEY ([ProductId])  REFERENCES [Catalog].[Product]([Id]),
 CONSTRAINT [FK_ProductOnEvent_Event] FOREIGN KEY ([EventId])  REFERENCES [Event].[Event]([Id]),
 
 CONSTRAINT [UQ_ProductOnEvent_EventId_ProductId] UNIQUE ([EventId], [ProductId])
);

CREATE NONCLUSTERED INDEX [fkIdx_ProductOnEvent_ProductId] ON [Event].[ProductOnEvent] ([ProductId] ASC) INCLUDE ([Price])
CREATE NONCLUSTERED INDEX [fkIdx_ProductOnEvent_EventId] ON [Event].[ProductOnEvent] ([EventId] ASC) INCLUDE ([Price])
GO

----------------------------------------------------------------

CREATE TABLE [Log].[Error]
(
 [Id]            BIGINT IDENTITY(1,1) NOT NULL ,
 [ProcedureName] NVARCHAR(300) NOT NULL ,
 [ErrorCode]     INT NOT NULL ,
 [Parameters]    NVARCHAR(MAX) NOT NULL ,

 CONSTRAINT [PK_Error] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE NONCLUSTERED INDEX [ix_Error_ProcedureName] ON [Log].[Error] ([ProcedureName] ASC) 
CREATE NONCLUSTERED INDEX [ix_Error_ErrorCode] ON [Log].[Error] ([ErrorCode] ASC) 
GO

----------------------------------------------------------------

CREATE TABLE [UI].[UserRole]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_UserRole_Name] UNIQUE ([Name])
);
GO

----------------------------------------------------------------

CREATE TABLE [UI].[User]
(
 [id]       BIGINT IDENTITY(1,1) NOT NULL ,
 [Login]    NVARCHAR(30) NOT NULL ,
 [PersonId] BIGINT NOT NULL ,
 [RoleId]   BIGINT NOT NULL ,
 [Password] NVARCHAR(100) NOT NULL ,
 [Salt]     NVARCHAR(10) NOT NULL ,

 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([id] ASC),

 CONSTRAINT [FK_User_UserRole] FOREIGN KEY ([RoleId])  REFERENCES [UI].[UserRole]([Id]),
 CONSTRAINT [FK_User_Person] FOREIGN KEY ([PersonId])  REFERENCES [Org].[Person]([Id]),

 CONSTRAINT [UQ_User_Login] UNIQUE ([Login]),
 CONSTRAINT [UQ_User_PersonId] UNIQUE ([PersonId])
);

CREATE NONCLUSTERED INDEX [fkIdx_User_PersonId] ON [UI].[User] ([PersonId] ASC) INCLUDE ([Login])

CREATE FULLTEXT INDEX ON [UI].[User]([Login]) KEY INDEX [PK_User] WITH (CHANGE_TRACKING AUTO)
GO

----------------------------------------------------------------

CREATE TABLE [UI].[Session]
(
 [id]         BIGINT IDENTITY(1,1) NOT NULL ,
 [UserId]     BIGINT NOT NULL ,
 [Key]        uniqueidentifier NOT NULL ,
 [IP]         NVARCHAR(39) NOT NULL ,
 [User-Agent] NVARCHAR(100) NOT NULL ,
 [DeviceId]   NVARCHAR(100) NOT NULL ,
 [LogOn]      DATETIME2(7) NOT NULL ,
 [LogOut]     DATETIME2(7) ,

 CONSTRAINT [PK_Session] PRIMARY KEY CLUSTERED ([id] ASC),

 CONSTRAINT [FK_Session_User] FOREIGN KEY ([UserId])  REFERENCES [UI].[User]([id]),

 CONSTRAINT [UQ_Session_Key] UNIQUE ([Key])
);

CREATE NONCLUSTERED INDEX [fkIdx_Session_User] ON [UI].[Session] ([UserId] ASC)

CREATE NONCLUSTERED INDEX [ix_Session_Key] ON [UI].[Session] ([Key] ASC)
GO

----------------------------------------------------------------

CREATE TABLE [History].[PersonStatus]
(
	[Id]			BIGINT IDENTITY(1,1) NOT NULL ,
	[PersonId]		BIGINT NOT NULL,
	[ChangerId]		BIGINT NOT NULL,
	[OldStatusId]	BIGINT NOT NULL,
	[NewStatusId]	BIGINT NOT NULL,
	[Reason]		NVARCHAR(MAX) NOT NULL,

	CONSTRAINT [PK_PersonStatus] PRIMARY KEY ([Id] ASC),

	CONSTRAINT [FK_PersonStatus_Person] FOREIGN KEY ([PersonId]) REFERENCES [Org].[Person]([Id]),
	CONSTRAINT [FK_PersonStatus_Person_Changer] FOREIGN KEY ([ChangerId]) REFERENCES [Org].[Person]([Id]),
	CONSTRAINT [FK_PersonStatus_StatusOld] FOREIGN KEY ([OldStatusId]) REFERENCES [Org].[PersonStatus]([Id]),
	CONSTRAINT [FK_PersonStatus_StatusNew] FOREIGN KEY ([NewStatusId]) REFERENCES [Org].[PersonStatus]([Id]),
)

CREATE NONCLUSTERED INDEX [fkIdx_History_PersonStatus_PersonId] ON [History].[PersonStatus] ([PersonId] ASC)
CREATE NONCLUSTERED INDEX [fkIdx_History_PersonStatus_ChangerId] ON [History].[PersonStatus] ([ChangerId] ASC)

----------------------------------------------------------------

CREATE TABLE [History].[PersonType]
(
	[Id]			BIGINT IDENTITY(1,1) NOT NULL ,
	[PersonId]		BIGINT NOT NULL,
	[ChangerId]		BIGINT NOT NULL,
	[OldTypeId]		BIGINT NOT NULL,
	[NewTypeId]		BIGINT NOT NULL,
	[Reason]		NVARCHAR(MAX) NOT NULL,

	CONSTRAINT [PK_PersonStatus] PRIMARY KEY ([Id] ASC),

	CONSTRAINT [FK_PersonStatus_Person] FOREIGN KEY ([PersonId]) REFERENCES [Org].[Person]([Id]),
	CONSTRAINT [FK_PersonStatus_Person_Changer] FOREIGN KEY ([ChangerId]) REFERENCES [Org].[Person]([Id]),
	CONSTRAINT [FK_PersonStatus_TypeOld] FOREIGN KEY ([OldTypeId]) REFERENCES [Org].[PersonType]([Id]),
	CONSTRAINT [FK_PersonStatus_TypeNew] FOREIGN KEY ([NewTypeId]) REFERENCES [Org].[PersonType]([Id]),
)

CREATE NONCLUSTERED INDEX [fkIdx_History_PersonType_PersonId] ON [History].[PersonType] ([PersonId] ASC)
CREATE NONCLUSTERED INDEX [fkIdx_History_PersonType_ChangerId] ON [History].[PersonType] ([ChangerId] ASC)

------------------------------------------------------------------

--CREATE TABLE [Localization].[Language]
--(
--	[Id]	BIGINT,
--	[Code]	INT,
--	[Name]	NVARCHAR(30)

--	CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED ([Id] ASC)
--)

------------------------------------------------------------------


---------------------------- SALES --------------------------------------

CREATE TABLE [Report].[Order]
(
 [id]						BIGINT NOT NULL ,
 [Date]						DATETIME2(7) NOT NULL ,
 [Sum]						DECIMAL(18,2) NOT NULL ,
 [Discount]					DECIMAL(18,2) NOT NULL ,
 [SellerId]					BIGINT NOT NULL,
 [SellerBusinesUnitId]		BIGINT NOT NULL,
 [SellerFullName]			NVARCHAR (300) NOT NULL,
 [SellerBusinesUnitName]	NVARCHAR (100) NOT NULL,
 [ClientId]					BIGINT NOT NULL,
 [ClientBusinesUnitId]		BIGINT NOT NULL,
 [ClientFullName]			NVARCHAR (300) NOT NULL,
 [ClientBusinesUnitName]	NVARCHAR (100) NOT NULL,

 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED ([id] ASC),
 
 CONSTRAINT [FK_Order_SellerId] FOREIGN KEY (SellerId)  REFERENCES [Org].[Person]([Id]),
 CONSTRAINT [FK_Order_ClientId] FOREIGN KEY (ClientId)  REFERENCES [Org].[Person]([Id]),
 CONSTRAINT [FK_Order_SellerBusinesUnitId] FOREIGN KEY ([SellerBusinesUnitId])  REFERENCES [Org].[BusinessUnit]([Id]),
 CONSTRAINT [FK_Order_ClientBusinesUnitId] FOREIGN KEY ([SellerBusinesUnitId])  REFERENCES [Org].[BusinessUnit]([Id]),
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_Order_SellerId] ON [Report].[Order] ([SellerId] ASC)
GO

CREATE NONCLUSTERED INDEX [fkIdx_Order_ClientId] ON [Report].[Order] ([ClientId] ASC)
GO

------------------------------------------------------------------

CREATE TABLE [Report].[OrderLine]
(
 [Id]			BIGINT NOT NULL ,
 [Name]			NVARCHAR(100) NOT NULL ,
 [Externalid]	NVARCHAR(50) NOT NULL ,
 [OrderId]		BIGINT NOT NULL ,
 [ProductId]	BIGINT NOT NULL ,
 [Count]		DECIMAL(18,3) NOT NULL ,
 [Sum]			DECIMAL(18,2) NOT NULL ,
 [Discount]		DECIMAL(18,2) NOT NULL ,

 CONSTRAINT [PK_OrderLine] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_OrderLine_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [Report].[Order]([Id]),
 CONSTRAINT [FK_OrderLine_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Catalog].[Product]([Id]),
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_OrderLine_OrderId] ON [Report].[OrderLine] ([OrderId] ASC)
GO

CREATE NONCLUSTERED INDEX [fkIdx_OrderLine_ProductId] ON [Report].[OrderLine] ([ProductId] ASC)
GO

CREATE NONCLUSTERED INDEX [fkIdx_OrderLine_Externalid] ON [Report].[OrderLine] ([Externalid] ASC)
GO
