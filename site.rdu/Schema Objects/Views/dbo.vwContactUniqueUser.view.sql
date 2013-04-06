CREATE VIEW [dbo].[vwContactUniqueUser] WITH SCHEMABINDING
AS 
	SELECT [UserID] FROM [dbo].[Contact] WHERE [UserID] IS NOT NULL;
/*
совместно с индексом [vwContactUniqueUser].[IX_UserID] делают поле UserID уникальным, 
но разрешает значение NULL
*/	
