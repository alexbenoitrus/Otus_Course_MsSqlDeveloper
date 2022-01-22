CREATE TABLE [Communication].[ChannelIdentificatorForBusinessUnit] (
    [Id]                   BIGINT         IDENTITY (1, 1) NOT NULL,
    [BusinessUnitId]       BIGINT         NOT NULL,
    [ChannelId]            BIGINT         NOT NULL,
    [Identificator]        NVARCHAR (200) NOT NULL,
    [IsAppruved]           BIT            NOT NULL,
    [IsVoiceAllowed]       BIT            NOT NULL,
    [IsTextAllowed]        BIT            NOT NULL,
    [IsPriorityForChannel] BIT            NULL,
    [IsMain]               BIT            NULL,
    CONSTRAINT [PK_Communication_ChannelIdentificatorForBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Communication_ChannelIdentificatorForBusinessUnit_BusinessUnit] FOREIGN KEY ([BusinessUnitId]) REFERENCES [Org].[BusinessUnit] ([Id]),
    CONSTRAINT [FK_Communication_ChannelIdentificatorForBusinessUnit_Channel] FOREIGN KEY ([ChannelId]) REFERENCES [Communication].[Channel] ([Id]),
    CONSTRAINT [UQ_Communication_ChannelIdentificatorForBusinessUnit_BusinessUnitId_ChannelId_Identificator] UNIQUE NONCLUSTERED ([BusinessUnitId] ASC, [ChannelId] ASC, [Identificator] ASC)
);






GO



GO
CREATE NONCLUSTERED INDEX [IX_Communication_ChannelIdentificatorForBusinessUnit_Identificator]
    ON [Communication].[ChannelIdentificatorForBusinessUnit]([Identificator] ASC);


GO
CREATE NONCLUSTERED INDEX [FKIDX_Communication_ChannelIdentificatorForBusinessUnit_BusinessUnitId]
    ON [Communication].[ChannelIdentificatorForBusinessUnit]([BusinessUnitId] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Communication_ChannelIdentificatorForBusinessUnit_BusinessUnitId_IsMain]
    ON [Communication].[ChannelIdentificatorForBusinessUnit]([BusinessUnitId] ASC, [IsMain] ASC) WHERE ([IsMain] IS NOT NULL);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Communication_ChannelIdentificatorForBusinessUnit_BusinessUnitId_ChannelId_IsPriorityForChannel]
    ON [Communication].[ChannelIdentificatorForBusinessUnit]([BusinessUnitId] ASC, [ChannelId] ASC, [IsPriorityForChannel] ASC) WHERE ([IsPriorityForChannel] IS NOT NULL);

