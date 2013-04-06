<%@ WebHandler Language="C#" Class="UserFoto" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Data;

/// <summary>
/// вывод фотографии пользователя из базы Контактов
/// </summary>
public class UserFoto : IHttpHandler
{

    /// <summary>обработка запроса</summary>
    /// <param name="context"></param>
    public void ProcessRequest(HttpContext context)
    {
        HttpRequest request = context.Request;
        HttpResponse response = context.Response;

        //забираем значение id из UserFoto.ashx?id=1
        int id;
        if (int.TryParse(request.QueryString["id"], out id))
        {
            string select = string.Format("SELECT TOP 1 [Foto] FROM [Contact] WHERE [ID] = {0} AND Foto IS NOT NULL", id);
            SqlDataReader reader = AdoUtils.CreateSqlDataReader(select);
            if (reader.HasRows)
            {
                reader.Read();
                response.ContentType = "image/jpeg";
                response.OutputStream.Write(reader.GetSqlBinary(0).Value, 0, reader.GetSqlBinary(0).Length);                
            }
            else
                OutputNoFoto(ref response);
            reader.Close();            
        }
        else
            OutputNoFoto(ref response);
        //todo: нужны ли эти функции?
        //response.Cache.SetCacheability(HttpCacheability.Public);
        //response.BufferOutput = false;                
        response.End();

        /*
        Для подключения HttpHandlerов используется секция <httpHandlers> файла конфигурации web.config. 
        Формат строки подключения HttpHandlerа следующий:
        <httpHandlers> <add verb="(verbs)" path="(путь к файлу)" type="(полное имя класса,имя сборки)" /> </httpHandlers>
        Опираясь на это подключим созданный нами HttpHandler к веб приложению. 
        Перепишем скомпилированную сборку в подкаталог bin веб приложения и добавим в файл конфигурации в раздел <httpHandlers> следующую строку:
        <add verb="*" path="photo.aspx" type="PictureHandler.PictureHandler,PictureHandler" /> 
          
         Вот и все. Теперь в любом месте веб приложения для вывода картинки с id=10 можно использовать 
         <img src="photo.aspx?id=10">. 
         */
    }

    /// <summary>может ли наш класс вызываться без повторной инициализации</summary>
    public bool IsReusable
    {
        get { return false; }
    }

    /// <summary>вывод пустой фотографии</summary>
    private void OutputNoFoto(ref HttpResponse response)
    {
        response.ContentType = "image/png";
        response.WriteFile(@"~/images/user_nofoto.png");
    }
}