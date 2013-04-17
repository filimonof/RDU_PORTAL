<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LinksMenu.ascx.cs" Inherits="controls_LinksMenu" %>


<%--Data Source списка заголовков --%>
<asp:SqlDataSource ID="SqlDataSourceCaption" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
    SelectCommand="SELECT [ID], [Name] FROM [LinksMenuCaption] WHERE [Enabled] = 1 ORDER BY [Order]">
</asp:SqlDataSource>

<%--Data Source с ссылками --%>
<asp:SqlDataSource ID="SqlDataSourceItems" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
    SelectCommand="SELECT [Name], [Link] FROM [LinksMenuItem] WHERE ([Enabled] = 1) AND ([CaptionID] = @CaptionID) ORDER BY [Order],[Name]">
    <SelectParameters>
        <asp:Parameter Name="CaptionID" Type="Int32" />      
    </SelectParameters>
</asp:SqlDataSource>

<!-- меню ссылок -->
<asp:DataList ID="DataListLinks" runat="server" DataSourceID="SqlDataSourceCaption" DataKeyField="ID"  
    OnItemCommand="DataListLinks_ItemCommand" Width="100%">
    <HeaderTemplate>
        <table id="linktable" cellspacing="0" cellpadding="0" width="100%" border="0" class="linkmenu_table" >
    </HeaderTemplate>
    <SeparatorTemplate>
        <tr><td class="linkmenu_separator" ><img src="images/spacer.gif" width="1" height="1" alt="" /></td></tr>
    </SeparatorTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>
    <ItemTemplate>    
        <tr><td class="linkmenu_caption_cell" style="height: 20px;">
            <asp:Image ID="ImageLinkMenuLocal" runat="server" ImageUrl="~/images/links.png" Width="16" Height="16" />
            <asp:LinkButton ID="LinkButtonName" runat="server" CssClass="font_caption color_blue linkmenu_caption" 
                Text='<%# Eval("Name") %>' CommandName="Select" CommandArgument='<%# Eval("ID") %>' /></td></tr>    
    </ItemTemplate>
    <SelectedItemTemplate>
        <tr><td class="linkmenu_caption_cell" style="height: 20px;">
            <asp:Image ID="ImageLinkMenuLocal" runat="server" ImageUrl="~/images/links_select.png" Width="16" Height="16" />
            <asp:LinkButton ID="LinkButtonName" runat="server" CssClass="font_caption color_blue linkmenu_caption" 
                Text='<%# Eval("Name") %>' CommandName="Select" CommandArgument='<%# Eval("ID") %>' /></td></tr>    
        <tr id="linkmenu_in" >
            <td>
                <asp:Repeater ID="RepeaterItems" runat="server" DataSourceID="SqlDataSourceItems" >
                    <HeaderTemplate>
                        <ul class="linkmenu_list font_standart color_blue"></HeaderTemplate>
                    <ItemTemplate>                    
                        <li><a href="<%# Eval("Link") %>" target="_blank"><%# Eval("Name") %></a></li></ItemTemplate>
                    <FooterTemplate>
                        </ul></FooterTemplate>                        
                </asp:Repeater></td></tr>    
    </SelectedItemTemplate>
</asp:DataList>