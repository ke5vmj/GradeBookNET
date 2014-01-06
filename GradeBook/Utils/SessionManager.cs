using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using GradeBook.Utils.Classes;

namespace GradeBook.Utils
{
    public static class SessionManager
    {
        /// <summary>
        /// Returns Session value contained in string 'key'
        /// </summary>
        /// <typeparam name="T">Generic parameter</typeparam>
        /// <param name="key">The Session key name</param>
        /// <returns>Session value</returns>
        private static T GetFromSession<T>(string key)
        {
            object obj = HttpContext.Current.Session[key];

            if (obj == null)
            {
                return default(T);
            }

            return (T)obj;
        }

        /// <summary>
        /// Sets Session value for string 'key'
        /// </summary>
        /// <typeparam name="T">Generic parameter</typeparam>
        /// <param name="key">The Session key name</param>
        /// <param name="value">Session value</param>
        private static void SetInSession<T>(string key, T value)
        {
            if (value == null)
            {
                HttpContext.Current.Session.Remove(key);
            }
            else
            {
                HttpContext.Current.Session[key] = value;

            }
        }

        /// <summary>
        /// Get value from Application
        /// </summary>
        /// <typeparam name="T">Parameter to cast</typeparam>
        /// <param name="key">Name of the parameter</param>
        /// <returns></returns>
        private static T GetFromApplication<T>(string key)
        {
            return (T)HttpContext.Current.Application[key];
        }

        /// <summary>
        /// Sets a value in the Application
        /// </summary>
        /// <typeparam name="T">Type of parameter</typeparam>
        /// <param name="key">Name of the parameter</param>
        /// <param name="value">Value of the parameter</param>
        private static void SetInApplication<T>(string key, T value)
        {
            if (value == null)
            {
                HttpContext.Current.Application.Remove(key);
            }
            else
            {
                HttpContext.Current.Application[key] = value;
            }
        }

        /// <summary>
        /// Tests for deleted session by seeing if Application is null
        /// </summary>
        public static bool CheckNull()
        {
            return (Instructor == null) ? true : false;
        }

        public static Instructor Instructor          
        {
            get { return GetFromSession<Instructor>("Instructor"); }
            set { SetInSession<Instructor>("Instructor", value); }
        }

        public static Courses Course
        {
            get { return GetFromSession<Courses>("Course"); }
            set { SetInSession<Courses>("Course", value); }
        }

        public static Student Student
        {
            get { return GetFromSession<Student>("Course"); }
            set { SetInSession<Student>("Course", value); }
        }
    }
}