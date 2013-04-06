CREATE TABLE [dbo].[NewsType]
(
	[ID] INT NOT NULL PRIMARY KEY,
	[Name] NVARCHAR(100) NOT NULL		
);
/*
	Типы новостных лент 
		таблица должна синхронизироваться с классом  App_Code\TypeNews.cs
	
	[Name]    - Название	
*/

