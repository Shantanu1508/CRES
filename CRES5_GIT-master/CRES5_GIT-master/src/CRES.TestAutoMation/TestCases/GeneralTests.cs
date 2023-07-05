using AventStack.ExtentReports;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Support.Events;
using System;
using System.Collections.Generic;
using System.Linq;
//using AutoItX3Lib;
//using java.lang;

namespace CRES.TestAutoMation.TestCases
{

    public class GeneralTests : BaseClass
    {
        ExtentTest test = null;
        ///CreateExcel
        ///
        [Test]
        public void TestGenerateExcel()
        {

            TextLogger.Write("this is first commennt", "");


            //create directory and log into that file 
            string cutomfilename = "manish" + ".txt";

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

            CRES_Login loginapp = new CRES_Login();
            Login login = new Login(driver);
            Deal deal = new Deal(driver);
            Util util = new Util(driver);
            string dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
            string username = BaseConfiguration.getusername();
            string password = BaseConfiguration.getpassword();
            string LoginUrl = BaseConfiguration.QAUrl();
            util.OpenUrl(LoginUrl);
            System.Threading.Thread.Sleep(10000);
            try
            {

                if (login.LoginWebPageMultiBrowser(driver))
                {
                    driver.Navigate().GoToUrl(LoginUrl + "#/dealdetail/19-0869");
                    System.Threading.Thread.Sleep(20000);

                    IWebElement totalcomittment = driver.FindElement(By.Id("TotalCommitment"));
                    String totalcomittement1 = totalcomittment.GetAttribute("value");

                    Console.WriteLine("value= " + totalcomittement1);

                    IWebElement notename = driver.FindElement(By.XPath("//*[@id=\"cell01\"]"));

                    IWebElement notename2 = driver.FindElement(By.XPath("//*[@id=\"cell11\"]"));

                    IWebElement notename3 = driver.FindElement(By.XPath("//*[@id=\"cell21\"]"));

                    IWebElement notename4 = driver.FindElement(By.XPath("//*[@id=\"cell31\"]"));

                    var firstarray = new String[] { notename.Text, notename2.Text, notename3.Text, notename4.Text };

                    System.Threading.Thread.Sleep(20000);
                    driver.FindElement(deal.copyDealBtn).Click();
                    var now = DateTime.Now;
                    string crenoteid = now.ToString("MMddyyyyss");
                    driver.FindElement(deal.copyDealID).SendKeys("Deal_copy15" + crenoteid);
                    string crenotename = now.ToString("MMddyyyyss");
                    driver.FindElement(deal.copyDealName).SendKeys("Deal_Copy15" + crenotename);

                    Utility.WijmoHelper.CreateFlexGridObject((OpenQA.Selenium.Remote.RemoteWebDriver)driver, "'#griddealcopy'");


                    var totalRowIdx = WijmoHelper.GetVisibleRows((OpenQA.Selenium.Remote.RemoteWebDriver)driver);
                    var colIndex = WijmoHelper.GetColumnIndex((OpenQA.Selenium.Remote.RemoteWebDriver)driver, "CRENewNoteID");

                    string credealid = now.ToString("MMddyyyyss");

                    for (int r = 0; r <= totalRowIdx; r++)
                    {

                        WijmoHelper.SetCellElement((OpenQA.Selenium.Remote.RemoteWebDriver)driver, r, colIndex, "Copy_Note15" + r + credealid);


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
                else
                {
                    System.Diagnostics.Debug.WriteLine("Login Failed");
                }
            }
            catch(Exception e)
            {
                Console.WriteLine(" Copy Deal Exception = " + e);
            }

         /*   EmailDataContract emailDC = new EmailDataContract();
            emailDC.To = "gthakur@hvantage.com";//rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com

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
        }
        [Test]
        public void addNewUser()
        {
            ExtentTest test = null;
            test = extent.CreateTest("Add new user ").Info("Test started");
            Actions actions = new Actions(driver);

            CRES_Login loginapp = new CRES_Login();
            Login login = new Login(driver);
            Deal deal = new Deal(driver);
            Util util = new Util(driver);
            string subLoginUrl;

            string dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
            //string username = BaseConfiguration.getusername();
            //string password = BaseConfiguration.getpassword();
            //string LoginUrl = BaseConfiguration.LoginUrl();
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

            if (login.LoginWebPageMultiBrowser(driver))
            {
                String url = BaseUrl + "#/userpermission";
                util.OpenUrl(url);
                System.Threading.Thread.Sleep(20000);
                /*IWebElement krishnaDropdown = driver.FindElement(By.ClassName("caret"));
                krishnaDropdown.Click();
                System.Threading.Thread.Sleep(20000);
                IWebElement userManagement = driver.FindElement(By.XPath("/html/body/div/ng-component/div/div[1]/div/div/div[4]/div/ul/li[4]/ul/li[2]/a"));
                userManagement.Click();
                System.Threading.Thread.Sleep(10000);
                EventFiringWebDriver eventFiringWebDriver = new EventFiringWebDriver(driver);
                eventFiringWebDri ver.ExecuteScript("document.querySelector('#flex > div:nth-child(1) > div:nth-child(2)').scrollBottom=1000");
                System.Threading.Thread.Sleep(10000);*/

                EventFiringWebDriver eventFiringWebDriver = new EventFiringWebDriver(driver);
                eventFiringWebDriver.ExecuteScript("document.querySelector('#flex > div:nth-child(1) > div:nth-child(2)').scrollTop=8000");
                System.Threading.Thread.Sleep(8000);
                //First Name
                //AutoItX3 autoit = new AutoItX3();
                //autoit.ClipPut("Rosy");
                driver.FindElement(deal.firstName).Click();
                System.Threading.Thread.Sleep(5000);
                //driver.FindElement(deal.firstName).Clear();
                driver.FindElement(deal.firstName).SendKeys(Keys.Control + "v");

                System.Threading.Thread.Sleep(2000);
                // driver.FindElement(deal.firstName).Click();
                System.Threading.Thread.Sleep(5000);




                //Last Name
                //autoit.ClipPut("Thakur");
                //autoit.ClipPut("User");
                driver.FindElement(deal.lastName).Click();
                System.Threading.Thread.Sleep(2000);
                driver.FindElement(deal.lastName).SendKeys(Keys.Control + "v");

                System.Threading.Thread.Sleep(2000);
                //driver.FindElement(deal.lastName).Click();
                //driver.FindElement(deal.lastName).SendKeys(Keys.Control +"v");
                System.Threading.Thread.Sleep(2000);
                //Email
                //autoit.ClipPut("rosy@gmail.com");
                driver.FindElement(deal.email).Click();
                System.Threading.Thread.Sleep(2000);
                driver.FindElement(deal.email).SendKeys(Keys.Control + "v");

                System.Threading.Thread.Sleep(2000);
                //driver.FindElement(deal.email).Click();
                System.Threading.Thread.Sleep(1000);

                //Login Name
                //autoit.ClipPut("rosy");
                driver.FindElement(deal.loginName).Click();
                System.Threading.Thread.Sleep(2000);
                driver.FindElement(deal.loginName).SendKeys(Keys.Control + "v");

                System.Threading.Thread.Sleep(2000);
                //driver.FindElement(deal.loginName).Click();

                System.Threading.Thread.Sleep(2000);

                //Role
                driver.FindElement(deal.dropRole).Click();
                System.Threading.Thread.Sleep(2000);
                driver.FindElement(deal.selectRole).Click();
                System.Threading.Thread.Sleep(2000);
                driver.FindElement(deal.dropRole).Click();
                //Status
                driver.FindElement(deal.dropStatus).Click();
                System.Threading.Thread.Sleep(2000);
                driver.FindElement(deal.statusSelect).Click();
                System.Threading.Thread.Sleep(2000);
                driver.FindElement(deal.dropStatus).Click();
                //Time Zone
                driver.FindElement(deal.dropTimeZone).Click();
                System.Threading.Thread.Sleep(2000);
                driver.FindElement(deal.timeZoneSelect).Click();
                System.Threading.Thread.Sleep(2000);
                driver.FindElement(deal.dropTimeZone).Click();
                System.Threading.Thread.Sleep(8000);
                driver.FindElement(By.XPath("//*[@id=\"flex\"]/div[1]/div[2]/div[1]/div[71]")).Click();
                System.Threading.Thread.Sleep(2000);
                IWebElement saveBtn = driver.FindElement(By.XPath("//*[@id=\"userpermission\"]/div/div/div/button[1]"));
                saveBtn.Click();
                //saveBtn.Click();
                System.Threading.Thread.Sleep(3000);
                IWebElement successMsg = driver.FindElement(By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/userpermission/div/div[1]/div"));
                String msg = successMsg.Text;
                if (msg == "User Added/Updated Successfully.")
                {
                    Console.WriteLine("User added successfully.");
                }
                else
                {
                    Console.WriteLine("User not added successfully.");
                }

                System.Threading.Thread.Sleep(6000);

                driver.FindElement(By.XPath("//*[@id=\"flex\"]/div[1]/div[2]/div[1]/div[1]"));
                IWebElement ele = null;
                int flag = 0;
                int count = 0;

                do
                {
                    try
                    {

                        ele = driver.FindElement(By.XPath("//*[text()='Rosy']"));
                        flag = 1;
                    }
                    catch (Exception e)
                    {

                        driver.FindElement(By.XPath("//*[@id=\"flex\"]/div[1]/div[2]")).SendKeys(Keys.PageDown);
                        System.Threading.Thread.Sleep(3000);
                    }
                } while ((flag == 0) || ((++count) == 250));

                if (flag == 1)
                {
                    Console.WriteLine("Element has been found");
                }
                else
                {
                    Console.WriteLine("Element has not been found.!!");
                }
                var getFirstName = driver.FindElement(By.XPath("//*[text()='Rosy']"));

                System.Threading.Thread.Sleep(6000);
                String getName = getFirstName.Text;
                Console.WriteLine("First name=" + getName);

                var lastName = driver.FindElement(By.XPath("//*[text()='User']"));
                System.Threading.Thread.Sleep(6000);
                String getLastName = lastName.Text;
                Console.WriteLine("Last name=" + getLastName);

                var email = driver.FindElement(By.XPath("//*[text()='rosy@gmail.com']"));
                System.Threading.Thread.Sleep(6000);
                String getEmail = email.Text;
                Console.WriteLine("Email=" + getEmail);

                var loginName = driver.FindElement(By.XPath("//*[text()='rosy']"));
                System.Threading.Thread.Sleep(6000);
                String getLogin = loginName.Text;
                Console.WriteLine("Login=" + getLogin);

                var role = driver.FindElement(By.XPath("//*[text()='Viewer']"));
                System.Threading.Thread.Sleep(6000);
                String getRole = role.Text;
                Console.WriteLine("Role=" + getRole);

                var status = driver.FindElement(By.XPath("//*[text()='Active']"));
                System.Threading.Thread.Sleep(6000);
                String getStatus = status.Text;
                Console.WriteLine("Status=" + getStatus);

                var zone = driver.FindElement(By.XPath("//*[text()='India Standard Time']"));
                System.Threading.Thread.Sleep(6000);
                String getZone = zone.Text;
                Console.WriteLine("Zone=" + getZone);

                System.Threading.Thread.Sleep(1000);
                //Console.WriteLine("value=\n" + "\n"+getFirstName + "\n" + getLastName + "\n" + getEmail + "\n" + getRole + "\n" + getLogin + "\n" + getStatus + "\n" + getZone );
                var printMessages = "<p><b>Login FAILED!</b></p>";
                if (getName.Contains("Rosy") && getLastName.Contains("User") && getEmail.Contains("rosy@gmail.com") && getRole.Contains("Viewer")

                    && getLogin.Contains("rosy") && getStatus.Contains("Active") && getZone.Contains("India Standard Time")
                    )
                {
                    Console.WriteLine("Success");
                    test.Log(Status.Pass, "User added  successfully");

                }
                else
                {
                    Console.WriteLine("Failed");
                    printMessages += $"Message: <br>{"User not added"}<br>";
                    test.Fail(printMessages);

                }

            }
         /*   EmailDataContract emailDC = new EmailDataContract();
            emailDC.To = "gthakur@hvantage.com";//rsahu@hvantage.com,msingh@hvantage.com,sbanerjee@hvantage.com

            //optional
            //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
            //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
            emailDC.ReceiverName = "All";
            emailDC.FileAttachment = new List<FileAttachmentDataContract>();
            //emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = pathNew + "\\ExecutionReports\\ExcelReports\\" + pathExcel });
            string path = ProjectBaseConfiguration.ExecutionReportFolder;
            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = path + "\\index.html" });
            emailDC.Subject = "Add new user and verify";
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
        }


    }
}












