<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LinkMenu.ascx.cs" Inherits="controls_LinkMenu" %>

<!-- меню ссылок -->
<table id="linktable" cellspacing="0" cellpadding="0" width="100%" border="0" class="linkmenu_table">
    <tr>
        <td class="linkmenu_caption_cell" style="height: 23px;">
            <asp:Image ID="ImageLinkMenuLocal" runat="server" ImageUrl="~/images/globe_grey.png" Width="20" Height="20" />
            <a href="?link=local" onclick="return showLink(true);" class="font_caption color_blue linkmenu_caption">Внутренние ссылки</a></td></tr>    
    <tr id="linkmenu_in" style="<%= IsVsb(true) %>" >
        <td>
            <asp:Repeater ID="RepeaterLinkLocal" runat="server" DataSourceID="SqlDataSourceLinkLocal" >
                <HeaderTemplate>
                    <ul class="linkmenu_list font_standart color_blue"></HeaderTemplate>
                <ItemTemplate>                    
                    <li><a href="<%# Eval("Link") %>" target="_blank"><%# Eval("Name") %></a></li></ItemTemplate>
                <FooterTemplate>
                    </ul></FooterTemplate>
            </asp:Repeater></td></tr>
    <tr>
        <td class="linkmenu_caption_cell" style="height: 23px;">                        
            <asp:Image ID="ImageLinkMenuInternet" runat="server" ImageUrl="~/images/globe_blue.png" Width="20" Height="20" />
            <a href="?link=inet" onclick="return showLink(false);" class="font_caption color_blue linkmenu_caption">Ссылки в интернет</a></td></tr>
    <tr id="linkmenu_out" style="<%= IsVsb(false) %>">
        <td>
            <asp:Repeater ID="RepeaterLinkInternet" runat="server" DataSourceID="SqlDataSourceLinkInternet">
                <HeaderTemplate>
                    <ul class="linkmenu_list font_standart color_blue"></HeaderTemplate>
                <ItemTemplate>                    
                    <li><a href="<%# Eval("Link") %>" target="_blank"><%# Eval("Name") %></a></li></ItemTemplate>
                <FooterTemplate>
                    </ul></FooterTemplate>
            </asp:Repeater></td></tr></table>
<%--Скрипт для открывания/закрывания пунктов меню--%>
<script type="text/javascript" language="JavaScript">
<!--
function showLink(is_in_out)
{	        
    var blockExpand=document.getElementById('linkmenu_in');
    var blockCollapse=document.getElementById('linkmenu_out');
    if (!is_in_out)
    {
        blockExpand=document.getElementById('linkmenu_out');
        blockCollapse=document.getElementById('linkmenu_in');        
    }
	if ( (!blockExpand.style.display) || (blockExpand.style.display == 'none') )    	
	{
	    if ( navigator.appName == 'Microsoft Internet Explorer' ) {
		    blockExpand.style.display='block';
		    blockCollapse.style.display='none';
	    } else {
		    blockExpand.style.display='table-cell';
		    blockCollapse.style.display='none';
	    }
	}
    return false;
} 
-->
</script>
<%--Data Source интернет ссылки--%>
<asp:SqlDataSource ID="SqlDataSourceLinkInternet" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
    SelectCommand="SELECT [Name], [Link] FROM [LinkMenu] WHERE (([Enabled] = @Enabled) AND ([InternetLink] = @InternetLink)) ORDER BY [Order]">
    <SelectParameters>
        <asp:Parameter Name="Enabled" Type="Boolean" DefaultValue="true" />
        <asp:Parameter Name="InternetLink" Type="Boolean" DefaultValue="true" />
    </SelectParameters>
</asp:SqlDataSource>
<%--Data Source локальные ссылки--%>
<asp:SqlDataSource ID="SqlDataSourceLinkLocal" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
    SelectCommand="SELECT [Name], [Link] FROM [LinkMenu] WHERE (([Enabled] = @Enabled) AND ([InternetLink] = @InternetLink)) ORDER BY [Order]">
    <SelectParameters>
        <asp:Parameter Name="Enabled" Type="Boolean" DefaultValue="true" />
        <asp:Parameter Name="InternetLink" Type="Boolean" DefaultValue="false" />
    </SelectParameters>
</asp:SqlDataSource>
