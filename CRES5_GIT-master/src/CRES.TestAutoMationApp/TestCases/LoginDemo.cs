using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;


namespace CRES.TestAutoMation_Latest.TestCases
{
    public class LoginDemo
    {
      //  [Test]
      [Category("UITest")]
        public void login()
        {
            var chromeOptions = new ChromeOptions();
            chromeOptions.AddArgument("headless");

            using (var driver = new ChromeDriver(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), chromeOptions))
            {
                //Notice navigation is slightly different than the Java version
                //This is because 'get' is a keyword in C#
                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/login");

                //var wait = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
                System.Threading.Thread.Sleep(20000);

                // Find the text input element by its name
                IWebElement username = driver.FindElement(By.Name("login"));
                username.SendKeys("admin_qa");

                IWebElement password = driver.FindElement(By.Name("password"));
                password.SendKeys("qwert1*");

                IWebElement loginbtn = driver.FindElement(By.Id("login"));
                loginbtn.Click();

                // Now submit the form. WebDriver will find the form for us from the element
                //query.Submit();

                // Google's search is rendered dynamically with JavaScript.
                // Wait for the page to load, timeout after 10 seconds
                // var wait1 = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
                // wait.Until(d => d.Title.StartsWith("cheese", StringComparison.OrdinalIgnoreCase));

                //var wait1 = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
                // Should see: "Cheese - Google Search" (for an English locale)
                System.Threading.Thread.Sleep(20000);
                Assert.AreEqual(driver.Title, "M61–Dashboard");


            }

            /*
            IWebDriver driver = new ChromeDriver(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location),chromeOptions);

            driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/login");
            System.Threading.Thread.Sleep(10000);

            driver.Manage().Window.Maximize();
            System.Threading.Thread.Sleep(5000);

            IWebElement username = driver.FindElement(By.Name("login"));
            username.SendKeys("admin_qa");

            System.Threading.Thread.Sleep(5000);
            IWebElement password = driver.FindElement(By.Name("password"));
            password.SendKeys("qwert1*");


            System.Threading.Thread.Sleep(5000);
            IWebElement loginbtn = driver.FindElement(By.Id("login"));
            loginbtn.Click();


            System.Threading.Thread.Sleep(5000);

            
             driver.Close();
            */

            //EmailDataContract emailDC = new EmailDataContract();
            //emailDC.To = "sbanerjee@hvantage.com";//rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com

            ////optional
            ////emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
            ////emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
            //emailDC.ReceiverName = "All";
            //emailDC.FileAttachment = new List<FileAttachmentDataContract>();
            //////emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\ExcelReports\\" + pathExcel });
            ////emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = "C:\\temp\\index.html" });
            //emailDC.Subject = "Copy deal test report";
            //emailDC.Body = "PFA the verification report.";
            //emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
            //emailDC.EmailSettings.Host = BaseConfiguration.Host;
            //emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
            //emailDC.EmailSettings.Password = BaseConfiguration.Password;
            //emailDC.EmailSettings.Port = BaseConfiguration.Port;
            ////
            //EmailAutomationLogic lg = new EmailAutomationLogic();

            //String response = lg.SendGenericEmail(emailDC);

        }

        //[Test]
        public void SearchForChees()
        {

            var chromeOptions = new ChromeOptions();
            chromeOptions.AddArguments("headless");

            using (var driver = new ChromeDriver(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), chromeOptions))
            {
                //Notice navigation is slightly different than the Java version
                //This is because 'get' is a keyword in C#
                driver.Navigate().GoToUrl("http://www.google.com/");

                // Find the text input element by its name
                IWebElement query = driver.FindElement(By.Name("q"));

                // Enter something to search for
                query.SendKeys("Cheese");

                // Now submit the form. WebDriver will find the form for us from the element
                query.Submit();

                // Google's search is rendered dynamically with JavaScript.
                // Wait for the page to load, timeout after 10 seconds
                var wait = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
                wait.Until(d => d.Title.StartsWith("cheese", StringComparison.OrdinalIgnoreCase));

                // Should see: "Cheese - Google Search" (for an English locale)
                Assert.AreEqual(driver.Title, "Cheese - Google Search");
            }

        }
    }
}
