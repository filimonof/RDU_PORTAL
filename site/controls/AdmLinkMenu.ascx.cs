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

public partial class controls_AdmLinkMenu : System.Web.UI.UserControl
{
    /// <summary>загрузка страницы</summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        //ограничение доступа
        int userID = (int)this.Session["USER_ID"];
        if (!Rule.IsAccess(userID, RuleEnum.Admin))
            this.Response.Redirect("~/Default.aspx");      
    }

    /// <summary>добавить новую ссылку</summary>
    protected void ButtonNew_Click(object sender, EventArgs e)
    {
        this.SqlDataSourceLinkMenu.Insert();
        this.GridViewLinkMenu.DataBind();

        this.TextBoxNewName.Text = string.Empty;
        this.TextBoxNewLink.Text = string.Empty;
        this.TextBoxNewOrder.Text = string.Empty;
        this.CheckBoxNewInternetLink.Checked = false;
        this.CheckBoxNewEnabled.Checked = false;
    }

    /// <summary>удаление с запросом</summary>
    protected void GridViewLinkMenu_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate)
            {
                if (e.Row.Cells[0].Controls[2] is Button)
                    ((Button)e.Row.Cells[0].Controls[2]).Attributes.Add("onclick", "if(!confirm('Желаете удалить данные?')) return false;");
            }
        }

    }
}
