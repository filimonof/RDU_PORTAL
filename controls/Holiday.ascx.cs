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

public partial class controls_Holiday : System.Web.UI.UserControl
{
    /// <summary>загрузка компоненты</summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        this.CreateHoliday();
    }

    /// <summary>Создать таблицу с праздниками</summary>
    private void CreateHoliday()
    {
        string select = "SELECT * FROM dbo.HolidayAndBirthday(@Date, @Pred, @Next, @Min) AS tbl ORDER BY Date";
        SqlParameter[] param = { 
            new SqlParameter("@Date", SqlDbType.SmallDateTime), 
            new SqlParameter("@Pred", SqlDbType.Int),
            new SqlParameter("@Next", SqlDbType.Int),
            new SqlParameter("@Min",  SqlDbType.Int) 
        };
        param[0].Value = DateTime.Today;
        param[1].Value = 2;
        param[2].Value = 7;    //todo : потом вбить в настройки
        param[3].Value = 4;    // от сёдня-2 до сёдня+7 но не менее 4        
        SqlDataReader reader = AdoUtils.CreateSqlDataReader(select, param);
        if (reader.HasRows)
        {
            while (reader.Read())
            {
                string comment = string.Format("{0}<br />{1}<br />{2}&nbsp;{3}<br />{4}",
                    (bool)reader["IsUser"] ? ((bool)reader["IsRoundedDay"] ? "Юбилей" : "ДР") : string.Empty,
                    (string)reader["Name"],
                    ((DateTime)reader["Date"]).Day,
                    DateUtils.MonthToRusRp(((DateTime)reader["Date"]).Month).ToLower(),
                    DateUtils.DayOfWeekToRus(((DateTime)reader["Date"]).DayOfWeek).ToLower()
                );
                string foto = string.Format("~/{0}.ashx?type=holiday&id={1}", (bool)reader["IsUser"] ? "UserFoto" : "Img", (int)reader["ID"]);
                bool isHappy = (DateTime)reader["Date"] <= DateTime.Today && (bool)reader["IsUser"];
                this.AddRowHoliday(comment, foto, string.Empty, isHappy);
            }
        }
        reader.Close();
    }

    /// <summary>добавить строку с праздником</summary>
    /// <param name="text">текст с данными поздравления</param>
    /// <param name="link">ссылка на картинку</param>
    /// <param name="alt">подпись картинки</param>
    /// <param name="isHappy">отметить поздравлением</param>
    private void AddRowHoliday(string text, string link, string alt, bool isHappy)
    {
        TableRow row = new TableRow();

        TableCell cellName = new TableCell();
        cellName.CssClass = "happy_table_text font_small color_yellow";
        if (isHappy) cellName.CssClass += " happy_table_img";
        cellName.Text = text;

        TableCell cellImg = new TableCell();
        cellImg.CssClass = "happy_table_user";
        cellImg.Style.Add("width", "90px;");

        Image img = new Image();
        img.CssClass = "user_img";
        img.Height = 90;
        img.Width = 80;
        img.BorderWidth = 1;
        img.AlternateText = alt;
        img.ImageUrl = link;

        cellImg.Controls.Add(img);
        row.Controls.Add(cellName);
        row.Controls.Add(cellImg);
        this.TableHoliday.Rows.Add(row);
        
        #region дизайн праздников
        /*<table cellspacing="0" cellpadding="0" width="100%" border="0" class="happy_table">
            <tr>
                <td class="happy_table_text font_small color_yellow">
                    ДР<br />
                    Ярлушкина И.Ю.
                    <br />
                    29 августа
                    <br />
                    среда</td>
                <td class="happy_table_user" style="width: 90px;">
                    <img src="images/user_YarlushkinaIU.jpg" class="user_img" height="90" width="80"
                        alt="Ярлушкина И.Ю." /></td></tr>
            <tr>
                <td class="happy_table_text font_small color_yellow">
                    Юбилей<br />
                    Курылёв А.В.
                    <br />
                    30 августа
                    <br />
                    воскресенье</td>
                <td class="happy_table_user" style="width: 90px;">
                    <img src="images/user_KurilevAV.jpg" class="user_img" height="90" width="80" alt="Курылёв А.В." /></td></tr>
            <tr>
                <td class="happy_table_text font_small color_yellow">
                    День знаний<br />
                    1 сентября
                    <br />
                    понедельник</td>
                <td class="happy_table_user" style="width: 90px;">
                    <img src="images/happy_0109.jpg" class="user_img" height="90" width="80" alt="1 Сентября" /></td></tr></table>--%>
         */
        #endregion
    }
}
