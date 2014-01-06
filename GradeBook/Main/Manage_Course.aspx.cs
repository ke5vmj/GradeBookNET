using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Configuration;
using GradeBook.Utils;
using GradeBook.Utils.Classes;

namespace GradeBook.Main
{
    public partial class Manage_Course : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (System.Web.HttpContext.Current.User.Identity.IsAuthenticated)
            {
                lblError.Visible = false;
                if (!IsPostBack)
                {
                    lblCourseName.Text = SessionManager.Course.Name;

                    DataHandler db = new DataHandler();

                    using (db.Connect())
                    {
                        db.Command("ListCourseAssignments", true);
                        db.Add("@course_id", SessionManager.Course.ID);
                        db.Start();

                        rptAssignments.DataSource = db.Exec();
                        rptAssignments.DataBind();
                        db.Stop();
                    }
                }
            }
        }

        protected void AddAssignment(object sender, EventArgs e)
        {
            DataHandler db = new DataHandler();

            using (db.Connect())
            {
                int result;
                int finalized;
                db.Command("CheckTagSystem", true);
                db.Add("@course_id", SessionManager.Course.ID);
                db.AddIntReturn();

                db.Start();
                db.ExecNonQuery();
                result = db.ReturnValue();

                db.Command("CheckFinalized", true);
                db.Add("@course_id", SessionManager.Course.ID);
                db.AddIntReturn();

                db.ExecNonQuery();
                finalized = db.ReturnValue();

                if (result != 1)
                {
                    lblError.Text = "Grading System unbalanced. Could cause inaccurate reporting. Ensure total weights add up to 100%";
                    lblError.Visible = true;
                }
                else 
                if(finalized != 1)
                {
                    lblError.Text = "Roster has not been finalized yet";
                    lblError.Visible = true;
                }
                else
                {
                    lblError.Visible = false;
                    db.Command("CreateNewAssignment", true);
                    db.Add("@course_id", SessionManager.Course.ID);
                    db.Add("@assignment_name", txtAssgnName.Text);
                    db.Add("@tag_id", drpTypeList.SelectedValue);
                    db.Add("@instructor_id", SessionManager.Instructor.ID);

                    db.ExecNonQuery();
                    db.Stop();
                    Response.Redirect(Request.RawUrl);
                }
            }
        }


        protected void AddType(object sender, EventArgs e)
        {
            DataHandler db = new DataHandler();
            int weight = int.Parse(txtTagWeight.Text);

            using (db.Connect())
            {
                db.Command("INSERT INTO Tag (tag_type, tag_weight, course_id) VALUES (@tag_type, CONVERT(DECIMAL(16,2), @tag_weight/100.0), @course_id)", false);
                db.Add("@tag_type", txtTagName.Text);
                db.Add("@tag_weight", weight);
                db.Add("@course_id", SessionManager.Course.ID);

                db.Start();
                db.ExecNonQuery();
                db.Stop();
            }

            Response.Redirect(Request.RawUrl);
        }
    }
}