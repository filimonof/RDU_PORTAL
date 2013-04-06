CREATE PROCEDURE [dbo].[IsAccess]
(
	@UserID INT, 
	@RuleID INT	
)
AS
BEGIN	
/*
Проверка доступа пользователя userID на ресурс ruleID
output:
	1 - есть доступ
	0 - нет доступа
*/	
	IF EXISTS(  
		SELECT [ID] FROM Rule_To_RuleGroup
		WHERE RuleID = @RuleID AND 
			RuleGroupID IN (SELECT RuleGroupID FROM RuleGroup_To_User WHERE UserID = @UserID)
	)
		return 1
	ELSE
		return 0
END;