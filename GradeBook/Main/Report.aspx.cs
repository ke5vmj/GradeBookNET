using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using System.Collections.Specialized;
using DocumentFormat.OpenXml.Packaging;
using GradeBook.Utils;

using DocumentFormat.OpenXml.Spreadsheet;
using DocumentFormat.OpenXml.Presentation;

namespace GradeBook.Main
{
    public partial class Report : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        protected void ExportGradeSheet(object sender, EventArgs e)
        {
            DataHandler db = new DataHandler();

            using (db.Connect())
            {
                db.Command("ListAllCourseAndGradesForInstructor", true);
                db.Add("@instructor_id", SessionManager.Instructor.ID);

                db.Start();
                SqlDataReader reader = db.Exec();

                SpreadSheetExport excelExport = new SpreadSheetExport();
                excelExport.CreateSpreadSheet();

                //These values will keep track of the utilized Assignments and Students
                string prevCourse = "";
                string prevAssignment = "";
                string prevStudent = "";

                //Will use these values to keep track of where I'm placing values
                string student_column = "A";        //This shouldn't change
                uint student_row_value = 2;

                string assign_column = "B";
                uint assgn_row_value = 1;           //This shouldn't change.
                //I will only increment student_row_value and assign_column when new fields are added
                //----------------------------------------------------------------


                OrderedDictionary trackedReferences = new OrderedDictionary();
                //My current strategy to solve the issue of keeping track which Student and Assignment is what and where to place
                //the associated grade is to keep track of said Student and Assignment in an associative array. As I come across each
                //Student or assignment I will store thier col and row values in the array. Once I come across said Student or Assignment
                //Again I will reference it and use that value to put them in their rightful place.
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        string currentCourse = reader["course_name"].ToString();
                        string currentStudent = reader["student_name"].ToString();
                        string currentAssignment = reader["assignment_name"].ToString();
                        string currentAssignmentGrade = reader["assignment_grade"].ToString();

                        //This section determines whether we have a new Course to add or not
                        if (!prevCourse.Equals(currentCourse) && !prevCourse.Equals(""))      //We found a new Course name and it's not the first sheet
                        {
                            excelExport.AddWorkSheet(currentCourse);
                            student_row_value = 2;
                            assign_column = "B";
                            //Reset these values back to thier defaults since we're going to be using a new sheet
                        }
                        else if (prevCourse.Equals(""))     //This means our first runthrough. We're going to need the name of this course now
                        {
                            prevCourse = currentCourse;
                            excelExport.AddWorkSheet(currentCourse);
                        }

                        //We've come across a different assignment but we've seen it before AND not a new student
                        //if (!prevAssignment.Equals(reader["assignment_name"].ToString()) && 
                        //    (trackedReferences.Contains(reader["assignment_name"].ToString()) && trackedReferences.Contains(reader["student_name"].ToString())))
                        if (trackedReferences.Contains(currentStudent) && trackedReferences.Contains(currentAssignment))
                        {
                            excelExport.InsertTextInCell(currentAssignmentGrade, trackedReferences[currentAssignment].ToString(), (uint)trackedReferences[currentStudent], currentCourse);

                        } //New assignment and haven't added it before and existing student
                        else if ((!prevAssignment.Equals(currentAssignment) &&
                                 !trackedReferences.Contains(currentAssignment)) && trackedReferences.Contains(currentStudent)) 
                        {
                            excelExport.InsertTextInCell(currentAssignment, assign_column, assgn_row_value, currentCourse);
                            trackedReferences.Add(currentAssignment, assign_column);

                            excelExport.InsertTextInCell(currentAssignmentGrade, assign_column, (uint)trackedReferences[currentStudent], currentCourse);
                        
                            assign_column = excelExport.IncrementColRef(assign_column);

                        } //New student found but not assignment
                        else if ((!prevStudent.Equals(currentStudent) && !trackedReferences.Contains(currentStudent)) && trackedReferences.Contains(currentAssignment)) 
                        {
                            excelExport.InsertTextInCell(currentStudent, student_column, student_row_value, currentCourse);
                            trackedReferences.Add(currentStudent, student_row_value);

                            excelExport.InsertTextInCell(currentAssignmentGrade, trackedReferences[currentAssignment].ToString(), student_row_value, currentCourse);
                            student_row_value++;
                        }
                        else if((!trackedReferences.Contains(currentStudent) && !trackedReferences.Contains(currentAssignment)) || (prevAssignment.Equals("") && prevStudent.Equals("")))  //This appears to be a new student and assignment. Add it and place in dictionary
                        {
                            excelExport.InsertTextInCell(currentStudent, student_column, student_row_value, currentCourse);
                            trackedReferences.Add(currentStudent, student_row_value);


                            excelExport.InsertTextInCell(currentAssignment, assign_column, assgn_row_value, currentCourse);
                            trackedReferences.Add(currentAssignment, assign_column);


                            excelExport.InsertTextInCell(currentAssignmentGrade, assign_column, student_row_value, currentCourse);

                            student_row_value++;
                            assign_column = excelExport.IncrementColRef(assign_column);
                        }

                        //This may look weird, but I'm doing this to capture the previous value in this variable because on next iration the real current values will be captured
                        prevCourse = currentCourse;
                        prevAssignment = currentAssignment;
                        prevStudent = currentStudent;
                    }
                }

                excelExport.ExcelToResponse();
                db.Stop();
            }


        }
    }
}