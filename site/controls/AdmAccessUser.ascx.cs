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

public partial class controls_AdmAccessUser : System.Web.UI.UserControl
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
    protected void DataListAccessUser_EditCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListAccessUser.EditItemIndex = e.Item.ItemIndex;
        this.DataListAccessUser.DataBind();
    }

    /// <summary>Отмена</summary>
    protected void DataListAccessUser_CancelCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListAccessUser.EditItemIndex = -1;
        this.DataListAccessUser.DataBind();
    }

    /// <summary>Сохранение изменения</summary>
    protected void DataListAccessUser_UpdateCommand(object source, DataListCommandEventArgs e)
    {
        int id = (int)this.DataListAccessUser.DataKeys[e.Item.ItemIndex];

        if (Page.IsValid)
        {
            HiddenField hiddenFieldUserID = ((HiddenField)e.Item.FindControl("HiddenFieldUserID"));
            DataList dataListGroup = ((DataList)e.Item.FindControl("DataListGroup"));
            if (dataListGroup != null)
            {
                foreach (DataListItem itemRule in dataListGroup.Items)
                {
                    CheckBox checkBoxValue = (CheckBox)itemRule.FindControl("CheckBoxGroup");
                    HiddenField hiddenFieldID = (HiddenField)itemRule.FindControl("HiddenFieldID");
                    HiddenField hiddenFieldRuleGroupID = (HiddenField)itemRule.FindControl("HiddenFieldRuleGroupID");
                    if (checkBoxValue.Checked)
                    {
                        if (string.IsNullOrEmpty(hiddenFieldID.Value))
                        {
                            this.SqlDataSourceRuleGroup_To_User.InsertParameters["RuleGroupID"].DefaultValue = hiddenFieldRuleGroupID.Value;
                            this.SqlDataSourceRuleGroup_To_User.InsertParameters["UserID"].DefaultValue = hiddenFieldUserID.Value;
                            this.SqlDataSourceRuleGroup_To_User.Insert();
                        }
                    }
                    else
                    {
                        if (!string.IsNullOrEmpty(hiddenFieldID.Value))
                        {
                            this.SqlDataSourceRuleGroup_To_User.DeleteParameters["ID"].DefaultValue = hiddenFieldID.Value;
                            this.SqlDataSourceRuleGroup_To_User.Delete();
                        }
                    }
                }
            }

        }

        this.DataListAccessUser.EditItemIndex = -1;
        this.DataListAccessUser.DataBind();
    }

    /// <summary>Набор групп пользователя (если id=null пользователь не входит в эту группу)</summary>
    /// <param name="idUser">пользователь</param>
    /// <returns>набор данных</returns>
    protected DataView GetGroupsUser(int idUser)
    {
        this.SqlDataSourceRuleGroup_To_User.SelectParameters["UserID"].DefaultValue = idUser.ToString();
        return (DataView)(SqlDataSourceRuleGroup_To_User.Select(new DataSourceSelectArguments()));
    }

    /// <summary>отображение групп внутри пользователя</summary>
    protected void DataListGroup_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            CheckBox checkBoxValue = (CheckBox)e.Item.FindControl("CheckBoxGroup");
            HiddenField hiddenFieldID = (HiddenField)e.Item.FindControl("HiddenFieldID");
            checkBoxValue.Checked = !string.IsNullOrEmpty(hiddenFieldID.Value);
        }
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
