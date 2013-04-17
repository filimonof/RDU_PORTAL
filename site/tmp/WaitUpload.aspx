<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<script runat="server">
protected void UploadFile(object src, EventArgs e)
{
    if (myFile.HasFile)
    {
        string strFileName;
        int intFileNameLength;
        string strFileExtension;

        strFileName = myFile.FileName;
        intFileNameLength = strFileName.Length;
        strFileExtension = strFileName.Substring(intFileNameLength - 4, 4);        

        if (strFileExtension == ".txt")
        {
            try
            {
                myFile.PostedFile.SaveAs(Server.MapPath(".") + "//AJAXUpload.txt");
                lblMsg.Text = strFileName + " Uploaded successfully!";
            }
            catch (Exception exc)
            {
                lblMsg.Text = exc.Message;
            }
        }
        else
        {
            lblMsg.Text = "Only Text File (.txt) can be uploaded.";
        }
    }
    else
    {
        lblMsg.Text = "Please select a file!";
    }
}
</script>


<script language="javascript" type="text/javascript">
function showWait()
{
    if ($get('myFile').value.length > 0)
    {
        $get('UpdateProgress1').style.display = 'block';
    }
}
</script>
    <title>File Upload</title>
</head>
<body>
<form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"/>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnUpload" /> 
        </Triggers>
        <ContentTemplate>
            <asp:FileUpload ID="myFile" runat="server" />
            <asp:Label ID="lblMsg" runat="server"></asp:Label>            
            <br />
            <asp:Button ID="btnUpload" runat="server" Text="Upload" 
                OnClick="UploadFile" OnClientClick="javascript:showWait();"/>           
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                <ProgressTemplate>
                    <asp:Label ID="lblWait" runat="server" BackColor="#507CD1" Font-Bold="True" ForeColor="White" Text="Please wait ... Uploading file"></asp:Label>
                </ProgressTemplate>
            </asp:UpdateProgress>
        </ContentTemplate>
    </asp:UpdatePanel>
</form>
</body>
</html>
