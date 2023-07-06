using AutoItX3Lib;
using AventStack.ExtentReports;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;
using System;
using System.Collections.Generic;

namespace CRES.TestAutoMation.TestCases
{
    public class EditIndexScenario : BaseClass
    {
        ExtentTest test = null;

        [Test]
        public void EditIndexScen()
        {
            test = extent.CreateTest("Edit Index Scenario ").Info("Test started");
            Actions actions = new Actions(driver);

            CRES_Login loginapp = new CRES_Login();
            Login login = new Login(driver);
            Deal deal = new Deal(driver);
            Util util = new Util(driver);
            string subLoginUrl;

            string dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
            //string username = BaseConfiguration.getusername();
            //string password = BaseConfiguration.getpassword();
            //string LoginUrl = BaseConfiguration.LoginUrl();
            string BaseUrl = null;
            string env = BaseConfiguration.GetEnvironment();

            BaseUrl = env switch
            {
                "QA" => BaseConfiguration.GetQAUrl(),
                "Integration" => BaseConfiguration.GetIntUrl(),
                "Staging" => BaseConfiguration.GetStagingUrl(),
                _ => BaseConfiguration.GetQAUrl(),
            };

            subLoginUrl = BaseConfiguration.GetLoginUrlNew();

            string LoginUrl = BaseUrl + subLoginUrl;
            util.OpenUrl(LoginUrl);


            System.Threading.Thread.Sleep(10000);
            try
            {
                if (login.LoginWebPage())
                {

                    string IndexUrl = BaseUrl + BaseConfiguration.IndexPageUrl();
                    util.OpenUrl(IndexUrl);
                    System.Threading.Thread.Sleep(20000);
                    driver.FindElement(deal.defaultIndex).Click();
                    System.Threading.Thread.Sleep(8000);

                    AutoItX3 autoit = new AutoItX3();
                    autoit.ClipPut("0.0012698");
                    IWebElement index = driver.FindElement(deal.mLabor);
                    index.Click();
                    System.Threading.Thread.Sleep(5000);
                    index.SendKeys(Keys.Control + 'v');
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(By.XPath("//*[@id=\"dialogboxfoot\"]/span")).Click();
                    System.Threading.Thread.Sleep(5000);

                    //index.Click();
                    driver.FindElement(By.XPath("//*[@id=\"flexIndexesDetail\"]/div[1]/div[2]/div[1]/div[3]")).Click();
                    System.Threading.Thread.Sleep(3000);

                    driver.FindElement(deal.defaultIndexSaveBtn).Click();

                    System.Threading.Thread.Sleep(3000);
                    String successMsg = driver.FindElement(deal.indexSuccessMsg).Text;
                    Console.WriteLine(successMsg);
                    var printMessages = "<p><b>Test FAILED!</b></p>";
                    if (successMsg == "Changes were saved successfully.")
                    {
                        Console.WriteLine("Index rate edited successfully");
                        test.Log(Status.Pass, "Index rate edited successfully");
                    }
                    else
                    {
                        Console.WriteLine("Edit index rate failed");
                        printMessages += $"Message: <br>{"Edit index rate failed"}<br>";
                        test.Fail(printMessages);

                    }
                }
            }
            catch (Exception e)
            {

            }
            EmailDataContract emailDC = new EmailDataContract();
            emailDC.To = "gthakur@hvantage.com";//rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com

            //optional
            //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
            //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
            emailDC.ReceiverName = "All";
            emailDC.FileAttachment = new List<FileAttachmentDataContract>();
            //emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\ExcelReports\\" + pathExcel });
            string path = ProjectBaseConfiguration.ExecutionReportFolder;
            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });
            emailDC.Subject = "Index Scenario report";
            emailDC.Body = "PFA the verification report.";
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