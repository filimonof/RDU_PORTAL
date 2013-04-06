<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UpdateHappyImg.aspx.cs" Inherits="tmp_UpdateHappyImg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Обновление картинок праздников</title>
</head>
<body>
    <form enctype="multipart/form-data" runat="server" id="form1" name="form1">
    Введите ID праздника
    <input type="text" id="txtImgName" runat="server">
    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Required"
        ControlToValidate="txtImgName"></asp:RequiredFieldValidator>
    <br>
    Выьерите картинку для загрузки
    <input id="UploadFile" type="file" runat="server">
    <asp:Button ID="UploadBtn" Text="Загрузить" OnClick="UploadBtn_Click" runat="server">
    </asp:Button>
    <br>
    <br>
    <asp:SqlDataSource ID="SqlDataSourceHappy" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
        SelectCommand="SELECT * FROM [Holiday] ORDER BY [Month],[Day]">
    </asp:SqlDataSource>
    <asp:GridView ID="GridView1" runat="server" AllowPaging="False" AllowSorting="True"
        AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSourceHappy">
        <Columns>
            <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                SortExpression="ID" />
            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
            <asp:BoundField DataField="Day" HeaderText="Day" SortExpression="Day" />
            <asp:BoundField DataField="Month" HeaderText="Month" SortExpression="Month" />
        </Columns>
    </asp:GridView>
    </form>
</body>
</html>