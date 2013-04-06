<%@ Page Language="C#" MasterPageFile="~/MasterPage_TwoPlace.master" AutoEventWireup="true" CodeFile="LinksMenuCaption.aspx.cs" Inherits="admin_LinksMenuCaption" %>

<%@ Register Src="~/controls/UserMenu.ascx" TagName="UserMenu" TagPrefix="vit" %>
<%@ Register Src="~/controls/AdmLinksMenuCaption.ascx" TagName="AdmLinksMenuCaption" TagPrefix="vit" %>
<%@ Register Namespace="vit.Control" Assembly="__code" TagPrefix="vit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderLeft" Runat="Server">
    <vit:UserMenu ID="UserMenu1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderCenter" Runat="Server">
    <vit:TabCaptions ID="TabCaptions1" runat="server">
        <vit:TabCaption Name="Группы ссылок" Selected="true" />
        <vit:TabCaption Name="Ссылки" Href="~/admin/LinksMenuItem.aspx" Selected="false" />
    </vit:TabCaptions>
    <br />
    <vit:AdmLinksMenuCaption ID="AdmLinksMenuCaption1" runat="server" />
</asp:Content>

