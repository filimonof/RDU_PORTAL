CREATE FUNCTION [dbo].[DayAfterBirthday]
(
	@day SMALLDATETIME,
	@BirthDay SMALLDATETIME
)
RETURNS INT AS
BEGIN
	/*
	Сколько дней после дня рождения
	*/
	RETURN -DATEDIFF(day, @day, DATEADD(year, dbo.DiffAges(@BirthDay, @day), @BirthDay))
END