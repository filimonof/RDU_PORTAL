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

public partial class controls_AdmRuleGroup : System.Web.UI.UserControl
{
    /// <summary>загрузка страницы</summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        //ограничение доступа
        int userID = (int)this.Session["USER_ID"];
        if (!Rule.IsAccess(userID, RuleEnum.Admin))
            this.Response.Redirect("~/Default.aspx");
    }

    /// <summary>добавить</summary>
    protected void ButtonNew_Click(object sender, EventArgs e)
    {
        this.SqlDataSourceRuleGroup.Insert();
        this.DataListGroup.DataBind();

        this.TextBoxNewName.Text = string.Empty;
    }

    /// <summary>удаление с запросом</summary>
    protected void GridViewRuleGroup_RowDataBound(object sender, GridViewRowEventArgs e)
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

    /// <summary>Редактирование</summary>
    protected void DataListGroup_EditCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListGroup.EditItemIndex = e.Item.ItemIndex;
        this.DataListGroup.DataBind();
    }

    /// <summary>Отмена</summary>
    protected void DataListGroup_CancelCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListGroup.EditItemIndex = -1;
        this.DataListGroup.DataBind();
    }

    /// <summary>Сохранение изменения</summary>
    protected void DataListGroup_UpdateCommand(object source, DataListCommandEventArgs e)
    {
        int id = (int)this.DataListGroup.DataKeys[e.Item.ItemIndex];

        TextBox textBoxGroup = (TextBox)e.Item.FindControl("TextBoxName");
        this.SqlDataSourceRuleGroup.UpdateParameters["ID"].DefaultValue = id.ToString();
        this.SqlDataSourceRuleGroup.UpdateParameters["Name"].DefaultValue = textBoxGroup.Text;
        this.SqlDataSourceRuleGroup.Update();
        
        if (Page.IsValid)
        {
            HiddenField hiddenFieldGroupID = ((HiddenField)e.Item.FindControl("HiddenFieldGroupID"));
            DataList dataListRule = ((DataList)e.Item.FindControl("DataListRule"));
            if (dataListRule != null)
            {
                foreach (DataListItem itemRule in dataListRule.Items)
                {
                    CheckBox checkBoxValue = (CheckBox)itemRule.FindControl("CheckBoxNameRule");
                    HiddenField hiddenFieldID = (HiddenField)itemRule.FindControl("HiddenFieldID");
                    HiddenField hiddenFieldRuleID = (HiddenField)itemRule.FindControl("HiddenFieldRuleID");
                    if (checkBoxValue.Checked)
                    {
                        if (string.IsNullOrEmpty(hiddenFieldID.Value))
                        {
                            this.SqlDataSourceRule_To_RuleGroup.InsertParameters["RuleGroupID"].DefaultValue = hiddenFieldGroupID.Value;
                            this.SqlDataSourceRule_To_RuleGroup.InsertParameters["RuleID"].DefaultValue = hiddenFieldRuleID.Value;
                            this.SqlDataSourceRule_To_RuleGroup.Insert();
                        }
                    }
                    else
                    {
                        if (!string.IsNullOrEmpty(hiddenFieldID.Value))
                        {
                            this.SqlDataSourceRule_To_RuleGroup.DeleteParameters["ID"].DefaultValue = hiddenFieldID.Value;
                            this.SqlDataSourceRule_To_RuleGroup.Delete();
                        }
                    }
                }
            }

        }

        this.DataListGroup.EditItemIndex = -1;
        this.DataListGroup.DataBind();
    }

    /// <summary>Удалить</summary>
    protected void DataListGroup_DeleteCommand(object source, DataListCommandEventArgs e)
    {
        int id = (int)this.DataListGroup.DataKeys[e.Item.ItemIndex];
        this.SqlDataSourceRuleGroup.DeleteParameters["ID"].DefaultValue = id.ToString();
        this.SqlDataSourceRuleGroup.Delete();

        this.DataListGroup.EditItemIndex = -1;
        this.DataListGroup.DataBind();
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

    /// <summary>Набор правил группы (если id=null правило в группу не входит)</summary>
    /// <param name="idGroup">группа</param>
    /// <returns>набор данных</returns>
    protected DataView GetRulesGroup(int idGroup)
    {
        this.SqlDataSourceRule_To_RuleGroup.SelectParameters["RuleGroupID"].DefaultValue = idGroup.ToString();
        return (DataView)(SqlDataSourceRule_To_RuleGroup.Select(new DataSourceSelectArguments()));
    }

    /// <summary>отображение правил внутри группы</summary>
    protected void DataListRule_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            CheckBox checkBoxValue = (CheckBox)e.Item.FindControl("CheckBoxNameRule");
            HiddenField hiddenFieldID = (HiddenField)e.Item.FindControl("HiddenFieldID");
            checkBoxValue.Checked = !string.IsNullOrEmpty(hiddenFieldID.Value);
        }
    }

}
