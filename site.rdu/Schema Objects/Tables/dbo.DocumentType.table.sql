CREATE TABLE [dbo].[DocumentType]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Image] IMAGE NULL,
	[ImageContentType]  NVARCHAR(100) NULL,
	[Extension] NVARCHAR(255) NOT NULL,
	[Comment] NVARCHAR(100) NULL,
	[ContentTypeDocument]  NVARCHAR(100) NULL
);

/*
	Типы документов		
    
    [Image]     - картинка
    [ImageContentType] - тип картинки
	[Extension] - расширения	
	[Comment]   - комментарий к типу документа
	[ContentTypeDocument] - тип документа для браузера
*/
