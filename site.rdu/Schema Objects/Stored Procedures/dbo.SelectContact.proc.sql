CREATE PROCEDURE [dbo].[SelectContact]
(
	@letter NVARCHAR(MAX), 
	@departamentID INT,
	@postID INT
)
AS
BEGIN
/*
	Выводим список контактной информации с параметрами фильтрации
	
	@letter - первая буква фамилии , ''- без фильтра
	@departamentID - подразделение,  0 - без фильтра , -1 - NULL
	@postID - должность,             0 - без фильтра , -1 - NULL
	@sort   - поле сортировки,       ''- поле по умолчанию, должности
*/	

	DECLARE @sql NVARCHAR(MAX)
	SET @sql = N' SELECT 
		c.[ID],
		c.[UserType],
		c.[Family] + '' '' + c.[FirstName] + '' '' + c.[LastName] AS FIO,
		c.[Family],
		c.[FirstName],
		c.[LastName],		
		c.[BirthDay],
		c.[Phone],
		c.[Email],
		c.[DepartamentID],
		d.[Name] AS DepartamentName,
		d.[ShortName] AS DepartamentShortName,
		d.[Order] AS DepartamentOrder,
		c.[PostID],
		p.[Name] AS PostName,
		p.[ShortName] AS PostShortName,
		p.[Order] AS PostOrder,		
		c.[Foto]
	FROM ([Contact] AS c 
		LEFT JOIN [Departament] AS d ON  c.DepartamentID = d.ID)
		LEFT JOIN [Post] AS p ON c.PostID = p.ID
	WHERE c.[Enabled] = 1 '
	
	IF LTRIM(RTRIM(@letter)) <> ''
		SET @sql = @sql + N' AND UPPER(c.Family) LIKE UPPER(LTRIM(RTRIM(''' + @letter + ''')))+''%'' '
		
	IF @departamentID > 0
		SET @sql = @sql + N' AND c.[DepartamentID] = ' + CAST(@departamentID AS NVARCHAR)
	ELSE IF @departamentID = -1	
		SET @sql = @sql + N' AND c.[DepartamentID] IS NULL'
		
	IF @postID <> 0
		SET @sql = @sql + N' AND c.[PostID] = ' + CAST(@postID AS NVARCHAR)	
	ELSE IF @postID = -1	
		SET @sql = @sql + N' AND c.[PostID] IS NULL'
		
	EXEC (@sql + N' ORDER BY DepartamentOrder ASC, PostOrder ASC, FIO ASC ')
		
END