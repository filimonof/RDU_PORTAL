<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Contacts.aspx.cs" Inherits="Contacts" %>

<%@ Register Namespace="vit.Control" Assembly="__code" TagPrefix="vit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderWorkspace" runat="Server">
    <table cellspacing="0" cellpadding="0" border="0" width="100%">
        <tr>
            <!-- левое поле  -->
            <td class="width_left_place" align="left" valign="top">
                <!-- список контактных источников  -->
                <asp:SqlDataSource ID="SqlDataSourceContact" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
                    SelectCommand="SELECT * FROM [ContactTitle] WHERE [Enabled] = 1 ORDER BY [Order]"></asp:SqlDataSource>
                <asp:DataList ID="DataListContact" runat="server" DataSourceID="SqlDataSourceContact" DataKeyField="ID" 
                    OnItemCommand="DataListContact_ItemCommand">
                    <ItemTemplate>                       
                        <tr>
                            <td><asp:Image ID="ImageContact"  runat="server" ImageUrl='<%# string.Format("~/Img.ashx?type=contact&id={0}", Eval("ID")) %>' Width="24" Height="24" AlternateText="" /></td>
                            <td><asp:LinkButton ID="LinkButtonSelectContactGroup" runat="server" Text='<%# Eval("Name") %>' 
                                CommandName="Select" CommandArgument='<%# Eval("ID") %>' /></td>
                        </tr>
                    </ItemTemplate>
                    <SelectedItemTemplate>
                        <tr>
                            <td><asp:Image ID="ImageContact" runat="server" ImageUrl='<%# string.Format("~/Img.ashx?type=contact&id={0}", Eval("ID")) %>' Width="24" Height="24" AlternateText="" /></td>
                            <td><asp:Label ID="LabelSelectedContactGroup" runat="server" Font-Bold="true" Text='<%# Eval("Name") %>' /></td>
                        </tr>
                    </SelectedItemTemplate>                         
                    <HeaderTemplate><table border="0" cellpadding="5"></HeaderTemplate>
                    <FooterTemplate></table></FooterTemplate>                         
                </asp:DataList>      
                <br />
                <asp:Button ID="ButtonLoad" runat="server" Text="Загрузить контакты с сайта СО" OnClick="ButtonLoad_Click" />
            </td>
            <!-- центральное поле -->
            <td class="center_place_separate" align="left" valign="top">                 
                <asp:Label runat="server" ID="Title" CssClass="font_caption color_yellow"/>
                <br /><br />
                <asp:MultiView ID="MultiViewContacts" runat="server" ActiveViewIndex="0">
                    <!-- Пусто  -->
                    <asp:View runat="server" ID="ViewEmpty">
                        Нет данных
                    </asp:View>
                   
                    <!-- список всех подразделений в локальной контактной информации -->
                    <asp:View runat="server" ID="ViewDepartaments">                        
                        <vit:LinkFirstLetter runat="server" ID="LinkFirstLetterLocal1" onselect="LinkFirstLetterLocal_Select" />
                        <asp:SqlDataSource ID="SqlDataSourceDepartament" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
                            SelectCommand="SELECT * FROM [Departament] ORDER BY [Order] ASC, [Name] ASC "></asp:SqlDataSource>
                        <asp:DataList ID="DataListDepartament" runat="server" DataSourceID="SqlDataSourceDepartament"
                            DataKeyField="ID" OnItemCommand="DataListDepartament_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td><asp:LinkButton ID="LinkButtonSelectDepartament" runat="server" Text='<%# Eval("Name") %>' 
                                        CommandName="Select" CommandArgument='<%# Eval("ID") %>' /></td>
                                </tr>
                            </ItemTemplate>
                            <HeaderTemplate><table border="0" cellpadding="2"></HeaderTemplate>
                            <FooterTemplate></table></FooterTemplate>
                        </asp:DataList>                    
                        &nbsp;<asp:LinkButton ID="LinkButtonSelectDepartamentNull" runat="server" Text="Прочие контакты" OnClick="LinkButtonSelectDepartamentNull_OnClick" />
                    </asp:View>
                    
                    <asp:View runat="server" ID="ViewLocal">
                        <!-- ЛОКАЛЬНАЯ контактная информация -->
                        <asp:HiddenField runat="server" ID="HiddenFieldSortingLocal" />
                        <vit:LinkFirstLetter runat="server" ID="LinkFirstLetterLocal2" onselect="LinkFirstLetterLocal_Select" />
                        &nbsp;<asp:LinkButton ID="LinkButtonReturnToDepartament" runat="server" Text="Список подразделений" 
                            onclick="LinkButtonReturnToDepartament_Click" />
                        <br />
                        <br />
                        <asp:SqlDataSource ID="SqlDataSourceLocalData" runat="server" ConnectionString="<%$ ConnectionStrings:siteConnectionString %>"
                            SelectCommand="SelectContact" SelectCommandType="StoredProcedure" 
                            onselecting="SqlDataSourceLocalData_Selecting"  >
                            <SelectParameters>
                                <asp:Parameter DefaultValue="" Name="letter" Type="String" ConvertEmptyStringToNull="false" />
                                <asp:Parameter DefaultValue="0" Name="departamentID" Type="Int32" />
                                <asp:Parameter DefaultValue="0" Name="postID" Type="Int32" />                                
                            </SelectParameters>
                        </asp:SqlDataSource>                             
                        <asp:DataList ID="DataListLocalData" runat="server" DataSourceID="SqlDataSourceLocalData" 
                            DataKeyField="ID"  OnItemCommand="DataListLocalData_ItemCommand"  >
                            <ItemTemplate>
                                <tr class='<%# this.StyleValueRow() %>'>
                                    <td><asp:LinkButton ID="LinkButtonFIO" runat="server" CssClass="font_standart color_dark" 
                                        Text='<%# Eval("FIO") %>' CommandName="Select" CommandArgument='<%# Eval("ID") %>' /></td>
                                    <td><asp:HyperLink ID="HyperLinkEmail" runat="server"  CssClass="font_standart color_dark" 
                                        NavigateUrl='<%# string.Format("mailto:{0}", Eval("Email")) %>'><%# Eval("Email") %></asp:HyperLink></td>
                                    <td><asp:Label ID="LabelPhone" CssClass="font_standart color_dark" runat="server" Text='<%# Eval("Phone") %>' /></td>
                                    <td><asp:Label ID="LabelPost" CssClass="font_standart color_dark" runat="server" Text='<%# string.Format("{0} - {1}", Eval("DepartamentShortName"), Eval("PostShortName")) %>' /></td>
                                </tr>
                            </ItemTemplate>     
                            <SelectedItemTemplate>                                                    
                                <tr class='<%# this.StyleValueRow() %>'>
                                    <td colspan="4">                                        
                                        <table border="0" cellpadding="4">
                                            <tr>
                                                <td><asp:LinkButton ID="LinkButtonCloseInfoUsers" runat="server"  CssClass="font_standart color_blue" onclick="LinkButtonCloseInfoUsers_Click" Text="свернуть"/></td>
                                                <td align="right" class="color_yellow font_small">имя</td>
                                                <td><%# Eval("FIO") %></td>
                                            </tr>
                                            <tr>
                                                <td rowspan="5" valign="bottom"><asp:Image ID="ImageUser" CssClass="user_img" runat="server" ImageUrl='<%# Contact.Link(Eval("ID")) %>' Width="80" Height="90" AlternateText="" /></td>                                                
                                                <td align="right" class="color_yellow font_small">почта</td>
                                                <td><asp:HyperLink ID="HyperLinkEmail" runat="server"  CssClass="font_standart color_dark" 
                                                        NavigateUrl='<%# string.Format("mailto:{0}", Eval("Email")) %>'><%# Eval("Email") %></asp:HyperLink></td>
                                            </tr>
                                            <tr>                                                
                                                <td align="right" class="color_yellow font_small">телефон</td>
                                                <td><%# Eval("Phone")%></td>
                                            </tr>
                                            <tr>                                                
                                                <td align="right" class="color_yellow font_small">подразделение</td>
                                                <td><%# Eval("DepartamentName")%></td>
                                            </tr>
                                            <tr>                                                
                                                <td align="right" class="color_yellow font_small">должность</td>
                                                <td><%# Eval("PostName")%></td>
                                            </tr>
                                            <tr>                                                
                                                <td align="right" class="color_yellow font_small">день рождения</td>
                                                <td><%# DateUtils.DateToStr(Eval("BirthDay")) %></td>
                                            </tr>
                                            
                                        </table>                                        
                                    </td>
                                </tr>
                            </SelectedItemTemplate>                 
                            <HeaderTemplate><table border="0" cellpadding="4" cellspacing="2">
                                <tr>
                                    <td><asp:LinkButton ID="LinkButtonTitleFIO" runat="server"  CssClass="font_caption color_dark" Text="Имя"  CommandName="FIO"  OnCommand="SortLocal_OnCommand"/></td>
                                    <td><asp:LinkButton ID="LinkButtonTitleEmail" runat="server"  CssClass="font_caption color_dark" Text="Почта"  CommandName="Email"  OnCommand="SortLocal_OnCommand"/></td>
                                    <td><asp:LinkButton ID="LinkButtonTitlePhone" runat="server"  CssClass="font_caption color_dark" Text="Телефон"  CommandName="Phone"  OnCommand="SortLocal_OnCommand"/></td>
                                    <td><asp:LinkButton ID="LinkButtonTitleDepartament" runat="server"  CssClass="font_caption color_dark" Text="Подразделение"  CommandName="DepartamentShortName"  OnCommand="SortLocal_OnCommand"/>
                                        &nbsp;-&nbsp;<asp:LinkButton ID="LinkButtonTitlePost" runat="server"  CssClass="font_caption color_dark" Text="должность"  CommandName="PostShortName"  OnCommand="SortLocal_OnCommand"/></td>
                                </tr>
                            </HeaderTemplate>
                            <FooterTemplate></table></FooterTemplate>                                                    
                        </asp:DataList>
                    </asp:View>

                    <asp:View runat="server" ID="ViewUPSv2Departament">
                        <!-- Контактная информация ОДУ и РДУ Подразделения  -->
                        <!-- заголовок -->
                        <asp:XmlDataSource ID="XmlDataSourceUPS2TitleDepartament" runat="server" XPath="RDU_Contacts" />
                        <asp:Repeater ID="RepeaterUPSv2TitleDepartament" runat="server" DataSourceID="XmlDataSourceUPS2TitleDepartament">
                            <ItemTemplate>
                                <asp:Label ID="LabelTitleDescription" CssClass="font_standart color_dark padding_tab10" runat="server" Text='<%# XPath("description")%>' />
                                <br />
                                <a href='<%# XPath("link") %>' target="_blank" class="font_standart color_blue padding_tab10">
                                (информация на сайте СО)</a>
                                <br />
                                <br />                        
                            </ItemTemplate>                                        
                        </asp:Repeater>
                        <!-- список подразделений -->    
                        <vit:LinkFirstLetter runat="server" ID="LinkFirstLetterUPSv2Departament" onselect="LinkFirstLetterUPSv2_Select" />                        
                        <br />
                        <asp:XmlDataSource ID="XmlDataSourceUPS2Departament" runat="server" XPath="RDU_Contacts/departament" />
                        <asp:DataList ID="DataListUPS2Departament" runat="server" DataSourceID="XmlDataSourceUPS2Departament"
                            OnItemCommand="DataListUPS2Departament_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td><asp:LinkButton ID="LinkButtonSelectUPS2Departament" runat="server" Text='<%# XPath("@name") %>' 
                                        CommandName="Select" CommandArgument='<%# XPath("@name") %>' /></td>
                                </tr>
                            </ItemTemplate>
                            <HeaderTemplate><table border="0" cellpadding="2"></HeaderTemplate>
                            <FooterTemplate></table></FooterTemplate>
                        </asp:DataList>                         
                    </asp:View>
                                        
                    <asp:View runat="server" ID="ViewUPSv2">
                        <!-- Контактная информация ОДУ и РДУ  -->
                        <!-- заголовок -->
                        <asp:XmlDataSource ID="XmlDataSourceUPS2Title" runat="server" XPath="RDU_Contacts" />
                        <asp:Repeater ID="RepeaterUPSv2Title" runat="server" DataSourceID="XmlDataSourceUPS2Title">
                            <ItemTemplate>
                                <asp:Label ID="LabelTitleDescription" CssClass="font_standart color_dark padding_tab10" runat="server" Text='<%#XPath("description")%>' />
                                <br />                                
                                <a href='<%# XPath("link") %>' target="_blank" class="font_standart color_blue padding_tab10">
                                (информация на сайте СО)</a>
                                <br />
                                <br />                        
                            </ItemTemplate>                                        
                        </asp:Repeater>
                        <!-- список контактов -->  
                        <asp:HiddenField runat="server" ID="HiddenLetter" />
                        <asp:HiddenField runat="server" ID="HiddenDepartament" />
                        <vit:LinkFirstLetter runat="server" ID="LinkFirstLetterUPSv2" onselect="LinkFirstLetterUPSv2_Select" />
                        &nbsp;<asp:LinkButton ID="LinkButtonReturnToDepartamentUPSv2" runat="server" Text="Список подразделений" onclick="LinkButtonReturnToDepartamentUPSv2_Click" />
                        <br />
                        <br />
                        <asp:XmlDataSource ID="XmlDataSourceUPS2" runat="server" TransformFile="~/xsl/ContactRDU.xslt" XPath="/Contacts/contact" EnableCaching="false" />
                        <asp:DataList ID="DataListUPS2" runat="server" DataSourceID="XmlDataSourceUPS2" >
                            <ItemTemplate>
                                <tr class='<%# this.StyleValueRow() %>'>
                                    <td><asp:Label ID="LabelFIO" runat="server" CssClass="font_standart color_dark" Text='<%# XPath("@name") %>' /></td>
                                    <td><asp:HyperLink ID="HyperLinkEmail" runat="server"  CssClass="font_standart color_dark" 
                                        NavigateUrl='<%# string.Format("mailto:{0}", XPath("@email")) %>'><%# XPath("@email") %></asp:HyperLink></td>
                                    <td><asp:Label ID="LabelPhone" CssClass="font_standart color_dark" runat="server" Text='<%# string.Format("{0}, {1}", XPath("@tel"), XPath("@tel_local")) %>' /></td>
                                    <td><asp:Label ID="LabelPost" CssClass="font_standart color_dark" runat="server" Text='<%# XPath("@post") %>' /></td>
                                </tr>
                            </ItemTemplate>     
                            <HeaderTemplate><table border="0" cellpadding="4" cellspacing="2">
                                <tr>
                                    <td><asp:LinkButton ID="LinkButtonTitleFIO" runat="server"  CssClass="font_caption color_dark" Text="Имя"  CommandName="name"  OnCommand="SortUPS2_OnCommand"/></td>
                                    <td><asp:LinkButton ID="LinkButtonTitleEmail" runat="server"  CssClass="font_caption color_dark" Text="Почта"  CommandName="email"  OnCommand="SortUPS2_OnCommand"/></td>
                                    <td><asp:LinkButton ID="LinkButtonTitlePhone" runat="server"  CssClass="font_caption color_dark" Text="Телефон"  CommandName="tel"  OnCommand="SortUPS2_OnCommand"/></td>
                                    <td><asp:LinkButton ID="LinkButtonTitlePost" runat="server"  CssClass="font_caption color_dark" Text="Должность"  CommandName="post"  OnCommand="SortUPS2_OnCommand"/></td>
                                </tr>
                            </HeaderTemplate>
                            <FooterTemplate></table></FooterTemplate>                                                  
                        </asp:DataList>
                    </asp:View>                    
                    <asp:View runat="server" ID="ViewXLS">    
                        <!-- Контактная информация из XLS файлов НЕ ИСПОЛЬЗУЕТСЯ  -->
                        <asp:SqlDataSource ID="SqlDataSourceXLS" runat="server" ProviderName="System.Data.Odbc"
                            SelectCommand="SELECT * FROM [Sheet1$]" 
                            ConnectionString="Driver={Microsoft Excel Driver (*.xls)};DBQ=D:\price.xls">
                        </asp:SqlDataSource>
                        <asp:GridView ID="DataGridXLS" runat="server" DataSourceID="SqlDataSourceXLS">
                        </asp:GridView>                    
                    </asp:View>
                    
                </asp:MultiView>
                
            </td>
        </tr>
    </table>   
</asp:Content>
