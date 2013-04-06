CREATE FUNCTION [dbo].[HolidayAndBirthday]
(
	@day SMALLDATETIME,     -- дата
	@predDay INT,           -- дней до даты 
	@nextDay INT,           -- дней после даты 
	@min_birthday INT	    -- брать ДР не менее чем, 0-минимальное количество не учитывать
)
RETURNS @returntable TABLE 
(
	[IsUser] BIT,           -- 1-ДР         или  0-Праздник
	[ID] INT,               -- Contact.ID   или  Holiday.ID
	[Name] NVARCHAR(100),   -- Фамилия И.О. или  Название праздника 
	[Date] SMALLDATETIME,   -- Праздничный день
	[IsRoundedDay] BIT		-- 1-юбилей
)
AS
BEGIN
/*
Получить список Праздников и ДнейРождения

берём ДР в диапазоне дат от @day-@predDay до @day+@nextDay 
если количество ДР меньше чем @min_birthday то диапазон @nextDay увеличиваем
если @min_birthday = 0 то диапазоны не увеличиваются

праздники берём диапазоном от @day-@predDay до @day+@nextDay , где @nextDay после расширения диапазона

пример:
select * from dbo.HolidayAndBirthday('12/28/2011', 2, 7, 4) ORDER BY [Date]
*/	

	--если записей в таблице меньше чем то @min_birthday сокращаем количество 
	IF @min_birthday > (SELECT COUNT(*) FROM [Contact] WHERE [Enabled] = 1 AND [BirthDay] IS NOT NULL)
		SET @min_birthday = (SELECT COUNT(*) FROM [Contact] WHERE [Enabled] = 1 AND [BirthDay] IS NOT NULL)

	--если днюх меньше чем @min_birthday , то увеличиваем диапазон дат 
	IF @min_birthday > 0 AND @min_birthday > (
		SELECT COUNT(*) FROM [Contact] 
		WHERE [Enabled] = 1
			AND [BirthDay] IS NOT NULL 
			AND [BirthDay] <= @day 
			AND (
				dbo.DayBeforeBirthday(@day, [BirthDay]) <= @nextDay         -- до днюхи
				OR dbo.DayAfterBirthday(@day, [BirthDay]) <= @predDay       -- после днюхи
				)
	)			
	BEGIN
		-- берём первые @min_birthday днюх и определяем максимальное количество дней 
		-- получаем новое значение @nextDay 
		SELECT @nextDay = MAX(DO) from (
			SELECT TOP (@min_birthday) dbo.DayBeforeBirthday(@day, [BirthDay]) AS DO
			FROM [Contact] 
			WHERE [Enabled] = 1
				AND [BirthDay] IS NOT NULL 
				AND [BirthDay] <= @day 
			ORDER BY DO
		) AS S_BIRD
	END	
		
	-- берём данные из контактов	
	INSERT @returntable
		SELECT  
			1, -- дни рождения
			[ID],
			LTRIM(RTRIM(Family)) + ' ' +  SUBSTRING(LTRIM(RTRIM(FirstName)),1,1) + '.' + SUBSTRING(LTRIM(RTRIM(LastName)),1,1) + '.',
			DATEADD(year
				,dbo.DiffAges([BirthDay], @day) 
					+ CASE WHEN MONTH([BirthDay]) = MONTH(@day) AND DAY([BirthDay]) = DAY(@day) THEN 0 ELSE 1 END
					- CASE WHEN dbo.DayAfterBirthday(@day, [BirthDay]) <= @predDay AND dbo.DayAfterBirthday(@day, [BirthDay]) > 0 THEN 1 ELSE 0 END
				,[BirthDay]),
			CASE WHEN (dbo.DiffAges(BirthDay, @day) 
				+ CASE WHEN MONTH([BirthDay]) = MONTH(@day) AND DAY([BirthDay]) = DAY(@day) THEN 0 ELSE 1 END
				- CASE WHEN dbo.DayAfterBirthday(@day, [BirthDay]) <= @predDay AND dbo.DayAfterBirthday(@day, [BirthDay]) > 0 THEN 1 ELSE 0 END
			) % 5 = 0 THEN 1 ELSE 0 END -- юбилей			
		FROM [Contact] 
		WHERE [Enabled] = 1
			AND [BirthDay] IS NOT NULL 
			AND [BirthDay] <= @day 
			AND (
				dbo.DayBeforeBirthday(@day, [BirthDay]) <= @nextDay         -- до днюхи
				OR dbo.DayAfterBirthday(@day, [BirthDay]) <= @predDay       -- после днюхи
				)

	
	--берём данные из праздников
	INSERT @returntable
		SELECT  
			0, -- праздники
			[ID],
			LTRIM(RTRIM(Name)),
			CASE WHEN DATEDIFF(day, @day, dbo.ToDate(YEAR(@Day) + ( CASE WHEN @Day > dbo.ToDate(YEAR(@Day), [Month], [Day]) THEN 1 ELSE 0 END ), [Month], [Day])) <= @nextDay 
				THEN dbo.ToDate(YEAR(@Day) + CASE WHEN @Day > dbo.ToDate(YEAR(@Day), [Month], [Day]) THEN 1 ELSE 0 END, [Month], [Day])
				ELSE dbo.ToDate(YEAR(@Day) - CASE WHEN @Day > dbo.ToDate(YEAR(@Day), [Month], [Day]) THEN 0 ELSE 1 END, [Month], [Day]) 
			END,		
			0 -- у праздников нет юбилея 
		FROM [Holiday] 
		WHERE	
			DATEDIFF(day, @day, dbo.ToDate(YEAR(@Day) + ( CASE WHEN @Day > dbo.ToDate(YEAR(@Day), [Month], [Day]) THEN 1 ELSE 0 END ), [Month], [Day])) <= @nextDay   -- до праздника 
			OR DATEDIFF(day, @day, dbo.ToDate(YEAR(@Day) - ( CASE WHEN @Day > dbo.ToDate(YEAR(@Day), [Month], [Day]) THEN 0 ELSE 1 END ), [Month], [Day])) >= 0       -- после праздника 
	
	RETURN
END