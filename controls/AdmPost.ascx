<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdmPost.ascx.cs" Inherits="controls_AdmPost" %>
<%--Администрирование должностей--%>
<div class="font_caption color_yellow">Администрирование должностей</div>
<br />
<asp:SqlDataSource ID="SqlDataSourcePost" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    DeleteCommand="DELETE FROM [Post] WHERE [ID] = @ID" 
    InsertCommand="INSERT INTO [Post] ([Name], [ShortName], [Order]) VALUES (@Name, @ShortName, @Order)" 
    SelectCommand="SELECT * FROM [Post]" 
    UpdateCommand="UPDATE [Post] SET [Name] = @Name, [ShortName] = @ShortName, [Order] = @Order WHERE [ID] = @ID">
    <DeleteParameters>
        <asp:Parameter Name="ID" Type="Int32" />
    </DeleteParameters>
    <UpdateParameters>
        <asp:Parameter Name="Name" Type="String" />
        <asp:Parameter Name="ShortName" Type="String" />
        <asp:Parameter Name="Order" Type="Int32" />
        <asp:Parameter Name="ID" Type="Int32" />
    </UpdateParameters>
    <InsertParameters>
        <asp:ControlParameter ControlID="TextBoxNewName" Name="Name" PropertyName="Text" Type="String" />
        <asp:ControlParameter ControlID="TextBoxNewShortName" Name="ShortName" PropertyName="Text" Type="String" />
        <asp:ControlParameter ControlID="TextBoxNewOrder" Name="Order" PropertyName="Text" Type="Int32" />
    </InsertParameters>
</asp:SqlDataSource>
<%--  New --%>
<table border="0">
    <tr>
        <td><asp:Label ID="LabelNewName" runat="server" Text="Новая должность" /></td>
        <td><asp:TextBox ID="TextBoxNewName" runat="server" ValidationGroup="new" Width="300" />
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewName" runat="server" ErrorMessage="Введите данные"
                ControlToValidate="TextBoxNewName" Display="Dynamic" ValidationGroup="new" /></td>
    </tr>
    <tr>
        <td><asp:Label ID="LabelNewShortName" runat="server" Text="Сокращенное название" /></td>
        <td><asp:TextBox ID="TextBoxNewShortName" runat="server" ValidationGroup="new" Width="150"/>
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewShortName" runat="server" ErrorMessage="Введите данные"
            ControlToValidate="TextBoxNewShortName" Display="Dynamic" ValidationGroup="new" /></td>
    </tr>
    <tr>
        <td><asp:Label ID="LabelNewOrder" runat="server" Text="Порядок сортировки" /></td>
        <td><asp:TextBox ID="TextBoxNewOrder" runat="server" ValidationGroup="new" Width="50" />
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewOrder" runat="server" ErrorMessage="Введите данные"
                ControlToValidate="TextBoxNewOrder" Display="Dynamic" ValidationGroup="new" />
            <asp:CompareValidator ID="CompareValidatorNewOrder" runat="server" ErrorMessage="Введите число"
                ControlToValidate="TextBoxNewOrder" Type="Integer" Operator="DataTypeCheck" Display="Dynamic" ValidationGroup="new"  /></td>
    </tr>
    <tr>
        <td colspan="2">
            <asp:Button ID="ButtonNewName" runat="server" Text="Добавить" OnClick="ButtonNew_Click"
                ValidationGroup="new" /></td>
    </tr>
</table>
<br />
<%--  Grid View --%>
<asp:GridView ID="GridViewPost" runat="server" AllowSorting="True" DataKeyNames="ID"
    DataSourceID="SqlDataSourcePost" OnRowDataBound="GridViewPost_RowDataBound"
    AutoGenerateColumns="False">
    <Columns>
        <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ButtonType="Button"
            CancelText="Отмена" DeleteText="Удалить" EditText="Изменить" UpdateText="Сохранить" />
        <asp:TemplateField HeaderText="Должность" SortExpression="Name">
            <ItemTemplate>
                <asp:Label ID="LabelEditName" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="TextBoxEditName" runat="server" Text='<%# Bind("Name") %>' Width="300"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorEditName" runat="server" ErrorMessage="Введите данные"
                    ControlToValidate="TextBoxEditName" Display="Dynamic"><br/>Введите данные</asp:RequiredFieldValidator>
            </EditItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Сокращено" SortExpression="ShortName">
            <ItemTemplate>
                <asp:Label ID="LabelEditShortName" runat="server" Text='<%# Bind("ShortName") %>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="TextBoxEditShortName" runat="server" Text='<%# Bind("ShortName") %>' Width="150"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorEditShortName" runat="server"
                    ErrorMessage="Введите короткое название" ControlToValidate="TextBoxEditShortName"
                    Display="Dynamic"><br/>Введите короткое название</asp:RequiredFieldValidator>
            </EditItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Порядок" SortExpression="Order">
            <ItemTemplate>
                <asp:Label ID="LabelEditOrder" runat="server" Text='<%# Bind("Order") %>'></asp:Label>
            </ItemTemplate>        
            <EditItemTemplate>
                <asp:TextBox ID="TextBoxEditOrder" runat="server" Text='<%# Bind("Order") %>' Width="50"></asp:TextBox>
                <asp:CompareValidator ID="CompareValidatorEditOrder" runat="server" ErrorMessage="Введите число"
                    ControlToValidate="TextBoxEditOrder" Type="Integer" Operator="DataTypeCheck"
                    Display="Dynamic"><br />Введите число</asp:CompareValidator>
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorEditOrder" runat="server" ErrorMessage="Введите число"
                    ControlToValidate="TextBoxEditOrder" Display="Dynamic"><br/>Введите число</asp:RequiredFieldValidator>
            </EditItemTemplate>
        </asp:TemplateField>
    </Columns>
    <EmptyDataTemplate>
        Нет должностей
    </EmptyDataTemplate>
</asp:GridView>

