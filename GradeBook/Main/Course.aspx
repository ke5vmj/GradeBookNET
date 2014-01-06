<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Course.aspx.cs" Inherits="GradeBook.Main.Course" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <h1><asp:Label ID="lblCourseName" runat="server" Text="" /></h1>
</asp:Content>



<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="course_panel">
        <table id="course_listing">
            <tr>
                <td><asp:HyperLink ID="lnkStudents" runat="server" NavigateUrl="~/Main/Manage_Students.aspx?Id="><asp:Image ID="imgMngStudents" runat="server" ImageUrl="~/Images/manage_students.png"/></asp:HyperLink></td>
                <td><asp:HyperLink ID="lnkGrading" runat="server" NavigateUrl="~/Main/Grading.aspx?Id="><asp:Image ID="imgGrading" runat="server" ImageUrl="~/Images/grading_button.png" /></asp:HyperLink></td>           
            </tr>
            

            <tr>
                <td><asp:HyperLink ID="lnkCourse" runat="server" NavigateUrl="~/Main/Manage_Course.aspx?Id="><asp:Image ID="imgMngCourse" runat="server" ImageUrl="~/Images/manage_course.png" /></asp:HyperLink></td>
                <td><asp:HyperLink ID="lnkReport" runat="server" NavigateUrl="~/Main/Report.aspx?Id="><asp:Image ID="imgReport" runat="server" ImageUrl="~/Images/report_button.png" /></asp:HyperLink></td>            
            </tr>                    
        </table>    
    </div>

</asp:Content>
