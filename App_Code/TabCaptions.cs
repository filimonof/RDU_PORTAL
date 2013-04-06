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
using System.Drawing.Design;
using System.ComponentModel;

namespace vit.Control
{

    /// <summary>
    /// Control класс TabCaption заголовки вкладок
    /// </summary>
    [
    DefaultProperty("Tabs"),
    ParseChildren(true, "Tabs"),
    ToolboxData("<{0}:TabCaption runat=\"server\"> </{0}:TabCaption>")
    ]
    public class TabCaptions : WebControl
    {
        /// <summary>поле для хранения списка закладок</summary>
        private TabCaptionCollection _tabCaptions = new TabCaptionCollection();

        /// <summary>Список закладок</summary>
        [
        Description("Список закладок"),
        DesignerSerializationVisibility(DesignerSerializationVisibility.Content),
        PersistenceMode(PersistenceMode.InnerProperty)
        ]
        public TabCaptionCollection Tabs
        {
            get { return this._tabCaptions; }
        }

        /// <summary>Отображение (render) компоненты</summary>
        /// <param name="writer"></param>
        protected override void RenderContents(HtmlTextWriter writer)
        {
            Table t = CreateContactsTable();
            if (t != null) t.RenderControl(writer);         
        }

        /// <summary>Создание HTML кода таблицы со вкладками</summary>
        /// <returns></returns>
        private Table CreateContactsTable()
        {
            Table tbl = null;
            if (this._tabCaptions != null && this._tabCaptions.Count > 0)
            {
                //создание таблицы
                tbl = new Table();
                tbl.Height = 30;
                tbl.BorderWidth = 0;
                tbl.CellPadding = 0;
                tbl.CellSpacing = 0;

                //формирование строки таблицы
                TableRow tr = new TableRow();                
                TableCell td;
                Image img;
                HyperLink span;

                //левая часть коллекции вкладок
                td = new TableCell();
                img = new Image();
                img.ImageUrl = @"~/images/tabs_left.jpg";
                img.Width = 10;
                img.Height = 30;
                td.Controls.Add(img);
                tr.Controls.Add(td);                
                //row.Controls.Add((new TableCell()).Controls.Add(img));

                td = new TableCell();
                img = new Image();
                img.ImageUrl = @"~/images/tabs_downline.jpg";
                img.Width = 1;
                img.Height = 30;               
                td.Controls.Add(img);                
                tr.Controls.Add(td);

                //вкладки
                foreach (TabCaption tab in this._tabCaptions)
                {                  
                    td = new TableCell();
                    img = new Image();
                    img.ImageUrl = tab.Selected ? @"~/images/tabs_active_left.jpg" : @"~/images/tabs_unactive_left.jpg";
                    img.Width = 6;
                    img.Height = 30;
                    td.Controls.Add(img);
                    tr.Controls.Add(td);

                    td = new TableCell();
                    td.CssClass = tab.Selected ? "tab_active_fon" : "tab_unactive_fon";
                    span = new HyperLink();
                    span.CssClass = tab.Selected ? "font_standart color_dark tab_padding_text padding5" : "font_standert color_blue tab_padding_text padding5";
                    span.Text = tab.Name;
                    span.NavigateUrl = tab.Href;
                    td.Controls.Add(span);
                    tr.Controls.Add(td);

                    td = new TableCell();
                    img = new Image();
                    img.ImageUrl = tab.Selected ? @"~/images/tabs_active_right.jpg" : @"~/images/tabs_unactive_right.jpg";
                    img.Width = 6;
                    img.Height = 30;
                    td.Controls.Add(img);
                    tr.Controls.Add(td);
                }

                //правая часть коллекции вкладок
                td = new TableCell();
                img = new Image();
                img.ImageUrl = @"~/images/tabs_downline.jpg";
                img.Width = 20; //длинна концевого промежутка 
                img.Height = 30;
                td.Controls.Add(img);
                tr.Controls.Add(td);

                td = new TableCell();
                img = new Image();
                img.ImageUrl = @"~/images/tabs_right.jpg";
                img.Width = 10;
                img.Height = 30;
                td.Controls.Add(img);
                tr.Controls.Add(td);

                //добавление строки в таблицу
                tbl.Controls.Add(tr);
            }
            return tbl;
            #region код который должен получиться
            /*
            <table height="30" border="0" cellpadding="0" cellspacing="0">
	            <tr>
                    <td><img src="images/tabs_left.jpg" width="10" height="30" alt=""></td>
		            <td><img src="images/tabs_downline.jpg" width="1" height="30" alt=""></td>
            		
            		
		            <td><img src="images/tabs_unactive_left.jpg" width="6" height="30" alt=""></td>
		            <td class="tab_unactive_fon"><span class="font_standert color_blue tab_padding_text padding5">Правила</span></td>
		            <td><img src="images/tabs_unactive_right.jpg" width="6" height="30" alt=""></td>
            		
		            <td><img src="images/tabs_active_left.jpg" width="6" height="30" alt=""></td>
		            <td class="tab_active_fon"><span class="font_standart color_dark tab_padding_text padding5">Группы</span></td>
		            <td><img src="images/tabs_active_right.jpg" width="6" height="30" alt=""></td>
            				
		            <td><img src="images/tabs_unactive_left.jpg" width="6" height="30" alt=""></td>
		            <td class="tab_unactive_fon"><span class="font_standert color_blue tab_padding_text padding5">По пользователям</span></td>
		            <td><img src="images/tabs_unactive_right.jpg" width="6" height="30" alt=""></td>
            	
		            <td><img src="images/tabs_unactive_left.jpg" width="6" height="30" alt=""></td>
		            <td class="tab_unactive_fon"><span class="font_standert color_blue tab_padding_text padding5">По группам</span></td>
		            <td><img src="images/tabs_unactive_right.jpg" width="6" height="30" alt=""></td>            				
            				
            				
		            <td><img src="images/tabs_downline.jpg" width="20" height="30" alt=""></td>
                    <td><img src="images/tabs_right.jpg" width="10" height="30" alt=""></td>
                </tr>
            </table>
         */
            #endregion
        }
    }


    /// <summary>
    /// Класс вкладок
    /// </summary>
    [TypeConverter(typeof(ExpandableObjectConverter))]
    public class TabCaption
    {
        /// <summary>конструктор</summary>
        public TabCaption() : this(false, "Закладка", "") { }

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
        DefaultValue("Закладка"),
        Description("Название"),
        NotifyParentProperty(true)
        ]
        public string Name { get; set; }

        /// <summary>Ссылка</summary>
        [
        Browsable(true),
        DefaultValue(""),
        Description("Ссылка"),
        NotifyParentProperty(true)
        ]
        public string Href { get; set; }

        ///// <summary>переопределение вывода как строки</summary>
        ///// <returns>строка</returns>
        //public override string ToString()
        //{
        //    return this.Name;
        //}
    }

    /// <summary>
    /// Коллекция вкладок
    /// </summary>
    public class TabCaptionCollection : CollectionBase
    {
        public TabCaption this[int index]
        {
            get { return (TabCaption)this.List[index]; }
            set { this.List[index] = value; }
        }

        public void Add(TabCaption tab)
        {
            this.List.Add(tab);
        }

        #region не используются но возможно пригодятся
        //public void Insert(int index, TabCaption tab)
        //{
        //    this.List.Insert(index, tab);
        //}

        //public void Remove(TabCaption tab)
        //{
        //    this.List.Remove(tab);
        //}

        //public bool Contains(TabCaption tab)
        //{
        //    return this.List.Contains(tab);
        //}

        //public int IndexOf(object obj)
        //{
        //    if (obj is int)
        //        return (int)obj;
        //    else
        //        throw new ArgumentException("Значения должно быть integer.");
        //}

        //public void CopyTo(TabCaption[] array, int index)
        //{
        //    this.List.CopyTo(array, index);
        //}

        //public bool Contains(string key)
        //{
        //    IEnumerator oEnum = this.GetEnumerator();
        //    while (oEnum.MoveNext())
        //    {
        //        if (string.Compare(key, ((TabCaption)oEnum.Current).Name, true) == 0)
        //            return true;
        //    }
        //    return false;
        //}

        //public void Remove(string key)
        //{
        //    IEnumerator oEnum = this.GetEnumerator();
        //    while (oEnum.MoveNext())
        //    {
        //        if (string.Compare(key, ((TabCaption)oEnum.Current).Name, true) == 0)
        //            this.Remove((TabCaption)oEnum.Current);
        //    }
        //}
        #endregion
    }

}