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
using System.IO;
using System.Data.SqlClient;

public partial class controls_AdmDocumentType : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //ограничение доступа
        int userID = (int)this.Session["USER_ID"];
        if (!Rule.IsAccess(userID, RuleEnum.Admin))
            this.Response.Redirect("~/Default.aspx");
    }

    /// <summary>Валидация загруженного файла</summary>
    protected void CustomValidatorNewImage_ServerValidate(object source, ServerValidateEventArgs args)
    {
        //проверка расширений файла с картинками            
        string fileName = Server.HtmlEncode(this.FileUploadNewImage.FileName);
        string extension = System.IO.Path.GetExtension(fileName);
        if (extension.StartsWith("."))
            extension = extension.Remove(0, 1);
        string[] exts = Parameter.EXTENSION_ICON.Split(Parameter.SPLITTER_STRING_ARRAY);
        args.IsValid = false;
        foreach (string ext in exts)
            if (extension.ToLower().Equals(ext.ToLower().Trim()))
                args.IsValid = true;
        if (!args.IsValid)
            this.CustomValidatorNewImage.ErrorMessage = string.Format("Формат \"{0}\" не поддерживается", extension);
        return;
        /*
         <asp:RegularExpressionValidator id="RegularExpressionValidator1" runat="server" 
            ErrorMessage="Only mp3, m3u or mpeg files are allowed!" 
            ValidationExpression="^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w].*))+(.mp3|.MP3|.mpeg|.MPEG|.m3u|.M3U)$" 
            ControlToValidate="FileUpload1"></asp:RegularExpressionValidator>
         */
    }

    /// <summary>удаление с запросом и сохранение с постбаком</summary>
    protected void GridViewTypes_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //сохранение с постбаком
            if (e.Row.Cells[0].Controls[0] is Button)
            {
                Button btn = (Button)e.Row.Cells[0].Controls[0];
                if (btn.CommandName.Equals("Update"))
                {                  
                    //PostBackTrigger tr = new PostBackTrigger();
                    //tr.ControlID = btn.UniqueID;
                    //this.UpdatePanelDoc.Triggers.Add(tr);
                    this.ScriptManagerDoc.RegisterPostBackControl(btn);

                    //ScriptManager sman = ScriptManager.GetCurrent(Page);
                    //sman.RegisterPostBackControl(btn_addDocument);
                }
            }
            
            //удаление с запросом
            if (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate)
            {
                if (e.Row.Cells[0].Controls[2] is Button)
                    ((Button)e.Row.Cells[0].Controls[2]).Attributes.Add("onclick", "if(!confirm('Желаете удалить данные?')) return false;");
            }
        }
    }

    /// <summary>Сохранение нового типа</summary>
    protected void ButtonNew_Click(object sender, EventArgs e)
    {
        if (this.Page.IsValid)
        {
            this.SqlDataSourceDocumentType.Insert();

            this.GridViewTypes.DataBind();
            this.TextBoxNewExtension.Text = string.Empty;
            this.TextBoxNewContentType.Text = string.Empty;
            this.TextBoxComment.Text = string.Empty;
        }
    }

    /// <summary>Событие в ДатаСурс - добавления типов доументов</summary>
    protected void SqlDataSourceDocumentType_Inserting(object sender, SqlDataSourceCommandEventArgs e)
    {
        //добавление картинки при INSERT
        if (!string.IsNullOrEmpty(this.FileUploadNewImage.FileName) && this.FileUploadNewImage.HasFile)
        {
            Stream streamImage = this.FileUploadNewImage.PostedFile.InputStream;
            byte[] binaryImg = new byte[this.FileUploadNewImage.PostedFile.ContentLength];
            streamImage.Read(binaryImg, 0, binaryImg.Length);

            e.Command.Parameters.RemoveAt("@Image");
            SqlParameter uploadedImage = new SqlParameter("@Image", SqlDbType.Image);
            uploadedImage.Value = binaryImg;
            e.Command.Parameters.Add(uploadedImage);

            e.Command.Parameters.RemoveAt("@ImageContentType");
            SqlParameter contentType = new SqlParameter("@ImageContentType", SqlDbType.NVarChar, 100);
            contentType.Value = this.FileUploadNewImage.PostedFile.ContentType;
            e.Command.Parameters.Add(contentType);
        }
        else
        {
            e.Command.Parameters.RemoveAt("@Image");
            SqlParameter uploadedImage = new SqlParameter("@Image", SqlDbType.Image);
            uploadedImage.Value = null;
            e.Command.Parameters.Add(uploadedImage);

            e.Command.Parameters.RemoveAt("@ImageContentType");
            SqlParameter contentType = new SqlParameter("@ImageContentType", SqlDbType.NVarChar, 100);
            contentType.Value = null;
            e.Command.Parameters.Add(contentType);
        }
    }

    /// <summary>Событие в гриде - изменение типов документа</summary>
    protected void GridViewTypes_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        GridViewRow row = this.GridViewTypes.Rows[e.RowIndex];
        FileUpload uploadImage = (FileUpload)row.FindControl("FileUploadEditImage");
        if (uploadImage != null)
        {
            if (!string.IsNullOrEmpty(uploadImage.FileName) && uploadImage.HasFile)
            {
                //обновление c картинкой
                this.SqlDataSourceDocumentType.UpdateCommand = "UPDATE [DocumentType] SET [Image]=@Image, [ImageContentType]=@ImageContentType, [Extension]=@Extension, [Comment]=@Comment, [ContentTypeDocument]=@ContentTypeDocument WHERE [ID] = @ID";
            }
            else
            {
                //без картинок
                this.SqlDataSourceDocumentType.UpdateCommand = "UPDATE [DocumentType] SET [ImageContentType]=@ImageContentType, [Extension]=@Extension, [Comment]=@Comment, [ContentTypeDocument]=@ContentTypeDocument WHERE [ID] = @ID";
            }
        }
    }

    /// <summary>событие в датасурс - событие изменение типов доументов</summary>
    protected void SqlDataSourceDocumentType_Updating(object sender, SqlDataSourceCommandEventArgs e)
    {
        GridViewRow row = this.GridViewTypes.Rows[this.GridViewTypes.EditIndex];
        FileUpload uploadImage = (FileUpload)row.FindControl("FileUploadEditImage");
        if (uploadImage != null)
        {
            if (!string.IsNullOrEmpty(uploadImage.FileName) && uploadImage.HasFile)
            {
                Stream streamImage = uploadImage.PostedFile.InputStream;
                byte[] binaryImg = new byte[uploadImage.PostedFile.ContentLength];
                streamImage.Read(binaryImg, 0, binaryImg.Length);

                e.Command.Parameters.RemoveAt("@Image");
                SqlParameter uploadedImage = new SqlParameter("@Image", SqlDbType.Image);
                uploadedImage.Value = binaryImg;
                e.Command.Parameters.Add(uploadedImage);

                e.Command.Parameters.RemoveAt("@ImageContentType");
                SqlParameter contentType = new SqlParameter("@ImageContentType", SqlDbType.NVarChar, 100);
                contentType.Value = uploadImage.PostedFile.ContentType;
                e.Command.Parameters.Add(contentType);
            }
        }
    }

    /// <summary>Получение типа контента из загруженного файла</summary>
    protected void ButtonTest_Click(object sender, EventArgs e)
    {
        if (this.FileUploadTestContentType.HasFile)
        {
            this.TextBoxResultContentType.Text = this.FileUploadTestContentType.PostedFile.ContentType;        
        }
    }
    
}
