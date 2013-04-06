<%@ Page Language="C#" MasterPageFile="~/MasterPage_TwoPlace.master" AutoEventWireup="true"
    CodeFile="Documents.aspx.cs" Inherits="admin_Documents" %>

<%@ Register Src="~/controls/UserMenu.ascx" TagName="UserMenu" TagPrefix="vit" %>
<%@ Register Src="~/controls/AdmDocuments.ascx" TagName="AdmDocuments" TagPrefix="vit" %>
<%@ Register Namespace="vit.Control" Assembly="__code" TagPrefix="vit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderLeft" runat="Server">
    <vit:UserMenu ID="UserMenu1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderCenter" runat="Server">
    <vit:TabCaptions ID="TabCaptions1" runat="server">        
        <vit:TabCaption Name="Список документов" Href="~/admin/Documents.aspx" Selected="true" />        
        <vit:TabCaption Name="Папки с документами" Href="~/admin/DocumentFolders.aspx" Selected="false" />                
        <vit:TabCaption Name="Типы документов" Href="~/admin/DocumentType.aspx" Selected="false" />        
    </vit:TabCaptions>
    <br />
    <vit:AdmDocuments ID="AdmDocuments1" runat="server" />
</asp:Content>
