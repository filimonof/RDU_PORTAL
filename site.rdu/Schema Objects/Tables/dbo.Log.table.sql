CREATE TABLE [dbo].[Log]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,		
	[Date] DATETIME NOT NULL,	
	[Type] NVARCHAR(10) NOT NULL,	
	[User] NVARCHAR(100) NULL,
	[IP] NVARCHAR(100) NULL,	
	[Message] NVARCHAR(MAX) NOT NULL
);

/*
	Логи
	
	[Date]    - дата
	[Type]    - тип записи
	[User]    - пользователь
	[IP]      - IP адресс
	[Message] - сообщение
*/
