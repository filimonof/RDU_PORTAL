<%@ Page Language="C#" MasterPageFile="~/MasterPage_TreePlace.master" AutoEventWireup="true"
    CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register Src="~/controls/UserMenu.ascx" TagName="UserMenu" TagPrefix="vit" %>
<%@ Register Src="~/controls/LinksMenu.ascx" TagName="LinksMenu" TagPrefix="vit" %>
<%@ Register Src="~/controls/Holiday.ascx" TagName="Holiday" TagPrefix="vit" %>
<%@ Register Src="~/controls/UserMessage.ascx" TagName="UserMessage" TagPrefix="vit" %>
<%@ Register Src="~/controls/SimpleMessage.ascx" TagName="SimpleMessage" TagPrefix="vit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderLeft" runat="Server">
    <vit:UserMenu ID="UserMenu1" runat="server" />
    <vit:LinksMenu ID="LinksMenu1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderCenter" runat="Server">
    <vit:UserMessage ID="UserMessage1" runat="server" />
<%--    <br />
    <vit:SimpleMessage ID="SimpleMessage1" runat="server" />
    <br />--%>    
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolderRight" runat="Server">
    <vit:Holiday ID="Holiday" runat="server" />
</asp:Content>
