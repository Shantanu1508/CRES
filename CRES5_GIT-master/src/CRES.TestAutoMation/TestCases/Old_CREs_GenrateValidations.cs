using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using AventStack.ExtentReports;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.ExecutionReports;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using CRES.Utilities;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Support.UI;
using CRES.TestAutoMation.EmailTemplate;

namespace CRES.TestAutoMation.TestCases
{
    internal class Old_CREs_GenrateValidations : BaseClass
    {
 
        ExtentTest test = null;
        public void GetAllDeal()
        {

        }
        string actualMessage;
        bool FFSuccessMessageVisible;
        IWebElement FFSuccessMessage;
        bool validationPopupVisible;
        int numberOfValidations;
        public string[,] data;
        int DealsProcessed = 0;
        readonly DateTime StartTime = DateTime.Now;
        String LogFile = "Logs-" + DateTime.Now;
        string BaseUrl = null;

        readonly string browser = BaseConfiguration.Browser();
        readonly string headless = BaseConfiguration.HeadlessDriver();
        readonly string env = BaseConfiguration.GetEnvironment();
        readonly bool SendProgressEmail = BaseConfiguration.SendProgressEmail();
        readonly int SendProgressEmailDealCounter = BaseConfiguration.SendProgressEmailDealCounter();
        string ExcelDealIDTab = BaseConfiguration.ExcelDealIDTab();

        List<DealDataContract> deallist = new List<DealDataContract>();
        List<AutoMationOutputData> _autoMationOutputDatalstResult = new List<AutoMationOutputData>();
        List<AutoMationOutputData> _autoMationOutputDatalst = new List<AutoMationOutputData>();
        AutoMationOutputData _autoMationOutputData = new AutoMationOutputData();
        WebDriverWait wait;
        Email SendEmail = new Email();


        [Test]
        public void GenerateValidations()
        {
            test = extent.CreateTest("Deal Funding Validation").Info("Test started");
            BrowserHelper helper = new BrowserHelper();
            helper.DeleteBrowserDriverInstances();

            string randomstring = DateTime.Now.ToString("MMddyyyyhhmmss");
            AutomationLogic autologic = new AutomationLogic();
            wait = new WebDriverWait(driver, TimeSpan.FromSeconds(15));
            string runForAllDeal = BaseConfiguration.TestAllDealForGenerateFunding();
            int browserCount = BaseConfiguration.BrowserCount();

            test.Log(Status.Info, "Generate funding automation running in " + browserCount + "  browsers");
            test.Log(Status.Info, "Generate funding automation running in " + env + "  environment");

            //AutomationLogic autologic = new AutomationLogic();
            if (runForAllDeal.ToString() == "Excel")  // Run for Deals in Excel
            {
                Console.WriteLine("\n Automation is running for Excel deals");
                var dataTable = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, ExcelDealIDTab);
                if (dataTable != null)
                {

                    for (int i = 0; i < dataTable.Rows.Count; i++)
                    {
                        if (i > 0)
                        {
                            DealDataContract ldc = new DealDataContract();
                            ldc.DealName = dataTable.Rows[i].ItemArray[0].ToString();
                            ldc.CREDealID = dataTable.Rows[i].ItemArray[1].ToString();
                            deallist.Add(ldc);
                        }
                    }

                }
            }

            else   // Run for All , AllFunded , Autospread , Phantom 
            {
                string getDealType = BaseConfiguration.GetDealType();
                Console.WriteLine("\n Automation is running for Autospread deals for deal type =" + getDealType);
                deallist = autologic.GetAllAutomationDeals(getDealType, env);
                Console.WriteLine("\nDeal List  = " + deallist);
            }

            //set count for deal generate
            int dealCount = deallist.Count();
            deallist = deallist.Skip(0).Take(dealCount).ToList();
            if (deallist != null)
            {
                test.Log(Status.Info, "Generate funding automation started for " + deallist.Count + " deals");
            }
            //SendEmail.sendInitialEmail(dealCount, StartTime, driver);


            List<DealDataContract> deallist1 = new List<DealDataContract>();
            List<DealDataContract> deallist2 = new List<DealDataContract>();
            List<DealDataContract> deallist3 = new List<DealDataContract>();
            List<DealDataContract> deallist4 = new List<DealDataContract>();
            List<DealDataContract> deallist5 = new List<DealDataContract>();


            // for (int i = 1; i == browserCount; i++)
            // {
            //     List<DealDataContract> deallist+i + = new List<DealDataContract>();
            //}

            int itemCnt = 0;
            deallist1 = deallist.Skip(itemCnt).Take(dealCount / browserCount).ToList();
            itemCnt += deallist1.Count();
            deallist2 = deallist.Skip(itemCnt).Take(dealCount / browserCount).ToList();
            itemCnt += deallist2.Count();
            deallist3 = deallist.Skip(itemCnt).Take(dealCount / browserCount).ToList();
            itemCnt += deallist3.Count();
            deallist4 = deallist.Skip(itemCnt).Take(dealCount / browserCount).ToList();
            itemCnt += deallist4.Count();

            //last list assign all remaining deal
            deallist5 = deallist.Skip(itemCnt).Take(dealCount - itemCnt).ToList();

            List<int> integerList = Enumerable.Range(0, 6).ToList();
            var poptions = new ParallelOptions()
            {
                MaxDegreeOfParallelism = browserCount
            };

            Parallel.ForEach(integerList, poptions, i =>
            {
                Console.WriteLine(@"value of new i = {0}", i);

                List<DealDataContract> _lstDeal = new List<DealDataContract>();

                if (i == 0)
                {
                    _lstDeal = deallist1;
                }
                else if (i == 1)
                {
                    _lstDeal = deallist2;
                }
                else if (i == 2)
                {
                    _lstDeal = deallist3;
                }
                else if (i == 3)
                {
                    _lstDeal = deallist4;
                }
                else if (i == 4)
                {
                    _lstDeal = deallist5;
                }


                if (_lstDeal.Count() > 0)
                {
                    IWebDriver _driver = null;
                    if (browser == "Chrome")
                    {
                        ChromeOptions options = new ChromeOptions();
                        options.AddArguments("--window-size=1366x768");
                        if (headless.ToString().ToLower() == "yes")
                        {
                            options.AddArguments("headless");
                        }
                        options.AddArguments("--incognito");
                        options.AddArguments("start-maximized");
                        options.AddArguments("disable-infobars");
                        options.AddArguments("--disable-notifications");
                        options.AddArguments("--ignore-certificate-errors");
                        options.AddArguments("--allow-running-insecure-content");
                        options.AddArguments("--disable-web-security");
                        options.AddExcludedArgument("enable-automation");
                        options.SetLoggingPreference(LogType.Browser, LogLevel.Warning);
                        _driver = new ChromeDriver(options);
                        ((IJavaScriptExecutor)_driver).ExecuteScript("document.body.style.zoom='90%';");
                    }
                    else if (browser == "Edge")
                    {

                        ChromeOptions options = new ChromeOptions();

                    }

                    else
                    {
                        ChromeOptions options = new ChromeOptions();
                        options.AddArguments("--window-size=1366x768");
                        if (headless.ToString().ToLower() == "yes")
                        {
                            options.AddArguments("headless");
                        }
                        options.AddArguments("--incognito");
                        options.AddArguments("start-maximized");
                        options.AddArguments("disable-infobars");
                        options.AddArguments("--disable-notifications");
                        options.AddArguments("--ignore-certificate-errors");
                        options.AddArguments("--allow-running-insecure-content");
                        options.AddArguments("--disable-web-security");
                        options.AddExcludedArgument("enable-automation");
                        options.SetLoggingPreference(LogType.Browser, LogLevel.Warning);
                        _driver = new ChromeDriver(options);
                        ((IJavaScriptExecutor)_driver).ExecuteScript("document.body.style.zoom='90%';");

                    }


                    System.Threading.Thread.Sleep(2000);
                    try
                    {
                        generateFunding(_lstDeal, _driver, randomstring);
                    }
                    catch (Exception ex)
                    {
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (!string.IsNullOrEmpty("generateFunding"))
                        {
                            printMessage += $"Message: <br>{"generateFunding"}<br>";
                        }
                        test.Fail(printMessage);
                        String Message = ex.ToString();
                        ExtentEnd();
                        SendEmail.MergeallFilesAndEmail(randomstring, Message, driver);
                    }
                }
            }
            );

            test.Log(Status.Pass, "Deal Funding Generated Successfully");
            try
            {
                Utility.Util util = new Utility.Util(driver);
                string loggedInUserName = util.GetLoggedInUserName();
                test.Log(Status.Info, "Email sent with validation file attached.");
                test.Log(Status.Info, "Ran By: " + loggedInUserName);
                String FilePath = ExcelUtility.MergeAllFiles(randomstring);
                SendEmail.ValidationFile(FilePath, "", driver);
                driver.Quit();
                ExtentEnd();
            }
            catch (Exception e)
            {
            }

        } // Close GenerateValidations

        public void generateFunding(List<DealDataContract> _lstDeal, IWebDriver driver, string randomstring)
        {
            List<AutoMationOutputData> _autoMationOutputDatalst = new List<AutoMationOutputData>();

            Login login = new Login(driver);
            Utility.Util util = new Utility.Util(driver);
            Deal dealPage = new Deal(driver);
            Deal FundingPage = new Deal(driver);
            string weburl = BaseConfiguration.GetURL();
            //IWebElement AutospreadRepaymentButton;

            BaseUrl = env switch
            {
                "QA" => BaseConfiguration.GetQAUrl(),
                "Integration" => BaseConfiguration.GetIntUrl(),
                "Staging" => BaseConfiguration.GetStagingUrl(),
                "Demo" => BaseConfiguration.GetDemoUrl(),
                "Dev" => BaseConfiguration.GetDevUrl(),
                "Acore" => BaseConfiguration.GetAcoreUrl(),
                "Ng" => BaseConfiguration.GetNgUrl(),
                _ => BaseConfiguration.GetQAUrl(),
            };
            string subLoginUrl = BaseConfiguration.GetLoginUrlNew();
            string LoginUrl = BaseUrl + subLoginUrl;
            string dealfunding = BaseUrl + BaseConfiguration.DealFunding();
            string dashboard = BaseUrl + BaseConfiguration.GetDashboardUrl();

            System.Threading.Thread.Sleep(2000);
            util.OpenUrl(LoginUrl);
            util.WaitForElementVisible(dealPage.loginBtn);
            // System.Threading.Thread.Sleep(5000);

            //login in web site
            if (login.LoginWebPageMultiBrowser(driver))
            {

                for (int loop = 0; loop < _lstDeal.Count; loop++)
                {
                    FFSuccessMessageVisible = false;
                    IWebElement GenerateButton;
                    IWebElement AutospreadRepaymentButton;
                    Actions actions = new Actions(driver);

                    // Send a progress email after every SendProgressEmailDealCounter deals
                    if (SendProgressEmail)
                    {
                        DealsProcessed++;
                        int mod = DealsProcessed % SendProgressEmailDealCounter;
                        if (mod == 0)
                        {
                            SendEmail.sendProgressEmail(deallist.Count, DealsProcessed, StartTime, driver);
                        }
                    }

                    AutoMationOutputData _autoMationOutputData = new AutoMationOutputData();

                    util.OpenUrlMultiBrowser(dealfunding + _lstDeal[loop].CREDealID.ToString(), driver);

                    _autoMationOutputData.DealID = _lstDeal[loop].CREDealID;
                    _autoMationOutputData.DealName = _lstDeal[loop].DealName;

                    System.Threading.Thread.Sleep(3000);
                    dealPage.CheckDealPageLoaded();

                    try
                    {
                        System.Threading.Thread.Sleep(2000);
                        dealPage.clickTotalCommitment();
                        System.Threading.Thread.Sleep(4000);
                        dealPage.ClickFunding();
                        System.Threading.Thread.Sleep(4000);
                        dealPage.CheckDealPageLoaded();
                        IWebElement DealType = driver.FindElement(By.Id("dealBtntype"));
                        string ButtonToClick = DealType.GetAttribute("innerHTML");
                        // string i2 = driver.ExecuteJavaScript<string>("return arguments[0].innerHTML", DealType);
                        //string i3 = DealType.GetAttribute("textContent");
                        //string i4 = driver.ExecuteJavaScript<string>("return arguments[0].textContent", DealType);
                        //ButtonToClick = "";

                        try
                        {
                            switch (ButtonToClick)
                            {

                                case "1":
                                    util.WaitForElementVisible(dealPage.btnGenerateFunding);
                                    GenerateButton = dealPage.GenerateFutureFundingButton();
                                    System.Threading.Thread.Sleep(1000);
                                    actions.MoveToElement(GenerateButton).Perform();
                                    System.Threading.Thread.Sleep(2000);
                                    GenerateButton.Click();
                                    getValidations(driver);
                                    break;

                                case "2":
                                    System.Threading.Thread.Sleep(2000);
                                    util.WaitForElementVisible(dealPage.btnRepaymentAutpspread);
                                    AutospreadRepaymentButton = dealPage.AutospreadRepaymentButton();
                                    actions.MoveToElement(AutospreadRepaymentButton).Perform();
                                    System.Threading.Thread.Sleep(2000);
                                    AutospreadRepaymentButton.Click();
                                    getValidations(driver);
                                    break;

                                case "0":
                                    _autoMationOutputData.GenerateMessage = "<USE RULE N>";
                                    //System.Threading.Thread.Sleep(5000);
                                    if (BaseConfiguration.AllowSave())
                                    {
                                        _autoMationOutputData = SaveDeal(_autoMationOutputData, _lstDeal[loop].CREDealID, driver);
                                    }
                                    break;

                                case "":
                                    try
                                    {
                                        try
                                        {
                                            util.WaitForElementVisible(dealPage.btnGenerateFunding);
                                            GenerateButton = dealPage.GenerateFutureFundingButton();
                                            actions.MoveToElement(GenerateButton).Perform();
                                            System.Threading.Thread.Sleep(2000);
                                            GenerateButton.Click();
                                            getValidations(driver);
                                        }
                                        catch
                                        {
                                            // util.WaitForElementVisible(dealPage.btnRepaymentAutpspread);
                                            AutospreadRepaymentButton = dealPage.AutospreadRepaymentButton();
                                            actions.MoveToElement(AutospreadRepaymentButton).Perform();
                                            //System.Threading.Thread.Sleep(2000);
                                            AutospreadRepaymentButton.Click();
                                            getValidations(driver);
                                        }
                                    }

                                    catch
                                    {
                                        _autoMationOutputData.GenerateMessage = "<USE RULE N>";
                                        util.captureScreenshotMultiBrowser(_lstDeal[loop].CREDealID + "_UseRuleN", driver);
                                        //System.Threading.Thread.Sleep(2000);
                                        if (BaseConfiguration.AllowSave())
                                        {
                                            _autoMationOutputData = SaveDeal(_autoMationOutputData, _lstDeal[loop].CREDealID, driver);
                                        }
                                    }

                                    //if (BaseConfiguration.AllowSave())
                                    // {
                                    //     _autoMationOutputData = saveDeal(_autoMationOutputData, _lstDeal[loop].CREDealID, driver);
                                    //}

                                    break;
                            }
                        }
                        catch (Exception e)
                        {

                        }

                        _autoMationOutputDatalst.Add(_autoMationOutputData);

                        if (_autoMationOutputDatalst.Count >= 10)
                        {
                            Random _random1 = new Random();
                            string strPost1 = _random1.Next().ToString();
                            GenerateExcelFile.CreateExcelDataTable(ObjToDataTable.ConvertToDataTable(_autoMationOutputDatalst), "Result" + strPost1 + "_" + randomstring);
                            _autoMationOutputDatalst.Clear();
                        }

                        void getValidations(IWebDriver driver)
                        {
                            try
                            {
                                try
                                {
                                    System.Threading.Thread.Sleep(1000);
                                    IWebElement overrideNonCommentedRecordsPopUp = driver.FindElement(dealPage.overrideNonCommentedRecords);
                                    Boolean popupvisible = overrideNonCommentedRecordsPopUp.Displayed;
                                    if (popupvisible)
                                    {
                                        IWebElement okbutton = driver.FindElement(dealPage.btnoverrideNonCommentedRecordsOk);
                                        okbutton.Click();
                                    }
                                }
                                catch (Exception e)
                                {
                                    //FFSuccessMessageVisible = false;
                                }

                                //System.Threading.Thread.Sleep(1000);
                                try
                                {
                                    WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(60));
                                    wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(dealPage.successMessage));
                                    FFSuccessMessage = driver.FindElement(dealPage.successMessage);
                                    FFSuccessMessageVisible = FFSuccessMessage.Displayed;
                                    actualMessage = FFSuccessMessage.Text;
                                }
                                catch (Exception e)
                                {
                                    FFSuccessMessageVisible = false;
                                    _autoMationOutputData.GenerateMessage = "1 Error in generating funding schedule.";
                                }

                                if (FFSuccessMessageVisible)
                                {
                                    util.captureScreenshotMultiBrowser(_lstDeal[loop].CREDealID + "_Generate", driver);
                                    String successMessage = "Funding schedule generated successfully.";
                                    if (actualMessage.Equals(successMessage))
                                    {
                                        _autoMationOutputData.GenerateMessage = actualMessage;

                                        System.Threading.Thread.Sleep(4000);

                                    }
                                }

                                try
                                {
                                    validationPopupVisible = driver.FindElement(dealPage.validationPopUp).Displayed;
                                }
                                catch
                                {
                                    validationPopupVisible = false;
                                }

                                if (validationPopupVisible) // Sometimes validation comes for commitment tab even if funding schedule generates successfully.
                                {
                                    util.captureScreenshotMultiBrowser(_lstDeal[loop].CREDealID + "_Generate", driver);
                                    IList<IWebElement> Validations = driver.FindElements(dealPage.ValidationsList);
                                    numberOfValidations = Validations.Count;

                                    for (int j = 1; j <= numberOfValidations; j++)
                                    {
                                        String validation = driver.FindElement(By.XPath("//*[@id=\"dialogboxbody\"]/p[" + j + "]")).Text;

                                        //read property name dynamicly
                                        PropertyInfo _propertyInfo = _autoMationOutputData.GetType().GetProperty("Validation" + j);
                                        _propertyInfo.SetValue(_autoMationOutputData, validation, null);

                                    }

                                    IWebElement OkButton = driver.FindElement(dealPage.btnGenerateFundingOK);
                                    OkButton.Click();

                                    System.Threading.Thread.Sleep(1000);
                                }

                                if (BaseConfiguration.AllowSave())
                                {
                                    _autoMationOutputData = SaveDeal(_autoMationOutputData, _lstDeal[loop].CREDealID, driver);
                                }

                                if (FFSuccessMessageVisible == false && validationPopupVisible == false)
                                {
                                    _autoMationOutputData.GenerateMessage = "Error in generating funding schedule.";
                                }
                            }
                            catch (Exception e)
                            {
                                _autoMationOutputData.GenerateMessage = "Timeout or error in generating funding schedule.";
                                util.captureScreenshotMultiBrowser(_lstDeal[loop].CREDealID + "_ErrorInGenerate", driver);
                            }
                        }
                    }
                    catch (Exception e)
                    {
                        //System.Diagnostics.Debug.WriteLine(e);
                        _autoMationOutputData.GenerateMessage = "Timeout or error in loading the deal.";
                    }
                }  // For Loop Close

                System.Diagnostics.Debug.WriteLine(_autoMationOutputDatalst);

                Random _random = new Random();
                string strPost = _random.Next().ToString();
                GenerateExcelFile.CreateExcelDataTable(ObjToDataTable.ConvertToDataTable(_autoMationOutputDatalst), "Result" + strPost + "_" + randomstring);
                //GenerateExcelFile.CreateExcel(_autoMationOutputDatalst, "Result" + strPost);
                driver.Quit();
            }  // Close (If Login successful)
            else
            {
                System.Diagnostics.Debug.WriteLine("Login Failed");
                driver.Quit();
            }

        } // Close GenerateFunding





        public AutoMationOutputData SaveDeal(AutoMationOutputData _autoMationOutputData, String CREDealID, IWebDriver driver)
        {
            Deal dealPage = new Deal(driver);
            Utility.Util util = new Utility.Util(driver);
            //System.Diagnostics.Debug.WriteLine("Save");
            util.WaitForElementVisible(dealPage.btnSaveDeal);
            IWebElement saveButton = driver.FindElement(dealPage.btnSaveDeal);
            Actions actions = new Actions(driver);
            actions.MoveToElement(saveButton).Perform();

            System.Threading.Thread.Sleep(2000);
            saveButton.Click();
            System.Threading.Thread.Sleep(2000);
            try
            {
                IWebElement savedialogmessage = driver.FindElement(dealPage.saveDialogBox);
                IWebElement okButton = driver.FindElement(dealPage.saveDialogBoxOkButton);
                if (savedialogmessage.Displayed)
                {
                    util.captureScreenshotMultiBrowser(CREDealID + "_Warning", driver);
                    okButton.Click();
                }
            }
            catch (Exception e)
            {
            }

            bool validationPopupSaveVisible = driver.FindElement(dealPage.validationPopUp).Displayed;
            if (validationPopupSaveVisible)
            {
                IList<IWebElement> Validations = driver.FindElements(dealPage.ValidationsList);
                int numberOfValidations = Validations.Count;

                if (numberOfValidations != 0)
                {
                    for (int j = 1; j <= numberOfValidations; j++)
                    {
                        String msgValidation = driver.FindElement(By.XPath("//*[@id=\"dialogboxbody\"]/p[" + j + "]")).Text;
                        //read property name dynamicly
                        PropertyInfo _propertyInfo = _autoMationOutputData.GetType().GetProperty("Validation" + j);
                        _propertyInfo.SetValue(_autoMationOutputData, msgValidation, null);

                        util.captureScreenshotMultiBrowser(CREDealID + "_Save", driver);
                    }
                }
            }
            else
            {
                try
                {
                    WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(180));
                    wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(dealPage.successMessage));
                    String dealSaveSuccessActualMessage = driver.FindElement(dealPage.successMessage).Text;
                    _autoMationOutputData.SaveMessage = dealSaveSuccessActualMessage;

                    // Take screenshot
                    System.Threading.Thread.Sleep(1000);
                    util.captureScreenshotMultiBrowser(CREDealID + "_Save", driver);
                    System.Threading.Thread.Sleep(3000);
                }
                catch (Exception e)
                {
                    _autoMationOutputData.SaveMessage = "Timeout/Error in saving the deal";
                    // Take screenshot
                    System.Threading.Thread.Sleep(2000);
                    util.captureScreenshotMultiBrowser(CREDealID + "_ErrorInSave", driver);
                }
            }


            return _autoMationOutputData;

        }  // Save Close

        // [Test]
        // public void SendEMail1()
        // {
        //      SendEmail.TestEmail();
        //  }


    } // Close class

} // Close namespace
