﻿<%@ Page Language="C#" MasterPageFile="~/MasterPage_TwoPlace.master" AutoEventWireup="true"
    CodeFile="News.aspx.cs" Inherits="admin_News" %>

<%@ Register Src="~/controls/UserMenu.ascx" TagName="UserMenu" TagPrefix="vit" %>
<%@ Register Src="~/controls/AdmNews.ascx" TagName="AdmNews" TagPrefix="vit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderLeft" runat="Server">
    <vit:UserMenu ID="UserMenu1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderCenter" runat="Server">
    <vit:AdmNews ID="AdmNews1" runat="server" />
</asp:Content>
