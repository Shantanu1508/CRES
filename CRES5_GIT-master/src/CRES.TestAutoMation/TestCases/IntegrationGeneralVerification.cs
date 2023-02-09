using AventStack.ExtentReports;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.ExecutionReports;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using Newtonsoft.Json;
//using com.sun.tools.@internal.ws.processor.model;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;
using System;
using System.Collections.Generic;
using System.Data;
//using java.nio.file;
using System.IO;
using System.Threading;


// IntegrationGeneralVerification

namespace CRES.TestAutoMation.TestCases
{
    public class IntegrationGeneralVerification : BaseClass

    {
        ExtentTest test = null;
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
                String time = IntegrationGeneralVerification.Timestamp();

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
                throw ex;
            }
        }




        List<PageLoadTest> listPageLoad = new List<PageLoadTest>();


        // bool DealDataVerificationStatus = false;

        [Test]
        public void DealDataVerification()
        {

            Actions actions = new Actions(driver);

            CRES_Login loginapp = new CRES_Login();
            Login login = new Login(driver);
            Deal deal = new Deal(driver);
            CreateNewDeal createDeal = new CreateNewDeal(driver);
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
                    test = extent.CreateTest("General verification to load all the pages ").Info("Test started").AssignAuthor("Shantanu_Sharma");
                
                    String DealUrl = BaseUrl + "#/dealdetail/FDD8EC03-9D63-4512-9990-89C508983EDC";
                    util.OpenUrl(DealUrl);

                    //GeneralVerificationStatus = true;
                    //test.Log(Status.Pass, "All pages loaded sucessfully");
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
                    /*try
                    {
                        driver.FindElement(deal.fundingTab).Click();
                    }
                    catch (Exception e)
                    {

                    }
                    System.Threading.Thread.Sleep(10000);

                    var element = driver.FindElement(deal.btnGenerateFunding);
                    Actions action = new Actions(driver);
                    actions.MoveToElement(element);
                    actions.Perform();
                    System.Threading.Thread.Sleep(10000);
                    bool EnableFundingSchedule = false;
                    try
                    {
                        EnableFundingSchedule = driver.FindElement(deal.enableFundingSchedule).Displayed;
                        Console.WriteLine("EnableFundingSchedule=  " + EnableFundingSchedule);
                        addtolist("deal", "Funding", EnableFundingSchedule);
                        Console.WriteLine("EnableFundingSchedule = " + EnableFundingSchedule);
                        var printMessages = "<p><b>Test FAILED!</b></p>";
                        if (EnableFundingSchedule == false)
                        {
                            printMessages += $"Message: <br>{"Funding Page Load Error"}<br>";
                            test.Fail(printMessages);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Funding page loaded sucessfully");
                        }
                    }
                    catch (Exception ex)
                    {
                        EnableFundingSchedule = false;
                        throw ex;

                    }*/

                    //System.Threading.Thread.Sleep(20000);
                    //Boolean TotalCommitementAdjustment = driver.FindElement(By.ClassName("wj-form-control wj-numeric")).Displayed;
                    //Console.WriteLine("Total Commitement Adjustment= " + TotalCommitementAdjustment);
                    //System.Threading.Thread.Sleep(20000);





                    //MainTab



                    try
                    {
                        IWebElement mainTab = driver.FindElement(By.Id("aMain"));
                        mainTab.Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Main Tab Exception = " + e);
                    }
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
                        addtolist("deal", "Main", DealName);
                        var printMessages = "<p><b>Test FAILED!</b></p>";
                        if (DealID == false || DealName == false)
                        {
                            printMessages += $"Message: <br>{"Main Page Load Error"}<br>";
                            test.Fail(printMessages);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Main page loaded sucessfully");
                        }

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

                    try
                    {

                        driver.FindElement(deal.payRuleTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("PayRules Tab Exception = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);

                    bool PayrulePage = false;
                    try
                    {
                        PayrulePage = driver.FindElement(deal.payrulePage).Displayed;

                        Console.WriteLine("Payrul NoteID  = " + PayrulePage);
                        addtolist("deal", "Pay Rules", PayrulePage);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (PayrulePage == false)
                        {
                            printMessage += $"Message: <br>{"Payrules Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Payrules page loaded sucessfully");
                        }

                    }
                    catch (Exception ex)
                    {
                        PayrulePage = false;

                        throw ex;
                    }


                    //Commitement/Equity tab

                    try
                    {
                        driver.FindElement(deal.totalCommitementTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("TotalCommitement tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool TotalCommitmentCheck = false;
                    try
                    {
                        TotalCommitmentCheck = driver.FindElement(By.XPath("//*[@id=\"DealAdjustedtotalCommitment\"]/div/div/div[2]/label")).Displayed;

                        Console.WriteLine("Total commitment check  = " + TotalCommitmentCheck);
                        addtolist("deal", "Total commitment ", TotalCommitmentCheck);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (TotalCommitmentCheck == false)
                        {
                            printMessage += $"Message: <br>{"Total commitement Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Total commitement page loaded sucessfully");
                        }
                        System.Threading.Thread.Sleep(10000);




                    }
                    catch (Exception ex)
                    {
                        TotalCommitmentCheck = false;
                        throw ex;
                    }


                    //PayOff
                    /* try
                     {
                         driver.FindElement(deal.payOffTab).Click();
                     }
                     catch (Exception e)
                     {

                     }
                     System.Threading.Thread.Sleep(10000);
                     bool PayOffCheck = false;
                     try
                     {
                         PayOffCheck = driver.FindElement(deal.payOffCheckElement).Displayed;

                         Console.WriteLine("PayOff check  = " + PayOffCheck);
                         addtolist("deal", "PayOff ", PayOffCheck);
                         var printMessage = "<p><b>Test FAILED!</b></p>";
                         if (PayOffCheck == false)
                         {
                             printMessage += $"Message: <br>{"Pay off Page Load Error"}<br>";
                             test.Fail(printMessage);
                         }
                         else
                         {
                             test.Log(Status.Pass, "Pay off page loaded sucessfully");
                         }

                     }
                     catch (Exception ex)
                     {
                         PayOffCheck = false;
                         throw ex;
                     }*/
                    System.Threading.Thread.Sleep(10000);





                    //Documents


                    try
                    {
                        driver.FindElement(deal.documentsTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Documents tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool DocumentsCheck = false;
                    try
                    {

                        DocumentsCheck = driver.FindElement(deal.documentCheckElement).Displayed;

                        Console.WriteLine("Documents check  = " + DocumentsCheck);
                        addtolist("deal", "Documents ", DocumentsCheck);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (DocumentsCheck == false)
                        {
                            printMessage += $"Message: <br>{"Documents Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Documents page loaded sucessfully");
                        }
                    }
                    catch (Exception ex)
                    {

                        DocumentsCheck = false;
                        throw ex;
                    }
                    System.Threading.Thread.Sleep(10000);


                    //ActivityTab
                    try
                    {
                        driver.FindElement(deal.activityTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("ActivityTab tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool ActivityCheck = false;
                    try
                    {
                        ActivityCheck = driver.FindElement(deal.activityCheckElement).Displayed;

                        Console.WriteLine("Activity check  = " + ActivityCheck);
                        addtolist("deal", "Activity ", ActivityCheck);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (ActivityCheck == false)
                        {
                            printMessage += $"Message: <br>{"Activity Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Activity page loaded sucessfully");
                        }
                    }
                    catch (Exception ex)
                    {

                        ActivityCheck = false;
                        throw ex;
                    }
                    System.Threading.Thread.Sleep(5000);

                    //ButtonVerification


                    bool SaveButton = false;
                    try
                    {
                        SaveButton = driver.FindElement(deal.btnSaveDeal).Displayed;

                        Console.WriteLine("Save button  check  = " + SaveButton);
                        addtolist("deal", "Save Button ", SaveButton);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (SaveButton == false)
                        {
                            printMessage += $"Message: <br>{"Save button Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Save button checked sucessfully");
                        }
                    }
                    catch (Exception ex)
                    {

                        SaveButton = false;
                        throw ex;
                    }


                    System.Threading.Thread.Sleep(5000);
                    bool CancelButton = false;
                    try
                    {
                        CancelButton = driver.FindElement(deal.dealCancelButton).Displayed;

                        Console.WriteLine("Cancel button  check  = " + CancelButton);
                        addtolist("deal", "cancel Button ", CancelButton);

                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (CancelButton == false)
                        {
                            printMessage += $"Message: <br>{"Cancel button Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Cancel button checked sucessfully");
                        }

                    }
                    catch (Exception ex)
                    {
                        CancelButton = false;
                        throw ex;
                    }

                    System.Threading.Thread.Sleep(5000);
                    bool CopyDealButton = false;
                    try
                    {
                        CopyDealButton = driver.FindElement(deal.copyDealBtn).Displayed;

                        Console.WriteLine("Copy Deal  button  check  = " + CopyDealButton);
                        addtolist("deal", "Copy Deal  Button ", CopyDealButton);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (CopyDealButton == false)
                        {
                            printMessage += $"Message: <br>{"Copy deal button Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "copy deal  button checked sucessfully");
                        }

                    }
                    catch (Exception ex)
                    {

                        CopyDealButton = false;
                        throw ex;
                    }
                    System.Threading.Thread.Sleep(5000);
                    bool DownloadButton = false;
                    try
                    {
                        DownloadButton = driver.FindElement(deal.downloadButton).Displayed;

                        Console.WriteLine("Download button  check  = " + DownloadButton);
                        addtolist("deal", "Download Button ", DownloadButton);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (DownloadButton == false)
                        {
                            printMessage += $"Message: <br>{"Download button Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Download button checked sucessfully");
                        }
                    }
                    catch (Exception ex)
                    {
                        DownloadButton = false;
                        throw ex;
                    }
                    System.Threading.Thread.Sleep(5000);
                    bool AdminButton = false;
                    try
                    {
                        AdminButton = driver.FindElement(deal.adminButton).Displayed;

                        Console.WriteLine("Admin button  check  = " + AdminButton);
                        addtolist("deal", "Admin Button ", AdminButton);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (AdminButton == false)
                        {
                            printMessage += $"Message: <br>{"Admin button Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Admin button checked sucessfully");
                        }
                    }
                    catch (Exception ex)
                    {
                        AdminButton = false;
                        throw ex;
                    }
                    System.Threading.Thread.Sleep(5000);


                    //----------------------Note Details Verification---------------------------

                    string NoteUrl = BaseUrl + "#/notedetail/4bd379aa-162d-45f0-8ca6-22da944c6884";
                    util.OpenUrl(NoteUrl);
                    System.Threading.Thread.Sleep(5000);


                    //Closing Tab


                    try
                    {
                        driver.FindElement(deal.closingTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Closing Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool actualFreqElmnt = false;
                    try
                    {
                        actualFreqElmnt = driver.FindElement(deal.actualFreqElmnt).Displayed;

                        Console.WriteLine("Actual Freq Element   = " + actualFreqElmnt);
                        addtolist("Note ", "Closing Tab ", actualFreqElmnt);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (actualFreqElmnt == false)
                        {
                            printMessage += $"Message: <br>{"Closing page load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Closing page loaded sucessfully");
                        }
                    }
                    catch (Exception ex)
                    {
                        actualFreqElmnt = false;
                        throw ex;
                    }
                    System.Threading.Thread.Sleep(5000);


                    //AccountingTab


                    try
                    {
                        driver.FindElement(deal.accountingTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("AccountingTab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool clientElement = false;
                    try
                    {
                        clientElement = driver.FindElement(deal.clientElement).Displayed;

                        Console.WriteLine("Client Element    = " + clientElement);
                        addtolist("Note ", "Accounting Tab ", clientElement);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (clientElement == false)
                        {
                            printMessage += $"Message: <br>{"Accounting Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Accounting loaded sucessfully");
                        }
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
                        Console.WriteLine("Financing Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool financingFacElmnt = false;
                    try
                    {
                        financingFacElmnt = driver.FindElement(deal.financingFacElmnt).Displayed;

                        Console.WriteLine(" Financing facility element    = " + financingFacElmnt);
                        addtolist("Note ", "Financing Tab ", financingFacElmnt);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (financingFacElmnt == false)
                        {
                            printMessage += $"Message: <br>{"Financing Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Financing loaded sucessfully");
                        }
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
                        Console.WriteLine("Settelement Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool closingDateElmnt = false;
                    try
                    {
                        closingDateElmnt = driver.FindElement(deal.closingDateElmnt).Displayed;

                        Console.WriteLine(" Closing Date Element   = " + closingDateElmnt);
                        addtolist("Note ", "Settelment Tab ", closingDateElmnt);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (closingDateElmnt == false)
                        {
                            printMessage += $"Message: <br>{"Settelement Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Settelement loaded sucessfully");
                        }
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
                        Console.WriteLine("Default Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool effectiveDteElmnt = false;
                    try
                    {
                        effectiveDteElmnt = driver.FindElement(deal.effectiveDteElmnt).Displayed;

                        Console.WriteLine(" Effective Date Element  = " + effectiveDteElmnt);
                        addtolist("Note ", "Deafult Tab ", effectiveDteElmnt);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (effectiveDteElmnt == false)
                        {
                            printMessage += $"Message: <br>{"Default Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Default loaded sucessfully");
                        }
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
                        Console.WriteLine("Servicing Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool servicingNameElmnt = false;
                    try
                    {
                        servicingNameElmnt = driver.FindElement(deal.servicingNameElmnt).Displayed;

                        Console.WriteLine(" Servicing Name Element   = " + servicingNameElmnt);
                        addtolist("Note ", "Deafult Tab ", servicingNameElmnt);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (servicingNameElmnt == false)
                        {
                            printMessage += $"Message: <br>{"Servicing Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Servicing loaded sucessfully");
                        }
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
                        Console.WriteLine("Actuals Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool interestElement = false;
                    try
                    {
                        interestElement = driver.FindElement(deal.interestElement).Displayed;

                        Console.WriteLine(" Interest Element    = " + interestElement);
                        addtolist("Note ", "Actuals Tab ", interestElement);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (interestElement == false)
                        {
                            printMessage += $"Message: <br>{"Actuals Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Actuals loaded sucessfully");
                        }
                    }
                    catch (Exception ex)
                    {
                        interestElement = false;
                        throw ex;
                    }

                    //PIK Tab


                    try
                    {
                        driver.FindElement(deal.pikTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("PIK Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool pikSourceElement = false;
                    try
                    {
                        pikSourceElement = driver.FindElement(deal.pikSourceElement).Displayed;

                        Console.WriteLine(" PIK source element    = " + pikSourceElement);
                        addtolist("Note ", "PIK Tab ", pikSourceElement);

                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (pikSourceElement == false)
                        {
                            printMessage += $"Message: <br>{"PIK Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "PIK loaded sucessfully");
                        }
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
                        Console.WriteLine("Coupon Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool couponElement = false;
                    try
                    {
                        couponElement = driver.FindElement(deal.couponElement).Displayed;

                        Console.WriteLine(" Coupon Element    = " + couponElement);
                        addtolist("Note ", "Coupon Tab ", couponElement);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (couponElement == false)
                        {
                            printMessage += $"Message: <br>{"Coupon Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Coupon loaded sucessfully");
                        }
                    }
                    catch (Exception ex)
                    {

                        couponElement = false;
                        throw ex;
                    }


                    //Note Funding Tab


                    try
                    {
                        driver.FindElement(deal.noteFundingTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Note Funding Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool noteFundingElemnt = false;
                    try
                    {
                        noteFundingElemnt = driver.FindElement(deal.noteFundingElemnt).Displayed;

                        Console.WriteLine(" Funding Element    = " + noteFundingElemnt);
                        addtolist("Note ", "PIK Tab ", noteFundingElemnt);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (noteFundingElemnt == false)
                        {
                            printMessage += $"Message: <br>{"Note funding  Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Note funding loaded sucessfully");
                        }
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
                        Console.WriteLine("Cashflow Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool periodicOtpButton = false;
                    try
                    {
                        periodicOtpButton = driver.FindElement(deal.periodicOtpButton).Displayed;

                        Console.WriteLine(" Cashflow Element    = " + periodicOtpButton);
                        addtolist("Note ", "Cashflow Tab ", periodicOtpButton);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (periodicOtpButton == false)
                        {
                            printMessage += $"Message: <br>{"Cashflow Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Cashflow funding loaded sucessfully");
                        }
                    }
                    catch (Exception ex)
                    {

                        periodicOtpButton = false;
                        throw ex;
                    }


                    //Exceptions Tab


                    try
                    {
                        driver.FindElement(deal.exceptionTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Exceptions Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool exceptionElement = false;
                    try
                    {
                        exceptionElement = driver.FindElement(deal.exceptionElement).Displayed;

                        Console.WriteLine(" Exception Element    = " + exceptionElement);
                        addtolist("Note ", "Exception Tab ", exceptionElement);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (exceptionElement == false)
                        {
                            printMessage += $"Message: <br>{"Exception Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Exception funding loaded sucessfully");
                        }
                    }
                    catch (Exception ex)
                    {

                        exceptionElement = false;
                        throw ex;
                    }


                    //Notes Document Tab


                    try
                    {
                        driver.FindElement(deal.noteDocTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Notes Document Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool noteDocTabElmnt = false;
                    try
                    {
                        noteDocTabElmnt = driver.FindElement(deal.noteDocTabElmnt).Displayed;
                        Console.WriteLine(" Note Document Element    = " + noteDocTabElmnt);
                        addtolist("Note ", "Exception Tab ", noteDocTabElmnt);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (noteDocTabElmnt == false)
                        {
                            printMessage += $"Message: <br>{"Notes Document Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Notes Document funding loaded sucessfully");
                        }

                    }
                    catch (Exception ex)
                    {

                        noteDocTabElmnt = false;
                        throw ex;
                    }


                    //Activity Tab


                    try
                    {
                        driver.FindElement(deal.noteActTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Activity Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(3000);
                    bool noteActElement = false;
                    try
                    {
                        noteActElement = driver.FindElement(deal.noteActElement).Displayed;

                        Console.WriteLine(" Note Activity Element    = " + noteActElement);
                        addtolist("Note ", "Activity Tab ", noteActElement);
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (noteActElement == false)
                        {
                            printMessage += $"Message: <br>{"Activity Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Activity loaded sucessfully");
                        }
                    }
                    catch (Exception ex)
                    {

                        noteActElement = false;
                        throw ex;
                    }

                    //---------------------My Account Verification------------------------------


                    String MyAccounturl = BaseConfiguration.MyAccountUrl();
                    String OpenMyAccountUrl = BaseUrl + MyAccounturl;
                    util.OpenUrl(OpenMyAccountUrl);
                    System.Threading.Thread.Sleep(10000);


                    //Accounting Tab


                    try
                    {
                        driver.FindElement(deal.accountTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Accounting Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool accountTabElmnt = false;
                    try
                    {
                        accountTabElmnt = driver.FindElement(deal.accountTabElmnt).Displayed;

                        Console.WriteLine(" Account Tab Element     = " + accountTabElmnt);
                        addtolist("My Account ", "My Account  Tab ", accountTabElmnt);
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
                        throw ex;

                    }


                    //Preferences Tab


                    try
                    {
                        driver.FindElement(deal.preferencesTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Preferences Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool preferenceTabElmnt = false;
                    try
                    {
                        preferenceTabElmnt = driver.FindElement(deal.preferenceTabElmnt).Displayed;

                        Console.WriteLine(" Preferences Tab Element     = " + preferenceTabElmnt);
                        addtolist("My Account ", "Preferences  Tab ", preferenceTabElmnt);
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
                        throw ex;
                    }


                    //Profile Delegation Tab


                    try
                    {
                        driver.FindElement(deal.profileDelegTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Profile Delegation Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool btnCreateRole = false;
                    try
                    {
                        btnCreateRole = driver.FindElement(deal.btnCreateRole).Displayed;

                        Console.WriteLine(" Profile Delegation Tab Element     = " + btnCreateRole);
                        addtolist("My Account ", " Profile Delegation Tab ", btnCreateRole);
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
                        throw ex;
                    }

                    //--------------------------User Management verification----------------------------------------------//

                    // User management tab


                    String UserManagementurl = BaseConfiguration.UserManagementUrl();
                    String OpenUserManagementUrl = BaseUrl + UserManagementurl;
                    util.OpenUrl(OpenUserManagementUrl);

                    System.Threading.Thread.Sleep(10000);
                    bool userManagementElmnt = false;
                    try
                    {
                        userManagementElmnt = driver.FindElement(deal.userManagementElmnt).Displayed;

                        Console.WriteLine(" User Management Element      = " + userManagementElmnt);
                        addtolist("User Management ", " User Management Tab ", userManagementElmnt);
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
                        throw ex;
                    }
                    System.Threading.Thread.Sleep(10000);


                    // Role Permission Tab


                    try
                    {
                        driver.FindElement(deal.rolePermissionTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Profile Delegation Tab = " + e);
                    }
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
                        throw ex;
                    }
                    System.Threading.Thread.Sleep(5000);


                    //Manage App settings Tab


                    try
                    {
                        driver.FindElement(deal.manageAppSettngsTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Manage App settings Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool managaeAppStngElmnt = false;
                    try
                    {
                        managaeAppStngElmnt = driver.FindElement(deal.managaeAppStngElmnt).Displayed;

                        Console.WriteLine(" Manage App settings Element      = " + managaeAppStngElmnt);
                        addtolist("User Management ", " Manage App settings Tab ", managaeAppStngElmnt);
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
                        throw ex;
                    }
                    System.Threading.Thread.Sleep(5000);



                    //Workflow Approver Tab



                    try
                    {
                        driver.FindElement(deal.workflowApprovTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Workflow Approver Tab = " + e);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool workAprvElmnt = false;
                    try
                    {
                        workAprvElmnt = driver.FindElement(deal.workAprvElmnt).Displayed;

                        Console.WriteLine(" WorkFlow Approver Element      = " + workAprvElmnt);
                        addtolist("User Management ", " Workflow Approver Tab ", workAprvElmnt);
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
                        throw ex;
                    }
                    System.Threading.Thread.Sleep(10000);


                    //-----------------------------------------Data Management----------------

                    String DataManagementUrl = BaseUrl + BaseConfiguration.DataManagementUrl();
                    util.OpenUrl(DataManagementUrl);
                    System.Threading.Thread.Sleep(5000);


                    // Delete Deal Tab



                    bool deleteDealName = false;
                    try
                    {
                        deleteDealName = driver.FindElement(deal.deleteDealName).Displayed;

                        Console.WriteLine("Data Management- Delete deal tab     = " + deleteDealName);
                        addtolist("Data Management ", " Delete deal Tab ", deleteDealName);
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
                        throw ex;
                    }


                    //Delete Note Tab


                    try
                    {
                        driver.FindElement(deal.deleteNoteTab).Click();
                    }
                    catch (Exception e)
                    {

                    }
                    System.Threading.Thread.Sleep(8000);
                    bool deleteNoteElmnt = false;
                    try
                    {
                        deleteNoteElmnt = driver.FindElement(deal.deleteNoteElmnt).Displayed;

                        Console.WriteLine("Data Management- Delete Note tab     = " + deleteNoteElmnt);
                        addtolist("Data Management ", " Delete note Tab ", deleteNoteElmnt);
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
                        throw ex;
                    }
                    //Upload file Tab
                    /* try
                     {
                         driver.FindElement(deal.uploadFileTab).Click();
                     }
                     catch (Exception e)
                     {

                     }
                     System.Threading.Thread.Sleep(8000);
                     bool dailyExtractBtn = false;
                     try
                     {
                         dailyExtractBtn = driver.FindElement(deal.dailyExtractBtn).Displayed;

                         Console.WriteLine("Data Management- Upload file tab     = " + dailyExtractBtn);
                         addtolist("Data Management ", " Upload File Tab ", dailyExtractBtn);
                         var printMessage = "<p><b>Test FAILED!</b></p>";
                         if (dailyExtractBtn == false)
                         {
                             printMessage += $"Message: <br>{"Upload file Page Load Error"}<br>";
                             test.Fail(printMessage);
                         }
                         else
                         {
                             test.Log(Status.Pass, "Upload file loaded sucessfully");
                         }
                     }
                     catch (Exception ex)
                     {

                         dailyExtractBtn = false;
                         throw ex;
                     }*/



                    // Servicer Tab


                    try
                    {
                        driver.FindElement(deal.servicerTab).Click();
                    }
                    catch (Exception e)
                    {

                    }
                    System.Threading.Thread.Sleep(8000);
                    bool serviceName = false;
                    try
                    {
                        serviceName = driver.FindElement(deal.serviceName).Displayed;

                        Console.WriteLine("Data Management- Servicer tab     = " + serviceName);
                        addtolist("Data Management ", " Servicer Tab ", serviceName);
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
                        throw ex;

                    }


                    //Transaction type Tab


                    try
                    {
                        driver.FindElement(deal.transactionTypesTab).Click();
                    }
                    catch (Exception e)
                    {

                    }
                    System.Threading.Thread.Sleep(8000);
                    bool transactionTypeElmnt = false;
                    try
                    {
                        transactionTypeElmnt = driver.FindElement(deal.transactionTypeElmnt).Displayed;

                        Console.WriteLine("Data Management- Transaction Type tab     = " + transactionTypeElmnt);
                        addtolist("Data Management ", " Transaction Type tab ", transactionTypeElmnt);
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
                        throw ex;
                    }
                    System.Threading.Thread.Sleep(5000);


                    //--------------------------------Notification Subscription-----------------------------------------//

                    String NotifSubUrl = BaseUrl + BaseConfiguration.NotificationSubsUrl();
                    util.OpenUrl(NotifSubUrl);
                    System.Threading.Thread.Sleep(8000);
                    bool IntnotifiSubElmnt = false;
                    try
                    {
                        IntnotifiSubElmnt = driver.FindElement(deal.IntnotifiSubElmnt).Displayed;

                        Console.WriteLine("Notification Subscription     = " + IntnotifiSubElmnt);
                        addtolist("Notification Subscription ", " Notification Subscription ", IntnotifiSubElmnt);
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
                        throw ex;
                    }

                    //---------------------------------------Scenarios verification-------------------------------//

                    String ScenariosUrl = BaseUrl + BaseConfiguration.ScenarioUrl();
                    util.OpenUrl(ScenariosUrl);
                    System.Threading.Thread.Sleep(10000);
                    bool addScenarioBtn = false;
                    try
                    {
                        addScenarioBtn = driver.FindElement(deal.addScenarioBtn).Displayed;

                        Console.WriteLine(" Scenario Element      = " + addScenarioBtn);
                        addtolist("Scenario ", " Scenarios ", addScenarioBtn);

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
                        throw ex;
                    }
                    try
                    {
                        driver.FindElement(deal.addScenarioBtn).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("add Scenario Button = " + e.Message);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool scenarioName = false;
                    bool calculationMode = false;
                    try
                    {
                        scenarioName = driver.FindElement(deal.scenarioName).Displayed;

                        Console.WriteLine(" Add Scenario Element     = " + scenarioName);
                        addtolist("Scenario ", " Add Scenarios ", scenarioName);
                        System.Threading.Thread.Sleep(10000);
                        calculationMode = driver.FindElement(deal.calculationMode).Displayed;

                        Console.WriteLine(" Add Scenario Element     = " + calculationMode);
                        addtolist("Scenario ", " Add Scenarios ", calculationMode);
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
                        throw ex;
                    }

                    //------------------------------------Index page Verification---------------------------------------//

                    String IndexPageurl = BaseUrl + BaseConfiguration.IndexPageUrl();
                    util.OpenUrl(IndexPageurl);
                    System.Threading.Thread.Sleep(10000);
                    bool addIndexScenarioBtn = false;
                    try
                    {
                        addIndexScenarioBtn = driver.FindElement(deal.addIndexScenarioBtn).Displayed;

                        Console.WriteLine(" Index Scenario Element     = " + addIndexScenarioBtn);
                        addtolist("Index Scenario ", " Index Scenarios ", addIndexScenarioBtn);
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
                        throw ex;
                    }
                    try
                    {
                        driver.FindElement(deal.addIndexScenarioBtn).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Index page verification Button = " + e.Message);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool indexName = false;
                    bool indexDescription = false;
                    try
                    {
                        indexName = driver.FindElement(deal.indexName).Displayed;

                        Console.WriteLine(" Add Index Scenario Element     = " + indexName);
                        addtolist("Index Scenario ", " Add Index Scenarios ", indexName);
                        System.Threading.Thread.Sleep(10000);
                        indexDescription = driver.FindElement(deal.indexDescription).Displayed;

                        Console.WriteLine(" Add Index Scenario Element     = " + indexDescription);
                        addtolist("Index Scenario ", " Add Index Scenarios ", indexDescription);
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
                        throw ex;
                    }


                    //-------------------------------Fee Configuration----------------------------------------//


                    String FeeConfigurl = BaseUrl + BaseConfiguration.FeeConfigUrl();
                    util.OpenUrl(FeeConfigurl);
                    System.Threading.Thread.Sleep(8000);


                    // Fee Function Definition Tab


                    bool feeFuncDefElmnt = false;
                    try
                    {
                        feeFuncDefElmnt = driver.FindElement(deal.feeFuncDefElmnt).Displayed;

                        Console.WriteLine(" Fee Function Definition Element     = " + feeFuncDefElmnt);
                        addtolist("Fee Configuration ", " Fee Function Definition ", feeFuncDefElmnt);
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
                        throw ex;
                    }

                    //Base Amount Determination Tab

                    try
                    {
                        driver.FindElement(deal.baseAmntDeterm).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Base Amount Determination Exception = " + e.Message);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool baseAmntDetermElmnt = false;
                    try
                    {
                        baseAmntDetermElmnt = driver.FindElement(deal.baseAmntDetermElmnt).Displayed;

                        Console.WriteLine(" Base Amount Determination Element     = " + baseAmntDetermElmnt);
                        addtolist("Fee Configuration ", " Base Amount Determination ", baseAmntDetermElmnt);
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
                        throw ex;
                    }


                    // ----------Dynamic Portfolio---------------------------------------------


                    String DynamicPortfolioUrl = BaseUrl + BaseConfiguration.DynamicPortfolioUrl();
                    util.OpenUrl(DynamicPortfolioUrl);
                    System.Threading.Thread.Sleep(10000);
                    bool addPortfolioBtn = false;
                    try
                    {
                        addPortfolioBtn = driver.FindElement(deal.addPortfolioBtn).Displayed;

                        Console.WriteLine(" Dynamic portfolio Element    = " + addPortfolioBtn);
                        addtolist("Dynamic Portfolio ", " Dynamic Portfolio ", addPortfolioBtn);

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
                        throw ex;
                    }
                    try
                    {
                        driver.FindElement(deal.addPortfolioBtn).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Dynamic Portfolio Button Exception = " + e.Message);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool portfolioName = false;
                    try
                    {
                        portfolioName = driver.FindElement(deal.portfolioName).Displayed;

                        Console.WriteLine(" Dynamic portfolio Element    = " + portfolioName);
                        addtolist("Dynamic Portfolio ", " Add Portfolio ", portfolioName);
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
                        throw ex;
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

                        Console.WriteLine(" Transaction reconsilationElement    = " + clearSectionBtn);
                        addtolist("Transaction reconsilation ", " Transaction reconsilation ", clearSectionBtn);

                        downloadTemplateBtn = driver.FindElement(deal.downloadTemplateBtn).Displayed;

                        Console.WriteLine(" Transaction reconsilationElement    = " + downloadTemplateBtn);
                        addtolist("Transaction reconsilation ", " Transaction reconsilation ", downloadTemplateBtn);

                        transReconPage = driver.FindElement(deal.InttransReconPage).Displayed;

                        Console.WriteLine(" Transaction reconsilationElement    = " + transReconPage);
                        addtolist("Transaction reconsilation ", " Transaction reconsilation ", transReconPage);

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
                        throw ex;
                    }


                    //Transacaction Audit 

                    //Transacaction Audit 

                    String IntTransacAuditUrl = BaseUrl + BaseConfiguration.IntTransactionauditURL();
                    util.OpenUrl(IntTransacAuditUrl);
                    System.Threading.Thread.Sleep(10000);
                    bool transcAuditPage = false;
                    try
                    {
                        transcAuditPage = driver.FindElement(deal.transcAuditPage).Displayed;

                        Console.WriteLine("Transacaction Audit    = " + transcAuditPage);
                        addtolist("Transacaction Audit  ", " Transacaction Audit ", transcAuditPage);
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
                        throw ex;
                    }
                    //-------------------------Periodic Close-----------------------------------------//

                    String PeriodicloseUrl = BaseUrl + BaseConfiguration.periodicCloseUrl();
                    util.OpenUrl(PeriodicloseUrl);
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
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        if (closePeriodBtn == false || periodicEndDate == false)
                        {
                            printMessage += $"Message: <br>{"Periodic close Page Load Error"}<br>";
                            test.Fail(printMessage);
                        }
                        else
                        {
                            test.Log(Status.Pass, "Periodic close loaded sucessfully");
                        }
                    }
                    catch (Exception ex)
                    {

                        closePeriodBtn = false;
                        periodicEndDate = false;
                        Console.WriteLine("Periodic close Exception = " + ex.Message);
                        throw ex;
                    }


                    //----------------------------------------Calculation Manager-------------------------------------//

                    //calculation Manager

                    String IntCalcManagerUrl = BaseUrl + BaseConfiguration.IntCalculationManagerUrl();
                    util.OpenUrl(IntCalcManagerUrl);
                    System.Threading.Thread.Sleep(10000);
                    bool calculationManagerElmnt = false;
                    try
                    {
                        calculationManagerElmnt = driver.FindElement(deal.calculationManagerElmnt).Displayed;

                        Console.WriteLine("calculation Manager Element   = " + calculationManagerElmnt);
                        addtolist("calculation Manager   ", " calculation Manager  ", calculationManagerElmnt);
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
                        throw ex;
                    }


                    //Notes With Exception Tab


                    try
                    {
                        driver.FindElement(deal.notesWthExcepTab).Click();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Note with Exception = " + e.Message);
                    }
                    System.Threading.Thread.Sleep(10000);
                    bool notesWthExcepElmnt = false;
                    try
                    {
                        notesWthExcepElmnt = driver.FindElement(deal.notesWthExcepElmnt).Displayed;

                        Console.WriteLine("Notes With Exception Element   = " + notesWthExcepElmnt);
                        addtolist("calculation Manager   ", " Notes With Exception ", notesWthExcepElmnt);
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
                        throw ex;
                    }

                    //Batch Log

                    try
                    {
                        driver.FindElement(deal.batchLogTab).Click();
                        System.Threading.Thread.Sleep(10000);
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
                        addtolist("calculation Manager   ", " Batch Log ", batchLogElmnt);
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
                        throw ex;
                    }

                    /*   //----------------------------------------Generate Automation----------------------------------//

                       String GenerateAutomationUrl = BaseUrl + BaseConfiguration.GenerateAutomationUrl();
                       util.OpenUrl(GenerateAutomationUrl);
                       System.Threading.Thread.Sleep(8000);
                       String GenerateAutomationText = "Automation Manager";
                       try
                       {
                           GenerateAutomationText = driver.FindElement(deal.GenerateAutomationText).Text;
                           Console.WriteLine("GenerateAutomation Text   = " + GenerateAutomationText);

                           var printMessage = "<p><b>Test FAILED!</b></p>";
                           if (GenerateAutomationText == "Automation Manager")
                           {
                               test.Log(Status.Pass, "Generate Automation loaded sucessfully");                            
                           }
                           else
                           {
                               addtolist("Generate Automation   ", " Generate Automation ", false);
                               printMessage += $"Message: <br>{"Generate Automation Page Load Error"}<br>";
                               test.Fail(printMessage);
                           }
                       }
                       catch (Exception ex)
                       {


                           Console.WriteLine("Generate Automation Exception = " + ex.Message);

                       }   
                           */

                    //----------------------------------------Generate Automation----------------------------------//

                    String GenerateAutomationUrl = BaseUrl + BaseConfiguration.GenerateAutomationUrl();
                    util.OpenUrl(GenerateAutomationUrl);
                    System.Threading.Thread.Sleep(8000);
                    bool GenerateAutomationSave = false;
                    try
                    {
                        GenerateAutomationSave = deal.GenerateAutomationSaveButton();
                        //GenerateAutomationSave = driver.FindElement(dealPage.GenerateAutomationSave).Displayed;
                        Console.WriteLine("Generate Automation Save button is displayed = " + GenerateAutomationSave);
                        addtolist("Generate Automation Page  ", " Generate Automation Page ", GenerateAutomationSave);

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

                    // Automation Log Tab

                    driver.FindElement(deal.AutomationLogTab).Click();
                    bool AutomationLogText = false;
                    try
                    {
                        AutomationLogText = deal.AutomationLogTextDisplay();
                        //AutomationLogText = driver.FindElement(dealPage.AutomationLogText).Displayed;
                        Console.WriteLine("Generate Automation Log text is displayed = " + AutomationLogText);
                        addtolist("Generate Automation Log Tab  ", " Generate Automation Log Tab", AutomationLogText);

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
                    System.Threading.Thread.Sleep(8000);
                    bool refreshDataWarehouseBtn = false;
                    try
                    {
                        refreshDataWarehouseBtn = driver.FindElement(deal.refreshDataWarehouseBtn).Displayed;
                        Console.WriteLine("Reports   = " + refreshDataWarehouseBtn);
                        addtolist("Reports   ", " Reports ", refreshDataWarehouseBtn);
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
                        throw ex;
                    }

                    //reports History

                    String ReportHistoryUrl = BaseUrl + BaseConfiguration.ReportHistoryUrl();
                    util.OpenUrl(ReportHistoryUrl);
                    System.Threading.Thread.Sleep(8000);
                    bool reportName = false;
                    try
                    {
                        reportName = driver.FindElement(deal.reportName).Displayed;
                        Console.WriteLine("Reports   = " + reportName);
                        addtolist("Reports   ", " Reports History ", reportName);
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
                        throw ex;
                    }

                    //----------------------------Tags---------------------------//

                    String TagsUrl = BaseUrl + BaseConfiguration.TagsUrl();
                    util.OpenUrl(TagsUrl);
                    System.Threading.Thread.Sleep(8000);
                    bool addNewTagBtn = false;
                    try
                    {
                        addNewTagBtn = driver.FindElement(deal.addNewTagBtn).Displayed;
                        Console.WriteLine("Tags   = " + addNewTagBtn);
                        addtolist("Tags   ", " Tags ", addNewTagBtn);
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
                        throw ex;
                    }

                    //----------------------WorkFlow-----------------------------------//

                    String WorkflowUrl = BaseUrl + BaseConfiguration.WorkFlowUrl();
                    util.OpenUrl(WorkflowUrl);
                    System.Threading.Thread.Sleep(8000);
                    bool workflowElmnt = false;
                    try
                    {
                        workflowElmnt = driver.FindElement(deal.workflowElmnt).Displayed;

                        Console.WriteLine("Workflow   = " + workflowElmnt);
                        addtolist("Workflow   ", " Workflow ", workflowElmnt);
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
                        throw ex;
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
                        addtolist("Task Management   ", " Task Management ", addTaskBtn);
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
                        throw ex;
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

                        Console.WriteLine("Task Management  = " + addTaskElmnt);
                        addtolist("Task Management   ", " Add Task ", addTaskElmnt);

                        summaryElmnt = driver.FindElement(deal.summaryElmnt).Displayed;

                        Console.WriteLine("Task Management  = " + summaryElmnt);
                        addtolist("Task Management   ", " Add Task ", summaryElmnt);
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
                        throw ex;
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

                        Console.WriteLine("Help  = " + helpBtn);
                        addtolist("Help  ", " Help ", helpBtn);

                        contactUsHeading = driver.FindElement(deal.contactUsHeading).Displayed;

                        Console.WriteLine("Help  = " + contactUsHeading);
                        addtolist("Help  ", " Help ", contactUsHeading);

                        var printMessages = "<p><b>Test FAILED!</b></p>";
                        if (helpBtn == false || contactUsHeading == false || CancelButton == false)
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
                        CancelButton = false;
                        Console.WriteLine("Help Page Loaded Exception = " + ex.Message);
                    }
                    GenerateExcelFile.CreateExcelDataTable((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(listPageLoad), (typeof(DataTable))), "PageLoad");

                    //----------------------------Logout-----------//

                    try
                    {
                        driver.FindElement(deal.krishnaDropdown).Click();
                        System.Threading.Thread.Sleep(10000);

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
                        addtolist("Logout  ", " Logout ", logoutElmnt);
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
                        throw ex;
                    }
                    System.Threading.Thread.Sleep(7000);

                    String times = GeneralVerification.Timestamp();

                    IntegrationGeneralVerification.CreateExcelDataTableNew((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(listPageLoad), (typeof(DataTable))), "PageLoad");
                    //String time = VerifyDeal.Timestamp();
                    System.Threading.Thread.Sleep(7000);

                    // String FileName;

                    String pathExcel = "PageLoad" + "_" + times + ".xlsx";
                    Console.WriteLine("Excel report = =  " + pathExcel);
                    //CreateExcelDataTableNew(pathExcel);
                    System.Threading.Thread.Sleep(5000);
                    string pathNew = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName;
                    Console.WriteLine("Path of current directory " + pathNew);

                    // Email attachment 
                    /*   // Email check point
                        EmailDataContract emailDC = new EmailDataContract();
                        emailDC.To = "shantanu@hvantage.com";//,rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com,rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com";

                        //optional
                        //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
                        //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
                        emailDC.ReceiverName = "All";
                        emailDC.FileAttachment = new List<FileAttachmentDataContract>();
                        emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\ExcelReports\\" + pathExcel });
                        string path = ProjectBaseConfiguration.ExecutionReportFolder;
                        emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });
                        emailDC.Subject = "General verification test report of new Angular version";
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

                    */  // Email check point

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

        /*   //Note save 
           [Test]
           public void noteSave()
           {
               test = extent.CreateTest("Note save testcase ").Info("Test started");
               Actions actions = new Actions(driver);

               CRES_Login loginapp = new CRES_Login();
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


               System.Threading.Thread.Sleep(10000);
               try
               {
                   if (login.LoginWebPage())
                   {
                       string NoteUrl = BaseUrl + "#/notedetail/4bd379aa-162d-45f0-8ca6-22da944c6884";
                       util.OpenUrl(NoteUrl);
                       System.Threading.Thread.Sleep(15000);
                       driver.FindElement(deal.noteSaveBtn).Click();
                       System.Threading.Thread.Sleep(5000);
                       String NoteSuccessMsg = driver.FindElement(deal.noteSaveSucessMsg).Text;
                       Console.WriteLine(NoteSuccessMsg);
                       var printMessages = "<p><b>Test FAILED!</b></p>";
                       System.Threading.Thread.Sleep(5000);
                       if (NoteSuccessMsg == "Note saved successfully.")
                       {
                           Console.WriteLine("Note saved sucessfully");
                           test.Log(Status.Pass, "Note saved successfully");
                       }
                       else
                       {
                           Console.WriteLine("Pass: Note save failed");
                           printMessages += $"Message: <br>{"Note saved failed"}<br>";
                           test.Fail(printMessages);
                       }


                   }
                   else
                   {
                       Console.WriteLine("Fail: Login Failed");

                   }
               }

               catch (Exception ex)
               {

               }

               EmailDataContract emailDC = new EmailDataContract();
               emailDC.To = "shantanu@hvantage.com,rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com";

                   //optional
                   //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
                   //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
                   emailDC.ReceiverName = "All";
                   emailDC.FileAttachment = new List<FileAttachmentDataContract>();
                   //emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\ExcelReports\\" + pathExcel });
                   string path = ProjectBaseConfiguration.ExecutionReportFolder;
                   emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });
                   emailDC.Subject = "Copy deal test report of new Angular version";
                   emailDC.Body = "PFA the verification report.";
                   emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
                   emailDC.EmailSettings.Host = BaseConfiguration.Host;
                   emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
                   emailDC.EmailSettings.Password = BaseConfiguration.Password;
                   emailDC.EmailSettings.Port = BaseConfiguration.Port;
                   //
                   EmailAutomationLogic lg = new EmailAutomationLogic();

                   String response = lg.SendGenericEmail(emailDC);        
           }       */


        /* //Deal save generate funding

         [Test]
         public void dealSave()
         {
             Actions actions = new Actions(driver);

             CRES_Login loginapp = new CRES_Login();
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


             System.Threading.Thread.Sleep(10000);
             try
             {
                 if (login.LoginWebPage())
                 {
                     test = extent.CreateTest("verify deal funding data").Info("Test started");
                     String DealUrl = BaseUrl + "#/dealdetail/FDD8EC03-9D63-4512-9990-89C508983EDC";
                     util.OpenUrl(DealUrl);
                     System.Threading.Thread.Sleep(15000);
                     driver.FindElement(deal.fundingTab).Click();
                     System.Threading.Thread.Sleep(5000);

                     var element = driver.FindElement(deal.btnGenerateFunding);
                     Actions action = new Actions(driver);
                     actions.MoveToElement(element);
                     actions.Perform();
                     System.Threading.Thread.Sleep(10000);
                     //Deal funding data verification
                     var printMessage = "<p><b>Test FAILED!</b></p>";
                     Boolean saveBtn = driver.FindElement(deal.btnSaveDeal).Displayed;
                     Console.WriteLine("Save button" + saveBtn);
                     if (saveBtn == true)
                     {
                         test.Log(Status.Pass, "save button verified successfully");
                     }
                     else
                     {
                         printMessage += $"Message: <br>{"Save button verification failed"}<br>";
                         test.Fail(printMessage);
                     }
                     Boolean cancelBtn = driver.FindElement(deal.dealCancelButton).Displayed;
                     Console.WriteLine("Cancel button" + cancelBtn);
                     if (cancelBtn == true)
                     {

                         test.Log(Status.Pass, "cancel button verified successfully");
                     }
                     else
                     {
                         printMessage += $"Message: <br>{"cancel button verification failed"}<br>";
                         test.Fail(printMessage);
                     }
                     Boolean copyDealBtn = driver.FindElement(deal.copyDealBtn).Displayed;
                     Console.WriteLine("Copy deal button" + copyDealBtn);
                     if (copyDealBtn == true)
                     {


                         test.Log(Status.Pass, "copy deal button button verified successfully");
                     }
                     else
                     {
                         printMessage += $"Message: <br>{"copy deal button button verification failed"}<br>";
                         test.Fail(printMessage);
                     }
                     Boolean downloadBtn = driver.FindElement(deal.downloadButton).Displayed;
                     Console.WriteLine("Download button" + downloadBtn);
                     if (downloadBtn == true)
                     {


                         test.Log(Status.Pass, "download  button verified successfully");
                     }
                     else
                     {
                         printMessage += $"Message: <br>{"download button verification failed"}<br>";
                         test.Fail(printMessage);
                     }
                     Boolean fundingSeqBtn = driver.FindElement(deal.addFundingSeqBtn).Displayed;
                     Console.WriteLine("Funding Sequence button" + fundingSeqBtn);
                     if (fundingSeqBtn == true)
                     {


                         test.Log(Status.Pass, "Funding sequence button verified successfully");
                     }
                     else
                     {
                         printMessage += $"Message: <br>{"Funding sequence button verification failed"}<br>";
                         test.Fail(printMessage);
                     }
                     Boolean addRepaySeqBtn = driver.FindElement(deal.addRepaySeqBtn).Displayed;
                     Console.WriteLine("Add repay sequence button" + addRepaySeqBtn);
                     if (addRepaySeqBtn == true)
                     {


                         test.Log(Status.Pass, "Add repay sequence button verified successfully");
                     }
                     else
                     {
                         printMessage += $"Message: <br>{"Add repay sequence button verification failed"}<br>";
                         test.Fail(printMessage);
                     }
                     Boolean openAllNoteBtn = driver.FindElement(deal.openAllNotesBtn).Displayed;
                     Console.WriteLine("OPen all notes button" + openAllNoteBtn);
                     if (openAllNoteBtn == true)
                     {


                         test.Log(Status.Pass, "Open all note  button verified successfully");
                     }
                     else
                     {
                         printMessage += $"Message: <br>{"Open all note button verification failed"}<br>";
                         test.Fail(printMessage);
                     }
                     Boolean viewComitDeatilsBtn = driver.FindElement(deal.viewComitDeatilsBtn).Displayed;
                     Console.WriteLine("View commitement details button" + viewComitDeatilsBtn);
                     if (viewComitDeatilsBtn == true)
                     {

                         test.Log(Status.Pass, "view commitement details button verified successfully");
                     }
                     else
                     {
                         printMessage += $"Message: <br>{"view commitement details button verification failed"}<br>";
                         test.Fail(printMessage);
                     }
                     element.Click();
                     System.Threading.Thread.Sleep(10000);
                     //driver.FindElement(deal.btnGenerateFundingOK).Click();
                     //System.Threading.Thread.Sleep(15000);
                     IWebElement saveButton = driver.FindElement(deal.btnSaveDeal);
                     System.Threading.Thread.Sleep(2000);
                     saveButton.Click();
                     System.Threading.Thread.Sleep(10000);
                     driver.FindElement(deal.btnCRESvalOk).Click();
                     System.Threading.Thread.Sleep(11000);
                     String DealSuccessMessage = driver.FindElement(deal.successMessage).Text;
                     Console.WriteLine(DealSuccessMessage);
                     test = extent.CreateTest("To verify if deal is saved successfully").Info("Test started");
                     var printMessages = "<p><b>Test FAILED!</b></p>";
                     System.Threading.Thread.Sleep(10000);
                     bool validationPopupSaveVisible = driver.FindElement(deal.validationPopUp).Displayed;
                     if (DealSuccessMessage == "Deal Saved Successfully")
                     {
                         Console.WriteLine("Pass: Deal saved sucessfully");
                         test.Log(Status.Pass, "Deal saved successfully");
                     }

                     else
                     {
                         Console.WriteLine("Fail: Deal save failed");
                         printMessages += $"Message: <br>{"Deal saved failed"}<br>";
                         test.Fail(printMessages);


                     }
                 }
                 else
                 {
                     Console.WriteLine("Login Failed");
                 }
             }

             catch (Exception ex)
             {

             }
                EmailDataContract emailDC = new EmailDataContract();
                emailDC.To = "shantanu@hvantage.com,rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com";

                //optional
                //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
                //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
                emailDC.ReceiverName = "All";
                emailDC.FileAttachment = new List<FileAttachmentDataContract>();
                //emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\ExcelReports\\" + pathExcel });
                string path = ProjectBaseConfiguration.ExecutionReportFolder;
                emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });
                emailDC.Subject = "Save Deal and deal funding data verification report of new Angular version";
                emailDC.Body = "PFA the verification report.";
                emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
                emailDC.EmailSettings.Host = BaseConfiguration.Host;
                emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
                emailDC.EmailSettings.Password = BaseConfiguration.Password;
                emailDC.EmailSettings.Port = BaseConfiguration.Port;
                //
                EmailAutomationLogic lg = new EmailAutomationLogic();

                String response = lg.SendGenericEmail(emailDC);  

         }       */


        //Verify Search bar

        [Test]
        public void verifySearchBar()
        {
            {
                test = extent.CreateTest("To verify search bar ").Info("Test started");
                Actions actions = new Actions(driver);

                CRES_Login loginapp = new CRES_Login();
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


                System.Threading.Thread.Sleep(10000);
                try
                {
                    if (login.LoginWebPage())
                    {
                        //util.OpenUrl(BaseUrl);
                        //verify for deal in search box
                        driver.FindElement(deal.searchBar).Click();
                        driver.FindElement(deal.searchBar).SendKeys("The Hill");
                        System.Threading.Thread.Sleep(5000);
                        driver.FindElement(deal.dealSearch).Click();
                        System.Threading.Thread.Sleep(25000);
                        String dealName = driver.FindElement(deal.dealName).GetAttribute("value");
                        var printMessages = "<p><b>Test FAILED!</b></p>";
                        Console.WriteLine(dealName);
                        if (dealName == "The Hill")
                        {
                            Console.WriteLine("Deal " + dealName + " searched successfully.");
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
                        driver.FindElement(deal.noteSearch).Click();
                        System.Threading.Thread.Sleep(25000);
                        String noteID = driver.FindElement(deal.noteID).GetAttribute("value");
                        var printMessage = "<p><b>Test FAILED!</b></p>";
                        Console.WriteLine(noteID);
                        if (noteID == "2060")
                        {
                            Console.WriteLine("Note " + noteID + " searched successfully.");
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
            }
            String times = GeneralVerification.Timestamp();

            IntegrationGeneralVerification.CreateExcelDataTableNew((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(listPageLoad), (typeof(DataTable))), "PageLoad");
            //String time = VerifyDeal.Timestamp();
            System.Threading.Thread.Sleep(7000);

            // String FileName;

            String pathExcel = "PageLoad" + "_" + times + ".xlsx";
            Console.WriteLine("Excel report = =  " + pathExcel);
            //CreateExcelDataTableNew(pathExcel);
            System.Threading.Thread.Sleep(5000);
            string pathNew = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName;
            Console.WriteLine("Path of current directory " + pathNew);
            string path = ProjectBaseConfiguration.ExecutionReportFolder;

          /*  // Email check point

            EmailDataContract emailDC = new EmailDataContract();
            emailDC.To = "shantanu@hvantage.com";//,rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com";
        
            //optional
            //emailDC.Cc = "ssingh@hvantage.com";
            //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
            emailDC.ReceiverName = "All";
            emailDC.FileAttachment = new List<FileAttachmentDataContract>();
            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\ExcelReports\\" + pathExcel });
            //string path = ProjectBaseConfiguration.ExecutionReportFolder;
            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });
            emailDC.Subject = "Automation - Searh bar verification Report of new Angular version";
            emailDC.Body = "PFA the report.";
            emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
            emailDC.EmailSettings.Host = BaseConfiguration.Host;
            emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
            emailDC.EmailSettings.Password = BaseConfiguration.Password;
            emailDC.EmailSettings.Port = BaseConfiguration.Port;
            //
            EmailAutomationLogic lg = new EmailAutomationLogic();

            String response = lg.SendGenericEmail(emailDC);

          */ // Email check point

        }

        //Read Deal funding grid's data
        /*     [Test]
             public void dealFudingGridDataRead()
             {
                 test = extent.CreateTest("Comapre deal funding grid's data ").Info("Test started");
                 Actions actions = new Actions(driver);

                 CRES_Login loginapp = new CRES_Login();
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


                 System.Threading.Thread.Sleep(10000);
                 try
                 {
                     if (login.LoginWebPage())
                     {
                         String DealUrl = BaseUrl + "#/dealdetail/FDD8EC03-9D63-4512-9990-89C508983EDC";
                         util.OpenUrl(DealUrl);
                         System.Threading.Thread.Sleep(15000);
                         driver.FindElement(deal.fundingTab).Click();
                         System.Threading.Thread.Sleep(15000);
                         IWebElement scroll = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[5]/div/div[4]"));
                         Actions action1 = new Actions(driver);
                         action1.MoveToElement(scroll);
                         action1.Perform();
                         System.Threading.Thread.Sleep(5000);
                         EventFiringWebDriver eventFiringWebDriver = new EventFiringWebDriver(driver);
                         eventFiringWebDriver.ExecuteScript("document.querySelector('#dealfunding > div:nth-child(1) > div:nth-child(2)').scrollTop=5");
                         System.Threading.Thread.Sleep(8000);
                         System.Threading.Thread.Sleep(10000);
                         IList<IWebElement> rows_table = driver.FindElements(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[3]"));
                         if (rows_table.Count > 0)
                         {

                             foreach (var elemTd in rows_table)
                             {
                                 System.Threading.Thread.Sleep(8000);



                                 IList<IWebElement> rows_table2 = driver.FindElements(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[2]/div[1]/div[3]"));
                                 var gridRowData = new String[] { elemTd.Text };
                                 var element = driver.FindElement(deal.btnGenerateFunding);
                                 Actions action = new Actions(driver);
                                 actions.MoveToElement(element);
                                 System.Threading.Thread.Sleep(2000);
                                 actions.Perform();
                                 System.Threading.Thread.Sleep(5000);
                                 element.Click();
                                 System.Threading.Thread.Sleep(10000);
                                 IWebElement saveButton = driver.FindElement(deal.btnSaveDeal);
                                 System.Threading.Thread.Sleep(2000);
                                 saveButton.Click();
                                 System.Threading.Thread.Sleep(10000);
                                 driver.FindElement(deal.btnCRESvalOk).Click();
                                 System.Threading.Thread.Sleep(27000);
                                 IWebElement scroll1 = driver.FindElement(By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[5]/div/div[4]"));
                                 Actions action2 = new Actions(driver);
                                 action2.MoveToElement(scroll1);
                                 action2.Perform();
                                 System.Threading.Thread.Sleep(5000);
                                 EventFiringWebDriver eventFiringWebDriver1 = new EventFiringWebDriver(driver);
                                 eventFiringWebDriver1.ExecuteScript("document.querySelector('#dealfunding > div:nth-child(1) > div:nth-child(2)').scrollTop=5");
                                 System.Threading.Thread.Sleep(8000);
                                 foreach (var elemID2 in rows_table2)
                                 {
                                     var gridRowData1 = new String[] { elemID2.Text };
                                     for (int i = 0; i < gridRowData.Length; i++)
                                     {
                                         for (int j = 0; j < gridRowData1.Length; j++)
                                         {
                                             foreach (var row in gridRowData)
                                             {
                                                 foreach (var row2 in gridRowData1)
                                                 {
                                                     Console.WriteLine("---------------------Data before save---------------------------" + "\n" + gridRowData[i]);
                                                     Console.WriteLine("-------------------- Data After save-------------------------- - " + "\n" + gridRowData1[j]);
                                                     var printMessages = "<p><b>Test FAILED!</b></p>";
                                                     if (gridRowData[i] == gridRowData1[j])
                                                     {
                                                         Console.WriteLine("Data matched");
                                                         test.Log(Status.Pass, "Data matched successfully");
                                                     }
                                                     else
                                                     {
                                                         Console.WriteLine("Data not  matched ");
                                                         IEnumerable<string> compareGrid = gridRowData1.Except(gridRowData);

                                                         Console.WriteLine("Data which are not found after saving");
                                                         foreach (var n in compareGrid)
                                                         {
                                                             Console.WriteLine(n);
                                                         }
                                                         printMessages += $"Message: <br>{"Failed: Data not matched"}<br>";
                                                         test.Fail(printMessages);
                                                     }


                                                     // Console.WriteLine(strRowData[i]);
                                                 }
                                             }
                                         }

                                     }
                                 }
                             }
                         }
                         System.Threading.Thread.Sleep(10000);
                     }
                     else
                     {
                         Console.WriteLine("Login Failed");
                     }
                 }

                 catch (Exception ex)
                 {

                 }       
                     EmailDataContract emailDC = new EmailDataContract();
                     emailDC.To = "shantanu@hvantage.com,rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com";

                     //optional
                     //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
                     //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
                     emailDC.ReceiverName = "All";
                     emailDC.FileAttachment = new List<FileAttachmentDataContract>();
                     //emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\ExcelReports\\" + pathExcel });
                     string path = ProjectBaseConfiguration.ExecutionReportFolder;
                     emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });
                     emailDC.Subject = "Automation- Compare deal funding grid's data report of new Angular version";
                     emailDC.Body = "PFA the verification report.";
                     emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
                     emailDC.EmailSettings.Host = BaseConfiguration.Host;
                     emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
                     emailDC.EmailSettings.Password = BaseConfiguration.Password;
                     emailDC.EmailSettings.Port = BaseConfiguration.Port;
                     //
                     EmailAutomationLogic lg = new EmailAutomationLogic();

                     String response = lg.SendGenericEmail(emailDC);     
             }    */
    }
}





