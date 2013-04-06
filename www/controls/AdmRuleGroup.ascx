<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdmRuleGroup.ascx.cs" 
Inherits="controls_AdmRuleGroup" %>
<%--Администрирование групп правил --%>
<div class="font_caption color_yellow">Администрирование групп правил</div>
<br />
<asp:SqlDataSource ID="SqlDataSourceRuleGroup" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    DeleteCommand="DELETE FROM [RuleGroup] WHERE [ID] = @ID" 
    InsertCommand="INSERT INTO [RuleGroup] ([Name]) VALUES (@Name)" 
    SelectCommand="SELECT * FROM [RuleGroup]" 
    UpdateCommand="UPDATE [RuleGroup] SET [Name] = @Name WHERE [ID] = @ID">
    <DeleteParameters>
        <asp:Parameter Name="ID" Type="Int32" />
    </DeleteParameters>
    <UpdateParameters>
        <asp:Parameter Name="Name" Type="String"  ConvertEmptyStringToNull="False" />
        <asp:Parameter Name="ID" Type="Int32" />
    </UpdateParameters>
    <InsertParameters>        
        <asp:ControlParameter ControlID="TextBoxNewName" Name="Name" PropertyName="Text" Type="String"  ConvertEmptyStringToNull="False"/>
    </InsertParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="SqlDataSourceRule_To_RuleGroup" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
    SelectCommand=" SELECT RtR.ID as ID,[Rule].[ID] AS RuleID, [Name]
        FROM [Rule]  LEFT OUTER JOIN 
        (SELECT * FROM Rule_To_RuleGroup WHERE RuleGroupID = @RuleGroupID) AS RtR 
	    ON RtR.RuleID = [Rule].ID"
    InsertCommand="INSERT INTO [Rule_To_RuleGroup] ([RuleGroupID], [RuleID]) VALUES (@RuleGroupID, @RuleID)"
    DeleteCommand="DELETE FROM [Rule_To_RuleGroup] WHERE [ID] = @ID">
    <SelectParameters>
        <asp:Parameter Name="RuleGroupID" Type="Int32" DefaultValue="0" />                
    </SelectParameters>
    <InsertParameters>        
        <asp:Parameter Name="RuleGroupID" Type="Int32" DefaultValue="0" />
        <asp:Parameter Name="RuleID" Type="Int32" DefaultValue="0" />
    </InsertParameters>
    <DeleteParameters>
        <asp:Parameter Name="ID" Type="Int32" />
    </DeleteParameters>
</asp:SqlDataSource>
<%--  New --%>
<table border="0">    
    <tr>
        <td><asp:Label ID="LabelNewName" runat="server" Text="Название группы" /></td>
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
<br />
<%--DataList--%>
<asp:DataList ID="DataListGroup" runat="server"  DataKeyField="ID" DataSourceID="SqlDataSourceRuleGroup" 
    oncancelcommand="DataListGroup_CancelCommand" 
    ondeletecommand="DataListGroup_DeleteCommand" 
    oneditcommand="DataListGroup_EditCommand" 
    onupdatecommand="DataListGroup_UpdateCommand">    
    <ItemTemplate>
        <tr class='<%# StyleRow() %>'>
            <td><asp:Button runat="server" ID="ButtonEdit" CommandName="Edit" Text="Редактировать" Width="120" /></td>
            <td class="padding_tab10"><asp:Label ID="LabelName" runat="server" Text='<%# Eval("Name") %>' /></td></tr>
    </ItemTemplate>
    <EditItemTemplate>        
         <tr class='<%# StyleRow() %>'>
            <td  valign="top" align="center">
                <table border="0" cellpadding="2">
                    <tr><td><asp:Button runat="server" ID="ButtonCancel" CommandName="Cancel" Text="Отменить" Width="80" /></td></tr>
                    <tr><td><asp:Button runat="server" ID="ButtonSave" CommandName="Update" Text="Сохранить" Width="80" /></td></tr>
                    <tr><td><asp:Button runat="server" ID="ButtonDelete" CommandName="Delete" Text="Удалить" Width="80" 
                        OnClientClick="if(!confirm('Желаете удалить данные?')) return false;" /></td></tr>
                </table><br /></td>
            <td valign="top"> 
                <asp:TextBox ID="TextBoxName" runat="server" Text='<%# Bind("Name") %>' Width="250" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorName" runat="server" 
                    ErrorMessage="Введите название группы" ControlToValidate="TextBoxName" 
                    Display="Dynamic" Enabled="false">Введите название группы</asp:RequiredFieldValidator>                                   
                <asp:HiddenField ID="HiddenFieldGroupID" runat="server" Value='<%# Eval("ID") %>' />                
                <%--Всунуть дата лист с правилами --%>                
                <asp:DataList ID="DataListRule" runat="server" DataSource='<%# GetRulesGroup((int)Eval("ID"))%>'
                    OnItemDataBound="DataListRule_ItemDataBound">
                    <ItemTemplate>                        
                        <tr><td>
                            <asp:CheckBox ID="CheckBoxNameRule" runat="server" Text='<%# Eval("Name") %>' />
                            <asp:HiddenField ID="HiddenFieldID" runat="server" Value='<%# Eval("ID") %>' />
                            <asp:HiddenField ID="HiddenFieldRuleID" runat="server" Value='<%# Eval("RuleID") %>' /></td></tr>
                    </ItemTemplate>                    
                    <HeaderTemplate><table border="0" cellpadding="1"></HeaderTemplate>
                    <FooterTemplate></table></FooterTemplate>
                </asp:DataList></td></tr>
    </EditItemTemplate>
    <HeaderTemplate>
        <table border="0" cellspacing="2">
    </HeaderTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>
</asp:DataList>
