//using jdk.nashorn.@internal.ir;
using AventStack.ExtentReports;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMationApp;
using CRES.TestAutoMationApp.Pages;
using CRES.TestAutoMationApp.Utility;
using Newtonsoft.Json;
//using com.sun.tools.@internal.ws.processor.model;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Interactions;
using System;
using System.Collections.Generic;
using System.Data;
//using java.nio.file;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace CRES.TestAutoMation_Latest.TestCases

{
    public class GeneralVerification
    {


        //ExtentTest test = null;


        // bool DealDataVerificationStatus = false;

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

                if (!Directory.Exists(path))
                {
                    DirectoryInfo di = Directory.CreateDirectory(path);
                }
                String time = GeneralVerification.Timestamp();

                path = path + FileName + "_" + time + ".xlsx";
                using (var fs = new FileStream(path, FileMode.Create, FileAccess.Write))
                {
                    IWorkbook workbook = new XSSFWorkbook();
                    ISheet excelSheet = workbook.CreateSheet("Validation_Summary");

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
                throw;
            }
        }
        // [Category("UITest")]
        [Test]
        public void MultipleBrowser()
        {


            //Actions actions = new Actions(driver);

            //test = extent.CreateTest("General verification ").Info("Test started");
            int browserCount = BaseConfiguration.BrowserCount();

            string headless = BaseConfiguration.HeadlessDriver();

            List<int> integerList = Enumerable.Range(0, 5).ToList();
            var options = new ParallelOptions()
            {
                MaxDegreeOfParallelism = browserCount
            };

            Parallel.ForEach(integerList, options, i =>
            {
                Console.WriteLine(@"value of new i = {0}", i);



                IWebDriver _driver = null;
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
                options.AddExcludedArgument("enable-automation");
                options.SetLoggingPreference(LogType.Browser, LogLevel.Warning);

                _driver = new ChromeDriver(options);
                ((IJavaScriptExecutor)_driver).ExecuteScript("document.body.style.zoom='90%';");
                if (i == 0)
                {
                    OtherModules(_driver);
                }

                else if (i == 1)
                {
                    NoteDetail(_driver);
                }

                else if (i == 2)
                {
                    DealDetail(_driver);
                }
                else if (i == 4)
                {
                    DealDetail2(_driver);
                }
                else if (i == 3)
                {
                    NoteDetail2(_driver);
                }
            }
            );

        }



        List<PageLoadTest> listPageLoad = new List<PageLoadTest>();

        public void NoteDetail(IWebDriver driver)
        {
            var chromeOptions = new ChromeOptions();
            //chromeOptions.AddArgument("headless");

            // using (var driver = new ChromeDriver(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), chromeOptions))
            {
                Deal deal = new Deal(driver);
                //Actions actions = new Actions(driver);

                //test = extent.CreateTest("General verification ").Info("Test started");



                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/login");


                System.Threading.Thread.Sleep(20000);

                driver.Manage().Window.Maximize();
                System.Threading.Thread.Sleep(10000);

                IWebElement username = driver.FindElement(By.Name("login"));
                username.SendKeys("Automated");

                IWebElement password = driver.FindElement(By.Name("password"));
                password.SendKeys("Fight0n$");

                IWebElement loginbtn = driver.FindElement(By.Id("login"));
                loginbtn.Click();
                System.Threading.Thread.Sleep(20000);

                //----------------------Note Details Verification---------------------------

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/notedetail/4bd379aa-162d-45f0-8ca6-22da944c6884");

                System.Threading.Thread.Sleep(8000);

                //Closing Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.closingTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(2000);
                bool actualFreqElmnt = false;
                try
                {
                    try
                    {
                        actualFreqElmnt = driver.FindElement(deal.actualFreqElmnt).Displayed;
                    }
                    catch (Exception e)
                    {

                        addList("Note ", "Closing Tab ", e.Message, "Error");

                    }
                    //Console.WriteLine("Actual Freq Element   = " + actualFreqElmnt);
                    addtolist("Note ", "Closing Tab ", actualFreqElmnt);
                    /* var printMessage = "<p><b>Test FAILED!</b></p>";
                     if (actualFreqElmnt == false)
                     {
                         printMessage += $"Message: <br>{"Closing page load Error"}<br>";
                         test.Fail(printMessage);
                     }
                     else
                     {
                         test.Log(Status.Pass, "Closing page loaded sucessfully");
                     }*/
                }
                catch (Exception ex)
                {
                    actualFreqElmnt = false;
                    throw ex;
                }
                System.Threading.Thread.Sleep(2000);

                //AccountingTab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.accountingTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(2000);
                bool clientElement = false;
                try
                {
                    try
                    {
                        clientElement = driver.FindElement(deal.clientElement).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("Note ", "Accounting Tab ", e.Message, "Error");

                    }
                    //Console.WriteLine("Client Element    = " + clientElement);
                    addtolist("Note ", "Accounting Tab ", clientElement);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (clientElement == false)
                    {
                        printMessage += $"Message: <br>{"Accounting Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Accounting loaded sucessfully");
                    }*/
                }
                catch (Exception ex)
                {

                    clientElement = false;
                    throw ex;
                }

                //Financing Tab
                try
                {
                    driver.FindElement(deal.financingTab).Click();
                }
                catch (Exception e)
                {
                    throw e;
                }
                System.Threading.Thread.Sleep(2000);
                bool financingFacElmnt = false;
                try
                {
                    try
                    {
                        financingFacElmnt = driver.FindElement(deal.financingFacElmnt).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("Note ", "Financing Tab ", e.Message, "Error");
                    }
                    //Console.WriteLine(" Financing facility element    = " + financingFacElmnt);
                    addtolist("Note ", "Financing Tab ", financingFacElmnt);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (financingFacElmnt == false)
                    {
                        printMessage += $"Message: <br>{"Financing Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Financing loaded sucessfully");
                    }*/
                }
                catch (Exception ex)
                {
                    financingFacElmnt = false;
                    throw ex;
                }

                //SettelementTab
                try
                {
                    driver.FindElement(deal.settlmntTab).Click();
                }
                catch (Exception e)
                {
                    throw e;
                }
                System.Threading.Thread.Sleep(2000);
                bool closingDateElmnt = false;
                try
                {
                    try
                    {
                        closingDateElmnt = driver.FindElement(deal.closingDateElmnt).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("Note ", "Settelment Tab ", e.Message, "Error");
                    }
                    //Console.WriteLine(" Closing Date Element   = " + closingDateElmnt);
                    addtolist("Note ", "Settelment Tab ", closingDateElmnt);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (closingDateElmnt == false)
                    {
                        printMessage += $"Message: <br>{"Settelement Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Settelement loaded sucessfully");
                    }*/
                }
                catch (Exception ex)
                {
                    closingDateElmnt = false;
                    throw ex;
                }

                //Default Tab
                try
                {
                    driver.FindElement(deal.defaultTab).Click();
                }
                catch (Exception e)
                {
                    throw e;
                }
                System.Threading.Thread.Sleep(2000);
                bool effectiveDteElmnt = false;
                try
                {
                    try
                    {

                        effectiveDteElmnt = driver.FindElement(deal.effectiveDteElmnt).Displayed;
                    }

                    catch (Exception e)
                    {
                        addList("Note ", "Deafult Tab ", e.Message, "Error");
                    }
                    // Console.WriteLine(" Effective Date Element  = " + effectiveDteElmnt);
                    addtolist("Note ", "Deafult Tab ", effectiveDteElmnt);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (effectiveDteElmnt == false)
                    {
                        printMessage += $"Message: <br>{"Default Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Default loaded sucessfully");
                    }*/
                }
                catch (Exception ex)
                {
                    effectiveDteElmnt = false;
                    throw ex;
                }

                //Servicing Tab
                try
                {
                    driver.FindElement(deal.servicingTab).Click();
                }
                catch (Exception e)
                {
                    throw e;
                }
                System.Threading.Thread.Sleep(2000);
                bool servicingNameElmnt = false;
                try
                {
                    try
                    {
                        servicingNameElmnt = driver.FindElement(deal.servicingNameElmnt).Displayed;
                    }

                    catch (Exception e)
                    {
                        addList("Note ", "Deafult Tab ", e.Message, "Error");
                    }
                    //Console.WriteLine(" Servicing Name Element   = " + servicingNameElmnt);
                    addtolist("Note ", "Deafult Tab ", servicingNameElmnt);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (servicingNameElmnt == false)
                    {
                        printMessage += $"Message: <br>{"Servicing Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Servicing loaded sucessfully");
                    }*/
                }
                catch (Exception ex)
                {
                    servicingNameElmnt = false;
                    throw ex;

                }

                //Actuals Tab
                try
                {
                    driver.FindElement(deal.actualsTab).Click();
                }
                catch (Exception e)
                {
                    throw e;
                }
                System.Threading.Thread.Sleep(2000);
                bool interestElement = false;
                try
                {
                    try
                    {


                        interestElement = driver.FindElement(deal.interestElement).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("Note ", "Actuals Tab ", e.Message, "Error");
                    }
                    // Console.WriteLine(" Interest Element    = " + interestElement);
                    addtolist("Note ", "Actuals Tab ", interestElement);
                    /* var printMessage = "<p><b>Test FAILED!</b></p>";
                     if (interestElement == false)
                     {
                         printMessage += $"Message: <br>{"Actuals Page Load Error"}<br>";
                         test.Fail(printMessage);
                     }
                     else
                     {
                         test.Log(Status.Pass, "Actuals loaded sucessfully");
                     }*/
                }
                catch (Exception ex)
                {
                    interestElement = false;
                    throw ex;
                }


            }
        }

        public void NoteDetail2(IWebDriver driver)
        {
            Deal deal = new Deal(driver);
            //Actions actions = new Actions(driver);

            //test = extent.CreateTest("General verification ").Info("Test started");



            driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/login");


            System.Threading.Thread.Sleep(20000);

            driver.Manage().Window.Maximize();
            System.Threading.Thread.Sleep(10000);
            IWebElement username = driver.FindElement(By.Name("login"));
            username.SendKeys("Automated");

            IWebElement password = driver.FindElement(By.Name("password"));
            password.SendKeys("Fight0n$");

            IWebElement loginbtn = driver.FindElement(By.Id("login"));
            loginbtn.Click();
            System.Threading.Thread.Sleep(20000);

            driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/notedetail/4bd379aa-162d-45f0-8ca6-22da944c6884");

            System.Threading.Thread.Sleep(20000);
            //PIK Tab
            try
            {
                driver.FindElement(deal.pikTab).Click();
            }
            catch (Exception e)
            {
                throw e;
            }
            System.Threading.Thread.Sleep(2000);
            bool pikSourceElement = false;
            try
            {
                try
                {

                    pikSourceElement = driver.FindElement(deal.pikSourceElement).Displayed;
                }
                catch (Exception e)
                {
                    addList("Note ", "PIK Tab ", e.Message, "Error");
                }
                //Console.WriteLine(" PIK source element    = " + pikSourceElement);
                addtolist("Note ", "PIK Tab ", pikSourceElement);

                /*var printMessage = "<p><b>Test FAILED!</b></p>";
                if (pikSourceElement == false)
                {
                    printMessage += $"Message: <br>{"PIK Page Load Error"}<br>";
                    test.Fail(printMessage);
                }
                else
                {
                    test.Log(Status.Pass, "PIK loaded sucessfully");
                }*/
            }
            catch (Exception ex)
            {
                pikSourceElement = false;
                throw ex;
            }

            //Coupon Tab
            try
            {
                driver.FindElement(deal.couponTab).Click();
            }
            catch (Exception e)
            {
                throw e;
            }
            System.Threading.Thread.Sleep(2000);
            bool couponElement = false;
            try
            {
                try
                {
                    couponElement = driver.FindElement(deal.couponElement).Displayed;
                }
                catch (Exception e)
                {
                    addList("Note ", "Coupon Tab ", e.Message, "Error");
                }
                //Console.WriteLine(" Coupon Element    = " + couponElement);
                addtolist("Note ", "Coupon Tab ", couponElement);
                /*var printMessage = "<p><b>Test FAILED!</b></p>";
                if (couponElement == false)
                {
                    printMessage += $"Message: <br>{"Coupon Page Load Error"}<br>";
                    test.Fail(printMessage);
                }
                else
                {
                    test.Log(Status.Pass, "Coupon loaded sucessfully");
                }*/
            }
            catch (Exception ex)
            {

                couponElement = false;
                throw ex;
            }
            //Note Funding Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
            try
            {
                driver.FindElement(deal.noteFundingTab).Click();
            }
            catch (Exception e)
            {

            }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
            System.Threading.Thread.Sleep(2000);
            bool noteFundingElemnt = false;
            try
            {
                try
                {
                    noteFundingElemnt = driver.FindElement(deal.noteFundingElemnt).Displayed;
                }
                catch (Exception e)
                {
                    addList("Note ", "PIK Tab ", e.Message, "Error");
                }
                //Console.WriteLine(" Funding Element    = " + noteFundingElemnt);
                addtolist("Note ", "PIK Tab ", noteFundingElemnt);
                /*var printMessage = "<p><b>Test FAILED!</b></p>";
                if (noteFundingElemnt == false)
                {
                    printMessage += $"Message: <br>{"Note funding  Load Error"}<br>";
                    test.Fail(printMessage);
                }
                else
                {
                    test.Log(Status.Pass, "Note funding loaded sucessfully");
                }*/
            }
            catch (Exception ex)
            {

                noteFundingElemnt = false;
                throw ex;
            }
            //Cashflow Tab
            try
            {
                driver.FindElement(deal.cashflowTab).Click();
            }
            catch (Exception e)
            {
                throw e;
            }
            System.Threading.Thread.Sleep(2000);
            bool periodicOtpButton = false;
            try
            {
                try
                {

                    periodicOtpButton = driver.FindElement(deal.periodicOtpButton).Displayed;
                }
                catch (Exception e)
                {
                    addList("Note ", "Cashflow Tab ", e.Message, "Error");
                }
                // Console.WriteLine(" Cashflow Element    = " + periodicOtpButton);
                addtolist("Note ", "Cashflow Tab ", periodicOtpButton);
                /* var printMessage = "<p><b>Test FAILED!</b></p>";
                 if (periodicOtpButton == false)
                 {
                     printMessage += $"Message: <br>{"Cashflow Page Load Error"}<br>";
                     test.Fail(printMessage);
                 }
                 else
                 {
                     test.Log(Status.Pass, "Cashflow funding loaded sucessfully");
                 }
                */
            }
            catch (Exception ex)
            {

                periodicOtpButton = false;
                throw ex;
            }
            //Exceptions Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
            try
            {
                driver.FindElement(deal.exceptionTab).Click();
            }
            catch (Exception e)
            {

            }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
            System.Threading.Thread.Sleep(2000);
            bool exceptionElement = false;
            try
            {
                try
                {


                    exceptionElement = driver.FindElement(deal.exceptionElement).Displayed;
                }
                catch (Exception e)
                {
                    addList("Note ", "Exception Tab ", e.Message, "Error");
                }
                // Console.WriteLine(" Exception Element    = " + exceptionElement);
                addtolist("Note ", "Exception Tab ", exceptionElement);
                /* var printMessage = "<p><b>Test FAILED!</b></p>";
                if (exceptionElement == false)
                {
                    printMessage += $"Message: <br>{"Exception Page Load Error"}<br>";
                    test.Fail(printMessage);
                }
                else
                {
                    test.Log(Status.Pass, "Exception funding loaded sucessfully");
                }*/
            }
            catch (Exception ex)
            {

                exceptionElement = false;
                throw ex;
            }
            //Notes Document Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
            try
            {
                driver.FindElement(deal.noteDocTab).Click();
            }
            catch (Exception e)
            {

            }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
            System.Threading.Thread.Sleep(2000);
            bool noteDocTabElmnt = false;
            try
            {
                try
                {
                    noteDocTabElmnt = driver.FindElement(deal.noteDocTabElmnt).Displayed;
                }
                catch (Exception e)
                {
                    addList("Note ", "Exception Tab ", e.Message, "Error");
                }
                //Console.WriteLine(" Note Document Element    = " + noteDocTabElmnt);
                addtolist("Note ", "Exception Tab ", noteDocTabElmnt);
                /* var printMessage = "<p><b>Test FAILED!</b></p>";
                if (noteDocTabElmnt == false)
                {
                    printMessage += $"Message: <br>{"Notes Document Page Load Error"}<br>";
                    test.Fail(printMessage);
                }
                else
                {
                    test.Log(Status.Pass, "Notes Document funding loaded sucessfully");
                } */

            }
            catch (Exception ex)
            {

                noteDocTabElmnt = false;
                throw ex;
            }
            //Activity Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
            try
            {
                driver.FindElement(deal.noteActTab).Click();
            }
            catch (Exception e)
            {

            }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
            System.Threading.Thread.Sleep(2000);
            bool noteActElement = false;
            try
            {
                try
                {
                    noteActElement = driver.FindElement(deal.noteActElement).Displayed;
                }
                catch (Exception e)
                {
                    addList("Note ", "Activity Tab ", e.Message, "Error");
                }
                //Console.WriteLine(" Note Activity Element    = " + noteActElement);
                addtolist("Note ", "Activity Tab ", noteActElement);
                /* var printMessage = "<p><b>Test FAILED!</b></p>";
                if (noteActElement == false)
                {
                    printMessage += $"Message: <br>{"Activity Page Load Error"}<br>";
                    test.Fail(printMessage);
                }
                else
                {
                    test.Log(Status.Pass, "Activity loaded sucessfully");
                }*/
            }
            catch (Exception ex)
            {

                noteActElement = false;
                throw ex;


            }
        }

        public void DealDetail(IWebDriver driver)
        {

            var chromeOptions = new ChromeOptions();
            //chromeOptions.AddArgument("headless");

            // using (var driver = new ChromeDriver(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), chromeOptions))
            {
                Deal deal = new Deal(driver);
                //Actions actions = new Actions(driver);

                //test = extent.CreateTest("General verification ").Info("Test started");



                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/login");


                System.Threading.Thread.Sleep(20000);

                driver.Manage().Window.Maximize();
                System.Threading.Thread.Sleep(10000);

                IWebElement username = driver.FindElement(By.Name("login"));
                username.SendKeys("Automated");

                IWebElement password = driver.FindElement(By.Name("password"));
                password.SendKeys("Fight0n$");

                IWebElement loginbtn = driver.FindElement(By.Id("login"));
                loginbtn.Click();
                System.Threading.Thread.Sleep(20000);
                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/dealdetail/a/fdd8ec03-9d63-4512-9990-89c508983edc");
                System.Threading.Thread.Sleep(20000);
                //ButtonVerification
                bool SaveButton = false;
                try
                {
                    try
                    {
                        SaveButton = driver.FindElement(deal.btnSaveDeal).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("deal", "Save Button ", e.Message, "Error");
                    }
                    // Console.WriteLine("Save button  check  = " + SaveButton);
                    addtolist("deal", "Save Button ", SaveButton);

                }
                catch (Exception ex)
                {

                    SaveButton = false;
                    throw ex;
                }


                System.Threading.Thread.Sleep(2000);
                bool CancelButton = false;
                try
                {
                    try
                    {

                        CancelButton = driver.FindElement(deal.dealCancelButton).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("deal", "cancel Button ", e.Message, "Error");
                    }
                    // Console.WriteLine("Cancel button  check  = " + CancelButton);
                    addtolist("deal", "cancel Button ", CancelButton);


                }
                catch (Exception ex)
                {
                    CancelButton = false;
                    throw ex;
                }

                System.Threading.Thread.Sleep(2000);
                bool CopyDealButton = false;
                try
                {
                    try
                    {
                        CopyDealButton = driver.FindElement(deal.copyDealBtn).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("deal", "Copy Deal  Button ", e.Message, "Error");
                    }
                    //Console.WriteLine("Copy Deal  button  check  = " + CopyDealButton);
                    addtolist("deal", "Copy Deal  Button ", CopyDealButton);


                }
                catch (Exception ex)
                {

                    CopyDealButton = false;
                    throw ex;
                }
                System.Threading.Thread.Sleep(2000);
                bool DownloadButton = false;
                try
                {
                    try
                    {
                        DownloadButton = driver.FindElement(deal.downloadButton).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("deal", "Download Button ", e.Message, "Error");
                    }
                    // Console.WriteLine("Download button  check  = " + DownloadButton);
                    addtolist("deal", "Download Button ", DownloadButton);

                }
                catch (Exception ex)
                {
                    DownloadButton = false;
                    throw ex;
                }
                System.Threading.Thread.Sleep(2000);
                bool AdminButton = false;
                try
                {
                    try
                    {
                        AdminButton = driver.FindElement(deal.adminButton).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("deal", "Admin Button ", e.Message, "Error");
                    }
                    //Console.WriteLine("Admin button  check  = " + AdminButton);
                    addtolist("deal", "Admin Button ", AdminButton);

                }
                catch (Exception ex)
                {
                    AdminButton = false;
                    throw ex;
                }

                //FundingTab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.fundingTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(2000);
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    var element = driver.FindElement(deal.btnGenerateFunding);
                    Actions action = new Actions(driver);
                    action.MoveToElement(element);
                    action.Perform();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used

                System.Threading.Thread.Sleep(2000);
                bool EnableFundingSchedule = false;
                try
                {
                    try
                    {
                        EnableFundingSchedule = driver.FindElement(deal.enableFundingSchedule).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("deal", "Funding", e.Message, "Error");
                    }
                    //Console.WriteLine("EnableFundingSchedule=  " + EnableFundingSchedule);
                    addtolist("deal", "Funding", EnableFundingSchedule);
                    //Console.WriteLine("EnableFundingSchedule = " + EnableFundingSchedule);
#pragma warning disable CS0219 // The variable 'printMessages' is assigned but its value is never used
                    var printMessages = "<p><b>Test FAILED!</b></p>";
#pragma warning restore CS0219 // The variable 'printMessages' is assigned but its value is never used
                    /* if (EnableFundingSchedule == false)
                     {
                         printMessages += $"Message: <br>{"Funding Page Load Error"}<br>";
                         test.Fail(printMessages);
                     }
                     else
                     {
                         test.Log(Status.Pass, "Funding page loaded sucessfully");
                     }*/
                }
                catch (Exception ex)
                {
                    EnableFundingSchedule = false;
                    throw ex;

                }


                //MainTab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    IWebElement mainTab = driver.FindElement(By.Id("aMain"));
                    mainTab.Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(2000);
                bool DealID = false;
                bool DealName = false;
                try
                {
                    try
                    {


                        DealID = driver.FindElement(deal.dealID).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("deal", "Main", e.Message, "Error");
                    }
                    addtolist("deal", "Main", DealID);
                    //Console.WriteLine("Deal Id= " + DealID);
                    try
                    {
                        DealName = driver.FindElement(deal.dealName).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("deal", "Main", e.Message, "Error");
                    }
                    // Console.WriteLine("Deal Name= " + DealName);
                    addtolist("deal", "Main", DealName);
#pragma warning disable CS0219 // The variable 'printMessages' is assigned but its value is never used
                    var printMessages = "<p><b>Test FAILED!</b></p>";
#pragma warning restore CS0219 // The variable 'printMessages' is assigned but its value is never used
                    /*if (DealID == false || DealName == false)
                    {
                        printMessages += $"Message: <br>{"Main Page Load Error"}<br>";
                        test.Fail(printMessages);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Main page loaded sucessfully");
                    }*/

                }
                catch (Exception ex)
                {
                    DealID = false;
                    DealName = false;
                    throw ex;


                }





                //TotalCommitement tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.totalCommitementTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(2000);
                bool TotalCommitmentCheck = false;
                try
                {

                    try
                    {
                        TotalCommitmentCheck = driver.FindElement(By.ClassName("col-sm-3")).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("deal", "Total commitment ", e.Message, "Error");
                    }
                    // Console.WriteLine("Total commitment check  = " + TotalCommitmentCheck);
                    addtolist("deal", "Total commitment ", TotalCommitmentCheck);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (TotalCommitmentCheck == false)
                    {
                        printMessage += $"Message: <br>{"Total commitement Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Total commitement page loaded sucessfully");
                    }*/
                    System.Threading.Thread.Sleep(2000);




                }
                catch (Exception ex)
                {
                    TotalCommitmentCheck = false;
                    throw ex;
                }



                //Documents
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.documentsTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(2000);
                bool DocumentsCheck = false;
                try
                {
                    try
                    {
                        DocumentsCheck = driver.FindElement(deal.documentCheckElement).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("deal", "Documents ", e.Message, "Error");
                    }
                    //Console.WriteLine("Documents check  = " + DocumentsCheck);
                    addtolist("deal", "Documents ", DocumentsCheck);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (DocumentsCheck == false)
                    {
                        printMessage += $"Message: <br>{"Documents Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Documents page loaded sucessfully");
                    }*/
                }
                catch (Exception ex)
                {

                    DocumentsCheck = false;
                    throw ex;
                }
                System.Threading.Thread.Sleep(2000);


                //ActivityTab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.activityTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(2000);
                bool ActivityCheck = false;
                try
                {
                    try
                    {


                        ActivityCheck = driver.FindElement(deal.activityCheckElement).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("deal", "Activity ", e.Message, "Error");
                    }
                    // Console.WriteLine("Activity check  = " + ActivityCheck);
                    addtolist("deal", "Activity ", ActivityCheck);
                    /* var printMessage = "<p><b>Test FAILED!</b></p>";
                     if (ActivityCheck == false)
                     {
                         printMessage += $"Message: <br>{"Activity Page Load Error"}<br>";
                         test.Fail(printMessage);
                     }
                     else
                     {
                         test.Log(Status.Pass, "Activity page loaded sucessfully");
                     }*/
                }
                catch (Exception ex)
                {

                    ActivityCheck = false;
                    throw ex;
                }
                System.Threading.Thread.Sleep(2000);
            }
        }

        public void DealDetail2(IWebDriver driver)
        {
            var chromeOptions = new ChromeOptions();
            //chromeOptions.AddArgument("headless");

            // using (var driver = new ChromeDriver(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), chromeOptions))
            {
                Deal deal = new Deal(driver);
                //Actions actions = new Actions(driver);

                //test = extent.CreateTest("General verification ").Info("Test started");



                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/login");


                System.Threading.Thread.Sleep(20000);

                driver.Manage().Window.Maximize();
                System.Threading.Thread.Sleep(10000);

                IWebElement username = driver.FindElement(By.Name("login"));
                username.SendKeys("Automated");

                IWebElement password = driver.FindElement(By.Name("password"));
                password.SendKeys("Fight0n$");

                IWebElement loginbtn = driver.FindElement(By.Id("login"));
                loginbtn.Click();
                System.Threading.Thread.Sleep(20000);

                //----------------------------------Transaction reconsilation----------------------------------------------------//

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/Transcationreconciliation");
                System.Threading.Thread.Sleep(8000);
                bool clearSectionBtn = false;
                bool downloadTemplateBtn = false;
                try
                {
                    try
                    {
                        clearSectionBtn = driver.FindElement(deal.clearSectionBtn).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("Transaction reconsilation ", " Transaction reconsilation ", e.Message, "Error");
                    }
                    // Console.WriteLine(" Transaction reconsilationElement    = " + clearSectionBtn);
                    addtolist("Transaction reconsilation ", " Transaction reconsilation ", clearSectionBtn);
                    try
                    {
                        downloadTemplateBtn = driver.FindElement(deal.downloadTemplateBtn).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("Transaction reconsilation ", " Transaction reconsilation ", e.Message, "Error");
                    }
                    // Console.WriteLine(" Transaction reconsilationElement    = " + downloadTemplateBtn);
                    addtolist("Transaction reconsilation ", " Transaction reconsilation ", downloadTemplateBtn);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (clearSectionBtn == false || downloadTemplateBtn == false)
                   {
                       printMessage += $"Message: <br>{"Transaction reconsilation Page Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "Transaction reconsilation loaded sucessfully");
                   }*/
                }
                catch (Exception ex)
                {

                    clearSectionBtn = false;
                    downloadTemplateBtn = false;
                    throw ex;
                }
                //Transacaction Audit 

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/Transactionaudit");
                System.Threading.Thread.Sleep(8000);
                bool transcAuditElmnt = false;
                try
                {
                    try
                    {



                        transcAuditElmnt = driver.FindElement(deal.transcAuditElmnt).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("Transacaction Audit  ", " Transacaction Audit ", e.Message, "Error");
                    }
                    //Console.WriteLine("Transacaction Audit    = " + transcAuditElmnt);
                    addtolist("Transacaction Audit  ", " Transacaction Audit ", transcAuditElmnt);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (transcAuditElmnt == false)
                   {
                       printMessage += $"Message: <br>{"Transaction edit Page Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "Transaction edit loaded sucessfully");
                   }*/
                }
                catch (Exception ex)
                {

                    transcAuditElmnt = false;
                    throw ex;
                }



                //----------------------------------------Calculation Manager-------------------------------------//

                //calculation Manager

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/CalculationManager");
                System.Threading.Thread.Sleep(8000);
                bool calculationManagerElmnt = false;
                try
                {
                    try
                    {
                        calculationManagerElmnt = driver.FindElement(deal.calculationManagerElmnt).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("calculation Manager   ", " calculation Manager  ", e.Message, "Error");
                    }
                    // Console.WriteLine("calculation Manager Element   = " + calculationManagerElmnt);
                    addtolist("calculation Manager   ", " calculation Manager  ", calculationManagerElmnt);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (calculationManagerElmnt == false)
                   {
                       printMessage += $"Message: <br>{"Calculation manager Page Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "Calculation manager loaded sucessfully");
                   }*/
                }
                catch (Exception ex)
                {

                    calculationManagerElmnt = false;
                    throw ex;
                }


                //Notes With Exception Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.notesWthExcepTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(2000);
                bool notesWthExcepElmnt = false;
                try
                {
                    try
                    {
                        notesWthExcepElmnt = driver.FindElement(deal.notesWthExcepElmnt).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("calculation Manager   ", " Notes With Exception ", e.Message, "Error");
                    }
                    // Console.WriteLine("Notes With Exception Element   = " + notesWthExcepElmnt);
                    addtolist("calculation Manager   ", " Notes With Exception ", notesWthExcepElmnt);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (notesWthExcepElmnt == false)
                   {
                       printMessage += $"Message: <br>{"Note with exception Page Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "Note with exception loaded sucessfully");
                   }*/
                }
                catch (Exception ex)
                {

                    notesWthExcepElmnt = false;
                    throw ex;
                }

                //Batch Log
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.batchLogTab).Click();
                    System.Threading.Thread.Sleep(2000);
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                bool batchLogElmnt = false;
                try
                {
                    try
                    {
                        batchLogElmnt = driver.FindElement(deal.batchLogElmnt).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("calculation Manager   ", " Batch Log ", e.Message, "Error");
                    }
                    //Console.WriteLine("Batch Log Element   = " + batchLogElmnt);
                    addtolist("calculation Manager   ", " Batch Log ", batchLogElmnt);
                    /* var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (batchLogElmnt == false)
                    {
                        printMessage += $"Message: <br>{"Batch log Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Batch log loaded sucessfully");
                    }*/
                }
                catch (Exception ex)
                {

                    batchLogElmnt = false;
                    throw ex;

                }

                //----------------------------------------Reports----------------------------------//
                // reports 
                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/report");
                System.Threading.Thread.Sleep(5000);
                bool refreshDataWarehouseBtn = false;
                try
                {
                    try
                    {
                        refreshDataWarehouseBtn = driver.FindElement(deal.refreshDataWarehouseBtn).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("Reports   ", " Reports ", e.Message, "Error");
                    }
                    //Console.WriteLine("Reports   = " + refreshDataWarehouseBtn);
                    addtolist("Reports   ", " Reports ", refreshDataWarehouseBtn);
                    /* var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (refreshDataWarehouseBtn == false)
                    {
                        printMessage += $"Message: <br>{"Reports Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Reoprts Batch log loaded sucessfully");
                    }*/
                }
                catch (Exception ex)
                {

                    refreshDataWarehouseBtn = false;
                    throw ex;
                }

                //reports History

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/reporthistory");
                System.Threading.Thread.Sleep(5000);
                bool reportName = false;
                try
                {
                    try
                    {
                        reportName = driver.FindElement(deal.reportName).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("Reports   ", " Reports History ", e.Message, "Error");

                    }
                    //Console.WriteLine("Reports   = " + reportName);
                    addtolist("Reports   ", " Reports History ", reportName);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (reportName == false)
                   {
                       printMessage += $"Message: <br>{"Report History Page Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "Reports History page loaded sucessfully");
                   }*/
                }
                catch (Exception ex)
                {
                    reportName = false;
                    throw ex;
                }







            }

        }


        // [Category("UITest")]
        public void OtherModules(IWebDriver driver)
        {
#pragma warning disable CS0219 // The variable 'test' is assigned but its value is never used
            ExtentTest test = null;
#pragma warning restore CS0219 // The variable 'test' is assigned but its value is never used
            var chromeOptions = new ChromeOptions();
            //chromeOptions.AddArgument("headless");
            Actions actions = new Actions(driver);
            // using (var driver = new ChromeDriver(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), chromeOptions))
            {
                Deal deal = new Deal(driver);
                //Actions actions = new Actions(driver);

                //test = extent.CreateTest("General verification ").Info("Test started");



                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/login");


                System.Threading.Thread.Sleep(20000);

                driver.Manage().Window.Maximize();
                System.Threading.Thread.Sleep(10000);
                IWebElement username = driver.FindElement(By.Name("login"));
                username.SendKeys("Automated");

                IWebElement password = driver.FindElement(By.Name("password"));
                password.SendKeys("Fight0n$");

                IWebElement loginbtn = driver.FindElement(By.Id("login"));
                loginbtn.Click();
                System.Threading.Thread.Sleep(20000);
                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/" + "#/dealdetail/FDD8EC03-9D63-4512-9990-89C508983EDC");


                //GeneralVerificationStatus = true;
                // test.Log(Status.Pass, "All pages loaded sucessfully");
                System.Threading.Thread.Sleep(9000);

                /*IWebElement intLogin = driver.FindElement(By.Name("login"));
                intLogin.SendKeys("admin_qa");

                IWebElement intPass = driver.FindElement(By.Name("password"));
                intPass.SendKeys("qwert1*");

                IWebElement loginBtn = driver.FindElement(By.Id("login"));
                loginBtn.Click();



                System.Threading.Thread.Sleep(20000);*/


                //System.Threading.Thread.Sleep(20000);







                //---------------------My Account Verification------------------------------
                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/myaccount");
                System.Threading.Thread.Sleep(8000);
                //Accounting Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.accountTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(2000);
                bool accountTabElmnt = false;
                try
                {
                    try
                    {
                        accountTabElmnt = driver.FindElement(deal.accountTabElmnt).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("My Account ", "My Account  Tab ", e.Message, "Error");

                    }
                    //Console.WriteLine(" Account Tab Element     = " + accountTabElmnt);
                    addtolist("My Account ", "My Account  Tab ", accountTabElmnt);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (accountTabElmnt == false)
                   {
                       printMessage += $"Message: <br>{"My account Page Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "My account loaded sucessfully");
                   }*/
                }
                catch (Exception ex)
                {

                    accountTabElmnt = false;
                    throw ex;


                }

                //Preferences Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.preferencesTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(2000);
                bool preferenceTabElmnt = false;
                try
                {
                    try
                    {
                        preferenceTabElmnt = driver.FindElement(deal.preferenceTabElmnt).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("My Account ", "Preferences  Tab ", e.Message, "Error");
                    }
                    //Console.WriteLine(" Preferences Tab Element     = " + preferenceTabElmnt);
                    addtolist("My Account ", "Preferences  Tab ", preferenceTabElmnt);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (preferenceTabElmnt == false)
                   {
                       printMessage += $"Message: <br>{"Preferences Page Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "Preferences loaded sucessfully");
                   }*/
                }
                catch (Exception ex)
                {

                    preferenceTabElmnt = false;
                    throw ex;
                }

                //Profile Delegation Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.profileDelegTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(2000);
                bool btnCreateRole = false;
                try
                {
                    try
                    {
                        btnCreateRole = driver.FindElement(deal.btnCreateRole).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("My Account ", " Profile Delegation Tab ", e.Message, "Error");
                    }
                    //Console.WriteLine(" Profile Delegation Tab Element     = " + btnCreateRole);
                    addtolist("My Account ", " Profile Delegation Tab ", btnCreateRole);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (btnCreateRole == false)
                   {
                       printMessage += $"Message: <br>{"Profile delegation Page Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "Profile delegation loaded sucessfully");
                   }*/
                }
                catch (Exception ex)
                {

                    btnCreateRole = false;
                    throw ex;
                }

                //--------------------------User Management verification----------------------------------------------//
                // User management tab
                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/userpermission");
                System.Threading.Thread.Sleep(8000);
                bool userManagementElmnt = false;
                try
                {
                    try
                    {
                        userManagementElmnt = driver.FindElement(deal.userManagementElmnt).Displayed;

                    }
                    catch (Exception e)
                    {
                        throw e;
                    }
                    Console.WriteLine(" User Management Element      = " + userManagementElmnt);
                    addtolist("User Management ", " User Management Tab ", userManagementElmnt);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (userManagementElmnt == false)
                   {
                       printMessage += $"Message: <br>{"User management Page Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "User management loaded sucessfully");
                   }*/
                }
                catch (Exception ex)
                {

                    userManagementElmnt = false;
                    throw ex;
                }
                System.Threading.Thread.Sleep(2000);
                // Role Permission Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.rolePermissionTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(2000);
                bool roleElmnt = false;
#pragma warning disable CS0219 // The variable 'addNewRoleBtn' is assigned but its value is never used
                bool addNewRoleBtn = false;
#pragma warning restore CS0219 // The variable 'addNewRoleBtn' is assigned but its value is never used
                try
                {
                    try
                    {
                        roleElmnt = driver.FindElement(deal.roleElmnt).Displayed;
                    }
                    catch (Exception e)
                    {
                        throw e;
                    }
                    Console.WriteLine(" Role Permission Element      = " + roleElmnt);
                    addtolist("User Management ", " Role Permission Tab ", roleElmnt);
                    System.Threading.Thread.Sleep(2000);

                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (roleElmnt == false || addNewRoleBtn == false)
                   {
                       printMessage += $"Message: <br>{"Role permission Page Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "Role permission loaded sucessfully");
                   }*/
                }
                catch (Exception ex)
                {

                    roleElmnt = false;
                    addNewRoleBtn = false;
                    throw ex;
                }
                System.Threading.Thread.Sleep(2000);
                //Manage App settings Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.manageAppSettngsTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(2000);
                bool managaeAppStngElmnt = false;
                try
                {
                    try
                    {
                        managaeAppStngElmnt = driver.FindElement(deal.managaeAppStngElmnt).Displayed;
                    }
                    catch (Exception e)
                    {
                        addList("User Management ", "  Manage App settings Tab ", e.Message, "Error");
                    }
                    //Console.WriteLine(" Manage App settings Element      = " + managaeAppStngElmnt);
                    addtolist("User Management ", " Manage App settings Tab ", managaeAppStngElmnt);
                    /* var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (managaeAppStngElmnt == false)
                    {
                        printMessage += $"Message: <br>{"Manage app settings Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Manage app settings permission loaded sucessfully");
                    }*/
                }
                catch (Exception ex)
                {

                    managaeAppStngElmnt = false;
                    throw ex;
                }
                System.Threading.Thread.Sleep(2000);

                //Workflow Approver Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.workflowApprovTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(2000);
                bool workAprvElmnt = false;
                try
                {
                    try
                    {
                        workAprvElmnt = driver.FindElement(deal.workAprvElmnt).Displayed;
                    }
                    catch (Exception e)
                    {



                        addList("User Management ", " Workflow Approver Tab ", e.Message, "Error");

                    }
                    //  Console.WriteLine(" WorkFlow Approver Element      = " + workAprvElmnt);
                    addtolist("User Management ", " Workflow Approver Tab ", workAprvElmnt);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (workAprvElmnt == false)
                   {
                       printMessage += $"Message: <br>{"Workflow approver Page Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "workflow approver loaded sucessfully");
                   }*/
                }
                catch (Exception ex)
                {

                    workAprvElmnt = false;
                    throw ex;
                }
                System.Threading.Thread.Sleep(1000);











                String times = GeneralVerification.Timestamp();

                GeneralVerification.CreateExcelDataTableNew((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(listPageLoad), (typeof(DataTable))), "PageLoad");
                //String time = VerifyDeal.Timestamp();
                System.Threading.Thread.Sleep(7000);

                // String FileName;

                String pathExcel = "PageLoad" + "_" + times + ".xlsx";
                Console.WriteLine("Excel report = =  " + pathExcel);
                // CreateExcelDataTableNew(pathExcel);
                System.Threading.Thread.Sleep(5000);
                string pathNew = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName;
                Console.WriteLine("Path of current directory " + pathNew);
                System.Threading.Thread.Sleep(10000);


                // Email attachment 

                EmailDataContract emailDC = new EmailDataContract();
                emailDC.To = "gthakur@hvantage.com,rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com";//rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com

                //optional
                //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
                //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
                emailDC.ReceiverName = "All";
                emailDC.FileAttachment = new List<FileAttachmentDataContract>();
                emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\ExcelReports\\" + pathExcel });
                string path = ProjectBaseConfiguration.ExecutionReportFolder;
                //emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });
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
                System.Threading.Thread.Sleep(3000);

                /* if (env == "QA" || env == "Integration")
                 {

                     createDeal.TestCreateNewDeal();
                     Console.WriteLine("Method called");
                 }
                 else
                 {
                     Console.WriteLine("Method  not called");
                 }

                 System.Threading.Thread.Sleep(10000);*/
                //Console.WriteLine("Method called");
                //System.Threading.Thread.Sleep(8000);
            }

        }
        private string CreateExcelDataTableNew(string path)
        {
            throw new NotImplementedException();
        }

        public void addtolist(string pagename, string tabname, Boolean res)
        {
            PageLoadTest plt = new PageLoadTest();
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
        }
        public void addList(string pagename, string tabname, String exception, String status)
        {
            PageLoadTest pageloadtest = new PageLoadTest();
            pageloadtest.PageName = pagename;
            pageloadtest.TabName = tabname;
            pageloadtest.Exception = exception;
            pageloadtest.Status = "Error";

            listPageLoad.Add(pageloadtest);
        }

    }


    //listPageLoad.Add(plt);
}



//Note save 






