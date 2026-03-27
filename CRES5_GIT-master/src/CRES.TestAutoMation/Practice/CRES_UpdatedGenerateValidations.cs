using AventStack.ExtentReports;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.EmailTemplate;
using CRES.TestAutoMation.ExecutionReports;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.TestCases;
using CRES.TestAutoMation.Utility;
using CRES.Utilities;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Support.UI;
using SeleniumExtras.WaitHelpers;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;

namespace CRES.TestAutoMation.Practice
{
    public class CRES_UpdatedGenerateValidations : BaseClass
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
            driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(50);
            test = extent.CreateTest("Deal Funding Validation").Info("Test started");
            BrowserHelper helper = new BrowserHelper();
            helper.DeleteBrowserDriverInstances();

            string randomstring = DateTime.Now.ToString("MMddyyyyhhmmss");
            AutomationLogic autologic = new AutomationLogic();
            wait = new WebDriverWait(driver, TimeSpan.FromSeconds(15));
            string runForAllDeal = BaseConfiguration.GetDealType();
            int browserCount = BaseConfiguration.BrowserCount();

            test.Log(Status.Info, "Generate funding automation running in " + browserCount + "  browsers");
            test.Log(Status.Info, "Generate funding automation running in " + env + "  environment");

            //AutomationLogic autologic = new AutomationLogic();
            /*f (runForAllDeal.ToString() == "All") //Run for  All Deals
            {
                Console.WriteLine("\n Automation is running for All the deals");
                //TestAllDealForGenerateFunding                
                deallist = autologic.GetAllDeal();
            }
            */
            if (runForAllDeal.ToString().ToLower() == "excel")  // Run for Deals in Excel
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
                string env = BaseConfiguration.GetEnvironment();
                Console.WriteLine("\n Automation is running for Autospread deals for deal type ="+ getDealType);
                deallist = autologic.GetAllAutomationDeals(getDealType, env);
                Console.WriteLine("\nDeal List  = " + deallist);
            }

            //set count for deal generate
            int cntDeal = deallist.Count();
            deallist = deallist.Skip(0).Take(cntDeal).ToList();
            if (deallist != null)
            {
                test.Log(Status.Info, "Generate funding automation started for " + deallist.Count + " deals");
            }
            SendEmail.SendInitializationEmail(cntDeal, StartTime, driver);


            List<DealDataContract> deallist1 = new List<DealDataContract>();
            List<DealDataContract> deallist2 = new List<DealDataContract>();
            List<DealDataContract> deallist3 = new List<DealDataContract>();
            List<DealDataContract> deallist4 = new List<DealDataContract>();

            // for (int i = 1; i == browserCount; i++)
            // {
            //     List<DealDataContract> deallist+i + = new List<DealDataContract>();
            //}

            int itemCnt = 0;
            deallist1 = deallist.Skip(itemCnt).Take(cntDeal / browserCount).ToList();
            Console.WriteLine("\ndeallist1 = " + deallist1);
            itemCnt += deallist1.Count();
            deallist2 = deallist.Skip(itemCnt).Take(cntDeal / browserCount).ToList();
            Console.WriteLine("\ndeallist2 = " + deallist2);
            itemCnt += deallist2.Count();
            deallist3 = deallist.Skip(itemCnt).Take(cntDeal / browserCount).ToList();
            Console.WriteLine("\ndeallist3 = " + deallist3);
            itemCnt += deallist3.Count();

            //last list assign all remaining deal
            deallist4 = deallist.Skip(itemCnt).Take(cntDeal - itemCnt).ToList();
            Console.WriteLine("\ndeallist4 = " + deallist4);

            List<int> integerList = Enumerable.Range(0, 5).ToList();
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
                        SendEmail.MergeallFilesAndEmail(randomstring, Message, driver);  // Check Point 
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
                SendEmail.ValidationFile(FilePath, "", driver);               // Check Point
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
                "Ng" => BaseConfiguration.GetNgUrl(),
                "Integration" => BaseConfiguration.GetIntUrl(),
                "Staging" => BaseConfiguration.GetStagingUrl(),
                "Demo" => BaseConfiguration.GetDemoUrl(),
                "Dev" => BaseConfiguration.GetDevUrl(),
                "Acore" => BaseConfiguration.GetAcoreUrl(),
                _ => BaseConfiguration.GetQAUrl(),
            };
            string subLoginUrl = BaseConfiguration.GetLoginUrlNew();
            string LoginUrl = BaseUrl + subLoginUrl;
            string dealfunding = BaseUrl + BaseConfiguration.DealFunding();
            string dashboard = BaseUrl + BaseConfiguration.GetDashboardUrl();

            
            util.OpenUrl(LoginUrl);
            System.Threading.Thread.Sleep(2000);
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
                             SendEmail.sendProgressEmail(deallist.Count, DealsProcessed, StartTime, driver);  //check Point 
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
                        // System.Threading.Thread.Sleep(2000);
                        //dealPage.clickTotalCommitment();
                        driver.Navigate().Refresh();
                        System.Threading.Thread.Sleep(5000);
                        dealPage.ClickFunding();
                        System.Threading.Thread.Sleep(4000);
                        dealPage.CheckDealPageLoaded();
                        IWebElement DealType = driver.FindElement(By.Id("dealBtntype"));
                        string ButtonToClick = DealType.GetAttribute("innerHTML");
                        //string i2 = driver.ExecuteJavaScript<string>("return arguments[0].innerHTML", DealType);
                        //string i3 = DealType.GetAttribute("textContent");
                        //string i4 = driver.ExecuteJavaScript<string>("return arguments[0].textContent", DealType);
                        //ButtonToClick = "";
                        
                            switch (ButtonToClick)
                            {

                                case "1":
                                    util.WaitForElementVisible(dealPage.btnGenerateFunding);
                                    GenerateButton = dealPage.GenerateFutureFundingButton();
                                if (GenerateButton.Displayed)
                                {
                                    actions.MoveToElement(GenerateButton).Perform();
                                    actions.MoveToElement(GenerateButton).Click().Perform();
                                    System.Threading.Thread.Sleep(2000);
                                }
                                else
                                {
                                    Thread.Sleep(2000);
                                    GenerateButton.Click();
                                }    
                                    
                                    getValidations(driver);
                                break;

                                case "2":
                                    System.Threading.Thread.Sleep(2000);
                                    util.WaitForElementVisible(dealPage.btnRepaymentAutpspread);
                                    AutospreadRepaymentButton = dealPage.AutospreadRepaymentButton();
                                if (AutospreadRepaymentButton.Displayed)
                                {
                                    actions.MoveToElement(AutospreadRepaymentButton).Perform();
                                    actions.MoveToElement(AutospreadRepaymentButton).Click().Perform();
                                    System.Threading.Thread.Sleep(2000);

                                }
                                else
                                {
                                    Thread.Sleep(2000);
                                    AutospreadRepaymentButton.Click();
                                }
                                    getValidations(driver);
                                break;

                                case "0":
                                    _autoMationOutputData.GenerateMessage = "<USE RULE N>";
                                    System.Threading.Thread.Sleep(5000);
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
                                        if (GenerateButton.Displayed)
                                        {
                                            actions.MoveToElement(GenerateButton).Perform();
                                            actions.MoveToElement(GenerateButton).Click().Perform();
                                            //System.Threading.Thread.Sleep(2000);

                                        }
                                        else
                                        {
                                            Thread.Sleep(2000);
                                            GenerateButton.Click();
                                        }
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
                                        // util.captureScreenshotMultiBrowser(_lstDeal[loop].CREDealID + "_UseRuleN", driver);
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
                    catch (Exception ex)
                    {
                       Console.WriteLine("Deal Page Load Exception = " + ex);
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
                            System.Threading.Thread.Sleep(1000);
                            IWebElement overrideNonCommentedRecordsPopUp = driver.FindElement(dealPage.overrideNonCommentedRecords);
                            Boolean popupvisible = overrideNonCommentedRecordsPopUp.Displayed;
                            if (popupvisible)
                            {
                                Thread.Sleep(2000);
                                IWebElement okbutton = driver.FindElement(dealPage.btnoverrideNonCommentedRecordsOk);
                                okbutton.Click();
                            }
                        }
                        catch (Exception ex)
                        {
                            //FFSuccessMessageVisible = false;
                        }

                        //System.Threading.Thread.Sleep(1000);
                        try
                        {
                            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(40));
                            wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(dealPage.successMessage));
                            FFSuccessMessage = driver.FindElement(dealPage.successMessage);
                            FFSuccessMessageVisible = FFSuccessMessage.Displayed;
                            actualMessage = FFSuccessMessage.Text;
                            Console.WriteLine("Generate funding Success message = " + actualMessage + " and Is this displayed = " + FFSuccessMessageVisible);
                        }
                        catch (Exception ex)
                        {
                            FFSuccessMessageVisible = false;
                            Console.WriteLine("Generate funding Success message Exception= " + ex);
                        }

                        

                        try
                        {
                        if (FFSuccessMessageVisible)
                        {
                            // util.captureScreenshotMultiBrowser(_lstDeal[loop].CREDealID + "_Generate", driver);
                            String successMessage = "Funding schedule generated successfully.";
                            if (actualMessage.Equals(successMessage))
                            {
                                _autoMationOutputData.GenerateMessage = actualMessage;
                                Console.WriteLine("Generate funding Success message 02 = " + actualMessage + " and Is this displayed 02= " + FFSuccessMessageVisible);
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
                                // util.captureScreenshotMultiBrowser(_lstDeal[loop].CREDealID + "_Generate", driver);
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

                                Thread.Sleep(1000);
                            }

                            if (BaseConfiguration.AllowSave())
                            {
                                _autoMationOutputData = SaveDeal(_autoMationOutputData, _lstDeal[loop].CREDealID, driver);
                            }

                            if (FFSuccessMessageVisible == false && validationPopupVisible == false)
                            {
                                _autoMationOutputData.GenerateMessage = "Error in generating funding schedule.";
                            }

                            /*else
                            {
                                _autoMationOutputData.GenerateMessage = "Timeout or error in generating funding schedule.";
                                *//*util.captureScreenshotMultiBrowser(_lstDeal[loop].CREDealID + "_ErrorInGenerate", driver);
                                Console.WriteLine("");*//*
                            }*/
                        }
                        catch (Exception ex)
                        {
                            validationPopupVisible = false;
                            _autoMationOutputData.GenerateMessage = "Timeout or error in generating funding schedule.";
                            Console.WriteLine("validationPopupVisible Exception = " + ex);
                        }                 


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
            /*Actions actions = new Actions(driver);
            actions.MoveToElement(saveButton).Perform();

            System.Threading.Thread.Sleep(2000);
            saveButton.Click();
            System.Threading.Thread.Sleep(2000);*/


            Thread.Sleep(5000);
            if (saveButton.Displayed)
            {
            saveButton.Click();
                Thread.Sleep(6000);
            }
            else
            {
                Thread.Sleep(2000);
                Actions actions = new Actions(driver);
                actions.MoveToElement(saveButton).Click().Build().Perform();
                Thread.Sleep(6000);
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

                      //  util.captureScreenshotMultiBrowser(CREDealID + "_Save", driver);
                    }
                }
            }

            IWebElement savedialogmessage = driver.FindElement(dealPage.saveDialogBox);

            if (savedialogmessage.Displayed)
            {

                try
                {

                    // util.captureScreenshotMultiBrowser(CREDealID + "_Warning", driver);
                    Thread.Sleep(4000);
                    IWebElement okButton = driver.FindElement(dealPage.btnCRESvalOk);
                    //util.WaitForElementVisible(dealPage.btnCRESvalOk);

                    //util.WaitForStuff(dealPage.btnCRESvalOk, dealPage.saveDialogBoxOkButton);

                    if (okButton.Displayed)
                    {
                        okButton.Click();
                        Thread.Sleep(6000);
                    }
                    else
                    {
                        IWebElement okButton02 = driver.FindElement(dealPage.saveDialogBoxOkButton);
                        //util.WaitForElementVisible(dealPage.saveDialogBoxOkButton);
                        okButton02.Click();
                        Thread.Sleep(6000);
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(" Dialog box ok button exception = " + ex);
                }
                try
                {

                    //util.WaitForStuff(dealPage.successMessage02, dealPage.successMessage );
                    /* bool SuccMesssage = driver.FindElement(By.XPath("//div[contains(@class, 'head fixheaderdiv')]/div[contains(@id, 'sucessmessagediv')]")).Displayed;
                     Console.WriteLine("SuccMesssage = "+ SuccMesssage)
;                    util.WaitForElementVisible(dealPage.successMessage);

                    WebDriverWait wait = new WebDriverWait(driver, System.TimeSpan.FromSeconds(30));
                    IWebElement element = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(dealPage.successMessage));*/

                    

                    WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(180));
                    wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(dealPage.calculationStatusRunning));
                    

                    if (driver.FindElement(dealPage.calculationStatus).Text == "Running")
                    {
                        //util.WaitForElementVisible(dealPage.successMessage);
                        String dealSaveSuccessActualMessage = driver.FindElement(dealPage.calculationStatusRunning).Text;
                        Console.WriteLine("dealSaveSuccessActualMessage = " + dealSaveSuccessActualMessage);
                        _autoMationOutputData.SaveMessage = dealSaveSuccessActualMessage;

                        // Take screenshot
                        Thread.Sleep(1000);
                        // util.captureScreenshotMultiBrowser(CREDealID + "_Save", driver);
                        // System.Threading.Thread.Sleep(3000);
                    }

                    else
                    {

                        String CalulationStatus = driver.FindElement(dealPage.calculationStatus).Text;
                        Console.WriteLine("dealSaveSuccessActualMessage = " + CalulationStatus);
                        _autoMationOutputData.SaveMessage = "Deal Saved Successfully - " + CalulationStatus;

                        // Take screenshot
                        Thread.Sleep(1000);
                        // util.captureScreenshotMultiBrowser(CREDealID + "_Save", driver);
                        // System.Threading.Thread.Sleep(3000);
                    }
                }
                catch (Exception ex)
                {
                    _autoMationOutputData.SaveMessage = "Timeout/Error in saving the deal";
                    Console.WriteLine("Success Message Exception " + ex);
                    // Take screenshot
                    Thread.Sleep(2000);
                    //  util.captureScreenshotMultiBrowser(CREDealID + "_ErrorInSave", driver);
                }



            }

            else
            {
              try
              {


                    WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(180));
                    wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(dealPage.calculationStatusRunning));

                    if (driver.FindElement(dealPage.calculationStatusRunning).Text == "Running")
                {
                        //util.WaitForElementVisible(dealPage.successMessage);
                        String CalulationStatus = driver.FindElement(dealPage.calculationStatus).Text;
                        Console.WriteLine("dealSaveSuccessActualMessage = " + CalulationStatus);
                        _autoMationOutputData.SaveMessage = "Deal Saved Successfully - " + CalulationStatus;

                        // Take screenshot
                        Thread.Sleep(1000);
                    // util.captureScreenshotMultiBrowser(CREDealID + "_Save", driver);
                    // System.Threading.Thread.Sleep(3000);
                }

                else
                {

                    String dealSaveSuccessActualMessage = driver.FindElement(dealPage.calculationStatus).Text;
                        _autoMationOutputData.SaveMessage = "Timeout/Error in saving the deal";
                        Console.WriteLine("dealSaveSuccessActualMessage = " + dealSaveSuccessActualMessage);
                   // _autoMationOutputData.SaveMessage = dealSaveSuccessActualMessage;

                    // Take screenshot
                    Thread.Sleep(1000);
                    // util.captureScreenshotMultiBrowser(CREDealID + "_Save", driver);
                    // System.Threading.Thread.Sleep(3000);
                }
              }
              catch(Exception ex)
              {
                    _autoMationOutputData.SaveMessage = "Timeout/Error in saving the deal";
                    Console.WriteLine("Success Message Exception " + ex);
                    // Take screenshot
                    Thread.Sleep(2000);
              }

            
            }
            
            


            return _autoMationOutputData;

        }


        /*public AutoMationOutputData saveDeal(AutoMationOutputData _autoMationOutputData, String CREDealID, IWebDriver driver)
        {
            bool dealSaveSuccessMessage = false;
            String dealSaveSuccessActualMessage = null;
            Deal dealPage = null;
            try
            {


                dealPage = new Deal(driver);
                Utility.Util util = new Utility.Util(driver);
                //System.Diagnostics.Debug.WriteLine("Save");
                util.WaitForElementVisible(dealPage.btnSaveDeal);
                IWebElement saveButton = driver.FindElement(dealPage.btnSaveDeal);
                
                Thread.Sleep(5000);
                if (saveButton.Displayed)
                {
                    saveButton.Click();
                    
                }
                else
                {
                    Thread.Sleep(2000);
                    Actions actions = new Actions(driver);
                    actions.MoveToElement(saveButton).Click().Perform();                    
                }
                
            }
            catch (Exception ex)
            {
                Console.WriteLine("save Button Exception" + ex);
            }
            try
            {
                Thread.Sleep(1000);
                IWebElement savedialogmessage = driver.FindElement(dealPage.saveDialogBox);
                IWebElement okButton = driver.FindElement(dealPage.btnCRESvalOk);
                if (savedialogmessage.Displayed)
                {
                    // util.captureScreenshotMultiBrowser(CREDealID + "_Warning", driver);
                    Thread.Sleep(4000);
                    okButton.Click();
                    //Thread.Sleep(3000);
                }
              
            }
            catch (Exception ex)
            {
                Console.WriteLine("Save Deal dialog exception = " + ex);
            }
            try
            {
                *//*  bool dealSaveSuccessMessage = driver.FindElement(dealPage.successMessage).Displayed;  change 01

                  String dealSaveSuccessMessageText = driver.FindElement(dealPage.successMessage).Text;*//*
                

                bool validationPopupSaveVisible = driver.FindElement(dealPage.validationPopUp).Displayed;
                Console.WriteLine("validationPopupSaveVisible  = " + validationPopupSaveVisible);

                if (validationPopupSaveVisible)
                {
                  

                        IList<IWebElement> Validations = driver.FindElements(dealPage.ValidationsList);
                        int numberOfValidations = Validations.Count;
                        // Take screenshot
                        *//*  System.Threading.Thread.Sleep(2000);
                          util.captureScreenshotMultiBrowser(CREDealID + "_Save", driver);
                          System.Threading.Thread.Sleep(1000); *//*
                    
                    if (numberOfValidations != 0)
                    {
                        for (int j = 1; j <= numberOfValidations; j++)
                        {
                            String msgValidation = driver.FindElement(By.XPath("//*[@id=\"dialogboxbody\"]/p[" + j + "]")).Text;
                            //read property name dynamicly
                            PropertyInfo _propertyInfo = _autoMationOutputData.GetType().GetProperty("Validation" + j);
                            _propertyInfo.SetValue(_autoMationOutputData, msgValidation, null);

                            // util.captureScreenshotMultiBrowser(CREDealID + "_Save", driver);
                        }
                    }
                }
                else
                {
                    try
                    {
                        WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(30));
                        wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(dealPage.successMessage));
                        dealSaveSuccessMessage = driver.FindElement(dealPage.successMessage).Displayed;
                        

                        Console.WriteLine("Save Deal Success message = " + dealSaveSuccessMessage);

                        if (dealSaveSuccessMessage)
                        {
                            dealSaveSuccessActualMessage = driver.FindElement(dealPage.successMessage).Text;
                            _autoMationOutputData.SaveMessage = dealSaveSuccessActualMessage;
                            Console.WriteLine("Save Deal Success message text = " + dealSaveSuccessActualMessage + " and Is this displayed 01 = " + dealSaveSuccessMessage);
                            Thread.Sleep(2000);
                        }

                        else
                        {

                            _autoMationOutputData.SaveMessage = "Timeout/Error in saving the deal";
                            Console.WriteLine("Deal save Time Out error");
                            // Take screenshot
                            System.Threading.Thread.Sleep(2000);

                            *//*wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(dealPage.successMessage));
                            String dealSaveSuccessActualMessage = driver.FindElement(dealPage.successMessage).Text;
                            _autoMationOutputData.SaveMessage = dealSaveSuccessActualMessage;*//*

                            // Take screenshot
                            *//*  System.Threading.Thread.Sleep(2000);
                              util.captureScreenshotMultiBrowser(CREDealID + "_Save", driver);
                              System.Threading.Thread.Sleep(1000); *//*

                        }
                    }
                    catch (Exception ex)
                    {
                        _autoMationOutputData.SaveMessage = "Timeout/Error in saving the deal";
                        Console.WriteLine("Deal success message Exception= " + ex);
                        // Take screenshot
                        System.Threading.Thread.Sleep(2000);
                        //  util.captureScreenshotMultiBrowser(CREDealID + "_ErrorInSave", driver);
                    }

                }       
   
            }
            catch (Exception ex)
            {
                _autoMationOutputData.SaveMessage = "Timeout/Error in saving the deal";
                Console.WriteLine("success Message = " + ex);
            }



            return _autoMationOutputData;
            

        }*/         // Save Close

        /* [Test]
         public void SendEMail1()
         {
              SendEmail.TestEmail();
          }
        */

    } // Close class

} // Close namespace