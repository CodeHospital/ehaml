﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Portals;
using DotNetNuke.Entities.Users;
using DotNetNuke.Web.UI.WebControls;


namespace MyDnn_EHaml.MyDnn_EHaml_Inquiries
{
    public partial class ReplyToInquiry_Zadghan : PortalModuleBase
    {
        private Util util = new Util();
        private NameValueCollection _tedadVaGeymateVaghed = new NameValueCollection();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                dtpZamaneAmadegiBarayeShoorooeAmaliyat.MinDate = DateTime.Today.Date;
                Util util = new Util();
                string status = util.IsUserOk(UserId, 0);
                if (status != "OK")
                {
                    switch (status)
                    {
                        case "LoginNakarde":
                            pnlMessageForLoginNakarde.Visible = true;
                            lnkSubmit.Enabled = false;
                            break;
                        case "ApproveNashode":
                            pnlMessageForNotApproved.Visible = true;
                            lnkSubmit.Enabled = false;
                            break;
                        case "Bedehkare":
                            pnlMessageForBedehkarUser.Visible = true;
                            lnkSubmit.Enabled = false;
                            break;
                        case "SubscribeNistMamooli":
                            pnlMessageForNotSubscribeUser.Visible = true;
                            lnkSubmit.Enabled = false;
                            break;
                        case "SubscribeNistAvaziS":
                            pnlMessageForNotSubscribeAvaziSUser.Visible = true;
                            lnkSubmit.Enabled = false;
                            break;
                        case "SubscribeNistAvaziK":
                            pnlMessageForNotSubscribeAvaziKUser.Visible = true;
                            lnkSubmit.Enabled = false;
                            break;
                    }
                }

                if (Request.QueryString["IsPrint"] == "Yes" || Request.QueryString["popUp"] == "true")
                {
                    pnlMessageForBedehkarUser.Visible = false;
                    pnlMessageForLoginNakarde.Visible = false;
                    pnlMessageForNotApproved.Visible = false;
                    pnlMessageForNotSubscribeUser.Visible = false;
                    lnkSubmit.Visible = false;
                    logoForPrint.Visible = true;
                    pnlMessageForNotSubscribeAvaziSUser.Visible = false;
                    pnlMessageForNotSubscribeAvaziKUser.Visible = false;
                }

                string inquiryId = Request.QueryString["InqId"];

                FillPageControllsShenasname(inquiryId);
                FillPageControllsReply(inquiryId);
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            lnkSubmit.Click += LnkSubmitOnClick;
            lnkTasviye.Click += lnkSub_Click;
            btnErsaleLinkTaeid1.Click += btnErsaleLinkTaeid1_Click;
            lnkPrintKon.Click += lnkPrintKon_Click;
        }

        private void lnkPrintKon_Click(object sender, EventArgs e)
        {
            Response.Redirect("/default.aspx?tabid=1147&mid=3561&ctl=ReplyToInquiryShenasname&RepId=" +
                              hiddenFieldId.Value + "&IsPrint=Yes&popUp=true");
        }

        private void btnErsaleLinkTaeid1_Click(object sender, EventArgs e)
        {
            string appCode = util.getUserAppCode(util.GetUserEHamlUserIdByPortalId(UserId));
            string link = "http://" + PortalSettings.DefaultPortalAlias.ToLower().Replace("http://", "") +
                          "/default.aspx?tabid=" + 124 +
                          "&mid=439&ctl=Approve&AppCode=" + appCode;

            util.SendAppLinkToUserMail(UserId, link);
            pnlMessageForNotApproved.Visible = false;
            pnlMessageForNotApprovedAfterErsal.Visible = true;
        }

        private void lnkSub_Click(object sender, EventArgs e)
        {
            Session["FinalReturnTabId"] = "tabid=" + this.TabId;
            Response.Redirect("/default.aspx?tabid=" +
                              PortalController.GetPortalSettingAsInteger("SubscriptionTabId", PortalId, -1) + "&type=0");
        }

        private void LnkSubmitOnClick(object sender, EventArgs eventArgs)
        {
            string userStatus = util.IsUserOk(this.UserId, 0);
            if ((userStatus != "OK"))
            {
                util.MakeThisUserOk(this.UserId, userStatus, this.TabId.ToString(), 0);
            }
            else
            {
                using (
                    DataClassesDataContext context =
                        new DataClassesDataContext(Config.GetConnectionString()))
                {
                    string inquiryId = Request.QueryString["InqId"];

                    MyDnn_EHaml_ReplyToInquiry_Zadghan replyToInquiryZadghan = new MyDnn_EHaml_ReplyToInquiry_Zadghan();
                    replyToInquiryZadghan.KerayeyePishnahadi = txtKerayeyePishnahadi.Text;
                    context.MyDnn_EHaml_ReplyToInquiry_Zadghans.InsertOnSubmit(replyToInquiryZadghan);
                    string noVaTedadeVasileyeHamlResult = string.Empty;
                    //                    List<int> geymatha = new List<int>();
                    foreach (var repeaterItem in rptNoeVaTedadeVasileyeHaml.Items)
                    {
                        var objGeymateVahed = (((RepeaterItem) repeaterItem).FindControl("txtGeymateVahed")) as TextBox;
                        //                        var objGeymateKol = (((RepeaterItem)repeaterItem).FindControl("txtGeymateKol")) as TextBox;

                        string geymateVahedOnvan = (objGeymateVahed.ToolTip);
                        //                        string geymateKolOnvan = (objGeymateKol.ToolTip);
                        string noeVasileyeHaml = objGeymateVahed.ValidationGroup.Replace(":", "");
                        //                        geymatha.Add(Convert.ToInt32(objGeymateKol.Text));

                        //int tedad = util.GetTedadeVasileyeHamFromString(noeVasileyeHaml, "Zadghan");

                        //_tedadVaGeymateVaghed.Add(tedad.ToString(), objGeymateVahed.Text);

                        if (noeVasileyeHaml != null)
                        {
                            noVaTedadeVasileyeHamlResult += noeVasileyeHaml + "{" + geymateVahedOnvan + "(" +
                                                            objGeymateVahed.Text + ")" +
                                                            //                                                            "," + geymateKolOnvan + "(" + objGeymateKol.Text + ")" +
                                                            "} |";
                        }
                    }
                    replyToInquiryZadghan.NoVaTedadeVasileyeHaml = noVaTedadeVasileyeHamlResult;
                    context.SubmitChanges();

                    MyDnn_EHaml_ReplyToInquiry replyToInquiry = new MyDnn_EHaml_ReplyToInquiry();
                    replyToInquiry.ReplyToInquiryDetail_Id = replyToInquiryZadghan.Id;
                    replyToInquiry.ReplyToInquiryType = "Zadghan";
                    replyToInquiry.MyDnn_EHaml_User_Id = (from i in context.MyDnn_EHaml_Users
                        where i.PortalUserId == this.UserId
                        select i.Id).Single();
                    replyToInquiry.KoleModatZamaneHaml = txtModatRooz.Text;
                    replyToInquiry.ZamaneAmadegiBarayeShooroo =
                        dtpZamaneAmadegiBarayeShoorooeAmaliyat.SelectedDate;

                    if (chkIsGozareshAmaliyat.Checked)
                    {
                        replyToInquiry.GozareshAmaliyat = true;
                    }

                    //int geymatekol = geymatha.Sum();
                    replyToInquiry.GeymateKol = Convert.ToDecimal(util.getPool(txtGeymateKoleKol.Text));
                    replyToInquiry.CreateDate = DateTime.Now.Date;
                    context.MyDnn_EHaml_ReplyToInquiries.InsertOnSubmit(replyToInquiry);

                    context.SubmitChanges();

                    MyDnn_EHaml_Inquiry_ReplyToInquiry myDnnEHamlInquiryReplyToInquiry =
                        new MyDnn_EHaml_Inquiry_ReplyToInquiry();
                    myDnnEHamlInquiryReplyToInquiry.InquiryId = (from i in context.MyDnn_EHaml_Inquiries
                        where i.Id == int.Parse(Request.QueryString["InqId"])
                        select i.Id).Single();

                    replyToInquiry.Pishbini = cbolPishbini.SelectedItem.Value;

                    myDnnEHamlInquiryReplyToInquiry.ReplyToInquiryId = replyToInquiry.Id;
                    myDnnEHamlInquiryReplyToInquiry.Status = 2;
                    myDnnEHamlInquiryReplyToInquiry.CreateDate = DateTime.Now.Date;
                    context.MyDnn_EHaml_Inquiry_ReplyToInquiries.InsertOnSubmit(myDnnEHamlInquiryReplyToInquiry);
                    
                    context.SubmitChanges();

                    hiddenFieldId.Value = myDnnEHamlInquiryReplyToInquiry.Id.ToString();
                    shenasnameForm.Visible = false;
                    messageAfterSubmit.Visible = true;
                    messageAfterSubmit.InnerHtml = "فرم شما با موفقیت ثبت گردید.";
                    messageAfterSubmit.Attributes["class"] = "dnnFormMessage dnnFormSuccess";
                    lnkSubmit.Visible = false;
                    lnkPrintKon.Visible = true;

                    var content = util.ContentForEtelaresaniReplyToInquiry(context,
                        myDnnEHamlInquiryReplyToInquiry.Id.ToString());
                    util.EtelaresaniForReplyToInquiry(Convert.ToInt32(myDnnEHamlInquiryReplyToInquiry.Id), content);
                }
            }
        }


        private void FillPageControllsReply(string inquiryId)
        {
            lblPasokhDahandeValue.Text = this.UserInfo.DisplayName;

            using (
                DataClassesDataContext context = new DataClassesDataContext(Config.GetConnectionString()))
            {
                MyDnn_EHaml_Inquiry inquiry = (from i in context.MyDnn_EHaml_Inquiries
                    where i.Id == int.Parse(inquiryId)
                    select i).Single();

                MyDnn_EHaml_Inquiry_ZadghanT zadghanT = (from i in context.MyDnn_EHaml_Inquiry_ZadghanTs
                    where i.Id == inquiry.InquiryDetail_Id
                    select i).Single();

                List<NameVaTedadJft> listNameVaTedad = new List<NameVaTedadJft>();
                NameVaTedadJft nameVaTedadJft = new NameVaTedadJft();

                string loadType = zadghanT.NoVaTedadeVasileyeHaml;

                string[] nameVaTedadVatedadList = loadType.Split(',');
                foreach (string item in nameVaTedadVatedadList)
                {
                    if (!string.IsNullOrEmpty(item) && !string.IsNullOrWhiteSpace(item))
                    {
                        nameVaTedadJft = new NameVaTedadJft() {VasileyeHamlName = item};
                        listNameVaTedad.Add(nameVaTedadJft);
                    }
                }

                FillCbolPishbini();
                rptNoeVaTedadeVasileyeHaml.DataSource = listNameVaTedad;
                rptNoeVaTedadeVasileyeHaml.DataBind();
            }
        }

        private void FillCbolPishbini()
        {
            cbolPishbini.Items.Add(new DnnComboBoxItem("-- انتخاب نماييد --", "-1"));
            cbolPishbini.Items.Add(new DnnComboBoxItem("مطلوب", "مطلوب"));
            cbolPishbini.Items.Add(new DnnComboBoxItem("کند", "کند"));
            cbolPishbini.Items.Add(new DnnComboBoxItem("بسیار کند", "بسیار کند"));

            cbolPishbini.SelectedValue = "-1";
            cbolPishbini.Items[0].Enabled = false;
        }

        private void FillPageControllsShenasname(string inquiryId)
        {
            using (
                DataClassesDataContext context = new DataClassesDataContext(Config.GetConnectionString()))
            {
                //lblDarkhastKonandeValue.Text =UserController.GetUserById(this.PortalId, (int) (from i in context.MyDnn_EHaml_Inquiries join j in context.MyDnn_EHaml_Users on i.MyDnn_EHaml_User_Id equals j.Id where i.Id == int.Parse(inquiryId) select j.PortalUserId).Single()).DisplayName;
//                lblDarkhastKonandeValue.Text =
//                    UserController.GetUserById(this.PortalId,util.GetSahebUserByInquiryId(Convert.ToInt32(inquiryId))).DisplayName;

                MyDnn_EHaml_Inquiry inquiry = (from i in context.MyDnn_EHaml_Inquiries
                    where i.Id == int.Parse(inquiryId)
                    select i).Single();

                lblTarihkeEngezaValue.Text = inquiry.ExpireDate.Value.ToShortDateString();
                lblSherkatValue.Text = this.UserInfo.Profile.GetPropertyValue("Company");

                if (inquiry.IsReallyNeed != null && (bool) inquiry.IsReallyNeed)
                {
                    lblIsReallyNeedValue.Text = "صرفا برای اطلاع از قیمت نیست و نیاز به این خدمات دارم";
                }
                else
                {
                    lblIsReallyNeedValue.Text = "صرفآ برای اطلاع از قیمت استعلام می کنم";
                }

                lblZamaneEstelamValue.Text = inquiry.CreateDate.Value.ToShortDateString();
                if (inquiry.ModifieDate != null)
                {
                    lblAkharinZamaneTagireEstelamValue.Text =
                        inquiry.ModifieDate.Value.ToShortDateString();
                }
                else
                {
                    lblAkharinZamaneTagireEstelamValue.Text = "تغییری نداشته است";
                }

                if (inquiry.IsExtend != null && (bool) inquiry.IsExtend)
                {
                    lblIsExtendValue.Text = "بله";
                }
                else
                {
                    lblIsExtendValue.Text = "خیر";
                }

                if (inquiry.IsTender != null && (bool) inquiry.IsTender)
                {
                    lblIsTenderValue.Text = "بله";
                }
                else
                {
                    lblIsTenderValue.Text = "خیر";
                }

                lblStartingPointValue.Text = inquiry.StartingPoint;
                lblMagsadValue.Text = inquiry.Destination;

                lblActionDateValue.Text = inquiry.ActionDate.Value.ToShortDateString();
                lblLoadTypeValue.Text = inquiry.LoadType;

                MyDnn_EHaml_Inquiry_ZadghanT zadghant = (from i in context.MyDnn_EHaml_Inquiry_ZadghanTs
                    where i.Id == inquiry.InquiryDetail_Id
                    select i).Single();

                if (zadghant.WithInsurance != null && (bool) zadghant.WithInsurance)
                {
                    lblWithInsuranceValue.Text = "بله";
                    hplFileArzesheBar.NavigateUrl = (zadghant.FileArzesheBar);
                    hplFileArzesheBar.Text = "دریافت";
                }
                else
                {
                    lblWithInsuranceValue.Text = "خیر";
                    hplFileArzesheBar.Text =
                        "با توجه به در خواست نکردن بیمه توسط استعلام کننده ، لذا این فایل موجود نمی باشد.";
                }

                if (zadghant.EmptyingCharges != null && (bool) zadghant.EmptyingCharges)
                {
                    lblEmptyingChargesValue.Text = "بله";
                }
                else
                {
                    lblEmptyingChargesValue.Text = "خیر";
                }

                lblNoVaTedadeVasileyeHamlValue.Text = zadghant.NoVaTedadeVasileyeHaml;
            }
        }
    }

    internal class NameVaTedadJft
    {
        public string VasileyeHamlName { get; set; }
    }
}