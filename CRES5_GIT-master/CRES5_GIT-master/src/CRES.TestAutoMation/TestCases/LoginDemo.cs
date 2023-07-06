using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;

namespace CRES.TestAutoMation.TestCases
{

    class LoginDemo
    {
        [Test]
        public void login()
        {
            IWebDriver driver = new ChromeDriver();

            driver.Navigate().GoToUrl("https://qacres4.azurewebsites.net/#/login");
            System.Threading.Thread.Sleep(10000);

            driver.Manage().Window.Maximize();
            System.Threading.Thread.Sleep(5000);

            IWebElement username = driver.FindElement(By.Name("login"));
            username.SendKeys("admin_qa");

            System.Threading.Thread.Sleep(5000);
            IWebElement password = driver.FindElement(By.Name("password"));
            password.SendKeys("qwert1*");


            System.Threading.Thread.Sleep(5000);
            IWebElement loginbtn = driver.FindElement(By.Id("login"));
            loginbtn.Click();


            System.Threading.Thread.Sleep(5000);


            //driver.Close();








        }
    }
}
