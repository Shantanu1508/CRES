using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Internal;
using System;
using System.Linq.Expressions;
using System.Threading;
using WebDriverManager.DriverConfigs.Impl;

namespace CRES.TestAutoMation.Practice
{
    internal class MainTab
    {

        [Test]
        public void login()
        {
            try
            {


                new WebDriverManager.DriverManager().SetUpDriver(new ChromeConfig());
                IWebDriver driver = new ChromeDriver();

                string dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
                string BaseUrl = null;
                string env = BaseConfiguration.GetEnvironment();

                BaseUrl = env switch
                {
                    "QA" => BaseConfiguration.GetQAUrl(),
                    "Integration" => BaseConfiguration.GetIntUrl(),
                    "Staging" => BaseConfiguration.GetStagingUrl(),
                    _ => BaseConfiguration.GetQAUrl(),
                };

                driver.Navigate().GoToUrl(BaseUrl);
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


                //driver.Close();
                Util util = new Utility.Util(driver);
                Deal dealPage = new Deal(driver);
                Deal FundingPage = new Deal(driver);
            /*
                Actions actions = new Actions(driver);
                util.WaitForElementVisible(dealPage.mainTab);
                IWebElement MainTab = driver.FindElement(dealPage.mainTab);
                Thread.Sleep(3000);
                actions.MoveToElement(MainTab).Click().Perform();
                Thread.Sleep(3000);

                IWebElement Deal_ID = driver.FindElement(dealPage.dealID);
                Deal_ID.Click();
                Deal_ID.SendKeys("Demo Deal 14");

                Thread.Sleep(3000);

                IWebElement Deal_Name = driver.FindElement(dealPage.dealName);
                Deal_Name.Click();
                Deal_Name.SendKeys("15-1105");

                IWebElement DealSave = driver.FindElement(dealPage.btnSaveDeal);
                DealSave.Click();
            */
                //----------------------------------------Generate Automation----------------------------------//

                String GenerateAutomationUrl = BaseUrl + BaseConfiguration.GenerateAutomationUrl();
                util.OpenUrl(GenerateAutomationUrl);
                System.Threading.Thread.Sleep(8000);
                bool GenerateAutomationSave = false;
                try
                {
                    GenerateAutomationSave = dealPage.GenerateAutomationSaveButton();
                    //GenerateAutomationSave = driver.FindElement(dealPage.GenerateAutomationSave).Displayed;
                    Console.WriteLine("Generate Automation Save button display = " + GenerateAutomationSave);

                    var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (GenerateAutomationSave = true)
                    {
                        Console.WriteLine(" Generate Automation Page loaded successfully");
                    }
                    else
                    {
                        Console.WriteLine(" Generate Automation Page Filed to load");
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine("Generate Automation Page load exception" + e.ToString());
                }

                Thread.Sleep(8000);

                // Automation Log Tab
                driver.FindElement(dealPage.AutomationLogTab).Click();
                bool AutomationLogText = false;
                try
                {
                    AutomationLogText = dealPage.AutomationLogTextDisplay(); 
                    //AutomationLogText = driver.FindElement(dealPage.AutomationLogText).Displayed;
                    Console.WriteLine("Generate Automation Log text is displayed = " + AutomationLogText);

                    var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (AutomationLogText = true)
                    {
                        Console.WriteLine(" Generate Automation Log Page loaded successfully");
                    }
                    else
                    {
                        Console.WriteLine(" Generate Automation Log Page Filed to load");
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine("Generate Automation Log Page load exception" + e.ToString());
                }

            }
            catch (Exception e)
            {
                Console.WriteLine("Login Exception " + e.ToString());
            }
        }
    }
}
