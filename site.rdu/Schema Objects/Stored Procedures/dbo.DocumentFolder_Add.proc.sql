CREATE PROCEDURE [dbo].[DocumentFolder_Add]
(
	@Name NVARCHAR(MAX),
	@ParentFolderID INT,
	@Order INT = 0
)
AS
BEGIN
/*
	Добавление новой папки для документов	
	с последующим наследованием разрешений от родительской папки
	@Name           - название папки
	@ParentFolderID - ID родительской папки
	@Order INT      - порядок сортировки
*/
	INSERT INTO [DocumentFolder] ([Name], [ParentFolderID], [Order]) VALUES (@Name, @ParentFolderID, @Order)
	
	DECLARE @NewID INT
	SET @NewID = SCOPE_IDENTITY()
	
    INSERT INTO DocumentFolder_To_RuleGroup([DocumentFolderID], [RuleGroupID], [IsWriter])
		SELECT @NewID, RuleGroupID, IsWriter FROM DocumentFolder_To_RuleGroup WHERE DocumentFolderID = @ParentFolderID

	RETURN @NewID;
END;