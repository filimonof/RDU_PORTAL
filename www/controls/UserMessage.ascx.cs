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

public partial class controls_UserMessage : System.Web.UI.UserControl
{
    /// <summary>загрузка компоненты</summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        this.CreateTableMessages();
    }

    /// <summary>Создать таблицу с сообщениями</summary>
    private void CreateTableMessages()
    {
        int currentUserID = (int)this.Session["USER_ID"];
        bool isAdmin = Rule.IsAccess(currentUserID, RuleEnum.Admin);

        string select = "SELECT * FROM [UserMessage] WHERE Enabled = 1 AND ([DeleteDate] >= @CurentDate OR [DeleteDate] IS NULL) ORDER BY [Important] DESC, [CreateDate] DESC";
        SqlParameter[] param = { new SqlParameter("@CurentDate", SqlDbType.SmallDateTime) };
        param[0].Value = DateTime.Today;
        SqlDataReader reader = AdoUtils.CreateSqlDataReader(select, param);
        if (reader.HasRows)
        {
            while (reader.Read())
            {
                int userID = (int)reader["UserID"];
                Contact contact = new Contact(userID);
                this.AddOneMessages(
                    (int)reader["ID"],
                    (string)reader["Text"],              //todo : можно проверить на запрещенные символы
                    Contact.GetPostName(contact.PostID, false) + "<br />" + contact.FIO, //todo : сделать проверку на контактную информацию
                    Contact.Link(contact.ID, false), 
                    string.Empty,                        //alt = пустой
                    isAdmin || userID == currentUserID,  //редактировать можно админу или хозяину сообщения
                    (bool)reader["Important"]
                    );
            }
        }
        reader.Close();
    }

    /// <summary>добавить строку с сообщением в таблицу</summary>
    /// <param name="idMsg">ID сообщения</param>
    /// <param name="text">текст с данными поздравления</param>
    /// <param name="nameUser">должность и имя человека</param>
    /// <param name="linkFoto">ссылка на картинку</param>
    /// <param name="altFoto">подпись картинки</param>
    /// <param name="isEdit">разрешение на редактирование</param>
    /// <param name="isImportant">важность сообщения</param>
    private void AddOneMessages(int idMsg, string text, string nameUser, string linkFoto, string altFoto, bool isEdit, bool isImportant)
    {
        TableRow rowGlobal = new TableRow();
        TableCell cellGlobal = new TableCell();

        #region Верхняя полоса окна с сообщением
        const string HTML_MSG_LINE_UP = @" 
            <table cellspacing='0' cellpadding='0' width='100%' border='0'>
                <tr>
                    <td class='msgmenu_top_left' style='width: 5px;'>
                        <img src='images/spacer.gif' width='1' height='5' alt='' /></td>
                    <td class='msgmenu_top_background'>
                        <img src='images/spacer.gif' width='1' height='5' alt='' /></td>
                    <td class='msgmenu_top_right' style='width: 5px;'>
                        <img src='images/spacer.gif' width='1' height='5' alt='' /></td></tr></table>";
        Label labelLineUp = new Label();
        labelLineUp.Text = HTML_MSG_LINE_UP;
        cellGlobal.Controls.Add(labelLineUp);
        #endregion

        #region tableMessage - Текст сообщения
        /*
        <table cellspacing='0' cellpadding='0' width='100%' border='0'>
            <tr>
                <td class='msgmenu_workspace font_standart color_dark' >
                    {0}
                </td></tr></table>
        */
        Table tableMessage = new Table();
        tableMessage.CellPadding = 0;
        tableMessage.CellSpacing = 0;
        tableMessage.BorderWidth = 0;
        tableMessage.Style.Add("width", "100%;");

        TableRow rowMessage = new TableRow();

        TableCell cellMessage = new TableCell();
        cellMessage.CssClass = "msgmenu_workspace font_standart color_dark";
        if (isImportant)
        {
            Image imgImportant = new Image();
            imgImportant.CssClass = "msgmenu_img_important";
            imgImportant.ImageUrl = "~/images/Important.gif";
            cellMessage.Controls.Add(imgImportant);
        }
        Label labelMsg = new Label();
        labelMsg.Text = controls_UserMessage.ParseMsgToOutput(text);
        //todo : сдесь сделать парсинг вывода текста сообщения
        cellMessage.Controls.Add(labelMsg);

        rowMessage.Controls.Add(cellMessage);
        tableMessage.Controls.Add(rowMessage);
        cellGlobal.Controls.Add(tableMessage);
        #endregion

        #region Нижняя полоса окна с сообщением
        const string HTML_MSG_LINE_DOWN = @" 
            <table cellspacing='0' cellpadding='0' width='100%' border='0'>
                <tr>
                    <td class='msgmenu_bottom_left' style='height: 15px; width: 5px;'>
                        <img src='images/spacer.gif' width='5' height='15' alt='' /></td>
                    <td class='msgmenu_bottom_background' style='height: 15px;'>
                        <img src='images/spacer.gif' width='1' height='15' alt='' /></td>
                    <td class='msgmenu_corner_1' style='height: 15px; width: 72px;'>
                        <img src='images/spacer.gif' width='72' height='15' alt='' /></td>
                    <td class='msgmenu_bottom_background' style='height: 15px; width: 89px;'>
                        <img src='images/spacer.gif' width='89' height='15' alt='' /></td>
                    <td class='msgmenu_bottom_right' style='height: 15px; width: 5px;'>
                        <img src='images/spacer.gif' width='5' height='15' alt='' /></td></tr></table>";
        Label labelLineDown = new Label();
        labelLineDown.Text = HTML_MSG_LINE_DOWN;
        cellGlobal.Controls.Add(labelLineDown);
        #endregion

        #region tableFotter - нижняя часть сообщения - пользователь и фото
        /*
        <table cellspacing='0' cellpadding='0' width='100%' border='0'>
            <tr>
                <td class='msgmenu_corner_2 font_standart color_dark' style='height: 94px' valign='bottom' align='right'>
                    {4}<br/><br/>{1}
                </td>
                <td style='width: 94px; height: 96px;' valign='bottom' align='right'>
                    <img src='{2}' class='user_img' height='90' width='80' alt='{3}' /></td></tr></table>
        */
        Table tableFotter = new Table();
        tableFotter.CellPadding = 0;
        tableFotter.CellSpacing = 0;
        tableFotter.BorderWidth = 0;
        tableFotter.Style.Add("width", "100%;");

        TableRow rowFotter = new TableRow();

        TableCell cellFotterComment = new TableCell();
        cellFotterComment.CssClass = "msgmenu_corner_2 font_standart color_dark";
        cellFotterComment.Height = 94;
        cellFotterComment.VerticalAlign = VerticalAlign.Bottom;
        cellFotterComment.HorizontalAlign = HorizontalAlign.Right;
        if (isEdit)
        {
            Panel panelEdit = new Panel();
            panelEdit.CssClass = "font_standart color_blue";
            Image imgEdit = new Image();
            imgEdit.CssClass = "img_16_caption";
            imgEdit.ImageUrl = "~/images/message_edit.png";
            panelEdit.Controls.Add(imgEdit);
            LinkButton linkEdit = new LinkButton();
            linkEdit.Text = "редактировать объявление";
            linkEdit.PostBackUrl = string.Format("~/EditMessage.aspx?id={0}", idMsg);
            panelEdit.Controls.Add(linkEdit);
            cellFotterComment.Controls.Add(panelEdit);
            Label br = new Label();
            br.Text = "<br  />";
            cellFotterComment.Controls.Add(br);
        }
        Label labelNameUser = new Label();
        labelNameUser.Text = nameUser;
        cellFotterComment.Controls.Add(labelNameUser);
        rowFotter.Controls.Add(cellFotterComment);

        TableCell cellFotterFoto = new TableCell();
        cellFotterFoto.Width = 94;
        cellFotterFoto.Height = 96;
        cellFotterFoto.VerticalAlign = VerticalAlign.Bottom;
        cellFotterFoto.HorizontalAlign = HorizontalAlign.Right;
        Image imgUser = new Image();
        imgUser.ImageUrl = linkFoto;
        imgUser.CssClass = "user_img";
        imgUser.Height = 90;
        imgUser.Width = 80;
        imgUser.AlternateText = altFoto;
        imgUser.BorderWidth = 1;
        cellFotterFoto.Controls.Add(imgUser);

        rowFotter.Controls.Add(cellFotterFoto);
        tableFotter.Controls.Add(rowFotter);
        cellGlobal.Controls.Add(tableFotter);
        #endregion

        Label brMsg = new Label();
        brMsg.Text = "<br  />";
        cellGlobal.Controls.Add(brMsg);

        rowGlobal.Controls.Add(cellGlobal);
        this.TableMessages.Rows.Add(rowGlobal);
    }

    /// <summary>замена спецсимволов на теги в сообщениях пользователя</summary>
    /// <param name="msg">сообщение с спецсимволами</param>
    /// <returns>проебразованное сообщение с тэгами</returns>
    public static string ParseMsgToOutput(string msg)
    { 
        //todo : объединить с такой же функцией в администрировании
        //return msg.Replace("\n", "<br />").Replace("  ", "&nbsp;&nbsp;");
        return msg.Replace("\n", "<br />").Replace("  ", "&nbsp;&nbsp;").Replace("[href]","<a href=").Replace("[/href]", ">ссылка</a>");
    }
}
