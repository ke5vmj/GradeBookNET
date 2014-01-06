using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using GradeBook.Utils;

namespace GradeBook.Main
{
    public partial class Student : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (System.Web.HttpContext.Current.User.Identity.IsAuthenticated && !SessionManager.CheckNull())
            {
                DataHandler db = new DataHandler();

                using (db.Connect())
                {
                    String FirstName;
                    String LastName;

                    db.Command("SELECT f_name, l_name FROM Student WHERE student_id = @student_id", false);
                    db.Add("@student_id", Request["Id"]);

                    db.Start();
                    SqlDataReader reader = db.Exec();
                    reader.Read();

                    FirstName = reader.GetString(0);
                    LastName = reader.GetString(1);

                    lblName.Text = FirstName + " " + LastName;

                    db.Stop();
                }
            }
        }
    }
}