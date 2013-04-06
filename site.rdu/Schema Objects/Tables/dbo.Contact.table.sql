CREATE TABLE [dbo].[Contact]
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,	
	
	[UserType] BIT NOT NULL DEFAULT (1),	
	[Family] NVARCHAR(100) NOT NULL DEFAULT (''),
	[FirstName] NVARCHAR(100) NOT NULL DEFAULT (''),
	[LastName] NVARCHAR(100) NOT NULL DEFAULT (''),
	[BirthDay] SMALLDATETIME NULL,	
	[Phone] NVARCHAR(100) NOT NULL DEFAULT (''),
	[Email] NVARCHAR(100) NOT NULL DEFAULT (''),		
	[Enabled] BIT NOT NULL DEFAULT (1),	
	
	[DepartamentID] INT NULL,
	[PostID] INT NULL,	
	[UserID] INT NULL,
	
	[Foto] IMAGE NULL,

	CONSTRAINT [FK_Contact_DepartamentID] 
		FOREIGN KEY ([DepartamentID]) REFERENCES [dbo].[Departament] ([ID]) 					
			ON DELETE NO ACTION,
			
	CONSTRAINT [FK_Contact_PostID] 
		FOREIGN KEY ([PostID]) REFERENCES [dbo].[Post] ([ID]) 					
			ON DELETE NO ACTION,
			
	CONSTRAINT [FK_Contact_UserID] 
		FOREIGN KEY ([UserID]) REFERENCES [dbo].[User] ([ID]) 					
			ON DELETE NO ACTION			
);


/*
	Контактные данные
		
	[UserType] - 1-человек, 0-иной
	[Family] - фамилия у человека, название у иного профиля
	[FirstName] - имя
	[LastName] - отчество
	[BirthDay] - День рождения	
	[Phone] - телефон
	[Email] - мыло
	[Enabled] - 0-отключен	
	
	[DepartamentID] - ID подразделения
	[PostID] - ID должности	
	[UserID] - ID авторизационной записи на доступ к сайут, null если нет доступа на сайт
	           уникальность userid проверяется триггером 
	           
	[Foto] - фотография           
	           
	           
CREATE TRIGGER [TR_Contact_UniqueUser]
ON [dbo].[Contact]
INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON


	-- из инета
	DECLARE @user int
	SET @user = (SELECT UserID FROM Inserted)
	
	IF NOT @user IS NULL
	BEGIN
		IF EXISTS (SELECT 1 FROM [Contact] WHERE UserID = @user)
		BEGIN
			ROLLBACK TRAN
		END
		ELSE
			INSERT [Contact] (UserID) VALUES (@user)

	END
	ELSE
	    INSERT [Contact] (UserID)  VALUES (@user)
    
	    
	
	-- мои наработки
	IF UPDATE(UserID)
	BEGIN	
		IF EXISTS(
			SELECT * FROM Contact
			WHERE UserID IN (SELECT UserID FROM inserted WHERE UserID IS NOT NULL))
		BEGIN
			RAISERROR ('Дублировани пользователя в контактах не допустимо', 16, 1)
			GOTO QuitWithRollback  
		END
	
		-- если записи нету то можно вставить	
		UPDATE Contact
			SET Contact.UserID = inserted.UserID
			FROM inserted 
			WHERE inserted.ID = Contact.ID 
	
	END	
	ELSE 
		 COMMIT TRANSACTION
		 
	
	GOTO   Quit

QuitWithRollback:
	IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION 

Quit: 

END;	           
*/