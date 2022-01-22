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
CREATE SCHEMA [DWH]
GO
CREATE SCHEMA [TVP]
GO
CREATE SCHEMA [SB]
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

 CONSTRAINT [PK_Org_AddressLevelType] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Org_AddressLevelType_Name]
	ON [Org].[AddressLevelType]([Name])
	WHERE [Name] IS NOT NULL;
	
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Org_AddressLevelType_IsDefault]
	ON [Org].[AddressLevelType]([IsDefault])
	WHERE [IsDefault] IS NOT NULL;

GO

----------------------------------------------------------------

CREATE TABLE [Org].[AddressLevel]
(
 [Id]         BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]       NVARCHAR(100) NOT NULL ,
 [TypeId]     BIGINT NOT NULL ,
 [ExternalId] NVARCHAR(50) NOT NULL ,
 [ParentId]	  BIGINT ,

 CONSTRAINT [PK_Org_AddressLevel] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Org_AddressLevel_AddressLevelType] FOREIGN KEY ([TypeId])  REFERENCES [Org].[AddressLevelType]([Id]),
 CONSTRAINT [FK_Org_AddressLevel_AddressLevel] FOREIGN KEY ([ParentId]) REFERENCES [Org].[AddressLevel]([Id]),

 CONSTRAINT [UQ_Org_AddressLevel_Name_ParentId] UNIQUE ([Name], [ParentId])
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Org_AddressLevel_ExternalId]
	ON [Org].[AddressLevel]([ExternalId])
	WHERE [ExternalId] IS NOT NULL;

CREATE NONCLUSTERED INDEX [FKIDX_Org_AddressLevel_ParentId] ON [Org].[AddressLevel] ([ParentId] ASC) INCLUDE ([Name])

CREATE NONCLUSTERED INDEX [IX_Org_AddressLevel_Name] ON [Org].[AddressLevel] ([Name] ASC)
CREATE NONCLUSTERED INDEX [IX_Org_AddressLevel_ExternalId] ON [Org].[AddressLevel] ([ExternalId] ASC)

CREATE FULLTEXT INDEX ON [Org].[AddressLevel]([Name], [ExternalId]) KEY INDEX [PK_Org_AddressLevel] WITH (CHANGE_TRACKING AUTO)

GO

----------------------------------------------------------------

CREATE TABLE [Org].[BusinessDirectionType]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_Org_BusinessDirectionType] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_Org_BusinessDirectionType_Name] UNIQUE ([Name])
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Org_BusinessDirectionType_IsDefault]
	ON [Org].[BusinessDirectionType]([IsDefault])
	WHERE [IsDefault] IS NOT NULL;

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

 CONSTRAINT [PK_Org_BusinessUnitType] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Org_BusinessUnitType_BusinessDirectionType] FOREIGN KEY ([BusinessDirectionTypeId])  REFERENCES [Org].[BusinessDirectionType]([Id]),

 CONSTRAINT [UQ_Org_BusinessUnitType_Name] UNIQUE ([Name])
);

GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Org_BusinessUnitType_IsDefault]
	ON [Org].[BusinessUnitType]([IsDefault])
	WHERE [IsDefault] IS NOT NULL;

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

 CONSTRAINT [PK_Org_BusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Org_BusinessUnit_BusinessUnit] FOREIGN KEY ([ParentId])  REFERENCES [Org].[BusinessUnit]([Id]),
 CONSTRAINT [FK_Org_BusinessUnit_AddressLevel] FOREIGN KEY ([AddressLevelId])  REFERENCES [Org].[AddressLevel]([Id]),
 CONSTRAINT [FK_Org_BusinessUnit_BusinessUnitType] FOREIGN KEY ([TypeId])  REFERENCES [Org].[BusinessUnitType]([Id]),

 CONSTRAINT [UQ_Org_BusinessUnit_Name_ParentId] UNIQUE ([Name], [ParentId])
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Org_BusinessUnit_ExternalId]
	ON [Org].[BusinessUnit]([ExternalId])
	WHERE [ExternalId] IS NOT NULL;

CREATE NONCLUSTERED INDEX [FKIDX_Org_BusinessUnit_ParentId] ON [Org].[BusinessUnit] ([ParentId] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [FKIDX_Org_BusinessUnit_AddressLevelId] ON [Org].[BusinessUnit] ([AddressLevelId] ASC) INCLUDE ([Name])

CREATE NONCLUSTERED INDEX [IX_Org_BusinessUnit_Name] ON [Org].[BusinessUnit] ([Name] ASC)
CREATE NONCLUSTERED INDEX [IX_Org_BusinessUnit_ExternalId] ON [Org].[BusinessUnit] ([ExternalId] ASC) INCLUDE ([Name])

CREATE FULLTEXT INDEX ON [Org].[BusinessUnit]([Name], [ExternalId]) KEY INDEX [PK_Org_BusinessUnit] WITH (CHANGE_TRACKING AUTO)

GO

----------------------------------------------------------------

CREATE TABLE [Org].[PersonStatus]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_Org_PersonStatus] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_Org_PersonStatus_Name] UNIQUE ([Name])
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Org_BusinessUnit_IsDefault]
	ON [Org].[PersonStatus]([IsDefault])
	WHERE [IsDefault] IS NOT NULL;

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

 CONSTRAINT [PK_Org_PersonType] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Org_PersonType_BusinessDirectionType] FOREIGN KEY ([BusinessDirectionTypeId])  REFERENCES [Org].[BusinessDirectionType]([Id]),
 
 CONSTRAINT [UQ_Org_PersonType_Name] UNIQUE ([Name]),
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Org_PersonType_IsDefault]
	ON [Org].[PersonType]([IsDefault])
	WHERE [IsDefault] IS NOT NULL;

GO

----------------------------------------------------------------

CREATE TABLE [Org].[GenderType]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_Org_GenderType] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_Org_GenderType_Name] UNIQUE ([Name])
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Org_GenderType_IsDefault]
	ON [Org].[GenderType]([IsDefault])
	WHERE [IsDefault] IS NOT NULL;

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

 CONSTRAINT [PK_Org_Person] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Org_Person_BusinessUnit] FOREIGN KEY ([BusinessUnitId])  REFERENCES [Org].[BusinessUnit]([Id]),
 CONSTRAINT [FK_Org_Person_PersonStatus] FOREIGN KEY ([StatusId])  REFERENCES [Org].[PersonStatus]([Id]),
 CONSTRAINT [FK_Org_Person_PersonType] FOREIGN KEY ([TypeId])  REFERENCES [Org].[PersonType]([Id]),
 CONSTRAINT [FK_Org_Person_AddressLevel] FOREIGN KEY ([AddressLevelId])  REFERENCES [Org].[AddressLevel]([Id]),
 CONSTRAINT [FK_Org_Person_GenderType] FOREIGN KEY ([GenderTypeId]) REFERENCES [Org].[GenderType] ([Id]),

 --CONSTRAINT [UQ_Org_Person_ExternalId] UNIQUE ([ExternalId]),

 CONSTRAINT [CH_Org_Person_BirthDay] CHECK ([BirthDay] < GETDATE()),
 CONSTRAINT [CH_Org_Person_RegisterOn] CHECK ([RegisterOn] <= GETDATE())
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Org_Person_ExternalId]
	ON [Org].[Person]([ExternalId])
	WHERE [ExternalId] IS NOT NULL;

CREATE NONCLUSTERED INDEX [FKIDX_Org_Person_BusinessUnitId] ON [Org].[Person] ([BusinessUnitId] ASC) INCLUDE ([FirstName], [LastName], [MiddleName])
CREATE NONCLUSTERED INDEX [FKIDX_Org_Person_AddressLevelId] ON [Org].[Person] ([AddressLevelId] ASC) INCLUDE ([ExternalId])

CREATE NONCLUSTERED INDEX [IX_Org_Person_BirthDay] ON [Org].[Person] ([BirthDay] ASC) INCLUDE ([FirstName], [LastName], [MiddleName])
CREATE NONCLUSTERED INDEX [IX_Org_Person_RegisterOn] ON [Org].[Person] ([RegisterOn] ASC) INCLUDE ([FirstName], [LastName], [MiddleName])
CREATE NONCLUSTERED INDEX [IX_Org_Person_FirstName] ON [Org].[Person] ([FirstName] ASC) INCLUDE ([LastName], [MiddleName])
CREATE NONCLUSTERED INDEX [IX_Org_Person_LastName] ON [Org].[Person] ([LastName] ASC) INCLUDE ([FirstName], [MiddleName])
CREATE NONCLUSTERED INDEX [IX_Org_Person_MiddleName] ON [Org].[Person] ([MiddleName] ASC) INCLUDE ([FirstName], [LastName])
CREATE NONCLUSTERED INDEX [IX_Org_Person_ExternalId] ON [Org].[Person] ([ExternalId] ASC) INCLUDE ([FirstName], [LastName], [MiddleName])

CREATE FULLTEXT INDEX ON [Org].[Person]([FirstName], [LastName], [MiddleName], [ExternalId]) KEY INDEX [PK_Org_Person] WITH (CHANGE_TRACKING AUTO)

GO

----------------------------------------------------------------

CREATE TABLE [Org].[AdditionalBusinessUnit]
(
 [Id]             BIGINT IDENTITY(1,1) NOT NULL ,
 [BusinessUnitId] BIGINT NOT NULL ,
 [PersonId]       BIGINT NOT NULL ,

 CONSTRAINT [PK_Org_AdditionalBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Org_AdditionalBusinessUnit_BusinessUnit] FOREIGN KEY ([BusinessUnitId])  REFERENCES [Org].[BusinessUnit]([Id]),
 CONSTRAINT [FK_Org_AdditionalBusinessUnit_Person] FOREIGN KEY ([PersonId])  REFERENCES [Org].[Person]([Id]),

 CONSTRAINT [UQ_Org_AdditionalBusinessUnit_PersonId_BusinessUnitId] UNIQUE ([PersonId], [BusinessUnitId])
);

CREATE NONCLUSTERED INDEX [FKIDX_Org_AdditionalBusinessUnit_BusinessUnitId] ON [Org].[AdditionalBusinessUnit] ([BusinessUnitId] ASC)
CREATE NONCLUSTERED INDEX [FKIDX_Org_AdditionalBusinessUnit_PersonId] ON [Org].[AdditionalBusinessUnit] ([PersonId] ASC)

GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[ProductMeasurementType]
(
 [Id]          BIGINT IDENTITY(1,1)  NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_Catalog_ProductMeasurementType] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_Catalog_ProductMeasurementType_Name] UNIQUE ([Name])
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Catalog_ProductMeasurementType_IsDefault]
	ON [Catalog].[ProductMeasurementType]([IsDefault])
	WHERE [IsDefault] IS NOT NULL;

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

 CONSTRAINT [PK_Catalog_ProductCatalogLevel] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Catalog_ProductCatalogLevel_ProductCatalogLevel] FOREIGN KEY ([ParentId])  REFERENCES [Catalog].[ProductCatalogLevel]([Id]),
 
 CONSTRAINT [UQ_Catalog_ProductCatalogLevel_Name_ParentId] UNIQUE ([Name], [ParentId])
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Catalog_ProductCatalogLevel_ExternalId]
	ON [Catalog].[ProductCatalogLevel]([ExternalId])
	WHERE [ExternalId] IS NOT NULL;

CREATE NONCLUSTERED INDEX [FKIDX_Catalog_ProductCatalogLevel_ParendId] ON [Catalog].[ProductCatalogLevel] ([ParentId] ASC) INCLUDE ([Name])

CREATE NONCLUSTERED INDEX [IX_Catalog_ProductCatalogLevel_Name] ON [Catalog].[ProductCatalogLevel] ([Name] ASC)
CREATE NONCLUSTERED INDEX [IX_Catalog_ProductCatalogLevel_ExtenalId] ON [Catalog].[ProductCatalogLevel] ([ExternalId] ASC) INCLUDE ([Name])

CREATE FULLTEXT INDEX ON [Catalog].[ProductCatalogLevel]([Name], [ExternalId]) KEY INDEX [PK_Catalog_ProductCatalogLevel] WITH (CHANGE_TRACKING AUTO)

GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[Product]
(
 [Id]						BIGINT IDENTITY(1,1) NOT NULL ,
 [Price]					DECIMAL(18,2) NOT NULL ,
 [CatalogLevelId]			BIGINT ,
 [MeasurementTypeId]		BIGINT NOT NULL ,
 [Name]						NVARCHAR(100) NOT NULL ,
 [Description]				NVARCHAR(300) ,
 [IsActive]					BIT NOT NULL ,
 [Icon]						NVARCHAR(MAX) ,
 [ExternalId]				NVARCHAR(50) ,
 [BusinessDirectionTypeId]	BIGINT NOT NULL ,

 CONSTRAINT [PK_Catalog_Product] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Catalog_Product_ProductMeasurementType] FOREIGN KEY ([MeasurementTypeId])  REFERENCES [catalog].[ProductMeasurementType]([Id]),
 CONSTRAINT [FK_Catalog_Product_ProductCatalogLevel] FOREIGN KEY ([CatalogLevelId])  REFERENCES [catalog].[ProductCatalogLevel]([Id]),
 CONSTRAINT [FK_Catalog_Product_BusinessDirectionType] FOREIGN KEY ([BusinessDirectionTypeId])  REFERENCES [Org].[BusinessDirectionType]([Id]),
 
 CONSTRAINT [UQ_Catalog_Product_Name_ParentId_BusinessDirectionTypeId_MeasurementTypeId] UNIQUE ([Name], [CatalogLevelId], [BusinessDirectionTypeId], [MeasurementTypeId]),
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Catalog_Product_ExternalId]
	ON [Catalog].[Product]([ExternalId])
	WHERE [ExternalId] IS NOT NULL;

CREATE NONCLUSTERED INDEX [FKIDX_Catalog_Product_CatalogLevelId] ON [catalog].[Product] ([CatalogLevelId] ASC) INCLUDE ([Name]) 

CREATE NONCLUSTERED INDEX [IX_Catalog_Product_Name] ON [Catalog].[Product] ([Name] ASC)
CREATE NONCLUSTERED INDEX [IX_Catalog_Product_ExtenalId] ON [Catalog].[Product] ([ExternalId] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [IX_Catalog_Product_Price] ON [Catalog].[Product] ([Price] ASC) INCLUDE ([Name])

CREATE FULLTEXT INDEX ON [Catalog].[Product]([Name], [ExternalId]) KEY INDEX [PK_Catalog_Product] WITH (CHANGE_TRACKING AUTO)

GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[ProductPriceByBusinessUnit]
(
 [Id]             BIGINT IDENTITY(1,1) NOT NULL ,
 [ProductId]      BIGINT NOT NULL ,
 [BusinessUnitId] BIGINT NOT NULL ,
 [Price]          DECIMAL(18,0) NOT NULL ,
 [IsActive]       BIT NOT NULL ,

 CONSTRAINT [PK_Catalog_ProductPriceByBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Catalog_ProductPriceByBusinessUnit_Product] FOREIGN KEY ([ProductId])  REFERENCES [Catalog].[Product]([Id]),
 CONSTRAINT [FK_Catalog_ProductPriceByBusinessUnit_BusinessUnit] FOREIGN KEY ([BusinessUnitId])  REFERENCES [Org].[BusinessUnit]([Id]),

 CONSTRAINT [UQ_Catalog_ProductPriceByBusinessUnit_ProductId_BusinessUnitId] UNIQUE ([ProductId], [BusinessUnitId])
);

CREATE NONCLUSTERED INDEX [FKIDX_Catalog_ProductPriceByBusinessUnit_ProductId] ON [Catalog].[ProductPriceByBusinessUnit] ([ProductId] ASC) INCLUDE ([Price])
CREATE NONCLUSTERED INDEX [FKIDX_Catalog_ProductPriceByBusinessUnit_BusinessUnitId] ON [Catalog].[ProductPriceByBusinessUnit] ([BusinessUnitId] ASC) INCLUDE ([Price])

CREATE NONCLUSTERED INDEX [IX_Catalog_ProductPriceByBusinessUnit_Price] ON [Catalog].[ProductPriceByBusinessUnit] ([Price] ASC) INCLUDE ([ProductId], [BusinessUnitId])

GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[ProductPriceByPerson]
(
 [Id]        BIGINT IDENTITY(1,1) NOT NULL ,
 [PersonId]  BIGINT NOT NULL ,
 [ProductId] BIGINT NOT NULL ,
 [Price]     DECIMAL NOT NULL ,
 [IsActive]  BIT NOT NULL ,

 CONSTRAINT [PK_Catalog_ProductPriceByPerson] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Catalog_ProductPriceByPerson_Person] FOREIGN KEY ([PersonId])  REFERENCES [Org].[Person]([Id]),
 CONSTRAINT [FK_Catalog_ProductPriceByPerson_Product] FOREIGN KEY ([ProductId])  REFERENCES [Catalog].[Product]([Id]),
 
 CONSTRAINT [UQ_Catalog_ProductPriceByPerson_ProductId_PersonId] UNIQUE ([ProductId], [PersonId])
);

CREATE NONCLUSTERED INDEX [FKIDX_Catalog_ProductPriceByPerson_PersonId] ON [Catalog].[ProductPriceByPerson] ([PersonId] ASC) INCLUDE ([Price])
CREATE NONCLUSTERED INDEX [FKIDX_Catalog_ProductPriceByPerson_ProductId] ON [Catalog].[ProductPriceByPerson] ([ProductId] ASC) INCLUDE ([Price])

CREATE NONCLUSTERED INDEX [IX_Catalog_ProductPriceByPerson_Price] ON [Catalog].[ProductPriceByPerson] ([Price] ASC) INCLUDE ([ProductId], [PersonId])

GO

----------------------------------------------------------------

CREATE TABLE [Catalog].[ProductSpecialPriceLevel]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Description] NVARCHAR(MAX) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,

 CONSTRAINT [PK_Catalog_ProductSpecialPriceLevel] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_Catalog_ProductSpecialPriceLevel_Name] UNIQUE ([Name])
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

 CONSTRAINT [PK_Catalog_ProductSpecialPrice] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Catalog_ProductSpecialPrice_Product] FOREIGN KEY ([ProductId])  REFERENCES [Catalog].[Product]([Id]),
 CONSTRAINT [FK_Catalog_ProductSpecialPrice_ProductSpecialPriceLevel] FOREIGN KEY ([LevelId])  REFERENCES [Catalog].[ProductSpecialPriceLevel]([Id]),
);

CREATE NONCLUSTERED INDEX [FKIDX_Catalog_ProductSpecialPrice_ProductId] ON [Catalog].[ProductSpecialPrice] ([ProductId] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [FKIDX_Catalog_ProductSpecialPrice_LevelId] ON [Catalog].[ProductSpecialPrice] ([LevelId] ASC) INCLUDE ([Name])

CREATE NONCLUSTERED INDEX [IX_Catalog_ProductSpecialPrice_Price] ON [Catalog].[ProductSpecialPrice] ([Price] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [IX_Catalog_ProductSpecialPrice_StartOn] ON [Catalog].[ProductSpecialPrice] ([StartOn] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [IX_Catalog_ProductSpecialPrice_EndOn] ON [Catalog].[ProductSpecialPrice] ([EndOn] ASC) INCLUDE ([Name])

CREATE FULLTEXT INDEX ON [Catalog].[ProductSpecialPrice]([Name]) KEY INDEX [PK_Catalog_ProductSpecialPrice] WITH (CHANGE_TRACKING AUTO)

GO

----------------------------------------------------------------

CREATE TABLE [Communication].[Channel]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(50) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [Icon]        NVARCHAR(MAX) ,

 CONSTRAINT [PK_Communication_Channel] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_Communication_Channel_Name] UNIQUE ([Name])
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

 CONSTRAINT [PK_Communication_ChannelIdentificatorForBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC)

 CONSTRAINT [FK_Communication_ChannelIdentificatorForBusinessUnit_BusinessUnit] FOREIGN KEY ([BusinessUnitId])  REFERENCES [Org].[BusinessUnit]([Id]),
 CONSTRAINT [FK_Communication_ChannelIdentificatorForBusinessUnit_Channel] FOREIGN KEY ([ChannelId])  REFERENCES [Communication].[Channel]([Id]),

 CONSTRAINT [UQ_Communication_ChannelIdentificatorForBusinessUnit_BusinessUnitId_ChannelId_Identificator] UNIQUE ([BusinessUnitId], [ChannelId], [Identificator])
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Communication_ChannelIdentificatorForBusinessUnit_BusinessUnitId_ChannelId_IsPriorityForChannel]
	ON [Communication].[ChannelIdentificatorForBusinessUnit]([BusinessUnitId], [ChannelId], [IsPriorityForChannel])
	WHERE [IsPriorityForChannel] IS NOT NULL;

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Communication_ChannelIdentificatorForBusinessUnit_BusinessUnitId_IsMain]
	ON [Communication].[ChannelIdentificatorForBusinessUnit]([BusinessUnitId], [IsMain])
	WHERE [IsMain] IS NOT NULL;

CREATE NONCLUSTERED INDEX [FKIDX_Communication_ChannelIdentificatorForBusinessUnit_BusinessUnitId] ON [Communication].[ChannelIdentificatorForBusinessUnit] ([BusinessUnitId] ASC)

CREATE NONCLUSTERED INDEX [IX_Communication_ChannelIdentificatorForBusinessUnit_Identificator] ON [Communication].[ChannelIdentificatorForBusinessUnit] ([Identificator] ASC)

CREATE FULLTEXT INDEX ON [Communication].[ChannelIdentificatorForBusinessUnit]([Identificator]) KEY INDEX [PK_Communication_ChannelIdentificatorForBusinessUnit] WITH (CHANGE_TRACKING AUTO)

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

 CONSTRAINT [PK_Communication_ChannelIdentificatorForPerson] PRIMARY KEY CLUSTERED ([Id] ASC),
 
 CONSTRAINT [FK_Communication_ChannelIdentificatorForPerson_Channel] FOREIGN KEY ([ChannelId])  REFERENCES [Communication].[Channel]([Id]),
 CONSTRAINT [FK_Communication_ChannelIdentificatorForPerson_Person] FOREIGN KEY ([PersonId])  REFERENCES [Org].[Person]([Id]),

 CONSTRAINT [UQ_Communication_ChannelIdentificatorForPerson_BusinessUnitId_ChannelId_Identificator] UNIQUE ([PersonId], [ChannelId], [Identificator])
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Communication_ChannelIdentificatorForPerson_BusinessUnitId_ChannelId_IsPriorityForChannel]
	ON [Communication].[ChannelIdentificatorForPerson]([PersonId], [ChannelId], [IsPriorityForChannel])
	WHERE [IsPriorityForChannel] IS NOT NULL;

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Communication_ChannelIdentificatorForPerson_BusinessUnitId_IsMain]
	ON [Communication].[ChannelIdentificatorForPerson]([PersonId], [IsMain])
	WHERE [IsMain] IS NOT NULL;

CREATE NONCLUSTERED INDEX [FKIDX_Communication_ChannelIdentificatorForPerson_ChannelId] ON [Communication].[ChannelIdentificatorForPerson] ([ChannelId] ASC) 

CREATE NONCLUSTERED INDEX [IX_Communication_ChannelIdentificatorForPerson_Identificator] ON [Communication].[ChannelIdentificatorForPerson] ([Identificator] ASC)

CREATE FULLTEXT INDEX ON [Communication].[ChannelIdentificatorForPerson]([Identificator]) KEY INDEX [PK_Communication_ChannelIdentificatorForPerson] WITH (CHANGE_TRACKING AUTO)

GO

----------------------------------------------------------------

CREATE TABLE [Configuration].[AttachmentAllow]
(
 [Id]      BIGINT IDENTITY(1,1) NOT NULL ,
 [TableId] INT NOT NULL ,

 CONSTRAINT [PK_Configuration_AttachmentAllow] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_Configuration_AttachmentAllow_TableId] UNIQUE ([TableId])
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

 CONSTRAINT [PK_Configuration_BasePreset] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

----------------------------------------------------------------

CREATE TABLE [Configuration].[HashtagAllow]
(
 [Id]      BIGINT IDENTITY(1,1) NOT NULL ,
 [TableId] INT NOT NULL ,

 CONSTRAINT [PK_Configuration_HashtagAllow] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_Configuration_HashtagAllow_TableId] UNIQUE ([TableId])
);

GO

----------------------------------------------------------------

CREATE TABLE [Configuration].[NoteAllow]
(
 [Id]      BIGINT NOT NULL ,
 [TableId] INT NOT NULL ,

 CONSTRAINT [PK_Configuration_NoteAllow] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_Configuration_NoteAllow_TableId] UNIQUE ([TableId])
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

 CONSTRAINT [PK_Configuration_PresetType] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Configuration_PresetType_IsDefault]
	ON [Configuration].[PresetType]([IsDefault])
	WHERE [IsDefault] IS NOT NULL;

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

 CONSTRAINT [PK_Configuration_Preset] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Configuration_Preset_PresetType] FOREIGN KEY ([TypeId])  REFERENCES [Configuration].[PresetType]([Id])
);

CREATE NONCLUSTERED INDEX [FKIDX_Configuration_Preset_TypeId] ON [Configuration].[Preset] ([TypeId] ASC) INCLUDE ([Name])

GO

----------------------------------------------------------------

CREATE TABLE [Extension].[Attachment]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Body]        VARBINARY(MAX) NOT NULL ,
 [Description] NVARCHAR(MAX) NOT NULL ,

 CONSTRAINT [PK_Extension_Attachment] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE FULLTEXT INDEX ON [Extension].[Attachment]([Name]) KEY INDEX [PK_Extension_Attachment] WITH (CHANGE_TRACKING AUTO)

GO

----------------------------------------------------------------

CREATE TABLE [Extension].[AttachmentAssign]
(
 [Id]           BIGINT IDENTITY(1,1) NOT NULL ,
 [TableId]      INT NOT NULL ,
 [AttachmentId] BIGINT NOT NULL ,
 [EntityId]     BIGINT NOT NULL ,

 CONSTRAINT [PK_Extension_AttachmentAssign] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Extension_AttachmentAssign_Attachment] FOREIGN KEY ([AttachmentId])  REFERENCES [Extension].[Attachment]([Id]),

 CONSTRAINT [UQ_Extension_AttachmentAssign_TableId_AttachmentId_EntityId] UNIQUE ([TableId], [AttachmentId], [EntityId])
);

CREATE NONCLUSTERED INDEX [FKIDX_Extension_AttachmentAssign_AttachmentId] ON [Extension].[AttachmentAssign] ([AttachmentId] ASC)

GO

----------------------------------------------------------------

CREATE TABLE [Extension].[FileHeader]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [FileId]      VARBINARY(MAX) NOT NULL ,
 [Description] NVARCHAR(MAX) NOT NULL ,

 CONSTRAINT [PK_Extension_FileHeader] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE NONCLUSTERED INDEX [IX_Extension_FileHeader_Name] ON [Extension].[FileHeader] ([Name] ASC)

CREATE FULLTEXT INDEX ON [Extension].[FileHeader]([Name]) KEY INDEX [PK_Extension_FileHeader] WITH (CHANGE_TRACKING AUTO)

GO

----------------------------------------------------------------

CREATE TABLE [Extension].[File]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Body]        VARBINARY(MAX) NOT NULL ,

 CONSTRAINT [PK_Extension_File] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

----------------------------------------------------------------

CREATE TABLE [Extension].[Hashtag]
(
 [Id]    BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]  NVARCHAR(50) NOT NULL ,

 CONSTRAINT [PK_Extension_Hashtag] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_Extension_Hashtag_Name] UNIQUE ([Name])
);

CREATE NONCLUSTERED INDEX [IX_Extension_HashTag_Name] ON [Extension].[Hashtag] ([Name] ASC)

CREATE FULLTEXT INDEX ON [Extension].[Hashtag]([Name]) KEY INDEX [PK_Extension_Hashtag] WITH (CHANGE_TRACKING AUTO)

GO

----------------------------------------------------------------

CREATE TABLE [Extension].[HashtagAssign]
(
 [Id]        BIGINT IDENTITY(1,1) NOT NULL ,
 [TableId]   INT NOT NULL ,
 [HashtagId] BIGINT NOT NULL ,
 [EntityId]  BIGINT NOT NULL ,

 CONSTRAINT [PK_Extension_HashtagAssign] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Extension_HashtagAssign_Hashtag] FOREIGN KEY ([HashtagId])  REFERENCES [Extension].[Hashtag]([Id]),

 CONSTRAINT [UQ_Extension_HashtagAssign_TableId_HashtagId_EntityId] UNIQUE ([TableId], [HashtagId], [EntityId])
);

CREATE NONCLUSTERED INDEX [IX_Extension_HashtagAssign_HashtagIdTableIdEntityId] ON [Extension].[HashtagAssign] ([HashtagId] ASC, [TableId] ASC, [EntityId] ASC) 
CREATE NONCLUSTERED INDEX [IX_Extension_HashtagAssign_TableIdEntityId] ON [Extension].[HashtagAssign] ([TableId] ASC, [EntityId] ASC) INCLUDE ([HashtagId]) 

GO

----------------------------------------------------------------

CREATE TABLE [Extension].[Note]
(
 [Id]     BIGINT IDENTITY(1,1) NOT NULL ,
 [Name] NVARCHAR(300) NOT NULL ,
 [Body]   ntext NOT NULL ,

 CONSTRAINT [PK_Extension_Note] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE NONCLUSTERED INDEX [IX_Extension_Note_Name] ON [Extension].[Note] ([Name] ASC)

CREATE FULLTEXT INDEX ON [Extension].[Note]([Name]) KEY INDEX [PK_Extension_Note] WITH (CHANGE_TRACKING AUTO)

GO

----------------------------------------------------------------

CREATE TABLE [Extension].[NoteAssign]
(
 [Id]       BIGINT IDENTITY(1,1) NOT NULL ,
 [TableId]  INT NOT NULL ,
 [NoteId]   BIGINT NOT NULL ,
 [EntityId] BIGINT NOT NULL ,

 CONSTRAINT [PK_Extension_NoteAssign] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Extension_NoteAssign_Note] FOREIGN KEY ([NoteId])  REFERENCES [Extension].[Note]([Id]),

 CONSTRAINT [UQ_Extension_NoteAssign_TableId_NoteId_EntityId] UNIQUE ([TableId], [NoteId], [EntityId])
);

CREATE NONCLUSTERED INDEX [IX_Extension_NoteAssign_HashtagIdTableIdEntityId] ON [Extension].[NoteAssign] ([NoteId] ASC, [TableId] ASC, [EntityId] ASC) 
CREATE NONCLUSTERED INDEX [IX_Extension_NoteAssign_TableIdEntityId] ON [Extension].[NoteAssign] ([TableId] ASC, [EntityId] ASC) INCLUDE ([NoteId]) 

GO

----------------------------------------------------------------

CREATE TABLE [Event].[Status]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,
 
 CONSTRAINT [PK_Event_Status] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_Event_Status_Name] UNIQUE ([Name])
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Event_Status_IsDefault]
	ON [Event].[Status]([IsDefault])
	WHERE [IsDefault] IS NOT NULL;

GO

----------------------------------------------------------------

CREATE TABLE [Event].[Type]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_Event_Type] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_Event_Type_Name] UNIQUE ([Name])
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Event_Type_IsDefault]
	ON [Event].[Type]([IsDefault])
	WHERE [IsDefault] IS NOT NULL;

GO

----------------------------------------------------------------

CREATE TABLE [Event].[Event]
(
 [Id]						BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]						NVARCHAR(100) NOT NULL ,
 [PreviosEventId]			BIGINT ,
 [StatusId]					BIGINT NOT NULL ,
 [TypeId]					BIGINT NOT NULL ,
 [Desctiption]				NVARCHAR(MAX) ,
 [StartOn]					DATETIME2(7) NOT NULL ,
 [EndOn]					DATETIME2(7) NOT NULL ,
 [IsPlanned]				BIT NOT NULL ,
 [BusinessDirectionTypeId]	BIGINT NOT NULL

 CONSTRAINT [PK_Event_Event] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Event_Event_Type] FOREIGN KEY ([TypeId])  REFERENCES [Event].[Type]([Id]),
 CONSTRAINT [FK_Event_Event_Status] FOREIGN KEY ([StatusId])  REFERENCES [Event].[Status]([Id]),
 CONSTRAINT [FK_Event_Event_Event] FOREIGN KEY ([PreviosEventId])  REFERENCES [Event].[Event]([Id]),
 CONSTRAINT [FK_Event_Event_BusinessDirectionType] FOREIGN KEY ([BusinessDirectionTypeId])  REFERENCES [Org].[BusinessDirectionType]([Id]),
);

CREATE NONCLUSTERED INDEX [FKIDX_Event_Event_PreviosEventId] ON [Event].[Event] ([PreviosEventId] ASC) INCLUDE ([Name])

CREATE NONCLUSTERED INDEX [IX_Event_Event_Name] ON [Event].[Event] ([Name] ASC)
CREATE NONCLUSTERED INDEX [IX_Event_Event_StartOn] ON [Event].[Event] ([StartOn] ASC) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [IX_Event_Event_EndOn] ON [Event].[Event] ([EndOn] ASC) INCLUDE ([Name])

CREATE FULLTEXT INDEX ON [Event].[Event]([Name]) KEY INDEX [PK_Event_Event] WITH (CHANGE_TRACKING AUTO)

GO

----------------------------------------------------------------

CREATE TABLE [Event].[InviteStatus]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_Event_InviteStatus] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_Event_InviteStatus_Name] UNIQUE ([Name])
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Event_InviteStatus_IsDefault]
	ON [Event].[InviteStatus]([IsDefault])
	WHERE [IsDefault] IS NOT NULL;

GO

----------------------------------------------------------------

CREATE TABLE [Event].[InviteType]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_Event_InviteType] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_Event_InviteType_Name] UNIQUE ([Name])
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Event_InviteType_IsDefault]
	ON [Event].[InviteType]([IsDefault])
	WHERE [IsDefault] IS NOT NULL;

GO

----------------------------------------------------------------

CREATE TABLE [Event].[Invite]
(
 [Id]           BIGINT IDENTITY(1,1) NOT NULL ,
 [EventId]      BIGINT NOT NULL ,
 [TypeId]       BIGINT NOT NULL ,
 [StatusId]     BIGINT NOT NULL ,
 [PersonId]     BIGINT NOT NULL ,
 [IsRequired]   BIT NOT NULL ,

 CONSTRAINT [PK_Event_Invite] PRIMARY KEY CLUSTERED ([Id] ASC),
 
 CONSTRAINT [FK_Event_Invite_Type] FOREIGN KEY ([TypeId])  REFERENCES [Event].[InviteType]([Id]),
 CONSTRAINT [FK_Event_Invite_Event] FOREIGN KEY ([EventId])  REFERENCES [Event].[Event]([Id]),
 CONSTRAINT [FK_Event_Invite_Person] FOREIGN KEY ([PersonId])  REFERENCES [Org].[Person]([Id]),
 CONSTRAINT [FK_Event_Invite_EventInviteStatus] FOREIGN KEY ([StatusId])  REFERENCES [Event].[InviteStatus]([Id]),

 CONSTRAINT [UQ_Event_Invite_EventId_PersonId] UNIQUE ([EventId], [PersonId])
);

CREATE NONCLUSTERED INDEX [FKIDX_Event_Invite_TypeId] ON [Event].[Invite] ([TypeId] ASC) 
CREATE NONCLUSTERED INDEX [FKIDX_Event_Invite_EventId] ON [Event].[Invite] ([EventId] ASC) 
CREATE NONCLUSTERED INDEX [FKIDX_Event_Invite_PersonId] ON [Event].[Invite] ([PersonId] ASC) 
CREATE NONCLUSTERED INDEX [FKIDX_Event_Invite_StatusTypeId] ON [Event].[Invite] ([TypeId] ASC) 

GO

----------------------------------------------------------------

CREATE TABLE [Event].[ProductOnEvent]
(
 [Id]        BIGINT IDENTITY(1,1) NOT NULL ,
 [ProductId] BIGINT NOT NULL ,
 [EventId]   BIGINT NOT NULL ,
 [Price]     DECIMAL(18,0) NOT NULL ,
 [Quantity]  DECIMAL(18,0) NOT NULL ,

 CONSTRAINT [PK_Event_ProductOnEvent] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Event_ProductOnEvent_Product] FOREIGN KEY ([ProductId])  REFERENCES [Catalog].[Product]([Id]),
 CONSTRAINT [FK_Event_ProductOnEvent_Event] FOREIGN KEY ([EventId])  REFERENCES [Event].[Event]([Id]),
 
 CONSTRAINT [UQ_Event_ProductOnEvent_EventId_ProductId] UNIQUE ([EventId], [ProductId])
);

CREATE NONCLUSTERED INDEX [FKIDX_Event_ProductOnEvent_ProductId] ON [Event].[ProductOnEvent] ([ProductId] ASC) INCLUDE ([Price])
CREATE NONCLUSTERED INDEX [FKIDX_Event_ProductOnEvent_EventId] ON [Event].[ProductOnEvent] ([EventId] ASC) INCLUDE ([Price])

GO

----------------------------------------------------------------

CREATE TABLE [Log].[Error]
(
 [Id]            BIGINT IDENTITY(1,1) NOT NULL ,
 [ProcedureName] NVARCHAR(300) NOT NULL ,
 [ErrorCode]     INT NOT NULL ,
 [ErrorMessage]  NVARCHAR(MAX) NOT NULL ,
 [Parameters]    NVARCHAR(MAX) NOT NULL ,
 [DateTime]		 DATETIME2(7) NOT NULL

 CONSTRAINT [PK_Log_Error] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE NONCLUSTERED INDEX [IX_Log_Error_ProcedureName] ON [Log].[Error] ([ProcedureName] ASC) 
CREATE NONCLUSTERED INDEX [IX_Log_Error_ErrorCode] ON [Log].[Error] ([ErrorCode] ASC) 

GO

----------------------------------------------------------------

CREATE TABLE [UI].[UserRole]
(
 [Id]          BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]        NVARCHAR(100) NOT NULL ,
 [Description] NVARCHAR(300) NOT NULL ,
 [IsActive]    BIT NOT NULL ,
 [IsDefault]   BIT ,

 CONSTRAINT [PK_UI_UserRole] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [UQ_UI_UserRole_Name] UNIQUE ([Name])
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_UI_UserRole_IsDefault]
	ON [UI].[UserRole]([IsDefault])
	WHERE [IsDefault] IS NOT NULL;

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

 CONSTRAINT [PK_UI_User] PRIMARY KEY CLUSTERED ([id] ASC),

 CONSTRAINT [FK_UI_User_UserRole] FOREIGN KEY ([RoleId])  REFERENCES [UI].[UserRole]([Id]),
 CONSTRAINT [FK_UI_User_Person] FOREIGN KEY ([PersonId])  REFERENCES [Org].[Person]([Id]),

 CONSTRAINT [UQ_UI_User_Login] UNIQUE ([Login]),
 CONSTRAINT [UQ_UI_User_PersonId] UNIQUE ([PersonId])
);

CREATE NONCLUSTERED INDEX [FKIDX_UI_User_PersonId] ON [UI].[User] ([PersonId] ASC) INCLUDE ([Login])

CREATE FULLTEXT INDEX ON [UI].[User]([Login]) KEY INDEX [PK_UI_User] WITH (CHANGE_TRACKING AUTO)

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

 CONSTRAINT [PK_UI_Session] PRIMARY KEY CLUSTERED ([id] ASC),

 CONSTRAINT [FK_UI_Session_User] FOREIGN KEY ([UserId])  REFERENCES [UI].[User]([id]),

 CONSTRAINT [UQ_UI_Session_Key] UNIQUE ([Key])
);

CREATE NONCLUSTERED INDEX [FKIDX_UI_Session_User] ON [UI].[Session] ([UserId] ASC)

CREATE NONCLUSTERED INDEX [IX_UI_Session_Key] ON [UI].[Session] ([Key] ASC)

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

	CONSTRAINT [PK_History_PersonStatus] PRIMARY KEY ([Id] ASC),

	CONSTRAINT [FK_History_PersonStatus_Person] FOREIGN KEY ([PersonId]) REFERENCES [Org].[Person]([Id]),
	CONSTRAINT [FK_History_PersonStatus_Person_Changer] FOREIGN KEY ([ChangerId]) REFERENCES [Org].[Person]([Id]),
	CONSTRAINT [FK_History_PersonStatus_StatusOld] FOREIGN KEY ([OldStatusId]) REFERENCES [Org].[PersonStatus]([Id]),
	CONSTRAINT [FK_History_PersonStatus_StatusNew] FOREIGN KEY ([NewStatusId]) REFERENCES [Org].[PersonStatus]([Id]),
)

CREATE NONCLUSTERED INDEX [FKIDX_History_PersonStatus_PersonId] ON [History].[PersonStatus] ([PersonId] ASC)
CREATE NONCLUSTERED INDEX [FKIDX_History_PersonStatus_ChangerId] ON [History].[PersonStatus] ([ChangerId] ASC)

GO

----------------------------------------------------------------

CREATE TABLE [History].[PersonType]
(
	[Id]			BIGINT IDENTITY(1,1) NOT NULL ,
	[PersonId]		BIGINT NOT NULL,
	[ChangerId]		BIGINT NOT NULL,
	[OldTypeId]		BIGINT NOT NULL,
	[NewTypeId]		BIGINT NOT NULL,
	[Reason]		NVARCHAR(MAX) NOT NULL,

	CONSTRAINT [PK_History_PersonType] PRIMARY KEY ([Id] ASC),

	CONSTRAINT [FK_History_PersonType_Person] FOREIGN KEY ([PersonId]) REFERENCES [Org].[Person]([Id]),
	CONSTRAINT [FK_History_PersonType_Person_Changer] FOREIGN KEY ([ChangerId]) REFERENCES [Org].[Person]([Id]),
	CONSTRAINT [FK_History_PersonType_TypeOld] FOREIGN KEY ([OldTypeId]) REFERENCES [Org].[PersonType]([Id]),
	CONSTRAINT [FK_History_PersonType_TypeNew] FOREIGN KEY ([NewTypeId]) REFERENCES [Org].[PersonType]([Id])
)

CREATE NONCLUSTERED INDEX [FKIDX_History_PersonType_PersonId] ON [History].[PersonType] ([PersonId] ASC)
CREATE NONCLUSTERED INDEX [FKIDX_History_PersonType_ChangerId] ON [History].[PersonType] ([ChangerId] ASC)

GO

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
 [id]						BIGINT IDENTITY(1,1) NOT NULL ,
 [Date]						DATETIME2(7) NOT NULL ,
 [Sum]						DECIMAL(18,2) NOT NULL ,
 [Discount]					DECIMAL(18,2) NOT NULL ,
 [EventId]					BIGINT NOT NULL,
 [EventName]				NVARCHAR (100) NOT NULL,
 [SellerId]					BIGINT NOT NULL,
 [SellerBusinessUnitId]		BIGINT NOT NULL,
 [SellerFullName]			NVARCHAR (300) NOT NULL,
 [SellerBusinessUnitName]	NVARCHAR (100) NOT NULL,
 [ClientId]					BIGINT NOT NULL,
 [ClientBusinessUnitId]		BIGINT NOT NULL,
 [ClientFullName]			NVARCHAR (300) NOT NULL,
 [ClientBusinessUnitName]	NVARCHAR (100) NOT NULL,

 CONSTRAINT [PK_Report_Order] PRIMARY KEY CLUSTERED ([id] ASC),
 
 --CONSTRAINT [FK_Report_Order_EventId] FOREIGN KEY (EventId)  REFERENCES [Event].[Event]([Id]),
 CONSTRAINT [FK_Report_Order_SellerId] FOREIGN KEY (SellerId)  REFERENCES [Org].[Person]([Id]),
 CONSTRAINT [FK_Report_Order_ClientId] FOREIGN KEY (ClientId)  REFERENCES [Org].[Person]([Id]),
 CONSTRAINT [FK_Report_Order_SellerBusinessUnitId] FOREIGN KEY ([SellerBusinessUnitId])  REFERENCES [Org].[BusinessUnit]([Id]),
 CONSTRAINT [FK_Report_Order_ClientBusinessUnitId] FOREIGN KEY ([ClientBusinessUnitId])  REFERENCES [Org].[BusinessUnit]([Id])
);
GO

--CREATE NONCLUSTERED INDEX [FKIDX_Report_Order_EventId] ON [Report].[Order] ([EventId] ASC)
CREATE NONCLUSTERED INDEX [FKIDX_Report_Order_SellerId] ON [Report].[Order] ([SellerId] ASC)
CREATE NONCLUSTERED INDEX [FKIDX_Report_Order_ClientId] ON [Report].[Order] ([ClientId] ASC)
CREATE NONCLUSTERED INDEX [FKIDX_Report_Order_SellerBusinessUnitId] ON [Report].[Order] ([SellerBusinessUnitId] ASC)
CREATE NONCLUSTERED INDEX [FKIDX_Report_Order_ClientBusinessUnitId] ON [Report].[Order] ([ClientBusinessUnitId] ASC)
GO

------------------------------------------------------------------

CREATE TABLE [Report].[OrderLine]
(
 [Id]			BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]			NVARCHAR(100) NOT NULL ,
 [Externalid]	NVARCHAR(50) ,
 [OrderId]		BIGINT NOT NULL ,
 [ProductId]	BIGINT NOT NULL ,
 [Count]		DECIMAL(18,3) NOT NULL ,
 [Price]		DECIMAL(18,2) NOT NULL ,
 [Sum]			DECIMAL(18,2) NOT NULL ,
 [Discount]		DECIMAL(18,2) NOT NULL ,

 CONSTRAINT [PK_Report_OrderLine] PRIMARY KEY CLUSTERED ([Id] ASC),

 CONSTRAINT [FK_Report_OrderLine_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [Report].[Order]([Id]),
 CONSTRAINT [FK_Report_OrderLine_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Catalog].[Product]([Id])
);
GO

CREATE NONCLUSTERED INDEX [FKIDX_Report_OrderLine_OrderId] ON [Report].[OrderLine] ([OrderId] ASC)
CREATE NONCLUSTERED INDEX [FKIDX_Report_OrderLine_ProductId] ON [Report].[OrderLine] ([ProductId] ASC)
CREATE NONCLUSTERED INDEX [FKIDX_Report_OrderLine_Externalid] ON [Report].[OrderLine] ([Externalid] ASC)
GO

---------------------------- Mini DWH --------------------------------------

CREATE TABLE [DWH].[DimPerson]
(
 [Id]                BIGINT IDENTITY(1,1) NOT NULL ,
 [FirstName]         NVARCHAR(100) NOT NULL ,
 [LastName]          NVARCHAR(100) ,
 [MiddleName]        NVARCHAR(100) ,
 [Icon]              NVARCHAR(MAX) ,
 [ExternalId]        NVARCHAR(50) ,

 CONSTRAINT [PK_DWH_DimPerson] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_DWH_DimPerson_ExternalId]
	ON [DWH].[DimPerson]([ExternalId])
	WHERE [ExternalId] IS NOT NULL;

GO

------------------------------------------------------------------

CREATE TABLE [DWH].[DimBusinessUnit]
(
 [Id]			BIGINT IDENTITY(1,1) NOT NULL ,
 [Name]			NVARCHAR(100) NOT NULL ,
 [Icon]			NVARCHAR(MAX) ,
 [ExternalId]	NVARCHAR(50) NOT NULL ,

 CONSTRAINT [PK_DWH_DimBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_DWH_DimBusinessUnit_ExternalId]
	ON [DWH].[DimBusinessUnit]([ExternalId])
	WHERE [ExternalId] IS NOT NULL;
	
GO

-------------------------------------------------------------------

CREATE TABLE [DWH].[DimDate]
(
 [Id]		BIGINT IDENTITY(1,1) NOT NULL ,
 [Day]	    INT NOT NULL,
 [Month]	INT NOT NULL,
 [Year]	    INT NOT NULL,

 CONSTRAINT [PK_DWH_DimDate] PRIMARY KEY CLUSTERED ([id] ASC),

 CONSTRAINT [CHK_DWH_DimDate_Day] CHECK ([Day] >=1 AND [Day] <=31),
 CONSTRAINT [CHK_DWH_DimDate_Month] CHECK ([Month] >=1 AND [Month] <=12),
 CONSTRAINT [CHK_DWH_DimDate_Year] CHECK ([Year] >=1900 AND [Year] <=2100)
);

CREATE NONCLUSTERED INDEX [FKIDX_DWH_DimDate_YearMonthDay] ON [DWH].[DimDate] ([Year] ASC, [Month] ASC, [Day] ASC)

GO

-------------------------------------------------------------------

CREATE TABLE [DWH].[FactOrder]
(
 [id]						BIGINT NOT NULL ,
 [Sum]						DECIMAL(18,2) NOT NULL ,
 [Discount]					DECIMAL(18,2) NOT NULL ,
 [DateId]					BIGINT NOT NULL,
 [SellerId]					BIGINT NOT NULL,
 [SellerBusinessUnitId]		BIGINT NOT NULL,
 [ClientId]					BIGINT NOT NULL,
 [ClientBusinessUnitId]		BIGINT NOT NULL,

 CONSTRAINT [PK_DWH_FactOrder] PRIMARY KEY CLUSTERED ([id] ASC),
 
 CONSTRAINT [FK_DWH_FactOrder_DateId] FOREIGN KEY (DateId)  REFERENCES [DWH].[DimDate]([Id]),
 CONSTRAINT [FK_DWH_FactOrder_SellerId] FOREIGN KEY (SellerId)  REFERENCES [DWH].[DimPerson]([Id]),
 CONSTRAINT [FK_DWH_FactOrder_ClientId] FOREIGN KEY (ClientId)  REFERENCES [DWH].[DimPerson]([Id]),
 CONSTRAINT [FK_DWH_FactOrder_SellerBusinessUnitId] FOREIGN KEY ([SellerBusinessUnitId])  REFERENCES [DWH].[DimBusinessUnit]([Id]),
 CONSTRAINT [FK_DWH_FactOrder_ClientBusinessUnitId] FOREIGN KEY ([ClientBusinessUnitId])  REFERENCES [DWH].[DimBusinessUnit]([Id]),
)

GO

------------------------- SEQUENCES ---------------------

CREATE SEQUENCE OrderNumberSequence
	START WITH 1
    INCREMENT BY 1 ;

GO

------------------------- TVP ---------------------------

CREATE TYPE [TVP].[ProductList] AS TABLE
(
	[Id] INT NOT NULL PRIMARY KEY
	, [Quantity] DECIMAL(18,3)
);

GO