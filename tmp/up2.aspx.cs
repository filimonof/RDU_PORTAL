﻿using System;
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

public partial class tmp_up2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Label2.Text = DateTime.Now.ToString();
    }

    protected void btnUpload_Click(object sender, EventArgs e)
    {
        AsyncFileUpload1.SaveAs(Server.MapPath((AsyncFileUpload1.FileName)));
        Label1.Text = "You uploaded " + AsyncFileUpload1.FileName;
    }
}
