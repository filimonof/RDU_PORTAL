using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Xml;
using System.Text;
using System.IO;

/// <summary>
/// Типы новостных лент
/// должен синхронизироваться с таблицей NewsType
/// </summary>
public enum TypeNewsEnum
{
    /// <summary>RSS лента версия 2.0</summary>
    RSS_2 = 1,

    /// <summary>новости с сайта ОДУ СВ версия 1.0 на 2010 год</summary>
    NewsODUSV_1 = 2,

    /// <summary>новости о погоде с сайта yandex.ru версия 1.0 на 2010 год</summary>
    WeatherYandex_1 = 3
}

/// <summary>
/// Тип новостей 
/// </summary>
public static class TypeNews
{
    
    /// <summary>папка с кэшем новостей</summary>
    public const string DIR_CACHE_NEWS = @"~/cache/News";

    /// <summary>загрузка новостных лент</summary>
    /// <param name="link">ссылка на файл в интернете</param>
    /// <param name="filename">файл сохранённый локально в кэше</param>
    /// <param name="type">тип новостной ленты</param>
    public static void DownloadNews(string link, string filename, TypeNewsEnum type)
    {
        //проверка существования директории с кэшем новостей
        TypeNews.TestDirectory();

        try
        {
            switch (type)
            {
                case (TypeNewsEnum.RSS_2):
                    LoadData.DownloadFile(link, filename);
                    RSS.ClearTags(filename);
                    break;
                case (TypeNewsEnum.NewsODUSV_1):
                    TypeNews.ParseOdusv1(link, filename);
                    break;
                case (TypeNewsEnum.WeatherYandex_1):
                    TypeNews.ParseWeatherYandex1(link, filename);
                    break;
            }
        }
        catch (Exception e)
        {
            Log.ToFile(LogEnum.Error, "TypeNews.DownloadNews -> Ошибка в загрузке новостей \n " + e.Message);
        }
    }

    /// <summary>проверка существования директории с кэшем новостей</summary>
    public static void TestDirectory()
    {
        string localname = HttpContext.Current.Server.MapPath(TypeNews.DIR_CACHE_NEWS);
        if (!Directory.Exists(localname))
            Directory.CreateDirectory(localname);
    }

    /// <summary>парсинг новостного сайта ОДУ СВ и сохранение его RSS локально</summary>
    /// <param name="link">ссылка на новости в интернет</param>
    /// <param name="filename">имя локального файла в кэше</param>
    public static void ParseOdusv1(string link, string filename)
    {
        try
        {
            //список новостей
            List<RSSItem> itemNews = new List<RSSItem>();

            //получаем страницу, кодировка сайта ОДУ СВ -> Windows-1251
            string page = LoadData.DownloadPage(link, Encoding.GetEncoding("Windows-1251"));

            /* взять содержимое из page:
            <!--begin ВЕСЬ КОНТЕНТ-->
              ....         
            <!--end ВСЕГО КОНТЕНТА-->
            */
            string news_src = StringUtils.GetStringBetween(page, "<!--begin ВЕСЬ КОНТЕНТ-->", false, "<!--end ВСЕГО КОНТЕНТА-->", false);
            /*
             каждая новость в списке news_src :
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="15">&nbsp;</td>
                    <td >
                        <div align="left" align="top" class="txt14">
                            <span class="date">11 марта 2010</span><br>

                            <b><a href="/news/about.php?id=406" class="a-main" ><b>Открытый запрос предложений </b></a></b>
                        </div>
                        <div >на право заключения Договора на оказание услуг по уборке помещений и прилегающей территории, хозяйственное обслуживание помещений для нужд Филиала ОАО «СО ЕЭС» Чувашское РДУ<br><a href="/news/about.php?id=406" class="a-main" >подробнее&nbsp;&gt;&gt;&gt;</a></div>
                    </td>
                </tr>
            </table><br>
            */

            //выделяем таблицу с новостью       
            MatchCollection matches_table = Regex.Matches(news_src, "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">(?<table>.*?)</table>", RegexOptions.IgnoreCase | RegexOptions.ExplicitCapture | RegexOptions.Singleline);
            foreach (Match match_table in matches_table)
            {
                RSSItem item = new RSSItem();

                string table_one_news = match_table.Groups["table"].Value;

                // получение даты
                Regex reg_date = new Regex("<span class=\"date\">(?<pubDate>.*?)</span>", RegexOptions.IgnoreCase);
                item.PubDate = reg_date.IsMatch(table_one_news) ?
                    reg_date.Matches(table_one_news)[0].Groups["pubDate"].Value :
                    string.Empty;
                // получение ссылки
                Regex reg_link = new Regex("<a href=\"(?<link>.*?)\" class=\"a-main\"", RegexOptions.IgnoreCase);
                item.Link = reg_link.IsMatch(table_one_news) ?
                    reg_link.Matches(table_one_news)[0].Groups["link"].Value :
                    string.Empty;
                const string START_NEWS = "/news";
                if (item.Link.StartsWith(START_NEWS))
                    item.Link = item.Link.Remove(0, START_NEWS.Length);
                if (link.EndsWith("/") && item.Link.StartsWith("/"))
                    item.Link = item.Link.Remove(0, "/".Length);
                item.Link = link + item.Link;
                // получение заголовка
                Regex reg_title = new Regex("class=\"a-main\" ><b>(?<title>.*?)</b>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
                item.Title = reg_title.IsMatch(table_one_news) ?
                    reg_title.Matches(table_one_news)[0].Groups["title"].Value :
                    string.Empty;
                // получение описания
                Regex reg_description = new Regex("<div >(?<description>.*?)<a href=", RegexOptions.IgnoreCase | RegexOptions.Singleline);
                item.Description = reg_description.IsMatch(table_one_news) ?
                    reg_description.Matches(table_one_news)[0].Groups["description"].Value :
                    string.Empty;

                //очистить от HTML тегов и пробельный символов в начале и конце (Trim)
                item.Description = RSS.ClearHtmlTag(item.Description);
                item.Title = RSS.ClearHtmlTag(item.Title);
                item.PubDate = RSS.ClearHtmlTag(item.PubDate);
                item.Link = RSS.ClearHtmlTag(item.Link);

                itemNews.Add(item);
            }

            //записать в xml(rss) данные
            if (itemNews.Count > 0)
                RSS.CreateRSS(filename, Encoding.UTF8, "Новости с сайта ОДУ Средней Волги", link, "Новостная лента ОДУ Средней Волги", itemNews);
        }
        catch (Exception e)
        {
            throw new Exception("TypeNews.ParseOdusv1 -> Ошибка в парсинге новостей ОДУ СВ 1 \n " + e.Message);
        }
    }

    /// <summary>парсинг сайта Yandex погода</summary>
    /// <param name="link">ссылка на страницу с погодой</param>
    /// <param name="filename">имя локального файла в кэше</param>
    public static void ParseWeatherYandex1(string link, string filename)
    {
        try
        {
            //получаем страницу, кодировка сайта ОДУ СВ -> Utf8
            string page = LoadData.DownloadPage(link, Encoding.UTF8);

            /* взять содержимое из page:
            <table class="b-forecast-details">
            ....                 
            <div class="b-page speeddial">

            <ul class="b-foot b-foot_4columns b-foot_weather">
            заголовок таблицы  <table class="b-forecast-details"> оставляем
            */

            string weather_src = StringUtils.GetStringBetween(page, "<table class=\"b-forecast-details\">", true, "<div class=\"b-page speeddial\">", false);

            if (weather_src == string.Empty)


                //удаляем последний </div>
                weather_src = weather_src.Substring(0, weather_src.LastIndexOf("</div>"));

            weather_src = weather_src.Trim();

            //подменить ссылки на картинки
            weather_src = weather_src.Replace("//i.yandex.st/weather/i/", HttpContext.Current.Request.ApplicationPath + "images/YandexWeather/");

            //создаём одну новость в ленте
            List<RSSItem> itemNews = new List<RSSItem>();
            itemNews.Add(new RSSItem("Прогноз погоды в Саранске", link, DateTime.Now.ToString(), weather_src));

            //сохранить RSS  ленту на диске
            RSS.CreateRSS(filename, Encoding.UTF8, "Погода от Yandex", link, "Погода от Yandex", itemNews);
        }
        catch (Exception e)
        {
            throw new Exception("TypeNews.ParseWeatherYandex1 -> Ошибка в парсинге погоды Яндекса 1 \n " + e.Message);
        }
    }
}

