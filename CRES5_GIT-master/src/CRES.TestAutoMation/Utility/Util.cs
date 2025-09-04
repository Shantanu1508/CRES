using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Support.UI;
using System;
using System.IO;
using System.Threading;

namespace CRES.TestAutoMation.Utility
{
   public class Util
    {

        private IWebDriver driver = null;
        IAlert simpleAlert; 
        public Util(IWebDriver d)
        {
            driver = d;
        }
        public void captureScreenshot(string imagename)
        {
            String TakesScreenshot = BaseConfiguration.TakeScreenshot();
            if (TakesScreenshot.ToString().ToLower() == "yes")
            {
                Screenshot ss = ((ITakesScreenshot)driver).GetScreenshot();
                string screenshot = ss.AsBase64EncodedString;
                byte[] screenshotAsByteArray = ss.AsByteArray;
                string path = ProjectBaseConfiguration.ScreenShotFolder;
                ss.SaveAsFile(path + imagename + "_" + GetTimestamp(DateTime.Now) + ".Png");
            }
        }

        public void captureScreenshotMultiBrowser(string imagename, IWebDriver sdriver)
        {
            //code
            String TakesScreenshot = BaseConfiguration.TakeScreenshot();
            if (TakesScreenshot.ToString().ToLower() == "yes")
            {
                Screenshot ss = ((ITakesScreenshot)sdriver).GetScreenshot();
                string screenshot = ss.AsBase64EncodedString;
                byte[] screenshotAsByteArray = ss.AsByteArray;
                string path = ProjectBaseConfiguration.ScreenShotFolder;
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }
                ss.SaveAsFile(path + imagename + "_" + GetTimestamp(DateTime.Now) + ".Png");
            }
        }

        public static String GetTimestamp(DateTime value)
        {
            return value.ToString("MM_dd_yyyy_HH_mm_ss");

        }

        public IWebElement WaitForElementVisible(By locator)
        {

            WebDriverWait wait = new WebDriverWait(driver, System.TimeSpan.FromSeconds(30));
            IWebElement element = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(locator));
            return element;
        }       

        public IWebElement LongWaitForElementVisible(By locator)
        {

            WebDriverWait wait = new WebDriverWait(driver, System.TimeSpan.FromMinutes(5));
            IWebElement element = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(locator));
            return element;
        }

        public IWebElement WaitForElementVisibleNew(IWebElement element)
        {

            WebDriverWait wait = new WebDriverWait(driver, System.TimeSpan.FromSeconds(15));
            wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id("content-section")));
            return element;
        }


        public IWebElement WaitForElementClickable(By locator)
        {

            WebDriverWait wait = new WebDriverWait(driver, System.TimeSpan.FromSeconds(7));
            IWebElement element = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(locator));
            return element;
        }
        public bool ClickElement(By locator)
        {
            bool returnValue = false;
            try
            {
                WaitForElementVisible(locator).Click();
                returnValue = true;
            }
            catch (NoSuchElementException e)
            {
                Console.WriteLine("Element " + locator + "not found on page " + driver.Title);
                returnValue = false;
            }
            catch (Exception e)
            {
                Console.WriteLine("Unknown error " + e.Message + " occurred on page " + driver.Title);
                returnValue = false;
            }
            return returnValue;
        }
        public bool IsElementVisible(By locator)
        {
            bool returnValue = false;
            try
            {
                returnValue = WaitForElementVisible(locator).Displayed;
            }
            catch (NoSuchElementException e)
            {
                Console.WriteLine("Element " + locator + "not found on page " + driver.Title);
                returnValue = false;
            }
            catch (Exception e)
            {
                Console.WriteLine("Unknown error " + e.Message + " occurred on page " + driver.Title);
                returnValue = false;
            }
            return returnValue;
        }


        public string GetElementText(By locator)
        {
            return driver.FindElement(locator).Text;
        }
        public bool CheckElementVisible(By locator)
        {
            bool returnValue = false;
            try
            {
                returnValue =driver.FindElement(locator).Displayed;
            }
            catch (NoSuchElementException e)
            {

                returnValue = false;
            }
            catch (Exception e)
            {
                returnValue = false;
            }
            return returnValue;
        }

        public void OpenUrl(string url)
        {
             driver.Navigate().GoToUrl(url);
            //driver.Manage().Window.Maximize();
        }

        public void OpenUrlMultiBrowser(string url, IWebDriver driver)
        {            
                driver.Navigate().GoToUrl(url);
                Console.WriteLine(url);
                Thread.Sleep(5000);
            }

        //method
        public void ImplicitWait(double timeinsecs)
        {
            driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(timeinsecs);

        }

        public bool ElementDisplayed(By locator)
        {
            new WebDriverWait(driver, TimeSpan.FromSeconds(20)).Until(condition: SeleniumExtras.WaitHelpers.ExpectedConditions.PresenceOfAllElementsLocatedBy(locator));
            return driver.FindElement(locator).Displayed;
        }

        public void WaitForPageLoad(IWebDriver driver)
        {
            IWebElement page = null;
            if (page != null)
            {
                var waitForCurrentPageToStale = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
                waitForCurrentPageToStale.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.StalenessOf(page));
            }

            var waitForDocumentReady = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
            waitForDocumentReady.Until((wdriver) => (driver as IJavaScriptExecutor).ExecuteScript("return document.readyState").Equals("complete"));

            page = driver.FindElement(By.TagName("html"));

        }

        public string GetLoggedInUserName()
        {
            string loggedInUserName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
            return loggedInUserName;
        }
    }

}
