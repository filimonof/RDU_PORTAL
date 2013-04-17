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

public partial class controls_UserMenu : System.Web.UI.UserControl
{
    /// <summary>Загрузка страницы</summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        //todo: изменение картинки уберём в скрипте

        int userID = (int)this.Session["USER_ID"];

        // Приветствие и определение имени 
        this.LabelHello.Text = "Здравствуйте";        
        if (userID == 0 && !Rule.IsForceAdmin())
        {
            this.LabelUserName.Text = "Гость";
            this.LabelTrafik.Text = "";
            this.PanelMenu.Visible = false;
            this.PanelAdminMenu.Visible = false;
        }
        else
        {
            //вывод имени пользователя
            Contact contact = new Contact(userID);
            if (contact.HasContact)
            {
                //вывод имени
                this.LabelUserName.Text = contact.Name;
                //вывод фотографии
                this.ImageUser.ImageUrl = Contact.Link(contact.ID, false);
            }
            else
                this.LabelUserName.Text = HttpContext.Current.User.Identity.Name;
            
            //показ трафика 
            this.LabelTrafik.Text = "";
            if (Rule.IsAccess(userID, RuleEnum.Trafik))
            {
                this.LabelTrafik.Text = "Трафик: 55 из 200 МБт";    
                //todo: процедура просмотра трафика 

            }
                        
            //вывод соответствующий пунктов меню
            this.PanelMenu.Visible = true;
            this.PanelPutMessage.Visible = Rule.IsAccess(userID, RuleEnum.PutMessage);
            this.PanelCarantin.Visible = Rule.IsAccess(userID, RuleEnum.EmailKarantin);
            this.PanelStatistics.Visible = Rule.IsAccess(userID, RuleEnum.StatisticsTrafik);
            this.PanelAdminMenu.Visible = Rule.IsAccess(userID, RuleEnum.Admin);

            //отрабатывание событий меню

            //размещение сообщений
            if (this.PanelPutMessage.Visible)
            {
                //todo: сделать процедуру размещения объявления
                this.LinkButtonPutMessage.PostBackUrl = "~/EditMessage.aspx";
            }

            //карантин
            if (this.PanelCarantin.Visible)
            {
                UriBuilder uri_cr = new UriBuilder("https", "172.23.84.243", 8447);
                uri_cr.Path = "login.imss";
                //uri_cr.Query = string.Format("userid={0}&password={1}", "PavlovaNA", "38qwedsa");
                uri_cr.Query = string.Format("userid={0}&password={1}", "", "");
                this.LinkButtonCarantin.PostBackUrl = uri_cr.ToString();
            }

            //статистика трафика
            if (this.PanelStatistics.Visible)
            {
                UriBuilder uri_s = new UriBuilder("https", "172.23.84.73");
                //uri_s.Path = @"/stat/cgi/index.cgi";
                uri_s.Path = @"/stat/cgi/statistic.cgi";            
                //uri_s.UserName = "PavlovaNA";
                //uri_s.Password = "38qwedsa";
                this.LinkButtonStatistics.PostBackUrl = uri_s.ToString();
            }
        }

    }
}
