SET  ARITHABORT, CONCAT_NULL_YIELDS_NULL, ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, QUOTED_IDENTIFIER ON 
SET  NUMERIC_ROUNDABORT OFF
GO
:setvar DatabaseName "site.rdu"
:setvar PrimaryFilePhysicalName "c:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\site.rdu.mdf"
:setvar PrimaryLogFilePhysicalName "c:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\site.rdu_log.ldf"

USE [master]

GO

:on error exit

IF  (DB_ID(N'$(DatabaseName)') IS NOT NULL
    AND DATABASEPROPERTYEX(N'$(DatabaseName)','Status') <> N'ONLINE')
BEGIN
    RAISERROR(N'The state of the target database, %s, is not set to ONLINE. To deploy to this database, its state must be set to ONLINE.', 16, 127,N'$(DatabaseName)') WITH NOWAIT
    RETURN
END
GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL)
BEGIN
    IF ((SELECT CAST(value AS nvarchar(128))
	    FROM 
		    [$(DatabaseName)]..fn_listextendedproperty('microsoft_database_tools_deploystamp', null, null, null, null, null, null )) 
	    = CAST(N'a4805d83-14e0-42e4-91da-19fd28163a34' AS nvarchar(128)))
    BEGIN
	    RAISERROR(N'Deployment has been skipped because the script has already been deployed to the target server.', 16 ,100) WITH NOWAIT
	    RETURN
    END
END
GO


:on error resume
     
:on error exit

IF (@@servername != 'FILIMONOVVV-MRD\SQLEXPRESS')
BEGIN
    RAISERROR(N'The server name in the build script %s does not match the name of the target server %s. Verify whether your database project settings are correct and whether your build script is up to date.', 16, 127,N'FILIMONOVVV-MRD\SQLEXPRESS',@@servername) WITH NOWAIT
    RETURN
END
GO


DECLARE @sqlver as INT;
SET @sqlver = cast(((@@microsoftversion / 0x1000000) * 10) as int);
IF (@sqlver != 90)
BEGIN
    RAISERROR(N'The version of SQL Server in the build script %i does not match the version on the target server %i. Verify whether your database project settings are correct and whether your build script is up to date.', 16, 127,90,@sqlver) WITH NOWAIT;
    RETURN;
END
GO


IF NOT EXISTS (SELECT 1 FROM [master].[dbo].[sysdatabases] WHERE [name] = N'site.rdu')
BEGIN
    RAISERROR(N'You cannot deploy this update script to target FILIMONOVVV-MRD\SQLEXPRESS. The database for which this script was built, site.rdu, does not exist on this server.', 16, 127) WITH NOWAIT
    RETURN
END
GO


IF (N'$(DatabaseName)' ! = N'site.rdu')
BEGIN
    RAISERROR(N'The database name in the build script %s does not match the name of the target database %s. Verify whether your database project settings are correct and  whether your build script is up to date.', 16, 127,N'$(DatabaseName)',N'site.rdu') WITH NOWAIT;
    RETURN
END
GO


DECLARE @dbcompatlvl as int;
SELECT  @dbcompatlvl = cmptlevel
FROM    [master].[dbo].[sysdatabases]
WHERE   [name] = N'$(DatabaseName)';
IF (ISNULL(@dbcompatlvl, 0) != 90)
BEGIN
    RAISERROR(N'The database compatibility level of the build script %i does not match the compatibility level of the target database %i. Verify whether your database project settings are correct and whether your build script is up to date.', 16, 127, 90, @dbcompatlvl) WITH NOWAIT;
    RETURN;
END
GO


IF CAST(DATABASEPROPERTY(N'$(DatabaseName)','IsReadOnly') as bit) = 1
BEGIN
    RAISERROR(N'You cannot deploy this update script because the database for which this script was built, %s , is set to READ_ONLY.', 16, 127, N'$(DatabaseName)') WITH NOWAIT
    RETURN
END
GO

:on error resume
     
IF EXISTS (SELECT 1 FROM [sys].[databases] WHERE [name] = N'$(DatabaseName)') 
    ALTER DATABASE [$(DatabaseName)] SET  
	ALLOW_SNAPSHOT_ISOLATION OFF
GO

IF EXISTS (SELECT 1 FROM [sys].[databases] WHERE [name] = N'$(DatabaseName)') 
    ALTER DATABASE [$(DatabaseName)] SET  
	READ_COMMITTED_SNAPSHOT OFF
GO

IF EXISTS (SELECT 1 FROM [sys].[databases] WHERE [name] = N'$(DatabaseName)') 
    ALTER DATABASE [$(DatabaseName)] SET  
	MULTI_USER,
	CURSOR_CLOSE_ON_COMMIT OFF,
	CURSOR_DEFAULT LOCAL,
	AUTO_CLOSE OFF,
	AUTO_CREATE_STATISTICS ON,
	AUTO_SHRINK OFF,
	AUTO_UPDATE_STATISTICS ON,
	AUTO_UPDATE_STATISTICS_ASYNC ON,
	ANSI_NULL_DEFAULT ON,
	ANSI_NULLS ON,
	ANSI_PADDING ON,
	ANSI_WARNINGS ON,
	ARITHABORT ON,
	CONCAT_NULL_YIELDS_NULL ON,
	NUMERIC_ROUNDABORT OFF,
	QUOTED_IDENTIFIER ON,
	RECURSIVE_TRIGGERS OFF,
	RECOVERY FULL,
	PAGE_VERIFY NONE,
	DISABLE_BROKER,
	PARAMETERIZATION SIMPLE
	WITH ROLLBACK IMMEDIATE
GO

IF IS_SRVROLEMEMBER ('sysadmin') = 1
BEGIN

IF EXISTS (SELECT 1 FROM [sys].[databases] WHERE [name] = N'$(DatabaseName)') 
    EXEC sp_executesql N'
    ALTER DATABASE [$(DatabaseName)] SET  
	DB_CHAINING OFF,
	TRUSTWORTHY OFF'

END
ELSE
BEGIN
    RAISERROR(N'Unable to modify the database settings for DB_CHAINING or TRUSTWORTHY. You must be a SysAdmin in order to apply these settings.',0,1)
END

GO

USE [$(DatabaseName)]

GO
/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script	
 Use SQLCMD syntax to include a file into the pre-deployment script			
 Example:      :r .\filename.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
GO

:on error exit

:on error resume
GO
PRINT N'Creating [dbo].[DateClearTime]'
GO
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
GO

GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script		
 Use SQLCMD syntax to include a file into the post-deployment script			
 Example:      :r .\filename.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

-- LinkMenu

--DELETE FROM [dbo].[LinkMenu]
--INSERT INTO [dbo].[LinkMenu] VALUES (N'СО-ЦДУ ЕЭС', N'http://www.cdo.ups.ru/', 0, 0, 1);
--INSERT INTO [dbo].[LinkMenu] VALUES (N'ОДУ Средней Волги', N'http://www.odusv.so-cdu.ru/', 0, 1, 1);
--INSERT INTO [dbo].[LinkMenu] VALUES (N'ОДУ СВ Балансирующий рынок', N'http://somod.odusv.so-cdu.ru/index.htm', 0, 2, 1);
--INSERT INTO [dbo].[LinkMenu] VALUES (N'Мордовэнерго', N'http://172.23.40.100/new/', 0, 3, 1);
--INSERT INTO [dbo].[LinkMenu] VALUES (N'ТЭЦ-2', N'http://192.168.1.1/', 0, 4, 1);
--INSERT INTO [dbo].[LinkMenu] VALUES (N'ОДУ Урала', N'http://172.21.4.62/', 0, 5, 1);
--INSERT INTO [dbo].[LinkMenu] VALUES (N'РАО-ЕЭС России', N'http://www.rao-ees.ru/', 1, 0, 1);
--INSERT INTO [dbo].[LinkMenu] VALUES (N'СО-ЦДУ ЕЭС', N'http://www.so-cdu.ru/', 1, 1, 1);
--INSERT INTO [dbo].[LinkMenu] VALUES (N'ТЭЦ-2', N'http://www.tec2.ru/', 1, 2, 1);
--INSERT INTO [dbo].[LinkMenu] VALUES (N'АТС', N'http://www.np-ats.ru/index.jsp', 1, 3, 1);


-- LinkMenuCaption

--DELETE FROM [dbo].[LinkMenuCaption]
--INSERT INTO [dbo].[LinkMenuCaption] VALUES (N'Сайты филиалов СО', 1, 1);
--INSERT INTO [dbo].[LinkMenuCaption] VALUES (N'Сайты электроэнергетики', 5, 1);
--INSERT INTO [dbo].[LinkMenuCaption] VALUES (N'Полезные сайты', 10, 1);

-- Post

--DELETE FROM [dbo].[Post]
--INSERT INTO [dbo].[Post] VALUES (N'Директор', N'Директор',1);
--INSERT INTO [dbo].[Post] VALUES (N'Первый заместитель директора - главный диспетчер', N'1-ый зам. директора', 2);
--INSERT INTO [dbo].[Post] VALUES (N'Заместитель директора по информационным технологиям', N'Зам. директора по ИТ', 3);
--INSERT INTO [dbo].[Post] VALUES (N'Заместитель главного диспетчера - начальник ОДС', N'Начальник ОДС', 4);
--INSERT INTO [dbo].[Post] VALUES (N'Главный бухгалтер', N'Главбух', 5);
--INSERT INTO [dbo].[Post] VALUES (N'Начальник службы', N'Начальник службы', 6);
--INSERT INTO [dbo].[Post] VALUES (N'Начальник отдела', N'Начальник отдела', 7);
--INSERT INTO [dbo].[Post] VALUES (N'И. о. начальника службы', N'И.о. нач. сужбы', 8);
--INSERT INTO [dbo].[Post] VALUES (N'И. о. начальника отдела', N'И.о. нач. отдела', 9);
--INSERT INTO [dbo].[Post] VALUES (N'Ведущий эксперт', N'Ведущий эксперт', 10);
--INSERT INTO [dbo].[Post] VALUES (N'Старший диспетчер', N'Старший диспетчер', 11);
--INSERT INTO [dbo].[Post] VALUES (N'Главный специалист', N'Главный специалист', 12);
--INSERT INTO [dbo].[Post] VALUES (N'Ведущий специалист', N'Ведущий специалист', 13);
--INSERT INTO [dbo].[Post] VALUES (N'Дежурный диспетчер', N'Дежурный диспетчер', 14);
--INSERT INTO [dbo].[Post] VALUES (N'Диспетчер', N'Диспетчер', 15);
--INSERT INTO [dbo].[Post] VALUES (N'Специалист 1 категории', N'Специалист 1 к.', 16);
--INSERT INTO [dbo].[Post] VALUES (N'Специалист 2 категории', N'Специалист 2 к.', 17);
--INSERT INTO [dbo].[Post] VALUES (N'Специалист 3 категории', N'Специалист 3 к.', 18);
--INSERT INTO [dbo].[Post] VALUES (N'Специалист', N'Специалист', 19);
--INSERT INTO [dbo].[Post] VALUES (N'Специалист по ГО и ЧС', N'Спец. ГОиЧС', 20);


-- Departament

--DELETE FROM [dbo].[Departament]
--INSERT INTO [dbo].[Departament] VALUES (N'Руководство РДУ', N'Руководство РДУ', 1);
--INSERT INTO [dbo].[Departament] VALUES (N'Оперативно-диспетчерская служба', N'ОДС', 2);
--INSERT INTO [dbo].[Departament] VALUES (N'Служба эксплуатации программно-аппаратного комплекса', N'СЭПАК', 3);
--INSERT INTO [dbo].[Departament] VALUES (N'Служба телемеханики и связи', N'СТС', 4);
--INSERT INTO [dbo].[Departament] VALUES (N'Служба электрических режимов', N'СЭР', 5);
--INSERT INTO [dbo].[Departament] VALUES (N'Служба энергетических режимов, балансов и развития', N'СЭРБР', 6);
--INSERT INTO [dbo].[Departament] VALUES (N'Служба релейной защиты и автоматики', N'СРЗА', 7);
--INSERT INTO [dbo].[Departament] VALUES (N'Отдел сопровождения рынка', N'ОСР', 8);
--INSERT INTO [dbo].[Departament] VALUES (N'Отдел бухгалтерского учета и экономики', N'ОБУ', 9);
--INSERT INTO [dbo].[Departament] VALUES (N'Ведущий эксперт по техническому аудиту', N'Техаудит', 10);
--INSERT INTO [dbo].[Departament] VALUES (N'Административно-правовой отдел', N'АПО', 11);
--INSERT INTO [dbo].[Departament] VALUES (N'Отдел административно-хозяйственного обеспечения', N'АХО', 12);
--INSERT INTO [dbo].[Departament] VALUES (N'Дежурный персонал', N'Дежурный персонал', 13);


-- Rule

--DELETE FROM [dbo].[Rule]
--INSERT INTO [dbo].[Rule] VALUES (1, N'Получение трафика');
--INSERT INTO [dbo].[Rule] VALUES (2, N'Просмотр почтового карантина');
--INSERT INTO [dbo].[Rule] VALUES (3, N'Статистика по трафику');
--INSERT INTO [dbo].[Rule] VALUES (4, N'Размещение объявлений');
--INSERT INTO [dbo].[Rule] VALUES (5, N'Управление новостями');
--INSERT INTO [dbo].[Rule] VALUES (6, N'Управление контактами');
--INSERT INTO [dbo].[Rule] VALUES (7, N'Доступ к документам');
--INSERT INTO [dbo].[Rule] VALUES (666, N'Администратор');

-- NewsType

--DELETE FROM [dbo].[NewsType]
--INSERT INTO [dbo].[NewsType] VALUES (1, N'Рассылка RSS 2.0');
--INSERT INTO [dbo].[NewsType] VALUES (2, N'Новости ОДУ СВ 1.0');
--INSERT INTO [dbo].[NewsType] VALUES (3, N'Погода на Yandex 1.0');


-- ContactType

--DELETE FROM [dbo].[ContactType]
--INSERT INTO [dbo].[ContactType] VALUES (1, N'Контакты сайта');
--INSERT INTO [dbo].[ContactType] VALUES (2, N'Сайт ЦДУ исполнительный аппарат');
--INSERT INTO [dbo].[ContactType] VALUES (3, N'Сайт ЦДУ работники ОДУ и РДУ');
--INSERT INTO [dbo].[ContactType] VALUES (4, N'Файл');
--INSERT INTO [dbo].[ContactType] VALUES (5, N'Excel-файл версия 1');


-- DocumentType

--DELETE FROM [dbo].[DocumentType]
--INSERT INTO [dbo].[DocumentType] VALUES (null, N'doc', N'Документ Microsoft Word', N'application/msword');
--INSERT INTO [dbo].[DocumentType] VALUES (null, N'', N'', N'');
--image/gif
--image/jpeg
--image/tiff
--application/rtf
--application/x-excel
--application/ms-powerpoint
--application/pdf
--application/zip
--application/ogg 	
--audio/midi 	              mid midi kar
--audio/mpeg              	mpga mp2 mp3 
--video/x-msvideo         	avi 




USE [$(DatabaseName)]
IF ((SELECT COUNT(*) 
	FROM 
		::fn_listextendedproperty( 'microsoft_database_tools_deploystamp', null, null, null, null, null, null )) 
	> 0)
BEGIN
	EXEC [dbo].sp_dropextendedproperty 'microsoft_database_tools_deploystamp'
END
EXEC [dbo].sp_addextendedproperty 'microsoft_database_tools_deploystamp', N'a4805d83-14e0-42e4-91da-19fd28163a34'
GO

