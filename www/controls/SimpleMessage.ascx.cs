using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class controls_SimpleMessage : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //string s = HttpContext.Current.Request.UserHostAddress + "\n" +
        //    HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"] + "\n" +
        //    HttpContext.Current.Request.ServerVariables["REMOTE_HOST"];
        //HttpContext.Current.Request.UserHostName();

        string s = @"<p><b>Name:</b> " + HttpContext.Current.User.Identity.Name + @" </p>
            <p><b>Authentication type:</b> " + HttpContext.Current.User.Identity.AuthenticationType.ToString() + @" </p>
            <p><b>Is authenticated:</b> " + HttpContext.Current.User.Identity.IsAuthenticated.ToString() + @" </p>
            <p><b>Is admin:</b> " + HttpContext.Current.User.IsInRole("Administrator").ToString() + @" </p>";
        

        s += "<p><b>Днс имя:</b> " + System.Net.Dns.GetHostByName("LocalHost").HostName + @" </p>";
        s += "<p><b>Нетбиос имя:</b> " + System.Environment.MachineName + @" </p>";
        s += "<p><b>Хост имя:</b> " + System.Net.Dns.GetHostName() + @" </p>";

        s += "<p><b>Имя польз:</b> " + System.Environment.UserDomainName + @"\" + System.Environment.UserName + @" </p>";
        System.Security.Principal.WindowsIdentity user = System.Security.Principal.WindowsIdentity.GetCurrent();
        s += "<p><b>Имя польз2:</b> " + user.Name.ToString() + @" </p>";

        Label1.Text = s;

    }
}
