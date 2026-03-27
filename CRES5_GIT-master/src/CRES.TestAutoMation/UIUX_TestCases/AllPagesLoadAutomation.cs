using AventStack.ExtentReports;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.EmailTemplate;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using OpenQA.Selenium;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using Newtonsoft.Json;
using CRES.TestAutoMation;
using System.Data;
//using com.sun.tools.@internal.ws.processor.model;
using OpenQA.Selenium.Interactions;
using System.Data;
using CRES.TestAutoMation.TestCases;
using System;
using System.Threading;
using System.Collections.Generic;
using System.IO;
using NUnit.Framework;
//using java.nio.file;

namespace CRES.TestAutoMation.UIUX_TestCases
{
    [Category("Regression")]
    internal class AllPagesLoadAutomation : BaseClass
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
        public static void CreateExcelDataTableNew(DataTable table, string FileName)
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
                    Console.WriteLine("\nEvironment Name= " + env);
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

        [Test]
        public void DealDataVerification()
        {

            Actions actions = new Actions(driver);

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

                        for (int i = 0; i < 10; i++)
                        {
                            driver.FindElement(deal.LeftArrow).Click();
                            Thread.Sleep(1000);
                        }


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

                    //......................................Funding Tab....................


                    try
                    {
                        deal.ClickFunding();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Funding Tab exception = " + e);

                    }
                    Thread.Sleep(3000);

                    bool FundingRuleDisplay = false;


                    try
                    {
                        FundingRuleDisplay = driver.FindElement(deal.FundingRule).Displayed;
                        Console.WriteLine("Funding Rule = " + FundingRuleDisplay);
                        


                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (FundingRuleDisplay == false)
                        {
                            printMessage += $"Message: <br>{"Funding Tab Load Error"}<br>";
                            addtolist(2, "deal", "Funding", FundingRuleDisplay, "");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Funding Tab loaded sucessfully");
                            addtolist(2, "deal", "Funding", FundingRuleDisplay, "");
                        }


                    }

                    catch (Exception ex)
                    {
                        FundingRuleDisplay = false;
                        addtolist(2, "deal", "Funding", FundingRuleDisplay, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;

                    }
                    Thread.Sleep(3000);

                    //......................................Liabilty Tab....................


                    try
                    {
                        driver.FindElement(deal.LiabiltyTab).Click();
                        Thread.Sleep(3000);

                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Liability Tab exception = " + e);

                    }
                    Thread.Sleep(3000);

                    bool DealLiabilitysetup = false;
                    bool AddLiabutton = false;


                    try
                    {
                        DealLiabilitysetup = driver.FindElement(deal.DealLiabilitySetup).Displayed;
                        Console.WriteLine("Liability Page  = " + FundingRuleDisplay);
                        


                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (DealLiabilitysetup == false)
                        {
                            printMessage += $"Message: <br>{"Liability Tab Load Error"}<br>";
                            addtolist(3, "deal", "Liability", DealLiabilitysetup, "");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Liability Tab loaded sucessfully");
                            addtolist(3, "deal", "Liability", DealLiabilitysetup, "");
                        }


                    }

                    catch (Exception ex)
                    {
                        DealLiabilitysetup = false;
                        AddLiabutton = false;
                        addtolist(3, "deal", "Liability", DealLiabilitysetup, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;

                    }
                    Thread.Sleep(10000);

                    //......................................Liabilty Draws & Paydowns Tab....................


                    try
                    {
                        driver.FindElement(deal.LiaDrawNPay).Click();
                        Thread.Sleep(3000);

                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Liability Draws & Paydowns Tab exception = " + e);

                    }
                    Thread.Sleep(3000);

                    bool LiabilityDrawnPaydown = false;


                    try
                    {
                        LiabilityDrawnPaydown = driver.FindElement(deal.LiaDrawnPaydown).Displayed;
                        Console.WriteLine("Liability Draws & Paydowns Tab  = " + LiabilityDrawnPaydown);
                        


                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (LiabilityDrawnPaydown == false)
                        {
                            printMessage += $"Message: <br>{"Liability Draws & Paydowns Tab Load Error"}<br>";
                            addtolist(4, "deal", "Liability Draws & Paydowns Tab", LiabilityDrawnPaydown,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Liability Draws & Paydowns Tab loaded sucessfully");

                            addtolist(4, "deal", "Liability Draws & Paydowns Tab", LiabilityDrawnPaydown, "");
                        }


                    }

                    catch (Exception ex)
                    {
                        LiabilityDrawnPaydown = false;

                        addtolist(4, "deal", "Liability Draws & Paydowns Tab", LiabilityDrawnPaydown, ex.ToString());
                        Console.WriteLine("Liability Draws & Paydowns Tab =" + ex.ToString());

                    }
                    Thread.Sleep(3000);


                    //......................................Liabilty Cashflow Tab....................


                    try
                    {
                        driver.FindElement(deal.LiaCashflowTab).Click();
                        Thread.Sleep(3000);

                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Liability Cashflow Tab exception = " + e);

                    }
                    Thread.Sleep(3000);

                    bool LiacashflowTab = false;


                    try
                    {
                        LiacashflowTab = driver.FindElement(deal.LiaCashflowTab).Displayed;
                        Console.WriteLine("Liability Cashflow Tab  = " + LiacashflowTab);
                        



                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (LiacashflowTab == false)
                        {
                            printMessage += $"Message: <br>{"Liability Cashflow Tab Load Error"}<br>";
                            addtolist(5, "deal", "Liability Cashflow Tab", LiacashflowTab,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Liability Cashflow Tab loaded sucessfully");
                            addtolist(5, "deal", "Liability Cashflow Tab", LiacashflowTab, "");
                        }


                    }

                    catch (Exception ex)
                    {
                        LiacashflowTab = false;
                        addtolist(5, "deal", "Liability Cashflow Tab", LiacashflowTab, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;

                    }
                    Thread.Sleep(3000);

                    //...................Commitement/Equity tab...................

                    try
                    {
                        driver.FindElement(deal.totalCommitementTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Commitement/Equity tab = " + e);
                    }
                    Thread.Sleep(3000);
                    bool CommitmentCheck = false;
                    try
                    {
                        CommitmentCheck = driver.FindElement(By.Id("anchortag-Commitment")).Displayed;

                        Console.WriteLine("Commitement/Equityt check  = " + CommitmentCheck);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (CommitmentCheck == false)
                        {
                            printMessage += $"Message: <br>{"Commitement/Equity Tab Load Error"}<br>";
                            addtolist(6, "deal", "Commitement/Equity ", CommitmentCheck,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Commitement/Equity Tab loaded sucessfully");
                            addtolist(6, "deal", "Commitement/Equity ", CommitmentCheck, "");
                        }
                        Thread.Sleep(3000);

                    }
                    catch (Exception ex)
                    {
                        CommitmentCheck = false;
                        addtolist(6, "deal", "Commitement/Equity ", CommitmentCheck, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }


                    //......................................Reserves Tab....................


                    try
                    {
                        driver.FindElement(deal.Reserves).Click();
                        Thread.Sleep(3000);

                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Reserves Tab exception = " + e);

                    }
                    Thread.Sleep(3000);

                    bool Reservesaccount = false;
                    try
                    {
                        Reservesaccount = driver.FindElement(deal.ReservesAccount).Displayed;
                        Console.WriteLine("Reserves Page  = " + Reservesaccount);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (Reservesaccount == false)
                        {
                            printMessage += $"Message: <br>{"Reserves Tab Load Error"}<br>";
                            addtolist(7, "deal", "Reserves", Reservesaccount,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Reserves Tab loaded sucessfully");
                            addtolist(7, "deal", "Reserves", Reservesaccount, "");
                        }


                    }

                    catch (Exception ex)
                    {
                        Reservesaccount = false;
                        addtolist(7, "deal", "Reserves", Reservesaccount, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;

                    }
                    Thread.Sleep(3000);


                    //......................................Invoice Tab....................


                    try
                    {
                        driver.FindElement(deal.Invoice).Click();
                        Thread.Sleep(3000);

                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Invoice Tab exception = " + e);

                    }
                    Thread.Sleep(3000);

                    bool InvoicePage = false;



                    try
                    {
                        InvoicePage = driver.FindElement(deal.InvoiceHeading).Displayed;
                        Console.WriteLine("Invoice Page  = " + InvoicePage);
                        

                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (InvoicePage == false)
                        {
                            printMessage += $"Message: <br>{"Invoice Tab Load Error"}<br>";
                            addtolist(8, "deal", "Invoice", InvoicePage,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Invoice Tab loaded sucessfully");
                            addtolist(8, "deal", "Invoice", InvoicePage, "");
                        }


                    }

                    catch (Exception ex)
                    {
                        InvoicePage = false;
                        addtolist(8, "deal", "Invoice", InvoicePage,ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;

                    }
                    Thread.Sleep(3000);

                    //..............................PayRules.......................

                    try
                    {

                        driver.FindElement(deal.payRuleTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("PayRules Tab Exception = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);

                    bool PayrulePage = false;
                    try
                    {
                        PayrulePage = driver.FindElement(deal.payrulePage).Displayed;

                        Console.WriteLine("Payrul NoteID  = " + PayrulePage);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (PayrulePage == false)
                        {
                            printMessage += $"Message: <br>{"Payrules Page Load Error"}<br>";
                            addtolist(9, "deal", "Pay Rules", PayrulePage,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Payrules page loaded sucessfully");
                            addtolist(9, "deal", "Pay Rules", PayrulePage, "");
                        }

                    }
                    catch (Exception ex)
                    {
                        PayrulePage = false;
                        addtolist(9, "deal", "Pay Rules", PayrulePage, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }


                    //......................................Maturity Tab....................


                    try
                    {
                        driver.FindElement(deal.Maturity).Click();
                        Thread.Sleep(3000);

                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Maturity Tab exception = " + e);

                    }
                    Thread.Sleep(3000);

                    bool InvoiMaturityconfigcePage = false;



                    try
                    {
                        InvoiMaturityconfigcePage = driver.FindElement(deal.MaturityHeading).Displayed;
                        Console.WriteLine("Maturity Page  = " + InvoiMaturityconfigcePage);
                        

                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (InvoiMaturityconfigcePage == false)
                        {
                            printMessage += $"Message: <br>{"Maturity Tab Load Error"}<br>";
                            addtolist(10, "deal", "Maturity", InvoiMaturityconfigcePage,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Maturity Tab loaded sucessfully");
                            addtolist(10, "deal", "Maturity", InvoiMaturityconfigcePage, "");
                        }


                    }

                    catch (Exception ex)
                    {
                        InvoiMaturityconfigcePage = false;
                        addtolist(10, "deal", "Maturity", InvoiMaturityconfigcePage, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;

                    }
                    Thread.Sleep(3000);


                    for (int i = 0; i < 10; i++)
                    {
                        driver.FindElement(deal.RightArrow).Click();
                        Thread.Sleep(1000);
                    }

                    //......................................Deal's Accounting Close Tab....................


                    try
                    {
                        driver.FindElement(deal.DealAccClose).Click();
                        Thread.Sleep(3000);

                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Deal's Accounting Close Tab exception = " + e);

                    }
                    Thread.Sleep(3000);

                    bool accountingCloseText = false;

                    try
                    {
                        accountingCloseText = driver.FindElement(deal.AccountingCloseText).Displayed;
                        Console.WriteLine("Deal's Accounting Close  = " + accountingCloseText);
                        

                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (accountingCloseText == false)
                        {
                            printMessage += $"Message: <br>{"Deal's Accounting Close Tab Load Error"}<br>";
                            addtolist(11, "deal", "Deal's Accounting Close", accountingCloseText,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Deal's Accounting Close Tab loaded sucessfully");
                            addtolist(11, "deal", "Deal's Accounting Close", accountingCloseText, "");
                        }


                    }

                    catch (Exception ex)
                    {
                        accountingCloseText = false;
                        addtolist(11, "deal", "Deal's Accounting Close", accountingCloseText, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;

                    }
                    Thread.Sleep(3000);


                    //......................................Distressed Tab....................


                    try
                    {
                        driver.FindElement(deal.SpecialServicing).Click();
                        Thread.Sleep(3000);

                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Distressed Tab exception = " + e);

                    }
                    Thread.Sleep(3000);

                    bool AccountingBasisHeading = false;



                    try
                    {
                        AccountingBasisHeading = driver.FindElement(deal.AccountingBasis).Displayed;
                        Console.WriteLine("Distressed Tab  = " + AccountingBasisHeading);
                        

                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (AccountingBasisHeading == false)
                        {
                            printMessage += $"Message: <br>{"Distressed Tab Load Error"}<br>";
                            addtolist(12, "deal", "Distressed Tab", AccountingBasisHeading,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Distressed Tab loaded sucessfully");
                            addtolist(12, "deal", "Distressed Tab", AccountingBasisHeading, "");
                        }


                    }

                    catch (Exception ex)
                    {
                        AccountingBasisHeading = false;
                        addtolist(12, "deal", "Distressed Tab", AccountingBasisHeading,ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;

                    }
                    Thread.Sleep(3000);


                    //......................................XIRR Tab....................


                    try
                    {
                        driver.FindElement(deal.Xirr).Click();
                        Thread.Sleep(3000);

                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("XIRR Tab exception = " + e);

                    }
                    Thread.Sleep(3000);

                    bool XirrHeading = false;



                    try
                    {
                        XirrHeading = driver.FindElement(deal.XirrHeading).Displayed;
                        Console.WriteLine("XIRR Tab  = " + XirrHeading);
                        


                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (XirrHeading == false)
                        {
                            printMessage += $"Message: <br>{"XIRR Tab Load Error"}<br>";
                            addtolist(12, "deal", "XIRR Tab", XirrHeading,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "XIRR Tab loaded sucessfully");
                            addtolist(12, "deal", "XIRR Tab", XirrHeading, "");
                        }


                    }

                    catch (Exception ex)
                    {
                        XirrHeading = false;
                        addtolist(12, "deal", "XIRR Tab", XirrHeading,ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;

                    }
                    Thread.Sleep(3000);



                    //......................................Rules Tab....................


                    try
                    {
                        driver.FindElement(deal.Rules).Click();
                        Thread.Sleep(3000);

                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Rules Tab exception = " + e);

                    }
                    Thread.Sleep(3000);

                    bool rulesTab = false;

                    try
                    {
                        rulesTab = driver.FindElement(deal.RulesTab).Displayed;
                        Console.WriteLine("Rules Tab  = " + rulesTab);
                        

                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (rulesTab == false)
                        {
                            printMessage += $"Message: <br>{"Rules Tab Load Error"}<br>";
                            addtolist(13, "deal", "Rules Tab", rulesTab,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Rules Tab loaded sucessfully");
                            addtolist(13, "deal", "Rules Tab", rulesTab, "");
                        }


                    }

                    catch (Exception ex)
                    {
                        rulesTab = false;
                        addtolist(13, "deal", "Rules Tab", rulesTab, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;

                    }
                    Thread.Sleep(3000);



                    //.........................Documents..............................


                    try
                    {
                        driver.FindElement(deal.documentsTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Documents tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    bool DocumentsCheck = false;
                    try
                    {

                        DocumentsCheck = driver.FindElement(deal.documentCheckElement).Displayed;

                        Console.WriteLine("Documents check  = " + DocumentsCheck);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (DocumentsCheck == false)
                        {
                            printMessage += $"Message: <br>{"Documents Page Load Error"}<br>";
                            addtolist(14, "deal", "Documents ", DocumentsCheck,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Documents page loaded sucessfully");
                            addtolist(14, "deal", "Documents ", DocumentsCheck, "");
                        }
                    }
                    catch (Exception ex)
                    {

                        DocumentsCheck = false;
                        addtolist(14, "deal", "Documents ", DocumentsCheck, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }
                    System.Threading.Thread.Sleep(3000);


                    //..............................ActivityTab..................
                    try
                    {
                        driver.FindElement(deal.activityTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("ActivityTab tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    bool ActivityCheck = false;
                    try
                    {
                        ActivityCheck = driver.FindElement(deal.activityCheckElement).Displayed;

                        Console.WriteLine("Activity check  = " + ActivityCheck);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (ActivityCheck == false)
                        {
                            printMessage += $"Message: <br>{"Activity Page Load Error"}<br>";
                            addtolist(15, "deal", "Activity ", ActivityCheck,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Activity page loaded sucessfully");
                            addtolist(15, "deal", "Activity ", ActivityCheck, "");
                        }
                    }
                    catch (Exception ex)
                    {

                        ActivityCheck = false;
                        addtolist(15, "deal", "Activity ", ActivityCheck,ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }
                    System.Threading.Thread.Sleep(3000);



                    //----------------------Note Details Verification---------------------------

                    string NoteUrl = BaseUrl + "#/notedetail/a0dce04e-10ac-4dda-961b-aeeb33346279";
                    util.OpenUrl(NoteUrl);
                    System.Threading.Thread.Sleep(3000);


                    //...................................InvestorPricing Tab.................................


                    try
                    {
                        driver.FindElement(deal.InvestorPricing).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("InvestorPricing Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    bool InvesotDetails = false;
                    try
                    {
                        InvesotDetails = driver.FindElement(deal.InvestorDetails).Displayed;

                        Console.WriteLine("InvestorPricing Element   = " + InvesotDetails);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (InvesotDetails == false)
                        {
                            printMessage += $"Message: <br>{"InvestorPricing Tab load Error"}<br>";
                            addtolist(21, "Note ", "InvestorPricing Tab ", InvesotDetails,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "InvestorPricing tab loaded sucessfully");
                            addtolist(21, "Note ", "InvestorPricing Tab ", InvesotDetails, "");
                        }
                    }
                    catch (Exception ex)
                    {
                        InvesotDetails = false;
                        addtolist(21, "Note ", "InvestorPricing Tab ", InvesotDetails, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }
                    System.Threading.Thread.Sleep(3000);


                    //.......................Note Commitment-tab.......................


                    try
                    {
                        driver.FindElement(deal.NoteCommitmenttab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("AccountingTab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    bool CommitmentElement = false;
                    try
                    {
                        CommitmentElement = driver.FindElement(deal.CommitmentElement).Displayed;

                        Console.WriteLine("Client Element    = " + CommitmentElement);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (CommitmentElement == false)
                        {
                            printMessage += $"Message: <br>{"NoteCommitmenttab Page Load Error"}<br>";
                            addtolist(22, "Note ", "NoteCommitmenttab Tab ", CommitmentElement,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "NoteCommitmenttab loaded sucessfully");
                            addtolist(22, "Note ", "NoteCommitmenttab Tab ", CommitmentElement, "");
                        }
                    }
                    catch (Exception ex)
                    {

                        CommitmentElement = false;
                        addtolist(22, "Note ", "NoteCommitmenttab Tab ", CommitmentElement,ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }


                    //........................Funding-tab.......................


                    try
                    {
                        driver.FindElement(deal.noteFundingtab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("noteFunding Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    bool financingFacElmnt = false;
                    try
                    {
                        financingFacElmnt = driver.FindElement(deal.fundingElmnt).Displayed;

                        Console.WriteLine(" noteFunding tab element    = " + financingFacElmnt);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (financingFacElmnt == false)
                        {
                            printMessage += $"Message: <br>{"noteFunding tab Load Error"}<br>";
                            addtolist(23, "Note ", "noteFunding Tab ", financingFacElmnt,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "noteFunding tab loaded sucessfully");
                            addtolist(23, "Note ", "noteFunding Tab ", financingFacElmnt, "");
                        }
                    }
                    catch (Exception ex)
                    {
                        financingFacElmnt = false;
                        addtolist(23, "Note ", "noteFunding Tab ", financingFacElmnt, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }


                    //..........................noteInterest-tab...................


                    try
                    {
                        driver.FindElement(deal.noteInteresttab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("noteInterest Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    bool InterestGeneralTermElmnt = false;
                    try
                    {
                        InterestGeneralTermElmnt = driver.FindElement(deal.InterestGeneralTerm).Displayed;

                        Console.WriteLine(" noteInterest Element   = " + InterestGeneralTermElmnt);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (InterestGeneralTermElmnt == false)
                        {
                            printMessage += $"Message: <br>{"noteInterest tab Load Error"}<br>";
                            addtolist(24, "Note ", "noteInterest Tab ", InterestGeneralTermElmnt,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "noteInterest tab loaded sucessfully");
                            addtolist(24, "Note ", "noteInterest Tab ", InterestGeneralTermElmnt, "");
                        }
                    }
                    catch (Exception ex)
                    {
                        InterestGeneralTermElmnt = false;
                        addtolist(24, "Note ", "noteInterest Tab ", InterestGeneralTermElmnt, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }


                    //...........................PIK Tab...................


                    try
                    {
                        driver.FindElement(deal.PIKtab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("PIK Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    bool PikScheduleElmnt = false;
                    try
                    {
                        PikScheduleElmnt = driver.FindElement(deal.PikScheduleElmnt).Displayed;

                        Console.WriteLine(" Effective Date Element  = " + PikScheduleElmnt);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (PikScheduleElmnt == false)
                        {
                            printMessage += $"Message: <br>{"PIK-tab Load Error"}<br>";
                            addtolist(25, "Note ", "PIK Tab ", PikScheduleElmnt,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "PIK-tab loaded sucessfully");
                            addtolist(25, "Note ", "PIK Tab ", PikScheduleElmnt, "");
                        }
                    }
                    catch (Exception ex)
                    {
                        PikScheduleElmnt = false;
                        addtolist(25, "Note ", "PIK Tab ", PikScheduleElmnt,ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }


                    //......................Amortization Tab..................


                    try
                    {
                        driver.FindElement(deal.Amortizationtab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Amortization Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    bool AmortizationElmnt = false;
                    try
                    {
                        AmortizationElmnt = driver.FindElement(deal.AmortizationElmnt).Displayed;

                        Console.WriteLine(" Amortization Name Element   = " + AmortizationElmnt);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (AmortizationElmnt == false)
                        {
                            printMessage += $"Message: <br>{"Amortization-tab Load Error"}<br>";
                            addtolist(26, "Note ", "Amortization Tab ", AmortizationElmnt,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Amortization-tab loaded sucessfully");
                            addtolist(26, "Note ", "Amortization Tab ", AmortizationElmnt, "");
                        }
                    }
                    catch (Exception ex)
                    {
                        AmortizationElmnt = false;
                        addtolist(26, "Note ", "Amortization Tab ", AmortizationElmnt, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;

                    }

                    //......................Fee Tab..................


                    try
                    {
                        driver.FindElement(deal.Feetab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Fee Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    bool FeeElmnt = false;
                    try
                    {
                        FeeElmnt = driver.FindElement(deal.FeeScheduleElem).Displayed;

                        Console.WriteLine(" Fee Name Element   = " + FeeElmnt);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (FeeElmnt == false)
                        {
                            printMessage += $"Message: <br>{"Fee-tab Load Error"}<br>";
                            addtolist(26, "Note ", "Fee Tab ", FeeElmnt,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Fee-tab loaded sucessfully");
                            addtolist(26, "Note ", "Fee Tab ", FeeElmnt, "");
                        }
                    }
                    catch (Exception ex)
                    {
                        FeeElmnt = false;
                        addtolist(26, "Note ", "Fee Tab ", FeeElmnt, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;

                    }


                    //......................Maturity Tab..................


                    try
                    {
                        driver.FindElement(deal.maturitytab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Maturity Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    bool MaturityElmnt = false;
                    try
                    {
                        MaturityElmnt = driver.FindElement(deal.maturityElem).Displayed;

                        Console.WriteLine(" Maturity Name Element   = " + MaturityElmnt);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (MaturityElmnt == false)
                        {
                            printMessage += $"Message: <br>{"Maturity-tab Load Error"}<br>";
                            addtolist(26, "Note ", "Maturity Tab ", MaturityElmnt,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Maturity-tab loaded sucessfully");
                            addtolist(26, "Note ", "Maturity Tab ", MaturityElmnt, "");
                        }
                    }
                    catch (Exception ex)
                    {
                        MaturityElmnt = false;
                        addtolist(26, "Note ", "Maturity Tab ", MaturityElmnt, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;

                    }

                    for (int i = 0; i<8;i++)
                    {
                        actions.KeyDown(Keys.ArrowDown).Build().Perform();
                        actions.KeyUp(Keys.ArrowDown).Build().Perform();
                        actions.KeyDown(Keys.ArrowDown).Build().Perform();
                        actions.KeyUp(Keys.ArrowDown).Build().Perform();
                        actions.KeyDown(Keys.ArrowDown).Build().Perform();
                        actions.KeyUp(Keys.ArrowDown).Build().Perform();
                        actions.KeyDown(Keys.ArrowDown).Build().Perform();
                        actions.KeyUp(Keys.ArrowDown).Build().Perform();
                    }
                    Thread.Sleep(1000);
                    //......................Actuals Tab....................

                    try
                    {
                        driver.FindElement(deal.actualsTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Actuals Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    bool ServicingDropDate = false;
                    try
                    {
                        ServicingDropDate = driver.FindElement(deal.ServicingDropDate).Displayed;

                        Console.WriteLine(" Interest Element    = " + ServicingDropDate);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (ServicingDropDate == false)
                        {
                            printMessage += $"Message: <br>{"Actuals Page Load Error"}<br>";
                            addtolist(27, "Note ", "Actuals Tab ", ServicingDropDate, "");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Actuals loaded sucessfully");
                            addtolist(27, "Note ", "Actuals Tab ", ServicingDropDate, "");
                        }
                    }
                    catch (Exception ex)
                    {
                        ServicingDropDate = false;
                        addtolist(27, "Note ", "Actuals Tab ", ServicingDropDate, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }

                    //..............................Defualt Tab...................


                    try
                    {
                        driver.FindElement(deal.NoteDefaultTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Defualt Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    //bool UPBAtForeclosure = false;
                    bool NoteDefaultTab = false;
                    try
                    {
                        // UPBAtForeclosure = driver.FindElement(deal.UPBAtForeclosure).Displayed;
                        NoteDefaultTab = driver.FindElement(deal.NoteDefaultTab).Displayed;
                        Console.WriteLine(" Defualt source element    = " + NoteDefaultTab);
                        

                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (NoteDefaultTab == false)
                        {
                            printMessage += $"Message: <br>{"Defualt tab Load Error"}<br>";
                            addtolist(28, "Note ", "Defualt Tab ", NoteDefaultTab, "");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Defualt tab loaded sucessfully");
                            addtolist(28, "Note ", "Defualt Tab ", NoteDefaultTab, "");
                        }
                    }
                    catch (Exception ex)
                    {
                        NoteDefaultTab = false;
                        addtolist(28, "Note ", "Defualt Tab ", NoteDefaultTab, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }



                    //.......................Cashflow Tab...................


                    try
                    {
                        driver.FindElement(deal.cashflowTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Cashflow Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    // bool periodicOtpButton = false;
                    bool cashflowTab = false;
                    try
                    {
                        // periodicOtpButton = driver.FindElement(deal.periodicOtpButton).Displayed;
                        cashflowTab = driver.FindElement(deal.cashflowTab).Displayed;
                        Console.WriteLine(" Cashflow Element    = " + cashflowTab);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (cashflowTab == false)
                        {
                            printMessage += $"Message: <br>{"Cashflow Page Load Error"}<br>";
                            addtolist(31, "Note ", "Cashflow Tab ", cashflowTab, "");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Cashflow funding loaded sucessfully");
                            addtolist(31, "Note ", "Cashflow Tab ", cashflowTab, "");
                        }
                    }
                    catch (Exception ex)
                    {

                        cashflowTab = false;
                        addtolist(31, "Note ", "Cashflow Tab ", cashflowTab, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }


                    //.......................Note Rules Tab...................


                    try
                    {
                        driver.FindElement(deal.NoteRules).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Note Rules Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);

                    //bool NoteRulesHeading = false;
                    bool ResetBtn = false;

                    try
                    {
                        //NoteRulesHeading = driver.FindElement(deal.NoteRulesHeading).Displayed;
                        ResetBtn = driver.FindElement(deal.RulesRestButton).Displayed;
                        Console.WriteLine(" Note Rules Element    = " + ResetBtn);
                        

                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (ResetBtn == false)
                        {
                            printMessage += $"Message: <br>{"Note Rules Page Load Error"}<br>";
                            addtolist(32, "Note ", "Rules Tab ", ResetBtn, "");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Note Rules loaded sucessfully");
                            addtolist(32, "Note ", "Rules Tab ", ResetBtn, "");
                        }
                    }
                    catch (Exception ex)
                    {

                        ResetBtn = false;
                        addtolist(32, "Note ", "Rules Tab ", ResetBtn, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }


                    //................................Exceptions Tab..................


                    try
                    {
                        driver.FindElement(deal.exceptionTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Exceptions Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    //bool exceptionElement = false;
                    bool exceptionTab = false;
                    try
                    {
                        //exceptionElement = driver.FindElement(deal.exceptionElement).Displayed;
                        exceptionTab = driver.FindElement(deal.exceptionTab).Displayed;
                        Console.WriteLine(" Exception Element    = " + exceptionTab);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (exceptionTab == false)
                        {
                            printMessage += $"Message: <br>{"Exception Page Load Error"}<br>";
                            addtolist(33, "Note ", "Exception Tab ", exceptionTab, "");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Exception funding loaded sucessfully");
                            addtolist(33, "Note ", "Exception Tab ", exceptionTab, "");
                        }
                    }
                    catch (Exception ex)
                    {
                        exceptionTab = false;
                        addtolist(33, "Note ", "Exception Tab ", exceptionTab, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }


                    //...........................Notes Document Tab.....................


                    /*try
                    {
                        driver.FindElement(deal.noteDocTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Notes Document Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    //bool noteDocTabElmnt = false;
                    bool noteUploadedDoc = false;
                    try
                    {
                        //noteDocTabElmnt = driver.FindElement(deal.noteDocTabElmnt).Displayed;
                        noteUploadedDoc = driver.FindElement(deal.noteUploadedDoc).Displayed;
                        Console.WriteLine(" Note Document Element    = " + noteUploadedDoc);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (noteUploadedDoc == false)
                        {
                            printMessage += $"Message: <br>{"Notes Document Page Load Error"}<br>";
                            addtolist(34, "Note ", "Document Tab ", noteUploadedDoc, "");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Notes Document funding loaded sucessfully");
                            addtolist(34, "Note ", "Document Tab ", noteUploadedDoc, "");
                        }

                    }
                    catch (Exception ex)
                    {

                        noteUploadedDoc = false;
                        addtolist(34, "Note ", "Document Tab ", noteUploadedDoc, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }
*/

                    //.........................Activity Tab.............................


                    try
                    {
                        driver.FindElement(deal.noteActTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Activity Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    //bool noteActElement = false;
                    bool ActivityTab = false;
                    try
                    {
                        //noteActElement = driver.FindElement(deal.noteActElement).Displayed;
                        ActivityTab = driver.FindElement(deal.noteActTab).Displayed;

                        Console.WriteLine(" Note Activity Element    = " + ActivityTab);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (ActivityTab == false)
                        {
                            printMessage += $"Message: <br>{"Activity Page Load Error"}<br>";
                            addtolist(35, "Note ", "Activity Tab ", ActivityTab, "");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Activity loaded sucessfully");
                            addtolist(35, "Note ", "Activity Tab ", ActivityTab, "");

                        }
                    }
                    catch (Exception ex)
                    {

                        ActivityTab = false;
                        addtolist(35, "Note ", "Activity Tab ", ActivityTab, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }


                    //................................Other Tab..................


                    try
                    {
                        driver.FindElement(deal.otherTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Other Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    //bool OthertabElement = false;
                    bool OthertabElement = false;
                    try
                    {
                        OthertabElement = driver.FindElement(deal.otherTab).Displayed;

                        Console.WriteLine(" Other-tab Element    = " + OthertabElement);
                        
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (OthertabElement == false)
                        {
                            printMessage += $"Message: <br>{"Other-tab Load Error"}<br>";
                            addtolist(36, "Note ", "Other Tab ", OthertabElement,"");
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Other-tab loaded sucessfully");
                            addtolist(36, "Note ", "Other Tab ", OthertabElement, "");
                        }
                    }
                    catch (Exception ex)
                    {

                        OthertabElement = false;
                        addtolist(36, "Note ", "Other Tab ", OthertabElement, ex.ToString());
                        Console.WriteLine(" Exception =" + ex); // ex;
                    }

                    /*
                                            //--------------------------------Liability --------------------------------

                                            //......................................Debt Page....................

                                            try
                                            {
                                                driver.FindElement(deal.AddManu).Click();
                                                Thread.Sleep(3000);

                                                driver.FindElement(deal.Debt).Click();
                                                Thread.Sleep(3000);

                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Debt Page exception = " + e);

                                            }
                                            Thread.Sleep(5000);

                                            bool debtLogo = false;

                                            try
                                            {
                                                debtLogo = driver.FindElement(deal.DebtLogo).Displayed;
                                                Console.WriteLine("Debt Page  = " + debtLogo);
                                                addtolist(36, "Debt", "Debt", debtLogo);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (debtLogo == false)
                                                {
                                                    printMessage += $"Message: <br>{"Debt Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Debt Page loaded sucessfully");
                                                }

                                            }

                                            catch (Exception ex)
                                            {
                                                debtLogo = false;
                                                Console.WriteLine("Debt Page exception =" + ex);
                                                //Console.WriteLine(" Exception ="+ex); // ex;

                                            }
                                            Thread.Sleep(5000);


                                            //......................................Debt Main Tab....................


                                            try
                                            {
                                                driver.FindElement(deal.DebtMain).Click();
                                                Thread.Sleep(3000);

                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Debt Main Tab exception = " + e);

                                            }
                                            Thread.Sleep(5000);

                                            bool interestExpenseSetup = false;

                                            try
                                            {
                                                interestExpenseSetup = driver.FindElement(deal.InterestExpenseSetup).Displayed;
                                                Console.WriteLine("Debt Main  = " + interestExpenseSetup);
                                                addtolist(37, "Debt", "Debt Main", interestExpenseSetup);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (interestExpenseSetup == false)
                                                {
                                                    printMessage += $"Message: <br>{"Debt Main Tab Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Debt Main Tab loaded sucessfully");
                                                }


                                            }

                                            catch (Exception ex)
                                            {
                                                interestExpenseSetup = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;

                                            }
                                            Thread.Sleep(5000);



                                            //......................................Debt Notes Tab....................


                                            try
                                            {
                                                driver.FindElement(deal.DebtNotes).Click();
                                                Thread.Sleep(3000);

                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Notes Tab exception = " + e);

                                            }
                                            Thread.Sleep(5000);

                                            bool DebtTab = false;

                                            try
                                            {
                                                DebtTab = driver.FindElement(deal.DebtNotes).Displayed;
                                                Console.WriteLine("Notes Page  = " + DebtTab);
                                                addtolist(38, "Debt", "Notes", DebtTab);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (DebtTab == false)
                                                {
                                                    printMessage += $"Message: <br>{"Debt Notes Tab Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Debt Notes Tab loaded sucessfully");
                                                }

                                            }

                                            catch (Exception ex)
                                            {
                                                DebtTab = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;

                                            }
                                            Thread.Sleep(5000);


                                            //......................................Debt Draws & Paydowns Tab....................


                                            try
                                            {
                                                driver.FindElement(deal.DrawsNPaydowns).Click();
                                                Thread.Sleep(3000);

                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Debt Draws & Paydowns Tab Tab exception = " + e);

                                            }
                                            Thread.Sleep(5000);

                                            bool requestApprovalButton = false;
                                            bool confirmedButton = false;



                                            try
                                            {
                                                requestApprovalButton = driver.FindElement(deal.RequestApprovalButton).Displayed;
                                                Console.WriteLine("Debt Draws & Paydowns Tab Page  = " + requestApprovalButton);
                                                addtolist(39, "Debt", "Draws & Paydowns Tab", requestApprovalButton);

                                                confirmedButton = driver.FindElement(deal.ConfirmedButton).Displayed;
                                                Console.WriteLine("Debt Draws & Paydowns Tab Page  = " + confirmedButton);


                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (requestApprovalButton == false || confirmedButton == false)
                                                {
                                                    printMessage += $"Message: <br>{"Debt Draws & Paydowns Tab Tab Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Debt Draws & Paydowns Tab loaded sucessfully");
                                                }


                                            }

                                            catch (Exception ex)
                                            {
                                                requestApprovalButton = false;
                                                confirmedButton = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;

                                            }
                                            Thread.Sleep(5000);

                                            //......................................Debt Additional Transactions Tab....................
                                            try
                                            {
                                                driver.FindElement(deal.DebtAdditionalTransactions).Click();
                                                Thread.Sleep(3000);

                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Debt Additional Transactions Tab exception = " + e);

                                            }
                                            Thread.Sleep(5000);

                                            bool debtAdditionalTransactions = false;

                                            try
                                            {
                                                debtAdditionalTransactions = driver.FindElement(deal.DebtAdditionalTransactions).Displayed;
                                                Console.WriteLine("Debt Additional Transactions Tab  = " + debtAdditionalTransactions);
                                                addtolist(40, "Debt", "Additional Transactions", debtAdditionalTransactions);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (debtAdditionalTransactions == false)
                                                {
                                                    printMessage += $"Message: <br>{"Debt Additional Transactions Tab Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Debt Additional Transactions Tab loaded sucessfully");
                                                }

                                            }

                                            catch (Exception ex)
                                            {
                                                debtAdditionalTransactions = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;

                                            }
                                            Thread.Sleep(5000);

                                            //......................................Journal Entry Tab....................
                                            try
                                            {
                                                driver.FindElement(deal.ManualEntry).Click();
                                                Thread.Sleep(3000);

                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Debt Journal Entry Tab exception = " + e);

                                            }
                                            Thread.Sleep(5000);

                                            bool journalEntry = false;

                                            try
                                            {
                                                journalEntry = driver.FindElement(deal.ManualEntry).Displayed;
                                                Console.WriteLine("Debt Journal Entry Tab = " + journalEntry);
                                                addtolist(41, "Debt", "Journal Entry", journalEntry);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (journalEntry == false)
                                                {
                                                    printMessage += $"Message: <br>{"Debt Journal Entry Tab Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Debt Journal Entry Tab loaded sucessfully");
                                                }

                                            }

                                            catch (Exception ex)
                                            {
                                                journalEntry = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;

                                            }
                                            Thread.Sleep(5000);

                                            //......................................Debt Cashflow Tab....................
                                            try
                                            {
                                                driver.FindElement(deal.DebtCashflow).Click();
                                                Thread.Sleep(3000);

                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Debt Cashflow Tab exception = " + e);

                                            }
                                            Thread.Sleep(5000);

                                            bool debtCashflow = false;

                                            try
                                            {
                                                debtCashflow = driver.FindElement(deal.DebtCashflow).Displayed;
                                                Console.WriteLine("Debt Cashflow Tab = " + debtCashflow);
                                                addtolist(42, "Debt", "Cashflow", debtCashflow);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (debtCashflow == false)
                                                {
                                                    printMessage += $"Message: <br>{"Debt Cashflow Tab Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Debt Cashflow Tab loaded sucessfully");
                                                }

                                            }

                                            catch (Exception ex)
                                            {
                                                debtCashflow = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;

                                            }
                                            Thread.Sleep(5000);


                                            //----------------------------------Equity Page---------------------------------

                                            //......................................Equity Page....................

                                            try
                                            {
                                                driver.FindElement(deal.AddManu).Click();
                                                Thread.Sleep(3000);

                                                driver.FindElement(deal.Equity).Click();
                                                Thread.Sleep(3000);

                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Equity Page exception = " + e);

                                            }
                                            Thread.Sleep(5000);

                                            bool equityLogo = false;

                                            try
                                            {
                                                equityLogo = driver.FindElement(deal.EquityLogo).Displayed;
                                                Console.WriteLine("Equity Page  = " + equityLogo);
                                                addtolist(43, "Equity", "Equity", equityLogo);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (equityLogo == false)
                                                {
                                                    printMessage += $"Message: <br>{"Equity Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Equity Page loaded sucessfully");
                                                }

                                            }

                                            catch (Exception ex)
                                            {
                                                equityLogo = false;
                                                Console.WriteLine("Equity Page exception =" + ex);
                                                //Console.WriteLine(" Exception ="+ex); // ex;

                                            }
                                            Thread.Sleep(5000);


                                            //......................................Equity Main Tab....................


                                            *//*try
                                            {
                                                driver.FindElement(deal.EquityMain).Click();
                                                Thread.Sleep(3000);

                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Equity Main Tab exception = " + e);

                                            }
                                            Thread.Sleep(5000);*//*

                                            bool effectiveDatebasedSetup = false;


                                            try
                                            {
                                                effectiveDatebasedSetup = driver.FindElement(deal.EffectiveDatebasedSetup).Displayed;
                                                Console.WriteLine("Equity Main  = " + effectiveDatebasedSetup);


                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (effectiveDatebasedSetup == false)
                                                {
                                                    printMessage += $"Message: <br>{"Equity Main Tab Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    addtolist(44, "Equity", "Main", effectiveDatebasedSetup);
                                                    test.Log(Status.Pass, "Equity Main Tab loaded sucessfully");
                                                }


                                            }

                                            catch (Exception ex)
                                            {
                                                effectiveDatebasedSetup = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;

                                            }
                                            Thread.Sleep(5000);



                                            //......................................Equity Notes Tab....................


                                            try
                                            {
                                                driver.FindElement(deal.EquityNotes).Click();
                                                Thread.Sleep(3000);

                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Equity Notes Tab exception = " + e);

                                            }
                                            Thread.Sleep(5000);

                                            bool equityNotes = false;

                                            try
                                            {
                                                equityNotes = driver.FindElement(deal.EquityNotes).Displayed;
                                                Console.WriteLine("Notes Page  = " + equityNotes);
                                                addtolist(45, "Equity", "Notes", equityNotes);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (equityNotes == false)
                                                {
                                                    printMessage += $"Message: <br>{"Equity Notes Tab Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Equity Notes Tab loaded sucessfully");
                                                }

                                            }

                                            catch (Exception ex)
                                            {
                                                equityNotes = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;

                                            }
                                            Thread.Sleep(5000);


                                            //......................................Equity Capital Contribution & Distribution Tab....................


                                            try
                                            {
                                                driver.FindElement(deal.EquityContributionNDistribution).Click();
                                                Thread.Sleep(3000);

                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Equity Capital Contribution & Distribution Tab exception = " + e);

                                            }
                                            Thread.Sleep(5000);

                                            bool sendCapitalCallNotificationButton = false;
                                            bool equityConfirmedButton = false;

                                            try
                                            {
                                                sendCapitalCallNotificationButton = driver.FindElement(deal.SendCapitalCallNotificationButton).Displayed;
                                                Console.WriteLine("Equity Capital Contribution & Distribution  Tab= " + sendCapitalCallNotificationButton);
                                                addtolist(46, "Equity", "Capital Contribution & Distribution", sendCapitalCallNotificationButton);

                                                equityConfirmedButton = driver.FindElement(deal.EquityConfirmedButton).Displayed;
                                                Console.WriteLine("Equity Capital Contribution & Distribution  = " + equityConfirmedButton);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (sendCapitalCallNotificationButton == false || equityConfirmedButton == false)
                                                {
                                                    printMessage += $"Message: <br>{"Equity Capital Contribution & Distribution Tab Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Equity Capital Contribution & Distribution Tab loaded sucessfully");
                                                }


                                            }

                                            catch (Exception ex)
                                            {
                                                sendCapitalCallNotificationButton = false;
                                                equityConfirmedButton = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;

                                            }
                                            Thread.Sleep(5000);


                                            //......................................Equity Fees & Expenses Tab....................


                                            try
                                            {
                                                driver.FindElement(deal.EquityFeeNExpenses).Click();
                                                Thread.Sleep(3000);

                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Equity Fees & Expenses Tab exception = " + e);

                                            }
                                            Thread.Sleep(5000);

                                            bool equityFeeNExpenses = false;

                                            try
                                            {
                                                equityFeeNExpenses = driver.FindElement(deal.EquityFeeNExpenses).Displayed;
                                                Console.WriteLine("Equity Fees & Expenses Tab= " + equityFeeNExpenses);
                                                addtolist(47, "Equity", "Fees & Expenses", equityFeeNExpenses);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (equityFeeNExpenses == false)
                                                {
                                                    printMessage += $"Message: <br>{"Equity Fees & Expenses Tab Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Equity Fees & Expenses Tab loaded sucessfully");
                                                }


                                            }

                                            catch (Exception ex)
                                            {
                                                equityFeeNExpenses = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;

                                            }
                                            Thread.Sleep(5000);


                                            //......................................Equity Cashflow Tab....................


                                            try
                                            {
                                                driver.FindElement(deal.EquityCashflow).Click();
                                                Thread.Sleep(3000);

                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Equity Cashflow Tab exception = " + e);

                                            }
                                            Thread.Sleep(10000);

                                            bool equityCashflow = false;

                                            try
                                            {
                                                equityCashflow = driver.FindElement(deal.EquityCashflow).Displayed;
                                                Console.WriteLine("Equity Cashflow Tab = " + equityCashflow);
                                                addtolist(48, "Equity", "Cashflow", equityCashflow);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (equityCashflow == false)
                                                {
                                                    printMessage += $"Message: <br>{"Equity Cashflow Tab Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Equity Cashflow Tab loaded sucessfully");
                                                }

                                            }

                                            catch (Exception ex)
                                            {
                                                equityCashflow = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;

                                            }
                                            Thread.Sleep(5000);

                                            //......................................Journal Entry Tab....................


                                            try
                                            {
                                                driver.FindElement(deal.EquityJournalEntry).Click();
                                                Thread.Sleep(3000);

                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Equity Journal Entry Tab exception = " + e);

                                            }
                                            Thread.Sleep(5000);

                                            bool equityJournalEntry = false;

                                            try
                                            {
                                                equityJournalEntry = driver.FindElement(deal.EquityJournalEntry).Displayed;
                                                Console.WriteLine("Equity Journal Entry Tab = " + equityJournalEntry);
                                                addtolist(49, "Equity", "Journal Entry", equityJournalEntry);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (equityJournalEntry == false)
                                                {
                                                    printMessage += $"Message: <br>{"Equity Journal Entry Tab Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Equity Journal Entry Tab loaded sucessfully");
                                                }

                                            }

                                            catch (Exception ex)
                                            {
                                                equityJournalEntry = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;

                                            }
                                            Thread.Sleep(5000);


                                            //......................................Journal Entry Page....................


                                            try
                                            {
                                                driver.FindElement(deal.AddManu).Click();
                                                Thread.Sleep(3000);
                                                driver.FindElement(deal.JournalEntry).Click();
                                                Thread.Sleep(3000);

                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Journal Entry Page exception = " + e);

                                            }
                                            Thread.Sleep(5000);

                                            bool JournalEntryLabel = false;

                                            try
                                            {
                                                JournalEntryLabel = driver.FindElement(deal.JournalEntryLabel).Displayed;
                                                Console.WriteLine("Journal Entry Page  = " + JournalEntryLabel);
                                                addtolist(50, "Journal Entry", "Journal Entry Page", JournalEntryLabel);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (JournalEntryLabel == false)
                                                {
                                                    printMessage += $"Message: <br>{"Journal Entry Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Journal Entry Page loaded sucessfully");
                                                }

                                            }

                                            catch (Exception ex)
                                            {
                                                JournalEntryLabel = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;

                                            }
                                            Thread.Sleep(5000);


                                            //---------------------My Account Verification------------------------------


                                            String MyAccounturl = BaseConfiguration.MyAccountUrl();
                                            String OpenMyAccountUrl = BaseUrl + MyAccounturl;
                                            util.OpenUrl(OpenMyAccountUrl);
                                            System.Threading.Thread.Sleep(5000);


                                            //.......................Accounting Tab...........................


                                            try
                                            {
                                                driver.FindElement(deal.accountTab).Click();
                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Accounting Tab = " + e);
                                            }
                                            System.Threading.Thread.Sleep(5000);
                                            bool accountTabElmnt = false;
                                            try
                                            {
                                                accountTabElmnt = driver.FindElement(deal.accountTabElmnt).Displayed;

                                                Console.WriteLine(" Account Tab Element     = " + accountTabElmnt);
                                                addtolist(51, "My Account ", "My Account  Tab ", accountTabElmnt);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (accountTabElmnt == false)
                                                {
                                                    printMessage += $"Message: <br>{"My account Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "My account loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                accountTabElmnt = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }

                                            //..........................Preferences Tab.................

                                            try
                                            {
                                                driver.FindElement(deal.preferencesTab).Click();
                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Preferences Tab = " + e);
                                            }
                                            System.Threading.Thread.Sleep(5000);
                                            bool preferenceTabElmnt = false;
                                            try
                                            {
                                                preferenceTabElmnt = driver.FindElement(deal.preferenceTabElmnt).Displayed;

                                                Console.WriteLine(" Preferences Tab Element     = " + preferenceTabElmnt);
                                                addtolist(52, "My Account ", "Preferences  Tab ", preferenceTabElmnt);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (preferenceTabElmnt == false)
                                                {
                                                    printMessage += $"Message: <br>{"Preferences Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Preferences loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                preferenceTabElmnt = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }


                                            //........................Profile Delegation Tab.................


                                            try
                                            {
                                                driver.FindElement(deal.profileDelegTab).Click();
                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Profile Delegation Tab = " + e);
                                            }
                                            System.Threading.Thread.Sleep(5000);
                                            bool btnCreateRole = false;
                                            try
                                            {
                                                btnCreateRole = driver.FindElement(deal.btnCreateRole).Displayed;

                                                Console.WriteLine(" Profile Delegation Tab Element     = " + btnCreateRole);
                                                addtolist(53, "My Account ", " Profile Delegation Tab ", btnCreateRole);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (btnCreateRole == false)
                                                {
                                                    printMessage += $"Message: <br>{"Profile delegation Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Profile delegation loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                btnCreateRole = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }

                                            //--------------------------User Management verification----------------------------------------------//

                                            //.............................. User management tab....................


                                            String UserManagementurl = BaseConfiguration.UserManagementUrl();
                                            String OpenUserManagementUrl = BaseUrl + UserManagementurl;
                                            util.OpenUrl(OpenUserManagementUrl);

                                            System.Threading.Thread.Sleep(5000);
                                            bool userManagementElmnt = false;
                                            try
                                            {
                                                userManagementElmnt = driver.FindElement(deal.userManagementElmnt).Displayed;

                                                Console.WriteLine(" User Management Element      = " + userManagementElmnt);
                                                addtolist(54, "User Management ", " User Management Tab ", userManagementElmnt);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (userManagementElmnt == false)
                                                {
                                                    printMessage += $"Message: <br>{"User management Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "User management loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                userManagementElmnt = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }
                                            System.Threading.Thread.Sleep(5000);


                                            //............................ Role Permission Tab.................


                                            try
                                            {
                                                driver.FindElement(deal.rolePermissionTab).Click();
                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Profile Delegation Tab = " + e);
                                            }
                                            System.Threading.Thread.Sleep(5000);
                                            bool roleElmnt = false;
                                            bool addNewRoleBtn = false;
                                            try
                                            {
                                                roleElmnt = driver.FindElement(deal.roleElmnt).Displayed;
                                                addNewRoleBtn = driver.FindElement(deal.addNewRoleBtn).Displayed;
                                                Console.WriteLine(" Role Permission Element      = " + roleElmnt);
                                                Console.WriteLine(" Role Permission Element      = " + addNewRoleBtn);
                                                addtolist(55, "User Management ", " Role Permission Tab ", roleElmnt);
                                                System.Threading.Thread.Sleep(10000);


                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (roleElmnt == false || addNewRoleBtn == false)
                                                {
                                                    printMessage += $"Message: <br>{"Role permission Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Role permission loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                roleElmnt = false;
                                                addNewRoleBtn = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }
                                            System.Threading.Thread.Sleep(5000);


                                            //........................Manage App settings Tab........................


                                            try
                                            {
                                                driver.FindElement(deal.manageAppSettngsTab).Click();
                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Manage App settings Tab = " + e);
                                            }
                                            System.Threading.Thread.Sleep(5000);
                                            bool managaeAppStngElmnt = false;
                                            try
                                            {
                                                managaeAppStngElmnt = driver.FindElement(deal.managaeAppStngElmnt).Displayed;

                                                Console.WriteLine(" Manage App settings Element      = " + managaeAppStngElmnt);
                                                addtolist(56, "User Management ", " Manage App settings Tab ", managaeAppStngElmnt);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (managaeAppStngElmnt == false)
                                                {
                                                    printMessage += $"Message: <br>{"Manage app settings Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Manage app settings permission loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                managaeAppStngElmnt = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }
                                            System.Threading.Thread.Sleep(5000);



                                            //.......................Workflow Approver Tab................



                                            try
                                            {
                                                driver.FindElement(deal.workflowApprovTab).Click();
                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Workflow Approver Tab = " + e);
                                            }
                                            System.Threading.Thread.Sleep(5000);
                                            bool workAprvElmnt = false;
                                            try
                                            {
                                                workAprvElmnt = driver.FindElement(deal.workAprvElmnt).Displayed;

                                                Console.WriteLine(" WorkFlow Approver Element      = " + workAprvElmnt);
                                                addtolist(57, "User Management ", " Workflow Approver Tab ", workAprvElmnt);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (workAprvElmnt == false)
                                                {
                                                    printMessage += $"Message: <br>{"Workflow approver Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "workflow approver loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                workAprvElmnt = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }
                                            System.Threading.Thread.Sleep(5000);


                                            //-----------------------------------------Data Management----------------

                                            String DataManagementUrl = BaseUrl + BaseConfiguration.DataManagementUrl();
                                            util.OpenUrl(DataManagementUrl);
                                            System.Threading.Thread.Sleep(5000);


                                            //........................... Delete Deal Tab..........................



                                            bool deleteDealName = false;
                                            try
                                            {
                                                deleteDealName = driver.FindElement(deal.deleteDealName).Displayed;

                                                Console.WriteLine("Data Management- Delete deal tab     = " + deleteDealName);
                                                addtolist(58, "Data Management ", " Delete deal Tab ", deleteDealName);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (deleteDealName == false)
                                                {
                                                    printMessage += $"Message: <br>{"Data management Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Data management loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                deleteDealName = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }


                                            //.........................Delete Note Tab..........................


                                            try
                                            {
                                                driver.FindElement(deal.deleteNoteTab).Click();
                                            }
                                            catch (Exception e)
                                            {

                                            }
                                            System.Threading.Thread.Sleep(5000);
                                            bool deleteNoteElmnt = false;
                                            try
                                            {
                                                deleteNoteElmnt = driver.FindElement(deal.deleteNoteElmnt).Displayed;

                                                Console.WriteLine("Data Management- Delete Note tab     = " + deleteNoteElmnt);
                                                addtolist(59, "Data Management ", " Delete note Tab ", deleteNoteElmnt);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (deleteNoteElmnt == false)
                                                {
                                                    printMessage += $"Message: <br>{"Delete note Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Delete note loaded sucessfully");
                                                }

                                            }
                                            catch (Exception ex)
                                            {

                                                deleteNoteElmnt = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }

                                            //.............................. Servicer Tab...........................


                                            try
                                            {
                                                driver.FindElement(deal.servicerTab).Click();
                                            }
                                            catch (Exception e)
                                            {

                                            }
                                            System.Threading.Thread.Sleep(5000);
                                            bool serviceName = false;
                                            try
                                            {
                                                serviceName = driver.FindElement(deal.serviceName).Displayed;

                                                Console.WriteLine("Data Management- Servicer tab     = " + serviceName);
                                                addtolist(60, "Data Management ", " Servicer Tab ", serviceName);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (serviceName == false)
                                                {
                                                    printMessage += $"Message: <br>{"Servicer Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Servicer loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                serviceName = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;

                                            }


                                            //..........................Transaction type Tab.......................


                                            try
                                            {
                                                driver.FindElement(deal.transactionTypesTab).Click();
                                            }
                                            catch (Exception e)
                                            {

                                            }
                                            System.Threading.Thread.Sleep(5000);
                                            bool transactionTypeElmnt = false;
                                            try
                                            {
                                                transactionTypeElmnt = driver.FindElement(deal.transactionTypeElmnt).Displayed;

                                                Console.WriteLine("Data Management- Transaction Type tab     = " + transactionTypeElmnt);
                                                addtolist(61, "Data Management ", " Transaction Type tab ", transactionTypeElmnt);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (transactionTypeElmnt == false)
                                                {
                                                    printMessage += $"Message: <br>{"Transaction Type Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Transaction type loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                transactionTypeElmnt = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }
                                            System.Threading.Thread.Sleep(5000);


                                            //--------------------------------Notification Subscription-----------------------------------------//

                                            String NotifSubUrl = BaseUrl + BaseConfiguration.NotificationSubsUrl();
                                            util.OpenUrl(NotifSubUrl);
                                            System.Threading.Thread.Sleep(5000);
                                            bool IntnotifiSubElmnt = false;
                                            try
                                            {
                                                IntnotifiSubElmnt = driver.FindElement(deal.IntnotifiSubElmnt).Displayed;

                                                Console.WriteLine("Notification Subscription     = " + IntnotifiSubElmnt);
                                                addtolist(62, "Notification Subscription ", " Notification Subscription ", IntnotifiSubElmnt);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (IntnotifiSubElmnt == false)
                                                {
                                                    printMessage += $"Message: <br>{"Notification subscription Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Notification subscription loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                IntnotifiSubElmnt = false;
                                                Console.WriteLine("Notification Subscription Exception = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }

                                            //---------------------------------------Scenarios verification-------------------------------//

                                            String ScenariosUrl = BaseUrl + BaseConfiguration.ScenarioUrl();
                                            util.OpenUrl(ScenariosUrl);
                                            System.Threading.Thread.Sleep(5000);
                                            bool addScenarioBtn = false;
                                            try
                                            {
                                                addScenarioBtn = driver.FindElement(deal.addScenarioBtn).Displayed;

                                                Console.WriteLine(" Scenario Element      = " + addScenarioBtn);
                                                addtolist(63, "Scenario ", " Scenarios ", addScenarioBtn);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (addScenarioBtn == false)
                                                {
                                                    printMessage += $"Message: <br>{"Scenario Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Scenario loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                addScenarioBtn = false;
                                                Console.WriteLine("Scenario Verification = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }
                                            try
                                            {
                                                driver.FindElement(deal.addScenarioBtn).Click();
                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("add Scenario Button = " + e.Message);
                                            }
                                            System.Threading.Thread.Sleep(5000);
                                            bool scenarioName = false;
                                            bool calculationMode = false;
                                            try
                                            {
                                                scenarioName = driver.FindElement(deal.scenarioName).Displayed;
                                                calculationMode = driver.FindElement(deal.calculationMode).Displayed;
                                                Console.WriteLine(" Add Scenario Element     = " + scenarioName);
                                                Console.WriteLine(" Add Scenario Element     = " + calculationMode);
                                                addtolist(64, "Scenario ", " Add Scenarios ", scenarioName);
                                                System.Threading.Thread.Sleep(5000);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (scenarioName == false || calculationMode == false)
                                                {
                                                    printMessage += $"Message: <br>{"Add Scenario Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Add Scenario loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                scenarioName = false;
                                                calculationMode = false;
                                                Console.WriteLine("Add Scenario  = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }

                                            //------------------------------------Index page Verification---------------------------------------//

                                            String IndexPageurl = BaseUrl + BaseConfiguration.IndexPageUrl();
                                            util.OpenUrl(IndexPageurl);
                                            System.Threading.Thread.Sleep(5000);
                                            bool addIndexScenarioBtn = false;
                                            try
                                            {
                                                addIndexScenarioBtn = driver.FindElement(deal.addIndexScenarioBtn).Displayed;

                                                Console.WriteLine(" Index Scenario Element     = " + addIndexScenarioBtn);
                                                addtolist(65, "Index Scenario ", " Index Scenarios ", addIndexScenarioBtn);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (addIndexScenarioBtn == false)
                                                {
                                                    printMessage += $"Message: <br>{"Index Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Index loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                addIndexScenarioBtn = false;
                                                Console.WriteLine("Index page verification = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }
                                            try
                                            {
                                                driver.FindElement(deal.addIndexScenarioBtn).Click();
                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Index page verification Button = " + e.Message);
                                            }
                                            System.Threading.Thread.Sleep(5000);
                                            bool indexName = false;
                                            bool indexDescription = false;
                                            try
                                            {
                                                indexName = driver.FindElement(deal.indexName).Displayed;

                                                Console.WriteLine(" Add Index Scenario Element     = " + indexName);
                                                Console.WriteLine(" Add Index Scenario Element     = " + indexDescription);
                                                addtolist(66, "Index Scenario ", " Add Index Scenarios ", indexName);
                                                System.Threading.Thread.Sleep(10000);
                                                indexDescription = driver.FindElement(deal.indexDescription).Displayed;

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (indexName == false || indexDescription == false)
                                                {
                                                    printMessage += $"Message: <br>{"Add index Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Add index  loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                indexDescription = false;
                                                indexName = false;
                                                Console.WriteLine("Add Index Loaded = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }


                                            //-------------------------------Fee Configuration----------------------------------------//


                                            String FeeConfigurl = BaseUrl + BaseConfiguration.FeeConfigUrl();
                                            util.OpenUrl(FeeConfigurl);
                                            System.Threading.Thread.Sleep(8000);


                                            //............... Fee Function Definition Tab..............


                                            bool feeFuncDefElmnt = false;
                                            try
                                            {
                                                feeFuncDefElmnt = driver.FindElement(deal.feeFuncDefElmnt).Displayed;

                                                Console.WriteLine(" Fee Function Definition Element     = " + feeFuncDefElmnt);
                                                addtolist(67, "Fee Configuration ", " Fee Function Definition ", feeFuncDefElmnt);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (feeFuncDefElmnt == false)
                                                {
                                                    printMessage += $"Message: <br>{"Fee configuration Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Fee configuration loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                feeFuncDefElmnt = false;
                                                Console.WriteLine("Fee Function Definition Exception = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }

                                            //........................Base Amount Determination Tab..................

                                            try
                                            {
                                                driver.FindElement(deal.baseAmntDeterm).Click();
                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Base Amount Determination Exception = " + e.Message);
                                            }
                                            System.Threading.Thread.Sleep(5000);
                                            bool baseAmntDetermElmnt = false;
                                            try
                                            {
                                                baseAmntDetermElmnt = driver.FindElement(deal.baseAmntDetermElmnt).Displayed;

                                                Console.WriteLine(" Base Amount Determination Element     = " + baseAmntDetermElmnt);
                                                addtolist(68, "Fee Configuration ", " Base Amount Determination ", baseAmntDetermElmnt);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (baseAmntDetermElmnt == false)
                                                {
                                                    printMessage += $"Message: <br>{"Base Amount Determination Page Load Error"}<br>";
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Base Amount Determination loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                baseAmntDetermElmnt = false;
                                                Console.WriteLine("Base Amount Determination Loaded Exception = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }


                                            // ----------Dynamic Portfolio---------------------------------------------


                                            String DynamicPortfolioUrl = BaseUrl + BaseConfiguration.DynamicPortfolioUrl();
                                            util.OpenUrl(DynamicPortfolioUrl);
                                            System.Threading.Thread.Sleep(5000);
                                            bool addPortfolioBtn = false;
                                            try
                                            {
                                                addPortfolioBtn = driver.FindElement(deal.addPortfolioBtn).Displayed;

                                                Console.WriteLine(" Dynamic portfolio Element    = " + addPortfolioBtn);
                                                addtolist(69, "Dynamic Portfolio ", " Dynamic Portfolio ", addPortfolioBtn);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (addPortfolioBtn == false)
                                                {
                                                    printMessage += $"Message: <br>{"Dynamic portfolio Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Dynamic portfolio loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                addPortfolioBtn = false;
                                                Console.WriteLine("Dynamic Portfolio Loaded Exception = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }
                                            try
                                            {
                                                driver.FindElement(deal.addPortfolioBtn).Click();
                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Dynamic Portfolio Button Exception = " + e.Message);
                                            }
                                            System.Threading.Thread.Sleep(5000);
                                            bool portfolioName = false;
                                            try
                                            {
                                                portfolioName = driver.FindElement(deal.portfolioName).Displayed;

                                                Console.WriteLine(" Dynamic portfolio Element    = " + portfolioName);
                                                addtolist(70, "Dynamic Portfolio ", " Add Portfolio ", portfolioName);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (portfolioName == false)
                                                {
                                                    printMessage += $"Message: <br>{"Dynamic portfolio  Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Dynamic portfolio loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                portfolioName = false;
                                                Console.WriteLine("Dynamic Portfolio Loaded Exception = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }


                                            //----------------------------------Transaction reconsilation----------------------------------------------------//

                                            String TranscationReconUrl = BaseUrl + BaseConfiguration.IntTranscatioReconUrl();
                                            util.OpenUrl(TranscationReconUrl);
                                            System.Threading.Thread.Sleep(10000);
                                            bool clearSectionBtn = false;
                                            bool downloadTemplateBtn = false;
                                            bool transReconPage = false;
                                            try
                                            {
                                                clearSectionBtn = driver.FindElement(deal.clearSectionBtn).Displayed;
                                                downloadTemplateBtn = driver.FindElement(deal.downloadTemplateBtn).Displayed;
                                                transReconPage = driver.FindElement(deal.InttransReconPage).Displayed;

                                                Console.WriteLine(" Transaction reconsilationElement    = " + transReconPage);
                                                Console.WriteLine(" Transaction reconsilationElement    = " + downloadTemplateBtn);
                                                Console.WriteLine(" Transaction reconsilationElement    = " + clearSectionBtn);
                                                addtolist(71, "Transaction reconsilation ", " Transaction reconsilation ", clearSectionBtn);


                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (clearSectionBtn == false || downloadTemplateBtn == false)
                                                {
                                                    printMessage += $"Message: <br>{"Transaction reconsilation Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Transaction reconsilation loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                Console.WriteLine("Transaction Reconciliation Exception " + ex);
                                                clearSectionBtn = false;
                                                downloadTemplateBtn = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }


                                            //......................Transacaction Audit ..................                                     

                                            String IntTransacAuditUrl = BaseUrl + BaseConfiguration.IntTransactionauditURL();
                                            util.OpenUrl(IntTransacAuditUrl);
                                            System.Threading.Thread.Sleep(5000);
                                            bool transcAuditPage = false;
                                            try
                                            {
                                                transcAuditPage = driver.FindElement(deal.transcAuditPage).Displayed;

                                                Console.WriteLine("Transacaction Audit    = " + transcAuditPage);
                                                addtolist(72, "Transacaction Audit  ", " Transacaction Audit ", transcAuditPage);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (transcAuditPage == false)
                                                {
                                                    printMessage += $"Message: <br>{"Transaction edit Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Transaction edit loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                Console.WriteLine("Transaction Audit Exception " + ex);
                                                transcAuditPage = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }
                                            //-------------------------Accounting Close-----------------------------------------//

                                            String PeriodicloseUrl = BaseUrl + BaseConfiguration.accountingcloseUrl();
                                            util.OpenUrl(PeriodicloseUrl);
                                            System.Threading.Thread.Sleep(5000);
                                            bool AccCloseLogo = false;
                                            bool periodicEndDate = false;
                                            try
                                            {
                                                AccCloseLogo = driver.FindElement(deal.AccountingCloselogo).Displayed;

                                                Console.WriteLine("Accounting Close   = " + AccCloseLogo);
                                                addtolist(73, "Accounting Close   ", " Accounting Close  ", AccCloseLogo);
                                                System.Threading.Thread.Sleep(10000);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (AccCloseLogo == false)
                                                {
                                                    printMessage += $"Message: <br>{"Accounting close Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Accounting close loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                AccCloseLogo = false;
                                                periodicEndDate = false;
                                                Console.WriteLine("Accounting close Exception = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }


                                            //----------------------------------------Calculation Manager-------------------------------------//

                                            //..........................................calculation Manager...........

                                            String IntCalcManagerUrl = BaseUrl + BaseConfiguration.IntCalculationManagerUrl();
                                            util.OpenUrl(IntCalcManagerUrl);
                                            System.Threading.Thread.Sleep(5000);
                                            bool calculationManagerElmnt = false;
                                            try
                                            {
                                                calculationManagerElmnt = driver.FindElement(deal.calculationManagerElmnt).Displayed;

                                                Console.WriteLine("calculation Manager Element   = " + calculationManagerElmnt);
                                                addtolist(74, "calculation Manager   ", " calculation Manager  ", calculationManagerElmnt);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (calculationManagerElmnt == false)
                                                {
                                                    printMessage += $"Message: <br>{"Calculation manager Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Calculation manager loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                calculationManagerElmnt = false;
                                                Console.WriteLine("Calculation Exception = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }


                                            //.........................Notes With Exception Tab...........


                                            try
                                            {
                                                driver.FindElement(deal.notesWthExcepTab).Click();
                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Note with Exception = " + e.Message);
                                            }
                                            System.Threading.Thread.Sleep(5000);
                                            bool notesWthExcepElmnt = false;
                                            try
                                            {
                                                notesWthExcepElmnt = driver.FindElement(deal.notesWthExcepElmnt).Displayed;

                                                Console.WriteLine("Notes With Exception Element   = " + notesWthExcepElmnt);
                                                addtolist(75, "calculation Manager   ", " Notes With Exception ", notesWthExcepElmnt);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (notesWthExcepElmnt == false)
                                                {
                                                    printMessage += $"Message: <br>{"Note with exception Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Note with exception loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                notesWthExcepElmnt = false;
                                                Console.WriteLine("Note with Exception Loaded Exception = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }

                                            //......................................Batch Log.................

                                            try
                                            {
                                                driver.FindElement(deal.batchLogTab).Click();
                                                System.Threading.Thread.Sleep(5000);
                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Batch Log Exception = " + e.Message);
                                            }
                                            bool batchLogElmnt = false;
                                            try
                                            {
                                                batchLogElmnt = driver.FindElement(deal.batchLogElmnt).Displayed;

                                                Console.WriteLine("Batch Log Element   = " + batchLogElmnt);
                                                addtolist(76, "calculation Manager   ", " Batch Log ", batchLogElmnt);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (batchLogElmnt == false)
                                                {
                                                    printMessage += $"Message: <br>{"Batch log Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Batch log loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                batchLogElmnt = false;
                                                Console.WriteLine("Batch log Loaded Exception = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }


                                            //----------------------------------------Generate Automation----------------------------------//

                                            String GenerateAutomationUrl = BaseUrl + BaseConfiguration.GenerateAutomationUrl();
                                            util.OpenUrl(GenerateAutomationUrl);
                                            System.Threading.Thread.Sleep(5000);
                                            bool GenerateAutomationSave = false;
                                            try
                                            {
                                                GenerateAutomationSave = deal.GenerateAutomationSaveButton();
                                                //GenerateAutomationSave = driver.FindElement(dealPage.GenerateAutomationSave).Displayed;
                                                Console.WriteLine("Generate Automation Save button is displayed = " + GenerateAutomationSave);
                                                addtolist(77, "Generate Automation Page  ", " Generate Automation Page ", GenerateAutomationSave);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (GenerateAutomationSave = true)
                                                {
                                                    Console.WriteLine(" Generate Automation Page loaded successfully");
                                                    test.Log(Status.Pass, "Generate Automation page loaded sucessfully");
                                                }
                                                else
                                                {
                                                    Console.WriteLine(" Generate Automation Page is Filed to load");
                                                    printMessage += $"Message: <br>{"Generate Automation Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Generate Automation Page load exception" + e.ToString());
                                            }

                                            Thread.Sleep(8000);

                                            //................... Automation Log Tab............................

                                            driver.FindElement(deal.AutomationLogTab).Click();
                                            bool AutomationLogText = false;
                                            try
                                            {
                                                AutomationLogText = deal.AutomationLogTextDisplay();
                                                //AutomationLogText = driver.FindElement(dealPage.AutomationLogText).Displayed;
                                                Console.WriteLine("Generate Automation Log text is displayed = " + AutomationLogText);
                                                addtolist(78, "Generate Automation Log Tab  ", " Generate Automation Log Tab", AutomationLogText);

                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (AutomationLogText = true)
                                                {
                                                    Console.WriteLine(" Generate Automation Log Tab loaded successfully");
                                                    test.Log(Status.Pass, "Generate Automation Log Tab loaded sucessfully");
                                                }
                                                else
                                                {
                                                    Console.WriteLine(" Generate Automation Log Tab is Filed to load");
                                                    printMessage += $"Message: <br>{"Generate Automation Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                            }
                                            catch (Exception e)
                                            {
                                                Console.WriteLine("Generate Automation Log Page load exception" + e.ToString());
                                            }

                                            //----------------------------------------Reports----------------------------------//
                                            // reports 
                                            String ReportUrl = BaseUrl + BaseConfiguration.ReportUrl();
                                            util.OpenUrl(ReportUrl);
                                            System.Threading.Thread.Sleep(5000);
                                            bool refreshDataWarehouseBtn = false;
                                            try
                                            {
                                                refreshDataWarehouseBtn = driver.FindElement(deal.refreshDataWarehouseBtn).Displayed;
                                                Console.WriteLine("Reports   = " + refreshDataWarehouseBtn);
                                                addtolist(79, "Reports   ", " Reports ", refreshDataWarehouseBtn);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (refreshDataWarehouseBtn == false)
                                                {
                                                    printMessage += $"Message: <br>{"Reports Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Reoprts Batch log loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {

                                                refreshDataWarehouseBtn = false;
                                                Console.WriteLine("Report Exception = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }

                                            //............................reports History...........................

                                            String ReportHistoryUrl = BaseUrl + BaseConfiguration.ReportHistoryUrl();
                                            util.OpenUrl(ReportHistoryUrl);
                                            System.Threading.Thread.Sleep(5000);
                                            bool reportName = false;
                                            try
                                            {
                                                reportName = driver.FindElement(deal.reportName).Displayed;
                                                Console.WriteLine("Reports   = " + reportName);
                                                addtolist(80, "Reports   ", " Reports History ", reportName);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (reportName == false)
                                                {
                                                    printMessage += $"Message: <br>{"Report History Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Reports History page loaded sucessfully");
                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                reportName = false;
                                                Console.WriteLine("Report History Exception = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }

                                            //----------------------------Tags---------------------------//

                                            String TagsUrl = BaseUrl + BaseConfiguration.TagsUrl();
                                            util.OpenUrl(TagsUrl);
                                            System.Threading.Thread.Sleep(5000);
                                            bool addNewTagBtn = false;
                                            try
                                            {
                                                addNewTagBtn = driver.FindElement(deal.addNewTagBtn).Displayed;
                                                Console.WriteLine("Tags   = " + addNewTagBtn);
                                                addtolist(81, "Tags   ", " Tags ", addNewTagBtn);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (addNewTagBtn == false)
                                                {
                                                    printMessage += $"Message: <br>{"Tags Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Tags page loaded sucessfully");
                                                }

                                            }
                                            catch (Exception ex)
                                            {
                                                addNewTagBtn = false;
                                                Console.WriteLine("Tags Exception = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }

                                            //----------------------WorkFlow-----------------------------------//

                                            String WorkflowUrl = BaseUrl + BaseConfiguration.WorkFlowUrl();
                                            util.OpenUrl(WorkflowUrl);
                                            System.Threading.Thread.Sleep(5000);
                                            bool workflowElmnt = false;
                                            try
                                            {
                                                workflowElmnt = driver.FindElement(deal.workflowElmnt).Displayed;

                                                Console.WriteLine("Workflow   = " + workflowElmnt);
                                                addtolist(82, "Workflow   ", " Workflow ", workflowElmnt);
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                if (workflowElmnt == false)
                                                {
                                                    printMessage += $"Message: <br>{"Workflow Page Load Error"}<br>";
                                                    test.Fail(printMessage);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Workflow page loaded sucessfully");
                                                }

                                            }
                                            catch (Exception ex)
                                            {
                                                workflowElmnt = false;
                                                Console.WriteLine("Workflow Exception = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }

                                            //----------------Task Management--------

                                            String TaskManagementUrl = BaseUrl + BaseConfiguration.DevDashboard();
                                            util.OpenUrl(TaskManagementUrl);
                                            System.Threading.Thread.Sleep(8000);
                                            bool addTaskBtn = false;
                                            try
                                            {
                                                addTaskBtn = driver.FindElement(deal.addTaskBtn).Displayed;


                                                Console.WriteLine("Task Management  = " + addTaskBtn);
                                                addtolist(83, "Task Management   ", " Task Management ", addTaskBtn);
                                                var printMessages = "<p><b>Test FAILED!</b></p>";
                                                if (addTaskBtn == false)
                                                {
                                                    printMessages += $"Message: <br>{"Task management page Load Error"}<br>";
                                                    test.Fail(printMessages);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Task management page loaded sucessfully");
                                                }

                                            }
                                            catch (Exception ex)
                                            {

                                                addTaskBtn = false;
                                                Console.WriteLine("Task Management Exception = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }
                                            try
                                            {
                                                driver.FindElement(deal.addTaskBtn).Click();
                                            }
                                            catch (Exception e)
                                            {

                                            }
                                            System.Threading.Thread.Sleep(5000);
                                            bool addTaskElmnt = false;
                                            bool summaryElmnt = false;
                                            try
                                            {
                                                addTaskElmnt = driver.FindElement(deal.addTaskElmnt).Displayed;
                                                summaryElmnt = driver.FindElement(deal.summaryElmnt).Displayed;

                                                Console.WriteLine("Task Management  = " + summaryElmnt);
                                                Console.WriteLine("Task Management  = " + addTaskElmnt);
                                                addtolist(84, "Task Management   ", " Add Task ", addTaskElmnt);

                                                var printMessages = "<p><b>Test FAILED!</b></p>";
                                                if (addTaskBtn == false || addTaskElmnt == false)
                                                {
                                                    printMessages += $"Message: <br>{"Task management Page Load Error"}<br>";
                                                    test.Fail(printMessages);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Task management page  loaded sucessfully");
                                                }


                                            }
                                            catch (Exception ex)
                                            {

                                                addTaskElmnt = false;
                                                summaryElmnt = false;
                                                Console.WriteLine("Task Management Page Loaded Exception = " + ex.Message);
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }

                                            //------------------------------Help----------------------------------------//

                                            String HelpUrl = BaseUrl + BaseConfiguration.HelpPageUrl();
                                            util.OpenUrl(HelpUrl);
                                            System.Threading.Thread.Sleep(8000);
                                            bool helpBtn = false;
                                            bool contactUsHeading = false;

                                            try
                                            {
                                                helpBtn = driver.FindElement(deal.helpBtn).Displayed;
                                                contactUsHeading = driver.FindElement(deal.contactUsHeading).Displayed;

                                                Console.WriteLine("Help  = " + contactUsHeading);
                                                Console.WriteLine("Help  = " + helpBtn);
                                                addtolist(85, "Help  ", " Help ", helpBtn);


                                                var printMessages = "<p><b>Test FAILED!</b></p>";
                                                if (helpBtn == false || contactUsHeading == false)
                                                {
                                                    printMessages += $"Message: <br>{"Help Page Load Error"}<br>";
                                                    test.Fail(printMessages);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Help page loaded sucessfully");
                                                }

                                            }
                                            catch (Exception ex)
                                            {

                                                helpBtn = false;
                                                contactUsHeading = false;
                                                Console.WriteLine("Help Page Loaded Exception = " + ex.Message);
                                            }
                                            // UpdatedGeneralVerification.CreateExcelDataTableNew((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(listPageLoad), (typeof(DataTable))), "PageLoad");

                                            //----------------------------Logout-----------//

                                            try
                                            {
                                                driver.FindElement(deal.krishnaDropdown).Click();
                                                System.Threading.Thread.Sleep(5000);

                                                var Logout = driver.FindElement(deal.logout);
                                                Actions action = new Actions(driver);
                                                action.MoveToElement(Logout).Click().Build().Perform();
                                                System.Threading.Thread.Sleep(8000);
                                            }
                                            catch (Exception e)
                                            {

                                            }
                                            bool logoutElmnt = false;
                                            try
                                            {
                                                logoutElmnt = driver.FindElement(deal.loginPage).Displayed;
                                                Console.WriteLine("Logout  = " + logoutElmnt);
                                                addtolist(86, "Logout  ", " Logout ", logoutElmnt);
                                                var printMessages = "<p><b>Test FAILED!</b></p>";
                                                if (logoutElmnt == false)
                                                {
                                                    printMessages += $"Message: <br>{"Logout Page Load Error"}<br>";
                                                    test.Fail(printMessages);
                                                }
                                                else
                                                {
                                                    test.Log(Status.Pass, "Logout Page loaded sucessfully");
                                                }

                                            }
                                            catch (Exception ex)
                                            {

                                                logoutElmnt = false;
                                                Console.WriteLine(" Exception =" + ex); // ex;
                                            }



                                            System.Threading.Thread.Sleep(7000);

                                            *//*String times = GeneralVerification.Timestamp();

                                            UpdatedGeneralVerification.CreateExcelDataTableNew((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(listPageLoad), (typeof(DataTable))), "PageLoad Test Report");
                                            //String time = VerifyDeal.Timestamp();
                                            System.Threading.Thread.Sleep(7000);

                                            // String FileName;

                                            String pathExcel = "PageLoad" + "_" + times + ".xlsx";
                                            Console.WriteLine("Excel report = =  " + pathExcel);
                                            //CreateExcelDataTableNew(pathExcel);
                                            System.Threading.Thread.Sleep(5000);
                                            string pathNew = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName;
                                            Console.WriteLine("Path of current directory " + pathNew);*//*

                                            //............................. Email attachment ........................
                                            // Email check point
                                            *//*
                                              try
                                              {
                                                string sendValidationReportEmail = BaseConfiguration.SendValidationReportEmail();

                                                if (sendValidationReportEmail.ToString().ToLower() == "yes")
                                                {
                                                    Console.WriteLine("\nsend Merge all files mail");
                                                     EmailDataContract emailDC = new EmailDataContract();
                                                     emailDC.To = "shantanu@hvantage.com,rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com,rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com";

                                                     //optional
                                                     //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
                                                     //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
                                                     emailDC.ReceiverName = "All";
                                                     emailDC.FileAttachment = new List<FileAttachmentDataContract>();
                                                     emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\ExcelReports\\" + pathExcel });
                                                     string path = ProjectBaseConfiguration.ExecutionReportFolder;
                                                     emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });
                                                     emailDC.Subject = "General verification test report";
                                                     emailDC.Body = "PFA the verification report.";
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
                                              catch(Exception ex)
                                              {
                                                Console.WriteLine("\nSend report mail Exception =" + ex);
                                              }        



                                                /*if (env == "QA" || env == "Integration")
                                                 {

                                                     createDeal.TestCreateNewDeal();
                                                     Console.WriteLine("Method called");
                                                 }
                                                 else
                                                 {
                                                     Console.WriteLine("Method  not called");
                                                 }*//*

                                            System.Threading.Thread.Sleep(5000);
                                            //Console.WriteLine("Method called");
                                            //System.Threading.Thread.Sleep(8000);
                                        }
                                        else
                                        {
                                            Console.WriteLine("Login Failed");
                                        }
                                    }
                                    catch (Exception ex)
                                    {
                                        Console.WriteLine("General Verification Exception " + ex.Message);
                                    }
                                }




                                //Verify Search bar

                                [Test]
                                public void verifySearchBar()
                                {
                                    {
                                        test = extent.CreateTest("To verify search bar ").Info("Test started");
                                        Actions actions = new Actions(driver);

                                        Login_Verification loginapp = new Login_Verification();
                                        Login login = new Login(driver);
                                        Deal deal = new Deal(driver);
                                        Util util = new Util(driver);
                                        string subLoginUrl;

                                        string dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
                                        string BaseUrl = null;
                                        string env = BaseConfiguration.GetEnvironment();

                                        BaseUrl = env switch
                                        {
                                            "QA" => BaseConfiguration.GetQAUrl(),
                                            "Integration" => BaseConfiguration.GetIntUrl(),
                                            "Staging" => BaseConfiguration.GetStagingUrl(),
                                            _ => BaseConfiguration.GetQAUrl(),
                                        };

                                        subLoginUrl = BaseConfiguration.GetLoginUrlNew();

                                        string LoginUrl = BaseUrl + subLoginUrl;
                                        util.OpenUrl(LoginUrl);


                                        System.Threading.Thread.Sleep(5000);
                                        try
                                        {
                                            if (login.LoginWebPage())
                                            {
                                                //util.OpenUrl(BaseUrl);
                                                //verify for deal in search box
                                                driver.FindElement(deal.searchBar).Click();
                                                driver.FindElement(deal.searchBar).SendKeys("The Hill");
                                                System.Threading.Thread.Sleep(5000);
                                                driver.FindElement(deal.DebtSearchedResult).Click();
                                                System.Threading.Thread.Sleep(25000);
                                                String dealName = driver.FindElement(deal.dealName).GetAttribute("value");
                                                var printMessages = "<p><b>Test FAILED!</b></p>";
                                                Console.WriteLine(dealName);
                                                if (dealName == "The Hill")
                                                {
                                                    Console.WriteLine("Deal " + dealName + " searched successfully.");
                                                    addtolist(87, "Deal details  ", " Deal Search ", true);
                                                    test.Log(Status.Pass, "Deal " + dealName + " searched successfully.");
                                                }
                                                else
                                                {
                                                    Console.WriteLine("Deal searched failed.");
                                                    test.Fail(printMessages);
                                                }
                                                System.Threading.Thread.Sleep(5000);
                                                util.OpenUrl(BaseUrl + BaseConfiguration.GetDashboardUrl());
                                                System.Threading.Thread.Sleep(10000);
                                                //verify for note in search box
                                                driver.FindElement(deal.searchBar).Click();
                                                driver.FindElement(deal.searchBar).SendKeys(" 2060 ");
                                                System.Threading.Thread.Sleep(5000);
                                                driver.FindElement(deal.DebtSearchedResult).Click();
                                                System.Threading.Thread.Sleep(25000);
                                                String noteID = driver.FindElement(deal.noteID).GetAttribute("value");
                                                var printMessage = "<p><b>Test FAILED!</b></p>";
                                                Console.WriteLine(noteID);
                                                if (noteID == "2060")
                                                {
                                                    Console.WriteLine("Note " + noteID + " searched successfully.");
                                                    addtolist(88, "Note details  ", " Note Search ", true);
                                                    test.Log(Status.Pass, "Note " + noteID + " searched successfully.");
                                                }
                                                else
                                                {
                                                    Console.WriteLine("Note searched failed.");
                                                    test.Fail(printMessage);
                                                }
                                            }
                                        }
                                        catch (Exception ex)
                                        {

                                        }

                                        */
                }


                UpdatedGeneralVerification.CreateExcelDataTableNew((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(listPageLoad), (typeof(DataTable))), "PageLoad Test Report");
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
                        emailDC.To = "shantanu@hvantage.com,rsahu@hvantage.com,msingh@hvantage.com";

                        //optional
                        emailDC.Cc = "ssingh@hvantage.com,vbalapure@hvantage.com,vandana@hvantage.com";
                        //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
                        emailDC.ReceiverName = "All";
                        emailDC.FileAttachment = new List<FileAttachmentDataContract>();
                        emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + pathExcel });
                        // Console.WriteLine("attached file = " + filePath);
                        //string path = ProjectBaseConfiguration.ExecutionReportFolder;
                        Console.WriteLine("Path of index file email = " + pathNew);
                        emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\index.html" });
                      //  Console.WriteLine("attached file index = " + filePath);
                        emailDC.Subject = "Automation - All Pages Load Verification Report";
                        emailDC.Body = "PFA the report of load of all the pages.";
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
            catch (Exception ex)
            {
                Console.WriteLine("\nLogin Exception =" + ex);

            }

        }
    }
}











