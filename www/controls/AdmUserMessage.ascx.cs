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

public partial class controls_AdmUserMessage : System.Web.UI.UserControl
{
    /// <summary>загрузка страницы</summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        //ограничение доступа
        int userID = (int)this.Session["USER_ID"];
        if (!Rule.IsAccess(userID, RuleEnum.Admin))
            this.Response.Redirect("~/Default.aspx");
    }

    /// <summary>удаление</summary>
    protected void DataListUserMessage_DeleteCommand(object source, DataListCommandEventArgs e)
    {
        int id = (int)this.DataListUserMessage.DataKeys[e.Item.ItemIndex];
        this.SqlDataSourceUserMesasge.DeleteParameters["ID"].DefaultValue = id.ToString();
        this.SqlDataSourceUserMesasge.Delete();

        this.DataListUserMessage.DataBind();
    }

    /// <summary>редактирование</summary>
    protected void DataListUserMessage_EditCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListUserMessage.EditItemIndex = e.Item.ItemIndex;
        this.DataListUserMessage.DataBind();
    }

    /// <summary>отмена изменений</summary>
    protected void DataListUserMessage_CancelCommand(object source, DataListCommandEventArgs e)
    {        
        this.DataListUserMessage.EditItemIndex = -1;
        this.DataListUserMessage.DataBind();
    }

    /// <summary>сохранение изменений</summary>
    protected void DataListUserMessage_UpdateCommand(object source, DataListCommandEventArgs e)
    {
        if (!this.Page.IsValid)  return;

        int id = (int)this.DataListUserMessage.DataKeys[e.Item.ItemIndex];

        CheckBox checkBoxEnabled = (CheckBox)e.Item.FindControl("CheckBoxEnabled");
        CheckBox checkBoxImportant = (CheckBox)e.Item.FindControl("CheckBoxImportant");
        TextBox textBoxCreateDate = (TextBox)e.Item.FindControl("TextBoxCreateDate");
        TextBox textBoxDeleteDate = (TextBox)e.Item.FindControl("TextBoxDeleteDate");
        DropDownList dropDownListUserID = (DropDownList)e.Item.FindControl("DropDownListUserID");
        TextBox textBoxText = (TextBox)e.Item.FindControl("TextBoxText");

        this.SqlDataSourceUserMesasge.UpdateParameters["ID"].DefaultValue = id.ToString();
        this.SqlDataSourceUserMesasge.UpdateParameters["UserID"].DefaultValue = dropDownListUserID.SelectedValue;
        this.SqlDataSourceUserMesasge.UpdateParameters["Text"].DefaultValue = textBoxText.Text;

        this.SqlDataSourceUserMesasge.UpdateParameters["CreateDate"].DefaultValue = textBoxCreateDate.Text;
        this.SqlDataSourceUserMesasge.UpdateParameters["DeleteDate"].DefaultValue = textBoxDeleteDate.Text;
        this.SqlDataSourceUserMesasge.UpdateParameters["Enabled"].DefaultValue = checkBoxEnabled.Checked.ToString();
        this.SqlDataSourceUserMesasge.UpdateParameters["Important"].DefaultValue = checkBoxImportant.Checked.ToString();
        this.SqlDataSourceUserMesasge.Update();

        this.DataListUserMessage.EditItemIndex = -1;
        this.DataListUserMessage.DataBind();
    }

    /// <summary>Вадиlатор введённой даты</summary>
    protected void CustomValidatorDate_ServerValidate(object source, ServerValidateEventArgs args)
    {
        DateTime dt;        
        args.IsValid = DateTime.TryParse(args.Value, out dt);
    }

    /// <summary>Вадиlатор введённого текста</summary>
    protected void CustomValidatorText_ServerValidate(object source, ServerValidateEventArgs args)
    {
        args.IsValid = !string.IsNullOrEmpty(args.Value.Trim());
    }

    /// <summary>преобразование даты</summary>
    /// <param name="dat">дата из базы</param>
    /// <returns>строка с датой</returns>
    protected static string DeldateToSrt(object dat)
    {
        return dat == DBNull.Value ? "не ограничено" : ((DateTime)dat).ToShortDateString();
    }

    /// <summary>замена спецсимволов на теги в сообщениях пользователя</summary>
    /// <param name="msg">сообщение с спецсимволами</param>
    /// <returns>проебразованное сообщение с тэгами</returns>
    public static string ParseMsgToOutput(object msg)
    {
        //todo : объединить с такой же функцией в сообщениях пользователей
        return msg.ToString().Replace("\n", "<br />").Replace("  ", "&nbsp;&nbsp;");
    }
        
}
