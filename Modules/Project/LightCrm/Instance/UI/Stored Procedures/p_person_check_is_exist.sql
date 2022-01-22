
CREATE PROCEDURE [UI].[p_person_check_is_exist]
(	
	@PersonId BIGINT
)
AS
BEGIN
	Declare 
		@PersonNotFoundError INT = 100002;

	IF NOT EXISTS (SELECT 1 FROM [Org].[Person] p WHERE p.[Id] = @PersonId)
	BEGIN
		raiserror(@PersonNotFoundError, 16, 1)
	END
END