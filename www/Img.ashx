<%@ WebHandler Language="C#" Class="Img" %>

using System;
using System.Web;
using System.Data.SqlClient;

/// <summary>
/// вывод картинки праздника
/// </summary>
public class Img : IHttpHandler
{
    /// <summary>обработка запроса</summary>
    /// <param name="context"></param>
    public void ProcessRequest(HttpContext context)
    {
        HttpRequest request = context.Request;
        HttpResponse response = context.Response;

        //забираем значение id и type из Img.ashx?type=holiday&id=1
        int id;
        if (!int.TryParse(request.QueryString["id"], out id))
            id = 0;
        string type = request.QueryString["type"];
        if (!string.IsNullOrEmpty(type))
        {
            type = type.ToLower();
            if (type.Equals(ImgUtils.GetText(TypeImgEnum.Holiday).ToLower()))
                this.OutputHolidayImg(ref response, id);
            else if (type.Equals(ImgUtils.GetText(TypeImgEnum.News).ToLower()))
                this.OutputNewsImg(ref response, id);
            else if (type.Equals(ImgUtils.GetText(TypeImgEnum.Contact).ToLower()))
                this.OutputContactImg(ref response, id);
            else if (type.Equals(ImgUtils.GetText(TypeImgEnum.TypeDocument).ToLower()))
                this.OutputDocumentTypeImg(ref response, id);
            else
                this.OutputDefaultImg(ref response);
        }
        else
            this.OutputDefaultImg(ref response);

        //todo: нужны ли эти функции?
        response.Cache.SetCacheability(HttpCacheability.NoCache);
        //response.BufferOutput = false;                

        response.End();
    }

    /// <summary>может ли наш класс вызываться без повторной инициализации</summary>
    public bool IsReusable
    {
        get { return false; }
    }


    /// <summary>вывод пустой картинки</summary>
    /// <param name="response">ответ с картинкой</param>    
    private void OutputDefaultImg(ref HttpResponse response)
    {
        response.ContentType = "image/gif";
        response.WriteFile(@"~/images/spacer.gif");
    }

    /// <summary>вывод картинки праздников</summary>
    /// <param name="response">ответ с картинкой</param>
    /// <param name="id">ID картинки</param>
    private void OutputHolidayImg(ref HttpResponse response, int id)
    {
        string select = string.Format("SELECT TOP 1 [Image] FROM [Holiday] WHERE [ID] = {0} AND [Image] IS NOT NULL", id);
        SqlDataReader reader = AdoUtils.CreateSqlDataReader(select);
        if (reader.HasRows)
        {
            reader.Read();
            response.ContentType = "image/jpeg";
            response.OutputStream.Write(reader.GetSqlBinary(0).Value, 0, reader.GetSqlBinary(0).Length);
        }
        else
        {
            response.ContentType = "image/png";
            response.WriteFile(@"~/images/holiday.png");
        }
        reader.Close();
    }

    /// <summary>вывод новостной картинки</summary>
    /// <param name="response">ответ с картинкой</param>
    /// <param name="id">ID картинки</param>
    private void OutputNewsImg(ref HttpResponse response, int id)
    {
        string select = string.Format("SELECT TOP 1 [Image] FROM [NewsTitle] WHERE [ID] = {0} AND [Image] IS NOT NULL", id);
        SqlDataReader reader = AdoUtils.CreateSqlDataReader(select);
        if (reader.HasRows)
        {
            reader.Read();
            response.ContentType = "image/jpeg";
            response.OutputStream.Write(reader.GetSqlBinary(0).Value, 0, reader.GetSqlBinary(0).Length);
        }
        else
        {
            response.ContentType = "image/gif";
            response.WriteFile(@"~/images/rss.gif");
        }
        reader.Close();
    }

    /// <summary>вывод картинки для группы контактов</summary>
    /// <param name="response">ответ с картинкой</param>
    /// <param name="id">ID картинки</param>
    private void OutputContactImg(ref HttpResponse response, int id)
    {
        string select = string.Format("SELECT TOP 1 [Image] FROM [ContactTitle] WHERE [ID] = {0} AND [Image] IS NOT NULL", id);
        SqlDataReader reader = AdoUtils.CreateSqlDataReader(select);
        if (reader.HasRows)
        {
            reader.Read();
            response.ContentType = "image/jpeg";
            response.OutputStream.Write(reader.GetSqlBinary(0).Value, 0, reader.GetSqlBinary(0).Length);
        }
        else
        {
            response.ContentType = "image/gif";
            response.WriteFile(@"~/images/contact.gif");
        }
        reader.Close();
    }

    /// <summary>вывод картинки для документов</summary>
    /// <param name="response">ответ с картинкой</param>
    /// <param name="id">ID картинки</param>
    private void OutputDocumentTypeImg(ref HttpResponse response, int id)
    {
        string select = string.Format("SELECT TOP 1 [Image], [ImageContentType] FROM [DocumentType] WHERE [ID] = {0} AND [Image] IS NOT NULL", id);
        SqlDataReader reader = AdoUtils.CreateSqlDataReader(select);
        if (reader.HasRows)
        {
            reader.Read();
            response.ContentType = AdoUtils.DBNullToNull(reader["ImageContentType"]) == null ? string.Empty : reader["ImageContentType"].ToString();
            response.OutputStream.Write(reader.GetSqlBinary(0).Value, 0, reader.GetSqlBinary(0).Length);
        }
        else
        {
            response.ContentType = "image/png";
            response.WriteFile(@"~/images/document.png");
        }
        reader.Close();
    }
    
}