Declare @ID BIGINT

----- EMPLOYEE
EXEC [UI].[p_person_create]	@FirstName = N'Олег', @Id = @ID output

----- CLIENTS
EXEC [UI].[p_person_create]	@FirstName = N'Олег', @BusinessUnitId = 2, @TypeId = 4, @Id = @ID output
EXEC [UI].[p_person_create]	@FirstName = N'Виктор', @BusinessUnitId = 2, @TypeId = 4, @Id = @ID output
EXEC [UI].[p_person_create]	@FirstName = N'Пётр', @BusinessUnitId = 2, @TypeId = 4, @Id = @ID output
EXEC [UI].[p_person_create]	@FirstName = N'Жанна', @GenderTypeId = 2, @BusinessUnitId = 2, @TypeId = 4, @Id = @ID output
EXEC [UI].[p_person_create]	@FirstName = N'Алиса', @GenderTypeId = 2, @BusinessUnitId = 2, @TypeId = 4, @Id = @ID output

----- PRODUCTS
EXEC [UI].[p_product_create] @Name = N'Стрижка "Под горшок"', @Price = 220.00, @Id = @ID output
EXEC [UI].[p_product_create] @Name = N'Стрижка "Вин Дизель"', @Price = 100.95, @Id = @ID output
EXEC [UI].[p_product_create] @Name = N'Завивка усов "Пропуск"', @Price = 500.00, @Id = @ID output
EXEC [UI].[p_product_create] @Name = N'Покраска волос "Авангард"', @Price = 2500.00, @Id = @ID output
