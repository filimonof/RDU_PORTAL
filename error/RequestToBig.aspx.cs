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

public partial class error_RequestToBig : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //current request
        int currentRequest = 0;
        if (this.Page.Request["requestSize"] != null)
        {
            int i;
            if (int.TryParse(this.Page.Request["requestSize"].ToString(), out i))
                currentRequest = i / 1024;
        }

        //max request
        int maxRequestSizeKBytes = 4 * 1024;
        System.Web.Configuration.HttpRuntimeSection section = (System.Web.Configuration.HttpRuntimeSection)HttpContext.Current.GetSection("system.web/httpRuntime");
        if (section != null)
            maxRequestSizeKBytes = section.MaxRequestLength;

        this.Label3.Visible = currentRequest != 0;
        this.Label3.Text = string.Format("Текущий размер запроса: {0} kB <br/> Максимальный размер запроса: {1} kB",
            currentRequest, maxRequestSizeKBytes);
    }
}
