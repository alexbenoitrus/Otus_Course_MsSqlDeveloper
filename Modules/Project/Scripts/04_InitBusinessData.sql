Declare @ID BIGINT

----- EMPLOYEE
EXEC [UI].[p_person_create]	@FirstName = N'����', @Id = @ID output

----- CLIENTS
EXEC [UI].[p_person_create]	@FirstName = N'����', @BusinessUnitId = 2, @TypeId = 4, @Id = @ID output
EXEC [UI].[p_person_create]	@FirstName = N'������', @BusinessUnitId = 2, @TypeId = 4, @Id = @ID output
EXEC [UI].[p_person_create]	@FirstName = N'ϸ��', @BusinessUnitId = 2, @TypeId = 4, @Id = @ID output
EXEC [UI].[p_person_create]	@FirstName = N'�����', @GenderTypeId = 2, @BusinessUnitId = 2, @TypeId = 4, @Id = @ID output
EXEC [UI].[p_person_create]	@FirstName = N'�����', @GenderTypeId = 2, @BusinessUnitId = 2, @TypeId = 4, @Id = @ID output

----- PRODUCTS
EXEC [UI].[p_product_create] @Name = N'������� "��� ������"', @Price = 220.00, @Id = @ID output
EXEC [UI].[p_product_create] @Name = N'������� "��� ������"', @Price = 100.95, @Id = @ID output
EXEC [UI].[p_product_create] @Name = N'������� ���� "�������"', @Price = 500.00, @Id = @ID output
EXEC [UI].[p_product_create] @Name = N'�������� ����� "��������"', @Price = 2500.00, @Id = @ID output
