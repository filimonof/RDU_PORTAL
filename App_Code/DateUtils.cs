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
using System.Globalization;

/// <summary>
/// Вспомогательные функции для работы с датами
/// </summary>
public class DateUtils
{

    /// <summary>Название месяцов</summary>
    private static readonly string[] NameMonthRus = new string[] {
        "январь", 
        "февраль",
        "март",
        "апрель",
        "май",
        "июнь",
        "июль",
        "август",
        "сентябрь",
        "октябрь",
        "ноябрь",
        "декабрь"
    };

    /// <summary>Название месяцов в родительном падеже</summary>
    private static readonly string[] NameMonthRusRp = new string[] {
        "января", 
        "февраля",
        "марта",
        "апреля",
        "мая",
        "июня",
        "июля",
        "августа",
        "сентября",
        "октября",
        "ноября",
        "декабря"
    };

    /// <summary>День недели по русски</summary>
    /// <param name="day">день недели</param>
    /// <returns>русское название дня недели</returns>
    public static string DayOfWeekToRus(DayOfWeek day)
    {
        CultureInfo culture = new CultureInfo("ru-RU");
        return culture.DateTimeFormat.GetDayName(day);
    }

    /// <summary>Месяц по русски</summary>
    /// <param name="month">номер месяца 1..12</param>
    /// <returns>название месяца по русски с большой буквы</returns>
    public static string MonthToRus(int month)
    {
        if (1 <= month && month <= 12)
        {
            CultureInfo culture = new CultureInfo("ru-RU");
            return culture.DateTimeFormat.GetMonthName(month);
        }
        else
            return string.Empty;
    }

    /// <summary>Месяц по русски в родительном падеже</summary>
    /// <param name="month">номер месяца 1..12</param>
    /// <returns>название месяца по русски с маленькой буквы  в родительном падеже</returns>
    public static string MonthToRusRp(int month)
    {
        if (1 <= month && month <= 12)
            return DateUtils.NameMonthRusRp[month - 1];
        else
            return string.Empty;
    }

    /// <summary>Преобразовать дату в строку 01 месяца 2001г. в р.п.</summary>
    /// <param name="obj">дата</param>
    /// <returns>строка с датой в родительном падеже</returns>
    public static string DateToStr(object obj)
    {
        DateTime dt;
        if (DateTime.TryParse(obj.ToString(), out dt))
            return string.Format("{0} {1} {2} г.", dt.Day, DateUtils.MonthToRusRp(dt.Month), dt.Year);
        else
            return string.Empty;
    }

    /// <summary>вывод даты в виде строки без времени и часа</summary>
    /// <param name="obj">дата</param>
    /// <returns>строка тлько дата без времени</returns>
    public static string DateToShortDateString(object obj)
    {
        DateTime dt;
        if (DateTime.TryParse(obj.ToString(), out dt))
            return dt.ToShortDateString();
        else
            return string.Empty;
    }
}
