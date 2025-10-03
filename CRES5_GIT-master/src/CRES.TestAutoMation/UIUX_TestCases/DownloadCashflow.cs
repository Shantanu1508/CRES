using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.TestCases;
using CRES.TestAutoMation.Utility;
using DocumentFormat.OpenXml.Spreadsheet;
//using java.awt;
//using java.awt.datatransfer;
//using java.awt.@event;
//using java.util.concurrent;
//using jdk.nashorn.@internal.runtime;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;
using System;
using System.Threading;
//using static com.sun.tools.classfile.Opcode;

namespace CRES.TestAutoMation.UIUX_TestCases
{
    class DownloadCashflow : BaseClass
    {
        [Test]
        public void downloadCashflow()
        {

            Actions actions = new Actions(driver);

            Login_Verification loginapp = new Login_Verification();
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
            bool LoginStatus = login.LoginWebPage();
                Console.WriteLine("\n Loged in status = " + LoginStatus);
            if (LoginStatus)

            {
                    //...................Cashflow from Scenarios Page..............................

                    try
                    {                       
                            Console.WriteLine(" From Scenaios page, cashflow download");
                            driver.Navigate().GoToUrl(BaseUrl + "#/scenarios");
                            Thread.Sleep(10000);

                            IWebElement downloadCashflow = driver.FindElement(By.XPath("(//div[@class='wj-cell']//div/a)[2]"));
                            downloadCashflow.Click();

                            Thread.Sleep(150000);
                            Console.WriteLine(" From Scenaios page, cashflow downloaded = " + downloadCashflow.Text);
                                          
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(" Scenario page cashflow Exception = " + e);
                    }

                    //...................Cashflow from Calculation Manager Page...................................

                    try
                    {
                        Console.WriteLine("Loged for Calculation Manager");
                        driver.Navigate().GoToUrl(BaseUrl + "#/CalculationManager");
                        System.Threading.Thread.Sleep(10000);

                        Console.WriteLine(" \n Calculation manager page is opening ");

                        //IWebElement checkbox = driver.FindElement(By.XPath("//*[@id=\"calculationManager\"]/div/div/div[2]/wj-flex-grid/div[1]/div[2]/div[1]/div[2]/input"));
                        IWebElement checkbox = driver.FindElement(By.XPath("//input[@id='chkSelectAlldownload']"));
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
                        System.Threading.Thread.Sleep(20000);
                    }
                    catch(Exception e) 
                    { 
                        Console.WriteLine("\n Calculation Manager Exception = "+e);
                    }

                //.........................Note Level Cashflow Download..........................................
                try
                {

                    Console.WriteLine(" Note level cashflow download");
                    driver.Navigate().GoToUrl(BaseUrl + "#/notedetail/59047b3e-c063-4699-a996-c66d289bf7e3");
                    System.Threading.Thread.Sleep(10000);

                   // driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/notedetail/59047b3e-c063-4699-a996-c66d289bf7e3");

                    //IWebElement note = driver.FindElement(By.XPath("//*[@id=\"calculationManager\"]/div/div/div[2]/wj-flex-grid/div[1]/div[2]/div[1]/div[3]/div/div/a"));
                    //note.Click();
                    System.Threading.Thread.Sleep(10000);

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
                catch (Exception e)
                {
                    Console.WriteLine("Note level cashflow download exception = " + e);
                }

                //.................................. Deal level Cashflow Exception..............................

                try
                {
                    Console.WriteLine(" Deal level cashflow download");
                    driver.Navigate().GoToUrl(BaseUrl + "#/dealdetail/A48F6318-37EF-41CA-8143-1B84484974C0");
                    System.Threading.Thread.Sleep(10000);

                    IWebElement download = driver.FindElement(By.Id("btnDownload"));
                    download.Click();
                    System.Threading.Thread.Sleep(5000);

                    IWebElement defaultOption = driver.FindElement(By.XPath("//*[@id=\"form1\"]/div/div[1]/span/div/ul/li[2]/a"));
                    defaultOption.Click();
                    System.Threading.Thread.Sleep(10000);
                }
                catch(Exception e) {
                    Console.WriteLine("Deal level Exception = " + e);
                }
            }
        }
    }
}

