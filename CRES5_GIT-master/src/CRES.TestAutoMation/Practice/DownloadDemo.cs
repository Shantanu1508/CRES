using System;
using System.Collections.Generic;
using System.Linq;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using NUnit.Framework;
using System.IO; // we need this namespace for working with  directories and files, a reference needs to be added for this
using System.IO.Compression;// we need this namespace for working with zip files , a reference needs to be added for this
using System.Threading.Tasks;//we need this namespace to create a logical delay in time

namespace CRES.TestAutoMation.Practice
{
    class DownloadDemo
    {
        string currentFile = string.Empty;
        static string name = string.Empty;
        bool result = false;

        IWebDriver driver;

        [SetUp]
        public void Initialize()
        {
            driver = new ChromeDriver(); //"C:\\Program Files (x86)\\chromedriver"
        }


        [Test]
        public void Download_Demo()
        {
            driver.Navigate().GoToUrl("file:///D:/data/");//browse the URL
            driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(10);                                              //
            
            name = driver.FindElement(By.LinkText("Sample.zip")).Text; //we store the zip filename in a variable 
            driver.FindElement(By.LinkText("Sample.zip")).Click();//this downloads the zip file
            Task.Delay(5000).Wait();//wait for sometime till download is completed
            string path = "C:\\Users\\ShantanuSharma\\Downloads";//the path of the folder where the zip file will be downloaded

            if (Directory.Exists(path)) //we check if the directory or folder exists
            {
                bool result = CheckFile(name); // boolean result true or false is stored after checking the zip file name
                if (result == true)
                {
                    ExtractFiles();// if the zip file is present , this method is called to extract files within the zip file
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


        public void ExtractFiles()  //Change
        {
            string newExtractFolder = @"C:\Users\ShantanuSharma\Downloads\Extract";
            // we provide a path ( i.e. @"C:\Users\abc\Downloads\) and a name (i.e. Extract) for the new folder which will store files within the zip file
            ZipFile.ExtractToDirectory(currentFile, newExtractFolder);
            // we extract contents of the zip file to the  new folder which has been created
            VerifyFiles(newExtractFolder); //we call this method and pass the path of the folder where extracted files are stored
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
            List<string> originalList = new List<string> { "Test.xlsx" };// the files which we expect to be  present //Change
            //string originalList = "Test.xlsx";
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
