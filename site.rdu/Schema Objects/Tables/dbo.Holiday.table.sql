CREATE TABLE [dbo].[Holiday]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] NVARCHAR(100) NOT NULL DEFAULT (''),
	[Image] IMAGE NULL,
	[Day] INT NOT NULL,
	[Month]	INT NOT NULL,
	CONSTRAINT [CK_Check_HolidayDays] CHECK ( [dbo].[DayInMonth]([Month]) >= [Day] ),
	CONSTRAINT [CK_Check_HolidayMonth] CHECK ( 1 <= [Month] AND [Month] <= 12 )
);


/*
	Праздники
	
	[Name]  - название праздника	
	[Image] - картинка
	[Day]   - день
	[Month]	- месяц
*/