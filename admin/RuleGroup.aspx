<%@ Page Language="C#" MasterPageFile="~/MasterPage_TwoPlace.master" AutoEventWireup="true" 
CodeFile="RuleGroup.aspx.cs" Inherits="admin_RuleGroup" %>

<%@ Register Src="~/controls/UserMenu.ascx" TagName="UserMenu" TagPrefix="vit" %>
<%@ Register Src="~/controls/AdmRuleGroup.ascx" TagName="AdmRuleGroup" TagPrefix="vit" %>
<%@ Register Namespace="vit.Control" Assembly="__code" TagPrefix="vit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderLeft" Runat="Server">
    <vit:UserMenu ID="UserMenu1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderCenter" Runat="Server">
    <vit:TabCaptions ID="TabCaptions1" runat="server">
        <vit:TabCaption Name="Доступ по группам" Href="~/admin/AccessGroup.aspx" Selected="false" />
        <vit:TabCaption Name="Доступ по пользователям" Href="~/admin/AccessUser.aspx" Selected="false" />
        <vit:TabCaption Name="Группы правил " Selected="true" />
        <vit:TabCaption Name="Правила" Href="~/admin/Rule.aspx" Selected="false" />
    </vit:TabCaptions>
    <br />
    <vit:AdmRuleGroup ID="AdmRuleGroup1" runat="server" />
</asp:Content>

