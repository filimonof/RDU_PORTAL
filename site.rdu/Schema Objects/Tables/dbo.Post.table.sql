CREATE TABLE [dbo].[Post]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] NVARCHAR(255) NOT NULL DEFAULT (''),
	[ShortName] NVARCHAR(100) NOT NULL DEFAULT (''),
	[Order]	INT NOT NULL DEFAULT (0),
);
/*
	Должность
	
	[Name] - название 
	[ShortName] - короткое название
	[Order] - порядок вывода (INDEX - IX_Order)
*/

