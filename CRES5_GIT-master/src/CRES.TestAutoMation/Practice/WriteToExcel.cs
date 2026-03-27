
using CRES.TestAutoMation.Pages;
using NUnit.Framework;
using NUnit.Framework.Internal;
using OpenQA.Selenium.Interactions;
using System;
using CRES.TestAutoMation.Utility;
using System.Collections.Generic;
using AventStack.ExtentReports;
using AventStack.ExtentReports.Model;
using CRES.DataContract;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System.Data;
using System.IO;
using Newtonsoft.Json;
using CRES.TestAutoMation.EmailTemplate;
using OpenQA.Selenium.Support.UI;
using OpenQA.Selenium;
using CRES.BusinessLogic;
using CRES.TestAutoMation.TestCases;
using Thread = System.Threading.Thread;
using String = System.String;
using Boolean = System.Boolean;
using Exception = System.Exception;
using System.Globalization;
using AngleSharp.Text;
using CRES.Utilities;
using jdk.nashorn.@internal.runtime;
using DocumentFormat.OpenXml.Wordprocessing;
using Microsoft.Office.Interop.Excel;
using DataTable = System.Data.DataTable;
using Actions = OpenQA.Selenium.Interactions.Actions;

namespace CRES.TestAutoMation.Practice
{
    public class WriteToExcel : BaseClass
    {
        ExtentTest test = null;
        SelectElement select;
        string debtName = null;
        string debtType = null;
        string debtStatus = null;
        static string indexReport = null;
        static string filePath = null;
        static IRow row;
        string Equity_Name = "Equity_Shan_01_09_2024_16_08_04";
        string Debt_Name = "Debt_Test_02_05_2024_17_41_51";
        string liabilitynote;
        string LiabilityNoteLabel;
        static String TimeStamp;
        static string time;
        static string BaseUrl;
        static string env;
        static ISheet excelSheet;
        string AttributeValue;

        int num; string liabilityNoteID; string liabilityID; 
        string liabilityAssetID; string liabilityStatus; string liabilityPledgeDate; double liabilityPaydownAdvanceRate; double liabilityFundingAdvanceRate; double liabilityTargetAdvanceRate; string liabilityMaturityDate; string rSSEffectiveDate; string rSSDate; string rSSValueType; string rSSValue; string rSSCalcMethod; string rSSRateOrSpreadToBeStripped; string rSSIndexName; string rSSDeterminationDateHolidayList;
        CultureInfo provider = CultureInfo.InvariantCulture;
        public WriteToExcel()
        {

        }


        Email SendEmail = new Email();
        List<Liabilitys> liability = new List<Liabilitys>();
        List<DebtSheet> debtSheet = new List<DebtSheet>();

        public static String Timestamp()
        {
            String timeStamp = Util.GetTimestamp(DateTime.Now);
            return timeStamp;
        }

        public void addtosheet(int Num, string LiabilityNoteID, string LiabilityID, string LiabilityAssetID, string LiabilityStatus, string LiabilityPledgeDate, double LiabilityPaydownAdvanceRate, double LiabilityFundingAdvanceRate, double LiabilityTargetAdvanceRate, string LiabilityMaturityDate, string RSSEffectiveDate,string RSSDate, string RSSValueType, string RSSValue, string RSSCalcMethod, string RSSRateOrSpreadToBeStripped, string RSSIndexName, string RSSDeterminationDateHolidayList)
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

        public void addtolist(int Num, string entityname, string entityid, string entitytype, Boolean res, string exception)
        {
            Liabilitys lbt = new Liabilitys();
            lbt.SrNo = Num;
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
                    Console.WriteLine("\nExcel sheet name = "+ excelSheet.Workbook.GetSheetName(1));

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
        
        public static void WriteToExcelDataTableNew(DataTable table, string FileName)
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

                    excelSheet = workbook.GetSheet("Liability_Summary") ?? workbook.CreateSheet("Liability_Summary");
                    Console.WriteLine("excelSheet = " + excelSheet);
                                       
                    IRow row = excelSheet.GetRow(7);

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

                    row = excelSheet.GetRow(7) ?? excelSheet.CreateRow(7);
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
                    excelSheet.GetRow(4).CreateCell(5).SetCellValue(env);
                    Console.WriteLine("row = " + excelSheet.GetRow(4));

                    // To insert updated data from 7th row.
                    int rowIndex = 7;
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
        public void FunctionalTest()
        {

            Actions actions = new Actions(driver);

            Login_Verification loginapp = new Login_Verification();
            Login login = new Login(driver);
            Deal deal = new Deal(driver);
            //CreateNewDeal createDeal = new CreateNewDeal(driver);
            Util util = new Util(driver);

            string dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
            // string username = BaseConfiguration.getusername();
            //string password = BaseConfiguration.getpassword();
            //string LoginUrl = BaseConfiguration.LoginUrl();

            string subLoginUrl;
            BaseUrl = null;
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
                
                    Console.WriteLine("You are in LiabilityNote Data Velidation method.");
                try
                {

                    driver.FindElement(deal.searchBar).Click();
                    driver.FindElement(deal.searchBar).SendKeys(Debt_Name);
                    System.Threading.Thread.Sleep(5000);
                    driver.FindElement(deal.DebtSearchedResult).Click();
                    System.Threading.Thread.Sleep(25000);
                    debtName = driver.FindElement(deal.DebtName).GetAttribute("ng-reflect-model");
                    Console.WriteLine("liabilitynote = " + LiabilityNoteLabel);


                    AttributeValue = driver.FindElement(deal.DebtType).GetAttribute("ng-reflect-model");
                    debtType = driver.FindElement(By.XPath("//select[@id='DebtType']//child::option[@value='" + AttributeValue + "']")).ToString();
                    Thread.Sleep(3000);


                    AttributeValue = driver.FindElement(deal.DebtStatus).GetAttribute("ng-reflect-model");
                    debtStatus = driver.FindElement(By.XPath("//select[@id='DebtStatus']//child::option[@value='" + AttributeValue + "']")).ToString();
                    Thread.Sleep(3000);

                    // LiabilityIdDropdown = driver.FindElement(deal.LiabilityIdDropdown).Text;
                    //Thread.Sleep(3000);


                    AttributeValue = driver.FindElement(By.XPath("//select[@id='ddlAssetID']")).GetAttribute("ng-reflect-model");
                    liabilityAssetID = driver.FindElement(By.XPath("//select[@id='ddlAssetID']//child::option[@ng-reflect-value='"+AttributeValue+"']")).Text;
                    Thread.Sleep(3000);


                    AttributeValue = driver.FindElement(By.XPath("//select[@id='ddlStatus']")).GetAttribute("ng-reflect-model");
                    liabilityStatus = driver.FindElement(By.XPath("//select[@id='ddlStatus']//child::option[@ng-reflect-value='"+AttributeValue+"']")).Text;
                    Thread.Sleep(3000);

                    string LargeDate = driver.FindElement(By.XPath("//wj-input-date[@name='PledgeDate']")).GetAttribute("ng-reflect-model");
                    Console.WriteLine("liabilityPledgeDate  Date formate = " + LargeDate);
                    var date = DateTime.ParseExact(LargeDate + "000 (GMT Standard Time)", "ddd MMM dd yyyy HH:mm:ss 'GMT+0000 (GMT Standard Time)'", CultureInfo.InvariantCulture);
                    liabilityPledgeDate = date.ToString("MM/dd/yyyy");
                    Console.WriteLine("liabilityPledgeDate = "+ liabilityPledgeDate);

                    /*string s = "Mon Jan 13 2014 00:00:00 GMT+0000 (GMT Standard Time)";
                    var date01 = DateTime.ParseExact(s, "ddd MMM dd yyyy HH:mm:ss 'GMT+0000 (GMT Standard Time)'", CultureInfo.InvariantCulture);
                    Console.WriteLine(date01.ToString("yyyy-MM-dd"));*/

                    string val01 = driver.FindElement(By.XPath("//wj-input-number[@name='PaydownAdvanceRate']")).GetAttribute("ng-reflect-model").ToString();
                    double temp = double.Parse(val01);
                    liabilityPaydownAdvanceRate = temp * 100;                    
                    Console.WriteLine("\nliabilityPaydownAdvanceRate = " + liabilityPaydownAdvanceRate);
                    Thread.Sleep(3000);
                    
                    string val02 =  driver.FindElement(By.XPath("//wj-input-number[@name='FundingAdvanceRate']")).GetAttribute("ng-reflect-model").ToString();
                    liabilityFundingAdvanceRate = Convert.ToDouble(val02);
                    liabilityFundingAdvanceRate = liabilityFundingAdvanceRate * 100;
                    Console.WriteLine("\n liabilityFundingAdvanceRate = " + liabilityFundingAdvanceRate);
                    Thread.Sleep(3000);

                    string val03  = driver.FindElement(By.XPath("//wj-input-number[@name='TargetAdvanceRate']")).GetAttribute("ng-reflect-model").ToString();
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

                    addtosheet( 1, liabilityNoteID,  liabilityID,  liabilityAssetID,  liabilityStatus,  liabilityPledgeDate,  liabilityPaydownAdvanceRate,  liabilityFundingAdvanceRate,  liabilityTargetAdvanceRate,  liabilityMaturityDate, rSSEffectiveDate, rSSDate, rSSValueType, rSSValue, rSSCalcMethod, rSSRateOrSpreadToBeStripped, rSSIndexName, rSSDeterminationDateHolidayList);
                    Console.WriteLine("\nColumns = " + num +" " + liabilityNoteID + " " + liabilityID + " " + liabilityAssetID + " " + liabilityStatus + " " + liabilityPledgeDate + " " + liabilityPaydownAdvanceRate + " " + liabilityFundingAdvanceRate + " " + liabilityTargetAdvanceRate + " " + liabilityMaturityDate + " " + rSSEffectiveDate + " " + rSSDate + " " + rSSValueType + " " + rSSValue + " " + rSSCalcMethod + " " + rSSRateOrSpreadToBeStripped + " " + rSSIndexName + " " + rSSDeterminationDateHolidayList);
                                      

                    System.Threading.Thread.Sleep(5000);
                }

                catch (Exception ex)
                {
                    Console.WriteLine("Liability Note Exception = " + ex);
                }
                

                //..............................................................................


            }
            else
            {
                Console.WriteLine("Login failed");
              
            }

            WriteToExcel.VerifyEntityData((System.Data.DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(debtSheet), (typeof(DataTable))), "Liability Test Report", "Debt_Data");
            //WriteToExcel.WriteToExcelDataTableNew((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(liability), (typeof(DataTable))), "Liability Test Report");

            

                //............................. Email attachment ........................                  

                string sendValidationReportEmail = BaseConfiguration.SendValidationReportEmail();
                if (sendValidationReportEmail.ToString().ToLower() == "yes")
                {
                    try
                    {

                        string loggedInUserName = util.GetLoggedInUserName();
                        test.Log(Status.Info, "Email sent with Liability report attached file.");
                        test.Log(Status.Info, "Ran By: " + loggedInUserName);                             // Email check point


                        if (sendValidationReportEmail.ToString().ToLower() == "yes")
                        {
                            Console.WriteLine("\nsend Merge all files mail");
                            EmailDataContract emailDC = new EmailDataContract();
                            emailDC.To = "shantanu@hvantage.com";
                            //emailDC.Cc = "rsahu@hvantage.com,msingh@hvantage.com,ssingh@hvantage.com,vbalapure@hvantage.com";
                            //optional
                            //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
                            //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
                            emailDC.ReceiverName = "All";
                            emailDC.FileAttachment = new List<FileAttachmentDataContract>();
                            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = filePath });
                            Console.WriteLine("attached file = " + filePath);
                            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = indexReport + "\\index.html" });
                            emailDC.Subject = "Liability Functional test report";
                            emailDC.Body = "PFA the Liability Functional test report.";
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

        public object GetFormat(Type formatType)
        {
            throw new NotImplementedException();
        }
    }
}
