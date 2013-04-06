<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdmRule.ascx.cs" Inherits="controls_AdmRule" %>
<%--Администрирование правил (доступа)--%>
<div class="font_caption color_yellow">Администрирование правил</div>
<br />
<asp:SqlDataSource ID="SqlDataSourceRule" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    DeleteCommand="DELETE FROM [Rule] WHERE [ID] = @ID" 
    InsertCommand="INSERT INTO [Rule] ([ID], [Name]) VALUES (@ID, @Name)" 
    SelectCommand="SELECT * FROM [Rule]" 
    UpdateCommand="UPDATE [Rule] SET [Name] = @Name WHERE [ID] = @ID">
    <DeleteParameters>
        <asp:Parameter Name="ID" Type="Int32" />
    </DeleteParameters>
    <UpdateParameters>
        <asp:Parameter Name="Name" Type="String" />
        <asp:Parameter Name="ID" Type="Int32" />
    </UpdateParameters>
    <InsertParameters>
        <asp:ControlParameter ControlID="TextBoxNewID" Name="ID" PropertyName="Text" Type="Int32" />
        <asp:ControlParameter ControlID="TextBoxNewName" Name="Name" PropertyName="Text" Type="String" />
    </InsertParameters>
</asp:SqlDataSource>
<%--  New --%>
<table border="0">    
    <tr>
        <td><asp:Label ID="LabelNewID" runat="server" Text="Номер правила" /></td>
        <td><asp:TextBox ID="TextBoxNewID" runat="server" ValidationGroup="new" Width="50" />
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewID" runat="server" ErrorMessage="Введите данные"
                ControlToValidate="TextBoxNewID" Display="Dynamic" ValidationGroup="new" />
            <asp:CompareValidator ID="CompareValidatorNewID" runat="server" ErrorMessage="Введите число"
                ControlToValidate="TextBoxNewID" Type="Integer" Operator="DataTypeCheck" Display="Dynamic" ValidationGroup="new" /></td>
    </tr>
    <tr>    
        <td><asp:Label ID="LabelNewName" runat="server" Text="Название правила" /></td>
        <td><asp:TextBox ID="TextBoxNewName" runat="server" ValidationGroup="new" Width="300" />
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewName" runat="server" ErrorMessage="Введите данные"
                ControlToValidate="TextBoxNewName" Display="Dynamic" ValidationGroup="new" /></td>
    </tr>
    <tr>
        <td colspan="2">
            <asp:Button ID="ButtonNewName" runat="server" Text="Добавить" OnClick="ButtonNew_Click"
                ValidationGroup="new" /></td>
    </tr>
</table>
<br />
<asp:Button ID="ButtonSynhro" runat="server" Text="Синхронизация" OnClick="ButtonSync_Click" />
<br />
<br />
<%--  Grid View --%>
<asp:GridView ID="GridViewRule" runat="server" AllowSorting="True" DataKeyNames="ID" 
    DataSourceID="SqlDataSourceRule" OnRowDataBound="GridViewRule_RowDataBound" AutoGenerateColumns="False">
    <Columns>
        <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ButtonType="Button"
            CancelText="Отмена" DeleteText="Удалить" EditText="Изменить" UpdateText="Сохранить" />            
        <asp:TemplateField HeaderText="Номер" SortExpression="ID">
            <ItemTemplate>
                <asp:Label ID="LabelEditID" runat="server" Text='<%# Bind("ID") %>'></asp:Label>
            </ItemTemplate>        
            <EditItemTemplate>
                <asp:Label ID="LabelEditID" runat="server" Text='<%# Bind("ID") %>'></asp:Label>
                <%--<asp:TextBox ID="TextBoxEditID" runat="server" Text='<%# Bind("ID") %>' Width="50"></asp:TextBox>
                <asp:CompareValidator ID="CompareValidatorEditID" runat="server" ErrorMessage="Введите число"
                    ControlToValidate="TextBoxEditID" Type="Integer" Operator="DataTypeCheck"
                    Display="Dynamic"><br />Введите число</asp:CompareValidator>
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorEditID" runat="server" ErrorMessage="Введите число"
                    ControlToValidate="TextBoxEditID" Display="Dynamic"><br/>Введите число</asp:RequiredFieldValidator>--%>
            </EditItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Правило" SortExpression="Name">
            <ItemTemplate>
                <asp:Label ID="LabelEditName" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="TextBoxEditName" runat="server" Text='<%# Bind("Name") %>' Width="300"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorEditName" runat="server" ErrorMessage="Введите данные"
                    ControlToValidate="TextBoxEditName" Display="Dynamic"><br/>Введите данные</asp:RequiredFieldValidator>
            </EditItemTemplate>
        </asp:TemplateField>
    </Columns>
    <EmptyDataTemplate>
        Нет правил
    </EmptyDataTemplate>
</asp:GridView>
