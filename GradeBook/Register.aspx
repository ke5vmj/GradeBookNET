<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="GradeBook.Register" %>

<asp:Content ID="MenuContent" ContentPlaceHolderID="SiteMapContent" runat="server">
</asp:Content>

<asp:Content ID="Heading" ContentPlaceHolderID="HeadContent" runat="server">
    <h2>Register</h2>
</asp:Content>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="login">
                    
            <div class="register_wizard">                              
                    <table>
                        <tr>
                            <th class="register_title">Register</th>
                            <th class="register_title"></th>
                        </tr>

                        <tr>
                            <td><asp:Label ID="lblFname" runat="server" Text="First Name:" /></td>
                            <td><asp:TextBox ID="FirstName" runat="server" /><asp:RequiredFieldValidator ID="rqrdFirstName" 
                                                                                                         runat="server" 
                                                                                                         ControlToValidate="FirstName" 
                                                                                                         ErrorMessage="First name is required"
                                                                                                         ToolTip="First name is required." 
                                                                                                         ValidationGroup="masterForm">*</asp:RequiredFieldValidator>                                                                                                         </td>                                                                                   
                        </tr>

                        <tr>  
                            <td><asp:Label ID="lblLName" runat="server" Text="Last Name:" /></td>                                     
                            <td><asp:TextBox ID="LastName" runat="server" /><asp:RequiredFieldValidator ID="rqrdLastName" 
                                                                                                         runat="server" 
                                                                                                         ControlToValidate="LastName" 
                                                                                                         ErrorMessage="Last name is required"
                                                                                                         ToolTip="Last name is required." 
                                                                                                         ValidationGroup="masterForm">*</asp:RequiredFieldValidator></td>                                        
                        </tr>

                        <tr>
                            <td><asp:Label ID="lblUsrName" runat="server" Text="User Name:"/></td>                                    
                            <td><asp:TextBox ID="UserName" runat="server" /><asp:RequiredFieldValidator ID="rqrdUserName" 
                                                                                                         runat="server" 
                                                                                                         ControlToValidate="UserName" 
                                                                                                         ErrorMessage="User name is required"
                                                                                                         ToolTip="User name is required." 
                                                                                                         ValidationGroup="masterForm">*</asp:RequiredFieldValidator></td>
                        </tr>  

                        <tr>
                            <td><asp:Label ID="lblPassword" runat="server" Text="Password:" /></td>
                            <td><asp:TextBox ID="Password" runat="server" TextMode="Password" /><asp:RequiredFieldValidator ID="rqrdPassword" 
                                                                                                         runat="server" 
                                                                                                         ControlToValidate="Password" 
                                                                                                         ErrorMessage="Password is required"
                                                                                                         ToolTip="Password is required." 
                                                                                                         ValidationGroup="masterForm">*</asp:RequiredFieldValidator></td>                                        
                        </tr>

                        <tr>
                            <td><asp:Button ID="btnComplete" CssClass="register_button" Text="Complete" runat="server" OnClick="CreateNewUser" ValidationGroup="masterForm" /></td>
                        </tr>
                    </table>

                    <asp:Label ID="lblComplete" runat="server" Text="Registration complete!" Visible="false" />
                </div>       
    </div>
</asp:Content>
