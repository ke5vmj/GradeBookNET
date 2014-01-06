<%@ Page Title="Log In" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeBehind="Login.aspx.cs" Inherits="GradeBook.Login" %>

<asp:Content ID="MenuContent" ContentPlaceHolderID="SiteMapContent" runat="server">
</asp:Content>

<asp:Content ID="Heading" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

        <div id="login">
            <asp:Login
                id="LoginBox"
                OnAuthenticate="LoginBox_Authenticate"
                DestinationPageUrl="~/Main/Index.aspx"
                InstructionText="Please login to manage courses."
                TitleText="Instructor Login"
                TextLayout="TextOnTop"
                LoginButtonText="Login"
                DisplayRememberMe="false"
                CssClass="login_wizard"
                TitleTextStyle-CssClass="login_title"
                InstructionTextStyle-CssClass="login_instructions"
                CreateUserText="Create"
                CreateUserUrl="Register.aspx"
                LoginButtonStyle-CssClass="login_button"
                runat="server" />
        </div>   

</asp:Content>