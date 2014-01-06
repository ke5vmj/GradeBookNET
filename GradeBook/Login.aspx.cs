using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data;
using System.Data.SqlClient;
using GradeBook.Utils;
using GradeBook.Utils.Classes;

namespace GradeBook
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                


            }
        }

        protected void LoginBox_Authenticate(object sender, AuthenticateEventArgs e)
        {
            DataHandler db = new DataHandler();
            Instructor instructor = new Instructor();

            e.Authenticated = false;

            using (db.Connect())
            {
                int result;

                db.Command("Login", true);
                db.Add("@username", LoginBox.UserName);
                db.Add("@password", LoginBox.Password);
                db.AddIntReturn();

                db.Start();
                db.ExecNonQuery();
                result = db.ReturnValue();

                if (result > 0)
                {
                    db.Command("CollectSessionInfoInstructor", true);
                    db.Add("@username", LoginBox.UserName);
                    SqlDataReader reader = db.Exec();
                    reader.Read();                      //read the record, advance the cursor, etc.
                    

                    e.Authenticated = true;
                    FormsAuthentication.RedirectFromLoginPage(LoginBox.UserName, true);
                    instructor.UserName = LoginBox.UserName;
                    instructor.ID = reader.GetInt32(0);             //Encapsulate my Session information for later use
                    instructor.FirstName = reader.GetString(1);
                    instructor.LastName = reader.GetString(2);

                    SessionManager.Instructor = instructor;
                }
                else
                {
                    e.Authenticated = false;

                }

                db.Stop();
            }            
        }
    }
}
