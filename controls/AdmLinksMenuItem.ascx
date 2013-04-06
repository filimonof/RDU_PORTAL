<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdmLinksMenuItem.ascx.cs"
    Inherits="controls_AdmLinksMenuItem" %>
<%--Администрирование ссылок--%>
<div class="font_caption color_yellow">Администрирование ссылок</div>
<br />
<%--Data Source с ссылками --%>
<asp:SqlDataSource ID="SqlDataSourceItems" runat="server" 
ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
    DeleteCommand="DELETE FROM [LinksMenuItem] WHERE [ID] = @ID" 
    InsertCommand="INSERT INTO [LinksMenuItem] ([Name], [Link], [CaptionID], [Order], [Enabled]) VALUES (@Name, @Link, @CaptionID, @Order, @Enabled)"
    SelectCommand="SELECT * FROM [LinksMenuItem]" 
    UpdateCommand="UPDATE [LinksMenuItem] SET [Name] = @Name, [Link] = @Link, [CaptionID] = @CaptionID, [Order] = @Order, [Enabled] = @Enabled WHERE [ID] = @ID">
    <DeleteParameters>
        <asp:Parameter Name="ID" Type="Int32" />
    </DeleteParameters>
    <UpdateParameters>
        <asp:Parameter Name="Name" Type="String" />
        <asp:Parameter Name="Link" Type="String" />
        <asp:Parameter Name="CaptionID" Type="Int32" />
        <asp:Parameter Name="Order" Type="Int32" />
        <asp:Parameter Name="Enabled" Type="Boolean" />
        <asp:Parameter Name="ID" Type="Int32" />
    </UpdateParameters>
    <InsertParameters>
        <asp:ControlParameter ControlID="TextBoxNewName" Name="Name" PropertyName="Text" Type="String" />
        <asp:ControlParameter ControlID="TextBoxNewLink" Name="Link" PropertyName="Text" Type="String" />
        <asp:ControlParameter ControlID="DropDownNewCaption" Name="CaptionID" PropertyName="SelectedValue" Type="Int32" />      
        <asp:ControlParameter ControlID="TextBoxNewOrder" Name="Order" PropertyName="Text" Type="Int32" />
        <asp:ControlParameter ControlID="CheckBoxNewEnabled" Name="Enabled" PropertyName="Checked" Type="Boolean" />
    </InsertParameters>
</asp:SqlDataSource>
<%--Data Source группами --%>
<asp:SqlDataSource ID="SqlDataSourceCaptions" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
    SelectCommand="SELECT * FROM [LinksMenuCaption] ORDER BY [Order]">
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
        <td><asp:Label ID="LabelNewCaption" runat="server" Text="Группа ссылок" /></td>
        <td><asp:DropDownList ID="DropDownNewCaption" runat="server" DataSourceID="SqlDataSourceCaptions"  
            Width="150px" DataTextField="Name" DataValueField="ID" /></td>
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
<asp:GridView ID="GridViewItems" runat="server" AllowSorting="True" DataKeyNames="ID"
    DataSourceID="SqlDataSourceItems" OnRowDataBound="GridViewItems_RowDataBound"
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
         <asp:TemplateField HeaderText="Группа ссылок" SortExpression="CaptionID">
            <ItemTemplate>
                <asp:Label ID="LabelCaption" runat="server" ></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>                
                <asp:DropDownList ID="DropDownListType" runat="server" DataSourceID="SqlDataSourceCaptions"   SelectedValue='<%# Bind("CaptionID") %>'
                    Width="150px" DataTextField="Name" DataValueField="ID" />
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
        Нет ссылок
    </EmptyDataTemplate>
</asp:GridView>