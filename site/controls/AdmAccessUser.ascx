<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdmAccessUser.ascx.cs" Inherits="controls_AdmAccessUser" %>
<%--Администрирование доступа по пользователям--%>
<div class="font_caption color_yellow">Администрирование доступа по пользователям</div>
<br />
<asp:SqlDataSource ID="SqlDataSourceUser" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    SelectCommand="SELECT * FROM [User]"> 
</asp:SqlDataSource>
<asp:SqlDataSource ID="SqlDataSourceRuleGroup_To_User" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
    SelectCommand=" SELECT RtU.ID as ID, RuleGroup.ID AS RuleGroupID, RuleGroup.[Name]
        FROM RuleGroup  LEFT OUTER JOIN 
        (SELECT * FROM RuleGroup_To_User WHERE UserID = @UserID) AS RtU 
	    ON RtU.RuleGroupID = RuleGroup.ID"
    InsertCommand="INSERT INTO [RuleGroup_To_User] ([RuleGroupID], [UserID]) VALUES (@RuleGroupID, @UserID)"
    DeleteCommand="DELETE FROM [RuleGroup_To_User] WHERE [ID] = @ID">
    <SelectParameters>
        <asp:Parameter Name="UserID" Type="Int32" DefaultValue="0" />                
    </SelectParameters>
    <InsertParameters>        
        <asp:Parameter Name="RuleGroupID" Type="Int32" DefaultValue="0" />
        <asp:Parameter Name="UserID" Type="Int32" DefaultValue="0" />
    </InsertParameters>
    <DeleteParameters>
        <asp:Parameter Name="ID" Type="Int32" />
    </DeleteParameters>
</asp:SqlDataSource>
<%--DataList--%>
<asp:DataList ID="DataListAccessUser" runat="server"  DataKeyField="ID" DataSourceID="SqlDataSourceUser" 
    oneditcommand="DataListAccessUser_EditCommand" 
    oncancelcommand="DataListAccessUser_CancelCommand" 
    onupdatecommand="DataListAccessUser_UpdateCommand">   
    <ItemTemplate>
        <tr class='<%# StyleRow() %>'>
            <td><asp:Button runat="server" ID="ButtonEdit" CommandName="Edit" Text="Права" Width="80" /></td>
            <td class="padding_tab10"><asp:Label ID="LabelName" runat="server" Text='<%# Eval("DomainName") %>' />
            &nbsp;&nbsp;<asp:CheckBox ID="CheckBoxActive" runat="server" Checked='<%# Eval("Enabled") %>' Enabled="false" /></td></tr>
    </ItemTemplate>
    <EditItemTemplate>     
        <tr class='<%# StyleRow() %>'>
            <td  valign="top" align="center">
                <table border="0" cellpadding="2">
                    <tr><td><asp:Button runat="server" ID="ButtonCancel" CommandName="Cancel" Text="Отменить" Width="80" /></td></tr>
                    <tr><td><asp:Button runat="server" ID="ButtonSave" CommandName="Update" Text="Сохранить" Width="80" /></td></tr>
                </table><br /></td>
            <td valign="top">                  
                &nbsp;&nbsp;<asp:Label ID="LabelName" runat="server" Text='<%# Eval("DomainName") %>' Font-Bold="true"/>
                &nbsp;&nbsp;<asp:CheckBox ID="CheckBoxActive" runat="server" Checked='<%# Eval("Enabled") %>' Enabled="false" />                
                <asp:HiddenField ID="HiddenFieldUserID" runat="server" Value='<%# Eval("ID") %>' />                
                <%-- Всунуть дата лист с группами  --%>
                <asp:DataList ID="DataListGroup" runat="server" DataSource='<%# GetGroupsUser((int)Eval("ID"))%>'
                    OnItemDataBound="DataListGroup_ItemDataBound">
                    <ItemTemplate>                        
                        <tr><td>
                            <asp:CheckBox ID="CheckBoxGroup" runat="server" Text='<%# Eval("Name") %>' />
                            <asp:HiddenField ID="HiddenFieldID" runat="server" Value='<%# Eval("ID") %>' />
                            <asp:HiddenField ID="HiddenFieldRuleGroupID" runat="server" Value='<%# Eval("RuleGroupID") %>' /></td></tr>
                    </ItemTemplate>                    
                    <HeaderTemplate><table border="0" cellpadding="1"></HeaderTemplate>
                    <FooterTemplate></table></FooterTemplate>
                </asp:DataList>
            </td></tr>    
    </EditItemTemplate>
    <HeaderTemplate>
        <table border="0" cellspacing="2">
    </HeaderTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>        
</asp:DataList>