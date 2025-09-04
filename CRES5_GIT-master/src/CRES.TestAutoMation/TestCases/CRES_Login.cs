using System;
using System.Buffers.Text;
using System.Collections.Generic;
using System.Text;
using CRES.TestAutoMation.Utility;
using CRES.DataContract;
using NUnit.Framework;
using CRES.TestAutoMation.Pages;
using System.Linq;
using System.IO;
using OpenQA.Selenium;

namespace CRES.TestAutoMation.TestCases
{
    public class CRES_Login : BaseClass
    {
        [Test]
        public void VerifyLogin()
        {
            List<AutoMationLoginDataContract> testparmeters = new List<AutoMationLoginDataContract>();
            Util util = new Util(driver);
            Login login = new Login(driver);
            var dataTable = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, "credential");
            if (dataTable != null)
            {

               
                        AutoMationLoginDataContract ldc = new AutoMationLoginDataContract();
                        ldc.UserName = dataTable.Rows[1].ItemArray[0].ToString();
                        ldc.Password = dataTable.Rows[1].ItemArray[1].ToString();
                        ldc.URL = dataTable.Rows[1].ItemArray[2].ToString();
                        testparmeters.Add(ldc);


            }
            foreach (var res in testparmeters)
            {
                util.OpenUrl(res.URL.ToString());
                System.Threading.Thread.Sleep(15000);
                ////login in web site
                //login.LoginWebPage();
                IWebElement username = driver.FindElement(By.Name("login"));
                username.SendKeys(res.UserName.ToString());
                IWebElement password = driver.FindElement(By.Name("password"));
                password.SendKeys(res.Password.ToString());
                IWebElement btnlogin = driver.FindElement(By.Id("login"));
                System.Threading.Thread.Sleep(10000);
                btnlogin.Click();
                System.Threading.Thread.Sleep(10000);
                string currentUrl = driver.Url;
                Console.WriteLine(currentUrl);
                
                string url = "https://qacres4.azurewebsites.net/#/dashboard";
                
                if (currentUrl == url)
                {
                    Console.WriteLine("login successfully for username :- " + res.UserName + " and password :-" +res.Password);
                }
                else
                {
                    Console.WriteLine("login failed  for :- " + res.UserName + " and password :-"+res.Password);
                }
            }
        }
        [Test]
        public void verifyInvalidUsernameLogin()
        {
            List<AutoMationLoginDataContract> testparmeters = new List<AutoMationLoginDataContract>();
            Util util = new Util(driver);
            Login login = new Login(driver);
            var dataTable = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, "credential");
            if (dataTable != null)
            {

              
                        AutoMationLoginDataContract ldc = new AutoMationLoginDataContract();
                        ldc.UserName = dataTable.Rows[3].ItemArray[0].ToString();
                        ldc.Password = dataTable.Rows[3].ItemArray[1].ToString();
                        ldc.URL = dataTable.Rows[3].ItemArray[2].ToString();
                        //Console.WriteLine(i);
                        testparmeters.Add(ldc);
                    
                
            }
            foreach (var res in testparmeters)
            {
                util.OpenUrl(res.URL.ToString());
                System.Threading.Thread.Sleep(10000);
                ////login in web site
                //login.LoginWebPage();
                IWebElement username = driver.FindElement(By.Name("login"));
                 username.SendKeys(res.UserName.ToString());
                IWebElement password = driver.FindElement(By.Name("password"));
                password.SendKeys(res.Password.ToString());
                IWebElement btnlogin = driver.FindElement(By.Id("login"));
                btnlogin.Click();
                System.Threading.Thread.Sleep(10000);
                string url = "https://qacres4.azurewebsites.net/#/dashboard";
                string currentUrl = driver.Url;
                if (currentUrl==url)
                {
                    Console.WriteLine("login successfully for username :- " + res.UserName +" and password :-" + res.Password);
                }
                else
                {
                    Console.WriteLine("login failed for username :- " + res.UserName + " and password :-" + res.Password);
                }
            }
        }
        [Test]
        public void verifyInvalidPasswordLogin()
        {
            List<AutoMationLoginDataContract> testparmeters = new List<AutoMationLoginDataContract>();
            Util util = new Util(driver);
            Login login = new Login(driver);
            var dataTable = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, "credential");
            if (dataTable != null)
            {


                AutoMationLoginDataContract ldc = new AutoMationLoginDataContract();
                ldc.UserName = dataTable.Rows[4].ItemArray[0].ToString();
                ldc.Password = dataTable.Rows[4].ItemArray[1].ToString();
                ldc.URL = dataTable.Rows[4].ItemArray[2].ToString();
                //Console.WriteLine(i);
                testparmeters.Add(ldc);


            }
            foreach (var res in testparmeters)
            {
                util.OpenUrl(res.URL.ToString());
                System.Threading.Thread.Sleep(10000);
                ////login in web site
                //login.LoginWebPage();
                IWebElement username = driver.FindElement(By.Name("login"));
                username.SendKeys(res.UserName.ToString());
                IWebElement password = driver.FindElement(By.Name("password"));
                password.SendKeys(res.Password.ToString());
                IWebElement btnlogin = driver.FindElement(By.Id("login"));
                btnlogin.Click();
                System.Threading.Thread.Sleep(10000);
                string url = "https://qacres4.azurewebsites.net/#/dashboard";
                string currentUrl = driver.Url;
                if (currentUrl == url)
                {
                    Console.WriteLine("login successfully for username :- " + res.UserName + " and password :-" + res.Password);
                    
                }
                else
                {
                    Console.WriteLine("login failed for username :- " + res.UserName + " and password :-" + res.Password);
                }
            }
        }
        [Test]
        public void verifyInvalidUsernameAndPasswordLogin()
        {
            List<AutoMationLoginDataContract> testparmeters = new List<AutoMationLoginDataContract>();
            Util util = new Util(driver);
            Login login = new Login(driver);
            var dataTable = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, "credential");
            if (dataTable != null)
            {


                AutoMationLoginDataContract ldc = new AutoMationLoginDataContract();
                ldc.UserName = dataTable.Rows[5].ItemArray[0].ToString();
                ldc.Password = dataTable.Rows[5].ItemArray[1].ToString();
                ldc.URL = dataTable.Rows[5].ItemArray[2].ToString();
                //Console.WriteLine(i);
                testparmeters.Add(ldc);


            }
            foreach (var res in testparmeters)
            {
                util.OpenUrl(res.URL.ToString());
                System.Threading.Thread.Sleep(10000);
                ////login in web site
                //login.LoginWebPage();
                IWebElement username = driver.FindElement(By.Name("login"));
                username.SendKeys(res.UserName.ToString());
                IWebElement password = driver.FindElement(By.Name("password"));
                password.SendKeys(res.Password.ToString());
                IWebElement btnlogin = driver.FindElement(By.Id("login"));
                btnlogin.Click();
                System.Threading.Thread.Sleep(10000);
                string url = "https://qacres4.azurewebsites.net/#/dashboard";
                string currentUrl = driver.Url;
                if (currentUrl == url)
                {
                    Console.WriteLine("login successfully for username :- " + res.UserName + " and password :-" + res.Password);

                }
                else
                {
                    Console.WriteLine("login failed for username :- " + res.UserName + " and password :-" + res.Password);
                }
            }
        }

        [Test]
        public void verifyBlankUsernamePasswordLogin()
        {
            List<AutoMationLoginDataContract> testparmeters = new List<AutoMationLoginDataContract>();
            Util util = new Util(driver);
            Login login = new Login(driver);
            var dataTable = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, "credential");
            if (dataTable != null)
            {


                AutoMationLoginDataContract ldc = new AutoMationLoginDataContract();
                ldc.URL = dataTable.Rows[5].ItemArray[2].ToString();
                //Console.WriteLine(i);
                testparmeters.Add(ldc);


            }
            foreach (var res in testparmeters)
            {
                util.OpenUrl(res.URL.ToString());
                System.Threading.Thread.Sleep(15000);
                ////login in web site
                //login.LoginWebPage();
                
                IWebElement btnlogin = driver.FindElement(By.Id("login"));
                btnlogin.Click();
                System.Threading.Thread.Sleep(10000);
                string url = "https://qacres4.azurewebsites.net/#/dashboard";
                string currentUrl = driver.Url;
                if (currentUrl == url)
                {
                    Console.WriteLine("login successfully for username :- " + res.UserName + " and password :-" + res.Password);

                }
                else
                {
                    Console.WriteLine("login failed for username :- " + res.UserName + " and password :-" + res.Password);
                }
            }
        }

        [Test]
        public  void Login()
        {
            bool loginstatus = false;
            try
            { 
                Util util = new Util(driver);
                Login login = new Login(driver);

                string username = BaseConfiguration.getusername();
                string password = BaseConfiguration.getpassword();
                string LoginUrl = BaseConfiguration.LoginUrl();

                util.OpenUrl(LoginUrl);
                ////login in web site
                login.LoginWebPage();
                loginstatus = true;
            }
            catch (Exception ex)
            {
                loginstatus = false;
                throw ex;
            }

            //return loginstatus;            
        }

    }
}
