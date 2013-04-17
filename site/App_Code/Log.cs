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
using System.IO;
using System.Data.SqlClient;

/// <summary>
/// Тип записи в журнале логов 
/// (длинна не более 10 символов)
/// </summary>
public enum LogEnum
{
    /// <summary>информация</summary>
    Info,

    /// <summary>ошибка</summary>
    Error,

    /// <summary>авторизаия</summary>
    Login,

    /// <summary>выход</summary>
    Logout,

    /// <summary>посещение страницы</summary>
    Page,

    /// <summary>добавлен документ</summary>
    DocAdd,

    /// <summary>отредактирован документ</summary>
    DocEdit,

    /// <summary>удалён документ</summary>
    DocDel

}

/// <summary>
/// Ведение Логов
/// </summary>
public class Log
{
    /// <summary>вывод логов в файл</summary>
    /// <param name="log">тип информации</param>        
    /// <param name="message">строка с сообщением</param>        
    public static void ToFile(LogEnum log, string message)
    {
        string localdir = HttpContext.Current.Server.MapPath(@"~/logs/");
        string filename = Path.Combine(localdir, DateTime.Today.ToString("yyyy-MM-dd") + ".txt");
        StreamWriter sw = null;
        string user = string.Empty;
        string ip = string.Empty;
        if (HttpContext.Current.User != null)
            try
            {
                user = HttpContext.Current.User.Identity.Name;
                ip = HttpContext.Current.Request.UserHostAddress;
            }
            catch { }

        try
        {
            sw = File.AppendText(filename);
            sw.WriteLine(string.Format("{0,-6} {1,-11} {2,-21} {3,-16} {4}",
                DateTime.Now.ToString("HH:mm"), log.ToString(), user, ip, message));
        }
        catch { }
        finally
        {
            if (sw != null) sw.Close();
        }
    }

    /// <summary>вывод логов в базу</summary>
    /// <param name="log">тип информации</param>        
    /// <param name="message">строка с сообщением</param>   
    public static void ToDB(LogEnum log, string message)
    {
        string user = string.Empty;
        string ip = string.Empty;
        if (HttpContext.Current.User != null)
            try
            {
                user = HttpContext.Current.User.Identity.Name;
                ip = HttpContext.Current.Request.UserHostAddress;
            }
            catch { }

        try
        {
            SqlParameter[] param = {                     
                    new SqlParameter("@Date", SqlDbType.DateTime),
                    new SqlParameter("@Type", SqlDbType.NVarChar, 10),
                    new SqlParameter("@User", SqlDbType.NVarChar, 100),
                    new SqlParameter("@IP", SqlDbType.NVarChar, 100),
                    new SqlParameter("@Message", SqlDbType.NVarChar)
                };
            param[0].Value = DateTime.Now;
            param[1].Value = log.ToString();
            param[2].IsNullable = true;
            if (string.IsNullOrEmpty(user))
                param[2].Value = DBNull.Value;
            else
                param[2].Value = user;
            param[3].IsNullable = true;
            if (string.IsNullOrEmpty(ip))
                param[3].Value = DBNull.Value;
            else
                param[3].Value = ip;
            param[4].Value = message;
            AdoUtils.ExecuteCommand("INSERT INTO [Log] ([Date], [Type], [User], [IP], [Message]) VALUES (@Date, @Type, @User, @IP, @Message) ", param);
        }
        catch (Exception e)
        {
            Log.ToFile(LogEnum.Error, e.Message);
        }
    }
}
