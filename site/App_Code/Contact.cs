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
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Text;
using System.Xml;
using System.IO;


/// <summary>
/// Типы контактной информации
/// должен синхронизироваться с таблицей ContactType
/// </summary>
public enum TypeContactEnum
{
    /// <summary>Контактная информация сайта</summary>
    LocalContact = 1,

    /// <summary>Контакты с сайта ЦДУ раздел исполнительного аппарата</summary>
    UPSv1 = 2,

    /// <summary>Контакты с сайта ЦДУ разделы ОДУ и РДУ</summary>
    UPSv2 = 3,

    /// <summary>Файл</summary>
    File = 4,

    /// <summary>Excel-файл версия 1</summary>
    XLSv1 = 5

}

/// <summary>
/// Работа с контактами и контактной информацией
/// </summary>
public class Contact
{
    /// <summary>тип пользователя - пользователь</summary>
    private const string TYPEUSER_USER = "Пользователь";
    /// <summary>тип пользователя - иной контакт</summary>
    private const string TYPEUSER_OTHER = "Иной контакт";

    /// <summary>папка с кэшем контактов</summary>
    public const string DIR_CACHE_CONTACT = @"~/cache/Contact";

    /// <summary>true - есть контактные данные</summary>
    public bool HasContact { get; private set; }

    #region  поля с данными

    /// <summary>ID</summary>
    public int ID { get; private set; }

    /// <summary>тип true-человек, false-иной</summary>
    public bool UserType { get; private set; }

    /// <summary>фамилия</summary>
    public string Family { get; private set; }

    /// <summary>имя</summary>
    public string FirstName { get; private set; }

    /// <summary>отчество</summary>
    public string LastName { get; private set; }

    /// <summary>День рождения</summary>
    public DateTime? BirthDay { get; private set; }

    /// <summary>Телефон</summary>
    public string Phone { get; private set; }

    /// <summary>мыло</summary>
    public string Email { get; private set; }

    /// <summary>активно</summary>
    public bool Enabled { get; private set; }

    /// <summary>подразделение</summary>
    public int? DepartamentID { get; private set; }

    /// <summary>должность</summary>
    public int? PostID { get; private set; }

    /// <summary>ID в таблице пользователей (аунтентификации)</summary>
    public int? UserID { get; private set; }

    #endregion

    /// <summary>обращение к пользователю</summary>    
    public string Name
    {
        get
        {
            if (this.UserType) //если человек
                return this.FirstName + " " + this.LastName;
            else
                return this.Family;
        }
    }

    /// <summary>Фамилия И.О.</summary>    
    public string FIO
    {
        get
        {
            if (this.UserType) //если человек                
                return this.Family.Trim() + " " + this.FirstName.Trim().Substring(0, 1) + "." + this.LastName.Trim().Substring(0, 1) + ".";
            else
                return this.Family;
        }
    }

    /// <summary>конструктор с инициализацией данных из базы</summary>
    /// <param name="userID">ID пользователя</param>
    public Contact(int userID)
    {
        //todo: убрать Image из запроса или может оставить? 
        string select = string.Format("SELECT TOP 1 * FROM [Contact] WHERE [UserID] = {0} ", userID);
        SqlDataReader reader = AdoUtils.CreateSqlDataReader(select);
        this.HasContact = reader.HasRows;
        if (this.HasContact)
        {
            reader.Read();

            this.ID = (int)reader["ID"];
            this.UserType = (bool)reader["UserType"];
            this.Family = (string)reader["Family"];
            this.FirstName = (string)reader["FirstName"];
            this.LastName = (string)reader["LastName"];
            this.BirthDay = (DateTime?)AdoUtils.DBNullToNull(reader["BirthDay"]);
            this.Phone = (string)reader["Phone"];
            this.Email = (string)reader["Email"];
            this.Enabled = (bool)reader["Enabled"];
            this.DepartamentID = (int?)AdoUtils.DBNullToNull(reader["DepartamentID"]);
            this.PostID = (int?)AdoUtils.DBNullToNull(reader["PostID"]);
            this.UserID = userID;
        }
        reader.Close();
    }

    /// <summary>Значение типа пользователя в строку</summary>
    /// <param name="type">тип пользователя</param>
    /// <returns>строка со значением</returns>
    public static string TypeUserToString(bool type)
    {
        if (type) return Contact.TYPEUSER_USER;
        else return Contact.TYPEUSER_OTHER;
    }

    /// <summary>Получение короткого имени подразделения по ID</summary>
    /// <param name="id">ID записи</param>
    /// <param name="isShortName">короткое имя?</param>
    /// <returns>Короткое имя</returns>
    public static string GetDepartamentName(object id, bool isShortName)
    {
        if (id != DBNull.Value && id != null)
        {
            object obj = AdoUtils.GetParamFromID("Departament", isShortName ? "ShortName" : "Name", (int)id).ToString();
            if (obj == null) return string.Empty;
            else return obj.ToString();
        }
        else return string.Empty;
    }

    /// <summary>Получение имени должности по ID</summary>
    /// <param name="id">ID записи</param>
    /// <param name="isShortName">короткое имя?</param>
    /// <returns>должность</returns>
    public static string GetPostName(object id, bool isShortName)
    {
        if (id != DBNull.Value && id != null)
        {
            object obj = AdoUtils.GetParamFromID("Post", isShortName ? "ShortName" : "Name", (int)id).ToString();
            if (obj == null) return string.Empty;
            else return obj.ToString();
        }
        else return string.Empty;
    }

    /// <summary>Получение доменного имени по ID</summary>
    /// <param name="id">ID записи</param>
    /// <returns>Доменное имя</returns>
    public static string GetUserDomainName(object id)
    {
        if (id != DBNull.Value && id != null)
        {
            object obj = AdoUtils.GetParamFromID("User", "DomainName", (int)id).ToString();
            if (obj == null) return string.Empty;
            else return obj.ToString();
        }
        else return string.Empty;
    }

    /// <summary>Получение строки с сылкой на фото пользователя</summary>
    /// <param name="id">ID пользосателя</param>
    /// <returns>текст с сылкой</returns>
    public static string Link(object id)
    {
        if (AdoUtils.DBNullToNull(id) == null)
            return @"~/UserFoto.ashx";
        else
            return string.Format(@"~/UserFoto.ashx?id={0}", id.ToString());
    }

    /// <summary>Получение строки с сылкой на фото пользователя</summary>
    /// <param name="id">ID пользосателя</param>
    /// <param name="typeID">true - UserID пользователя, false - ID контактной информации</param>
    /// <returns>строка с ссылкой</returns>
    public static string Link(object id, bool typeID)
    {
        if (typeID)
        {
            Contact contact = new Contact((int)id);
            return Contact.Link(contact.ID);            
        }
        else
            return Contact.Link(id);            
    }

    /// <summary>загрузка контактных данных с сайта СО</summary>
    /// <param name="name">название оргинизации</param>
    /// <param name="link">страница с данными</param>
    /// <param name="filename">результирующий файл</param>
    /// <param name="type">тип контактного файла</param>
    /// <param name="description">описание организации</param>
    public static void DownloadContact(string name, string link, string filename, TypeContactEnum type, string description)
    {
        switch (type)
        {
            case (TypeContactEnum.LocalContact):
            case (TypeContactEnum.File):
            case (TypeContactEnum.XLSv1):
                //загружать нечего
                break;
            case (TypeContactEnum.UPSv1):
                Contact.ParseUPSv1(name, link, filename, description);
                break;
            case (TypeContactEnum.UPSv2):
                Contact.ParseUPSv2(name, link, filename, description);
                break;
        }
    }

    /// <summary>проверка существования директории с кэшем контактов</summary>
    public static void TestDirectory()
    {
        string localname = HttpContext.Current.Server.MapPath(Contact.DIR_CACHE_CONTACT);
        if (!Directory.Exists(localname))
            Directory.CreateDirectory(localname);
    }

    /// <summary>парсинг и формирование контактных данных СО</summary>
    /// <param name="name">имя организации</param>
    /// <param name="link">ссылка на страницу</param>
    /// <param name="filename">результирующий файл</param>
    /// <param name="description">описание организации</param>
    public static void ParseUPSv1(string name, string link, string filename, string description)
    {
        //заебался , там в зависимости от подразделения разный формат
        return;
        
        //проверка существования директории с кэшем контактов
        Contact.TestDirectory();

        //получаем страницу, кодировка сайта СО -> KOI8-R        
        string page = LoadData.DownloadPage(link, Encoding.GetEncoding("KOI8-R"));

        string localname = HttpContext.Current.Server.MapPath(filename);
        XmlTextWriter wr = new XmlTextWriter(localname, Encoding.UTF8);
        wr.WriteStartDocument();

        wr.WriteStartElement("SO_Contacts");

        wr.WriteElementString("title", name);
        wr.WriteElementString("link", link);
        wr.WriteElementString("description", description);

        string departament_src = StringUtils.GetStringBetween(page, "Приемные руководителей</a>", false, "Ответственный за оформление служебных командировок</a>", false);

        string server = (new Uri(link)).Host;
        string scheme = (new Uri(link)).Scheme;

        //выделяем подразделения
        // <A CLASS=nav href="/kdr3.nsf/wwwslcdo?OpenView&190">Департамент правового обеспечения</a>
        MatchCollection matches_departament = Regex.Matches(departament_src
            , "<A CLASS=nav href=\"(?<link_dep>.*?)\">(?<name_dep>.*?)</a>"
            , RegexOptions.IgnoreCase | RegexOptions.ExplicitCapture | RegexOptions.Singleline);
        foreach (Match match_dep in matches_departament)
        {
            string link_dep = match_dep.Groups["link_dep"].Value;
            string name_dep = match_dep.Groups["name_dep"].Value;

            //<departament name="">	
            wr.WriteStartElement("departament");
            wr.WriteAttributeString("name", name_dep.Substring(0, 1).ToUpper() + name_dep.Substring(1).ToLower());

            if (!string.IsNullOrEmpty(link_dep))
            {
                //загрузить страницу c подразделениями по линку и выцепить данные
                string pageDep = LoadData.DownloadPage(scheme + @":\\" + server + link_dep, Encoding.GetEncoding("KOI8-R"));
                string departUser_src = StringUtils.GetStringBetween(pageDep, "<TABLE><TR bgcolor=D5D1C4>", false, "</table>", false);
                /* млятство, там данные разные
                <TR valign=top>
                  <TD nowrap>Аюев Борис Ильич&nbsp;
                  <TD nowrap>
                  <FONT color=red>23-00,30-00&nbsp;
                  <TD nowrap>
                  <FONT color=000080>(495)710-51-20 &nbsp;
                  <TD nowrap>
                  <FONT color=000080>(495)625-86-68&nbsp;
                  <TD nowrap>
                  <A CLASS=nav HREF="mailto:abi@so-cdu.ru">abi@so-cdu.ru&nbsp;
                  <TD nowrap>Председатель Правления
                  </a>
                 */
                MatchCollection matches_departament_user = Regex.Matches(departUser_src
                    , @"<TR valign=top>[\s]*<[^>]+>(?<name>[^<]*?)<[^<]+<[^<]+>(?<tel_local>[^<]*?)<[^<]+<[^<]+>(?<tel_u>[^<]*?)<[^<]+<[^>]+>(?<tel_local>[^<]*?)<[^<]+<[^>]+>(?<tel>[^<]*?)<[^<]+<[^>]+>(?<email>[^<]*?)<[^<]+>(?<post>[^<]*?)<[^<]+"
                    //, @"<tr valign=top>[\s]*<[^>]+<[^>]+>(?<name>[^<]*?)<[^<]+"
                    , RegexOptions.IgnoreCase | RegexOptions.ExplicitCapture | RegexOptions.Singleline);
                foreach (Match match_dep_user in matches_departament_user)
                {
                    string user_name = match_dep_user.Groups["name"].Value;
                    string user_email = match_dep_user.Groups["email"].Value;
                    string user_tel_local = match_dep_user.Groups["tel_local"].Value;
                    string user_tel_muse = match_dep_user.Groups["tel_u"].Value;
                    string user_tel = match_dep_user.Groups["tel"].Value;
                    string user_post = match_dep_user.Groups["post"].Value;

                    //запись контакта в xml
                    //<contact name="" email="" tel="" tel_local="" post="" />
                    wr.WriteStartElement("contact");
                    wr.WriteAttributeString("name", user_name);
                    wr.WriteAttributeString("email", user_email);
                    wr.WriteAttributeString("tel", user_tel);
                    wr.WriteAttributeString("tel_local", user_tel_local);
                    wr.WriteAttributeString("tel_muse", user_tel_muse);
                    wr.WriteAttributeString("post", user_post);
                    wr.WriteEndElement(); //contact
                }
            }
            wr.WriteEndElement(); // departament
        }
        wr.WriteEndElement(); // SO_Contacts

        wr.WriteEndDocument();

        wr.Flush();
        wr.Close();
    }

    /// <summary>парсинг и формирование контактных данных ОДУ и РДУ</summary>
    /// <param name="name">имя организации</param>
    /// <param name="link">ссылка на страницу</param>
    /// <param name="filename">результирующий файл</param>
    /// <param name="description">описание организации</param>
    public static void ParseUPSv2(string name, string link, string filename, string description)
    {
        #region цикл записи XML
        /* 
        XmlTextWriter wr = new XmlTextWriter(filename, Encoding.UTF8);
        wr.WriteStartDocument();

        wr.WriteStartElement("RDU_Contacts");        
                
        wr.WriteElementString("title", "title");
        wr.WriteElementString("link", "link");
        wr.WriteElementString("description", "description");

        wr.WriteStartElement("departament");
        wr.WriteElementString("name", "");
        
        {
            wr.WriteStartElement("contact");
            wr.WriteElementString("name", "");
            wr.WriteElementString("email", "");
            wr.WriteElementString("tel", "");
            wr.WriteElementString("tel_local", "");
            wr.WriteElementString("post", ""); 
            wr.WriteEndElement(); //contact
        }

        wr.WriteEndElement(); // departament
        
        wr.WriteEndElement(); // RDU_Contacts

        wr.WriteEndDocument();

        wr.Flush();
        wr.Close();
         */
        #endregion

        //проверка существования директории с кэшем контактов
        Contact.TestDirectory();

        //получаем страницу, кодировка сайта СО -> KOI8-R        
        string page = LoadData.DownloadPage(link, Encoding.GetEncoding("KOI8-R"));

        string localname = HttpContext.Current.Server.MapPath(filename);
        XmlTextWriter wr = new XmlTextWriter(localname, Encoding.UTF8);
        wr.WriteStartDocument();

        wr.WriteStartElement("RDU_Contacts");

        wr.WriteElementString("title", name);
        wr.WriteElementString("link", link);
        wr.WriteElementString("description", description);

        // взять содержимое из page:
        // <TABLE width=100% cols=1 cellpadding=0>
        // ....         
        // <CENTER><HR width=20%></center>
        string departament_src = StringUtils.GetStringBetween(page, "<TABLE width=100% cols=1 cellpadding=0>", false, "<CENTER><HR width=20%></center>", false);

        string server = (new Uri(link)).Host;
        string scheme = (new Uri(link)).Scheme;

        //выделяем подразделения
        // <A href="/elektraNEW.nsf/wwwresult?ReadForm&REJ=4&ORG=@16@06@14@08@06@14@18@11@15@06@00@17@05@20&SOTR=@05@06@07@20@17@14@28@10@00@16@06@17@18@15@14@01@12">ДЕЖУРНЫЙ ПЕРСОНАЛ</a>     
        MatchCollection matches_departament = Regex.Matches(departament_src
            , "<A href=\"(?<link_dep>.*?)\">(?<name_dep>.*?)</a>"
            , RegexOptions.IgnoreCase | RegexOptions.ExplicitCapture | RegexOptions.Singleline);
        foreach (Match match_dep in matches_departament)
        {
            string link_dep = match_dep.Groups["link_dep"].Value;
            string name_dep = match_dep.Groups["name_dep"].Value;

            //<departament name="">	
            wr.WriteStartElement("departament");
            wr.WriteAttributeString("name", name_dep.Substring(0, 1).ToUpper() + name_dep.Substring(1).ToLower());

            if (!string.IsNullOrEmpty(link_dep))
            {
                //загрузить страницу c подразделениями по линку и выцепить данные
                string pageDep = LoadData.DownloadPage(scheme + @":\\" + server + link_dep, Encoding.GetEncoding("KOI8-R"));
                string departUser_src = StringUtils.GetStringBetween(pageDep, "<TABLE width=100% cols=4 cellpadding=0>", false, "<TR bgcolor=D5D1C4>", false);

                /*	парсим вот эту хрень
	               <TR valign=top align=left>
	                  <TD nowrap>имя<FONT size=1>&nbsp;&nbsp;&nbsp;<BR><A href="mailto:sa@ch-rdu.ru">email</a></font></td>
	                  <TD nowrap><FONT color=#000080>тел город</td>
	                  <TD nowrap><FONT color=#FF0000>тел</td>
	                  <TD nowrap><FONT color=#000080>пост</td>
	               </tr>  */
                //<TR valign=top align=left>[\s]*<[^>]+>([^<]*)<[^<]+<BR><[^>]+>([^<]*)<[^<]+<[^<]+<[^<]+<[^<]+<[^>]+>([^<]*)<[^<]+<[^<]+<[^>]+>([^<]*)<[^<]+<[^<]+<[^>]+>([^<]*)
                MatchCollection matches_departament_user = Regex.Matches(departUser_src
                    , @"<TR valign=top align=left>[\s]*<[^>]+>(?<name>[^<]*?)<[^<]+<BR><[^>]+>(?<email>[^<]*?)<[^<]+<[^<]+<[^<]+<[^<]+<[^>]+>(?<tel>[^<]*?)<[^<]+<[^<]+<[^>]+>(?<tel_local>[^<]*?)<[^<]+<[^<]+<[^>]+>(?<post>[^<]*?)<[^<]+"
                    , RegexOptions.IgnoreCase | RegexOptions.ExplicitCapture | RegexOptions.Singleline);
                foreach (Match match_dep_user in matches_departament_user)
                {
                    string user_name = match_dep_user.Groups["name"].Value;
                    string user_email = match_dep_user.Groups["email"].Value;
                    string user_tel_local = match_dep_user.Groups["tel_local"].Value;
                    string user_tel = match_dep_user.Groups["tel"].Value;
                    string user_post = match_dep_user.Groups["post"].Value;

                    //запись контакта в xml
                    //<contact name="" email="" tel="" tel_local="" post="" />
                    wr.WriteStartElement("contact");
                    wr.WriteAttributeString("name", user_name);
                    wr.WriteAttributeString("email", user_email);
                    wr.WriteAttributeString("tel", user_tel);
                    wr.WriteAttributeString("tel_local", user_tel_local);
                    wr.WriteAttributeString("post", user_post);
                    wr.WriteEndElement(); //contact
                }
            }
            wr.WriteEndElement(); // departament
        }
        wr.WriteEndElement(); // RDU_Contacts

        wr.WriteEndDocument();

        wr.Flush();
        wr.Close();
    }
}
