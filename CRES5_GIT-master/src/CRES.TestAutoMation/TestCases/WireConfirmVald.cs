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
    class WireConfirmVald : BaseClass
    {
        ExtentTest test = null;
        [Test]
        public void WireConfirm()
        {
            test = extent.CreateTest("Wire confirm validation ").Info("Test started");

            Actions actions = new Actions(driver);

            Login_Verification loginapp = new Login_Verification();
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
                    String DealUrl = BaseUrl + "#/dealdetail/17-1673";
                    util.OpenUrl(DealUrl);
                    System.Threading.Thread.Sleep(15000);
                    driver.FindElement(deal.fundingTab).Click();
                    System.Threading.Thread.Sleep(8000);
                    IWebElement grid = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[5]/div/div[4]"));
                    System.Threading.Thread.Sleep(2000);
                    Actions action = new Actions(driver);
                    actions.MoveToElement(grid);
                    System.Threading.Thread.Sleep(2000);
                    actions.Perform();
                    System.Threading.Thread.Sleep(10000);
                    /*EventFiringWebDriver eventFiringWebDriver = new EventFiringWebDriver(driver);
                    eventFiringWebDriver.ExecuteScript("document.querySelector('#dealfunding > div:nth-child(1) > div:nth-child(2)').scrollTop=5");
                    System.Threading.Thread.Sleep(8000);*/
                    IWebElement dropDown = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[7]"));
                    dropDown.Click();
                    IWebElement drop = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[7]/div/span"));
                    drop.Click();
                    System.Threading.Thread.Sleep(5000);
                    IWebElement capitalInt = driver.FindElement(By.XPath("/html/body/div[2]/div[2]"));
                    capitalInt.Click();
                    System.Threading.Thread.Sleep(5000);
                    IWebElement saveBtn = driver.FindElement(deal.btnSaveDeal);
                    saveBtn.Click();

                    System.Threading.Thread.Sleep(5000);
                    Boolean validationPopUp = driver.FindElement(deal.validationPopUp).Displayed;
                    var printMessages = "<p><b>Test FAILED!</b></p>";
                    if (validationPopUp == true)
                    {
                        Console.WriteLine("Validation pop up displayed");
                        test.Log(Status.Pass, "Validation pop up displayed");
                    }
                    else
                    {
                        Console.WriteLine("Validation pop up not shown");
                        printMessages += $"Message: <br>{"Validation pop up not shown"}<br>";
                        test.Fail(printMessages);
                    }

                }
                else
                {
                    Console.WriteLine("Login Failed");
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
            emailDC.Subject = "Wire confirm validation report";
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
