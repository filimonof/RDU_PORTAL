<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdmUserMessage.ascx.cs" Inherits="controls_AdmUserMessage" %>
<%--Администрирование объявлений--%>
<div class="font_caption color_yellow">Администрирование объявлений</div>
<br />
<asp:SqlDataSource ID="SqlDataSourceUserMesasge" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    DeleteCommand="DELETE FROM [UserMessage] WHERE [ID] = @ID" 
    SelectCommand="SELECT * FROM [UserMessage] ORDER BY [ID]" 
    UpdateCommand="UPDATE [UserMessage] SET [UserID] = @UserID, [Text] = @Text, [CreateDate] = @CreateDate, [DeleteDate] = @DeleteDate, [Enabled] = @Enabled, [Important] = @Important WHERE [ID] = @ID">
    <DeleteParameters>
        <asp:Parameter Name="ID" Type="Int32" />
    </DeleteParameters>
    <UpdateParameters>
        <asp:Parameter Name="UserID" Type="Int32" />
        <asp:Parameter Name="Text" Type="String" />
        <asp:Parameter Name="CreateDate" Type="DateTime" />
        <asp:Parameter Name="DeleteDate" Type="DateTime" />
        <asp:Parameter Name="Enabled" Type="Boolean" />
        <asp:Parameter Name="Important" Type="Boolean" />
        <asp:Parameter Name="ID" Type="Int32" />
    </UpdateParameters>    
</asp:SqlDataSource>
<asp:SqlDataSource ID="SqlDataSourceUser" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"   
    SelectCommand="SELECT ID, DomainName FROM [User] ORDER BY DomainName">
</asp:SqlDataSource>
<br />
<%--Список объявлений--%>   
<asp:DataList ID="DataListUserMessage" runat="server" DataKeyField="ID" 
    DataSourceID="SqlDataSourceUserMesasge" 
    oncancelcommand="DataListUserMessage_CancelCommand" ondeletecommand="DataListUserMessage_DeleteCommand" 
    oneditcommand="DataListUserMessage_EditCommand" onupdatecommand="DataListUserMessage_UpdateCommand" >
    <ItemTemplate>
        <tr>
            <td valign="top">
                <br />                
                <asp:Button runat="server" id="EditMessage" CommandName="Edit" Text="Изменить" Width="80" />    
                <br />
                <br />
                <asp:Button runat="server" id="DeleteMessage" CommandName="Delete" Text="Удалить" Width="80" 
                    OnClientClick="if(!confirm('Желаете удалить данные?')) return false;" /></td>
            <td>
                <table  cellpadding="2" width="100%">
                    <tr>
                        <td><asp:CheckBox ID="CheckBoxEnabled" runat="server" Text="Активно" Checked='<%# Eval("Enabled") %>'  Enabled="false" /></td>
                        <td class="color_yellow font_small">Дата создания <asp:Label ID="LabelCreateDate" runat="server" CssClass="color_dark font_standart" Text='<%# Eval("CreateDate") %>' /></td>
                        <td class="color_yellow font_small">Действительно до <asp:Label ID="LabelDeleteDate" runat="server" CssClass="color_dark font_standart" Text='<%# DeldateToSrt(Eval("DeleteDate")) %>' /></td>
                    </tr>
                    <tr>
                        <td><asp:CheckBox ID="CheckBoxImportant" runat="server" Text="Важное сообщение" Checked='<%# Eval("Important") %>'  Enabled="false" /></td>
                        <td colspan="2" class="color_yellow font_small">Пользователь <asp:Label ID="LabelUser" runat="server" CssClass="color_dark font_standart" Text='<%# Contact.GetUserDomainName(Eval("UserID")) %>' /></td>                        
                    </tr>
                    <tr>                        
                        <td colspan="3" class="color_yellow font_small">Текст сообщения<br /> <asp:Label ID="LabelText" runat="server" CssClass="color_dark font_standart" Text='<%# ParseMsgToOutput(Eval("Text")) %>' /></td>                        
                    </tr>                
                </table></td>
        </tr>    
    </ItemTemplate>
    <EditItemTemplate>   
        <tr>
            <td valign="top">                
                <br />
                <asp:Button ID="UpdateProduct" runat="server" CommandName="Update" Text="Сохранить" Width="80" />  
                <br />
                <br />
                <asp:Button ID="CancelUpdate" runat="server" CommandName="Cancel" Text="Отмена" Width="80" /></td>
            <td>
                <table  cellpadding="2" width="100%">
                    <tr>
                        <td><asp:CheckBox ID="CheckBoxEnabled" runat="server" Text="Активно" Checked='<%# Bind("Enabled") %>' /></td>
                        <td class="color_yellow font_small">Дата создания
                            <asp:TextBox ID="TextBoxCreateDate" runat="server" Text='<%# Bind("CreateDate") %>' Width="150"/>
                            <asp:CustomValidator ID="CustomValidatorDateCreate" runat="server" ControlToValidate="TextBoxCreateDate"
                                Display="Dynamic" ErrorMessage="Введите дату или оставьте пустым" OnServerValidate="CustomValidatorDate_ServerValidate"
                                SetFocusOnError="True" ValidateEmptyText="True" ><br />Введите дату</asp:CustomValidator></td>
                        <td class="color_yellow font_small">Действительно до 
                            <asp:TextBox ID="TextBoxDeleteDate" runat="server" Text='<%# Bind("DeleteDate") %>' Width="150"/>
                            <asp:CustomValidator ID="CustomValidatorDate" runat="server" ControlToValidate="TextBoxDeleteDate"
                                Display="Dynamic" ErrorMessage="Введите дату или оставьте пустым" OnServerValidate="CustomValidatorDate_ServerValidate"
                                SetFocusOnError="True" ><br />Введите дату или оставьте пустым</asp:CustomValidator>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:CheckBox ID="CheckBoxImportant" runat="server" Text="Важное сообщение" Checked='<%# Bind("Important") %>' /></td>
                        <td colspan="2" class="color_yellow font_small">Пользователь
                            <asp:DropDownList ID="DropDownListUserID" runat="server" DataSourceID="SqlDataSourceUser" 
                            DataTextField="DomainName" DataValueField="ID" SelectedValue='<%# Bind("UserID") %>' /></td>
                    </tr>
                    <tr>                        
                        <td colspan="3" class="color_yellow font_small">Текст сообщения<br /> 
                        <asp:TextBox ID="TextBoxText" runat="server" Width="100%" Rows="7" TextMode="MultiLine" Text='<%# Bind("Text") %>'/>
                        <asp:CustomValidator ID="CustomValidatorText" runat="server" ControlToValidate="TextBoxText"
                                Display="Dynamic" ErrorMessage="Введите текст сообщения" OnServerValidate="CustomValidatorText_ServerValidate"
                                SetFocusOnError="True"  ValidateEmptyText="True" ><br />Введите текст сообщения</asp:CustomValidator></td>
                    </tr>                
                </table></td>
        </tr>    
    </EditItemTemplate>
    <HeaderTemplate>        
        <table border="0">
    </HeaderTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>
    <SeparatorTemplate>
        <tr><td colspan="3"><hr class="color_yellow" /></td></tr>
    </SeparatorTemplate>
</asp:DataList>

