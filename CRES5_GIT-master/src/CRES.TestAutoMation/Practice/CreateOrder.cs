using AutoItX3Lib;
using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Support.UI;
using SeleniumExtras.WaitHelpers;
using System;

namespace CRES.TestAutoMation.Practice
{
    public class CreateOrder : RSIP_Login
    {

        public void createNewOrder()
        {
            {
                System.Threading.Thread.Sleep(10000);
                IWebElement Addtab = driver.FindElement(By.XPath("//*[@id=\"stepcreateorder\"]/i"));
                Addtab.Click();
                WebDriverWait w = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
                w.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementExists(By.XPath("/html/body/app-root/div/mat-sidenav-container/mat-sidenav-content/app-place-order/div/div[1]/div[2]/mat-card/mat-card-title")));
                IWebElement selectUser = driver.FindElement(By.XPath("/html/body/app-root/div/mat-sidenav-container/mat-sidenav-content/app-place-order/div/mat-card/mat-card-title/div[2]/app-account-user-dropdown-groupping/div/mat-form-field/div/div[1]/div[4]/button/span/mat-icon"));
                System.Threading.Thread.Sleep(2000);
                selectUser.Click();
                //System.Threading.Thread.Sleep(2000);
                //selectUser.Click();

                AutoItX3 auto = new AutoItX3();
                auto.Send("RSIP Test");

                //System.Threading.Thread.Sleep(5000);
                IWebElement selectDrpDown = driver.FindElement(By.XPath("//*[text()=' RSIP Test ']"));
                selectDrpDown.Click();

                IWebElement PatentName = driver.FindElement(By.Id("mat-input-3"));
                PatentName.SendKeys("US7353555 ");
                //System.Threading.Thread.Sleep(2000);

                IWebElement PreApproved = driver.FindElement(By.Id("mat-checkbox-1"));
                PreApproved.Click();

                IWebElement CreateOrderBtn = driver.FindElement(By.XPath("/html/body/app-root/div/mat-sidenav-container/mat-sidenav-content/app-place-order/div/div[2]/button/span"));
                CreateOrderBtn.Click();
                w.Until(ExpectedConditions.ElementExists(By.XPath("//*[@id=\"dvInprogress\"]/div[3]/div/ng2-file-input/div/div[2]/button")));

                IWebElement browse = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/div[3]/div/ng2-file-input/div/div[2]/button"));
                browse.Click();
                System.Threading.Thread.Sleep(5000);



                //AutoItX3 auto = new AutoItX3();
                System.Threading.Thread.Sleep(5000);
                //Upload patent 360 file 1
                auto.WinActivate("Open");
                System.Threading.Thread.Sleep(6000);

                auto.Send("C:\\RSIP orders doc folder\\working patent\\IP_NPL_3555.csv");
                System.Threading.Thread.Sleep(5000);

                auto.Send("{Enter}");
                System.Threading.Thread.Sleep(10000);

                //Upload patent 360 file 2


                browse.Click();
                System.Threading.Thread.Sleep(5000);



                //AutoItX3 auto = new AutoItX3();
                System.Threading.Thread.Sleep(5000);
                //Upload patent 360 file 1
                auto.WinActivate("Open");
                System.Threading.Thread.Sleep(6000);

                auto.Send("C:\\RSIP orders doc folder\\working patent\\patent-export-abcnHm.csv");
                System.Threading.Thread.Sleep(5000);

                auto.Send("{Enter}");
                System.Threading.Thread.Sleep(10000);




                //Upload patent 360 file 3

                browse.Click();
                System.Threading.Thread.Sleep(5000);



                //AutoItX3 auto = new AutoItX3();
                System.Threading.Thread.Sleep(5000);
                //Upload patent 360 file 1
                auto.WinActivate("Open");
                System.Threading.Thread.Sleep(6000);

                auto.Send("C:\\RSIP orders doc folder\\working patent\\US7353555 - All.xlsx");
                System.Threading.Thread.Sleep(5000);

                auto.Send("{Enter}");
                System.Threading.Thread.Sleep(10000);



                w.Until(ExpectedConditions.ElementExists(By.XPath("//*[@id=\"dvInprogress\"]/mat-card-actions/button[1]/span")));

                IWebElement uploadAndSaveButton = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/mat-card-actions/button[1]/span"));
                Actions action = new Actions(driver);
                action.MoveToElement(uploadAndSaveButton);
                action.Perform();
                System.Threading.Thread.Sleep(5000);
                uploadAndSaveButton.Click();

                System.Threading.Thread.Sleep(6000);


                IWebElement submit = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/mat-card-actions/button[2]"));
                submit.Click();

                System.Threading.Thread.Sleep(6000);


                IWebElement yesBtn = driver.FindElement(By.XPath("//*[text()='Yes']"));
                yesBtn.Click();
                System.Threading.Thread.Sleep(15000);

            }



        }
    }
}

