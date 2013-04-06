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
using System.ComponentModel;
using System.Security.Permissions;
using System.Collections.Generic;
using System.Drawing;
using System.Reflection;
using System.ComponentModel.Design;

[
PersistChildren(false),
ParseChildren(true, "TabCaptions"),
DefaultProperty("TabCaptions")
]
public partial class controls_Tab : System.Web.UI.UserControl
{
    /// <summary>поле для хранения списка закладок</summary>
    private TabCaptionCollection _tabCaptions = new TabCaptionCollection();

    /// <summary>Список закладок</summary>

    [
        //Editor(typeof(TabCaptionCollectionEditor), typeof(System.Drawing.Design.UITypeEditor)),
    Description("Список закладок"),
    DesignerSerializationVisibility(DesignerSerializationVisibility.Visible),
    PersistenceMode(PersistenceMode.InnerProperty),
        //NotifyParentProperty(true)
    ]
    public TabCaptionCollection TabCaptions
    {
        get { return this._tabCaptions; }
    }

    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
        // не забываем инстанцировать шаблон во время init
        this.CreateContent();
    }

    private void CreateContent()
    {

        this.placeForTemplate.Controls.Clear();

        foreach (TabCaption item in this._tabCaptions)
        {
            //TabCaption tabCaption = new TabCaption();//= (TabCaption)item.;
            TabCaption tabCaption = (TabCaption)item;

            if (tabCaption != null)
            //for (int i = 0; i < this.TabCaptions.Count; i++)
            {
                //TabCaption tabCaption = (TabCaption)(this.TabCaptions[i]);
                HyperLink link = new HyperLink();
                link.Text = tabCaption.Name;
                link.NavigateUrl = tabCaption.Href;
                this.placeForTemplate.Controls.Add(link);
                //if (i != this.TabCaptions.Count - 1)
                //{
                //    this.placeForTemplate.Controls.Add(new LiteralControl(" | "));
                //}
            }
        }

        //foreach (TabCaption tab in this.TabCaptions)
        //{
        //    Label lb = new Label();
        //    lb.Text = tab.Name;
        //    this.placeForTemplate.Controls.Add(lb);
        //}

    }

}


/// <summary>
/// Класс вкладок
/// </summary>
[TypeConverter(typeof(ExpandableObjectConverter))]
public class TabCaption
{
    /// <summary>конструктор</summary>
    public TabCaption() : this(false, "вкладка", "#") { }

    /// <summary>конструктор</summary>
    /// <param name="selected">вкладка выделена</param>
    /// <param name="name">заголовок</param>
    /// <param name="href">сылка</param>
    public TabCaption(bool selected, string name, string href)
    {
        this.Selected = selected;
        this.Name = name;
        this.Href = href;
    }

    /// <summary>Выделенная вкладка</summary>
    [
    Browsable(true),
    DefaultValue("false"),
    Description("Выделенная вкладка"),
    NotifyParentProperty(true)
    ]
    public bool Selected { get; set; }

    /// <summary>Название</summary>
    [
    Browsable(true),
    DefaultValue("вкладка"),
    Description("Название"),
    NotifyParentProperty(true)
    ]
    public string Name { get; set; }

    /// <summary>Ссылка</summary>
    [
    Browsable(true),
    DefaultValue("#"),
    Description("Ссылка"),
    NotifyParentProperty(true)
    ]
    public string Href { get; set; }

    /// <summary>переопределение вывода как строки</summary>
    /// <returns>строка</returns>
    public override string ToString()
    {
        return this.Name;
    }
}


/// <summary>
/// Коллекция вкладок
/// </summary>
//[Editor(typeof(TabCaptionCollectionEditor), typeof(System.Drawing.Design.UITypeEditor))]
public class TabCaptionCollection : CollectionBase
{
    public TabCaption this[object index]
    {
        get
        {
            return (TabCaption)this.List[IndexOf(index)];
        }
        set
        {
            this.List[IndexOf(index)] = value;
        }
    }

    public void Add(TabCaption tab)
    {
        this.List.Add(tab);
    }

    public void Insert(int index, TabCaption tab)
    {
        this.List.Insert(index, tab);
    }

    public void Remove(TabCaption tab)
    {
        this.List.Remove(tab);
    }

    public bool Contains(TabCaption tab)
    {
        return this.List.Contains(tab);
    }

    public int IndexOf(object obj)
    {
        if (obj is int)
            return (int)obj;
        else
            throw new ArgumentException("Значения должно быть integer.");
    }

    public void CopyTo(TabCaption[] array, int index)
    {
        this.List.CopyTo(array, index);
    }

    public bool Contains(string key)
    {
        IEnumerator oEnum = this.GetEnumerator();
        while (oEnum.MoveNext())
        {
            if (string.Compare(key, ((TabCaption)oEnum.Current).Name, true) == 0)
                return true;
        }
        return false;
    }

    public void Remove(string key)
    {
        IEnumerator oEnum = this.GetEnumerator();
        while (oEnum.MoveNext())
        {
            if (string.Compare(key, ((TabCaption)oEnum.Current).Name, true) == 0)
                this.Remove((TabCaption)oEnum.Current);
        }
    }
}


public class TabCaptionCollectionEditor : CollectionEditor
{
    public TabCaptionCollectionEditor(Type type)
        : base(type)
    {
    }

    protected override bool CanSelectMultipleInstances()
    {
        return false;
    }

    protected override Type CreateCollectionItemType()
    {
        return typeof(TabCaption);
    }
}



//public class Editor : System.Drawing.Design.UITypeEditor
//{
//    public Editor()
//        : base()
//    {
//    }

//    public override object EditValue(System.ComponentModel.ITypeDescriptorContext context, IServiceProvider provider, object value)
//    {
//        if (context != null && context.Instance != null && provider != null)
//        {
//            System.Windows.Forms.Design.IWindowsFormsEditorService edSvc = (System.Windows.Forms.Design.IWindowsFormsEditorService)
//            provider.GetService(typeof(System.Windows.Forms.Design.IWindowsFormsEditorService));
//            if (edSvc != null)
//            {
//                System.Web.UI.Control oControl = (System.Web.UI.Control)context.Instance;
//                VisualEditor form = new VisualEditor(oControl, (TabCaption)value);

//                System.Windows.Forms.DialogResult result = edSvc.ShowDialog(form);
//                context.OnComponentChanging();
//                if (result == System.Windows.Forms.DialogResult.OK)
//                {
//                    value = form.Comands;
//                    context.OnComponentChanged();
//                }
//            }
//            return value;
//        }
//        return base.EditValue(context, provider, value);
//    }

//    public override System.Drawing.Design.UITypeEditorEditStyle GetEditStyle(ITypeDescriptorContext context)
//    {
//        if (context != null && context.Instance != null)
//        {
//            return System.Drawing.Design.UITypeEditorEditStyle.Modal;
//        }
//        return base.GetEditStyle(context);
//    }
//}