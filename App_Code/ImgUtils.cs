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
using System.Reflection;


public enum TypeImgEnum
{
    /// <summary>картинки праздников</summary>
    [Text("holiday")]
    Holiday,

    /// <summary>картинки канала новостей</summary>
    [Text("news")]
    News,

    /// <summary>картинки контактов предприятий</summary>
    [Text("contact")]
    Contact,

    /// <summary>картинки документов</summary>
    [Text("typedoc")]
    TypeDocument
}

/// <summary>
/// Описание - атрибут перечисления TypeImgEnum
/// </summary>
class TextAttribute : Attribute
{
    /// <summary>поле для описания</summary>
    private readonly string _name;

    /// <summary>конструктор</summary>
    /// <param name="name">описание</param>
    public TextAttribute(string name)
    {
        this._name = name;
    }

    /// <summary>перевести в строку</summary>
    /// <returns>строковое значение атрибута</returns>
    public override string ToString()
    {
        return this._name.ToString();
    }
}

/// <summary>
/// Summary description for Img
/// </summary>
public static class ImgUtils
{
    /// <summary>Получение значения аттрибута Text у перечисления TypeImgEnum</summary>
    /// <param name="type">значение перечисления</param>
    /// <returns>значение аттрибута или имя перечисления</returns>
    public static string GetText(TypeImgEnum type)
    {
        // получение значение аттрибута Description у пеерчисления
        FieldInfo fi = type.GetType().GetField(type.ToString());
        TextAttribute attr = (TextAttribute)Attribute.GetCustomAttribute(fi, typeof(TextAttribute));

        if (attr != null)
            //если есть аттрибут Text то выводим значение аттрибута
            return attr.ToString();
        else
            // если нет аттрибута то имя перечисления
            return type.ToString();
    }

    /// <summary>Получение строки с сылкой на картинку</summary>
    /// <param name="type">тип (какая база) картинки</param>
    /// <param name="id">ID картинки</param>
    /// <returns>текст с сылкой</returns>
    public static string Link(TypeImgEnum type, object id)
    {
        if (AdoUtils.DBNullToNull(id) == null)
            return ImgUtils.Link();
        else
            return string.Format(@"~/Img.ashx?type={0}&id={1}", ImgUtils.GetText(type), id.ToString());
    }

    /// <summary>Получение строки с сылкой на  пустую картинку</summary>
    /// <returns>текст с сылкой</returns>
    public static string Link()
    {
        return @"~/Img.ashx";
    }
}
