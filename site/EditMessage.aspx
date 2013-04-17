<%@ Page Language="C#" MasterPageFile="~/MasterPage_TwoPlace.master" AutoEventWireup="true" CodeFile="EditMessage.aspx.cs" Inherits="EditMessage" %>

<%@ Register Src="~/controls/UserMenu.ascx" TagName="UserMenu" TagPrefix="vit" %>
<%@ Register Src="~/controls/UserMessageEdit.ascx" TagName="UserMessageEdit" TagPrefix="vit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderLeft" Runat="Server">
    <vit:UserMenu ID="UserMenu1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderCenter" Runat="Server">
    <vit:UserMessageEdit ID="UserMessageEdit1" runat="server" />
</asp:Content>

