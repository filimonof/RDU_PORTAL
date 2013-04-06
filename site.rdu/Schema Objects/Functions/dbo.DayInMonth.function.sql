CREATE FUNCTION [dbo].[DayInMonth]
(
	@Month  INT  -- месяц
)
RETURNS INT AS 
BEGIN
/*
Количество дней в месяце
*/
	RETURN 
		CASE @Month
			WHEN  1 THEN 31 
			WHEN  2 THEN 28  -- !!! у нас 29 февраля праздников не будет
			WHEN  3 THEN 31 
			WHEN  4 THEN 30 
			WHEN  5 THEN 31 
			WHEN  6 THEN 30 
			WHEN  7 THEN 31 
			WHEN  8 THEN 31 
			WHEN  9 THEN 30 
			WHEN 10 THEN 31 
			WHEN 11 THEN 30 
			WHEN 12 THEN 31 
			ELSE 0 
		END
END