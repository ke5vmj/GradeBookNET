<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Grading.aspx.cs" Inherits="GradeBook.Main.Grading" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <h1>Final Grades - <asp:Label ID="lblCourse" runat="server" Text="" /></h1>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
            <asp:GridView
            ID="grdGrades"
            CssClass="gradebook_table"
            DataSourceID="srcGrades"
            EmptyDataText="There appears to be no students enrolled in this course."
            AutoGenerateColumns="false"
            runat="server">
            <Columns>            

            <asp:BoundField
                 DataField="First"
                 HeaderText="First Name"
                 ReadOnly="true" />
            <asp:BoundField
                  DataField="Last"
                  HeaderText="Last Name"
                  ReadOnly="true" />


               <asp:TemplateField HeaderText="Final Grade">
                    <ItemTemplate>
                        <%# string.IsNullOrEmpty(Eval("Final").ToString()) ? "No final grade yet." : Eval("Final").ToString() %>
                    </ItemTemplate>
               </asp:TemplateField>
            </Columns>

            </asp:GridView>

            <asp:SqlDataSource
            id="srcGrades"
            SelectCommand="DisplayStudentFinalGrades"
            SelectCommandType="StoredProcedure"
            ConnectionString="<%$ ConnectionStrings:ApplicationServices %>"
            runat="server">

            <SelectParameters>
                <asp:QueryStringParameter Name="course_id" QueryStringField="Id" />
            </SelectParameters>

        </asp:SqlDataSource>

</asp:Content>
