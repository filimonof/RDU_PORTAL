<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Header.ascx.cs" Inherits="controls_Header" %>

<asp:SiteMapDataSource ID="SiteMapDataSourceMaster" runat="server" ShowStartingNode="false" />
<table cellspacing="0" cellpadding="0" border="0" width="100%">
    <tr>
        <td class="logo" style="width: 280px;">            
            <asp:Image ID="ImageSpacer" runat="server" ImageUrl="~/images/spacer.gif" Width="1" Height="160" AlternateText="" />
            </td>
        <td align="left" valign="top">
            <div class="main_menu_padding font_caption color_blue">                    
                <asp:Menu ID="MenuMain" runat="server" DataSourceID="SiteMapDataSourceMaster" />              
            </div></td></tr></table>  
            <%--<a href="#">Главная</a>&nbsp;&nbsp;|&nbsp;&nbsp; 
                <a href="#">Новости</a>&nbsp;&nbsp;|&nbsp;&nbsp;
                <a href="#">Контакты</a>&nbsp;&nbsp;|&nbsp;&nbsp; 
                <a href="#">Документы</a>&nbsp;&nbsp;|&nbsp;&nbsp;
                <a href="#">Досуг</a>--%>