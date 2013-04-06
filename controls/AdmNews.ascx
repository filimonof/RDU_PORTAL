<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdmNews.ascx.cs" Inherits="controls_AdmNews" %>
<%-- Администрирование новостных лент --%>
<div class="font_caption color_yellow">Администрирование новостных лент</div>
<br />
<asp:SqlDataSource ID="SqlDataSourceNews" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    DeleteCommand="DELETE FROM [NewsTitle] WHERE [ID] = @ID" 
    InsertCommand="INSERT INTO [NewsTitle] ([Name], [Link], [TypeID], [Order], [Enabled]) VALUES (@Name, @Link, @TypeID, @Order, @Enabled)" 
    SelectCommand="SELECT * FROM [NewsTitle]" 
    UpdateCommand="UPDATE [NewsTitle] SET [Name] = @Name, [Link] = @Link, [TypeID] = @TypeID, [Order] = @Order, [Enabled] = @Enabled WHERE [ID] = @ID">
    <DeleteParameters>
        <asp:Parameter Name="ID" Type="Int32" />
    </DeleteParameters>
    <UpdateParameters>
        <asp:Parameter Name="Name" Type="String" />
        <asp:Parameter Name="Link" Type="String" />        
        <asp:Parameter Name="TypeID" Type="Int32" />
        <asp:Parameter Name="Order" Type="Int32" />
        <asp:Parameter Name="Enabled" Type="Boolean" />
        <asp:Parameter Name="ID" Type="Int32" />
    </UpdateParameters>
    <InsertParameters>
        <asp:ControlParameter ControlID="TextBoxNewName" Name="Name" PropertyName="Text" Type="String" />
        <asp:ControlParameter ControlID="TextBoxNewLink" Name="Link" PropertyName="Text" Type="String" />        
        <asp:ControlParameter ControlID="DropDownNewType" Name="TypeID" PropertyName="SelectedValue" Type="Int32" />
        <asp:ControlParameter ControlID="TextBoxNewOrder" Name="Order" PropertyName="Text" Type="Int32" />
        <asp:ControlParameter ControlID="CheckBoxNewEnabled" Name="Enabled" PropertyName="Checked" Type="Boolean" />
    </InsertParameters>
</asp:SqlDataSource>    
<asp:SqlDataSource ID="SqlDataSourceNewsType" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    SelectCommand="SELECT * FROM [NewsType]" />
<%--  New --%>
<table border="0">
    <tr>
        <td>&nbsp;</td>
        <td><asp:CheckBox ID="CheckBoxNewEnabled" runat="server" Checked="true" Text="Активно" /></td>
    </tr>
    <tr>
        <td><asp:Label ID="LabelNewName" runat="server" Text="Название новостной ленты" /></td>
        <td><asp:TextBox ID="TextBoxNewName" runat="server" ValidationGroup="new" Width="300" />
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewName" runat="server" ErrorMessage="Введите название"
                ControlToValidate="TextBoxNewName" Display="Dynamic" ValidationGroup="new" /></td>
    </tr>
    <tr>
        <td><asp:Label ID="LabelNewLink" runat="server" Text="Ссылка на новостную ленту" /></td>
        <td><asp:TextBox ID="TextBoxNewLink" runat="server" ValidationGroup="new" Width="300" />
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewLink" runat="server" ErrorMessage="Введите адресс новостей в интернет"
                ControlToValidate="TextBoxNewLink" Display="Dynamic" ValidationGroup="new" /></td>
    </tr>    
    <tr>
        <td><asp:Label ID="LabelNewType" runat="server" Text="Тип новостной ленты" /></td>
        <td><asp:DropDownList ID="DropDownNewType" runat="server" DataSourceID="SqlDataSourceNewsType"  
            Width="150px" DataTextField="Name" DataValueField="ID" />
        </td>
    </tr>
    <tr>
        <td><asp:Label ID="LabelNewImage" runat="server" Text="Картинка" />
            <br />
            <asp:Label ID="LabelNewImageComment" CssClass="font_small" runat="server" Text="рекомендуется 24 на 24 jpeg" /></td>
        <td><asp:Image ID="ImageUser" runat="server" ImageUrl="~/Img.ashx?type=news" Width="24" Height="24" AlternateText="" /></td>
    </tr>
    <tr>
        <td><asp:Label ID="LabelNewOrder" runat="server" Text="Порядок вывода" /></td>
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
<br />
<%--  Grid View --%>
<asp:GridView ID="GridViewNews" runat="server" AllowSorting="True" DataKeyNames="ID"
    DataSourceID="SqlDataSourceNews" OnRowDataBound="GridViewNews_RowDataBound"
    AutoGenerateColumns="False">
    <Columns>
        <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ButtonType="Button"
            CancelText="Отмена" DeleteText="Удалить" EditText="Изменить" UpdateText="Сохранить" />
        <asp:CheckBoxField DataField="Enabled" HeaderText="Активно" SortExpression="Enabled" />
        <asp:TemplateField HeaderText="Название" SortExpression="Name">
            <ItemTemplate>
                <asp:Label ID="LabelEditName" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="TextBoxEditName" runat="server" Text='<%# Bind("Name") %>' Width="200"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorEditName" runat="server" ErrorMessage="Введите название"
                    ControlToValidate="TextBoxEditName" Display="Dynamic"><br/>Введите название</asp:RequiredFieldValidator>
            </EditItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Ссылка" SortExpression="Link">
            <ItemTemplate>
                <asp:Label ID="LabelEditLink" runat="server" Text='<%# Bind("Link") %>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="TextBoxEditLink" runat="server" Text='<%# Bind("Link") %>' Width="200"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorEditLink" runat="server" ErrorMessage="Введите ссылку"
                    ControlToValidate="TextBoxEditLink" Display="Dynamic"><br/>Введите ссылку</asp:RequiredFieldValidator>
            </EditItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Картинка">
            <ItemTemplate>
                <asp:Image ID="ImageNews" runat="server" ImageUrl='<%# string.Format("~/Img.ashx?type=news&id={0}", Eval("ID")) %>' Width="24" Height="24" AlternateText="" />
            </ItemTemplate>
            <EditItemTemplate>
                <asp:Image ID="ImageNews" runat="server" ImageUrl='<%# string.Format("~/Img.ashx?type=news&id={0}", Eval("ID")) %>' Width="24" Height="24" AlternateText="" />
            </EditItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Тип" SortExpression="TypeID">
            <ItemTemplate>
                <asp:Label ID="LabelGridType" runat="server" ></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>                
                <asp:DropDownList ID="DropDownListType" runat="server" DataSourceID="SqlDataSourceNewsType"   SelectedValue='<%# Bind("TypeID") %>'
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
    </Columns>
    <EmptyDataTemplate>
        Новостных каналов нету
    </EmptyDataTemplate>    
</asp:GridView>