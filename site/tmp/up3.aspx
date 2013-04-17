<%@ Page Language="C#" AutoEventWireup="true" CodeFile="up3.aspx.cs" Inherits="tmp_up3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>

    <script type="text/javascript">
        function iUploadFrameLoad() {
            if (window.iUploadFrame.document.body.innerHTML == "SUCCESS") {
                document.forms[0].elements[btnUploadCompleted].click();
            }
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <asp:UpdatePanel ID="pnlMain" runat="server">
            <ContentTemplate>
                <asp:Label ID="lblMessage" runat="server" />
                <asp:Button ID="btnUploadCompleted" runat="server" Style="visibility: hidden;" OnClick="btnUploadComplted_Click" OnClientClick="javascript:document.forms[0].encoding = 'multipart/form-data';"/>
            </ContentTemplate>
            <%--<Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnUploadCompleted" EventName="Click" />
            </Triggers>--%>
        </asp:UpdatePanel>
    </div>
    </form>
    <iframe name="iUploadFrame" src="up3iframe.htm" frameborder="0" onload="iUploadFrameLoad();">
    </iframe>
</body>
</html>

