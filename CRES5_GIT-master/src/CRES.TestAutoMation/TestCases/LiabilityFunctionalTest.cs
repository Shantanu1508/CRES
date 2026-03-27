using CRES.TestAutoMation.Pages;
using NUnit.Framework;
using NUnit.Framework.Internal;
using OpenQA.Selenium.Interactions;
using System;
using CRES.TestAutoMation.Utility;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using AventStack.ExtentReports;
using AventStack.ExtentReports.Model;
using CRES.DataContract;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System.Data;
using System.IO;
using Newtonsoft.Json;
using CRES.TestAutoMation.EmailTemplate;
using com.sun.org.apache.bcel.@internal.generic;
using OpenQA.Selenium.Support.UI;
using OpenQA.Selenium;
using DocumentFormat.OpenXml.Drawing.ChartDrawing;
using CRES.BusinessLogic;
using NPOI.HSSF.Record;
using DocumentFormat.OpenXml.Bibliography;
using com.sun.org.glassfish.external.arc;
using CRES.TestAutoMation.Practice;
using System.Globalization;

namespace CRES.TestAutoMation.TestCases
{
    public class LiabilityFunctionalTest : BaseClass
    {
        ExtentTest test = null;
        SelectElement select;
        String debtname = null;
        string debtType = null;

        String equityname = null;
        string equityType = null;
        static string indexReport = null;
        static string filePath=null;
        static ISheet excelSheet;        
        static string TimeStamp;

        Actions actions;
        Login_Verification loginapp;
        Login login;
        Deal deal;
        //CreateNewDeal createDeal;
        Util util;
        string dealfunding;
        string subLoginUrl;
        string BaseUrl;
        static string env;
        string LoginUrl;
        bool loginValidation;
        string Equity_Name;
        string Debt_Name;
        static string JeLogo;
        string LiabilityNote_Name;
        string LiabilityNoteLabel;
        static string loggedInUserName;

        int num; string liabilityNoteID; string liabilityID;
        string liabilityAssetID; string liabilityStatus; string liabilityPledgeDate; double liabilityPaydownAdvanceRate; double liabilityFundingAdvanceRate; double liabilityTargetAdvanceRate; string liabilityMaturityDate; string rSSEffectiveDate; string rSSDate; string rSSValueType; string rSSValue; string rSSCalcMethod; string rSSRateOrSpreadToBeStripped; string rSSIndexName; string rSSDeterminationDateHolidayList;
        CultureInfo provider = CultureInfo.InvariantCulture;

        public LiabilityFunctionalTest()
        {
            
        }

        Email SendEmail = new Email();
        List<Liabilitys> liability = new List<Liabilitys>();
        List<DebtSheet> debtSheet = new List<DebtSheet>();
        string randomstring = DateTime.Now.ToString("MM_dd_yyyy");

        public void addtolist(int srno, string entityname, string entityid, string entitytype, Boolean res, string exception)
        {
            Liabilitys lbt = new Liabilitys();
            lbt.SrNo = srno;
            lbt.Entity_Name = entityname;
            lbt.Entity_Id = entityid;
            lbt.Entity_Type = entitytype;
            lbt.Exception = exception;

            if (res == true)
            {
                lbt.Status = "Created";
            }
            else
            {
                lbt.Status = "Failed";
            }

            liability.Add(lbt);
        }

        public void addtosheet(int Num, string LiabilityNoteID, string LiabilityID, string LiabilityAssetID, string LiabilityStatus, string LiabilityPledgeDate, double LiabilityPaydownAdvanceRate, double LiabilityFundingAdvanceRate, double LiabilityTargetAdvanceRate, string LiabilityMaturityDate, string RSSEffectiveDate, string RSSDate, string RSSValueType, string RSSValue, string RSSCalcMethod, string RSSRateOrSpreadToBeStripped, string RSSIndexName, string RSSDeterminationDateHolidayList)
        {
            DebtSheet ds = new DebtSheet();
            ds.SrNo = Num;
            ds.Output = "Actual Output";
            ds.LiabilityNoteID = LiabilityNoteID;
            ds.LiabilityID = LiabilityID;
            ds.LiabilityAssetID = LiabilityAssetID;
            ds.LiabilityStatus = LiabilityStatus;
            ds.LiabilityPledgeDate = LiabilityPledgeDate;
            ds.LiabilityPaydownAdvanceRate = LiabilityPaydownAdvanceRate;
            ds.LiabilityFundingAdvanceRate = LiabilityFundingAdvanceRate;
            ds.LiabilityTargetAdvanceRate = LiabilityTargetAdvanceRate;
            ds.LiabilityMaturityDate = LiabilityMaturityDate;
            ds.RSSEffectiveDate = RSSEffectiveDate;
            ds.RSSDate = RSSDate;
            ds.RSSValueType = RSSValueType;
            ds.RSSValue = RSSValue;
            ds.RSSCalcMethod = RSSCalcMethod;
            ds.RSSRateOrSpreadToBeStripped = RSSRateOrSpreadToBeStripped;
            ds.RSSIndexName = RSSIndexName;
            ds.RSSDeterminationDateHolidayList = RSSDeterminationDateHolidayList;

            debtSheet.Add(ds);
        }


        public static String Timestamp()
        {
            String timeStamp = Util.GetTimestamp(DateTime.Now);
            return timeStamp;
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

                    excelSheet = workbook.GetSheet("Liability_Summary") ?? workbook.CreateSheet("Liability_Summary");
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

        public static void VerifyEntityData(DataTable table, string FileName, string sheetName)
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


                    TimeStamp = DateTime.Now.ToString("MM/dd/yyyy_HH:mm:ss");

                    filePath = path + FileName + ".xlsx";
                    IWorkbook workbook;
                    using (var fs = new FileStream(filePath, FileMode.Open, FileAccess.Read))
                    {
                        workbook = new XSSFWorkbook(fs);
                        fs.Close();

                    }

                    excelSheet = workbook.GetSheet(sheetName) ?? workbook.CreateSheet(sheetName);
                    Console.WriteLine("excelSheet = " + excelSheet);
                    Console.WriteLine("\nExcel sheet name = " + excelSheet.Workbook.GetSheetName(1));

                    IRow row = excelSheet.GetRow(6);

                    // To delete old data from 7th row.
                    int RowIndex = 7;
                    while (excelSheet.GetRow(RowIndex) != null)
                    {
                        row = excelSheet.GetRow(RowIndex);
                        Console.Write("\nrowIndex =" + row.ToString());
                        excelSheet.RemoveRow(row);
                        Console.Write("\nrowIndex =" + row.ToString());

                        RowIndex++;
                    }
                    Console.WriteLine("\nrows deleted upto the row =" + RowIndex);

                    //ISheet excelSheet01 = workbook.CreateSheet("Liability_Summary01");
                    List<String> columns = new List<string>();

                    // To set colmns name of the sheet.
                    row = excelSheet.GetRow(5) ?? excelSheet.CreateRow(5);
                    Console.WriteLine("row = " + row);
                    int columnIndex = 0;
                    foreach (System.Data.DataColumn column in table.Columns)
                    {
                        columns.Add(column.ColumnName);
                        //row.CreateCell(columnIndex).SetCellValue(column.ColumnName);
                        columnIndex++;
                    }

                    // To set Date& Time in sheet.
                    row = excelSheet.GetRow(4) ?? excelSheet.CreateRow(4);
                    row.CreateCell(2).SetCellValue(TimeStamp);
                    Console.WriteLine("row = " + row);
                    // To set Environment in the sheet.
                    row = excelSheet.GetRow(4) ?? excelSheet.CreateRow(4);
                    row.CreateCell(5).SetCellValue(env);
                    Console.WriteLine("row = " + row);

                    // To insert updated data from 7th row.
                    int rowIndex = 7;
                    foreach (DataRow dsrow in table.Rows)
                    {
                        row = excelSheet.CreateRow(rowIndex);
                        Console.WriteLine("row = " + row);
                        int cellIndex = 0;
                        foreach (String col in columns)
                        {
                            row.CreateCell(cellIndex).SetCellValue(dsrow[col].ToString());
                            cellIndex++;
                        }

                        // To verify data
                        row = excelSheet.CreateRow(8);
                        Console.WriteLine("row = " + row);
                        cellIndex = 0;
                        foreach (String colIndex in columns)
                        {

                            if (excelSheet.GetRow(6).GetCell(cellIndex).ToString() == excelSheet.GetRow(7).GetCell(cellIndex).ToString())
                            {
                                Console.WriteLine("\n Cell value = " + excelSheet.GetRow(7).GetCell(cellIndex).ToString());
                                row.CreateCell(cellIndex).SetCellValue("Pass");

                            }
                            else
                            {
                                row.CreateCell(cellIndex).SetCellValue("Value is different = " + excelSheet.GetRow(7).GetCell(cellIndex).ToString());
                            }

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


        [Test, Order(1)]
        public void FunctionalTest()
        {

             actions = new Actions(driver);

            loginapp = new Login_Verification();
             login = new Login(driver);
             deal = new Deal(driver);
             //createDeal = new CreateNewDeal(driver);
             util = new Util(driver);
            
             dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
            // string username = BaseConfiguration.getusername();
            //string password = BaseConfiguration.getpassword();
            //string LoginUrl = BaseConfiguration.LoginUrl();

            string subLoginUrl;
            string BaseUrl = null;
             env = BaseConfiguration.GetEnvironment();

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

                System.Threading.Thread.Sleep(10000);

                if (loginValidation)
                {
                    test = extent.CreateTest("Liability Functional Testing ").Info("Test started").AssignAuthor("Shantanu_Sharma");
                }
                else
                {
                test.Log(Status.Fail, debtname + "Login Failed");
                Console.WriteLine("Login Failed");
                }

            this.DebtCreation();

            this.EquityCreation();

            this.JournalEntryCreation();

            this.LiabilityNoteCreation();

            this.LiabilityNoteDataValidation();

            this.SendMail();

        }
        //--------------------------------Liability --------------------------------

        //......................................Debt Page....................
        
        public void DebtCreation()
        {
            Console.WriteLine("You are in DebtCreation method");

            try
            {
                driver.FindElement(deal.AddManu).Click();
                Thread.Sleep(3000);

                driver.FindElement(deal.Debt).Click();
                Thread.Sleep(7000);

                driver.Navigate().Refresh();
                Thread.Sleep(5000);

                Debt_Name = "Debt_Test_" + LiabilityFunctionalTest.Timestamp().ToString();
                Console.WriteLine("Debt Name = " + Debt_Name);
                driver.FindElement(deal.DebtName).Click();
                driver.FindElement(deal.DebtName).SendKeys(Debt_Name);

                Thread.Sleep(3000);

                select = new SelectElement(driver.FindElement(deal.DebtType));
                select.SelectByValue("2");
                Thread.Sleep(3000);
                select = new SelectElement(driver.FindElement(deal.DebtStatus));
                select.SelectByValue("1");
                Thread.Sleep(3000);
                select = new SelectElement(driver.FindElement(deal.Currency));
                select.SelectByValue("187");
                Thread.Sleep(3000);
                select = new SelectElement(driver.FindElement(deal.MatchTerms));
                select.SelectByValue("3");
                Thread.Sleep(3000);
                select = new SelectElement(driver.FindElement(deal.IsRevolving));
                select.SelectByValue("3");

                driver.FindElement(deal.FundingNoticeBusinessDays).SendKeys("4");
                Thread.Sleep(3000);

                driver.FindElement(deal.InitialFundingDelay).SendKeys("5");
                Thread.Sleep(3000);

                driver.FindElement(deal.EarliestFinancingArrival).SendKeys("10/20/2023");
                Thread.Sleep(3000);

                driver.FindElement(deal.DebtTags).SendKeys("Note Transfer");
                Thread.Sleep(3000);

                driver.FindElement(deal.MaxAdvanceRate).SendKeys("50");
                Thread.Sleep(3000);


                driver.FindElement(deal.OriginationDate).SendKeys("10/20/2023");
                Thread.Sleep(3000);

                driver.FindElement(deal.OriginationFees).SendKeys("2");
                Thread.Sleep(3000);

                select = new SelectElement(driver.FindElement(deal.RateType));
                select.SelectByValue("139");
                Thread.Sleep(3000);

                driver.FindElement(deal.PaydownDelay).SendKeys("2");
                Thread.Sleep(3000);

                driver.FindElement(deal.DebtEffectiveDate01).SendKeys("10/20/2023");
                Thread.Sleep(3000);

                driver.FindElement(deal.DebtCommitment).SendKeys("200000000");
                Thread.Sleep(3000);

                driver.FindElement(deal.InitialMaturityDate).SendKeys("10/20/2024");
                Thread.Sleep(3000);

                driver.FindElement(deal.InitialInterestAccrualEnddate).SendKeys("10/20/2023");
                Thread.Sleep(3000);

                driver.FindElement(deal.AccrualFrequency).SendKeys("1");
                Thread.Sleep(3000);

                driver.FindElement(deal.PaymentDayMonth).SendKeys("1");
                Thread.Sleep(3000);

                driver.FindElement(deal.PaymentDateBusinessDayLag).SendKeys("1");
                Thread.Sleep(3000);

                driver.FindElement(deal.Determinationdateleaddays).SendKeys("-1");
                Thread.Sleep(3000);

                driver.FindElement(deal.DeterminationDateRefDayMonth).SendKeys("1");
                Thread.Sleep(3000);

                select = new SelectElement(driver.FindElement(deal.RoundingMethod));
                select.SelectByValue("251");
                Thread.Sleep(3000);

                driver.FindElement(deal.IndexRoundingRule).SendKeys("1");
                Thread.Sleep(3000);

                driver.FindElement(deal.FinanacingSpreadRate).SendKeys("10");
                Thread.Sleep(3000);


                driver.FindElement(deal.PayFrequency).SendKeys("1");
                Thread.Sleep(3000);

                select = new SelectElement(driver.FindElement(deal.IntCalcMethod));
                select.SelectByValue("178");
                Thread.Sleep(3000);

                select = new SelectElement(driver.FindElement(deal.DefaultIndexName));
                select.SelectByValue("837");
                Thread.Sleep(3000);

                driver.FindElement(deal.TargetAdvanceRate).SendKeys("50");
                Thread.Sleep(3000);

                driver.FindElement(deal.DebtEffectiveDateFeeSchedule).Click();
                driver.FindElement(deal.DebtEffectiveDateFeeSchedule).SendKeys("10/20/2023");
                Thread.Sleep(3000);

                driver.FindElement(deal.FeeName).SendKeys("Test Fee");
                Thread.Sleep(5000);

                driver.FindElement(deal.StartDate).Click();
                driver.FindElement(deal.StartDate).SendKeys("10/20/2023");
                Thread.Sleep(5000);

                driver.FindElement(deal.EndDate).Click();
                driver.FindElement(deal.EndDate).SendKeys("10/20/2024");
                Thread.Sleep(3000);


                driver.FindElement(deal.FeeType).Click();
                driver.FindElement(deal.AcoreOriginFee).Click();
                Thread.Sleep(3000);

                driver.FindElement(deal.Fee).Click();
                driver.FindElement(deal.Fee).SendKeys("2.5");
                Thread.Sleep(3000);

                driver.FindElement(deal.FeeAmountOverride).Click();
                driver.FindElement(deal.FeeAmountOverride).SendKeys("1000");
                Thread.Sleep(3000);

                driver.FindElement(deal.BaseAmountOverride).Click();
                driver.FindElement(deal.BaseAmountOverride).SendKeys("2000");
                Thread.Sleep(3000);

                actions.KeyDown(Keys.ArrowRight).Build().Perform();
                actions.KeyUp(Keys.ArrowRight).Build().Perform();

                driver.FindElement(deal.ApplyTrueUp).Click();
                Thread.Sleep(3000);
                driver.FindElement(deal.ApplyTrueUpYes).Click();
                Thread.Sleep(3000);                
                
                actions.KeyDown(Keys.ArrowRight).Build().Perform();
                actions.KeyUp(Keys.ArrowRight).Build().Perform();
                actions.KeyDown(Keys.ArrowRight).Build().Perform();
                actions.KeyUp(Keys.ArrowRight).Build().Perform();
                actions.KeyDown(Keys.ArrowRight).Build().Perform();
                actions.KeyUp(Keys.ArrowRight).Build().Perform();
                Thread.Sleep(5000);


                /*IJavaScriptExecutor js = (IJavaScriptExecutor)driver;
                js.ExecuteScript("window.scrollBy(0,-1000)", "");*/
                driver.FindElement(deal.InLvYieldCalc).Click();
                driver.FindElement(deal.InLvYieldCalc).SendKeys("10");
                Thread.Sleep(3000);
                driver.FindElement(deal.FeeToBeStripped).Click();
                driver.FindElement(deal.FeeToBeStripped).SendKeys("20");
                Thread.Sleep(3000);

                driver.FindElement(deal.Delete).Click();
                Thread.Sleep(3000);
                driver.FindElement(deal.DeletePopupCancelButton).Click();
                Thread.Sleep(3000);

                driver.FindElement(deal.DebtSave).Click();
                Thread.Sleep(5000);




                driver.FindElement(deal.searchBar).Click();
                driver.FindElement(deal.searchBar).SendKeys(Debt_Name);
                System.Threading.Thread.Sleep(5000);
                driver.FindElement(deal.DebtSearchedResult).Click();
                System.Threading.Thread.Sleep(25000);
                debtname = driver.FindElement(deal.DebtLogo).Text.ToString();
                Console.WriteLine(debtname);
                var printMessages = "<p><b>Test FAILED!</b></p>";
                Console.WriteLine("debt name = " + debtname);
                Console.WriteLine("Date Time =" + randomstring);
                if (debtname == "Debt: " + Debt_Name)
                {

                    string index = driver.FindElement(deal.DebtType).GetAttribute("ng-reflect-model");
                    Console.WriteLine("index = " + index);
                    debtType = driver.FindElement(By.XPath("//select//option[@value='" + index + "']")).Text.ToString();
                    Console.WriteLine("Debt Type = " + debtType);

                    addtolist(1, "Debt", Debt_Name, debtType, true, "");
                    test.Log(Status.Pass, debtname + " created successfully.");
                }
                else
                {
                    Console.WriteLine("Debt searched failed.");
                    addtolist(1, "Debt", Debt_Name, debtType, false, "Debt note created");
                    test.Fail(printMessages);
                }
                System.Threading.Thread.Sleep(5000);


            }
            catch (Exception ex)
            {
                Console.WriteLine("Debt Page exception = " + ex);
                addtolist(1, "Debt", debtname, debtType, false, ex.ToString());
            }
            Thread.Sleep(5000);
        }

        
        public void EquityCreation()
        {
            Console.WriteLine("You are in EquityCreation method");
            try
            {
                driver.FindElement(deal.AddManu).Click();
                Thread.Sleep(3000);

                driver.FindElement(deal.Equity).Click();
                Thread.Sleep(7000);
                Equity_Name = "Equity_Test_" + LiabilityFunctionalTest.Timestamp().ToString();
                Console.WriteLine("Equity Name = " + Equity_Name);
                driver.FindElement(deal.EquityName).Click();
                driver.FindElement(deal.EquityName).SendKeys(Equity_Name);
                Thread.Sleep(3000);

                select = new SelectElement(driver.FindElement(deal.EquityType));
                select.SelectByValue("4");
                Thread.Sleep(3000);

                select = new SelectElement(driver.FindElement(deal.EquityStatus));
                select.SelectByValue("1");
                Thread.Sleep(3000);


                select = new SelectElement(driver.FindElement(deal.Currency));
                select.SelectByValue("187");
                Thread.Sleep(3000);


                driver.FindElement(deal.InvestorCapital).Click();
                Thread.Sleep(1000);
                driver.FindElement(deal.InvestorCapital).SendKeys("500000000");
                Thread.Sleep(3000);

                driver.FindElement(deal.CapitalReserveRequirement).Click();
                Thread.Sleep(1000);
                driver.FindElement(deal.CapitalReserveRequirement).SendKeys("10");
                Thread.Sleep(3000);

                driver.FindElement(deal.ReserveRequirement).Click();
                Thread.Sleep(1000);
                driver.FindElement(deal.ReserveRequirement).SendKeys("150000000");
                Thread.Sleep(3000);

                driver.FindElement(deal.CapitalCallNoticeBusinessDays).Click();
                Thread.Sleep(1000);
                driver.FindElement(deal.CapitalCallNoticeBusinessDays).SendKeys("1");
                Thread.Sleep(3000);

                driver.FindElement(deal.LastDateOfInvest).Click();
                Thread.Sleep(3000);
                driver.FindElement(deal.LastDateOfInvest).SendKeys("10/20/2024");
                Thread.Sleep(5000);

                driver.FindElement(deal.InceptionDate).Click();
                Thread.Sleep(1000);
                driver.FindElement(deal.InceptionDate).SendKeys("10/20/2023");
                Thread.Sleep(3000);

                /*driver.FindElement(deal.LastDateOfInvest).Click();
                Thread.Sleep(3000);
                driver.FindElement(deal.LastDateOfInvest).SendKeys("10/20/2024");
                Thread.Sleep(5000);*/

                driver.FindElement(deal.LinkedShortTermBorrowingFacility).Click();
                Thread.Sleep(3000);
                driver.FindElement(deal.LinkedShortTermBorrowingFacility).SendKeys("shan");
                Thread.Sleep(3000);

                driver.FindElement(deal.EqTags).Click();
                driver.FindElement(deal.EqTags).SendKeys("Note Transfer");
                Thread.Sleep(3000);

                actions.KeyDown(Keys.Enter).Build().Perform();
                actions.KeyUp(Keys.Enter).Build().Perform();
                Thread.Sleep(3000);

                driver.FindElement(deal.EqEffectiveDate).Click();
                Thread.Sleep(1000);
                driver.FindElement(deal.EqEffectiveDate).SendKeys("10/20/2023");
                Thread.Sleep(3000);

                driver.FindElement(deal.EqCommitment).Click();
                driver.FindElement(deal.EqCommitment).SendKeys("200000000");
                Thread.Sleep(3000);

                driver.FindElement(deal.EqInitialMaturityDate).Click();
                Thread.Sleep(1000);
                driver.FindElement(deal.EqInitialMaturityDate).SendKeys("10/20/2024");
                Thread.Sleep(3000);

                driver.FindElement(deal.DebtSave).Click();
                Thread.Sleep(5000);


                driver.FindElement(deal.searchBar).Click();
                driver.FindElement(deal.searchBar).SendKeys(Equity_Name);
                System.Threading.Thread.Sleep(5000);

                driver.FindElement(deal.DebtSearchedResult).Click();
                System.Threading.Thread.Sleep(25000);

                equityname = driver.FindElement(deal.EquityLogo).Text.ToString();
                Console.WriteLine(equityname);
                var printMessages = "<p><b>Test FAILED!</b></p>";
                Console.WriteLine("Equity name = " + equityname);
                Console.WriteLine("Equity Time =" + randomstring);

                if (equityname == "Equity: " + Equity_Name)
                {

                    string index = driver.FindElement(deal.EquityType).GetAttribute("ng-reflect-model");
                    Console.WriteLine("index = " + index);
                    equityType = driver.FindElement(By.XPath("//select//option[@value='" + index + "']")).Text.ToString();
                    Console.WriteLine("Equity Type = " + equityType);

                    addtolist(2, "Equity", Equity_Name, equityType, true, "");
                    test.Log(Status.Pass, equityname + " created successfully.");
                }
                else
                {
                    Console.WriteLine("Equity searched failed.");
                    addtolist(2, "Equity", Equity_Name, equityType, false, "Equity note created");
                    test.Fail(printMessages);
                }
                System.Threading.Thread.Sleep(5000);

            }
            catch (Exception ex)
            {
                Console.WriteLine("Equity not created" + ex);
            }
        }
        
        public void JournalEntryCreation()
        {
            Console.WriteLine("You are in JournalEntryCreation method");
            try
            {
                driver.FindElement(deal.AddManu).Click();
                Thread.Sleep(3000);

                driver.FindElement(deal.JournalEntry).Click();
                Thread.Sleep(7000);

                driver.FindElement(deal.JournalEntryDate).Click();
                Thread.Sleep(1000);
                driver.FindElement(deal.JournalEntryDate).SendKeys("10/20/2023");
                Thread.Sleep(3000);

                driver.FindElement(deal.JeComment).SendKeys("Shan");
                Thread.Sleep(3000);

                //driver.FindElement(deal.JeAccount01).Click();
                //Thread.Sleep(1000);
                driver.FindElement(deal.JeAccount01).SendKeys(Debt_Name);
                Thread.Sleep(3000);

                driver.FindElement(deal.JeAccount02).Click();
                Thread.Sleep(1000);
                driver.FindElement(deal.JeAccount02).SendKeys(Equity_Name);
                Thread.Sleep(3000);

                driver.FindElement(deal.JeTransactionDate01).Click();
                Thread.Sleep(1000);
                driver.FindElement(deal.JeTransactionDate01).SendKeys("10/20/2023");
                Thread.Sleep(3000);

                driver.FindElement(deal.JeTransactionDate02).Click();
                Thread.Sleep(1000);
                driver.FindElement(deal.JeTransactionDate02).SendKeys("10/20/2023");
                Thread.Sleep(3000);

                driver.FindElement(deal.JeTransactionType01).Click();
                Thread.Sleep(1000);
                driver.FindElement(deal.JeTransactionType01).SendKeys("SublineAdvance");
                Thread.Sleep(3000);

                driver.FindElement(deal.JeTransactionType02).Click();
                Thread.Sleep(1000);
                driver.FindElement(deal.JeTransactionType02).SendKeys("EquityCapitalCall");
                Thread.Sleep(3000);

                driver.FindElement(deal.JeTransactionAmount01).Click();
                Thread.Sleep(1000);
                driver.FindElement(deal.JeTransactionAmount01).SendKeys("-1000");
                Thread.Sleep(3000);

                driver.FindElement(deal.JeTransactionAmount02).Click();
                Thread.Sleep(3000);
                driver.FindElement(deal.JeTransactionAmount02).SendKeys("1000");
                Thread.Sleep(3000);

                driver.FindElement(deal.JeGridComment01).Click();
                Thread.Sleep(1000);
                driver.FindElement(deal.JeGridComment01).SendKeys("Test");
                Thread.Sleep(3000);

                driver.FindElement(deal.JeGridComment02).Click();
                Thread.Sleep(1000);
                driver.FindElement(deal.JeGridComment02).SendKeys("Test");
                Thread.Sleep(3000);

                driver.FindElement(deal.DebtSave).Click();
                Thread.Sleep(1000);

                string JeSuccessMessageText = driver.FindElement(deal.sucessmessagediv).Text;
                Console.WriteLine("JeSuccessMessage = " + JeSuccessMessageText);
                bool JeSuccessMessage = driver.FindElement(deal.sucessmessagediv).Displayed;
                Console.WriteLine("JeSuccessMessage = " + JeSuccessMessage);
                Thread.Sleep(10000);

                JeLogo = driver.FindElement(deal.JournalEntryLabel).Text;


                if (JeSuccessMessage)
                {

                    addtolist(3, "Journal Entry", JeLogo, "InterestExpence", true, "");
                    test.Log(Status.Pass, JeLogo + " created successfully.");
                }
                else
                {
                    var printMessages = "<p><b>Test FAILED!</b></p>";
                    Console.WriteLine("Journal Entry failed.");
                    addtolist(3, "Journal Entry", JeLogo, "InterestExpence", false, "Journal Entry is not created");
                    test.Fail(printMessages);
                }
                System.Threading.Thread.Sleep(5000);

            }
            catch (Exception ex)
            {
                Console.WriteLine("Journal Entry Exception = " + ex);
            }
        }
            
            public void LiabilityNoteCreation()
            {
                Console.WriteLine("You are in LiabilityNoteCreation method.");
              try
              {

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/dealdetail/80ee5f55-83ad-4d3d-a8c1-0eee3f92b1d3");
                Thread.Sleep(5000);

                driver.FindElement(deal.LiabiltyTab).Click();
                Thread.Sleep(3000);

                driver.FindElement(deal.AddLiabilityNoteButton).Click();
                Thread.Sleep(3000);

                
                LiabilityNote_Name = "LN_EQ_22-2586_" + LiabilityFunctionalTest.Timestamp().ToString();
                driver.FindElement(deal.LiabilityNoteID).SendKeys(LiabilityNote_Name);
                Thread.Sleep(3000);

                driver.FindElement(deal.LiabilityID).SendKeys(Equity_Name);
                Thread.Sleep(3000);

                driver.FindElement(deal.LiabilityIdDropdown).Click();
                Thread.Sleep(3000);

                select = new SelectElement(driver.FindElement(deal.LiabilityAssetID));
                select.SelectByValue("64491ade-158b-4353-95ac-96e35f4a8580");
                Thread.Sleep(3000);

                select = new SelectElement(driver.FindElement(deal.LiabilityStatus));
                select.SelectByValue("1");
                Thread.Sleep(3000);

                driver.FindElement(deal.LiabilityPledgeDate).SendKeys("10/20/2023");
                Thread.Sleep(3000);

                driver.FindElement(deal.LiabilityPaydownAdvanceRate).SendKeys("10");
                Thread.Sleep(3000);

                driver.FindElement(deal.LiabilityFundingAdvanceRate).SendKeys("20");
                Thread.Sleep(3000);

                driver.FindElement(deal.LiabilityTargetAdvanceRate).SendKeys("30");
                Thread.Sleep(3000);

                driver.FindElement(deal.LiabilityMaturityDate).SendKeys("10/20/2024");
                Thread.Sleep(3000);

                driver.FindElement(deal.RSSEffectiveDate).SendKeys("10/20/2023");
                Thread.Sleep(3000);

                driver.FindElement(deal.RSSDate).SendKeys("10/20/2023");
                Thread.Sleep(3000);

                driver.FindElement(deal.RSSValueType).Click();
                Thread.Sleep(3000);
                driver.FindElement(deal.RSSValueType).SendKeys("Spread");
                Thread.Sleep(3000);

                driver.FindElement(deal.RSSValue).Click();
                Thread.Sleep(3000);
                driver.FindElement(deal.RSSValue).SendKeys("1000");
                Thread.Sleep(3000);

                driver.FindElement(deal.RSSCalcMethod).Click();
                Thread.Sleep(3000);
                driver.FindElement(deal.RSSCalcMethod).SendKeys("Actual/360");
                Thread.Sleep(3000);

                driver.FindElement(deal.RSSRateOrSpreadToBeStripped).Click();
                Thread.Sleep(3000);
                driver.FindElement(deal.RSSRateOrSpreadToBeStripped).SendKeys("10");
                Thread.Sleep(3000);

                driver.FindElement(deal.RSSIndexName).Click();
                Thread.Sleep(3000);
                driver.FindElement(deal.RSSIndexName).SendKeys("SOFR");
                Thread.Sleep(3000);

                driver.FindElement(deal.RSSDeterminationDateHolidayList).Click();
                Thread.Sleep(3000);
                driver.FindElement(deal.RSSDeterminationDateHolidayList).SendKeys("US");
                Thread.Sleep(3000);

                driver.FindElement(deal.RSSDelete).Click();
                Thread.Sleep(5000);

                driver.FindElement(deal.DeletePopupCancelButton).Click();
                Thread.Sleep(3000);

                driver.FindElement(deal.DebtSave).Click();
                Thread.Sleep(1000);

                string LiabilityNoteSucessMessage01 = driver.FindElement(deal.sucessmessagediv).Text;
                Console.WriteLine("LiabilityNoteSucessMessage = " + LiabilityNoteSucessMessage01);
                bool LiabilityNoteSucessMessage = driver.FindElement(deal.sucessmessagediv).Displayed;
                Console.WriteLine("LiabilityNoteSucessMessage01 = " + LiabilityNoteSucessMessage);
                Thread.Sleep(10000);

                driver.FindElement(deal.searchBar).Click();
                driver.FindElement(deal.searchBar).SendKeys(LiabilityNote_Name);
                System.Threading.Thread.Sleep(5000);
                driver.FindElement(deal.DebtSearchedResult).Click();
                System.Threading.Thread.Sleep(25000);
                LiabilityNoteLabel = driver.FindElement(deal.LiabilityNoteLabel).Text.ToString();
                Console.WriteLine("liabilitynote = " + LiabilityNoteLabel);

                if (LiabilityNoteSucessMessage || LiabilityNoteLabel == "Note details: TBC Life Science\"" + LiabilityNote_Name)
                {

                    addtolist(4, "Liability Note", LiabilityNote_Name, Equity_Name, true, "");
                    test.Log(Status.Pass, LiabilityNoteLabel + " created successfully.");

                }
                else
                {
                    var printMessages = "<p><b>Test FAILED!</b></p>";
                    Console.WriteLine("Liability Note failed to create.");
                    addtolist(4, "Liability Note", LiabilityNote_Name, Equity_Name, false, "Liabiloty Note is not created");
                    test.Fail(printMessages);
                }
                System.Threading.Thread.Sleep(5000);

              }
              catch (Exception ex)
              {
                Console.WriteLine("Liability Note Exception = " + ex);
              }
            }
        
        public void LiabilityNoteDataValidation()
        {
            Console.WriteLine("You are in Liability Note Data Velidation method.");
            try
            {

                /*driver.FindElement(deal.searchBar).Click();
                driver.FindElement(deal.searchBar).SendKeys(LiabilityNote_Name);
                System.Threading.Thread.Sleep(5000);
                driver.FindElement(deal.DebtSearchedResult).Click();
                System.Threading.Thread.Sleep(25000);
                LiabilityNoteLabel = driver.FindElement(deal.LiabilityNoteLabel).Text.ToString();
                Console.WriteLine("liabilitynote = " + LiabilityNoteLabel);
                LiabilityNote_Name = "LN_EQ_22-2586_" + LiabilityFunctionalTest.Timestamp().ToString();*/

                driver.FindElement(deal.LiabilityNoteID).Click();
                liabilityNoteID = driver.FindElement(deal.LiabilityNoteID).GetAttribute("ng-reflect-model").ToString();
                Thread.Sleep(3000);


                liabilityID = driver.FindElement(By.XPath("//wj-auto-complete[@ng-reflect-placeholder='Type Liability ID']")).GetAttribute("ng-reflect-text").ToString();
                Thread.Sleep(3000);

                // LiabilityIdDropdown = driver.FindElement(deal.LiabilityIdDropdown).Text;
                //Thread.Sleep(3000);


                string AttributeValue = driver.FindElement(By.XPath("//select[@id='ddlAssetID']")).GetAttribute("ng-reflect-model");
                liabilityAssetID = driver.FindElement(By.XPath("//select[@id='ddlAssetID']//child::option[@ng-reflect-value='" + AttributeValue + "']")).Text;
                Thread.Sleep(3000);


                string AttributeValue02 = driver.FindElement(By.XPath("//select[@id='ddlStatus']")).GetAttribute("ng-reflect-model");
                liabilityStatus = driver.FindElement(By.XPath("//select[@id='ddlStatus']//child::option[@ng-reflect-value='" + AttributeValue02 + "']")).Text;
                Thread.Sleep(3000);

                string LargeDate = driver.FindElement(By.XPath("//wj-input-date[@name='PledgeDate']")).GetAttribute("ng-reflect-model");
                Console.WriteLine("liabilityPledgeDate  Date formate = " + LargeDate);
                var date = DateTime.ParseExact(LargeDate + "000 (GMT Standard Time)", "ddd MMM dd yyyy HH:mm:ss 'GMT+0000 (GMT Standard Time)'", CultureInfo.InvariantCulture);
                liabilityPledgeDate = date.ToString("MM/dd/yyyy");
                Console.WriteLine("liabilityPledgeDate = " + liabilityPledgeDate);

                /*string s = "Mon Jan 13 2014 00:00:00 GMT+0000 (GMT Standard Time)";
                var date01 = DateTime.ParseExact(s, "ddd MMM dd yyyy HH:mm:ss 'GMT+0000 (GMT Standard Time)'", CultureInfo.InvariantCulture);
                Console.WriteLine(date01.ToString("yyyy-MM-dd"));*/

                string val01 = driver.FindElement(By.XPath("//wj-input-number[@name='PaydownAdvanceRate']")).GetAttribute("ng-reflect-model").ToString();
                double temp = double.Parse(val01);
                liabilityPaydownAdvanceRate = temp * 100;
                Console.WriteLine("\nliabilityPaydownAdvanceRate = " + liabilityPaydownAdvanceRate);
                Thread.Sleep(3000);

                string val02 = driver.FindElement(By.XPath("//wj-input-number[@name='FundingAdvanceRate']")).GetAttribute("ng-reflect-model").ToString();
                liabilityFundingAdvanceRate = Convert.ToDouble(val02);
                liabilityFundingAdvanceRate = liabilityFundingAdvanceRate * 100;
                Console.WriteLine("\n liabilityFundingAdvanceRate = " + liabilityFundingAdvanceRate);
                Thread.Sleep(3000);

                string val03 = driver.FindElement(By.XPath("//wj-input-number[@name='TargetAdvanceRate']")).GetAttribute("ng-reflect-model").ToString();
                liabilityTargetAdvanceRate = Convert.ToDouble(val03);
                liabilityTargetAdvanceRate = liabilityTargetAdvanceRate * 100;
                Console.WriteLine("\n liabilityTargetAdvanceRate = " + liabilityTargetAdvanceRate);
                Thread.Sleep(3000);

                string LargeDate01 = driver.FindElement(By.XPath("//wj-input-date[@name='MaturityDate']")).GetAttribute("ng-reflect-model").ToString();
                Thread.Sleep(3000);
                Console.WriteLine("liabilityMaturityDate  Date formate = " + LargeDate01);
                var date01 = DateTime.ParseExact(LargeDate01 + "000 (GMT Standard Time)", "ddd MMM dd yyyy HH:mm:ss 'GMT+0000 (GMT Standard Time)'", CultureInfo.InvariantCulture);
                liabilityMaturityDate = date01.ToString("MM/dd/yyyy");
                Console.WriteLine("liabilityMaturityDate = " + liabilityMaturityDate);


                driver.FindElement(deal.RSSEffectiveDate).Click();
                string LargeDate02 = driver.FindElement(By.XPath("//wj-input-date[@name='LatestEffectiveDaterateSchedule']")).GetAttribute("ng-reflect-model").ToString();
                Thread.Sleep(3000);
                Console.WriteLine("rSSEffectiveDate  Date formate = " + LargeDate02);
                var date02 = DateTime.ParseExact(LargeDate02 + "000 (GMT Standard Time)", "ddd MMM dd yyyy HH:mm:ss 'GMT+0000 (GMT Standard Time)'", CultureInfo.InvariantCulture);
                rSSEffectiveDate = date02.ToString("MM/dd/yyyy");
                Console.WriteLine("rSSEffectiveDate = " + rSSEffectiveDate);

                rSSDate = driver.FindElement(deal.RSSDate).Text;
                Thread.Sleep(3000);

                driver.FindElement(deal.RSSValueType).Click();
                Thread.Sleep(3000);
                rSSValueType = driver.FindElement(deal.RSSValueType).Text;

                driver.FindElement(deal.RSSValue).Click();
                Thread.Sleep(3000);
                rSSValue = driver.FindElement(deal.RSSValue).Text;
                Thread.Sleep(3000);

                driver.FindElement(deal.RSSCalcMethod).Click();
                Thread.Sleep(3000);
                rSSCalcMethod = driver.FindElement(deal.RSSCalcMethod).Text;
                Thread.Sleep(3000);

                driver.FindElement(deal.RSSRateOrSpreadToBeStripped).Click();
                Thread.Sleep(3000);
                rSSRateOrSpreadToBeStripped = driver.FindElement(deal.RSSRateOrSpreadToBeStripped).Text;
                Thread.Sleep(3000);

                driver.FindElement(deal.RSSIndexName).Click();
                Thread.Sleep(3000);
                rSSIndexName = driver.FindElement(deal.RSSIndexName).Text;
                Thread.Sleep(3000);

                driver.FindElement(deal.RSSDeterminationDateHolidayList).Click();
                Thread.Sleep(3000);
                rSSDeterminationDateHolidayList = driver.FindElement(deal.RSSDeterminationDateHolidayList).Text;
                Thread.Sleep(3000);

                addtosheet(1, liabilityNoteID, liabilityID, liabilityAssetID, liabilityStatus, liabilityPledgeDate, liabilityPaydownAdvanceRate, liabilityFundingAdvanceRate, liabilityTargetAdvanceRate, liabilityMaturityDate, rSSEffectiveDate, rSSDate, rSSValueType, rSSValue, rSSCalcMethod, rSSRateOrSpreadToBeStripped, rSSIndexName, rSSDeterminationDateHolidayList);
                Console.WriteLine("\nColumns = " + num + " " + liabilityNoteID + " " + liabilityID + " " + liabilityAssetID + " " + liabilityStatus + " " + liabilityPledgeDate + " " + liabilityPaydownAdvanceRate + " " + liabilityFundingAdvanceRate + " " + liabilityTargetAdvanceRate + " " + liabilityMaturityDate + " " + rSSEffectiveDate + " " + rSSDate + " " + rSSValueType + " " + rSSValue + " " + rSSCalcMethod + " " + rSSRateOrSpreadToBeStripped + " " + rSSIndexName + " " + rSSDeterminationDateHolidayList);


                System.Threading.Thread.Sleep(5000);
            }

            catch (Exception ex)
            {
                Console.WriteLine("Liability Note Exception = " + ex);
            }

        }

            
        public void SendMail() 
        {
            Console.WriteLine("You are in SendMail method");
            LiabilityFunctionalTest.CreateExcelDataTableNew((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(liability), (typeof(DataTable))), "Liability Test Report");
            Thread.Sleep(3000);
            LiabilityFunctionalTest.VerifyEntityData((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(debtSheet), (typeof(DataTable))), "Liability Test Report", "LiabilityNote_Data");
            Thread.Sleep(7000);
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
                       // emailDC.Cc = "rsahu@hvantage.com,msingh@hvantage.com,ssingh@hvantage.com,vbalapure@hvantage.com,vandana@hvantage.com";
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
                driver.Quit();
                ExtentEnd();
            }
         }
        
        private string CreateExcelDataTableNew(string path)
        {
            throw new NotImplementedException();
        }
    }
}
