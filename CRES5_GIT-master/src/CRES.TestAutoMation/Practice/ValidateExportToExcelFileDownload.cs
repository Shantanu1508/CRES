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
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;

namespace CRES.TestAutoMation.Practice
{
    public class ValidateExportToExcelFileDownload : BaseClass
    {
  
            string currentFile = string.Empty;
            static string name = string.Empty;
            static string DealName = string.Empty;
            bool result = false;
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
            List<ExcelAutoMationOutputData> _autoMationOutputDatalstResult = new List<ExcelAutoMationOutputData>();
            List<ExcelAutoMationOutputData> _autoMationOutputDatalst = new List<ExcelAutoMationOutputData>();
            ExcelAutoMationOutputData _autoMationOutputData = new ExcelAutoMationOutputData();
            WebDriverWait wait;
            Email SendEmail = new Email();

            [Test]
            public void GenerateValidations()
            {
                test = extent.CreateTest("Export to excel verification").Info("Test started");
                BrowserHelper helper = new BrowserHelper();
            helper.DeleteBrowserDriverInstances();

                string randomstring = DateTime.Now.ToString("MMddyyyyhhmmss");
                AutomationLogic autologic = new AutomationLogic();
                wait = new WebDriverWait(driver, TimeSpan.FromSeconds(15));
                string runForAllDeal = BaseConfiguration.TestAllDealForGenerateFunding();
                int browserCount = BaseConfiguration.BrowserCount();

                test.Log(Status.Info, "Export to excel automation running in " + browserCount + "  browsers");
                test.Log(Status.Info, "Export to excel automation running in " + env + "  environment");

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
                    test.Log(Status.Info, "Export to excel automation started for " + deallist.Count + " deals");
                }



                List<DealDataContract> deallist1 = new List<DealDataContract>();
                List<DealDataContract> deallist2 = new List<DealDataContract>();
                List<DealDataContract> deallist3 = new List<DealDataContract>();
                List<DealDataContract> deallist4 = new List<DealDataContract>();


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
                            //options.AddArguments("--incognito");
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
                            ExportToExcel(_lstDeal, _driver, randomstring);     //ExportToExcel Call
                        }
                        catch (Exception ex)
                        {
                            var printMessage = "<p><b>Test FAILED!</b></p>";
                            if (!string.IsNullOrEmpty("Export to excel"))
                            {
                                printMessage += $"Message: <br>{"Export to excel"}<br>";
                            }
                            test.Fail(printMessage);
                            String Message = ex.ToString();
                            ExtentEnd();

                            // SendEmail.MergeallExcelFilesAndEmail(randomstring, Message, driver);  // Check Point 
                        }
                    }
                }
                );

                test.Log(Status.Pass, "Export to excel downloaded Successfully");
                try
                {
                    Utility.Util util = new Utility.Util(driver);
                    string loggedInUserName = util.GetLoggedInUserName();
                    test.Log(Status.Info, "Email sent with Export to excel report file attached.");
                    test.Log(Status.Info, "Ran By: " + loggedInUserName);
                    String FilePath = ExcelUtility.MergeAllExportToExcelFiles(randomstring);

                    // SendEmail.ExcelValidationFile(FilePath, "", driver);               // Check Point

                    driver.Quit();
                    ExtentEnd();
                }
                catch (Exception e)
                {
                }

        } // Close ExportToExcelValidations

        //ExportToExcel Logic

        public void ExportToExcel(List<DealDataContract> _lstDeal, IWebDriver driver, string randomstring)
        {


                List<ExcelAutoMationOutputData> _autoMationOutputDatalst = new List<ExcelAutoMationOutputData>();

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

                        Actions actions = new Actions(driver);

                        // Send a progress email after every SendProgressEmailDealCounter deals
                        if (SendProgressEmail)
                        {
                            DealsProcessed++;
                            int mod = DealsProcessed % SendProgressEmailDealCounter;
                            if (mod == 0)
                            {
                                //SendEmail.sendProgressEmail(deallist.Count, DealsProcessed, StartTime, driver);  //check Point 
                            }
                        }

                        ExcelAutoMationOutputData _autoMationOutputData = new ExcelAutoMationOutputData();

                        util.OpenUrlMultiBrowser(dealfunding + _lstDeal[loop].CREDealID.ToString(), driver);

                        _autoMationOutputData.CREID = _lstDeal[loop].CREDealID;
                        _autoMationOutputData.Name = _lstDeal[loop].DealName;

                        System.Threading.Thread.Sleep(3000);
                        dealPage.CheckDealPageLoaded();
                        Thread.Sleep(3000);

                        try
                        {

                            //..............................Start....................................

                            try
                            {
                                //.................................Open File link and dowload the file................................
                                driver.FindElement(dealPage.mainTab).Click();
                                Thread.Sleep(4000);

                                string dealName = driver.FindElement(dealPage.dealName).GetAttribute("value");

                                //string dealName = driver.FindElement(dealPage.DealHeading).Text;
                                Console.WriteLine("\nDeal Name = " + dealName);
                                Thread.Sleep(2000);

                                driver.FindElement(dealPage.Commitment_EquityTab).Click();
                                Thread.Sleep(4000);

                                driver.FindElement(dealPage.CommitmentExportToExcel).Click();
                                Thread.Sleep(3000);

                                driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(10);                                              //

                                name = dealName + "_Commitment.xlsx"; //we store the zip filename in a variable 
                                                                      //wait for sometime till download is completed


                                //...................................................................................................


                                string path = @"C:\Users\ShantanuSharma\Downloads";//the path of the folder where the zip file will be downloaded

                                if (Directory.Exists(path)) //we check if the directory or folder exists
                                {
                                    bool result = CheckFile(name); // boolean result true or false is stored after checking the zip file name

                                    if (result)
                                    {
                                        _autoMationOutputData.CommitmentDownloadPassStatus = "Download Pass: - File "+ name + " is exist in folder.";

                                        System.Threading.Thread.Sleep(4000);

                                        //ExtractFiles();// if the Excel file is present , this method is called to extract files within the zip file
                                        Console.WriteLine("\nFile is exist in folder =" + name);
                                    }
                                    else
                                    {
                                    _autoMationOutputData.DownloadFailedStatus = "Download Failed: - The file "+ name + " does not exist in the folder.";
                                    Assert.Fail();
                                    }

                                    Thread.Sleep(4000);

                                }
                                else
                                {
                                    _autoMationOutputData.FolderNotExist = "Directory does not exist.";

                                    Thread.Sleep(4000);
                                    Assert.Fail("Login failed.");// if the Excel file is not present, then the  test fails
                                }                                                              

                                if (_autoMationOutputDatalst.Count >= 10)
                                {
                                    Random _random1 = new Random();
                                    string strPost1 = _random1.Next().ToString();
                                    GenerateExcelFile.CreateExcelDataTable(ObjToDataTable.ConvertToDataTable(_autoMationOutputDatalst), "Result_" + randomstring);
                                    _autoMationOutputDatalst.Clear();
                                }

                            }
                            catch (Exception e)
                            {
                            _autoMationOutputData.Exception = e.ToString();
                            Console.WriteLine("Download Exception = " + e);
                            }

                        _autoMationOutputDatalst.Add(_autoMationOutputData);

                    }
                        catch (Exception ex)
                        {
                            Console.WriteLine("\n Login Exception");
                        }

                        //System.Threading.Thread.Sleep(1000);

                    }

                    // For Loop Close

                    System.Diagnostics.Debug.WriteLine(_autoMationOutputDatalst);

                    Random _random = new Random();
                    string strPost = _random.Next().ToString();
                    GenerateExcelFile.CreateExcelDataTable(ObjToDataTable.ConvertToDataTable(_autoMationOutputDatalst), "Result_" + randomstring);
                    //GenerateExcelFile.CreateExcel(_autoMationOutputDatalst, "Result" + strPost);
                    driver.Quit();
                }  // Close (If Login successful)


                // Close GenerateFunding

            }


            //.....................................Download Methods...................................

            public bool CheckFile(string name) // the name of the excel file which is obtained, is passed in this method
            {
                currentFile = @"C:\Users\ShantanuSharma\Downloads\" + name + ""; // the zip filename is stored in a variable
                if (System.IO.File.Exists(currentFile)) //helps to check if the excel file is present
                {
                    return true; //if the zip file exists return boolean true
                }
                else
                {
                    _autoMationOutputData.DownloadFailedStatus = "The file does not exist = " + name;
                    Console.WriteLine("\nThe file does not exist in folder =" + currentFile);

                    return false; // if the zip file does not exist return boolean false
                }
            }

            /*public void VerifyFiles(string newExtractFolder)
            {
                string[] fileEntries = Directory.GetFiles(newExtractFolder);// we obtain and store files within the "Extract" folder in an array 
                List<string> listItemsName = new List<string>();//we create a list of string which will store these  files individually    // Change
                //string listItemsName = "";
                for (int i = 0; i < fileEntries.Length; i++)  //Change
                {
                    string[] split = fileEntries[i].Split('\\');
                    listItemsName.Add(split.Last());
                }
                List<string> originalList = new List<string> {DealName+"_Commitment.xlsx" };// the files which we expect to be  present //Change

                result = originalList.Count == listItemsName.Count && originalList.All(listItemsName.Contains);
                //compare two lists if they have the same number of items and 
                //check that all items are same, by using contains we ensure that both lists have same items, 
                //irrespective of the order(ascending or descending) of items within the lists
                if (result == true)
                {
                    Console.WriteLine("The expected files are present.");
                    DeleteFilesAndDirectory();//delete the test data
                    Assert.Pass("The expected files are present.");
                }
                else
                {
                    Console.WriteLine("The expected files are not present.");
                    DeleteFilesAndDirectory();//delete the test data
                    Assert.Fail("The expected files are not present.");
                }
            }


            public void DeleteFilesAndDirectory()
            {
                if (Directory.Exists(@"C:\Users\ShantanuSharma\Downloads\Extract"))
                {
                    Directory.Delete(@"C:\Users\ShantanuSharma\Downloads\Extract", true);//cleanup created folder which has any content inside it.
                    //true ensures that folder is deleted even if it is not empty. 
                }
                if (File.Exists(currentFile))
                {
                    File.Delete(currentFile); //delete the downloaded zip file
                }
            } */
            // Save Close

            /* [Test]
             public void SendEMail1()
             {
                  SendEmail.TestEmail();
              }
            */

        } // Close class
    }
    // Close namespace




// Close namespace


/*Thread.Sleep(3000);
sourceDir = @"C:\Users\ShantanuSharma\Downloads\" + name;//the path of the folder where the excel file will be downloaded
Thread.Sleep(3000);

Console.WriteLine("\nsourceDir =" + sourceDir);

destDir = @"C:\Users\ShantanuSharma\ExportToExcel\" + name;
Thread.Sleep(3000);

Console.WriteLine("\ndestDir =" + destDir);

try
{
    Directory.Move(sourceDir, destDir);
    if (Directory.Exists(destDir))
    {
        Console.WriteLine("{0} is moved successfully to {1}", sourceDir, destDir);
    }
}
catch (Exception e)
{
    Console.WriteLine(e.Message);
}*/



//...................................................................................................
