﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReplyToInquiry_Zaban.ascx.cs" Inherits="MyDnn_EHaml.MyDnn_EHaml_Inquiries.ReplyToInquiry_Zaban" %>
<%@ Register TagPrefix="dnn" TagName="Label" Src="~/controls/labelcontrol.ascx" %>
<%@ Import Namespace="DotNetNuke.Entities.Portals" %>
<%@ Register TagPrefix="dnn" Namespace="DotNetNuke.Web.UI.WebControls" Assembly="DotNetNuke.Web" %>
<script>
    function MackeThisUserOK(userId, userStatus, userType, returnUrl) {
        if (userStatus === "SubscribeNist") {
            var modulePath = '<%= string.Format("/default.aspx?tabid=1142&type=") %>' + userType;
            dnnModal.show(modulePath, true, 550, 960, true, '');
        }
    }

    function IsThisUserOK() {
        var sf = $.ServicesFramework(<%= ModuleId %>);
        var value = "<%= this.UserId %>";
        $.ajax({
            type: "GET",
            url: sf.getServiceRoot('MyDnn_EHaml_Inquiries') + "Inquiries/IsThisUserOk",
            data: { "UserId": value, "UserCurrentType": 0 },
            beforeSend: sf.setModuleHeaders
        }).done(function(result) {
            if (result !== "OK") {
                MackeThisUserOK(value, result, 0, "default.aspx");
                return false;
            } else {
                return true;
            }
        }).fail(function(xhr, status, error) {
            alert(error);
        });
    };

    function voorood(parameters) {
        var modulePath = '/login?ReturnURL=<%= Page.Request.RawUrl %>&popUp=true';
        dnnModal.show(modulePath, true, 550, 960, true, '');
    }
</script>
<asp:Panel runat="server" ID="pnlMessageForNotSubscribeAvaziKUser" Visible="False">
    <div class="MessageForNotSubscribeUser">
        <p>
            کاربر گرامی برای ارسال فرم باید به عنوان خدمت گزار ثیت نام نمایید.در غیر این صورت قادر به ارسال فرم نخواهید بود.
        </p>
        <asp:LinkButton runat="server" ID="lnkExitSubscribeAvaziKUser" Text=""></asp:LinkButton>
    </div>
</asp:Panel>
<asp:Panel runat="server" ID="pnlMessageForNotSubscribeAvaziSUser" Visible="False">
    <div class="MessageForNotSubscribeUser">
        <p>
            کاربر گرامی برای ارسال فرم باید به عنوان صاحب بار ثبت نام نمایید.در غیر این صورت قادر به ارسال فرم نخواهید بود.
        </p>
        <asp:LinkButton runat="server" ID="lnkExitSubscribeAvaziSUser" Text=""></asp:LinkButton>
    </div>
</asp:Panel>
<asp:Panel runat="server" ID="pnlMessageForNotSubscribeUser" Visible="False">
    <div class="MessageForNotSubscribeUser">
        <p>
            کاربر گرامی برای ارسال فرم باید طرح عضویت را خریداری نمایید. در غیر این صورت قادر به ارسال فرم نخواهید بود.
        </p>
        <asp:LinkButton runat="server" ID="lnkTasviye" Text="خرید طرح عضویت"></asp:LinkButton>
    </div>
</asp:Panel>
<asp:Panel runat="server" ID="pnlMessageForBedehkarUser" Visible="False">
    <div class="MessageForBedehkarUser">
        <p>
            کاربر گرامی مهلت فعالیت شما در حالت بدهکاری پایان یافته ، برای ارسال فرم می بایست تسویه نمایید.
        </p>
        <a href="/default.aspx?tabid=<%= PortalController.GetPortalSettingAsInteger("TasviyeTabId", PortalId, -1) %>&type=1&FinalReturnTabId=<%= this.TabId %>">تسویه حساب</a>
    </div>
</asp:Panel>
<asp:Panel runat="server" ID="pnlMessageForLoginNakarde" Visible="False">
    <div class="MessageForLoginNakarde">
        <p>
            کاربر گرامی شما در سایت لوگین نکرده اید. لطفآ ابتدا در سایت لوگین کنید.
        </p>
        <a class="RegisterClass dnnPrimaryAction" href="/ثبت-نام">ثبت نام</a>
        <a class="LoginClass dnnSecondaryAction" onclick=" voorood(); ">ورود</a>
    </div>
</asp:Panel>
<asp:Panel runat="server" ID="pnlMessageForNotApprovedAfterErsal" Visible="False"><div class="MessageAfterErsal"><p>لینک فعال سازی حساب کاربری شما به ایمیل تان ارسال گردید. لطفآ ایمیل خود را بررسی نمایید.</p></div></asp:Panel><asp:Panel runat="server" ID="pnlMessageForNotApproved" Visible="False">
                                                                                                                                                                                                                                      <div class="MessageForNotApproved">
                                                                                                                                                                                                                                          <p>
                                                                                                                                                                                                                                              کاربر گرامی شما هنور عضویت خود را تایید ننمود ه اید. برای این کار لطفآ بر روی لینک ارسالی در ایمل خود کلیک نمایید.
                                                                                                                                                                                                                                          </p>
                                                                                                                                                                                                                                          <asp:LinkButton runat="server" ID="btnErsaleLinkTaeid23" Text="ارسال مجدد لینک تایید"/>
                                                                                                                                                                                                                                      </div>
                                                                                                                                                                                                                                  </asp:Panel>
<div class="ReplyToInquiry-Zaban-Shenasname shenasnameForm dnnForm">
    
    <div class="dnnFormItem pasokh-title">
        <dnn:Label Text="شناسنامه استعلام" ID="lblReplyToInquiryZabanShenasnameTitle" runat="server"></dnn:Label>
    </div>
    <div class="dnnFormItem" style="display: none">
        <dnn:Label HelpText=" " ID="lblDarkhastKonande" Text="استعلام دهنده:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblDarkhastKonandeValue" runat="server"></dnn:Label>
    </div>
    <div class="dnnFormItem"  style="display: none">
        <dnn:Label HelpText=" " ID="lblSherkat" Text="نام شرکت:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblSherkatValue" runat="server"></dnn:Label>
    </div>
    
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblIsReallyNeed" Text="ماهیت استعلام:" runat="server"></dnn:Label>
        <dnn:Label ID="lblIsReallyNeedValue" runat="server"></dnn:Label>
    </div>
    
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblZamaneEstelam" Text="زمان استعلام:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblZamaneEstelamValue" runat="server"></dnn:Label>
    </div>
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblTarihkeEngeza" Text="تاریخ انقضاء" runat="server"></dnn:Label>
        <dnn:Label  ID="lblTarihkeEngezaValue" runat="server"></dnn:Label>
    </div>
    
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblAkharinZamaneTagireEstelam" Text="آخرین زمان تغییر استعلام:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblAkharinZamaneTagireEstelamValue" runat="server"></dnn:Label>
    </div>
    
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblIsExtend" Text="تمدید شده:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblIsExtendValue" runat="server"></dnn:Label>
    </div>
    <div class="dnnFormItem" style="display: none">
        <dnn:Label HelpText=" " ID="lblIsTender" Text="استعلام به صورت مناقصه میباشد؟" runat="server"></dnn:Label>
        <dnn:Label  ID="lblIsTenderValue" runat="server"></dnn:Label>
    </div>
    
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblStartingPoint" Text="مبدا:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblStartingPointValue" runat="server"></dnn:Label>
    </div>
    
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblMagsad" Text="مقصد:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblMagsadValue" runat="server"></dnn:Label>
    </div>
    
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblActionDate" Text="تاریخ آغاز عملیات:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblActionDateValue" runat="server"></dnn:Label>
    </div>
    
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblNoeHamlSh" Text="نوع حمل:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblNoeHamlShValue" runat="server"></dnn:Label>
    </div>
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblHSCodeSh" Text="کد HS:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblHSCodeShValue" runat="server"></dnn:Label>
    </div>
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblBarAsaseSh" Text="استعلام بر اساس:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblBarAsaseShValue" runat="server"></dnn:Label>
    </div>
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblMegdareBarAsaseSh" Text="جزئیات:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblMegdareBarAsaseShValue" runat="server"></dnn:Label>
    </div>
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblIsHazineyeOdateContinerSh" Text="هزینه عودت کانتینر:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblIsHazineyeOdateContinerShValue" runat="server"></dnn:Label>
    </div>
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblIsKhahaneErsaleBeKharejiha" Text="خواهان ارسال استعلام برای خارجی ها:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblIsKhahaneErsaleBeKharejihaValue" runat="server"></dnn:Label>
    </div>

    
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblLoadType" Text="نوع محموله:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblLoadTypeValue" runat="server"></dnn:Label>
    </div>
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblWithInsurance" Text="با احتساب بیمه:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblWithInsuranceValue" runat="server"></dnn:Label>
    </div>
    
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblEmptyingCharges" Text="با احتساب هزینه تخلیه بار:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblEmptyingChargesValue" runat="server"></dnn:Label>
    </div>
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblNoVaTedadeVasileyeHaml" Text="نوع و تعداد وسیله حمل:" runat="server"></dnn:Label>
        <dnn:Label  ID="lblNoVaTedadeVasileyeHamlValue" runat="server"></dnn:Label>
    </div>
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " Text="موقعیت تحویل دادن محموله به پیمانکار حمل:" runat="server" ID="lblMogeiyateTahvilDadanShenasname"/>
        <asp:Label runat="server" ID="lblMogeiyateTahvilDadanShenasnameValue"/>
    </div>
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblFileListeAdlBandi" Text="فایل لیست عدلبندی:" runat="server"></dnn:Label>
        <asp:HyperLink CssClass="dnnSecondaryAction" runat="server"  ID="hplFileListeAdlBandi"></asp:HyperLink>
    </div>
    
    <div class="dnnFormItem" style="display: none">
        <dnn:Label HelpText=" " ID="lblFileArzesheBar" Text="فایل ارزش محموله:" runat="server"></dnn:Label>
        <asp:HyperLink runat="server"  ID="hplFileArzesheBar"></asp:HyperLink>
    </div>
    
    <div class="dnnFormItem">
        <ul class="dnnActions dnnClear">
            <li>
                <a id="lnkReply" class="dnnPrimaryAction">پاسخ به استعلام</a>
            </li>
        </ul>
    </div>
</div>

<div class="ReplyToInquiry-Zaban-Reply-Form dnnForm formPasokh">
    <div class="dnnFormItem pasokh-title">
        <dnn:Label ID="lblReplyToInquiryZabanTitle" runat="server" Text="پاسخ به استعلام"></dnn:Label>
    </div>
    <div class="dnnFormItem" style="display: none">
        <dnn:Label ID="lblPasokhDahande" Text="پاسخ دهنده:" runat="server"></dnn:Label>
        <dnn:Label ID="lblPasokhDahandeValue" runat="server"></dnn:Label>
    </div>
    
    <%--    <div class="dnnFormItem">--%>
    <%--        <dnn:Label HelpText=" " Text="کرایه پیشنهادی:" runat="server" ></dnn:Label>--%>
    <%--        <asp:TextBox ID="txtKerayeyePishnahadi" runat="server"></asp:TextBox>--%>
    <%--    </div>--%>
    
    <div class="dnnFormItem">
        <dnn:Label ID="lblBarAsase" HelpText=" " Text="استعلام بر اساس:" runat="server"></dnn:Label>
        <dnn:Label ID="lblBarAsaseValue" runat="server"></dnn:Label>
    </div>
    <asp:Repeater ID="rptBarAsaseTedadVaNo" runat="server">
        <ItemTemplate>
            <div class="dnnFormItem">
                <dnn:Label HelpText=" " ID="Label3" Text="جزئیات محموله:" runat="server" ></dnn:Label>
                <dnn:Label CssClass="priceItem_Tonaji_VazneKol_T1" ID="lblTedadVaNoeVasileyeHamlVaHadeAxareVazn" Text='<%# Eval("NameVatedadVaHadeaxareVazn").ToString() %>' 
                           runat="server" ></dnn:Label>
            </div>
            <div class="dnnFormItem">
                <dnn:Label HelpText=" " ID="lblGeymateVahed" Text="قیمت واحد:" runat="server" ></dnn:Label>
                <asp:TextBox CssClass="priceItem_Tonaji_Geymate_T1" ID="txtGeymateVahed" runat="server" ToolTip='<%# Eval("NameVatedadVaHadeaxareVazn").ToString() %>'></asp:TextBox>
            </div>
            <div class="dnnFormItem" style="display: none">
                <dnn:Label HelpText=" " ID="lblGeymateKol" Text="قیمت کل:" runat="server" ></dnn:Label>
                <asp:TextBox CssClass="priceItem" ID="txtGeymateKol" runat="server" ToolTip="قیمت کل:"></asp:TextBox>
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <asp:Repeater ID="rptBarAsaseTonaj" runat="server">
        <ItemTemplate>
            <div class="dnnFormItem">
                <dnn:Label HelpText=" " ID="Label3" Text="جزئیات محموله:" runat="server" ></dnn:Label>
                <dnn:Label CssClass="PriceItem_Tonaj_VazneKol_T1" ID="lblVazneKoleMahmooleVaVazneHarVahed" Text='<%# Eval("VazneKolVaVazneHarVahed").ToString() %>' runat="server" ></dnn:Label>
            </div>
            <div class="dnnFormItem">
                <dnn:Label HelpText=" " ID="lblGeymatBeEzayeHarTon" Text="قیمت به ازای هر تن :" runat="server" ></dnn:Label>
                <asp:TextBox CssClass="PriceItem_Tonaj_Geymat_T1" ID="txtGeymatBeEzayeHarTon" runat="server" ToolTip="قیمت به ازای هر تن :"></asp:TextBox>
            </div>
            <div class="dnnFormItem" style="display: none">
                <dnn:Label HelpText=" " ID="lblGeymateKol" Text="قیمت کل:" runat="server" ></dnn:Label>
                <asp:TextBox CssClass="priceItem" ID="txtGeymateKol" runat="server" ToolTip="قیمت کل:"></asp:TextBox>
            </div>
            
        </ItemTemplate>
    </asp:Repeater>
    
    <asp:panel runat="server" ID="pnlgeymatBarAsaseListeAdlBandi" class="dnnFormItem">
        <dnn:Label HelpText=" " ID="lblGeymateKolBarAsaseListeAdlBandi" Text="قیمت کل بر اساس لیست عدلبندی:" runat="server" ></dnn:Label>
        <asp:TextBox CssClass="PriceItem_Groopaj_Geymat" ID="txtGeymateKolBarAsaseListeAdlBandi" runat="server"></asp:TextBox>
    </asp:panel>
    
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " Text="موقعیت تحویل دادن محموله به پیمانکار حمل:" runat="server" ID="lblMogeiyateTahvilDadan" CssClass="dnnFormRequired"/>
        <dnn:DnnComboBox EmptyMessage="-- انتخاب نماييد --" runat="server" ID="cbolMogeiyateTahvilDadan"/>
    </div>
    
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " Text="با احتساب هزینه عودت کانتینر خالی:" runat="server" ID="lbleEhtesab" CssClass="dnnFormRequired"/>
        <asp:CheckBox runat="server" Text="با احتساب هزینه عودت کانتینر خالی:" ID="chkIsEhtesabeHazineyeOdateKantinerKhali"/>
    </div>
    
   
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " Text="کل مدت زمان حمل (روز):" runat="server" ></dnn:Label>
        <asp:TextBox ID="txtModatRooz1" runat="server" />
    </div>
    
    <div class="dnnFormItem">
        <dnn:Label HelpText=" " Text="زمان آمادگی برای شروع عملیات:" runat="server" ID="lblZamaneAmadegiBarayeShoorooeAmaliyat"/>
        <dnn:DnnDatePicker runat="server" ID="dtpZamaneAmadegiBarayeShoorooeAmaliyat"/>
    </div>
    <div class="dnnFormItem textAfterTheButton">
        <span>(هزینه های مرزی و غیر از حقوق و عوارض گمرکی مشمول محموله، در قیمت لحاظ می باشد)</span>
    </div>
    <div class="dnnFormItem fromtop20">
        <dnn:Label ID="Label2" HelpText=" " Text="گزارش عملیات:" runat="server" ></dnn:Label>
        <asp:CheckBox runat="server" Text="گزارش عملیات و ردیابی محموله به صورت روزانه و منظم ارائه می گردد:" ID="chkIsGozareshAmaliyat"/>
    </div>
    
    <div class="dnnFormItem ">
        <span class="full-line textAfterTheButton">با توجه به شرایط موجود( از قبیل شرایط مسیر،شرایط آب و هوایی،در دسترس بودن وسیله مورد نیاز و غیره ) امکان پذیری عملیات به این صورت پیش بینی می گردد:" </span>
    </div>
    <div class="dnnFormItem fromtop20">
        <dnn:label helptext=" " id="lblPishbini" text="پیش بینی:" runat="server"></dnn:label>
        <dnn:DnnComboBox EmptyMessage="-- انتخاب نماييد --" runat="server" id="cbolPishbini" cssclass="dnnFixedSizeComboBox" />
    </div>
    
    <div class="dnnFormItem">
        <dnn:Label ID="Label1"  HelpText=" " Text="قیمت کل:" runat="server" ></dnn:Label>
        <asp:TextBox CssClass="geymateKol" ID="txtGeymateKol2" runat="server" Enabled="False"></asp:TextBox>
        <asp:RequiredFieldValidator ControlToValidate="txtGeymateKol2" runat="server" ValidationGroup="FormValidation" 
                                    ErrorMessage="محاسبه قیمت کل الزامی است.لطفآ برروی دکمه محاسبه قیمت کلیک نمایید."></asp:RequiredFieldValidator>
        <a class="dnnSecondaryAction" onclick=" CalcultePrice(); " >محاسبه قیمت</a>
    </div>
    
    <div class="dnnFormItem">
        <ul class="dnnActions dnnClear">
            <li>
                <asp:LinkButton  ID="lnkSubmit" ValidationGroup="FormValidation" runat="server" CssClass="dnnPrimaryAction" Text="ارسال:" />
            </li>
        </ul>
    </div>
</div>

<div class="messageAfterSubmit dnnFormMessage" visible="False" id="messageAfterSubmit" runat="server"></div>
<div class="">
    <asp:LinkButton Text="چاپ" Visible="False" ID="lnkPrintKon" runat="server" CssClass="dnnPrimaryAction" /></div>
<asp:HiddenField runat="server" ID="hiddenFieldId" />

<div id="logoForPrint" class="logoForPrint" runat="server" visible="False">
    <img src="/Portals/0/Logo.png"/>
</div>

<script>

    $(document).ready(function() {
        $("#lnkReply").click(function() {
            $(".formPasokh").fadeIn(200);
        });

        if ($(".logoForPrint").length != 0) {
            $("#lnkReply").hide();
            window.print();
        }

    });

    function MackeThisUserOK(userId, userStatus, userType, returnUrl) {
        if (userStatus === "SubscribeNist") {
            var modulePath = '<%= string.Format("/default.aspx?tabid=1142&type=") %>' + userType;
            dnnModal.show(modulePath, true, 550, 960, true, '');
        }
    }

    function IsThisUserOK() {
        var sf = $.ServicesFramework(<%= ModuleId %>);
        var value = "<%= this.UserId %>";
        $.ajax({
            type: "GET",
            url: sf.getServiceRoot('MyDnn_EHaml_Inquiries') + "Inquiries/IsThisUserOk",
            data: { "UserId": value, "UserCurrentType": 0 },
            beforeSend: sf.setModuleHeaders
        }).done(function(result) {
            if (result !== "OK") {
                MackeThisUserOK(value, result, 0, "default.aspx");
                return false;
            } else {
                return true;
            }
        }).fail(function(xhr, status, error) {
            alert(error);
        });
    }

    function CalcultePrice() {
        var val = "";
        if ($(".PriceItem_Tonaj_VazneKol_T1").length > 0)
            val = mohasebegheymatForZABAN1();
        if ($(".PriceItem_Groopaj_Geymat").length > 0)
            val = mohasebegheymatForZABAN2();
        if ($(".priceItem_Tonaji_VazneKol_T1").length > 0)
            val = mohasebegheymatForZABAN3();


        $(".geymateKol").val(val);
    };;

    function voorood(parameters) {
        var modulePath = '/login?ReturnURL=<%= Page.Request.RawUrl %>&popUp=true';
        dnnModal.show(modulePath, true, 550, 960, true, '');
    }
</script>