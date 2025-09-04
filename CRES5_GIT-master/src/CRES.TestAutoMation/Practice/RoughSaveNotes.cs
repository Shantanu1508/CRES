using AventStack.ExtentReports;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.EmailTemplate;
using CRES.TestAutoMation.ExecutionReports;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using CRES.Utilities;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Support.UI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using CRES.TestAutoMation.TestCases;
using java.lang.management;
using System.Threading;
using OpenQA.Selenium.Support.Events;
using com.sun.tools.corba.se.idl;
using NPOI.HSSF.Record;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System.Data;
using System.IO;
using com.sun.org.glassfish.external.arc;
using Newtonsoft.Json;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Information;
using SeleniumExtras.WaitHelpers;
using Util = CRES.TestAutoMation.Utility.Util;

namespace CRES.TestAutoMation.Practice
{
    internal class RoughSaveNotes : BaseClass
    {
       
        int DealsProcessed = 0;
        readonly DateTime StartTime = DateTime.Now;
        String LogFile = "Logs-" + DateTime.Now;
        string BaseUrl = null;

        WebDriverWait wait;


        SelectElement select;

        static string indexReport = null;
        static string filePath = null;
        static IRow row;

        static String TimeStamp;
        static string time;
        static string env;
        static ISheet excelSheet;
        string AttributeValue;
        static string loggedInUserName;
        String noteSaveSuccessActualMessage;
        int SerNum; 
        Login login;
        Deal deal;
        Util util;

        /*public RoughSaveNotes() 
        {
            deal = new Deal(driver);
            util = new Util(driver);
            loggedInUserName = util.GetLoggedInUserName();
        }*/

        ExtentTest test = null;
        public void GetAllDeal()
        {

        }

        readonly string browser = BaseConfiguration.Browser();
        readonly string headless = BaseConfiguration.HeadlessDriver();
        //readonly string env = BaseConfiguration.GetEnvironment();
        readonly bool SendProgressEmail = BaseConfiguration.SendProgressEmail();
        readonly int SendProgressEmailDealCounter = BaseConfiguration.SendProgressEmailDealCounter();
        string ExcelNoteIDTab = BaseConfiguration.ExcelNoteIDTab();

        List<NoteDataContract> deallist = new List<NoteDataContract>();
        List<NoteSheet> noteSheet = new List<NoteSheet>();
        List<NoteDataContract> noteList = new List<NoteDataContract>();

        public void addtosheet(int srNo, string NoteID, string NoteName, string Status, string Exception)
        {
            NoteSheet Nt = new NoteSheet();
            Nt.SrNo = srNo;
            Nt.Note_ID = NoteID;
            Nt.Note_Name = NoteName;
            Nt.Status = Status;
            Nt.Exception = Exception;

            noteSheet.Add(Nt);
        }

        public static void CreateExcelDataTableNew(DataTable table, string FileName)
        {
            try
            {

                var memoryStream = new MemoryStream();
                string path = ProjectBaseConfiguration.ExcelReportsFolder;
                indexReport = ProjectBaseConfiguration.ExecutionReportFolder;

                Console.WriteLine("Path of the directory = " + path);
                if (Directory.Exists(path))
                {
                    DirectoryInfo di = Directory.CreateDirectory(path);

                    //time = LiabilityFunctionalTest.Timestamp();
                    TimeStamp = DateTime.Now.ToString("MM/dd/yyyy_HH:mm:ss");

                    filePath = path + FileName + ".xlsx";
                    IWorkbook workbook;
                    using (var fs = new FileStream(filePath, FileMode.Open, FileAccess.Read))
                    {
                        workbook = new XSSFWorkbook(fs);
                        fs.Close();
                    }

                    excelSheet = workbook.GetSheet("Note_Save_Summary") ?? workbook.CreateSheet("Note_Save_Summary");
                    Console.WriteLine("excelSheet = " + excelSheet);


                    //ISheet excelSheet01 = workbook.CreateSheet("Liability_Summary01");
                    List<String> columns = new List<string>();

                    IRow row = excelSheet.GetRow(7) ?? excelSheet.CreateRow(7);
                    Console.WriteLine("row = " + row);

                    // To delete old data from 7th row.
                    int RowIndex = 6;
                    while (excelSheet.GetRow(RowIndex) != null)
                    {
                        row = excelSheet.GetRow(RowIndex);
                        Console.Write("\nrowIndex =" + row.ToString());
                        excelSheet.RemoveRow(row);
                        Console.Write("\nrowIndex =" + row.ToString());

                        RowIndex++;
                    }
                    Console.WriteLine("\nrows deleted upto the row =" + RowIndex);

                    int columnIndex = 0;
                    foreach (System.Data.DataColumn column in table.Columns)
                    {
                        columns.Add(column.ColumnName);
                        //row.CreateCell(columnIndex).SetCellValue(column.ColumnName);
                        columnIndex++;
                    }

                    // To set system user name
                    excelSheet.GetRow(3).CreateCell(2).SetCellValue(loggedInUserName);
                    Console.WriteLine("row = " + excelSheet.GetRow(4));

                    // To set Date& Time in sheet.
                    excelSheet.GetRow(4).CreateCell(2).SetCellValue(TimeStamp);
                    Console.WriteLine("row = " + excelSheet.GetRow(4));
                    // To set Environment in the sheet.
                    excelSheet.GetRow(4).CreateCell(5).SetCellValue(env);
                    Console.WriteLine("row = " + excelSheet.GetRow(4));

                    //To update latest data from 7th row.
                    int rowIndex = 6;
                    foreach (DataRow dsrow in table.Rows)
                    {
                        row = excelSheet.CreateRow(rowIndex);
                        int cellIndex = 0;
                        foreach (String col in columns)
                        {
                            row.CreateCell(cellIndex).SetCellValue(dsrow[col].ToString());
                            cellIndex++;
                        }

                        rowIndex++;
                    }

                    using (var fs = new FileStream(filePath, FileMode.Create, FileAccess.Write))
                    {
                        workbook.Write(fs);
                        fs.Close();
                    }

                }
                else
                {
                    Console.WriteLine("Direcoty does not exist." + path);
                }
            }
            catch (Exception ex)
            {
                //TextLogger.Write("Error while creating Excel" + ex.Message.ToString(), "");
                Console.WriteLine("Excelsheet exception = " + ex);
            }

        }


        [Test]
        public void NoteSaveAutomation()
        {
            
            test = extent.CreateTest("Note Save Automation").Info("Test started");
            BrowserHelper helper = new BrowserHelper();
            helper.DeleteBrowserDriverInstances();

            string randomstring = DateTime.Now.ToString("MMddyyyyhhmmss");
            AutomationLogic autologic = new AutomationLogic();
            wait = new WebDriverWait(driver, TimeSpan.FromSeconds(15));
            string runForAllDeal = BaseConfiguration.TestAllDealForGenerateFunding();
            string sendValidationReportEmail = BaseConfiguration.SendValidationReportEmail();
            int browserCount = BaseConfiguration.BrowserCount();

            test.Log(Status.Info, "Note Save automation running in " + browserCount + "  browsers");
            test.Log(Status.Info, "Note Save automation running in " + env + "  environment");

            //AutomationLogic autologic = new AutomationLogic();
            if (runForAllDeal.ToString() == "All") //Run for  All Notes
            {
                Console.WriteLine("\n Automation is running for All the deals");
                //TestAllDealForGenerateFunding                
                deallist = autologic.GetAllNotes();
            }           
            else // Run for Deals in Excel
            {
                Console.WriteLine("\n Automation is running for Excel deals");
                var dataTable = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, "Note_List");
                if (dataTable != null)
                {

                    for (int i = 0; i < dataTable.Rows.Count; i++)
                    {
                        if (i > 0)
                        {
                            NoteDataContract ldc = new NoteDataContract();
                            ldc.CRENoteID = dataTable.Rows[i].ItemArray[0].ToString();
                            ldc.NoteId = dataTable.Rows[i].ItemArray[1].ToString();
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
                test.Log(Status.Info, "Note Save automation started for " + deallist.Count + " notes");
                Console.WriteLine("Note Save automation started for " + deallist.Count + " deals");
            }



            List<NoteDataContract> deallist1 = new List<NoteDataContract>();
            List<NoteDataContract> deallist2 = new List<NoteDataContract>();
            List<NoteDataContract> deallist3 = new List<NoteDataContract>();
            List<NoteDataContract> deallist4 = new List<NoteDataContract>();

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

                List<NoteDataContract> _lstDeal = new List<NoteDataContract>();

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
                        options.AddArgument("--disable-single-click-autofill");
                        options.AddArgument("--disable-popup-blocking");
                        options.AddUserProfilePreference("disable-popup-blocking", "true");
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
                        options.AddArgument("--disable-single-click-autofill");
                        options.AddArgument("--disable-popup-blocking");
                        options.AddUserProfilePreference("disable-popup-blocking", "true");
                        options.SetLoggingPreference(LogType.Browser, LogLevel.Warning);
                        _driver = new ChromeDriver(options);
                        ((IJavaScriptExecutor)_driver).ExecuteScript("document.body.style.zoom='90%';");
                        IJavaScriptExecutor js = (IJavaScriptExecutor)driver;
                        js.ExecuteScript("window.alert = function() {};");
                    }


                    System.Threading.Thread.Sleep(2000);
                    try
                    {
                        ToSaveNotes(_lstDeal, _driver, randomstring);

                    }
                    catch (Exception ex)
                    {
                        ///Console.WriteLine("NoteSaveAutomation Exception = " + ex);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (!string.IsNullOrEmpty("ToSaveNotes"))
                        {
                            printMessage += $"Message: <br>{"ToSaveNotes"}<br>";
                        }
                        test.Fail(printMessage);
                        //String Message = ex.ToString();
                        ExtentEnd();
                        if (sendValidationReportEmail.ToString().ToLower() == "yes")
                        {
                            Console.WriteLine("\nsend Merge all files mail");
                            // SendEmail.MergeallExcelFilesAndEmail(randomstring, Message, driver);  // Check Point 
                        }
                    }
                   
                }
            }
            );

            test.Log(Status.Pass, "Note Save Automation Completed Successfully");
            try
            {
                Util util = new Util(driver);
                loggedInUserName = util.GetLoggedInUserName();
                Console.WriteLine("\nloggedInUserName =" + loggedInUserName);
                test.Log(Status.Info, "Email sent with validation file attached.");
                test.Log(Status.Info, "Ran By: " + loggedInUserName);
                String FilePath = ExcelUtility.MergeAllFiles(randomstring);
                
                if (sendValidationReportEmail.ToString().ToLower() == "yes")
                {
                    Console.WriteLine("\nsend Excel validation file mail");
                    // SendEmail.ExcelValidationFile(FilePath, "", driver);               // Check Point
                }
                driver.Quit();      

                ExtentEnd();
            }
            catch (Exception e)
            {
                Console.WriteLine("\nNotesaveAutoation Exception01 = " + e.Message);
            }
            
        } // Close GenerateValidations

        public void ToSaveNotes(List<NoteDataContract> _lstDeal, IWebDriver driver, string randomstring)
        {
            Console.WriteLine("\nYou are in ToSaveNotes Method");
           
            Login login = new Login(driver);
            //deal = new Deal(driver);
            Util util = new Utility.Util(driver);
            Deal dealPage = new Deal(driver);
            Deal FundingPage = new Deal(driver);
            string weburl = BaseConfiguration.GetURL();
            //IWebElement AutospreadRepaymentButton;

            env = BaseConfiguration.GetEnvironment();

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
            string notefunding = BaseUrl + BaseConfiguration.NoteFunding();


            Thread.Sleep(2000);
            util.OpenUrl(LoginUrl);
            System.Threading.Thread.Sleep(2000);
            util.WaitForElementVisible(dealPage.loginBtn);
            // System.Threading.Thread.Sleep(5000);

           
            //login in web site
            if (login.LoginWebPageMultiBrowser(driver))
            {
                
                
                for (int loop = 0; loop < _lstDeal.Count; loop++)
                {

                    Console.WriteLine("\n NoteID = " + _lstDeal[loop].NoteId.ToString() + "\n NoteName = ");

                }



                for (int loop = 0; loop < _lstDeal.Count; loop++)
                {
                    try
                    {

                        Console.WriteLine("Loop count =" + loop + " count = " + _lstDeal.Count.ToString());


                        // Send a progress email after every SendProgressEmailDealCounter deals
                        if (SendProgressEmail)
                        {
                            DealsProcessed++;
                            int mod = DealsProcessed % SendProgressEmailDealCounter;
                            if (mod == 0)
                            {
                                //   SendEmail.sendProgressEmail(deallist.Count, DealsProcessed, StartTime, driver);  //check Point 
                            }
                        }

                        util.OpenUrlMultiBrowser(notefunding + _lstDeal[loop].NoteId.ToString(), driver);
                        //util.OpenUrlMultiBrowser(dashboard, driver);
                        //Console.WriteLine("\n CRENoteId = " + _lstDeal[loop].NoteName.ToString());
                        // Perform action on multi browser................................                                     
                        
                        Thread.Sleep(5000);

                        //SaveNote(loop, notefunding, _lstDeal[loop].NoteId, driver);
                        //saveDeal(loop, dashboard,_lstDeal[loop].NoteId, driver);
                        SaveNote(loop, dashboard, _lstDeal[loop].NoteId, driver);
                        
                        //addtosheet(SerNum, _lstDeal[loop].NoteId.ToString(), "****", SuccessMessage, "No Exception");
                        /*Thread.Sleep(3000);
                        IAlert simpleAlert = driver.SwitchTo().Alert();
                        String alertText = simpleAlert.Text;
                        Console.WriteLine("Alert text is " + alertText);
                        simpleAlert.Accept();*/
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("\n loop and SaveDeal Exception = "+ex.Message);
                    }
                    
                }  // For Loop Close

                //generate result excel file here.........................................
                SendMail();
                driver.Quit();
                
            }  // Close (If Login successful)
            else
            {
                System.Diagnostics.Debug.WriteLine("Login Failed");
                driver.Quit();
                
            }
            
        } // Close ToNoteSave


        public void saveDeal(int loop, String dashboard, String NoteId, IWebDriver driver)
        {
            try
            {
                Console.WriteLine("\n You are in DealSave method = ");
                Deal dealPage = new Deal(driver);
                Util util = new Utility.Util(driver);

                driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(10);
                //System.Diagnostics.Debug.WriteLine("Save");

                /*Thread.Sleep(5000);
                driver.FindElement(deal.searchBar).Click();
                driver.FindElement(deal.searchBar).SendKeys(NoteId);
                System.Threading.Thread.Sleep(5000);
                driver.FindElement(deal.DebtSearchedResult).Click();
                System.Threading.Thread.Sleep(15000);
            */
                driver.Navigate().Refresh();
                Thread.Sleep(5000);
                util.WaitForElementVisible(dealPage.DebtSave);
                IWebElement saveButton = driver.FindElement(dealPage.DebtSave);
                bool Display = saveButton.Displayed;
                Console.WriteLine("\nSave button display = " + Display + " for noteID =" + NoteId);
                if (Display)
                {

                    try
                    {
                        /*FFSuccessMessageVisible = false;
                        Console.WriteLine("Remaining Notes: " + (noteList.Count - loop));
                        util.OpenUrl(dashboard);
                        System.Threading.Thread.Sleep(4000);
                        util.OpenUrl(NoteFunding + noteList[loop].NoteId.ToString());
                        System.Threading.Thread.Sleep(15000);
                        util.WaitForPageLoad(driver);
                        IWebElement saveButton = driver.FindElement(By.Id("btnSave"));
                        saveButton.Click();
                        util.WaitForPageLoad(driver);
                        System.Threading.Thread.Sleep(10000);*/


                        System.Threading.Thread.Sleep(5000);
                        saveButton.Click();

                        //System.Threading.Thread.Sleep(2000);

                   
                        WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(200));
                       wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(dealPage.noteSaveSuccessMessage));
                        noteSaveSuccessActualMessage = driver.FindElement(dealPage.noteSaveSuccessMessage).Text;
                      
                        Console.WriteLine("\n Note Save success message = " + noteSaveSuccessActualMessage + "For Note Id" + NoteId);
                        addtosheet(00, NoteId, "****", noteSaveSuccessActualMessage, "No Exception");
                        Display = false;
                        Thread.Sleep(3000);
                        Console.WriteLine("Remaining Notes: " + (noteList.Count - loop));
                        //OpenUrl(dashboard);
                        //util.WaitForPageLoad(driver);
                        Thread.Sleep(10000);
                    }
                    catch (Exception Ex)
                    {

                        //Console.WriteLine("Success message exception = " + Ex.Message);
                        addtosheet(00, NoteId, "****", noteSaveSuccessActualMessage, Ex.Message);
                        //util.WaitForPageLoad(driver);
                        Thread.Sleep(10000);
                        // Take screenshot
                        System.Threading.Thread.Sleep(2000);
                        //  util.captureScreenshotMultiBrowser(CREDealID + "_ErrorInSave", driver);
                    }

                }
                else
                {
                    Console.WriteLine("\n Success message is note showing ");
                }
                

            }
            catch(Exception Ex)
            {
                Console.WriteLine("Save deal exception ="+Ex.Message);
            }
            
            
        }

        public void SaveNote(int loop, String notefunding, String NoteId, IWebDriver driver)
        {
            try
            {
                Deal dealPage = new Deal(driver);
                System.Threading.Thread.Sleep(4000);
                /*util.OpenUrl(notefunding + noteList[loop].NoteId.ToString());
                System.Threading.Thread.Sleep(15000);
                util.WaitForElementVisible(dealPage.DebtSave);
                IWebElement saveButton = driver.FindElement(dealPage.DebtSave);
                saveButton.Click();
                util.WaitForElementVisible(dealPage.DebtSave);
                Console.WriteLine("Sr. No. = " + loop + " Saved Noted = " + noteList[loop].NoteId.ToString());
                Console.WriteLine("\n Note Save success message = " + noteSaveSuccessActualMessage + "For Note Id" + NoteId);
                addtosheet(00, NoteId, "****", noteSaveSuccessActualMessage, "No Exception");
                System.Threading.Thread.Sleep(10000);*/




                //util.WaitForElementVisible(dealPage.DebtSave);
                IWebElement saveButton = driver.FindElement(dealPage.DebtSave);
                bool Display = saveButton.Displayed;
                saveButton.Click();
                Thread.Sleep(15000);
                Console.WriteLine("\nLoop = "+loop+" Save button display = " + Display + " for noteID =" + NoteId);
                addtosheet(00, NoteId, "****", "Note Displayed ", "No Exception");
                driver.Navigate().Refresh();
                try
                {
                    WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(10) /*timeout in seconds*/);
                }
                catch(Exception ex)
                { 
                    Console.WriteLine("\nAlert Exception ="+ex.Message);
                }
                if (wait.Until(ExpectedConditions.AlertIsPresent()) == null)
                {
                    Console.WriteLine("alert was not present");
                }
                else
                {
                    IAlert alert1 = driver.SwitchTo().Alert();
                    alert1.Accept();
                    Thread.Sleep(3000);
                    
                }
                if (wait.Until(ExpectedConditions.AlertIsPresent()) == null)
                {
                    Console.WriteLine("alert was not present");
                }
                else
                {
                    IAlert alert2 = driver.SwitchTo().Alert();
                    alert2.Accept();
                }

            }
            catch (Exception Ex)
            {
                Console.WriteLine("Save note exception =" + Ex.Message);
                addtosheet(00, NoteId, "****", noteSaveSuccessActualMessage, Ex.Message);
            }


        }

        public void SendMail()
        {
            try
            {


                Console.WriteLine("You are in SendMail method");
                RoughSaveNotes.CreateExcelDataTableNew((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(noteSheet), (typeof(DataTable))), "Note_Save_Report");
                Thread.Sleep(3000);

            }
            catch(Exception Ex)
            {
                Console.WriteLine("Excel shhet calling Exception = " + Ex.Message);
            }
            
            //............................. Email attachment ........................                  

            string sendValidationReportEmail = BaseConfiguration.SendValidationReportEmail();
            if (sendValidationReportEmail.ToString().ToLower() == "yes")
            {
                try
                {

                    loggedInUserName = util.GetLoggedInUserName();
                    test.Log(Status.Info, "Email sent with Liability report attached file.");
                    test.Log(Status.Info, "Ran By: " + loggedInUserName);                            // Email check point


                    if (sendValidationReportEmail.ToString().ToLower() == "yes")
                    {
                        Console.WriteLine("\nsend Merge all files mail");
                        EmailDataContract emailDC = new EmailDataContract();
                        emailDC.To = "shantanu@hvantage.com";
                        emailDC.Cc = "rsahu@hvantage.com,msingh@hvantage.com,ssingh@hvantage.com,vbalapure@hvantage.com,vandana@hvantage.com";
                        //optional
                        //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
                        //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
                        emailDC.ReceiverName = "All";
                        emailDC.FileAttachment = new List<FileAttachmentDataContract>();
                        emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = filePath });
                        Console.WriteLine("attached file = " + filePath);
                        emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = indexReport + "\\index.html" });
                        emailDC.Subject = "Liability Functional Flow Test Report";
                        emailDC.Body = "PFA the Liability Functional Flow Test Report.";
                        emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
                        emailDC.EmailSettings.Host = BaseConfiguration.Host;
                        emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
                        emailDC.EmailSettings.Password = BaseConfiguration.Password;
                        emailDC.EmailSettings.Port = BaseConfiguration.Port;
                        //
                        EmailAutomationLogic lg = new EmailAutomationLogic();

                        String response = lg.SendGenericEmail(emailDC);
                        System.Threading.Thread.Sleep(10000);  // Check Point 
                    }


                }
                catch (Exception ex)
                {
                    Console.WriteLine("\nSend report mail Exception =" + ex);

                }       //Email check point             // Check Point
                
          
            }
        }
        
    } // Close class

} // Close namespace