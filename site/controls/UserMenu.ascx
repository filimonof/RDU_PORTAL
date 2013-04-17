<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UserMenu.ascx.cs" Inherits="controls_UserMenu" %>

<!--Меню пользователя-->
<div class="usermenu_top_background"><div class="usermenu_top_left"><div class="usermenu_top_right">                        
    <div class="usermenu_caption_place" style="height: 20px;">        
        <asp:Image ID="ImageUserMenuCaption" runat="server" ImageUrl="~/images/user2.png" Width="20" Height="20" />
        <span class="font_caption color_blue usermenu_caption">Пользователь</span></div></div></div></div>            
<div class="usermenu_workspace"> 
    <table cellspacing="0" cellpadding="0" width="95%" border="0">
        <tr>
            <td style="width: 80px;" >
                <div class="user_img">                             
                <asp:Image ID="ImageUser" CssClass="user_img" runat="server" ImageUrl='<%# Contact.Link(null) %>' Width="80" Height="90" AlternateText="" /></div></td>                
            <td class="font_standart color_dark padding10" align="left" valign="top">                              
                <asp:Label ID="LabelHello" runat="server" Text="Здравствуйте"></asp:Label>
                <br />                
                <span class="font_caption"><asp:Label ID="LabelUserName" runat="server" Text="Имя Отчество"></asp:Label></span>
                <br />                
                <br />  
                <asp:Label ID="LabelTrafik" runat="server" Text="Трафик"></asp:Label></td></tr>
        <tr>
            <td colspan="2" valign="top" align="left">
                <asp:Panel ID="PanelMenu" runat="server">
                    <asp:Panel ID="PanelPutMessage" runat="server" CssClass="font_caption color_blue usermenu_list">
                        <asp:Image ID="ImagePutMessage" runat="server" ImageUrl="~/images/message_add.png" CssClass="img_16_caption" />
                        <asp:LinkButton ID="LinkButtonPutMessage" runat="server">Разместить объявление</asp:LinkButton>
                    </asp:Panel>
                    <asp:Panel ID="PanelStatistics" runat="server" CssClass="font_caption color_blue usermenu_list">
                        <asp:Image ID="ImageStatistics" runat="server" ImageUrl="~/images/statistics.png" CssClass="img_16_caption" />
                        <asp:LinkButton ID="LinkButtonStatistics" runat="server">Статистика по трафику</asp:LinkButton>
                    </asp:Panel>
                    <asp:Panel ID="PanelCarantin" runat="server" CssClass="font_caption color_blue usermenu_list">
                        <asp:Image ID="ImageCarantin" runat="server" ImageUrl="~/images/carantin.png" CssClass="img_16_caption" />
                        <asp:LinkButton ID="LinkButtonCarantin" runat="server">Почтовый карантин</asp:LinkButton>
                    </asp:Panel>
                </asp:Panel>
                <%--АдминЪ--%>
                <asp:Panel ID="PanelAdminMenu" runat="server" CssClass="usermenu_list">
                    <asp:Image runat="server" ID="AdminMenuImage" ImageUrl="~/images/admin.png" CssClass="img_16_caption" />
                    <asp:LinkButton ID="LinkButtonAdmin" OnClientClick="return ExpandCollapseAdminMenu();"
                        runat="server" CssClass="font_caption color_blue">АдминЪ</asp:LinkButton>
                    <div id="AdminMenuBlock" class="infoBlock" style="display: none">
                        <ul class="usermenu_admin_list font_standart color_blue">
                            <li><asp:LinkButton ID="LinkButton1" runat="server" PostBackUrl="~/admin/Departament.aspx">Подразделения</asp:LinkButton></li>
                            <li><asp:LinkButton ID="LinkButton2" runat="server" PostBackUrl="~/admin/Post.aspx">Должности</asp:LinkButton></li>
                            <li><asp:LinkButton ID="LinkButton3" runat="server" PostBackUrl="~/admin/User.aspx">Пользователи</asp:LinkButton></li>
                            <li><asp:LinkButton ID="LinkButton9" runat="server" PostBackUrl="~/admin/AccessGroup.aspx">Раздача прав</asp:LinkButton></li>
                            <li><asp:LinkButton ID="LinkButton5" runat="server" PostBackUrl="~/admin/LinksMenuCaption.aspx">Меню ссылок</asp:LinkButton></li>
                            <li><asp:LinkButton ID="LinkButton10" runat="server" PostBackUrl="~/admin/Holiday.aspx">Праздники</asp:LinkButton></li>
                            <li><asp:LinkButton ID="LinkButton6" runat="server" PostBackUrl="~/admin/UserMessages.aspx">Объявления</asp:LinkButton></li>
                            <li><asp:LinkButton ID="LinkButton7" runat="server" PostBackUrl="~/admin/News.aspx">Новости</asp:LinkButton></li>                            
                            <li><asp:LinkButton ID="LinkButton4" runat="server" PostBackUrl="~/admin/Contacts.aspx">Контакты</asp:LinkButton></li>
                            <li><asp:LinkButton ID="LinkButton8" runat="server" PostBackUrl="~/admin/Documents.aspx">Документы</asp:LinkButton></li>
                        </ul>
                    </div>
                </asp:Panel>
            </td></tr></table></div>
<div class="usermenu_bottom_bg"><div class="usermenu_bottom_left"><div class="usermenu_bottom_right">
    <asp:Image ID="ImageSpaces" runat="server" ImageUrl="~/images/spacer.gif" Width="1" Height="5" AlternateText=""/></div></div></div>
     
     <%--   <table cellspacing="0" cellpadding="0" width="100%" border="0">
            <tr>
                <td style="width: 30px;" >
                    <img src="images/user2.png" width="20" height="20" alt=" " /></td>
                <td class="font_caption color_blue">Пользователь</td></tr></table>--%>
<%--Скрипт для открывания/закрывания пунктов меню--%>
<script type="text/javascript" language="JavaScript">
<!--
function ExpandCollapseAdminMenu()
{
    //todo: изменение картинки уберём
    var adminMenuBlock=document.getElementById('AdminMenuBlock');
    //var adminMenuImage=document.getElementById('AdminMenuImage');
    
    if (adminMenuBlock != undefined && adminMenuBlock != null 
        )//&& adminMenuImage != undefined && adminMenuImage != null)
    {    
        if ( (!adminMenuBlock.style.display) || (adminMenuBlock.style.display == 'none') ) 
        {        
            //если невидим сделать видимымы            
            adminMenuBlock.style.display='block';
            //adminMenuImage.src = "images/up.png";
        }
        else 
        {
            //сделать невидимым
            adminMenuBlock.style.display='none';    
            //adminMenuImage.src = "images/down.png";
        }
    }
    return false;    
}
-->
</script>
                