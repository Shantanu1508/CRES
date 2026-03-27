using com.sun.org.apache.xalan.@internal.xsltc.compiler.util;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.TestCases;
using NUnit.Framework;
using OpenQA.Selenium.Chrome;
using CRES.TestAutoMation.Utility;
using System;
using System.Collections.Generic;
using System.Text;
using Util = CRES.TestAutoMation.Utility.Util;
using System.Threading;
using DocumentFormat.OpenXml.Bibliography;
using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;

namespace CRES.TestAutoMation.Practice
{
    [TestFixture]
    internal class TestASTotalRepaymentEquity : BaseClass
    {        
        public Util util = null;

        public Deal deal = null;
        public Login_Verification loginapp;
        private  Login login = null;
        // CreateNewDeal createDeal = new CreateNewDeal(driver);
        public bool loginValidation;
        public string dealfunding;
        public string subLoginUrl;
        public string BaseUrl;
        public string env;
        IWebElement ASTotalRepaymentEquity;



        string LoginUrl;

        public TestASTotalRepaymentEquity()
        {
            
            util = new Util(driver);
            //driver = new ChromeDriver();
            loginapp = new Login_Verification();
            login = new Login(driver);
            util = new Util(driver);
            dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
            BaseUrl = null;
            env = BaseConfiguration.GetEnvironment();
            deal = new Deal(driver);
            

            BaseUrl = env switch
            {
                "QA" => BaseConfiguration.GetQAUrl(),
                "Ng" => BaseConfiguration.GetNgUrl(),
                "Integration" => BaseConfiguration.GetIntUrl(),
                "Staging" => BaseConfiguration.GetStagingUrl(),
                "Acore" => BaseConfiguration.AcoreUrl(),
                "Dev" => BaseConfiguration.GetDevUrl(),
                _ => BaseConfiguration.GetQAUrl(),
            };

            subLoginUrl = BaseConfiguration.GetLoginUrlNew();
            LoginUrl = BaseUrl + subLoginUrl;
            Console.WriteLine("subLoginUrl = " + subLoginUrl + " LoginUrl = " + LoginUrl+ " BaseUrl = "+ BaseUrl);

        }


        [SetUp]
        public void SetUp()
        {



            // CreateNewDeal createDeal = new CreateNewDeal(driver);            
            
            Console.WriteLine("\nSetUp Method is called");

            util.OpenUrl(LoginUrl);
            //driver.Navigate().GoToUrl(LoginUrl);
            loginValidation = login.LoginWebPage();
            Thread.Sleep(10000);
            Console.WriteLine("Loge in status =" + loginValidation);


            Console.WriteLine("\nLogedin Successfully");
            Thread.Sleep(20000);
           

        }

        [Test]
        public void EquityTest1()
        {
            // ............................To Login M-61....................................                     

            
            if (loginValidation)
            {

                //Test 1: - The Total Deal Funding Equity per pupose type should be equal to Equity in the Project Budget(Autospread Total Debt Amount)
                try
                {
                    
                    util.OpenUrl(BaseUrl + "/#/dealdetail/20-0514");
                    //driver.Navigate().GoToUrl(BaseUrl + "/#/dealdetail/20-0514");
                    Thread.Sleep(50000);

                    driver.FindElement(deal.fundingTab).Click();

                    IJavaScriptExecutor js = (IJavaScriptExecutor)driver;
                    js.ExecuteScript("window.scrollBy(0,1000)", "");

                    ASTotalRepaymentEquity = this.driver.FindElement(deal.ASTotalRequiredEquity);

                    //IJavaScriptExecutor js = (IJavaScriptExecutor)driver;
                    //js.ExecuteScript("window.scrollBy(0,1000)");

                    // js.ExecuteScript("arguments[0].scrollIntoView();", ASTotalRepaymentEquity);

                    ((IJavaScriptExecutor)driver).ExecuteScript("arguments[0].scrollIntoView()", ASTotalRepaymentEquity);
                    Thread.Sleep(30000);
                                      

                    string TestASTotalRepaymentEquity = ASTotalRepaymentEquity.Text;
                    Console.WriteLine("\n ASTotalRequiredEquity = " + TestASTotalRepaymentEquity);

                    driver.FindElement(deal.Commitment_EquityTab).Click();
                    Thread.Sleep(1000);
                    String CommitmentRequiredEquity = driver.FindElement(deal.CommitmentRequiredEquity).Text;
                    Console.WriteLine("\n CommitmentRequiredEquity" + CommitmentRequiredEquity);

                    if (TestASTotalRepaymentEquity == CommitmentRequiredEquity)
                    {
                        Console.WriteLine("\n Test Pass: - Autospread equity is equlas to Commitment Equity");
                    }
                    else
                        Console.WriteLine("\n Test Failed: - Autospread equity is not equlas to Commitment Equity");

                }
                catch (Exception ex)
                {
                    Console.WriteLine("Exception = " + ex.ToString());
                }


            }
        }



    }
}
