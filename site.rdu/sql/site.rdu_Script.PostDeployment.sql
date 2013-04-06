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



