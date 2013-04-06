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

public partial class controls_AdmNews : System.Web.UI.UserControl
{
    /// <summary>загрузка страницы</summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        //ограничение доступа
        int userID = (int)this.Session["USER_ID"];
        if (!Rule.IsAccess(userID, RuleEnum.Admin))
            this.Response.Redirect("~/Default.aspx");
    }

    /// <summary>удаление с запросом и показ типа записи</summary>
    protected void GridViewNews_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate)
            {
                //запрос на удаление
                if (e.Row.Cells[0].Controls[2] is Button)
                    ((Button)e.Row.Cells[0].Controls[2]).Attributes.Add("onclick", "if(!confirm('Желаете удалить данные?')) return false;");

                //вывод типа ленты 
                // получить значение текущего типа
                int typeID = (int)((DataRowView)e.Row.DataItem).Row["TypeID"];
                // получить данные из SqlDataSource 
                DataView ds = (DataView)this.SqlDataSourceNewsType.Select(DataSourceSelectArguments.Empty);
                ds.RowFilter = string.Format("ID='{0}'", typeID);
                //вывод знчения в ячейку
                ((Label)e.Row.FindControl("LabelGridType")).Text = ds[0].Row["Name"].ToString(); 
            }
        }
    }
    
    /// <summary>добавить новую ленту</summary>
    protected void ButtonNew_Click(object sender, EventArgs e)
    {
        this.SqlDataSourceNews.Insert();
        this.GridViewNews.DataBind();

        this.TextBoxNewName.Text = string.Empty;
        this.TextBoxNewLink.Text = string.Empty;
        this.TextBoxNewOrder.Text = string.Empty;
        this.DropDownNewType.SelectedIndex = 0;
        this.CheckBoxNewEnabled.Checked = true;
    }

}
