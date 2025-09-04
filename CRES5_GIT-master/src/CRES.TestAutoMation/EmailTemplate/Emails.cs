using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.Utility;
using NUnit.Framework;
using OpenQA.Selenium;
using System;
using System.Collections.Generic;

namespace CRES.TestAutoMation.EmailTemplate
{
    class Email
    {

        public void ValidationFile(String FilePath, String Message, IWebDriver driver)
        {
            string sendValidationReportEmail = BaseConfiguration.SendValidationReportEmail();
            if (sendValidationReportEmail.ToString().ToLower() == "yes")
            {
            Utility.Util util = new Utility.Util(driver);
            string loggedInUserName = util.GetLoggedInUserName();
            string path = ProjectBaseConfiguration.ExecutionReportFolder;
            EmailDataContract emailDC = new EmailDataContract();
            emailDC.To = "rsahu@hvantage.com";
            //emailDC.Cc = "msingh@hvantage.com,vbalapure@hvantage.com,ssingh@hvantage.com";
             emailDC.ReceiverName = "All";
            emailDC.FileAttachment = new List<FileAttachmentDataContract>();
            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\ExtentReportResults.html" });
            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = FilePath });
            emailDC.Subject = "Automation - Deal Funding Validation Report1";
            emailDC.Body = "PFA the report. This  report might be incomplete as some deals does not gets loaded timely during automation process. These deals should be processed manually." + "<br />" + "<br />" + "Ran by: " + loggedInUserName + "<br />" + "Message/Error: " + Message;
            emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
            emailDC.EmailSettings.Host = BaseConfiguration.Host;
            emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
            emailDC.EmailSettings.Password = BaseConfiguration.Password;
            emailDC.EmailSettings.Port = BaseConfiguration.Port;

            EmailAutomationLogic lg = new EmailAutomationLogic();
            String response = lg.SendGenericEmail(emailDC);
            }
        }

        public void ExcelValidationFile(String FilePath, String Message, IWebDriver driver)
        {
            Util util = new Util(driver);
            string loggedInUserName = util.GetLoggedInUserName();
            string path = ProjectBaseConfiguration.ExecutionReportFolder;
            EmailDataContract emailDC = new EmailDataContract();
            emailDC.To = "rsahu@hvantage.com";
            //emailDC.Cc = "msingh@hvantage.com,vbalapure@hvantage.com,ssingh@hvantage.com";
            emailDC.ReceiverName = "All";
            emailDC.FileAttachment = new List<FileAttachmentDataContract>();
            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });
            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = FilePath });
            emailDC.Subject = "Automation - Export to Excel Validation Report2";
            emailDC.Body = "PFA of the report. This  report might be incomplete as some deals does not gets loaded timely during automation process. These deals should be processed manually." + "<br />" + "<br />" + "Ran by: " + loggedInUserName + "<br />" + "Message/Error: " + Message;
            emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
            emailDC.EmailSettings.Host = BaseConfiguration.Host;
            emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
            emailDC.EmailSettings.Password = BaseConfiguration.Password;
            emailDC.EmailSettings.Port = BaseConfiguration.Port;

            EmailAutomationLogic lg = new EmailAutomationLogic();

            String response = lg.SendGenericEmail(emailDC);
        }


        public void SendInitializationEmail(int TotalDeals, DateTime StartTime, IWebDriver driver)
        {
            string SendInitializationEmail = BaseConfiguration.SendInitializationEmail();
            if (SendInitializationEmail.ToString().ToLower() == "yes")
            {
                Utility.Util util = new Utility.Util(driver);
                //string path = ProjectBaseConfiguration.ExecutionReportFolder;
                EmailDataContract emailDC = new EmailDataContract();
                emailDC.To = "rsahu@hvantage.com";
                //emailDC.Cc = "msingh@hvantage.com,vbalapure@hvantage.com,ssingh@hvantage.com";
                string loggedInUserName = util.GetLoggedInUserName();
                emailDC.ReceiverName = "All";
                emailDC.Subject = "Automation Started";
                emailDC.Body = "A new automation run has been started." + "<br/>" + "<br/>" + "Total Deals: " + TotalDeals + "<br/>" + "Environment: " + BaseConfiguration.GetEnvironment() + "<br/>" + "Browser: " + BaseConfiguration.Browser() + "<br/>" + "ExcelDealIDTabName: " + BaseConfiguration.ExcelDealIDTab() + "<br/>"+ "SendValidationEmail: " + BaseConfiguration.SendValidationReportEmail() + "<br/>" + "TakeScreenshots: " + BaseConfiguration.TakeScreenshot() + "<br />" + "<br />" + "Initiated by: " + loggedInUserName + "<br/>" + "Initiated at: " + StartTime;
                emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
                emailDC.EmailSettings.Host = BaseConfiguration.Host;
                emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
                emailDC.EmailSettings.Password = BaseConfiguration.Password;
                emailDC.EmailSettings.Port = BaseConfiguration.Port;
                //
                EmailAutomationLogic lg = new EmailAutomationLogic();

                lg.SendGenericEmail(emailDC);
            }
             
        }


        public void sendProgressEmail(int TotalDeals, int CompletedDeals, DateTime StartTime, IWebDriver driver)
        {
            Utility.Util util = new Utility.Util(driver);
            string path = ProjectBaseConfiguration.ExecutionReportFolder;
            EmailDataContract emailDC = new EmailDataContract();
            emailDC.To = "rsahu@hvantage.com";
            //emailDC.Cc = "msingh@hvantage.com,vbalapure@hvantage.com,ssingh@hvantage.com";
            string loggedInUserName = util.GetLoggedInUserName();
            emailDC.ReceiverName = "All";
            emailDC.Subject = "Automation Progress - " + CompletedDeals + "/" + TotalDeals + " deals completed";
            emailDC.Body = "Total Deals: " + TotalDeals + "    " + "Completed Deals: " + CompletedDeals + "    " + "Remaining Deals: " + (TotalDeals - CompletedDeals) + "<br />" + "<br />" + "Initiated by: " + loggedInUserName + "<br />" + "Initiated at: " + StartTime;
            emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
            emailDC.EmailSettings.Host = BaseConfiguration.Host;
            emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
            emailDC.EmailSettings.Password = BaseConfiguration.Password;
            emailDC.EmailSettings.Port = BaseConfiguration.Port;
            //
            EmailAutomationLogic lg = new EmailAutomationLogic();

            String response = lg.SendGenericEmail(emailDC);
        }

        public void MergeallFilesAndEmail(string randomstring, String ex, IWebDriver driver)
        {

            try
            {
                String FilePath = ExcelUtility.MergeAllFiles(randomstring);
                ValidationFile(FilePath, ex, driver);
            }
            catch (Exception e)
            {
            }
        }

        public void MergeallExcelFilesAndEmail(string randomstring, String ex, IWebDriver driver)
        {

            try
            {
                String FilePath = ExcelUtility.MergeAllExportToExcelFiles(randomstring);
                ValidationFile(FilePath, ex, driver);
            }
            catch (Exception e)
            {
            }
        }


        [Test]
        public void TestEmail()
        {
            EmailDataContract emailDC = new EmailDataContract();
            emailDC.To = "rsahu@hvantage.com";
            emailDC.ReceiverName = "All";
            emailDC.Subject = "Automation Progress - ";
            emailDC.Body = "Total Deals: ";
            emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
            emailDC.EmailSettings.Host = BaseConfiguration.Host;
            emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
            emailDC.EmailSettings.Password = BaseConfiguration.Password;
            emailDC.EmailSettings.Port = BaseConfiguration.Port;
            //
            EmailAutomationLogic lg = new EmailAutomationLogic();

            String response = lg.SendGenericEmail(emailDC);
        }
    }
}
