CREATE TABLE [Communication].[ChannelIdentificatorForPerson] (
    [Id]                   BIGINT         IDENTITY (1, 1) NOT NULL,
    [ChannelId]            BIGINT         NOT NULL,
    [PersonId]             BIGINT         NOT NULL,
    [Identificator]        NVARCHAR (200) NOT NULL,
    [IsAppruved]           BIT            NOT NULL,
    [IsVoiceAllowed]       BIT            NOT NULL,
    [IsTextAllowed]        BIT            NOT NULL,
    [IsPriorityForChannel] BIT            NULL,
    [IsMain]               BIT            NULL,
    CONSTRAINT [PK_Communication_ChannelIdentificatorForPerson] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Communication_ChannelIdentificatorForPerson_Channel] FOREIGN KEY ([ChannelId]) REFERENCES [Communication].[Channel] ([Id]),
    CONSTRAINT [FK_Communication_ChannelIdentificatorForPerson_Person] FOREIGN KEY ([PersonId]) REFERENCES [Org].[Person] ([Id]),
    CONSTRAINT [UQ_Communication_ChannelIdentificatorForPerson_BusinessUnitId_ChannelId_Identificator] UNIQUE NONCLUSTERED ([PersonId] ASC, [ChannelId] ASC, [Identificator] ASC),
    CONSTRAINT [UQ_Communication_ChannelIdentificatorForPerson_BusinessUnitId_ChannelId_IsPriorityForChannel] UNIQUE NONCLUSTERED ([PersonId] ASC, [ChannelId] ASC, [IsPriorityForChannel] ASC),
    CONSTRAINT [UQ_Communication_ChannelIdentificatorForPerson_BusinessUnitId_IsMain] UNIQUE NONCLUSTERED ([PersonId] ASC, [IsMain] ASC)
);




GO



GO
CREATE NONCLUSTERED INDEX [IX_Communication_ChannelIdentificatorForPerson_Identificator]
    ON [Communication].[ChannelIdentificatorForPerson]([Identificator] ASC);


GO
CREATE NONCLUSTERED INDEX [FKIDX_Communication_ChannelIdentificatorForPerson_ChannelId]
    ON [Communication].[ChannelIdentificatorForPerson]([ChannelId] ASC);

