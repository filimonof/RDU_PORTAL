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

public partial class controls_AdmAccessGroup : System.Web.UI.UserControl
{
    /// <summary>загрузка страницы</summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        //ограничение доступа
        int userID = (int)this.Session["USER_ID"];
        if (!Rule.IsAccess(userID, RuleEnum.Admin))
            this.Response.Redirect("~/Default.aspx");
    }

    /// <summary>Редактирование</summary>
    protected void DataListAccessGroup_EditCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListAccessGroup.EditItemIndex = e.Item.ItemIndex;
        this.DataListAccessGroup.DataBind();
    }

    /// <summary>Отмена</summary>
    protected void DataListAccessGroup_CancelCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListAccessGroup.EditItemIndex = -1;
        this.DataListAccessGroup.DataBind();
    }

    /// <summary>Добавить пользователя в группу</summary>    
    protected void DataListAccessGroup_UpdateCommand(object source, DataListCommandEventArgs e)
    {
        if (Page.IsValid)
        {
            HiddenField hiddenFieldGroupID = ((HiddenField)e.Item.FindControl("HiddenFieldGroupID"));
            DropDownList dropDownListUserID = ((DropDownList)e.Item.FindControl("DropDownListUserID"));
            if (!string.IsNullOrEmpty(dropDownListUserID.SelectedValue))
            {
                this.SqlDataSourceUser_To_RuleGroup.InsertParameters["RuleGroupID"].DefaultValue = hiddenFieldGroupID.Value;
                this.SqlDataSourceUser_To_RuleGroup.InsertParameters["UserID"].DefaultValue = dropDownListUserID.SelectedValue;
                this.SqlDataSourceUser_To_RuleGroup.Insert();

                this.DataListAccessGroup.DataBind();
            }
        }
    }

    /// <summary>Список пользователей для добавления в группу</summary>
    /// <param name="idGroup">группа</param>
    /// <returns>набор данных</returns>
    protected DataView GetAddedUsers(int idGroup)
    {
        this.SqlDataSourceUser_inGroup.SelectParameters["GroupID"].DefaultValue = idGroup.ToString();
        return (DataView)(SqlDataSourceUser_inGroup.Select(new DataSourceSelectArguments()));
    }

    /// <summary>Список пользователей в группе</summary>
    /// <param name="idGroup">группа</param>
    /// <returns>набор данных</returns>
    protected DataView GetUsers(int idGroup)
    {
        this.SqlDataSourceUser_To_RuleGroup.SelectParameters["GroupID"].DefaultValue = idGroup.ToString();
        return (DataView)(SqlDataSourceUser_To_RuleGroup.Select(new DataSourceSelectArguments()));
    }

    /// <summary>Удалить пользователя из группы</summary>
    protected void DataListUser_DeleteCommand(object source, DataListCommandEventArgs e)
    {
        //берем id из внутреннего грида
        int id = (int)((DataList)source).DataKeys[e.Item.ItemIndex];
        this.SqlDataSourceUser_To_RuleGroup.DeleteParameters["ID"].DefaultValue = id.ToString();
        this.SqlDataSourceUser_To_RuleGroup.Delete();

        this.DataListAccessGroup.DataBind();
    }

    /// <summary>Переменная для подсчета строк в гриде</summary>
    private int _numRow = 0;

    /// <summary>Чередование стилей строк</summary>
    /// <returns>css стиль строки</returns>
    protected string StyleRow()
    {
        //использовать как - <tr class='<%# StyleRow() %>'>
        return (++this._numRow % 2 == 0) ? "item_row_alt" : "item_row";
    }

}
