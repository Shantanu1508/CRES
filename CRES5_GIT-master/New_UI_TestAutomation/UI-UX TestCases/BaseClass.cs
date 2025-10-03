using AventStack.ExtentReports;
using AventStack.ExtentReports.Reporter;
using Microsoft.AspNetCore.Mvc;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Diagnostics;
using WebDriverManager.DriverConfigs.Impl;
using CRES.TestAutoMation;

namespace New_UI_TestAutomation.TestCases
{
    [TestFixture]
    public class BaseClass : ControllerBase
    {
        public WebDriver driver = null;
        public ExtentReports extent = null;
        static void main(string[] args)
        {

        }
        [SetUp]
        public void initialize()
        {
            string headless = BaseConfiguration.HeadlessDriver();
            ChromeOptions options = new ChromeOptions();
            options.AddArguments("--window-size=1366x768");

            if (headless.ToString().ToLower() == "yes")
            {
                options.AddArguments("headless");
            }

            options.AddArguments("--incognito");
            options.AddArguments("start-maximized");
            options.AddArguments("disable-infobars");
            options.AddArguments("--disable-notifications");
            options.AddExcludedArgument("enable-automation");
            options.AddArgument("--disable-single-click-autofill");
            options.AddArgument("--disable-popup-blocking");
            options.AddUserProfilePreference("disable-popup-blocking", "true");
            //options.AddAdditionalCapability("useAutomationExtension", false);
            options.SetLoggingPreference(LogType.Browser, LogLevel.Warning);
            new WebDriverManager.DriverManager().SetUpDriver(new ChromeConfig());
            driver = new ChromeDriver(options);

            driver.Manage().Window.Maximize();
            driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(30);

        }



        [OneTimeSetUp]
        public void ExtentStart()
        {
            extent = new ExtentReports();
            // var reporter = new ExtentHtmlReporter(@"C:\temp\");
            string path = ProjectBaseConfiguration.ExecutionReportFolder;
            path = path + "\\ExtentReportResults.html";
            var reporter = new ExtentSparkReporter(@path);
            reporter.Config.DocumentTitle = "Automation_Testing_Report";
            reporter.Config.ReportName = "Regression_Testing";
            //reporter.Config.Theme = AventStack.ExtentReports.Reporter.Configuration.Theme.Standard;
            extent.AttachReporter(reporter);
            extent.AddSystemInfo("Application Under Test", "CRES");
            string env = BaseConfiguration.GetEnvironment();
            extent.AddSystemInfo("Environment", env);
            extent.AddSystemInfo("Machine", Environment.MachineName);
            extent.AddSystemInfo("OS", Environment.OSVersion.VersionString);
            extent.AttachReporter(reporter);
        }

        [OneTimeTearDown]
        public void CloseAll()
        {
            ExtentEnd();
        }
        public void ExtentEnd()
        {
            extent.Flush();
        }

        [TearDown]
        public void cleanUp()
        {
            driver.Quit();
            // Kill chromedriver instances
            Process[] chromeDriverProcesses = Process.GetProcessesByName("chromedriver");

            foreach (var chromeDriverProcess in chromeDriverProcesses)
            {
                chromeDriverProcess.Kill();
            }
        }
    }
}
