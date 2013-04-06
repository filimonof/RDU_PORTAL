<%@ WebHandler Language="C#" Class="Doc" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;

/// <summary>
/// получение файла из базы Документов
/// </summary>
public class Doc : IHttpHandler, IReadOnlySessionState
{
    /// <summary>обработка запроса</summary>
    /// <param name="context"></param>
    public void ProcessRequest(HttpContext context)
    {
        HttpRequest request = context.Request;
        HttpResponse response = context.Response;

        //забираем значение id из Doc.ashx?id=1
        int id;
        if (int.TryParse(request.QueryString["id"], out id))
        {            
            //проверка прав доступа                 
            if (Document.IsReaderDocument((int)context.Session["USER_ID"], id))
            {
                string select = string.Format("SELECT TOP 1 [Document].[Doc], DocumentType.[ContentTypeDocument], Document.[Name], DocumentType.[Extension] FROM [Document] INNER JOIN DocumentType ON [Document].DocumentTypeID = DocumentType.ID WHERE [Document].[ID] = {0} AND [Document].[Doc] IS NOT NULL", id);
                SqlDataReader reader = AdoUtils.CreateSqlDataReader(select);
                if (reader.HasRows)
                {
                    reader.Read();
                    if (reader["ContentTypeDocument"] != null)
	            {
                        response.ContentType = reader["ContentTypeDocument"].ToString();                    
			response.AddHeader("content-disposition", string.Format("inline; filename=\"{0}.{1}\"", reader["Name"].ToString(), reader["Extension"].ToString()));		
//todo : при формировании имени файла убрать спецсимволы
		    }
                    response.OutputStream.Write(reader.GetSqlBinary(0).Value, 0, reader.GetSqlBinary(0).Length);

                }
                else
                {
                    context.Response.ContentType = "text/plain";
                    context.Response.Write("Документ не найден");
                }
            }
            else
            {
                context.Response.ContentType = "text/plain";
                context.Response.Write("У вас нет разрешения для просмотра этого документа");
            }
        }
        else
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("Не указан идентификатор документа");
        }
        //response.Cache.SetCacheability(HttpCacheability.Public);
        //response.BufferOutput = false;                
        response.End();
    }

    /// <summary>может ли наш класс вызываться без повторной инициализации</summary>
    public bool IsReusable
    {
        get { return false; }
    }
    
}

/*
/// <summary>
/// получение файла из базы Документов
/// </summary>
public class Doc : IHttpHandler, IReadOnlySessionState
{
    /// <summary>обработка запроса</summary>
    /// <param name="context"></param>
    public void ProcessRequest(HttpContext context)
    {
        HttpRequest request = context.Request;
        HttpResponse response = context.Response;

        //забираем значение id из Doc.ashx?id=1
        int id;
        if (int.TryParse(request.QueryString["id"], out id))
        {            
            //проверка прав доступа                 
            if (Document.IsReaderDocument((int)context.Session["USER_ID"], id))
            {
                string select = string.Format("SELECT TOP 1 [Document].[Doc], DocumentType.[ContentTypeDocument], Document.[Name], DocumentType.[Extension]  FROM [Document] INNER JOIN DocumentType ON [Document].DocumentTypeID = DocumentType.ID WHERE [Document].[ID] = {0} AND [Document].[Doc] IS NOT NULL", id);
                SqlDataReader reader = AdoUtils.CreateSqlDataReader(select);
                if (reader.HasRows)
                {
                    reader.Read();
                    if (reader["ContentTypeDocument"] != null)
{
                        response.ContentType = reader["ContentTypeDocument"].ToString();                    
			response.AddHeader("content-disposition", string.Format("inline; filename=\"{0}.{1}\"", reader["Name"].ToString(), reader["Extension"].ToString()));		
//todo : при формировании имени файла убрать спецсимволы
}
                    response.OutputStream.Write(reader.GetSqlBinary(0).Value, 0, reader.GetSqlBinary(0).Length);


response.AddHeader("content-disposition", "attachment;filename=" + reader["Name"].ToString() + "." + reader["Extension"].ToString());		

//
//Response.AppendHeader("content-disposition", "inline; filename=" + name );
//
//
//context.Response.AddHeader("content-disposition", "attachment;filename=PUTYOURFILENAMEHERE.pdf");
//context.Response.ContentType = "application/pdf";
//

                }
                else
                {
                    context.Response.ContentType = "text/plain";
                    context.Response.Write("Документ не найден");
                }
            }
            else
            {
                context.Response.ContentType = "text/plain";
                context.Response.Write("У вас нет разрешения для просмотра этого документа");
            }
        }
        else
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("Не указан идентификатор документа");
        }
        //response.Cache.SetCacheability(HttpCacheability.Public);
        //response.BufferOutput = false;                
        response.End();
    }

    /// <summary>может ли наш класс вызываться без повторной инициализации</summary>
    public bool IsReusable
    {
        get { return false; }
    }
    
}
*/