<%@ Page Language="C#" MasterPageFile="~/MasterPage_TwoPlace.master" AutoEventWireup="true" CodeFile="AccessGroup.aspx.cs" Inherits="admin_AccessGroup" %>

<%@ Register Src="~/controls/UserMenu.ascx" TagName="UserMenu" TagPrefix="vit" %>
<%@ Register Src="~/controls/AdmAccessGroup.ascx" TagName="AdmAccessGroup" TagPrefix="vit" %>
<%@ Register Namespace="vit.Control" Assembly="__code" TagPrefix="vit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderLeft" Runat="Server">
    <vit:UserMenu ID="UserMenu1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderCenter" Runat="Server">
    <vit:TabCaptions ID="TabCaptions1" runat="server">
        <vit:TabCaption Name="Доступ по группам" Selected="true" />
        <vit:TabCaption Name="Доступ по пользователям" Href="~/admin/AccessUser.aspx" Selected="false" />
        <vit:TabCaption Name="Группы правил " Href="~/admin/RuleGroup.aspx" Selected="false" />
        <vit:TabCaption Name="Правила" Href="~/admin/Rule.aspx" Selected="false" />
    </vit:TabCaptions>
    <br />
    <vit:AdmAccessGroup ID="AdmAccessGroup1" runat="server" />
</asp:Content>

