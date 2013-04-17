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
/// Вспомогательные функции для работы с базами данных
/// </summary>
public class AdoUtils
{

    /// <summary>Получение DataReadera с данными после запроса</summary>
    /// <param name="selectQuery">запрос</param>
    /// <returns>Reader с данными</returns>
    public static SqlDataReader CreateSqlDataReader(string selectQuery)
    {
        SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["siteConnectionString"].ConnectionString);
        SqlCommand command = new SqlCommand(selectQuery, connection);
        command.CommandType = CommandType.Text;
        try
        {            
            command.Connection.Open();
            SqlDataReader reader = command.ExecuteReader(CommandBehavior.CloseConnection);
            return reader;
        }
        catch (SqlException e)
        {
            connection.Close();
            throw new Exception(string.Format("AdoUtils.CreateSqlDataReader -> Ошибка при выполнении запроса \n {0} \n {1}", selectQuery, e.Message));
        }
    }

    /// <summary>Получение DataReadera с данными после запроса с параметрами</summary>
    /// <param name="selectQuery">запрос</param>
    /// <param name="parameters">параметры</param>
    /// <returns>Reader с данными</returns>
    public static SqlDataReader CreateSqlDataReader(string selectQuery, SqlParameter[] parameters)
    {        
        SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["siteConnectionString"].ConnectionString);
        SqlCommand command = new SqlCommand(selectQuery, connection);
        command.CommandType = CommandType.Text;
        command.Parameters.AddRange(parameters);
        try
        {
            command.Connection.Open();
            SqlDataReader reader = command.ExecuteReader(CommandBehavior.CloseConnection);
            return reader;
        }
        catch (SqlException e)
        {
            connection.Close();
            throw new Exception(string.Format("AdoUtils.CreateSqlDataReader -> Ошибка при выполнении запроса \n {0} \n {1}", selectQuery, e.Message));
        }
    }

    /// <summary>выполнить запрос</summary>
    /// <param name="sql">sql запрос</param>
    /// <returns>количество строк задействованных в запросе</returns>
    public static int ExecuteCommand(string sql)
    {
        SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["siteConnectionString"].ConnectionString);
        SqlCommand command = new SqlCommand(sql, connection);
        command.CommandType = CommandType.Text;
        try
        {
            connection.Open();
            return command.ExecuteNonQuery();
        }
        catch (SqlException e)
        {
            throw new Exception(string.Format("AdoUtils.ExecuteCommand -> Ошибка при выполнении запроса \n {0} \n {1}", sql, e.Message));
        }
        finally
        {
            connection.Close();
        }
    }

    /// <summary>выполнить запрос c параметрами</summary>
    /// <param name="sql">sql запрос</param>
    /// <param name="parameters">параметры</param>
    /// <returns>количество строк задействованных в запросе</returns>
    public static int ExecuteCommand(string sql, SqlParameter[] parameters)
    {
        SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["siteConnectionString"].ConnectionString);
        SqlCommand command = new SqlCommand(sql, connection);
        command.CommandType = CommandType.Text;
        command.Parameters.AddRange(parameters);
        try
        {
            connection.Open();
            return command.ExecuteNonQuery();
        }
        catch (SqlException e)
        {
            throw new Exception(string.Format("AdoUtils.ExecuteCommand -> Ошибка при выполнении запроса \n {0} \n {1}", sql, e.Message));
        }
        finally
        {
            connection.Close();
        }
    }

    /// <summary>Получение ID из таблицы</summary>
    /// <param name="table">таблица</param>
    /// <param name="field">поле таблицы для сравнения значения</param>
    /// <param name="valueField">значение, по которому определяется ID</param>
    /// <param name="extensionQuery">дополнительный подзапрос</param>
    /// <returns>0-нет данных, или значение ID</returns>
    public static int? GetID(string table, string field, string valueField, string extensionQuery)
    {    
        string select = string.Format("SELECT [ID] FROM [{0}] WHERE [{1}] = @Value {2}", table, field, extensionQuery);
        SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["siteConnectionString"].ConnectionString);
        SqlCommand command = new SqlCommand(select, connection);
        command.CommandType = CommandType.Text;
        command.Parameters.Add("@Value", SqlDbType.NVarChar).Value = valueField;
        try
        {
            connection.Open();
            return (int?)command.ExecuteScalar();
        }
        catch (SqlException e)
        {
            throw new Exception(string.Format("AdoUtils.GetID -> Ошибка после запроса \n {0} \n @Value = {1} \n {2}", select, valueField, e.Message));
        }
        finally
        {
            connection.Close();
        }
    }

    /// <summary>Получение ID из таблицы</summary>
    /// <param name="table">таблица</param>
    /// <param name="field">поле таблицы для сравнения значения</param>
    /// <param name="valueField">значение, по которому определяется ID</param>
    /// <returns>0-нет данных, или значение ID</returns>
    public static int? GetID(string table, string field, string valueField)
    {
        return GetID(table, field, valueField, string.Empty);
    }

    /// <summary>Получение значения параметра по ID</summary>
    /// <param name="table">таблица</param>
    /// <param name="param">параметр (поле)</param>
    /// <param name="id">значение ID</param>
    /// <returns>значение параметра(поля)</returns>
    public static object GetParamFromID(string table, string param, int id)
    {
        string select = string.Format("SELECT [{0}] FROM [{1}] WHERE [ID] = @Value ", param, table);
        SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["siteConnectionString"].ConnectionString);
        SqlCommand command = new SqlCommand(select, connection);
        command.CommandType = CommandType.Text;
        command.Parameters.Add("@Value", SqlDbType.Int).Value = id;
        try
        {
            connection.Open();
            return command.ExecuteScalar();
        }
        catch (SqlException e)
        {
            throw new Exception(string.Format("AdoUtils.GetParamFromID -> Ошибка после запроса \n {0} \n @Value = {1} \n {2}", select, id, e.Message));
        }
        finally
        {
            connection.Close();
        }
    }

    /// <summary>значения поля DBNull преобразуем в null</summary>
    /// <param name="field">значение поля таблицы</param>
    /// <returns>либо поле либо null (исключаем значение DBNull)</returns>
    public static object DBNullToNull(object field)
    {
        if (field != DBNull.Value) return field;
        else return null;
    }

}
