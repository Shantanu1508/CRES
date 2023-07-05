using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMationApp;
using CRES.TestAutoMationApp.ExecutionReports;
using CRES.TestAutoMationApp.Pages;
using CRES.TestAutoMationApp.Utility;
using Newtonsoft.Json;
//using com.sun.tools.@internal.ws.processor.model;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using OpenQA.Selenium;
//using jdk.nashorn.@internal.ir;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Interactions;
using System;
using System.Collections.Generic;
using System.Data;
//using java.nio.file;
using System.IO;
using System.Reflection;

namespace CRES.TestAutoMation_Latest.TestCases

{
    public class GeneralVerification_weekly
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
                String time = GeneralVerification_weekly.Timestamp();

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




        List<PageLoadTest> listPageLoad = new List<PageLoadTest>();

        //[Test]
        //[Category("UITest")]
        public void DealDataVerification()
        {
            var chromeOptions = new ChromeOptions();
            chromeOptions.AddArgument("headless");

            using (var driver = new ChromeDriver(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), chromeOptions))
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
                System.Threading.Thread.Sleep(10000);
                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/" + "#/dealdetail/FDD8EC03-9D63-4512-9990-89C508983EDC");


                //GeneralVerificationStatus = true;
                // test.Log(Status.Pass, "All pages loaded sucessfully");
                System.Threading.Thread.Sleep(25000);

                /*IWebElement intLogin = driver.FindElement(By.Name("login"));
                intLogin.SendKeys("admin_qa");

                IWebElement intPass = driver.FindElement(By.Name("password"));
                intPass.SendKeys("qwert1*");

                IWebElement loginBtn = driver.FindElement(By.Id("login"));
                loginBtn.Click();



                System.Threading.Thread.Sleep(20000);*/


                //System.Threading.Thread.Sleep(20000);
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
                System.Threading.Thread.Sleep(10000);

                var element = driver.FindElement(deal.btnGenerateFunding);
                Actions action = new Actions(driver);
                action.MoveToElement(element);
                action.Perform();
                System.Threading.Thread.Sleep(10000);
                bool EnableFundingSchedule = false;
                try
                {
                    EnableFundingSchedule = driver.FindElement(deal.enableFundingSchedule).Displayed;
                    Console.WriteLine("EnableFundingSchedule=  " + EnableFundingSchedule);
                    // addtolist("deal", "Funding", EnableFundingSchedule);
                    Console.WriteLine("EnableFundingSchedule = " + EnableFundingSchedule);
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

                //System.Threading.Thread.Sleep(20000);
                //Boolean TotalCommitementAdjustment = driver.FindElement(By.ClassName("wj-form-control wj-numeric")).Displayed;
                //Console.WriteLine("Total Commitement Adjustment= " + TotalCommitementAdjustment);
                //System.Threading.Thread.Sleep(20000);
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
                System.Threading.Thread.Sleep(10000);
                bool DealID = false;
                bool DealName = false;
                try
                {
                    DealID = driver.FindElement(deal.dealID).Displayed;

                    addtolist("deal", "Main", DealID);
                    Console.WriteLine("Deal Id= " + DealID);

                    DealName = driver.FindElement(deal.dealName).Displayed;

                    Console.WriteLine("Deal Name= " + DealName);
                    //addtolist("deal", "Main", DealName);
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

                //AmortTab


                /*try
                {
                    driver.FindElement(deal.amortTab).Click();
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);

                }
                System.Threading.Thread.Sleep(10000);

                bool AmortizationMethod = false;
                bool ReduceAmortization = false;
                try
                {
                    AmortizationMethod = driver.FindElement(deal.amortizationMethodElement).Displayed;
                    Console.WriteLine("Amortization Method = " + AmortizationMethod);
                    addtolist("deal", "Amort", AmortizationMethod);
                    ReduceAmortization = driver.FindElement(deal.reduceAmortizationElement).Displayed;
                    Console.WriteLine("Reduce Amortization = " + ReduceAmortization);
                    addtolist("deal", "Amort", ReduceAmortization);
                    var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (AmortizationMethod == false || ReduceAmortization == false)
                    {
                        printMessage += $"Message: <br>{"Amort Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Amort page loaded sucessfully");
                    }


                }

                catch (Exception ex)
                {
                    AmortizationMethod = false;
                    ReduceAmortization = false;

                    throw ex;

                }
                System.Threading.Thread.Sleep(10000);*/

                //PayRules

                //try
                //{

                //  driver.FindElement(deal.payRuleTab).Click();
                //}
                //catch (Exception e)
                // {

                //}
                //System.Threading.Thread.Sleep(10000);

                //bool PayruleNoteId = false;
                //try
                //{
                //  PayruleNoteId = driver.FindElement(deal.payruleNoteID).Displayed;

                //Console.WriteLine("Payrul NoteID  = " + PayruleNoteId);
                //addtolist("deal", "Pay Rules", PayruleNoteId);
                //var printMessage = "<p><b>Test FAILED!</b></p>";
                /*if (PayruleNoteId == false)
                {
                    printMessage += $"Message: <br>{"Payrules Page Load Error"}<br>";
                    test.Fail(printMessage);
                }
                else
                {
                    test.Log(Status.Pass, "Payrules page loaded sucessfully");
                }*/

                //}
                //catch (Exception ex)
                //{
                //  PayruleNoteId = false;

                //throw ex;
                //}


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
                System.Threading.Thread.Sleep(10000);
                bool TotalCommitmentCheck = false;
                try
                {
                    TotalCommitmentCheck = driver.FindElement(By.ClassName("custombutton")).Displayed;

                    Console.WriteLine("Total commitment check  = " + TotalCommitmentCheck);
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
                    System.Threading.Thread.Sleep(10000);




                }
                catch (Exception ex)
                {
                    TotalCommitmentCheck = false;
                    throw ex;
                }


                //PayOff
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.payOffTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(10000);
                bool PayOffCheck = false;
                try
                {
                    PayOffCheck = driver.FindElement(deal.payOffCheckElement).Displayed;

                    Console.WriteLine("PayOff check  = " + PayOffCheck);
                    addtolist("deal", "PayOff ", PayOffCheck);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (PayOffCheck == false)
                    {
                        printMessage += $"Message: <br>{"Pay off Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Pay off page loaded sucessfully");
                    }*/

                }
                catch (Exception ex)
                {
                    PayOffCheck = false;
                    throw ex;
                }
                System.Threading.Thread.Sleep(10000);

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
                System.Threading.Thread.Sleep(10000);
                bool DocumentsCheck = false;
                try
                {

                    DocumentsCheck = driver.FindElement(deal.documentCheckElement).Displayed;

                    Console.WriteLine("Documents check  = " + DocumentsCheck);
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
                System.Threading.Thread.Sleep(10000);


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
                System.Threading.Thread.Sleep(10000);
                bool ActivityCheck = false;
                try
                {
                    ActivityCheck = driver.FindElement(deal.activityCheckElement).Displayed;

                    Console.WriteLine("Activity check  = " + ActivityCheck);
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
                System.Threading.Thread.Sleep(20000);

                //ButtonVerification
                bool SaveButton = false;
                try
                {
                    SaveButton = driver.FindElement(deal.btnSaveDeal).Displayed;

                    Console.WriteLine("Save button  check  = " + SaveButton);
                    addtolist("deal", "Save Button ", SaveButton);
                    /* var printMessage = "<p><b>Test FAILED!</b></p>";
                     if (SaveButton == false)
                     {
                         printMessage += $"Message: <br>{"Save button Error"}<br>";
                         test.Fail(printMessage);
                     }
                     else
                     {
                         test.Log(Status.Pass, "Save button checked sucessfully");
                     }*/
                }
                catch (Exception ex)
                {

                    SaveButton = false;
                    throw ex;
                }


                System.Threading.Thread.Sleep(10000);
                bool CancelButton = false;
                try
                {
                    CancelButton = driver.FindElement(deal.dealCancelButton).Displayed;

                    Console.WriteLine("Cancel button  check  = " + CancelButton);
                    addtolist("deal", "cancel Button ", CancelButton);

                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (CancelButton == false)
                    {
                        printMessage += $"Message: <br>{"Cancel button Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Cancel button checked sucessfully");
                    }*/

                }
                catch (Exception ex)
                {
                    CancelButton = false;
                    throw ex;
                }

                System.Threading.Thread.Sleep(10000);
                bool CopyDealButton = false;
                try
                {
                    CopyDealButton = driver.FindElement(deal.copyDealBtn).Displayed;

                    Console.WriteLine("Copy Deal  button  check  = " + CopyDealButton);
                    addtolist("deal", "Copy Deal  Button ", CopyDealButton);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (CopyDealButton == false)
                    {
                        printMessage += $"Message: <br>{"Copy deal button Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "copy deal  button checked sucessfully");
                    }*/

                }
                catch (Exception ex)
                {

                    CopyDealButton = false;
                    throw ex;
                }
                System.Threading.Thread.Sleep(10000);
                bool DownloadButton = false;
                try
                {
                    DownloadButton = driver.FindElement(deal.downloadButton).Displayed;

                    Console.WriteLine("Download button  check  = " + DownloadButton);
                    addtolist("deal", "Download Button ", DownloadButton);
                    /* var printMessage = "<p><b>Test FAILED!</b></p>";
                     if (DownloadButton == false)
                     {
                         printMessage += $"Message: <br>{"Download button Error"}<br>";
                         test.Fail(printMessage);
                     }
                     else
                     {
                         test.Log(Status.Pass, "Download button checked sucessfully");
                     }*/
                }
                catch (Exception ex)
                {
                    DownloadButton = false;
                    throw ex;
                }
                System.Threading.Thread.Sleep(10000);
                bool AdminButton = false;
                try
                {
                    AdminButton = driver.FindElement(deal.adminButton).Displayed;

                    Console.WriteLine("Admin button  check  = " + AdminButton);
                    addtolist("deal", "Admin Button ", AdminButton);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (AdminButton == false)
                    {
                        printMessage += $"Message: <br>{"Admin button Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Admin button checked sucessfully");
                    }*/
                }
                catch (Exception ex)
                {
                    AdminButton = false;
                    throw ex;
                }
                System.Threading.Thread.Sleep(20000);


                //----------------------Note Details Verification---------------------------

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/notedetail/4bd379aa-162d-45f0-8ca6-22da944c6884");

                System.Threading.Thread.Sleep(25000);

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
                System.Threading.Thread.Sleep(10000);
                bool actualFreqElmnt = false;
                try
                {
                    actualFreqElmnt = driver.FindElement(deal.actualFreqElmnt).Displayed;

                    Console.WriteLine("Actual Freq Element   = " + actualFreqElmnt);
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
                System.Threading.Thread.Sleep(10000);

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
                System.Threading.Thread.Sleep(10000);
                bool clientElement = false;
                try
                {
                    clientElement = driver.FindElement(deal.clientElement).Displayed;

                    Console.WriteLine("Client Element    = " + clientElement);
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
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.financingTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(10000);
                bool financingFacElmnt = false;
                try
                {
                    financingFacElmnt = driver.FindElement(deal.financingFacElmnt).Displayed;

                    Console.WriteLine(" Financing facility element    = " + financingFacElmnt);
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
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.settlmntTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(10000);
                bool closingDateElmnt = false;
                try
                {
                    closingDateElmnt = driver.FindElement(deal.closingDateElmnt).Displayed;

                    Console.WriteLine(" Closing Date Element   = " + closingDateElmnt);
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
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.defaultTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(10000);
                bool effectiveDteElmnt = false;
                try
                {
                    effectiveDteElmnt = driver.FindElement(deal.effectiveDteElmnt).Displayed;

                    Console.WriteLine(" Effective Date Element  = " + effectiveDteElmnt);
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
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.servicingTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(10000);
                bool servicingNameElmnt = false;
                try
                {
                    servicingNameElmnt = driver.FindElement(deal.servicingNameElmnt).Displayed;

                    Console.WriteLine(" Servicing Name Element   = " + servicingNameElmnt);
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
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.actualsTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(10000);
                bool interestElement = false;
                try
                {
                    interestElement = driver.FindElement(deal.interestElement).Displayed;

                    Console.WriteLine(" Interest Element    = " + interestElement);
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

                //PIK Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.pikTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(10000);
                bool pikSourceElement = false;
                try
                {
                    pikSourceElement = driver.FindElement(deal.pikSourceElement).Displayed;

                    Console.WriteLine(" PIK source element    = " + pikSourceElement);
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
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.couponTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(10000);
                bool couponElement = false;
                try
                {
                    couponElement = driver.FindElement(deal.couponElement).Displayed;

                    Console.WriteLine(" Coupon Element    = " + couponElement);
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
                System.Threading.Thread.Sleep(10000);
                bool noteFundingElemnt = false;
                try
                {
                    noteFundingElemnt = driver.FindElement(deal.noteFundingElemnt).Displayed;

                    Console.WriteLine(" Funding Element    = " + noteFundingElemnt);
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
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.cashflowTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(10000);
                bool periodicOtpButton = false;
                try
                {
                    periodicOtpButton = driver.FindElement(deal.periodicOtpButton).Displayed;

                    Console.WriteLine(" Cashflow Element    = " + periodicOtpButton);
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
                System.Threading.Thread.Sleep(10000);
                bool exceptionElement = false;
                try
                {
                    exceptionElement = driver.FindElement(deal.exceptionElement).Displayed;

                    Console.WriteLine(" Exception Element    = " + exceptionElement);
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
                System.Threading.Thread.Sleep(10000);
                bool noteDocTabElmnt = false;
                try
                {
                    noteDocTabElmnt = driver.FindElement(deal.noteDocTabElmnt).Displayed;
                    Console.WriteLine(" Note Document Element    = " + noteDocTabElmnt);
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
                System.Threading.Thread.Sleep(10000);
                bool noteActElement = false;
                try
                {
                    noteActElement = driver.FindElement(deal.noteActElement).Displayed;

                    Console.WriteLine(" Note Activity Element    = " + noteActElement);
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

                //---------------------My Account Verification------------------------------
                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/myaccount");
                System.Threading.Thread.Sleep(10000);
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
                System.Threading.Thread.Sleep(10000);
                bool accountTabElmnt = false;
                try
                {
                    accountTabElmnt = driver.FindElement(deal.accountTabElmnt).Displayed;

                    Console.WriteLine(" Account Tab Element     = " + accountTabElmnt);
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
                System.Threading.Thread.Sleep(10000);
                bool preferenceTabElmnt = false;
                try
                {
                    preferenceTabElmnt = driver.FindElement(deal.preferenceTabElmnt).Displayed;

                    Console.WriteLine(" Preferences Tab Element     = " + preferenceTabElmnt);
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
                System.Threading.Thread.Sleep(15000);
                bool btnCreateRole = false;
                try
                {
                    btnCreateRole = driver.FindElement(deal.btnCreateRole).Displayed;

                    Console.WriteLine(" Profile Delegation Tab Element     = " + btnCreateRole);
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
                System.Threading.Thread.Sleep(10000);
                bool userManagementElmnt = false;
                try
                {
                    userManagementElmnt = driver.FindElement(deal.userManagementElmnt).Displayed;

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
                System.Threading.Thread.Sleep(10000);
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
                System.Threading.Thread.Sleep(10000);
                bool roleElmnt = false;
                bool addNewRoleBtn = false;
                try
                {
                    roleElmnt = driver.FindElement(deal.roleElmnt).Displayed;

                    Console.WriteLine(" Role Permission Element      = " + roleElmnt);
                    addtolist("User Management ", " Role Permission Tab ", roleElmnt);
                    System.Threading.Thread.Sleep(10000);
                    addNewRoleBtn = driver.FindElement(deal.addNewRoleBtn).Displayed;

                    Console.WriteLine(" Role Permission Element      = " + addNewRoleBtn);
                    addtolist("User Management ", " Role Permission Tab ", addNewRoleBtn);
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
                System.Threading.Thread.Sleep(10000);
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
                System.Threading.Thread.Sleep(10000);
                bool managaeAppStngElmnt = false;
                try
                {
                    managaeAppStngElmnt = driver.FindElement(deal.managaeAppStngElmnt).Displayed;

                    Console.WriteLine(" Manage App settings Element      = " + managaeAppStngElmnt);
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
                System.Threading.Thread.Sleep(10000);

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
                System.Threading.Thread.Sleep(10000);
                bool workAprvElmnt = false;
                try
                {
                    workAprvElmnt = driver.FindElement(deal.workAprvElmnt).Displayed;

                    Console.WriteLine(" WorkFlow Approver Element      = " + workAprvElmnt);
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
                System.Threading.Thread.Sleep(10000);
                //-----------------------------------------Data Management----------------

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/datamanagement");
                System.Threading.Thread.Sleep(20000);
                // Delete Deal Tab
                bool deleteDealName = false;
                try
                {
                    deleteDealName = driver.FindElement(deal.deleteDealName).Displayed;

                    Console.WriteLine("Data Management- Delete deal tab     = " + deleteDealName);
                    addtolist("Data Management ", " Delete deal Tab ", deleteDealName);
                    /* var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (deleteDealName == false)
                    {
                        printMessage += $"Message: <br>{"Data management Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Data management loaded sucessfully");
                    }*/
                }
                catch (Exception ex)
                {

                    deleteDealName = false;
                    throw ex;
                }
                //Delete Note Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.deleteNoteTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(8000);
                bool deleteNoteElmnt = false;
                try
                {
                    deleteNoteElmnt = driver.FindElement(deal.deleteNoteElmnt).Displayed;

                    Console.WriteLine("Data Management- Delete Note tab     = " + deleteNoteElmnt);
                    addtolist("Data Management ", " Delete note Tab ", deleteNoteElmnt);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (deleteNoteElmnt == false)
                    {
                        printMessage += $"Message: <br>{"Delete note Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Delete note loaded sucessfully");
                    }*/

                }
                catch (Exception ex)
                {

                    deleteNoteElmnt = false;
                    throw ex;
                }
                //Upload file Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.uploadFileTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(8000);
                bool dailyExtractBtn = false;
                try
                {
                    dailyExtractBtn = driver.FindElement(deal.dailyExtractBtn).Displayed;

                    Console.WriteLine("Data Management- Upload file tab     = " + dailyExtractBtn);
                    addtolist("Data Management ", " Upload File Tab ", dailyExtractBtn);
                    /* var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (dailyExtractBtn == false)
                    {
                        printMessage += $"Message: <br>{"Upload file Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Upload file loaded sucessfully");
                    }*/
                }
                catch (Exception ex)
                {

                    dailyExtractBtn = false;
                    throw ex;
                }
                // Servicer Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.servicerTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(8000);
                bool serviceName = false;
                try
                {
                    serviceName = driver.FindElement(deal.serviceName).Displayed;

                    Console.WriteLine("Data Management- Servicer tab     = " + serviceName);
                    addtolist("Data Management ", " Servicer Tab ", serviceName);
                    /* var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (serviceName == false)
                    {
                        printMessage += $"Message: <br>{"Servicer Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Servicer loaded sucessfully");
                    }*/
                }
                catch (Exception ex)
                {

                    serviceName = false;
                    throw ex;

                }
                //Transaction type Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.transactionTypesTab).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(8000);
                bool transactionTypeElmnt = false;
                try
                {
                    transactionTypeElmnt = driver.FindElement(deal.transactionTypeElmnt).Displayed;

                    Console.WriteLine("Data Management- Transaction Type tab     = " + transactionTypeElmnt);
                    addtolist("Data Management ", " Transaction Type tab ", transactionTypeElmnt);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (transactionTypeElmnt == false)
                   {
                       printMessage += $"Message: <br>{"Transaction Type Page Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "Transaction type loaded sucessfully");
                   }*/
                }
                catch (Exception ex)
                {

                    transactionTypeElmnt = false;
                    throw ex;
                }
                System.Threading.Thread.Sleep(8000);


                //--------------------------------Notification Subscription-----------------------------------------//

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/notificationsubscription");

                System.Threading.Thread.Sleep(8000);
                bool notifiSubElmnt = false;
                try
                {
                    notifiSubElmnt = driver.FindElement(deal.notifiSubElmnt).Displayed;

                    Console.WriteLine("Notification Subscription     = " + notifiSubElmnt);
                    addtolist("Notification Subscription ", " Notification Subscription ", notifiSubElmnt);
                    /* var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (notifiSubElmnt == false)
                    {
                        printMessage += $"Message: <br>{"Notification subscription Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Notification subscription loaded sucessfully");
                    }*/
                }
                catch (Exception ex)
                {

                    notifiSubElmnt = false;
                    throw ex;
                }

                //---------------------------------------Scenarios verification-------------------------------//

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/scenarios");
                System.Threading.Thread.Sleep(10000);
                bool addScenarioBtn = false;
                try
                {
                    addScenarioBtn = driver.FindElement(deal.addScenarioBtn).Displayed;

                    Console.WriteLine(" Scenario Element      = " + addScenarioBtn);
                    addtolist("Scenario ", " Scenarios ", addScenarioBtn);

                    /* var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (addScenarioBtn == false)
                    {
                        printMessage += $"Message: <br>{"Scenario Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Scenario loaded sucessfully");
                    }*/
                }
                catch (Exception ex)
                {
                    addScenarioBtn = false;
                    throw ex;
                }
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.addScenarioBtn).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(10000);
                /* bool scenarioName = false;

                 try
                 {
                     scenarioName = driver.FindElement(deal.scenarioName).Displayed;

                     Console.WriteLine(" Add Scenario Element     = " + scenarioName);
                    addtolist("Scenario ", " Add Scenarios ", scenarioName);
                     System.Threading.Thread.Sleep(10000);*/



                //addtolist("Scenario ", " Add Scenarios ", calculationMode);
                /*var printMessage = "<p><b>Test FAILED!</b></p>";
               if (scenarioName == false || calculationMode == false)
               {
                   printMessage += $"Message: <br>{"Add Scenario Page Load Error"}<br>";
                   test.Fail(printMessage);
               }
               else
               {
                   test.Log(Status.Pass, "Add Scenario loaded sucessfully");
               }*/
                /*}
                catch (Exception ex)
                {

                    scenarioName = false;
                    
                    throw ex;
                }*/

                //------------------------------------Index page Verification---------------------------------------//

                //driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/indexes");
                // System.Threading.Thread.Sleep(10000);
                //bool addIndexScenarioBtn = false;
                // try
                //{
                // addIndexScenarioBtn = driver.FindElement(deal.addIndexScenarioBtn).Displayed;

                //Console.WriteLine(" Index Scenario Element     = " + addIndexScenarioBtn);
                // addtolist("Index Scenario ", " Index Scenarios ", addIndexScenarioBtn);
                /*var printMessage = "<p><b>Test FAILED!</b></p>";
               if (addIndexScenarioBtn == false)
               {
                   printMessage += $"Message: <br>{"Index Page Load Error"}<br>";
                   test.Fail(printMessage);
               }
               else
               {
                   test.Log(Status.Pass, "Index loaded sucessfully");
               }*/
                // }
                //catch (Exception ex)
                // {

                //  addIndexScenarioBtn = false;
                // throw ex;
                // }
                //  try
                // {
                //     driver.FindElement(deal.addIndexScenarioBtn).Click();
                // }
                // catch (Exception e)
                //{

                // }
                // System.Threading.Thread.Sleep(20000);
                // bool indexName = false;
                //bool indexDescription = false;
                // try
                //{
                //indexName = driver.FindElement(deal.indexName).Displayed;

                //Console.WriteLine(" Add Index Scenario Element     = " + indexName);
                //addtolist("Index Scenario ", " Add Index Scenarios ", indexName);
                // System.Threading.Thread.Sleep(20000);
                //indexDescription = driver.FindElement(deal.indexDescription).Displayed;

                // Console.WriteLine(" Add Index Scenario Element     = " + indexDescription);
                // addtolist("Index Scenario ", " Add Index Scenarios ", indexDescription);
                /* var printMessage = "<p><b>Test FAILED!</b></p>";
                if (indexName == false || indexDescription == false)
                {
                    printMessage += $"Message: <br>{"Add index Page Load Error"}<br>";
                    test.Fail(printMessage);
                }
                else
                {
                    test.Log(Status.Pass, "Add index  loaded sucessfully");
                }*/
                //}
                // catch (Exception ex)
                //{

                // indexDescription = false;
                // indexName = false;
                //  throw ex;
                // }
                //-------------------------------Fee Configuration----------------------------------------//


                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/feeconfiguration");
                System.Threading.Thread.Sleep(10000);

                // Fee Function Definition Tab
                bool feeFuncDefElmnt = false;
                try
                {
                    feeFuncDefElmnt = driver.FindElement(deal.feeFuncDefElmnt).Displayed;

                    Console.WriteLine(" Fee Function Definition Element     = " + feeFuncDefElmnt);
                    addtolist("Fee Configuration ", " Fee Function Definition ", feeFuncDefElmnt);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (feeFuncDefElmnt == false)
                   {
                       printMessage += $"Message: <br>{"Fee configuration Page Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "Fee configuration loaded sucessfully");
                   }*/
                }
                catch (Exception ex)
                {

                    feeFuncDefElmnt = false;
                    throw ex;
                }
                //Base Amount Determination Tab
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.baseAmntDeterm).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(10000);
                bool baseAmntDetermElmnt = false;
                try
                {
                    baseAmntDetermElmnt = driver.FindElement(deal.baseAmntDetermElmnt).Displayed;

                    Console.WriteLine(" Base Amount Determination Element     = " + baseAmntDetermElmnt);
                    addtolist("Fee Configuration ", " Base Amount Determination ", baseAmntDetermElmnt);
                    /* var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (baseAmntDetermElmnt == false)
                    {
                        printMessage += $"Message: <br>{"Base Amount Determination Page Load Error"}<br>";
                    }
                    else
                    {
                        test.Log(Status.Pass, "Base Amount Determination loaded sucessfully");
                    }*/
                }
                catch (Exception ex)
                {

                    baseAmntDetermElmnt = false;
                    throw ex;
                }


                // ----------Dynamic Portfolio
                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/portfolio");
                System.Threading.Thread.Sleep(10000);
                bool addPortfolioBtn = false;
                try
                {
                    addPortfolioBtn = driver.FindElement(deal.addPortfolioBtn).Displayed;

                    Console.WriteLine(" Dynamic portfolio Element    = " + addPortfolioBtn);
                    addtolist("Dynamic Portfolio ", " Dynamic Portfolio ", addPortfolioBtn);

                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (addPortfolioBtn == false)
                   {
                       printMessage += $"Message: <br>{"Dynamic portfolio Page Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "Dynamic portfolio loaded sucessfully");
                   }*/
                }
                catch (Exception ex)
                {
                    addPortfolioBtn = false;
                    throw ex;
                }
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.addPortfolioBtn).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(10000);
                bool portfolioName = false;
                try
                {
                    portfolioName = driver.FindElement(deal.portfolioName).Displayed;

                    Console.WriteLine(" Dynamic portfolio Element    = " + portfolioName);
                    addtolist("Dynamic Portfolio ", " Add Portfolio ", portfolioName);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (portfolioName == false)
                   {
                       printMessage += $"Message: <br>{"Dynamic portfolio  Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "Dynamic portfolio loaded sucessfully");
                   }*/
                }
                catch (Exception ex)
                {

                    portfolioName = false;
                    throw ex;
                }

                //----------------------------------Transaction reconsilation----------------------------------------------------//

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/Transcationreconciliation");
                System.Threading.Thread.Sleep(10000);
                bool clearSectionBtn = false;
                bool downloadTemplateBtn = false;
                try
                {
                    clearSectionBtn = driver.FindElement(deal.clearSectionBtn).Displayed;

                    Console.WriteLine(" Transaction reconsilationElement    = " + clearSectionBtn);
                    addtolist("Transaction reconsilation ", " Transaction reconsilation ", clearSectionBtn);

                    downloadTemplateBtn = driver.FindElement(deal.downloadTemplateBtn).Displayed;

                    Console.WriteLine(" Transaction reconsilationElement    = " + downloadTemplateBtn);
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
                System.Threading.Thread.Sleep(10000);
                bool transcAuditElmnt = false;
                try
                {
                    transcAuditElmnt = driver.FindElement(deal.transcAuditElmnt).Displayed;

                    Console.WriteLine("Transacaction Audit    = " + transcAuditElmnt);
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
                //-------------------------Periodic Close-----------------------------------------//

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/periodicclose");
                System.Threading.Thread.Sleep(10000);
                bool closePeriodBtn = false;
                bool periodicEndDate = false;
                try
                {
                    closePeriodBtn = driver.FindElement(deal.closePeriodBtn).Displayed;

                    Console.WriteLine("Periodic Close   = " + closePeriodBtn);
                    addtolist("Periodic Close   ", " Periodic Close  ", closePeriodBtn);
                    System.Threading.Thread.Sleep(10000);
                    periodicEndDate = driver.FindElement(deal.periodicEndDate).Displayed;

                    Console.WriteLine("Periodic Close   = " + periodicEndDate);
                    addtolist("Periodic Close   ", " Periodic Close  ", periodicEndDate);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (closePeriodBtn == false || periodicEndDate == false)
                   {
                       printMessage += $"Message: <br>{"Periodic close Page Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "Periodic close loaded sucessfully");
                   }*/
                }
                catch (Exception ex)
                {

                    closePeriodBtn = false;
                    periodicEndDate = false;
                    throw ex;
                }


                //----------------------------------------Calculation Manager-------------------------------------//

                //calculation Manager

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/CalculationManager");
                System.Threading.Thread.Sleep(10000);
                bool calculationManagerElmnt = false;
                try
                {
                    calculationManagerElmnt = driver.FindElement(deal.calculationManagerElmnt).Displayed;

                    Console.WriteLine("calculation Manager Element   = " + calculationManagerElmnt);
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
                System.Threading.Thread.Sleep(10000);
                bool notesWthExcepElmnt = false;
                try
                {
                    notesWthExcepElmnt = driver.FindElement(deal.notesWthExcepElmnt).Displayed;

                    Console.WriteLine("Notes With Exception Element   = " + notesWthExcepElmnt);
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
                    System.Threading.Thread.Sleep(10000);
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                bool batchLogElmnt = false;
                try
                {
                    batchLogElmnt = driver.FindElement(deal.batchLogElmnt).Displayed;

                    Console.WriteLine("Batch Log Element   = " + batchLogElmnt);
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
                System.Threading.Thread.Sleep(8000);
                bool refreshDataWarehouseBtn = false;
                try
                {
                    refreshDataWarehouseBtn = driver.FindElement(deal.refreshDataWarehouseBtn).Displayed;
                    Console.WriteLine("Reports   = " + refreshDataWarehouseBtn);
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
                System.Threading.Thread.Sleep(8000);
                bool reportName = false;
                try
                {
                    reportName = driver.FindElement(deal.reportName).Displayed;
                    Console.WriteLine("Reports   = " + reportName);
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

                //----------------------------Tags---------------------------//

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/tags");
                System.Threading.Thread.Sleep(8000);
                bool addNewTagBtn = false;
                try
                {
                    addNewTagBtn = driver.FindElement(deal.addNewTagBtn).Displayed;
                    Console.WriteLine("Tags   = " + addNewTagBtn);
                    addtolist("Tags   ", " Tags ", addNewTagBtn);
                    /* var printMessage = "<p><b>Test FAILED!</b></p>";
                    if (addNewTagBtn == false)
                    {
                        printMessage += $"Message: <br>{"Tags Page Load Error"}<br>";
                        test.Fail(printMessage);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Tags page loaded sucessfully");
                    }*/

                }
                catch (Exception ex)
                {
                    addNewTagBtn = false;
                    throw ex;
                }

                //----------------------WorkFlow-----------------------------------//

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/workflow");
                System.Threading.Thread.Sleep(8000);
                bool workflowElmnt = false;
                try
                {
                    workflowElmnt = driver.FindElement(deal.workflowElmnt).Displayed;

                    Console.WriteLine("Workflow   = " + workflowElmnt);
                    addtolist("Workflow   ", " Workflow ", workflowElmnt);
                    /*var printMessage = "<p><b>Test FAILED!</b></p>";
                   if (workflowElmnt == false)
                   {
                       printMessage += $"Message: <br>{"Workflow Page Load Error"}<br>";
                       test.Fail(printMessage);
                   }
                   else
                   {
                       test.Log(Status.Pass, "Workflow page loaded sucessfully");
                   }
                    */
                }
                catch (Exception ex)
                {
                    workflowElmnt = false;
                    throw ex;
                }

                //----------------Task Management--------

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/task");
                System.Threading.Thread.Sleep(8000);
                bool addTaskBtn = false;
                try
                {
                    addTaskBtn = driver.FindElement(deal.addTaskBtn).Displayed;


                    Console.WriteLine("Task Management  = " + addTaskBtn);
                    addtolist("Task Management   ", " Task Management ", addTaskBtn);
                    /* var printMessages = "<p><b>Test FAILED!</b></p>";
                    if (addTaskBtn == false)
                    {
                        printMessages += $"Message: <br>{"Task management page Load Error"}<br>";
                        test.Fail(printMessages);
                    }
                    else
                    {
                        test.Log(Status.Pass, "Task management page loaded sucessfully");
                    }*/

                }
                catch (Exception ex)
                {

                    addTaskBtn = false;
                    throw ex;
                }
#pragma warning disable CS0168 // The variable 'e' is declared but never used
                try
                {
                    driver.FindElement(deal.addTaskBtn).Click();
                }
                catch (Exception e)
                {

                }
#pragma warning restore CS0168 // The variable 'e' is declared but never used
                System.Threading.Thread.Sleep(5000);
                bool addTaskElmnt = false;
                bool summaryElmnt = false;
                try
                {
                    addTaskElmnt = driver.FindElement(deal.addTaskElmnt).Displayed;

                    Console.WriteLine("Task Management  = " + addTaskElmnt);
                    addtolist("Task Management   ", " Add Task ", addTaskElmnt);

                    summaryElmnt = driver.FindElement(deal.summaryElmnt).Displayed;

                    Console.WriteLine("Task Management  = " + summaryElmnt);
                    addtolist("Task Management   ", " Add Task ", summaryElmnt);
                    /*var printMessages = "<p><b>Test FAILED!</b></p>";
                   if (addTaskBtn == false || addTaskElmnt == false)
                   {
                       printMessages += $"Message: <br>{"Task management Page Load Error"}<br>";
                       test.Fail(printMessages);
                   }
                   else
                   {
                       test.Log(Status.Pass, "Task management page  loaded sucessfully");
                   }*/


                }
                catch (Exception ex)
                {

                    addTaskElmnt = false;
                    summaryElmnt = false;
                    throw ex;
                }
                //------------------------------Help----------------------------------------//

                driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/help");
                System.Threading.Thread.Sleep(8000);
                bool helpBtn = false;
                bool contactUsHeading = false;

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
                try
                {
                    helpBtn = driver.FindElement(deal.helpBtn).Displayed;

                    Console.WriteLine("Help  = " + helpBtn);
                    addtolist("Help  ", " Help ", helpBtn);

                    contactUsHeading = driver.FindElement(deal.contactUsHeading).Displayed;

                    Console.WriteLine("Help  = " + contactUsHeading);
                    addtolist("Help  ", " Help ", contactUsHeading);

                    /*var printMessages = "<p><b>Test FAILED!</b></p>";
                   if (helpBtn == false || contactUsHeading == false || CancelButton == false)
                   {
                       printMessages += $"Message: <br>{"Help Page Load Error"}<br>";
                       test.Fail(printMessages);
                   }
                   else
                   {
                       test.Log(Status.Pass, "Help page loaded sucessfully");
                   }*/

                }
                catch (Exception ex)
                {

                    helpBtn = false;
                    contactUsHeading = false;
                    CancelButton = false;
                }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
                GenerateExcelFile.CreateExcelDataTable((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(listPageLoad), (typeof(DataTable))), "PageLoad");

                //----------------------------Logout-----------//

                // try
                // {
                // driver.FindElement(deal.krishnaDropdown).Click();
                // System.Threading.Thread.Sleep(10000);

                // driver.FindElement(deal.logoutBtn).Click();
                //  System.Threading.Thread.Sleep(8000);
                // }
                // catch (Exception e)
                // {

                // }
                // bool logoutElmnt = false;
                //try
                // {
                //  logoutElmnt = driver.FindElement(deal.loginPage).Displayed;
                // Console.WriteLine("Logout  = " + logoutElmnt);
                // addtolist("Logout  ", " Logout ", logoutElmnt);*/
                /* var printMessages = "<p><b>Test FAILED!</b></p>";
                if (logoutElmnt == false)
                {
                    printMessages += $"Message: <br>{"Logout Page Load Error"}<br>";
                    test.Fail(printMessages);
                }
                else
                {
                    test.Log(Status.Pass, "Logout Page loaded sucessfully");
                }*/

                // }
                // catch (Exception ex)
                // {

                // logoutElmnt = false;
                // throw ex;
                // }
                System.Threading.Thread.Sleep(7000);




                String times = GeneralVerification_weekly.Timestamp();

                GeneralVerification_weekly.CreateExcelDataTableNew((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(listPageLoad), (typeof(DataTable))), "PageLoad");
                //String time = VerifyDeal.Timestamp();
                System.Threading.Thread.Sleep(7000);

                // String FileName;

                String pathExcel = "PageLoad" + "_" + times + ".xlsx";
                Console.WriteLine("Excel report = =  " + pathExcel);
                // CreateExcelDataTableNew(pathExcel);
                System.Threading.Thread.Sleep(5000);
                string pathNew = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName;
                Console.WriteLine("Path of current directory " + pathNew);



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
                System.Threading.Thread.Sleep(10000);

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

    }


    //listPageLoad.Add(plt);
}



//Note save 






