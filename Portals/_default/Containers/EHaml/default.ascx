<%@ Control AutoEventWireup="false" Explicit="True" Inherits="DotNetNuke.UI.Containers.Container" %>
<%@ Register TagPrefix="dnn" TagName="TITLE" Src="~/Admin/Containers/Title.ascx" %>

<div class="page-content">
    <h2 class="page-content-title">
        <dnn:TITLE runat="server" ID="dnnTITLE"  />
    </h2>
    <div id="ContentPane" runat="server"></div>
    <div class="clear"></div>
</div>
