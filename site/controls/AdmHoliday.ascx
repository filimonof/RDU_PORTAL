<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdmHoliday.ascx.cs" Inherits="controls_AdmHoliday" %>
<%--НАстройка праздников--%>
<div class="font_caption color_yellow">Праздники</div>
<br />
<asp:SqlDataSource ID="SqlDataSourceHoliday" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
    DeleteCommand="DELETE FROM [Holiday] WHERE [ID] = @ID" 
    InsertCommand="INSERT INTO [Holiday] ([Name], [Day], [Month]) VALUES (@Name, @Day, @Month)"
    SelectCommand="SELECT * FROM [Holiday] ORDER BY [Month], [Day]" 
    UpdateCommand="UPDATE [Holiday] SET [Name] = @Name, [Day] = @Day, [Month] = @Month WHERE [ID] = @ID">
    <DeleteParameters>
        <asp:Parameter Name="ID" Type="Int32" />
    </DeleteParameters>
    <UpdateParameters>
        <asp:Parameter Name="Name" Type="String" />        
        <asp:Parameter Name="Day" Type="Int32" />
        <asp:Parameter Name="Month" Type="Int32" />
        <asp:Parameter Name="ID" Type="Int32" />
    </UpdateParameters>
    <InsertParameters>
        <asp:ControlParameter ControlID="TextBoxNewName" Name="Name" PropertyName="Text" Type="String" />        
        <asp:ControlParameter ControlID="TextBoxNewDay" Name="Day" PropertyName="Text" Type="Int32" />
        <asp:ControlParameter ControlID="TextBoxNewMonth" Name="Month" PropertyName="Text" Type="Int32" />
    </InsertParameters>
</asp:SqlDataSource>
<%--  New --%>
<table border="0">
    <tr>
        <td><asp:Label ID="LabelNewName" runat="server" Text="Название праздника" /></td>
        <td><asp:TextBox ID="TextBoxNewName" runat="server" ValidationGroup="new" Width="200" />
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewName" runat="server" ErrorMessage="Введите название"
                ControlToValidate="TextBoxNewName" Display="Dynamic" ValidationGroup="new" /></td>
    </tr>
    <tr>
        <td><asp:Label ID="LabelNewImage" runat="server" Text="Картинка" /></td>
        <td><asp:Image ID="ImageUser" CssClass="user_img" runat="server" ImageUrl="~/Img.ashx?type=holiday" Width="80" Height="90" AlternateText="" /></td>
    </tr>
    <tr>
        <td><asp:Label ID="LabelNewDay" runat="server" Text="День" /></td>
        <td><asp:TextBox ID="TextBoxNewDay" runat="server" ValidationGroup="new" Width="50" />
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewDay" runat="server" ErrorMessage="Введите день"
                ControlToValidate="TextBoxNewDay" Display="Dynamic" ValidationGroup="new" /></td>
    </tr>
    <tr>
        <td><asp:Label ID="LabelNewMonth" runat="server" Text="Месяц" /></td>
        <td><asp:TextBox ID="TextBoxNewMonth" runat="server" ValidationGroup="new" Width="50" />
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewMonth" runat="server" ErrorMessage="Введите месяц"
                ControlToValidate="TextBoxNewMonth" Display="Dynamic" ValidationGroup="new" />
            <asp:RangeValidator ID="RangeValidatorNewMonth" runat="server" 
                ErrorMessage="Значение от 1 до 12" ControlToValidate="TextBoxNewMonth" 
                Display="Dynamic" MaximumValue="12" MinimumValue="1" Type="Integer" 
                ValidationGroup="new" /></td>
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
<asp:GridView ID="GridViewHoliday" runat="server" AllowSorting="True" DataKeyNames="ID"
    DataSourceID="SqlDataSourceHoliday" OnRowDataBound="GridViewHoliday_RowDataBound"
    AutoGenerateColumns="False">
    <Columns>
        <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ButtonType="Button"
            CancelText="Отмена" DeleteText="Удалить" EditText="Изменить" UpdateText="Сохранить" />
        <asp:TemplateField HeaderText="Картинка">
            <ItemTemplate>
                <asp:Image ID="ImageHoliday" runat="server" ImageUrl='<%# GetHolidayFotoLink(Eval("ID")) %>' Width="80" Height="90" AlternateText="" />
            </ItemTemplate>
            <EditItemTemplate>
                <asp:Image ID="ImageHoliday" runat="server" ImageUrl='<%# GetHolidayFotoLink(Eval("ID")) %>' Width="80" Height="90" AlternateText="" />
            </EditItemTemplate>
        </asp:TemplateField>
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
        <asp:TemplateField HeaderText="День" SortExpression="Day">
            <ItemTemplate>
                <asp:Label ID="LabelEditDay" runat="server" Text='<%# Bind("Day") %>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="TextBoxEditDay" runat="server" Text='<%# Bind("Day") %>' Width="50"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorEditDay" runat="server" ErrorMessage="День введён не корректно"
                    ControlToValidate="TextBoxEditDay" Display="Dynamic"><br/>День введён не корректно</asp:RequiredFieldValidator>
            </EditItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Месяц" SortExpression="Month">
            <ItemTemplate>
                <asp:Label ID="LabelEditMonth" runat="server" Text='<%# Bind("Month") %>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="TextBoxEditMonth" runat="server" Text='<%# Bind("Month") %>' Width="50"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorEditMonth" runat="server" ErrorMessage="Месяц введён не корректно"
                    ControlToValidate="TextBoxEditMonth" Display="Dynamic"><br/>Месяц введён не корректно</asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidatorMonth" runat="server" ControlToValidate="TextBoxEditMonth" 
                    Display="Dynamic" MaximumValue="12" MinimumValue="1" Type="Integer" ErrorMessage="Значение от 1 до 12"><br/>Значение от 1 до 12</asp:RangeValidator>
            </EditItemTemplate>
        </asp:TemplateField>
    </Columns>
    <EmptyDataTemplate>
        Праздники не введены
    </EmptyDataTemplate>
</asp:GridView>
