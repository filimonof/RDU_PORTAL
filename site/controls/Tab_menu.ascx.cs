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

public partial class controls_Tab_menu : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void Menu1_MenuItemClick(object sender, MenuEventArgs e)
    {
        switch (e.Item.Value)
        {
            case "0":
                MultiView1.ActiveViewIndex = 0;
                break;
            case "1":
                MultiView1.ActiveViewIndex = 1;
                break;
            case "2":
                MultiView1.ActiveViewIndex = 2;
                break;
            case "3":
                MultiView1.ActiveViewIndex = 3;
                break;
            default:
                break;
        }
    }
}
