CREATE TABLE [dbo].[ContactTitle]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] NVARCHAR(255) NOT NULL,		
	[Link] NVARCHAR(255) NULL,
	[Image] IMAGE NULL,
	[TypeID] INT NOT NULL,
	[Order]	INT NOT NULL DEFAULT (0),	
	[Enabled] BIT NOT NULL DEFAULT (1),
	[Description] NVARCHAR(MAX) NOT NULL DEFAULT(''),
	
	CONSTRAINT [FK_ContactTitle_TypeID] 
		FOREIGN KEY (TypeID) REFERENCES [dbo].[ContactType] ([ID]) 					
			ON DELETE NO ACTION
);
	

/*
	Заголовки контактных блоков
	
	[Name]    - Название
	[Link]    - ссылка на иссточник с контактной информацией, или NULL если нет внешнего иссточника
	[TypeID]  - тип контактной информации (влияет на применение парсинга и вывода данных)
	[Image]   - картинка
	[Order]	  - порядок вывода
	[Enabled] - 1-активна
	[Description] - описание организации, комментарий
*/