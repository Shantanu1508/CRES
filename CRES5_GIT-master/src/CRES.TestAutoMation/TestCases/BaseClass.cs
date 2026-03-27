using AventStack.ExtentReports;
using AventStack.ExtentReports.Reporter;
using Microsoft.AspNetCore.Mvc;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using WebDriverManager.DriverConfigs.Impl;
using CRES.TestAutoMation.Utility;
using System.Diagnostics;

namespace CRES.TestAutoMation.TestCases
{
    [TestFixture]
    public class BaseClass : ControllerBase
    {
        public WebDriver driver = null;
        public ExtentReports extent = null;
        private  BrowserHelper browserHelper = new BrowserHelper();


        public static void Main(string[] args)
        {

        }
        [SetUp]
        public void Initialize()
        {
            try
            {
                string headless = BaseConfiguration.HeadlessDriver();
                ChromeOptions options = new ChromeOptions();
                options.AddArguments("--window-size=1366x768");
                //options.AddArguments("headless");
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
            catch ( Exception e){
               Console.WriteLine(e);
            }
        }
    



        [OneTimeSetUp]
        public void ExtentStart()
        {
            //extent = new ExtentReports();
            // var reporter = new ExtentHtmlReporter(@"C:\temp\");
            
            string path = ProjectBaseConfiguration.ExecutionReportFolder;
            path = path + "\\ExtentReportResults.html";
            var sparkReporter = new ExtentSparkReporter(@path);
            sparkReporter.Config.DocumentTitle = "Automation Test Report";
            sparkReporter.Config.ReportName = "Sample Test Run";

            extent = new ExtentReports();
            extent.AttachReporter(sparkReporter);

            // Create ExtentReports and attach the reporter
            
            //reporter.Config.Theme = AventStack.ExtentReports.Reporter.Configuration.Theme.Standard;
            extent.AttachReporter(sparkReporter);
            extent.AddSystemInfo("Application Under Test", "CRES");
            string env = BaseConfiguration.GetEnvironment();
            extent.AddSystemInfo("Environment", env);
            extent.AddSystemInfo("Machine", Environment.MachineName);
            extent.AddSystemInfo("OS", Environment.OSVersion.VersionString);
            extent.AttachReporter(sparkReporter);
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
        public void CleanUp()
        {
            driver.Quit();
            browserHelper.DeleteBrowserDriverInstances();
            foreach (var proc in Process.GetProcessesByName("msedge"))
            {
                proc.Kill();
            }
            //browserHelper.DeleteBrowserInstances();  // Will close all Chrome windows
        }
    }
}
