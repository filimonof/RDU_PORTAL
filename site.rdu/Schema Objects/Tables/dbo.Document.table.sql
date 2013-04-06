CREATE TABLE [dbo].[Document]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Number] NVARCHAR(100) NULL,
	[Date] SMALLDATETIME NULL,
	[Name] NVARCHAR(MAX) NOT NULL,
	[FolderID] INT NOT NULL,
	[DateUpload] DATETIME NOT NULL,
	[DocumentTypeID] INT NOT NULL, 
	[Deleted] BIT NOT NULL DEFAULT(0),
	[Doc] IMAGE NULL,
					
	CONSTRAINT [FK_Document_FolderID] 
		FOREIGN KEY ([FolderID]) REFERENCES [dbo].[DocumentFolder] ([ID]) 					
			ON DELETE NO ACTION,
			
	CONSTRAINT [FK_Document_DocumentTypeID] 
		FOREIGN KEY ([DocumentTypeID]) REFERENCES [dbo].[DocumentType] ([ID]) 					
			ON DELETE NO ACTION		
);

/*
	Документы

	[Number]         - номер жокумента
	[Date]           - дата документа
	[Name]           - название документа
	[FolderID]       - в какой папке лежит
	[DateUpload]     - когда документ загружен на сервер
	[DocumentTypeID] - тип файла документа
	[Deleted]        - 1 - документ удален
	[Doc]            - сам документ
	
*/