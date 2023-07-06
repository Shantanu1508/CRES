using AventStack.ExtentReports;
using AventStack.ExtentReports.Model;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using NUnit.Framework;
using System;


namespace CRES.TestAutoMation.TestCases
{
    public class HtmlReportTest : BaseClass
    {
        ExtentTest test = null;


        [Test, Category("DealFunding")]
        public void LoginExtent()
        {
            bool loginstatus = false;
            try
            {
                test = extent.CreateTest("Login Test").Info("test started");
                Util util = new Util(driver);
                Login login = new Login(driver);

                string username = BaseConfiguration.getusername();
                string password = BaseConfiguration.getpassword();
                string LoginUrl = BaseConfiguration.LoginUrl();

                util.OpenUrl(LoginUrl);
                test.Log(Status.Info, "Login page opened");
                ////login in web site
                login.LoginWebPage();
                test.Log(Status.Info, "Login Process completed");
                loginstatus = true;
                test.Log(Status.Pass, "LoginExtent Pass");

            }
            catch (Exception ex)
            {
                test.Log(Status.Error, ex);
                loginstatus = false;
                throw ex;
            }

            //return loginstatus;            
        }

        [Test, Category("DealFunding")]
        public void OpenPage()
        {
            bool loginstatus = false;
            try
            {
                test = extent.CreateTest("OpenPage").Info("test started");
                test.Log(Status.Info, "page opened");
                test.Log(Status.Info, "Open Process completed");
                test.Log(Status.Pass, "OpenPage Pass");
            }
            catch (Exception ex)
            {
                test.Log(Status.Error, ex);
                loginstatus = false;
                throw ex;
            }

            //return loginstatus;            
        }

        [Test, Category("DealFunding")]

        public void OtherTest()
        {

            try
            {
                test = extent.CreateTest("Other Test").Info("Test started");
                string[] cars = { "Volvo", "BMW", "Ford", "Mazda" };
                string a = cars[10];

                //test.Log(Status.Fail, "OtherTest failed");
            }
            catch (Exception ex)
            {
                var printMessage = "<p><b>Test FAILED!</b></p>";
                if (!string.IsNullOrEmpty("OtherTest"))
                {
                    printMessage += $"Message: <br>{"OtherTest"}<br>";
                }
                test.Fail(printMessage);
            }

        }

    }
}
