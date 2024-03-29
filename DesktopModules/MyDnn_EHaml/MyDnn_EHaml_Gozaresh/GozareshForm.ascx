﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="GozareshForm.ascx.cs" Inherits="MyDnn_EHaml.MyDnn_EHaml_Gozaresh.GozareshForm" %>
<%@ Register TagPrefix="dnn" TagName="Label" Src="~/controls/labelcontrol.ascx" %>
<%@ Import Namespace="DotNetNuke.Entities.Content.Common" %>
<%@ Import Namespace="MyDnn_EHaml" %>
<%@ Register TagPrefix="dnn" Assembly="DotNetNuke" Namespace="DotNetNuke.UI.WebControls" %>
<%@ Register TagPrefix="dnn" Assembly="DotNetNuke.Web" Namespace="DotNetNuke.Web.UI.WebControls" %>
<%@ Register TagPrefix="dnn" Namespace="DotNetNuke.Web.Client.ClientResourceManagement" Assembly="DotNetNuke.Web.Client" %>

<div class="dnnForm">
    <div class="dnnFormItem">
        <dnn:Label Text="تاریخ:" HelpText=" " runat="server" ID="lblDate"/>
        <dnn:DnnDatePicker runat="server" ID="dtpDate"/>
    </div>
    <div class="dnnFormItem">
        <dnn:Label Text="متن گزارش:" HelpText=" " runat="server" ID="lblGozareshValue"/>
        <asp:TextBox runat="server" TextMode="MultiLine" ID="txtGozareshValue"></asp:TextBox>
    </div>
    
    <div class="dnnFormItem">
        <ul class="dnnActions dnnClear">
            <li>
                <asp:LinkButton Text="ارسال گزارش"  ID="lnkSubmit" ValidationGroup="FormValidation" runat="server" CssClass="dnnPrimaryAction" resourcekey="lnkSubmit" />
            </li>
        </ul>
    </div>

</div>