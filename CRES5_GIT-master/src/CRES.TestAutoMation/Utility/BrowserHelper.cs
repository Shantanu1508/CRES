using java.util.concurrent;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Edge;
using sun.misc;
using System;
using System.Diagnostics;

namespace CRES.TestAutoMation.Utility
{
    public class BrowserHelper
    {
        public static WebDriver InitializeChromeDriver()
        {
            try
            {
                WebDriver driver = null;
                string headless = BaseConfiguration.HeadlessDriver();
                ChromeOptions options = new ChromeOptions();
                //options.AddUserProfilePreference("credentials_enable_service", false);
                //options.AddUserProfilePreference("profile.password_manager_enabled", false);

                if (headless.ToLower() == "yes")
                {
                    options.AddArguments("--headless=new");
                    options.AddArguments("--window-size=1920,1200");
                } else {
                    options.AddArguments("start-maximized");
                }
                options.AddArguments("--incognito");
                options.AddArguments("disable-infobars");
                options.AddArguments("--disable-notifications");
                options.AddArgument("--disable-gpu");
                options.AddArgument("--no-sandbox");
                options.AddExcludedArgument("enable-automation");
                options.AddExcludedArgument("--disable-popup-blocking");
                options.AddExcludedArgument("--disable-extensions");
                options.AddExcludedArgument("--disable-save-password-bubble");
                options.SetLoggingPreference(LogType.Browser, LogLevel.Warning);

                // Create driver
                driver = new ChromeDriver(options);
                //driver.Manage().Window.Maximize();
                driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(30);

                return driver;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return null; // Needed to prevent "not all code paths return a value"
            }
        }

        public WebDriver InitializeEdgeDriver()
        {
            WebDriver driver = null;
            string headless = BaseConfiguration.HeadlessDriver();
            var options = new EdgeOptions();

            // Example options
            options.AddArgument("start-maximized");      // Start browser maximized
            options.AddArgument("disable-infobars");     // Disable info bar
            options.AddArgument("--disable-extensions"); // Disable extensions
            if (headless.ToString().ToLower() == "yes")   // Headless mode
            {
                options.AddArgument("--headless");
            }
            options.AddArgument("--disable-gpu");
            options.AddArgument("--incognito");             // Required for headless in some environments
            driver = new EdgeDriver(options);
            driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(30);
            return driver;
        }

        public  void DeleteBrowserDriverInstances()
        {
            // Kill chromedriver instances left from previous runs, if any.
            Process[] chromeDriverProcesses = Process.GetProcessesByName("chromedriver");

            foreach (var chromeDriverProcess in chromeDriverProcesses)
            {
                chromeDriverProcess.Kill();
            }

            foreach (var proc in Process.GetProcessesByName("msedgedriver"))
            {
                proc.Kill();
            }
        }

        public  void DeleteBrowserInstances()   // This will close all open browser windows
        {
            // Kill chromedriver instances
            Process[] chromeProcesses = Process.GetProcessesByName("chrome");

            foreach (var chromeProcess in chromeProcesses)
            {
                chromeProcess.Kill();
            }
            foreach (var proc in Process.GetProcessesByName("msedge"))
            {
                proc.Kill();
            }
        }
    }



}
