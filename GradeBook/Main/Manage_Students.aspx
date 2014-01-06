<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Manage_Students.aspx.cs" Inherits="GradeBook.Main.Manage_Students" %>

<asp:Content ID="Scripting" ContentPlaceHolderID="ScriptContent" runat="server">
<link rel="stylesheet" href="http://code.jquery.com/ui/1.9.2/themes/base/jquery-ui.css" />
<script type="text/javascript" src="http://code.jquery.com/jquery-1.8.3.js"></script>
<script type="text/javascript" src="http://code.jquery.com/ui/1.9.2/jquery-ui.js"></script>
<script type="text/javascript">
$().ready(function() {
    $("#dialog-confirm").dialog(
    { autoOpen: false,
        modal: true,
        bgiframe: true,
        width: 400,
        height: 300,
        buttons: {
            'Yes': function() {
                <%=this.Page.ClientScript.GetPostBackEventReference(new PostBackOptions(this.lnkFinalize))%>;
            },
            'No': function() {
                $(this).dialog('close');
            }
        }
    })
});
</script>
</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <h1>Manage Students - <asp:Label ID="lblCourseName" runat="server" Text="" /></h1>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <asp:Repeater ID="rptStudents" 
                  runat="server">
        <HeaderTemplate>
            <table class="gradebook_table">
                <tr>
                    <th>First</th>
                    <th>Last</th>
                    <th>Grade</th>
                </tr>
        </HeaderTemplate>

        <ItemTemplate>
            <tr>
                    <td><asp:HyperLink ID="lnkStudentFName" runat="server" Text='<%# Eval("f_name") %>' NavigateUrl='<%# Eval("student_id", "~/Main/Student.aspx?Id={0}") %>' /></td>
                    <td><asp:HyperLink ID="lnkStudentLName" runat="server" Text='<%# Eval("l_name") %>' NavigateUrl='<%# Eval("student_id", "~/Main/Student.aspx?Id={0}") %>' /></td>
                    <td><%# Eval("final_grade") %></td>
            </tr>       
        </ItemTemplate>

        <FooterTemplate>
            </table>            
        </FooterTemplate>
    </asp:Repeater>   

    <div class="dotted_section">
        <table class="dotted_table">
            <tr>
                <td><asp:Label ID="lblFirstName" runat="server" Text="First:" /></td>
                <td><asp:TextBox ID="txtFirstName" runat="server" />
                    <asp:RequiredFieldValidator ID="rqrdFrstName" runat="server"
                                            ControlToValidate="txtFirstName"
                                            Text="*"
                                            ValidationGroup="GroupAddStudent"
                                            EnableClientSideScript="false" /></td>
                <td></td>
            </tr>


            <tr>
                <td><asp:Label ID="lblLastName" runat="server" Text="Last:" /></td>
                <td><asp:TextBox ID="txtLastName" runat="server" />
                    <asp:RequiredFieldValidator ID="rqrdLstName" runat="server"
                                            ControlToValidate="txtLastName"
                                            Text="*"
                                            ValidationGroup="GroupAddStudent"
                                            EnableClientSideScript="false" /></td>
                <td></td>
            </tr>     

            <tr>
                <td><asp:LinkButton ID="lnkAdd" runat="server" Text="Add" ValidationGroup="GroupAddStudent" OnCommand="AddStudent" /></td>
                <td></td>
                <td><asp:LinkButton ID="lnkFinalize" runat="server" Text="Finalize Roster" OnClick="FinalizeRoster"  OnClientClick="javascript: $('#dialog-confirm').dialog('open'); return false;"  />
                    <asp:Label ID="lblFinalized" runat="server" CssClass="error" Text="Finalized" Visible="false" /></td>
            </tr>
        </table>    
    </div>

    <div id="dialog-confirm" style="display: none;" title="Confirm Finalize">
        <p><span class="ui-icon ui-icon-alert" style="float: left; margin: 0 7px 20px 0;"></span>Are you sure you want to finalize roster?</p>
    </div>

</asp:Content>
