<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdmDocumentType.ascx.cs"
    Inherits="controls_AdmDocumentType" %>
<%--Администрирование типов документов--%>
<asp:ScriptManager ID="ScriptManagerDoc" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True"/>
<asp:UpdatePanel ID="UpdatePanelDoc" runat="server">
    <Triggers>
        <asp:PostBackTrigger ControlID="ButtonNewType" />
        <asp:PostBackTrigger ControlID="ButtonTest" />        
        <asp:PostBackTrigger ControlID="GridViewTypes" />        
    </Triggers>
    <ContentTemplate>
        <div class="font_caption color_yellow">Администрирование типов документов</div>
        <br />
        <asp:SqlDataSource ID="SqlDataSourceDocumentType" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
            DeleteCommand="DELETE FROM [DocumentType] WHERE [ID] = @ID" 
            InsertCommand="INSERT INTO [DocumentType] ([Image], [ImageContentType], [Extension], [Comment], [ContentTypeDocument]) VALUES (@Image, @ImageContentType, @Extension, @Comment, @ContentTypeDocument)"
            SelectCommand="SELECT * FROM [DocumentType]"     
            UpdateCommand="UPDATE [DocumentType] SET [Image]=@Image, [ImageContentType]=@ImageContentType, [Extension]=@Extension, [Comment]=@Comment, [ContentTypeDocument]=@ContentTypeDocument WHERE [ID] = @ID" 
            OnInserting="SqlDataSourceDocumentType_Inserting" 
            onupdating="SqlDataSourceDocumentType_Updating">
            <DeleteParameters>
                <asp:Parameter Name="ID" Type="Int32" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="Image" Type="Object" />        
                <asp:Parameter Name="ImageContentType" Type="String" />
                <asp:Parameter Name="Extension" Type="String" />
                <asp:Parameter Name="Comment" Type="String" />
                <asp:Parameter Name="ContentTypeDocument" Type="String" />
                <asp:Parameter Name="ID" Type="Int32" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="Image" Type="Object" />
                <asp:Parameter Name="ImageContentType" Type="String" />
                <asp:ControlParameter ControlID="TextBoxNewExtension" Name="Extension" PropertyName="Text" Type="String"  ConvertEmptyStringToNull="false"/>        
                <asp:ControlParameter ControlID="TextBoxComment" Name="Comment" PropertyName="Text" Type="String" ConvertEmptyStringToNull="true" />
                <asp:ControlParameter ControlID="TextBoxNewContentType" Name="ContentTypeDocument" PropertyName="Text" Type="String"  ConvertEmptyStringToNull="true"/>
            </InsertParameters>
        </asp:SqlDataSource>
        <%--  New --%>
        <table border="0">
            <tr>
                <td><asp:Label ID="LabelNewExtension" runat="server" Text="Расширение файла" /></td>
                <td><asp:TextBox ID="TextBoxNewExtension" runat="server" ValidationGroup="new" Width="250" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewExtension" runat="server" ErrorMessage="Введите название"
                        ControlToValidate="TextBoxNewExtension" Display="Dynamic" ValidationGroup="new" /></td>
            </tr>
            <tr>
                <td><asp:Label ID="LabelNewImage" runat="server" Text="Картинка" />
                    <br />&nbsp;&nbsp;&nbsp; 
                    <asp:Label ID="LabelNewImageComment" CssClass="font_small color_yellow" runat="server" Text="необязательно, размер 16px на 16px" /></td>
                <td><asp:FileUpload ID="FileUploadNewImage" runat="server" Width="325"></asp:FileUpload>
                    &nbsp;&nbsp;
                    <asp:CustomValidator ID="CustomValidatorNewImage" runat="server" ControlToValidate="FileUploadNewImage"
                        Display="dynamic" ErrorMessage="Ошибка при загрузке" OnServerValidate="CustomValidatorNewImage_ServerValidate" 
                        SetFocusOnError="true" ValidationGroup="new" /></td>
            </tr>
            <tr>
                <td><asp:Label ID="LabelNewContentType" runat="server" Text="Тип контента документа" />        
                <br />&nbsp;&nbsp;&nbsp;
                <asp:Label ID="LabelNewContentTypeComment" CssClass="font_small color_yellow" runat="server" Text="необязательно" /></td>
                <td><asp:TextBox ID="TextBoxNewContentType" runat="server" ValidationGroup="new" Width="250" /></td>
            </tr>
            <tr>
                <td><asp:Label ID="LabelComment" runat="server" Text="Комментарий" />
                <br />&nbsp;&nbsp;&nbsp;
                <asp:Label ID="LabelCommentComm" CssClass="font_small color_yellow" runat="server" Text="необязательно" /></td>
                <td><asp:TextBox ID="TextBoxComment" runat="server" ValidationGroup="new" Width="250" /></td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button ID="ButtonNewType" runat="server" Text="Добавить" OnClick="ButtonNew_Click"
                        ValidationGroup="new" /></td>
            </tr>
        </table>
        <br />
        <br />
        <%--  определение типа контента из загруженного файла --%>
        <asp:Label ID="LabelTestContentType" runat="server" Text="Получить тип контента" />
        &nbsp;<asp:TextBox ID="TextBoxResultContentType" runat="server" ValidationGroup="test" Width="150" />
        &nbsp;<asp:Label ID="LabelResultContentType" runat="server" Text="из файла" />        
        &nbsp;<asp:FileUpload ID="FileUploadTestContentType" runat="server" Width="150"></asp:FileUpload>
        &nbsp;<asp:Button ID="ButtonTest" runat="server" Text="Получить" OnClick="ButtonTest_Click" ValidationGroup="test" />
        <br />
        <br />
        <br />
        <%--  Grid View --%>
        <asp:GridView ID="GridViewTypes" runat="server" AllowSorting="True" DataKeyNames="ID" 
            DataSourceID="SqlDataSourceDocumentType" OnRowDataBound="GridViewTypes_RowDataBound" 
            AutoGenerateColumns="False" onrowupdating="GridViewTypes_RowUpdating">
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ButtonType="Button"
                    CancelText="Отмена" DeleteText="Удалить" EditText="Изменить" UpdateText="Сохранить" />            
                <asp:TemplateField HeaderText="Расширение" SortExpression="Extension">
                    <ItemTemplate>
                        <asp:Label ID="LabelEditExtension" runat="server" Text='<%# Eval("Extension") %>'></asp:Label>
                    </ItemTemplate>        
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBoxEditExtension" runat="server" Text='<%# Bind("Extension") %>' ></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorEditExtension" runat="server" ErrorMessage="Введите расширение"
                            ControlToValidate="TextBoxEditExtension" Display="Dynamic"><br/>Введите расширение</asp:RequiredFieldValidator>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Тип контента документа" SortExpression="ContentTypeDocument">
                    <ItemTemplate>
                        <asp:Label ID="LabelEditContentType" runat="server" Text='<%# Eval("ContentTypeDocument") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBoxEditContentType" runat="server" Text='<%# Bind("ContentTypeDocument") %>'></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Комментарий" SortExpression="Comment">
                    <ItemTemplate>
                        <asp:Label ID="LabelEditComment" runat="server" Text='<%# Eval("Comment") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBoxEditComment" runat="server" Text='<%# Bind("Comment") %>' ></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>        
                <asp:TemplateField HeaderText="Иконка" SortExpression="">
                    <ItemTemplate>
                        <asp:Image ID="ImageExt" CssClass="img_16_caption" runat="server" ImageUrl='<%# ImgUtils.Link(TypeImgEnum.TypeDocument, Eval("ID")) %>' Width="16" Height="16" AlternateText="" />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:FileUpload ID="FileUploadEditImage" runat="server"></asp:FileUpload>
                    </EditItemTemplate>
                </asp:TemplateField>   
                <asp:TemplateField HeaderText="Тип контента картинки" SortExpression="ImageContentType">
                    <ItemTemplate>
                        <asp:Label ID="LabelEditImageContentType" runat="server" Text='<%# Eval("ImageContentType") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBoxEditImageContentType" runat="server" Text='<%# Bind("ImageContentType") %>'></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>         
            </Columns>
            <EmptyDataTemplate>
                Нет правил
            </EmptyDataTemplate>
        </asp:GridView>
    </ContentTemplate>
</asp:UpdatePanel>