using System;
using System.Collections.Generic;
using System.Linq;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using NUnit.Framework;
using System.IO; // we need this namespace for working with  directories and files, a reference needs to be added for this
using System.IO.Compression;// we need this namespace for working with zip files , a reference needs to be added for this
using System.Threading.Tasks;//we need this namespace to create a logical delay in time
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.TestCases;
using CRES.TestAutoMation.Utility;
using System.Threading;
using AngleSharp.Io;
using DocumentFormat.OpenXml.Spreadsheet;

namespace CRES.TestAutoMation.Practice
{
    class DownloadVerify : BaseClass
    {
        string currentFile = string.Empty;
        static string name = string.Empty;
        bool result = false;                

        [Test]
        public void Download_Demo()
        {
            //.................................Write code of download file......................................
            
            CRES_Login loginapp = new CRES_Login();
            Login login = new Login(driver);
            Deal deal = new Deal(driver);
            
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
                "Ng" => BaseConfiguration.GetNgUrl(),
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
                    //test = extent.CreateTest("General verification ").Info("Test started");
                    String DealUrl = BaseUrl + "#/dealdetail/16-1075";
                    util.OpenUrl(DealUrl);

                    Thread.Sleep(15000);

                    try
                    {
                     //.................................Open File link and dowload the file................................
                        driver.FindElement(deal.mainTab).Click();
                        Thread.Sleep(4000);

                        string DealName = driver.FindElement(deal.dealName).GetAttribute("value");

                        string dealName= driver.FindElement(deal.DealHeading).Text;
                        Console.WriteLine("\nDeal Name = "+dealName+ " DealName = "+ DealName);
                        Thread.Sleep(2000);

                        driver.FindElement(deal.Commitment_EquityTab).Click();
                        Thread.Sleep(4000);

                        driver.FindElement(deal.ExportToExcel).Click();
                        Thread.Sleep(3000);

                        driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(10);                                              //
                                
                        name = DealName+"_Commitment.xlsx"; //we store the zip filename in a variable 
                        //wait for sometime till download is completed
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Download Exception = " + e);
                    }
                }
                else
                {
                    Console.WriteLine("Login Failed");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("\n Login Exception");
            }


        //...................................................................................................

                           
            string path = @"C:\Users\ShantanuSharma\Downloads";//the path of the folder where the zip file will be downloaded

            if (Directory.Exists(path)) //we check if the directory or folder exists
            {
                bool result = CheckFile(name); // boolean result true or false is stored after checking the zip file name
                if (result == true)
                {
                    //ExtractFiles();// if the zip file is present , this method is called to extract files within the zip file
                    Console.WriteLine("\nFile is exist in folder");
                }

                else
                {
                    Assert.Fail("The file does not exist.");// if the zip file is not present, then the  test fails
                }
            }
            else
            {
                Assert.Fail("The directory or folder does not exist.");//if the directory or folder does not exist, then the test fails
            }
        }


        public bool CheckFile(string name) // the name of the zip file which is obtained, is passed in this method
        {
            currentFile = @"C:\Users\ShantanuSharma\Downloads\" + name + ""; // the zip filename is stored in a variable
            if (File.Exists(currentFile)) //helps to check if the zip file is present
            {
                return true; //if the zip file exists return boolean true
            }
            else
            {
                return false; // if the zip file does not exist return boolean false
            }
        }

        public void VerifyFiles(string newExtractFolder)
        {
            string[] fileEntries = Directory.GetFiles(newExtractFolder);// we obtain and store files within the "Extract" folder in an array 
            List<string> listItemsName = new List<string>();//we create a list of string which will store these  files individually    // Change
            //string listItemsName = "";
            for (int i = 0; i < fileEntries.Length; i++)  //Change
            {
                string[] split = fileEntries[i].Split('\\');
                listItemsName.Add(split.Last());
            }
            List<string> originalList = new List<string> { "MannKind_Commitment.xlsx" };// the files which we expect to be  present //Change
            
            result = originalList.Count == listItemsName.Count && originalList.All(listItemsName.Contains);
            //compare two lists if they have the same number of items and 
            //check that all items are same, by using contains we ensure that both lists have same items, 
            //irrespective of the order(ascending or descending) of items within the lists
            if (result == true)
            {
                Console.WriteLine("The expected files are present.");
                DeleteFilesAndDirectory();//delete the test data
                Assert.Pass("The expected files are present.");
            }
            else
            {
                Console.WriteLine("The expected files are not present.");
                DeleteFilesAndDirectory();//delete the test data
                Assert.Fail("The expected files are not present.");
            }
        }


        public void DeleteFilesAndDirectory()
        {
            if (Directory.Exists(@"C:\Users\ShantanuSharma\Downloads\Extract"))
            {
                Directory.Delete(@"C:\Users\ShantanuSharma\Downloads\Extract", true);//cleanup created folder which has any content inside it.
                //true ensures that folder is deleted even if it is not empty. 
            }
            if (File.Exists(currentFile))
            {
                File.Delete(currentFile); //delete the downloaded zip file
            }
        }


        [TearDown]
        public void End()
        {
            driver.Close();
        }
    }
}

