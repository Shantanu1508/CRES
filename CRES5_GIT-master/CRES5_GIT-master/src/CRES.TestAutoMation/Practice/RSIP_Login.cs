using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using SeleniumExtras.WaitHelpers;
using System;

namespace CRES.TestAutoMation.Practice
{
    [TestFixture]
    public class RSIP_Login
    {
        public static IWebDriver driver { get; set; }

        public bool loginFun()
        {

            bool res = false;
            try
            {

                driver = new ChromeDriver();

                driver.Manage().Window.Maximize();
                System.Threading.Thread.Sleep(3000);
                driver.Navigate().GoToUrl("https://rsip-dev.azurewebsites.net/");
                WebDriverWait w = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
                w.Until(ExpectedConditions.ElementExists(By.ClassName("logo")));

                IWebElement username = driver.FindElement(By.Id("mat-input-0"));
                username.SendKeys("sdasari@hvantage.com");

                IWebElement password = driver.FindElement(By.Id("mat-input-1"));
                password.SendKeys("bQc9%G3q");

                IWebElement loginbtn = driver.FindElement(By.XPath("/html/body/app-root/div/mat-sidenav-container/mat-sidenav-content/app-login/div/div/div[1]/form/div[3]/button[1]/span"));
                loginbtn.Click();
                WebDriverWait w1 = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
                w1.Until(ExpectedConditions.ElementExists(By.XPath("/html/body/app-root/div/mat-toolbar/a")));
                res = true;
            }
            catch (Exception ex)
            {
                res = false;

            }

            return res;
        }
    }
}

