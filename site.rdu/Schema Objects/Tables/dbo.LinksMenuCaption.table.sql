CREATE TABLE [dbo].[LinksMenuCaption]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] NVARCHAR(100) NOT NULL DEFAULT (''),		
	[Order]	INT NOT NULL DEFAULT (100),
	[Enabled] BIT NOT NULL DEFAULT (1)	
);
/*
	Ссылки
	[Name] Название группы ссылок
	[Order]	порядок вывода
	[Enabled] 1-активна 
*/