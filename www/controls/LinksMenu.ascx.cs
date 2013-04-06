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

public partial class controls_LinksMenu : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if ((!this.IsPostBack) && (this.DataListLinks.Items.Count > 0))
        {
            this.DataListLinks.SelectedIndex = 0;
            this.SqlDataSourceItems.SelectParameters["CaptionID"].DefaultValue = this.DataListLinks.SelectedValue.ToString();
            this.DataListLinks.DataBind();
        }
    }

    /// <summary>выбор группы ссылок</summary>
    protected void DataListLinks_ItemCommand(object source, DataListCommandEventArgs e)
    {
        this.SqlDataSourceItems.SelectParameters["CaptionID"].DefaultValue = e.CommandArgument.ToString();
        this.DataListLinks.SelectedIndex = e.Item.ItemIndex;
        this.DataListLinks.DataBind();
    }
}
