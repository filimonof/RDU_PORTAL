CREATE FUNCTION [dbo].[FirstNumberToString] 
(
	@@String	NVARCHAR(MAX)
) 
RETURNS DECIMAL(38,0) WITH RETURNS NULL ON NULL INPUT AS 
BEGIN 
	/*
	Получаем вхождение первого числа в строке
	*/
	RETURN 
	(
		SELECT	SUBSTRING(@@String, [From], CASE WHEN [To] - [From] < 38 THEN [To] - [From] + 1 ELSE 38 END)
		FROM ( SELECT PATINDEX('%[0-9]%', @@String) AS [From],
			   	      NULLIF(PATINDEX('%[0-9][^0-9]%', @@String), 0) AS [To]) [$]
	) 
END


--CREATE FUNCTION [dbo].[FirstNumberToString]
--(
	--@Str NVARCHAR(MAX)	
--)
--RETURNS DECIMAL(38,0) WITH RETURNS NULL ON NULL INPUT AS 
--BEGIN 
	--RETURN 	
		--SELECT	SUBSTRING(@Str, [From], CASE WHEN [To] - [From] < 38 THEN [To] - [From] + 1 ELSE 38 END)
		--FROM  ( 
				--SELECT PATINDEX('%[0-9]%', @Str) AS [From], 
					   --NULLIF(PATINDEX('%[0-9][^0-9]%', @Str), 0) AS [To]
			  --) 
	 
--END
