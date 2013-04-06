<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdmAccessGroup.ascx.cs" Inherits="controls_AdmAccessGroup" %>
<%--Администрирование доступа по группам--%>
<div class="font_caption color_yellow">Администрирование доступа по группам</div>
<br />
<asp:SqlDataSource ID="SqlDataSourceGroup" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    SelectCommand="SELECT * FROM [RuleGroup]"> 
</asp:SqlDataSource>
<asp:SqlDataSource ID="SqlDataSourceUser_inGroup" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    SelectCommand="SELECT * FROM [User] 
                   WHERE ID NOT IN (SELECT UserID FROM RuleGroup_To_User WHERE RuleGroupID = @GroupID )"> 
    <SelectParameters>
        <asp:Parameter Name="GroupID" Type="Int32" DefaultValue="0" />                
    </SelectParameters>                   
</asp:SqlDataSource>
<asp:SqlDataSource ID="SqlDataSourceUser_To_RuleGroup" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
    SelectCommand=" SELECT RtU.ID as ID, RtU.UserID AS UserID, [User].DomainName, [User].[Enabled]
        FROM  [User] INNER JOIN 
        (SELECT * FROM RuleGroup_To_User WHERE RuleGroupID = @GroupID) AS RtU 
	    ON RtU.UserID = [User].ID"
    InsertCommand="INSERT INTO [RuleGroup_To_User] ([RuleGroupID], [UserID]) VALUES (@RuleGroupID, @UserID)"
    DeleteCommand="DELETE FROM [RuleGroup_To_User] WHERE [ID] = @ID">
    <SelectParameters>
        <asp:Parameter Name="GroupID" Type="Int32" DefaultValue="0" />                
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
<asp:DataList ID="DataListAccessGroup" runat="server"  DataKeyField="ID" DataSourceID="SqlDataSourceGroup" 
    oneditcommand="DataListAccessGroup_EditCommand"    
    oncancelcommand="DataListAccessGroup_CancelCommand" 
    onupdatecommand="DataListAccessGroup_UpdateCommand"> 
    <ItemTemplate>
        <tr class='<%# StyleRow() %>'>
            <td><asp:Button runat="server" ID="ButtonEdit" CommandName="Edit" Text="Пользователи" Width="100" /></td>
            <td class="padding_tab10"><asp:Label ID="LabelName" runat="server" Text='<%# Eval("Name") %>' /></td></tr>
    </ItemTemplate>
    <EditItemTemplate>         
         <tr class='<%# StyleRow() %>'>
                <td  valign="top" align="center">
                    <table border="0" cellpadding="2">
                        <tr><td><asp:Button runat="server" ID="ButtonCancel" CommandName="Cancel" Text="Закрыть" Width="80" /></td></tr>
                    </table><br /></td>
                <td valign="top">                  
                    <asp:Label ID="Label1" runat="server" Text="Группа:"/>
                    &nbsp;&nbsp;
                    <asp:Label ID="LabelName" runat="server" Text='<%# Eval("Name") %>' Font-Bold="true"/>                             
                    <asp:HiddenField ID="HiddenFieldGroupID" runat="server" Value='<%# Eval("ID") %>' />                
                    <%-- новый --%> 
                    <br /> 
                    <asp:Button runat="server" ID="ButtonAddUser" CommandName="Update" Text="Добавить в группу" Width="125" />
                    &nbsp;
                    <asp:DropDownList ID="DropDownListUserID" runat="server" AppendDataBoundItems="True"
                        DataSource='<%# GetAddedUsers((int)Eval("ID"))%>' DataTextField="DomainName" DataValueField="ID"
                        Width="190">
                        <asp:ListItem Value="">  - выберите пользователя - </asp:ListItem>
                    </asp:DropDownList>
                    <br />                                        
                    <%-- дата лист с пользователями--%> 
                    <asp:DataList ID="DataListUser" runat="server" DataKeyField="ID" DataSource='<%# GetUsers((int)Eval("ID"))%>'
                        OnDeleteCommand="DataListUser_DeleteCommand">                        
                        <ItemTemplate>                        
                            <tr><td>
                                <asp:Button runat="server" ID="ButtonDelUser" CommandName="Delete" Text="Убрать из группы" Width="120" />
                                &nbsp;&nbsp;
                                <asp:Label ID="LabelDomainName" runat="server" Text='<%# Eval("DomainName") %>' />
                                &nbsp;&nbsp;
                                <asp:CheckBox ID="CheckBoxActive" runat="server" Checked='<%# Eval("Enabled") %>' Enabled="false" />
                                <asp:HiddenField ID="HiddenFieldID" runat="server" Value='<%# Eval("ID") %>' />
                                <asp:HiddenField ID="HiddenFieldUserID" runat="server" Value='<%# Eval("UserID") %>' /></td></tr>
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