<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdmContact.ascx.cs" Inherits="controls_AdmContact" %>
<%--<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>--%>
<%--Администрирование контактной информации--%>
<div class="font_caption color_yellow">Администрирование контактной информации</div>
<br />
<asp:SqlDataSource ID="SqlDataSourceContact" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    DeleteCommand="DELETE FROM [Contact] WHERE [ID] = @ID" 
    InsertCommand="INSERT INTO Contact(UserType, Family, FirstName, LastName, BirthDay, Phone, Email, Enabled, DepartamentID, PostID, UserID) VALUES (@UserType, @Family, @FirstName, @LastName, @BirthDay, @Phone, @Email, @Enabled, @DepartamentID, @PostID, @UserID)" 
    SelectCommand="SELECT * FROM [Contact]"         
    UpdateCommand="UPDATE [Contact] SET [UserType] = @UserType, [Family] = @Family, [FirstName] = @FirstName, [LastName] = @LastName, [BirthDay] = @BirthDay, [Phone] = @Phone, [Email] = @Email, [Enabled] = @Enabled, [DepartamentID] = @DepartamentID, [PostID] = @PostID, [UserID] = @UserID WHERE [ID] = @ID" 
    oninserting="SqlDataSourceContact_Inserting">
    <DeleteParameters>
        <asp:Parameter Name="ID" Type="Int32" />
    </DeleteParameters>
    <UpdateParameters>
        <asp:Parameter Name="UserType" Type="Boolean" ConvertEmptyStringToNull="False" />
        <asp:Parameter Name="Family" Type="String" ConvertEmptyStringToNull="False" />
        <asp:Parameter Name="FirstName" Type="String" ConvertEmptyStringToNull="False" />
        <asp:Parameter Name="LastName" Type="String" ConvertEmptyStringToNull="False" />
        <asp:Parameter Name="BirthDay" Type="DateTime" />
        <asp:Parameter Name="Phone" Type="String" ConvertEmptyStringToNull="False" />
        <asp:Parameter Name="Email" Type="String" ConvertEmptyStringToNull="False" />
        <asp:Parameter Name="Enabled" Type="Boolean" ConvertEmptyStringToNull="False" />
        <asp:Parameter Name="DepartamentID" Type="Int32" />
        <asp:Parameter Name="PostID" Type="Int32" />
        <asp:Parameter Name="UserID" Type="Int32" />
        <asp:Parameter Name="ID" Type="Int32" />
        <%--<asp:Parameter Name="Foto" ConvertEmptyStringToNull="true"/>--%>
    </UpdateParameters>
    <InsertParameters>
        <asp:ControlParameter ControlID="DropDownListUserType" Name="UserType" PropertyName="SelectedValue" Type="Boolean" />
        <asp:ControlParameter ControlID="TextBoxFamily" Name="Family" PropertyName="Text" Type="String" ConvertEmptyStringToNull="false" />
        <asp:ControlParameter ControlID="TextBoxFirstName" Name="FirstName" PropertyName="Text" Type="String" ConvertEmptyStringToNull="false" />
        <asp:ControlParameter ControlID="TextBoxLastName" Name="LastName" PropertyName="Text" Type="String" ConvertEmptyStringToNull="false" />
        <asp:ControlParameter ControlID="TextBoxBirthDay" Name="BirthDay" PropertyName="Text" Type="DateTime" />
        <asp:ControlParameter ControlID="TextBoxPhone" Name="Phone" PropertyName="Text"  Type="String" ConvertEmptyStringToNull="false" />
        <asp:ControlParameter ControlID="TextBoxEmail" Name="Email" PropertyName="Text"  Type="String" ConvertEmptyStringToNull="false" />
        <asp:ControlParameter ControlID="CheckBoxEnabled" Name="Enabled" PropertyName="Checked" Type="Boolean" />
        <asp:ControlParameter ControlID="DropDownListDepartamentID" Name="DepartamentID" PropertyName="SelectedValue" Type="Int32" />
        <asp:ControlParameter ControlID="DropDownListPost" Name="PostID"  PropertyName="SelectedValue" Type="Int32" />
        <asp:ControlParameter ControlID="DropDownListUserID" Name="UserID" PropertyName="SelectedValue" Type="Int32" />        
       <%-- <asp:Parameter Name="Foto" DefaultValue="" />--%>
        <%--<asp:ControlParameter ControlID="AsyncFileUpload1" Name="Foto" PropertyName="FileBytes" />--%> 
        
    </InsertParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="SqlDataSourceUser" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"   
    SelectCommand="SELECT ID, DomainName FROM [User] ORDER BY DomainName">
</asp:SqlDataSource>
<asp:SqlDataSource ID="SqlDataSourceDepartament" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    SelectCommand="SELECT [ID], [ShortName] FROM [Departament] ORDER BY [ShortName]">
</asp:SqlDataSource>
<asp:SqlDataSource ID="SqlDataSourcePost" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    SelectCommand="SELECT [ID], [ShortName] FROM [Post] ORDER BY [ShortName]">
</asp:SqlDataSource>
<%--Новый контакт--%>
<table class="color_yellow" border="1" style="border-style: dotted;" cellpadding="3"><tr><td>
<table border="0"> 
    <tr>
        <td align="right" class="color_yellow font_small">Активно</td>
        <td><asp:CheckBox ID="CheckBoxEnabled" runat="server" /></td>            
        <td align="right" class="color_yellow font_small">Тип контакта</td>
        <td>                
            <asp:DropDownList ID="DropDownListUserType" runat="server" Width="155">
                <asp:ListItem Value="True">Пользователь</asp:ListItem>
                <asp:ListItem Value="False">Иной контакт</asp:ListItem>
            </asp:DropDownList></td>
        <td align="right" class="color_yellow font_small">Учётная запись</td>            
        <td>                
            <asp:DropDownList ID="DropDownListUserID" runat="server" AppendDataBoundItems="True"
                DataSourceID="SqlDataSourceUser" DataTextField="DomainName" DataValueField="ID"
                Width="155">
                <asp:ListItem Value=""> - нет - </asp:ListItem>
            </asp:DropDownList></td>            
    </tr>
    <tr>
        <td align="right" class="color_yellow font_small">Фамилия</td>
        <td><asp:TextBox ID="TextBoxFamily" runat="server"  Width="150" />
            <br />
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewFamily" runat="server" 
                ErrorMessage="Введите фамилию или описание" ControlToValidate="TextBoxFamily" 
                Display="Dynamic" ValidationGroup="new">Введите фамилию или описание</asp:RequiredFieldValidator>
        </td>
        <td align="right" class="color_yellow font_small">Имя</td>
        <td><asp:TextBox ID="TextBoxFirstName" runat="server" Width="150"/></td>
        <td align="right" class="color_yellow font_small">Отчество</td>
        <td><asp:TextBox ID="TextBoxLastName" runat="server" Width="150" /></td>
    </tr>
    <tr>
        <td align="right" class="color_yellow font_small">День рождения</td>
        <td><asp:TextBox ID="TextBoxBirthDay" runat="server" Width="150" /></td>
        <td align="right" class="color_yellow font_small">Телефон</td>
        <td><asp:TextBox ID="TextBoxPhone" runat="server" Width="150" /></td>
        <td align="right" class="color_yellow font_small">E-mail</td>
        <td><asp:TextBox ID="TextBoxEmail" runat="server" Width="150" /></td>
    </tr>
    <tr>
        <td align="right" class="color_yellow font_small">Подразделение</td>
        <td>
            <asp:DropDownList ID="DropDownListDepartamentID" runat="server" AppendDataBoundItems="True"
                DataSourceID="SqlDataSourceDepartament" DataTextField="ShortName" DataValueField="ID"
                Width="155" >
                <asp:ListItem Value=""> - нет - </asp:ListItem>
            </asp:DropDownList></td>
        <td align="right" class="color_yellow font_small">Должность</td>
        <td>
            <asp:DropDownList ID="DropDownListPost" runat="server" AppendDataBoundItems="True"
                DataSourceID="SqlDataSourcePost" DataTextField="ShortName" DataValueField="ID"
                Width="155" >
                <asp:ListItem Value=""> - нет - </asp:ListItem>
            </asp:DropDownList></td>
        <td align="right" class="color_yellow font_small"></td>            
        <%--<td> 
            <AjaxToolkit:AsyncFileUpload ID="AsyncFileUpload1" runat="server" Width="100" UploaderStyle="Modern" UploadingBackColor="#CCFFFF" />        
        </td>--%>   
        <td>
            <asp:Button ID="ButtonAdd" runat="server" Text="Добавить контакт" 
                onclick="ButtonAdd_Click" ValidationGroup="new" /></td>   
    </tr>    
</table></td></tr></table>
<br />
<br />
<%--Список контактов--%>
<asp:DataList ID="DataListContact" runat="server" DataKeyField="ID" 
    DataSourceID="SqlDataSourceContact" 
    oncancelcommand="DataListContact_CancelCommand" 
    ondeletecommand="DataListContact_DeleteCommand" 
    oneditcommand="DataListContact_EditCommand" 
    onupdatecommand="DataListContact_UpdateCommand" >
    <ItemTemplate>
        <tr>
            <td>
                <asp:Button runat="server" id="EditProduct" CommandName="Edit" Text="Изменить" Width="80" />    
                <br />
                <br />
                <asp:Button runat="server" id="DeleteProduct" CommandName="Delete" Text="Удалить" Width="80" 
                    OnClientClick="if(!confirm('Желаете удалить данные?')) return false;" /></td>
            <td>
                <table  cellpadding="2">
                    <tr>
                        <td align="right" class="color_yellow font_small">Активно</td>
                        <td><asp:CheckBox ID="CheckBoxEnabled" runat="server" Checked='<%# Eval("Enabled") %>' Enabled="false" /></td>            
                        <td align="right" class="color_yellow font_small">Тип контакта</td>
                        <td><asp:Label ID="UserTypeLabel" runat="server" Text='<%# Contact.TypeUserToString((bool)Eval("UserType")) %>' /></td>
                        <td align="right" class="color_yellow font_small">Учётная запись</td>            
                        <td><asp:Label ID="LabelUserID" runat="server" Text='<%# Contact.GetUserDomainName(Eval("UserID")) %>' /></td>            
                    </tr>                    
                    <tr>
                        <td align="right" class="color_yellow font_small">Фамилия</td>
                        <td><asp:Label ID="LabelFamily" runat="server" Text='<%# Eval("Family") %>' /></td>
                        <td align="right" class="color_yellow font_small">Имя</td>
                        <td><asp:Label ID="LabelFirstName" runat="server" Text='<%# Eval("FirstName") %>' /></td>
                        <td align="right" class="color_yellow font_small">Отчество</td>
                        <td><asp:Label ID="LabelLastName" runat="server" Text='<%# Eval("LastName") %>' /></td>
                    </tr>
                    <tr>
                        <td align="right" class="color_yellow font_small">День рождения</td>
                        <td><asp:Label ID="LabelBirthDay" runat="server" Text='<%# Eval("BirthDay") %>' /></td>
                        <td align="right" class="color_yellow font_small">Телефон</td>
                        <td><asp:Label ID="LabelPhone" runat="server" Text='<%# Eval("Phone") %>' /></td>
                        <td align="right" class="color_yellow font_small">E-mail</td>
                        <td><asp:Label ID="LabelEmail" runat="server" Text='<%# Eval("Email") %>' /></td>
                    </tr>
                    <tr>
                        <td align="right" class="color_yellow font_small">Подразделение</td>
                        <td><asp:Label ID="LabelDepartamentID" runat="server" Text='<%# Contact.GetDepartamentName(Eval("DepartamentID"), true) %>' /></td>
                        <td align="right" class="color_yellow font_small">Должность</td>
                        <td><asp:Label ID="LabelPostID" runat="server" Text='<%# Contact.GetPostName(Eval("PostID"), true) %>' /></td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>  
                </table></td>
           <td>
                <asp:Image ID="ImageUser" CssClass="user_img" runat="server" ImageUrl='<%# Contact.Link(Eval("ID"), false) %>' Width="80" Height="90" AlternateText="" />
            </td></tr>     
    </ItemTemplate>
    <EditItemTemplate>   
        <tr>
            <td>  
                <asp:Button ID="UpdateProduct" runat="server" CommandName="Update" Text="Сохранить" Width="80" />  
                <br />
                <br />
                <asp:Button ID="CancelUpdate" runat="server" CommandName="Cancel" Text="Отмена" Width="80" /></td>
            <td>
                <table> 
                    <tr>
                        <td align="right" class="color_yellow font_small">Активно</td>
                        <td><asp:CheckBox ID="CheckBoxEnabled" runat="server" Checked='<%# Bind("Enabled") %>' /></td>            
                        <td align="right" class="color_yellow font_small">Тип контакта</td>
                        <td>                
                            <asp:DropDownList ID="DropDownListUserType" runat="server" SelectedValue='<%# Bind("UserType") %>' Width="155">
                                <asp:ListItem Value="True">Пользователь</asp:ListItem>
                                <asp:ListItem Value="False">Иной контакт</asp:ListItem>
                            </asp:DropDownList></td>
                        <td align="right" class="color_yellow font_small">Учётная запись</td>            
                        <td>                
                            <asp:DropDownList ID="DropDownListUserID" runat="server" AppendDataBoundItems="True"
                                DataSourceID="SqlDataSourceUser" DataTextField="DomainName" DataValueField="ID"
                                SelectedValue='<%# Bind("UserID") %>' Width="155">
                                <asp:ListItem Value=""> - нет - </asp:ListItem>
                            </asp:DropDownList></td>            
                    </tr>
                    <tr>
                        <td align="right" class="color_yellow font_small">Фамилия</td>
                        <td><asp:TextBox ID="TextBoxFamily" runat="server" Text='<%# Bind("Family") %>' Width="150" />
                            <br />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorFamily" runat="server" 
                                ErrorMessage="Введите фамилию или описание" ControlToValidate="TextBoxFamily" 
                                Display="Dynamic" Enabled="false">Введите фамилию или описание</asp:RequiredFieldValidator></td>
                        <td align="right" class="color_yellow font_small">Имя</td>
                        <td><asp:TextBox ID="TextBoxFirstName" runat="server" Text='<%# Bind("FirstName") %>'  Width="150"/></td>
                        <td align="right" class="color_yellow font_small">Отчество</td>
                        <td><asp:TextBox ID="TextBoxLastName" runat="server" Text='<%# Bind("LastName") %>' Width="150" /></td>
                    </tr>
                    <tr>
                        <td align="right" class="color_yellow font_small">День рождения</td>
                        <td><asp:TextBox ID="TextBoxBirthDay" runat="server" Text='<%# Bind("BirthDay") %>' Width="150" /></td>
                        <td align="right" class="color_yellow font_small">Телефон</td>
                        <td><asp:TextBox ID="TextBoxPhone" runat="server" Text='<%# Bind("Phone") %>' Width="150" /></td>
                        <td align="right" class="color_yellow font_small">E-mail</td>
                        <td><asp:TextBox ID="TextBoxEmail" runat="server" Text='<%# Bind("Email") %>' Width="150" /></td>
                    </tr>
                    <tr>
                        <td align="right" class="color_yellow font_small">Подразделение</td>
                        <td>
                            <asp:DropDownList ID="DropDownListDepartamentID" runat="server" AppendDataBoundItems="True"
                                DataSourceID="SqlDataSourceDepartament" DataTextField="ShortName" DataValueField="ID"
                                SelectedValue='<%# Bind("DepartamentID") %>' Width="155" >
                                <asp:ListItem Value=""> - нет - </asp:ListItem>
                            </asp:DropDownList></td>
                        <td align="right" class="color_yellow font_small">Должность</td>
                        <td>
                            <asp:DropDownList ID="DropDownListPost" runat="server" AppendDataBoundItems="True"
                                DataSourceID="SqlDataSourcePost" DataTextField="ShortName" DataValueField="ID"
                                SelectedValue='<%# Bind("PostID") %>' Width="155" >
                                <asp:ListItem Value=""> - нет - </asp:ListItem>
                            </asp:DropDownList></td>
                        <td>&nbsp;</td>   
                        <td>&nbsp;</td>                              
                    </tr>    
                </table></td>
            <td>
                <asp:Image ID="ImageUser" CssClass="user_img" runat="server" ImageUrl='<%# Contact.Link(Eval("ID"), false) %>' Width="80" Height="90" AlternateText="" />
            </td></tr>   
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

