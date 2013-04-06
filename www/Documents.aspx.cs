using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;

public partial class Documents : System.Web.UI.Page
{
    /// <summary>поле для хранение прав на добавление документов в текущую папку</summary>
    private bool? _isEditCurrentFolder = null;

    /// <summary>разрешено ли добавлять документы  в текущей выбранной папке</summary>
    protected bool IsEditCurrentFolder
    {
        get
        {            
            if (!this._isEditCurrentFolder.HasValue)
            {
                if (string.IsNullOrEmpty(this.TreeViewFolders.SelectedNode.Value))
                    this._isEditCurrentFolder = false;
                else
                    this._isEditCurrentFolder = Document.IsWriterFolder((int)this.Session["USER_ID"], int.Parse(this.TreeViewFolders.SelectedNode.Value));
            }
            return this._isEditCurrentFolder.Value;
        }
    }

    /// <summary>загрузка страницы</summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        this.Page.Title += " - Документы";

        if (!this.IsPostBack)
        {
            Log.ToDB(LogEnum.Page, "Документы");

            //формируем дерево папок
            this.CreateFolders();

            //выделить первый элемент
            if (this.TreeViewFolders.Nodes.Count > 0)
            {
                this.TreeViewFolders.Nodes[0].Select();
                this.TreeViewFolders_SelectedNodeChanged(sender, e);
            }
            else
                this.FillYears(null);
        }

        //чтобы попуп календаря закрывался при щелчек мимо
        //this.Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "hideCalendar", @"function hideCalendar(calExtender) { calExtender.hide(); }", true);
    }

    /// <summary>Формируем дерево папок</summary>
    private void CreateFolders()
    {
        List<FolderDoc> listFolders = Document.GetFolderDoc((int)this.Session["USER_ID"]);
        this.TreeViewFolders.Nodes.Clear();
        this.FillTreeViewFolders(null, this.TreeViewFolders.Nodes, listFolders);
    }

    /// <summary>заполняем дерево папок рекурсивно</summary>
    /// <param name="parent">текущая папка (уровень)</param>
    /// <param name="nodesCollection">ветка которую заполняем и от которой идем в рекурсию</param>
    /// <param name="listFolders">полный список папок</param>
    private void FillTreeViewFolders(int? parent, TreeNodeCollection nodesCollection, List<FolderDoc> listFolders)
    {
        foreach (FolderDoc folder in listFolders)
        {
            if (parent == folder.ParentID)
            {
                TreeNode node = new TreeNode();
                node.Text = folder.Name + string.Format("&nbsp;&nbsp;(&nbsp;{0}&nbsp;/&nbsp;{1}&nbsp;)", folder.NewCount, folder.Count);
                node.Value = folder.ID.ToString();
                node.SelectAction = TreeNodeSelectAction.SelectExpand;
                if (!folder.IsReader)
                    node.ImageUrl = @"~/images/lock.png";
                nodesCollection.Add(node);
                this.FillTreeViewFolders(folder.ID, node.ChildNodes, listFolders);
            }
        }
    }

    /// <summary>событие - выбор папки или изменеение параметров фильтрации</summary>
    protected void TreeViewFolders_SelectedNodeChanged(object sender, EventArgs e)
    {
        string selectedFolderID = this.TreeViewFolders.SelectedNode.Value;
        string selectedFolderName = this.TreeViewFolders.SelectedNode.Text;

        //избавиться от количества документов в заголовке        
        if (selectedFolderName.LastIndexOf("(") > 0)
            this.LabelCaption.Text = selectedFolderName.Remove(selectedFolderName.LastIndexOf("("));
        else
            this.LabelCaption.Text = selectedFolderName;

        //доступ на чтение
        bool isPermi = false;
        if (!string.IsNullOrEmpty(selectedFolderID))
        {
            int folderID = int.Parse(selectedFolderID);
            isPermi = Document.IsReaderFolder((int)this.Session["USER_ID"], folderID);
            this.DataListDocumentsEdit.Visible = isPermi;
            this.TableNoRule.Visible = !isPermi;
            this.TableMenu.Visible = isPermi;
            this.PanelNewDoc.Visible = this.IsEditCurrentFolder;
            this.LinkButtonNewDoc.Visible = this.IsEditCurrentFolder;
            this.ImageNewDoc.Visible = this.IsEditCurrentFolder;
            if (isPermi)
            {
                this.FillYears(folderID);
                this.FillDocuments();
            }
        }        
        this.DataListDocumentsEdit.DataBind();

        //видимость надписи НЕТ ДОКУМЕНТОВ
        this.LabelNoData.Visible = this.DataListDocumentsEdit.Items.Count == 0 && isPermi;
    }

    /// <summary>вывести список документов</summary>           
    private void FillDocuments()
    {
        string sql = @"
            SELECT 
                [Document].ID, [Document].Number, [Document].Date, 
                [Document].Name, [Document].FolderID, [Document].DateUpload, 
                [Document].DocumentTypeID, DocumentType.Comment, DocumentType.ID AS TypeID,
                [dbo].[FirstNumberToString]([Document].Number) as Num 
            FROM 
                [Document] INNER JOIN DocumentType ON [Document].DocumentTypeID = DocumentType.ID 
            WHERE [Document].Deleted = 0 AND [Document].FolderID = @FolderID {0}
            ORDER BY {1} ";

        //фильтрация
        string where = " ";
        if (!string.IsNullOrEmpty(this.DropDownListYear.SelectedValue))
        {
            where += " AND ( YEAR([Document].Date) = " + this.DropDownListYear.SelectedValue;
            if (this.CheckNoDate.Checked)
                where += " OR [Document].Date IS NULL ";
            where += " ) ";
        }
        else //все года 
        {
            if (!this.CheckNoDate.Checked)
                where += " AND [Document].Date IS NOT NULL ";
        }

        //сортировка
        string orderBy;
        switch (this.DropDownListOrder.SelectedIndex)
        {
            case (0): orderBy = "[Document].Name ASC"; break; //Названию
            case (1): orderBy = "Num ASC"; break; //Номеру                
            case (2): orderBy = "[Document].Date ASC"; break; //Дате
            case (3):
            default: orderBy = "[Document].DateUpload DESC"; break; //Дате размещения
        }

        //получаемый запрос с одним параметром @FolderID
        sql = string.Format(sql, where, orderBy);

        this.SqlDataSourceDocuments.SelectCommand = sql;
        this.SqlDataSourceDocuments.SelectParameters["FolderID"].DefaultValue = this.TreeViewFolders.SelectedNode.Value;
    }

    /// <summary>заполняем в фильтре всевозможные года документов</summary>
    /// <param name="folderID">номер папки</param>
    private void FillYears(int? folderID)
    {
        //запоминаем текущую дату
        string currentYear = null;
        if (this.IsPostBack)
            currentYear = this.DropDownListYear.SelectedValue;

        string folder = string.Empty;
        if (folderID.HasValue)
            folder = string.Format(" AND FolderID = {0} ", folderID.Value);

        this.DropDownListYear.Items.Clear();
        SqlDataReader reader = AdoUtils.CreateSqlDataReader("SELECT DISTINCT YEAR([Document].[Date]) AS years FROM [Document] WHERE [Deleted]=0 " + folder + " ORDER BY years");
        if (reader.HasRows)
        {
            while (reader.Read())
            {
                if (AdoUtils.DBNullToNull(reader["years"]) != null)
                {
                    ListItem item = new ListItem(reader["years"].ToString(), reader["years"].ToString());
                    this.DropDownListYear.Items.Add(item);
                }
            }
        }
        //если текущего года нету то добавляем
        if (this.DropDownListYear.Items.FindByValue(DateTime.Today.Year.ToString()) == null)
            this.DropDownListYear.Items.Add(new ListItem(DateTime.Today.Year.ToString(), DateTime.Today.Year.ToString()));
        //добавляем ВСЕ года
        this.DropDownListYear.Items.Add(new ListItem(" все ", string.Empty));
        //если выбрана дата то дату, если нет даты или новая страница то текущую
        if (currentYear != null)
        {
            if (this.DropDownListYear.Items.FindByValue(currentYear) != null)
                this.DropDownListYear.Items.FindByValue(currentYear).Selected = true;
            else
                this.DropDownListYear.Items.FindByValue(DateTime.Today.Year.ToString()).Selected = true;
        }
        else
            this.DropDownListYear.Items.FindByValue(DateTime.Today.Year.ToString()).Selected = true;
    }

    /// <summary>вывод название документа в списке</summary>
    /// <param name="name">название документа</param>
    /// <param name="number">номер</param>
    /// <param name="date">дата</param>
    /// <returns>строка с комбинацией названия номера и даты</returns>
    protected static string NameOutput(object name, object number, object date)
    {
        if (AdoUtils.DBNullToNull(name) == null)
            return "(без названия)";
        string sName = name.ToString();
        string sNumber = AdoUtils.DBNullToNull(number) == null ? string.Empty : "№" + AdoUtils.DBNullToNull(number).ToString();
        string sDate = AdoUtils.DBNullToNull(date) == null ? string.Empty : "от " + ((DateTime)AdoUtils.DBNullToNull(date)).ToShortDateString();
        if (!string.IsNullOrEmpty(sNumber) || !string.IsNullOrEmpty(sDate))
            sName = string.Format("{0} {1} - {2}", sNumber, sDate, sName);
        return sName;
    }

    /// добавление нового документа 

    /// <summary>Валидатор введённой даты</summary>
    protected void CustomValidatorNewDate_ServerValidate(object source, ServerValidateEventArgs args)
    {
        DateTime dt;
        args.IsValid = string.IsNullOrEmpty(args.Value.Trim()) ? true : DateTime.TryParse(args.Value, out dt);
    }

    /// <summary>Валидация загруженного файла</summary>
    protected void CustomValidatorNewDoc_ServerValidate(object source, ServerValidateEventArgs args)
    {
        if (this.IsValid)
        {
            this.LabelErrorUpload.Text = string.Empty;

            //Проверка не корректна, так как ошибка размера файлы вылезит в Global.asa BeginRequest            
            //из web.config сайта
            System.Web.Configuration.HttpRuntimeSection section = (System.Web.Configuration.HttpRuntimeSection)HttpContext.Current.GetSection("system.web/httpRuntime");
            //из  machine.config сервера
            //System.Web.Configuration.HttpRuntimeSection section = new System.Web.Configuration.HttpRuntimeSection();
            if (section != null)
            {
                this.CustomValidatorNewDoc.ErrorMessage = string.Format("Слишком большой размер файла (ограничение {0} kB)", section.MaxRequestLength);
                args.IsValid = (this.FileUploadNewDoc.PostedFile.ContentLength) < section.MaxRequestLength * 1024;
                if (!args.IsValid)
                    return;
            }

            //проверка расширений или типов файлов            
            string fileName = Server.HtmlEncode(this.FileUploadNewDoc.FileName);
            args.IsValid = Document.GetTypeDocument(fileName) != null;
            if (!args.IsValid)
                this.CustomValidatorNewDoc.ErrorMessage = string.Format("Формат \"{0}\" не поддерживается", System.IO.Path.GetExtension(fileName));

            return;
        }
    }

    /// <summary>загрузка и сохранение документа</summary>
    protected void UploadButtonNew_Click(object sender, EventArgs e)
    {
        if (this.Page.IsValid)
        {
            if (this.FileUploadNewDoc.HasFile)
            {
                try
                {
                    this.LabelErrorUpload.Text = string.Empty;

                    //определяем тип документа по расширению                    
                    string fileName = Server.HtmlEncode(this.FileUploadNewDoc.FileName);
                    int? typeID = Document.GetTypeDocument(fileName);
                    if (!typeID.HasValue)
                    {
                        this.LabelErrorUpload.Text = "Ошибка с определением типа документа";
                        this.LabelErrorUpload.ForeColor = System.Drawing.Color.Red;
                        return;
                    }

                    //получаем документ 
                    Stream streamDoc = this.FileUploadNewDoc.PostedFile.InputStream;
                    int contentLength = this.FileUploadNewDoc.PostedFile.ContentLength;
                    byte[] binaryDoc = new byte[contentLength];
                    streamDoc.Read(binaryDoc, 0, contentLength);

                    //сохранение в базу
                    SqlParameter[] param = { 
                        new SqlParameter("@Number", SqlDbType.NVarChar, 100),
                        new SqlParameter("@Date", SqlDbType.SmallDateTime),
                        new SqlParameter("@Name", SqlDbType.NVarChar),
                        new SqlParameter("@FolderID", SqlDbType.Int),
                        new SqlParameter("@DateUpload", SqlDbType.DateTime),
                        new SqlParameter("@DocumentTypeID", SqlDbType.Int),
                        new SqlParameter("@Doc", SqlDbType.Image)                    
                    };
                    //номер
                    param[0].IsNullable = true;
                    if (string.IsNullOrEmpty(this.TextBoxNewNomer.Text.Trim()))
                        param[0].Value = DBNull.Value;
                    else
                        param[0].Value = this.TextBoxNewNomer.Text.Trim();
                    //дата
                    param[1].IsNullable = true;
                    if (string.IsNullOrEmpty(this.TextBoxNewDate.Text.Trim()))
                        param[1].Value = DBNull.Value;
                    else
                    {
                        DateTime dt;
                        DateTime.TryParse(this.TextBoxNewDate.Text, out dt);
                        param[1].Value = dt;
                    }
                    //имя
                    if (string.IsNullOrEmpty(this.TextBoxNewName.Text.Trim()))
                        param[2].Value = "без названия";
                    else
                        param[2].Value = this.TextBoxNewName.Text.Trim();
                    param[3].Value = this.TreeViewFolders.SelectedNode.Value;
                    param[4].Value = DateTime.Now;
                    param[5].Value = typeID.Value;
                    param[6].IsNullable = true;
                    if (binaryDoc.Length < 1)
                        param[6].Value = DBNull.Value;
                    else
                        param[6].Value = binaryDoc;
                    int rowsAffected = AdoUtils.ExecuteCommand("INSERT INTO [Document] ([Number], [Date], [Name], [FolderID], [DateUpload], [DocumentTypeID], [Doc]) VALUES (@Number, @Date, @Name, @FolderID, @DateUpload, @DocumentTypeID, @Doc) ", param);
                    if (rowsAffected > 0)
                    {
                        Log.ToDB(LogEnum.DocAdd,
                            string.Format("Добавлен документ №{0} от {1} - {2}", this.TextBoxNewNomer.Text, this.TextBoxNewDate.Text, this.TextBoxNewName.Text));
                        
                        this.LabelErrorUpload.Text = "Документ сохранен";
                        this.LabelErrorUpload.ForeColor = System.Drawing.Color.Gray;

                        this.TextBoxNewNomer.Text = string.Empty;
                        this.TextBoxNewDate.Text = string.Empty;
                        this.TextBoxNewName.Text = string.Empty;
                        this.TreeViewFolders_SelectedNodeChanged(sender, e);
                    }
                    else
                    {
                        this.LabelErrorUpload.Text = "Ошибка при загрузке документа";
                        this.LabelErrorUpload.ForeColor = System.Drawing.Color.Red;
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("Documents.UploadButtonNew_Click -> Ошибка при добавлении нового документа \n " + ex.Message);
                }
            }
            else
            {
                this.LabelErrorUpload.Text = "Ошибка при загрузке документа";
                this.LabelErrorUpload.ForeColor = System.Drawing.Color.Red;
            }
        }
    }

    /// редактирование документа

    /// <summary>бинд (отображение) строки с документом</summary>
    protected void DataListDocumentsEdit_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        //видимость кнопок редактирования
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {            
            ImageButton editButton = (ImageButton)e.Item.FindControl("ImageButtonEdit");
            if (editButton != null)
                editButton.Visible = this.IsEditCurrentFolder;
        }

        //запрос на удаление
        if (e.Item.ItemType == ListItemType.SelectedItem)
        {
            LinkButton deleteButton = (LinkButton)e.Item.FindControl("LinkButtonDel");
            if (deleteButton != null)
                deleteButton.Attributes["onclick"] = "javascript:return confirm('Желаете удалить данные?')";
        }

        //подсветка новых        
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            HiddenField hiddenDateUpload = (HiddenField)e.Item.FindControl("HiddenFieldDateUpload");
            Image imageNew = (Image)e.Item.FindControl("ImageNew");
            imageNew.Visible = false;
            DateTime dt;
            if (hiddenDateUpload != null && imageNew != null)
            {                
                if (DateTime.TryParse(hiddenDateUpload.Value, out dt))
                    if (DateTime.Today <= dt.AddDays(Parameter.DAY_NEW_DOC))
                        imageNew.Visible = true;
            }
        }
    }

    /// <summary>редактировать запись о документе</summary>
    protected void DataListDocumentsEdit_EditCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListDocumentsEdit.SelectedIndex = e.Item.ItemIndex;
        this.TreeViewFolders_SelectedNodeChanged(source, e);
    }

    /// <summary>отмена редактирования записи документа</summary>
    protected void DataListDocumentsEdit_CancelCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListDocumentsEdit.SelectedIndex = -1;
        this.TreeViewFolders_SelectedNodeChanged(source, e);
    }

    /// <summary>удаление записи о документе</summary>
    protected void DataListDocumentsEdit_DeleteCommand(object source, DataListCommandEventArgs e)
    {
        if (this.IsEditCurrentFolder)
        {
            try
            {
                //запись не удаляется а помечается как удалённая
                SqlParameter[] param = { new SqlParameter("@ID", SqlDbType.Int) };
                param[0].Value = this.DataListDocumentsEdit.SelectedValue;
                int rowsAffected = AdoUtils.ExecuteCommand("UPDATE [Document] SET [Deleted] = 1 WHERE [ID] = @ID ", param);
                if (rowsAffected > 0)
                {
                    Log.ToDB(LogEnum.DocDel, "Документ ID=" + this.DataListDocumentsEdit.SelectedValue.ToString() + " помечен на удаление");
                    this.DataListDocumentsEdit.SelectedIndex = -1;
                    this.TreeViewFolders_SelectedNodeChanged(source, e);
                }
                else
                {
                    //error
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Documents.DataListDocumentsEdit_DeleteCommand -> Ошибка при удалении документа \n " + ex.Message);
            }
        }
    }

    /// <summary>сохранение изменений записи о документе</summary>
    protected void DataListDocumentsEdit_UpdateCommand(object source, DataListCommandEventArgs e)
    {
        this.Page.Validate("edit");
        if (this.IsEditCurrentFolder && this.Page.IsValid)
        {
            try
            {
                SqlParameter[] param = { 
                    new SqlParameter("@Number", SqlDbType.NVarChar, 100),
                    new SqlParameter("@Date", SqlDbType.SmallDateTime),
                    new SqlParameter("@Name", SqlDbType.NVarChar),
                    new SqlParameter("@ID", SqlDbType.Int),
                };
                //номер
                TextBox textBoxNomer = (TextBox)e.Item.FindControl("TextBoxEditNomer");
                param[0].IsNullable = true;
                if (textBoxNomer != null)
                {
                    if (string.IsNullOrEmpty(textBoxNomer.Text.Trim()))
                        param[0].Value = DBNull.Value;
                    else
                        param[0].Value = textBoxNomer.Text.Trim();
                }
                else
                    param[0].Value = DBNull.Value;
                //дата
                TextBox textBoxDate = (TextBox)e.Item.FindControl("TextBoxEditDate");
                param[1].IsNullable = true;
                if (textBoxDate != null)
                {
                    if (string.IsNullOrEmpty(textBoxDate.Text.Trim()))
                        param[1].Value = DBNull.Value;
                    else
                    {
                        DateTime dt;
                        DateTime.TryParse(textBoxDate.Text, out dt);
                        param[1].Value = dt;
                    }
                }
                else
                    param[1].Value = DBNull.Value;
                //имя
                TextBox textBoxName = (TextBox)e.Item.FindControl("TextBoxEditName");
                if (textBoxName != null)
                {
                    if (string.IsNullOrEmpty(textBoxName.Text.Trim()))
                        param[2].Value = "без названия";
                    else
                        param[2].Value = textBoxName.Text.Trim();
                }
                else
                    param[2].Value = "без названия";
                //ID
                param[3].Value = this.DataListDocumentsEdit.SelectedValue;

                int rowsAffected = AdoUtils.ExecuteCommand("UPDATE [Document] SET [Number]=@Number, [Date]=@Date, [Name]=@Name WHERE [ID]=@ID ", param);
                if (rowsAffected > 0)
                {
                    Log.ToDB(LogEnum.DocEdit, "Редактирование документа ID=" + this.DataListDocumentsEdit.SelectedValue.ToString());
                    this.DataListDocumentsEdit.SelectedIndex = -1;
                    this.TreeViewFolders_SelectedNodeChanged(source, e);
                }
                else
                {
                    //error
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Documents.DataListDocumentsEdit_UpdateCommand -> Ошибка при редактировании документа \n " + ex.Message);                
            }
        }
    }

}
