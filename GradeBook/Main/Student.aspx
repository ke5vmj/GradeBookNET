<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Student.aspx.cs" Inherits="GradeBook.Main.Student" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
    <h1><asp:Label ID="lblName" runat="server" Text="" /> - Grades</h1>
    <h3>Assignments</h3>

</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">
    <asp:GridView ID="grdStudentAssignments"
                  runat="server"
                  CssClass="gradebook_table"
                  DataSourceID="srcAssignments"
                  EmptyDataText="Student has no assignments assigned to them"
                  AutoGenerateColumns="false">
        <Columns>
            <asp:BoundField
                 DataField="assignment_name"
                 HeaderText="Title"
                 ReadOnly="true" />
            <asp:BoundField
                  DataField="tag_type"
                  HeaderText="Type"
                  ReadOnly="true" />
            <asp:BoundField
                  DataField="assignment_grade"
                  HeaderText="Grade"
                  ReadOnly="true" />        
        </Columns>                  
     </asp:GridView>


      <asp:SqlDataSource ID="srcAssignments"
                         SelectCommand="ListStudentAssignments"
                         SelectCommandType="StoredProcedure"
                         ConnectionString="<%$ ConnectionStrings:ApplicationServices %>"
                         runat="server">

            <SelectParameters>
                <asp:QueryStringParameter Name="student_id" QueryStringField="Id" />
            </SelectParameters>

        </asp:SqlDataSource>
     

</asp:Content>
