using AventStack.ExtentReports;
using com.sun.org.apache.xalan.@internal.xsltc.runtime;
using com.sun.org.apache.xml.@internal.resolver.helpers;
using com.sun.xml.@internal.rngom.parse.host;
using CRES.BusinessLogic;
using CRES.DataContract;
//using CRES.DataContract;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using DocumentFormat.OpenXml.Presentation;
using DocumentFormat.OpenXml.Spreadsheet;
using java.util;
using Microsoft.Office.Interop.Excel;
using Microsoft.VisualStudio.TestPlatform.CoreUtilities.Extensions;
using Newtonsoft.Json;
using NPOI.SS.UserModel;
using NPOI.SS.Util;
using NPOI.XSSF.UserModel;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Firefox;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Support.UI;
using sun.awt;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Runtime.InteropServices;
using System.Threading;
using static CRES.TestAutoMation.BaseConfiguration;
using Actions = OpenQA.Selenium.Interactions.Actions;
using DataTable = System.Data.DataTable;
using Hashtable = System.Collections.Hashtable;
using List = java.util.List;
using NoteCalculation = CRES.TestAutoMation.BaseConfiguration.NoteCalculation;
using x1 = Microsoft.Office.Interop.Excel;

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
namespace CRES.TestAutoMation.TestCases
{

    public class NotesCalculation : BaseClass
    {
        public Deal deal;
        ExtentTest test = null;
        string FullStatus = " ";
        string CalcException = " ";




        //...................................................................

        public static string Timestamp()
        {
            string timeStamp = Util.GetTimestamp(DateTime.Now);
            return timeStamp;
        }
        // ....................New Excel Sheet .......................................................




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
                string time = Timestamp();
                Console.WriteLine("Excel sheet creation Time =" + time);

                path = path + FileName + "_" + time + ".xlsx";
                using (var fs = new FileStream(path, FileMode.Create, FileAccess.Write))
                {
                    IWorkbook workbook = new XSSFWorkbook();
                    ISheet excelSheet = workbook.CreateSheet("Note_Calculation_Report");


                    List<string> columns = new List<string>();
                    IRow row = excelSheet.CreateRow(0);
                    int columnIndex = 0;


                    foreach (DataColumn column in table.Columns)
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
                        foreach (string col in columns)
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

        //........................To add data(noteId, calculationStatus, fullStatus) to Excel............................................................

        List<NoteCalculation> ListNoteCalculation = new List<NoteCalculation>();

        public void addtolist(string noteId, string calculationStatus, string fullStatus, string CalcException)
        {
            NoteCalculation Nc = new NoteCalculation();
            Nc.Note_Id = noteId;
            Nc.Calculation = calculationStatus;

            Nc.Status = fullStatus;
            Nc.Exception = CalcException;
            ListNoteCalculation.Add(Nc);
        }
        //..............................................................................................................

        [Test]
        public void NoteCalculation()
        {
            driver = new ChromeDriver();
            Actions actions = new Actions(driver);

            Login_Verification loginapp = new Login_Verification();
            Login login = new Login(driver);
            deal = new Deal(driver);
            // CreateNewDeal createDeal = new CreateNewDeal(driver);
            Util util = new Util(driver);
            string dealfunding = GetURL() + DealFunding();
            string subLoginUrl;
            string BaseUrl = null;
            string env = GetEnvironment();

            BaseUrl = env switch
            {
                "QA" => GetQAUrl(),
                "Ng" => GetNgUrl(),
                "Integration" => GetIntUrl(),
                "Staging" => GetStagingUrl(),
                "Acore" => AcoreUrl(),
                "Dev" => GetDevUrl(),
                _ => GetQAUrl(),
            };

            subLoginUrl = GetLoginUrlNew();

            string LoginUrl = BaseUrl + subLoginUrl;
            util.OpenUrl(LoginUrl);

            bool loginValidation = login.LoginWebPage();

            // ............................To Login M-61....................................
            try
            {
                Thread.Sleep(10000);

                if (loginValidation)
                {
                    test = extent.CreateTest("Note Calculation verification ").Info("<p><b>Calculation Test Started</b></p>");
                    string DealUrl = BaseUrl + "#/dealdetail/FDD8EC03-9D63-4512-9990-89C508983EDC";
                    util.OpenUrl(DealUrl);
                    test.Log(Status.Pass, "Login Page loaded sucessfully");

                    //...........................................Scenario Details.....................................................................//

                    string ScenarioUrl = BaseUrl + BaseConfiguration.ScenarioUrl();
                    util.OpenUrl(ScenarioUrl);
                    Thread.Sleep(8000);
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
                                Thread.Sleep(1000);
                                driver.FindElement(deal.defaultScenario).Click();
                                Console.WriteLine("\nDefault scenario selected");
                                Thread.Sleep(3000);

                                // To Select "Use Servicing Data" = Y / N
                                new SelectElement(driver.FindElement(deal.UseServicingData)).SelectByText("N");
                                test.Log(Status.Pass, "Use Servicing Data = " + driver.FindElement(deal.UseServicingData).Text);
                                Thread.Sleep(3000);


                                //To select Calc Engine Type:-"C# (Existing)"/"V1 (New)"
                                new SelectElement(driver.FindElement(deal.CalcEngineType)).SelectByText("C# (Existing)");
                                test.Log(Status.Pass, "Calc Engine Type = " + driver.FindElement(deal.CalcEngineType).Text);
                                Thread.Sleep(5000);

                                //To save Scenario
                                driver.FindElement(deal.saveButton).Click();
                                Thread.Sleep(1000);
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

                    //................................To open Calculation Manager...................................
                    try
                    {
                        string calculationManagerUrl = BaseUrl + IntCalculationManagerUrl();
                        util.OpenUrl(calculationManagerUrl);
                        Thread.Sleep(5000);

                        string CalculationManagerTitle = driver.FindElement(deal.scenarioPage).Text;
                        Console.WriteLine("\nCalculation Manager Title Page =" + CalculationManagerTitle);
                        List<string> NoteId = new List<string>();

                        if (CalculationManagerTitle == "Calculation Manager")
                        {
                            Console.WriteLine("\nCalculation Manager Page loded successfully");
                            var printMessages = "<p><b> Calculation Manager</b></p>";
                            test.Pass(printMessages);
                            test.Log(Status.Pass, "Calculation Manager Page loaded sucessfully");

                            //To store all notes in List
                            Thread.Sleep(5000);
                            IList<IWebElement> CalcCheckBoxes = driver.FindElements(deal.CalcCheckBox);

                            // To store all visible note id of calculation manager grid
                            driver.Navigate().Refresh();
                            Thread.Sleep(20000);
                            string href = "/#/notedetail/";
                            IList<IWebElement> NoteIdElem = driver.FindElements(By.CssSelector("a[href*='" + href + "']"));
                            // IList<IWebElement> NoteIdElem = driver.FindElements(By.XPath("(//input[contains(@Class, 'wj-cell-check')])"));
                            Console.WriteLine("\nNoteIdElem =" + NoteIdElem[0].Text);
                            // NoteId.Insert(0, NoteIdElem[0].Text);

                            // Console.WriteLine("\nNoteId at =" + NoteId[0]);
                            //IList <IWebElement>NotId_href = driver.FindElements(By.XPath("//div[contains(@class,'wj-cell')]/div/div/div/div/a")); -- for Ng
                            Console.WriteLine("\nNoteid Count =" + NoteIdElem.Count);
                            IList<IWebElement> NotId_href = driver.FindElements(By.XPath("//div[contains(@class,'wj-cell')]/div/div"));
                            //string Noteid_href = driver.FindElement(By.XPath("//div[contains(@class,'wj-cell')]/div/div/div/div/a")).GetAttribute("href");
                            string Noteid_href = driver.FindElement(By.XPath("(//div[contains(@class,'wj-cell')]/div/div/a)[2]")).GetAttribute("href");
                            Console.WriteLine("\nNote Id href = " + Noteid_href);
                            //To select specific notes for calculation

                            //for (int i = 0; i < 10; i = i + 2)   // i<10
                            for (int i = 0; i < NoteIdElem.Count - 1; i = i + 2)
                            {
                                string Noteid = "";
                                try
                                {
                                    Console.WriteLine("\n i = " + i);
                                    // driver.Navigate().Refresh();
                                    //  Thread.Sleep(10000);
                                    // NoteIdElem = driver.FindElements(By.CssSelector("a[href*='" + href + "']"));
                                    //  NoteIdElem = driver.FindElements(By.CssSelector("a[href*='" + href + "']"));
                                    Console.WriteLine("\nSelected Note for Calculation = " + NoteIdElem[i].Text);
                                    Noteid = NoteIdElem[i].Text;
                                    // NoteId.Insert(i, NoteIdElem[i].Text);

                                    // NoteId.Add(NoteIdElem[i].Text);

                                    Console.WriteLine("\nSelected Note for Calculation = " + Noteid);
                                    //Console.WriteLine("\nSelected Note for Calculation = " + NoteId[i]);
                                    // Console.WriteLine("\nNote Id href for "+i+"st Note = " + NotId_href[i].GetAttribute("href"));
                                    // printMessages = "<p><b> Note for Calculation = " + NoteId[i] + " </b></p>";
                                    printMessages = "<p><b> Note for Calculation = " + Noteid + " </b></p>";
                                    test.Pass(printMessages);

                                    NoteIdElem[i].Click();
                                    Thread.Sleep(8000);

                                    driver.FindElement(deal.cashflowTab).Click();
                                    Thread.Sleep(10000);

                                    driver.FindElement(deal.calcButton).Click();
                                    Thread.Sleep(25000);

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
                                    string FullStatus = " ";
                                    if (calculationStatus == "Completed")
                                    {
                                        Console.WriteLine("\n" + i + "th Note calculation is completed");
                                        Thread.Sleep(10000);
                                        try
                                        {
                                            FullStatus = driver.FindElement(deal.calculationFullStatus).Text;
                                            Console.WriteLine("\nCompleted Note's Full Status = " + FullStatus);
                                            test.Log(Status.Pass, "Full Status = " + FullStatus);
                                            addtolist(NoteId[i], calculationStatus, FullStatus, "No Exception");
                                            //test.Log(Status.Pass, "Calculation has been Completed for Note = "+NoteId);
                                            test.Log(Status.Pass, "Calculation has been Completed for Note = " + Noteid);
                                            Console.WriteLine("\nCompleted status Logged");
                                        }
                                        catch (Exception ex)
                                        {
                                            Console.WriteLine("\n Excel Report Exception =" + ex.Message);
                                            // addtolist(NoteId[i], calculationStatus, FullStatus, CalcException);
                                            addtolist(Noteid, calculationStatus, FullStatus, CalcException);
                                        }
                                        driver.Navigate().Back();
                                        Thread.Sleep(10000);

                                        continue;
                                    }

                                    // .............................Note Calculation Failed..............................
                                    else if (calculationStatus == "Failed")
                                    {
                                        try
                                        {
                                            printMessages = "<p><b>Test FAILED!</b></p>";
                                            test.Fail(printMessages);
                                            Console.WriteLine("\nCompleted status Log failed");
                                            FullStatus = driver.FindElement(deal.calculationFullStatus).Text;
                                            Console.WriteLine("\nCompleted Note's Full Status = " + FullStatus);
                                            Console.WriteLine("\n" + i + "the Note's calculation is failed");
                                            // test.Log(Status.Fail, "Calculation has been failed for Note = " + NoteId);
                                            test.Log(Status.Fail, "Calculation has been failed for Note = " + Noteid);
                                            // addtolist(NoteId[i], calculationStatus, FullStatus, "");
                                            addtolist(Noteid, calculationStatus, FullStatus, "");
                                            Thread.Sleep(5000);
                                        }
                                        catch (Exception ex)
                                        {
                                            Console.WriteLine("\n Excel Report Exception =" + ex.Message);
                                        }
                                        driver.Navigate().Back();
                                        Thread.Sleep(5000);
                                        continue;
                                    }
                                    //.............................................................................   
                                    else
                                        Console.WriteLine("\nLoop count = " + i);
                                }
                                catch (Exception e)
                                {
                                    Console.WriteLine("\nException =" + e.Message);
                                }

                                driver.Navigate().Refresh();
                                Thread.Sleep(20000);
                                href = "/#/notedetail/";
                                NoteIdElem = driver.FindElements(By.CssSelector("a[href*='" + href + "']"));

                            }

                            //............................Calling Excel Report creation.............................................

                            Thread.Sleep(3000);
                            string times = Timestamp();
                            CreateExcelDataTableNew((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(ListNoteCalculation), typeof(DataTable)), "NoteCalculationReport");
                            Thread.Sleep(7000);

                            // String FileName;
                            string pathExcel = "NoteCalculationReport" + "_" + times + ".xlsx";
                            Console.WriteLine("\nExcel report = " + pathExcel);
                            Thread.Sleep(5000);

                            //CreateExcelDataTableNew(pathExcel);                            
                            string pathNew = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName;
                            Console.WriteLine("\nPath of current directory " + pathNew);

                            //........................................Mail Send with Excel Report............................................................

                            EmailDataContract emailDC = new EmailDataContract();
                            emailDC.To = "shantanu@hvantage.com ";//,rsahu@hvantage.com,ssingh@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com,rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com";

                            //optional
                            //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
                            //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
                            emailDC.ReceiverName = "All";
                            emailDC.FileAttachment = new List<FileAttachmentDataContract>();
                            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\NoteCalculation\\" + pathExcel });
                            string path = ProjectBaseConfiguration.ExecutionReportFolder;
                            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });    //  No need
                            emailDC.Subject = "Notes Calculation report";
                            emailDC.Body = "Please find an attachment of Notes calculation Report.";
                            emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
                            emailDC.EmailSettings.Host = Host;
                            emailDC.EmailSettings.UserName = UserName;
                            emailDC.EmailSettings.Password = Password;
                            emailDC.EmailSettings.Port = Port;

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
                                                                                       */
                            //.............................................................................................................
                            printMessages = "<p><b>Calculation is completed for all Notes</b></p>";
                            test.Pass(printMessages);
                        }
                        else
                            Console.WriteLine("\nCalculation Manager page load failed");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("\nCalculation Manager Exception = " + ex.Message);
                    }
                }
                else
                    Console.WriteLine("\nLogin Failed");
            }
            catch (Exception ex)
            {
                Console.Write("\nFinal Exception =" + ex.ToString());
            }

        }
    }
}
