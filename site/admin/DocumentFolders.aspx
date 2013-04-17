<%@ Page Language="C#" MasterPageFile="~/MasterPage_TwoPlace.master" AutoEventWireup="true"
    CodeFile="DocumentFolders.aspx.cs" Inherits="admin_DocumentFolders" %>

<%@ Register Src="~/controls/UserMenu.ascx" TagName="UserMenu" TagPrefix="vit" %>
<%@ Register Src="~/controls/AdmDocumentFolders.ascx" TagName="AdmDocumentFolders"
    TagPrefix="vit" %>
<%@ Register Namespace="vit.Control" Assembly="__code" TagPrefix="vit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderLeft" runat="Server">
    <vit:UserMenu ID="UserMenu1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderCenter" runat="Server">
    <vit:TabCaptions ID="TabCaptions1" runat="server">        
        <vit:TabCaption Name="Список документов" Href="~/admin/Documents.aspx" Selected="false" />        
        <vit:TabCaption Name="Папки с документами" Href="~/admin/DocumentFolders.aspx" Selected="true" />                
        <vit:TabCaption Name="Типы документов" Href="~/admin/DocumentType.aspx" Selected="false" />        
    </vit:TabCaptions>
    <br />
    <vit:AdmDocumentFolders ID="AdmDocumentFolders1" runat="server" />
</asp:Content>
