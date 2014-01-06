<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Assignment.aspx.cs" Inherits="GradeBook.Main.Assignment" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <h1>Manage Assignment - <asp:Label ID="lblAssgnName" runat="server" Text=""/></h1>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="grade_area">
            <asp:GridView
            id="grdAssignmts"
            CssClass="gradebook_table"            
            DataKeyNames="assignment_id,student_id"
            DataSourceID="srcAssignments"            
            EmptyDataText="This assignment has not been given to any students yet. Your course likely has no students enrolled."
            AutoGenerateColumns="false"
            runat="server">
                <Columns>
                <asp:CommandField ShowEditButton="true" ValidationGroup="GradeGroup" />

                    <asp:BoundField
                        DataField="assignment_name"
                        HeaderText="Assignment"
                        ReadOnly="true" />
                    <asp:BoundField
                        DataField="f_name"
                        HeaderText="First"
                        ReadOnly="true" />
                    <asp:BoundField
                        DataField="l_name"
                        HeaderText="Last"
                        ReadOnly="true"/>

                    <asp:TemplateField HeaderText="Grade">
                        <EditItemTemplate>
                                <asp:TextBox ID="txtAssgnGrade" runat="server" Text='<%# Bind("assignment_grade") %>' />
                                <asp:RequiredFieldValidator ID="rqrdAssgnGrade"
                                                            runat="server"
                                                            ControlToValidate="txtAssgnGrade"
                                                            ErrorMessage="*"
                                                            ValidationGroup="GradeGroup" />
                                <asp:RegularExpressionValidator ID="rglAssgnGrade"
                                                                runat="server"
                                                                ControlToValidate="txtAssgnGrade"
                                                                ErrorMessage="Invalid value"
                                                                ValidationGroup="GradeGroup"
                                                                ValidationExpression="^[+-]?(?:\d+\.?\d*|\d*\.?\d+)[\r\n]*$" />
                       </EditItemTemplate>

                       <ItemTemplate>
                                <asp:Label ID="lblAssgnGrade" runat="server" Text='<%# Bind("assignment_grade") %>' />            
                       </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
        </asp:GridView>

        <asp:SqlDataSource
            id="srcAssignments"
            SelectCommandType="StoredProcedure"
            SelectCommand="ListAssignmentsByID"
            UpdateCommand="UPDATE Students_has_Assignments SET assignment_grade=@assignment_grade WHERE assignment_id=@assignment_id AND student_id=@student_id"
            ConnectionString="<%$ ConnectionStrings:ApplicationServices %>"
            runat="server">

            <SelectParameters>
                <asp:QueryStringParameter Name="assignment_id" QueryStringField="Id" />
            </SelectParameters>
        </asp:SqlDataSource>
    
    </div>
</asp:Content>
