<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdmUser.ascx.cs" Inherits="controls_AdmUser" %>
<%--Администрирование учётных записей пользователей--%>
<div class="font_caption color_yellow">Администрирование учётных записей пользователей</div>
<br />
<asp:SqlDataSource ID="SqlDataSourceUser" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    DeleteCommand="DELETE FROM [User] WHERE [ID] = @ID" 
    InsertCommand="INSERT INTO [User] ([DomainName], [Enabled]) VALUES (@DomainName, @Enabled)" 
    SelectCommand="SELECT * FROM [User]" 
    UpdateCommand="UPDATE [User] SET [DomainName] = @DomainName, [Enabled] = @Enabled WHERE [ID] = @ID">
    <DeleteParameters>
        <asp:Parameter Name="ID" Type="Int32" />
    </DeleteParameters>
    <UpdateParameters>
        <asp:Parameter Name="DomainName" Type="String" />
        <asp:Parameter Name="Enabled" Type="Boolean" />
        <asp:Parameter Name="ID" Type="Int32" />
    </UpdateParameters>
    <InsertParameters>
        <asp:ControlParameter ControlID="TextBoxNewName" Name="DomainName" PropertyName="Text" Type="String" />
        <asp:ControlParameter ControlID="CheckBoxNewEnabled" Name="Enabled" PropertyName="Checked" Type="Boolean" />
    </InsertParameters>
</asp:SqlDataSource>
<%--  New --%>
<table border="0">
    <tr>
        <td><asp:Label ID="LabelNewName" runat="server" Text="Новый пользователь" /></td>
        <td><asp:TextBox ID="TextBoxNewName" runat="server" ValidationGroup="new" Width="200" />
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewName" runat="server" ErrorMessage="Введите данные"
                ControlToValidate="TextBoxNewName" Display="Dynamic" ValidationGroup="new" />
                <asp:CustomValidator ID="CustomValidatorUnique" runat="server" ErrorMessage="Учетная запись существует" 
                ControlToValidate="TextBoxNewName" Display="Dynamic" ValidationGroup="new" OnServerValidate="ServerValidate" /></td>
    </tr>
    <tr>
        <td><asp:Label ID="LabelNewEnabled" runat="server" Text="Активен" /></td>
        <td><asp:CheckBox ID="CheckBoxNewEnabled" runat="server" Checked="false" /></td>
    </tr>
    <tr>
        <td colspan="2">
            <asp:Button ID="ButtonNewName" runat="server" Text="Добавить" OnClick="ButtonNew_Click"
                ValidationGroup="new" /></td>
    </tr>
</table>
<br />
<%--  Grid View --%>
<asp:GridView ID="GridViewUser" runat="server" AllowSorting="True" DataKeyNames="ID"
    DataSourceID="SqlDataSourceUser" OnRowDataBound="GridViewUser_RowDataBound"
    AutoGenerateColumns="False">
    <Columns>
        <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ButtonType="Button"
            CancelText="Отмена" DeleteText="Удалить" EditText="Изменить" UpdateText="Сохранить" />
        <asp:TemplateField HeaderText="Учётная запись" SortExpression="DomainName">
            <ItemTemplate>
                <asp:Label ID="LabelEditName" runat="server" Text='<%# Bind("DomainName") %>'  Width="200" ></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="TextBoxEditName" runat="server" Text='<%# Bind("DomainName") %>' Width="200"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorEditName" runat="server" ErrorMessage="Введите данные"
                    ControlToValidate="TextBoxEditName" Display="Dynamic"><br/>Введите данные</asp:RequiredFieldValidator>
            </EditItemTemplate>
        </asp:TemplateField>
        <asp:CheckBoxField DataField="Enabled" HeaderText="Активно" SortExpression="Enabled" />
    </Columns>
    <EmptyDataTemplate>
        Нет учётных записей
    </EmptyDataTemplate>
</asp:GridView>

