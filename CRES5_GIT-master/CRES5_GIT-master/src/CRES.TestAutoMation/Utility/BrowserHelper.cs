using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System.Diagnostics;

namespace CRES.TestAutoMation.Utility
{
    public class BrowserHelper
    {
        public IWebDriver initializeDriver(IWebDriver driver)
        {
            ChromeOptions options = new ChromeOptions();
            options.AddArguments("--window-size=1366x768");
            //options.AddArguments("headless");
            options.AddArguments("--incognito");
            options.AddArguments("start-maximized");
            options.AddArguments("disable-infobars");
            options.AddArguments("--disable-notifications");
            options.AddExcludedArgument("enable-automation");
            //options.AddAdditionalCapability("useAutomationExtension", false);
            options.SetLoggingPreference(LogType.Browser, LogLevel.Warning);
            driver = new ChromeDriver(options);
            driver.Manage().Window.Maximize();
            return driver;
        }

        public void DeleteChromeDriverInstances()
        {
            // Kill chromedriver instances left from previous runs, if any.
            Process[] chromeDriverProcesses = Process.GetProcessesByName("chromedriver");

            foreach (var chromeDriverProcess in chromeDriverProcesses)
            {
                chromeDriverProcess.Kill();
            }
        }

        public void DeleteChromeInstances()
        {
            // Kill chromedriver instances
            Process[] chromeDriverProcesses = Process.GetProcessesByName("chrome");

            foreach (var chromeDriverProcess in chromeDriverProcesses)
            {
                chromeDriverProcess.Kill();
            }
        }
    }



}
