using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.Utilities;
using CRES.DAL.Repository;
using CRES.DataContract;
using System.Configuration;
using System.IO;
using System.Globalization;
using CRES.DataContract.WorkFlow;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using CRES.BusinessLogic;
using System.Data;
using System.Xml;
using OfficeOpenXml.FormulaParsing.Excel.Functions.DateTime;
using Microsoft.Extensions.Primitives;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Text;
using Newtonsoft.Json;
using Syncfusion.DocIO.DLS;
using System.Text.RegularExpressions;
using System.Net.Http;

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
        void SendDealFundingandNoteFundingDiscrepancy(DataTable dt, int rowcount, DataTable dt1, int rowcount1, DataTable dt2, int rowcount2, DataTable dt3, int rowcount3, DataTable dt4, int rowcount4, DataTable dt5, int rowcount5, DataTable dt6, int rowcount6, DataTable dt7, int rowcount7, DataTable dt8, int rowcount8, DataTable dt9, int rowcount9, DataTable dt10, int rowcount10, DataTable dt11, int rowcount11, DataTable dt12, int rowcount12, DataTable dt13, int rowcount13, DataTable dt14, int rowcount14, DataTable dt15, int rowcount15, DataTable dt16, int rowcount16, DataTable dt17, int rowcount17, DataTable dt18, int rowcount18);

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
        void SendEmailForParentClientMissingEmailId(DataTable dt);
        void SendAutoConfirmAmortization(DataTable dt, string Type, MemoryStream ms, string filename, DataTable batchdata);

        void SendFundingValidationEmail(MemoryStream ms, string filename, string batchtype, DataTable batchdata);
        void SendEmailOnExceptionFailed(string ModuleName, string exceptionMessage, string shortmessage, string userID, string emailextrainfo);
        void SendErrorListEmail(MemoryStream ms, string filename);
        void SendGenericInvoiceNotification(DrawFeeInvoiceDataContract DrawFeeDC);
        void SendValuationAfterCalculationEmail(DataTable dt, MemoryStream ms, string filename);

        void SendFundingDrawBusinessdayEmails(DataTable dt);
        void SendChathamFinancialDailyRateNotification(string Message, string type, string failorsuccess);
        void SendChathamFinancialQuarterlyForwardRateNotification(string Message, MemoryStream ms, string Filename);
        void SendChathamFinancialDailyRateNotificationSucces(DataTable importeddata, DataTable copiedData, string ratesource);
        void SendBalancediscrepancynotificationtoServicer(DataTable dtwells, DataTable dtBerkadia);
       void SendGenericNotificationEmail(string body, string subjecttext);
       void SendEmailforADFDiscrepancy(DataTable dt);
       void SendEmailforZeroADFDiscrepancy();
       void SendDiscrepancyForCalcGapBtnDefAndFullyScenario(DataTable dt);
       void SendEmailforPrepayPayOffStatementwithAttachment(string EmailID, MemoryStream ms, string Filename, string dealname, string username,string summary);
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
            int moduleId = 347;
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
            //    htmlContent = htmlContent.Replace("{login}", loginid);
            //htmlContent = htmlContent.Replace("{password}", password);
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

            string fromEmail = "test@test.com";
            string HtmlTemplateName = "ExportFFBackshopFailEmailNotification.html";
            StringBuilder bodyText = new StringBuilder();
            int moduleId = 363;

            List<EmailDataContract> lstEmailIDs = new List<EmailDataContract>();
            List<string> emailidsBCC = new List<string>();
            string[] emailidsCC = null;

            lstEmailIDs = _userRepository.GetEmailIdsByModuleandType(moduleId);

            var lstEmailIdsCcbyType = lstEmailIDs.Where(r => r.Type == 783);
            emailidsCC = lstEmailIdsCcbyType.Select(r => r.EmailID).ToArray();

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

            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            if (!string.IsNullOrEmpty(bodyText.ToString()))
                htmlContent = htmlContent.Replace("{message}", bodyText.ToString());
            htmlContent = htmlContent.Replace("{ErrorMessage}", exceptionMessage);

            if (!string.IsNullOrEmpty(linkName))
            {
                htmlContent = htmlContent.Replace("{link}", linkName);
                subject = "(" + linkName.Remove(0, 4) + ")" + subject;
            }

            htmlContent = htmlContent.Replace("{FirstName}", CultureInfo.CurrentCulture.TextInfo.ToTitleCase(_userdatacontract.FirstName));
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);

            //send email             
            EmailSender.SendTOCCEmail(fromEmail, new[] { toEmail }, emailidsCC.ToList(), subject, null, null, htmlContent);
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
            string password = "admin1*";
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
            string password = "admin1*";
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
            string password = "admin1*";
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
            string password = "admin1*";
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
            try
            {
                GetConfigSetting();
                string password = "admin1*";
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
                if (wfDetailWorkflowInternullGroup.Count() > 0)
                {
                    htmlContent = htmlContentMain;
                    var lst = wfDetailWorkflowInternullGroup[0];
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

                    var toEmail = wfDetailWorkflowInternullGroup.Select(x => x.Email).ToArray();


                    try
                    {
                        EmailSender.SendTOEmail(fromEmail, toEmail, emailidsBCC, subject, bodyText.ToString(), UserName, htmlContent);
                    }
                    catch (Exception ex)
                    {
                        LoggerLogic Log = new LoggerLogic();
                        Log.WriteLogException(CRESEnums.Module.WFNotification.ToString(), "Error occurred while SendTOEmail -InternullGroup", "", "", ex.TargetSite.Name.ToString(), "", ex);

                    }

                }

                #endregion

                #region "Additional Group"
                subject = "Draw preview request";
                List<WFNotificationDataContract> wfDetailWorkflowAdditionalGroup = wfDetail.FindAll(x => x.WorkflowUserTypeID == 564);

                using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateNameAdditionalGroup))
                {
                    htmlContentMain = reader.ReadToEnd();
                }

                if (wfDetailWorkflowAdditionalGroup.Count() > 0)
                {

                    htmlContent = htmlContentMain;
                    var lst = wfDetailWorkflowAdditionalGroup[0];
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
                    var toEmail = wfDetailWorkflowAdditionalGroup.Select(x => x.Email).ToArray();

                    //send email
                    try
                    {
                        EmailSender.SendTOEmail(fromEmail, toEmail, emailidsBCC, subject, bodyText.ToString(), UserName, htmlContent);
                    }
                    catch (Exception ex)
                    {
                        LoggerLogic Log = new LoggerLogic();
                        Log.WriteLogException(CRESEnums.Module.WFNotification.ToString(), "Error occurred in SendWorkFlowNotification-SendTOEmail -AdditionalGroup", "", "", ex.TargetSite.Name.ToString(), "", ex);

                    }
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.WFNotification.ToString(), "Error occurred in SendWorkFlowNotification", "", "", ex.TargetSite.Name.ToString(), "", ex);
                throw ex;
            }
            #endregion

        }
        public void SendReserveWorkFlowInternalNotification(List<WFNotificationDataContract> wfDetail)
        {
            try
            {
                GetConfigSetting();
                string password = "admin1*";
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
                if (wfDetailWorkflowInternullGroup.Count() > 0)
                {
                    htmlContent = htmlContentMain;
                    var lst = wfDetailWorkflowInternullGroup[0];
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
                    var toEmail = wfDetailWorkflowInternullGroup.Select(x => x.Email).ToArray();
                    //send email

                    try
                    {
                        EmailSender.SendTOEmail(fromEmail, toEmail, emailidsBCC, subject, bodyText.ToString(), UserName, htmlContent);
                    }
                    catch (Exception ex)
                    {
                        LoggerLogic Log = new LoggerLogic();
                        Log.WriteLogException(CRESEnums.Module.WFNotification.ToString(), "Error occurred in SendReserveWorkFlowInternalNotification-SendTOEmail -InternullGroup", "", "", ex.TargetSite.Name.ToString(), "", ex);

                    }

                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.WFNotification.ToString(), "Error occurred in SendReserveWorkFlowInternalNotification", "", "", ex.TargetSite.Name.ToString(), "", ex);
                throw ex;
            }
            #endregion
        }

        public void SendPeriodicCloseExportFailNotification(PeriodicDataContract _periodicDC)
        {
            GetConfigSetting();
            string password = "admin1*";
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
            string password = "admin1*";
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            List<string> emailidsBCC = new List<string>();
            string subject = "";


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
            //WFLogic wl = new WFLogic();
            //UserDataContract dcPAM = wl.GetDealPrimaryAMByDealOrTaskType("", wfDetail.TaskTypeID, wfDetail.TaskID.ToString(), "");
            //if (dcPAM != null && !string.IsNullOrEmpty(dcPAM.FirstName))
            //{
            //    htmlContent = htmlContent.Replace("{primaryam}", dcPAM.FirstName + " " + dcPAM.LastName);
            //    htmlContent = htmlContent.Replace("{primaryamemail}", dcPAM.Email + (string.IsNullOrEmpty(dcPAM.ContactNo1) ? " | " + dcPAM.ContactNo1 : ""));
            //    htmlContent = htmlContent.Replace("{sendername}", dcPAM.FirstName + " " + dcPAM.LastName);
            //}
            //else
            //{
            //    htmlContent = htmlContent.Replace("{sendername}", wfDetail.UserName);
            //}
            //
            htmlContent = htmlContent.Replace("{sendername}", wfDetail.UserName);
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
            if (!string.IsNullOrEmpty(linkName))
                htmlContent = htmlContent.Replace("{link}", linkName);
            htmlContent = htmlContent.Replace("{bodytext}", wfDetail.MessageHTML);

            if (wfDetail.WFNotificationMasterID == 8 || wfDetail.WFNotificationMasterID == 9)
            {
                string clickhere = "<a target='_blank' href=" + EmailBaseUrl.TrimEnd('/') + "/#/workflowdetail/" + wfDetail.TaskID + "/" + wfDetail.TaskTypeID + " >here</a> ";
                htmlContent = htmlContent.Replace("{clickhere}", clickhere);

                htmlContent = htmlContent.Replace("{dealdetail}", wfDetail.DealDetail);
            }
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
                string password = "admin1*";
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
            string UserName = "Super Admin";
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
            string password = "admin1*";
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
        public void SendDealFundingandNoteFundingDiscrepancy(DataTable dt, int rowcount, DataTable dt1, int rowcount1, DataTable dt2, int rowcount2, DataTable dt3, int rowcount3, DataTable dt4, int rowcount4, DataTable dt5, int rowcount5, DataTable dt6, int rowcount6, DataTable dt7, int rowcount7, DataTable dt8, int rowcount8, DataTable dt9, int rowcount9, DataTable dt10, int rowcount10, DataTable dt11, int rowcount11, DataTable dt12, int rowcount12, DataTable dt13, int rowcount13, DataTable dt14, int rowcount14, DataTable dt15, int rowcount15, DataTable dt16, int rowcount16, DataTable dt17, int rowcount17, DataTable dt18, int rowcount18)
        {
            GetConfigSetting();
            UserRepository _userRepository = new UserRepository();
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string showlink = linkName.Substring(4);
            string subject = "(" + showlink + ")" + " Automated Consolidate Discrepancy Notification";
            int moduleId = 632;

            //string[] toEmail = null;

            List<EmailDataContract> lstEmailIDs = new List<EmailDataContract>();
            string[] emailidsTo = null;
            string[] emailidsCC = null;
            if (dt.Rows.Count > 0 || dt1.Rows.Count > 0 || dt2.Rows.Count > 0 || dt5.Rows.Count > 0 || dt6.Rows.Count > 0 || dt7.Rows.Count > 0 || dt8.Rows.Count > 0 || dt9.Rows.Count > 0 || dt10.Rows.Count > 0 || dt11.Rows.Count > 0 || dt12.Rows.Count > 0 || dt13.Rows.Count > 0 || dt14.Rows.Count > 0 || dt15.Rows.Count > 0 || dt16.Rows.Count > 0 || dt17.Rows.Count > 0 || dt18.Rows.Count > 0)
            {

                //toEmail = _userRepository.GetEmailIdsByModule(moduleId).ToArray();

                lstEmailIDs = _userRepository.GetEmailIdsByModuleandType(moduleId);

                var lstEmailIdsCcbyType = lstEmailIDs.Where(r => r.Type == 783);
                emailidsCC = lstEmailIdsCcbyType.Select(r => r.EmailID).ToArray();

                var lstEmailIdsTObyType = lstEmailIDs.Where(r => r.Type == 782);
                emailidsTo = lstEmailIdsTObyType.Select(r => r.EmailID).ToArray();
            }
            else
            {
                emailidsTo = new[] { "msingh@hvantage.com" };
                emailidsCC = new[] { "msingh@hvantage.com" };

                //toEmail = new[] { "rsahu@hvantage.com" };
            }


            string Htmltext = "";
            string Htmltext1 = "";
            string Htmltext2 = "";
            string Htmltext3 = "";
            string Htmltext4 = "";
            string Htmltext5 = "";
            string Htmltext6 = "";
            string Htmltext7 = "";
            string Htmltext8 = "";
            string Htmltext9 = "";
            string Htmltext10 = "";
            string Htmltext11 = "";
            string Htmltext12 = "";
            string Htmltext13 = "";
            string Htmltext14 = "";
            string Htmltext15 = "";
            string Htmltext16 = "";
            string Htmltext17 = "";
            string Htmltext18 = "";

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
            bodyText.Append("<td style=text-align:left !important;> " + "Funding" + " </td><td style=text-align:right !important;>" + rowcount + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Exit / Extension fee stripping/ Receivable" + " </td><td style=text-align:right !important;>" + rowcount1 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Future funding mismatch between m61 and backshop" + " </td><td style=text-align:right !important;>" + rowcount2 + " </td>");
            bodyText.Append("</tr>");

            //bodyText.Append("<tr>");
            //bodyText.Append("<td style=text-align:left !important;> " + "Commitment Discrepancy" + " </td><td style=text-align:right !important;>" + rowcount3 + " </td>");
            //bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Commitment" + " </td><td style=text-align:right !important;>" + rowcount4 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Eligible deals to autospread" + " </td><td style=text-align:right !important;>" + rowcount5 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Export paydown between m61 and backshop" + " </td><td style=text-align:right !important;>" + rowcount6 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Balance not zeroed out" + " </td><td style=text-align:right !important;>" + rowcount7 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Notes with missing financing source" + " </td><td style=text-align:right !important;>" + rowcount8 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Invoices pending more than 3 BDs" + " </td><td style=text-align:right !important;>" + rowcount9 + " </td>");
            bodyText.Append("</tr>");


            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Record less than current date and not wire confirmed" + " </td><td style=text-align:right !important;>" + rowcount10 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Balance not matching between m61 and backshop" + " </td><td style=text-align:right !important;>" + rowcount11 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Adjusted commitment not matching between m61 and backshop" + " </td><td style=text-align:right !important;>" + rowcount12 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Future funding not matching with unfunded commitment" + " </td><td style=text-align:right !important;>" + rowcount13 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Backshop duplicate PIKNC and PIKPP" + " </td><td style=text-align:right !important;>" + rowcount14 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Notes failed in default scenario" + " </td><td style=text-align:right !important;>" + rowcount15 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Auto spread deals without underwriting update" + " </td><td style=text-align:right !important;>" + rowcount16 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Discrepancy for amort schedule" + " </td><td style=text-align:right !important;>" + rowcount17 + " </td>");
            bodyText.Append("</tr>");

            bodyText.Append("<tr>");
            bodyText.Append("<td style=text-align:left !important;> " + "Discrepancy for duplicate transactions" + " </td><td style=text-align:right !important;>" + rowcount18 + " </td>");
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
                    if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "Deal ID")
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
                        if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "Deal ID")
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
                    if (myColumn.ColumnName == "Scenario" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "Deal ID")
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
                        if (myColumn.ColumnName == "Scenario" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "Deal ID")
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
                    if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "CRENoteID" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Note ID")
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
                        if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "CRENoteID" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Note ID")
                        {
                            strHTMLBuilder2.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder2.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder2.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "M61 Funding Amount" && myRow["M61 Funding Amount"] != DBNull.Value)
                        {
                            strHTMLBuilder2.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder2.Append(formattedCurrency);
                            strHTMLBuilder2.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "BS Funding Amount" && myRow["BS Funding Amount"] != DBNull.Value)
                        {
                            strHTMLBuilder2.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder2.Append(formattedCurrency);
                            strHTMLBuilder2.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "Delta" && myRow["Delta"] != DBNull.Value) // Assuming "M61 Funding Amount" is the column name
                        {
                            strHTMLBuilder2.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder2.Append(formattedCurrency);
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
                    if (myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Name")
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
                        if (myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Name")
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
                    if (myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Name")
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
                        if (myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Name")
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
                    if (myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Pool")
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
                        if (myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Pool")
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
                    if (myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Date") //
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
                strHTMLBuilder6.Append("</tr>");


                foreach (DataRow myRow in dt6.Rows)
                {

                    strHTMLBuilder6.Append("<tr >");
                    foreach (DataColumn myColumn in dt6.Columns)
                    {
                        if (myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Note Name")
                        {
                            strHTMLBuilder6.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder6.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder6.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "M61 Amount" && myRow["M61 Amount"] != DBNull.Value)
                        {
                            strHTMLBuilder6.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder6.Append(formattedCurrency);
                            strHTMLBuilder6.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "BS Amount" && myRow["BS Amount"] != DBNull.Value)
                        {
                            strHTMLBuilder6.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder6.Append(formattedCurrency);
                            strHTMLBuilder6.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "Delta" && myRow["Delta"] != DBNull.Value)
                        {
                            strHTMLBuilder6.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder6.Append(formattedCurrency);
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


            //Table7
            StringBuilder strHTMLBuilder7 = new StringBuilder();
            if (dt7.Rows.Count > 0)
            {

                strHTMLBuilder7.Append("<html >");
                strHTMLBuilder7.Append("<head>");
                strHTMLBuilder7.Append("</head>");
                strHTMLBuilder7.Append("<body>");
                strHTMLBuilder7.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder7.Append("<tr id='trHeader'>");


                foreach (DataColumn myColumn in dt7.Columns)
                {
                    if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Scenario")
                    {
                        strHTMLBuilder7.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                        strHTMLBuilder7.Append(myColumn.ColumnName);
                        strHTMLBuilder7.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder7.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                        strHTMLBuilder7.Append(myColumn.ColumnName);
                        strHTMLBuilder7.Append("</td>");
                    }
                }
                strHTMLBuilder7.Append("</tr>");


                foreach (DataRow myRow in dt7.Rows)
                {

                    strHTMLBuilder7.Append("<tr >");
                    foreach (DataColumn myColumn in dt7.Columns)
                    {
                        if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Scenario")
                        {
                            strHTMLBuilder7.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder7.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder7.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder7.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            strHTMLBuilder7.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder7.Append("</td>");
                        }
                    }
                    strHTMLBuilder7.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder7.Append("</table>");
                strHTMLBuilder7.Append("</body>");
                strHTMLBuilder7.Append("</html>");
                Htmltext7 = strHTMLBuilder7.ToString();
            }


            //Table8
            StringBuilder strHTMLBuilder8 = new StringBuilder();
            if (dt8.Rows.Count > 0)
            {

                strHTMLBuilder8.Append("<html >");
                strHTMLBuilder8.Append("<head>");
                strHTMLBuilder8.Append("</head>");
                strHTMLBuilder8.Append("<body>");
                strHTMLBuilder8.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder8.Append("<tr id='trHeader'>");


                foreach (DataColumn myColumn in dt8.Columns)
                {
                    if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Financing Source")
                    {
                        strHTMLBuilder8.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                        strHTMLBuilder8.Append(myColumn.ColumnName);
                        strHTMLBuilder8.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder8.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                        strHTMLBuilder8.Append(myColumn.ColumnName);
                        strHTMLBuilder8.Append("</td>");
                    }
                }
                strHTMLBuilder8.Append("</tr>");


                foreach (DataRow myRow in dt8.Rows)
                {

                    strHTMLBuilder8.Append("<tr >");
                    foreach (DataColumn myColumn in dt8.Columns)
                    {
                        if (myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Financing Source")
                        {
                            strHTMLBuilder8.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder8.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder8.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder8.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            strHTMLBuilder8.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder8.Append("</td>");
                        }
                    }
                    strHTMLBuilder8.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder8.Append("</table>");
                strHTMLBuilder8.Append("</body>");
                strHTMLBuilder8.Append("</html>");
                Htmltext8 = strHTMLBuilder8.ToString();
            }


            //Table9
            StringBuilder strHTMLBuilder9 = new StringBuilder();
            if (dt9.Rows.Count > 0)
            {

                strHTMLBuilder9.Append("<html >");
                strHTMLBuilder9.Append("<head>");
                strHTMLBuilder9.Append("</head>");
                strHTMLBuilder9.Append("<body>");
                strHTMLBuilder9.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder9.Append("<tr id='trHeader'>");


                foreach (DataColumn myColumn in dt9.Columns)
                {
                    if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Comment" || myColumn.ColumnName == "Invoice Type")
                    {
                        strHTMLBuilder9.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                        strHTMLBuilder9.Append(myColumn.ColumnName);
                        strHTMLBuilder9.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder9.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                        strHTMLBuilder9.Append(myColumn.ColumnName);
                        strHTMLBuilder9.Append("</td>");
                    }
                }
                strHTMLBuilder9.Append("</tr>");


                foreach (DataRow myRow in dt9.Rows)
                {

                    strHTMLBuilder9.Append("<tr >");
                    foreach (DataColumn myColumn in dt9.Columns)
                    {
                        if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Comment" || myColumn.ColumnName == "Invoice Type")
                        {
                            strHTMLBuilder9.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder9.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder9.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "Invoice Amount" && myRow["Invoice Amount"] != DBNull.Value)
                        {
                            strHTMLBuilder9.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder9.Append(formattedCurrency);
                            strHTMLBuilder9.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder9.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            strHTMLBuilder9.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder9.Append("</td>");
                        }
                    }
                    strHTMLBuilder9.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder9.Append("</table>");
                strHTMLBuilder9.Append("</body>");
                strHTMLBuilder9.Append("</html>");
                Htmltext9 = strHTMLBuilder9.ToString();
            }


            //Table10
            StringBuilder strHTMLBuilder10 = new StringBuilder();
            if (dt10.Rows.Count > 0)
            {

                strHTMLBuilder10.Append("<html >");
                strHTMLBuilder10.Append("<head>");
                strHTMLBuilder10.Append("</head>");
                strHTMLBuilder10.Append("<body>");
                strHTMLBuilder10.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder10.Append("<tr id='trHeader'>");


                foreach (DataColumn myColumn in dt10.Columns)
                {
                    if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Purpose" || myColumn.ColumnName == "Generated By" || myColumn.ColumnName == "Status" || myColumn.ColumnName == "Comment")
                    {
                        strHTMLBuilder10.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                        strHTMLBuilder10.Append(myColumn.ColumnName);
                        strHTMLBuilder10.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder10.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                        strHTMLBuilder10.Append(myColumn.ColumnName);
                        strHTMLBuilder10.Append("</td>");
                    }
                }
                strHTMLBuilder10.Append("</tr>");


                foreach (DataRow myRow in dt10.Rows)
                {

                    strHTMLBuilder10.Append("<tr >");
                    foreach (DataColumn myColumn in dt10.Columns)
                    {
                        if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Purpose" || myColumn.ColumnName == "Generated By" || myColumn.ColumnName == "Status" || myColumn.ColumnName == "Comment")
                        {
                            strHTMLBuilder10.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder10.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder10.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "Amount" && myRow["Amount"] != DBNull.Value)
                        {
                            strHTMLBuilder10.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder10.Append(formattedCurrency);
                            strHTMLBuilder10.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "Required Equity" && myRow["Required Equity"] != DBNull.Value)
                        {
                            strHTMLBuilder10.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder10.Append(formattedCurrency);
                            strHTMLBuilder10.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "Additional Equity" && myRow["Additional Equity"] != DBNull.Value)
                        {
                            strHTMLBuilder10.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder10.Append(formattedCurrency);
                            strHTMLBuilder10.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder10.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            strHTMLBuilder10.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder10.Append("</td>");
                        }

                    }
                    strHTMLBuilder10.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder10.Append("</table>");
                strHTMLBuilder10.Append("</body>");
                strHTMLBuilder10.Append("</html>");
                Htmltext10 = strHTMLBuilder10.ToString();
            }


            //Table11
            StringBuilder strHTMLBuilder11 = new StringBuilder();
            if (dt11.Rows.Count > 0)
            {

                strHTMLBuilder11.Append("<html >");
                strHTMLBuilder11.Append("<head>");
                strHTMLBuilder11.Append("</head>");
                strHTMLBuilder11.Append("<body>");
                strHTMLBuilder11.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder11.Append("<tr id='trHeader'>");



                foreach (DataColumn myColumn in dt11.Columns)
                {
                    if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Financing Source")
                    {
                        strHTMLBuilder11.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                        strHTMLBuilder11.Append(myColumn.ColumnName);
                        strHTMLBuilder11.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder11.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                        strHTMLBuilder11.Append(myColumn.ColumnName);
                        strHTMLBuilder11.Append("</td>");
                    }
                }
                strHTMLBuilder11.Append("</tr>");


                foreach (DataRow myRow in dt11.Rows)
                {

                    strHTMLBuilder11.Append("<tr >");
                    foreach (DataColumn myColumn in dt11.Columns)
                    {
                        if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Financing Source")
                        {
                            strHTMLBuilder11.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder11.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder11.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "M61_CurrentBls" && myRow["M61_CurrentBls"] != DBNull.Value)
                        {
                            strHTMLBuilder11.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder11.Append(formattedCurrency);
                            strHTMLBuilder11.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "BS_CurrentBls" && myRow["BS_CurrentBls"] != DBNull.Value)
                        {
                            strHTMLBuilder11.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder11.Append(formattedCurrency);
                            strHTMLBuilder11.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "Delta" && myRow["Delta"] != DBNull.Value)
                        {
                            strHTMLBuilder11.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder11.Append(formattedCurrency);
                            strHTMLBuilder11.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder11.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            strHTMLBuilder11.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder11.Append("</td>");
                        }
                    }
                    strHTMLBuilder11.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder11.Append("</table>");
                strHTMLBuilder11.Append("</body>");
                strHTMLBuilder11.Append("</html>");
                Htmltext11 = strHTMLBuilder11.ToString();
            }



            //Table12
            StringBuilder strHTMLBuilder12 = new StringBuilder();
            if (dt12.Rows.Count > 0)
            {

                strHTMLBuilder12.Append("<html >");
                strHTMLBuilder12.Append("<head>");
                strHTMLBuilder12.Append("</head>");
                strHTMLBuilder12.Append("<body>");
                strHTMLBuilder12.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder12.Append("<tr id='trHeader'>");



                foreach (DataColumn myColumn in dt12.Columns)
                {
                    if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Financing Source" || myColumn.ColumnName == "Deal Type")
                    {
                        strHTMLBuilder12.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                        strHTMLBuilder12.Append(myColumn.ColumnName);
                        strHTMLBuilder12.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder12.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                        strHTMLBuilder12.Append(myColumn.ColumnName);
                        strHTMLBuilder12.Append("</td>");
                    }
                }
                strHTMLBuilder12.Append("</tr>");


                foreach (DataRow myRow in dt12.Rows)
                {

                    strHTMLBuilder12.Append("<tr >");
                    foreach (DataColumn myColumn in dt12.Columns)
                    {
                        if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Financing Source" || myColumn.ColumnName == "Deal Type")
                        {
                            strHTMLBuilder12.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder12.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder12.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "M61_NoteAdjustedTotalCommitment" && myRow["M61_NoteAdjustedTotalCommitment"] != DBNull.Value)
                        {
                            strHTMLBuilder12.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder12.Append(formattedCurrency);
                            strHTMLBuilder12.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "TotalCurrentAdjustedCommitment" && myRow["TotalCurrentAdjustedCommitment"] != DBNull.Value)
                        {
                            strHTMLBuilder12.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder12.Append(formattedCurrency);
                            strHTMLBuilder12.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "Delta" && myRow["Delta"] != DBNull.Value)
                        {
                            strHTMLBuilder12.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder12.Append(formattedCurrency);
                            strHTMLBuilder12.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder12.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            strHTMLBuilder12.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder12.Append("</td>");
                        }
                    }
                    strHTMLBuilder12.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder12.Append("</table>");
                strHTMLBuilder12.Append("</body>");
                strHTMLBuilder12.Append("</html>");
                Htmltext12 = strHTMLBuilder12.ToString();
            }


            //Table13
            StringBuilder strHTMLBuilder13 = new StringBuilder();
            if (dt13.Rows.Count > 0)
            {

                strHTMLBuilder13.Append("<html >");
                strHTMLBuilder13.Append("<head>");
                strHTMLBuilder13.Append("</head>");
                strHTMLBuilder13.Append("<body>");
                strHTMLBuilder13.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder13.Append("<tr id='trHeader'>");



                foreach (DataColumn myColumn in dt13.Columns)
                {
                    if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Financing Source")
                    {
                        strHTMLBuilder13.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                        strHTMLBuilder13.Append(myColumn.ColumnName);
                        strHTMLBuilder13.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder13.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                        strHTMLBuilder13.Append(myColumn.ColumnName);
                        strHTMLBuilder13.Append("</td>");
                    }
                }
                strHTMLBuilder13.Append("</tr>");


                foreach (DataRow myRow in dt13.Rows)
                {

                    strHTMLBuilder13.Append("<tr >");
                    foreach (DataColumn myColumn in dt13.Columns)
                    {
                        if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Financing Source")
                        {
                            strHTMLBuilder13.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder13.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder13.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "FundingAmount" && myRow["FundingAmount"] != DBNull.Value)
                        {
                            strHTMLBuilder13.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder13.Append(formattedCurrency);
                            strHTMLBuilder13.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "RemainingUnfundedCommitment" && myRow["RemainingUnfundedCommitment"] != DBNull.Value)
                        {
                            strHTMLBuilder13.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder13.Append(formattedCurrency);
                            strHTMLBuilder13.Append("</td>");
                        }
                        else if (myColumn.ColumnName == "Delta" && myRow["Delta"] != DBNull.Value)
                        {
                            strHTMLBuilder13.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            CultureInfo culture = new CultureInfo("en-US");
                            string formattedCurrency = string.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow[myColumn.ColumnName].ToString()).Value, 2));
                            strHTMLBuilder13.Append(formattedCurrency);
                            strHTMLBuilder13.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder13.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            strHTMLBuilder13.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder13.Append("</td>");
                        }
                    }
                    strHTMLBuilder13.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder13.Append("</table>");
                strHTMLBuilder13.Append("</body>");
                strHTMLBuilder13.Append("</html>");
                Htmltext13 = strHTMLBuilder13.ToString();
            }


            //Table14
            StringBuilder strHTMLBuilder14 = new StringBuilder();
            if (dt14.Rows.Count > 0)
            {

                strHTMLBuilder14.Append("<html >");
                strHTMLBuilder14.Append("<head>");
                strHTMLBuilder14.Append("</head>");
                strHTMLBuilder14.Append("<body>");
                strHTMLBuilder14.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder14.Append("<tr id='trHeader'>");


                foreach (DataColumn myColumn in dt14.Columns)
                {
                    if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Funding Purpose")
                    {
                        strHTMLBuilder14.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                        strHTMLBuilder14.Append(myColumn.ColumnName);
                        strHTMLBuilder14.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder14.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                        strHTMLBuilder14.Append(myColumn.ColumnName);
                        strHTMLBuilder14.Append("</td>");
                    }
                }
                strHTMLBuilder14.Append("</tr>");


                foreach (DataRow myRow in dt14.Rows)
                {

                    strHTMLBuilder14.Append("<tr >");
                    foreach (DataColumn myColumn in dt14.Columns)
                    {
                        if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Funding Purpose")
                        {
                            strHTMLBuilder14.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder14.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder14.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder14.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            strHTMLBuilder14.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder14.Append("</td>");
                        }
                    }
                    strHTMLBuilder14.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder14.Append("</table>");
                strHTMLBuilder14.Append("</body>");
                strHTMLBuilder14.Append("</html>");
                Htmltext14 = strHTMLBuilder14.ToString();
            }

            //Table15
            StringBuilder strHTMLBuilder15 = new StringBuilder();
            if (dt15.Rows.Count > 0)
            {

                strHTMLBuilder15.Append("<html >");
                strHTMLBuilder15.Append("<head>");
                strHTMLBuilder15.Append("</head>");
                strHTMLBuilder15.Append("<body>");
                strHTMLBuilder15.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder15.Append("<tr id='trHeader'>");


                foreach (DataColumn myColumn in dt15.Columns)
                {
                    if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Status" || myColumn.ColumnName == "Scenario")
                    {
                        strHTMLBuilder15.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                        strHTMLBuilder15.Append(myColumn.ColumnName);
                        strHTMLBuilder15.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder15.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                        strHTMLBuilder15.Append(myColumn.ColumnName);
                        strHTMLBuilder15.Append("</td>");
                    }
                }
                strHTMLBuilder15.Append("</tr>");


                foreach (DataRow myRow in dt15.Rows)
                {

                    strHTMLBuilder15.Append("<tr >");
                    foreach (DataColumn myColumn in dt15.Columns)
                    {
                        if (myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Note ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Status" || myColumn.ColumnName == "Scenario")
                        {
                            strHTMLBuilder15.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important; >");
                            strHTMLBuilder15.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder15.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder15.Append("<td style=text-align:right; padding-left:5px!important; padding-right:5px!important; >");
                            strHTMLBuilder15.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder15.Append("</td>");
                        }
                    }
                    strHTMLBuilder15.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder15.Append("</table>");
                strHTMLBuilder15.Append("</body>");
                strHTMLBuilder15.Append("</html>");
                Htmltext15 = strHTMLBuilder15.ToString();
            }
            //=============================

            //Table16
            StringBuilder strHTMLBuilder16 = new StringBuilder();
            if (dt16.Rows.Count > 0)
            {

                strHTMLBuilder16.Append("<html >");
                strHTMLBuilder16.Append("<head>");
                strHTMLBuilder16.Append("</head>");
                strHTMLBuilder16.Append("<body>");
                strHTMLBuilder16.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder16.Append("<tr id='trHeader'>");


                foreach (DataColumn myColumn in dt16.Columns)
                {
                    if (myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID")
                    {
                        strHTMLBuilder16.Append("<td style=text-align:left;padding-left:16px!important;padding-right:16px!important; >");
                        strHTMLBuilder16.Append(myColumn.ColumnName);
                        strHTMLBuilder16.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder16.Append("<td style=text-align:right; padding-left:16px!important; padding-right:16px!important; >");
                        strHTMLBuilder16.Append(myColumn.ColumnName);
                        strHTMLBuilder16.Append("</td>");
                    }
                }
                strHTMLBuilder16.Append("</tr>");


                foreach (DataRow myRow in dt16.Rows)
                {

                    strHTMLBuilder16.Append("<tr >");
                    foreach (DataColumn myColumn in dt16.Columns)
                    {
                        if (myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID")
                        {
                            strHTMLBuilder16.Append("<td style=text-align:left;padding-left:16px!important;padding-right:16px!important; >");
                            strHTMLBuilder16.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder16.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder16.Append("<td style=text-align:right; padding-left:16px!important; padding-right:16px!important; >");
                            strHTMLBuilder16.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder16.Append("</td>");
                        }
                    }
                    strHTMLBuilder16.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder16.Append("</table>");
                strHTMLBuilder16.Append("</body>");
                strHTMLBuilder16.Append("</html>");
                Htmltext16 = strHTMLBuilder16.ToString();
            }
            ///=================================

            //Table17
            StringBuilder strHTMLBuilder17 = new StringBuilder();
            if (dt17.Rows.Count > 0)
            {

                strHTMLBuilder17.Append("<html >");
                strHTMLBuilder17.Append("<head>");
                strHTMLBuilder17.Append("</head>");
                strHTMLBuilder17.Append("<body>");
                strHTMLBuilder17.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder17.Append("<tr id='trHeader'>");


                foreach (DataColumn myColumn in dt17.Columns)
                {
                    if (myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Note ID")
                    {
                        strHTMLBuilder17.Append("<td style=text-align:left;padding-left:17px!important;padding-right:17px!important; >");
                        strHTMLBuilder17.Append(myColumn.ColumnName);
                        strHTMLBuilder17.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder17.Append("<td style=text-align:right; padding-left:17px!important; padding-right:17px!important; >");
                        strHTMLBuilder17.Append(myColumn.ColumnName);
                        strHTMLBuilder17.Append("</td>");
                    }
                }
                strHTMLBuilder17.Append("</tr>");


                foreach (DataRow myRow in dt17.Rows)
                {

                    strHTMLBuilder17.Append("<tr >");
                    foreach (DataColumn myColumn in dt17.Columns)
                    {
                        if (myColumn.ColumnName == "CREDealID" || myColumn.ColumnName == "Deal Name" || myColumn.ColumnName == "Deal ID" || myColumn.ColumnName == "Note Name" || myColumn.ColumnName == "Note ID")
                        {
                            strHTMLBuilder17.Append("<td style=text-align:left;padding-left:17px!important;padding-right:17px!important; >");
                            strHTMLBuilder17.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder17.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder17.Append("<td style=text-align:right; padding-left:17px!important; padding-right:17px!important; >");
                            strHTMLBuilder17.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder17.Append("</td>");
                        }
                    }
                    strHTMLBuilder17.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder17.Append("</table>");
                strHTMLBuilder17.Append("</body>");
                strHTMLBuilder17.Append("</html>");
                Htmltext17 = strHTMLBuilder17.ToString();
            }
            ///=================================

            //Table17
            StringBuilder strHTMLBuilder18 = new StringBuilder();
            if (dt18.Rows.Count > 0)
            {

                strHTMLBuilder18.Append("<html >");
                strHTMLBuilder18.Append("<head>");
                strHTMLBuilder18.Append("</head>");
                strHTMLBuilder18.Append("<body>");
                strHTMLBuilder18.Append("<table id='Dealfundingdiscrepancy'>");
                strHTMLBuilder18.Append("<tr id='trHeader'>");


                foreach (DataColumn myColumn in dt18.Columns)
                {
                    if (myColumn.ColumnName == "Scenario" || myColumn.ColumnName == "DealName" || myColumn.ColumnName == "DealID" || myColumn.ColumnName == "NoteID" || myColumn.ColumnName == "CalcEngineType")
                    {
                        strHTMLBuilder18.Append("<td style=text-align:left;padding-left:17px!important;padding-right:17px!important; >");
                        strHTMLBuilder18.Append(myColumn.ColumnName);
                        strHTMLBuilder18.Append("</td>");
                    }
                    else
                    {
                        strHTMLBuilder18.Append("<td style=text-align:right; padding-left:17px!important; padding-right:17px!important; >");
                        strHTMLBuilder18.Append(myColumn.ColumnName);
                        strHTMLBuilder18.Append("</td>");
                    }
                }
                strHTMLBuilder18.Append("</tr>");


                foreach (DataRow myRow in dt18.Rows)
                {

                    strHTMLBuilder18.Append("<tr >");
                    foreach (DataColumn myColumn in dt18.Columns)
                    {
                        if (myColumn.ColumnName == "Scenario" || myColumn.ColumnName == "DealName" || myColumn.ColumnName == "DealID" || myColumn.ColumnName == "NoteID" || myColumn.ColumnName == "CalcEngineType")
                        {
                            strHTMLBuilder18.Append("<td style=text-align:left;padding-left:17px!important;padding-right:17px!important; >");
                            strHTMLBuilder18.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder18.Append("</td>");
                        }
                        else
                        {
                            strHTMLBuilder18.Append("<td style=text-align:right; padding-left:17px!important; padding-right:17px!important; >");
                            strHTMLBuilder18.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder18.Append("</td>");
                        }
                    }
                    strHTMLBuilder18.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder18.Append("</table>");
                strHTMLBuilder18.Append("</body>");
                strHTMLBuilder18.Append("</html>");
                Htmltext18 = strHTMLBuilder18.ToString();
            }
            ///=================================
            string htmlContent = string.Empty;
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }

            if (!string.IsNullOrEmpty(linkName))
                htmlContent = htmlContent.Replace("{link}", linkName);

            string reporturl = EmailBaseUrl + "#/reportdetail/77be5eb1-c09a-4093-b65b-a73ae39864d9/12e682bc-12ec-455d-80e3-292636ab98c1";
            //ReportURL
            htmlContent = htmlContent.Replace("{ReportURL}", reporturl);
            htmlContent = htmlContent.Replace("{URL}", EmailBaseUrl);
            htmlContent = htmlContent.Replace("{contactemail}", contactEmail);
            htmlContent = htmlContent.Replace("{messagesummary}", bodyText.ToString());
            if (Htmltext.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{discrepancytitle}", "Funding discrepancy");
                htmlContent = htmlContent.Replace("{message}", Htmltext.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{discrepancytitle}", "Funding discrepancy");
                htmlContent = htmlContent.Replace("{message}", "No discrepancy found.");
            }
            if (Htmltext1.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{exitfeetitle}", "Exit / Extension fee stripping / Receivable discrepancy");
                htmlContent = htmlContent.Replace("{message1}", Htmltext1.ToString());
            }
            else
            {

                htmlContent = htmlContent.Replace("{exitfeetitle}", "Exit / Extension fee stripping / Receivable discrepancy");
                htmlContent = htmlContent.Replace("{message1}", "No discrepancy found.");
            }
            if (Htmltext2.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{FFBetweenM61andBackshoptitle}", "Future funding mismatch between m61 and backshop");
                htmlContent = htmlContent.Replace("{message2}", Htmltext2.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{FFBetweenM61andBackshoptitle}", "Future funding mismatch between m61 and backshop");
                htmlContent = htmlContent.Replace("{message2}", "No discrepancy found.");
            }

            //if (Htmltext3.ToString() != "")
            //{
            //    htmlContent = htmlContent.Replace("{CommitmentDiscrepancytitle}", "Commitment Discrepancy");
            //    htmlContent = htmlContent.Replace("{message3}", Htmltext3.ToString());
            //}
            //else
            //{
            //    htmlContent = htmlContent.Replace("{CommitmentDiscrepancytitle}", "Commitment Discrepancy");
            //    htmlContent = htmlContent.Replace("{message3}", "No discrepancy found.");
            //}

            if (Htmltext4.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{CommitmentDiscrepancyDatatitle}", "Commitment");
                htmlContent = htmlContent.Replace("{message4}", Htmltext4.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{CommitmentDiscrepancyDatatitle}", "Commitment");
                htmlContent = htmlContent.Replace("{message4}", "No discrepancy found.");
            }
            if (Htmltext5.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{Eligibledealsautospreadtitle}", "Eligible deals to autospread");
                htmlContent = htmlContent.Replace("{message5}", Htmltext5.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{Eligibledealsautospreadtitle}", "Eligible deals to autospread");
                htmlContent = htmlContent.Replace("{message5}", "No discrepancy found.");
            }
            if (Htmltext6.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{EPBetweenM61andBackshoptitle}", "Export paydown between m61 and backshop");
                htmlContent = htmlContent.Replace("{message6}", Htmltext6.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{EPBetweenM61andBackshoptitle}", "Export paydown between m61 and backshop");
                htmlContent = htmlContent.Replace("{message6}", "No discrepancy found.");
            }
            if (Htmltext7.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{NetIOTransactiontitle}", "Balanced not zeroed out");
                htmlContent = htmlContent.Replace("{message7}", Htmltext7.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{NetIOTransactiontitle}", "Balanced not zeroed out");
                htmlContent = htmlContent.Replace("{message7}", "No discrepancy found.");
            }


            if (Htmltext8.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{FinancingSource}", "Notes with missing financing source");
                htmlContent = htmlContent.Replace("{message8}", Htmltext8.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{FinancingSource}", "Notes with missing financing source");
                htmlContent = htmlContent.Replace("{message8}", "No discrepancy found.");
            }


            if (Htmltext9.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{InvoiceDiscrepancy}", "Invoices pending more than 3 BDs");
                htmlContent = htmlContent.Replace("{message9}", Htmltext9.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{InvoiceDiscrepancy}", "Invoices pending more than 3 BDs");
                htmlContent = htmlContent.Replace("{message9}", "No discrepancy found.");
            }


            if (Htmltext10.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyForWireConfirmed}", "Record less than current date and not wire confirmed");
                htmlContent = htmlContent.Replace("{message10}", Htmltext10.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyForWireConfirmed}", "Record less than current date and not wire confirmed");
                htmlContent = htmlContent.Replace("{message10}", "No discrepancy found.");
            }

            if (Htmltext11.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyForBalanceM61VsBackshop}", "Balance not matching between m61 and backshop (Paid off deals have been filtered out)");
                htmlContent = htmlContent.Replace("{message11}", Htmltext11.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyForBalanceM61VsBackshop}", "Balance not matching between m61 and backshop (Paid off deals have been filtered out)");
                htmlContent = htmlContent.Replace("{message11}", "No discrepancy found.");
            }

            if (Htmltext12.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyForAdjCommitmentM61VsBackshop}", "Adjusted commitment not matching between m61 and backshop (Paid off deals have been filtered out)");
                htmlContent = htmlContent.Replace("{message12}", Htmltext12.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyForAdjCommitmentM61VsBackshop}", "Adjusted commitment not matching between m61 and backshop (Paid off deals have been filtered out)");
                htmlContent = htmlContent.Replace("{message12}", "No discrepancy found.");
            }


            if (Htmltext13.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyForTotalFFVsUnfundedCommitment}", "Future funding not matching with unfunded commitment");
                htmlContent = htmlContent.Replace("{message13}", Htmltext13.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyForTotalFFVsUnfundedCommitment}", "Future funding not matching with unfunded commitment");
                htmlContent = htmlContent.Replace("{message13}", "No discrepancy found.");
            }

            if (Htmltext14.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyForDuplicatePIK_InBackshop}", "Backshop duplicate PIKNC and PIKPP");
                htmlContent = htmlContent.Replace("{message14}", Htmltext14.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyForDuplicatePIK_InBackshop}", "Backshop duplicate PIKNC and PIKPP");
                htmlContent = htmlContent.Replace("{message14}", "No discrepancy found.");
            }

            if (Htmltext15.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyForNotesFailedInCalculation}", "Notes failed in default scenario");
                htmlContent = htmlContent.Replace("{message15}", Htmltext15.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyForNotesFailedInCalculation}", "Notes failed in default scenario");
                htmlContent = htmlContent.Replace("{message15}", "No discrepancy found.");
            }

            if (Htmltext16.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyAutoSpreadDealWithNoUnderwriting}", "Auto spread deals without underwriting update");
                htmlContent = htmlContent.Replace("{message16}", Htmltext16.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyAutoSpreadDealWithNoUnderwriting}", "Auto spread deals without underwriting update");
                htmlContent = htmlContent.Replace("{message16}", "No discrepancy found.");
            }

            if (Htmltext17.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyAmortSchedule}", "Discrepancy for amort schedule");
                htmlContent = htmlContent.Replace("{message17}", Htmltext17.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyAmortSchedule}", "Discrepancy for amort schedule");
                htmlContent = htmlContent.Replace("{message17}", "No discrepancy found.");
            }

            if (Htmltext18.ToString() != "")
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyForDuplicateTransactions}", "Discrepancy for duplicate transactions");
                htmlContent = htmlContent.Replace("{message18}", Htmltext18.ToString());
            }
            else
            {
                htmlContent = htmlContent.Replace("{GetDiscrepancyForDuplicateTransactions}", "Discrepancy for duplicate transactions");
                htmlContent = htmlContent.Replace("{message18}", "No discrepancy found.");
            }

            //send email
            //EmailSender.SendTOEmail(fromEmail, toEmail, null, subject, null, null, htmlContent);
            EmailSender.SendTOCCEmail(fromEmail, emailidsTo, emailidsCC.ToList(), subject, null, null, htmlContent);
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
            string EnvironmentName = Sectionroot.GetSection("EnvironmentName").Value != "" ? "(" + Sectionroot.GetSection("EnvironmentName").Value.Trim() + ") " : "";
            subject = EnvironmentName + subject;

            string HtmlTemplateName = "ForceFundingnotification.html";
            StringBuilder bodyText = new StringBuilder();
            string message = "", reminder = "";
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
                message = " The below Force Funding is scheduled " + days + " BDs from today. This is a reminder to send out the Preliminary Capital Call. Click <a href=" + workflowUrl + ">here</a> to send.";
            if (days == 2)
                message = " The below Force Funding is scheduled " + days + " BDs from today. This is a reminder to ensure the Final Capital Call is sent out today (" + dtnxtdate.ToString("MM-dd-yyyy").Replace("-", "/") + "). Click <a href=" + workflowUrl + ">here</a> to view this transaction in M61.";

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
            string password = "admin1*";
            string fromEmail = "no-reply@m61systems.com";
            string UserName = "Admin";
            List<string> emailidsBCC = new List<string>();
            string subject = "ACORE Draw Fee Invoice - " + DrawFeeDC.DealName + " - " + DrawFeeDC.InvoiceNoUI;
            string ServerName = Sectionroot.GetSection("ServerName").Value;
            if (!string.IsNullOrEmpty(ServerName) && !ServerName.ToLower().Contains("acore"))
            {
                subject = "(" + ServerName.Remove(0, 4) + ")" + subject;
            }
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
            string password = "admin1*";
            string fromEmail = "test@test.com";
            string UserName = "Admin";
            List<string> emailidsBCC = new List<string>();
            string subject = "";


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
            string password = "admin1*";
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


        public void SendEmailForParentClientMissingEmailId(DataTable dt)
        {
            GetConfigSetting();
            string[] emailidsTo = null;
            UserRepository _userRepository = new UserRepository();
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string showlink = linkName.Substring(4);
            string subject = "A list of parent clients needs email ids for notification.";
            int moduleId = 792;
            List<EmailDataContract> lstEmailIDs = new List<EmailDataContract>();
            if (dt == null || dt.Rows.Count == 0)
                return;

            if (dt.Rows.Count > 0)
            {
                lstEmailIDs = _userRepository.GetEmailIdsByModuleandType(moduleId);
                if (lstEmailIDs != null && lstEmailIDs.Count() > 0)
                {
                    emailidsTo = lstEmailIDs.Select(r => r.EmailID).ToArray();
                }
                string Htmltext = "";
                string fromEmail = "test@test.com";
                string HtmlTemplateName = "ParentClientMissingEmail.html";
                string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
                StringBuilder strHTMLBuilder = new StringBuilder();
                foreach (DataRow myRow in dt.Rows)
                {
                    strHTMLBuilder.Append(myRow["ParentClientMaster"].ToString() + "<br />");

                }
                Htmltext = strHTMLBuilder.ToString();

                string htmlContent = string.Empty;
                using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
                {
                    htmlContent = reader.ReadToEnd();
                }
                if (Htmltext.ToString() != "")
                {
                    htmlContent = htmlContent.Replace("{missingemail}", Htmltext.ToString());
                }
                //send email
                EmailSender.SendTOCCEmail(fromEmail, emailidsTo, null, subject, null, null, htmlContent);
            }
        }

        public void SendAutoConfirmAmortization(DataTable dt, string Type, MemoryStream ms, string filename, DataTable batchdata)
        {
            GetConfigSetting();
            string[] emailidsTo = null;
            string summary = "";
            UserRepository _userRepository = new UserRepository();
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string showlink = linkName.Substring(4);
            string subject = "";
            int moduleId = 802;
            int faileddeals = 0;
            int totaldeals = 0;
            string faileddealtext = "";
            List<EmailDataContract> lstEmailIDs = new List<EmailDataContract>();
            if (Type == "FundingMoveToNextMonth")
            {
                subject = "(" + showlink + ")" + " Auto Kicked Out Month End Fundings";
                summary = "Below fundings have been automatically kicked-out to next month:";

            }
            else if (Type == "FundingMoveTo1BusinessdaysWF")
            {
                moduleId = 852;
                subject = "(" + showlink + ")" + " Auto Kicked Out Fundings Records To Next Business Day";
                summary = "Below fundings have been automatically kicked-out to next Business day:";
            }
            else if (Type == "FundingMoveTo15Businessdays")
            {
                moduleId = 852;
                subject = "(" + showlink + ")" + " Auto Kicked Out Fundings Records To after 10 Business Day";
                summary = "Below fundings have been automatically kicked-out to after 10 Business days:";
            }
            else
            {
                subject = "(" + showlink + ")" + " Auto Wire Confirmed Amortization Records";
                summary = "The below transactions were auto wire confirmed today:";
            }
            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string[] emailidsCC = null;
            string[] TobeDistinctColumns = { "Email" };
            DataTable dt1 = new DataTable();
            dt1.Columns.Add("Email");
            foreach (DataRow dr in dt.Rows)
            {
                if (Convert.ToString(dr["SeconderyEmail"]) != "")
                {
                    DataRow SeconderyEmail = dt1.NewRow();
                    SeconderyEmail["Email"] = Convert.ToString(dr["SeconderyEmail"]);
                    dt1.Rows.Add(SeconderyEmail);
                }
                if (Convert.ToString(dr["Email"]) != "")
                {
                    DataRow Email = dt1.NewRow();
                    Email["Email"] = Convert.ToString(dr["Email"]);
                    dt1.Rows.Add(Email);
                }
            }
            StringBuilder strFailed = new StringBuilder();
            int batchid = 0;
            // batch summary
            var temp1 = batchdata.Select("StatusID = '265'");
            if (temp1 != null)
            {
                if (temp1.Length > 0)
                {
                    var filterdata1 = batchdata.Select("StatusID = '265'").CopyToDataTable();
                    DataTable validationdeals = filterdata1.DefaultView.ToTable(true, "DealID");
                    faileddeals = validationdeals.Rows.Count;


                    if (Type == "AmortizationAutoWire")
                    {
                        faileddealtext = "The below Deals were not auto wire confirmed today due to validation errors:";
                    }
                    else if (Type == "FundingMoveTo1BusinessdaysWF" || Type == "FundingMoveTo15Businessdays")
                    {
                        faileddealtext = "The below Deals were not moved to next Business day due to validation errors:";
                    }
                    else
                    {
                        faileddealtext = "The below Deals were not moved to next Month End due to validation errors:";
                    }

                    strFailed.Append("<table id='AutoConfirmAmortization'style='width:40% !important;'  >");
                    strFailed.Append("<tr id='trHeader'>");
                    strFailed.Append("<td style='width: 80px!important;'>DealID</td><td style='width: 200px!important;'>Deal Name</td><td style='width: 300px!important;'> Validation 1</td><td style='width: 300px!important;'>Validation 1</td>");
                    strFailed.Append("</tr>");
                    GenerateAutomationHelper generateAutomationHelper = new GenerateAutomationHelper();
                    DataTable formatedvalidatindataset = generateAutomationHelper.GetFormatedDatafromDatatableForAutomation(filterdata1);

                    foreach (DataRow dr2 in formatedvalidatindataset.Rows)
                    {
                        string dealurl = EmailBaseUrl + "#/dealdetail/" + dr2["CREID"].ToString();
                        strFailed.Append("<tr>");

                        strFailed.Append("<td style=text-align:left;>");
                        strFailed.Append("<a href=" + dealurl + ">" + dr2["CREID"].ToString() + "</a>");
                        strFailed.Append("</td>");

                        strFailed.Append("<td style=text-align:left;>");
                        strFailed.Append(Convert.ToString(dr2["Name"]));
                        strFailed.Append("</td>");

                        strFailed.Append("<td style=text-align:left;>");
                        strFailed.Append(Convert.ToString(dr2["Validation1"]));
                        strFailed.Append("</td>");

                        strFailed.Append("<td style=text-align:left;>");
                        strFailed.Append(Convert.ToString(dr2["Validation2"]));
                        strFailed.Append("</td>");
                        strFailed.Append("</tr>");
                    }
                    strFailed.Append("</table>");
                }
            }


            //batchdata
            DataTable totaldeal = batchdata.DefaultView.ToTable(true, "DealID");
            totaldeals = totaldeal.Rows.Count;

            int completeddeals = totaldeals - faileddeals;
            batchid = Convert.ToInt16(batchdata.Rows[0]["BatchID"]);
            if (Type == "FundingMoveTo1BusinessdaysWF" || Type == "FundingMoveTo15Businessdays")
            {

                DataTable dtUniqRecords = new DataTable();

                dtUniqRecords = dt1.DefaultView.ToTable(true, TobeDistinctColumns);
                emailidsCC = dtUniqRecords.AsEnumerable().Select(r => r.Field<string>("Email")).ToArray();

                lstEmailIDs = _userRepository.GetEmailIdsByModuleandType(moduleId);
                var lstEmailIdsCcbyType = lstEmailIDs.Where(r => r.Type == 783);
                var addCC = lstEmailIdsCcbyType.Select(r => r.EmailID).ToArray();

                var lstEmailIdsTObyType = lstEmailIDs.Where(r => r.Type == 782);
                emailidsTo = lstEmailIdsTObyType.Select(r => r.EmailID).ToArray();

                if (emailidsCC.Count() > 0)
                {
                    emailidsCC = emailidsCC.Concat(addCC).ToArray();
                }
                else
                {
                    emailidsCC = addCC;
                }

            }
            else
            {
                DataTable dtUniqRecords = new DataTable();

                dtUniqRecords = dt1.DefaultView.ToTable(true, TobeDistinctColumns);
                emailidsTo = dtUniqRecords.AsEnumerable().Select(r => r.Field<string>("Email")).ToArray();

                lstEmailIDs = _userRepository.GetEmailIdsByModuleandType(moduleId);
                var lstEmailIdsCcbyType = lstEmailIDs.Where(r => r.Type == 783);
                emailidsCC = lstEmailIdsCcbyType.Select(r => r.EmailID).ToArray();
            }


            //toEmail = "ssingh@hvantage.com";
            string fromEmail = "test@test.com";
            string HtmlTemplateName = "AutoConfirmAmortization.html";

            string ServerName = Sectionroot.GetSection("ServerName").Value;
            if (ServerName != "M61-Acore")
            {
                emailidsTo = emailidsTo.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
                emailidsCC = emailidsCC.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
            }
            //manish
            StringBuilder strHTMLBuilder = new StringBuilder();
            //Deal and Note Discrpancy
            if (dt.Rows.Count > 0)
            {
                strHTMLBuilder.Append("<html >");
                strHTMLBuilder.Append("<head>");
                strHTMLBuilder.Append("</head>");
                strHTMLBuilder.Append("<body>");
                strHTMLBuilder.Append("<table id='AutoConfirmAmortization'style='width:55% !important;'  >");
                strHTMLBuilder.Append("<tr id='trHeader'>");
                strHTMLBuilder.Append("<td>DealID</td><td>Deal Name</td><td>Purpose Type</td><td>Amount</td><td>Revised Date</td><td>Message</td>");

                strHTMLBuilder.Append("</tr>");
                foreach (DataRow dr in dt.Rows)
                {
                    string dealurl = EmailBaseUrl + "#/dealdetail/" + dr["CREDealID"].ToString();
                    strHTMLBuilder.Append("<tr>");

                    strHTMLBuilder.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important;width:70px !important;  >");
                    strHTMLBuilder.Append("<a href=" + dealurl + ">" + dr["CREDealID"].ToString() + "</a>");
                    strHTMLBuilder.Append("</td>");

                    strHTMLBuilder.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important;width:150px !important;  >");
                    strHTMLBuilder.Append(Convert.ToString(dr["DealName"]));
                    strHTMLBuilder.Append("</td>");

                    strHTMLBuilder.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important;width:125px !important;  >");
                    strHTMLBuilder.Append(Convert.ToString(dr["Purpose"]));
                    strHTMLBuilder.Append("</td>");

                    strHTMLBuilder.Append("<td style=text-align:right;padding-left:5px!important;padding-right:5px!important;width:100px !important;>");
                    strHTMLBuilder.Append(string.Format("{0:C}", Math.Round(CommonHelper.StringToDecimal(dr["Amount"]).Value, 2)));
                    strHTMLBuilder.Append("</td>");

                    strHTMLBuilder.Append("<td style=text-align:right;padding-left:5px!important;padding-right:5px!important;width:100px !important;  >");
                    if (dr["Date"] != null && dr["Date"].ToString() != "")
                    {
                        strHTMLBuilder.Append(CommonHelper.ToDateTime(dr["Date"]).Value.ToString("MM/dd/yyyy"));
                    }
                    else
                    {
                        strHTMLBuilder.Append("");
                    }
                    strHTMLBuilder.Append("</td>");

                    strHTMLBuilder.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important;width:250px;  >");
                    if (Type == "AmortizationAutoWire")
                    {
                        strHTMLBuilder.Append("Auto wire confirmed by the system");
                    }
                    else
                    {
                        strHTMLBuilder.Append(Convert.ToString(dr["Message"]));
                    }

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

            if (Htmltext.ToString() != null)
            {
                htmlContent = htmlContent.Replace("{message}", Htmltext.ToString());
                htmlContent = htmlContent.Replace("{summary}", summary);
                htmlContent = htmlContent.Replace("{BatchID}", batchid.ToString());
                htmlContent = htmlContent.Replace("{DealCount}", totaldeals.ToString());
                htmlContent = htmlContent.Replace("{completed}", completeddeals.ToString());
                htmlContent = htmlContent.Replace("{validation}", faileddeals.ToString());

                htmlContent = htmlContent.Replace("{faileddealtext}", faileddealtext.ToString());
                htmlContent = htmlContent.Replace("{faileddealtable}", strFailed.ToString());

            }
            //send email           
            //EmailSender.SendTOCCEmail(fromEmail, emailidsTo, emailidsCC.ToList(), subject, null, null, htmlContent);
            EmailSender.SendEmailTOCCWithAttachmentASMemoryStream(fromEmail, emailidsTo, emailidsCC, subject, htmlContent, ms, filename);
        }

        public void SendFundingValidationEmail(MemoryStream ms, string filename, string batchtype, DataTable batchdata)
        {

            GetConfigSetting();
            string summary = "";
            if (batchtype == "AutoSpread_UnderwritingDataChanged")
            {
                summary = "PFA the generate and save automation report for list of deal for which Backshop underwriting data has been changed.";
            }
            else
            {
                summary = "PFA the generate and save automation report.";
            }
            // batch summary
            int batchid = 0;
            int faileddeals = 0;
            int totaldeals = 0;
            var temp1 = batchdata.Select("StatusID = '265'");
            if (temp1 != null)
            {
                if (temp1.Length > 0)
                {
                    var filterdata1 = batchdata.Select("StatusID = '265'").CopyToDataTable();
                    DataTable validationdeals = filterdata1.DefaultView.ToTable(true, "DealID");
                    faileddeals = validationdeals.Rows.Count;
                }
            }
            //batchdata
            DataTable totaldeal = batchdata.DefaultView.ToTable(true, "DealID");
            totaldeals = totaldeal.Rows.Count;

            int completeddeals = totaldeals - faileddeals;
            batchid = Convert.ToInt16(batchdata.Rows[0]["BatchID"]);

            UserRepository _userRepository = new UserRepository();
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string showlink = linkName.Substring(4);
            string subject = "";
            int moduleId = 803;
            List<EmailDataContract> lstEmailIDs = new List<EmailDataContract>();

            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;
            string ServerName = Sectionroot.GetSection("ServerName").Value;
            string[] emailidsCC = null;

            string[] emailidsTo = null;

            subject = "(" + showlink + ")" + " Generate Automation - Deal Funding Validation Report";

            lstEmailIDs = _userRepository.GetEmailIdsByModuleandType(moduleId);

            var lstEmailIdsCcbyType = lstEmailIDs.Where(r => r.Type == 783);
            emailidsCC = lstEmailIdsCcbyType.Select(r => r.EmailID).ToArray();

            var lstEmailIdsTObyType = lstEmailIDs.Where(r => r.Type == 782);
            emailidsTo = lstEmailIdsTObyType.Select(r => r.EmailID).ToArray();


            string fromEmail = "test@test.com";
            string HtmlTemplateName = "DealFundingValidation_Generate_Automation.html";

            if (ServerName != "M61-Acore")
            {
                emailidsTo = emailidsTo.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
                emailidsCC = emailidsCC.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
            }

            StringBuilder strHTMLBuilder = new StringBuilder();

            string Htmltext = strHTMLBuilder.ToString();

            string htmlContent = string.Empty;
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }

            if (Htmltext.ToString() != null)
            {
                htmlContent = htmlContent.Replace("{message}", Htmltext.ToString());
                htmlContent = htmlContent.Replace("{summary}", summary);

                htmlContent = htmlContent.Replace("{BatchID}", batchid.ToString());
                htmlContent = htmlContent.Replace("{DealCount}", totaldeals.ToString());
                htmlContent = htmlContent.Replace("{completed}", completeddeals.ToString());
                htmlContent = htmlContent.Replace("{validation}", faileddeals.ToString());

            }
            EmailSender.SendEmailTOCCWithAttachmentASMemoryStream(fromEmail, emailidsTo, emailidsCC, subject, htmlContent, ms, filename);

        }

        public void SendEmailOnExceptionFailed(string ModuleName, string exceptionMessage, string shortmessage, string userID, string emailextrainfo)
        {
            GetConfigSetting();
            UserLogic ul = new UserLogic();
            UserDataContract _userdatacontract = ul.GetUserCredentialByUserID(new Guid(userID), new Guid("00000000-0000-0000-0000-000000000000"));
            string[] toEmail = null;
            string linkName = Sectionroot.GetSection("ServerName").Value;


            UserRepository _userRepository = new UserRepository();
            string subject = "Error occurred in -" + ModuleName;

            string fromEmail = "test@test.com";
            //string UserName = "Admin";
            string HtmlTemplateName = "ExceptionError.html";
            StringBuilder bodyText = new StringBuilder();
            int moduleId = 615;
            toEmail = _userRepository.GetEmailIdsByModule(moduleId).ToArray();

            string htmlContent = string.Empty;
            //using streamreader for reading my htmltemplate  
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            htmlContent = htmlContent.Replace("{errormessage}", exceptionMessage);
            htmlContent = htmlContent.Replace("{shortmessage}", shortmessage);
            htmlContent = htmlContent.Replace("{modulename}", ModuleName);
            htmlContent = htmlContent.Replace("{emailextrainfo}", emailextrainfo);

            if (!string.IsNullOrEmpty(linkName))
            {
                subject = "(" + linkName.Remove(0, 4) + ") " + subject;
                htmlContent = htmlContent.Replace("{link}", linkName);
            }
            htmlContent = htmlContent.Replace("{username}", CultureInfo.CurrentCulture.TextInfo.ToTitleCase(_userdatacontract.FirstName));
            //send email
            EmailSender.SendTOEmail(fromEmail, toEmail, null, subject, bodyText.ToString(), null, htmlContent);

        }


        public void SendErrorListEmail(MemoryStream ms, string filename)
        {

            GetConfigSetting();
            string summary = "";

            summary = "Please find attached list of exception occurred in last 24 hours.";

            UserRepository _userRepository = new UserRepository();
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string showlink = linkName.Substring(4);
            string subject = "";
            int moduleId = 615;
            //string[] emailidsTo = null;
            //string[] emailidsCC = null;
            //emailidsTo = new[] { "nsharma@hvantage.com" };
            //emailidsCC = new[] { "nsharma@hvantage.com" };

            var listOfStrings = new List<string>();
            string[] emailidsCC = listOfStrings.ToArray(); ;
            string[] emailidsTo = null;
            emailidsTo = _userRepository.GetEmailIdsByModule(moduleId).ToArray();
            subject = "(" + showlink + ")" + " Cres System Error Notification ";
            string fromEmail = "test@test.com";
            string HtmlTemplateName = "GenericEmailNotification.html";

            DevDashBoardLogic DevDashBoardLogic = new DevDashBoardLogic();
            DataTable moduleCount = DevDashBoardLogic.GetErrorForEmail();

            var moduleCountsQuery = moduleCount.AsEnumerable()
                .GroupBy(row => row.Field<string>("Module"))
                .Select(group => new
                {
                    ModuleName = group.Key,
                    ModuleCount = group.Count()
                })
                .ToList();

            List<string> moduleNames = moduleCountsQuery.Select(item => item.ModuleName).ToList();
            List<int> moduleCounts = moduleCountsQuery.Select(item => item.ModuleCount).ToList();

            string[] moduleNamesArray = moduleNames.ToArray();
            int[] moduleCountsArray = moduleCounts.ToArray();

            string[] colors = new[]
            {
    "rgba(255, 0, 0, 0.6)",
    "rgba(0, 255, 0, 0.6)",
    "rgba(0, 0, 255, 0.6)",
    "rgba(255, 255, 0, 0.6)",
    "rgba(255, 0, 255, 0.6)"
};

            string moduleNamesJson = JsonConvert.SerializeObject(moduleNamesArray);
            string moduleCountsJson = JsonConvert.SerializeObject(moduleCountsArray);

            string chartConfig = $@"
    {{
        ""type"": ""bar"",
        ""data"": {{
            ""labels"": {moduleNamesJson},
            ""datasets"": [{{
                ""data"": {moduleCountsJson},
                ""backgroundColor"": {JsonConvert.SerializeObject(colors)},
                ""borderColor"": {JsonConvert.SerializeObject(colors)},
                ""borderWidth"": 1
            }}]
        }},
        ""options"": {{
            ""scales"": {{
                ""y"": {{
                    ""beginAtZero"": true,
                    ""ticks"": {{
                        ""color"": ""rgba(0, 0, 0, 0.8)"",
                        ""font"": {{
                            ""family"": ""Arial"",
                            ""size"": 14,
                            ""style"": ""bold""
                        }}
                    }}
                }},
                ""x"": {{
                    ""ticks"": {{
                        ""color"": ""rgba(0, 0, 0, 0.8)"",
                        ""font"": {{
                            ""family"": ""Arial"",
                            ""size"": 14,
                            ""style"": ""italic""
                        }}
                    }}
                }}
            }},
            ""plugins"": {{
                ""datalabels"": {{
                    ""anchor"": ""end"",
                    ""align"": ""top"",
                    ""color"": ""rgba(0, 0, 0, 0.8)"", // Font color for counts
                    ""font"": {{
                        ""family"": ""Arial"",
                        ""size"": 14,
                        ""style"": ""bold""
                    }},
                    ""formatter"": function(value, context) {{
                        // Display the count on the bar
                        return value;
                    }}
                }}
            }},
            ""legend"": {{
                ""display"": false // Hide the legend
            }},
            ""title"": {{
                ""display"": true // Hide the title
            }}
        }}
    }}";

            string chartUrl = "https://quickchart.io/chart?width=500&height=200&chart=" + Uri.EscapeDataString(chartConfig);

            string htmlContent = string.Empty;
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            htmlContent = htmlContent.Replace("{chartImage}", chartUrl);
            htmlContent = htmlContent.Replace("{bodytext}", summary);
            htmlContent = htmlContent.Replace("{UserName}", "All");

            EmailSender.SendEmailTOCCWithAttachmentASMemoryStream(fromEmail, emailidsTo, emailidsCC, subject, htmlContent, ms, filename);

        }

        public void SendGenericInvoiceNotification(DrawFeeInvoiceDataContract DrawFeeDC)
        {
            GetConfigSetting();
            string password = "admin1*";
            string fromEmail = "no-reply@m61systems.com";
            string UserName = "Admin";
            List<string> emailidsBCC = new List<string>();

            string subject = (DrawFeeDC.InvoiceTypeID == 558 ? "ACORE Draw Fee Invoice" : "ACORE Processing Fee Invoice") + " - " + DrawFeeDC.DealName + " - " + DrawFeeDC.InvoiceNoUI;

            string HtmlTemplateName = "DrawFeeNotification.html";
            if (DrawFeeDC.InvoiceTypeID != 558)
            {
                HtmlTemplateName = "GenericInvoiceNotification.html";
            }
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
            if (!String.IsNullOrEmpty(DrawFeeDC.EmailCC))
            {
                DrawFeeDC.Email2 = DrawFeeDC.Email2.Replace(";", ",") + ',' + DrawFeeDC.EmailCC;
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
            string invoicetypeText = DrawFeeDC.InvoiceTypeName;
            if (!string.IsNullOrEmpty(DrawFeeDC.InvoiceTypeName))
            {
                try
                {
                    if (DrawFeeDC.InvoiceTypeName.Substring(DrawFeeDC.InvoiceTypeName.Length - 3).ToLower() != "fee"
                        && DrawFeeDC.InvoiceTypeName.Substring(DrawFeeDC.InvoiceTypeName.Length - 4).ToLower() != "fees")
                    {
                        invoicetypeText += " Fee";
                    }
                }
                catch
                {
                    invoicetypeText += " Fee";
                }
            }

            htmlContent = htmlContent.Replace("{fee}", invoicetypeText);

            if (DrawFeeDC.InvoiceTypeID != 558)
            {
                htmlContent = htmlContent.Replace("{invoicecomment}", DrawFeeDC.InvoiceComment);
            }


            string replyTo = (DrawFeeDC.Email1.Trim().Replace(";", ",") + "," + DrawFeeDC.Email2.Replace(";", ",")).Trim().Trim(',');
            //send email
            //EmailSender.SendEmailTOCCWithAttachment(fromEmail, DrawFeeDC.Email1.Trim().Split(','), DrawFeeDC.Email2.Trim().Split(','), subject, UserName, htmlContent, DrawFeeDC.filestream.ToArray(), DrawFeeDC.FileName);
            EmailSender.SendEmailTOCCReplyToWithAttachment(fromEmail, DrawFeeDC.Email1.Replace(";", ",").Trim().Split(','), DrawFeeDC.Email2.Replace(";", ",").Trim().Split(','), replyTo.Split(','), subject, UserName, htmlContent, DrawFeeDC.filestream.ToArray(), DrawFeeDC.FileName);


            //
        }

        public void SendValuationAfterCalculationEmail(DataTable dt, MemoryStream ms, string filename)
        {
            GetConfigSetting();
            string[] emailidsTo = null;
            string summary = "";
            UserRepository _userRepository = new UserRepository();
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string showlink = linkName.Substring(4);
            string subject = "";
            int moduleId = 821;
            int faileddeals = 0;
            int totaldeals = 0;

            List<EmailDataContract> lstEmailIDs = new List<EmailDataContract>();

            subject = "(" + showlink + ")" + " Valuation Module Calculation Summary";
            summary = " Deals for the valuation module have been successfully calculated. Please find below a summary of the failed deals..";

            string[] emailidsCC = null;
            StringBuilder strFailed = new StringBuilder();

            var temp1 = dt.Select("Status = 'Failed'");
            if (temp1 != null)
            {
                if (temp1.Length > 0)
                {
                    var filterdata1 = dt.Select("Status = 'Failed'").CopyToDataTable();
                    DataTable validationdeals = filterdata1.DefaultView.ToTable(true, "CREDealID");
                    faileddeals = validationdeals.Rows.Count;


                    strFailed.Append("<table id='Valuation'style='width:60% !important;'  >");
                    strFailed.Append("<tr id='trHeader'>");
                    strFailed.Append("<td>DealID</td><td>Deal Name</td><td>Message</td>");
                    strFailed.Append("</tr>");

                    foreach (DataRow dr1 in validationdeals.Rows)
                    {
                        string dealid = dr1["CREDealID"].ToString();
                        foreach (DataRow dr2 in filterdata1.Rows)
                        {
                            if (dr2["CREDealID"].ToString() == dealid)
                            {

                                strFailed.Append("<tr>");

                                strFailed.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important;width:70px !important;  >");
                                strFailed.Append(Convert.ToString(dr2["CREDealID"]));
                                strFailed.Append("</td>");

                                strFailed.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important;width:170px !important;  >");
                                strFailed.Append(Convert.ToString(dr2["DealName"]));
                                strFailed.Append("</td>");

                                strFailed.Append("<td style=text-align:left;padding-left:5px!important;padding-right:5px!important;width:320px;  >");
                                strFailed.Append(Convert.ToString(dr2["ErrorMessage"]));
                                strFailed.Append("</td>");
                                strFailed.Append("</tr>");

                                break;
                            }
                        }
                    }
                    strFailed.Append("</table>");
                }
            }

            DataTable totaldeal = dt.DefaultView.ToTable(true, "CREDealID");
            totaldeals = totaldeal.Rows.Count;

            int completeddeals = totaldeals - faileddeals;
            //emailidsTo = new[] { "msingh@hvantage.com" };
            //emailidsCC = new[] { "msingh@hvantage.com" };


            lstEmailIDs = _userRepository.GetEmailIdsByModuleandType(moduleId);
            var lstEmailIdsCcbyType = lstEmailIDs.Where(r => r.Type == 783);

            emailidsCC = lstEmailIdsCcbyType.Select(r => r.EmailID).ToArray();

            var lstEmailIdsTObyType = lstEmailIDs.Where(r => r.Type == 782);
            emailidsTo = lstEmailIdsTObyType.Select(r => r.EmailID).ToArray();

            string ServerName = Sectionroot.GetSection("ServerName").Value;
            if (ServerName != "M61-Acore")
            {
                emailidsTo = emailidsTo.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
                emailidsCC = emailidsCC.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
            }

            string fromEmail = "test@test.com";
            string HtmlTemplateName = "ValuationEmailNotification.html";

            string htmlContent = string.Empty;
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }

            if (strFailed.ToString() != null)
            {
                htmlContent = htmlContent.Replace("{message}", strFailed.ToString());
                htmlContent = htmlContent.Replace("{summary}", summary);
                htmlContent = htmlContent.Replace("{DealCount}", totaldeals.ToString());
                htmlContent = htmlContent.Replace("{completed}", completeddeals.ToString());
                htmlContent = htmlContent.Replace("{validation}", faileddeals.ToString());

            }
            EmailSender.SendEmailTOCCWithAttachmentASMemoryStream(fromEmail, emailidsTo, emailidsCC, subject, htmlContent, ms, filename);
        }

        public void SendFundingDrawBusinessdayEmails(DataTable dt)
        {
            //823 54  FundingDrawBusinessdayNotification
            GetConfigSetting();
            string[] emailidsTo = null;
            string summary = "";
            UserRepository _userRepository = new UserRepository();
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string showlink = linkName.Substring(4);
            string subject = "";
            int moduleId = 823;
            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;

            List<EmailDataContract> lstEmailIDs = new List<EmailDataContract>();

            subject = "(" + showlink + ")" + " Advances occurring in the next 10 business days";
            summary = " Below are the deals with advances occurring in the next 10 business days. Please take the necessary action or they will be automatically pushed out to next month in 5 business days from today.";

            string[] emailidsCC = null;
            StringBuilder str = new StringBuilder();

            str.Append("<table id='Valuation' >");
            str.Append("<tr id='trHeader'>");
            str.Append("<td style='width: 100px!important;'>Deal ID</td><td style='width: 200px!important;'>Deal Name</td><td style='width: 100px!important;'>Date</td><td style='width: 100px!important;'>Amount</td><td style='width: 150px!important;'>Purpose</td><td style='width: 150px!important;'>Primary AM</td>");
            str.Append("</tr>");


            foreach (DataRow dr1 in dt.Rows)
            {
                string dealurl = EmailBaseUrl + "#/dealdetail/" + dr1["CREDealID"].ToString();

                str.Append("<tr>");
                str.Append("<td style='text-align:left;' >");
                str.Append("<a href=" + dealurl + ">" + dr1["CREDealID"].ToString() + "</a>");
                str.Append("</td>");

                str.Append("<td style='text-align:left;'>");
                str.Append(Convert.ToString(dr1["DealName"]));
                str.Append("</td>");

                str.Append("<td style='text-align:right;'  >");
                str.Append(CommonHelper.ToDateTime(dr1["Date"]).Value.ToString("MM/dd/yyyy"));
                str.Append("</td>");

                str.Append("<td style='text-align:right;'  >");
                str.Append(string.Format("{0:C}", Math.Round(CommonHelper.StringToDecimal(dr1["Amount"]).Value, 2)));
                str.Append("</td>");

                str.Append("<td style='text-align:left;' >");
                str.Append(Convert.ToString(dr1["Purpose"]));
                str.Append("</td>");

                str.Append("<td style='text-align:left;' >");
                str.Append(Convert.ToString(dr1["AMUser"]));
                str.Append("</td>");

                str.Append("</tr>");

            }
            str.Append("</table>");
            //emailidsTo = new[] { "msingh@hvantage.com" };
            //emailidsCC = new[] { "msingh@hvantage.com" };


            lstEmailIDs = _userRepository.GetEmailIdsByModuleandType(moduleId);
            var lstEmailIdsCcbyType = lstEmailIDs.Where(r => r.Type == 783);
            emailidsCC = lstEmailIdsCcbyType.Select(r => r.EmailID).ToArray();

            var lstEmailIdsTObyType = lstEmailIDs.Where(r => r.Type == 782);
            emailidsTo = lstEmailIdsTObyType.Select(r => r.EmailID).ToArray();

            string ServerName = Sectionroot.GetSection("ServerName").Value;
            if (ServerName != "M61-Acore")
            {
                emailidsTo = emailidsTo.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
                emailidsCC = emailidsCC.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
            }

            string fromEmail = "test@test.com";
            string HtmlTemplateName = "FundingDrawNotification.html";

            string htmlContent = string.Empty;
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            if (str.ToString() != null)
            {
                htmlContent = htmlContent.Replace("{message}", str.ToString());
                htmlContent = htmlContent.Replace("{summary}", summary);
            }
            EmailSender.SendTOCCEmail(fromEmail, emailidsTo, emailidsCC.ToList(), subject, str.ToString(), "", htmlContent);
        }

        public void SendChathamFinancialDailyRateNotification(string Message, string type, string failorsuccess)
        {
            UserRepository _userRepository = new UserRepository();
            string[] emailidsTo = null;
            string[] emailidsCC = null;
            GetConfigSetting();
            string[] toEmail = null;
            int moduleId = 824;
            string subject = "";
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string showlink = linkName.Substring(4);

            if (failorsuccess == "")
            {
                if (type == "Daily")
                {
                    subject = "(" + showlink + ")" + " Daily SOFR Pull From CME Financial : " + DateTime.Now.ToString("MM/dd/yyyy");
                }
                else
                {
                    subject = "(" + showlink + ")" + " Quarterly SOFR forward curve rates has been pulled successfully Chatham Financial: " + DateTime.Now.ToString("MM/dd/yyyy");
                }
            }
            else
            {
                if (type == "Daily")
                {
                    subject = "(" + showlink + ")" + " Failed Daily SOFR Pull From CME Financial : " + DateTime.Now.ToString("MM/dd/yyyy");
                }
                else
                {
                    subject = "(" + showlink + ")" + " Failed Quarterly SOFR forward curve rates pull : " + DateTime.Now.ToString("MM/dd/yyyy");
                }
            }

            List<EmailDataContract> lstEmailIDs = new List<EmailDataContract>();
            string summary = Message;
            string fromEmail = "test@test.com";
            string HtmlTemplateName = "ChathamFinancialDailyRateNotification.html";


            //emailidsTo = new[] { "msingh@hvantage.com" };
            //emailidsCC = new[] { "msingh@hvantage.com" };

            lstEmailIDs = _userRepository.GetEmailIdsByModuleandType(moduleId);
            var lstEmailIdsCcbyType = lstEmailIDs.Where(r => r.Type == 783);
            emailidsCC = lstEmailIdsCcbyType.Select(r => r.EmailID).ToArray();

            var lstEmailIdsTObyType = lstEmailIDs.Where(r => r.Type == 782);
            emailidsTo = lstEmailIdsTObyType.Select(r => r.EmailID).ToArray();

            string ServerName = Sectionroot.GetSection("ServerName").Value;
            string htmlContent = string.Empty;


            if (ServerName != "M61-Acore")
            {
                emailidsTo = emailidsTo.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
                emailidsCC = emailidsCC.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
            }

            //using streamreader for reading my htmltemplate  
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            htmlContent = htmlContent.Replace("{shortmessage}", Message);
            if (!string.IsNullOrEmpty(htmlContent))
            {
                htmlContent = htmlContent.Replace("{summary}", summary);
            }

            EmailSender.SendTOCCEmail(fromEmail, emailidsTo, emailidsCC.ToList(), subject, htmlContent, null, htmlContent);

        }

        public void SendChathamFinancialQuarterlyForwardRateNotification(string Message, MemoryStream ms, string Filename)
        {
            UserRepository _userRepository = new UserRepository();
            string[] emailidsTo = null;
            string[] emailidsCC = null;
            GetConfigSetting();
            string[] toEmail = null;
            int moduleId = 824;
            string subject = "";
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string showlink = linkName.Substring(4);

            subject = "(" + showlink + ")" + " Quarterly SOFR forward curve rates has been pulled successfully Chatham Financial: " + DateTime.Now.ToString("MM/dd/yyyy");

            List<EmailDataContract> lstEmailIDs = new List<EmailDataContract>();
            string summary = Message;
            string fromEmail = "test@test.com";
            string HtmlTemplateName = "ChathamFinancialDailyRateNotification.html";

            //emailidsTo = new[] { "msingh@hvantage.com" };
            //emailidsCC = new[] { "msingh@hvantage.com" };

            lstEmailIDs = _userRepository.GetEmailIdsByModuleandType(moduleId);
            var lstEmailIdsCcbyType = lstEmailIDs.Where(r => r.Type == 783);
            emailidsCC = lstEmailIdsCcbyType.Select(r => r.EmailID).ToArray();

            var lstEmailIdsTObyType = lstEmailIDs.Where(r => r.Type == 782);
            emailidsTo = lstEmailIdsTObyType.Select(r => r.EmailID).ToArray();

            string ServerName = Sectionroot.GetSection("ServerName").Value;
            string htmlContent = string.Empty;


            if (ServerName != "M61-Acore")
            {
                emailidsTo = emailidsTo.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
                emailidsCC = emailidsCC.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
            }

            //using streamreader for reading my htmltemplate  
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            htmlContent = htmlContent.Replace("{shortmessage}", Message);
            if (!string.IsNullOrEmpty(htmlContent))
            {
                htmlContent = htmlContent.Replace("{summary}", summary);
            }
            EmailSender.SendEmailTOCCWithAttachmentASMemoryStream(fromEmail, emailidsTo, emailidsCC, subject, htmlContent, ms, Filename);

        }

        public void SendChathamFinancialDailyRateNotificationSucces(DataTable importeddata, DataTable copiedData, string ratesource)
        {
            UserRepository _userRepository = new UserRepository();
            string[] emailidsTo = null;
            string[] emailidsCC = null;
            GetConfigSetting();
            string[] toEmail = null;
            int moduleId = 824;
            string subject = "", summarycopy = "";
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string showlink = linkName.Substring(4);

            subject = "(" + showlink + ")" + " Daily SOFR Pull From " + ratesource + ": " + DateTime.Now.ToString("MM/dd/yyyy");

            List<EmailDataContract> lstEmailIDs = new List<EmailDataContract>();
            string summary = "Daily SOFR rates, Prime rate,Treasury rates from Chatham Financial" + " have been pulled successfully. Below is the summary of import. ";
            string fromEmail = "test@test.com";
            string HtmlTemplateName = "ChathamFinancialDailyRateNotificationSuccess.html";

            StringBuilder strimport = new StringBuilder();

            strimport.Append("<table id='strimport'>");
            strimport.Append("<tr id='trHeader'>");
            strimport.Append("<td style='width: 100px!important;' >Date</td><td  style='width: 100px!important;'>Value</td><td  style='width: 150px!important;'>Index Type</td>");
            strimport.Append("</tr>");

            foreach (DataRow dr2 in importeddata.Rows)
            {
                strimport.Append("<tr>");

                strimport.Append("<td style='text-align:right;'>");
                strimport.Append(CommonHelper.ToDateTime(dr2["Date"]).Value.ToString("MM/dd/yyyy"));
                strimport.Append("</td>");

                strimport.Append("<td style='text-align:right;'>");
                strimport.Append(CommonHelper.StringToDecimal(dr2["Value"]));
                strimport.Append("</td>");

                strimport.Append("<td style='text-align:left;'>");
                strimport.Append(Convert.ToString(dr2["IndexType"]));
                strimport.Append("</td>");
                strimport.Append("</tr>");


            }
            strimport.Append("</table>");
            StringBuilder strcopied = new StringBuilder();
            if (copiedData.Rows.Count > 0)
            {
                summarycopy = "SOFR for the below dates has been copied from prior business day.";

                strcopied.Append("<table id='strimport'  >");
                strcopied.Append("<tr id='trHeader'>");
                strcopied.Append("<td style='width: 100px!important;'>Date</td><td style='width: 100px!important;'> Value</td><td style='width: 150px!important;'>Index Type</td><td style='width: 100px!important;'>Update From Date</td>");
                strcopied.Append("</tr>");

                foreach (DataRow dr3 in copiedData.Rows)
                {
                    strcopied.Append("<tr>");
                    strcopied.Append("<td style='text-align:right;'>");
                    strcopied.Append(CommonHelper.ToDateTime(dr3["Calender_Date"]).Value.ToString("MM/dd/yyyy"));
                    strcopied.Append("</td>");

                    strcopied.Append("<td style='text-align:right;'>");
                    strcopied.Append(CommonHelper.StringToDecimal(dr3["Value"]));
                    strcopied.Append("</td>");

                    strcopied.Append("<td style='text-align:right;'>");
                    strcopied.Append(Convert.ToString(dr3["IndexTypeText"]));
                    strcopied.Append("</td>");

                    strcopied.Append("<td style='text-align:right;'>");
                    strcopied.Append(CommonHelper.ToDateTime(dr3["CopyFrom_Date"]).Value.ToString("MM/dd/yyyy"));
                    strcopied.Append("</td>");
                    strcopied.Append("</tr>");
                }
                strcopied.Append("</table>");
            }

            //emailidsTo = new[] { "nsharma@hvantage.com" };
            //emailidsCC = new[] { "nsharma@hvantage.com" };

            lstEmailIDs = _userRepository.GetEmailIdsByModuleandType(moduleId);
            var lstEmailIdsCcbyType = lstEmailIDs.Where(r => r.Type == 783);
            emailidsCC = lstEmailIdsCcbyType.Select(r => r.EmailID).ToArray();

            var lstEmailIdsTObyType = lstEmailIDs.Where(r => r.Type == 782);
            emailidsTo = lstEmailIdsTObyType.Select(r => r.EmailID).ToArray();

            string ServerName = Sectionroot.GetSection("ServerName").Value;
            string htmlContent = string.Empty;

            if (ServerName != "M61-Acore")
            {
                emailidsTo = emailidsTo.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
                emailidsCC = emailidsCC.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
            }

            //using streamreader for reading my htmltemplate  
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            if (!string.IsNullOrEmpty(htmlContent))
            {
                htmlContent = htmlContent.Replace("{summary}", summary);
                htmlContent = htmlContent.Replace("{importdata}", strimport.ToString());
                htmlContent = htmlContent.Replace("{summarycopied}", summarycopy.ToString());
                htmlContent = htmlContent.Replace("{copieddata}", strcopied.ToString());
            }
            EmailSender.SendTOCCEmail(fromEmail, emailidsTo, emailidsCC.ToList(), subject, htmlContent, null, htmlContent);

        }

        public void SendBalancediscrepancynotificationtoServicer(DataTable dtwells, DataTable dtBerkadia)
        {
            UserRepository _userRepository = new UserRepository();
            GetConfigSetting();
            string[] emailidsTo = null;
            string[] emailidsCC = null;
            string[] toEmail = null;

            string[] WellsemailidsTo = null;
            string[] WellsemailidsCC = null;

            int BerkadiamoduleId = 893;
            int WellsmoduleId = 895;

            string ServerName = Sectionroot.GetSection("ServerName").Value;
            //Berkadia emails id
            List<EmailDataContract> lstEmailIDs = new List<EmailDataContract>();
            lstEmailIDs = _userRepository.GetEmailIdsByModuleandType(BerkadiamoduleId);
            var lstEmailIdsCcbyType = lstEmailIDs.Where(r => r.Type == 783);
            emailidsCC = lstEmailIdsCcbyType.Select(r => r.EmailID).ToArray();

            var lstEmailIdsTObyType = lstEmailIDs.Where(r => r.Type == 782);
            emailidsTo = lstEmailIdsTObyType.Select(r => r.EmailID).ToArray();

            //Wells emails id
            List<EmailDataContract> lstWellsEmailIDs = new List<EmailDataContract>();
            lstWellsEmailIDs = _userRepository.GetEmailIdsByModuleandType(WellsmoduleId);
            
            var lstWellsEmailIdsCcbyType = lstWellsEmailIDs.Where(r => r.Type == 783);
            WellsemailidsCC = lstWellsEmailIdsCcbyType.Select(r => r.EmailID).ToArray();

            var lstWellsEmailIdsTObyType = lstWellsEmailIDs.Where(r => r.Type == 782);
            WellsemailidsTo = lstWellsEmailIdsTObyType.Select(r => r.EmailID).ToArray();

            string showlink = ServerName.Substring(4);

            string subject = "(" + showlink + ")" + " Balance Discrepancy Notification";

            string emailToWells = string.Empty;
            string emailCCWells = string.Empty;
            string emailToBerkadia = string.Empty;
            string emailCCBerkadia = string.Empty;

            if (dtwells.Rows.Count > 0)
            {
                DataRow topRowWells = dtwells.Rows[0];                 
                emailCCWells = topRowWells["EmailidCC"].ToString();
            }
            if (dtBerkadia.Rows.Count > 0)
            {
                DataRow topRowBerkadia = dtBerkadia.Rows[0];              
                emailCCBerkadia = topRowBerkadia["EmailidCC"].ToString();
            }
             
            //email for dtwells
            string[] emailidsToWells = emailToWells.Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries);
            string[] emailidsCCWells = emailCCWells.Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries);

            //add emails from db
            emailidsCCWells = emailidsCCWells.Concat(WellsemailidsCC).ToArray();
            emailidsToWells = emailidsToWells.Concat(WellsemailidsTo).ToArray();
            
            //email for dtBerkadia
            string[] emailidsToBerkadia = emailToBerkadia.Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries);
            string[] emailidsCCBerkadia = emailCCBerkadia.Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries);


            //add emails from db
            emailidsCCBerkadia = emailidsCCBerkadia.Concat(emailidsCC).ToArray();
            emailidsToBerkadia = emailidsToBerkadia.Concat(emailidsTo).ToArray();

            if (ServerName != "M61-Acore")
            {
                emailidsToWells = emailidsToWells.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
                emailidsCCWells = emailidsCCWells.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
                emailidsToBerkadia = emailidsToBerkadia.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
                emailidsCCBerkadia = emailidsCCBerkadia.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();


                emailidsToWells = emailidsToWells.Select(x => x.Replace("berkadia.com", "mailinator.com")).ToArray();
                emailidsCCWells = emailidsCCWells.Select(x => x.Replace("berkadia.com", "mailinator.com")).ToArray();
                emailidsToBerkadia = emailidsToBerkadia.Select(x => x.Replace("berkadia.com", "mailinator.com")).ToArray();
                emailidsCCBerkadia = emailidsCCBerkadia.Select(x => x.Replace("berkadia.com", "mailinator.com")).ToArray();

            }

            string fromEmail = "test@test.com";
            string HtmlTemplateName = "BalanceDiscrepancyNotification.html";
            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;

            string dealurl = EmailBaseUrl + "#/dealdetail/";

            // Generate HTML content for dtwells
            string htmlContentWells = GenerateHtmlContent(dtwells, dealurl);

            // Generate HTML content for dtBerkadia
            string htmlContentBerkadia = GenerateHtmlContent(dtBerkadia, dealurl);

            // Load HTML template
            string htmlTemplatePath = Path.Combine(_hostingEnvironment.ContentRootPath, "wwwroot", "EmailTemplate", HtmlTemplateName);
            string htmlTemplate;
            using (StreamReader reader = new StreamReader(htmlTemplatePath))
            {
                htmlTemplate = reader.ReadToEnd();
            }

            string[] ReplyToWells = emailidsToWells.Concat(emailidsCCWells).ToArray();
            string[] ReplyToBerkadia = emailidsToBerkadia.Concat(emailidsCCBerkadia).ToArray();

            //send email for dtwells
            if (!string.IsNullOrEmpty(htmlContentWells))
            {
                string formattedHtmlWells = htmlTemplate.Replace("{message}", htmlContentWells);
                EmailSender.SendTOCCEmailwithReplyTo(fromEmail, emailidsToWells, emailidsCCWells.ToList(), ReplyToWells, subject, null, null, formattedHtmlWells);
            }

            //send email for dtBerkadia
            if (!string.IsNullOrEmpty(htmlContentBerkadia))
            {
                string formattedHtmlBerkadia = htmlTemplate.Replace("{message}", htmlContentBerkadia);
                EmailSender.SendTOCCEmailwithReplyTo(fromEmail, emailidsToBerkadia, emailidsCCBerkadia.ToList(), ReplyToBerkadia, subject, null, null, formattedHtmlBerkadia);
            }

        }

        public string GenerateHtmlContent(DataTable dataTable,string dealurl)
        {
            StringBuilder strHTMLBuilder = new StringBuilder();
            CultureInfo culture = new CultureInfo("en-US");           
            
            foreach (DataRow myRow in dataTable.Rows)
            {
                dealurl = dealurl + myRow["CREDealid"].ToString();
                strHTMLBuilder.Append("<tr>");
                strHTMLBuilder.Append("<td style='text-align:left;'>");               
                strHTMLBuilder.Append("<a href=" + dealurl + ">" + myRow["CREDealid"].ToString() + "</a>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:left;'>");
                strHTMLBuilder.Append(myRow["DealName"].ToString());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:left;'>");
                strHTMLBuilder.Append(myRow["CRENoteID"].ToString());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:left;'>");
                strHTMLBuilder.Append(myRow["NoteName"].ToString());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:right;'>");
                strHTMLBuilder.Append(CommonHelper.ToDateTimeStringFormat(myRow["LastPaydown"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:left;'>");
                strHTMLBuilder.Append(myRow["PurposeType"].ToString());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:right;'>");
                strHTMLBuilder.Append(String.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow["LastPaydownAmount"]).Value, 2)));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:right;'>");
                strHTMLBuilder.Append(String.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow["M61_Balance"]).Value, 2)));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:right;'>");
                strHTMLBuilder.Append(String.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow["Servicer_Balance"]).Value, 2)));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:right;'>");
                strHTMLBuilder.Append(String.Format(culture, "{0:C}", Math.Round(CommonHelper.StringToDecimal(myRow["delta"]).Value, 2)));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:'>");
                strHTMLBuilder.Append(myRow["List_crenoteid"].ToString());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
            }

            return strHTMLBuilder.ToString();
        }

        public void SendGenericNotificationEmail(string body,string subjecttext)
        {

            GetConfigSetting();
            List<EmailDataContract> lstEmailIDs = new List<EmailDataContract>();
            UserRepository _userRepository = new UserRepository();
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string showlink = linkName.Substring(4);
            string subject = "";
            int moduleId = 898;            

            var listOfStrings = new List<string>();
            string[] emailidsCC = listOfStrings.ToArray(); ;
            string[] emailidsTo = null;

            emailidsTo = _userRepository.GetEmailIdsByModule(moduleId).ToArray();

            lstEmailIDs = _userRepository.GetEmailIdsByModuleandType(moduleId);
            var lstEmailIdsCcbyType = lstEmailIDs.Where(r => r.Type == 783);
            emailidsCC = lstEmailIdsCcbyType.Select(r => r.EmailID).ToArray();

            var lstEmailIdsTObyType = lstEmailIDs.Where(r => r.Type == 782);
            emailidsTo = lstEmailIdsTObyType.Select(r => r.EmailID).ToArray();

            subject = "(" + showlink + ") " + subjecttext;
            string fromEmail = "test@test.com";
            string HtmlTemplateName = "GenericNotification.html";             

            string htmlContent = string.Empty;
            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            
            htmlContent = htmlContent.Replace("{bodytext}", body);
            htmlContent = htmlContent.Replace("{UserName}", "All");
           
            EmailSender.SendTOCCEmail(fromEmail, emailidsTo, emailidsCC.ToList(), subject, htmlContent, null, htmlContent);

        }

        public string GenerateHtmlContentforADFDiscrepancy(DataTable dataTable)
        {
            StringBuilder strHTMLBuilder = new StringBuilder();

            foreach (DataRow myRow in dataTable.Rows)
            {
                strHTMLBuilder.Append("<tr>");
                strHTMLBuilder.Append("<td style='text-align:left;'>");
                strHTMLBuilder.Append(myRow["SourceName"].ToString());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:left;'>");
                strHTMLBuilder.Append(myRow["SchemaName"].ToString());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:left;'>");
                strHTMLBuilder.Append(myRow["TableName"].ToString());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:right;'>");
                strHTMLBuilder.Append(myRow["SourceCount"].ToInt32());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:right;'>");
                strHTMLBuilder.Append(myRow["DestinationCount(Snowflake)"].ToInt32());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:right;'>");
                strHTMLBuilder.Append(myRow["Delta"].ToInt32());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
            }

            return strHTMLBuilder.ToString();
        }

        public void SendEmailforADFDiscrepancy(DataTable dt)
        {
            GetConfigSetting();

            string ServerName = Sectionroot.GetSection("ServerName").Value;
            string showlink = ServerName.Substring(4);

            string subject = "(" + showlink + ") " + "ADF Discrepancy Acore Vs Snowflake";

            string[] emailidsTo = null;
            string[] emailidsCC = null;

            emailidsTo = new[] { "nsharma@hvantage.com", "akothari@hvantage.com", "vbalapure@hvantage.com", "msingh@hvantage.com", "kbhagwat@hvantage.com" };
            emailidsCC = new[] { "nsharma@hvantage.com", "akothari@hvantage.com", "vbalapure@hvantage.com", "msingh@hvantage.com", "kbhagwat@hvantage.com" };

            if (ServerName != "M61-Acore")
            {
                emailidsTo = emailidsTo.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
                emailidsCC = emailidsCC.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
            }

            string fromEmail = "test@test.com";
            string HtmlTemplateName = "ADFdiscrepancyTemplate.html";
            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;

            string htmlContent = GenerateHtmlContentforADFDiscrepancy(dt);

            string htmlTemplatePath = Path.Combine(_hostingEnvironment.ContentRootPath, "wwwroot", "EmailTemplate", HtmlTemplateName);
            string htmlTemplate;
            using (StreamReader reader = new StreamReader(htmlTemplatePath))
            {
                htmlTemplate = reader.ReadToEnd();
            }

            if (!string.IsNullOrEmpty(htmlContent))
            {
                string formattedHtml = htmlTemplate.Replace("{message}", htmlContent);
                EmailSender.SendTOCCEmail(fromEmail, emailidsTo, emailidsCC.ToList(), subject, formattedHtml, null, formattedHtml);
            }
        }

        public void SendEmailforZeroADFDiscrepancy()
        {
            GetConfigSetting();

            string ServerName = Sectionroot.GetSection("ServerName").Value;
            string showlink = ServerName.Substring(4);

            string subject = "(" + showlink + ") " + "ADF Discrepancy Acore Vs Snowflake";

            string[] emailidsTo = null;
            string[] emailidsCC = null;

            emailidsTo = new[] { "nsharma@hvantage.com", "akothari@hvantage.com", "vbalapure@hvantage.com", "msingh@hvantage.com", "kbhagwat@hvantage.com" };
            emailidsCC = new[] { "nsharma@hvantage.com", "akothari@hvantage.com", "vbalapure@hvantage.com", "msingh@hvantage.com", "kbhagwat@hvantage.com" };

            if (ServerName != "M61-Acore")
            {
                emailidsTo = emailidsTo.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
                emailidsCC = emailidsCC.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
            }

            string fromEmail = "test@test.com";
            string HtmlTemplateName = "NodiscrepancyTemplate.html";
            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;

            string htmlContent = "No ADF discrepancy found between ACORE and Snowflake.";

            string htmlTemplatePath = Path.Combine(_hostingEnvironment.ContentRootPath, "wwwroot", "EmailTemplate", HtmlTemplateName);
            string htmlTemplate;
            using (StreamReader reader = new StreamReader(htmlTemplatePath))
            {
                htmlTemplate = reader.ReadToEnd();
            }

            EmailSender.SendTOCCEmail(fromEmail, emailidsTo, emailidsCC.ToList(), subject, htmlContent, null, htmlContent);
        }

        public void SendDiscrepancyForCalcGapBtnDefAndFullyScenario(DataTable dt)
        {
            GetConfigSetting();

            string ServerName = Sectionroot.GetSection("ServerName").Value;
            string showlink = ServerName.Substring(4);

            string subject = "(" + showlink + ") Discrepancy: Calc gap btn Default and Calc Along scenarios";

            string[] emailidsTo = null;
            string[] emailidsCC = null;
            List<EmailDataContract> lstEmailIDs = new List<EmailDataContract>();
            UserRepository _userRepository = new UserRepository();
            int moduleId = 936;

            lstEmailIDs = _userRepository.GetEmailIdsByModuleandType(moduleId);

            var lstEmailIdsTObyType = lstEmailIDs.Where(r => r.Type == 782);
            emailidsTo = lstEmailIdsTObyType.Select(r => r.EmailID).ToArray();

            var lstEmailIdsCcbyType = lstEmailIDs.Where(r => r.Type == 783);
            emailidsCC = lstEmailIdsCcbyType.Select(r => r.EmailID).ToArray();

            if (ServerName != "M61-Acore")
            {
                emailidsTo = emailidsTo.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
                emailidsCC = emailidsCC.Select(x => x.Replace("acorecapital.com", "mailinator.com")).ToArray();
            }

            string fromEmail = "test@test.com";
            string HtmlTemplateName = "DiscrepancyForCalcGapBtnDefAndFullyScenario.html";
            string EmailBaseUrl = Sectionroot.GetSection("EmailBaseUrl").Value;

            StringBuilder strHTMLBuilder = new StringBuilder();

            foreach (DataRow myRow in dt.Rows)
            {
                strHTMLBuilder.Append("<tr>");
                strHTMLBuilder.Append("<td style='text-align:left;'>");
                strHTMLBuilder.Append(myRow["AnalysisName"].ToString());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:left;'>");
                strHTMLBuilder.Append(myRow["credealid"].ToString());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:left;'>");
                strHTMLBuilder.Append(myRow["DealName"].ToString());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:right;'>");
                strHTMLBuilder.Append(myRow["crenoteid"].ToString());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:right;'>");
                strHTMLBuilder.Append(myRow["NoteName"].ToString());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:right;'>");
                strHTMLBuilder.Append(myRow["EndTime_Default"].ToString());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:right;'>");
                strHTMLBuilder.Append(myRow["EndTime_Fully"].ToString());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:right;'>");
                strHTMLBuilder.Append(myRow["Datediff_HOUR"].ToString());
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
            }

            string htmlContent = strHTMLBuilder.ToString();

            string htmlTemplatePath = Path.Combine(_hostingEnvironment.ContentRootPath, "wwwroot", "EmailTemplate", HtmlTemplateName);
            string htmlTemplate;
            using (StreamReader reader = new StreamReader(htmlTemplatePath))
            {
                htmlTemplate = reader.ReadToEnd();
            }

            //if (!string.IsNullOrEmpty(htmlContent))
            //{
                string formattedHtml = htmlTemplate.Replace("{message}", htmlContent);
                EmailSender.SendTOCCEmail(fromEmail, emailidsTo, emailidsCC.ToList(), subject, formattedHtml, null, formattedHtml);
            //}
        }

        public void SendEmailforPrepayPayOffStatementwithAttachment(string EmailID, MemoryStream ms, string Filename,string dealname,string username,string summary)
        {
            string[] emailidsTo = null;
            string[] emailidsCC = null;
            GetConfigSetting();
            string subject = "";
            string linkName = Sectionroot.GetSection("ServerName").Value;
            string showlink = linkName.Substring(4);

            subject = "(" + showlink + ")" + " "+ dealname + " Payoff Statement ";
            Filename = "(" + showlink + ")" + " " + Filename;
            List<EmailDataContract> lstEmailIDs = new List<EmailDataContract>();
             // summary = "Please find the attached Payoff Statement for Deal " + dealname;
            string fromEmail = "test@test.com";
            string HtmlTemplateName = "PrepayPayOffStatementEmail.html";

            //emailidsTo = new[] { "nsharma@hvantage.com" };
            //emailidsCC = new[] { "nsharma@hvantage.com" };
            emailidsTo = new[] { EmailID };
            emailidsCC = new[] { EmailID };

            string htmlContent = string.Empty;

            using (StreamReader reader = new StreamReader(_hostingEnvironment.ContentRootPath + "//" + "wwwroot/EmailTemplate/" + HtmlTemplateName))
            {
                htmlContent = reader.ReadToEnd();
            }
            if (!string.IsNullOrEmpty(htmlContent))
            {
                htmlContent = htmlContent.Replace("{summary}", summary);
                htmlContent = htmlContent.Replace("{username}", username);
            }
            EmailSender.SendEmailTOCCWithAttachmentASMemoryStream(fromEmail, emailidsTo, emailidsCC, subject, htmlContent, ms, Filename);

        }
    }

}
