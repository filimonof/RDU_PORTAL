CREATE TABLE [dbo].[DocumentFolder_To_RuleGroup]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[DocumentFolderID] INT NOT NULL,
	[RuleGroupID] INT NOT NULL,	
	[IsWriter] BIT NOT NULL DEFAULT (0),
	
	CONSTRAINT [FK_DocumentFolder_To_RuleGroup__DocumentFolder] 
		FOREIGN KEY ([DocumentFolderID]) REFERENCES [dbo].[DocumentFolder] ([ID]) 					
			ON DELETE CASCADE,				
	
	CONSTRAINT [FK_DocumentFolder_To_RuleGroup__RuleGroup] 
		FOREIGN KEY ([RuleGroupID]) REFERENCES [dbo].[RuleGroup] ([ID]) 					
			ON DELETE CASCADE			
);

/*
	Связь много ко многим между ГруппамиПрав и Папками документов 
	
	Уникальный индекс [DocumentFolderID] [RuleGroupID]
	
	[IsWriter] - разрешается ли запись в папку документов этой группой
*/
