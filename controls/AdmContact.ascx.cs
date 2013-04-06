using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class controls_AdmContact : System.Web.UI.UserControl
{
    /// <summary>загрузка страницы</summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        //ограничение доступа
        int userID = (int)this.Session["USER_ID"];
        if (!Rule.IsAccess(userID, RuleEnum.Admin))
            this.Response.Redirect("~/Default.aspx");
    }

    /// <summary>удаление контакта</summary>
    protected void DataListContact_DeleteCommand(object source, DataListCommandEventArgs e)
    {
        int id = (int)this.DataListContact.DataKeys[e.Item.ItemIndex];
        this.SqlDataSourceContact.DeleteParameters["ID"].DefaultValue = id.ToString();
        this.SqlDataSourceContact.Delete();
                
        this.DataListContact.DataBind();
    }

    /// <summary>отмена редактирования контакта</summary>
    protected void DataListContact_CancelCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListContact.EditItemIndex = -1;                 
        this.DataListContact.DataBind();
    }

    /// <summary>редактирование контакта</summary>
    protected void DataListContact_EditCommand(object source, DataListCommandEventArgs e)
    {
        this.DataListContact.EditItemIndex = e.Item.ItemIndex;               
        this.DataListContact.DataBind();
    }    

    /// <summary>подтвердить изменение контакта</summary>
    protected void DataListContact_UpdateCommand(object source, DataListCommandEventArgs e)
    {
        //if (!this.Page.IsValid) return;

        int id = (int)this.DataListContact.DataKeys[e.Item.ItemIndex];

        CheckBox checkBoxEnabled = (CheckBox)e.Item.FindControl("CheckBoxEnabled"); 
        TextBox textBoxFamily = (TextBox)e.Item.FindControl("TextBoxFamily");
        TextBox textBoxFirstName = (TextBox)e.Item.FindControl("TextBoxFirstName");
        TextBox textBoxLastName = (TextBox)e.Item.FindControl("TextBoxLastName");
        TextBox textBoxBirthDay = (TextBox)e.Item.FindControl("TextBoxBirthDay");
        TextBox textBoxPhone = (TextBox)e.Item.FindControl("TextBoxPhone");
        TextBox textBoxEmail = (TextBox)e.Item.FindControl("TextBoxEmail"); 
        DropDownList dropDownListUserType = (DropDownList)e.Item.FindControl("DropDownListUserType"); 
        DropDownList dropDownListUserID = (DropDownList)e.Item.FindControl("DropDownListUserID"); 
        DropDownList dropDownListDepartamentID = (DropDownList)e.Item.FindControl("DropDownListDepartamentID"); 
        DropDownList dropDownListPost = (DropDownList)e.Item.FindControl("DropDownListPost");

        
        this.SqlDataSourceContact.UpdateParameters["ID"].DefaultValue = id.ToString();        
        this.SqlDataSourceContact.UpdateParameters["Family"].DefaultValue = textBoxFamily.Text;
        this.SqlDataSourceContact.UpdateParameters["FirstName"].DefaultValue = textBoxFirstName.Text;
        this.SqlDataSourceContact.UpdateParameters["LastName"].DefaultValue = textBoxLastName.Text;
        this.SqlDataSourceContact.UpdateParameters["BirthDay"].DefaultValue = textBoxBirthDay.Text;        
        this.SqlDataSourceContact.UpdateParameters["Phone"].DefaultValue = textBoxPhone.Text;        
        this.SqlDataSourceContact.UpdateParameters["Email"].DefaultValue = textBoxEmail.Text;
        this.SqlDataSourceContact.UpdateParameters["Enabled"].DefaultValue = checkBoxEnabled.Checked.ToString();
        this.SqlDataSourceContact.UpdateParameters["UserType"].DefaultValue = dropDownListUserType.SelectedValue;
        this.SqlDataSourceContact.UpdateParameters["DepartamentID"].DefaultValue = dropDownListDepartamentID.SelectedValue;
        this.SqlDataSourceContact.UpdateParameters["PostID"].DefaultValue = dropDownListPost.SelectedValue;
        this.SqlDataSourceContact.UpdateParameters["UserID"].DefaultValue = dropDownListUserID.SelectedValue;
        //this.SqlDataSourceContact.UpdateParameters["Foto"].DefaultValue = 
        this.SqlDataSourceContact.Update();               
        
        this.DataListContact.EditItemIndex = -1; 
        this.DataListContact.DataBind();

        /*
        //если выбрана другая фотография пользователя
        HtmlInputFile foto = (HtmlInputFile)(e.Item.FindControl("UploadedFoto"));
        if (foto.PostedFile.FileName != "")
        {
            string fileName = System.IO.Path.GetFileName(foto.Value);
            //filPicture.PostedFile.SaveAs(Server.MapPath("images/" + strFileName));
            strSQL = "UPDATE category SET Picture = 'images/" + strFileName + "' " +
                " WHERE CategoryID = " + lblCateID.Text + " ";
            objCmd = new OleDbCommand(strSQL, objConn);
            objCmd.ExecuteNonQuery();
        }
        */

        //http://netindonesia.net/blogs/andriyadi/archive/2009/10/20/ajax-control-toolkit-asyncfileupload.aspx

        /*
        if (this.IsValid && this.UploadedFile.HasFile)
        {
            //Create an ImageElement to wrap up the uploaded image
            Neodynamic.WebControls.ImageDraw.ImageElement uploadedImage;
            uploadedImage = Neodynamic.WebControls.ImageDraw.ImageElement.FromBinary(this.UploadedFile.FileBytes);

            //Create Resize imaging action to apply on the uploaded image
            //NOTE: You may apply any of the ImageDraw built-in imaging actions
            Neodynamic.WebControls.ImageDraw.Resize actResize = new Neodynamic.WebControls.ImageDraw.Resize();
            actResize.Width = 150;
            actResize.LockAspectRatio = Neodynamic.WebControls.ImageDraw.LockAspectRatio.WidthBased;

            uploadedImage.Actions.Add(actResize);

            //Composite the output image by using ImageDraw class
            Neodynamic.WebControls.ImageDraw.ImageDraw imgDraw = new Neodynamic.WebControls.ImageDraw.ImageDraw();

            //Add uploaded image
            imgDraw.Elements.Add(uploadedImage);

            //Output image settings...
            //For example: save the image in JPEG format always
            imgDraw.ImageFormat = Neodynamic.WebControls.ImageDraw.ImageDrawFormat.Jpeg;
            imgDraw.JpegCompressionLevel = 90;

            //Now, save the output image on disk
            string fileName = @"C:\Temp\" + System.IO.Path.GetFileNameWithoutExtension(this.FileUpload1.FileName) + ".jpg";
            imgDraw.Save(fileName);

        }
        */


    }

    /// <summary>добавить контакт</summary>
    protected void ButtonAdd_Click(object sender, EventArgs e)
    {
/*
        System.IO.Stream inputStream = FileUpload1.PostedFile.InputStream;
        int imageLength = FileUpload1.PostedFile.ContentLength;
        byte[] imageBinary = new byte[imageLength];
        int inputRead = inputStream.Read(imageBinary, 0, imageLength);
        byte[] imageData = imageBinary;
        System.Data.SqlClient.SqlParameter uploadData = new System.Data.SqlClient.SqlParameter("@photo", System.Data.SqlDbType.Image);
        uploadData.Value = imageData;
        this.SqlDataSourceContact.InsertParameters["Foto"].DefaultValue = string.Empty;
        this.SqlDataSourceContact.InsertParameters["Foto"].DefaultValue = imageData.ToString();
*/        

        /*
        if (this.SqlDataSourceContact.Insert() > 0)
        {            
            if (this.FileUpload1.PostedFile != null && this.FileUpload1.PostedFile.FileName != "")
            {
                byte[] imageSize = new byte[this.FileUpload1.PostedFile.ContentLength];
                HttpPostedFile uploadedImage = this.FileUpload1.PostedFile;
                uploadedImage.InputStream.Read(imageSize, 0, (int)this.FileUpload1.PostedFile.ContentLength);

                SqlParameter[] param = 
                { 
                    new SqlParameter("@ID", SqlDbType.Int),
                    new SqlParameter("@Foto", SqlDbType.Image) 
                };
                param[0].Value = 49;
                param[1].Value = imageSize;                   
                AdoUtils.ExecuteCommand("UPDATE [Contact] SET [Foto] = @Foto WHERE [ID] = @ID", param);
            }
        }
        */

        this.SqlDataSourceContact.Insert();
        this.DataListContact.DataBind();

        this.TextBoxFamily.Text = string.Empty;
        this.TextBoxFirstName.Text = string.Empty;
        this.TextBoxLastName.Text = string.Empty;
        this.TextBoxPhone.Text = string.Empty;
        this.TextBoxEmail.Text = string.Empty;
        this.TextBoxBirthDay.Text = string.Empty;
        this.CheckBoxEnabled.Checked = false;
        this.DropDownListDepartamentID.SelectedIndex = 0;
        this.DropDownListPost.SelectedIndex = 0;
        this.DropDownListUserID.SelectedIndex = 0;
        this.DropDownListUserType.SelectedIndex = 0;
    }

    protected void SqlDataSourceContact_Inserting(object sender, SqlDataSourceCommandEventArgs e)
    {
        //if (this.AsyncFileUpload1.HasFile)
        //    e.Command.Parameters["@Foto"].Value = this.AsyncFileUpload1.FileBytes;
    }
}
