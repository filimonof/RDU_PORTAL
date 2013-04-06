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
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Text.RegularExpressions;

/// <summary>
/// Структура записи RSS ленты
/// </summary>
public struct RSSItem
{
    /// <summary>заголовок</summary>
    public string Title { get; set; }

    /// <summary>ссылка</summary>
    public string Link { get; set; }

    /// <summary>дата</summary>
    public string PubDate { get; set; }

    /// <summary>описание</summary>
    public string Description { get; set; }

    /// <summary>конструктор</summary>
    /// <param name="title">заголовок</param>
    /// <param name="link">ссылка</param>
    /// <param name="pubdate">дата</param>
    /// <param name="description">описание</param> 
    public RSSItem(string title, string link, string pubdate, string description)
        : this()
    {
        this.Title = title;
        this.Link = link;
        this.PubDate = pubdate;
        this.Description = description;
    }
}

/// <summary>
/// Класс для работы с RSS лентами
/// </summary>
public class RSS
{
    /// <summary>конструктор</summary>
    public RSS()
    {
    }

    /// <summary>Создание RSS файла</summary>
    /// <param name="filename">имя файла</param>
    /// <param name="encoding">кодировка</param>
    /// <param name="title">заголовок ленты</param>
    /// <param name="link">ссылка ленты на сайт</param>
    /// <param name="description">описание</param>
    /// <param name="itemsNews">список новостей</param>
    public static void CreateRSS(string filename, Encoding encoding, string title, string link, string description, List<RSSItem> itemsNews)
    {
        string localname = HttpContext.Current.Server.MapPath(filename);
        XmlTextWriter wr = new XmlTextWriter(localname, encoding);
        wr.WriteStartDocument();

        wr.WriteStartElement("rss");
        wr.WriteAttributeString("version", "2.0");
        wr.WriteStartElement("channel");
        wr.WriteElementString("title", title);
        wr.WriteElementString("link", link);
        wr.WriteElementString("description", description);

        foreach (RSSItem item in itemsNews)
        {
            wr.WriteStartElement("item");
            wr.WriteElementString("title", item.Title);
            wr.WriteElementString("link", item.Link);
            wr.WriteElementString("description", item.Description);
            wr.WriteElementString("pubDate", item.PubDate);
            wr.WriteEndElement(); //item
        }

        wr.WriteEndElement(); //channel
        wr.WriteEndElement(); // rss

        wr.WriteEndDocument();

        wr.Flush();
        wr.Close();
    }

    /// <summary>Очистка RSS ленты от HTML тэгов</summary>
    /// <param name="filename">файл с RSS лентой</param>
    public static void ClearTags(string filename)
    {
        string localname = HttpContext.Current.Server.MapPath(filename);
        if (!System.IO.File.Exists(localname))
            return;

        XmlDocument xmlDoc = new XmlDocument();
        xmlDoc.Load(localname);

        XmlNode nodeCaption = xmlDoc.SelectNodes("/rss/channel")[0];
        if (nodeCaption.SelectSingleNode("title") != null)
            nodeCaption.SelectSingleNode("title").InnerText = RSS.ClearHtmlTag(nodeCaption.SelectSingleNode("title").InnerText);
        if (nodeCaption.SelectSingleNode("link") != null)
            nodeCaption.SelectSingleNode("link").InnerText = RSS.ClearHtmlTag(nodeCaption.SelectSingleNode("link").InnerText);
        if (nodeCaption.SelectSingleNode("description") != null)
            nodeCaption.SelectSingleNode("description").InnerText = RSS.ClearHtmlTag(nodeCaption.SelectSingleNode("description").InnerText);

        XmlNodeList nodeList = xmlDoc.SelectNodes("/rss/channel/item");
        foreach (XmlNode node in nodeList)
        {
            if (node.SelectSingleNode("title") != null)
                node.SelectSingleNode("title").InnerText = RSS.ClearHtmlTag(node.SelectSingleNode("title").InnerText);

            if (node.SelectSingleNode("description") != null)
                node.SelectSingleNode("description").InnerText = RSS.ClearHtmlTag(node.SelectSingleNode("description").InnerText);

            if (node.SelectSingleNode("link") != null)
                node.SelectSingleNode("link").InnerText = RSS.ClearHtmlTag(node.SelectSingleNode("link").InnerText);

            if (node.SelectSingleNode("pubDate") != null)
                node.SelectSingleNode("pubDate").InnerText = RSS.ClearHtmlTag(node.SelectSingleNode("pubDate").InnerText);
        }
        xmlDoc.Save(localname);
        xmlDoc.Clone();
    }

    /// <summary>Очистка строки от html тэгов и пробелов в начале и конце</summary>
    /// <param name="text">первоначальный текст</param>
    /// <returns>очищенный текст</returns>
    public static string ClearHtmlTag(object text)
    {
        return Regex.Replace(text.ToString(), @"<[/!?]?\w[^>]*>", String.Empty).Trim();
        /* 
        Regex.Replace(textWithHtmlTags, @"<[^>]+>", String.Empty);
        Regex r = new Regex("<[^>]*>", RegexOptions.Multiline);         
        Regex.Replace(text, "<(.|\n)*?>", string.Empty, RegexOptions.IgnoreCase);
        */ 
    }

}
