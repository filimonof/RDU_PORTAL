<%@ Page Language="C#" MasterPageFile="~/MasterPage_TwoPlace.master" AutoEventWireup="true"
    CodeFile="Contacts.aspx.cs" Inherits="admin_Contacts" %>

<%@ Register Src="~/controls/UserMenu.ascx" TagName="UserMenu" TagPrefix="vit" %>
<%--<%@ Register Src="~/controls/AdmContact.ascx" TagName="AdmContact" TagPrefix="vit" %>--%>
<%@ Register Namespace="vit.Control" Assembly="__code" TagPrefix="vit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderLeft" runat="Server">
    <vit:UserMenu ID="UserMenu1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderCenter" runat="Server">
    <vit:TabCaptions ID="TabCaptions1" runat="server">        
        <vit:TabCaption Name="Контакты" Href="~/admin/Contacts.aspx" Selected="true" />        
        <vit:TabCaption Name="Предприятия" Href="~/admin/Contacts.aspx" Selected="false" />                
        <vit:TabCaption Name="Типы контактной информации" Href="~/admin/Contacts.aspx" Selected="false" />        
    </vit:TabCaptions>
    <br />
    <%--<vit:AdmContact ID="AdmContact1" runat="server" />--%>
</asp:Content>
