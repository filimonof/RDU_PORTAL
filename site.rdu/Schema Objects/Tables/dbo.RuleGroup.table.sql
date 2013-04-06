CREATE TABLE [dbo].[RuleGroup]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,	
	[Name] NVARCHAR(100) NOT NULL UNIQUE
);


/*
	Группы прав
		
	[ID] - номер
	[Name] - название
*/
