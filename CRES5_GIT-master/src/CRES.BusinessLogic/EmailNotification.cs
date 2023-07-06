using CRES.DAL.Repository;
using CRES.DataContract;
using CRES.DataContract.WorkFlow;
using CRES.Utilities;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;

namespace CRES.BusinessLogic
{
    public interface IEmailNotification
    {
        void SendCalculationFailureNotification();
        void SendNewUserNotification(string FirstName, string SuperAdminName, string loginid, string toEmail, string newPassword);
        void SendEmailResetPasswordNotification(string FirstName, string SuperAdminName, string loginid, string toEmail, string newPassword);

        void SendEmailResetPasswordActivationLinkNotification(string FirstName, string SuperAdminName, string loginid, string toEmail, string authenticationKey);

        void SendEmailForgotPasswordActivationLinkNotification(string FirstName, string toEmail, string authenticationKey);

        void SendEmailExportFFBackShopFail(DealDataContract DealDC, string BackShopStatus, string exceptionMessage);
        void SendEmailExportFFBackShopFail(NoteDataContract NoteDC, string BackShopStatus, string exceptionMessage);

        void SendNewTaskNotification(UserDataContract udc, TaskManagementDataContract tmdc);
        void SendCommentNotificationtouser(UserDataContract udc, string summary, string taskid, string comment, string username);
        void SendTaskAssignedNotification(UserDataContract udc, TaskManagementDataContract tmdc, string username);
        void SendWorkFlowNotification(List<WFNotificationDataContract> wfDetail);
        void SendPeriodicCloseExportFailNotification(PeriodicDataContract _periodicDC);
        void SendWFNotification(WFNotificationDetailDataContract wfDetail, out string htmlContent);
        void SendBatchCalculationEmail();
        void SendEmailDealFailedToSave(DealDataContract DealDC, string exceptionMessage, string shortmessage);
        void SendConsolidatWFEmailNotification();
        void SendUserWorkflowApproverChangeNotification(string Email, int ModuleId, string ModuleName, string receiverName, string userName, string envName);
        void SendEmailDealGenerateFutureFundingFailed(DealDataContract DealDC, string exceptionMessage, string shortmessage);
        void SendDelegateUserNotification(string Email, string receiverName, string Startdate, string Enddate, string senderuserName);
        void SendDealFundingandNoteFundingDiscrepancy(DataTable dt, int rowcount, DataTable dt1, int rowcount1, DataTable dt2, int rowcount2, DataTable dt3, int rowcount3, DataTable dt4, int rowcount4, DataTable dt5, int rowcount5, DataTable dt6, int rowcount6);

        void BatchUploadSummaryNotification(List<GenericVSTOResult> list, string summary, string username);

        void SendEmailForceFundingNotification(List<WFNotificationDataContract> lstWFNoti, string DealName, DateTime FundingDate, int days);
        void SendInvoiceNotification(DrawFeeInvoiceDataContract DrawFeeDC);
        string TestCheckAppPath();
        void SendWFNotificationForNegativeAmt(WFNotificationDetailDataContract wfDetail, out string htmlContent);
        string SendErrorNotificationEmail(EmailDataContract emailDC);
        void SendEmailBackshopFailed(string Userid, string exceptionMessage);
        string SendInvoiceSyncNotification(EmailDataContract emailDC);
        void SendReserveWorkFlowInternalNotification(List<WFNotificationDataContract> wfDetail);
        void SendNonFullPayoffDealDiscrepancy(DataTable dt);

    }

    public class EmailNotification : IEmailNotification
    {
        IConfigurationSection Sectionroot = null;
        private readonly IHostingEnvironment _hostingEnvironment;
        //  public IHostingEnvironment _hostingEnvironment;
        public EmailNotification(IHostingEnvironment hostingEnvironment)
        {
            //IConfigurationBuilder builder = new ConfigurationBuilder();
            //builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
            //var root = builder.Build();
            //Sectionroot = root.GetSection("Application");
            _hostingEnvironment = hostingEnvironment;
        }

        public void GetConfigSetting()
        {
            if (Sectionroot == null)
            {
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                Sectionroot = root.GetSection("Application");
            }
        }
        private CalculationManagerRespository _calculationrespository = new CalculationManagerRespository();

        public void SendCalculationFailureNotification()
        {
            // GetConfigSetting();
            UserRepository _userRepository = new UserRepository();
            //required parameters
            string fromEmail = "test@test.com";
            string[] toEmail = null;
            string subject = "Automated Notification from M61 Systems";
            string UserName = "Admin";
            string HtmlTemplateName = "CalculationFailureNotification.html";
            int moduleId = 340;

            List<RequestFailureDataContract> lstnotes = _calculationrespository.GetCalculationRequestFailureNotes(moduleId).ToList();

            if (lstnotes.Count > 0)
            {
                string BaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
                string noteUrl = "";
                string dealUrl = "";
                toEmail = lstnotes[0].EmailIds.Split(',');
                List<string> emailidsCC = _userRepository.GetEmailIdsByModule(moduleId);
                StringBuilder bodyText = new StringBuilder();
                bodyText.Append("<table id='failtable'");
                bodyText.Append("<tr id='trHeader'>");
                bodyText.Append("<td>Note ID</td><td>Note Name</td><td>Deal ID</td><td width='100px'>Deal Name</td><td width='100px'>Action By</td><td>Error Message</td>");


                bodyText.Append("</tr>");
                foreach (RequestFailureDataContract rf in lstnotes)
                {
                    noteUrl = BaseUrl + "#/notedetail/" + rf.NoteID;
                    dealUrl = BaseUrl + "#/dealdetail/" + rf.DealID;
                    bodyText.Append("<tr>");
                    bodyText.Append("<td> " + rf.CRENoteID + " </td><td><a href=" + noteUrl + ">" + rf.Name + "</a></td><td> " + rf.CREDealID + " </td><td><a href=" + dealUrl + ">" + rf.DealName + "</a></td><td> " + rf.UserName + " </td><td> " + rf.ErrorMessage + " </td>");
                    bodyText.Append("</tr>");
                }
                bodyText.Append("</table>");

                string htmlContent = string.Empty;

                //using streamreader for reading my htmltemplate   
                using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
                {
                    htmlContent = reader.ReadToEnd();
                }

                string linkName = Sectionroot.GetSection("ServerName").Value;
                if (!string.IsNullOrEmpty(linkName))
                {
                    htmlContent = htmlContent.Replace("{link}", linkName);
                    subject = "(" + linkName.Remove(0, 4) + ")" + subject;
                }

                htmlContent = htmlContent.Replace("{message}", bodyText.ToString());

                //EmailSender.SendTOEmail(fromEmail, new[] { toEmail }, emailidsCC, subject, bodyText.ToString(), UserName, htmlContent);
                //send email
                EmailSender.SendTOEmail(fromEmail, toEmail, emailidsCC, subject, bodyText.ToString(), UserName, htmlContent);
            }
        }


        public void SendNewUserNotification(string FirstName, string SuperAdminName, string loginid, string toEmail, string newPassword)
        {
            GetConfigSetting();

            UserRepository _userRepository = new UserRepository();

            string subject = "Welcome to M61 Systems";
            string password = newPassword;
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            string HtmlTemplateName = "NewUserNotification.html";
            StringBuilder bodyText = new StringBuilder();
#pragma warning disable CS0219 // The variable 'moduleId' is assigned but its value is never used
            int moduleId = 347;
#pragma warning restore CS0219 // The variable 'moduleId' is assigned but its value is never used
            //List<string> emailidsCC = _userRepository.GetEmailIdsByModule(moduleId);
            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            // string linkName = "M61-QA";
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string htmlContent = string.Empty;



            //using streamreader for reading my htmltemplate   
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            if (!string.IsNullOrEmpty(FirstName))
                htmlContent = htmlContent.Replace("{FirstName}", FirstName);

            if (!string.IsNullOrEmpty(linkName))
            {
                htmlContent = htmlContent.Replace("{link}", linkName);
                subject = "(" + linkName.Remove(0, 4) + ")" + subject;
            }
            if (!string.IsNullOrEmpty(loginid))
                htmlContent = htmlContent.Replace("{login}", loginid);
            htmlContent = htmlContent.Replace("{password}", password);
            htmlContent = htmlContent.Replace("{URL}", EmailBaseUrl);
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
            htmlContent = htmlContent.Replace("{SuperAdminFullName}", SuperAdminName);

            //send email


            EmailSender.SendTOEmail(fromEmail, new[] { toEmail }, null, subject, bodyText.ToString(), UserName, htmlContent);
        }


        public void SendEmailResetPasswordNotification(string FirstName, string SuperAdminName, string loginid, string toEmail, string newPassword)
        {
            GetConfigSetting();
            UserRepository _userRepository = new UserRepository();
            string subject = "Reset your M61 account password";
            string password = newPassword;
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            string HtmlTemplateName = "ResetPasswordNotification.html";
            StringBuilder bodyText = new StringBuilder();
            int moduleId = 348;
            List<string> emailidsCC = _userRepository.GetEmailIdsByModule(moduleId);
            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            string linkName = Sectionroot.GetSection("ServerName").Value;
            // string linkName = "M61-QA";
            string htmlContent = string.Empty;
            //using streamreader for reading my htmltemplate  
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            if (!string.IsNullOrEmpty(FirstName))
                htmlContent = htmlContent.Replace("{FirstName}", FirstName);

            if (!string.IsNullOrEmpty(linkName))
            {
                htmlContent = htmlContent.Replace("{link}", linkName);
                subject = "(" + linkName.Remove(0, 4) + ")" + subject;
            }
            if (!string.IsNullOrEmpty(loginid))
                htmlContent = htmlContent.Replace("{login}", loginid);
            htmlContent = htmlContent.Replace("{password}", password);
            htmlContent = htmlContent.Replace("{URL}", EmailBaseUrl);
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
            htmlContent = htmlContent.Replace("{SuperAdminFullName}", SuperAdminName);

            //send email
            EmailSender.SendTOEmail(fromEmail, new[] { toEmail }, emailidsCC, subject, bodyText.ToString(), UserName, htmlContent);
        }

        public void SendEmailResetPasswordActivationLinkNotification(string FirstName, string SuperAdminName, string loginid, string toEmail, string authenticationKey)
        {
            GetConfigSetting();
            UserRepository _userRepository = new UserRepository();
            string subject = "Reset your M61 account password";
            //string password = newPassword;
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            string HtmlTemplateName = "ResetPasswordActivationLinkNotification.html";
            StringBuilder bodyText = new StringBuilder();
            int moduleId = 348;
            List<string> emailidsCC = _userRepository.GetEmailIdsByModule(moduleId);
            string AuthenticationEmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value + "#/resetpassword/" + authenticationKey;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            string linkName = Sectionroot.GetSection("ServerName").Value;
            // string linkName = "M61-QA";
            string htmlContent = string.Empty;
            //using streamreader for reading my htmltemplate   
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            if (!string.IsNullOrEmpty(FirstName))
                htmlContent = htmlContent.Replace("{FirstName}", FirstName);

            if (!string.IsNullOrEmpty(linkName))
            {
                htmlContent = htmlContent.Replace("{link}", linkName);
                subject = "(" + linkName.Remove(0, 4) + ")" + subject;
            }
            if (!string.IsNullOrEmpty(loginid))
                htmlContent = htmlContent.Replace("{login}", loginid);
            //htmlContent = htmlContent.Replace("{password}", password);
            htmlContent = htmlContent.Replace("{URL}", AuthenticationEmailBaseUrl);
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
            htmlContent = htmlContent.Replace("{SuperAdminFullName}", SuperAdminName);

            //send email
            EmailSender.SendTOEmail(fromEmail, new[] { toEmail }, emailidsCC, subject, bodyText.ToString(), UserName, htmlContent);
        }

        public void SendEmailForgotPasswordActivationLinkNotification(string FirstName, string toEmail, string authenticationKey)
        {
            GetConfigSetting();
            UserRepository _userRepository = new UserRepository();
            string subject = "Reset your M61 account password";
            //string password = newPassword;
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            string HtmlTemplateName = "ForgotPasswordActivationLinkNotification.html";
            StringBuilder bodyText = new StringBuilder();
            int moduleId = 348;
            List<string> emailidsCC = _userRepository.GetEmailIdsByModule(moduleId);
            string AuthenticationEmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value + "#/resetpassword/" + authenticationKey;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            string linkName = Sectionroot.GetSection("ServerName").Value;
            // string linkName = "M61-QA";
            string htmlContent = string.Empty;
            //using streamreader for reading my htmltemplate   
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            if (!string.IsNullOrEmpty(FirstName))
                htmlContent = htmlContent.Replace("{FirstName}", FirstName);

            if (!string.IsNullOrEmpty(linkName))
            {
                htmlContent = htmlContent.Replace("{link}", linkName);
                subject = "(" + linkName.Remove(0, 4) + ")" + subject;
            }
            //if (!string.IsNullOrEmpty(loginid))
            //    htmlContent = htmlContent.Replace("{login}", loginid);

            htmlContent = htmlContent.Replace("{URL}", AuthenticationEmailBaseUrl);
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
            //htmlContent = htmlContent.Replace("{SuperAdminFullName}", SuperAdminName);

            //send email
            EmailSender.SendTOEmail(fromEmail, new[] { toEmail }, emailidsCC, subject, bodyText.ToString(), UserName, htmlContent);
        }


        public void SendEmailExportFFBackShopFail(DealDataContract DealDC, string BackShopStatus, string exceptionMessage)
        {
            GetConfigSetting();
            UserLogic ul = new UserLogic();
            UserDataContract _userdatacontract = ul.GetUserCredentialByUserID(new Guid(DealDC.UpdatedBy), new Guid("00000000-0000-0000-0000-000000000000"));
            string toEmail = _userdatacontract.Email;


            UserRepository _userRepository = new UserRepository();
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string subject = "Failure export future funding to backshop from M61 Systems";
            //if (!string.IsNullOrEmpty(linkName))
            //{
            //    subject = "(" + linkName.Remove(0, 4) + ")" + subject;
            //}
#pragma warning disable CS0219 // The variable 'password' is assigned but its value is never used
            string password = "admin1*";
#pragma warning restore CS0219 // The variable 'password' is assigned but its value is never used
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            string HtmlTemplateName = "ExportFFBackshopFailEmailNotification.html";
            StringBuilder bodyText = new StringBuilder();
            int moduleId = 363;
            List<string> emailidsCC = _userRepository.GetEmailIdsByModule(moduleId);
            //string[] toEmail = emailidsCC.ToArray();

            List<string> emailidsBCC = new List<string>();

            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;


            string htmlContent = string.Empty;



            bodyText.Append("<table border=1>");
            bodyText.Append("<tr id='trHeader'>");
            //bodyText.Append("<td>Deal ID</td><td>Deal Name</td><td>Last Action By</td><td>Error Message</td><td>System Exception</td>");
            bodyText.Append("<td>Deal ID</td><td>Deal Name</td><td>Last Action By</td><td>Error Message</td>");

            bodyText.Append("</tr>");

            string ErrorMessage = "Future funding export from M61 system to backshop failed.";
            if (BackShopStatus == "loginfailed")
            {
                ErrorMessage = "Error occurred while logging into Backshop.";
            }

            string dealUrl = EmailBaseUrl + "#/dealdetail/" + DealDC.DealID;
            bodyText.Append("<tr>");
            //bodyText.Append("<td> " + DealDC.CREDealID + " </td><td><a href=" + dealUrl + ">" + DealDC.DealName + "</a></td><td> " + DealDC.LastUpdatedByFF + " </td><td> " + ErrorMessage + " </td><td> " + exceptionMessage + " </td>");
            bodyText.Append("<td> " + DealDC.CREDealID + " </td><td><a href=" + dealUrl + ">" + DealDC.DealName + "</a></td><td> " + DealDC.LastUpdatedByFF + " </td><td> " + ErrorMessage + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("</table>");
            //showing detail error
            // bodyText.Append("Error Detail: ");
            // bodyText.Append(exceptionMessage);
            //using streamreader for reading my htmltemplate  

            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }

            if (!string.IsNullOrEmpty(bodyText.ToString()))
                htmlContent = htmlContent.Replace("{message}", bodyText.ToString());

            if (!string.IsNullOrEmpty(linkName))
            {
                htmlContent = htmlContent.Replace("{link}", linkName);
                subject = "(" + linkName.Remove(0, 4) + ")" + subject;
            }

            htmlContent = htmlContent.Replace("{FirstName}", CultureInfo.CurrentCulture.TextInfo.ToTitleCase(_userdatacontract.FirstName));
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);

            //send email
            EmailSender.SendTOEmail(fromEmail, new[] { toEmail }, emailidsCC, subject, bodyText.ToString(), UserName, htmlContent);
        }

        public void SendEmailExportFFBackShopFail(NoteDataContract NoteDC, string BackShopStatus, string exceptionMessage)
        {
            GetConfigSetting();
            UserLogic ul = new UserLogic();
            UserDataContract _userdatacontract = ul.GetUserCredentialByUserID(new Guid(NoteDC.UpdatedBy), new Guid("00000000-0000-0000-0000-000000000000"));
            string toEmail = _userdatacontract.Email;
            UserRepository _userRepository = new UserRepository();
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string subject = "Failure export future funding to backshop from M61 Systems";
            //if (!string.IsNullOrEmpty(linkName))
            //{
            //    subject = "(" + linkName.Remove(0, 4) + ")" + subject;
            //}
#pragma warning disable CS0219 // The variable 'password' is assigned but its value is never used
            string password = "admin1*";
#pragma warning restore CS0219 // The variable 'password' is assigned but its value is never used
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            string HtmlTemplateName = "ExportFFBackshopFailEmailNotification.html";
            StringBuilder bodyText = new StringBuilder();
            int moduleId = 363;
            List<string> emailidsCC = _userRepository.GetEmailIdsByModule(moduleId);
            //string[] toEmail = emailidsCC.ToArray();

            List<string> emailidsBCC = new List<string>();

            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;


            string htmlContent = string.Empty;


            bodyText.Append("<table border=1>");
            bodyText.Append("<tr id='trHeader'>");
            //bodyText.Append("<td>Deal ID</td><td>Deal Name</td><td>Last Action By</td><td>Error Message</td><td>System Exception</td>");
            bodyText.Append("<td>Note ID</td><td>Note Name</td><td>Last Action By</td><td>Error Message</td>");

            bodyText.Append("</tr>");

            string ErrorMessage = "Future funding export from M61 system to backshop failed.";
            if (BackShopStatus == "loginfailed")
            {
                ErrorMessage = "Error occurred while logging into Backshop.";
            }

            string dealUrl = EmailBaseUrl + "#/notedetail/" + NoteDC.NoteId;
            bodyText.Append("<tr>");
            bodyText.Append("<td> " + NoteDC.CRENoteID + " </td><td><a href=" + dealUrl + ">" + NoteDC.Name + "</a></td><td> " + NoteDC.UpdatedBy + " </td><td> " + ErrorMessage + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("</table>");

            //using streamreader for reading my htmltemplate  

            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }

            if (!string.IsNullOrEmpty(bodyText.ToString()))
                htmlContent = htmlContent.Replace("{message}", bodyText.ToString());

            if (!string.IsNullOrEmpty(linkName))
            {
                htmlContent = htmlContent.Replace("{link}", linkName);
                subject = "(" + linkName.Remove(0, 4) + ")" + subject;
            }

            htmlContent = htmlContent.Replace("{FirstName}", CultureInfo.CurrentCulture.TextInfo.ToTitleCase(_userdatacontract.FirstName));
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);

            //send email
            EmailSender.SendTOEmail(fromEmail, new[] { toEmail }, emailidsCC, subject, bodyText.ToString(), UserName, htmlContent);
        }

        public void SendNewTaskNotification(UserDataContract udc, TaskManagementDataContract tmdc)
        {
            GetConfigSetting();
#pragma warning disable CS0219 // The variable 'password' is assigned but its value is never used
            string password = "admin1*";
#pragma warning restore CS0219 // The variable 'password' is assigned but its value is never used
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            List<string> emailidsBCC = new List<string>();
            string subject = tmdc.Summary;
            string HtmlTemplateName = "TaskCreatedNotification.html";
            StringBuilder bodyText = new StringBuilder();

            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            // string linkName = "M61-QA";
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string htmlContent = string.Empty;
            //using streamreader for reading my htmltemplate   
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            htmlContent = htmlContent.Replace("{FirstName}", CultureInfo.CurrentCulture.TextInfo.ToTitleCase(udc.FirstName));
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
            if (!string.IsNullOrEmpty(linkName))
            {
                htmlContent = htmlContent.Replace("{link}", linkName);
                subject = "(" + linkName.Remove(0, 4) + ")" + subject;
            }
            htmlContent = htmlContent.Replace("{Summary}", tmdc.Summary);
            htmlContent = htmlContent.Replace("{description}", tmdc.Description);
            string clickhere = "<a target='_blank' href=" + EmailBaseUrl + "/#/taskactivity/" + tmdc.TaskID + " >Click here to respond in M61</a> ";
            htmlContent = htmlContent.Replace("{clickhere}", clickhere);
            //send email
            EmailSender.SendTOEmail(fromEmail, new[] { udc.Email }, emailidsBCC, subject, bodyText.ToString(), UserName, htmlContent);
        }

        public void SendCommentNotificationtouser(UserDataContract udc, string summary, string taskid, string comment, string username)
        {
            GetConfigSetting();
#pragma warning disable CS0219 // The variable 'password' is assigned but its value is never used
            string password = "admin1*";
#pragma warning restore CS0219 // The variable 'password' is assigned but its value is never used
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            List<string> emailidsBCC = new List<string>();
            string subject = "Re:" + summary;
            string HtmlTemplateName = "CommentedPostedNotification.html";
            StringBuilder bodyText = new StringBuilder();
            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string htmlContent = string.Empty;
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            if (!string.IsNullOrEmpty(linkName))
            {
                subject = "(" + linkName.Remove(0, 4) + ")" + subject;
                htmlContent = htmlContent.Replace("{link}", linkName);
            }
            htmlContent = htmlContent.Replace("{username}", username);
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
            htmlContent = htmlContent.Replace("{Summary}", comment);
            string clickhere = "<a target='_blank' href=" + EmailBaseUrl + "/#/taskactivity/" + taskid + " >M61</a> ";
            htmlContent = htmlContent.Replace("{clickhere}", clickhere);
            //send email
            EmailSender.SendTOEmail(fromEmail, new[] { udc.Email }, emailidsBCC, subject, bodyText.ToString(), UserName, htmlContent);
        }

        public void SendTaskAssignedNotification(UserDataContract udc, TaskManagementDataContract tmdc, string username)
        {
            GetConfigSetting();
#pragma warning disable CS0219 // The variable 'password' is assigned but its value is never used
            string password = "admin1*";
#pragma warning restore CS0219 // The variable 'password' is assigned but its value is never used
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            List<string> emailidsBCC = new List<string>();
            string subject = username + " assigned you : " + tmdc.Summary;
            string HtmlTemplateName = "TaskAssignedNotification.html";
            StringBuilder bodyText = new StringBuilder();

            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            // string linkName = "M61-QA";
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string htmlContent = string.Empty;
            //using streamreader for reading my htmltemplate   
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            htmlContent = htmlContent.Replace("{username}", CultureInfo.CurrentCulture.TextInfo.ToTitleCase(username));
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
            if (!string.IsNullOrEmpty(linkName))
            {
                subject = "(" + linkName.Remove(0, 4) + ")" + subject;
                htmlContent = htmlContent.Replace("{link}", linkName);
            }
            htmlContent = htmlContent.Replace("{description}", tmdc.Description);
            string clickhere = "<a target='_blank' href=" + EmailBaseUrl + "/#/taskactivity/" + tmdc.TaskID + " >M61</a> ";
            htmlContent = htmlContent.Replace("{clickhere}", clickhere);
            //send email
            EmailSender.SendTOEmail(fromEmail, new[] { udc.Email }, emailidsBCC, subject, bodyText.ToString(), UserName, htmlContent);
        }


        public void SendWorkFlowNotification(List<WFNotificationDataContract> wfDetail)
        {
            GetConfigSetting();
#pragma warning disable CS0219 // The variable 'password' is assigned but its value is never used
            string password = "admin1*";
#pragma warning restore CS0219 // The variable 'password' is assigned but its value is never used
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            List<string> emailidsBCC = new List<string>();
            string subject = "Draw approval request" + " - " + wfDetail[0].DealName + " - " + wfDetail[0].Comment;
            if (wfDetail[0].FundingAmount == 0)
            {
                subject = "Equity draw only request" + " - " + wfDetail[0].DealName + " - " + wfDetail[0].Comment;
            }
            if (!string.IsNullOrEmpty(wfDetail[0].PreHeaderText))
            {
                subject = wfDetail[0].PreHeaderText + " - " + subject;
            }
            string HtmlTemplateNameIntenullGroup = "WorkFlowRequestNotification.html";
            string HtmlTemplateNameAdditionalGroup = "WorkflowAdditionalGroupNotification.html";
            StringBuilder bodyText = new StringBuilder();

            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            // string linkName = "M61-QA";
            string linkName = Sectionroot.GetSection("ContactEmail").Value;
            string htmlContentMain = string.Empty;
            string htmlContent = string.Empty;
            //using streamreader for reading my htmltemplate  

            ////get pramary AM as sender
            //WFLogic wl = new WFLogic();
            //DrawFeeInvoiceDataContract dcPAM = wl.GetDealPrimaryAM(DrawFeeDC.DrawFeeInvoiceDetailID, "");
            //if (dcPAM != null && !string.IsNullOrEmpty(dcPAM.SenderFirstName))
            //{
            //    DrawFeeDC.SenderFirstName = dcPAM.SenderFirstName;
            //    DrawFeeDC.SenderLastName = dcPAM.SenderLastName;
            //    DrawFeeDC.SenderEmail = dcPAM.SenderEmail;
            //}

            //if (!string.IsNullOrEmpty(DrawFeeDC.FirstName))
            //    htmlContent = htmlContent.Replace("{firstname}", DrawFeeDC.FirstName);
            //htmlContent = htmlContent.Replace("{drawComment}", DrawFeeDC.DrawNo);
            //htmlContent = htmlContent.Replace("{sendername}", (DrawFeeDC.SenderFirstName + " " + DrawFeeDC.SenderLastName).Trim());
            //htmlContent = htmlContent.Replace("{senderemail}", DrawFeeDC.SenderEmail);
            ////

            #region "Internull Group"
            List<WFNotificationDataContract> wfDetailWorkflowInternullGroup = wfDetail.FindAll(x => x.WorkflowUserTypeID == 0);

            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateNameIntenullGroup))
            {
                htmlContentMain = reader.ReadToEnd();
            }
            foreach (WFNotificationDataContract lst in wfDetailWorkflowInternullGroup)
            {
                htmlContent = htmlContentMain;
                string dealdetail = "<tr><td>" + lst.DealName + "</td><td>" + lst.FundingDate.ToString("MM/dd/yyyy") + "</td><td>" + String.Format("{0:C}", lst.FundingAmount) + "</td><td>" + lst.DealLine.ToString("MM/dd/yyyy") + "</td></tr>";
                htmlContent = htmlContent.Replace("{username}", CultureInfo.CurrentCulture.TextInfo.ToTitleCase(lst.UserName));
                htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
                if (!string.IsNullOrEmpty(linkName))
                    htmlContent = htmlContent.Replace("{link}", linkName);
                string clickhere = "<a target='_blank' href=" + EmailBaseUrl.TrimEnd('/') + "/#/workflowdetail/" + lst.TaskID + "/" + lst.TaskTypeID + " >here</a> ";
                htmlContent = htmlContent.Replace("{clickhere}", clickhere);
                htmlContent = htmlContent.Replace("{nextstatusname}", lst.NextStatusName);
                htmlContent = htmlContent.Replace("{dealdetail}", dealdetail);
                htmlContent = htmlContent.Replace("{activitylog}", lst.ActivityLog);
                htmlContent = htmlContent.Replace("{footer}", lst.FooterText);
                htmlContent = htmlContent.Replace("{sendername}", lst.SenderName);
                htmlContent = htmlContent.Replace("{drawapprovallist}", lst.DwarApprovalList);
                htmlContent = htmlContent.Replace("{SpecialInstructions}", lst.SpecialInstructions);
                htmlContent = htmlContent.Replace("{AdditionalComments}", lst.AdditionalComments);
                htmlContent = htmlContent.Replace("{noteswithAmount}", lst.NoteswithAmount);
                //send email
                EmailSender.SendTOEmail(fromEmail, new[] { lst.Email }, emailidsBCC, subject, bodyText.ToString(), UserName, htmlContent);
            }
            #endregion

            #region "Additional Group"
            subject = "Draw preview request";
            List<WFNotificationDataContract> wfDetailWorkflowAdditionalGroup = wfDetail.FindAll(x => x.WorkflowUserTypeID == 564);

            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateNameAdditionalGroup))
            {
                htmlContentMain = reader.ReadToEnd();
            }
            foreach (WFNotificationDataContract lst in wfDetailWorkflowAdditionalGroup)
            {
                htmlContent = htmlContentMain;
                string dealdetail = "<tr><td>" + lst.DealName + "</td><td>" + lst.FundingDate.ToString("MM/dd/yyyy") + "</td><td>" + String.Format("{0:C}", lst.FundingAmount) + "</td><td>" + lst.DealLine.ToString("MM/dd/yyyy") + "</td></tr>";
                htmlContent = htmlContent.Replace("{username}", CultureInfo.CurrentCulture.TextInfo.ToTitleCase(lst.UserName));
                htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
                if (!string.IsNullOrEmpty(linkName))
                    htmlContent = htmlContent.Replace("{link}", linkName);
                string clickhere = "<a target='_blank' href=" + EmailBaseUrl + "/#/workflowdetail/" + lst.TaskID + " >here</a> ";
                htmlContent = htmlContent.Replace("{clickhere}", clickhere);
                htmlContent = htmlContent.Replace("{nextstatusname}", lst.NextStatusName);
                htmlContent = htmlContent.Replace("{dealdetail}", dealdetail);
                htmlContent = htmlContent.Replace("{activitylog}", lst.ActivityLog);
                htmlContent = htmlContent.Replace("{footer}", lst.FooterText);
                htmlContent = htmlContent.Replace("{sendername}", lst.SenderName);
                htmlContent = htmlContent.Replace("{drawapprovallist}", lst.DwarApprovalList);
                htmlContent = htmlContent.Replace("{SpecialInstructions}", lst.SpecialInstructions);
                htmlContent = htmlContent.Replace("{AdditionalComments}", lst.AdditionalComments);
                htmlContent = htmlContent.Replace("{noteswithAmount}", lst.NoteswithAmount);

                //send email
                EmailSender.SendTOEmail(fromEmail, new[] { lst.Email }, emailidsBCC, subject, bodyText.ToString(), UserName, htmlContent);
            }
            #endregion

        }
        public void SendReserveWorkFlowInternalNotification(List<WFNotificationDataContract> wfDetail)
        {
            GetConfigSetting();
#pragma warning disable CS0219 // The variable 'password' is assigned but its value is never used
            string password = "admin1*";
#pragma warning restore CS0219 // The variable 'password' is assigned but its value is never used
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            List<string> emailidsBCC = new List<string>();
            string subject = "Reserve Draw approval request" + " - " + wfDetail[0].DealName + " - " + wfDetail[0].Comment;

            if (!string.IsNullOrEmpty(wfDetail[0].PreHeaderText))
            {
                subject = wfDetail[0].PreHeaderText + " - " + subject;
            }
            string HtmlTemplateNameIntenullGroup = "ReserveInternalNotification.html";
            StringBuilder bodyText = new StringBuilder();

            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            // string linkName = "M61-QA";
            string linkName = Sectionroot.GetSection("ContactEmail").Value;
            string htmlContentMain = string.Empty;
            string htmlContent = string.Empty;
            //using streamreader for reading my htmltemplate   

            #region "Internull Group"
            List<WFNotificationDataContract> wfDetailWorkflowInternullGroup = wfDetail.FindAll(x => x.WorkflowUserTypeID == 0);

            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateNameIntenullGroup))
            {
                htmlContentMain = reader.ReadToEnd();
            }
            foreach (WFNotificationDataContract lst in wfDetailWorkflowInternullGroup)
            {
                htmlContent = htmlContentMain;
                string dealdetail = "<tr><td>" + lst.DealName + "</td><td>" + lst.FundingDate.ToString("MM/dd/yyyy") + "</td><td>" + String.Format("{0:C}", lst.FundingAmount) + "</td></tr>";
                htmlContent = htmlContent.Replace("{username}", CultureInfo.CurrentCulture.TextInfo.ToTitleCase(lst.UserName));
                htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
                if (!string.IsNullOrEmpty(linkName))
                    htmlContent = htmlContent.Replace("{link}", linkName);
                string clickhere = "<a target='_blank' href=" + EmailBaseUrl.TrimEnd('/') + "/#/workflowdetail/" + lst.TaskID + "/" + lst.TaskTypeID + " >here</a> ";
                htmlContent = htmlContent.Replace("{clickhere}", clickhere);
                htmlContent = htmlContent.Replace("{nextstatusname}", lst.NextStatusName);
                htmlContent = htmlContent.Replace("{reservebreakDown}", lst.ReserveScheduleBreakDown);
                htmlContent = htmlContent.Replace("{dealdetail}", dealdetail);
                htmlContent = htmlContent.Replace("{activitylog}", lst.ActivityLog);
                htmlContent = htmlContent.Replace("{footer}", lst.FooterText);
                htmlContent = htmlContent.Replace("{sendername}", lst.SenderName);
                htmlContent = htmlContent.Replace("{drawapprovallist}", lst.DwarApprovalList);
                htmlContent = htmlContent.Replace("{SpecialInstructions}", lst.SpecialInstructions);
                htmlContent = htmlContent.Replace("{AdditionalComments}", lst.AdditionalComments);
                //send email
                EmailSender.SendTOEmail(fromEmail, new[] { lst.Email }, emailidsBCC, subject, bodyText.ToString(), UserName, htmlContent);
            }
            #endregion
        }

        public void SendPeriodicCloseExportFailNotification(PeriodicDataContract _periodicDC)
        {
            GetConfigSetting();
#pragma warning disable CS0219 // The variable 'password' is assigned but its value is never used
            string password = "admin1*";
#pragma warning restore CS0219 // The variable 'password' is assigned but its value is never used
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            List<string> emailidsBCC = new List<string>();
            string subject = "Periodic close database export failure";
            string HtmlTemplateName = "PeriodicCloseDBExportFailEmailNotification.html";
            StringBuilder bodyText = new StringBuilder();

            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            // string linkName = "M61-QA";
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string htmlContent = string.Empty;
            //using streamreader for reading my htmltemplate   
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            if (!string.IsNullOrEmpty(linkName))
            {
                subject = "(" + linkName.Remove(0, 4) + ")" + subject;
            }
            int moduleId = 548;
            UserRepository _userRepository = new UserRepository();
            List<string> emailidsCC = _userRepository.GetEmailIdsByModule(moduleId);

            foreach (string lst in emailidsCC)
            {
                htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
                htmlContent = htmlContent.Replace("{message}", _periodicDC.Message);
                htmlContent = htmlContent.Replace("{startdate}", Convert.ToDateTime(_periodicDC.StartDate).ToString("MM/dd/yyyy"));
                htmlContent = htmlContent.Replace("{enddate}", Convert.ToDateTime(_periodicDC.EndDate).ToString("MM/dd/yyyy"));

                //send email
                EmailSender.SendTOEmail(fromEmail, new[] { lst }, emailidsBCC, subject, bodyText.ToString(), UserName, htmlContent);
            }


        }
        public void SendWFNotification(WFNotificationDetailDataContract wfDetail, out string htmlContent)
        {
            GetConfigSetting();
#pragma warning disable CS0219 // The variable 'password' is assigned but its value is never used
            string password = "admin1*";
#pragma warning restore CS0219 // The variable 'password' is assigned but its value is never used
#pragma warning disable CS0219 // The variable 'fromEmail' is assigned but its value is never used
            string fromEmail = "test@test.com";
#pragma warning restore CS0219 // The variable 'fromEmail' is assigned but its value is never used
            string UserName = "Admin";
            List<string> emailidsBCC = new List<string>();
#pragma warning disable CS0219 // The variable 'subject' is assigned but its value is never used
            string subject = "";
#pragma warning restore CS0219 // The variable 'subject' is assigned but its value is never used


            StringBuilder bodyText = new StringBuilder();

            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            // string linkName = "M61-QA";
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string htmlContentMain = string.Empty;
            htmlContent = string.Empty;



            //using streamreader for reading my htmltemplate   

            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + wfDetail.TemplateFileName))
            {
                htmlContentMain = reader.ReadToEnd();
            }
            htmlContent = htmlContentMain;
            //get deals primary AM
            WFLogic wl = new WFLogic();
            UserDataContract dcPAM = wl.GetDealPrimaryAMByDealOrTaskType("", wfDetail.TaskTypeID, wfDetail.TaskID.ToString(), "");
            if (dcPAM != null && !string.IsNullOrEmpty(dcPAM.FirstName))
            {
                htmlContent = htmlContent.Replace("{primaryam}", dcPAM.FirstName + " " + dcPAM.LastName);
                htmlContent = htmlContent.Replace("{primaryamemail}", dcPAM.Email + (string.IsNullOrEmpty(dcPAM.ContactNo1) ? " | " + dcPAM.ContactNo1 : ""));
                htmlContent = htmlContent.Replace("{sendername}", dcPAM.FirstName + " " + dcPAM.LastName);
            }
            else
            {
                htmlContent = htmlContent.Replace("{sendername}", wfDetail.UserName);
            }
            //
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
            if (!string.IsNullOrEmpty(linkName))
                htmlContent = htmlContent.Replace("{link}", linkName);
            htmlContent = htmlContent.Replace("{bodytext}", wfDetail.MessageHTML);

            //send email
            EmailSender.SendEmailTOCCWithAttachment(wfDetail.ReplyTo, wfDetail.EmailToIds.Trim().Split(','), wfDetail.EmailCCIds.Trim().Split(','), wfDetail.Subject, UserName, htmlContent, new byte[0], "");

        }

        //send email on batch calulation if all notes are calculated with autogenerated tag
        public void SendBatchCalculationEmail()
        {
            GetConfigSetting();
            string BaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string linkName = Sectionroot.GetSection("ServerName").Value;
            UserRepository _userRepository = new UserRepository();
            //required parameters
            string fromEmail = "test@test.com";
            string subject = linkName + ": " + "Batch calculation request completed";

            string UserName = "Admin";
            string HtmlTemplateName = "BatchCalculationNotification.html";
            int moduleId = 595;
            List<string> emailidsAdmin = new List<string>();

            List<BatchCalculationMasterDataContract> lstbatch = _calculationrespository.GetBatchCalculationForEmailNotification("").ToList();

            if (lstbatch.Count > 0)
            {

                var lstbatchAll = lstbatch.Where(x => x.BatchType.ToLower() == "all").ToList();
                var lstbatchAllWIthTag = lstbatch.Where(x => x.BatchType.ToLower() == "allwithtag").ToList();

                //get admin email from email config table
                emailidsAdmin = _userRepository.GetEmailIdsByModule(moduleId);

                StringBuilder TableStart = new StringBuilder();
                TableStart.Append("<table id='failtable'>");
                TableStart.Append("<tr id='trHeader'>");
                TableStart.Append("<td>Batch ID </td><td>Total Notes</td><td>Completed</td><td>Failed</td><td>Scenario</td><td>Requested By</td><td>Start Time</td><td>End Time</td>");
                TableStart.Append("</tr>");
                StringBuilder bodyText = new StringBuilder();
                string TableEnd = "</table>";

                //send email for calc all without tage
                var emailids = lstbatchAll.Select(x => x.Email).Distinct();
                if (emailids.Count() > 0)
                {
                    foreach (string email in emailids)
                    {
                        bodyText.Clear();
                        bodyText = TableStart;
                        var batch = lstbatchAll.Where(x => x.Email == email);
                        int serial = 1;
                        foreach (BatchCalculationMasterDataContract bc in batch)
                        {

                            bodyText.Append("<tr>");
                            bodyText.Append("<td> " + bc.BatchCalculationMasterID + " </td><td>" + bc.Total + "</td><td> " + bc.TotalCompleted + " </td><td>" + bc.TotalFailed + "</td><td>" + bc.Name + "</td><td> " + bc.UserName + " </td><td> " + bc.StartTime + " </td><td> " + bc.EndTime + " </td>");
                            bodyText.Append("</tr>");
                            serial += 1;
                        }
                        bodyText.Append(TableEnd);

                        string htmlContent = string.Empty;

                        //using streamreader for reading my htmltemplate   
                        using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
                        {
                            htmlContent = reader.ReadToEnd();
                        }

                        if (!string.IsNullOrEmpty(linkName))
                        {
                            htmlContent = htmlContent.Replace("{link}", linkName);

                            subject = "(" + linkName.Remove(0, 4) + ")" + subject;
                        }
                        htmlContent = htmlContent.Replace("{message}", bodyText.ToString());

                        //EmailSender.SendTOEmail(fromEmail, new[] { toEmail }, emailidsCC, subject, bodyText.ToString(), UserName, htmlContent);
                        //send email

                        EmailSender.SendTOEmail(fromEmail, new[] { email }, emailidsAdmin, subject, bodyText.ToString(), UserName, htmlContent);

                    }

                }

                //send email for calc all with tage
                var emailidsWithTag = lstbatchAllWIthTag.Select(x => x.Email).Distinct();
                if (emailidsWithTag.Count() > 0)
                {
                    //subject = "Batch Calculation Notification with Tag generated from M61 Systems";

                    foreach (string email in emailidsWithTag)
                    {
                        bodyText.Clear();
                        bodyText = TableStart;
                        var batch = lstbatchAllWIthTag.Where(x => x.Email == email);
                        int serial = 1;
                        foreach (BatchCalculationMasterDataContract bc in batch)
                        {

                            bodyText.Append("<tr>");
                            bodyText.Append("<td> " + bc.BatchCalculationMasterID + " </td><td>" + bc.Total + "</td><td> " + bc.TotalCompleted + " </td><td>" + bc.TotalFailed + "</td><td>" + bc.Name + "</td><td> " + bc.UserName + " </td><td> " + bc.StartTime + " </td><td> " + bc.EndTime + " </td>");
                            bodyText.Append("</tr>");
                            serial += 1;
                        }
                        bodyText.Append(TableEnd);

                        string htmlContent = string.Empty;

                        //using streamreader for reading my htmltemplate   
                        using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
                        {
                            htmlContent = reader.ReadToEnd();
                        }

                        if (!string.IsNullOrEmpty(linkName))
                            htmlContent = htmlContent.Replace("{link}", linkName);

                        htmlContent = htmlContent.Replace("{message}", bodyText.ToString());

                        //EmailSender.SendTOEmail(fromEmail, new[] { toEmail }, emailidsCC, subject, bodyText.ToString(), UserName, htmlContent);
                        //send email
                        EmailSender.SendTOEmail(fromEmail, new[] { email }, emailidsAdmin, subject, bodyText.ToString(), UserName, htmlContent);

                    }

                }
            }

        }


        public void SendEmailDealFailedToSave(DealDataContract DealDC, string exceptionMessage, string shortmessage)
        {
            try
            {
                GetConfigSetting();
                UserLogic ul = new UserLogic();
                UserDataContract _userdatacontract = ul.GetUserCredentialByUserID(new Guid(DealDC.UpdatedBy), new Guid("00000000-0000-0000-0000-000000000000"));
                string[] toEmail = null;
                UserRepository _userRepository = new UserRepository();
                string subject = "Deal: " + DealDC.DealName + " failed to save";
#pragma warning disable CS0219 // The variable 'password' is assigned but its value is never used
                string password = "admin1*";
#pragma warning restore CS0219 // The variable 'password' is assigned but its value is never used
                string fromEmail = "test@test.com";
                string UserName = "Admin";
                string HtmlTemplateName = "DealFailedToSave.html";
                StringBuilder bodyText = new StringBuilder();
                int moduleId = 598;
                List<string> emailidsCC = null;
                string dealUrl = "";
                string dealname = "";

                toEmail = _userRepository.GetEmailIdsByModule(moduleId).ToArray();

                List<string> emailidsBCC = new List<string>();
                string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
                string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
                string linkName = Sectionroot.GetSection("ServerName").Value;
                string htmlContent = string.Empty;

                dealUrl = EmailBaseUrl + "#/dealdetail/" + DealDC.DealID;
                dealname = "<a href=" + dealUrl + ">" + DealDC.DealName + "</a>";

                //using streamreader for reading my htmltemplate  
                using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
                {
                    htmlContent = reader.ReadToEnd();
                }
                htmlContent = htmlContent.Replace("{errormessage}", exceptionMessage);
                htmlContent = htmlContent.Replace("{dealname}", dealname);
                htmlContent = htmlContent.Replace("{shortmessage}", shortmessage);
                if (!string.IsNullOrEmpty(linkName))
                {
                    htmlContent = htmlContent.Replace("{link}", linkName);
                    subject = "(" + linkName.Remove(0, 4) + ")" + subject;
                }


                htmlContent = htmlContent.Replace("{username}", CultureInfo.CurrentCulture.TextInfo.ToTitleCase(_userdatacontract.FirstName));
                //send email
                EmailSender.SendTOEmail(fromEmail, toEmail, emailidsCC, subject, bodyText.ToString(), UserName, htmlContent);
                //EmailSender.SendTOEmail(fromEmail, new[] { toEmail }, emailidsCC, subject, bodyText.ToString(), UserName, htmlContent);
            }
            catch (Exception ex)
            {

                string msg = ex.Message;
            }
        }
        public string DateToString(string dt)
        {

            DateTime date = Convert.ToDateTime(dt);
            return (date.Day % 10 == 1 && date.Day != 11) ? "st"
              : (date.Day % 10 == 2 && date.Day != 12) ? "nd"
              : (date.Day % 10 == 3 && date.Day != 13) ? "rd"
              : "th";
        }
        public void SendConsolidatWFEmailNotification()
        {
            WFRepository _wfRepository = new WFRepository();
            DataTable dt = _wfRepository.GetConsolidatWFEmailNotification();
            DataTable dtPreliminary = new DataTable();
            DataTable dtPreUniq = new DataTable();
            DataTable dtRevised = new DataTable();
            DataTable dtRevUniq = new DataTable();

            var Prerows = dt.AsEnumerable().Where(row => row.Field<string>("NotificationType").ToLower() == "preliminary");
            if (Prerows.Any())
            {
                dtPreliminary = Prerows.CopyToDataTable<DataRow>();
                dtPreUniq = dtPreliminary.DefaultView.ToTable(true, "dealname");
            }



            var Revrows = dt.AsEnumerable().Where(row => row.Field<string>("NotificationType").ToLower() == "preliminary revised");
            if (Revrows.Any())
            {
                dtRevised = Revrows.CopyToDataTable<DataRow>();
                dtRevUniq = dtRevised.DefaultView.ToTable(true, "dealname");
            }




            #region SendEmail

            string htmlContentMain = string.Empty;
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            string[] emailidsTo = null;
            string subject = "Future Funding Notice - ";
            string HtmlTemplateName = "ConsolidatedNotification.html";
            StringBuilder bodyText = new StringBuilder();

            if (dt.Rows.Count > 0)
            {
                emailidsTo = dt.DefaultView.ToTable(true, "EmailID").AsEnumerable().Select(r => r.Field<string>("EmailID")).ToArray();

                for (var i = 0; i < dtPreUniq.Rows.Count; i++)
                {
                    subject += dtPreUniq.Rows[i]["dealname"] + " FF, ";
                }

                for (var j = 0; j < dtRevUniq.Rows.Count; j++)
                {
                    subject += dtRevUniq.Rows[j]["dealname"] + " (Revised) FF, ";
                }

                subject = subject.Remove(subject.Length - 2, 2);
                if (dtPreliminary.Rows.Count > 0)
                {

                    bodyText.Append("<tr><td><h4><b>Preliminary Capital Calls:</b></h4></td></tr><br/>");
                    bodyText.Append("<tr><td>All,</td></tr><br/>");
                    for (var k = 0; k < dtPreliminary.Rows.Count; k++)
                    {

                        string msgClient = "";
                        var ClientAmount = dtPreliminary.Rows[k]["MessageData"].ToString().Split('|');
                        for (var i = 2; i < ClientAmount.Length; i++)
                        {

                            var Cl = ClientAmount[i].Split('#');

                            if (i == 2)
                                msgClient = "$" + string.Format("{0:n}", Convert.ToDecimal(Cl[1])) + " is anticipated to be funded by " + Cl[0].ToString();
                            else
                                msgClient += " and " + "$" + string.Format("{0:n}", Convert.ToDecimal(Cl[1])) + " by " + Cl[0].ToString();
                        }
                        string sFundDate = string.Format("{0:D}", dtPreliminary.Rows[k]["FundingDate"]);
                        string strDate = sFundDate.Split(' ')[2];
                        string newDate = strDate.Replace(",", "") + DateToString(dtPreliminary.Rows[k]["FundingDate"].ToString());
                        string FDate = sFundDate.Replace(strDate, newDate);

                        bodyText.Append("<tr><td>ACORE is reviewing a Lender Advance Request for " + dtPreliminary.Rows[k]["dealname"] + " in the total amount of " + "$" + String.Format("{0:n}", Convert.ToDecimal(ClientAmount[1])) + " of which " + msgClient + ". We anticipate funding on " + FDate + ". " + "</td></tr><br/>");

                    }

                    //bodyText.Append("<br/><tr><td>Funding Instructions will be sent 2 business days prior to funding.</td></tr><br/>");
                    //bodyText.Append("<tr><td>Please let us know if you have any questions, thank you.</td></tr><br/>");
                }

                //===============Revised 

                if (dtRevised.Rows.Count > 0)
                {

                    bodyText.Append("<tr><td><h4><b>Revised Preliminary Capital Calls:</b></h4></td></tr><br/>");
                    for (var i = 0; i < dtRevUniq.Rows.Count; i++)
                    {
                        decimal oldFundingValue = 0, newFundingValue = 0, ChangedFundingValue, PercentFunding;
                        bodyText.Append("<tr><td>Deal: " + dtRevUniq.Rows[i]["dealname"] + "</td></tr><br/>");
                        for (var k = 0; k < dtRevised.Rows.Count; k++)
                        {
                            if (dtRevUniq.Rows[i]["dealname"].ToString() == dtRevised.Rows[k]["dealname"].ToString())
                            {
                                string msgClient = "";

                                var ClientAmount = dtRevised.Rows[k]["MessageData"].ToString().Split('|');
                                for (var s = 2; s < ClientAmount.Length; s++)
                                {

                                    var Cl = ClientAmount[s].Split('#');

                                    if (s == 2)
                                    {
                                        if (dtRevised.Rows[k]["Ntype"].ToString().ToLower() == "old")
                                        {
                                            oldFundingValue = Convert.ToDecimal(ClientAmount[1]);
                                            msgClient = "$" + string.Format("{0:n}", Convert.ToDecimal(Cl[1])) + " was anticipated to be funded by " + Cl[0].ToString();
                                        }
                                        if (dtRevised.Rows[k]["Ntype"].ToString().ToLower() == "new")
                                        {
                                            newFundingValue = Convert.ToDecimal(ClientAmount[1]);
                                            msgClient = "$" + string.Format("{0:n}", Convert.ToDecimal(Cl[1])) + " is anticipated to be funded by " + Cl[0].ToString();
                                        }
                                    }
                                    else
                                        msgClient += " and " + "$" + string.Format("{0:n}", Convert.ToDecimal(Cl[1])) + " by " + Cl[0].ToString();
                                }

                                string sFundDate = string.Format("{0:D}", Convert.ToDateTime(ClientAmount[0]));
                                string strDate = sFundDate.Split(' ')[2];
                                string newDate = strDate.Replace(",", "") + DateToString(ClientAmount[0]);
                                string FDate = sFundDate.Replace(strDate, newDate);


                                if (dtRevised.Rows[k]["Ntype"].ToString().ToLower() == "old")
                                {
                                    bodyText.Append("<tr><td>The previous Preliminary Capital Call was for the total amount of " + "$" + String.Format("{0:n}", Convert.ToDecimal(ClientAmount[1])) + " of which " + msgClient + ". The anticipated funding date was " + FDate + ". " + "</td></tr><br/>");

                                }
                                if (dtRevised.Rows[k]["Ntype"].ToString().ToLower() == "new")
                                {
                                    bodyText.Append("<tr><td>The revised Preliminary Capital Call is for  the total amount of " + "$" + String.Format("{0:n}", Convert.ToDecimal(ClientAmount[1])) + " of which " + msgClient + ". The revised funding date is " + FDate + ". " + "</td></tr><br/>");

                                }

                                if (oldFundingValue == 0)
                                {
                                    ChangedFundingValue = 0;
                                    PercentFunding = 0;
                                }
                                else
                                {
                                    ChangedFundingValue = newFundingValue - oldFundingValue;
                                    PercentFunding = (ChangedFundingValue / oldFundingValue) * 100;
                                }

                                if (dtRevised.Rows[k]["Ntype"].ToString().ToLower() == "new")
                                {
                                    if (dtRevised.Rows[k - 1]["Ntype"].ToString().ToLower() == "old")
                                    {
                                        bodyText.Append("<tr><td>% change = " + String.Format("{0:n}", PercentFunding) + "%" + "</td></tr>");
                                        bodyText.Append("<tr><td>$ change = " + String.Format("{0:n}", ChangedFundingValue) + "</td></tr><br/><br/>");
                                    }
                                }
                            }
                        }

                    }
                }
                bodyText.Append("<tr><td>Funding Instructions will be sent 2 business days prior to funding.</td></tr><br/><br/>");
                bodyText.Append("<tr><td>Please let us know if you have any questions, thank you.</td></tr><br/>");

                using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
                {
                    htmlContentMain = reader.ReadToEnd();
                }
                htmlContentMain = htmlContentMain.Replace("{bodytext}", bodyText.ToString());

                //send email
                EmailSender.SendTOEmail(fromEmail, emailidsTo, null, subject, bodyText.ToString(), UserName, htmlContentMain);
                #endregion
            }
        }

        public void SendUserWorkflowApproverChangeNotification(string Email, int ModuleId, string ModuleName, string receiverName, string userName, string envName)
        {
            GetConfigSetting();
            UserRepository _userRepository = new UserRepository();
            string subject = "(" + envName + ")" + " Welcome to M61 Systems";
            string toEmail = Email;
            string fromEmail = "test@test.com";
            string updatedto = ModuleName;
#pragma warning disable CS0219 // The variable 'UserName' is assigned but its value is never used
            string UserName = "Super Admin";
#pragma warning restore CS0219 // The variable 'UserName' is assigned but its value is never used
            string HtmlTemplateName = "WorkFlowApprover.html";
            StringBuilder bodyText = new StringBuilder();
            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string htmlContent = string.Empty;

            // bodyText.Append("<tr><td>You have been updated to {updatedto}.</td></tr><br/><br/>");

            //using streamreader for reading my htmltemplate   
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }


            if (!string.IsNullOrEmpty(linkName))
                htmlContent = htmlContent.Replace("{link}", linkName);
            htmlContent = htmlContent.Replace("{URL}", EmailBaseUrl);
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
            htmlContent = htmlContent.Replace("{sendername}", userName);
            htmlContent = htmlContent.Replace("{updatedto}", updatedto);
            htmlContent = htmlContent.Replace("{receivername}", receiverName);
            //send email
            htmlContent = htmlContent.Replace("{bodytext}", bodyText.ToString());

            EmailSender.SendTOWPApproverEmail(fromEmail, toEmail, subject, bodyText.ToString(), htmlContent);
        }
        public void SendEmailDealGenerateFutureFundingFailed(DealDataContract DealDC, string exceptionMessage, string shortmessage)
        {
            GetConfigSetting();
            UserLogic ul = new UserLogic();
            UserDataContract _userdatacontract = ul.GetUserCredentialByUserID(new Guid(DealDC.UpdatedBy), new Guid("00000000-0000-0000-0000-000000000000"));
            string[] toEmail = null;
            UserRepository _userRepository = new UserRepository();
            string subject = "Deal Generate Funding Issue -" + DealDC.DealName;
#pragma warning disable CS0219 // The variable 'password' is assigned but its value is never used
            string password = "admin1*";
#pragma warning restore CS0219 // The variable 'password' is assigned but its value is never used
            string fromEmail = "test@test.com";
            //string UserName = "Admin";
            string HtmlTemplateName = "DealGenerateFutureFundingFailed.html";
            StringBuilder bodyText = new StringBuilder();
            int moduleId = 615;
            string dealUrl = "";
            string dealname = "";
            toEmail = _userRepository.GetEmailIdsByModule(moduleId).ToArray();
            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string htmlContent = string.Empty;

            dealUrl = EmailBaseUrl + "#/dealdetail/" + DealDC.DealID;
            dealname = "<a href=" + dealUrl + ">" + DealDC.DealName + "</a>";


            //using streamreader for reading my htmltemplate  
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            htmlContent = htmlContent.Replace("{errormessage}", exceptionMessage);
            htmlContent = htmlContent.Replace("{dealname}", dealname);
            htmlContent = htmlContent.Replace("{shortmessage}", shortmessage);
            if (!string.IsNullOrEmpty(linkName))
            {
                subject = "(" + linkName.Remove(0, 4) + ")" + subject;
                htmlContent = htmlContent.Replace("{link}", linkName);
            }
            htmlContent = htmlContent.Replace("{username}", CultureInfo.CurrentCulture.TextInfo.ToTitleCase(_userdatacontract.FirstName));
            //send email
            EmailSender.SendTOEmail(fromEmail, toEmail, null, subject, bodyText.ToString(), null, htmlContent);

        }
        public void SendDelegateUserNotification(string Email, string receiverName, string Startdate, string Enddate, string senderuserName)
        {
            GetConfigSetting();
            UserRepository _userRepository = new UserRepository();
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string subject = "(" + linkName + ")" + " Sharing access privileges of " + senderuserName + " between " + Startdate + " to " + Enddate;
            string toEmail = Email;
            string fromEmail = "test@test.com";
            // string UserName = "Super Admin";
            string HtmlTemplateName = "DelegateUserNotification.html";
            StringBuilder bodyText = new StringBuilder();

            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            // string linkName = "M61-QA";

            string htmlContent = string.Empty;

            // bodyText.Append("<tr><td>You have been updated to {updatedto}.</td></tr><br/><br/>");

            //using streamreader for reading my htmltemplate   
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }


            if (!string.IsNullOrEmpty(linkName))
                htmlContent = htmlContent.Replace("{link}", linkName);
            htmlContent = htmlContent.Replace("{URL}", EmailBaseUrl);
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
            htmlContent = htmlContent.Replace("{senderuserName}", senderuserName);
            htmlContent = htmlContent.Replace("{Startdate}", Startdate);
            htmlContent = htmlContent.Replace("{Enddate}", Enddate);
            htmlContent = htmlContent.Replace("{Receivername}", receiverName);
            //send email
            htmlContent = htmlContent.Replace("{bodytext}", bodyText.ToString());

            EmailSender.SendTOWPApproverEmail(fromEmail, toEmail, subject, bodyText.ToString(), htmlContent);
        }
        public void SendDealFundingandNoteFundingDiscrepancy(DataTable dt, int rowcount, DataTable dt1, int rowcount1, DataTable dt2, int rowcount2, DataTable dt3, int rowcount3, DataTable dt4, int rowcount4, DataTable dt5, int rowcount5, DataTable dt6, int rowcount6)
        {
            GetConfigSetting();
            UserRepository _userRepository = new UserRepository();
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string showlink = linkName.Substring(4);
            string subject = "(" + showlink + ")" + " Automated Consolidate Discrepancy Notification";
            int moduleId = 632;
            string[] toEmail = null;
            if (dt.Rows.Count > 0 || dt1.Rows.Count > 0 || dt2.Rows.Count > 0 || dt5.Rows.Count > 0 || dt6.Rows.Count > 0)
            {

                toEmail = _userRepository.GetEmailIdsByModule(moduleId).ToArray();
            }
            else
            {
                toEmail = new[] { "rsahu@hvantage.com" };
            }


            string Htmltext = "";
            string Htmltext1 = "";
            string Htmltext2 = "";
            string Htmltext3 = "";
            string Htmltext4 = "";
            string Htmltext5 = "";
            string Htmltext6 = "";
            string fromEmail = "test@test.com";
            string HtmlTemplateName = "DealandNoteFundingDiscrepancy.html";
            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            //Summary detail
            StringBuilder TableStart = new StringBuilder();
            TableStart.Append("<table id='Dealfundingdiscrepancy'>");
            TableStart.Append("<tr id='trHeader'>");
            TableStart.Append("<td>Discrepancies</td><td>Issue(s)</td>");
            TableStart.Append("</tr>");
            string TableEnd = "</table>";
            StringBuilder bodyText = new StringBuilder();


            bodyText = TableStart;
            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Funding" + " </td><td style=text-align:left !important;>" + rowcount + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Exit / Extension Fee Stripping/ Receivable" + " </td><td style=text-align:left !important;>" + rowcount1 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Future Funding Between M61 and Backshop" + " </td><td style=text-align:left !important;>" + rowcount2 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Commitment Discrepancy" + " </td><td style=text-align:left !important;>" + rowcount3 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Commitment Data Discrepancy" + " </td><td style=text-align:left !important;>" + rowcount4 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Eligible deals to autospread" + " </td><td style=text-align:left !important;>" + rowcount5 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Export Paydown Between M61 and Backshop" + " </td><td style=text-align:left !important;>" + rowcount6 + " </td>");
            bodyText.Append("</tr>");
            bodyText.Append(TableEnd);

            StringBuilder strHTMLBuilder = new StringBuilder();
            //Deal and Note Discrpancy
            if (dt.Rows.Count > 0)
            {
                strHTMLBuilder.Append("<html >");
                strHTMLBuilder.Append("<head>");
                strHTMLBuilder.Append("</head>");
                strHTMLBuilder.Append("<body>");
                strHTMLBuilder.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder.Append("<tr id='trHeader'>");


                foreach (DataColumn myColumn in dt.Columns)
                {
                    if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "CREDealID")
                    {
                        strHTMLBuilder.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                        strHTMLBuilder.Append(myColumn.ColumnName);
                        strHTMLBuilder.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                        strHTMLBuilder.Append(myColumn.ColumnName);
                        strHTMLBuilder.Append("</td>");
                    }
                }
                strHTMLBuilder.Append("</tr>");


                foreach (DataRow myRow in dt.Rows)
                {

                    strHTMLBuilder.Append("<tr >");
                    foreach (DataColumn myColumn in dt.Columns)
                    {
                        if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "CREDealID")
                        {
                            strHTMLBuilder.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            strHTMLBuilder.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder.Append("</td>");
                        }
                    }
                    strHTMLBuilder.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("</body>");
                strHTMLBuilder.Append("</html>");
                Htmltext = strHTMLBuilder.ToString();
            }
            //Exitfee table
            StringBuilder strHTMLBuilder1 = new StringBuilder();
            if (dt1.Rows.Count > 0)
            {

                strHTMLBuilder1.Append("<html >");
                strHTMLBuilder1.Append("<head>");
                strHTMLBuilder1.Append("</head>");
                strHTMLBuilder1.Append("<body>");
                strHTMLBuilder1.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder1.Append("<tr id='trHeader'>");


                foreach (DataColumn myColumn in dt1.Columns)
                {
                    if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "CREDealID")
                    {
                        strHTMLBuilder1.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                        strHTMLBuilder1.Append(myColumn.ColumnName);
                        strHTMLBuilder1.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder1.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                        strHTMLBuilder1.Append(myColumn.ColumnName);
                        strHTMLBuilder1.Append("</td>");
                    }
                }
                strHTMLBuilder1.Append("</tr>");


                foreach (DataRow myRow in dt1.Rows)
                {

                    strHTMLBuilder1.Append("<tr >");
                    foreach (DataColumn myColumn in dt1.Columns)
                    {
                        if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "CREDealID")
                        {
                            strHTMLBuilder1.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder1.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder1.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder1.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            strHTMLBuilder1.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder1.Append("</td>");
                        }
                    }
                    strHTMLBuilder1.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder1.Append("</table>");
                strHTMLBuilder1.Append("</body>");
                strHTMLBuilder1.Append("</html>");
                Htmltext1 = strHTMLBuilder1.ToString();
            }

            //FFbetweenBackshopandM61Table
            StringBuilder strHTMLBuilder2 = new StringBuilder();
            if (dt2.Rows.Count > 0)
            {

                strHTMLBuilder2.Append("<html >");
                strHTMLBuilder2.Append("<head>");
                strHTMLBuilder2.Append("</head>");
                strHTMLBuilder2.Append("<body>");
                strHTMLBuilder2.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder2.Append("<tr id='trHeader'>");


                foreach (DataColumn myColumn in dt2.Columns)
                {
                    if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "CRENoteID")
                    {
                        strHTMLBuilder2.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                        strHTMLBuilder2.Append(myColumn.ColumnName);
                        strHTMLBuilder2.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder2.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                        strHTMLBuilder2.Append(myColumn.ColumnName);
                        strHTMLBuilder2.Append("</td>");
                    }
                }
                strHTMLBuilder1.Append("</tr>");


                foreach (DataRow myRow in dt2.Rows)
                {

                    strHTMLBuilder2.Append("<tr >");
                    foreach (DataColumn myColumn in dt2.Columns)
                    {
                        if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "CRENoteID")
                        {
                            strHTMLBuilder2.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder2.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder2.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder2.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            strHTMLBuilder2.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder2.Append("</td>");
                        }
                    }
                    strHTMLBuilder2.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder2.Append("</table>");
                strHTMLBuilder2.Append("</body>");
                strHTMLBuilder2.Append("</html>");
                Htmltext2 = strHTMLBuilder2.ToString();
            }

            ///new 
            StringBuilder strHTMLBuilder3 = new StringBuilder();
            if (dt3.Rows.Count > 0)
            {

                strHTMLBuilder3.Append("<html >");
                strHTMLBuilder3.Append("<head>");
                strHTMLBuilder3.Append("</head>");
                strHTMLBuilder3.Append("<body>");
                strHTMLBuilder3.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder3.Append("<tr id='trHeader'>");


                foreach (DataColumn myColumn in dt3.Columns)
                {
                    if (myColumn.ColumnName == "DealID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "NoteID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Name")
                    {
                        strHTMLBuilder3.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                        strHTMLBuilder3.Append(myColumn.ColumnName);
                        strHTMLBuilder3.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder3.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                        strHTMLBuilder3.Append(myColumn.ColumnName);
                        strHTMLBuilder3.Append("</td>");
                    }
                }
                strHTMLBuilder2.Append("</tr>");


                foreach (DataRow myRow in dt3.Rows)
                {

                    strHTMLBuilder3.Append("<tr >");
                    foreach (DataColumn myColumn in dt3.Columns)
                    {
                        if (myColumn.ColumnName == "DealID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "NoteID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Name")
                        {
                            strHTMLBuilder3.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder3.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder3.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder3.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            strHTMLBuilder3.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder3.Append("</td>");
                        }
                    }
                    strHTMLBuilder3.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder3.Append("</table>");
                strHTMLBuilder3.Append("</body>");
                strHTMLBuilder3.Append("</html>");
                Htmltext3 = strHTMLBuilder3.ToString();
            }


            //Table4
            StringBuilder strHTMLBuilder4 = new StringBuilder();
            if (dt4.Rows.Count > 0)
            {

                strHTMLBuilder4.Append("<html >");
                strHTMLBuilder4.Append("<head>");
                strHTMLBuilder4.Append("</head>");
                strHTMLBuilder4.Append("<body>");
                strHTMLBuilder4.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder4.Append("<tr id='trHeader'>");


                foreach (DataColumn myColumn in dt4.Columns)
                {
                    if (myColumn.ColumnName == "DealID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "NoteID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Name")
                    {
                        strHTMLBuilder4.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                        strHTMLBuilder4.Append(myColumn.ColumnName);
                        strHTMLBuilder4.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder4.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                        strHTMLBuilder4.Append(myColumn.ColumnName);
                        strHTMLBuilder4.Append("</td>");
                    }
                }
                strHTMLBuilder3.Append("</tr>");


                foreach (DataRow myRow in dt4.Rows)
                {

                    strHTMLBuilder4.Append("<tr >");
                    foreach (DataColumn myColumn in dt4.Columns)
                    {
                        if (myColumn.ColumnName == "DealID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "NoteID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Name")
                        {
                            strHTMLBuilder4.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder4.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder4.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder4.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            strHTMLBuilder4.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder4.Append("</td>");
                        }
                    }
                    strHTMLBuilder4.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder4.Append("</table>");
                strHTMLBuilder4.Append("</body>");
                strHTMLBuilder4.Append("</html>");
                Htmltext4 = strHTMLBuilder4.ToString();
            }

            //Table5
            StringBuilder strHTMLBuilder5 = new StringBuilder();
            if (dt5.Rows.Count > 0)
            {

                strHTMLBuilder5.Append("<html >");
                strHTMLBuilder5.Append("<head>");
                strHTMLBuilder5.Append("</head>");
                strHTMLBuilder5.Append("<body>");
                strHTMLBuilder5.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder5.Append("<tr id='trHeader'>");


                foreach (DataColumn myColumn in dt5.Columns)
                {
                    if (myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "DealName")
                    {
                        strHTMLBuilder5.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                        strHTMLBuilder5.Append(myColumn.ColumnName);
                        strHTMLBuilder5.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder5.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                        strHTMLBuilder5.Append(myColumn.ColumnName);
                        strHTMLBuilder5.Append("</td>");
                    }
                }
                strHTMLBuilder4.Append("</tr>");


                foreach (DataRow myRow in dt5.Rows)
                {

                    strHTMLBuilder5.Append("<tr >");
                    foreach (DataColumn myColumn in dt5.Columns)
                    {
                        if (myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "DealName")
                        {
                            strHTMLBuilder5.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder5.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder5.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder5.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            strHTMLBuilder5.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder5.Append("</td>");
                        }
                    }
                    strHTMLBuilder5.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder5.Append("</table>");
                strHTMLBuilder5.Append("</body>");
                strHTMLBuilder5.Append("</html>");
                Htmltext5 = strHTMLBuilder5.ToString();
            }

            //Table6
            StringBuilder strHTMLBuilder6 = new StringBuilder();
            if (dt6.Rows.Count > 0)
            {

                strHTMLBuilder6.Append("<html >");
                strHTMLBuilder6.Append("<head>");
                strHTMLBuilder6.Append("</head>");
                strHTMLBuilder6.Append("<body>");
                strHTMLBuilder6.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder6.Append("<tr id='trHeader'>");


                foreach (DataColumn myColumn in dt6.Columns)
                {
                    if (myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "DealName" || myColumn.ColumnName == "NoteID" || myColumn.ColumnName == "notename" || myColumn.ColumnName == "Date")
                    {
                        strHTMLBuilder6.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                        strHTMLBuilder6.Append(myColumn.ColumnName);
                        strHTMLBuilder6.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder6.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                        strHTMLBuilder6.Append(myColumn.ColumnName);
                        strHTMLBuilder6.Append("</td>");
                    }
                }
                strHTMLBuilder5.Append("</tr>");


                foreach (DataRow myRow in dt6.Rows)
                {

                    strHTMLBuilder6.Append("<tr >");
                    foreach (DataColumn myColumn in dt6.Columns)
                    {
                        if (myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "DealName" || myColumn.ColumnName == "NoteID" || myColumn.ColumnName == "notename" || myColumn.ColumnName == "Date")
                        {
                            strHTMLBuilder6.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder6.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder6.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder6.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            strHTMLBuilder6.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder6.Append("</td>");
                        }
                    }
                    strHTMLBuilder6.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder6.Append("</table>");
                strHTMLBuilder6.Append("</body>");
                strHTMLBuilder6.Append("</html>");
                Htmltext6 = strHTMLBuilder6.ToString();
            }

            string htmlContent = string.Empty;
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }

            if (!string.IsNullOrEmpty(linkName))
                htmlContent = htmlContent.Replace("{link}", linkName);
            htmlContent = htmlContent.Replace("{URL}", EmailBaseUrl);
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
            htmlContent = htmlContent.Replace("{messagesummary}", bodyText.ToString());
            if (Htmltext.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{discrepancytitle}", "Funding Discrepancy");
                htmlContent = htmlContent.Replace("{message}", Htmltext.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{discrepancytitle}", "Funding Discrepancy");
                htmlContent = htmlContent.Replace("{message}", "No discrepancy found.");
            }
            if (Htmltext1.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{exitfeetitle}", "Exit/Extension Fee Stripping/Receivable Discrepancy");
                htmlContent = htmlContent.Replace("{message1}", Htmltext1.ToString());
            }
            else
            {

                htmlContent = htmlContent.Replace("{exitfeetitle}", "Exit/Extension Fee Stripping/Receivable Discrepancy");
                htmlContent = htmlContent.Replace("{message1}", "No discrepancy found.");
            }
            if (Htmltext2.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{FFBetweenM61andBackshoptitle}", "Future Funding Discrepancy Between M61 and Backshop");
                htmlContent = htmlContent.Replace("{message2}", Htmltext2.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{FFBetweenM61andBackshoptitle}", "Future Funding Discrepancy Between M61 and Backshop");
                htmlContent = htmlContent.Replace("{message2}", "No discrepancy found.");
            }

            if (Htmltext3.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{CommitmentDiscrepancytitle}", "Commitment Discrepancy");
                htmlContent = htmlContent.Replace("{message3}", Htmltext3.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{CommitmentDiscrepancytitle}", "Commitment Discrepancy");
                htmlContent = htmlContent.Replace("{message3}", "No discrepancy found.");
            }

            if (Htmltext4.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{CommitmentDiscrepancyDatatitle}", "Commitment Discrepancy Data");
                htmlContent = htmlContent.Replace("{message4}", Htmltext4.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{CommitmentDiscrepancyDatatitle}", "Commitment Discrepancy Data");
                htmlContent = htmlContent.Replace("{message4}", "No discrepancy data found.");
            }
            if (Htmltext5.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{Eligibledealsautospreadtitle}", "Eligible deals to autospread");
                htmlContent = htmlContent.Replace("{message5}", Htmltext5.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{Eligibledealsautospreadtitle}", "Eligible deals to autospread");
                htmlContent = htmlContent.Replace("{message5}", "No discrepancy data found.");
            }
            if (Htmltext6.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{EPBetweenM61andBackshoptitle}", "Export Paydown Between M61 and Backshop");
                htmlContent = htmlContent.Replace("{message6}", Htmltext6.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{EPBetweenM61andBackshoptitle}", "Export Paydown Between M61 and Backshop");
                htmlContent = htmlContent.Replace("{message6}", "No discrepancy data found.");
            }
            //send email
            EmailSender.SendTOEmail(fromEmail, toEmail, null, subject, null, null, htmlContent);
        }
        public void BatchUploadSummaryNotification(List<GenericVSTOResult> list, string summary, string username)
        {
            GetConfigSetting();
            UserRepository _userRepository = new UserRepository();
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string showlink = linkName.Substring(4);
            string subject = "(" + showlink + ")" + " Automated Batch Upload Summary Notification";
            int moduleId = 683;
            string toEmail = "";
            List<string> emailidsCC = _userRepository.GetEmailIdsByModule(moduleId);
            toEmail = _userRepository.GetUserEmailByUserName(username);
            string fromEmail = "test@test.com";
            string HtmlTemplateName = "BatchUploadSummary.html";
            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            //manish
            StringBuilder strHTMLBuilder = new StringBuilder();
            //Deal and Note Discrpancy
            if (list.Count > 0)
            {
                strHTMLBuilder.Append("<html >");
                strHTMLBuilder.Append("<head>");
                strHTMLBuilder.Append("</head>");
                strHTMLBuilder.Append("<body>");
                strHTMLBuilder.Append("<table id='BatchUploadSummary'>");
                strHTMLBuilder.Append("<tr id='trHeader'>");
                strHTMLBuilder.Append("<td>CRE NoteID</td><td>Comment(s)</td>");

                foreach (var item in list)
                {
                    strHTMLBuilder.Append("</tr>");

                    strHTMLBuilder.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                    strHTMLBuilder.Append(item.CRENoteID.ToString());
                    strHTMLBuilder.Append("</td>");

                    strHTMLBuilder.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                    strHTMLBuilder.Append(item.Comment.ToString());
                    strHTMLBuilder.Append("</td>");

                    strHTMLBuilder.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("</body>");
                strHTMLBuilder.Append("</html>");
            }

            string Htmltext = strHTMLBuilder.ToString();

            string htmlContent = string.Empty;
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            if (!string.IsNullOrEmpty(linkName))
                htmlContent = htmlContent.Replace("{link}", linkName);
            htmlContent = htmlContent.Replace("{URL}", EmailBaseUrl);
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);

            if (Htmltext.ToString() != null)
            {
                htmlContent = htmlContent.Replace("{message}", Htmltext.ToString());
                htmlContent = htmlContent.Replace("{uploadsummary}", summary);

            }
            //send email
            EmailSender.SendTOEmail(fromEmail, new[] { toEmail }, emailidsCC, subject, null, null, htmlContent);

        }
        public void SendEmailForceFundingNotification(List<WFNotificationDataContract> lstWFNoti, string DealName, DateTime FundingDate, int days)
        {
            GetConfigSetting();
            string[] emailidsTo = null;//new string[20];
            string[] emailidsCC = null;
            string htmlContent = string.Empty;
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            string Taskid = "", workflowUrl = "";
            int? TaskTypeID = 0;
            string subject = "REMINDER – Force Funding on " + DealName + " Loan Schedule for " + FundingDate.Date.ToShortDateString();
            string HtmlTemplateName = "ForceFundingnotification.html";
            StringBuilder bodyText = new StringBuilder();
#pragma warning disable CS0219 // The variable 'reminder' is assigned but its value is never used
            string message = "", reminder = "";
#pragma warning restore CS0219 // The variable 'reminder' is assigned but its value is never used
            //  emailidsTo = lstWFNoti;

            var lstWFNotiCC = lstWFNoti.Where(r => r.TaskID == "00000000-0000-0000-0000-000000000000");
            var lstWFNotiTo = lstWFNoti.Where(r => r.TaskID != "00000000-0000-0000-0000-000000000000");

            emailidsTo = lstWFNotiTo.Select(r => r.Email).ToArray();
            emailidsCC = lstWFNotiCC.Select(r => r.Email).ToArray();

            Taskid = lstWFNotiTo.ToArray()[0].TaskID;
            TaskTypeID = lstWFNotiTo.ToArray()[0].TaskType_ID;

            //for (var i = 0; i < lstWFNoti.Count; i++)
            //{
            //    if (lstWFNoti[i].DealID == "00000000-0000-0000-0000-000000000000")
            //        emailidsCC[i] = lstWFNoti[i].Email;
            //    else
            //        emailidsTo[i] = lstWFNoti[i].Email;
            //}



            //using streamreader for reading my htmltemplate   
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }

            NoteLogic _NoteLogic = new NoteLogic();
            List<HolidayListDataContract> _HolidayList = new List<HolidayListDataContract>();
            _HolidayList = _NoteLogic.GetHolidayList();

            string BaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            var tom = DateTime.Today;
            DateTime dtnxtdate = DateExtensions.CreateNewDate(tom.Year, tom.Month, tom.Day);
            DateTime tomorrow = DateExtensions.GetnextWorkingDays(dtnxtdate, Convert.ToInt16(1), "US", _HolidayList).Date;


            workflowUrl = BaseUrl + "#/workflowdetail/" + Taskid + "/" + TaskTypeID;
            if (days == 10 || days == 5)
                message = " The below Force Funding is scheduled " + days + " BDs from today.This is a reminder to send out the Preliminary Capital Call. Click <a href=" + workflowUrl + ">here</a> to send.";
            if (days == 3)
                message = " The below Force Funding is scheduled " + days + " BDs from today.This is a reminder to ensure the Final Capital Call is sent out tomorrow (" + tomorrow.ToString("MM-dd-yyyy").Replace("-", "/") + "). Click <a href=" + workflowUrl + ">here</a> to view this transaction in M61.";

            htmlContent = htmlContent.Replace("{message}", message);

            //

            string dealdetail = "<tr><td>" + lstWFNotiTo.ToArray()[0].DealName + "</td><td>" + lstWFNotiTo.ToArray()[0].FundingDate.ToString("MM-dd-yyyy").Replace("-", "/") + "</td><td>" + String.Format("{0:c}", lstWFNotiTo.ToArray()[0].FundingAmount) + "</td><td>" + lstWFNotiTo.ToArray()[0].DealLine.ToString("MM-dd-yyyy").Replace("-", "/") + "</td></tr>";

            htmlContent = htmlContent.Replace("{dealdetail}", dealdetail);
            htmlContent = htmlContent.Replace("{activitylog}", lstWFNotiTo.ToArray()[0].ActivityLog);
            htmlContent = htmlContent.Replace("{drawapprovallist}", lstWFNotiTo.ToArray()[0].DwarApprovalList);
            htmlContent = htmlContent.Replace("{SpecialInstructions}", lstWFNotiTo.ToArray()[0].SpecialInstructions);
            htmlContent = htmlContent.Replace("{AdditionalComments}", lstWFNotiTo.ToArray()[0].AdditionalComments);
            htmlContent = htmlContent.Replace("{noteswithAmount}", lstWFNotiTo.ToArray()[0].NoteswithAmount);
            EmailSender.SendTOCCEmail(fromEmail, emailidsTo, emailidsCC.ToList(), subject, bodyText.ToString(), UserName, htmlContent);

        }
        public void SendInvoiceNotification(DrawFeeInvoiceDataContract DrawFeeDC)
        {
            GetConfigSetting();
#pragma warning disable CS0219 // The variable 'password' is assigned but its value is never used
            string password = "admin1*";
#pragma warning restore CS0219 // The variable 'password' is assigned but its value is never used
            string fromEmail = "no-reply@m61systems.com";
            string UserName = "Admin";
            List<string> emailidsBCC = new List<string>();
            string subject = "ACORE Draw Fee Invoice - " + DrawFeeDC.DealName + " - " + DrawFeeDC.InvoiceNoUI;

            string HtmlTemplateName = "DrawFeeNotification.html";
            StringBuilder bodyText = new StringBuilder();

            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            // string linkName = "M61-QA";
            string linkName = Sectionroot.GetSection("ContactEmail").Value;
            string htmlContentMain = string.Empty;
            string htmlContent = string.Empty;
            //using streamreader for reading my htmltemplate 
            if (!String.IsNullOrEmpty(DrawFeeDC.AMEmails))
            {
                DrawFeeDC.Email2 = DrawFeeDC.Email2.Replace(";", ",") + ',' + DrawFeeDC.AMEmails;
            }

            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/InvoiceTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }

            WFLogic wl = new WFLogic();
            DrawFeeInvoiceDataContract dcPAM = wl.GetDealPrimaryAM(DrawFeeDC.DrawFeeInvoiceDetailID, "");
            if (dcPAM != null && !string.IsNullOrEmpty(dcPAM.SenderFirstName))
            {
                DrawFeeDC.SenderFirstName = dcPAM.SenderFirstName;
                DrawFeeDC.SenderLastName = dcPAM.SenderLastName;
                DrawFeeDC.SenderEmail = dcPAM.SenderEmail;
            }

            if (!string.IsNullOrEmpty(DrawFeeDC.FirstName))
                htmlContent = htmlContent.Replace("{firstname}", DrawFeeDC.FirstName);
            htmlContent = htmlContent.Replace("{drawComment}", DrawFeeDC.DrawNo);
            htmlContent = htmlContent.Replace("{sendername}", (DrawFeeDC.SenderFirstName + " " + DrawFeeDC.SenderLastName).Trim());
            htmlContent = htmlContent.Replace("{senderemail}", DrawFeeDC.SenderEmail);
            htmlContent = htmlContent.Replace("{fundingamount}", String.Format("{0:C}", DrawFeeDC.FundingAmount));
            htmlContent = htmlContent.Replace("{fundingdate}", DrawFeeDC.FundingDate.ToStringWithOrdinal("dddd, MMMM dnn, yyyy"));

            string replyTo = (DrawFeeDC.Email1.Trim().Replace(";", ",") + "," + DrawFeeDC.Email2.Replace(";", ",")).Trim().Trim(',');
            //send email
            //EmailSender.SendEmailTOCCWithAttachment(fromEmail, DrawFeeDC.Email1.Trim().Split(','), DrawFeeDC.Email2.Trim().Split(','), subject, UserName, htmlContent, DrawFeeDC.filestream.ToArray(), DrawFeeDC.FileName);
            EmailSender.SendEmailTOCCReplyToWithAttachment(fromEmail, DrawFeeDC.Email1.Replace(";", ",").Trim().Split(','), DrawFeeDC.Email2.Replace(";", ",").Trim().Split(','), replyTo.Split(','), subject, UserName, htmlContent, DrawFeeDC.filestream.ToArray(), DrawFeeDC.FileName);

        }
        public string TestCheckAppPath()
        {
            try
            {
                return _hostingEnvironment.ContentRootPath;
            }
            catch (Exception ex)
            {
                return ex.Message;
            }

        }
        public void SendWFNotificationForNegativeAmt(WFNotificationDetailDataContract wfDetail, out string htmlContent)
        {
            GetConfigSetting();
#pragma warning disable CS0219 // The variable 'password' is assigned but its value is never used
            string password = "admin1*";
#pragma warning restore CS0219 // The variable 'password' is assigned but its value is never used
#pragma warning disable CS0219 // The variable 'fromEmail' is assigned but its value is never used
            string fromEmail = "test@test.com";
#pragma warning restore CS0219 // The variable 'fromEmail' is assigned but its value is never used
            string UserName = "Admin";
            List<string> emailidsBCC = new List<string>();
#pragma warning disable CS0219 // The variable 'subject' is assigned but its value is never used
            string subject = "";
#pragma warning restore CS0219 // The variable 'subject' is assigned but its value is never used


            StringBuilder bodyText = new StringBuilder();

            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            // string linkName = "M61-QA";
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string htmlContentMain = string.Empty;
            htmlContent = string.Empty;
            //using streamreader for reading my htmltemplate   

            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + wfDetail.TemplateFileName))
            {
                htmlContentMain = reader.ReadToEnd();
            }
            htmlContent = htmlContentMain;
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
            if (!string.IsNullOrEmpty(linkName))
                htmlContent = htmlContent.Replace("{link}", linkName);
            htmlContent = htmlContent.Replace("{bodytext}", wfDetail.MessageHTML);
            htmlContent = htmlContent.Replace("{sendername}", wfDetail.UserName);

            //send email
            EmailSender.SendEmailTOCCWithAttachment(wfDetail.ReplyTo, wfDetail.EmailToIds.Trim().Split(','), wfDetail.EmailCCIds.Trim().Split(','), wfDetail.Subject, UserName, htmlContent, new byte[0], "");

        }
        public string SendErrorNotificationEmail(EmailDataContract emailDC)
        {
            string HtmlTemplateName = "EmailErrorNotification.html";
            UserRepository _userRepository = new UserRepository();
            string htmlContent = string.Empty;
            string fromEmail = "no-reply@m61systems.com";
            string Message = "";
            try
            {
                //using streamreader for reading my htmltemplate   

                if (emailDC != null)
                {
                    //using streamreader for reading my htmltemplate   
                    using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
                    {
                        htmlContent = reader.ReadToEnd();
                    }
                    if (!string.IsNullOrEmpty(emailDC.ReceiverName))
                        htmlContent = htmlContent.Replace("{UserName}", emailDC.ReceiverName);
                    if (!string.IsNullOrEmpty(emailDC.Body))
                        htmlContent = htmlContent.Replace("{bodytext}", emailDC.Body);
                    string[] files = "".Split(',');
                    List<string> emailToids = _userRepository.GetEmailIdsByModule(emailDC.ModuleId);
                    if (emailToids != null && emailToids.Count > 0)
                    {
                        emailDC.To = string.Join(",", emailToids);
                    }

                    emailDC.Cc = emailDC.Cc ?? "";
                    emailDC.Bcc = emailDC.Bcc ?? "";
                    emailDC.ReplyTo = emailDC.ReplyTo ?? "";
                    emailDC.Subject = emailDC.Subject ?? "";
                    if (emailDC.FileAttachment != null)
                    {
                        files = emailDC.FileAttachment.Select(i => i.FilePath).ToArray();
                    }
                    EmailSender.SendTOCCEmail(fromEmail, emailDC.To.Trim().Split(','), emailDC.Cc.Trim().Split(',').ToList(), emailDC.Subject, "", "", htmlContent);

                    Message = "Email sent succeeded";
                }
            }
            catch (Exception ex)
            {
                Message = ex.Message;
            }
            return Message;
        }
        public void SendEmailBackshopFailed(string Userid, string exceptionMessage)
        {
            GetConfigSetting();
            UserLogic ul = new UserLogic();
            UserDataContract _userdatacontract = ul.GetUserCredentialByUserID(new Guid(Userid), new Guid("00000000-0000-0000-0000-000000000000"));
            string[] toEmail = null;
            UserRepository _userRepository = new UserRepository();
            string subject = "Backshop Import Failed";// + DealDC.DealName;
            string fromEmail = "test@test.com";
            //string UserName = "Admin";
            string HtmlTemplateName = "BackshopFailedEmail.html";
            StringBuilder bodyText = new StringBuilder();
            int moduleId = 706;
            toEmail = _userRepository.GetEmailIdsByModule(moduleId).ToArray();
            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string htmlContent = string.Empty;

            //using streamreader for reading my htmltemplate  
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            htmlContent = htmlContent.Replace("{shortmessage}", exceptionMessage);
            if (!string.IsNullOrEmpty(linkName))
            {
                subject = "(" + linkName.Remove(0, 4) + ")" + subject;
                htmlContent = htmlContent.Replace("{link}", linkName);
            }
            htmlContent = htmlContent.Replace("{username}", CultureInfo.CurrentCulture.TextInfo.ToTitleCase(_userdatacontract.FirstName));
            //send email
            EmailSender.SendTOEmail(fromEmail, toEmail, null, subject, bodyText.ToString(), null, htmlContent);

        }
        public string SendInvoiceSyncNotification(EmailDataContract emailDC)
        {
            string HtmlTemplateName = "InvoiceSyncNotification.html";
            UserRepository _userRepository = new UserRepository();
            string htmlContent = string.Empty;
            string fromEmail = "no-reply@m61systems.com";
            string Message = "";
            try
            {
                //using streamreader for reading my htmltemplate   

                if (emailDC != null)
                {
                    //using streamreader for reading my htmltemplate   
                    using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/InvoiceTemplate/" + HtmlTemplateName))
                    {
                        htmlContent = reader.ReadToEnd();
                    }
                    if (!string.IsNullOrEmpty(emailDC.ReceiverName))
                        htmlContent = htmlContent.Replace("{UserName}", emailDC.ReceiverName);
                    if (!string.IsNullOrEmpty(emailDC.Body))
                        htmlContent = htmlContent.Replace("{bodytext}", emailDC.Body);
                    string[] files = "".Split(',');
                    List<string> emailToids = _userRepository.GetEmailIdsByModule(emailDC.ModuleId);
                    if (emailToids != null && emailToids.Count > 0)
                    {
                        emailDC.To = string.Join(",", emailToids);
                    }

                    emailDC.Cc = emailDC.Cc ?? "";
                    emailDC.Bcc = emailDC.Bcc ?? "";
                    emailDC.ReplyTo = emailDC.ReplyTo ?? "";
                    emailDC.Subject = emailDC.Subject ?? "";
                    if (emailDC.FileAttachment != null)
                    {
                        files = emailDC.FileAttachment.Select(i => i.FilePath).ToArray();
                    }
                    EmailSender.SendTOCCEmail(fromEmail, emailDC.To.Trim().Split(','), emailDC.Cc.Trim().Split(',').ToList(), emailDC.Subject, "", "", htmlContent);

                    Message = "Email sent succeeded";
                }
            }
            catch (Exception ex)
            {
                Message = ex.Message;
            }
            return Message;
        }

        public void SendNonFullPayoffDealDiscrepancy(DataTable dt)
        {
            GetConfigSetting();
            string[] emailidsTo = null;
            string[] emailidsCC = null;
            UserRepository _userRepository = new UserRepository();
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string showlink = linkName.Substring(4);
            string subject = "(" + showlink + ")" + " Eligible deals to autospread";
            int moduleId = 781; //632,781
            List<EmailDataContract> lstEmailIDs = new List<EmailDataContract>();
            if (dt == null || dt.Rows.Count == 0)
                return;

            if (dt.Rows.Count > 0)
            {
                lstEmailIDs = _userRepository.GetEmailIdsByModuleandType(moduleId);
                //  toEmail = _userRepository.GetEmailIdsByModule(moduleId).ToArray();
                var lstEmailIdsTobyType = lstEmailIDs.Where(r => r.Type == 782);
                var lstEmailIdsCcbyType = lstEmailIDs.Where(r => r.Type == 783);

                emailidsTo = lstEmailIdsTobyType.Select(r => r.EmailID).ToArray();
                emailidsCC = lstEmailIdsCcbyType.Select(r => r.EmailID).ToArray();
                string Htmltext = "";

                string fromEmail = "test@test.com";
                string HtmlTemplateName = "DealNonFullPayoffDiscrepancy.html";
                string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
                StringBuilder strHTMLBuilder = new StringBuilder();
                //Non full payoff deal Discrpancy
                string dealurl;
                foreach (DataRow myRow in dt.Rows)
                {
                    dealurl = EmailBaseUrl + "#/dealdetail/" + myRow["CREDealID"].ToString();
                    strHTMLBuilder.Append("<tr>");
                    strHTMLBuilder.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important;border:1px;border-style:solid; >");
                    strHTMLBuilder.Append("<a href=" + dealurl + ">" + myRow["DealName"].ToString() + "</a>");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important;border:1px;border-style:solid; >");
                    strHTMLBuilder.Append(myRow["CREDealID"].ToString());
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style=text-align:right;padding-left:5px!important;padding-right:5px!important;border:1px;border-style:solid; >");
                    strHTMLBuilder.Append(myRow["FullPayOffDate"].ToString());
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                }
                Htmltext = strHTMLBuilder.ToString();

                string htmlContent = string.Empty;
                using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
                {
                    htmlContent = reader.ReadToEnd();
                }
                if (Htmltext.ToString() != "")
                {
                    htmlContent = htmlContent.Replace("{message}", Htmltext.ToString());
                }
                //send email
                EmailSender.SendTOCCEmail(fromEmail, emailidsTo, emailidsCC.ToList(), subject, null, null, htmlContent);
                // EmailSender.SendTOEmail(fromEmail, toEmail, null, subject, null, null, htmlContent);
            }
        }

        public void CancelNotification(List<WFNotificationDataContract> wfDetail)
        {
            GetConfigSetting();
#pragma warning disable CS0219 // The variable 'password' is assigned but its value is never used
            string password = "admin1*";
#pragma warning restore CS0219 // The variable 'password' is assigned but its value is never used
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            List<string> emailidsBCC = new List<string>();
            string subject = "Reserve Draw approval request" + " - " + wfDetail[0].DealName + " - " + wfDetail[0].Comment;

            if (!string.IsNullOrEmpty(wfDetail[0].PreHeaderText))
            {
                subject = wfDetail[0].PreHeaderText + " - " + subject;
            }
            string HtmlTemplateNameIntenullGroup = "ReserveInternalNotification.html";
            StringBuilder bodyText = new StringBuilder();

            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string contactEmail = Sectionroot.GetSection("ContactEmail").Value;
            // string linkName = "M61-QA";
            string linkName = Sectionroot.GetSection("ContactEmail").Value;
            string htmlContentMain = string.Empty;
            string htmlContent = string.Empty;
            //using streamreader for reading my htmltemplate   

            #region "Internull Group"
            List<WFNotificationDataContract> wfDetailWorkflowInternullGroup = wfDetail.FindAll(x => x.WorkflowUserTypeID == 0);

            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateNameIntenullGroup))
            {
                htmlContentMain = reader.ReadToEnd();
            }
            foreach (WFNotificationDataContract lst in wfDetailWorkflowInternullGroup)
            {
                htmlContent = htmlContentMain;
                string dealdetail = "<tr><td>" + lst.DealName + "</td><td>" + lst.FundingDate.ToString("MM/dd/yyyy") + "</td><td>" + String.Format("{0:C}", lst.FundingAmount) + "</td></tr>";
                htmlContent = htmlContent.Replace("{username}", CultureInfo.CurrentCulture.TextInfo.ToTitleCase(lst.UserName));
                htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
                if (!string.IsNullOrEmpty(linkName))
                    htmlContent = htmlContent.Replace("{link}", linkName);
                string clickhere = "<a target='_blank' href=" + EmailBaseUrl.TrimEnd('/') + "/#/workflowdetail/" + lst.TaskID + "/" + lst.TaskTypeID + " >here</a> ";
                htmlContent = htmlContent.Replace("{clickhere}", clickhere);
                htmlContent = htmlContent.Replace("{nextstatusname}", lst.NextStatusName);
                htmlContent = htmlContent.Replace("{reservebreakDown}", lst.ReserveScheduleBreakDown);
                htmlContent = htmlContent.Replace("{dealdetail}", dealdetail);
                htmlContent = htmlContent.Replace("{activitylog}", lst.ActivityLog);
                htmlContent = htmlContent.Replace("{footer}", lst.FooterText);
                htmlContent = htmlContent.Replace("{sendername}", lst.SenderName);
                htmlContent = htmlContent.Replace("{drawapprovallist}", lst.DwarApprovalList);
                htmlContent = htmlContent.Replace("{SpecialInstructions}", lst.SpecialInstructions);
                htmlContent = htmlContent.Replace("{AdditionalComments}", lst.AdditionalComments);
                //send email
                EmailSender.SendTOEmail(fromEmail, new[] { lst.Email }, emailidsBCC, subject, bodyText.ToString(), UserName, htmlContent);
            }
            #endregion
        }

    }

}
