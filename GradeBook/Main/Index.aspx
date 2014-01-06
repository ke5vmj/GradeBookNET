<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeBehind="Index.aspx.cs" Inherits="GradeBook._Default" %>
    

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <h1><asp:Label ID="lblInstructorName" runat="server" Text="" /></h1>
    <h3>Courses</h3>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:Repeater ID="rptCourses" 
                  runat="server">
        <HeaderTemplate>
            <table class="gradebook_table">
                <tr>
                    <th>Name</th>
                    <th># Students</th>
                    <th>Date Start</th>
                    <th>Date End</th>
                </tr>
        </HeaderTemplate>

        <ItemTemplate>
            <tr>
                    <td><asp:HyperLink ID="lnkCourse" runat="server" Text='<%# Eval("c_course_name") %>' NavigateUrl='<%# Eval("c_id", "~/Main/Course.aspx?Id={0}") %>' /></td>
                    <td><%# Eval("c_num_students") %></td>
                    <td><%# Eval("c_start_date") %></td>
                    <td><%# Eval("c_end_date") %></td>
            </tr>       
        </ItemTemplate>

        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>


    <div class="dotted_section">
        <table class="dotted_table">
            <tr>
                <td><b><asp:Label ID="lblCourse" runat="server" Text="Course Name:" /></b></td>
                <td><asp:TextBox ID="txtCourseEntry" runat="server" /></td>
                <td><asp:RequiredFieldValidator ID="rqrdCourseName" runat="server"
                                            ControlToValidate="txtCourseEntry"
                                            Text="*Required"
                                            ValidationGroup="CourseGroup"
                                            EnableClientSideScript="false" /></td>
            
            </tr>

            <tr>
                <td><asp:Label ID="lblStartDate" runat="server" Text="Start Date:" /></td>
                <td><asp:TextBox ID="txtStartDate" runat="server" /></td>
                <td><asp:RequiredFieldValidator ID="rqrdStartDate" runat="server"
                                            ControlToValidate="txtStartDate"
                                            Text="*Required"
                                            ValidationGroup="CourseGroup"
                                            EnableClientSideScript="false" />
                <asp:CompareValidator ID="cmprStartDate" runat="server"
                                      Text="*Start Date exceeds End Date"
                                      ControlToValidate="txtStartDate"
                                      ControlToCompare="txtEndDate"
                                      ValidationGroup="CourseGroup"
                                      Operator="LessThanEqual"
                                      Type="Date" />
                <asp:RegularExpressionValidator ID="rglrStartDate" runat="server"
                                                ControlToValidate="txtStartDate"
                                                Text="*Not a valid date"
                                                ValidationGroup="CourseGroup"
                                                ValidationExpression="^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)\d\d$" /></td>
                                                 
            </tr>

            <tr>
                <td><asp:Label ID="lblEndDate" runat="server" Text="End Date:" /></td>
                <td><asp:TextBox ID="txtEndDate" runat="server" /></td>
                <td><asp:RequiredFieldValidator ID="rqrdEndDate" runat="server"
                                            ControlToValidate="txtEndDate"
                                            Text="*Required"
                                            ValidationGroup="CourseGroup"
                                            EnableClientSideScript="false" />
                <asp:CompareValidator ID="cmprEndDate" runat="server"
                                      Text="*End date preceeds Start Date"
                                      ControlToValidate="txtEndDate"
                                      ControlToCompare="txtStartDate"
                                      ValidationGroup="CourseGroup"
                                      Type="Date"
                                      Operator="GreaterThanEqual" />
                <asp:RegularExpressionValidator ID="rglrEndDate" runat="server"
                                                ControlToValidate="txtStartDate"
                                                Text="*Not a valid date"
                                                ValidationGroup="CourseGroup"
                                                ValidationExpression="^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)\d\d$" /></td>                
            </tr>        
        </table>        
        
        </br>
        <asp:LinkButton ID="lnkAddCourse" runat="server" Text="Add Course" ValidationGroup="CourseGroup" OnCommand="AddCourse"/>
    
    
    </div>

</asp:Content>
