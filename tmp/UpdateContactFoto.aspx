<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UpdateContactFoto.aspx.cs"
    Inherits="UpdateContactFoto" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Обновление фотографий контактов</title>
</head>
<body>
    <form enctype="multipart/form-data" runat="server" id="form1" name="form1">
    Введите ID пользователя
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
    <asp:SqlDataSource ID="SqlDataSourceContacts" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
        SelectCommand="SELECT [ID], [Family], [FirstName], [LastName] FROM [Contact] ORDER BY [Family]">
    </asp:SqlDataSource>
    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
        AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSourceContacts">
        <Columns>
            <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                SortExpression="ID" />
            <asp:BoundField DataField="Family" HeaderText="Family" SortExpression="Family" />
            <asp:BoundField DataField="FirstName" HeaderText="FirstName" SortExpression="FirstName" />
            <asp:BoundField DataField="LastName" HeaderText="LastName" SortExpression="LastName" />
        </Columns>
    </asp:GridView>
    </form>
    <%--<form id="form1" runat="server">
    <div>
        <cc1:toolkitscriptmanager runat="Server" enablepartialrendering="true" id="ScriptManager1" />
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <table>
                    <tr>
                        <td>
                            <asp:Label ID="Label1" runat="server" Text="User ID" />
                        </td>
                        <td>
                            <asp:TextBox ID="txtUserID" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="Label2" runat="server" Text="Upload Image" />
                        </td>
                        <td>
                            <cc1:asyncfileupload id="afuUpload" onclientuploadcomplete="uploadComplete" runat="server"
                                width="300px" uploaderstyle="Modern" uploadingbackcolor="#CCFFFF" />
                            <asp:Label runat="server" ID="myThrobber" Style="display: none;">

               <img align="absmiddle" alt="" src="images/down_ie.png" />

                            </asp:Label>
                        </td>
                    </tr>
                    <tr align="center">
                        <td>
                            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
                        </td>
                    </tr>
                </table>
                <asp:Label ID="lblMsg" ForeColor="Red" runat="server" /><br />
                <asp:ObjectDataSource ID="User" TypeName="objUser" InsertMethod="InsertUserDetail"
                    runat="server">
                    <InsertParameters>
                        <asp:ControlParameter Name="UserID" ControlID="txtUserID" PropertyName="Text" />
                        <asp:ControlParameter Name="UserImage" ControlID="afuUpload" PropertyName="FileBytes" />
                    </InsertParameters>
                </asp:ObjectDataSource>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    </form>--%>
</body>
</html>
