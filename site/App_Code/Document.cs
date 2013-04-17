using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Collections.Generic;
using System.Data.SqlClient;

/// <summary>
/// Структура ноды дерева папок
/// </summary>
public struct FolderDoc
{
    /// <summary>ID</summary>
    public int ID { get; set; }

    /// <summary>ID родителя</summary>
    public int? ParentID { get; set; }

    /// <summary>Название</summary>
    public string Name { get; set; }

    /// <summary>Доступ на чтение</summary>
    public bool IsReader { get; set; }

    /// <summary>Доступ на запись</summary>
    public bool IsWriter { get; set; }

    /// <summary>Количество документов в папке</summary>
    public int Count { get; set; }

    /// <summary>Количество новых документов</summary>
    public int NewCount { get; set; }

    /// <summary>конструктор</summary>
    /// <param name="id">ID</param>
    /// <param name="parentID">родительский ID</param>
    /// <param name="name">название</param>
    /// <param name="count">количество документов в папке</param>
    /// <param name="newCount">количество новых документов в папке</param>
    /// <param name="isReader">есть ли бодступ на чтение</param>
    /// <param name="isWriter">есть ли боступ на запись</param>
    public FolderDoc(int id, int? parentID, string name, int count, int newCount, bool isReader, bool isWriter)
        : this()
    {
        this.ID = id;
        this.ParentID = parentID;
        this.Name = name;
        this.Count = count;
        this.NewCount = newCount;
        this.IsReader = isReader;
        this.IsWriter = isWriter;
    }
}

/// <summary>
/// Библиотека для работы с документами
/// </summary>
public class Document
{
    /// <summary>Получение из базы данных списка папок</summary>
    /// <param name="userID">ID пользователя</param>
    /// <returns>List с папками</returns>
    public static List<FolderDoc> GetFolderDoc(int userID)
    {
        List<FolderDoc> listFolders = new List<FolderDoc>();
        SqlParameter[] param = { new SqlParameter("@DIFFDAY", SqlDbType.Int) };
        param[0].Value = Parameter.DAY_NEW_DOC;
        try
        {
            SqlDataReader reader = AdoUtils.CreateSqlDataReader(
                @"SELECT f_new.[ID], f_new.[Name], f_new.[Order], f_new.[ParentFolderID], f_new.[TOTAL], COUNT(d_new.[ID]) AS NEW
            FROM 
            (  
	            SELECT 	f.[ID], f.[Name], f.[Order], f.[ParentFolderID], COUNT(d.[ID]) AS TOTAL	
	            FROM [DocumentFolder] AS f 	
                    LEFT JOIN ( SELECT * FROM [Document] WHERE [Deleted] = 0 ) AS d ON f.[ID] = d.[FolderID]
	            GROUP BY f.[ID], f.[Name], f.[Order], f.[ParentFolderID]
            ) AS f_new LEFT JOIN 
            (
	            SELECT [ID], [FolderID] FROM [Document] 
                WHERE DATEDIFF(day, [dbo].[DateClearTime]([DateUpload]), [dbo].[DateClearTime](getdate())) <= @DIFFDAY 
                    AND [Deleted] = 0 
            ) AS d_new ON f_new.[ID] = d_new.[FolderID] 
            GROUP BY f_new.[ID], f_new.[Name], f_new.[Order], f_new.[ParentFolderID], f_new.[TOTAL]
            ORDER BY f_new.[ParentFolderID], f_new.[Order], f_new.[Name] "
                , param);
            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    int? parentID = (int?)AdoUtils.DBNullToNull(reader["ParentFolderID"]);
                    FolderDoc folder = new FolderDoc((int)reader["ID"], parentID, (string)reader["Name"]
                        , (int)reader["TOTAL"], (int)reader["NEW"]
                        , Document.IsReaderFolder(userID, (int)reader["ID"]), Document.IsWriterFolder(userID, (int)reader["ID"]));
                    listFolders.Add(folder);
                }
            }
            reader.Close();
        }
        catch (Exception e)
        {
            throw new Exception("Document.GetFolderDoc -> Ошибка при получение из базы данных списка папок c документами \n " + e.Message);
        }
        return listFolders;
    }

    /// <summary>получение ссылки на документ</summary>
    /// <param name="id">идентификатор ID документа</param>
    /// <returns>текст с сылкой</returns>
    public static string Link(object id)
    {
        if (AdoUtils.DBNullToNull(id) == null)
            return @"~/Doc.ashx";
        else
            return string.Format(@"~/Doc.ashx?id={0}", id.ToString());
    }

    /// <summary>проверка прав доступа пользователя к документу</summary>
    /// <param name="userID">ID пользователя</param>
    /// <param name="documentID">ID документа</param>
    /// <returns>есть или нет доступа</returns>
    public static bool IsReaderDocument(int userID, int documentID)
    {
        bool isRead;
        bool isWrite;
        Document.IsAccessDoc(userID, documentID, false, out isRead, out isWrite);
        return isRead;
    }

    /// <summary>проверка прав доступа на запись пользователя к документу</summary>
    /// <param name="userID">ID пользователя</param>
    /// <param name="documentID">ID документа</param>
    /// <returns>есть или нет доступа назапись</returns>
    public static bool IsWriterDocument(int userID, int documentID)
    {
        bool isRead;
        bool isWrite;
        Document.IsAccessDoc(userID, documentID, false, out isRead, out isWrite);
        return isWrite;
    }

    /// <summary>проверка прав доступа пользователя к папке</summary>
    /// <param name="userID">ID пользователя</param>
    /// <param name="folderID">ID папки</param>
    /// <returns>есть или нет доступа</returns>
    public static bool IsReaderFolder(int userID, int folderID)
    {
        bool isRead;
        bool isWrite;
        Document.IsAccessDoc(userID, folderID, true, out isRead, out isWrite);
        return isRead;
    }

    /// <summary>проверка прав доступа на запись пользователя в папку</summary>
    /// <param name="userID">ID пользователя</param>
    /// <param name="folderID">ID папки</param>
    /// <returns>есть или нет доступа</returns>
    public static bool IsWriterFolder(int userID, int folderID)
    {
        bool isRead;
        bool isWrite;
        Document.IsAccessDoc(userID, folderID, true, out isRead, out isWrite);
        return isWrite;
    }

    /// <summary>проверка доступа в документах</summary>
    /// <param name="userID">ID пользователя</param>
    /// <param name="thisID">ID папки или документа</param>
    /// <param name="isFolderOrDoc">проверять доступ к папке(true) или документу (false)</param>
    /// <param name="isRead">есть ли права на чтение</param>
    /// <param name="isWrite">есть ли права на запись</param>
    private static void IsAccessDoc(int userID, int thisID, bool isFolderOrDoc, out bool isRead, out bool isWrite)
    {        
        //todo : может перенести базу в Application
        //первый кто подключается базу заполняет
        //в случае обновления структуры базу удалить, и следующий снова её обновит

        isRead = false;
        isWrite = false;

        if (Rule.IsForceAdmin())
        {
            isRead = true;
            isWrite = true;
            return;
        }

        SqlParameter[] param = { 
            new SqlParameter("@UserID", SqlDbType.Int),
            new SqlParameter("@ID", SqlDbType.Int)
        };
        param[0].Value = userID;
        param[1].Value = thisID;

        try
        {
            SqlDataReader reader = AdoUtils.CreateSqlDataReader(
                @"SELECT  
                    CASE WHEN SUM(CAST([IsWriter] AS INT)) > 0 THEN CAST(1 AS BIT)
                         ELSE CAST(0 AS BIT) 
                    END AS [IsWriter],
					CASE WHEN COUNT(*) > 0 THEN CAST(1 AS BIT)
                         ELSE CAST(0 AS BIT) 
                    END AS [IsReader]
                FROM [DocumentFolder_To_RuleGroup]
                WHERE RuleGroupID IN (SELECT DISTINCT [RuleGroupID] FROM [RuleGroup_To_User] WHERE [UserID] = @UserID)
                    AND DocumentFolderID = "
                + (isFolderOrDoc ? "@ID" : "(SELECT [FolderID] FROM [Document] WHERE [ID] = @ID)")
                , param);

            if (reader.HasRows)
            {
                reader.Read();
                isWrite = (bool)reader["IsWriter"];
                isRead = (bool)reader["IsReader"];
            }
            reader.Close();
        }
        catch (Exception e)
        {
            throw new Exception("Document.IsAccessDoc -> Ошибка при проверке прав доступа в документах \n " + e.Message);
        }
    }

    /// <summary>определение ID типа документа</summary>
    /// <param name="filename">имя файла</param>
    /// <returns>ID типа в базе или null если нету</returns>
    public static int? GetTypeDocument(string filename)
    {
        string extension = System.IO.Path.GetExtension(filename);
        if (extension.StartsWith("."))
            extension = extension.Remove(0, 1);
        return AdoUtils.GetID("DocumentType", "Extension", extension);
    }

}

