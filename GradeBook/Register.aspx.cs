using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using GradeBook.Utils;

namespace GradeBook
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblComplete.Visible = false;

            if (!Page.IsPostBack)
            {
            }
        }

        protected void CreateNewUser(object sender, EventArgs e)
        {
            DataHandler db = new DataHandler();




            using (db.Connect())
            {
                
                db.Command("UserExists", true);
                db.Add("@username", UserName.Text);
                db.AddIntReturn();
                db.Start();
                db.ExecNonQuery();
                db.Stop();

                int result;
                result = db.ReturnValue();

                if (result == 0)
                {
                    db.Start();
                    db.Command("INSERT INTO Instructor (f_name, l_name, login, password) VALUES (@fname, @lname, @login, @pass)", false);
                    db.Add("@fname", FirstName.Text);
                    db.Add("@lname", LastName.Text);
                    db.Add("@login", UserName.Text);
                    db.Add("@pass", Password.Text);
                    db.ExecNonQuery();
                    db.Stop();

                    lblComplete.Text = "Registration is complete.";
                    lblComplete.Visible = true;
                }
                else
                {
                    lblComplete.Text = "This user already exists.";
                    lblComplete.Visible = true;
                }
            }

        }
    }
}