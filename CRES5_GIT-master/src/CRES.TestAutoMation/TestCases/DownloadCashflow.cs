using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
//using java.awt;
//using java.awt.datatransfer;
//using java.awt.@event;
//using java.util.concurrent;
//using jdk.nashorn.@internal.runtime;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;
using System;
//using static com.sun.tools.classfile.Opcode;

namespace CRES.TestAutoMation.TestCases
{
    class DownloadCashflow : BaseClass
    {
        [Test]
        public void downloadCashflowByCalculatorManager()
        {

            Actions actions = new Actions(driver);

            CRES_Login loginapp = new CRES_Login();
            Login login = new Login(driver);
            Deal deal = new Deal(driver);
            Util util = new Util(driver);
            string subLoginUrl;

            string dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
            //string username = BaseConfiguration.getusername();
            //string password = BaseConfiguration.getpassword();
            //string LoginUrl = BaseConfiguration.LoginUrl();
            string BaseUrl = null;
            string env = BaseConfiguration.GetEnvironment();

            BaseUrl = env switch
            {
                "QA" => BaseConfiguration.GetQAUrl(),
                "Integration" => BaseConfiguration.GetIntUrl(),
                "Staging" => BaseConfiguration.GetStagingUrl(),
                _ => BaseConfiguration.GetQAUrl(),
            };

            subLoginUrl = BaseConfiguration.GetLoginUrlNew();

            string LoginUrl = BaseUrl + subLoginUrl;
            util.OpenUrl(LoginUrl);


            System.Threading.Thread.Sleep(10000);
            try
            {
                if (login.LoginWebPage())

                {

                    driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/CalculationManager");
                    System.Threading.Thread.Sleep(10000);

                    IWebElement checkbox = driver.FindElement(By.XPath("//*[@id=\"calculationManager\"]/div/div/div[2]/wj-flex-grid/div[1]/div[2]/div[1]/div[2]/input"));
                    checkbox.Click();
                    System.Threading.Thread.Sleep(2000);

                    IWebElement transactionCateg = driver.FindElement(By.XPath("//*[@id=\"multiseltransactioncategory\"]/div[1]/div/div/input"));
                    transactionCateg.Click();
                    System.Threading.Thread.Sleep(2000);

                    IWebElement defaultChecbox = driver.FindElement(By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/ng-component/form/div/div[1]/div/div[1]/label/input"));
                    defaultChecbox.Click();
                    System.Threading.Thread.Sleep(2000);

                    IWebElement download = driver.FindElement(By.XPath("//*[@id=\"btnDownloadNoteCashflowsExportData\"]"));
                    download.Click();
                    System.Threading.Thread.Sleep(10000);
                }
            }
            catch (Exception e)
            {

            }

            System.Threading.Thread.Sleep(10000);
        }

        [Test]
        public void dwnldCashflowByNote()
        {
            Actions actions = new Actions(driver);

            CRES_Login loginapp = new CRES_Login();
            Login login = new Login(driver);
            Deal deal = new Deal(driver);
            Util util = new Util(driver);
            string subLoginUrl;

            string dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
            //string username = BaseConfiguration.getusername();
            //string password = BaseConfiguration.getpassword();
            //string LoginUrl = BaseConfiguration.LoginUrl();
            string BaseUrl = null;
            string env = BaseConfiguration.GetEnvironment();

            BaseUrl = env switch
            {
                "QA" => BaseConfiguration.GetQAUrl(),
                "Integration" => BaseConfiguration.GetIntUrl(),
                "Staging" => BaseConfiguration.GetStagingUrl(),
                _ => BaseConfiguration.GetQAUrl(),
            };

            subLoginUrl = BaseConfiguration.GetLoginUrlNew();

            string LoginUrl = BaseUrl + subLoginUrl;
            util.OpenUrl(LoginUrl);


            System.Threading.Thread.Sleep(10000);
            try
            {
                if (login.LoginWebPage())

                {
                    driver.Navigate().GoToUrl("https://integrationcres4.azurewebsites.net/#/CalculationManager");
                    System.Threading.Thread.Sleep(10000);

                    IWebElement note = driver.FindElement(By.XPath("//*[@id=\"calculationManager\"]/div/div/div[2]/wj-flex-grid/div[1]/div[2]/div[1]/div[3]/div/div/a"));
                    note.Click();
                    System.Threading.Thread.Sleep(20000);

                    IWebElement cashflow = driver.FindElement(By.Id("aCashflow"));
                    cashflow.Click();
                    System.Threading.Thread.Sleep(8000);

                    IWebElement defaultDrop = driver.FindElement(By.XPath("//*[@id=\"multiseltransactioncategory\"]/div[1]/div/div/input"));
                    defaultDrop.Click();
                    System.Threading.Thread.Sleep(5000);

                    IWebElement defaultCheck = driver.FindElement(By.XPath("/html/body/div[2]/div[1]/label/input"));
                    defaultCheck.Click();
                    System.Threading.Thread.Sleep(5000);

                    IWebElement downloadCash = driver.FindElement(By.Id("btnDownloadNoteCashflowsExportData"));
                    downloadCash.Click();
                    System.Threading.Thread.Sleep(10000);

                }


            }
            catch (Exception e)
            {

            }
        }

        [Test]
        public void dwnldCashflowByDeal()
        {
            Actions actions = new Actions(driver);

            CRES_Login loginapp = new CRES_Login();
            Login login = new Login(driver);
            Deal deal = new Deal(driver);
            Util util = new Util(driver);
            string subLoginUrl;

            string dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
            //string username = BaseConfiguration.getusername();
            //string password = BaseConfiguration.getpassword();
            //string LoginUrl = BaseConfiguration.LoginUrl();
            string BaseUrl = null;
            string env = BaseConfiguration.GetEnvironment();

            BaseUrl = env switch
            {
                "QA" => BaseConfiguration.GetQAUrl(),
                "Integration" => BaseConfiguration.GetIntUrl(),
                "Staging" => BaseConfiguration.GetStagingUrl(),
                _ => BaseConfiguration.GetQAUrl(),
            };

            subLoginUrl = BaseConfiguration.GetLoginUrlNew();

            string LoginUrl = BaseUrl + subLoginUrl;
            util.OpenUrl(LoginUrl);


            System.Threading.Thread.Sleep(10000);
            try
            {
                if (login.LoginWebPage())

                {
                    driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/dealdetail/A48F6318-37EF-41CA-8143-1B84484974C0");
                    System.Threading.Thread.Sleep(10000);

                    IWebElement download = driver.FindElement(By.Id("btnDownload"));
                    download.Click();
                    System.Threading.Thread.Sleep(5000);

                    IWebElement defaultOption = driver.FindElement(By.XPath("//*[@id=\"form1\"]/div/div[1]/span/div/ul/li[2]/a"));
                    defaultOption.Click();
                    System.Threading.Thread.Sleep(10000);

                }


            }
            catch (Exception e)
            {

            }
        }


    }

}

