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

public partial class controls_LinkMenu : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
      
    }

    /// <summary>
    /// какой элемент меню развернут (внутренние или интернет ссылки)   
    /// </summary>
    /// <param name="isLocal">true - развернуты локальные ссылки</param>
    /// <returns>"display: none;" если нужно спрятать что-то</returns>
    public string IsVsb(bool isLocal)
    {
        const string VISIBLE = "";
        const string INVISIBLE = "display: none;";
        
        if (this.Page.Request["link"] != "inet")
        {
            //внутренние ссылки
            if (isLocal) return VISIBLE;
            else return INVISIBLE;
        }
        else
        {
            //интернет ссылки
            if (isLocal) return INVISIBLE;
            else return VISIBLE;
        }
    }
}