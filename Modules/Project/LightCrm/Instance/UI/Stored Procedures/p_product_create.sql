
CREATE PROCEDURE [UI].[p_product_create]
(	
	@Name nvarchar(100) 
	, @Price decimal(18, 2) 
	, @CatalogLevelId bigint  = NULL
	, @Icon nvarchar(max)  = NULL
	, @ExternalId nvarchar(50) = NULL
	, @MeasurementTypeId bigint = 2
	, @BusinessDirectionTypeId bigint = 2
	, @IsActive bit = 1
	, @Description nvarchar(300) = null
	, @Id bigint output
)
AS
BEGIN
	INSERT INTO [Catalog].[Product]
           (
			[Price]
			,[CatalogLevelId]
			,[MeasurementTypeId]
			,[Name]
			,[Description]
			,[IsActive]
			,[Icon]
			,[ExternalId]
			,[BusinessDirectionTypeId]
		   )
     VALUES
           (
			@Price
			,@CatalogLevelId
			,@MeasurementTypeId
			,@Name
			,@Description
			,@IsActive
			,@Icon
			,@ExternalId
			,@BusinessDirectionTypeId
		   )

	SET @Id = @@IDENTITY;
END