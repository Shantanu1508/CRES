using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Text;
using System;
using System.Text.RegularExpressions;
using mailslurp.Api;

using mailslurp.Client;
using mailslurp.Model;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Firefox;
using sun.security.util;

using mailslurp.Api;
using mailslurp.Client;
using mailslurp.Model;



namespace CRES.TestAutoMation.Practice
{
    // Example usage for MailSlurp email API plugin


    [TestFixture]
    internal class MailNunitTest
    {
        /*
        private static IWebDriver _webdriver;
        private static Configuration _mailslurpConfig;

        // get a MailSlurp API Key free at https://app.mailslurp.com
        private static readonly string YourApiKey = "your-api-key-here";

        private static readonly long TimeoutMillis = 30_000L;
        
        var config = new Configuration();
        config.ApiKey.Add("x-api-key", "your_api_key_here");

        [SetUpFixture]
        public class NunitSetup
        {
            // runs once before any tests
            [OneTimeSetUp]
            public void SetUp()
            {
                // set up the webdriver for selenium
                var timeout = TimeSpan.FromMilliseconds(TimeoutMillis);
                var service = FirefoxDriverService.CreateDefaultService();
                _webdriver = new FirefoxDriver(service, new FirefoxOptions(), timeout);
                _webdriver.Manage().Timeouts().ImplicitWait = timeout;

                // configure mailslurp with API Key
                Assert.NotNull(YourApiKey);
                _mailslurpConfig = new Configuration();
                _mailslurpConfig.ApiKey.Add("x-api-key", YourApiKey);
            }

            // runs once after all tests finished
            [OneTimeTearDown]
            public void Dispose()
            {
                // close down the browser
                _webdriver.Quit();
                _webdriver.Dispose();
            }
            //--------------------------------------Test loading the playground------------------------------------------------------------------------
         
            [Test, Order(1)]
            public void CanLoadPlaygroundAppInBrowser_AndClickSignUp()
            {
                // open the dummy authentication app and assert it is loaded
                _webdriver.Navigate().GoToUrl("https://playground.mailslurp.com");
                Assert.AreEqual("React App", _webdriver.Title);

                // can click the signup button
                _webdriver.FindElement(By.CssSelector("[data-test=sign-in-create-account-link]")).Click();
            }

            //--------------------------------------Create test email accounts-----------------------------------------------------------------
           
                private static Inbox _inbox;

                [Test, Order(2)]
                public void CanCreateTestEmail_AndStartSignUp()
                {
                    // first create a test email account
                    var inboxControllerApi = new InboxControllerApi(_mailslurpConfig);
                    _inbox = inboxControllerApi.CreateInbox();

                    // inbox has a real email address
                    var emailAddress = _inbox.EmailAddress;

                    // next fill out the sign-up form with email address and a password
                    _webdriver.FindElement(By.Name("email")).SendKeys(emailAddress);
                    //_webdriver.FindElement(By.Name("password")).SendKeys(Password);

                    // submit form
                    _webdriver.FindElement(By.CssSelector("[data-test=sign-up-create-account-button]")).Click();
                }
                //---------------------------------------Receive confirmation email------------------------------------------------------------

                private static Email _email;

                [Test, Order(3)]
                public void CanReceiveConfirmationEmail()
                {
                    // now fetch the email that playground sends us
                    var waitForControllerApi = new WaitForControllerApi(_mailslurpConfig);
                    _email = waitForControllerApi.WaitForLatestEmail(inboxId: _inbox.Id, timeout: TimeoutMillis, unreadOnly: true);

                    // verify the contents
                    Assert.IsTrue(_email.Subject.Contains("Please confirm your email address"));
                }

                //--------------------------------------------Extract content and confirm-------------------------------------------------------

                private static String _confirmationCode;

                [Test, Order(4)]
                public void CanExtractConfirmationCode()
                {
                    // we need to get the confirmation code from the email
                    var rx = new Regex(@".*verification code is (\d{6}).*", RegexOptions.Compiled);
                    var match = rx.Match(_email.Body);
                    _confirmationCode = match.Groups[1].Value;

                    Assert.AreEqual(6, _confirmationCode.Length);
                }

                [Test, Order(5)]
                public void CanConfirmUserWithEmailedCode()
                {
                    // fill the confirm user form with the confirmation code we got from the email
                    _webdriver.FindElement(By.Name("code")).SendKeys(_confirmationCode);
                    _webdriver.FindElement(By.CssSelector("[data-test=confirm-sign-up-confirm-button]")).Click();
                }

                //-----------------------------------------------------Sign in with confirmed user-----------------------------------------------

                [Test, Order(6)]
                public void CanLoginWithConfirmedUser()
                {
                    // load the main page again
                    _webdriver.Navigate().GoToUrl("https://playground.mailslurp.com");

                    // login with email and password (we expect it to work now that we are confirmed)
                    _webdriver.FindElement(By.Name("username")).SendKeys(_inbox.EmailAddress);
                    _webdriver.FindElement(By.Name("password")).SendKeys(Password);
                    _webdriver.FindElement(By.CssSelector("[data-test=sign-in-sign-in-button]")).Click();

                    // verify that user can see authenticated content
                    Assert.IsTrue(_webdriver.FindElement(By.TagName("h1")).Text.Contains("Welcome"));
                }

            }

            */

        } 
            
        }