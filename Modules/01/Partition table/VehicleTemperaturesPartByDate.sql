use WideWorldImporters;

-- EDIT DB AND SCHEMA

ALTER DATABASE [WideWorldImporters] 
	ADD FILEGROUP [VehicleTemperaturesDateData]
GO

DECLARE @FolderPath NVARCHAR(100) = N'C:\Temp\Otus\MsSql\'; 
EXEC master.dbo.xp_create_subdir @FolderPath

ALTER DATABASE [WideWorldImporters] 
ADD FILE 
	( 
		NAME = N'VehicleTemperaturesDate', 
		FILENAME = N'C:\Temp\Otus\MsSql\VehicleTemperaturesDate', 
		SIZE = 1097152KB , 
		FILEGROWTH = 65536KB 
	) 
TO FILEGROUP [VehicleTemperaturesDateData]
GO

CREATE PARTITION FUNCTION [fn_VehicleTemperaturesDatePartition](DATETIME2(7)) 
AS RANGE RIGHT FOR VALUES
	(
		  '20160526'
		, '20160527'
		, '20160528'
		, '20160529'
	)																																																		
GO

CREATE PARTITION SCHEME [schmVehicleTemperaturesDatePartition] 
	AS PARTITION [fn_VehicleTemperaturesDatePartition] 
	ALL TO ([VehicleTemperaturesDateData])
GO

-- CREATE PARTITION TABLE

CREATE TABLE [Warehouse].[VehicleTemperaturesPartByDate]
(
	  [VehicleTemperatureID] BIGINT IDENTITY(1,1) NOT NULL
	, [VehicleRegistration]  NVARCHAR(20)         COLLATE Latin1_General_CI_AS NOT NULL
	, [ChillerSensorNumber]  INT                  NOT NULL
	, [RecordedWhen]         DATETIME2(7)         NOT NULL
	, [Temperature]          DECIMAL(10, 2)       NOT NULL
	, [FullSensorData]       NVARCHAR(1000)       COLLATE Latin1_General_CI_AS NULL
	, [IsCompressed]         BIT                  NOT NULL
	, [CompressedSensorData] VARBINARY(MAX)       NULL
) 
	ON [schmVehicleTemperaturesDatePartition] ([RecordedWhen])
GO


ALTER TABLE [Warehouse].[VehicleTemperaturesPartByDate]
	ADD CONSTRAINT [PK_Warehouse_VehicleTemperaturesPartByDate]
		PRIMARY KEY CLUSTERED ([RecordedWhen], [VehicleTemperatureID]) 
		ON [schmVehicleTemperaturesDatePartition] ([RecordedWhen]);
GO

-- FILL

INSERT INTO 
	[Warehouse].[VehicleTemperaturesPartByDate]
	([VehicleRegistration],[ChillerSensorNumber],[RecordedWhen],[Temperature],[FullSensorData],[IsCompressed],[CompressedSensorData])
SELECT
	[VehicleRegistration],[ChillerSensorNumber],[RecordedWhen],[Temperature],[FullSensorData],[IsCompressed],[CompressedSensorData]
FROM
	[Warehouse].[VehicleTemperatures]

-- CHECK PARTITIONS 

SELECT
	$PARTITION.[fn_VehicleTemperaturesDatePartition]([RecordedWhen]) AS [Partition]
	, COUNT(*) AS [Count]
	, MIN([RecordedWhen]) AS [Minimal value]
	, MAX([RecordedWhen]) AS [Maximum value]
FROM
	[Warehouse].[VehicleTemperaturesPartByDate]
GROUP BY
	$PARTITION.[fn_VehicleTemperaturesDatePartition]([RecordedWhen])
ORDER BY
	[Partition]

-- DROP

--DROP TABLE [Warehouse].[VehicleTemperaturesPartByDate]
--DROP PARTITION SCHEME [schmVehicleTemperaturesDatePartition] 
--DROP PARTITION FUNCTION [fn_VehicleTemperaturesDatePartition]
--GO

--ALTER DATABASE [WideWorldImporters]  REMOVE FILE [VehicleTemperaturesDate];
--GO

--ALTER DATABASE [WideWorldImporters] REMOVE FILEGROUP [VehicleTemperaturesDateData];
--GO