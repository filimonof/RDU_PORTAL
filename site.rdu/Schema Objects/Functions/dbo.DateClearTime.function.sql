CREATE FUNCTION [dbo].[DateClearTime]
(
	@date datetime
)
RETURNS DATETIME
AS
BEGIN
	/*
	Обнуляем значения времени и даты в дате
	*/
	RETURN Cast(Cast(@date As NVarChar(11)) As DateTime)	
END