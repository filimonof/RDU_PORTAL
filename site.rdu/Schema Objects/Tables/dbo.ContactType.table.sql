CREATE TABLE [dbo].[ContactType]
(
	[ID] INT NOT NULL PRIMARY KEY,
	[Name] NVARCHAR(100) NOT NULL
);
/*
	Типы контактой информации
		таблица должна синхронизироваться с классом  App_Code\Contact.cs
	
	[Name]    - Название	
*/

