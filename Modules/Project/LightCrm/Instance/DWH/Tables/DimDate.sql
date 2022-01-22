CREATE TABLE [DWH].[DimDate] (
    [Id]    BIGINT IDENTITY (1, 1) NOT NULL,
    [Day]   INT    NOT NULL,
    [Month] INT    NOT NULL,
    [Year]  INT    NOT NULL,
    CONSTRAINT [PK_DWH_DimDate] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CHK_DWH_DimDate_Day] CHECK ([Day]>=(1) AND [Day]<=(31)),
    CONSTRAINT [CHK_DWH_DimDate_Month] CHECK ([Month]>=(1) AND [Month]<=(12)),
    CONSTRAINT [CHK_DWH_DimDate_Year] CHECK ([Year]>=(1900) AND [Year]<=(2100))
);




GO
CREATE NONCLUSTERED INDEX [FKIDX_DWH_DimDate_YearMonthDay]
    ON [DWH].[DimDate]([Year] ASC, [Month] ASC, [Day] ASC);

