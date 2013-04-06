<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SimpleMessage.ascx.cs" Inherits="controls_SimpleMessage" %>

<!-- простое сообщение -->                
<div class="msgmenu_top_background"><div class="msgmenu_top_left"><div class="msgmenu_top_right">
            <img src="images/spacer.gif" width="1" height="5" alt=" " /></div></div></div>
<div class="msgmenu_workspace font_standart color_dark" onload="javascript:setTabInfo('tabInfoBlockID');">
    <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
    <br />
</div>
<div class="msgmenu_bottom_background"><div class="msgmenu_bottom_left"><div class="msgmenu_bottom_right">
            <img src="images/spacer.gif" width="1" height="5" alt=" " /></div></div></div>
