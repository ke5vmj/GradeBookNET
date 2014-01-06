using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using GradeBook.Utils;
using GradeBook.Utils.Classes;

namespace GradeBook.Main
{
    public partial class Course : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (System.Web.HttpContext.Current.User.Identity.IsAuthenticated)
            {
                Courses course = new Courses();
                DataHandler db = new DataHandler();
                string Id = Request["Id"];

                using (db.Connect())
                {

                    db.Command("SELECT course_name, start_date, end_date FROM Course WHERE course_id = @id", false);
                    db.Add("@id", Id);
                    db.Start();

                    SqlDataReader reader = db.Exec();
                    reader.Read();

                    //Collect this information for sessions
                    course.ID = Convert.ToInt32(Id);
                    course.Name = reader.GetString(0);
                    course.StartDate = reader.GetDateTime(1);
                    course.EndDate = reader.GetDateTime(2);
                    SessionManager.Course = course;
                    //Done

                    lblCourseName.Text = reader.GetString(0);

                    db.Stop();

                    //Right here I will append the ID to the ends of the navigation URLs
                    lnkCourse.NavigateUrl += Id;
                    lnkGrading.NavigateUrl += Id;
                    lnkReport.NavigateUrl += Id;
                    lnkStudents.NavigateUrl += Id;
                }
            }
        }
    }
}