CREATE FUNCTION [dbo].[ToDate]
(
	@Year INT,	-- год
	@Month INT, -- месяц
	@Day INT    -- день
)
RETURNS SmallDateTime AS
BEGIN
/*
	Преобразуем Год Месяц День в Дату
*/	
	RETURN DateAdd(day, @Day-1, DateAdd(month, @Month-1, DateAdd(year, @Year-2000, '20000101')))
--	RETURN CAST(CAST(@Year AS NVARCHAR) + '-' + CAST(@Month AS NVARCHAR) + '-' + CAST(@Day AS NVARCHAR) AS DATETIME)	
END
