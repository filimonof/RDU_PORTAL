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

namespace vit.Control
{
    /// <summary>
    /// Контрол - ссылки для фильтрации по первым буквам
    /// </summary>    
    public class LinkFirstLetter : WebControl, INamingContainer
    {
        /// <summary>поле для хранения списка ссылок</summary>
        private ListItemCollection _listLetter = new ListItemCollection();

        /// <summary>коллекция букоф</summary>
        public ListItemCollection ListLetter
        {
            get { return this._listLetter; }
        }

        /// <summary>Создание HTML кода со списком букв</summary>
        /// <returns>таблица сосписком или null</returns>
        private Table CreateListLetter()
        {
            Table tbl = null;
            if (this._listLetter != null && this._listLetter.Count > 0)
            {
                //создание таблицы
                tbl = new Table();
                tbl.BorderWidth = 0;
                tbl.CellPadding = 5;
                tbl.CellSpacing = 1;

                //формирование строки таблицы
                TableRow tr = new TableRow();
                //каждая буква в колонке таблицы
                foreach (ListItem item in this._listLetter)
                {
                    LinkButton letter = new LinkButton();
                    letter.ID = "LinkButton_" + item.Text;
                    letter.Text = item.Text;
                    letter.Click += new EventHandler(ClickedLetter);

                    TableCell td = new TableCell();
                    td.Controls.Add(letter);
                    tr.Controls.Add(td);
                }
                //добавление строки в таблицу
                tbl.Controls.Add(tr);
            }
            return tbl;
        }

        /// <summary>Прорисовка содержимого</summary>
        protected override void CreateChildControls()
        {
            Table t = CreateListLetter();
            if (t != null) Controls.Add(t);
        }

        /// <summary>Делегат - выбор буквы</summary>
        public delegate void SelectedDelegate(string letter);

        /// <summary>Событие - выбор буквы</summary>
        public event SelectedDelegate Select;

        /// <summary>выбор буквы</summary>
        public void ClickedLetter(object sender, EventArgs e)
        {
            if (this.Select != null)
            {
                string letter = ((LinkButton)sender).Text;
                this.Select(letter);
            }
        }

        /// <summary>Сортировать</summary>
        public void Sort()
        {
            IList<ListItem> itemList = new List<ListItem>();
            foreach (ListItem item in this.ListLetter)
                itemList.Add(item);

            IEnumerable<ListItem> itemEnum =
              from item in itemList orderby item.Text select item;

            this.ListLetter.Clear();
            this.ListLetter.AddRange(itemEnum.ToArray());
        }
    }
}