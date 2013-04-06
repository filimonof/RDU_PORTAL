CREATE TABLE [dbo].[UserMessage]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[UserID] INT NOT NULL,
	[Text] NVARCHAR(MAX) NOT NULL DEFAULT('Пустое сообщение.'),
	[CreateDate] DATETIME NOT NULL DEFAULT(GETDATE()),		
	[DeleteDate] SMALLDATETIME NULL,
	[Enabled] BIT NOT NULL DEFAULT(1),
	[Important] BIT NOT NULL DEFAULT(0),	
				
	CONSTRAINT [FK_UserMessage_UserID] 
		FOREIGN KEY ([UserID]) REFERENCES [dbo].[User] ([ID]) 					
			ON DELETE NO ACTION	
);

/*
	Сообщения пользователей	
		
	[UserID]        - кто разместил сообщение
	[Text]          - текст сообщения
	[CreateDate]    - дата создания сообщения	
	[DeleteDate]    - сообщение живет до этой даты, если NULL то пока сами не отменим (Enabled) сообщение
	[Enabled]       - 1-сообщение активно
	[Important]     - 1-важное сообщение
*/	