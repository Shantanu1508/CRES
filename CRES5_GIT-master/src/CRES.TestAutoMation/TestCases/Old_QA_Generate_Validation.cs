
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using AventStack.ExtentReports;
using com.sun.xml.@internal.bind.v2.runtime.unmarshaller;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.ExecutionReports;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using CRES.Utilities;
using NPOI.HPSF;
using NPOI.POIFS.FileSystem;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Support.UI;
using System.Windows;
using OpenQA.Selenium.Support.Extensions;
using System.Diagnostics;
using CRES.TestAutoMation.EmailTemplate;
using java.util.concurrent;
using OpenQA.Selenium.Edge;

namespace CRES.TestAutoMation.TestCases
{
    internal class Old_QA_Generate_Validation : BaseClass
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


            /* [Test]
             public void generateFundingOLD()
             {
                 test = extent.CreateTest("Generate Funding").Info("Test started");

                 List<AutoMationOutputData> _autoMationOutputDatalst = new List<AutoMationOutputData>();

                 Login login = new Login(driver);
                 Utility.Util util = new Utility.Util(driver);
                 Deal dealPage = new Deal(driver);
                 Deal FundingPage = new Deal(driver);
                 BaseUrl = env switch
                 {
                     "QA" => BaseConfiguration.GetQAUrl(),
                     "Integration" => BaseConfiguration.GetIntUrl(),
                     "Staging" => BaseConfiguration.GetStagingUrl(),
                     "Dev" => BaseConfiguration.GetDevUrl(),
                     _ => BaseConfiguration.GetQAUrl(),
                 };
                 // string weburl = BaseConfiguration.GetURL();
                 //string username = BaseConfiguration.getusername();
                 // string password = BaseConfiguration.getpassword();
                 string subLoginUrl = BaseConfiguration.GetLoginUrlNew();

                 string runForAllDeal = BaseConfiguration.TestAllDealForGenerateFunding();
                 string dashboard = "https://qacres4.azurewebsites.net/#/dashboard";
                 string dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
                 test.Log(Status.Info, "Running on " + env);


                 if (runForAllDeal.ToString().ToLower() == "yes")
                 {
                     test.Log(Status.Info, "Running for all deals ");
                     //TestAllDealForGenerateFunding
                     AutomationLogic autologic = new AutomationLogic();
                     deallist = autologic.GetAllDeal();
                 }
                 else
                 {

                     var dataTable = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, "Deal_List");
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

                 test.Log(Status.Info, "Running for sample deals ");
                 string LoginUrl = BaseUrl + subLoginUrl;
                 util.OpenUrl(LoginUrl);
                 System.Threading.Thread.Sleep(5000);


                 test.Log(Status.Info, "Login Website started ");
                 //login in web site
                 if (login.LoginWebPage())
                 {
                     test.Log(Status.Info, "Login Website Ended ");
                     // data = new string[deallist.Count + 1, 10];

                     for (loop = 0; loop < deallist.Count; loop++)
                     {
                         FFSuccessMessageVisible = false;

                         AutoMationOutputData _autoMationOutputData = new AutoMationOutputData();
                         System.Diagnostics.Debug.WriteLine("Remaining Deals: " + (deallist.Count - loop));
                         util.OpenUrl(dashboard);
                         System.Threading.Thread.Sleep(4000);
                         //dealPage.CheckDealPageLoaded();
                         util.OpenUrl(dealfunding + deallist[loop].CREDealID.ToString());

                         _autoMationOutputData.CREID = deallist[loop].CREDealID;
                         _autoMationOutputData.Name = deallist[loop].DealName;
                         TextLogger.Write(deallist[loop].CREDealID, LogFile);

                         System.Threading.Thread.Sleep(8000);
                         dealPage.CheckDealPageLoaded();
                         test.Log(Status.Info, "Deal page Loaded ");
                         try
                         {
                             System.Threading.Thread.Sleep(5000);
                             dealPage.ClickFunding();
                             dealPage.CheckDealPageLoaded();

                             try
                             {
                                 Actions actions = new Actions(driver);

                                 util.WaitForElementVisible(dealPage.tabFunding);
                                 IWebElement tabFunding = driver.FindElement(dealPage.tabFunding);
                                 actions.MoveToElement(tabFunding).Perform();

                                 util.WaitForElementVisible(dealPage.btnGenerateFunding);
                                 IWebElement GenerateButton = driver.FindElement(dealPage.btnGenerateFunding);

                                 actions.MoveToElement(GenerateButton).Perform();

                                 System.Threading.Thread.Sleep(2000);
                                 GenerateButton.Click();
                                 System.Threading.Thread.Sleep(2000);

                                 try
                                 {
                                     WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
                                     wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(dealPage.successMessage));
                                     FFSuccessMessage = driver.FindElement(dealPage.successMessage);
                                     FFSuccessMessageVisible = FFSuccessMessage.Displayed;
                                     actualMessage = FFSuccessMessage.Text;
                                 }
                                 catch (Exception e)
                                 {
                                 }

                                 if (FFSuccessMessageVisible)
                                 {
                                     util.captureScreenshot(deallist[loop].CREDealID + "_Generate");
                                     String successMessage = "Funding schedule generated successfully.";
                                     if (actualMessage.Equals(successMessage))
                                     {
                                         _autoMationOutputData.GenerateMessage = actualMessage;

                                         if (BaseConfiguration.AllowSave())
                                         {
                                             _autoMationOutputData = saveDeal(_autoMationOutputData);
                                         }
                                     }
                                 }
                                 else
                                 {
                                     validationPopupVisible = driver.FindElement(dealPage.validationPopUp).Displayed;

                                     if (validationPopupVisible)
                                     {
                                         util.captureScreenshot(deallist[loop].CREDealID + "_Generate");
                                         IList<IWebElement> Validations = driver.FindElements(dealPage.validationMessages);
                                         numberOfValidations = Validations.Count;


                                         for (int j = 1; j <= numberOfValidations; j++)
                                         {
                                             String validation = driver.FindElement(By.XPath("//*[@id=\"dialogboxbody\"]/p[" + j + "]")).Text;

                                             //read property name dynamicly
                                             PropertyInfo _propertyInfo = _autoMationOutputData.GetType().GetProperty("Validation" + j);
                                             _propertyInfo.SetValue(_autoMationOutputData, validation, null);

                                         }
                                     }

                                 }
                             }
                             catch (Exception)
                             {
                                 //System.Diagnostics.Debug.WriteLine("<USE RULE N>");
                                 _autoMationOutputData.GenerateMessage = "<USE RULE N>";

                                 if (BaseConfiguration.AllowSave())
                                 {
                                     _autoMationOutputData = saveDeal(_autoMationOutputData);
                                 }
                             }
                             finally
                             {
                                 _autoMationOutputDatalst.Add(_autoMationOutputData);
                             }

                         }
                         catch (Exception e)
                         {
                             //System.Diagnostics.Debug.WriteLine(e);
                             System.Diagnostics.Debug.WriteLine("Deal not loaded properly. Funding tab is not visible.");
                         }

                     }  // For Loop Close

                     System.Diagnostics.Debug.WriteLine(_autoMationOutputDatalst);
                     test.Log(Status.Info, "Create Excel started");
                     GenerateExcelFile.CreateExcel(_autoMationOutputDatalst, "Result");

                     test.Log(Status.Info, "Create Excel Ended");
                     EndTime = DateTime.Now;

                     test.Log(Status.Pass, "Completed ");
                     System.Diagnostics.Debug.WriteLine("StartTime: " + StartTime);
                     System.Diagnostics.Debug.WriteLine("EndTime: " + EndTime);

                 }  // Close (If Login successful)
                 else
                 {
                     test.Log(Status.Info, "Login Failed ");
                     System.Diagnostics.Debug.WriteLine("Login Failed");
                 }

             } // Close GenerateFunding

             public AutoMationOutputData saveDeal(AutoMationOutputData _autoMationOutputData)
             {

                 Utility.Util util = new Utility.Util(driver);
                 Deal dealPage = new Deal(driver);
                 Deal FundingPage = new Deal(driver);

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
                     IWebElement saveDialogBoxOkButton = driver.FindElement(dealPage.saveDialogBoxOkButton);
                     if (savedialogmessage.Displayed)
                     {
                         saveDialogBoxOkButton.Click();
                     }
                 }
                 catch (Exception e)
                 {
                 }

                 bool dealSaveValidationPopup = driver.FindElement(dealPage.dealSaveValidationPopup).Displayed;
                 if (dealSaveValidationPopup)
                 {
                     IList<IWebElement> Validations = driver.FindElements(dealPage.ValidationsList);
                     int numberOfValidations = Validations.Count;

                     if (numberOfValidations != 0)
                     {
                         for (int j = 1; j <= numberOfValidations; j++)
                         {
                             // AutoMationOutputData _autoMationOutputData = new AutoMationOutputData();
                             String msgValidation = driver.FindElement(By.XPath("//*[@id=\"dialogboxbody\"]/p[" + j + "]")).Text;

                             //read property name dynamicly
                             PropertyInfo _propertyInfo = _autoMationOutputData.GetType().GetProperty("Validation" + j);
                             _propertyInfo.SetValue(_autoMationOutputData, msgValidation, null);

                             util.captureScreenshot(deallist[loop].CREDealID + "_Save");
                         }
                     }
                 }
                 else
                 {
                     try
                     {
                         WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(25));
                         wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(dealPage.successMessage));
                         String dealSaveSuccessActualMessage = driver.FindElement(dealPage.successMessage).Text;
                         _autoMationOutputData.SaveMessage = dealSaveSuccessActualMessage;

                         // Take screenshot
                         System.Threading.Thread.Sleep(1000);
                         util.captureScreenshot(deallist[loop].CREDealID + "_Save");
                     }
                     catch (Exception e)
                     {
                         _autoMationOutputData.SaveMessage = "Error in saving the deal";
                     }
                 }

                 return _autoMationOutputData;

             }  // Save Close
     */

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
                if (runForAllDeal.ToString().ToLower() == "yes")
                {
                    //TestAllDealForGenerateFunding                
                    deallist = autologic.GetAllDeal();
                }
                else
                {
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

                //set count for deal generate
                int cntDeal = deallist.Count();
                deallist = deallist.Skip(0).Take(cntDeal).ToList();
                if (deallist != null)
                {
                    test.Log(Status.Info, "Generate funding automation started for " + deallist.Count + " deals");
                }



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
                itemCnt += deallist1.Count();
                deallist2 = deallist.Skip(itemCnt).Take(cntDeal / browserCount).ToList();
                itemCnt += deallist2.Count();
                deallist3 = deallist.Skip(itemCnt).Take(cntDeal / browserCount).ToList();
                itemCnt += deallist3.Count();

                //last list assign all remaining deal
                deallist4 = deallist.Skip(itemCnt).Take(cntDeal - itemCnt).ToList();

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
                            SendEmail.MergeallFilesAndEmail(randomstring, Message, driver);   //Check Point
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
                    SendEmail.ValidationFile(FilePath, "", driver);  //Check Point
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
                                SendEmail.sendProgressEmail(deallist.Count, DealsProcessed, StartTime, driver); //Check Point
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
                            dealPage.clickTotalCommitment();
                            System.Threading.Thread.Sleep(3000);
                            dealPage.ClickFunding();
                            System.Threading.Thread.Sleep(1000);
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
                                        System.Threading.Thread.Sleep(5000);
                                        if (BaseConfiguration.AllowSave())
                                        {
                                            _autoMationOutputData = saveDeal(_autoMationOutputData, _lstDeal[loop].CREDealID, driver);
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
                                            // util.captureScreenshotMultiBrowser(_lstDeal[loop].CREDealID + "_UseRuleN", driver);
                                            //System.Threading.Thread.Sleep(2000);
                                            if (BaseConfiguration.AllowSave())
                                            {
                                                _autoMationOutputData = saveDeal(_autoMationOutputData, _lstDeal[loop].CREDealID, driver);
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
                                        WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(40));
                                        wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(dealPage.successMessage));
                                        FFSuccessMessage = driver.FindElement(dealPage.successMessage);
                                        FFSuccessMessageVisible = FFSuccessMessage.Displayed;
                                        actualMessage = FFSuccessMessage.Text;
                                    }
                                    catch (Exception e)
                                    {
                                        FFSuccessMessageVisible = false;
                                    }

                                    if (FFSuccessMessageVisible)
                                    {
                                        // util.captureScreenshotMultiBrowser(_lstDeal[loop].CREDealID + "_Generate", driver);
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

                                        System.Threading.Thread.Sleep(1000);
                                    }

                                    if (BaseConfiguration.AllowSave())
                                    {
                                        _autoMationOutputData = saveDeal(_autoMationOutputData, _lstDeal[loop].CREDealID, driver);
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





            public AutoMationOutputData saveDeal(AutoMationOutputData _autoMationOutputData, String CREDealID, IWebDriver driver)
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
                        // util.captureScreenshotMultiBrowser(CREDealID + "_Warning", driver);
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

                            // util.captureScreenshotMultiBrowser(CREDealID + "_Save", driver);
                        }
                    }
                }
                else
                {
                    try
                    {
                        WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(200));
                        wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(dealPage.successMessage));
                        String dealSaveSuccessActualMessage = driver.FindElement(dealPage.successMessage).Text;
                        _autoMationOutputData.SaveMessage = dealSaveSuccessActualMessage;

                        // Take screenshot
                        /*  System.Threading.Thread.Sleep(2000);
                          util.captureScreenshotMultiBrowser(CREDealID + "_Save", driver);
                          System.Threading.Thread.Sleep(1000); */
                    }
                    catch (Exception e)
                    {
                        _autoMationOutputData.SaveMessage = "Timeout/Error in saving the deal";
                        // Take screenshot
                        System.Threading.Thread.Sleep(2000);
                        //  util.captureScreenshotMultiBrowser(CREDealID + "_ErrorInSave", driver);
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
