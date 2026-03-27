using CRES.TestAutoMation.Utility;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Threading;
using WebDriverManager.DriverConfigs.Impl;

namespace CRES.TestAutoMation.Pages
{
    public class Login
    {
      

        private IWebDriver driver = null;
        private Util util = null;
        public Login(IWebDriver d)
        {
            new WebDriverManager.DriverManager().SetUpDriver(new ChromeConfig()); //Auto Update the ChromeDriver Version
            ChromeOptions option = new ChromeOptions();
            option.LeaveBrowserRunning = true;
            this.driver = d;
            util = new Util(d);
        }
        //private By txtlogin=By.XPath("//input[@type='login']")
        private By txtlogin = By.Name("login");
        //private By txtlogin1 = By.Name("login");
        private By txtName = By.Name("password");
        private By btnlogin = By.Id("login");
        private By addmenu = By.Id("addmenu");
        private By HeaderLogo = By.Id("dvHeaderlogo");
        private By LoginHeader = By.XPath("//div[@id='dvHeaderlogo']");

        private By btnaddmenu = By.XPath("/html/body/div/ng-component/div/div[1]/div/div/div[4]/div/ul/li[2]/a/i");
      

        public bool LoginWebPageOld(string username, string password)
        {
            bool res = false;
            try
            {
                util.WaitForElementVisible(btnlogin);
                driver.FindElement(txtlogin).SendKeys(username);
                driver.FindElement(txtName).SendKeys(password);
                driver.FindElement(btnlogin).Click();
                util.WaitForElementVisible(addmenu);
                res = true;
            }
            catch (Exception ex)
            {
                res = false;

            }

            return res;
        }

        public bool LoginWebPage()
        {           
           
            bool res = false;
            string BaseUrl = null;
            string username = null;
            string password = null;
            try
            {
                string subLoginUrl = BaseConfiguration.GetLoginUrlNew();
                string env = BaseConfiguration.GetEnvironment();
                switch (env)
                {

                    case "NewQA":
                        BaseUrl = BaseConfiguration.GetNewQAUrl();
                        username = BaseConfiguration.GetQaUsername();
                        password = BaseConfiguration.GetQaPassword();
                        break;

                    case "QA":
                        BaseUrl = BaseConfiguration.GetNewQAUrl();
                        username = BaseConfiguration.GetQaUsername();
                        password = BaseConfiguration.GetQaPassword();
                        break;

                    case "Ng":
                        BaseUrl = BaseConfiguration.GetNgUrl();
                        username = BaseConfiguration.GetQaUsername();
                        password = BaseConfiguration.GetQaPassword();
                        break;

                    case "Integration":
                        BaseUrl = BaseConfiguration.GetIntUrl();
                        username = BaseConfiguration.GetIntUsername();
                        password = BaseConfiguration.GetIntPassword();
                        break;

                    case "Staging":
                        BaseUrl = BaseConfiguration.GetStagingUrl();
                        username = BaseConfiguration.GetStagingUsername();
                        password = BaseConfiguration.GetStagingPassword();
                        break;

                    case "Acore":
                        BaseUrl = BaseConfiguration.AcoreUrl();
                        username = BaseConfiguration.GetAcoreUsername();
                        password = BaseConfiguration.GetAcorePassword();
                        break;

                    case "Demo":
                        BaseUrl = BaseConfiguration.GetDemoUrl();
                        username = BaseConfiguration.GetDemoUsername();
                        password = BaseConfiguration.GetDemoPassword();
                        break;

                    case "Dev":
                        BaseUrl = BaseConfiguration.GetDevUrl();
                        username = BaseConfiguration.GetDevUsername();
                        password = BaseConfiguration.GetDevPassword();
                        break;

                    default:
                        BaseUrl = BaseConfiguration.GetQAUrl();
                        username = BaseConfiguration.GetQaUsername();
                        password = BaseConfiguration.GetQaPassword();
                        break;
                }

                string LoginUrl = BaseUrl + subLoginUrl;
                util.OpenUrl(LoginUrl);
                System.Threading.Thread.Sleep(5000);

                util.WaitForElementVisible(btnlogin);
                driver.FindElement(txtlogin).SendKeys(username);
                driver.FindElement(txtName).SendKeys(password);
                driver.FindElement(btnlogin).Click();                
                util.WaitForElementVisible(addmenu);
                res = true;
            }
            catch (Exception ex)
            {
                Console.WriteLine("\n Login Status Exception = " + ex);

                res = false;

            }

            return res;
        }

        public bool LoginWebPageMultiBrowser(IWebDriver driver)
        {
            bool res = false;
            string BaseUrl = null;
            string username = null;
            string password = null;
            try
            {
                string subLoginUrl = BaseConfiguration.GetLoginUrlNew();
                string env = BaseConfiguration.GetEnvironment();
                switch (env)
                {
                    case "QA":
                        BaseUrl = BaseConfiguration.GetQAUrl();
                        username = BaseConfiguration.GetQaUsername();
                        password = BaseConfiguration.GetQaPassword();
                        break;

                    case "Integration":
                        BaseUrl = BaseConfiguration.GetIntUrl();
                        username = BaseConfiguration.GetIntUsername();
                        password = BaseConfiguration.GetIntPassword();
                        break;

                    case "Staging":
                        BaseUrl = BaseConfiguration.GetStagingUrl();
                        username = BaseConfiguration.GetStagingUsername();
                        password = BaseConfiguration.GetStagingPassword();
                        break;

                    case "Acore":
                        BaseUrl = BaseConfiguration.AcoreUrl();
                        username = BaseConfiguration.GetAcoreUsername();
                        password = BaseConfiguration.GetAcorePassword();
                        break;

                    case "Demo":
                        BaseUrl = BaseConfiguration.GetDemoUrl();
                        username = BaseConfiguration.GetDemoUsername();
                        password = BaseConfiguration.GetDemoPassword();
                        break;

                    case "Dev":
                        BaseUrl = BaseConfiguration.GetDevUrl();
                        username = BaseConfiguration.GetDevUsername();
                        password = BaseConfiguration.GetDevPassword();
                        break;

                    case "m61":
                        BaseUrl = BaseConfiguration.Getm61Url();
                        username = BaseConfiguration.Getm61Username();
                        password = BaseConfiguration.Getm61Password();
                        break;

                    default:
                        //BaseUrl = BaseConfiguration.GetQAUrl();
                        //username = BaseConfiguration.GetQaUsername();
                        //password = BaseConfiguration.GetQaPassword();
                        Console.WriteLine("Please specify correct environment name");
                        break;
                }

                string LoginUrl = BaseUrl + subLoginUrl;
                Thread.Sleep(5000);

                util.WaitForElementVisible(btnlogin);
                driver.FindElement(txtlogin).SendKeys(username);
                driver.FindElement(txtName).SendKeys(password);
                driver.FindElement(btnlogin).Click();
                Thread.Sleep(5000);
                //util.WaitForElementVisible(addmenu);
                res = true;
            }
            catch (Exception ex)
            {
                res = false;
                Console.WriteLine("Multi Browser Exception in LoginWebPage MultiBrowser method ="+ex.Message+" res = "+res);
            }

            return res;
        }
    }
}
