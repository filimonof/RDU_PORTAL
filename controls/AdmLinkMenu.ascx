<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdmLinkMenu.ascx.cs" Inherits="controls_AdmLinkMenu" %>
<%--Администрирование ссылок--%>
<div class="font_caption color_yellow">Администрирование ссылок</div>
<br />
<asp:SqlDataSource ID="SqlDataSourceLinkMenu" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    DeleteCommand="DELETE FROM [LinkMenu] WHERE [ID] = @ID" 
    InsertCommand="INSERT INTO [LinkMenu] ([Name], [Link], [InternetLink], [Order], [Enabled]) VALUES (@Name, @Link, @InternetLink, @Order, @Enabled)" 
    SelectCommand="SELECT * FROM [LinkMenu]" 
    UpdateCommand="UPDATE [LinkMenu] SET [Name] = @Name, [Link] = @Link, [InternetLink] = @InternetLink, [Order] = @Order, [Enabled] = @Enabled WHERE [ID] = @ID" >
    <DeleteParameters>
        <asp:Parameter Name="ID" Type="Int32" />
    </DeleteParameters>
    <UpdateParameters>
        <asp:Parameter Name="Name" Type="String" />
        <asp:Parameter Name="Link" Type="String" />
        <asp:Parameter Name="InternetLink" Type="Boolean" />
        <asp:Parameter Name="Order" Type="Int32" />
        <asp:Parameter Name="Enabled" Type="Boolean" />
        <asp:Parameter Name="ID" Type="Int32" />
    </UpdateParameters>
    <InsertParameters>
        <asp:ControlParameter ControlID="TextBoxNewName" Name="Name" PropertyName="Text" Type="String" />
        <asp:ControlParameter ControlID="TextBoxNewLink" Name="Link" PropertyName="Text" Type="String" />
        <asp:ControlParameter ControlID="CheckBoxNewInternetLink" Name="InternetLink" PropertyName="Checked" Type="Boolean" />
        <asp:ControlParameter ControlID="TextBoxNewOrder" Name="Order" PropertyName="Text" Type="Int32" />
        <asp:ControlParameter ControlID="CheckBoxNewEnabled" Name="Enabled" PropertyName="Checked" Type="Boolean" />
    </InsertParameters>
</asp:SqlDataSource>
<%--  New --%>
<table border="0">
    <tr>
        <td><asp:Label ID="LabelNewName" runat="server" Text="Название ссылки" /></td>
        <td><asp:TextBox ID="TextBoxNewName" runat="server" ValidationGroup="new" Width="300" />
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewName" runat="server" ErrorMessage="Введите данные"
                ControlToValidate="TextBoxNewName" Display="Dynamic" ValidationGroup="new" /></td>
    </tr>
    <tr>
        <td><asp:Label ID="LabelNewLink" runat="server" Text="Ссылка" /></td>
        <td><asp:TextBox ID="TextBoxNewLink" runat="server" ValidationGroup="new" Width="150"/>
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewLink" runat="server" ErrorMessage="Введите данные или # если нужна пустая ссылка"
            ControlToValidate="TextBoxNewLink" Display="Dynamic" ValidationGroup="new" /></td>
    </tr>
    <tr>
        <td><asp:Label ID="LabelNewInternetLink" runat="server" Text="Ссылка в интернет" /></td>
        <td><asp:CheckBox ID="CheckBoxNewInternetLink" runat="server" Checked="false" /></td>
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
        <td>Активно</td>
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
<asp:GridView ID="GridViewLinkMenu" runat="server" AllowSorting="True" DataKeyNames="ID"
    DataSourceID="SqlDataSourceLinkMenu" OnRowDataBound="GridViewLinkMenu_RowDataBound"
    AutoGenerateColumns="False">
    <Columns>
        <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ButtonType="Button"
            CancelText="Отмена" DeleteText="Удалить" EditText="Изменить" UpdateText="Сохранить" />
        <asp:TemplateField HeaderText="Имя" SortExpression="Name">
            <ItemTemplate>
                <asp:Label ID="LabelEditName" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="TextBoxEditName" runat="server" Text='<%# Bind("Name") %>' Width="200"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorEditName" runat="server" ErrorMessage="Введите данные"
                    ControlToValidate="TextBoxEditName" Display="Dynamic"><br/>Введите данные</asp:RequiredFieldValidator>
            </EditItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Ссылка" SortExpression="Link">
            <ItemTemplate>
                <asp:Label ID="LabelEditLink" runat="server" Text='<%# Bind("Link") %>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="TextBoxEditLink" runat="server" Text='<%# Bind("Link") %>' Width="200"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorEditLink" runat="server"
                    ErrorMessage="Введите данные или #" ControlToValidate="TextBoxEditLink"
                    Display="Dynamic"><br/>Введите данные или #</asp:RequiredFieldValidator>
            </EditItemTemplate>
        </asp:TemplateField>
        <asp:CheckBoxField DataField="InternetLink" HeaderText="В интернет" SortExpression="InternetLink" />
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
        <asp:CheckBoxField DataField="Enabled" HeaderText="Активно" SortExpression="Enabled" />
    </Columns>
    <EmptyDataTemplate>
        Нет ссылок
    </EmptyDataTemplate>
</asp:GridView>