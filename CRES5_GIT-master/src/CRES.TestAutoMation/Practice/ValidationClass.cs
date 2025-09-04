using AventStack.ExtentReports;
using CRES.DataContract;
using CRES.TestAutoMation.ExecutionReports;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.TestCases;
using CRES.TestAutoMation.Utility;
using Newtonsoft.Json;
//using com.sun.tools.@internal.ws.processor.model;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Support.UI;
using System;
using System.Collections.Generic;
using System.Data;
//using java.nio.file;
using System.IO;
using System.Threading;
using static CRES.TestAutoMation.BaseConfiguration;

namespace CRES.TestAutoMation.Practice
{
    internal class ValidationClass : BaseClass
    {
        public IWebDriver driver = null;
        Deal deal;
        public ExtentTest test = null;
        public static  String Timestamp()
        {
            String timeStamp = Util.GetTimestamp(DateTime.Now);
            return timeStamp;
        }

        List<PageLoadTest> listPageLoad = new List<PageLoadTest>();

        

        [Test]
        public void validation()
        {
            driver = new ChromeDriver();
            Actions actions = new Actions(driver);

            Login_Verification loginapp = new Login_Verification();
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

                    //...........................................Scenario Details.....................................................................//

                    String ScenarioUrl = BaseUrl + BaseConfiguration.ScenarioUrl();
                    util.OpenUrl(ScenarioUrl);
                    System.Threading.Thread.Sleep(8000);
                    bool scenarioPage = false;
                    try
                    {
                        Console.WriteLine("\nScenario Page Title =" + deal.ScenarioPageTitle());

                        if (deal.ScenarioPageTitle() == "Scenarios")
                        {
                            var printMessages = "<p><b>Scenarios for Calculation</b></p>";
                           // test.Pass(printMessages);
                            Console.WriteLine("\nScenario page open Suceessfully");
                           // test.Log(Status.Pass, "Scenario Page loaded sucessfully");

                            //     Perform function here
                            try
                            {
                                // To Select Default Scenario.
                               // test.Log(Status.Pass, "Scenario for Calculation = " + driver.FindElement(deal.defaultScenario).Text);
                                System.Threading.Thread.Sleep(1000);
                                driver.FindElement(deal.defaultScenario).Click();
                                Console.WriteLine("\nDefault scenario selected");
                                Thread.Sleep(3000);

                                // To Select "Use Servicing Data" = Y / N
                                new SelectElement(driver.FindElement(deal.UseServicingData)).SelectByText("N");
                              //  test.Log(Status.Pass, "Use Servicing Data = " + (driver.FindElement(deal.UseServicingData).Text));
                                Thread.Sleep(3000);


                                //To select Calc Engine Type:-"C# (Existing)"/"V1 (New)"
                                new SelectElement(driver.FindElement(deal.CalcEngineType)).SelectByText("C# (Existing)");
                              //  test.Log(Status.Pass, "Calc Engine Type = " + (driver.FindElement(deal.CalcEngineType).Text));
                                Thread.Sleep(5000);

                                //To save Scenario
                                driver.FindElement(deal.saveButton).Click();
                                System.Threading.Thread.Sleep(1000);
                            }
                            catch (Exception e)
                            {
                                Console.WriteLine("\nDefasult scenario =" + e.Message);
                            }
                        }
                        else
                        {
                            var printMessages = "<p><b> Scenario page load Failed</b></p>";
                           // test.Fail(printMessages);
                          //  test.Log(Status.Fail, "Scenario page load Failed");
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
                }

            }
            catch (Exception ex)
            {
                Console.Write("Final Exception =" + ex.ToString());
            }

        }

        //.....................To create Note Input Excel Report ...............................
        List<NoteCalculation> ListNoteCalculation = new List<NoteCalculation>();

        //.....................To create Note Input Excel Report ...............................
        public static  void NotesExcelDataTableNew(DataTable table, string FileName)
        {
            try
            {
                var memoryStream = new MemoryStream();
                string path = ProjectBaseConfiguration.NotesInputFolder;

                if (!Directory.Exists(path))
                {
                    DirectoryInfo di = Directory.CreateDirectory(path);
                }
                String time = ValidationClass.Timestamp();
                Console.WriteLine("Excel sheet creation Time =" + time);

                path = path + FileName + "_" + time + ".xlsx";
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



        public  void AddNotesToList(string noteId)
        {
            NoteCalculation Nc = new NoteCalculation();
            Nc.Note_Id = noteId;
            ListNoteCalculation.Add(Nc);
        }


        [Test]
        public void NotesTransferToExcle()
        {
            Console.WriteLine("\nCalculation Manager Page loded successfully");
            var printMessages = "<p><b> Calculation Manager</b></p>";
           // test.Pass(printMessages);
            //test.Log(Status.Pass, "Calculation Manager Page loaded sucessfully");

            // To store all visible note id of calculation manager grid
            string href = "/#/notedetail/";
            IList<IWebElement> NoteIdElem = driver.FindElements(By.CssSelector("a[href*='" + href + "']"));
            Console.WriteLine("\nNoteid Count =" + NoteIdElem.Count);
            for (int i = 0; i < 10; i = i + 2)
            {
                try
                {
                    driver.Navigate().Refresh();
                    Thread.Sleep(10000);
                    NoteIdElem = driver.FindElements(By.CssSelector("a[href*='" + href + "']"));


                    string NoteId = NoteIdElem[i].Text;
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

            System.Threading.Thread.Sleep(3000);
            string times = ValidationClass.Timestamp();
            ValidationClass.NotesExcelDataTableNew((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(ListNoteCalculation), (typeof(DataTable))), "NoteCalculationReport");
            System.Threading.Thread.Sleep(7000);

            // String FileName;
            String pathExcel = "NoteCalculationReport" + "_" + times + ".xlsx";
            Console.WriteLine("\nExcel report = " + pathExcel);
            System.Threading.Thread.Sleep(5000);

            //CreateExcelDataTableNew(pathExcel);                            
            string pathNew = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName;
            Console.WriteLine("\nPath of current directory " + pathNew);


            //...........................................Eding block of Method...............................
        }

    }
    
}