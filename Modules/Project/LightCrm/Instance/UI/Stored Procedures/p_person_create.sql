
CREATE PROCEDURE [UI].[p_person_create]
(	
	  @FirstName			nvarchar(100)	
	, @Description			nvarchar(max)	= NULL
	, @AddressAdditional	nvarchar(100)	= NULL
	, @Icon					nvarchar(max)	= NULL
	, @BirthDay				datetime2(7)	= NULL
	, @LastName				nvarchar(100)	= NULL
	, @MiddleName			nvarchar(100)	= NULL
	, @AddressLevelId		bigint			= NULL
	, @ExternalId			nvarchar(50)	= NULL
	, @StatusId				bigint			= 1
	, @BusinessUnitId		bigint			= 1
	, @TypeId				bigint			= 1
	, @GenderTypeId			bigint			= 1
	, @Id					bigint	output
)
AS
BEGIN
	INSERT INTO [Org].[Person]
           ([StatusId]
           ,[FirstName]
           ,[LastName]
           ,[MiddleName]
           ,[GenderTypeId]
           ,[BusinessUnitId]
           ,[Description]
           ,[TypeId]
           ,[AddressLevelId]
           ,[AddressAdditional]
           ,[Icon]
           ,[ExternalId]
           ,[BirthDay]
           ,[RegisterOn])
     VALUES
           (@StatusId
           , @FirstName
           ,@LastName
           ,@MiddleName
           ,@GenderTypeId
           ,@BusinessUnitId
           ,@Description
           ,@TypeId
           ,@AddressLevelId
           ,@AddressAdditional
           ,@Icon
           ,@ExternalId
           ,@BirthDay
           ,GETDATE() - 1);

	SET @Id = @@IDENTITY;
END