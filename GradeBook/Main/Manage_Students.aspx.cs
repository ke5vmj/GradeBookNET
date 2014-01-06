using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using GradeBook.Utils;
using GradeBook.Utils.Classes;

namespace GradeBook.Main
{
    public partial class Manage_Students : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (System.Web.HttpContext.Current.User.Identity.IsAuthenticated)
            {
                if (!IsPostBack)
                {
                    lblCourseName.Text = SessionManager.Course.Name;

                   DataHandler db = new DataHandler();

                   using (db.Connect())
                   {
                       int finalized;

                       db.Command("ListStudentsForCourse", true);
                       db.Add("@course_id", SessionManager.Course.ID);
                       db.Start();
                       rptStudents.DataSource = db.Exec();
                       rptStudents.DataBind();
                       db.Stop();                                           //Close the already used datareader

                       db.Command("CheckFinalized", true);
                       db.Add("@course_id", SessionManager.Course.ID);
                       db.AddIntReturn();

                       db.Start();
                       db.ExecNonQuery();
                       finalized = db.ReturnValue();

                       if (finalized != 0)
                       {
                           lnkAdd.Visible = false;
                           lblFinalized.Visible = true;
                           lnkFinalize.Visible = false;
                       }
                       db.Stop();
                   }
                }
            }
        }

        protected void AddStudent(object sender, EventArgs e)
        {
            DataHandler db = new DataHandler();

            using (db.Connect())
            {
                db.Command("AddNewStudent", true);
                db.Add("@f_name", txtFirstName.Text);
                db.Add("@l_name", txtLastName.Text);
                db.Add("@instructor_id", SessionManager.Instructor.ID);
                db.Add("@course_id", SessionManager.Course.ID);

                db.Start();
                db.ExecNonQuery();
                db.Stop();
            }

            Response.Redirect(Request.RawUrl);
        }

        protected void FinalizeRoster(object sender, EventArgs e)
        {
            DataHandler db = new DataHandler();

            using (db.Connect())
            {
                db.Command("FinalizeRoster", true);
                db.Add("@course_id", SessionManager.Course.ID);

                db.Start();
                db.ExecNonQuery();
                db.Stop();
                Response.Redirect(Request.RawUrl);
            }
        }
    }
}