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

public partial class tmp_up3 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Files.Count == 1)
        {
            Response.Write("SUCCESS");
            Response.End();
        }
    }
    protected void btnUploadComplted_Click(object sender, EventArgs e)
    {
        lblMessage.Text = "UPLOAD PROCESS COMPLETED SUCCESSFULLY";
    }
}
