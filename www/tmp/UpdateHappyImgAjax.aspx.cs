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

public partial class tmp_UpdateHappyImgAjax : System.Web.UI.Page
{
    private void Page_Load(object sender, System.EventArgs e)
    {
    }

    public void UploadBtn_Click(object sender, System.EventArgs e)
    {
        if (Page.IsValid) //save the image
        {
            Stream imgStream = UploadFile.PostedFile.InputStream;
            int imgLen = UploadFile.PostedFile.ContentLength;
            string imgContentType = UploadFile.PostedFile.ContentType;
            string imgName = txtImgName.Value;
            byte[] imgBinaryData = new byte[imgLen];
            int n = imgStream.Read(imgBinaryData, 0, imgLen);

            int RowsAffected = SaveToDB(imgName, imgBinaryData, imgContentType);
            if (RowsAffected > 0)
            {
                Response.Write("<BR>Сохранено");
            }
            else
            {
                Response.Write("<BR>Ошибка");
            }
        }
    }


    private int SaveToDB(string imgName, byte[] imgbin, string imgcontenttype)
    {
        //use the web.config to store the connection string
        SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["siteConnectionString"].ConnectionString);
        SqlCommand command = new SqlCommand("UPDATE [Holiday] SET [Image] = @Foto WHERE  [ID] = @ID", connection);

        SqlParameter param0 = new SqlParameter("@ID", SqlDbType.Int);
        param0.Value = imgName;
        command.Parameters.Add(param0);

        SqlParameter param1 = new SqlParameter("@Foto", SqlDbType.Image);
        param1.Value = imgbin;
        command.Parameters.Add(param1);

        connection.Open();
        int numRowsAffected = command.ExecuteNonQuery();
        connection.Close();

        return numRowsAffected;
    }

}
