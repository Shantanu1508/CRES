using AventStack.ExtentReports;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using OpenQA.Selenium.Remote;
using OpenQA.Selenium.Chrome;
using WebDriverManager.DriverConfigs.Impl;
using WebDriverManager.Helpers;
using System.Reflection;
using System.IO;

namespace CRES.TestAutoMation.TestCases
{
    internal class PostProductionRegression : BaseClass
    {

        ExtentTest test = null;
        ///CreateExcel
        ///
        [Test]
        public void TestGenerateExcel()
        {

            TextLogger.Write("this is first commennt", "");


            //create directory and log into that file 
            string cutomfilename = "Shantanu Sharma" + ".txt";

            string fullpath = TextLogger.CreateDirectory("");

            // fullpath = Path.Combine(fullpath, cutomfilename);

            //fullpath= Path.Combine(fullpath, cutomfilename);


            TextLogger.Write("this is custom file log", fullpath);

            List<AutoMationOutputDataContract> list = new List<AutoMationOutputDataContract>();
            AutoMationOutputDataContract ao = new AutoMationOutputDataContract();
            ao.CREID = "15-009";
            ao.Name = "test deal";
            ao.GenerateMessage = "success";
            ao.SaveMessage = "Failed";
            ao.URL = "https://thecodebuzz.com/read-and-write-excel-file-in-net-core-using-npoi/";
            list.Add(ao);
            // GenerateExcelFile.CreateExcel(list, "result");

            ////CREID	Name	URL	SaveMessage	GenerateMessage	TestCaseName	Validation
            //string [] headers = new string[] { "Deal ID", "Deal Name", "URL", "Save Message", "Generate Message","Test case", "Validation" };
            //GenerateExcelFile.CreateExcelWithCustomHeader(list,headers, "ExcelWithCustomHeader");
        }



        //copy Deal


        [Test]
        public void VerifyCopyDeal()
        {
            test = extent.CreateTest("To verify copy deal").Info("Test started");
            Actions actions = new Actions(driver);

            Login_Verification loginapp = new Login_Verification();
            Login login = new Login(driver);
            Deal deal = new Deal(driver);
            Util util = new Util(driver);
            string dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
            string username = BaseConfiguration.getusername();
            string password = BaseConfiguration.getpassword();
            string LoginUrl = BaseConfiguration.QAUrl();
            util.OpenUrl(LoginUrl);
            System.Threading.Thread.Sleep(10000);

            if (login.LoginWebPageMultiBrowser(driver))
            {
                try
                {
                    driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/dealdetail/19-0869");
                    System.Threading.Thread.Sleep(20000);

                    IWebElement totalcomittment = driver.FindElement(By.Id("TotalCommitment"));
                    String totalcomittement1 = totalcomittment.GetAttribute("value");

                    Console.WriteLine("value= " + totalcomittement1);

                    IWebElement notename = driver.FindElement(By.XPath("(//div[contains(text(),'Note A-1')])[1]"));

                    IWebElement notename2 = driver.FindElement(By.XPath("//div[contains(text(),'Note A-1F')]"));

                    IWebElement notename3 = driver.FindElement(By.XPath("(//div[contains(text(),'Note B-1')])[1]"));

                   IWebElement notename4 = driver.FindElement(By.XPath("//div[contains(text(),'Note B-1F')]"));

                    var firstarray = new String[] { notename.Text, notename2.Text, notename3.Text, notename4.Text };

                    System.Threading.Thread.Sleep(3000);
                    driver.FindElement(deal.copyDealBtn).Click();
                    var now = DateTime.Now;
                    string crenoteid = now.ToString("MMddyyyyss");
                    driver.FindElement(deal.copyDealID).SendKeys("Deal_copy15" + crenoteid);
                    string crenotename = now.ToString("MMddyyyyss");
                    driver.FindElement(deal.copyDealName).SendKeys("Deal_Copy15" + crenotename);



                    /*
                    driver.FindElement(By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/dealdetail/form/div/div[2]/div/div[16]/div/div/div[2]/div[2]/wj-flex-grid/div[1]/div[2]/div[1]/div[2]")).SendKeys("1101");
                    driver.FindElement(By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/dealdetail/form/div/div[2]/div/div[16]/div/div/div[2]/div[2]/wj-flex-grid/div[1]/div[2]/div[1]/div[6]")).SendKeys("1102");
                    driver.FindElement(By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/dealdetail/form/div/div[2]/div/div[16]/div/div/div[2]/div[2]/wj-flex-grid/div[1]/div[2]/div[1]/div[10]")).SendKeys("1103");
                    driver.FindElement(By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/dealdetail/form/div/div[2]/div/div[16]/div/div/div[2]/div[2]/wj-flex-grid/div[1]/div[2]/div[1]/div[14]")).SendKeys("1104");

                   */
                   
                    Utility.WijmoHelper.CreateFlexGridObject((RemoteWebDriver)driver, "'#griddealcopy'");
                    

                    var totalRowIdx = WijmoHelper.GetVisibleRows((RemoteWebDriver)driver);
                    var colIndex = WijmoHelper.GetColumnIndex((RemoteWebDriver)driver, "CRENewNoteID");

                    string credealid = now.ToString("MMddyyyyss");

                    Thread.Sleep(3000);
                   
               for (int r = 0; r <= 3; r++)
                {
                    
                    WijmoHelper.SetCellElement((RemoteWebDriver)driver, r, 0, "Copy_Note15" + r + credealid);


                } 
                driver.FindElement(deal.copyAndOpenBtn).Click();

                System.Threading.Thread.Sleep(30000);
                IWebElement copyDealTotalCommitement = driver.FindElement(By.Name("TotalCommitment"));

                String totalcomittement2 = copyDealTotalCommitement.GetAttribute("value");
                Console.WriteLine("value= " + totalcomittement2);


                IWebElement copynotename = driver.FindElement(By.XPath("//*[@id=\"cell01\"]"));

                IWebElement copynotename2 = driver.FindElement(By.XPath("//*[@id=\"cell11\"]"));

                IWebElement copynotename3 = driver.FindElement(By.XPath("//*[@id=\"cell21\"]"));

                IWebElement copynotename4 = driver.FindElement(By.XPath("//*[@id=\"cell31\"]"));


                var secondarray = new string[] { copynotename.Text, copynotename2.Text, copynotename3.Text, copynotename4.Text };
                var printMessages = "<p><b>Login FAILED!</b></p>";
                Boolean isArrayEqual = true;
                if (firstarray.Length == secondarray.Length)
                {

                    for (int i = 0; i < secondarray.Length; i++)
                    {
                        Console.WriteLine("Oroginal Deal Elements =" + firstarray[i] + "\n" + "Copy deal elements= " + secondarray[i]);


                       if (secondarray[i] != firstarray[i])
                        {

                            isArrayEqual = false;
                        }
                    }
                }
                else
                {
                    isArrayEqual = false;
                }

                if (isArrayEqual)
                {


                    if (totalcomittement1 == totalcomittement2)
                    {

                        Console.WriteLine("Deal copied");
                        test.Log(Status.Pass, "Deal copied successfully ");
                    }

                    else
                    {
                        Console.WriteLine("Deal not copied");
                        printMessages += $"Message: <br>{"Deal not copied"}<br>";
                        test.Fail(printMessages);

                    }
                    var x = secondarray.Except(firstarray);
                    foreach (var item in x)
                        Console.WriteLine("Non match" + item);
                }
            }
             catch (Exception ex)
            {
                Console.WriteLine("Exception =" + ex.Message);
            }
            }
            else
            {
                System.Diagnostics.Debug.WriteLine("Login Failed");
            }

            //Check Point
            /*

            EmailDataContract emailDC = new EmailDataContract();
            emailDC.To = "shantanu@hvantage.com";//rsahu@hvantage.com, ssingh@hvantage.com, msingh@hvantage.com,sbanerjee@hvantage.com

            //optional
            //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
            //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
            emailDC.ReceiverName = "All";
            emailDC.FileAttachment = new List<FileAttachmentDataContract>();
            //emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\ExcelReports\\" + pathExcel });
            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = "C:\\temp\\index.html" });
            emailDC.Subject = "Copy deal test report";
            emailDC.Body = "PFA the verification report.";
            emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
            emailDC.EmailSettings.Host = BaseConfiguration.Host;
            emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
            emailDC.EmailSettings.Password = BaseConfiguration.Password;
            emailDC.EmailSettings.Port = BaseConfiguration.Port;
            //
            EmailAutomationLogic lg = new EmailAutomationLogic();

            String response = lg.SendGenericEmail(emailDC);
            */
            //Check Point
        }


    }
}
