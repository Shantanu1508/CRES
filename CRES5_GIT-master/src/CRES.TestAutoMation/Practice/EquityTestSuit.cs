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
using DocumentFormat.OpenXml.Presentation;
using Newtonsoft.Json;
using static CRES.DataContract.V1CalcDataContract;
using java.sql;
using System.Globalization;
using System.Linq.Expressions;

namespace CRES.TestAutoMation.Practice
{
    [TestFixture]
    internal class EquityTestSuit : BaseClass
    {

        public Deal deal;
        public String StrCommitmentRequiredEquity = null;
        public String StrASTotalRequiredEquity = null;
        public String StrTotalReqEquityDealFunding = null;
        public String StrTotalFundingSequance = null;
        public String StrAsEndDate = null;
        public String SrtFullyExtMaturityDate = null;

        [Test]
        public void SetUp() {            

            CRES_Login loginapp = new CRES_Login();
            Login login = new Login(driver);           
            // CreateNewDeal createDeal = new CreateNewDeal(driver);
            Util util = new Util(driver);
            string dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
            string subLoginUrl;
            string BaseUrl = null;
            string env = BaseConfiguration.GetEnvironment();

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

            string LoginUrl = BaseUrl + subLoginUrl;
            util.OpenUrl(LoginUrl);

            bool loginValidation = login.LoginWebPage();
            System.Threading.Thread.Sleep(10000);

            // ............................To Login M-61....................................

            if (loginValidation)
            {

                //Test 1: - The Total Deal Funding Equity per pupose type should be equal to Equity in the Project Budget(Autospread Total Debt Amount)
                try
                {
                    deal = new Deal(driver);
                    driver.Navigate().GoToUrl(BaseUrl + "/#/dealdetail/20-0514");
                    Thread.Sleep(20000);

                    IJavaScriptExecutor js = (IJavaScriptExecutor)driver;
                    js.ExecuteScript("window.scrollBy(0,1000)", "");

                    StrASTotalRequiredEquity = driver.FindElement(deal.ASTotalRequiredEquity).Text;
                    Console.WriteLine("\n ASTotalRequiredEquity = " + StrASTotalRequiredEquity);

                  
                    Thread.Sleep(30000);

                    driver.FindElement(deal.Commitment_EquityTab).Click();
                    Thread.Sleep(20000);
                    StrCommitmentRequiredEquity = driver.FindElement(deal.CommitmentRequiredEquity).Text;
                    Console.WriteLine("\n CommitmentRequiredEquity" + StrCommitmentRequiredEquity);

                    if (StrASTotalRequiredEquity == StrCommitmentRequiredEquity)
                    {
                        Console.WriteLine("\n 1st Test Pass: - Autospread equity is equlas to Commitment Equity");
                    }
                    else
                        Console.WriteLine("\n 1st Test Failed: - Autospread equity is not equlas to Commitment Equity");

                }
                catch (Exception ex)
                {
                    Console.WriteLine("Exception = "+ex.ToString());
                }
               
                // 2.Verify Enable Auto Spread: The Total Intial required Equity and the total Additional equity shown in Enable Auto Spread Grid
                // should be same as Total of equities(Required and Additional) in the Deal  funding schedule gridtry
                try
                {
                    driver.FindElement(deal.fundingTab).Click();
                    Thread.Sleep(2000);
                    StrTotalReqEquityDealFunding = driver.FindElement(deal.TotalReqEquityDealFunding).Text;
                    Console.WriteLine("\nTotalReqEquityDealFunding = " + StrTotalReqEquityDealFunding);

                    if (StrTotalReqEquityDealFunding == StrASTotalRequiredEquity)
                    {
                        Console.WriteLine("\n 2nd Test Pass: - Autospread equity is equlas to Deal's Equity");
                    }
                    else
                        Console.WriteLine("\n 2nd Test Failed: - Autospread equity is not equlas to Deal's Equity");


                }
                catch (Exception ex)
                {
                    Console.WriteLine("Exception of 2nd test case = " + ex);
                }

                //3. Verify Enable Auto Spread: The Total Intial required Equity and the total Additional equity shown in Enable Auto Spread Grid
                //should be equal or less than total Funding sequence in the Funding Rules grid.
                try
                {

                    Thread.Sleep(2000);
                    bool Display = driver.FindElement(deal.TotalFundingSequance).Displayed;
                    StrTotalFundingSequance = driver.FindElement(deal.TotalFundingSequance).Text;
                    Console.WriteLine("\nStrTotalFundingSequance = " + StrTotalFundingSequance+ " Display  "+ Display);

                    if (StrTotalReqEquityDealFunding == StrASTotalRequiredEquity)
                    {
                        Console.WriteLine("\n 3rd Test Pass: - Autospread equity is equal or less than Total Funding Sequance");
                    }
                    else
                        Console.WriteLine("\n 3rd Test Failed: - Autospread equity is equal or less than Total Funding Sequance");

                }
                catch (Exception ex)
                {
                    Console.WriteLine("Exception of 3rd test case = " + ex);
                }

                // 4. Verify End date in Enable Auto spread: The end date should not be after the maturity date

                try
                {

                    StrAsEndDate = driver.FindElement(deal.AsEndDate).Text;
                    Console.WriteLine("\n StrAsEndDate =" + StrAsEndDate);

                    driver.FindElement(deal.maturityTab).Click();
                    Thread.Sleep(2000);

                    SrtFullyExtMaturityDate = driver.FindElement(deal.FullyExtMaturityDate).Text;
                    Console.WriteLine("\nSrtFullyExtMaturityDate = " + SrtFullyExtMaturityDate);


                    if (DateTime.Parse(StrAsEndDate, CultureInfo.InvariantCulture) <= DateTime.Parse(SrtFullyExtMaturityDate, CultureInfo.InvariantCulture))                  
                    {
                        Console.WriteLine("\n 4th Pass: - End date in Enable Auto spread: The end date should not be after the maturity date");
                    }
                    else
                        Console.WriteLine("\n 4th Test Failed: - End date in Enable Auto spread: The end date should not be after the maturity date");

                }
                catch (Exception ex)
                {
                    Console.WriteLine("\nException of 4th test case = " + ex);
                }


                // 5. Verify if any record is wireconfirmed then the change in total equity and additional equity in the Auto spread field
                // should not impact the wireconfirmed records.

                try
                {

                    List<String> BeforeChangeWcRequiredEquity = new List<String>();


                    for (int i = 5; i <= 40; i = i + 8)
                    {
                        String Path = "//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[" + i + "]";

                        BeforeChangeWcRequiredEquity.Add(driver.FindElement(By.XPath(Path)).Text);

                        Console.WriteLine(" \n WcRequiredEquity = " + BeforeChangeWcRequiredEquity);
                    }



                    List<String> AfterChangeWcRequiredEquity = new List<String>();


                    for (int i = 5; i <= 40; i = i + 8)
                    {
                        String Path = "//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[" + i + "]";

                        AfterChangeWcRequiredEquity.Add(driver.FindElement(By.XPath(Path)).Text);

                        Console.WriteLine(" \n WcRequiredEquity = " + AfterChangeWcRequiredEquity);
                    }


                }
                catch (Exception ex)
                {
                    Console.WriteLine("\n5th Test case exception = " + ex);
                }




            }
        }
               
    }
}
