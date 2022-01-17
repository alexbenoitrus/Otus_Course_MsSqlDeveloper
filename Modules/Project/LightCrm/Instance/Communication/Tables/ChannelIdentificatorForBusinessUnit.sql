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
    CONSTRAINT [PK_ChannelIdentificatorForBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ChannelIdentificatorForBusinessUnit_BusinessUnit] FOREIGN KEY ([BusinessUnitId]) REFERENCES [Org].[BusinessUnit] ([Id]),
    CONSTRAINT [FK_ChannelIdentificatorForBusinessUnit_Channel] FOREIGN KEY ([ChannelId]) REFERENCES [Communication].[Channel] ([Id]),
    CONSTRAINT [UQ_ChannelIdentificatorForBusinessUnit_BusinessUnitId_ChannelId_Identificator] UNIQUE NONCLUSTERED ([BusinessUnitId] ASC, [ChannelId] ASC, [Identificator] ASC),
    CONSTRAINT [UQ_ChannelIdentificatorForBusinessUnit_BusinessUnitId_ChannelId_IsPriorityForChannel] UNIQUE NONCLUSTERED ([BusinessUnitId] ASC, [ChannelId] ASC, [IsPriorityForChannel] ASC),
    CONSTRAINT [UQ_ChannelIdentificatorForBusinessUnit_BusinessUnitId_IsMain] UNIQUE NONCLUSTERED ([BusinessUnitId] ASC, [IsMain] ASC)
);


GO
CREATE NONCLUSTERED INDEX [fkIdx_ChannelIdentificatorForBusinessUnit_BusinessUnitId]
    ON [Communication].[ChannelIdentificatorForBusinessUnit]([BusinessUnitId] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_ChannelIdentificatorForBusinessUnit_Identificator]
    ON [Communication].[ChannelIdentificatorForBusinessUnit]([Identificator] ASC);

