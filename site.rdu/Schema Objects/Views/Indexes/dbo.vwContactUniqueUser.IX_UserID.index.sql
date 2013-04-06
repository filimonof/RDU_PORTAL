CREATE UNIQUE CLUSTERED INDEX [IX_UserID]
ON [dbo].[vwContactUniqueUser]
	(UserID);
/*	
совместно с view-ом [vwContactUniqueUser] делают поле UserID уникальным, 
но разрешает значение NULL
*/	
	