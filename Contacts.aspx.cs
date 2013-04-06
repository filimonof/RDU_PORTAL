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
using System.Xml;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.Xml.Xsl;

public partial class Contacts : System.Web.UI.Page
{
    /// <summary>счетчик строк в таблице</summary>
    private int _numRow = 0;

    /// <summary>загрузка страницы</summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        this.Page.Title += " - Контакты";

        this.ButtonLoad.Visible = Rule.IsAccess((int)this.Session["USER_ID"], RuleEnum.AdmContact);

        if (!this.IsPostBack)
        {
            if (this.DataListContact.Items.Count > 0)
            {
                this.DataListContact.SelectedIndex = 0;
                this.DataListContact.DataBind();
            }

            int group;
            if (this.DataListContact.SelectedValue != null && int.TryParse(this.DataListContact.SelectedValue.ToString(), out group))
                this.CreateContactGroup(group);
        }

        //заполняем букофки
        if (this.DataListContact.SelectedValue != null)
            this.Fill_LinkFirstLetter((int)this.DataListContact.SelectedValue);
    }

    /// <summary>Заполнить поиск по первым буквам</summary>
    /// <param name="contactGroupID">ID группы контакной информации</param>
    protected void Fill_LinkFirstLetter(int contactGroupID)
    {
        //получить тип контактной группы 
        TypeContactEnum typeContact = (TypeContactEnum)AdoUtils.GetParamFromID("ContactTitle", "TypeID", contactGroupID);

        //проверяем тип
        switch (typeContact)
        {
            case (TypeContactEnum.LocalContact):
                string select = "SELECT DISTINCT SUBSTRING((LTRIM(c.[Family])),1,1) AS letter FROM [Contact] AS c WHERE c.[Enabled] = 1 ORDER BY letter ASC";
                SqlDataReader reader = AdoUtils.CreateSqlDataReader(select);
                this.LinkFirstLetterLocal1.ListLetter.Clear();
                this.LinkFirstLetterLocal2.ListLetter.Clear();
                while (reader.Read())
                {
                    this.LinkFirstLetterLocal1.ListLetter.Add((string)reader["letter"]);
                    this.LinkFirstLetterLocal2.ListLetter.Add((string)reader["letter"]);
                }
                reader.Close();
                break;
            case (TypeContactEnum.UPSv1):
                //парсить контакты СО заебёшься, так как на разные подразделения разный формат
                break;
            case (TypeContactEnum.UPSv2):
                string filename = System.IO.Path.Combine(Contact.DIR_CACHE_CONTACT, contactGroupID + ".xml");                
                string filename_abs = HttpContext.Current.Server.MapPath(filename);
                if (System.IO.File.Exists(filename_abs))
                {
                    this.LinkFirstLetterUPSv2Departament.ListLetter.Clear();
                    this.LinkFirstLetterUPSv2.ListLetter.Clear();
                    XmlDocument doc = new XmlDocument();
                    doc.Load(filename_abs);
                    XmlNodeList nodeList = doc.DocumentElement.SelectNodes(@"//RDU_Contacts/departament/contact");
                    foreach (XmlNode child in nodeList)
                    {
                        if (child.Attributes["name"].Value.Length > 0)
                        {
                            string letter = child.Attributes["name"].Value.Substring(0, 1).ToUpper();
                            if (this.LinkFirstLetterUPSv2Departament.ListLetter.FindByValue(letter) == null)
                            {
                                this.LinkFirstLetterUPSv2Departament.ListLetter.Add(letter);
                                this.LinkFirstLetterUPSv2.ListLetter.Add(letter);
                            }
                        }
                    }
                    this.LinkFirstLetterUPSv2Departament.Sort();
                    this.LinkFirstLetterUPSv2.Sort();
                }
                break;
            case (TypeContactEnum.File):
                //нет поиска 
                break;
            case (TypeContactEnum.XLSv1):
                //todo : нужно сделать
                break;
        }
    }
   
    /// <summary>установить заголовок</summary>
    private void SetTitle()
    {
        int group;
        if (this.DataListContact.SelectedValue != null && int.TryParse(this.DataListContact.SelectedValue.ToString(), out group))
            this.Title.Text = AdoUtils.GetParamFromID("ContactTitle", "Name", group).ToString();
        else
            this.Title.Text = string.Empty;
    }
    
    /// <summary>стилья для таблицы (переменые полосы)</summary>
    /// <returns>названия стилей в Css</returns>
    protected string StyleValueRow()
    {
        return (++this._numRow % 2 == 0) ? "GridRow_Row" : "GridRow_AltRow";
    }

    /// <summary>выбор контактной группы (левое-титульное меню с названиями организаций)</summary>
    protected void DataListContact_ItemCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListContact.SelectedIndex = e.Item.ItemIndex;
        int contactGroupID;
        if (int.TryParse(e.CommandArgument.ToString(), out contactGroupID))
            this.CreateContactGroup(contactGroupID);
        this.DataListContact.DataBind();
    }

    /// <summary>отображение контактов</summary>
    /// <param name="contactGroupID">ID группы контакной информации</param>
    private void CreateContactGroup(int contactGroupID)
    {
        //получить тип контактной группы 
        TypeContactEnum typeContact = (TypeContactEnum)AdoUtils.GetParamFromID("ContactTitle", "TypeID", contactGroupID);

        //включить пустое поле
        this.MultiViewContacts.SetActiveView(this.ViewEmpty);

        this.SetTitle();

        //проверяем тип
        switch (typeContact)
        {
            case (TypeContactEnum.LocalContact):
                this.CreateListLocalContact(string.Empty, string.Empty, string.Empty);
                break;
            case (TypeContactEnum.UPSv1):
                //todo : сделать парсинг контактов СО
                //парсить контакты СО заебёшься, так как на разные подразделения разный формат
                
                //делаем редирект
                string link = (string)AdoUtils.GetParamFromID("ContactTitle", "Link", contactGroupID);
                Response.Redirect(link);

                break;
            case (TypeContactEnum.UPSv2):
                this.CreateListUPSv2(contactGroupID, string.Empty, string.Empty, string.Empty);
                break;
            case (TypeContactEnum.File):
                this.CreateFileContact(contactGroupID);
                break;
            case (TypeContactEnum.XLSv1):
                this.CreateListXLS(contactGroupID);
                break;
        }

        //заполняем букофки
        if (this.DataListContact.SelectedValue != null)
            this.Fill_LinkFirstLetter((int)this.DataListContact.SelectedValue);
    }

/// -------------- локальные контакты -------------------------------------

    /// <summary>отображение локальных контактов</summary>
    /// <param name="letter">первая буква</param>
    /// <param name="departamentID">подразделение</param>
    /// <param name="postID">должность</param>    
    private void CreateListLocalContact(string letter, string departamentID, string postID)
    {
        this.SetTitle();

        if (string.IsNullOrEmpty(letter) && departamentID == string.Empty && string.IsNullOrEmpty(postID))
        {
            this.MultiViewContacts.SetActiveView(this.ViewDepartaments);
            this.DataListDepartament.DataBind();
        }
        else
        {
            this.HiddenFieldSortingLocal.Value = string.Empty; //сбрасываем сортировку на поумолчанию

            if (!string.IsNullOrEmpty(departamentID))
                this.Title.Text += ",  " + Contact.GetDepartamentName(int.Parse(departamentID), false);
            if (letter != string.Empty)
                this.Title.Text += ",  " + letter.ToUpper() + " . . .";

            this.MultiViewContacts.SetActiveView(this.ViewLocal);
            this.DataListLocalData.SelectedIndex = -1;
            this.SqlDataSourceLocalData.SelectParameters["letter"].DefaultValue = letter;
            this.SqlDataSourceLocalData.SelectParameters["departamentID"].DefaultValue = departamentID == null ? "-1" : (departamentID == string.Empty ? "0" : departamentID);
            this.SqlDataSourceLocalData.SelectParameters["postID"].DefaultValue = postID == null ? "-1" : (postID == string.Empty ? "0" : postID);            
            this.SqlDataSourceLocalData.Select(new DataSourceSelectArguments());
            this.DataListLocalData.DataBind();
        }
    }
    
    /// <summary>выбор подразделения</summary>
    protected void DataListDepartament_ItemCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListDepartament.SelectedIndex = e.Item.ItemIndex;
        int departamentID;
        if (int.TryParse(e.CommandArgument.ToString(), out departamentID))
            this.CreateListLocalContact(string.Empty, departamentID.ToString(), string.Empty);
        this.DataListDepartament.DataBind();
    }

    /// <summary>выбор прочих контактов</summary>
    protected void LinkButtonSelectDepartamentNull_OnClick(object source, EventArgs e)
    {
        this.CreateListLocalContact(string.Empty, null, string.Empty);
    }

    /// <summary>выбор пользователя дял просмотра полных данных</summary>
    protected void DataListLocalData_ItemCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListLocalData.SelectedIndex = e.Item.ItemIndex;
        this.DataListLocalData.DataBind();
    }

    /// <summary>убрать просмотр полных данных</summary>
    protected void LinkButtonCloseInfoUsers_Click(object sender, EventArgs e)
    {
        this.DataListLocalData.SelectedIndex = -1;
        this.DataListLocalData.DataBind();
    }

    /// <summary>кнопка вернуться к списку подразделений</summary>
    protected void LinkButtonReturnToDepartament_Click(object sender, EventArgs e)
    {
        this.CreateListLocalContact(string.Empty, string.Empty, string.Empty);
    }
    
    /// <summary>событие - выбор букве для фильтрафии по первой букве заголовка для локальной информации</summary>
    /// <param name="letter">буква</param>
    protected void LinkFirstLetterLocal_Select(string letter)
    {        
        this.CreateListLocalContact(letter, string.Empty, string.Empty);
    }

    /// <summary>событие - выбор параметра сортировки</summary>
    protected void SortLocal_OnCommand(Object sender, CommandEventArgs e)
    {
        this.HiddenFieldSortingLocal.Value = e.CommandName;
    }

    /// <summary>событие после выборки - указание параметра сортировки</summary>
    protected void SqlDataSourceLocalData_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
    {
        e.Arguments.SortExpression = this.HiddenFieldSortingLocal.Value;
    }

/// -------------- ОДУ и РДУ -------------------------------------

    /// <summary>отображение  контактов ОДУ или РДУ</summary>
    /// <param name="contactGroupID">ID группы контакной информации</param>
    /// <param name="letter">буква для вывода всех сотрудников на эту букву</param>
    /// <param name="departament">подразделение</param>
    /// <param name="sort">поле сортировки</param>
    private void CreateListUPSv2(int contactGroupID, string letter, string departament, string sort)
    {
        this.HiddenLetter.Value = letter;
        this.HiddenDepartament.Value = departament;

        string filename = System.IO.Path.Combine(Contact.DIR_CACHE_CONTACT, contactGroupID + ".xml");        
        string filename_abs = HttpContext.Current.Server.MapPath(filename);
        
        this.SetTitle();

        if (!System.IO.File.Exists(filename_abs))
            return;

        if (letter == string.Empty && departament == string.Empty)
        {
            //вывод подразделений
            this.MultiViewContacts.SetActiveView(this.ViewUPSv2Departament);
            this.XmlDataSourceUPS2TitleDepartament.DataFile = filename;
            this.XmlDataSourceUPS2Departament.DataFile = filename;
            this.RepeaterUPSv2TitleDepartament.DataBind();
            this.DataListUPS2Departament.DataBind();
        }
        else
        {
            //вывод работников подразделения
            this.MultiViewContacts.SetActiveView(this.ViewUPSv2);
            this.XmlDataSourceUPS2Title.DataFile = filename;
            this.XmlDataSourceUPS2.DataFile = filename;

            XsltArgumentList XsltArgList = new XsltArgumentList();
            XsltArgList.AddParam("field_sort", string.Empty, sort);
            XsltArgList.AddParam("first_letter_name", string.Empty, letter);
            XsltArgList.AddParam("name_departament", string.Empty, departament);
            XmlDataSourceUPS2.TransformArgumentList = XsltArgList;  
                      
            if (departament != string.Empty)
                this.Title.Text += ",  " + departament;
            else
                this.Title.Text += ",  " + letter.ToUpper() + " . . .";

            this.RepeaterUPSv2Title.DataBind();
            this.DataListUPS2.DataBind();
        }
    }

    /// <summary>выбор подразделения в контактах ОДУ и РДУ</summary>
    protected void DataListUPS2Departament_ItemCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListUPS2Departament.SelectedIndex = e.Item.ItemIndex;
        string departament = e.CommandArgument.ToString();
        this.CreateListUPSv2((int)this.DataListContact.SelectedValue, string.Empty, departament, string.Empty);
    }

    /// <summary>событие - выбор букве для фильтрафии по первой букве для информации об РДУ и ОДУ</summary>
    /// <param name="letter">буква</param>
    protected void LinkFirstLetterUPSv2_Select(string letter)
    {
        this.CreateListUPSv2((int)this.DataListContact.SelectedValue, letter, string.Empty, string.Empty);
    }

    /// <summary>кнопка вернуться к списку подразделений</summary>
    protected void LinkButtonReturnToDepartamentUPSv2_Click(object sender, EventArgs e)
    {
        this.CreateListUPSv2((int)this.DataListContact.SelectedValue, string.Empty, string.Empty, string.Empty);
    }

    /// <summary>событие - выбор параметра сортировки</summary>
    protected void SortUPS2_OnCommand(Object sender, CommandEventArgs e)
    {
        //todo : узнать подразделдение и букву        
        this.CreateListUPSv2((int)this.DataListContact.SelectedValue, this.HiddenLetter.Value, this.HiddenDepartament.Value, e.CommandName);        
    }

/// -------------- Excel -------------------------------------

    /// <summary>отображение  контактов из XLS файла</summary>
    /// <param name="contactGroupID">ID группы контакной информации</param>
    private void CreateListXLS(int contactGroupID)
    {
        //todo : нужно сделать
        string filename = System.IO.Path.Combine(Contact.DIR_CACHE_CONTACT, contactGroupID + ".xml");        
        string filename_abs = HttpContext.Current.Server.MapPath(filename);

        //this.SetTitle();

        if (!System.IO.File.Exists(filename_abs))
            return;


        this.MultiViewContacts.SetActiveView(this.ViewXLS);

        //export to excel 
        //Response.Clear();
        //Response.AddHeader("content-disposition", "attachment;filename=" + filename_abs); 
        //Response.Charset = ""; 
        //Response.Cache.SetCacheability(HttpCacheability.NoCache); 
        //Response.ContentType = "application/vnd.xls"; 
        //System.IO.StringWriter stringWrite = new System.IO.StringWriter(); 
        //System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite); 
        //gridPhysician.RenderControl(htmlWrite); 
        //Response.Write(stringWrite.ToString()); 
        //Response.End(); 

        /*
          OleDbConnection oledbConn = new OleDbConnection(string.Format("Provider=Microsoft.Jet.OleDb.4.0; data source={0}; Extended Properties=Excel 8.0;", filename_abs));

          try
          {
              // Open connection
              oledbConn.Open();

              // Create OleDbCommand object and select data from worksheet Sheet1
              OleDbCommand cmd = new OleDbCommand("SELECT * FROM [Лист1$]", oledbConn);

              // Create new OleDbDataAdapter
              OleDbDataAdapter oleda = new OleDbDataAdapter();

              oleda.SelectCommand = cmd;

              // Create a DataSet which will hold the data extracted from the worksheet.
              DataSet ds = new DataSet();

              // Fill the DataSet from the data extracted from the worksheet.
              oleda.Fill(ds, "Employees");

              // Bind the data to the GridView
              DataGridXLS.DataSourceID = null;
              DataGridXLS.DataSource = ds.Tables[0].DefaultView;
              DataGridXLS.DataBind();
          }
          finally
          {
              // Close connection
              oledbConn.Close();
          }
        
          */



        //this.DataGridXLS.DataBind();


        /*
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ProviderName="System.Data.Odbc"
        SelectCommand="SELECT * FROM [Sheet1$]" 
        ConnectionString="Driver={Microsoft Excel Driver (*.xls)};DBQ=D:\price.xls">
        </asp:SqlDataSource>
        */

        /*
          Microsoft Excel  11.0 Object Library
         * 
  public static void CreateExcelFile()
  {
   string FileName = "c:\\aa.xls";
   Missing miss = Missing.Value;
   Excel.Application m_objExcel = new Excel.Application();
   m_objExcel.Visible = false;
   Excel.Workbooks m_objBooks = (Excel.Workbooks)m_objExcel.Workbooks;
   Excel.Workbook m_objBook = (Excel.Workbook)(m_objBooks.Add(miss));

   m_objBook.SaveAs(FileName, miss, miss, miss, miss, miss, Excel.XlSaveAsAccessMode.xlNoChange, miss, miss,miss, miss, miss);
   m_objBook.Close(false, miss, miss);
   m_objExcel.Quit();
  } 
         */

        #region sample xls
        /* 
         using System;
using System.Data;
using System.Web;

namespace tahrep03
{
	/// <summary>
	/// Class to convert a dataset to an html stream which can be used to display the dataset
	/// in MS Excel
	/// The Convert method is overloaded three times as follows
	///  1) Default to first table in dataset
	///  2) Pass an index to tell us which table in the dataset to use
	///  3) Pass a table name to tell us which table in the dataset to use
	///  65536 excel row limit handled - 16.06.2006
	/// </summary>
	public class DataSetToExcel
	{
		public void Convert(DataSet ds, HttpResponse response, string xlsFileName)
		{
			response.Clear();
			response.AddHeader("content-disposition", "attachment;filename=" + xlsFileName);
			response.Charset = "";
			response.ContentType = "application/vnd.ms-excel";

			System.IO.StringWriter stringWrite = new System.IO.StringWriter();
			System.Web.UI.HtmlTextWriter htmlWrite = new System.Web.UI.HtmlTextWriter(stringWrite);
			System.Web.UI.WebControls.DataGrid dg = new System.Web.UI.WebControls.DataGrid();

			dg.DataSource = FitDataTableToExcel(ds.Tables[0]);
			dg.DataBind();
			dg.RenderControl(htmlWrite);

			response.Write(stringWrite.ToString());
			response.End();
		}
		public void Convert(DataSet ds, int TableIndex, HttpResponse response, string xlsFileName)
		{
			// lets make sure a table actually exists at the passed in value
			// if it is not call the base method
			if(TableIndex > ds.Tables.Count - 1)
			{
				Convert(ds, response, xlsFileName);
			}
			// we've got a good table so
			// let's clean up the response.object
			response.Clear();
			response.AddHeader("content-disposition", "attachment;filename=" + xlsFileName);
			response.Charset = "";
			// set the response mime type for excel
			response.ContentType = "application/vnd.ms-excel";
			// create a string writer
			System.IO.StringWriter stringWrite = new System.IO.StringWriter();
			// create an htmltextwriter which uses the stringwriter
			System.Web.UI.HtmlTextWriter htmlWrite = new System.Web.UI.HtmlTextWriter(stringWrite);
			// instantiate a datagrid
			System.Web.UI.WebControls.DataGrid dg = new System.Web.UI.WebControls.DataGrid();
			// set the datagrid datasource to the dataset passed in
			dg.DataSource = FitDataTableToExcel(ds.Tables[TableIndex]);
			// bind the datagrid
			dg.DataBind();
			// tell the datagrid to render itself to our htmltextwriter
			dg.RenderControl(htmlWrite);
			// all that's left is to output the html
			response.Write(stringWrite.ToString());
			response.End();
		}
		public void Convert(DataSet ds, string TableName,HttpResponse response, string xlsFileName)
		{
			// let's make sure the table name exists
			// if it does not then call the default method
			if(ds.Tables[TableName] == null)
			{
				Convert(ds, response, xlsFileName);
			}
			// we've got a good table so
			// let's clean up the response.object
			response.Clear();
			response.AddHeader("content-disposition", "attachment;filename=" + xlsFileName);
			response.Charset = "";
		    // set the response mime type for excel
			response.ContentType = "application/vnd.ms-excel";
			// create a string writer
			System.IO.StringWriter stringWrite = new System.IO.StringWriter();
			// create an htmltextwriter which uses the stringwriter
			System.Web.UI.HtmlTextWriter htmlWrite = new System.Web.UI.HtmlTextWriter(stringWrite);
			//instantiate a datagrid
			System.Web.UI.WebControls.DataGrid dg = new System.Web.UI.WebControls.DataGrid();
			// set the datagrid datasource to the dataset passed in
			dg.DataSource = this.FitDataTableToExcel(ds.Tables[TableName]);
			// bind the datagrid
			dg.DataBind();
			// tell the datagrid to render itself to our htmltextwriter
			dg.RenderControl(htmlWrite);
			// all that's left is to output the html
			response.Write(stringWrite.ToString());
			response.End();
		}
		private DataTable FitDataTableToExcel(DataTable dt)
		{
			int ExcelRowLimit = 65534;
			int TotTableRowCounter = 0;
			int TotExcelRowCounter = 0;
			int TempExcelRowCounter = 0;
			int TableCounter = 0;
			DataRow dr;
			DataTable ExcelTempTable = new DataTable();
			DataTable ExcelTable = new DataTable();
			do
			{
				ExcelTempTable = dt.Clone();
				TableCounter += 1;
				// Create Excel Temporary Table
				TempExcelRowCounter = 0;
				do
				{
					TotTableRowCounter += 1;
					TempExcelRowCounter += 1;
					dr = dt.Rows[TotTableRowCounter-1];
					ExcelTempTable.NewRow();
					ExcelTempTable.ImportRow(dr);
				} while (TotTableRowCounter < dt.Rows.Count & TempExcelRowCounter < ExcelRowLimit);
				// Join Excel Temporary Table to Excel Table as columns
				// Create columns of Excel Table
				// Line No column
				ExcelTable.Columns.Add(new DataColumn("No ["+TableCounter.ToString()+"]",typeof(Int32)));
				for (int i = 0; i <= ExcelTempTable.Columns.Count-1; i++) 
				{
					ExcelTable.Columns.Add(new DataColumn(ExcelTempTable.Columns[i].ColumnName+" ["+TableCounter.ToString()+"]",
						ExcelTempTable.Columns[i].DataType));
				}
				// Table seperator column
				ExcelTable.Columns.Add(new DataColumn("[*"+TableCounter.ToString()+"*]",typeof(String)));
				// Fill data into Excel Table from Excel Temporary Table
				int ExcelTableRow, ExcelTableCol = 0;
				for (ExcelTableRow = 0; ExcelTableRow <= ExcelTempTable.Rows.Count-1; ExcelTableRow ++)
				{
					try
					{
						ExcelTable.Rows[ExcelTableRow].BeginEdit();
					}
					catch
					{
						dr = ExcelTable.NewRow();
						ExcelTable.Rows.Add(dr);
						ExcelTable.Rows[ExcelTableRow].BeginEdit();
					}
					// Row Number value
					TotExcelRowCounter += 1;
					ExcelTable.Rows[ExcelTableRow][(TableCounter-1)+((TableCounter-1)*(ExcelTempTable.Columns.Count+1))] = TotExcelRowCounter;
					// Data column's value
					for (ExcelTableCol = 0; ExcelTableCol <= ExcelTempTable.Columns.Count-1; ExcelTableCol ++)
					{
						int CurrenColPositon = (ExcelTableCol+1)+((TableCounter-1)*(ExcelTempTable.Columns.Count+2));
						ExcelTable.Rows[ExcelTableRow][CurrenColPositon] =
							ExcelTempTable.Rows[ExcelTableRow].ItemArray[ExcelTableCol];
					}
					// Seperator column's value
					ExcelTable.Rows[ExcelTableRow][(TableCounter-1)+(((TableCounter-1)*(ExcelTempTable.Columns.Count+1))+ExcelTempTable.Columns.Count+1)] = " ";

					ExcelTable.Rows[ExcelTableRow].EndEdit();
					ExcelTable.Rows[ExcelTableRow].AcceptChanges();
				}
			}while (TotTableRowCounter < dt.Rows.Count);
			return ExcelTable;
		}
	}
}
         */
        #endregion
    }

/// -------------- File -------------------------------------

    /// <summary>отображение файла с контактами</summary>
    /// <param name="contactGroupID">ID группы контакной информации</param>
    private void CreateFileContact(int contactGroupID)
    {
        //todo : нужно сделать

        object ext = AdoUtils.GetParamFromID("ContactTitle", "Description", contactGroupID);
        string filename = System.IO.Path.Combine(Contact.DIR_CACHE_CONTACT, contactGroupID + "." + ext.ToString());        
        string filename_abs = HttpContext.Current.Server.MapPath(filename);

        if (!System.IO.File.Exists(filename_abs))
            return;

        //пока используем редирект, так как WriteFile в UpdatePanel не работает
        Response.Redirect(filename);

        #region отдать файл клиенту
        /* В Page_Load добавить  ScriptManager.GetCurrent(this.Page).RegisterPostBackControl(Button1);         
         *    ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)e.Row.FindControl("imgbtnName"));
         * 1) Open file within the browser: The following code will preface the response object as a PDF file, and then transmit the file directly to the HTTP response.  Then, it will flush the response to the browser, and stops execution of the page.  Typically, the behavior that this evokes is Adobe Reader will open inside the browser and download the document so that the user can view its contents within Adobe Reader.
            Response.ContentType = "application/pdf";
            //write file to the buffer
            Response.TransmitFile(@"e:\inet\www\docs\testdoc.pdf");
            Response.End();
            2) Open "file download" dialog box: If you do not want the PDF to automatically open inside the browser window, you can give the user the "File Download" option.  This dialog box typically lets the user either open, save, or cancel the file.  The method for communicating this behavior to the browser is to add an http header "content-disposition" to the response object. 
            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", "attachment; filename=testdoc.pdf");
            Response.TransmitFile(@"e:\inet\www\docs\testdoc.pdf");
            Response.End();
         *
         или
         * 
        Download(MapPath("~/Reports/Rep_.xls"), "Rep_.xls");
        public void Download(string fileName, string downloadName)
        {
            var fi = new FileInfo(fileName);
            base.Response.Clear();
            base.Response.ClearHeaders();
            base.Response.ContentType = "application/octet-stream";
            base.Response.AddHeader("Content-Length", fi.Length.ToString());
            if(base.Request.Browser.IsBrowser("IE"))
                downloadName = HttpUtility.UrlPathEncode(downloadName);
            base.Response.AddHeader("Content-Disposition", string.Format("attachment; filename=\"{0}\"", downloadName));
            base.Response.Buffer = false;
            base.Response.WriteFile(fileName);
            base.Response.Flush();
            base.Response.End();
          
            или 
          
            System.IO.FileInfo fileInfo = new System.IO.FileInfo(filename_abs);
            Response.Clear();
            Response.ContentType = "application;name=" + fileInfo.Name;
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + fileInfo.Name);
            Response.AppendHeader("Content-Length", fileInfo.Length.ToString());
            Response.WriteFile(filename_abs);
            Response.Flush();
        }
        */
        #endregion

        #region отдать файл клиенту с докачкой
        /*
         С докачкой. Механизм извлечения файлопути заточите под себя.
        Обращаю внимание на:
        1) Response.Buffer = False (неча тут буферизировать).
        2) Response.AddHeader("Content-Disposition", "attachment; extractFileName(fPath)) (подсказывае UA, какое имя файла)
        3) Response.AddHeader("ETag", (fPath.GetHashCode OR fInfo.LastWriteTimeUtc.GetHashCode)) (Сами строим ETAG -- кеш. проси его любят)
        4) Response.AddHeader("Accept-Ranges", "bytes") (да, поддерживаем докачку, и сами там ниже анализируем, просят ли докачку)
        5) IF Request.RequestType = "HEAD" THEN
                Response.AddHeader("X-DebugInfo", "HEAD request, no file data output")
           Вы уже поняли, что некоторые UA попросят HEAD перед закачкой? Так может делать, к примеру wget. И вот, тело файла не нужно отдавать при этом запросе, IIS всё равно отдаст только заголовки.
        6) Response.AddHeader("Content-Length", fSize) -- не обижаем UAs, отдадим им размер контента, пусть подавятся ;)
        7) Response.TransmitFile(fPath) -- остро заточенная ASP.NET функция для отдачи файлов, оптимизирована по самое не хочу.


        <%
	        Response.Buffer = False
	        Response.ContentType = "application/octet-stream"

	        DIM fPath AS String = Request("base")
	        IF [String].IsNullOrEmpty(fPath) OR (Right(fPath, 1) <> "/") OR (Right(fPath, 1) <> "\") THEN
		        fPath = fPath + "/"
	        END IF
	        fPath = Server.MapPath(fPath + Request("id"))
	        Response.AddHeader("Content-Disposition", "attachment; extractFileName(fPath))

	        DIM fInfo AS New IO.FileInfo(fPath)
	        Response.AddHeader("ETag", (fPath.GetHashCode OR fInfo.LastWriteTimeUtc.GetHashCode))
	        Response.AddHeader("Accept-Ranges", "bytes")

	        IF Request.RequestType = "HEAD" THEN
		        Response.AddHeader("X-DebugInfo", "HEAD request, no file data output")
	        ELSE
		        DIM rangeStr AS String = Request.Headers("Range")
		        DIM fSize AS Int64 = fInfo.Length
		        IF [String].isNullOrEmpty(rangeStr) THEN
			        Response.AddHeader("Content-Length", fSize)
			        Response.TransmitFile(fPath)
		        ELSE
			        DIM rangeStart, rangeEnd AS Int64
			        IF Left(rangeStr, 1) = "-" THEN
				        rangeStart = 0
				        rangeEnd = Convert.toInt64(rangeStr.SubString(2))
			        END IF
			        IF Right(rangeStr, 1) = "-" THEN 
				        rangeStart = Convert.toInt64(rangeStr.SubString(1, rangeStr.Length - 1))
				        rangeEnd = fSize
			        END IF
			        IF isNothing(rangeStart) THEN
				        DIM delimiterPos AS Integer
				        delimiterPos = rangeStr.IndexOf("-")
				        rangeStart = Convert.toInt64(rangeStr.SubString(1, delimiterPos))
				        rangeEnd = Convert.toInt64(rangeStr.Substring(delimiterPos + 1, rangeStr.Length))
			        END IF

			        DIM cLength AS Int64 = (fSize - rangeStart - rangeEnd)
			        Response.AddHeader("Content-Length", cLength)
			        Response.TransmitFile(fPath, rangeStart, cLength)
		        END IF
	        END IF
        %>


        Это решение подойдйт для отдачи самого тяжёлого контента, лишь бы хостер не зарубил долго висящий на синхронном Response.TransmitFile рабочий поток, но опять же, докачка.
        Успехов!
         */
        #endregion
    }

/// -------------- Load -------------------------------------

    /// <summary>кнопка загрузки контактов</summary>
    protected void ButtonLoad_Click(object sender, EventArgs e)
    {
        if (Rule.IsAccess((int)this.Session["USER_ID"], RuleEnum.AdmContact))
        {
            this.LoadContact();

            int group;
            if (this.DataListContact.SelectedValue != null && int.TryParse(this.DataListContact.SelectedValue.ToString(), out group))
                this.CreateContactGroup(group);
        }
    }

    /// <summary>Загрузка и формирование контактных данных</summary>
    public void LoadContact()
    {
        string select = "SELECT * FROM [ContactTitle] WHERE Enabled = 1 ORDER BY [Order] ";
        SqlDataReader reader = AdoUtils.CreateSqlDataReader(select);
        if (reader.HasRows)
        {
            while (reader.Read())
            {
                string filename = System.IO.Path.Combine(Contact.DIR_CACHE_CONTACT, reader["ID"].ToString() + ".xml" );
                if (!string.IsNullOrEmpty(reader["Link"].ToString()))
                    Contact.DownloadContact((string)reader["Name"], (string)reader["Link"], filename, (TypeContactEnum)reader["TypeID"], (string)reader["Description"]);
            }
        }
        reader.Close();
    }

}
