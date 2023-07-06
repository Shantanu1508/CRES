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
    internal class Old_Parallel_Notes_Calculation : BaseClass
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
            string Noteid_Href;
            //List<DealDataContract> deallist = new List<DealDataContract>();
            List<DealDataContract> notelist = new List<DealDataContract>();
            List<AutoMationOutputData> _autoMationOutputDatalstResult = new List<AutoMationOutputData>();
            List<AutoMationOutputData> _autoMationOutputDatalst = new List<AutoMationOutputData>();
            AutoMationOutputData _autoMationOutputData = new AutoMationOutputData();
            WebDriverWait wait;
            Email SendEmail = new Email();
            List<string> Href = new List<string>();
            IList<IWebElement> NotId_href;
            List<NoteInputForCalculation> ListNoteCalculation = new List<NoteInputForCalculation>();

            public void addtolist(string noteId, string NoteHref)
            {
                NoteInputForCalculation Nc = new NoteInputForCalculation();
                Nc.Note_Id = noteId;
                Nc.Note_Href = NoteHref;
                //ListNoteCalculation.Add(Nc);
                ListNoteCalculation.Add(Nc);
            }

            //............................Creating Excel Report.................................................
            //ProjectBaseConfiguration.DataDrivenFileXlsx, ExcelNoteIDTab

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
                    String time = NotesCalculation.Timestamp();
                    Console.WriteLine("Excel sheet creation Time =" + time);

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
            //................Note Calculation Method Block ....................................................................

            public void noteCalculation(List<DealDataContract> _lstDeal, string Noteid_Href, IWebDriver driver, string randomstring)
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



                //login in web site
                if (login.LoginWebPageMultiBrowser(driver))
                {
                    Console.WriteLine("\nFor multibrowser, _lstDeal = " + _lstDeal.Count);
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
                                //SendEmail.sendProgressEmail(notelist.Count, DealsProcessed, StartTime, driver);
                            }
                        }

                        AutoMationOutputData _autoMationOutputData = new AutoMationOutputData();
                        Console.WriteLine("\n_lstDeal[loop].CREDealID.ToString() = " + _lstDeal[loop].CREDealID.ToString());
                        util.OpenUrlMultiBrowser(Noteid_Href, driver);

                        _autoMationOutputData.CREID = _lstDeal[loop].CREDealID;
                        _autoMationOutputData.Name = _lstDeal[loop].DealName;

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
                                            //  _autoMationOutputData = saveDeal(_autoMationOutputData, _lstDeal[loop].CREDealID, driver);
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
                                                // _autoMationOutputData = saveDeal(_autoMationOutputData, _lstDeal[loop].CREDealID, driver);
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
                                        // _autoMationOutputData = saveDeal(_autoMationOutputData, _lstDeal[loop].CREDealID, driver);
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

            //...................................................................................................................
            [Test]
            public void GenerateValidations()
            {

                //.......................................To save Note ID and Note Href .......................................

                driver = new ChromeDriver();
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


                                //string Noteid_Href = driver.FindElement(By.XPath("//div[contains(@class,'wj-cell')]/div/div/div/div/a")).GetAttribute("href");
                                //Console.WriteLine("\nNote Id href = " + Noteid_href);
                                //To select specific notes for calculation


                                try
                                {
                                    //driver.Navigate().Refresh();
                                    Thread.Sleep(10000);
                                    NoteIdElem = driver.FindElements(By.CssSelector("a[href*='" + href + "']"));


                                    //printMessages = "<p><b> Note for Calculation = " + NoteId + " </b></p>"; 
                                    //test.Pass(printMessages);
                                    Console.WriteLine("\nNotElements count = " + NoteIdElem.Count);
                                    //var dataTable1 = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, "Deal_List");
                                    //Console.WriteLine("\nExcel sheet path dataTable1 = " + dataTable1.ToString());
                                    var dataTable = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.InputNoteIdsFileXlsx, ExcelNoteIDTab);
                                    Console.WriteLine("\nExcel sheet path dataTable = " + dataTable.ToString());
                                    DealDataContract ldc = new DealDataContract();

                                    if (dataTable != null)
                                    {

                                        for (int i = 0; i < NoteIdElem.Count - 1; i++)
                                        {


                                            string NoteId = NoteIdElem[i].Text;
                                            Console.WriteLine("\nSelected Note for Calculation = " + NoteId);

                                            NotId_href = driver.FindElements(By.XPath("//div[contains(@class,'wj-cell')]/div/div/div/div/a"));
                                            Noteid_Href = NotId_href[i].GetAttribute("href");
                                            Href[i] = NotId_href[i].GetAttribute("href");
                                            Console.WriteLine("\nNote Id href for " + i + "st Note = " + Noteid_Href);
                                            Console.WriteLine("\n Href = " + Href[i]);
                                            addtolist(NoteId, Noteid_Href);

                                            /*   ldc.NoteId = dataTable.Rows[i].ItemArray[0].ToString();
                                               Console.WriteLine("Note Id = " + ldc.NoteId);
                                               ldc.NoteHref = dataTable.Rows[i].ItemArray[1].ToString();
                                               Console.WriteLine("Note Href = " + ldc.NoteHref);
                                               notelist.Add(ldc); */

                                        }
                                        System.Threading.Thread.Sleep(3000);
                                        string times = NotesCalculation.Timestamp();
                                        Parallel_Notes_Calculation.CreateExcelDataTableNewForInput((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(ListNoteCalculation), (typeof(DataTable))), "InputNoteIds");
                                        System.Threading.Thread.Sleep(7000);

                                        // String FileName;
                                        String pathExcel = "InputNoteIds" + ".xlsx";
                                        Console.WriteLine("\nExcel report = " + pathExcel);
                                        System.Threading.Thread.Sleep(5000);

                                        //CreateExcelDataTableNew(pathExcel);                            
                                        // string pathNew = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName;
                                        //used for email purpose ------- string pathNew = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.Parent.FullName;
                                        // Console.WriteLine("\nPath of current directory " + pathNew);

                                    }
                                }

                                catch (Exception ex)
                                {
                                    Console.WriteLine("\n Excel Report Exception =" + ex.Message);

                                }
                                //driver.Navigate().Back();
                                Thread.Sleep(10000);

                            }

                            //............................................................................................................
                            test = extent.CreateTest("Note Calculation Validation").Info("Test started");
                            BrowserHelper helper = new BrowserHelper();
                            helper.DeleteChromeDriverInstances();

                            string randomstring = DateTime.Now.ToString("MMddyyyyhhmmss");
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
                                var dataTable1 = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, "Deal_List");
                                Console.WriteLine("dataTable1 =" + dataTable1.ToString());
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

                            // for (int i = 1; i == browserCount; i++)
                            // {
                            //     List<DealDataContract> deallist+i + = new List<DealDataContract>();
                            //}

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

                                        //.....................Note Calculation method calling......................................
                                        System.Threading.Thread.Sleep(2000);
                                        try
                                        {
                                            Console.WriteLine("\nnoteCalculation method is calling =" + _lstDeal);
                                            Console.WriteLine("\n Note Href = " + Noteid_Href);
                                            noteCalculation(_lstDeal, Noteid_Href, _driver, randomstring);

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
                                String FilePath = ExcelUtility.MergeAllFiles(randomstring);
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



