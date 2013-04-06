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

[
ParseChildren(true),
PersistChildren(false)
]
public partial class controls_Tab_items : System.Web.UI.UserControl
{
    private ListItemCollection m_Items;

    [
    PersistenceMode(PersistenceMode.InnerDefaultProperty),
    ]
    public virtual ListItemCollection Items
    {
        get
        {
            if (this.m_Items == null)
            {
                this.m_Items = new ListItemCollection();
            }
            return this.m_Items;
        }
    }

    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
        // не забываем инстанцировать шаблон во время init
        this.CreateTabs();
    }

    private void CreateTabs()
    {
        this.placeForTemplate.Controls.Clear();

        foreach (ListItem tab in this.Items)
        {
            HyperLink hl = new HyperLink();
            hl.Text = tab.Text;
            hl.NavigateUrl = tab.Value;
            this.placeForTemplate.Controls.Add(hl);
        }
    }
}
