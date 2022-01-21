GO
SET IDENTITY_INSERT [Org].[BusinessDirectionType] ON 
GO
INSERT [Org].[BusinessDirectionType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (1, N'Внутренний', N'Сотрудники и отделы', 1, 1)
GO
INSERT [Org].[BusinessDirectionType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (2, N'Исходящий', N'Клиенты', 1, NULL)
GO
INSERT [Org].[BusinessDirectionType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (3, N'Входящий', N'Подрядчики и поставщики', 1, NULL)
GO
INSERT [Org].[BusinessDirectionType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (4, N'Партнёрский', N'Бартер', 1, NULL)
GO
INSERT [Org].[BusinessDirectionType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (5, N'Отсустсвует', N'Для бизнес-процессов, объединяющих различные направления', 1, NULL)
GO
SET IDENTITY_INSERT [Org].[BusinessDirectionType] OFF
GO
SET IDENTITY_INSERT [Org].[BusinessUnitType] ON 
GO
INSERT [Org].[BusinessUnitType] ([Id], [Name], [Description], [IsActive], [IsDefault], [BusinessDirectionTypeId]) VALUES (1, N'Default (внутренний)', N'По-умолчанию для сотрудников', 1, 1, 1)
GO
INSERT [Org].[BusinessUnitType] ([Id], [Name], [Description], [IsActive], [IsDefault], [BusinessDirectionTypeId]) VALUES (2, N'Default (Исходящий)', N'По-умолчанию для клиентов', 1, NULL, 2)
GO
INSERT [Org].[BusinessUnitType] ([Id], [Name], [Description], [IsActive], [IsDefault], [BusinessDirectionTypeId]) VALUES (3, N'Default (Входящий)', N'По-умолчанию для клиентов', 1, NULL, 3)
GO
INSERT [Org].[BusinessUnitType] ([Id], [Name], [Description], [IsActive], [IsDefault], [BusinessDirectionTypeId]) VALUES (4, N'Default (Партнёры)', N'По-умолчанию для партнёров', 1, NULL, 4)
GO
INSERT [Org].[BusinessUnitType] ([Id], [Name], [Description], [IsActive], [IsDefault], [BusinessDirectionTypeId]) VALUES (5, N'Отдел', N'Отдел компании', 1, NULL, 1)
GO
INSERT [Org].[BusinessUnitType] ([Id], [Name], [Description], [IsActive], [IsDefault], [BusinessDirectionTypeId]) VALUES (6, N'Точка продаж', N'Физическая структурная единица по работе с клиентами', 1, NULL, 1)
GO
INSERT [Org].[BusinessUnitType] ([Id], [Name], [Description], [IsActive], [IsDefault], [BusinessDirectionTypeId]) VALUES (7, N'Тематическая группа', N'Для объединения сотрудников по внерабочим факторам', 1, NULL, 1)
GO
INSERT [Org].[BusinessUnitType] ([Id], [Name], [Description], [IsActive], [IsDefault], [BusinessDirectionTypeId]) VALUES (8, N'Кросс-команда', N'Для объединения сотрудников по временным рабочим факторам', 1, NULL, 1)
GO
SET IDENTITY_INSERT [Org].[BusinessUnitType] OFF
GO
SET IDENTITY_INSERT [Org].[PersonType] ON 
GO
INSERT [Org].[PersonType] ([Id], [Name], [Description], [IsActive], [IsDefault], [BusinessDirectionTypeId]) VALUES (1, N'Руководитель', N'Руководитель', 1, NULL, 1)
GO
INSERT [Org].[PersonType] ([Id], [Name], [Description], [IsActive], [IsDefault], [BusinessDirectionTypeId]) VALUES (2, N'Менеджер', N'Менеджер', 1, NULL, 1)
GO
INSERT [Org].[PersonType] ([Id], [Name], [Description], [IsActive], [IsDefault], [BusinessDirectionTypeId]) VALUES (3, N'Специалист', N'Специалист', 1, 1, 1)
GO
INSERT [Org].[PersonType] ([Id], [Name], [Description], [IsActive], [IsDefault], [BusinessDirectionTypeId]) VALUES (4, N'Клиент', N'Клиент', 1, NULL, 2)
GO
INSERT [Org].[PersonType] ([Id], [Name], [Description], [IsActive], [IsDefault], [BusinessDirectionTypeId]) VALUES (5, N'Менеджер поставщика', N'Менеджер поставщика', 1, NULL, 3)
GO
INSERT [Org].[PersonType] ([Id], [Name], [Description], [IsActive], [IsDefault], [BusinessDirectionTypeId]) VALUES (6, N'Потенциальный клиент', N'Потенциальный клиент', 1, NULL, 2)
GO
SET IDENTITY_INSERT [Org].[PersonType] OFF
GO
SET IDENTITY_INSERT [Catalog].[ProductMeasurementType] ON 
GO
INSERT [Catalog].[ProductMeasurementType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (1, N'Кг', N'Весовой (килограм)', 1, NULL)
GO
INSERT [Catalog].[ProductMeasurementType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (2, N'Шт', N'Поштучно', 1, 1)
GO
SET IDENTITY_INSERT [Catalog].[ProductMeasurementType] OFF
GO
SET IDENTITY_INSERT [Communication].[Channel] ON 
GO
INSERT [Communication].[Channel] ([Id], [Name], [Description], [Icon]) VALUES (1, N'SMS', N'SMS', 1)
GO
INSERT [Communication].[Channel] ([Id], [Name], [Description], [Icon]) VALUES (2, N'E-Mail', N'E-Mail', NULL)
GO
INSERT [Communication].[Channel] ([Id], [Name], [Description], [Icon]) VALUES (3, N'Viber', N'Viber', NULL)
GO
INSERT [Communication].[Channel] ([Id], [Name], [Description], [Icon]) VALUES (4, N'Voice', N'Voice', NULL)
GO
INSERT [Communication].[Channel] ([Id], [Name], [Description], [Icon]) VALUES (5, N'Push', N'Push', NULL)
GO
INSERT [Communication].[Channel] ([Id], [Name], [Description], [Icon]) VALUES (6, N'Физическая корреспонденция', N'Физическая корреспонденция', NULL)
GO
SET IDENTITY_INSERT [Communication].[Channel] OFF
GO
SET IDENTITY_INSERT [Event].[EventInviteStatusType] ON 
GO
INSERT [Event].[EventInviteStatusType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (1, N'Отправлено', N'Отправлено', 1, 1)
GO
INSERT [Event].[EventInviteStatusType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (2, N'Принято', N'Принято', 1, NULL)
GO
INSERT [Event].[EventInviteStatusType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (3, N'Отклонено', N'Отклонено', 1, NULL)
GO
SET IDENTITY_INSERT [Event].[EventInviteStatusType] OFF
GO
SET IDENTITY_INSERT [Event].[EventStatus] ON 
GO
INSERT [Event].[EventStatus] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (1, N'Назначена', N'Назначена', 1, 1)
GO
INSERT [Event].[EventStatus] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (2, N'Отменена', N'Отменена', 1, NULL)
GO
INSERT [Event].[EventStatus] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (3, N'В процессе', N'В процессе', 1, NULL)
GO
INSERT [Event].[EventStatus] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (4, N'Завершена', N'Завершена', 1, NULL)
GO
SET IDENTITY_INSERT [Event].[EventStatus] OFF
GO
SET IDENTITY_INSERT [Event].[EventType] ON 
GO
INSERT [Event].[EventType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (1, N'Встреча', N'Встреча', 1, NULL)
GO
INSERT [Event].[EventType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (2, N'Звонок', N'Звонок', 1, 1)
GO
INSERT [Event].[EventType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (3, N'Закупка', N'Закупка', 1, NULL)
GO
INSERT [Event].[EventType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (4, N'Продажа', N'Продажа', 1, NULL)
GO
SET IDENTITY_INSERT [Event].[EventType] OFF
GO
SET IDENTITY_INSERT [Org].[AddressLevelType] ON 
GO
INSERT [Org].[AddressLevelType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (1, N'Страна', N'Страна', 1, 1)
GO
INSERT [Org].[AddressLevelType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (2, N'Область', N'Область', 1, NULL)
GO
INSERT [Org].[AddressLevelType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (3, N'Район', N'Район', 1, NULL)
GO
INSERT [Org].[AddressLevelType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (4, N'Городской округ', N'Городской округ', 1, NULL)
GO
INSERT [Org].[AddressLevelType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (5, N'Город', N'Город', 1, NULL)
GO
INSERT [Org].[AddressLevelType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (6, N'Посёлок', N'Посёлок', 1, NULL)
GO
INSERT [Org].[AddressLevelType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (7, N'Деревня', N'Деревня', 1, NULL)
GO
SET IDENTITY_INSERT [Org].[AddressLevelType] OFF
GO
SET IDENTITY_INSERT [Org].[GenderType] ON 
GO
INSERT [Org].[GenderType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (1, N'М', N'Мужской', 1, 1)
GO
INSERT [Org].[GenderType] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (2, N'Ж', N'Женский', 1, NULL)
GO
SET IDENTITY_INSERT [Org].[GenderType] OFF
GO
SET IDENTITY_INSERT [Org].[PersonStatus] ON 
GO
INSERT [Org].[PersonStatus] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (1, N'Активен', N'Активен', 1, NULL)
GO
INSERT [Org].[PersonStatus] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (2, N'Заблокирован', N'Заблокирован', 1, NULL)
GO
INSERT [Org].[PersonStatus] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (3, N'Уволен', N'Уволен', 1, NULL)
GO
INSERT [Org].[PersonStatus] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (4, N'Не актуален', N'Не актуален', 1, NULL)
GO
INSERT [Org].[PersonStatus] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (5, N'В отпуске', N'В отпуске', 1, NULL)
GO
INSERT [Org].[PersonStatus] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (6, N'В декрете', N'В декрете', 1, NULL)
GO
SET IDENTITY_INSERT [Org].[PersonStatus] OFF
GO
SET IDENTITY_INSERT [UI].[UserRole] ON 
GO
INSERT [UI].[UserRole] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (1, N'Пользователь', N'Пользователь', 1, NULL)
GO
INSERT [UI].[UserRole] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (2, N'Менеджер', N'Менеджер', 1, NULL)
GO
INSERT [UI].[UserRole] ([Id], [Name], [Description], [IsActive], [IsDefault]) VALUES (3, N'Администратор', N'Администратор', 1, NULL)
GO
SET IDENTITY_INSERT [UI].[UserRole] OFF
GO
