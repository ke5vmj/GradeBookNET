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
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblName.Text = "";

            if (System.Web.HttpContext.Current.User.Identity.IsAuthenticated && !SessionManager.CheckNull())
            {
                SiteMap.SiteMapResolve += new SiteMapResolveEventHandler(this.FillPaths);
                lblName.Text = SessionManager.Instructor.UserName;
            }
            else
            {
                lblName.Text = "";
            }
        }

        /// <summary>
        /// Preserve the QueryString of past Pages
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <returns></returns>
        private SiteMapNode FillPaths(Object sender, SiteMapResolveEventArgs e)
        {
            SiteMapNode currentNode = SiteMap.CurrentNode.Clone(true);
            SiteMapNode temptNode = currentNode;

            // Obtain the recent IDs.
            int ID = GetPreviousID();

            // The current node, and its parents, can be modified to include
            // dynamic querystring information relevant to the currently
            // executing request.
            if (ID != 0)
            {
                temptNode.Url = temptNode.Url + "?Id=" + ID.ToString();
            }

            if (((temptNode = temptNode.ParentNode) != null) && ( ID != 0 ))
            {
                temptNode.Url = temptNode.Url + "?Id=" + ID.ToString();
            }

            return currentNode;
        }

        /// <summary>
        /// Gets previously used URL querystring of Id
        /// </summary>
        /// <returns></returns>
        private int GetPreviousID()
        {
            if (HttpContext.Current.Request != null)
                return Convert.ToInt32(HttpUtility.ParseQueryString(HttpContext.Current.Request.UrlReferrer.Query)["Id"]);
            else
            {
                return 0;
            }
        }
    }
    
}
