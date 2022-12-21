using AventStack.ExtentReports;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.EmailTemplate;
using CRES.TestAutoMation.ExecutionReports;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.TestCases;
using CRES.TestAutoMation.Utility;
using CRES.Utilities;
using Newtonsoft.Json;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Support.UI;
using RazorEngine.Compilation.ImpromptuInterface.Optimization;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;
using static CRES.TestAutoMation.BaseConfiguration;
using static CRES.TestAutoMation.Utility.ExcelUtility;
using Util = CRES.TestAutoMation.Utility.Util;

/*  Test Descrition:-
 *  1. Select the Environment.
 *  2. Login the M-61
    3. Select the required Scenario from Scenario details.
    4. Go to the Calculation Manager.
    5. Select 1st Note.
    6. Goto the Cashflow tab.
    7. Press Calc button for calculation.
    8. Wait untill Status is completed or failed.
    9. After getting status (Completed/Failed), it enter the data (NoteID, Calculation, Status)
       into Excel sheet.
    10.Repeat this process for 5 Notes.
    11.Generate Excel report in ExecutionReport| NoteCalculation|NoteCalculationReport.xlsx
    12. Generate the Html report.
    12.Send this reports to Team via GMail.
 */
namespace CRES.TestAutoMation.Practice
{

    public class Parallel_Notes_Calculation : BaseClass
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

        public Deal deal;
        readonly string browser = BaseConfiguration.Browser();
        readonly string headless = BaseConfiguration.HeadlessDriver();
        readonly string env = BaseConfiguration.GetEnvironment();
        readonly bool SendProgressEmail = BaseConfiguration.SendProgressEmail();
        readonly int SendProgressEmailDealCounter = BaseConfiguration.SendProgressEmailDealCounter();
        string ExcelNoteIDTab = BaseConfiguration.ExcelNoteIDTab();
        //List<DealDataContract> deallist = new List<DealDataContract>();
        List<DealDataContract> notelist = new List<DealDataContract>();
        List<AutoMationOutputData> _autoMationOutputDatalstResult = new List<AutoMationOutputData>();
        List<AutoMationOutputData> _autoMationOutputDatalst = new List<AutoMationOutputData>();
        AutoMationOutputData _autoMationOutputData = new AutoMationOutputData();
        WebDriverWait wait;
        Email SendEmail = new Email();
        IList<IWebElement> NotId_href;
        //........................................................................................................

        string FullStatus = " ";
        string CalcException = " ";
        List<string> NoteId = new List<string>();

        //...................................................................

       /* public static String Timestamp()
        {
            String timeStamp = Util.GetTimestamp(DateTime.Now);
            return timeStamp;
        }     */ 
        //............................Creating Excel Report.................................................        
        public static void CreateExcelDataTableNewForInput(DataTable table, string ExcelNoteIDTab)
        {
            try
            {
                var memoryStream = new MemoryStream();
                string path = ProjectBaseConfiguration.NotesInputFolder;

                if (!Directory.Exists(path))
                {
                    DirectoryInfo di = Directory.CreateDirectory(path);
                }
               // String time = NotesCalculation.Timestamp();
                //Console.WriteLine("Excel sheet creation Time =" + time);

                path = path + ExcelNoteIDTab + ".xlsx";
                using (var fs = new FileStream(path, FileMode.Create, FileAccess.Write))
                {
                    IWorkbook workbook = new XSSFWorkbook();
                    ISheet excelSheet = workbook.CreateSheet("Notes_Input_File");


                    List<String> columns = new List<string>();
                    IRow row = excelSheet.CreateRow(0);
                    int columnIndex = 0;

                    foreach (System.Data.DataColumn column in table.Columns)
                    {
                        columns.Add(column.ColumnName);
                        row.CreateCell(columnIndex).SetCellValue(column.ColumnName);
                        columnIndex++;
                    }
                    int rowIndex = 1;
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
                    workbook.Write(fs);
                }
            }
            catch (Exception ex)
            {
                TextLogger.Write("Error while creating Excel" + ex.Message.ToString(), "");
                throw ex;
            }
        }
        //.....................To create Note Calculation Excel Report ...............................
        public static void CreateExcelDataTableNew(DataTable table, string FileName)
        {
            try
            {
                var memoryStream = new MemoryStream();
                string path = ProjectBaseConfiguration.NoteCalculationReportFolder;

                if (!Directory.Exists(path))
                {
                    DirectoryInfo di = Directory.CreateDirectory(path);
                }
                //String time = NotesCalculation.Timestamp();
                //Console.WriteLine("Excel sheet creation Time =" + time);

                path = path + FileName + ".xlsx";
                using (var fs = new FileStream(path, FileMode.Create, FileAccess.Write))
                {
                    IWorkbook workbook = new XSSFWorkbook();
                    ISheet excelSheet = workbook.CreateSheet("Note_Calculation_Report");
                    List<String> columns = new List<string>();
                    IRow row = excelSheet.CreateRow(0);
                    int columnIndex = 0;


                    foreach (System.Data.DataColumn column in table.Columns)
                    {
                        columns.Add(column.ColumnName);
                        row.CreateCell(columnIndex).SetCellValue(column.ColumnName);
                        columnIndex++;
                    }

                    int rowIndex = 1;
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
                    workbook.Write(fs);
                }
            }
            catch (Exception ex)
            {
                TextLogger.Write("Error while creating Excel" + ex.Message.ToString(), "");
                throw ex;
            }
        }
        //.........................................................................................................

        List<NoteInputForCalculation> ListNoteCalculation = new List<NoteInputForCalculation>();

        public void addtolist(string noteId, string NoteHref)
        {
            NoteInputForCalculation Nc = new NoteInputForCalculation();
            Nc.Note_Id = noteId;
            Nc.Note_Href = NoteHref;
            //ListNoteCalculation.Add(Nc);
            ListNoteCalculation.Add(Nc);
        }
        //........................To add data(noteId, calculationStatus, fullStatus) to Excel............................................................

        List<NoteCalculation> NoteCalculationReport = new List<NoteCalculation>();

        public void addtolist2(string noteId, string calculationStatus, string fullStatus, string CalcException)
        {
            NoteCalculation Nc = new NoteCalculation();
            Nc.Note_Id = noteId;
            Nc.Calculation = calculationStatus;

            Nc.Status = fullStatus;
            Nc.Exception = CalcException;
            NoteCalculationReport.Add(Nc);
        }
        //..............................................................................................................
        public void scenarioSettings()
        {
            //...........................................Scenario Details.....................................................................//
            Util util = new Util(driver);
            String ScenarioUrl = BaseUrl + BaseConfiguration.ScenarioUrl();
            util.OpenUrl(ScenarioUrl);
            System.Threading.Thread.Sleep(8000);
            bool scenarioPage = false;
            try
            {
                Console.WriteLine("\nScenario Page Title =" + deal.ScenarioPageTitle());

                if (deal.ScenarioPageTitle() == "Scenarios")
                {
                    var printMessages = "<p><b>Scenarios for Calculation</b></p>";
                    test.Pass(printMessages);
                    Console.WriteLine("\nScenario page open Suceessfully");
                    test.Log(Status.Pass, "Scenario Page loaded sucessfully");

                    //     Perform function here
                    try
                    {
                        // To Select Default Scenario.
                        test.Log(Status.Pass, "Scenario for Calculation = " + driver.FindElement(deal.defaultScenario).Text);
                        System.Threading.Thread.Sleep(1000);
                        driver.FindElement(deal.defaultScenario).Click();
                        Console.WriteLine("\nDefault scenario selected");
                        Thread.Sleep(3000);

                        // To Select "Use Servicing Data" = Y / N
                        new SelectElement(driver.FindElement(deal.UseServicingData)).SelectByText("N");
                        test.Log(Status.Pass, "Use Servicing Data = " + (driver.FindElement(deal.UseServicingData).Text));
                        Thread.Sleep(3000);


                        //To select Calc Engine Type:-"C# (Existing)"/"V1 (New)"
                        new SelectElement(driver.FindElement(deal.CalcEngineType)).SelectByText("C# (Existing)");
                        test.Log(Status.Pass, "Calc Engine Type = " + (driver.FindElement(deal.CalcEngineType).Text));
                        Thread.Sleep(5000);

                        //To save Scenario
                        driver.FindElement(deal.saveButton).Click();
                        System.Threading.Thread.Sleep(1000);
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("\nDefasult scenario =" + e.Message);
                    }
                }
                else
                {
                    var printMessages = "<p><b> Scenario page load Failed</b></p>";
                    test.Fail(printMessages);
                    test.Log(Status.Fail, "Scenario page load Failed");
                }
            }
            catch (Exception ex)
            {
                scenarioPage = false;
                Console.WriteLine("\nScenario Page Exception = " + ex.Message);
                // throw ex;
            }
        }

        public void SeparateNoteCalculation(string NoteId)
        {
            Console.WriteLine("\nSeparateNoteCalculation is called");
            //driver = new ChromeDriver();
            Actions actions = new Actions(driver);
            Util util = new Util(driver);
            Deal dealPage = new Deal(driver);
            // ............................To Login M-61....................................
            try
            {
                System.Threading.Thread.Sleep(2000);
                util.WaitForElementVisible(deal.cashflowTab);
                Thread.Sleep(3000);
               // actions.MoveToElement(driver.FindElement(deal.cashflowTab));
                //actions.Click().Build().Perform();
               // Thread.Sleep(2000);
                driver.FindElement(deal.cashflowTab).Click();
                //driver.FindElement(deal.cashflowTab).Click();
                util.WaitForElementVisible(deal.calcButton);
                Thread.Sleep(3000);
               // actions.MoveToElement(driver.FindElement(deal.calcButton));
               // actions.Click().Build().Perform();
               // Thread.Sleep(10000);
                driver.FindElement(deal.calcButton).Click();
                Thread.Sleep(25000);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Calc Eception = " + ex.Message);
            }

            try { 
                //apply wait until status is completed
                string calculationStatus = driver.FindElement(deal.calculationStatus).Text;
                Console.WriteLine("\nCalculation Status = " + calculationStatus);
                if (calculationStatus == "Processing" || calculationStatus == "Running")
                {
                    Console.WriteLine("\nNote is Calculating");

                    WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromMinutes(10));
                    IWebElement SearchResult = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementExists(By.XPath("//span[@class='badge badge-success']")));
                    calculationStatus = driver.FindElement(deal.calculationStatus).Text;
                }

                // .............................Note Calculatio Completed.................................
                if (calculationStatus == "Completed")
                {
                    Console.WriteLine("\n" + NoteId + "th Note calculation is completed");
                    System.Threading.Thread.Sleep(10000);
                    try
                    {
                        string FullStatus = driver.FindElement(deal.calculationFullStatus).Text;
                        Console.WriteLine("\nCompleted Note's Full Status = " + FullStatus);
                        test.Log(Status.Pass, "Full Status = " + FullStatus);
                        addtolist2(NoteId, calculationStatus, FullStatus, "No Exception");
                        test.Log(Status.Pass, "Calculation has been Completed for Note = " + NoteId);
                        Console.WriteLine("\nCompleted status Logged");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("\n Excel Report Exception 1 =" + ex.Message);
                        addtolist2(NoteId, calculationStatus, FullStatus, CalcException);
                    }

                }
                // .............................Note Calculation Failed..............................
                else if (calculationStatus == "Failed")
                {
                    try
                    {
                       var printMessages = "<p><b>Test FAILED!</b></p>";
                        test.Fail(printMessages);
                        Console.WriteLine("\nCompleted status Log failed");
                        string FullStatus = driver.FindElement(deal.calculationFullStatus).Text;
                        Console.WriteLine("\nCompleted Note's Full Status = " + FullStatus);                       
                        test.Log(Status.Fail, "Calculation has been failed for Note = " + NoteId);
                        addtolist2(NoteId, calculationStatus, FullStatus, "");
                        Thread.Sleep(5000);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("\n Excel Report Exception 2 =" + ex.Message);
                    }
                }
                else
                    Console.WriteLine("\n calculationStatus is Failed");
            }
            catch (Exception e)
            {
                Console.WriteLine("\nException =" + e.Message);
            }
        }      
                   
            //........................................Mail Send with Excel Report............................................................
                    /*
            public voud MailSend()
            {
                      EmailDataContract emailDC = new EmailDataContract();
                       emailDC.To = "shantanu@hvantage.com,rsahu@hvantage.com,ssingh@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com,rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com";

                       //optional
                       //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
                       //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
                       emailDC.ReceiverName = "All";
                       emailDC.FileAttachment = new List<FileAttachmentDataContract>();
                       emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\NoteCalculation\\" + pathExcel });
                      // string path = ProjectBaseConfiguration.ExecutionReportFolder;
                      // emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });    //  No need
                       emailDC.Subject = "Notes Calculation test report";
                       emailDC.Body = "Please find an attachment of Notes calculation Report.";
                       emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
                       emailDC.EmailSettings.Host = BaseConfiguration.Host;
                       emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
                       emailDC.EmailSettings.Password = BaseConfiguration.Password;
                       emailDC.EmailSettings.Port = BaseConfiguration.Port;

                       EmailAutomationLogic lg = new EmailAutomationLogic();
                       string response = lg.SendGenericEmail(emailDC);
                       Console.WriteLine("Mail has been sent for Excel sheet");

                    /*

                       EmailDataContract emailDC = new EmailDataContract
                       {
                           To = "shantanu@hvantage.com",//,rsahu@hvantage.com,ssingh@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com";

                           ReceiverName = "All",
                           FileAttachment = new List<FileAttachmentDataContract>()
                       };
                       emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\NoteCalculation\\" + pathExcel });
                       //string path = ProjectBaseConfiguration.ExecutionReportFolder;
                       //emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });    //  No need
                       emailDC.Subject = "Notes Calculation test report";
                       emailDC.Body = "Please find an attachment of Notes calculation Report.";
                       emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
                       emailDC.EmailSettings.Host = BaseConfiguration.Host;
                       emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
                       emailDC.EmailSettings.Password = BaseConfiguration.Password;
                       emailDC.EmailSettings.Port = BaseConfiguration.Port;
                       EmailAutomationLogic lg = new EmailAutomationLogic();

                       String response = lg.SendGenericEmail(emailDC);
                       Console.WriteLine("Mail has been sent for excel sheet");
                                                                                       */
                    //........................................Mail Send with Html Report............................................................
                    /*
                      emailDC.To = "shantanu@hvantage.com,rsahu@hvantage.com,ssingh@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com";

                      emailDC.ReceiverName = "All";
                      emailDC.FileAttachment = new List<FileAttachmentDataContract>();
                      // emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\NoteCalculation\\" + pathExcel });
                      string path = ProjectBaseConfiguration.ExecutionReportFolder;
                      emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });    //  No need
                      emailDC.Subject = "Notes Calculation test report";
                      emailDC.Body = "Please find an attachment of Notes calculation Report.";
                      emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
                      emailDC.EmailSettings.Host = BaseConfiguration.Host;
                      emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
                      emailDC.EmailSettings.Password = BaseConfiguration.Password;
                      emailDC.EmailSettings.Port = BaseConfiguration.Port;

                      response = lg.SendGenericEmail(emailDC);
                      Console.WriteLine("Mail has been sent for html sheet");
               }                                                                            */
              
        //............................Excel Report creation.............................................
        public void ExcelsheetReport() 
        {
            //............................Calling Excel Report creation.............................................

            System.Threading.Thread.Sleep(3000);
            //string times = NotesCalculation.Timestamp();
            NotesCalculation.CreateExcelDataTableNew((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(NoteCalculationReport), (typeof(DataTable))), "NoteCalculationReport");
            System.Threading.Thread.Sleep(7000);

            // String FileName;
            String pathExcel = "NoteCalculationReport" + ".xlsx";
            Console.WriteLine("\nExcel report = " + pathExcel);
            System.Threading.Thread.Sleep(5000);

            //CreateExcelDataTableNew(pathExcel);                            
            string pathNew = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName;
            Console.WriteLine("\nPath of current directory " + pathNew);
        }               

        //................Note Calculation Method Block ....................................................................
        public void noteCalculation(List<DealDataContract> _lstDeal,string NoteID,List< string> Noteid_Href, IWebDriver driver)
        {
            Login login = new Login(driver);
            Utility.Util util = new Utility.Util(driver);
            Deal dealPage = new Deal(driver);
            Deal FundingPage = new Deal(driver);
            string weburl = BaseConfiguration.GetURL();
            
            Console.WriteLine("\nnote Calculation method is started");
            Console.WriteLine("\nNote Href = " + Noteid_Href);
            

            
            List<AutoMationOutputData> _autoMationOutputDatalst = new List<AutoMationOutputData>();


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

            driver.Navigate().GoToUrl(LoginUrl);
            Thread.Sleep(5000);

            //login in web site
            if (login.LoginWebPageMultiBrowser(driver))
            {
                Console.WriteLine("\nFor multibrowser, _lstDeal = " + _lstDeal.Count);
                for (int loop = 0; loop < _lstDeal.Count; loop++)
                {                    
                    Actions actions = new Actions(driver);

                    /*
                    // Send a progress email after every SendProgressEmailDealCounter deals
                    if (SendProgressEmail)
                    {
                        DealsProcessed++;
                        int mod = DealsProcessed % SendProgressEmailDealCounter;
                        if (mod == 0)
                        {
                            //SendEmail.sendProgressEmail(notelist.Count, DealsProcessed, StartTime, driver);
                        }
                    }

                    */
                    AutoMationOutputData _autoMationOutputData = new AutoMationOutputData();
                    Thread.Sleep(5000);
                    Console.WriteLine("\n Noteid_Href[loop], = " + _lstDeal[loop].NoteId.ToString());
                    driver.Navigate().Refresh();
                    Thread.Sleep(5000);
                    util.OpenUrlMultiBrowser(_lstDeal[loop].NoteId.ToString(), driver);
                    //_autoMationOutputData.CREID = _lstDeal[loop].CREDealID;
                    // _autoMationOutputData.Name = _lstDeal[loop].DealName;
                                     

                     try
                     {                            
                            Thread.Sleep(10000);
                            util.WaitForElementVisible(deal.cashflowTab);
                            Thread.Sleep(3000);
                           /* actions.MoveToElement(driver.FindElement(deal.cashflowTab));
                            actions.Click().Build().Perform();
                            Thread.Sleep(2000); */
                            driver.FindElement(deal.cashflowTab).Click();
                            //driver.FindElement(deal.cashflowTab).Click();
                            util.WaitForElementVisible(deal.calcButton);
                            Thread.Sleep(3000);
                          /*  actions.MoveToElement(driver.FindElement(deal.calcButton));
                            actions.Click().Build().Perform();
                            Thread.Sleep(10000); */
                            driver.FindElement(deal.calcButton).Click();
                            Thread.Sleep(25000);
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine("Calc Eception = " + ex.Message);
                        }

                        try
                        {
                            //apply wait until status is completed
                            string calculationStatus = driver.FindElement(deal.calculationStatus).Text;
                            Console.WriteLine("\nCalculation Status = " + calculationStatus);
                            if (calculationStatus == "Processing" || calculationStatus == "Running")
                            {
                                Console.WriteLine("\nNote is Calculating");

                                WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromMinutes(10));
                                IWebElement SearchResult = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementExists(By.XPath("//span[@class='badge badge-success']")));
                                calculationStatus = driver.FindElement(deal.calculationStatus).Text;
                            }

                            // .............................Note Calculatio Completed.................................
                            if (calculationStatus == "Completed")
                            {
                                Console.WriteLine("\n" + NoteID + "th Note calculation is completed");
                                System.Threading.Thread.Sleep(10000);
                                try
                                {
                                    string FullStatus = driver.FindElement(deal.calculationFullStatus).Text;
                                    Console.WriteLine("\nCompleted Note's Full Status = " + FullStatus);
                                    test.Log(Status.Pass, "Full Status = " + FullStatus);
                                    addtolist2(NoteID, calculationStatus, FullStatus, "No Exception");
                                    test.Log(Status.Pass, "Calculation has been Completed for Note = " + NoteId);
                                    Console.WriteLine("\nCompleted status Logged");
                                }
                                catch (Exception ex)
                                {
                                    Console.WriteLine("\n Excel Report Exception 3 =" + ex.Message);
                                    addtolist2(NoteID, calculationStatus, FullStatus, CalcException);
                                }

                            }

                            // .............................Note Calculation Failed..............................
                            else if (calculationStatus == "Failed")
                            {
                                try
                                {
                                    var printMessages = "<p><b>Test FAILED!</b></p>";
                                    test.Fail(printMessages);
                                    Console.WriteLine("\nCompleted status Log failed");
                                    string FullStatus = driver.FindElement(deal.calculationFullStatus).Text;
                                    Console.WriteLine("\nCompleted Note's Full Status = " + FullStatus);
                                    test.Log(Status.Fail, "Calculation has been failed for Note = " + NoteID);
                                    addtolist2(NoteID, calculationStatus, FullStatus, "");
                                    Thread.Sleep(5000);
                                }
                                catch (Exception ex)
                                {
                                    Console.WriteLine("\nCalculation has been failed =" + ex.Message);
                                }
                            }
                            else
                                Console.WriteLine("\n calculationStatus is Failed");                         
                    }
                     catch (Exception e)
                     {
                         //System.Diagnostics.Debug.WriteLine(e);
                         _autoMationOutputData.GenerateMessage = "Timeout or error in loading the deal.";
                     }                                                                                      
                }  // For Loop Close
                //.....................................Note Calculation Excel report................................
                    Console.WriteLine("\nExcel report calling");
                    ExcelsheetReport();                
                    driver.Quit();  
                
            }  // Close (If Login successful)
            else
            {
                System.Diagnostics.Debug.WriteLine("Login Failed");
                driver.Quit();
            }   
           
        } // Close GenerateFunding

        //...................................................................................................................
            [Test]
            public void GenerateValidations()
            {

            //.......................................To save Note ID and Note Href .......................................

            //driver = new ChromeDriver();
            Actions actions = new Actions(driver);

            CRES_Login loginapp = new CRES_Login();
            Login login = new Login(driver);
            deal = new Deal(driver);
            // CreateNewDeal createDeal = new CreateNewDeal(driver);
            Util util = new Util(driver);
            //string dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
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

            // ............................To Login M-61....................................
            try
            {
                System.Threading.Thread.Sleep(10000);

                if (loginValidation)
                {
                    test = extent.CreateTest("Note Calculation verification ").Info("<p><b>Calculation Test Started</b></p>");
                    
                    test.Log(Status.Pass, "Login Page loaded sucessfully");

                
                    //................................To open Calculation Manager...................................
                    try
                    {
                        String calculationManagerUrl = BaseUrl + BaseConfiguration.CalculationManagerUrl();
                        util.OpenUrl(calculationManagerUrl);
                        System.Threading.Thread.Sleep(5000);

                       string CalculationManagerTitle = driver.FindElement(deal.scenarioPage).Text;
                       Console.WriteLine("\nCalculation Manager Title Page =" + CalculationManagerTitle);
                        List<string> Noteid_Href = new List<string>();
                       
                        if (CalculationManagerTitle == "Calculation Manager")
                        {
                            Console.WriteLine("\nCalculation Manager Page loded successfully");
                            var printMessages = "<p><b> Calculation Manager</b></p>";
                            test.Pass(printMessages);
                            test.Log(Status.Pass, "Calculation Manager Page loaded sucessfully");

                            //To store all notes in List
                            Thread.Sleep(5000);
                           // IList<IWebElement> CalcCheckBoxes = driver.FindElements(deal.CalcCheckBox);

                            // To store all visible note id of calculation manager grid
                            string href = "/#/notedetail/";
                            IList<IWebElement> NoteIdElem = driver.FindElements(By.CssSelector("a[href*='" + href + "']"));
                            Console.WriteLine("\nNoteid Count =" + NoteIdElem.Count);
                            
                            try
                            {  
                                
                                Thread.Sleep(10000);
                                NoteIdElem = driver.FindElements(By.CssSelector("a[href*='" + href + "']"));

                                Console.WriteLine("\nNotElements count = " + NoteIdElem.Count);
                             
                                DealDataContract ldc = new DealDataContract();
                          
                                    for (int i = 0; i < NoteIdElem.Count - 1; i++)
                                    {                              
                                            
                                            NoteId.Insert(i,NoteIdElem[i].Text);
                                            Console.WriteLine("\nSelected Note for Calculation = " + NoteId[i]);

                                            NotId_href = driver.FindElements(By.XPath("//div[contains(@class,'wj-cell')]/div/div/div/div/a"));
                                            Noteid_Href.Insert(i, NotId_href[i].GetAttribute("href"));
                                            Console.WriteLine("Note Href = " + Noteid_Href[i]);
                                            ldc.NoteHref = Noteid_Href[i];
                                            //ldc.NoteHref = dataTable.Rows[i].ItemArray[1].ToString();
                                            addtolist(NoteId[i], Noteid_Href[i]);                                        

                                    }

                                System.Threading.Thread.Sleep(3000);
                                //string times = NotesCalculation.Timestamp();
                                Parallel_Notes_Calculation.CreateExcelDataTableNewForInput((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(ListNoteCalculation), (typeof(DataTable))), "InputNoteIds");
                                System.Threading.Thread.Sleep(7000);

                                // String FileName;
                                String pathExcel = "InputNoteIds" + ".xlsx";
                                Console.WriteLine("\nExcel report = " + pathExcel);
                                System.Threading.Thread.Sleep(5000);
                            }

                            catch (Exception ex)
                            {
                                Console.WriteLine("\n Excel Report Exception 5=" + ex.Message);

                            }
                            //driver.Navigate().Back();
                            Thread.Sleep(10000);
                        }

                        //............................................................................................................
                        test = extent.CreateTest("Note Calculation Validation").Info("Test started");
                        BrowserHelper helper = new BrowserHelper();
                        helper.DeleteChromeDriverInstances();
                        
                        //string randomstring = DateTime.Now.ToString("MMddyyyyhhmmss");
                        AutomationLogic autologic = new AutomationLogic();
                        wait = new WebDriverWait(driver, TimeSpan.FromSeconds(15));
                        string runForAllDeal = BaseConfiguration.TestAllDealForGenerateFunding();
                        int browserCount = BaseConfiguration.BrowserCount();

                        test.Log(Status.Info, "Note Calculation automation running in " + browserCount + "  browsers");
                        test.Log(Status.Info, "Note Calculation automation running in " + env + "  environment");

                        //AutomationLogic autologic = new AutomationLogic();
                        if (runForAllDeal.ToString().ToLower() == "yes")
                        {
                            //TestAllDealForGenerateFunding                
                            notelist = autologic.GetAllDeal();
                        }
                        else
                        {
                            //var dataTable1 = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, "Deal_List");
                            //Console.WriteLine("dataTable1 =" + dataTable1.ToString());
                            var dataTable = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.InputNoteIdsFileXlsx, ExcelNoteIDTab);
                            Console.WriteLine("dataTable =" + dataTable.ToString());
                          if (dataTable != null)
                            {

                                for (int i = 0; i < dataTable.Rows.Count; i++)
                                {
                                    if (i > 0)
                                    {
                                        Console.WriteLine("\nNote table input line no. 617");
                                        DealDataContract ldc = new DealDataContract();
                                        ldc.NoteHref = dataTable.Rows[i].ItemArray[0].ToString();
                                        ldc.NoteId = dataTable.Rows[i].ItemArray[1].ToString();
                                        notelist.Add(ldc);
                                    }
                                }

                            }                            
                        }
                        
                        //set count for deal generate
                        int cntNote = notelist.Count();
                        Console.WriteLine("notelist count = " + cntNote);
                        notelist = notelist.Skip(0).Take(cntNote).ToList();
                        if (notelist != null)
                        {
                            test.Log(Status.Info, "Note Calculation automation started for " + notelist.Count + " Notes");
                        }
                        List<DealDataContract> deallist1 = new List<DealDataContract>();
                        List<DealDataContract> deallist2 = new List<DealDataContract>();
                        List<DealDataContract> deallist3 = new List<DealDataContract>();
                        List<DealDataContract> deallist4 = new List<DealDataContract>();

                        int itemCnt = 0;
                        deallist1 = notelist.Skip(itemCnt).Take(cntNote / browserCount).ToList();
                        Console.WriteLine("\ndeallist1 = " + deallist1);
                        itemCnt += deallist1.Count();
                        deallist2 = notelist.Skip(itemCnt).Take(cntNote / browserCount).ToList();
                        Console.WriteLine("\ndeallist2 = " + deallist2);
                        itemCnt += deallist2.Count();
                        deallist3 = notelist.Skip(itemCnt).Take(cntNote / browserCount).ToList();
                        Console.WriteLine("\ndeallist3 = " + deallist3);
                        itemCnt += deallist3.Count();

                        //last list assign all remaining deal
                        deallist4 = notelist.Skip(itemCnt).Take(cntNote - itemCnt).ToList();
                        Console.WriteLine("\ndeallist4 = " + deallist4);

                        List<int> integerList = Enumerable.Range(0, 5).ToList();
                        var poptions = new ParallelOptions()
                        {
                            MaxDegreeOfParallelism = browserCount
                        };
                        try
                        {
                            
                            Parallel.ForEach(integerList, poptions, i =>
                            {
                                Console.WriteLine(@"value of new i = {0}", i);

                                List<DealDataContract> _lstDeal = new List<DealDataContract>();

                                if (i == 0)
                                {
                                    _lstDeal = deallist1;
                                    Console.WriteLine("\n_lstDeal 1=" + _lstDeal);
                                }
                                else if (i == 1)
                                {
                                    _lstDeal = deallist2;
                                    Console.WriteLine("\n_lstDeal 2=" + _lstDeal);
                                }
                                else if (i == 2)
                                {
                                    _lstDeal = deallist3;
                                    Console.WriteLine("\n_lstDeal 3=" + _lstDeal);
                                }
                                else if (i == 3)
                                {
                                    _lstDeal = deallist4;
                                    Console.WriteLine("\n_lstDeal 4=" + _lstDeal);
                                }
                                Console.WriteLine("\n_lstDeal = " + _lstDeal.Count);
                                Console.WriteLine("\nnotelist.Count() =" + notelist.Count);
                                //if (_lstDeal.Count() > 0)
                                    if (notelist.Count > 0)
                                    {
                                    IWebDriver driver = null;
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
                                        driver = new ChromeDriver(ChromeDriverService.CreateDefaultService(), options, TimeSpan.FromMinutes(3));                                        
                                        options.AddArgument("no-sandbox");
                                        driver.Manage().Timeouts().PageLoad.Add(System.TimeSpan.FromSeconds(30));
                                        ((IJavaScriptExecutor)driver).ExecuteScript("document.body.style.zoom='90%';");
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
                                       driver = new ChromeDriver(ChromeDriverService.CreateDefaultService(), options, TimeSpan.FromMinutes(3));                                        
                                        options.AddArgument("no-sandbox");
                                        driver.Manage().Timeouts().PageLoad.Add(System.TimeSpan.FromSeconds(30));
                                        ((IJavaScriptExecutor)driver).ExecuteScript("document.body.style.zoom='90%';");

                                    }

                                    //.....................Note Calculation method calling......................................
                                    System.Threading.Thread.Sleep(2000);
                                    try
                                    {
                                        Console.WriteLine("\n note Calculation method is calling =" + NoteId[i]+"\n" +Noteid_Href[i]);
                                        noteCalculation(_lstDeal, NoteId[i], Noteid_Href, driver);                                        
                                        Console.WriteLine("\nnoteCalculation method is called");
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
                                        // SendEmail.MergeallFilesAndEmail(randomstring, Message, driver);
                                    }
                                }
                            }
                            );
                        }
                        catch (Exception ex)
                        {
                            Console.Write("Method calling Exception =" + ex.ToString());
                        }
                        test.Log(Status.Pass, "Deal Funding Generated Successfully");
                        try
                        {
                            util = new Utility.Util(driver);
                            string loggedInUserName = util.GetLoggedInUserName();
                            test.Log(Status.Info, "Email sent with validation file attached.");
                            test.Log(Status.Info, "Ran By: " + loggedInUserName);
                            String FilePath = ExcelUtilityForNote.MergeAllFiles();
                           // SendEmail.ValidationFile(FilePath, "", driver);
                            driver.Quit();
                            ExtentEnd();
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine(e.Message);
                        }

                        // Close GenerateValidations                


                        // Save Close

                        /* [Test]
                         public void SendEMail1()
                         {
                              SendEmail.TestEmail();
                          }
                        */

                    } // Close class
                    catch (Exception e)
                    {
                        Console.WriteLine(e.Message);
                    }

                } // Close namespace
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }
    }
}
