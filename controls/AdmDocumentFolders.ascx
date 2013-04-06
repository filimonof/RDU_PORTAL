<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdmDocumentFolders.ascx.cs"
    Inherits="controls_AdmDocumentFolders" %>
<%--Администрирование папок с документами--%>
<div class="font_caption color_yellow">Администрирование папок с документами</div>
<br />
<%--DataSource доступа папки--%>
<asp:SqlDataSource ID="SqlDataSourceAccessFolder" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    SelectCommand="SELECT FolderRule.[ID], SelectRule.[ID] AS RuleGroupID, SelectRule.[Name], FolderRule.[IsWriter] FROM 
        (
	        SELECT [RuleGroup].[ID], [RuleGroup].[Name]
	        FROM (SELECT [RuleGroupID] FROM [Rule_To_RuleGroup] WHERE [RuleID] = @RuleDocument) AS Gr INNER JOIN
	        [RuleGroup] ON Gr.[RuleGroupID] = [RuleGroup].[ID]
        ) AS SelectRule
        LEFT OUTER JOIN 
        (
	        SELECT * FROM DocumentFolder_To_RuleGroup WHERE DocumentFolderID = @FolderID
        ) AS FolderRule ON SelectRule.[ID] = FolderRule.[RuleGroupID] "
    InsertCommand="INSERT INTO [DocumentFolder_To_RuleGroup] ([DocumentFolderID], [RuleGroupID], [IsWriter]) VALUES (@DocumentFolderID, @RuleGroupID, @IsWriter)"
    DeleteCommand="DELETE FROM [DocumentFolder_To_RuleGroup] WHERE [ID]=@ID"
    UpdateCommand="UPDATE [DocumentFolder_To_RuleGroup] SET [IsWriter] = @IsWriter WHERE [ID] = @ID" >      
    <SelectParameters>
        <asp:Parameter Name="RuleDocument" Type="Int32" />    
        <asp:Parameter Name="FolderID" Type="Int32" />    
    </SelectParameters>
    <InsertParameters>    
        <asp:Parameter Name="DocumentFolderID" Type="Int32" />    
        <asp:Parameter Name="RuleGroupID" Type="Int32" />    
        <asp:Parameter Name="IsWriter" Type="Boolean" />    
    </InsertParameters>
    <DeleteParameters>
        <asp:Parameter Name="ID" Type="Int32" />
    </DeleteParameters>
    <UpdateParameters>
        <asp:Parameter Name="IsWriter" Type="Boolean" />
        <asp:Parameter Name="ID" Type="Int32" />
    </UpdateParameters>
</asp:SqlDataSource>
<%--DataSource родительских папок--%>
<asp:SqlDataSource ID="SqlDataSourceDocumentFoldersCicle" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    SelectCommand="SELECT * FROM [DocumentFolder] ORDER BY [ParentFolderID] ASC, [Order] ASC">
    <SelectParameters>
        <asp:Parameter Name="currentID" Type="Int32" />    
    </SelectParameters>
</asp:SqlDataSource>
<%--DataSource папок--%>
<asp:SqlDataSource ID="SqlDataSourceDocumentFolders" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    SelectCommand="SELECT * FROM [DocumentFolder]" 
    DeleteCommand="DELETE FROM [DocumentFolder] WHERE [ID] = @ID" 
    InsertCommand="DocumentFolder_Add" InsertCommandType="StoredProcedure"
    UpdateCommand="UPDATE [DocumentFolder] SET [Name] = @Name, [ParentFolderID] = @ParentFolderID, [Order] = @Order WHERE [ID] = @ID">
    <DeleteParameters>
        <asp:Parameter Name="ID" Type="Int32" />
    </DeleteParameters>
    <UpdateParameters>
        <asp:Parameter Name="Name" Type="String" />
        <asp:Parameter Name="ParentFolderID" Type="Int32" />
        <asp:Parameter Name="Order" Type="Int32" />
        <asp:Parameter Name="ID" Type="Int32" />
    </UpdateParameters>
    <InsertParameters>
        <asp:ControlParameter ControlID="TextBoxNewName" Name="Name" PropertyName="Text" Type="String" />        
        <asp:ControlParameter ControlID="DropDownListParent" Name="ParentFolderID" PropertyName="SelectedValue" Type="Int32" />      
        <asp:ControlParameter ControlID="TextBoxNewOrder" Name="Order" PropertyName="Text" Type="Int32" />        
    </InsertParameters>
</asp:SqlDataSource>
<%--  New --%>
<table border="0">
    <tr>
        <td><asp:Label ID="LabelNewName" runat="server" Text="Название папки" /></td>
        <td><asp:TextBox ID="TextBoxNewName" runat="server" ValidationGroup="new" Width="300" />
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewName" runat="server" ErrorMessage="Введите данные"
                ControlToValidate="TextBoxNewName" Display="Dynamic" ValidationGroup="new" /></td>
    </tr>
    <tr>
        <td><asp:Label ID="LabelNewParent" runat="server" Text="Родительская папка" /></td>
        <td><asp:DropDownList ID="DropDownListParent" runat="server" AppendDataBoundItems="True" Width="300" 
                DataSourceID="SqlDataSourceDocumentFolders" DataTextField="Name" DataValueField="ID">
                <asp:ListItem Value=""> - корневая - </asp:ListItem>
            </asp:DropDownList></td>
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
        <td colspan="2"><asp:Label ID="LabelComment" runat="server" Text="* настройки доступа будут наследоваться от родительской папки" CssClass="font_small color_blue" /></td>        
    </tr>
    <tr>
        <td colspan="2">
            <asp:Button ID="ButtonNewName" runat="server" Text="Добавить" OnClick="ButtonNew_Click" ValidationGroup="new" /></td>
    </tr>
</table>
<br />
<%--DataList--%>
<asp:DataList ID="DataListFolders" runat="server"  DataKeyField="ID" DataSourceID="SqlDataSourceDocumentFolders" 
    OnEditCommand="DataListFolders_EditCommand" 
    OnCancelCommand="DataListFolders_CancelCommand" 
    OnUpdateCommand="DataListFolders_UpdateCommand"
    OnDeleteCommand="DataListFolders_DeleteCommand" >   
    <ItemTemplate>
        <tr class='<%# StyleRow() %>'>
            <td><asp:Button runat="server" ID="ButtonEdit" CommandName="Edit" Text="Редактировать" /></td>
            <td class="padding_tab10"><asp:Label ID="LabelName" runat="server" Text='<%# Eval("Name") %>' /></td></tr>
    </ItemTemplate>
    <EditItemTemplate>
        <tr class='<%# StyleRow() %>'>
            <td valign="top" align="center">
                <table border="0" cellpadding="2">
                    <tr><td><asp:Button runat="server" ID="ButtonCancel" CommandName="Cancel" Text="Отменить" Width="80" /></td></tr>
                    <tr><td><asp:Button runat="server" ID="ButtonSave" CommandName="Update" Text="Сохранить" Width="80" /></td></tr>
                    <tr><td><asp:Button runat="server" ID="ButtonDel" CommandName="Delete" Text="Удалить" Width="80" /></td></tr>
                </table><br /></td>
            <td valign="top">                  
                <table border="0" cellpadding="2">
                    <tr>
                        <td><asp:Label ID="LabelName" runat="server" Text="Имя папки"/></td>
                        <td><asp:TextBox ID="TextBoxName" runat="server" Text='<%# Eval("Name") %>' Width="300" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorEditName" runat="server" ErrorMessage="Введите данные"
                                ControlToValidate="TextBoxName" Display="Dynamic"><br/>Введите данные</asp:RequiredFieldValidator></td>
                    </tr>
                    <tr>
                        <td><asp:Label ID="LabelNameParent" runat="server" Text="Родительская папка"/></td>
                        <td><asp:DropDownList ID="DropDownListParent" runat="server" AppendDataBoundItems="True" Width="300" 
                                DataSource='<%# GetParentFolder((int)Eval("ID")) %>' DataTextField="Name" DataValueField="ID"
                                SelectedValue='<%# Bind("ParentFolderID") %>'>
                                <asp:ListItem Value=""> - корневая - </asp:ListItem>
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td><asp:Label ID="LabelOrder" runat="server" Text="Порядок вывода"/></td>
                        <td><asp:TextBox ID="TextBoxOrder" runat="server" Text='<%# Bind("Order") %>' Width="100" />
                            <asp:CompareValidator ID="CompareValidatorEditOrder" runat="server" ErrorMessage="Введите число"
                                ControlToValidate="TextBoxOrder" Type="Integer" Operator="DataTypeCheck"
                                Display="Dynamic"><br />Введите число</asp:CompareValidator>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorEditOrder" runat="server" ErrorMessage="Введите число"
                                ControlToValidate="TextBoxOrder" Display="Dynamic"><br/>Введите число</asp:RequiredFieldValidator></td>
                    </tr>
                </table>
                <asp:HiddenField ID="HiddenFieldsFolderID" runat="server" Value='<%# Eval("ID") %>' />                
                <%-- Всунуть дата лист с разрешениями --%>
                <table border="0" cellspacing="2">
                    <tr>
                        <td><asp:DataList ID="DataListAccess" runat="server" DataSource='<%# GetAccessFolder((int)Eval("ID"))%>'
                                OnItemDataBound="DataListAccess_ItemDataBound">
                                <ItemTemplate>                        
                                    <asp:HiddenField ID="HiddenFieldID" runat="server" Value='<%# Eval("ID") %>' />
                                    <asp:HiddenField ID="HiddenFieldRuleGroupID" runat="server" Value='<%# Eval("RuleGroupID") %>' />
                                    <asp:HiddenField ID="HiddenFieldValue" runat="server" Value='<%# Eval("IsWriter") %>' />
                                    <tr>
                                        <td align="left"><asp:Label ID="LabelName" runat="server" Text='<%# Eval("Name") %>' /></td>
                                        <td align="center"><asp:CheckBox ID="CheckBoxReader" runat="server" OnCheckedChanged="CheckBoxReader_CheckedChanged" AutoPostBack="true" /></td>
                                        <td align="center"><asp:CheckBox ID="CheckBoxWriter" runat="server" OnCheckedChanged="CheckBoxWriter_CheckedChanged" AutoPostBack="true" /></td>
                                    </tr>
                                </ItemTemplate>                    
                                <HeaderTemplate>
                                    <table border="0" cellpadding="2">
                                        <tr>
                                            <td align="left"><asp:Label ID="Label1" runat="server" Text="Группа" CssClass="font_small color_blue" /></td>
                                            <td align="center"><asp:Label ID="Label2" runat="server" Text="Чтение" CssClass="font_small color_blue"/></td>
                                            <td align="center"><asp:Label ID="Label3" runat="server" Text="Запись" CssClass="font_small color_blue"/></td>
                                        </tr>
                                </HeaderTemplate>
                                <FooterTemplate></table></FooterTemplate>
                            </asp:DataList></td>
                        <td></td>
                    </tr>                
                </table>
            </td></tr>    
    </EditItemTemplate>
    <HeaderTemplate>
        <table border="0" cellspacing="2">
    </HeaderTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>        
</asp:DataList>