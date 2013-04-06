<%@ Page Language="C#" MasterPageFile="~/MasterPage_TwoPlace.master" AutoEventWireup="true" CodeFile="LinksMenuItem.aspx.cs" Inherits="admin_LinksMenuItem" %>

<%@ Register Src="~/controls/UserMenu.ascx" TagName="UserMenu" TagPrefix="vit" %>
<%@ Register Src="~/controls/AdmLinksMenuItem.ascx" TagName="AdmLinksMenuItem" TagPrefix="vit" %>
<%@ Register Namespace="vit.Control" Assembly="__code" TagPrefix="vit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderLeft" Runat="Server">
    <vit:UserMenu ID="UserMenu1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderCenter" Runat="Server">
    <vit:TabCaptions ID="TabCaptions1" runat="server">
        <vit:TabCaption Name="Группы ссылок" Href="~/admin/LinksMenuCaption.aspx" Selected="false" />
        <vit:TabCaption Name="Ссылки" Selected="true" />
    </vit:TabCaptions>
    <br />
    <vit:AdmLinksMenuItem ID="AdmLinksMenuItem1" runat="server" />
</asp:Content>