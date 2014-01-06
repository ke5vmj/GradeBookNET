<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Manage_Course.aspx.cs" Inherits="GradeBook.Main.Manage_Course" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <h1>Manage Course - <asp:Label ID="lblCourseName" runat="server" Text="" /></h1>
</asp:Content>


<asp:Content ID="CourseArea" ContentPlaceHolderID="MainContent" runat="server">    
    <div class="grade_area">
        <asp:Repeater ID="rptAssignments" 
                  runat="server">
        <HeaderTemplate>
            <table class="gradebook_table">
                <tr>
                    <th>Name</th>
                    <th>Type</th>
                    <th>Average</th>
                </tr>
        </HeaderTemplate>

        <ItemTemplate>
            <tr>
                    <td><asp:HyperLink ID="lnkStudentFName" runat="server" Text='<%# Eval("assignment_name") %>' NavigateUrl='<%# Eval("assignment_id", "~/Main/Assignment.aspx?Id={0}") %>' /></td>
                    <td><asp:HyperLink ID="lnkStudentLName" runat="server" Text='<%# Eval("tag_type") %>' NavigateUrl='<%# Eval("assignment_id", "~/Main/Assignment.aspx?Id={0}") %>' /></td>
                    <td><asp:Label ID="lblAverage" runat="server" Text='<%# Eval("average") %>' /></td>
            </tr>       
        </ItemTemplate>

        <FooterTemplate>
            </table>
        </FooterTemplate>
      </asp:Repeater>

      <table>
            <tr>
                <td><asp:TextBox ID="txtAssgnName" runat="server" /></td>
                <td><asp:DropDownList ID="drpTypeList" runat="server" DataSourceID="srcTypeList" DataTextField="tag_type" DataValueField="tag_id" /></td>
                <td><asp:LinkButton ID="lnkNewAssgn" runat="server" ValidationGroup="NewAssignment" OnClick="AddAssignment" Text="New Assignment" /></td>
                <td><asp:RequiredFieldValidator ID="rqrdAssgnName"
                                                runat="server"
                                                ErrorMessage="*"
                                                ControlToValidate="txtAssgnName"
                                                ValidationGroup="NewAssignment" />
                    <asp:RegularExpressionValidator ID="rqlAssgnName"
                                                    runat="server"
                                                    ControlToValidate="txtAssgnName"
                                                    ValidationGroup="NewAssignment"
                                                    ErrorMessage="Name too long."
                                                    ValidationExpression=".{1,30}" /></td>
            </tr>
      </table>
      <asp:Label CssClass="error" ID="lblError" runat="server" Text="Grading System unbalanced. Could cause inaccurate reporting. Ensure total weights add up to 100%" />
    </div>

    <div class="grade_area">
        <asp:GridView
            id="grdTypes"
            CssClass="gradebook_table"
            DataKeyNames="tag_id"
            DataSourceID="srcTypes"
            EmptyDataText="No grade types created yet. Please establish a grading system."
            AutoGenerateColumns="false"
            AutoGenerateEditButton="true"            
            runat="server">
                <Columns>
                    <asp:TemplateField HeaderText="Type">
                        <EditItemTemplate>
                                <asp:TextBox ID="txtTagType" runat="server" Text='<%# Bind("tag_type") %>' />
                                <asp:RequiredFieldValidator ID="rqrdTagType"
                                                            runat="server"
                                                            ControlToValidate="txtTagType"
                                                            ErrorMessage="*" />
                                <asp:RegularExpressionValidator ID="rglValidateTagType"
                                                                runat="server"
                                                                ControlToValidate="txtTagType"
                                                                ValidationGroup="TagGroup"
                                                                ErrorMessage="Unacceptable tag name"
                                                                ValidationExpression=".{1,30}" />
                       </EditItemTemplate>

                       <ItemTemplate>
                                <asp:Label ID="lblTagType" runat="server" Text='<%# Bind("tag_type") %>' />                      
                       </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="%">
                        <EditItemTemplate>
                                <asp:TextBox ID="txtTagWeight" runat="server" Text='<%# Bind("tag_weight") %>' />
                                <asp:RequiredFieldValidator ID="rqrdTagWeight"
                                                            runat="server"
                                                            ControlToValidate="txtTagWeight"
                                                            ErrorMessage="*"
                                                            ValidationGroup="TagGroup" />
                                <asp:RegularExpressionValidator ID="rglValidationWeight"
                                                                runat="server"
                                                                ControlToValidate="txtTagWeight"
                                                                ErrorMessage="Invalid value"
                                                                ValidationGroup="TagGroup"                       
                                                                ValidationExpression="^[+-]?(?:\d+\.?\d*|\d*\.?\d+)[\r\n]*$" />
                       </EditItemTemplate>

                       <ItemTemplate>
                                <asp:Label ID="lblTagWeight" runat="server" Text='<%# Bind("tag_weight") %>' />            
                       </ItemTemplate>
                    </asp:TemplateField>

                    <asp:CommandField ValidationGroup="TagGroup" />
                </Columns>
        </asp:GridView>



        <table>
            <tr>
                <td>Type Name:</td>
                <td><asp:TextBox ID="txtTagName" runat="server" />
                    <asp:RequiredFieldValidator ID="rqrdTagName" runat="server"
                                            ControlToValidate="txtTagName"
                                            Text="*"
                                            ValidationGroup="TypeGroup"
                                            EnableClientSideScript="false" /></td>
                <td>Type Weight (%):</td>
                <td><asp:TextBox ID="txtTagWeight" runat="server" />
                    <asp:RequiredFieldValidator ID="rqrdTagWeight" runat="server"
                                            ControlToValidate="txtTagWeight"
                                            Text="*"
                                            ValidationGroup="TypeGroup"
                                            EnableClientSideScript="false" />
                    <asp:RegularExpressionValidator ID="rglrTagWeight" runat="server"
                                            ControlToValidate="txtTagWeight"
                                            Text="Not a number"
                                            EnableClientSideScript="false"
                                            ValidationExpression="\d+"
                                            ValidationGroup="TypeGroup" /></td>
                <td><asp:LinkButton ID="btnNewTag" Text="Add" runat="server" ValidationGroup="TypeGroup" OnClick="AddType" /></td>
            </tr>       
        </table>

        <asp:SqlDataSource
            id="srcTypes"
            SelectCommand="SELECT tag_id, tag_type, tag_weight*100 AS tag_weight FROM Tag WHERE course_id=@CourseID"
            UpdateCommand="UPDATE Tag SET tag_type=@tag_type, tag_weight = CONVERT(DECIMAL(16,2), @tag_weight/100.0) WHERE tag_id=@tag_id"
            ConnectionString="<%$ ConnectionStrings:ApplicationServices %>"
            runat="server">

            <SelectParameters>
                <asp:QueryStringParameter Name="CourseID" QueryStringField="Id" />
            </SelectParameters>

        </asp:SqlDataSource>



        <asp:SqlDataSource
            id="srcTypeList"           
            SelectCommand="SELECT tag_id, tag_type FROM Tag WHERE course_id=@CourseID"
            ConnectionString="<%$ ConnectionStrings:ApplicationServices %>"
            runat="server">

            <SelectParameters>
                <asp:QueryStringParameter Name="CourseID" QueryStringField="Id" />
            </SelectParameters>

        </asp:SqlDataSource>
            
    </div>
</asp:Content>
