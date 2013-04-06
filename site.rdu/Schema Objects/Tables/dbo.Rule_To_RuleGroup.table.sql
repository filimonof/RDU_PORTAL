CREATE TABLE [dbo].[Rule_To_RuleGroup]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[RuleGroupID] INT NOT NULL,
	[RuleID] INT NOT NULL,	
	
	CONSTRAINT [FK_Rule_To_RuleGroup_RuleGroup] 
		FOREIGN KEY ([RuleGroupID]) REFERENCES [dbo].[RuleGroup] ([ID]) 					
			ON DELETE CASCADE,
			
	CONSTRAINT [FK_Rule_To_RuleGroup_Rule] 
		FOREIGN KEY ([RuleID]) REFERENCES [dbo].[Rule] ([ID]) 					
			ON DELETE CASCADE
			ON UPDATE CASCADE,	
);

/*
	Связь много ко многим между ГруппамиПрав и самими Правами 
	
	Уникальный индекс RuleGroupID, RuleID
*/
