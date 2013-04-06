CREATE FUNCTION [dbo].[DiffAges]
(
	@Date1 SMALLDATETIME,
	@Date2 SMALLDATETIME
)
RETURNS INT AS
BEGIN
	/*
	Сколько полных лет прошло с события Date1 до события Date2
	*/
	RETURN DATEDIFF(year, @Date1, @Date2) 
		+ CASE WHEN DATEADD(year, DATEDIFF(YEAR, @Date1, @Date2),  @Date1)  > @Date2 -- в этом году (от Date2) будет
			THEN -1 
			ELSE 0  -- в этом году (от Date2) уже было
		END	
END
