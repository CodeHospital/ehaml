﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Portals;
using DotNetNuke.Web.UI.WebControls;
using Telerik.Web.UI;

namespace MyDnn_EHaml.MyDnn_EHaml_Inquiries
{
    public partial class Inquiry_Ts : PortalModuleBase
    {
        private void lnkSub_Click(object sender, EventArgs e)
        {
            Session["FinalReturnTabId"] = "tabid=" + this.TabId;
            Response.Redirect("/default.aspx?tabid=" +
                              PortalController.GetPortalSettingAsInteger("SubscriptionTabId", PortalId, -1) + "&type=1");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            dtpActionDate.MinDate = DateTime.Today.Date;
            dtpExpiredate.MinDate = DateTime.Today.Date;
            if (!Page.IsPostBack)
            {
                Util util = new Util();
                string status = util.IsUserOk(UserId, 1);
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
                FillPageControl();
            }
        }

        private void FillCbolStartingPointOstan()
        {
            DotNetNuke.Common.Lists.ListController lc = new DotNetNuke.Common.Lists.ListController();
            var leCountries = lc.GetListEntryInfoItems("Country", "", base.PortalSettings.PortalId).ToList();

            using (
                DataClassesDataContext context = new DataClassesDataContext(Config.GetConnectionString()))
            {
                cbolStartingPointOstan.DataValueField = "Value";
                cbolStartingPointOstan.DataTextField = "Text";
                var ostanList = (from i in leCountries
                    select new {Text = i.Text, Value = i.Text}).ToList();
                ostanList.RemoveAt(0);
                ostanList.RemoveAt(ostanList.Count - 1);

                
                foreach (var item in ostanList.Distinct())
                {
                    cbolStartingPointOstan.Items.Add(new RadComboBoxItem(item.Text, item.Value));
                }
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            lnkSubmit.Click += lnkSubmit_Click;
            lnkTasviye.Click += lnkSub_Click;
            lnkTasviyeS.Click += lnkSub_Click;
            btnErsaleLinkTaeid11.Click += btnErsaleLinkTaeid1_Click;
            lnkPrintKon.Click += lnkPrintKon_Click;
        }

        private void lnkPrintKon_Click(object sender, EventArgs e)
        {
            Response.Redirect("/default.aspx?tabid=" + this.TabId + "&mid=" + this.ModuleId +
                              "&ctl=ReplyToInquiry_Ts&InqId=" + hiddenFieldId.Value + "&popUp=true&IsPrint=Yes");
        }

        private void cbolStartingPointOstan_SelectedIndexChanged(object sender,
            RadComboBoxSelectedIndexChangedEventArgs e)
        {
            string country = cbolStartingPointOstan.SelectedItem.Value;


            using (
                DataClassesDataContext context = new DataClassesDataContext(Config.GetConnectionString()))
            {
                var countryValue = (from j in context.Lists
                    where j.ListName == "Country"
                          && j.Text == country
                    select j.EntryID).Single();

                var list = (from i in context.Lists
                    where i.ListName == "City" && i.ParentID == countryValue
                    select new {Text = i.Text, Value = i.Text}).ToList();

                cbolStartingPointShahr.DataTextField = "Text";
                cbolStartingPointShahr.DataValueField = "Value";
                cbolStartingPointShahr.DataSource = list;
                cbolStartingPointShahr.DataBind();
            }
        }

        private void btnErsaleLinkTaeid1_Click(object sender, EventArgs e)
        {
            Util util = new Util();
            string appCode = util.getUserAppCode(util.GetUserEHamlUserIdByPortalId(UserId));
            string link = "http://" + PortalSettings.DefaultPortalAlias.ToLower().Replace("http://", "") +
                          "/default.aspx?tabid=" + 124 +
                          "&mid=439&ctl=Approve&AppCode=" + appCode;

            util.SendAppLinkToUserMail(UserId, link);
            pnlMessageForNotApproved.Visible = false;
            pnlMessageForNotApprovedAfterErsal.Visible = true;
        }

        private string UploadLoadImage(FileUpload uploadedFile)
        {
            string guid = Guid.NewGuid().ToString();
            string filePath = PortalSettings.HomeDirectoryMapPath + @"/EHaml/Uploads/";
            //string now = DateTime.Now.ToShortDateString().Replace('\\', '_');
            string fileName = "Ts_LoadImage_UId(" + this.UserId + ")_" + guid.Substring(0, 8) +
                              "" + uploadedFile.FileName.Substring(uploadedFile.FileName.LastIndexOf("."));

            if (!File.Exists(filePath + fileName))
            {
                uploadedFile.SaveAs(filePath + fileName);
            }

            string filePath2 = PortalSettings.HomeDirectory + @"/EHaml/Uploads/";
            //string now = DateTime.Now.ToShortDateString().Replace('\\', '_');
            string fileName2 = "Ts_LoadImage_UId(" + this.UserId + ")_" + guid.Substring(0, 8) + "" +
                               uploadedFile.FileName.Substring(uploadedFile.FileName.LastIndexOf("."));

            return filePath2 + fileName2;
        }

        private void lnkSubmit_Click(object sender, EventArgs e)
        {
            Util util = new Util();
            string message = util.IsValidateDates(dtpActionDate: dtpActionDate, dtpExpiredate: dtpExpiredate);
            bool isReturn = message != "OK";

            message += "<span>لطفآ فرم را دوباره و با دقت بیشتری تکمیل نمایید.</span>";
            message = message.Replace("OK", "");
            errorMessages.InnerHtml = message;

            if (isReturn)
            {
                errorMessages.Visible = true;
                return;
            }
            else
            {
                errorMessages.Visible = false;
            }
            string userStatus = util.IsUserOk(this.UserId, 1);
            if ((userStatus != "OK"))
            {
                util.MakeThisUserOk(this.UserId, userStatus, this.TabId.ToString(), 1);
            }
            else
            {
                using (
                    DataClassesDataContext context =
                        new DataClassesDataContext(Config.GetConnectionString()))
                {
                    MyDnn_EHaml_Inquiry_T inquiryT = new MyDnn_EHaml_Inquiry_T();

                    inquiryT.NoeAmaliyat = cbolNoeAmaliyat.SelectedItem.Value;
                    if (fupFormeListeAdlBandiFull.HasFile)
                    {
                        inquiryT.FileListAdlBandi = UploadFormFileAdlBandi(fupFormeListeAdlBandiFull);
                    }
                    if (fupLoadImage.HasFile)
                    {
                        inquiryT.LoadImage = UploadLoadImage(fupLoadImage);
                    }

                    inquiryT.MakaneTakhliye = cbolMakaneAmaliyat.SelectedItem.Value;

                    context.MyDnn_EHaml_Inquiry_Ts.InsertOnSubmit(inquiryT);
                    context.SubmitChanges();

                    MyDnn_EHaml_Inquiry inquiry = new MyDnn_EHaml_Inquiry()
                    {
                        CreateDate = DateTime.Now,
                        ActionDate = dtpActionDate.SelectedDate,
                        ExpireDate = dtpExpiredate.SelectedDate,
                        StartingPoint =
                            "(" + cbolStartingPointOstan.SelectedItem.Value + " : " + cbolStartingPointShahr.Text + ")",
                        //Destination = "انگلیس:پاریس",
                        IsReallyNeed = bool.Parse(cbolIsReallyNeed.SelectedItem.Value),
                        InquiryType = "Ts"
                    };


                    inquiry.MyDnn_EHaml_User_Id = (context.MyDnn_EHaml_Users.Where(i => i.PortalUserId == this.UserId)
                        .Select(i => i.Id)).Single();

                    inquiry.InquiryDetail_Id = inquiryT.Id;
                    context.MyDnn_EHaml_Inquiries.InsertOnSubmit(inquiry);
                    context.SubmitChanges();

                    hiddenFieldId.Value = inquiry.Id.ToString();
                    messageAfterSubmit.Visible = true;
                    messageAfterSubmit.InnerHtml = "استعلام شما با موفقیت ثبت گردید.";
                    messageAfterSubmit.Attributes["class"] = "dnnFormMessage dnnFormSuccess";
                    lnkSubmit.Visible = false;
                    lnkPrintKon.Visible = true;
                }
            }
        }

        private string UploadFormFileAdlBandi(FileUpload uploadedFile)
        {
            string guid = Guid.NewGuid().ToString();
            string filePath = PortalSettings.HomeDirectoryMapPath + @"/EHaml/Uploads/";
            //string now = DateTime.Now.ToShortDateString().Replace('\\', '_');
            string fileName = "Ts_AdlBandi_UId(" + this.UserId + ")_" + guid.Substring(0, 8) +
                              ".xlsx";

            if (!File.Exists(filePath + fileName))
            {
                uploadedFile.SaveAs(filePath + fileName);
            }

            string filePath2 = PortalSettings.HomeDirectory + @"/EHaml/Uploads/";
            //string now = DateTime.Now.ToShortDateString().Replace('\\', '_');
            string fileName2 = "Ts_AdlBandi_UId(" + this.UserId + ")_" + guid.Substring(0, 8) +
                               ".xlsx";

            return filePath2 + fileName2;
        }

        private void FillPageControl()
        {
            lblDarkhastKonandeValue.Text = this.UserInfo.DisplayName;
            FillCbolIsReallyNeed();
            FillCbolNoeAmaliyat();
            FillCbolMakaneAmaliyat();
            FillCbolStartingPointOstan();
        }

        private void FillCbolMakaneAmaliyat()
        {
            cbolMakaneAmaliyat.Items.Add(new DnnComboBoxItem("فونداسیون", "فونداسیون"));
            cbolMakaneAmaliyat.Items.Add(new DnnComboBoxItem("پایه فلزی", "پایه فلزی"));
            cbolMakaneAmaliyat.Items.Add(new DnnComboBoxItem("الوار چوبی", "الوار چوبی"));
        }

        private void FillCbolNoeAmaliyat()
        {
            cbolNoeAmaliyat.Items.Add(new DnnComboBoxItem("تخلیه", "تخلیه"));
            cbolNoeAmaliyat.Items.Add(new DnnComboBoxItem("بارگیری", "بارگیری"));
        }

        private void FillCbolIsReallyNeed()
        {
            
            cbolIsReallyNeed.Items.Add(new DnnComboBoxItem("صرفآ برای اطلاع از قیمت استعلام می کنم", "false"));
            cbolIsReallyNeed.Items.Add(new DnnComboBoxItem("صرفا برای اطلاع از قیمت نیست و نیاز به این خدمات دارم",
                "true"));

            
            
        }
    }
}