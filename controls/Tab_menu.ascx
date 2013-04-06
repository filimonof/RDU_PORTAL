<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Tab_menu.ascx.cs" Inherits="controls_Tab_menu" %>
<asp:Menu ID="Menu1" runat="server" Orientation="Horizontal" BackColor="ActiveCaptionText"
    DynamicHorizontalOffset="0" Font-Names="Verdana" Font-Size="0.8em" ForeColor="DodgerBlue"
    StaticSubMenuIndent="10px" OnMenuItemClick="Menu1_MenuItemClick">
    <Items>
        <asp:MenuItem Text="Правила" Value="0" Selected="true"></asp:MenuItem>
        <asp:MenuItem Text="Группы" Value="1" ></asp:MenuItem>
        <asp:MenuItem Text="По пользователям" Value="2"></asp:MenuItem>
        <asp:MenuItem Text="По Группам" Value="3"></asp:MenuItem>
    </Items>
    <StaticMenuItemStyle HorizontalPadding="5px" VerticalPadding="2px" />
    <DynamicHoverStyle BackColor="#99FFFF" ForeColor="White" />
    <DynamicMenuStyle BackColor="#E3EAEB" />
    <StaticSelectedStyle BackColor="#FF0033" />
    <DynamicSelectedStyle BackColor="#FF0033" />
    <DynamicMenuItemStyle HorizontalPadding="5px" VerticalPadding="2px" />
    <StaticHoverStyle BackColor="#660066" ForeColor="White" />
</asp:Menu>
<asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
    <asp:View ID="View1" runat="server">
        <asp:Label ID="Label1" runat="server" Text="Правила"></asp:Label>
    </asp:View>
    <asp:View ID="View2" runat="server">
        <asp:Label ID="Label2" runat="server" Text="Группы"></asp:Label>
    </asp:View>
    <asp:View ID="View3" runat="server">
        <asp:Label ID="Label3" runat="server" Text="По пользователям"></asp:Label>
    </asp:View>
    <asp:View ID="View4" runat="server">
        <asp:Label ID="Label4" runat="server" Text="По группам"></asp:Label>
    </asp:View>
</asp:MultiView>