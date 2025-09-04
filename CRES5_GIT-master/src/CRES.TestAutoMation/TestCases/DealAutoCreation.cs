using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Remote;
using OpenQA.Selenium.Support.UI;
using System;
using System.Threading;


namespace CRES.TestAutoMation.TestCases
{
    public class DealAutoCreation : BaseClass

    {
        private bool acceptNextAlert;

        public DealAutoCreation()
        {
            IWebDriver driver = new ChromeDriver();
        }
        public DealAutoCreation(WebDriver driver)
        {
            this.driver = driver;
        }


        [Test]
        public void TestCreateNewDeal()
        {
            //Login 

           

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
                    String url = BaseUrl + "#/dealdetail/a/00000000-0000-0000-0000-000000000000";
                    util.OpenUrl(url);
                    //driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/dealdetail/a/00000000-0000-0000-0000-000000000000");
                    System.Threading.Thread.Sleep(10000);
                    // driver.FindElement(By.XPath("//li[@id='addmenu']/a/i")).Click();
                    //driver.FindElement(By.LinkText("Deal")).Click();
                    driver.FindElement(deal.mainTab).Click();
                    Thread.Sleep(1000);

                    driver.FindElement(By.Id("CREDealID")).Click();
                    driver.FindElement(By.Id("CREDealID")).SendKeys(credealid);
                    driver.FindElement(By.Id("DealName")).SendKeys("New Deal_" + credealid);
                    driver.FindElement(By.Id("Statusid")).Click();
                    new SelectElement(driver.FindElement(By.Id("Statusid"))).SelectByText("Active");
                    driver.FindElement(By.Id("Statusid")).Click();
                    driver.FindElement(By.Id("DealCity")).SendKeys("Kohala Coast");
                    driver.FindElement(By.Id("TotalCommitment")).Click();
                    driver.FindElement(By.Id("TotalCommitment")).SendKeys("0950000");
                    driver.FindElement(By.Id("cell00")).Click();

                    // add new note in grid
                    Utility.WijmoHelper.CreateFlexGridObject((RemoteWebDriver)driver, "'#mainTabNoteGrid'");
                    //add five rows
                    int numberofnotes = 2;
                    if (numberofnotes > 1)
                    {
                        for (int i = 0; i < numberofnotes; i++)
                        {
                            WijmoHelper.AddNewRowInGrid((RemoteWebDriver)driver);
                        }
                    }
                    var totalRowIdx = WijmoHelper.GetVisibleRows((RemoteWebDriver)driver);
                    var colIndex = WijmoHelper.GetColumnIndex((RemoteWebDriver)driver, "CRENoteID");
                    char ch = 'A';
                    var firstDayCurrentMonth = new DateTime(now.Year, now.Month, 1);
                    var closingdate = firstDayCurrentMonth.AddDays(-6);
                    var maturity = closingdate.AddMonths(24);
                    for (int r = 0; r < totalRowIdx; r++)
                    {
                        WijmoHelper.SetCellElement((RemoteWebDriver)driver, r, colIndex, "NT00" + (r + 1) + credealid);
                        WijmoHelper.SetCellElement((RemoteWebDriver)driver, r, colIndex + 1, ch + " Note");
                        //closing date 
                        WijmoHelper.SetCellElement((RemoteWebDriver)driver, r, colIndex + 5, closingdate.ToString("MM/dd/yyyy"));
                        WijmoHelper.SetCellElement((RemoteWebDriver)driver, r, colIndex + 6, "100000");
                        WijmoHelper.SetCellElement((RemoteWebDriver)driver, r, colIndex + 7, maturity.ToString("MM/dd/yyyy"));
                        WijmoHelper.SetCellElement((RemoteWebDriver)driver, r, colIndex + 8, maturity.ToString("MM/dd/yyyy"));
                        ch++;
                    }

                    var elem = WijmoHelper.GetCellElement((RemoteWebDriver)driver, totalRowIdx - 1, colIndex + 8);
                    //actions.DoubleClick(elem).Perform();


                    driver.FindElement(deal.btnSaveDeal).Click();
                    System.Threading.Thread.Sleep(5000);
                    driver.FindElement(deal.btnCRESvalOk).Click();
                    System.Threading.Thread.Sleep(2000);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(" Exception =" + e);
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
