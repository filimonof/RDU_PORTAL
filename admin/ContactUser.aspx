<%@ Page Language="C#" MasterPageFile="~/MasterPage_TwoPlace.master" AutoEventWireup="true"
    CodeFile="ContactUser.aspx.cs" Inherits="admin_Contact" %>

<%@ Register Src="~/controls/UserMenu.ascx" TagName="UserMenu" TagPrefix="vit" %>
<%@ Register Src="~/controls/AdmContact.ascx" TagName="AdmContact" TagPrefix="vit" %>
<%@ Register Namespace="vit.Control" Assembly="__code" TagPrefix="vit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderLeft" runat="Server">
    <vit:UserMenu ID="UserMenu1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderCenter" runat="Server">
    <vit:TabCaptions ID="TabCaptions1" runat="server">
        <vit:TabCaption Name="Пользователи" Href="~/admin/User.aspx" Selected="false" />
        <vit:TabCaption Name="Контактная информация пользователей" Href="~/admin/ContactUser.aspx" Selected="true" />
    </vit:TabCaptions>
    <br />
    <vit:AdmContact ID="AdmContact1" runat="server" />
</asp:Content>
