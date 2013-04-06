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
/// Summary description for StringUtils
/// </summary>
public class StringUtils
{
    public StringUtils()
    {
    }

    /// <summary>Получить строку между двумя подстроками</summary>
    /// <param name="text">текст</param>
    /// <param name="begin_content">начало подстроки</param>
    /// <param name="include_begin_content">включить в результат начало подстроки</param>
    /// <param name="end_content">конец подстроки</param>
    /// <param name="include_end_content">включить в результат конец подстроки</param>
    /// <returns>текст между пожстроками</returns>
    public static string GetStringBetween(string text, string begin_content, bool include_begin_content, string end_content, bool include_end_content)
    {
        int start_index_content = text.IndexOf(begin_content) + (include_begin_content ? 0 : begin_content.Length);
        int length_content = text.LastIndexOf(end_content) - start_index_content + (include_end_content ? end_content.Length : 0);
        if (start_index_content >= 0 && length_content > 0)
            return text.Substring(start_index_content, length_content);
        else
            return string.Empty;
    }
}
