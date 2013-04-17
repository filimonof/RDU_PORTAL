<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="News.aspx.cs" Inherits="News" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">    
    <link id="YandexWeatherCSS" href="images/YandexWeather/_weather.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderWorkspace" runat="Server">
    <table cellspacing="0" cellpadding="0" border="0" width="100%">
        <tr>
            <!-- левое поле  -->
            <td class="width_left_place" align="left" valign="top">
                <!-- список новоcтных лент  -->
                <asp:SqlDataSource ID="SqlDataSourceNews" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
                    SelectCommand="SELECT * FROM [NewsTitle] WHERE [Enabled] = 1 ORDER BY [Order]"></asp:SqlDataSource>
                <asp:DataList ID="DataListNews" runat="server" DataSourceID="SqlDataSourceNews" DataKeyField="ID" 
                    OnItemCommand="DataListNews_ItemCommand">
                    <ItemTemplate>                       
                        <tr>
                            <td><asp:Image ID="ImageNews"  runat="server" ImageUrl='<%# string.Format("~/Img.ashx?type=news&id={0}", Eval("ID")) %>' Width="24" Height="24" AlternateText="" /></td>
                            <td><asp:LinkButton ID="LinkButtonSelectNews" runat="server" Text='<%# Eval("Name") %>' 
                                CommandName="Select" CommandArgument='<%# Eval("ID") %>' /></td>
                        </tr>
                    </ItemTemplate>
                    <SelectedItemTemplate>
                        <tr>
                            <td><asp:Image ID="ImageNews" runat="server" ImageUrl='<%# string.Format("~/Img.ashx?type=news&id={0}", Eval("ID")) %>' Width="24" Height="24" AlternateText="" /></td>
                            <td><asp:Label ID="LabelSelectedNews" runat="server" Font-Bold="true" Text='<%# Eval("Name") %>' /></td>
                        </tr>
                    </SelectedItemTemplate>                    
                    <HeaderTemplate><table border="0" cellpadding="5"></HeaderTemplate>
                    <FooterTemplate></table></FooterTemplate>                    
                </asp:DataList>
                <br />
                <asp:Button ID="ButtonLoadNews" runat="server" Text="«агрузить новости из интернета" OnClick="ButtonLoad_Click" />                
            </td>
            <!-- центральное поле -->
            <td class="center_place_separate" align="left" valign="top">                
                <!-- заголовок ленты -->    
                <asp:XmlDataSource ID="XmlDataSourcePublicationsTitle" runat="server" XPath="rss/channel" />
                <asp:Repeater ID="RepeaterPublicationTitle" runat="server" DataSourceID="XmlDataSourcePublicationsTitle">
                    <ItemTemplate>
                        <asp:Label ID="TitleNews" CssClass="font_large_caption color_dark" runat="server" Text='<%#XPath("title")%>' />
                        <br />
                        <br />                        
                    </ItemTemplate>                                        
                </asp:Repeater>
                <!-- список новостей ленты -->    
                <asp:XmlDataSource ID="XmlDataSourcePublications" runat="server" XPath="rss/channel/item" />
                <asp:DataList ID="DataListPublications" runat="server" DataSourceID="XmlDataSourcePublications">
                    <ItemTemplate>
                        <div class="msgmenu_top_background"><div class="msgmenu_top_left"><div class="msgmenu_top_right">
                            <img src="images/spacer.gif" width="1" height="5" alt=" " /></div></div></div>
                        <div class="msgmenu_workspace font_standart color_dark">
                            <asp:Image ID="ImgRss" runat="server" CssClass="msgmenu_img_news" ImageUrl="~/images/rss.gif" />
                            <asp:Label ID="TitlePub" CssClass="font_caption color_dark msgmenu_title_news" runat="server" Text='<%#XPath("title")%>' />
                            <br />
                            <asp:Label ID="LabelPubTime" CssClass="font_small font_kursive color_dark msgmenu_time_news" runat="server" Text='<%# News.PubDateConvert(XPath("pubDate"))%>' />
                            <br />
                            <%# XPath("description") %>
                            <br />
                            <br />
                            <a href='<%# XPath("link") %>' target="_blank">ѕрочитать статью в интернете</a>
                        </div>
                        <div class="msgmenu_bottom_background"><div class="msgmenu_bottom_left"><div class="msgmenu_bottom_right">
                            <img src="images/spacer.gif" width="1" height="5" alt=" " /></div></div></div>                    
                    </ItemTemplate>
                    <SeparatorTemplate><br /></SeparatorTemplate>                    
                </asp:DataList>                
            </td>
        </tr>
    </table>   
</asp:Content>
