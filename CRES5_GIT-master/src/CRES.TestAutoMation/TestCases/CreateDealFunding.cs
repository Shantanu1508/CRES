using AutoItX3Lib;
//using AutoItX3Lib;
using AventStack.ExtentReports;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Support.Events;
using OpenQA.Selenium.Support.UI;
using System;
using System.Collections.Generic;

namespace CRES.TestAutoMation.TestCases
{

    class CreateDealFunding : BaseClass
    {
        ExtentTest test = null;
        private bool acceptNextAlert;

        /* public CreateNewDeal()
         {
             IWebDriver driver = new ChromeDriver();
         }*/
        /* public CreateNewDeal(RemoteWebDriver driver)
         {
             this.driver = driver;
         }*/


        [Test]
        [Obsolete]
        [STAThread]
        public void createDealFunding()
        {
            test = extent.CreateTest("Create deal funding ").Info("Test started");
            //Login 

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

            login.LoginWebPage();
            var now = DateTime.Now;

            string credealid = now.ToString("MMddyyyyss");

            //Testcreatenewdeal
            // String url = BaseUrl + "#/dealdetail/344398";
            // util.OpenUrl(url);
            driver.Navigate().GoToUrl("https://qacres4-ng.azurewebsites.net/#/dealdetail/a/00000000-0000-0000-0000-000000000000");
            System.Threading.Thread.Sleep(10000);
            // driver.FindElement(By.XPath("//li[@id='addmenu']/a/i")).Click();
            //driver.FindElement(By.LinkText("Deal")).Click();
            driver.FindElement(deal.mainTab).Click();
            System.Threading.Thread.Sleep(7000);
            driver.FindElement(By.Id("CREDealID")).Click();
            driver.FindElement(By.Id("CREDealID")).SendKeys(credealid);
            driver.FindElement(By.Id("DealName")).SendKeys("Automation Deal_" + credealid);
            driver.FindElement(By.Id("Statusid")).Click();
            new SelectElement(driver.FindElement(By.Id("Statusid"))).SelectByText("Active");
            driver.FindElement(By.Id("Statusid")).Click();
            driver.FindElement(By.Id("DealCity")).SendKeys("Kohala Coast");
            // driver.FindElement(By.Id("TotalCommitment")).Click();
            driver.FindElement(By.Id("TotalCommitment")).SendKeys("950000");
            System.Threading.Thread.Sleep(3000);

            var firstDayCurrentMonth = new DateTime(now.Year, now.Month, 1);
            var closingdate = firstDayCurrentMonth.AddDays(-6);
            var element = driver.FindElement(By.XPath("//*[@id=\"home\"]/div[3]/h3"));
            Actions action = new Actions(driver);
            action.MoveToElement(element);
            action.Perform();
            System.Threading.Thread.Sleep(3000);
            //-----------------------------------------------Note 1----------------------------------------------------------//
            AutoItX3 auto = new AutoItX3();
            //driver.FindElement(By.Id("cell00")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("NT001");
            driver.FindElement(By.Id("cell00")).SendKeys(Keys.Control + 'v');

            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell01")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("Note A");
            driver.FindElement(By.Id("cell01")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell05")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell05")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell06")).Click();
            auto.ClipPut("10000");
            driver.FindElement(By.Id("cell06")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell07")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell07")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            //-----------------------------------------------Note2----------------------------------------------------------//

            driver.FindElement(By.Id("cell10")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("NT002");
            driver.FindElement(By.Id("cell10")).SendKeys(Keys.Control + 'v');

            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell11")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("Note B");
            driver.FindElement(By.Id("cell11")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell15")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell15")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell16")).Click();
            auto.ClipPut("100000");
            driver.FindElement(By.Id("cell16")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell17")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell17")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            //-----------------------------------------------Note 3----------------------------------------------------------//


            driver.FindElement(By.Id("cell20")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("NT003");
            driver.FindElement(By.Id("cell20")).SendKeys(Keys.Control + 'v');

            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell21")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("Note C");
            driver.FindElement(By.Id("cell21")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell25")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell25")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell26")).Click();
            auto.ClipPut("100000");
            driver.FindElement(By.Id("cell26")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell27")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell27")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            //-----------------------------------------------Note 3----------------------------------------------------------//

            driver.FindElement(By.Id("cell20")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("NT003");
            driver.FindElement(By.Id("cell20")).SendKeys(Keys.Control + 'v');

            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell21")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("Note C");
            driver.FindElement(By.Id("cell21")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell25")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell25")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell26")).Click();
            auto.ClipPut("100000");
            driver.FindElement(By.Id("cell26")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell27")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell27")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            //-----------------------------------------------Note 4----------------------------------------------------------//

            driver.FindElement(By.Id("cell30")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("NT004");
            driver.FindElement(By.Id("cell30")).SendKeys(Keys.Control + 'v');

            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell31")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("Note D");
            driver.FindElement(By.Id("cell31")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell35")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell35")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell36")).Click();
            auto.ClipPut("100000");
            driver.FindElement(By.Id("cell36")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell37")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell37")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);

            //-----------------------------------------------Note 5----------------------------------------------------------//

            driver.FindElement(By.Id("cell40")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("NT005");
            driver.FindElement(By.Id("cell40")).SendKeys(Keys.Control + 'v');

            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell41")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("Note E");
            driver.FindElement(By.Id("cell41")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell45")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell45")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell46")).Click();
            auto.ClipPut("100000");
            driver.FindElement(By.Id("cell46")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell47")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell47")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);

            //-----------------------------------------------Note 6----------------------------------------------------------//

            driver.FindElement(By.Id("cell50")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("NT006");
            driver.FindElement(By.Id("cell50")).SendKeys(Keys.Control + 'v');

            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell51")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("Note F");
            driver.FindElement(By.Id("cell51")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell55")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell55")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell56")).Click();
            auto.ClipPut("100000");
            driver.FindElement(By.Id("cell56")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell57")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell57")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);

            //-----------------------------------------------Note 7----------------------------------------------------------//

            driver.FindElement(By.Id("cell60")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("NT007");
            driver.FindElement(By.Id("cell60")).SendKeys(Keys.Control + 'v');

            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell61")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("Note G");
            driver.FindElement(By.Id("cell61")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell65")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell65")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell66")).Click();
            auto.ClipPut("100000");
            driver.FindElement(By.Id("cell66")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell67")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell67")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);

            //-----------------------------------------------Note 8----------------------------------------------------------//

            driver.FindElement(By.Id("cell70")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("NT008");
            driver.FindElement(By.Id("cell70")).SendKeys(Keys.Control + 'v');

            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell71")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("Note H");
            driver.FindElement(By.Id("cell71")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell75")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell75")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell76")).Click();
            auto.ClipPut("100000");
            driver.FindElement(By.Id("cell76")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell77")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell77")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);

            //-----------------------------------------------Note 9----------------------------------------------------------//

            driver.FindElement(By.Id("cell80")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("NT009");
            driver.FindElement(By.Id("cell80")).SendKeys(Keys.Control + 'v');

            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell81")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("Note J");
            driver.FindElement(By.Id("cell81")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell85")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell85")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell86")).Click();
            auto.ClipPut("100000");
            driver.FindElement(By.Id("cell86")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell87")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell87")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            //-----------------------------------------------Note 10----------------------------------------------------------//

            driver.FindElement(By.Id("cell90")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("NT0010");
            driver.FindElement(By.Id("cell90")).SendKeys(Keys.Control + 'v');

            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell91")).Click();
            System.Threading.Thread.Sleep(3000);
            auto.ClipPut("Note K");
            driver.FindElement(By.Id("cell91")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell95")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell95")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell96")).Click();
            auto.ClipPut("100000");
            driver.FindElement(By.Id("cell96")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("cell97")).Click();
            auto.ClipPut(closingdate.ToString("MM/dd/yyyy"));
            driver.FindElement(By.Id("cell97")).SendKeys(Keys.Control + 'v');
            System.Threading.Thread.Sleep(3000);























            //actions.DoubleClick(elem).Perform();---------------------
            System.Threading.Thread.Sleep(15000);
            driver.FindElement(deal.btnSaveDeal).Click();
            System.Threading.Thread.Sleep(5000);
            //driver.FindElement(deal.btnCRESvalOk).Click();
            System.Threading.Thread.Sleep(2000);


            //---------------AddDealFunfing------
            try
            {
                // driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/dealdetail/D7B9E322-7530-4B20-97E4-8C7F196A79AC");
                System.Threading.Thread.Sleep(10000);
                driver.FindElement(deal.fundingTab).Click();
                System.Threading.Thread.Sleep(6000);
                driver.FindElement(deal.addFundingSeqBtn).Click();
                System.Threading.Thread.Sleep(5000);
                EventFiringWebDriver eventFiringWebDriver = new EventFiringWebDriver(driver);
                eventFiringWebDriver.ExecuteScript("document.querySelector('#futureFunding > div > div:nth-child(4) > div:nth-child(1) > wj-flex-grid > div:nth-child(1) > div:nth-child(2)').scrollLeft=1000");
                System.Threading.Thread.Sleep(10000);

                IWebElement useRule = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[3]"));
                useRule.Click();
                System.Threading.Thread.Sleep(10000);
                driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[4]/div/span")).Click();

                System.Threading.Thread.Sleep(10000);
                driver.FindElement(deal.useRuleY).Click();
                System.Threading.Thread.Sleep(5000);
                IWebElement useRule2 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[12]"));
                useRule2.Click();
                System.Threading.Thread.Sleep(5000);
                driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[11]/div/span")).Click();
                System.Threading.Thread.Sleep(10000);
                System.Threading.Thread.Sleep(10000);
                driver.FindElement(deal.useRuleY).Click();
                System.Threading.Thread.Sleep(10000);
                IWebElement useRule3 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[18]"));
                useRule3.Click();
                System.Threading.Thread.Sleep(10000);

                driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[18]/div/span")).Click();

                System.Threading.Thread.Sleep(10000);
                driver.FindElement(deal.useRuleY).Click();
                System.Threading.Thread.Sleep(10000);

                IWebElement useRule4 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[25]"));
                useRule4.Click();
                System.Threading.Thread.Sleep(10000);
                driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[25]/div/span")).Click();
                System.Threading.Thread.Sleep(10000);
                driver.FindElement(deal.useRuleY).Click();
                System.Threading.Thread.Sleep(10000);

                IWebElement useRule5 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[32]"));
                useRule5.Click();
                System.Threading.Thread.Sleep(10000);
                driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[32]/div/span")).Click();
                System.Threading.Thread.Sleep(10000);
                driver.FindElement(deal.useRuleY).Click();
                System.Threading.Thread.Sleep(10000);

                IWebElement useRule6 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[39]"));
                useRule6.Click();
                System.Threading.Thread.Sleep(10000);
                driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[39]/div/span")).Click();
                System.Threading.Thread.Sleep(10000);
                driver.FindElement(deal.useRuleY).Click();
                System.Threading.Thread.Sleep(10000);

                IWebElement useRule7 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[46]"));
                useRule7.Click();
                System.Threading.Thread.Sleep(10000);
                driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[46]/div/span")).Click();
                System.Threading.Thread.Sleep(10000);
                driver.FindElement(deal.useRuleY).Click();
                System.Threading.Thread.Sleep(10000);

                IWebElement userRule8 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[53]"));
                userRule8.Click();
                System.Threading.Thread.Sleep(10000);
                driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[53]/div/span")).Click();
                System.Threading.Thread.Sleep(10000);
                driver.FindElement(deal.useRuleY).Click();
                System.Threading.Thread.Sleep(10000);

                IWebElement useRule9 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[60]"));
                useRule9.Click();
                System.Threading.Thread.Sleep(10000);

                driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[60]/div/span")).Click();

                System.Threading.Thread.Sleep(10000);
                driver.FindElement(deal.useRuleY).Click();
                System.Threading.Thread.Sleep(10000);

                IWebElement useRule10 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[67]"));
                useRule10.Click();
                System.Threading.Thread.Sleep(10000);
                driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[67]/div/span")).Click();
                System.Threading.Thread.Sleep(10000);
                driver.FindElement(deal.useRuleY).Click();
                System.Threading.Thread.Sleep(10000);


            }
            catch (Exception ex)
            {
                Console.WriteLine("Add Deal Funding = " + ex.Message);
            }

            AutoItX3 autoit = new AutoItX3();

            EventFiringWebDriver eventFiringWebDriver1 = new EventFiringWebDriver(driver);
            eventFiringWebDriver1.ExecuteScript("document.querySelector('#futureFunding > div > div:nth-child(4) > div:nth-child(1) > wj-flex-grid > div:nth-child(1) > div:nth-child(2)').scrollLeft=1300");
            System.Threading.Thread.Sleep(5000);

            autoit.ClipPut("50000");
            IWebElement addSeq1 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[7]"));
            addSeq1.Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[7]")).SendKeys(Keys.Control + "v");



            System.Threading.Thread.Sleep(5000);
            autoit.ClipPut("20000");
            IWebElement addSeq2 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[14]"));
            addSeq2.Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[14]")).SendKeys(Keys.Control + "v");

            System.Threading.Thread.Sleep(5000);





            autoit.ClipPut("1500");
            IWebElement addSeq3 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[21]"));
            addSeq3.Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[21]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);

            autoit.ClipPut("3600");
            IWebElement addSeq4 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[28]"));
            addSeq4.Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[28]")).SendKeys(Keys.Control + "v");

            System.Threading.Thread.Sleep(5000);

            autoit.ClipPut("15000");
            IWebElement addSeq5 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[35]"));
            addSeq5.Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[35]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);

            autoit.ClipPut("15000");
            IWebElement addSeq6 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[42]"));
            addSeq6.Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[42]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);

            autoit.ClipPut("15000");
            IWebElement addSeq7 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[49]"));
            addSeq7.Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[49]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);

            autoit.ClipPut("15000");
            IWebElement addSeq8 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[56]"));
            addSeq8.Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[56]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);

            autoit.ClipPut("15000");
            IWebElement addSeq9 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[63]"));
            addSeq9.Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[63]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);

            autoit.ClipPut("15000");
            IWebElement addSeq10 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[70]"));
            addSeq10.Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[70]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);








            //1
            autoit.ClipPut("01/29/2021");
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[3]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[3]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);
            //2
            autoit.ClipPut("01/29/2021");
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[14]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[14]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);

            //3
            autoit.ClipPut("01/29/2021");
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[25]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[25]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);
            //4

            autoit.ClipPut("01/29/2021");
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[36]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[36]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);

            //5

            autoit.ClipPut("01/29/2021");
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[47]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[47]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);

            //6

            autoit.ClipPut("01/29/2021");
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[58]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[58]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);


            //7
            autoit.ClipPut("01/29/2021");
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[69]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[69]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);

            //8

            autoit.ClipPut("01/29/2021");
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[80]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[80]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);

            //9

            autoit.ClipPut("01/29/2021");
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[91]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[91]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);

            //10



            autoit.ClipPut("01/29/2021");
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[102]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[102]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);


            //1

            autoit.ClipPut("2500");
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[4]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[4]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);
            //2
            autoit.ClipPut("6000");
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[15]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[15]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);
            //3


            autoit.ClipPut("1200");
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[26]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[26]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);


            //4
            autoit.ClipPut("4010");
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[37]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[37]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);


            //5

            autoit.ClipPut("5210");
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[48]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[48]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);

            //6
            autoit.ClipPut("6320");
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[59]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[59]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);


            //7

            autoit.ClipPut("1982");
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[70]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[70]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);

            //8
            autoit.ClipPut("4150");
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[81]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[81]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);

            //9
            autoit.ClipPut("5605");
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[92]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[92]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);

            //10
            autoit.ClipPut("5950");
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[103]")).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[103]")).SendKeys(Keys.Control + "v");
            System.Threading.Thread.Sleep(5000);










            //1
            IWebElement dropDown1 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[7]"));
            dropDown1.Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement drop = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[7]/div/span"));
            drop.Click();

            System.Threading.Thread.Sleep(5000);
            IWebElement capitExpen = driver.FindElement(By.XPath("/html/body/div[2]/div[1]"));
            capitExpen.Click();
            System.Threading.Thread.Sleep(5000);
            //2
            IWebElement dropDown2 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[18]"));
            dropDown2.Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement drop2 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[18]/div"));
            drop2.Click();

            System.Threading.Thread.Sleep(5000);
            IWebElement capitalExp = driver.FindElement(By.XPath("/html/body/div[2]/div[1]"));
            capitalExp.Click();
            System.Threading.Thread.Sleep(5000);

            //3


            IWebElement dropDown3 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[29]"));
            dropDown3.Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement drop3 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[29]/div"));
            drop3.Click();

            System.Threading.Thread.Sleep(5000);
            IWebElement CapitalIntrest = driver.FindElement(By.XPath("/html/body/div[2]/div[2]"));
            CapitalIntrest.Click();
            System.Threading.Thread.Sleep(5000);


            //4

            IWebElement dropDown4 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[40]"));
            dropDown4.Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement drop4 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[40]/div"));
            drop4.Click();

            System.Threading.Thread.Sleep(5000);
            IWebElement CapitalIntrest1 = driver.FindElement(By.XPath("/html/body/div[2]/div[2]"));
            CapitalIntrest1.Click();
            System.Threading.Thread.Sleep(5000);

            //5

            IWebElement dropDown5 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[51]"));
            dropDown5.Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement drop5 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[51]/div"));
            drop5.Click();

            System.Threading.Thread.Sleep(5000);
            IWebElement CapitalExpen2 = driver.FindElement(By.XPath("/html/body/div[2]/div[2]"));
            CapitalExpen2.Click();
            System.Threading.Thread.Sleep(5000);

            //6
            IWebElement dropDown6 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[62]"));
            dropDown6.Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement drop6 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[62]/div"));
            drop6.Click();

            System.Threading.Thread.Sleep(5000);
            IWebElement CapitalExpen3 = driver.FindElement(By.XPath("/html/body/div[2]/div[1]"));
            CapitalExpen3.Click();
            System.Threading.Thread.Sleep(5000);

            //7
            IWebElement dropDown7 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[73]"));
            dropDown7.Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement drop7 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[73]/div"));
            drop7.Click();

            System.Threading.Thread.Sleep(5000);
            IWebElement CapitalInt = driver.FindElement(By.XPath("/html/body/div[2]/div[2]"));
            CapitalInt.Click();
            System.Threading.Thread.Sleep(5000);

            //8

            IWebElement dropDown8 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[84]"));
            dropDown8.Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement drop8 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[84]/div"));
            drop8.Click();

            System.Threading.Thread.Sleep(5000);
            IWebElement CapitalInt3 = driver.FindElement(By.XPath("/html/body/div[2]/div[2]"));
            CapitalInt3.Click();
            System.Threading.Thread.Sleep(5000);

            //9

            IWebElement dropDown9 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[95]"));
            dropDown9.Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement drop9 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[95]/div"));
            drop9.Click();

            System.Threading.Thread.Sleep(5000);
            IWebElement CapitalInt4 = driver.FindElement(By.XPath("/html/body/div[2]/div[2]"));
            CapitalInt4.Click();
            System.Threading.Thread.Sleep(5000);

            //10
            IWebElement dropDown10 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[106]"));
            dropDown10.Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement drop10 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[106]/div"));
            drop10.Click();

            System.Threading.Thread.Sleep(5000);
            IWebElement CaptialExpen4 = driver.FindElement(By.XPath("/html/body/div[2]/div[1]"));
            CaptialExpen4.Click();
            System.Threading.Thread.Sleep(5000);



            driver.FindElement(deal.btnGenerateFunding).Click();
            System.Threading.Thread.Sleep(3000);
            driver.FindElement(By.Id("btnSaveDeal")).Click();
            System.Threading.Thread.Sleep(3000);
            IWebElement successMessage = driver.FindElement(By.Id("sucessmessagediv"));
            String MsgText = successMessage.Text;
            Console.WriteLine(successMessage.Text);
            var printMessages = "<p><b>Test FAILED!</b></p>";
            if (MsgText == "Funding schedule generated successfully.")
            {
                Console.WriteLine("Deal funding generated successfully.");
                test.Log(Status.Pass, "Deal Funding  generated successfully.");
            }
            else
            {
                Console.WriteLine("Deal funding generated Failed.");
                printMessages += $"Message: <br>{"Deal funding generated Failed."}<br>";
                test.Fail(printMessages);
            }
            System.Threading.Thread.Sleep(10000);
            driver.FindElement(deal.btnSaveDeal).Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(deal.btnCRESvalOk).Click();

            System.Threading.Thread.Sleep(10000);




            EmailDataContract emailDC = new EmailDataContract();
            emailDC.To = "shantanu@hvantage.com";//rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com

            //optional
            //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
            //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
            emailDC.ReceiverName = "All";
            emailDC.FileAttachment = new List<FileAttachmentDataContract>();
            //emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\ExcelReports\\" + pathExcel });
            string path = ProjectBaseConfiguration.ExecutionReportFolder;
            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });
            emailDC.Subject = "Create deal funding report";
            emailDC.Body = "PFA the verification report.";
            emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
            emailDC.EmailSettings.Host = BaseConfiguration.Host;
            emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
            emailDC.EmailSettings.Password = BaseConfiguration.Password;
            emailDC.EmailSettings.Port = BaseConfiguration.Port;
            //
            EmailAutomationLogic lg = new EmailAutomationLogic();

            String response = lg.SendGenericEmail(emailDC);

        }
        private bool IsElementPresent(By by)
        {
            try
            {
                driver.FindElement(by);
                return true;
            }
            catch (NoSuchElementException)
            {
                return false;
            }
        }

        private bool IsAlertPresent()
        {
            try
            {
                driver.SwitchTo().Alert();
                return true;
            }
            catch (NoAlertPresentException)
            {
                return false;
            }
        }

        private string CloseAlertAndGetItsText()
        {
            try
            {
                IAlert alert = driver.SwitchTo().Alert();
                string alertText = alert.Text;
                if (acceptNextAlert)
                {
                    alert.Accept();
                }
                else
                {
                    alert.Dismiss();
                }
                return alertText;
            }
            finally
            {
                acceptNextAlert = true;
            }
        }

    }
}
