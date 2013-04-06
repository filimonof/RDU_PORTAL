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
using System.Net;
using System.Text;
using System.IO;
using System.Web.Configuration;


/// <summary>
/// Класс дял работой с функциями загрузки данных
/// </summary>
public class LoadData
{
    public LoadData()
    {

    }

    /// <summary>загрузка файла из интернета</summary>
    /// <param name="url">URL фала в сети</param>
    /// <param name="localname">путь и имя при сохранении локально</param>
    public static void DownloadFile(string url, string localname)
    {
        try
        {
            WebClient webClient = new WebClient();
            webClient.Proxy = LoadData.GetProxy();
            string localname_abs = HttpContext.Current.Server.MapPath(localname);
            webClient.DownloadFile(url, localname_abs);
        }
        catch (Exception e)
        {
            throw new Exception("LoadData.DownloadFile -> Ошибка при загрузке файла \n " + e.Message);
        }
    }

    /// <summary>загрузка страницы из интернеты</summary>
    /// <param name="url">адрес страницы</param>
    /// <returns>строка со страницей</returns>
    public static string DownloadPage(string url, Encoding encoding)
    {
        try
        {
            WebRequest request = WebRequest.Create(url);
            request.Proxy = LoadData.GetProxy();
            using (WebResponse response = request.GetResponse())
            {
                using (StreamReader reader = new StreamReader(response.GetResponseStream(), encoding))
                {
                    return reader.ReadToEnd();
                }
            }
        }
        catch (Exception e)
        {
            throw new Exception("LoadData.DownloadPage -> Ошибка при загрузке страницы \n " + e.Message);
        }
    }

    /// <summary>получить прокси для выхода в интернет</summary>
    /// <returns>объект WebProxy</returns>
    private static WebProxy GetProxy()
    {
        string proxy_ip = WebConfigurationManager.AppSettings["Proxy_IP"];
        string port = WebConfigurationManager.AppSettings["Proxy_Port"];
        string isAuth = WebConfigurationManager.AppSettings["Proxy_Auth"];
        string isDefault = WebConfigurationManager.AppSettings["Proxy_IsDefaultUser"];
        string login = WebConfigurationManager.AppSettings["Proxy_Login"];
        string password = WebConfigurationManager.AppSettings["Proxy_Password"];
        string domain = WebConfigurationManager.AppSettings["Proxy_Domain"];

        //&& Uri.CheckSchemeName(proxy_ip)
        if (!string.IsNullOrEmpty(proxy_ip))
        {
            if (!string.IsNullOrEmpty(port))
                proxy_ip += ":" + port;

            WebProxy proxy = new WebProxy(proxy_ip);

            bool byPass;
            if (!string.IsNullOrEmpty(isAuth) && bool.TryParse(isAuth, out byPass))
                proxy.BypassProxyOnLocal = byPass;
            else
                proxy.BypassProxyOnLocal = false;

            bool isDef;
            if (string.IsNullOrEmpty(isDefault) || !bool.TryParse(isDefault, out isDef))
                isDef = true;
            if (isDef)
                proxy.Credentials = CredentialCache.DefaultCredentials;
            else
                proxy.Credentials = new NetworkCredential(login, password, domain);

            return proxy;
        }
        else return null;
    }

}
