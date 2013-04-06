CREATE TABLE [dbo].[LinksMenuItem]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] NVARCHAR(255) NOT NULL DEFAULT (''),
	[Link] NVARCHAR(255) NOT NULL DEFAULT ('#'),
	[CaptionID] INT NOT NULL,
	[Order]	INT NOT NULL DEFAULT (100),
	[Enabled] BIT NOT NULL DEFAULT (1),
	
	CONSTRAINT [FK_LinkMenuItem_CaptionID] 
		FOREIGN KEY ([CaptionID]) REFERENCES [dbo].[LinksMenuCaption] ([ID]) 					
			ON DELETE CASCADE
);
/*
	Ссылки
	[Name] Название ссылки
	[Link] адресс
	[CaptionID] к какой группе принадлежит
	[Order]	порядок вывода
	[Enabled] 1-активна
*/