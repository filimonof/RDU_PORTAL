CREATE TABLE [dbo].[LinkMenu]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] NVARCHAR(255) NOT NULL DEFAULT (''),
	[Link] NVARCHAR(255) NOT NULL DEFAULT ('#'),
	[InternetLink] BIT NOT NULL DEFAULT (1),
	[Order]	INT NOT NULL DEFAULT (100),
	[Enabled] BIT NOT NULL DEFAULT (1)
);
/*
	Ссылки
	[Name] Название ссылки
	[Link] адресс
	[InternetLink] 1-интернет, 0-внутренняя
	[Order]	порядок вывода
	[Enabled] 1-активна
*/