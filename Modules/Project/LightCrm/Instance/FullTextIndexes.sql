CREATE FULLTEXT INDEX ON [Catalog].[ProductSpecialPrice]
    ([Name] LANGUAGE 1049)
    KEY INDEX [PK_Catalog_ProductSpecialPrice]
    ON [DefaultCatalog];




GO
CREATE FULLTEXT INDEX ON [Communication].[ChannelIdentificatorForBusinessUnit]
    ([Identificator] LANGUAGE 1049)
    KEY INDEX [PK_Communication_ChannelIdentificatorForBusinessUnit]
    ON [DefaultCatalog];




GO
CREATE FULLTEXT INDEX ON [Communication].[ChannelIdentificatorForPerson]
    ([Identificator] LANGUAGE 1049)
    KEY INDEX [PK_Communication_ChannelIdentificatorForPerson]
    ON [DefaultCatalog];




GO
CREATE FULLTEXT INDEX ON [Org].[AddressLevel]
    ([Name] LANGUAGE 1049, [ExternalId] LANGUAGE 1049)
    KEY INDEX [PK_Org_AddressLevel]
    ON [DefaultCatalog];




GO
CREATE FULLTEXT INDEX ON [Extension].[Attachment]
    ([Name] LANGUAGE 1049)
    KEY INDEX [PK_Extension_Attachment]
    ON [DefaultCatalog];




GO
CREATE FULLTEXT INDEX ON [Org].[BusinessUnit]
    ([Name] LANGUAGE 1049, [ExternalId] LANGUAGE 1049)
    KEY INDEX [PK_Org_BusinessUnit]
    ON [DefaultCatalog];




GO



GO
CREATE FULLTEXT INDEX ON [Extension].[Hashtag]
    ([Name] LANGUAGE 1049)
    KEY INDEX [PK_Extension_Hashtag]
    ON [DefaultCatalog];




GO
CREATE FULLTEXT INDEX ON [Extension].[Note]
    ([Name] LANGUAGE 1049)
    KEY INDEX [PK_Extension_Note]
    ON [DefaultCatalog];




GO
CREATE FULLTEXT INDEX ON [Org].[Person]
    ([FirstName] LANGUAGE 1049, [LastName] LANGUAGE 1049, [MiddleName] LANGUAGE 1049, [ExternalId] LANGUAGE 1049)
    KEY INDEX [PK_Org_Person]
    ON [DefaultCatalog];




GO
CREATE FULLTEXT INDEX ON [Event].[Event]
    ([Name] LANGUAGE 1049)
    KEY INDEX [PK_Event_Event]
    ON [DefaultCatalog];




GO
CREATE FULLTEXT INDEX ON [Catalog].[ProductCatalogLevel]
    ([Name] LANGUAGE 1049, [ExternalId] LANGUAGE 1049)
    KEY INDEX [PK_Catalog_ProductCatalogLevel]
    ON [DefaultCatalog];




GO
CREATE FULLTEXT INDEX ON [Catalog].[Product]
    ([Name] LANGUAGE 1049, [ExternalId] LANGUAGE 1049)
    KEY INDEX [PK_Catalog_Product]
    ON [DefaultCatalog];




GO
CREATE FULLTEXT INDEX ON [UI].[User]
    ([Login] LANGUAGE 1049)
    KEY INDEX [PK_UI_User]
    ON [DefaultCatalog];




GO
CREATE FULLTEXT INDEX ON [Extension].[FileHeader]
    ([Name] LANGUAGE 1049)
    KEY INDEX [PK_Extension_FileHeader]
    ON [DefaultCatalog];



