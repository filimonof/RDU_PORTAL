<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UserMessageEdit.ascx.cs" Inherits="controls_UserMessageEdit" %>


<table border="0" width="80%" cellpadding="3" cellspacing="3">
    <tr>        
        <td><asp:CheckBox ID="CheckBoxEnabled" CssClass="padding_tab10" runat="server" Checked="true" Text="Сообщение действительно" /></td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="LabelText" CssClass="padding10" runat="server" Text="Текст сообщения" />
            <br />
            <asp:TextBox ID="TextBoxText" runat="server" Width="100%" Rows="7" TextMode="MultiLine" Text="Уважаемые работники Мордовского РДУ." />
            <br />
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorText" runat="server" ErrorMessage="Введите текст сообщения" ControlToValidate="TextBoxText" Display="Dynamic">
                <asp:Label ID="LabelTextError" CssClass="padding_tab10" runat="server" Text="Введите текст сообщения" /></asp:RequiredFieldValidator></td>
    </tr>
    <tr>
        <td><asp:Label ID="LabelDelDate" runat="server" Text="Действительно до" />
            &nbsp;&nbsp;<asp:TextBox ID="TextBoxDelDate" runat="server" Width="150"  />
            <asp:CustomValidator ID="CustomValidatorDate" runat="server" ControlToValidate="TextBoxDelDate"
                Display="Dynamic" ErrorMessage="Введите дату или оставьте пустым" OnServerValidate="CustomValidatorDate_ServerValidate"
                SetFocusOnError="True" ValidateEmptyText="True" />
            <br />
            <asp:Label ID="LabelDelDataComment" CssClass="font_small padding_tab10" runat="server" Text="(если дата не указана, то сообщение будет действительно пока не будет отменено вручную)" /></td>
    </tr>
    <tr>        
        <td><asp:CheckBox ID="CheckBoxImportant" runat="server"  Text="Пометить как важное"/>
        <br />
        <asp:Label ID="LabelImportantComment" CssClass="font_small padding_tab10 msgadd_important_comment" runat="server" Text="(важные сообщения помечаются специальным значком " />
        <asp:Image ID="ImageImportant" runat="server" CssClass="msgadd_important_comment" ImageUrl="~/images/Important.gif" AlternateText="" />
        <asp:Label ID="LabelImportantCommentEnd" CssClass="font_small msgadd_important_comment" runat="server" Text=" )" /></td>        
    </tr>
    <tr>       
        <td><asp:Button ID="ButtonAddMessage" runat="server" Text="Разместить" OnClick="ButtonAddMessage_Click" /></td>        
    </tr>
</table>