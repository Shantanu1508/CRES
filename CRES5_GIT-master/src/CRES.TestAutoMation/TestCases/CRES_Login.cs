using AventStack.ExtentReports;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using NUnit.Framework;
using OpenQA.Selenium;
using System;
using System.Collections.Generic;

namespace CRES.TestAutoMation.TestCases

{
    [TestFixture]
    public class CRES_Login : BaseClass
    {
        ExtentTest test = null;

        [Test]
        public void VerifyLogin()
        {
            test = extent.CreateTest("Verify login with valid username and password").Info("Test started");
            List<AutoMationLoginDataContract> testparmeters = new List<AutoMationLoginDataContract>();
            Util util = new Util(driver);
            Login login = new Login(driver);

            var dataTable = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, "credential");
            if (dataTable != null)
            {
                AutoMationLoginDataContract ldc = new AutoMationLoginDataContract();
                ldc.UserName = dataTable.Rows[1].ItemArray[0].ToString();
                ldc.Password = dataTable.Rows[1].ItemArray[1].ToString();
                ldc.URL = dataTable.Rows[1].ItemArray[2].ToString();
                testparmeters.Add(ldc);
            }
            foreach (var res in testparmeters)
            {
                Deal deal = new Deal(driver);
                util.OpenUrl(res.URL.ToString());
                System.Threading.Thread.Sleep(15000);
                ////login in web site
                //login.LoginWebPage();
                IWebElement username = driver.FindElement(deal.username);
                username.SendKeys(res.UserName.ToString());
                IWebElement password = driver.FindElement(deal.password);
                password.SendKeys(res.Password.ToString());
                IWebElement btnlogin = driver.FindElement(deal.loginBtn);
                System.Threading.Thread.Sleep(10000);
                btnlogin.Click();
                System.Threading.Thread.Sleep(10000);
                string currentUrl = driver.Url;
                Console.WriteLine(currentUrl);

                Boolean dropdown = driver.FindElement(deal.krishnaDropdown).Displayed;
                var printMessages = "<p><b>Login FAILED!</b></p>";
                if (dropdown == true)
                {
                    Console.WriteLine("login successfully for username :- " + res.UserName + " and password :-" + res.Password);
                    test.Log(Status.Pass, "login successfully for username :- " + res.UserName + " and password :-" + res.Password);
                }
                else
                {
                    Console.WriteLine("login failed  for :- " + res.UserName + " and password :-" + res.Password);
                    printMessages += $"Message: <br>{"login failed  for :- " + res.UserName + " and password :-" + res.Password}<br>";
                    test.Fail(printMessages);
                }
            }
            //CRES_Login cresLogin = new CRES_Login();
            //cresLogin.verifyInvalidUsernameLogin();
        }

        [Test]
        public void verifyInvalidUsernameLogin()
        {

            test = extent.CreateTest("To verify login with invalid username").Info("Test started");
            //IWebDriver driver = new ChromeDriver();
            List<AutoMationLoginDataContract> testparmeters = new List<AutoMationLoginDataContract>();
            Util util = new Util(driver);

            Login login = new Login(driver);

            var dataTable = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, "credential");
            if (dataTable != null)
            {


                AutoMationLoginDataContract ldc = new AutoMationLoginDataContract();
                ldc.UserName = dataTable.Rows[3].ItemArray[0].ToString();
                ldc.Password = dataTable.Rows[3].ItemArray[1].ToString();
                ldc.URL = dataTable.Rows[3].ItemArray[2].ToString();
                //Console.WriteLine(i);
                testparmeters.Add(ldc);


            }
            foreach (var res in testparmeters)
            {
                Deal deal = new Deal(driver);
                util.OpenUrl(res.URL.ToString());
                System.Threading.Thread.Sleep(15000);
                ////login in web site
                //login.LoginWebPage();
                IWebElement username = driver.FindElement(deal.username);
                username.SendKeys(res.UserName.ToString());
                IWebElement password = driver.FindElement(deal.password);
                password.SendKeys(res.Password.ToString());
                IWebElement btnlogin = driver.FindElement(deal.loginBtn);
                btnlogin.Click();
                System.Threading.Thread.Sleep(5000);
                string loginAlertMsg = driver.FindElement(deal.loginAlertMsg).Text;
                Console.WriteLine(loginAlertMsg);
                System.Threading.Thread.Sleep(10000);
                var printMessages = "<p><b>Login FAILED!</b></p>";
                if (loginAlertMsg == "Username and password don't match to our records.")
                {
                    Console.WriteLine("login failed  for :- " + res.UserName + " and password :-" + res.Password);
                    test.Log(Status.Pass, "login failed for username :- " + res.UserName + " and password :-" + res.Password);

                }
                else
                {
                    Console.WriteLine("login successfully for username :- " + res.UserName + " and password :-" + res.Password);
                    printMessages += $"Message: <br>{"login failed  for :- " + res.UserName + " and password :-" + res.Password}<br>";
                    test.Fail(printMessages);
                }
            }
        }
        [Test]
        public void verifyInvalidPasswordLogin()
        {
            test = extent.CreateTest("Verify login with invalid password").Info("Test started");
            List<AutoMationLoginDataContract> testparmeters = new List<AutoMationLoginDataContract>();
            Util util = new Util(driver);
            Login login = new Login(driver);
            var dataTable = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, "credential");
            if (dataTable != null)
            {


                AutoMationLoginDataContract ldc = new AutoMationLoginDataContract();
                ldc.UserName = dataTable.Rows[4].ItemArray[0].ToString();
                ldc.Password = dataTable.Rows[4].ItemArray[1].ToString();
                ldc.URL = dataTable.Rows[4].ItemArray[2].ToString();
                //Console.WriteLine(i);
                testparmeters.Add(ldc);


            }
            foreach (var res in testparmeters)
            {
                Deal deal = new Deal(driver);
                util.OpenUrl(res.URL.ToString());
                System.Threading.Thread.Sleep(15000);
                ////login in web site
                //login.LoginWebPage();
                IWebElement username = driver.FindElement(deal.username);
                username.SendKeys(res.UserName.ToString());
                IWebElement password = driver.FindElement(deal.password);
                password.SendKeys(res.Password.ToString());
                IWebElement btnlogin = driver.FindElement(deal.loginBtn);
                btnlogin.Click();
                System.Threading.Thread.Sleep(10000);
                string loginAlertMsg = driver.FindElement(deal.loginAlertMsg).Text;
                Console.WriteLine(loginAlertMsg);
                System.Threading.Thread.Sleep(10000);
                var printMessages = "<p><b>Login FAILED!</b></p>";
                if (loginAlertMsg == "Username and password don't match to our records.")
                {
                    Console.WriteLine("login failed  for :- " + res.UserName + " and password :-" + res.Password);
                    test.Log(Status.Pass, "login failed for username :- " + res.UserName + " and password :-" + res.Password);

                }
                else
                {
                    Console.WriteLine("login successfully for username :- " + res.UserName + " and password :-" + res.Password);
                    printMessages += $"Message: <br>{"login sucessfully  for username :- " + res.UserName + " and password :-" + res.Password}<br>";
                    test.Fail(printMessages);
                }
            }

        }
        [Test]
        public void verifyInvalidUsernameAndPasswordLogin()
        {
            test = extent.CreateTest("Verify login with invalid username and invalid password").Info("Test started");
            List<AutoMationLoginDataContract> testparmeters = new List<AutoMationLoginDataContract>();
            Util util = new Util(driver);
            Login login = new Login(driver);
            var dataTable = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, "credential");
            if (dataTable != null)
            {
                AutoMationLoginDataContract ldc = new AutoMationLoginDataContract();
                ldc.UserName = dataTable.Rows[5].ItemArray[0].ToString();
                ldc.Password = dataTable.Rows[5].ItemArray[1].ToString();
                ldc.URL = dataTable.Rows[5].ItemArray[2].ToString();
                //Console.WriteLine(i);
                testparmeters.Add(ldc);
            }
            foreach (var res in testparmeters)
            {
                Deal deal = new Deal(driver);
                util.OpenUrl(res.URL.ToString());
                System.Threading.Thread.Sleep(10000);
                ////login in web site
                //login.LoginWebPage();
                IWebElement username = driver.FindElement(deal.username);
                username.SendKeys(res.UserName.ToString());
                IWebElement password = driver.FindElement(deal.password);
                password.SendKeys(res.Password.ToString());
                IWebElement btnlogin = driver.FindElement(deal.loginBtn);
                btnlogin.Click();
                System.Threading.Thread.Sleep(10000);
                string loginAlertMsg = driver.FindElement(deal.loginAlertMsg).Text;
                Console.WriteLine(loginAlertMsg);
                System.Threading.Thread.Sleep(10000);
                var printMessages = "<p><b>Login FAILED!</b></p>";
                if (loginAlertMsg == "Username and password don't match to our records.")
                {
                    Console.WriteLine("login failed  for :- " + res.UserName + " and password :-" + res.Password);
                    test.Log(Status.Pass, "Login failed for username :- " + res.UserName + " and password :-" + res.Password);

                }
                else
                {
                    Console.WriteLine("login successfully for username :- " + res.UserName + " and password :-" + res.Password);
                    printMessages += $"Message: <br>{"Login Successfully  for :- " + res.UserName + " and password :-" + res.Password}<br>";
                    test.Fail(printMessages);
                }
            }
        }

        [Test]
        public void verifyBlankUsernamePasswordLogin()
        {
            test = extent.CreateTest("To verify login with blank username and password").Info("Test started");
            List<AutoMationLoginDataContract> testparmeters = new List<AutoMationLoginDataContract>();
            Util util = new Util(driver);
            Login login = new Login(driver);
            var dataTable = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, "credential");
            if (dataTable != null)
            {


                AutoMationLoginDataContract ldc = new AutoMationLoginDataContract();
                ldc.URL = dataTable.Rows[5].ItemArray[2].ToString();
                //Console.WriteLine(i);
                testparmeters.Add(ldc);


            }
            foreach (var res in testparmeters)
            {
                Deal deal = new Deal(driver);
                util.OpenUrl(res.URL.ToString());
                System.Threading.Thread.Sleep(15000);
                ////login in web site
                //login.LoginWebPage();

                IWebElement btnlogin = driver.FindElement(deal.loginBtn);
                btnlogin.Click();
                System.Threading.Thread.Sleep(10000);
                //string url = "https://qacres4.azurewebsites.net/#/dashboard";
                //string currentUrl = driver.Url;
                var printMessages = "<p><b>Login FAILED!</b></p>";
                if (!btnlogin.GetAttribute("class").Contains("disabled"))
                {
                    Console.WriteLine("login failed  for username :- " + res.UserName + " and password :-" + res.Password);
                    test.Log(Status.Pass, "login failed for username :- " + res.UserName + " and password :-" + res.Password);

                }
                else
                {
                    Console.WriteLine("login successfully  for :- " + res.UserName + " and password :-" + res.Password);
                    printMessages += $"Message: <br>{"login successfully  for :- " + res.UserName + " and password :-" + res.Password}<br>";
                    test.Fail(printMessages);

                }
            }


        }



        // [Test]
        public void Login()
        {
            bool loginstatus = false;
            try
            {
                Util util = new Util(driver);
                Login login = new Login(driver);

                string username = BaseConfiguration.getusername();
                string password = BaseConfiguration.getpassword();
                string LoginUrl = BaseConfiguration.LoginUrl();

                util.OpenUrl(LoginUrl);
                ////login in web site
                login.LoginWebPage();
                loginstatus = true;
            }
            catch (Exception ex)
            {
                loginstatus = false;
                throw ex;
            }

            //return loginstatus;            
        }
        [OneTimeTearDown]
        public void sendEmail()
        {

            EmailDataContract emailDC = new EmailDataContract();
            emailDC.To = "rsahu@hvantage.com";//rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com

            //optional
            emailDC.Cc = "gthakur@hvantage.com";
            //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
            emailDC.ReceiverName = "All";
            emailDC.FileAttachment = new List<FileAttachmentDataContract>();
            //emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\ExcelReports\\" + pathExcel });
            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = "C:\\temp\\index.html" });
            emailDC.Subject = "Automation - Login Verification Report";
            emailDC.Body = "PFA the report.";
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
