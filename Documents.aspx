<%@ Page Language="C#" MasterPageFile="~/MasterPageNoAjax.master" AutoEventWireup="true"
    CodeFile="Documents.aspx.cs" Inherits="Documents" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderWorkspace" runat="Server">
    <asp:ScriptManager ID="ScriptManagerDoc" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True"/>
    <asp:UpdatePanel ID="UpdatePanelDoc" runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="UploadButtonNew" />
        </Triggers>
        <ContentTemplate>
            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                <tr>
                    <!-- левое поле - дерево попок -->
                    <td class="width_left_place_doc" align="left" valign="top">
                        <br />
                        <asp:TreeView ID="TreeViewFolders" ExpandDepth="1" runat="server" NodeWrap="True"
                            ImageSet="WindowsHelp" OnSelectedNodeChanged="TreeViewFolders_SelectedNodeChanged">
                            <ParentNodeStyle Font-Bold="False" />
                            <HoverNodeStyle Font-Underline="True" ForeColor="#a5794f" />
                            <SelectedNodeStyle Font-Underline="False" Font-Bold="True" ForeColor="#505050" />
                            <NodeStyle ForeColor="#094ea3" HorizontalPadding="5px" VerticalPadding="5px" />
                        </asp:TreeView>
                    </td>
                    <!-- центральное поле - список файлов в выбранной попке -->
                    <td class="center_place_separate_doc" align="left" valign="top">
                        <asp:Label ID="LabelCaption" runat="server" CssClass="font_large_caption color_dark">Выберите папку с документами</asp:Label>                
                        <br />
                        <%--SqlDataSource--%>
                        <asp:SqlDataSource ID="SqlDataSourceDocuments" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
                            SelectCommand="SELECT [Document].ID, [Document].Number, [Document].Date, [Document].Name, [Document].FolderID, [Document].DateUpload, [Document].DocumentTypeID, DocumentType.Comment, DocumentType.ID AS TypeID FROM [Document] INNER JOIN DocumentType ON [Document].DocumentTypeID = DocumentType.ID WHERE [Document].FolderID = @FolderID ORDER BY [Document].DateUpload">
                            <SelectParameters>
                                <asp:Parameter Name="FolderID" Type="Int32"/>
                            </SelectParameters>
                        </asp:SqlDataSource>                
                        <%--ограничение доступа--%>
                        <asp:Table runat="server" ID="TableNoRule" BorderWidth="0" CellPadding="10" Visible="false">
                            <asp:TableRow VerticalAlign="Middle">
                                <asp:TableCell>
                                    <asp:Image ID="ImageNoRule" runat="server"  ImageUrl="~/images/anim_smile/icon_mad.gif" />
                                </asp:TableCell>
                                <asp:TableCell>
                                    <asp:Label ID="LabelNoRule" runat="server" CssClass="font_large_caption color_yellow">&nbsp;&nbsp; У вас нет прав для просмотра этой папки</asp:Label>
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                        <%--меню фильтрации--%>
                        <asp:Table runat="server" ID="TableMenu" BorderWidth="0" CellPadding="3" CssClass="padding5"
                            Visible="false">
                            <asp:TableRow>
                                <asp:TableCell VerticalAlign="Middle">
                                    <asp:Image ID="ImageView" runat="server" ImageUrl="~/images/document_view.png" />
                                </asp:TableCell>
                                <asp:TableCell VerticalAlign="Middle">
                                    <asp:Label ID="LabelYear" runat="server" CssClass="font_standart color_yellow" Text="Год " />
                                    <asp:DropDownList ID="DropDownListYear" runat="server" AutoPostBack="true" OnSelectedIndexChanged="TreeViewFolders_SelectedNodeChanged">
                                        <asp:ListItem>2007</asp:ListItem>
                                        <asp:ListItem>2008</asp:ListItem>
                                        <asp:ListItem>2009</asp:ListItem>
                                        <asp:ListItem>2010</asp:ListItem>
                                    </asp:DropDownList>
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <asp:CheckBox ID="CheckNoDate" runat="server" Checked="true" CssClass="font_standart color_yellow"
                                        Text="Документы без даты" AutoPostBack="true" OnCheckedChanged="TreeViewFolders_SelectedNodeChanged" />
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <asp:Label ID="LabelOrder" runat="server" CssClass="font_standart color_yellow" Text="Сортировать по " />
                                    <asp:DropDownList ID="DropDownListOrder" runat="server" AutoPostBack="true" OnSelectedIndexChanged="TreeViewFolders_SelectedNodeChanged">
                                        <asp:ListItem>Названию</asp:ListItem>
                                        <asp:ListItem>Номеру</asp:ListItem>
                                        <asp:ListItem>Дате</asp:ListItem>
                                        <asp:ListItem Selected>Дате размещения</asp:ListItem>
                                    </asp:DropDownList>
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>                
                        <%--добавление документов--%>
                        <ajaxToolkit:CollapsiblePanelExtender ID="ajaxCollapsiablePanel" runat="Server" ExpandControlID="LinkButtonNewDoc"
                            CollapseControlID="LinkButtonNewDoc" TextLabelID="LabelNewDocComment" TargetControlID="PanelNewDoc"
                            CollapsedSize="0" Collapsed="True" AutoCollapse="False" AutoExpand="False" ScrollContents="False"
                            CollapsedText=" " ExpandedText="(свернуть форму)" ExpandDirection="Vertical" />
                        <asp:Image ID="ImageNewDoc" runat="server" CssClass="img_16_caption" ImageUrl="~/images/document_plus.png" />
                        <asp:LinkButton ID="LinkButtonNewDoc" CssClass="font_standart color_yellow" runat="server"
                            Text="Добавить документ " />
                        <asp:Label ID="LabelNewDocComment" runat="server" CssClass="font_small color_dark" />
                        <asp:Panel ID="PanelNewDoc" runat="server" BackColor="#F7F6F3">
                            <asp:Table runat="server" ID="TableEditing" BorderWidth="0" CellPadding="2" Visible="true">
                                <asp:TableRow VerticalAlign="Middle">
                                    <asp:TableCell>
                                        <asp:Label ID="LabelNewNomer" runat="server" CssClass="font_standart color_dark" Text="Номер" />
                                    </asp:TableCell>
                                    <asp:TableCell>
                                        <asp:TextBox ID="TextBoxNewNomer" runat="server" Width="100"></asp:TextBox>
                                        &nbsp;&nbsp;&nbsp;<asp:Label ID="LabelNewNomerComment" runat="server" CssClass="font_small color_dark" Text="(не обязательно)" />
                                    </asp:TableCell>
                                </asp:TableRow>
                                <asp:TableRow VerticalAlign="Middle">
                                    <asp:TableCell>
                                        <asp:Label ID="LabelNewDate" runat="server" CssClass="font_standart color_dark" Text="Дата" />
                                    </asp:TableCell>
                                    <asp:TableCell>
                                        <ajaxToolkit:CalendarExtender runat="server" ID="CalendarExtenderNewDate" TargetControlID="TextBoxNewDate"
                                            PopupButtonID="ImageNewDate" Format="d.MM.yyyy" />                                    
                                        <%--OnClientShown="ClientShown"--%>

                                        <script language="javascript" type="text/javascript">  
                                                     var IsClientShown = 0;  
                                                     function ClientShown(sender, args)  
                                                     {  
                                                         IsClientShown = 1;  
                                                     }  
                                                     document.documentElement.onclick = function()  
                                                     {  
                                                         var varCalendar = $find('<%= CalendarExtenderNewDate.ClientID %>');  
                                                          
                                                         if (varCalendar._isOpen == true && IsClientShown == 0)  
                                                             varCalendar.hide();  
                                                               
                                                        IsClientShown = 0;  
                                                     };  
                                        </script>

                                        <asp:TextBox ID="TextBoxNewDate" runat="server" Width="100" ValidationGroup="NewDoc"/>
                                        &nbsp;
                                        <asp:Image ID="ImageNewDate" runat="server" ImageUrl="~/images/calendar.png" />
                                        &nbsp;&nbsp;&nbsp;<asp:Label ID="LabelNewDateComment" runat="server" CssClass="font_small color_dark" Text="(не обязательно)" />
                                        &nbsp;&nbsp;                                
                                        <asp:CustomValidator ID="CustomValidatorNewDate" runat="server" ControlToValidate="TextBoxNewDate"
                                            Display="Dynamic" ErrorMessage="Введите дату или оставьте пустым" OnServerValidate="CustomValidatorNewDate_ServerValidate"
                                            SetFocusOnError="True" ValidateEmptyText="True" ValidationGroup="NewDoc"/>
                                    </asp:TableCell>
                                </asp:TableRow>
                                <asp:TableRow VerticalAlign="Middle">
                                    <asp:TableCell>
                                        <asp:Label ID="LabelNewName" runat="server" CssClass="font_standart color_dark" Text="Название" />
                                    </asp:TableCell>
                                    <asp:TableCell>
                                        <asp:TextBox ID="TextBoxNewName" runat="server" Width="300" ValidationGroup="NewDoc"></asp:TextBox>
                                        &nbsp;&nbsp;
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewName" runat="server" ErrorMessage=" Введите название документа"
                                            ControlToValidate="TextBoxNewName" Display="Dynamic" ValidationGroup="NewDoc" />
                                    </asp:TableCell>
                                </asp:TableRow>
                                <asp:TableRow VerticalAlign="Middle">
                                    <asp:TableCell>
                                        <asp:Label ID="LabelNewUpload" runat="server" CssClass="font_standart color_dark" Text="Выберите документ" />
                                    </asp:TableCell>
                                    <asp:TableCell>
                                        <asp:FileUpload ID="FileUploadNewDoc" runat="server" Width="300" ></asp:FileUpload>
                                        &nbsp;&nbsp;
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorNewDate" runat="server" ErrorMessage=" Выберите файл для загрузки"
                                            ControlToValidate="FileUploadNewDoc" Display="Dynamic" ValidationGroup="NewDoc" />
                                        <asp:CustomValidator ID="CustomValidatorNewDoc" runat="server" ControlToValidate="FileUploadNewDoc"
                                            Display="dynamic" ErrorMessage="Ошибка при загрузке" OnServerValidate="CustomValidatorNewDoc_ServerValidate"
                                            SetFocusOnError="true" ValidationGroup="NewDoc" />
                                    </asp:TableCell>
                                </asp:TableRow>
                                <asp:TableRow VerticalAlign="Middle">
                                    <asp:TableCell>
                                        <asp:Button ID="UploadButtonNew" Text="Сохранить" OnClick="UploadButtonNew_Click"
                                            runat="server" ValidationGroup="NewDoc" />
                                    </asp:TableCell>
                                    <asp:TableCell>
                                        <asp:Label ID="LabelErrorUpload" runat="server" CssClass="font_standart" ForeColor="Red" />
                                    </asp:TableCell>
                                </asp:TableRow>
                            </asp:Table>
                        </asp:Panel>                
                        <%-- END добавление документов--%>                
                        <br />
                        <asp:Label ID="LabelNoData" runat="server" CssClass="font_standart color_dark"><br />Нет документов<br /></asp:Label>                
                        <%--Список документов с редактированием--%>               
                        <asp:DataList ID="DataListDocumentsEdit" runat="server" DataSourceID="SqlDataSourceDocuments" DataKeyField="ID"  
                            OnEditCommand = "DataListDocumentsEdit_EditCommand" 
                            OnCancelCommand="DataListDocumentsEdit_CancelCommand" 
                            OnDeleteCommand="DataListDocumentsEdit_DeleteCommand" 
                            OnUpdateCommand="DataListDocumentsEdit_UpdateCommand" 
                            OnItemDatabound="DataListDocumentsEdit_ItemDataBound" >
                            <ItemTemplate>
                                <tr>
                                    <td style="width: 16px"><asp:ImageButton ID="ImageButtonEdit" runat="server" ImageUrl="~/images/document_edit.png"
                                            CommandName="Edit" CommandArgument='<%# Eval("ID") %>' AlternateText="править" /></td>
                                    <td style="width: 16px"><asp:Image ID="ImageNew" runat="server" Width="16" Height="16" AlternateText="Новый документ"
                                            ImageUrl="~/images/new_doc.png" CssClass="img_16_caption" Visible="false" /></td>
                                    <td style="width: 16px"><asp:Image ID="ImageType" runat="server" Width="16" Height="16" AlternateText='<%# Eval("Comment") %>'
                                            ImageUrl='<%# ImgUtils.Link(TypeImgEnum.TypeDocument, Eval("DocumentTypeID")) %>' CssClass="img_16_caption" /></td>
                                    <td><asp:HyperLink ID="HyperLinkDoc" runat="server" Target="_blank" NavigateUrl='<%# Document.Link(Eval("ID")) %>'>
                                        <%# Documents.NameOutput(Eval("Name"), Eval("Number"), Eval("Date"))%></asp:HyperLink>
                                        <asp:HiddenField ID="HiddenFieldDateUpload" runat="server" Value='<%# DateUtils.DateToShortDateString(Eval("DateUpload")) %>' /></td>
                                </tr> 
                            </ItemTemplate>     
                            <SelectedItemTemplate>  
                                <tr>
                                    <td colspan="4">
                                        <table border="0" cellpadding="2" cellspacing="2" class="item_row">
                                            <tr>
                                                <td><asp:LinkButton ID="LinkButtonCancel" runat="server" CssClass="font_small color_yellow" 
                                                        Text="отмена" CommandName="Cancel" CommandArgument='<%# Eval("ID") %>' /></td>
                                                <td><asp:Image ID="ImageType" runat="server" Width="16" Height="16" AlternateText='<%# Eval("Comment") %>'
                                                        ImageUrl='<%# ImgUtils.Link(TypeImgEnum.TypeDocument, Eval("DocumentTypeID")) %>' CssClass="img_16_caption"  /></td>
                                                <td align="right"><asp:Label ID="LabelEditNomer" runat="server" CssClass="font_standart color_dark" Text="Номер" /></td>
                                                <td><asp:TextBox ID="TextBoxEditNomer" runat="server" Width="100" Text='<%# Bind("Number") %>' ValidationGroup="edit"></asp:TextBox>
                                                    &nbsp;&nbsp;<asp:Label ID="LabelEditNomerComment" runat="server" CssClass="font_small color_dark" Text="(не обязательно)" /></td>
                                            </tr> 
                                            <tr>
                                                <td><asp:LinkButton ID="LinkButtonSave" runat="server" CssClass="font_small color_yellow" 
                                                        Text="сохранить" CommandName="Update" CommandArgument='<%# Eval("ID") %>' /></td>
                                                <td>&nbsp;</td>
                                                <td align="right"><asp:Label ID="LabelEditDate" runat="server" CssClass="font_standart color_dark" Text="Дата" /></td>
                                                <td><ajaxToolkit:CalendarExtender runat="server" ID="CalendarExtenderEditDate" TargetControlID="TextBoxEditDate"
                                                        PopupButtonID="ImageEditDate" Format="d.MM.yyyy" />                                                                    
                                                    <%--<script language="javascript" type="text/javascript">  
                                                                 var IsClientShownEdit = 0;  
                                                                 function ClientShown(sender, args)  
                                                                 {  
                                                                     IsClientShownEdit = 1;  
                                                                 }  
                                                                 document.documentElement.onclick = function()  
                                                                 {  
                                                                     var varCalendar = $find('<%= CalendarExtenderEditDate.ClientID %>');  
                                                                      
                                                                     if (varCalendar._isOpen == true && IsClientShownEdit == 0)  
                                                                         varCalendar.hide();  
                                                                           
                                                                    IsClientShownEdit = 0;  
                                                                 };  
                                                    </script>--%>
                                                    <asp:TextBox ID="TextBoxEditDate" runat="server" Width="100"  Text='<%# DateUtils.DateToShortDateString(Eval("Date")) %>'  ValidationGroup="edit"/>
                                                    &nbsp;
                                                    <asp:Image ID="ImageEditDate" runat="server" ImageUrl="~/images/calendar.png" />
                                                    &nbsp;&nbsp;<asp:Label ID="LabelEditDateComment" runat="server" CssClass="font_small color_dark" Text="(не обязательно)" />
                                                    &nbsp;&nbsp;                                
                                                    <asp:CustomValidator ID="CustomValidatorEditDate" runat="server" ControlToValidate="TextBoxEditDate"
                                                        Display="Dynamic" ErrorMessage="Введите дату или оставьте пустым" OnServerValidate="CustomValidatorNewDate_ServerValidate"
                                                        SetFocusOnError="True" ValidateEmptyText="True"  ValidationGroup="edit"/></td>
                                            </tr> 
                                            <tr>
                                                <td><asp:LinkButton ID="LinkButtonDel" runat="server" CssClass="font_small color_yellow" 
                                                        Text="удалить" CommandName="Delete" CommandArgument='<%# Eval("ID") %>' /></td>
                                                <td>&nbsp;</td>
                                                <td align="right"><asp:Label ID="LabelEditName" runat="server" CssClass="font_standart color_dark" Text="Название" /></td>
                                                <td><asp:TextBox ID="TextBoxEditName" runat="server" Width="300"  Text='<%# Eval("Name") %>'  ValidationGroup="edit"></asp:TextBox>
                                                    &nbsp;&nbsp;
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidatorEditName" runat="server" ErrorMessage=" Введите название документа"
                                                        ControlToValidate="TextBoxEditName" Display="Dynamic"  ValidationGroup="edit" /></td>
                                            </tr>                                                
                                        </table></td>
                                </tr>                    
                            </SelectedItemTemplate>
                            <HeaderTemplate><table border="0" cellpadding="2" cellspacing="2"></HeaderTemplate>                    
                            <FooterTemplate></table></FooterTemplate>                                                                        
                        </asp:DataList>
                        <%--END Список документов с редактированием--%>                                 
                        <br />
                    </td>   
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
