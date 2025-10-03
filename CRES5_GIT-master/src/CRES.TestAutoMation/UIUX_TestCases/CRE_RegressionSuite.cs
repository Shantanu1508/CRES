using AventStack.ExtentReports;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.EmailTemplate;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using OpenQA.Selenium;
using CRES.TestAutoMation.TestCases;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using Newtonsoft.Json;
using CRES.TestAutoMation;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System;
using AngleSharp.Io;
using DocumentFormat.OpenXml.Math;
using Microsoft.Office.Interop.Excel;
using NUnit.Framework;
using System.Threading;

namespace CRES.TestAutoMation.UIUX_TestCases
{
    internal class CRE_RegressionSuite : BaseClass
    {
        // IntegrationGeneralVerification

        ExtentTest test = null;
        static string indexReport = null;
        static string filePath = null;
        static IRow row;
        static string env;
        static String time;
        static String TimeStamp;
        static string loggedInUserName;
        static Util util = null;
        static string path = null;

        public static String Timestamp()
        {
            String timeStamp = Util.GetTimestamp(DateTime.Now);
            return timeStamp;
        }

        Email SendEmail = new Email();
        
        AllPagesLoadAutomation pageLoad = new AllPagesLoadAutomation();
        VerifyDeal dealSave = new VerifyDeal();
        NotesCalculation notesCalculation = new NotesCalculation();
        LiabilityFunctionalTest liability = new LiabilityFunctionalTest();
        DownloadCashflow cashflow = new DownloadCashflow();
        ExportToExcelVerify exportExcel = new ExportToExcelVerify();


        List<PageLoadTest> listPageLoad = new List<PageLoadTest>();


        public void addtolist(int srno, string pagename, string tabname, Boolean res, String Exception)
        {
            PageLoadTest plt = new PageLoadTest();

            plt.SrNo = srno;
            plt.PageName = pagename;
            plt.TabName = tabname;
            if (res == true)
            {
                plt.Status = "Loaded";
            }
            else
            {
                plt.Status = "Error";
            }
            listPageLoad.Add(plt);

            plt.Exception = Exception;
        }

        static ISheet excelSheet;
        public static void CreateExcelDataTableNew(System.Data.DataTable table, string FileName)
        {
            try
            {

                var memoryStream = new MemoryStream();
                path = ProjectBaseConfiguration.ExcelReportsFolder;
                indexReport = ProjectBaseConfiguration.ExecutionReportFolder;

                Console.WriteLine("Path of the directory = " + path);
                Console.WriteLine("Path of index file = " + indexReport);
                if (Directory.Exists(path))
                {
                    DirectoryInfo di = Directory.CreateDirectory(path);

                    //time = LiabilityFunctionalTest.Timestamp();
                    TimeStamp = DateTime.Now.ToString("MM/dd/yyyy_HH:mm:ss");
                    filePath = path + FileName + ".xlsx";
                    Console.WriteLine("Excel filepath = " + filePath);
                    IWorkbook workbook;
                    using (var fs = new FileStream(filePath, FileMode.Open, FileAccess.Read))
                    {
                        workbook = new XSSFWorkbook(fs);
                        fs.Close();
                    }

                    excelSheet = workbook.GetSheet("PageLoad_Summary") ?? workbook.CreateSheet("PageLoad_Summary");
                    Console.WriteLine("excelSheet = " + excelSheet.ToString());
                    List<String> columns = new List<string>();

                    IRow row = excelSheet.CreateRow(7);

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

                    Console.WriteLine("row = " + row);
                    int columnIndex = 0;
                    foreach (System.Data.DataColumn column in table.Columns)
                    {
                        columns.Add(column.ColumnName);
                        //row.CreateCell(columnIndex).SetCellValue(column.ColumnName);
                        columnIndex++;
                    }

                    // To set Date& Time in sheet.
                    excelSheet.GetRow(4).CreateCell(2).SetCellValue(TimeStamp);
                    Console.WriteLine("row = " + excelSheet.GetRow(4));
                    // To set Environment in the sheet.
                    env = BaseConfiguration.GetEnvironment();
                    Console.WriteLine("\nEvironment Name= " + env);
                    loggedInUserName = util.GetLoggedInUserName();
                    excelSheet.GetRow(3).CreateCell(2).SetCellValue(loggedInUserName);
                    Console.WriteLine("row = " + excelSheet.GetRow(3));

                    excelSheet.GetRow(4).CreateCell(4).SetCellValue(env);
                    Console.WriteLine("row = " + excelSheet.GetRow(4));

                    // To updated latest data from 7th row.
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

        //-------------------------------------------------------------------------------------------------------//

        //---------------------------verifyLogin----------------------------------------------------------------//

        public void verifyLogin() {
            //Login_Verification loginapp = new Login_Verification();
            Login login = new Login(driver);
            Deal deal = new Deal(driver);
            util = new Util(driver);
            string dealfunding = BaseConfiguration.GetNewQAUrl() + BaseConfiguration.DealFunding();


            string subLoginUrl;
            string BaseUrl = null;
            env = BaseConfiguration.GetEnvironment();
            loggedInUserName = util.GetLoggedInUserName();
            BaseUrl = env switch
            {
                "NewQA" => BaseConfiguration.GetNewQAUrl(),
                "QA" => BaseConfiguration.GetNewQAUrl(),
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
                    test = extent.CreateTest("General verification to load all the pages ").Info("Test started").AssignAuthor("Shantanu_Sharma");

                    String DealUrl = BaseUrl + "#/dealdetail/e25bef2b-abc4-4b68-bb02-1d4459df7969";
                    util.OpenUrl(DealUrl);
                    Thread.Sleep(25000);

                    //............................MainTab.......................
                    try
                    {
                        IWebElement mainTab = driver.FindElement(By.Id("aMain"));
                        mainTab.Click();
                        Thread.Sleep(3000);
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Main Tab Exception = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool HealHead = false;
                    try
                    {
                        HealHead = driver.FindElement(deal.DealHead).Displayed;
                        Console.WriteLine("Deal Id= " + HealHead);


                        var printMessages = "<p><b>Test FAILED!</b></p>";
                        if (HealHead == false)
                        {
                            printMessages += $"Message: <br>{"Main Page Load Error"}<br>";
                            test.Fail(printMessages);
                            addtolist(1, "deal", "Main", HealHead, "");
                        }
                        else
                        {
                            test.Log(Status.Pass, "Main page loaded sucessfully");
                            addtolist(1, "deal", "Main", HealHead, "");
                        }

                    }
                    catch (Exception ex)
                    {
                        HealHead = false;
                        Console.WriteLine(" Exception =" + ex); // ex;
                        addtolist(1, "deal", "Main", HealHead, ex.ToString());

                    }
                }
            }
            catch (Exception ex)
            {

                Console.WriteLine(" Exception =" + ex); // ex;
                addtolist(1, "deal", "Main", false, ex.ToString());

            }

        }


        //----------All pages and Tabs load Automation.----------------------------------------------------------//

        [Test] 
        public void PageLoadAutomation()
        {
            pageLoad.DealDataVerification();
        }


        //----------------------Left navigation bar and all tabs load---------------------------------------

        [Test]
        public void NavigationBarLoadAutomation()
        {

        }


        //----------------------Liability Automation.

        [Test]
        public void LiabilityAutomation()
        {
            
        }


        //----------------------A.Equity creation.

        [Test]
        public void CreateEquityAutomation()
        {
            liability.FunctionalTest();

            liability.EquityCreation();
            
        }


        //----------------------B.Debt creation.

        [Test]
        public void CreateDebtAutomation()
        {
            liability.DebtCreation();

            
        }


        //----------------------C.Liability Note creation.

        [Test]
        public void CreateLiabilityNoteAutomation()
        {
            liability.LiabilityNoteCreation();

            liability.LiabilityNoteDataValidation();
        }


        //----------------------D.General Entry creation.

        [Test]
        public void CreateGeneralEntryAutomation()
        {
            liability.JournalEntryCreation();

            
        }


        //----------------------4. Copy Deal creation Automation.

        [Test]
        public void CopyDealAutomation()
        {

        }


        //----------------------5. Single Deal calculation.

        [Test]
        public void dealCalcultaionAutomation()
        {

        }


        //----------------------6.  Single Note calculation Automation.

        [Test]
        public void noteCalculationAutomation()
        {
            notesCalculation.NoteCalculation();
        }


        //----------------------7. XIRR Automation.

        [Test]
        public void XIRRAutomation()
        {

        }


        //----------------------8.  Download cashflows Automation.

        [Test]
        public void downloadCashflowAutomation()
        {
            cashflow.downloadCashflow();
        }


        //----------------------9. Download all export to excel files for a deal.

        [Test]
        public void downloadExportToExcelAutomation()
        {
            exportExcel.DownloadExportToExcel();
        }

        //----------------------Report creation and Email -------------------------------------------//

        public void sendEmail() {

            UpdatedGeneralVerification.CreateExcelDataTableNew((System.Data.DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(listPageLoad), (typeof(System.Data.DataTable))), "PageLoad Test Report");
            string sendValidationReportEmail = BaseConfiguration.SendValidationReportEmail();
            if (sendValidationReportEmail.ToString().ToLower() == "yes")
            {
                try
                {

                    loggedInUserName = util.GetLoggedInUserName();
                    test.Log(Status.Info, "Email sent with Liability report attached file.");
                    test.Log(Status.Info, "Ran By: " + loggedInUserName);
                    Console.WriteLine("Logged in user = " + loggedInUserName);
                    //String time = VerifyDeal.Timestamp();
                    System.Threading.Thread.Sleep(7000);

                    // String FileName;

                    String pathExcel = "PageLoad Test Report" + ".xlsx";
                    Console.WriteLine("Excel report =" + pathExcel);
                    //CreateExcelDataTableNew(pathExcel);
                    System.Threading.Thread.Sleep(5000);
                    string pathNew = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName;
                    Console.WriteLine("Path of current directory " + pathNew);
                    string path = ProjectBaseConfiguration.ExcelReportsFolder;
                    Console.WriteLine("Path of execution folder = " + path);


                    EmailDataContract emailDC = new EmailDataContract();  // Check Point
                    emailDC.To = "shantanu@hvantage.com,rsahu@hvantage.com";

                    //optional
                    //emailDC.Cc = "ssingh@hvantage.com,vbalapure@hvantage.com,vandana@hvantage.com";
                    //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
                    emailDC.ReceiverName = "All";
                    emailDC.FileAttachment = new List<FileAttachmentDataContract>();
                    emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + pathExcel });
                    // Console.WriteLine("attached file = " + filePath);
                    //string path = ProjectBaseConfiguration.ExecutionReportFolder;
                    Console.WriteLine("Path of index file email = " + pathNew);
                    emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\index.html" });
                    //  Console.WriteLine("attached file index = " + filePath);
                    emailDC.Subject = "Automation - CRE Regression Test Report";
                    emailDC.Body = "PFA the report of CRE Regression Test";
                    emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
                    emailDC.EmailSettings.Host = BaseConfiguration.Host;
                    emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
                    emailDC.EmailSettings.Password = BaseConfiguration.Password;
                    emailDC.EmailSettings.Port = BaseConfiguration.Port;
                    //
                    EmailAutomationLogic lg = new EmailAutomationLogic();

                    String response = lg.SendGenericEmail(emailDC);
                    Thread.Sleep(10000);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("\nSend report mail Exception =" + ex);

                }



            }
            
        }

    }
}
