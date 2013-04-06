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
using System.Data.SqlClient;

public partial class controls_UserMessageEdit : System.Web.UI.UserControl
{
    /// <summary>ID сообщения при редактировании</summary>
    private int? MessageID { get; set; }

    /// <summary>Загрузка страницы</summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        this.Page.Title += " - Сообщение";
        int currentUserID = (int)this.Session["USER_ID"];

        if (this.Page.Request["id"] != null)
        {
            //редактировать
            int id;
            if (!int.TryParse(this.Page.Request["id"].ToString(), out id))
                this.Response.Redirect("~/Default.aspx");
            this.MessageID = id;
            this.CheckBoxEnabled.Enabled = true;
            this.ButtonAddMessage.Text = "Сохранить изменения";

            //если не пост бак то заполняем значения из базы
            if (!this.IsPostBack)
            {
                //взять параметры сообщения из базы                 
                string select = "SELECT * FROM [UserMessage] WHERE ID = @ID";
                SqlParameter[] param = { new SqlParameter("@ID", SqlDbType.Int) };
                param[0].Value = this.MessageID;
                SqlDataReader reader = AdoUtils.CreateSqlDataReader(select, param);
                if (reader.HasRows)
                {
                    reader.Read();
                    int userID = (int)reader["UserID"];

                    //если сообщение ни его и он не админ
                    if (userID != currentUserID && !Rule.IsAccess(currentUserID, RuleEnum.Admin))
                        this.Response.Redirect("~/Default.aspx");

                    this.CheckBoxEnabled.Checked = (bool)reader["Enabled"];
                    this.TextBoxText.Text = (string)reader["Text"];
                    this.TextBoxDelDate.Text = reader["DeleteDate"] != DBNull.Value ? ((DateTime)reader["DeleteDate"]).ToShortDateString() : string.Empty;
                    this.CheckBoxImportant.Checked = (bool)reader["Important"];
                }
                else
                {
                    this.Response.Redirect("~/Default.aspx");
                }
                reader.Close();
            }
        }
        else
        {
            //новое сообщение
            this.MessageID = null;
            this.CheckBoxEnabled.Enabled = false;
            this.ButtonAddMessage.Text = "Разместить объявление";

            //проверка прав на создание сообщений
            if (!Rule.IsAccess(currentUserID, RuleEnum.PutMessage) && !Rule.IsAccess(currentUserID, RuleEnum.Admin))
                this.Response.Redirect("~/Default.aspx");

            //если не пост бак то забить значения по умолчанию
            if (!this.IsPostBack)
            {
                this.CheckBoxEnabled.Checked = true;
                this.TextBoxText.Text = "Уважаемые работники Мордовского РДУ.";
                this.TextBoxDelDate.Text = string.Empty;
                this.CheckBoxImportant.Checked = false;
            }
        }
    }

    /// <summary>отредактировать сообщение или добавить новое</summary>
    protected void ButtonAddMessage_Click(object sender, EventArgs e)
    {
        if (this.MessageID == null)
        {
            // сохранить новое сообщение [CreateDate]
            string insert = "INSERT INTO [UserMessage] ([UserID], [Text], [DeleteDate], [Enabled], [Important]) VALUES (@UserID, @Text, @DeleteDate, @Enabled, @Important)";
            SqlParameter[] param = 
            {             
                new SqlParameter("@UserID", SqlDbType.Int),
                new SqlParameter("@Text", SqlDbType.NVarChar),                
                new SqlParameter("@DeleteDate", SqlDbType.SmallDateTime),
                new SqlParameter("@Enabled", SqlDbType.Bit),
                new SqlParameter("@Important", SqlDbType.Bit)                
            };
            param[0].Value = (int)this.Session["USER_ID"];
            param[1].Value = this.TextBoxText.Text;
            param[2].IsNullable = true;
            DateTime dt;
            if (DateTime.TryParse(this.TextBoxDelDate.Text.Trim(), out dt))
                param[2].Value = dt;
            else
                param[2].Value = DBNull.Value;
            param[3].Value = this.CheckBoxEnabled.Checked;
            param[4].Value = this.CheckBoxImportant.Checked;
            AdoUtils.ExecuteCommand(insert, param);
        }
        else
        {
            // сохранить изменения в сообщении
            string update = "UPDATE [UserMessage] SET [Text]=@Text, [DeleteDate]=@DeleteDate, [Enabled]=@Enabled, [Important]=@Important WHERE [ID]=@ID";
            SqlParameter[] param = 
            {            
                new SqlParameter("@ID", SqlDbType.Int),
                new SqlParameter("@Text", SqlDbType.NVarChar),
                new SqlParameter("@DeleteDate", SqlDbType.SmallDateTime),
                new SqlParameter("@Enabled", SqlDbType.Bit),
                new SqlParameter("@Important", SqlDbType.Bit)                
            };
            param[0].Value = this.MessageID;
            param[1].Value = this.TextBoxText.Text;
            param[2].IsNullable = true;
            DateTime dt;
            if (DateTime.TryParse(this.TextBoxDelDate.Text.Trim(), out dt))
                param[2].Value = dt;
            else
                param[2].Value = DBNull.Value;
            param[3].Value = this.CheckBoxEnabled.Checked;
            param[4].Value = this.CheckBoxImportant.Checked;
            AdoUtils.ExecuteCommand(update, param);
        }
        if (this.Page.IsValid)
            this.Response.Redirect("~/Default.aspx");
    }

    /// <summary>Вадиlатор введённой даты</summary>
    protected void CustomValidatorDate_ServerValidate(object source, ServerValidateEventArgs args)
    {
        DateTime dt;
        args.IsValid = string.IsNullOrEmpty(args.Value.Trim()) ? true : DateTime.TryParse(args.Value, out dt);
    }  
}
