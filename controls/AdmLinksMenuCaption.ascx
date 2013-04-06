<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdmLinksMenuCaption.ascx.cs" Inherits="controls_AdmLinksMenuCaption" %>
<%--Администрирование ссылок--%>
<div class="font_caption color_yellow">Администрирование ссылок</div>
<br />
<%--Data Source списка заголовков --%>
<asp:SqlDataSource ID="SqlDataSourceCaption" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
    SelectCommand="SELECT * FROM [LinksMenuCaption]"       
    DeleteCommand="DELETE FROM [LinksMenuCaption] WHERE [ID] = @ID" 
    InsertCommand="INSERT INTO [LinksMenuCaption] ([Name], [Order], [Enabled]) VALUES (@Name, @Order, @Enabled)"     
    UpdateCommand="UPDATE [LinksMenuCaption] SET [Name] = @Name, [Order] = @Order, [Enabled] = @Enabled WHERE [ID] = @ID" >
    <DeleteParameters>
        <asp:Parameter Name="ID" Type="Int32" />
    </DeleteParameters>
    <UpdateParameters>
        <asp:Parameter Name="Name" Type="String" />
        <asp:Parameter Name="Order" Type="Int32" />
        <asp:Parameter Name="Enabled" Type="Boolean" />
        <asp:Parameter Name="ID" Type="Int32" />
    </UpdateParameters>
    <InsertParameters>
        <asp:ControlParameter ControlID="TextBoxNewName" Name="Name" PropertyName="Text" Type="String" />
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
        <td><asp:Label ID="LabelNewOrder" runat="server" Text="Порядок сортировки" /></td>
        <td><asp:TextBox ID="TextBoxNewOrder" runat="server" ValidationGroup="new" Width="50" Text="100" />
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewOrder" runat="server" ErrorMessage="Введите данные"
                ControlToValidate="TextBoxNewOrder" Display="Dynamic" ValidationGroup="new" />
            <asp:CompareValidator ID="CompareValidatorNewOrder" runat="server" ErrorMessage="Введите число"
                ControlToValidate="TextBoxNewOrder" Type="Integer" Operator="DataTypeCheck" Display="Dynamic" ValidationGroup="new"  /></td>
    </tr>
    <tr>
        <td>Активно</td>
        <td><asp:CheckBox ID="CheckBoxNewEnabled" runat="server" Checked="true" /></td>
    </tr>
    <tr>
        <td colspan="2">
            <asp:Button ID="ButtonNewName" runat="server" Text="Добавить" OnClick="ButtonNew_Click"
                ValidationGroup="new" /></td>
    </tr>
</table>
<br />
<%--  Grid View --%>
<asp:GridView ID="GridViewCaption" runat="server" AllowSorting="True" DataKeyNames="ID"
    DataSourceID="SqlDataSourceCaption" OnRowDataBound="GridViewCaption_RowDataBound"
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
        Нет групп ссылок
    </EmptyDataTemplate>
</asp:GridView>
