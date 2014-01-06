using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using GradeBook.Utils;
using GradeBook.Utils.Classes;

namespace GradeBook
{
    public partial class _Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (System.Web.HttpContext.Current.User.Identity.IsAuthenticated && !SessionManager.CheckNull())
            {
                if (!IsPostBack)
                {
                    DataHandler db = new DataHandler();
                    lblInstructorName.Text = SessionManager.Instructor.FirstName + " " + SessionManager.Instructor.LastName;

                    using (db.Connect())
                    {
                        db.Command("ReturnInstructorCourses", true);
                        db.Add("@instructor_id", SessionManager.Instructor.ID);
                        db.Start();

                        rptCourses.DataSource = db.Exec();
                        rptCourses.DataBind();
                        db.Stop();
                    }
                }
            }
        }


        protected void AddCourse(object sender, EventArgs e)
        {
            DataHandler db = new DataHandler();

            using (db.Connect())
            {
                db.Command("INSERT INTO Course (course_name, start_date, end_date, instructor_id) VALUES (@c_name, @start_date, @end_date, @id)", false);
                db.Add("@c_name", txtCourseEntry.Text);
                db.Add("@start_date", txtStartDate.Text);
                db.Add("@end_date", txtEndDate.Text);
                db.Add("@id", SessionManager.Instructor.ID);
                db.Start();
                db.ExecNonQuery();

                db.Stop();


            }

            Response.Redirect(Request.RawUrl);
        }
    }
}
