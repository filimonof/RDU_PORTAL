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
using System.Data.SqlClient;

/// <summary>
/// Работа с пользователями (таблица User)
/// </summary>
public class UserSite
{
    /// <summary>Получение ID пользователя по доменному имени, если пользователя нету то добавляется в базу как отключенный</summary>
    /// <param name="domainName">доменное имя</param>
    public static int GetID(string domainName)
    {
        int id = 0;
        bool enabled = false;

        //получаем запись о домменном имени domainName
        SqlParameter[] param = { new SqlParameter("@DomainName", SqlDbType.NVarChar, 100) };
        param[0].Value = domainName;        
        SqlDataReader reader = AdoUtils.CreateSqlDataReader("SELECT TOP 1 [ID], [Enabled] FROM [User] WHERE [DomainName] = @DomainName", param);
        if (reader.HasRows)
        {
            reader.Read();
            id = (int)reader["ID"];
            enabled = (bool)reader["Enabled"];
        }
        reader.Close();

        //если доменного имени domainName в списке нету то добавить но неактивное
        if (id == 0)
        {
            SqlParameter[] paramInsert = { 
                new SqlParameter("@DomainName", SqlDbType.NVarChar, 100),
                new SqlParameter("@Enabled", SqlDbType.Bit)
            };
            paramInsert[0].Value = domainName;
            paramInsert[1].Value = enabled;
            AdoUtils.ExecuteCommand("INSERT INTO [User] (DomainName, [Enabled]) VALUES (@DomainName, @Enabled)", paramInsert);            
        }

        //выдаём id пользователя, если отключен или не существует то 0
        return enabled || Rule.IsForceAdmin(domainName) ? id : 0;
    }
}
