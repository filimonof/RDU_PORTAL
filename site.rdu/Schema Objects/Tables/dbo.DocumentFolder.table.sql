CREATE TABLE [dbo].[DocumentFolder]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] NVARCHAR(MAX) NOT NULL,
	[ParentFolderID] INT NULL,
	[Order]	INT NOT NULL DEFAULT (100),
			
	CONSTRAINT [FK_DocumentFolder_ParentFolderID] 
		FOREIGN KEY ([ParentFolderID]) REFERENCES [dbo].[DocumentFolder] ([ID]) 					
			ON DELETE NO ACTION
);

/*
	Папки для документов
	
	[Name]                   - Название
	[ParentFolderID]         - Родительская папка (NULL папка верхнего уровня)
	[Order]                  - Порядок сортировки
*/

