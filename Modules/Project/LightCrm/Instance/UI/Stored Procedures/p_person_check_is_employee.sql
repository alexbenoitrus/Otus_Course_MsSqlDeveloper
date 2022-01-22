
CREATE PROCEDURE [UI].[p_person_check_is_employee]
(	
	@PersonId BIGINT
)
AS
BEGIN
	Declare 
		@BusinessDirectionTypeId BIGINT
		, @IsNotEmployeeError INT = 100001;

	SELECT 
		@BusinessDirectionTypeId = t.BusinessDirectionTypeId
	FROM 
		[Org].[Person] p WITH (NOLOCK)
		JOIN [Org].[PersonType] t WITH (NOLOCK) ON t.[Id] = p.[TypeId]
	WHERE
		p.[Id] = @PersonId

	IF @BusinessDirectionTypeId <> 1
	BEGIN
		raiserror(@IsNotEmployeeError, 16, 1)
	END
END