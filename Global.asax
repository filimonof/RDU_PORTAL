<%@ Application Language="C#" %>

<script RunAt="server">

    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup
        Log.ToDB(LogEnum.Info, "Application Start");
        Log.ToFile(LogEnum.Info, "Application Start");
    }

    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown
        Log.ToDB(LogEnum.Info, "Application End");
        Log.ToFile(LogEnum.Info, "Application End");
    }

    void Application_Error(object sender, EventArgs e)
    {        
        try
        {
            Exception exception = Server.GetLastError();
            if (exception != null)
            {
                string err = string.Format("Application Error : \n  {0}",
                    exception.InnerException != null ? exception.InnerException.Message + " \n stack track : \n " + exception.StackTrace : exception.Message);
                Log.ToDB(LogEnum.Error, err);
                Log.ToFile(LogEnum.Error, err);
                
                Server.ClearError();
                Server.Transfer("~/error/Exception.aspx");
            }
        }
        catch
        {
            Server.Transfer("~/error/Exception.aspx");
        }         
    }

    void Session_Start(object sender, EventArgs e)
    {
        Session["USER_ID"] = 0; //guest
        Session["USER_ID"] = UserSite.GetID(HttpContext.Current.User.Identity.Name);
        Log.ToDB(LogEnum.Login, "Session Start");
    }

    void Session_End(object sender, EventArgs e)
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.
        Session["USER_ID"] = 0; //guest
        Log.ToDB(LogEnum.Logout, "Session End");
    }

    /// Fires at the beginning of each request
    protected void Application_BeginRequest(object source, EventArgs e)
    {

        #region Проверка на файлы и запросы большого размера
        /*
         При заливки файлов на сервер используя asp:FileUpload возникает ошибка:
            Maximum requested length exceeded
         причиной тому является ограничение на размер заливаемого файла в 4 мегабайта, как исправить? Приведу пару примеров.
         1. со стороны сайта:
            в управляющий файл web.config в секции вставим строку:
                <httpruntime executiontimeout="600" maxrequestlength="6000"></httpruntime>
            снять ограничения можно выставив maxRequestLength в «-1″.
         2. со стороны сервера:
            в конфигурационном файле machine.config на сервере в зависимости от версии:
                C:\WINDOWS\Microsoft.NET\Framework\v1.1.4322\CONFIG\machine.config
                C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\CONFIG\machine.config
         */

        int maxRequestSizeKBytes = 1024 * 4; // 4 MB

        // получение из конфига максимального размера запроса
        System.Web.Configuration.HttpRuntimeSection section = (System.Web.Configuration.HttpRuntimeSection)HttpContext.Current.GetSection("system.web/httpRuntime");
        if (section != null)
            maxRequestSizeKBytes = section.MaxRequestLength;

        // Проверка размера всего запроса
        if (this.Request.ContentLength > (maxRequestSizeKBytes * 1024))
        {
            Log.ToDB(LogEnum.Error, "Application BeginRequest : Попытка загрузки большого файла " + (this.Request.ContentLength / 1024).ToString() + " КБайт");
            this.Response.Redirect("~/error/RequestToBig.aspx?requestSize=" + this.Request.ContentLength.ToString());
        }

        //проверка размеров вложенных файлов
        //int maxFileSizeKBytes = 1024; // 1MB
        //// проверка размеров файлов
        //for (int i = 0; i < this.Request.Files.Count; i++)
        //{
        //    if (this.Request.Files[i].ContentLength > (maxFileSizeKBytes * 1024))
        //    {
        //        this.Response.Redirect("~/error/FileToBig.aspx?fileSize=" + this.Request.Files[i].ContentLength.ToString());
        //    }
        //}
        #endregion


    }  
</script>