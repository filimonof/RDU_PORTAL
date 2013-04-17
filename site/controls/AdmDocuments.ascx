<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdmDocuments.ascx.cs"
    Inherits="controls_AdmDocuments" %>
<%--Администрирование документов--%>
<div class="font_caption color_yellow">Администрирование документов</div>
<br />
<asp:SqlDataSource ID="SqlDataSourceDocuments" runat="server" 
    ConnectionString="<%$ ConnectionStrings:siteConnectionString %>" 
    DeleteCommand="DELETE FROM [Document] WHERE [ID] = @ID" 
    InsertCommand="INSERT INTO [Document] ([Number], [Date], [Name], [FolderID], [DateUpload], [DocumentTypeID], [Deleted], [Doc]) VALUES (@Number, @Date, @Name, @FolderID, @DateUpload, @DocumentTypeID, @Deleted, @Doc)" 
    SelectCommand="SELECT * FROM [Document]" 
    UpdateCommand="UPDATE [Document] SET [Number] = @Number, [Date] = @Date, [Name] = @Name, [FolderID] = @FolderID, [DateUpload] = @DateUpload, [DocumentTypeID] = @DocumentTypeID, [Deleted] = @Deleted, [Doc] = @Doc WHERE [ID] = @ID">
    <DeleteParameters>
        <asp:Parameter Name="ID" Type="Int32" />
    </DeleteParameters>
    <UpdateParameters>
        <asp:Parameter Name="Number" Type="String" />
        <asp:Parameter Name="Date" Type="DateTime" />
        <asp:Parameter Name="Name" Type="String" />
        <asp:Parameter Name="FolderID" Type="Int32" />
        <asp:Parameter Name="DateUpload" Type="DateTime" />
        <asp:Parameter Name="DocumentTypeID" Type="Int32" />
        <asp:Parameter Name="Deleted" Type="Boolean" />
        <asp:Parameter Name="Doc" Type="Object" />
        <asp:Parameter Name="ID" Type="Int32" />
    </UpdateParameters>
    <InsertParameters>
        <asp:Parameter Name="Number" Type="String" />
        <asp:Parameter Name="Date" Type="DateTime" />
        <asp:Parameter Name="Name" Type="String" />
        <asp:Parameter Name="FolderID" Type="Int32" />
        <asp:Parameter Name="DateUpload" Type="DateTime" />
        <asp:Parameter Name="DocumentTypeID" Type="Int32" />
        <asp:Parameter Name="Deleted" Type="Boolean" />
        <asp:Parameter Name="Doc" Type="Object" />
    </InsertParameters>
</asp:SqlDataSource>
<%--  New --%>

<br />
<br />
<%--  Grid View --%>
<asp:GridView ID="GridViewDocuments" runat="server" AllowPaging="True" 
    AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="ID" 
    DataSourceID="SqlDataSourceDocuments">
    <Columns>
        <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
        <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" 
            ReadOnly="True" SortExpression="ID" />
        <asp:BoundField DataField="Number" HeaderText="Number" 
            SortExpression="Number" />
        <asp:BoundField DataField="Date" HeaderText="Date" SortExpression="Date" />
        <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
        <asp:BoundField DataField="FolderID" HeaderText="FolderID" 
            SortExpression="FolderID" />
        <asp:BoundField DataField="DateUpload" HeaderText="DateUpload" 
            SortExpression="DateUpload" />
        <asp:BoundField DataField="DocumentTypeID" HeaderText="DocumentTypeID" 
            SortExpression="DocumentTypeID" />
        <asp:CheckBoxField DataField="Deleted" HeaderText="Deleted" 
            SortExpression="Deleted" />
    </Columns>
</asp:GridView>

