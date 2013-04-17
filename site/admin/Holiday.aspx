<%@ Page Language="C#" MasterPageFile="~/MasterPage_TwoPlace.master" AutoEventWireup="true" CodeFile="Holiday.aspx.cs" Inherits="admin_Holiday" %>
<%@ Register Src="~/controls/UserMenu.ascx" TagName="UserMenu" TagPrefix="vit" %>
<%@ Register Src="~/controls/AdmHoliday.ascx" TagName="AdmHoliday" TagPrefix="vit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderLeft" Runat="Server">
    <vit:UserMenu ID="UserMenu1" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderCenter" Runat="Server">
    <vit:AdmHoliday ID="AdmHoliday1" runat="server" />
</asp:Content>

