﻿<%@ Page Language="C#" MasterPageFile="~/MasterPageNoAjax.master" AutoEventWireup="true"
    CodeFile="RequestToBig.aspx.cs" Inherits="error_RequestToBig" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderWorkspace" runat="Server">
    <asp:Table ID="Table1" runat="server" BorderWidth="0" HorizontalAlign="Center" CellPadding="5">
        <asp:TableRow>
            <asp:TableCell>
                <asp:Image ID="ImageNoRule" runat="server" ImageUrl="~/images/anim_smile/icon_que.gif" />
            </asp:TableCell>
            <asp:TableCell>
                <asp:Label ID="Label1" runat="server" CssClass="color_yellow font_large_caption">Слишком большой размер запроса</asp:Label>
                <br />
                <asp:Label ID="Label2" runat="server" CssClass="color_yellow font_standart">возможно вы пытаетесь загрузить на сервер файл большого размера</asp:Label>
                <br />
                <asp:Label ID="Label3" runat="server" CssClass="color_yellow font_standart"></asp:Label>
            </asp:TableCell>
        </asp:TableRow>
    </asp:Table>
</asp:Content>
