using AutoItX3Lib;
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

    class VerifyWorkflow : BaseClass
    {

        private bool acceptNextAlert;

        /* public CreateNewDeal()
         {
             IWebDriver driver = new ChromeDriver();
         }*/
        /* public CreateNewDeal(RemoteWebDriver driver)
         {
             this.driver = driver;
         }*/

        ExtentTest test = null;

        [Test]
        [Obsolete]
        [STAThread]
        public void verifyWorkflow()
        {

            //Login 

            // Actions actions = new Actions(driver);
            test = extent.CreateTest("WorkFlow approval").Info("Test started");
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
            try
            {
                if (login.LoginWebPage())
                {
                    var now = DateTime.Now;

                    string credealid = now.ToString("MMddyyyyss");

                    //Testcreatenewdeal
                    // String url = BaseUrl + "#/dealdetail/344398";
                    // util.OpenUrl(url);
                    driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/dealdetail/a/00000000-0000-0000-0000-000000000000");
                    System.Threading.Thread.Sleep(15000);
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
                    driver.FindElement(By.Id("TotalCommitment")).Click();
                    driver.FindElement(By.Id("TotalCommitment")).SendKeys("950000");
                    System.Threading.Thread.Sleep(5000);

                    IWebElement asset = driver.FindElement(deal.assetManager);
                    asset.Click();
                    System.Threading.Thread.Sleep(5000);

                    // IWebElement asset = driver.FindElement(By.XPath("//*[@id=\"AssetManagerID\"]/option[37]"));

                    asset.SendKeys("Tier2");
                    System.Threading.Thread.Sleep(5000);

                    IWebElement amoversight = driver.FindElement(deal.amOversight);
                    amoversight.Click();
                    System.Threading.Thread.Sleep(5000);
                    amoversight.SendKeys("Primary AM User");
                    System.Threading.Thread.Sleep(5000);
                    IWebElement secondAsset = driver.FindElement(deal.secondAssetMan);
                    secondAsset.Click();
                    secondAsset.SendKeys("Secondary AM User");
                    System.Threading.Thread.Sleep(5000);
                    var firstDayCurrentMonth = new DateTime(now.Year, now.Month, 1);
                    var closingdate = firstDayCurrentMonth.AddDays(-6);
                    var element = driver.FindElement(By.XPath("//*[@id=\"home\"]/div[3]/h3"));
                    Actions action = new Actions(driver);
                    action.MoveToElement(element);
                    action.Perform();
                    System.Threading.Thread.Sleep(3000);
                    AutoItX3 auto = new AutoItX3();
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(By.Id("cell00")).Click();
                    System.Threading.Thread.Sleep(5000);
                    auto.ClipPut("NT001");
                    driver.FindElement(By.Id("cell00")).SendKeys(Keys.Control + 'v');

                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(By.Id("cell01")).Click();
                    System.Threading.Thread.Sleep(3000);
                    auto.ClipPut("Note A");
                    driver.FindElement(By.Id("cell01")).SendKeys(Keys.Control + 'v');
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(By.Id("cell05")).Click();
                    auto.ClipPut(closingdate.ToString("10/01/2019"));
                    driver.FindElement(By.Id("cell05")).SendKeys(Keys.Control + 'v');
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(By.Id("cell06")).Click();
                    auto.ClipPut("10000");
                    driver.FindElement(By.Id("cell06")).SendKeys(Keys.Control + 'v');
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(By.Id("cell07")).Click();
                    auto.ClipPut(closingdate.ToString("11/10/2022"));
                    driver.FindElement(By.Id("cell07")).SendKeys(Keys.Control + 'v');
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(By.Id("cell00")).Click();
                    System.Threading.Thread.Sleep(5000);
                    auto.ClipPut("NT001");
                    driver.FindElement(By.Id("cell00")).SendKeys(Keys.Control + 'v');

                    System.Threading.Thread.Sleep(3000);
                    //----------------//
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
                    auto.ClipPut(closingdate.ToString("10/01/2019"));
                    driver.FindElement(By.Id("cell15")).SendKeys(Keys.Control + 'v');
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(By.Id("cell16")).Click();
                    auto.ClipPut("100000");
                    driver.FindElement(By.Id("cell16")).SendKeys(Keys.Control + 'v');
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(By.Id("cell17")).Click();
                    auto.ClipPut(closingdate.ToString("11/10/2022"));
                    driver.FindElement(By.Id("cell17")).SendKeys(Keys.Control + 'v');
                    System.Threading.Thread.Sleep(3000);
                    Actions actions = new Actions(driver);
                    IWebElement elem = driver.FindElement(By.Id("cell20"));
                    actions.DoubleClick(elem).Perform();
                    System.Threading.Thread.Sleep(15000);
                    driver.FindElement(deal.btnSaveDeal).Click();
                    System.Threading.Thread.Sleep(5000);
                    //driver.FindElement(deal.btnCRESvalOk).Click();
                    System.Threading.Thread.Sleep(2000);

                    //---------------AddDealFunfing------

                    driver.FindElement(deal.fundingTab).Click();
                    System.Threading.Thread.Sleep(6000);
                    driver.FindElement(deal.boxDocLink).SendKeys("https://acorecapital.app.box.com/folder/95503577906");
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
                    System.Threading.Thread.Sleep(10000);

                    driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[11]/div/span")).Click();
                    System.Threading.Thread.Sleep(10000);
                    driver.FindElement(deal.useRuleY).Click();
                    System.Threading.Thread.Sleep(10000);
                    EventFiringWebDriver eventFiringWebDriver1 = new EventFiringWebDriver(driver);
                    eventFiringWebDriver1.ExecuteScript("document.querySelector('#futureFunding > div > div:nth-child(4) > div:nth-child(1) > wj-flex-grid > div:nth-child(1) > div:nth-child(2)').scrollLeft=1300");
                    System.Threading.Thread.Sleep(5000);

                    IWebElement addSeq1 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[7]"));
                    addSeq1.Click();
                    System.Threading.Thread.Sleep(5000);
                    AutoItX3 autoit = new AutoItX3();
                    autoit.Send("50000");
                    System.Threading.Thread.Sleep(5000);

                    System.Threading.Thread.Sleep(5000);
                    IWebElement addSeq2 = driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[14]"));
                    addSeq2.Click();
                    System.Threading.Thread.Sleep(5000);
                    autoit.Send("20000");

                    System.Threading.Thread.Sleep(5000);

                    autoit.ClipPut("03/29/2021");
                    driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[3]")).Click();
                    System.Threading.Thread.Sleep(5000);
                    driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[3]")).SendKeys(Keys.Control + "v");
                    System.Threading.Thread.Sleep(5000);
                    autoit.ClipPut("03/29/2021");
                    driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[14]")).Click();
                    System.Threading.Thread.Sleep(5000);
                    driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[14]")).SendKeys(Keys.Control + "v");
                    System.Threading.Thread.Sleep(5000);
                    autoit.ClipPut("2500");
                    System.Threading.Thread.Sleep(5000);
                    driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[4]")).Click();
                    System.Threading.Thread.Sleep(5000);
                    driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[4]")).SendKeys(Keys.Control + "v");
                    System.Threading.Thread.Sleep(5000);
                    autoit.ClipPut("6000");
                    System.Threading.Thread.Sleep(5000);
                    driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[15]")).Click();
                    System.Threading.Thread.Sleep(5000);
                    driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[15]")).SendKeys(Keys.Control + "v");
                    System.Threading.Thread.Sleep(5000);
                    IWebElement dropDown1 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[7]"));
                    dropDown1.Click();
                    System.Threading.Thread.Sleep(5000);
                    IWebElement drop = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[7]/div/span"));
                    drop.Click();

                    System.Threading.Thread.Sleep(5000);
                    IWebElement capitExpen = driver.FindElement(By.XPath("/html/body/div[2]/div[1]"));
                    capitExpen.Click();
                    System.Threading.Thread.Sleep(5000);
                    IWebElement dropDown2 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[18]"));
                    dropDown2.Click();
                    System.Threading.Thread.Sleep(5000);
                    IWebElement drop2 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[18]/div"));
                    drop2.Click();

                    System.Threading.Thread.Sleep(5000);
                    IWebElement capitalExp = driver.FindElement(By.XPath("/html/body/div[2]/div[1]"));
                    capitalExp.Click();
                    System.Threading.Thread.Sleep(5000);
                    IWebElement comment1 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[10]"));
                    comment1.Click();
                    //AutoItX3 autoit = new AutoItX3();
                    autoit.ClipPut("Draw #1");
                    System.Threading.Thread.Sleep(2000);
                    driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[10]")).SendKeys(Keys.Control + "v");
                    System.Threading.Thread.Sleep(5000);
                    IWebElement comment2 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[21]"));
                    comment2.Click();

                    autoit.ClipPut("Draw #2");
                    System.Threading.Thread.Sleep(2000);
                    driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[21]")).SendKeys(Keys.Control + "v");
                    System.Threading.Thread.Sleep(5000);
                    driver.FindElement(deal.btnGenerateFunding).Click();
                    System.Threading.Thread.Sleep(15000);
                    string dealUrl = driver.Url; ;
                    //driver.FindElement(By.Id("btnSaveDeal")).Click();
                    //System.Threading.Thread.Sleep(10000);


                    driver.FindElement(deal.btnSaveDeal).Click();
                    System.Threading.Thread.Sleep(15000);
                    driver.FindElement(deal.btnCRESvalOk).Click();
                    System.Threading.Thread.Sleep(15000);
                    driver.FindElement(By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[2]/div[1]/div[17]/div/div/a")).Click();
                    System.Threading.Thread.Sleep(15000);
                    driver.FindElement(By.XPath("//*[@id=\"Client\"]")).SendKeys("Delphi Financial");
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(By.XPath("//*[@id=\"Client\"]")).SendKeys("Delphi Financial");
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(By.Id("FinancingSource")).Click();
                    driver.FindElement(By.Id("FinancingSource")).SendKeys("Delphi Portfolio");
                    System.Threading.Thread.Sleep(1500);
                    driver.FindElement(By.Id("btnSave")).Click();
                    System.Threading.Thread.Sleep(15000);
                    //Under review
                    System.Threading.Thread.Sleep(10000);
                    driver.FindElement(deal.krishnaDropdown).Click();
                    System.Threading.Thread.Sleep(2000);
                    driver.FindElement(deal.logoutBtn).Click();
                    System.Threading.Thread.Sleep(10000);
                    driver.FindElement(deal.username).SendKeys("SAM");
                    driver.FindElement(deal.password).SendKeys("Fight0n$");
                    driver.FindElement(deal.loginBtn).Click();
                    System.Threading.Thread.Sleep(8000);
                    driver.Navigate().GoToUrl(dealUrl);
                    System.Threading.Thread.Sleep(8000);
                    IWebElement elements = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[5]/div/div[5]"));
                    Actions action3 = new Actions(driver);
                    action3.MoveToElement(elements);
                    action3.Perform();
                    System.Threading.Thread.Sleep(8000);
                    driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[2]/div/div/div/div/a")).Click();
                    System.Threading.Thread.Sleep(10000);

                    AutoItX3 autoit2 = new AutoItX3();
                    autoit.ClipPut("Comment 1");
                    driver.FindElement(By.XPath("//*[@id=\"flexWFCheckList\"]/div[1]/div[2]/div[1]/div[3]")).Click();
                    driver.FindElement(By.XPath("//*[@id=\"flexWFCheckList\"]/div[1]/div[2]/div[1]/div[3]")).SendKeys(Keys.Control + 'v');
                    //driver.FindElement(By.XPath("//*[@id=\"flexWFCheckList\"]/div[1]/div[2]/div[1]/div[3]")).SendKeys("#Comment1");
                    System.Threading.Thread.Sleep(5000);

                    driver.FindElement(By.XPath("//*[@id=\"flexWFCheckList\"]/div[1]/div[2]/div[1]/div[6]/div/span")).Click();
                    driver.FindElement(By.XPath("/html/body/div[2]/div[1]")).Click();

                    System.Threading.Thread.Sleep(5000);

                    driver.FindElement(By.XPath("//*[@id=\"flexWFCheckList\"]/div[1]/div[2]/div[1]/div[10]/div/span")).Click();
                    System.Threading.Thread.Sleep(8000);
                    autoit.ClipPut("comment 2");
                    driver.FindElement(By.XPath("/html/body/div[2]/div[3]")).Click();
                    System.Threading.Thread.Sleep(5000);
                    driver.FindElement(By.XPath("//*[@id=\"flexWFCheckList\"]/div[1]/div[2]/div[1]/div[11]")).Click();
                    driver.FindElement(By.XPath("//*[@id=\"flexWFCheckList\"]/div[1]/div[2]/div[1]/div[11]")).SendKeys(Keys.Control + 'v');
                    System.Threading.Thread.Sleep(5000);
                    autoit.ClipPut("comment 3");
                    driver.FindElement(By.XPath("//*[@id=\"flexWFCheckList\"]/div[1]/div[2]/div[1]/div[15]")).Click();
                    driver.FindElement(By.XPath("//*[@id=\"flexWFCheckList\"]/div[1]/div[2]/div[1]/div[15]")).SendKeys(Keys.Control + 'v');
                    System.Threading.Thread.Sleep(4000);
                    driver.FindElement(By.XPath("//*[@id=\"flexWFCheckList\"]/div[1]/div[2]/div[1]/div[18]/div")).Click();
                    System.Threading.Thread.Sleep(4000);
                    driver.FindElement(By.XPath("/html/body/div[2]/div[3]")).Click();
                    System.Threading.Thread.Sleep(4000);
                    autoit.ClipPut("comment 4");
                    driver.FindElement(By.XPath("//*[@id=\"flexWFCheckList\"]/div[1]/div[2]/div[1]/div[19]")).Click();
                    driver.FindElement(By.XPath("//*[@id=\"flexWFCheckList\"]/div[1]/div[2]/div[1]/div[19]")).SendKeys(Keys.Control + 'v');
                    System.Threading.Thread.Sleep(4000);
                    //driver.FindElement(By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/workflowdetail/form/div[1]/div[1]/span/span[1]/button")).Click();
                    System.Threading.Thread.Sleep(10000);
                    IWebElement activity = driver.FindElement(By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/workflowdetail/form/div[1]/div[2]/div[4]/h3"));
                    Actions action2 = new Actions(driver);
                    action2.MoveToElement(activity);
                    action2.Perform();
                    System.Threading.Thread.Sleep(8000);
                    autoit.ClipPut("500");
                    driver.FindElement(deal.drawFee).Click();
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(deal.drawFee).SendKeys(Keys.Control + 'v');
                    System.Threading.Thread.Sleep(3000);

                    driver.FindElement(deal.borrowerFirst).SendKeys("Garvita");
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(deal.drawFee).SendKeys("500");
                    System.Threading.Thread.Sleep(3000);

                    driver.FindElement(deal.borrowerLast).SendKeys("Thakur");
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(deal.title).SendKeys("QA");
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(deal.companyName).SendKeys("Hvantage");
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(deal.address).SendKeys("Old palasia");
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(deal.city).SendKeys("Indore");
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(deal.state).SendKeys("California");
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(deal.zip).SendKeys("90001");
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(deal.email1).SendKeys("gthakur@hvantage.com");
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(deal.email2).SendKeys("gthakur@hvnatage.com");
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(deal.drawFee).SendKeys("500");
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(deal.borrowerPhone).SendKeys("(123) 456-7890");
                    System.Threading.Thread.Sleep(8000);
                    driver.FindElement(By.XPath("//*[@id=\"drawFeeInvoicedivs\"]/div[1]/div[4]/div[1]/button")).Click();
                    System.Threading.Thread.Sleep(20000);
                    driver.FindElement(By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/workflowdetail/form/div[1]/div[1]/span/span[1]/button")).Click();
                    System.Threading.Thread.Sleep(25000);
                    IWebElement element1 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[5]/div/div[4]"));
                    Actions action1 = new Actions(driver);
                    action1.MoveToElement(element1);
                    action1.Perform();
                    System.Threading.Thread.Sleep(20000);

                    driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[2]/div/div/div/div/a")).Click();
                    System.Threading.Thread.Sleep(10000);
                    driver.FindElement(deal.underReviewBtn).Click();
                    System.Threading.Thread.Sleep(30000);
                    driver.FindElement(deal.sendBtn).Click();
                    System.Threading.Thread.Sleep(20000);

                    String underSuccMsg = driver.FindElement(By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/workflowdetail/form/div[1]/div[1]/h1")).Text;
                    System.Threading.Thread.Sleep(10000);
                    Console.WriteLine(underSuccMsg);
                    System.Threading.Thread.Sleep(5000);
                    System.Threading.Thread.Sleep(5000);
                    driver.Navigate().GoToUrl(dealUrl);
                    System.Threading.Thread.Sleep(10000);
                    IWebElement elements1 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[5]/div/div[5]"));
                    Actions action6 = new Actions(driver);
                    action6.MoveToElement(elements1);
                    action6.Perform();
                    System.Threading.Thread.Sleep(8000);
                    String underReviewStatus = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[9]/div/div")).Text;
                    if (underSuccMsg == "Status: Under Review" && underReviewStatus == "Under Review")
                    {
                        Console.WriteLine("Under review approval done successfully");
                    }
                    else
                    {
                        Console.WriteLine("Under review approval failed");
                    }
                    System.Threading.Thread.Sleep(5000);
                    driver.FindElement(deal.krishnaDropdown).Click();
                    System.Threading.Thread.Sleep(4000);
                    driver.FindElement(By.XPath("/html/body/div/ng-component/div/div[1]/div/div/div[3]/div/ul/li[2]/ul/li[6]/a")).Click();
                    System.Threading.Thread.Sleep(10000);


                    //First approval

                    driver.FindElement(deal.username).SendKeys("PAM");
                    driver.FindElement(deal.password).SendKeys("Fight0n$");
                    driver.FindElement(deal.loginBtn).Click();
                    System.Threading.Thread.Sleep(8000);
                    driver.Navigate().GoToUrl(dealUrl);
                    System.Threading.Thread.Sleep(8000);
                    IWebElement elements4 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[5]/div/div[4]"));
                    Actions action5 = new Actions(driver);
                    action5.MoveToElement(elements4);
                    action5.Perform();
                    System.Threading.Thread.Sleep(8000);
                    driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[2]/div/div/div/div/a")).Click();
                    System.Threading.Thread.Sleep(10000);
                    driver.FindElement(deal.firstAprv).Click();

                    System.Threading.Thread.Sleep(30000);
                    IWebElement elements41 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[5]/div/div[5]"));
                    Actions action41 = new Actions(driver);
                    action41.MoveToElement(elements41);
                    action41.Perform();
                    System.Threading.Thread.Sleep(8000);
                    String firstStatus = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[9]/div/div")).Text;
                    System.Threading.Thread.Sleep(2000);
                    driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[2]/div/div/div/div/a")).Click();
                    System.Threading.Thread.Sleep(10000);
                    String firstSuccMsg = driver.FindElement(By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/workflowdetail/form/div[1]/div[1]/h1")).Text;
                    System.Threading.Thread.Sleep(2000);
                    if (firstSuccMsg == "Status: 1st Approval" && firstStatus == "1st Approval Rec’d")
                    {
                        Console.WriteLine("First approval done successfully");
                    }
                    else
                    {
                        Console.WriteLine("Under review approval failed");
                    }
                    driver.FindElement(deal.krishnaDropdown).Click();
                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(By.XPath("/html/body/div/ng-component/div/div[1]/div/div/div[3]/div/ul/li[2]/ul/li[6]/a")).Click();
                    System.Threading.Thread.Sleep(10000);


                    //Final approval 

                    driver.FindElement(deal.username).SendKeys("Tier2");
                    driver.FindElement(deal.password).SendKeys("Fight0n$");
                    driver.FindElement(deal.loginBtn).Click();
                    System.Threading.Thread.Sleep(8000);
                    driver.Navigate().GoToUrl(dealUrl);
                    System.Threading.Thread.Sleep(8000);
                    IWebElement element4 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[5]/div/div[4]"));
                    Actions action4 = new Actions(driver);
                    action4.MoveToElement(element4);
                    action4.Perform();
                    System.Threading.Thread.Sleep(8000);
                    driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[2]/div/div/div/div/a")).Click();
                    System.Threading.Thread.Sleep(10000);
                    driver.FindElement(deal.finalAprv).Click();
                    System.Threading.Thread.Sleep(15000);
                    driver.FindElement(deal.sendBtn).Click();
                    System.Threading.Thread.Sleep(35000);
                    String finalSuccMsg = driver.FindElement(By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/workflowdetail/form/div[1]/div[1]/h1")).Text;
                    Console.WriteLine(finalSuccMsg);

                    System.Threading.Thread.Sleep(20000);

                    System.Threading.Thread.Sleep(10000);
                    driver.Navigate().GoToUrl(dealUrl);
                    System.Threading.Thread.Sleep(10000);
                    IWebElement elements46 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[5]/div/div[4]"));
                    Actions action46 = new Actions(driver);
                    action46.MoveToElement(elements46);
                    action46.Perform();
                    System.Threading.Thread.Sleep(8000);
                    String finalStatus = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[9]/div/div")).Text;
                    Console.WriteLine(finalStatus);
                    System.Threading.Thread.Sleep(2000);
                    if (finalSuccMsg == "Status: Completed" && finalStatus == "Completed")
                    {
                        Console.WriteLine("Workflow completed successfully");
                    }
                    else
                    {
                        Console.WriteLine("work flow final approval failed");
                    }
                    System.Threading.Thread.Sleep(5000);
                    var printMessages = "<p><b>Test FAILED!</b></p>";
                    if (finalStatus == "Completed")
                    {
                        Console.WriteLine("Workflow done successfully ");
                        test.Log(Status.Pass, "Workflow done successfully");
                    }
                    else
                    {
                        Console.WriteLine("WorkFlow failed");
                        printMessages += $"Message: <br>{"WorkFlow failed"}<br>";
                        test.Fail(printMessages);
                    }
                    System.Threading.Thread.Sleep(5000);

                    EmailDataContract emailDC = new EmailDataContract();
                    emailDC.To = "gthakur@hvantage.com,rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com";//rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com

                    //optional
                    //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
                    //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
                    emailDC.ReceiverName = "All";
                    emailDC.FileAttachment = new List<FileAttachmentDataContract>();
                    //emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\ExcelReports\\" + pathExcel });
                    string path = ProjectBaseConfiguration.ExecutionReportFolder;
                    emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });
                    emailDC.Subject = "Worflow Report";
                    emailDC.Body = "PFA the Workflow report.";
                    emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
                    emailDC.EmailSettings.Host = BaseConfiguration.Host;
                    emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
                    emailDC.EmailSettings.Password = BaseConfiguration.Password;
                    emailDC.EmailSettings.Port = BaseConfiguration.Port;
                    //
                    EmailAutomationLogic lg = new EmailAutomationLogic();

                    String response = lg.SendGenericEmail(emailDC);
                }
            }
            catch (Exception e)
            {

            }


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
