using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GradeBook.Utils.Classes
{
    public class Courses
    {
        public Courses()
        {

        }

        public int ID { get; set; }
        public string Name { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

    }
}