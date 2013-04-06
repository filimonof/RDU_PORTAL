CREATE TABLE [dbo].[NewsTitle]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] NVARCHAR(255) NOT NULL,		
	[Link] NVARCHAR(255) NOT NULL,
	[Image] IMAGE NULL,
	[TypeID] INT NOT NULL,
	[Order]	INT NOT NULL DEFAULT (0),	
	[Enabled] BIT NOT NULL DEFAULT (1),
	
	CONSTRAINT [FK_NewsTitle_TypeID] 
		FOREIGN KEY (TypeID) REFERENCES [dbo].[NewsType] ([ID]) 					
			ON DELETE NO ACTION
);
	

/*
	Новостные заголовки
	
	[Name]    - Название
	[Link]    - ссылка
	[TypeID]    - тип применяемого парсинга
	[Order]	  - порядок вывода
	[Enabled] - 1-активна
*/
