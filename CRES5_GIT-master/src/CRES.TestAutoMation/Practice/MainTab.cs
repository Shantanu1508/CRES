using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Interactions;
using System;
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

                driver.Navigate().GoToUrl("https://qacres4-ng.azurewebsites.net/#/login");
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

                Actions actions = new Actions(driver);

                driver.Navigate().GoToUrl("https://qacres4-ng.azurewebsites.net/#/dealdetail/00000000-0000-0000-0000-000000000000");

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

            }
            catch (Exception e)
            {
                Console.WriteLine("Login Exception " + e.ToString());
            }






        }

    }
}
