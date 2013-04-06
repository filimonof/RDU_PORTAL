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

public partial class controls_AdmDocumentFolders : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //ограничение доступа
        int userID = (int)this.Session["USER_ID"];
        if (!Rule.IsAccess(userID, RuleEnum.Admin))
            this.Response.Redirect("~/Default.aspx");
    }

    /// <summary>Редактирование</summary>
    protected void DataListFolders_EditCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListFolders.EditItemIndex = e.Item.ItemIndex;
        this.DataListFolders.DataBind();
    }

    /// <summary>Отмена</summary>
    protected void DataListFolders_CancelCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListFolders.EditItemIndex = -1;
        this.DataListFolders.DataBind();
    }

    /// <summary>Сохранение изменения</summary>
    protected void DataListFolders_UpdateCommand(object source, DataListCommandEventArgs e)
    {
        int id = (int)this.DataListFolders.DataKeys[e.Item.ItemIndex];

        if (Page.IsValid)
        {
            HiddenField hiddenFieldsFolderID = ((HiddenField)e.Item.FindControl("HiddenFieldsFolderID"));
            DropDownList dropDownListParent = ((DropDownList)e.Item.FindControl("DropDownListParent"));
            TextBox textBoxName = ((TextBox)e.Item.FindControl("TextBoxName"));
            TextBox textBoxOrder = ((TextBox)e.Item.FindControl("TextBoxOrder"));
            if (hiddenFieldsFolderID != null && dropDownListParent != null && textBoxName != null && textBoxOrder != null)
            {
                this.SqlDataSourceDocumentFolders.UpdateParameters["Name"].DefaultValue = textBoxName.Text;
                this.SqlDataSourceDocumentFolders.UpdateParameters["ParentFolderID"].DefaultValue = dropDownListParent.SelectedValue;
                this.SqlDataSourceDocumentFolders.UpdateParameters["Order"].DefaultValue = textBoxOrder.Text;
                this.SqlDataSourceDocumentFolders.UpdateParameters["ID"].DefaultValue = hiddenFieldsFolderID.Value;
                this.SqlDataSourceDocumentFolders.Update();
            }

            DataList dataListAccess = ((DataList)e.Item.FindControl("DataListAccess"));
            if (dataListAccess != null)
            {
                foreach (DataListItem itemRule in dataListAccess.Items)
                {
                    CheckBox checkBoxReader = (CheckBox)itemRule.FindControl("CheckBoxReader");
                    CheckBox checkBoxWriter = (CheckBox)itemRule.FindControl("CheckBoxWriter");
                    HiddenField hiddenFieldID = (HiddenField)itemRule.FindControl("HiddenFieldID");
                    HiddenField hiddenFieldRuleGroupID = (HiddenField)itemRule.FindControl("HiddenFieldRuleGroupID");
                    HiddenField hiddenFieldValue = (HiddenField)itemRule.FindControl("HiddenFieldValue");
                    if (checkBoxReader != null && checkBoxWriter != null && hiddenFieldID != null && hiddenFieldRuleGroupID != null && hiddenFieldValue != null)
                    {
                        if (!checkBoxReader.Checked) //нет доступа на чтение
                        {
                            if (!string.IsNullOrEmpty(hiddenFieldID.Value)) //запись есть в базе
                            {
                                this.SqlDataSourceAccessFolder.DeleteParameters["ID"].DefaultValue = hiddenFieldID.Value;
                                this.SqlDataSourceAccessFolder.Delete();
                            }
                        }
                        else //доступ на чтение разрешен
                        {
                            if (!string.IsNullOrEmpty(hiddenFieldID.Value)) //запись уже есть в базе
                            {
                                this.SqlDataSourceAccessFolder.UpdateParameters["ID"].DefaultValue = hiddenFieldID.Value;
                                this.SqlDataSourceAccessFolder.UpdateParameters["IsWriter"].DefaultValue = checkBoxWriter.Checked.ToString();
                                this.SqlDataSourceAccessFolder.Update();
                            }
                            else // нет записи
                            {
                                this.SqlDataSourceAccessFolder.InsertParameters["RuleGroupID"].DefaultValue = hiddenFieldRuleGroupID.Value;
                                this.SqlDataSourceAccessFolder.InsertParameters["DocumentFolderID"].DefaultValue = hiddenFieldsFolderID.Value;
                                this.SqlDataSourceAccessFolder.InsertParameters["IsWriter"].DefaultValue = checkBoxWriter.Checked.ToString();
                                this.SqlDataSourceAccessFolder.Insert();
                            }
                        }
                    }
                }
            }
        }

        this.DataListFolders.EditItemIndex = -1;
        this.DataListFolders.DataBind();
    }

    /// <summary>Удаление папки</summary>
    protected void DataListFolders_DeleteCommand(object source, DataListCommandEventArgs e)
    {
        int id = (int)this.DataListFolders.DataKeys[e.Item.ItemIndex];
        this.SqlDataSourceDocumentFolders.DeleteParameters["ID"].DefaultValue = id.ToString();
        this.SqlDataSourceDocumentFolders.Delete();
        this.DataListFolders.EditItemIndex = -1;
        this.DataListFolders.DataBind();
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

    /// <summary>Список папок в качестве родителя</summary>
    /// <param name="idFolder">группа</param>
    /// <returns>набор данных</returns>
    protected DataView GetParentFolder(int idFolder)
    {
        this.SqlDataSourceDocumentFoldersCicle.SelectParameters["currentID"].DefaultValue = idFolder.ToString();
        return (DataView)(this.SqlDataSourceDocumentFoldersCicle.Select(new DataSourceSelectArguments()));
    }

    /// <summary>отображение разрешений внутри редактируемой папки</summary>
    protected void DataListAccess_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            CheckBox checkBoxReader = (CheckBox)e.Item.FindControl("CheckBoxReader");
            CheckBox checkBoxWriter = (CheckBox)e.Item.FindControl("CheckBoxWriter");
            HiddenField hiddenFieldID = (HiddenField)e.Item.FindControl("HiddenFieldID");
            HiddenField hiddenFieldRuleGroupID = (HiddenField)e.Item.FindControl("HiddenFieldRuleGroupID");
            HiddenField hiddenFieldValue = (HiddenField)e.Item.FindControl("HiddenFieldValue");

            if (checkBoxReader != null && checkBoxWriter != null && hiddenFieldID != null && hiddenFieldRuleGroupID != null && hiddenFieldValue != null)
            {
                checkBoxReader.Checked = !string.IsNullOrEmpty(hiddenFieldValue.Value);
                if (checkBoxReader.Checked)
                {
                    bool isWrite;
                    if (bool.TryParse(hiddenFieldValue.Value, out isWrite))
                        checkBoxWriter.Checked = isWrite;
                    else
                        checkBoxWriter.Checked = false;
                }
            }
        }
    }

    /// <summary>Список папок в качестве родителя</summary>
    /// <param name="idFolder">группа</param>
    /// <returns>набор данных</returns>
    protected DataView GetAccessFolder(int idFolder)
    {
        this.SqlDataSourceAccessFolder.SelectParameters["RuleDocument"].DefaultValue = ((int)RuleEnum.UsedDocuments).ToString();
        this.SqlDataSourceAccessFolder.SelectParameters["FolderID"].DefaultValue = idFolder.ToString();
        return (DataView)(this.SqlDataSourceAccessFolder.Select(new DataSourceSelectArguments()));
    }

    /// <summary>При запрещении чтения папки запретить и запись</summary>
    protected void CheckBoxReader_CheckedChanged(object sender, EventArgs e)
    {
        if (!((CheckBox)sender).Checked)
        {
            DataListItem item = this.DataListFolders.Items[this.DataListFolders.EditItemIndex];
            if (item != null)
            {
                DataList dataListAccess = ((DataList)item.FindControl("DataListAccess"));
                if (dataListAccess != null)
                {
                    foreach (DataListItem itemRule in dataListAccess.Items)
                    {
                        CheckBox checkBoxReader = (CheckBox)itemRule.FindControl("CheckBoxReader");
                        CheckBox checkBoxWriter = (CheckBox)itemRule.FindControl("CheckBoxWriter");
                        if (checkBoxReader != null && checkBoxWriter != null)
                            if (checkBoxReader.UniqueID == ((CheckBox)sender).UniqueID)
                                checkBoxWriter.Checked = false;
                    }
                }
            }
        }
    }

    /// <summary>При разрешении записи разрешить и чтение</summary>
    protected void CheckBoxWriter_CheckedChanged(object sender, EventArgs e)
    {
        if (((CheckBox)sender).Checked)
        {
            DataListItem item = this.DataListFolders.Items[this.DataListFolders.EditItemIndex];
            if (item != null)
            {
                DataList dataListAccess = ((DataList)item.FindControl("DataListAccess"));
                if (dataListAccess != null)
                {
                    foreach (DataListItem itemRule in dataListAccess.Items)
                    {
                        CheckBox checkBoxReader = (CheckBox)itemRule.FindControl("CheckBoxReader");
                        CheckBox checkBoxWriter = (CheckBox)itemRule.FindControl("CheckBoxWriter");
                        if (checkBoxReader != null && checkBoxWriter != null)
                            if (checkBoxWriter.UniqueID == ((CheckBox)sender).UniqueID)
                                checkBoxReader.Checked = true;
                    }
                }
            }
        }
    }

    /// <summary>создание новой папки</summary>
    protected void ButtonNew_Click(object sender, EventArgs e)
    {
        this.SqlDataSourceDocumentFolders.Insert();
        this.DataListFolders.DataBind();
        this.TextBoxNewName.Text = string.Empty;
    }
}
