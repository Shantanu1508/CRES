using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome; // Or other browser drivers like FirefoxDriver, EdgeDriver

namespace CRES.TestAutoMation.Practice
{

    [TestFixture]
    internal class SimpleLogin
    {
        private IWebDriver driver;

        [SetUp]
        public void Setup()
        {
            // Initialize the WebDriver for your chosen browser
            // Ensure the corresponding driver executable (e.g., chromedriver.exe) is in your PATH
            // or specify its path directly.
            driver = new ChromeDriver();
        }

        [Test]
        public void OpenGoogleTest()
        {
            // Navigate to the desired URL
            driver.Navigate().GoToUrl("https://www.google.com");

            // Optional: Assert something to verify the page loaded
            Assert.AreEqual("Google", driver.Title);
        }

        [Test]
        public void OpenBingTest()
        {
            driver.Navigate().GoToUrl("https://www.bing.com");
            Assert.AreEqual("Bing", driver.Title);
        }

        [TearDown]
        public void Teardown()
        {
            // Close the browser after each test
            if (driver != null)
            {
                driver.Quit();
            }
        }

    }
}


    