CREATE TABLE [dbo].[RuleGroup_To_User]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[RuleGroupID] INT NOT NULL,
	[UserID] INT NOT NULL,
	
	CONSTRAINT [FK_RuleGroup_To_User_RuleGroup] 
		FOREIGN KEY ([RuleGroupID]) REFERENCES [dbo].[RuleGroup] ([ID])
			ON DELETE CASCADE,
			
	CONSTRAINT [FK_RuleGroup_To_User_Rule] 
		FOREIGN KEY ([UserID]) REFERENCES [dbo].[User] ([ID])
			ON DELETE CASCADE

);

/*
	Связь много ко многим между ГруппамиПрав и Пользователями
	
	Уникальный индекс RuleGroupID, UserID
*/
