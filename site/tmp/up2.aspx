<%@ Page Language="C#" AutoEventWireup="true" CodeFile="up2.aspx.cs" Inherits="tmp_up2" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <asp:Image ID="img1" runat="server" ImageUrl="~/Images/spin2.png" />
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <cc1:asyncfileupload id="AsyncFileUpload1" runat="server" uploaderstyle="Modern"
                    throbberid="img1" />
                <br />
                <asp:Button ID="btnUpload" runat="server" Text="Upload" OnClick="btnUpload_Click" />
                <br />
                <asp:Label ID="Label1" runat="server" />
                <br />
                <br />
            </ContentTemplate>
        </asp:UpdatePanel>
        <br />
        <asp:Label ID="Label2" runat="server" />
    </div>
    </form>
</body>
</html>
