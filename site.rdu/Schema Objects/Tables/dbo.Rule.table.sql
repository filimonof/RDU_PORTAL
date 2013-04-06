CREATE TABLE [dbo].[Rule]
(
	[ID] INT NOT NULL PRIMARY KEY,
	[Name] NVARCHAR(100) NOT NULL UNIQUE	
);

/*
	Права (Доступ) 
	!!! Таблица должна дублироваться в коде, номера должны совпадать

	[ID] - номер
	[Name] - название
		
*/
