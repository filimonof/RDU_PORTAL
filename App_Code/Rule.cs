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
using System.Reflection;
using System.Collections.Generic;
using System.Web.Configuration;

/// <summary>
/// Доступ / права на действие
/// </summary>
public enum RuleEnum
{
    /// <summary>Показ трафика в меню пользователя</summary>
    [Description("Показывать трафик")]
    Trafik = 1,

    /// <summary>Пункт меню - просмотр почтового карантина</summary>
    [Description("Просмотр почтового карантина")]
    EmailKarantin = 2,

    /// <summary>Пункт меню - статистика по трафику</summary>
    [Description("Статистика по трафику")]
    StatisticsTrafik = 3,

    /// <summary>Разместить объявление</summary>
    [Description("Размещение объявлений")]
    PutMessage = 4,

    /// <summary>Управление новостями</summary>
    [Description("Управление новостями")]
    AdmNews = 5,

    /// <summary>Управление контактами</summary>
    [Description("Управление контактами")]
    AdmContact = 6,

    /// <summary>Доступ к документам</summary>
    [Description("Доступ к документам")]
    UsedDocuments = 7,

    /// <summary>Администратор</summary>
    [Description("Администратор")]
    Admin = 666
}

/// <summary>
/// Описание - атрибут перечисления RuleEnum
/// </summary>
class DescriptionAttribute : Attribute
{
    /// <summary>поле для описания</summary>
    private readonly string _name;

    /// <summary>конструктор</summary>
    /// <param name="name">описание</param>
    public DescriptionAttribute(string name)
    {
        this._name = name;
    }

    /// <summary>перевести в строку</summary>
    /// <returns>строковое значение атрибута</returns>
    public override string ToString()
    {
        return this._name.ToString();
    }
}

/// <summary>
/// класс работы с правами доступа (Rule)
/// </summary>
public class Rule
{
    /// <summary>Проверка доступа пользователя</summary>
    /// <param name="userID">ID подьзователя</param>
    /// <param name="rule">доступ (права)</param>
    /// <returns>разрешение</returns>
    public static bool IsAccess(int userID, RuleEnum rule)
    {
        //todo : проверка IsAccess правильная, но напрягает делать каждый раз запрос к базе данных

        //проверка пользователя на безусловного админа из файла web.config
        if (Rule.IsForceAdmin()) return true;

        //проверка уровня доступа 
        SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["siteConnectionString"].ConnectionString);
        SqlCommand command = new SqlCommand("IsAccess", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.Add("@UserID", SqlDbType.Int).Value = userID;
        command.Parameters.Add("@RuleID", SqlDbType.Int).Value = rule;
        command.Parameters.Add("RETURN_VALUE", SqlDbType.Bit).Direction = ParameterDirection.ReturnValue;
        try
        {
            connection.Open();
            command.ExecuteNonQuery();
            return (int)command.Parameters["RETURN_VALUE"].Value == 1;
        }
        catch (SqlException e)
        {
            throw new ApplicationException("Ошибка при определении прав доступа \n" + e.Message);
        }
        finally
        {
            connection.Close();
        }
    }

    /// <summary>проверка пользователя на безусловного админа из файла web.config</summary>
    /// <param name="name">пользователь</param>
    /// <returns>true - безусловный админ</returns>
    public static bool IsForceAdmin(string domainName)
    {
        string forceAdmin = WebConfigurationManager.AppSettings["ForceAdmin"];
        string[] names = forceAdmin.Split(new char[] { ' ' });
        foreach (string name in names)
            if (name.Equals(domainName))
                return true;
        return false;
    }

    /// <summary>проверка ТЕКУЩЕГО пользователя на безусловного админа из файла web.config</summary>
    /// <returns>true - безусловный админ</returns>
    public static bool IsForceAdmin()
    {
        return Rule.IsForceAdmin(HttpContext.Current.User.Identity.Name);
    }

    /// <summary>Получение значения аттрибута Description у перечисления RuleEnum</summary>
    /// <param name="rule">значение перечисления</param>
    /// <returns>значение аттрибута или имя перечисления</returns>
    private static string GetDescription(RuleEnum rule)
    {
        // получение значение аттрибута Description у пеерчисления
        FieldInfo fi = rule.GetType().GetField(rule.ToString());
        DescriptionAttribute da = (DescriptionAttribute)Attribute.GetCustomAttribute(fi, typeof(DescriptionAttribute));

        if (da != null)
            //если есть аттрибут Description то выводим значение аттрибута
            return da.ToString();
        else
            // если нет аттрибута то имя перечисления
            return rule.ToString();
    }

    /// <summary>Синхронизация перечисления RuleEnum и таблицы Rule</summary>
    public static void Synchronized()
    {
        SqlDataReader reader = AdoUtils.CreateSqlDataReader("SELECT * FROM [Rule] ");
        List<int> list = new List<int>();
        while (reader.Read())
            list.Add((int)reader["ID"]);
        reader.Close();

        foreach (RuleEnum rule in Enum.GetValues(typeof(RuleEnum)))
        {
            bool exist = false;
            for (int i = 0; i < list.Count; i++)
                if (list[i] == (int)rule) exist = true;
            if (!exist)
                Rule.AddTable((int)rule, GetDescription(rule));
        }
        list.Clear();
    }

    /// <summary>Добавить запись о правиле в таблицу правил</summary>
    /// <param name="id">номер</param>
    /// <param name="name">описание</param>
    private static void AddTable(int id, string name)
    {
        SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["siteConnectionString"].ConnectionString);
        SqlCommand command = new SqlCommand("INSERT INTO [Rule] ([ID], [Name]) VALUES (@ID, @Name)", connection);
        command.CommandType = CommandType.Text;
        command.Parameters.Add("@ID", SqlDbType.Int).Value = id;
        command.Parameters.Add("@Name", SqlDbType.NVarChar, 100).Value = name;
        try
        {
            connection.Open();
            command.ExecuteNonQuery();
        }
        catch (SqlException e)
        {
            throw new ApplicationException("Ошибка при добавлении новых правил \n" + e.Message);
        }
        finally
        {
            connection.Close();
        }
    }

}
