<%@ Page Language="C#" AutoEventWireup="true" CodeFile="test_xsl.aspx.cs" Inherits="tmp_test_xsl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:XmlDataSource ID="XmlDataSource1" runat="server" DataFile="~/cache/Contact/6.xml"
            TransformFile="~/xsl/ContactRDU.xslt" XPath="/Contacts/contact"></asp:XmlDataSource>
        <asp:GridView ID="DataList1" DataSourceID="XmlDataSource1" runat="server">
        </asp:GridView>
        <%--<asp:DataList ID="DataListUPS2" runat="server" DataSourceID="XmlDataSource1">
            <ItemTemplate>
                <br />
                <asp:Label ID="LabelFIO" runat="server" Text='<%# XPath("@name") %>' />
            </ItemTemplate>
        </asp:DataList>--%>
    </div>
    </form>
</body>
</html>
