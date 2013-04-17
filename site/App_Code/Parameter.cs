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

/// <summary>
/// Параметры и константы
/// </summary>
public class Parameter
{
    /// <summary>разделитель в строковый массивах</summary>
    public const char SPLITTER_STRING_ARRAY = ';';

    /// <summary>разрешённые расширения картинок</summary>
    public const string EXTENSION_ICON = "jpeg;jpg;png;gif";

    /// <summary>сколько дней документ считается новым</summary>
    public const int DAY_NEW_DOC = 6;

    /// <summary>конструктор</summary>
	public Parameter()
	{
	}
}
