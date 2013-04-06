CREATE TABLE [dbo].[User]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,	
	[DomainName] NVARCHAR(100) NOT NULL UNIQUE, 
	[Enabled] BIT NOT NULL DEFAULT (1)
);

/*
	Пользователи
	
	[DomainName] - доменное имя, для HttpContext.Current.User.Identity.Name (пример ODUSV\FilimonovVV)
	[Enabled] - 0-отключен
*/