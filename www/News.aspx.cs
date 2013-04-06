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

public partial class News : System.Web.UI.Page
{

    #region полезные ссылки и rss
    /*
        СО-ЦДУ http://www.so-ups.ru/index.php?id=subscribe
        ссылки http://www.odusv.so-cdu.ru/links.html
        СО-ЦДУ http://www.cdo.ups.ru/newsso/            
        ОДУ СВ http://www.odusv.so-cdu.ru/news/
        Министерство энергетики http://www.minenergo.gov.ru/
       
        новости энергетики
        http://vklyakse.ru/?feed=rss2
        http://elmagazine.ru/feed
      
        комсомольская правда  http://www.kp.ru/rss.xml
        http://www.kp.ru/daily/00000/529958/
        Ежедневная интернет-газета. Новости со всего мира на русском языке http://lenta.ru/rss/
        yandex rss http://news.yandex.ru/export.html
        столица с  http://xml.feedcat.net/94223
        info-rm  http://www.info-rm.info/rss/
        http://news.mail.ru/rss/main/
        взгляд http://vz.ru/rss.xml
        Агентство русской информации. Новости http://ariru.info/rss.xml
        правда http://www.pravda.ru/export/
     
        футбол на куличках http://football.kulichki.net/news.rss
        спорт экспресс http://www.sport-express.ru/rss/
     
        погода http://www.gismeteo.ru/city/legacy/?city=4401&amp;shift=0&amp;print=1
        погода http://www.gismeteo.ru/city/legacy/?city=4401&amp;shift=3&amp;print=1
     * http://pogoda.yandex.ru/27760/details/#print
     * http://m.weather.yandex.ru/index.xml?rnd=75&mode=short
     * 
     * http://www.hmn.ru/index.php?index=52&value=27760
     * http://meteoinfo.ru/forecasts5000/russia/republic-mordovia/print
    */
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        this.Page.Title += " - Новости";

        this.ButtonLoadNews.Visible = Rule.IsAccess((int)this.Session["USER_ID"], RuleEnum.AdmNews);

        this.XmlDataSourcePublicationsTitle.Data = "<rss><channel><title>Не настроены новостные ленты</title></channel></rss>";
        this.XmlDataSourcePublications.Data = "<rss></rss>";

        if (!this.IsPostBack)
        {
            if (this.DataListNews.Items.Count > 0)
            {
                this.DataListNews.SelectedIndex = 0;
                this.DataListNews.DataBind();
            }
                        
            int news;
            if (this.DataListNews.SelectedValue != null && int.TryParse(this.DataListNews.SelectedValue.ToString(), out news)) 
                this.CreateListPublication(news);
        }
    }

    /// <summary>выбор новостного канала</summary>
    protected void DataListNews_ItemCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListNews.SelectedIndex = e.Item.ItemIndex;
        int newsID;
        if (int.TryParse(e.CommandArgument.ToString(), out newsID))
            this.CreateListPublication(newsID);
        this.DataListNews.DataBind();
    }

    /// <summary>Создание списка новостей новостного канала newsID</summary>
    /// <param name="newsID">ID новостного канала</param>
    private void CreateListPublication(int newsID)
    {        
        string filename = System.IO.Path.Combine(TypeNews.DIR_CACHE_NEWS, newsID + ".rss");
        //string filename = string.Format(@"~\cache\News\{0}.rss", newsID);
        string filename_abs = HttpContext.Current.Server.MapPath(filename);
        if (System.IO.File.Exists(filename_abs))
        {
            this.XmlDataSourcePublicationsTitle.DataFile = filename;
            this.XmlDataSourcePublications.DataFile = filename;
        }
        else
        {
            this.XmlDataSourcePublicationsTitle.Data = "<rss><channel><title>Не загружен новостной файл</title></channel></rss>";
            this.XmlDataSourcePublications.Data = "<rss></rss>";
        }

        try
        {            
            this.DataBind();
        }
        catch
        {
            // если файл RSS глючный, или какаядругая ошибка
            this.XmlDataSourcePublicationsTitle.DataFile = string.Empty;
            this.XmlDataSourcePublications.DataFile = string.Empty;
            this.XmlDataSourcePublicationsTitle.Data = "<rss><channel><title>Ошибка при отображении новостного файла</title></channel></rss>";
            this.XmlDataSourcePublications.Data = "<rss></rss>";
            this.RepeaterPublicationTitle.DataBind();
            this.DataListPublications.DataBind();
        }
    }

    /// <summary>Преобразование даты из RSS в полную русскоязычную</summary>
    /// <param name="pubDate">дата</param>
    /// <returns>строка с полной датой</returns>
    protected static string PubDateConvert(object pubDate)
    {        
        if (pubDate != null)
        {
            DateTime dt;
            if (DateTime.TryParse(pubDate.ToString(), out dt))
            {
                if (dt.Hour == 0 && dt.Minute == 0 && dt.Second == 0)
                    //дата без времени 9 марта 2010 г
                    return dt.ToLongDateString();
                else // полный формат даты  9 марта 2010 г. 14:40:39 
                    return dt.ToString("F");
            }
            else //если неможем распознать как дату то выводим что есть
                return pubDate.ToString();
        }
        else //если нет тега то выводим пустоту
            return string.Empty;
    }

    /// <summary>кнопка загрузки новостей</summary>
    protected void ButtonLoad_Click(object sender, EventArgs e)
    {
        if (Rule.IsAccess((int)this.Session["USER_ID"], RuleEnum.AdmNews))
        {
            this.LoadNews();

            int news;
            if (this.DataListNews.SelectedValue != null && int.TryParse(this.DataListNews.SelectedValue.ToString(), out news))
                this.CreateListPublication(news);
        }
    }

    /// <summary>Загрузка новостей из интернета</summary>
    private void LoadNews()
    {
        string select = "SELECT * FROM [NewsTitle] WHERE Enabled = 1 ORDER BY [Order] ";
        SqlDataReader reader = AdoUtils.CreateSqlDataReader(select);
        if (reader.HasRows)
        {
            while (reader.Read())
            {
                string filename = System.IO.Path.Combine(TypeNews.DIR_CACHE_NEWS, reader["ID"].ToString() + ".rss");                
                TypeNews.DownloadNews((string)reader["Link"], filename, (TypeNewsEnum)reader["TypeID"]);
            }
        }
        reader.Close();
    }

}
