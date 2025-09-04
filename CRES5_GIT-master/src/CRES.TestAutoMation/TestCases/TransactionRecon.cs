using AutoItX3Lib;
using AventStack.ExtentReports;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using java.awt;
using java.awt.datatransfer;
using java.awt.@event;
//using java.awt;
//using java.awt.datatransfer;
//using java.awt.@event;
//using java.util.concurrent;
//using jdk.nashorn.@internal.runtime;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Remote;
using Org.BouncyCastle.Crypto.Generators;
using System;
using System.Collections.Generic;
using System.Text;
//using static com.sun.tools.classfile.Opcode;

namespace CRES.TestAutoMation.TestCases
{
    [TestFixture]
    class TransactioRecon : BaseClass
    {
        ExtentTest test = null;

        [Test]
        public void remittanceFile()
        {
            test = extent.CreateTest("Remittance file upload ").Info("Test started");
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
                    String TranscationReconUrl = BaseUrl + BaseConfiguration.TranscatioReconUrl();
                    util.OpenUrl(TranscationReconUrl);
                    System.Threading.Thread.Sleep(20000);
                    IWebElement element = driver.FindElement(deal.transsRemitt);
                    element.Click();
                    AutoItX3 autoit = new AutoItX3();
                    autoit.WinActivate("Open");
                    System.Threading.Thread.Sleep(2000);
                    autoit.Send("E:\\Data\\Code\\CRES5_GIT\\src\\CRES.TestAutoMation\\Inputs\\Remittance File Template.xlsx");
                    System.Threading.Thread.Sleep(2000);
                    autoit.Send("{Enter}");
                   // clipboard.setContents(strSelection, null);
                    System.Threading.Thread.Sleep(10000);
                    driver.FindElement(deal.uploadOkBtn).Click();
                    System.Threading.Thread.Sleep(9000);
                    Boolean SuccessMsg = driver.FindElement(deal.uploadSuccessMsg).Displayed;
                    Console.WriteLine(SuccessMsg);
                    var printMessages = "<p><b>Test FAILED!</b></p>";
                    if (SuccessMsg == true)
                    {
                        Console.WriteLine("File uploaded successfully");
                        test.Log(Status.Pass, "File uploaded successfully");
                    }
                    else
                    {
                        Console.WriteLine("File failed to upload");
                        printMessages += $"Message: <br>{"File failed to upload"}<br>";
                        test.Fail(printMessages);
                    }


                }



            }
            catch (Exception e)
            {

            }

            System.Threading.Thread.Sleep(10000);
        }

        [Test]
        public void manualTransactionsFile()
        {
            test = extent.CreateTest("Manual transaction file upload ").Info("Test started");
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
                    String TranscationReconUrl = BaseUrl + BaseConfiguration.TranscatioReconUrl();
                    util.OpenUrl(TranscationReconUrl);
                    System.Threading.Thread.Sleep(20000);
                    IWebElement element = driver.FindElement(deal.importManualTrans);
                    element.Click();
                    AutoItX3 autoit = new AutoItX3();
                    autoit.WinActivate("Open");
                    System.Threading.Thread.Sleep(2000);
                    autoit.Send("E:\\Data\\Code\\CRES5_GIT\\src\\CRES.TestAutoMation\\Inputs\\Manual Transaction File Template.xlsx");
                    System.Threading.Thread.Sleep(5000);
                    autoit.Send("{Enter}");
                    //clipboard.setContents(strSelection, null);
                    System.Threading.Thread.Sleep(10000);
                    driver.FindElement(deal.uploadOkBtn).Click();
                    System.Threading.Thread.Sleep(9000);
                    Boolean SuccessMsg = driver.FindElement(deal.uploadSuccessMsg).Displayed;
                    Console.WriteLine(SuccessMsg);
                    var printMessages = "<p><b>Test FAILED!</b></p>";
                    if (SuccessMsg == true)
                    {
                        Console.WriteLine("File uploaded successfully");
                        test.Log(Status.Pass, "File uploaded successfully");
                    }
                    else
                    {
                        Console.WriteLine("File failed to upload");
                        printMessages += $"Message: <br>{"File failed to upload"}<br>";
                        test.Fail(printMessages);
                    }


                }



            }
            catch (Exception e)
            {

            }

            System.Threading.Thread.Sleep(10000);
        }

        [Test]
        public void berkadiaFile()
        {

            test = extent.CreateTest("Berkadia file upload ").Info("Test started");
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
                    String TranscationReconUrl = BaseUrl + BaseConfiguration.TranscatioReconUrl();
                    util.OpenUrl(TranscationReconUrl);
                    System.Threading.Thread.Sleep(20000);
                    IWebElement element = driver.FindElement(deal.importBerkadiaFile);
                    element.Click();
                    AutoItX3 autoit = new AutoItX3();
                    autoit.WinActivate("Open");
                    System.Threading.Thread.Sleep(2000);
                    autoit.Send("E:\\Data\\Code\\CRES5_GIT\\src\\CRES.TestAutoMation\\Inputs\\Berkadia_File.xlsx");
                    System.Threading.Thread.Sleep(2000);
                    autoit.Send("{Enter}");
                    //clipboard.setContents(strSelection, null);
                    System.Threading.Thread.Sleep(10000);
                    driver.FindElement(deal.uploadOkBtn).Click();
                    System.Threading.Thread.Sleep(9000);
                    Boolean SuccessMsg = driver.FindElement(deal.uploadSuccessMsg).Displayed;
                    Console.WriteLine(SuccessMsg);
                    var printMessages = "<p><b>Test FAILED!</b></p>";
                    if (SuccessMsg == true)
                    {
                        Console.WriteLine("File uploaded successfully");
                        test.Log(Status.Pass, "File uploaded successfully");
                    }
                    else
                    {
                        Console.WriteLine("File failed to upload");
                        printMessages += $"Message: <br>{"File failed to upload"}<br>";
                        test.Fail(printMessages);
                    }


                }



            }
            catch (Exception e)
            {

            }

            System.Threading.Thread.Sleep(10000);
        }
        [OneTimeTearDown]
        public void sendEmail()
        {

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
            emailDC.Subject = "Transacton recon file upload report";
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
