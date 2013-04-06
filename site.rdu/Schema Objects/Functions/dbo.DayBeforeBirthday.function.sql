CREATE FUNCTION [dbo].[DayBeforeBirthday]
(
	@day SMALLDATETIME,
	@BirthDay SMALLDATETIME
)
RETURNS INT AS
BEGIN
	/*
	Сколько дней до дня рождения
	*/
	RETURN DATEDIFF(day, @day
		, DATEADD(year, dbo.DiffAges(@BirthDay, @day) 
			+ CASE WHEN MONTH(@BirthDay) = MONTH(@day) AND DAY(@BirthDay) = DAY(@day) 
				THEN 0 
				ELSE 1 
			END
		, @BirthDay))
END