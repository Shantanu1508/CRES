using AventStack.ExtentReports;
using OpenQA.Selenium;
using System;
using System.Collections.Generic;
using System.Text;
using CRES.TestAutoMation.Utility;
using CRES.DataContract;
using NUnit.Framework;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Interactions;
using CRES.TestAutoMation.TestCases;
using CRES.TestAutoMation.Pages;
using System.Threading;
using OpenQA.Selenium.Support.UI;
using System.Data;
using System.IO;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using Newtonsoft.Json;
using static CRES.TestAutoMation.BaseConfiguration;
using AngleSharp.Dom;
using NoteCalculation = CRES.TestAutoMation.BaseConfiguration.NoteCalculation;
using System.Linq;
using System.Threading.Tasks;
using CRES.BusinessLogic;
using CRES.TestAutoMation.EmailTemplate;
using Microsoft.Office.Interop.Excel;
using Actions = OpenQA.Selenium.Interactions.Actions;
using DataTable = System.Data.DataTable;

namespace CRES.TestAutoMation.Practice


    // 1. parallelNoteCalculation
    // 2.
  
{
    internal class SaveNotesToExcelFromCM : BaseClass
    {
         
        Deal deal;
        
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

        List<DealDataContract> notelist = new List<DealDataContract>();
        List<AutoMationOutputData> _autoMationOutputDatalstResult = new List<AutoMationOutputData>();
        List<AutoMationOutputData> _autoMationOutputDatalst = new List<AutoMationOutputData>();
        AutoMationOutputData _autoMationOutputData = new AutoMationOutputData();
        WebDriverWait wait;
        Email SendEmail = new Email();

        public ExtentTest test = null;
        public static String Timestamp()
        {
            String timeStamp = Util.GetTimestamp(DateTime.Now);
            return timeStamp;
        }

        List<PageLoadTest> listPageLoad = new List<PageLoadTest>();

        IList<IWebElement> NoteIdElem;
        List<IWebElement> NoteIdsList;
        //.....................................Note Calculation Block.......................................
        /*     
         public void NoteCalculationValidation(List<DealDataContract> _lstNote, IWebDriver driver, string randomstring)
         {            
            // Past Note Calculation Blco here

         }   */
        //.....................To create Note Input Excel Report ...............................
        public static void NotesExcelDataTableNew(DataTable table, string FileName)
        {
            try
            {
                var memoryStream = new MemoryStream();
                string path = ProjectBaseConfiguration.NotesInputFolder;
                Console.WriteLine("Folder created = " + Directory.Exists(path));
                if (!Directory.Exists(path))
                {
                    DirectoryInfo di = Directory.CreateDirectory(path);
                }
                String time = SaveNotesToExcelFromCM.Timestamp();
                Console.WriteLine("Excel sheet creation Time =" + time);

                path = path + FileName + "_" + ".xlsx";
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


        List<NoteIds> ListNotIds = new List<NoteIds>();
        public void AddNotesToList(string noteId)
        {
            NoteIds NId = new NoteIds();
            NId.Note_Id = noteId;
            ListNotIds.Add(NId);
            
        } 

       
        public void NotesTransferToExcle()
        {
            Console.WriteLine("\nCalculation Manager Page loded successfully");
            var printMessages = "<p><b> Calculation Manager</b></p>";
            // test.Pass(printMessages);
            //test.Log(Status.Pass, "Calculation Manager Page loaded sucessfully");

            // To store all visible note id of calculation manager grid
            string href = "/#/notedetail/";
            NoteIdElem = driver.FindElements(By.CssSelector("a[href*='" + href + "']"));
            Console.WriteLine("\nNoteid Count =" + NoteIdElem.Count);
            NoteIdsList = new List<IWebElement>();
            for (int i = 0; i < 10; i = i + 2)
            {
                try
                {
                    //driver.Navigate().Refresh();
                    Thread.Sleep(10000);
                    NoteIdsList[i]  = (IWebElement)(NoteIdElem = driver.FindElements(By.CssSelector("a[href*='" + href + "']")));


                    string NoteId = NoteIdsList[i].Text;
                    Console.WriteLine("\nSelected Note for Calculation = " + NoteId);
                    printMessages = "<p><b> Note for Calculation = " + NoteId + " </b></p>";
                    // test.Pass(printMessages);

                    AddNotesToList(NoteId);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("\n Excel Report Exception =" + ex.Message);
                }
            }

            // To creat Folder
            //CreateExcelDataTableNew(pathExcel);                            
            string pathNew = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName;
            Console.WriteLine("\nPath of current directory " + pathNew);

            System.Threading.Thread.Sleep(3000);
            string times = SaveNotesToExcelFromCM.Timestamp();
            SaveNotesToExcelFromCM.NotesExcelDataTableNew((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(ListNotIds), (typeof(DataTable))), "InputNoteIds");
            System.Threading.Thread.Sleep(7000);

            // String FileName;
            String pathExcel = "NoteCalculationReport" + times+".xlsx";
            Console.WriteLine("\nExcel report = " + pathExcel);
            System.Threading.Thread.Sleep(5000);


        }

        [Test]
        public void parallelNotesCalculation()
        {
            test = extent.CreateTest("Parallel Notes Calculation Verification").Info("Test started");
            BrowserHelper helper = new BrowserHelper();
            helper.DeleteChromeDriverInstances();

            string randomstring = DateTime.Now.ToString("MMddyyyyhhmmss");
            AutomationLogic autologic = new AutomationLogic();
            wait = new WebDriverWait(driver, TimeSpan.FromSeconds(15));
          
            int browserCount = BaseConfiguration.BrowserCount();

            test.Log(Status.Info, "Notes Calculation automation running in " + browserCount + "  browsers");
            //test.Log(Status.Info, "Notes Calculation automation running in " + env + "  environment");

          
           
            var notedataTable = InputHelper.GetDataTableFromExcel(BaseConfiguration.InputNoteIdsFile, "Notes_Input_File");
            Console.WriteLine("notedataTable =" + notedataTable);
                if (notedataTable != null)
                {

                    for (int i = 0; i < notedataTable.Rows.Count; i++)
                    {
                        if (i > 0)
                        {
                            DealDataContract ldc = new DealDataContract();
                            Console.WriteLine("notedataTable.Rows.Count = " + notedataTable.Rows.Count);
                            ldc.NoteId = notedataTable.Rows[i].ItemArray[0].ToString();
                            Console.WriteLine("NoteDataTable Note ID count =" + ldc.NoteId);
                            notelist.Add(ldc);
                        }
                    }

                }
            //............................Note Calculation Block.......................................

            Console.WriteLine("\nNote Calculation Method Started");
            driver = new ChromeDriver();
            Actions actions = new Actions(driver);

            CRES_Login loginapp = new CRES_Login();
            Login login = new Login(driver);
            deal = new Deal(driver);
            // CreateNewDeal createDeal = new CreateNewDeal(driver);
            Util util = new Util(driver);
            string dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
            // string username = BaseConfiguration.getusername();
            //string password = BaseConfiguration.getpassword();
            //string LoginUrl = BaseConfiguration.LoginUrl();

            string subLoginUrl;
            string BaseUrl = null;
            string env = BaseConfiguration.GetEnvironment();

            BaseUrl = env switch
            {
                "QA" => BaseConfiguration.GetQAUrl(),
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

            try
            {

                System.Threading.Thread.Sleep(10000);

                if (loginValidation)
                {
                    // test = extent.CreateTest("General verification ").Info("Test started");
                    String DealUrl = BaseUrl + "#/dealdetail/FDD8EC03-9D63-4512-9990-89C508983EDC";
                    util.OpenUrl(DealUrl);

                    //...........................................Starting Block.....................................................................//

                    // test = extent.CreateTest("Note Calculation verification ").Info("<p><b>Calculation Test Started</b></p>");
                    DealUrl = BaseUrl + "#/dealdetail/FDD8EC03-9D63-4512-9990-89C508983EDC";
                    util.OpenUrl(DealUrl);
                    // test.Log(Status.Pass, "Login Page loaded sucessfully");


                    //................................To open Calculation Manager...................................
                    try
                    {
                        String calculationManagerUrl = BaseUrl + BaseConfiguration.CalculationManagerUrl();
                        util.OpenUrl(calculationManagerUrl);
                        System.Threading.Thread.Sleep(5000);

                        string CalculationManagerTitle = driver.FindElement(deal.scenarioPage).Text;
                        Console.WriteLine("\nCalculation Manager Title Page =" + CalculationManagerTitle);

                        if (CalculationManagerTitle == "Calculation Manager")
                        {
                            Console.WriteLine("\nCalculation Manager Page loded successfully");
                            var printMessages = "<p><b> Calculation Manager</b></p>";
                            //  test.Pass(printMessages);
                            // test.Log(Status.Pass, "Calculation Manager Page loaded sucessfully");

                            //To store all notes in List
                            Thread.Sleep(5000);
                            IList<IWebElement> CalcCheckBoxes = driver.FindElements(deal.CalcCheckBox);

                            // To store all visible note id of calculation manager grid
                            string href = "/#/notedetail/";
                            IList<IWebElement> NoteIdElem = driver.FindElements(By.CssSelector("a[href*='" + href + "']"));
                            Console.WriteLine("\nNoteid Count =" + NoteIdElem.Count);

                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Calculation Manager Exception =" + ex.Message);
                    }
                    //...........................................Ending Block.....................................................................//

                    this.NotesTransferToExcle();                    
                }

            }
            catch (Exception ex)
            {
                Console.Write("Final Exception =" + ex.ToString());
            }

            //...........................................................................................

            //set count for Note Calculation      

            int cntNote = NoteIdsList.Count();
            NoteIdsList = NoteIdsList.Skip(0).Take(cntNote).ToList();//notelist
            if (NoteIdElem != null)//
            {
                test.Log(Status.Info, "Notes Calculation automation started for " + NoteIdElem.Count + " deals");
            }


            /*
            List<DealDataContract> notelist1 = new List<DealDataContract>();
            List<DealDataContract> notelist2 = new List<DealDataContract>();
            List<DealDataContract> notelist3 = new List<DealDataContract>();
            List<DealDataContract> notelist4 = new List<DealDataContract>();
            */

            List<IWebElement> notelist1 = new List<IWebElement>();
            List<IWebElement> notelist2 = new List<IWebElement>();
            List<IWebElement> notelist3 = new List<IWebElement>();
            List<IWebElement> notelist4 = new List<IWebElement>();

            // for (int i = 1; i == browserCount; i++)
            // {
            //     List<DealDataContract> deallist+i + = new List<DealDataContract>();
            // }

            int itemCnt = 0;
            //notelist1 = notelist.Skip(itemCnt).Take(cntNote / browserCount).ToList();
            notelist1  =  NoteIdsList.Skip(itemCnt).Take(cntNote / browserCount).ToList();
            Console.WriteLine("\nnotelist1 = "+NoteIdsList.Skip(itemCnt).Take(cntNote / browserCount).ToList());
            itemCnt += notelist1.Count();
            Console.WriteLine("Note cuont = "+itemCnt+ "\n notelist1 = "+ notelist1.Count);
            notelist2 = NoteIdsList.Skip(itemCnt).Take(cntNote / browserCount).ToList();
            itemCnt += notelist2.Count();
            Console.WriteLine("Note cuont = " + itemCnt + "\n notelist2 = " + notelist2.Count);
            notelist3 = NoteIdsList.Skip(itemCnt).Take(cntNote / browserCount).ToList();
            itemCnt += notelist3.Count();
            Console.WriteLine("Note cuont = " + itemCnt + "\n notelist3 = " + notelist3.Count);

            //last list assign all remaining deal
            notelist4 = NoteIdsList.Skip(itemCnt).Take(cntNote - itemCnt).ToList();
            Console.WriteLine("Note cuont = " + itemCnt + "\n notelist4 = " + notelist4.Count);
            List<int> integerList = Enumerable.Range(0, 5).ToList();
            var poptions = new ParallelOptions()
            {
                MaxDegreeOfParallelism = browserCount
            };

            Parallel.ForEach(integerList, poptions, i =>
            {
                Console.WriteLine(@"value of new i = {0}", i);

                // List<DealDataContract> _lstNote = new List<DealDataContract>();
                List<IWebElement> _lstNote = new List<IWebElement>();

                if (i == 0)
                {
                    _lstNote =  notelist1;
                }
                else if (i == 1)
                {
                    _lstNote = notelist2;
                }
                else if (i == 2)
                {
                    _lstNote = notelist3;
                }
                else if (i == 3)
                {
                    _lstNote = notelist4;
                }

                if (_lstNote.Count() > 0)
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
                        driver = new ChromeDriver(options);
                        ((IJavaScriptExecutor) driver).ExecuteScript("document.body.style.zoom='90%';");
                    }
                    else if (browser == "Edge")                   {

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
                        driver = new ChromeDriver(options);
                        ((IJavaScriptExecutor)driver).ExecuteScript("document.body.style.zoom='90%';");

                    }

                    System.Threading.Thread.Sleep(2000);
                    try
                    {
                        Console.WriteLine("\nNote Calculation Method Called");
                        
                       // NoteCalculationValidation(_lstNote, _driver, randomstring);
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
    }
}
