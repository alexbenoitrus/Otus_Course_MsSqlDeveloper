CREATE FULLTEXT INDEX ON [Catalog].[ProductSpecialPrice]
    ([Name] LANGUAGE 1049)
    KEY INDEX [PK_ProductSpecialPrice]
    ON [DefaultCatalog];


GO
CREATE FULLTEXT INDEX ON [Communication].[ChannelIdentificatorForBusinessUnit]
    ([Identificator] LANGUAGE 1049)
    KEY INDEX [PK_ChannelIdentificatorForBusinessUnit]
    ON [DefaultCatalog];


GO
CREATE FULLTEXT INDEX ON [Communication].[ChannelIdentificatorForPerson]
    ([Identificator] LANGUAGE 1049)
    KEY INDEX [PK_ChannelIdentificatorForPerson]
    ON [DefaultCatalog];


GO
CREATE FULLTEXT INDEX ON [Org].[AddressLevel]
    ([Name] LANGUAGE 1049, [ExternalId] LANGUAGE 1049)
    KEY INDEX [PK_AddressLevel]
    ON [DefaultCatalog];


GO
CREATE FULLTEXT INDEX ON [Extension].[Attachment]
    ([Name] LANGUAGE 1049)
    KEY INDEX [PK_Attachment]
    ON [DefaultCatalog];


GO
CREATE FULLTEXT INDEX ON [Org].[BusinessUnit]
    ([Name] LANGUAGE 1049, [ExternalId] LANGUAGE 1049)
    KEY INDEX [PK_BusinessUnit]
    ON [DefaultCatalog];


GO
CREATE FULLTEXT INDEX ON [Extension].[File]
    ([Name] LANGUAGE 1049)
    KEY INDEX [PK_File]
    ON [DefaultCatalog];


GO
CREATE FULLTEXT INDEX ON [Extension].[Hashtag]
    ([Name] LANGUAGE 1049)
    KEY INDEX [PK_Hashtag]
    ON [DefaultCatalog];


GO
CREATE FULLTEXT INDEX ON [Extension].[Note]
    ([Name] LANGUAGE 1049)
    KEY INDEX [PK_Note]
    ON [DefaultCatalog];


GO
CREATE FULLTEXT INDEX ON [Org].[Person]
    ([FirstName] LANGUAGE 1049, [LastName] LANGUAGE 1049, [MiddleName] LANGUAGE 1049, [ExternalId] LANGUAGE 1049)
    KEY INDEX [PK_Person]
    ON [DefaultCatalog];


GO
CREATE FULLTEXT INDEX ON [Event].[Event]
    ([Name] LANGUAGE 1049)
    KEY INDEX [PK_Event]
    ON [DefaultCatalog];


GO
CREATE FULLTEXT INDEX ON [Catalog].[ProductCatalogLevel]
    ([Name] LANGUAGE 1049, [ExternalId] LANGUAGE 1049)
    KEY INDEX [PK_ProductCatalogLevel]
    ON [DefaultCatalog];


GO
CREATE FULLTEXT INDEX ON [Catalog].[Product]
    ([Name] LANGUAGE 1049, [ExternalId] LANGUAGE 1049)
    KEY INDEX [PK_Product]
    ON [DefaultCatalog];


GO
CREATE FULLTEXT INDEX ON [UI].[User]
    ([Login] LANGUAGE 1049)
    KEY INDEX [PK_User]
    ON [DefaultCatalog];

