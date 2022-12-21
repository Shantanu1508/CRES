using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.Utility;
using OpenQA.Selenium;
using System;
using System.Collections.Generic;

namespace CRES.TestAutoMation.EmailTemplate
{
    class Email
    {

        public void ValidationFile(String FilePath, String Message, IWebDriver driver)
        {
            Utility.Util util = new Utility.Util(driver);
            string loggedInUserName = util.GetLoggedInUserName();
            string path = ProjectBaseConfiguration.ExecutionReportFolder;
            EmailDataContract emailDC = new EmailDataContract();
            emailDC.To = "rsahu@hvantage.com";
            //emailDC.To = "rsahu@hvantage.com,krishna@hvantage.com";

            // optional
            emailDC.Cc = "sbanerjee@hvantage.com,msingh@hvantage.com,vbalapure@hvantage.com,ssingh@hvantage.com,shantanu@hvantage.com";
            //  emailDC.Bcc = "skhan@hvantage.com";
            emailDC.ReceiverName = "All";
            emailDC.FileAttachment = new List<FileAttachmentDataContract>();
            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });
            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = FilePath });
            emailDC.Subject = "Automation - Deal Funding Validation Report";
            emailDC.Body = "PFA the report. This  report might be incomplete as some deals does not gets loaded timely during automation process. These deals should be processed manually." + "<br />" + "<br />" + "Ran by: " + loggedInUserName + "<br />" + "Message/Error: " + Message;
            emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
            emailDC.EmailSettings.Host = BaseConfiguration.Host;
            emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
            emailDC.EmailSettings.Password = BaseConfiguration.Password;
            emailDC.EmailSettings.Port = BaseConfiguration.Port;

            EmailAutomationLogic lg = new EmailAutomationLogic();

            String response = lg.SendGenericEmail(emailDC);
        }
        public void sendInitialEmail(int TotalDeals, int CompletedDeals, DateTime StartTime, IWebDriver driver)
        {
            Utility.Util util = new Utility.Util(driver);
            string path = ProjectBaseConfiguration.ExecutionReportFolder;
            EmailDataContract emailDC = new EmailDataContract();
            emailDC.To = "rsahu@hvantage.com,shantanu@hvantage.com";
            //emailDC.To = "rdubal@hvantage.com,rsahu@hvantage.com,krishna@hvantage.com";
            //emailDC.Cc = "sbanerjee@hvantage.com,msingh@hvantage.com,vbalapure@hvantage.com,ssingh@hvantage.com,shantanu@hvantage.com";
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


        public void sendProgressEmail(int TotalDeals, int CompletedDeals, DateTime StartTime, IWebDriver driver)
        {
            Utility.Util util = new Utility.Util(driver);
            string path = ProjectBaseConfiguration.ExecutionReportFolder;
            EmailDataContract emailDC = new EmailDataContract();
            emailDC.To = "shantanu@hvantage.com,rsahu@hvantage.com,vbalapure@hvantage.com,ssingh@hvantage.com,sbanerjee@hvantage.com";
            //emailDC.To = "rsahu@hvantage.com,krishna@hvantage.com";
            //emailDC.Cc = "sbanerjee@hvantage.com,msingh@hvantage.com,vbalapure@hvantage.com,ssingh@hvantage.com";
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

        public void TestEmail()
        {
            EmailDataContract emailDC = new EmailDataContract();
            emailDC.To = "rsahu@hvantage.com,shantanu@hvantage.com";
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
