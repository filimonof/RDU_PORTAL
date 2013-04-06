<%@ Page Language="C#" MasterPageFile="~/MasterPage_TwoPlace.master" AutoEventWireup="true"
    CodeFile="Rule.aspx.cs" Inherits="admin_Rule" %>

<%@ Register Src="~/controls/UserMenu.ascx" TagName="UserMenu" TagPrefix="vit" %>
<%@ Register Src="~/controls/AdmRule.ascx" TagName="AdmRule" TagPrefix="vit" %>
<%@ Register Namespace="vit.Control" Assembly="__code" TagPrefix="vit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderLeft" runat="Server">
    <vit:UserMenu ID="UserMenu1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderCenter" runat="Server">
    <vit:TabCaptions ID="TabCaptions1" runat="server">
        <vit:TabCaption Name="Доступ по группам" Href="~/admin/AccessGroup.aspx" Selected="false" />
        <vit:TabCaption Name="Доступ по пользователям" Href="~/admin/AccessUser.aspx" Selected="false" />
        <vit:TabCaption Name="Группы правил " Href="~/admin/RuleGroup.aspx" Selected="false" />
        <vit:TabCaption Name="Правила" Selected="true" />
    </vit:TabCaptions>
    <br />
    <vit:AdmRule ID="AdmRule1" runat="server" />
</asp:Content>
