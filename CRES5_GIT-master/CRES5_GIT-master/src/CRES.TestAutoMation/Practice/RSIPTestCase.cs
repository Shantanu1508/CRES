using AutoItX3Lib;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Support.UI;
using System;

namespace CRES.TestAutoMation.Practice
{



    public class RsipTestCase : RSIP_Login
    {
        RSIP_Login login = new RSIP_Login();
        [Test]
        public void CreateOrderPatent360PreApproved()
        {



            //login.loginFun();
            WebDriverWait w = new WebDriverWait(driver, TimeSpan.FromSeconds(20));


            CreateOrder creatorder = new CreateOrder();
            creatorder.createNewOrder();
            System.Threading.Thread.Sleep(600000);

            //Open added order


            /*string orderNumber = driver.FindElement(By.Id("mat-input-5")).GetAttribute("value");
            Console.WriteLine(orderNumber);*/
            IWebElement dashboard = driver.FindElement(By.XPath("/html/body/app-root/div/mat-toolbar/a"));
            dashboard.Click();
            System.Threading.Thread.Sleep(10000);
            driver.SwitchTo().Frame(driver.FindElement(By.TagName("iframe")));

            System.Threading.Thread.Sleep(10000);
            IWebElement openOrder = driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[3]/div[2]"));
            Actions actionx = new Actions(driver);
            actionx.ContextClick(openOrder);
            actionx.Perform();
            System.Threading.Thread.Sleep(5000);
            IWebElement openTask = driver.FindElement(By.Id("contextmenu-label-text6"));
            openTask.Click();
            System.Threading.Thread.Sleep(5000);
            System.Threading.Thread.Sleep(12000);
            IWebElement checkbox = driver.FindElement(By.XPath("//*[@id=\"flexTaskInPublish\"]/div[1]/div[1]/div[1]/div[2]/div[4]/div/div/input"));
            checkbox.Click();
            System.Threading.Thread.Sleep(2000);

            IWebElement publishBtn = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/mat-card-actions/button"));
            publishBtn.Click();
            System.Threading.Thread.Sleep(15000);


            System.Threading.Thread.Sleep(10000);







            /* Func<IWebDriver, List<IWebElement>> waitForElement = new Func<IWebDriver, List<IWebElement>>((IWebDriver Web) =>
             {
                 try
                 {




                     return null;
                 }
                 catch (Exception ex)
                 {
                     return null;
                 }
             });
             WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(40));
             wait.Until(waitForElement);*/

            System.Threading.Thread.Sleep(10000);
        }



        [Test]
        public void CreateOrderPatent360NonPreApproved()
        {



            System.Threading.Thread.Sleep(15000);

            IWebElement createOrder = driver.FindElement(By.Id("stepcreateorder"));
            createOrder.Click();
            System.Threading.Thread.Sleep(10000);

            IWebElement selectUser = driver.FindElement(By.XPath("/html/body/app-root/div/mat-sidenav-container/mat-sidenav-content/app-place-order/div/mat-card/mat-card-title/div[2]/app-account-user-dropdown-groupping/div/mat-form-field/div/div[1]/div[4]/button/span/mat-icon"));
            selectUser.Click();
            System.Threading.Thread.Sleep(2000);
            //selectUser.Click();

            AutoItX3 auto = new AutoItX3();
            auto.Send("RSIP Test");

            System.Threading.Thread.Sleep(5000);
            IWebElement selectDrpDown = driver.FindElement(By.XPath("//*[text()=' RSIP Test ']"));
            selectDrpDown.Click();
            // IWebElement optionSelect = driver.FindElement(By.Id("mat-option-856"));
            // optionSelect.Click();
            //System.Threading.Thread.Sleep(5000);

            // US8433630
            IWebElement patentName = driver.FindElement(By.Id("mat-input-3"));
            patentName.SendKeys("US8433630");
            System.Threading.Thread.Sleep(5000);

            System.Threading.Thread.Sleep(5000);
            IWebElement createOrderBtn = driver.FindElement(By.XPath("/html/body/app-root/div/mat-sidenav-container/mat-sidenav-content/app-place-order/div/div[2]/button"));
            createOrderBtn.Click();
            System.Threading.Thread.Sleep(15000);


            System.Threading.Thread.Sleep(5000);
            driver.SwitchTo().Frame(driver.FindElement(By.TagName("iframe")));
            IWebElement sortByOrder = driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[2]/div/div[3]/div"));
            sortByOrder.Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[2]/div/div[3]/div")).Click();


            System.Threading.Thread.Sleep(5000);

            //sortByOrder.Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement openFirstOrder = driver.FindElement(By.XPath(" //*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[3]/div[1]"));
            //openFirstOrder.Click();

            System.Threading.Thread.Sleep(5000);

            Actions actions = new Actions(driver);
            actions.ContextClick(openFirstOrder);
            System.Threading.Thread.Sleep(5000);
            actions.Perform();
            System.Threading.Thread.Sleep(5000);

            IWebElement openTask = driver.FindElement(By.Id("contextmenu-label-text6"));
            openTask.Click();
            System.Threading.Thread.Sleep(16000);

            IWebElement selectAnalyst = driver.FindElement(By.XPath("//*[@id=\"flexPLR\"]/div[1]/div[1]/div[1]/div[2]/div[2]/div/div/select"));
            selectAnalyst.Click();
            System.Threading.Thread.Sleep(5000);

            IWebElement justinCole = driver.FindElement(By.XPath("//*[@id=\"flexPLR\"]/div[1]/div[1]/div[1]/div[2]/div[2]/div/div/select/option[2]"));
            justinCole.Click();
            System.Threading.Thread.Sleep(5000);

            IWebElement submitBtn = driver.FindElement(By.XPath("//*[@id=\"dvReviewOrder\"]/mat-card-actions/button[2]"));
            submitBtn.Click();
            System.Threading.Thread.Sleep(5000);


            System.Threading.Thread.Sleep(5000);

            driver.SwitchTo().Frame(driver.FindElement(By.TagName("iframe")));
            //driver.FindElement(By.XPath("'//div[text()='orderNumber']'variable")).Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement openOrder = driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[3]/div[1]"));

            Actions action = new Actions(driver);
            action.ContextClick(openOrder);
            action.Perform();
            System.Threading.Thread.Sleep(5000);

            driver.FindElement(By.XPath("/html/body/div[12]/drop-down-list/ng-transclude/ng-repeat[6]/drop-down-list-item/ng-transclude/ng-switch/div")).Click();
            System.Threading.Thread.Sleep(5000);

            IWebElement browse = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/div[3]/div/ng2-file-input/div/div[2]/button"));
            browse.Click();
            System.Threading.Thread.Sleep(5000);



            AutoItX3 autoit = new AutoItX3();
            System.Threading.Thread.Sleep(5000);
            //Upload patent 360 file 1
            auto.WinActivate("Open");
            System.Threading.Thread.Sleep(6000);

            autoit.Send("C:\\RSIP orders doc folder\\Patent 360\\xlsv files(Converted)\\patent-export-XvuGpD.xlsx");
            System.Threading.Thread.Sleep(5000);

            autoit.Send("{Enter}");
            System.Threading.Thread.Sleep(10000);

            IWebElement uploadAndSaveButton = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/mat-card-actions/button[1]/span"));
            Actions action1 = new Actions(driver);
            action1.MoveToElement(uploadAndSaveButton);
            action1.Perform();
            System.Threading.Thread.Sleep(5000);
            uploadAndSaveButton.Click();

            System.Threading.Thread.Sleep(10000);



            //upload patent 360 file 2

            browse.Click();
            System.Threading.Thread.Sleep(5000);
            autoit.WinActivate("Open");
            System.Threading.Thread.Sleep(5000);
            autoit.Send("C:\\RSIP orders doc folder\\Patent 360\\xlsv files(Converted)\\PLR_BC_3630.xlsx");
            System.Threading.Thread.Sleep(3000);
            autoit.Send("{ENTER}");
            System.Threading.Thread.Sleep(5000);

            action1.MoveToElement(uploadAndSaveButton);
            action1.Perform();
            System.Threading.Thread.Sleep(5000);
            uploadAndSaveButton.Click();
            System.Threading.Thread.Sleep(5000);

            System.Threading.Thread.Sleep(10000);

            //upload patent 360 file 3
            browse.Click();

            System.Threading.Thread.Sleep(5000);
            autoit.WinActivate("Open");
            System.Threading.Thread.Sleep(5000);
            autoit.Send("C:\\RSIP orders doc folder\\Patent 360\\xlsv files(Converted)\\PLR_FC_3630.xlsx");
            System.Threading.Thread.Sleep(5000);
            autoit.Send("{ENTER}");
            System.Threading.Thread.Sleep(2000);
            uploadAndSaveButton.Click();
            System.Threading.Thread.Sleep(10000);

            System.Threading.Thread.Sleep(10000);


            // upload patent 360 file 4
            browse.Click();
            System.Threading.Thread.Sleep(5000);
            autoit.WinActivate("Open");
            System.Threading.Thread.Sleep(5000);
            autoit.Send("C:\\RSIP orders doc folder\\Patent 360\\xlsv files(Converted)\\PLR_REJG_2422.xlsx");
            System.Threading.Thread.Sleep(6000);
            autoit.Send("{ENTER}");
            System.Threading.Thread.Sleep(5000);
            uploadAndSaveButton.Click();
            System.Threading.Thread.Sleep(6000);
            // SaveBtn.Click();
            System.Threading.Thread.Sleep(10000);

            //upload patent 360 file 5

            browse.Click();
            System.Threading.Thread.Sleep(5000);
            autoit.WinActivate("Open");
            System.Threading.Thread.Sleep(6000);
            auto.Send("C:\\RSIP orders doc folder\\Patent 360\\csv files\\US8433630 - All.xlsx");
            System.Threading.Thread.Sleep(6000);
            auto.Send("{Enter}");
            System.Threading.Thread.Sleep(5000);
            uploadAndSaveButton.Click();
            System.Threading.Thread.Sleep(10000);
            IWebElement SaveBtn = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/mat-card-actions/button[2]/span"));
            SaveBtn.Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement yesBtn = driver.FindElement(By.XPath("//*[text()='Yes']"));
            yesBtn.Click();





        }
        [Test]
        public void CreateAllOrdersAtOnce()
        {

            //RSIP_Login login = new RSIP_Login();
            login.loginFun();
            System.Threading.Thread.Sleep(15000);

            IWebElement createOrder = driver.FindElement(By.Id("stepcreateorder"));
            createOrder.Click();
            System.Threading.Thread.Sleep(10000);

            IWebElement selectUser = driver.FindElement(By.XPath("/html/body/app-root/div/mat-sidenav-container/mat-sidenav-content/app-place-order/div/mat-card/mat-card-title/div[2]/app-account-user-dropdown-groupping/div/mat-form-field/div/div[1]/div[4]/button/span/mat-icon"));
            selectUser.Click();
            System.Threading.Thread.Sleep(2000);
            //selectUser.Click();

            AutoItX3 auto = new AutoItX3();
            auto.Send("RSIP Test");

            System.Threading.Thread.Sleep(5000);
            IWebElement selectDrpDown = driver.FindElement(By.XPath("//*[text()=' RSIP Test ']"));
            selectDrpDown.Click();
            // IWebElement optionSelect = driver.FindElement(By.Id("mat-option-856"));
            // optionSelect.Click();
            //System.Threading.Thread.Sleep(5000);

            IWebElement portfolioName = driver.FindElement(By.Id("mat-input-2"));
            portfolioName.Click();
            portfolioName.SendKeys("RSIP G");
            System.Threading.Thread.Sleep(5000);




            IWebElement patendability = driver.FindElement(By.Id("mat-input-4"));
            patendability.Click();
            patendability.SendKeys("Patent RSIP G");
            System.Threading.Thread.Sleep(5000);


            // US8433630
            IWebElement patentName = driver.FindElement(By.Id("mat-input-3"));
            patentName.SendKeys("US8433630");
            System.Threading.Thread.Sleep(5000);




            IWebElement createOrderBtn = driver.FindElement(By.XPath("/html/body/app-root/div/mat-sidenav-container/mat-sidenav-content/app-place-order/div/div[2]/button"));
            createOrderBtn.Click();
            System.Threading.Thread.Sleep(15000);

            System.Threading.Thread.Sleep(5000);
            driver.SwitchTo().Frame(driver.FindElement(By.TagName("iframe")));
            IWebElement sortByOrder = driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[2]/div/div[3]/div"));
            sortByOrder.Click();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[2]/div/div[3]/div")).Click();


            System.Threading.Thread.Sleep(5000);

            //sortByOrder.Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement openFirstOrder = driver.FindElement(By.XPath(" //*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[3]/div[1]"));
            //openFirstOrder.Click();

            System.Threading.Thread.Sleep(5000);

            Actions actions = new Actions(driver);
            actions.ContextClick(openFirstOrder);
            System.Threading.Thread.Sleep(5000);
            actions.Perform();
            System.Threading.Thread.Sleep(5000);

            IWebElement openTask = driver.FindElement(By.Id("contextmenu-label-text6"));
            openTask.Click();
            System.Threading.Thread.Sleep(16000);

            System.Threading.Thread.Sleep(5000);
            string portName = driver.FindElement(By.XPath("//*[@id=\"flexPMR\"]/div[1]/div[1]/div[1]/div[2]/div[1]")).Text;
            Console.WriteLine(portName);
            System.Threading.Thread.Sleep(5000);

            string patentiblityString = driver.FindElement(By.XPath("//*[@id=\"flexPLR\"]/div[1]/div[1]/div[1]/div[2]/div[1]")).Text;
            Console.WriteLine(patentiblityString);
            System.Threading.Thread.Sleep(5000);

            string patentNme = driver.FindElement(By.XPath("//*[@id=\"flexPAT\"]/div[1]/div[1]/div[1]/div[2]/div[1]")).Text;
            Console.WriteLine(patentNme);
            System.Threading.Thread.Sleep(5000);




            IWebElement pmrAnalyst = driver.FindElement(By.XPath("//*[@id=\"flexPMR\"]/div[1]/div[1]/div[1]/div[2]/div[4]/div/div/select"));
            pmrAnalyst.Click();
            System.Threading.Thread.Sleep(6000);
            driver.FindElement(By.XPath("//*[@id=\"flexPMR\"]/div[1]/div[1]/div[1]/div[2]/div[4]/div/div/select/option[2]")).Click();


            System.Threading.Thread.Sleep(5000);

            IWebElement plrAnalyst = driver.FindElement(By.XPath("//*[@id=\"flexPLR\"]/div[1]/div[1]/div[1]/div[2]/div[2]/div/div/select"));
            plrAnalyst.Click();
            System.Threading.Thread.Sleep(6000);
            driver.FindElement(By.XPath("//*[@id=\"flexPLR\"]/div[1]/div[1]/div[1]/div[2]/div[2]/div/div/select/option[2]")).Click();
            System.Threading.Thread.Sleep(6000);

            IWebElement patAnalyst = driver.FindElement(By.XPath("//*[@id=\"flexPAT\"]/div[1]/div[1]/div[1]/div[2]/div[3]/div/div/select"));
            patAnalyst.Click();
            System.Threading.Thread.Sleep(6000);
            driver.FindElement(By.XPath("//*[@id=\"flexPAT\"]/div[1]/div[1]/div[1]/div[2]/div[3]/div/div/select/option[2]")).Click();
            System.Threading.Thread.Sleep(5000);

            IWebElement submitBtn = driver.FindElement(By.XPath("//*[@id=\"dvReviewOrder\"]/mat-card-actions/button[2]"));
            submitBtn.Click();
            System.Threading.Thread.Sleep(15000);
            driver.SwitchTo().Frame(driver.FindElement(By.TagName("iframe")));
            System.Threading.Thread.Sleep(5000);
            string patendabilityOrderVisibility = driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[7]/div[1]")).Text;
            Console.WriteLine(patendabilityOrderVisibility);
            System.Threading.Thread.Sleep(5000);

            string patent360 = driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[7]/div[2]")).Text;
            Console.WriteLine(patent360);
            System.Threading.Thread.Sleep(5000);

            string portfolio = driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[7]/div[3]")).Text;
            Console.WriteLine(portfolio);
            System.Threading.Thread.Sleep(5000);

            if (portName == portfolio && patentiblityString == patent360 && patentNme == patendabilityOrderVisibility)
            {
                Console.WriteLine("Orders added successfully");
            }
            else
            {
                Console.WriteLine("Order not added");
            }

            System.Threading.Thread.Sleep(5000);






        }
        [Test]
        public void ManualUnpublish()
        {
            //RSIP_Login login = new RSIP_Login();
            login.loginFun();
            System.Threading.Thread.Sleep(15000);



            RsipTestCase rsip = new RsipTestCase();
            rsip.CreateOrderPatent360PreApproved();
            System.Threading.Thread.Sleep(5000);


            IWebElement unpublish = driver.FindElement(By.XPath("//*[@id=\"flexTaskInPublish\"]/div[1]/div[1]/div[1]/div[2]/div[9]/div/input"));
            unpublish.Click();

            System.Threading.Thread.Sleep(5000);
            IWebElement yesBtn = driver.FindElement(By.XPath("//*[text()='Yes']"));
            yesBtn.Click();
            System.Threading.Thread.Sleep(15000);

            IWebElement dashboard = driver.FindElement(By.XPath("/html/body/app-root/div/mat-toolbar/a"));
            dashboard.Click();
            System.Threading.Thread.Sleep(10000);
            driver.SwitchTo().Frame(driver.FindElement(By.TagName("iframe")));

            System.Threading.Thread.Sleep(10000);
            String status = driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[5]/div[1]")).Text;

            Console.WriteLine("Status : " + status);
            System.Threading.Thread.Sleep(2000);
            bool checkStatus()
            {
                bool flag = false;


                if (status == "Ready to publish")
                {
                    flag = true;

                    return flag;
                }
                else
                {
                    //Console.WriteLine("Report is published");
                    return flag;
                }
            }

            if (checkStatus())
            {
                Console.WriteLine("Report Not published");
            }
            else
            {
                Console.WriteLine("Report published");
            }

            System.Threading.Thread.Sleep(10000);
        }




        [Test]
        public void AutoUnpublish()
        {

            //RSIP_Login login = new RSIP_Login();
            login.loginFun();
            System.Threading.Thread.Sleep(15000);
            RsipTestCase rsip = new RsipTestCase();
            rsip.CreateOrderPatent360PreApproved();
            IWebElement dashboard = driver.FindElement(By.XPath("/html/body/app-root/div/mat-toolbar/a"));
            dashboard.Click();
            System.Threading.Thread.Sleep(15000);
            driver.SwitchTo().Frame(driver.FindElement(By.TagName("iframe")));
            //driver.FindElement(By.XPath("'//div[text()='orderNumber']'variable")).Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement openFirstOrder = driver.FindElement(By.XPath(" //*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[3]/div[4]"));
            Actions actions = new Actions(driver);
            actions.ContextClick(openFirstOrder);
            System.Threading.Thread.Sleep(5000);
            actions.Perform();
            System.Threading.Thread.Sleep(5000);

            IWebElement openTask = driver.FindElement(By.Id("contextmenu-label-text6"));
            openTask.Click();
            System.Threading.Thread.Sleep(16000);

            IWebElement uploadMore = driver.FindElement(By.XPath("//*[@id=\"flexTaskInPublish\"]/div[1]/div[1]/div[1]/div[2]/div[5]/div/input"));
            uploadMore.Click();

            System.Threading.Thread.Sleep(5000);

            IWebElement browse = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/div[3]/div/ng2-file-input/div/div[2]/button"));
            browse.Click();
            System.Threading.Thread.Sleep(5000);



            AutoItX3 auto = new AutoItX3();
            System.Threading.Thread.Sleep(5000);
            //Upload patent 360 file 1
            auto.WinActivate("Open");
            System.Threading.Thread.Sleep(6000);

            auto.Send("C:\\RSIP orders doc folder\\Patent 360\\csv files\\US8433630 - All.xlsx");
            System.Threading.Thread.Sleep(5000);

            auto.Send("{Enter}");
            System.Threading.Thread.Sleep(10000);

            IWebElement uploadAndSaveButton = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/mat-card-actions/button[1]/span"));
            Actions action = new Actions(driver);
            action.MoveToElement(uploadAndSaveButton);
            action.Perform();
            System.Threading.Thread.Sleep(5000);
            uploadAndSaveButton.Click();

            System.Threading.Thread.Sleep(10000);

            IWebElement submitBtn = driver.FindElement(By.XPath("//*[@id='dvInprogress']/mat-card-actions/button[2]"));
            submitBtn.Click();
            System.Threading.Thread.Sleep(10000);

            IWebElement yesBtn = driver.FindElement(By.XPath("//*[text()='Yes']"));
            yesBtn.Click();
            System.Threading.Thread.Sleep(600000);

            driver.Navigate().GoToUrl("https://rsip-dev.azurewebsites.net/dashboard");
            System.Threading.Thread.Sleep(10000);
            driver.SwitchTo().Frame(driver.FindElement(By.TagName("iframe")));
            System.Threading.Thread.Sleep(10000);
            String status = driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[5]/div[3]")).Text;
            Console.WriteLine("Status is:" + status);
            System.Threading.Thread.Sleep(10000);
            bool checkStatus()
            {
                bool flag = false;


                if (status == "Report in Review")
                {
                    flag = true;

                    return flag;
                }
                else
                {
                    //Console.WriteLine("Report is published");
                    return flag;
                }
            }

            if (checkStatus())
            {
                Console.WriteLine("Report Not published");
            }
            else
            {
                Console.WriteLine("Report published");
            }

        }

        [Test]
        public void exporToPdf()
        {


            login.loginFun();
            System.Threading.Thread.Sleep(15000);

            CreateOrder creatorder = new CreateOrder();
            creatorder.createNewOrder();
            System.Threading.Thread.Sleep(15000);
            IWebElement dashboard = driver.FindElement(By.XPath("/html/body/app-root/div/mat-toolbar/a"));
            dashboard.Click();
            System.Threading.Thread.Sleep(15000);
            driver.SwitchTo().Frame(driver.FindElement(By.TagName("iframe")));
            //driver.FindElement(By.XPath("'//div[text()='orderNumber']'variable")).Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement openFirstOrder = driver.FindElement(By.XPath(" //*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[3]/div[4]"));
            Actions actions = new Actions(driver);
            actions.ContextClick(openFirstOrder);
            System.Threading.Thread.Sleep(5000);
            actions.Perform();
            System.Threading.Thread.Sleep(5000);

            IWebElement exportToPdf = driver.FindElement(By.Id("contextmenu-label-text9"));
            exportToPdf.Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement yesBtn = driver.FindElement(By.XPath("//*[text()='Yes']"));
            yesBtn.Click();
            System.Threading.Thread.Sleep(5000);

        }
        [Test]
        public void deleteReport()
        {

            login.loginFun();
            System.Threading.Thread.Sleep(15000);

            CreateOrder creatorder = new CreateOrder();
            creatorder.createNewOrder();
            IWebElement dashboard = driver.FindElement(By.XPath("/html/body/app-root/div/mat-toolbar/a"));
            dashboard.Click();
            System.Threading.Thread.Sleep(15000);
            driver.SwitchTo().Frame(driver.FindElement(By.TagName("iframe")));
            //driver.FindElement(By.XPath("'//div[text()='orderNumber']'variable")).Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement openFirstOrder = driver.FindElement(By.XPath(" //*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[3]/div[4]"));
            Actions actions = new Actions(driver);
            actions.ContextClick(openFirstOrder);
            System.Threading.Thread.Sleep(5000);
            actions.Perform();
            System.Threading.Thread.Sleep(5000);

            IWebElement deleteReport = driver.FindElement(By.Id("contextmenu-label-text7"));
            deleteReport.Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement yesBtn = driver.FindElement(By.XPath("//*[text()='Yes']"));
            yesBtn.Click();
            System.Threading.Thread.Sleep(5000);


        }
        [Test]
        public void deleteOrder()
        {



            login.loginFun();
            System.Threading.Thread.Sleep(15000);

            CreateOrder creatorder = new CreateOrder();
            creatorder.createNewOrder();
            System.Threading.Thread.Sleep(15000);
            IWebElement dashboard = driver.FindElement(By.XPath("/html/body/app-root/div/mat-toolbar/a"));
            dashboard.Click();
            System.Threading.Thread.Sleep(15000);
            driver.SwitchTo().Frame(driver.FindElement(By.TagName("iframe")));
            //driver.FindElement(By.XPath("'//div[text()='orderNumber']'variable")).Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement openFirstOrder = driver.FindElement(By.XPath(" //*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[3]/div[4]"));
            Actions actions = new Actions(driver);
            actions.ContextClick(openFirstOrder);
            System.Threading.Thread.Sleep(5000);
            actions.Perform();
            System.Threading.Thread.Sleep(5000);

            IWebElement deleteReport = driver.FindElement(By.Id("contextmenu-label-text8"));
            deleteReport.Click();
            System.Threading.Thread.Sleep(7000);
            IWebElement yes = driver.FindElement(By.XPath("//*[text()='Yes']"));
            yes.Click();

            System.Threading.Thread.Sleep(5000);
        }



        [Test]
        public void CreateOrderPortfolio()
        {

            // RSIP_Login login = new RSIP_Login();
            login.loginFun();
            System.Threading.Thread.Sleep(15000);

            IWebElement Addtab = driver.FindElement(By.XPath("//*[@id=\"stepcreateorder\"]/i"));
            Addtab.Click();
            System.Threading.Thread.Sleep(6000);
            IWebElement selectUser = driver.FindElement(By.XPath("/html/body/app-root/div/mat-sidenav-container/mat-sidenav-content/app-place-order/div/mat-card/mat-card-title/div[2]/app-account-user-dropdown-groupping/div/mat-form-field/div/div[1]/div[4]/button/span/mat-icon"));
            selectUser.Click();
            System.Threading.Thread.Sleep(2000);
            //selectUser.Click();

            AutoItX3 auto = new AutoItX3();
            auto.Send("RSIP Test");

            System.Threading.Thread.Sleep(5000);
            IWebElement selectDrpDown = driver.FindElement(By.XPath("//*[text()=' RSIP Test ']"));
            selectDrpDown.Click();

            IWebElement portdolioOrder = driver.FindElement(By.Id("mat-input-2"));
            portdolioOrder.SendKeys("AbbottCardio");
            System.Threading.Thread.Sleep(5000);

            IWebElement PreApproved = driver.FindElement(By.Id("mat-checkbox-1"));
            PreApproved.Click();
            System.Threading.Thread.Sleep(2000);

            IWebElement CreateOrderBtn = driver.FindElement(By.XPath("/html/body/app-root/div/mat-sidenav-container/mat-sidenav-content/app-place-order/div/div[2]/button/span"));
            CreateOrderBtn.Click();
            System.Threading.Thread.Sleep(10000);
            IWebElement browse = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/div[3]/div/ng2-file-input/div/div[2]/button"));
            browse.Click();
            System.Threading.Thread.Sleep(5000);

            //AutoItX3 auto = new AutoItX3();
            System.Threading.Thread.Sleep(5000);
            //Upload patent 360 file 1
            auto.WinActivate("Open");
            System.Threading.Thread.Sleep(6000);

            auto.Send("C:\\RSIP orders doc folder\\Portfolio\\xlsv converted\\PMR BUBBLE AbbottCardio.xlsx");
            System.Threading.Thread.Sleep(5000);

            auto.Send("{Enter}");
            System.Threading.Thread.Sleep(10000);

            IWebElement browse1 = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/div[3]/div/ng2-file-input/div/div[2]/button"));
            browse1.Click();
            System.Threading.Thread.Sleep(5000);

            //AutoItX3 auto = new AutoItX3();
            System.Threading.Thread.Sleep(5000);
            //Upload patent 360 file 1
            auto.WinActivate("Open");
            System.Threading.Thread.Sleep(6000);

            auto.Send("C:\\RSIP orders doc folder\\Portfolio\\xlsv converted\\PMR_CO_AbbottCardio.xlsx");
            System.Threading.Thread.Sleep(5000);

            auto.Send("{Enter}");
            System.Threading.Thread.Sleep(10000);

            IWebElement browse2 = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/div[3]/div/ng2-file-input/div/div[2]/button"));
            browse2.Click();
            System.Threading.Thread.Sleep(5000);

            //AutoItX3 auto = new AutoItX3();
            System.Threading.Thread.Sleep(5000);
            //Upload patent 360 file 1
            auto.WinActivate("Open");
            System.Threading.Thread.Sleep(6000);

            auto.Send("C:\\RSIP orders doc folder\\Portfolio\\xlsv converted\\PMR_FC_ALL_AbbottCardio.xlsx");
            System.Threading.Thread.Sleep(5000);

            auto.Send("{Enter}");
            System.Threading.Thread.Sleep(10000);
            IWebElement browse3 = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/div[3]/div/ng2-file-input/div/div[2]/button"));
            browse1.Click();
            System.Threading.Thread.Sleep(5000);

            //AutoItX3 auto = new AutoItX3();
            System.Threading.Thread.Sleep(5000);
            //Upload patent 360 file 1
            auto.WinActivate("Open");
            System.Threading.Thread.Sleep(6000);

            auto.Send("C:\\RSIP orders doc folder\\Portfolio\\xlsv converted\\PMR_INNCO_AbbotCardio.xlsx");
            System.Threading.Thread.Sleep(5000);

            auto.Send("{Enter}");
            System.Threading.Thread.Sleep(10000);
            IWebElement browse4 = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/div[3]/div/ng2-file-input/div/div[2]/button"));
            browse1.Click();
            System.Threading.Thread.Sleep(5000);

            //AutoItX3 auto = new AutoItX3();
            System.Threading.Thread.Sleep(5000);
            //Upload patent 360 file 1
            auto.WinActivate("Open");
            System.Threading.Thread.Sleep(6000);

            auto.Send("C:\\RSIP orders doc folder\\Portfolio\\xlsv converted\\PMR_INNCO_LIT_AbbotCardio.xlsx");
            System.Threading.Thread.Sleep(5000);

            auto.Send("{Enter}");
            System.Threading.Thread.Sleep(10000);
            IWebElement browse5 = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/div[3]/div/ng2-file-input/div/div[2]/button"));
            browse1.Click();
            System.Threading.Thread.Sleep(5000);

            //AutoItX3 auto = new AutoItX3();
            System.Threading.Thread.Sleep(5000);
            //Upload patent 360 file 1
            auto.WinActivate("Open");
            System.Threading.Thread.Sleep(6000);

            auto.Send("C:\\RSIP orders doc folder\\Portfolio\\xlsv converted\\PMR_LIT_AbbottCardio.xlsx");
            System.Threading.Thread.Sleep(5000);

            auto.Send("{Enter}");
            System.Threading.Thread.Sleep(10000);
            IWebElement browse6 = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/div[3]/div/ng2-file-input/div/div[2]/button"));
            browse1.Click();
            System.Threading.Thread.Sleep(5000);

            //AutoItX3 auto = new AutoItX3();
            System.Threading.Thread.Sleep(5000);
            //Upload patent 360 file 1
            auto.WinActivate("Open");
            System.Threading.Thread.Sleep(6000);

            auto.Send("C:\\RSIP orders doc folder\\Portfolio\\xlsv converted\\PMR_REJ_AbbottCardio.xlsx");
            System.Threading.Thread.Sleep(5000);

            auto.Send("{Enter}");
            System.Threading.Thread.Sleep(10000);

            IWebElement uploadAndSaveButton = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/mat-card-actions/button[1]/span"));
            Actions action = new Actions(driver);
            action.MoveToElement(uploadAndSaveButton);
            action.Perform();
            System.Threading.Thread.Sleep(5000);
            uploadAndSaveButton.Click();

            System.Threading.Thread.Sleep(10000);

            IWebElement submit = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/mat-card-actions/button[2]"));
            submit.Click();
            System.Threading.Thread.Sleep(10000);
            IWebElement yesBtn = driver.FindElement(By.XPath("//*[text()='Yes']"));
            yesBtn.Click();
            System.Threading.Thread.Sleep(600000);
            IWebElement dashboard = driver.FindElement(By.XPath("/html/body/app-root/div/mat-toolbar/a"));
            dashboard.Click();
            System.Threading.Thread.Sleep(10000);



            driver.SwitchTo().Frame(driver.FindElement(By.TagName("iframe")));
            //driver.FindElement(By.XPath("'//div[text()='orderNumber']'variable")).Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement openFirstOrder = driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[3]/div[1]"));
            Actions actions = new Actions(driver);
            actions.ContextClick(openFirstOrder);
            System.Threading.Thread.Sleep(5000);
            actions.Perform();
            System.Threading.Thread.Sleep(5000);

            IWebElement openTask = driver.FindElement(By.Id("contextmenu-label-text6"));
            openTask.Click();
            System.Threading.Thread.Sleep(16000);

            IWebElement checkBox = driver.FindElement(By.XPath("//*[@id=\"flexTaskInPublish\"]/div[1]/div[1]/div[1]/div[2]/div[4]/div/div/input"));
            checkBox.Click();

            IWebElement publishBtn = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/mat-card-actions/button"));
            publishBtn.Click();
            System.Threading.Thread.Sleep(5000);

        }



        [Test]
        public void CreateOrderPatentabilityAndFreedomToOperate()
        {



            // RSIP_Login login = new RSIP_Login();
            login.loginFun();
            System.Threading.Thread.Sleep(15000);

            IWebElement Addtab = driver.FindElement(By.XPath("//*[@id=\"stepcreateorder\"]/i"));
            Addtab.Click();
            System.Threading.Thread.Sleep(6000);
            IWebElement selectUser = driver.FindElement(By.XPath("/html/body/app-root/div/mat-sidenav-container/mat-sidenav-content/app-place-order/div/mat-card/mat-card-title/div[2]/app-account-user-dropdown-groupping/div/mat-form-field/div/div[1]/div[4]/button/span/mat-icon"));
            selectUser.Click();
            System.Threading.Thread.Sleep(2000);
            //selectUser.Click();

            AutoItX3 auto = new AutoItX3();
            auto.Send("RSIP Test");

            IWebElement patendability = driver.FindElement(By.Id("mat-input-4"));
            patendability.Click();
            patendability.SendKeys("Patentg");
            System.Threading.Thread.Sleep(5000);

            IWebElement searchTerm = driver.FindElement(By.Id("mat-input-5"));
            searchTerm.Click();
            searchTerm.SendKeys("Rsip test");
            System.Threading.Thread.Sleep(10000);


            IWebElement PreApproved = driver.FindElement(By.Id("mat-checkbox-1"));
            PreApproved.Click();
            System.Threading.Thread.Sleep(2000);

            IWebElement CreateOrderBtn = driver.FindElement(By.XPath("/html/body/app-root/div/mat-sidenav-container/mat-sidenav-content/app-place-order/div/div[2]/button/span"));
            CreateOrderBtn.Click();
            System.Threading.Thread.Sleep(10000);
            IWebElement browse = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/div[3]/div/ng2-file-input/div/div[2]/button"));
            browse.Click();
            System.Threading.Thread.Sleep(5000);

            //AutoItX3 auto = new AutoItX3();
            System.Threading.Thread.Sleep(5000);
            //Upload patent 360 file 1
            auto.WinActivate("Open");
            System.Threading.Thread.Sleep(6000);

            auto.Send("C:\\RSIP orders doc folder\\Patent 360\\xlsv files(Converted)\\patent-export-XvuGpD.xlsx");
            System.Threading.Thread.Sleep(5000);

            auto.Send("{Enter}");
            System.Threading.Thread.Sleep(10000);

            IWebElement uploadAndSaveButton = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/mat-card-actions/button[1]/span"));
            Actions action = new Actions(driver);
            action.MoveToElement(uploadAndSaveButton);
            action.Perform();
            System.Threading.Thread.Sleep(5000);
            uploadAndSaveButton.Click();

            System.Threading.Thread.Sleep(10000);

            IWebElement submit = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/mat-card-actions/button[2]"));
            submit.Click();
            System.Threading.Thread.Sleep(10000);
            IWebElement yesBtn = driver.FindElement(By.XPath("//*[text()='Yes']"));
            yesBtn.Click();
            System.Threading.Thread.Sleep(10000);
            IWebElement dashboard = driver.FindElement(By.XPath("/html/body/app-root/div/mat-toolbar/a"));
            dashboard.Click();
            System.Threading.Thread.Sleep(600000);



            driver.SwitchTo().Frame(driver.FindElement(By.TagName("iframe")));
            //driver.FindElement(By.XPath("'//div[text()='orderNumber']'variable")).Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement openFirstOrder = driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[3]/div[1]"));
            Actions actions = new Actions(driver);
            actions.ContextClick(openFirstOrder);
            System.Threading.Thread.Sleep(5000);
            actions.Perform();
            System.Threading.Thread.Sleep(5000);

            IWebElement openTask = driver.FindElement(By.Id("contextmenu-label-text6"));
            openTask.Click();
            System.Threading.Thread.Sleep(16000);

            IWebElement checkBox = driver.FindElement(By.XPath("//*[@id=\"flexTaskInPublish\"]/div[1]/div[1]/div[1]/div[2]/div[4]/div/div/input"));
            checkBox.Click();

            IWebElement publishBtn = driver.FindElement(By.XPath("//*[@id=\"dvInprogress\"]/mat-card-actions/button"));
            publishBtn.Click();
            System.Threading.Thread.Sleep(5000);




        }
        [Test]
        public void CreateOrderPortfolioUnpublish()
        {

            login.loginFun();

            RsipTestCase rsip = new RsipTestCase();
            rsip.CreateOrderPortfolio();
            System.Threading.Thread.Sleep(10000);

            IWebElement dashboard = driver.FindElement(By.XPath("/html/body/app-root/div/mat-toolbar/a"));
            dashboard.Click();
            System.Threading.Thread.Sleep(15000);


            driver.SwitchTo().Frame(driver.FindElement(By.TagName("iframe")));
            //driver.FindElement(By.XPath("'//div[text()='orderNumber']'variable")).Click();
            System.Threading.Thread.Sleep(5000);
            IWebElement openFirstOrder = driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[3]/div[1]"));
            Actions actions = new Actions(driver);
            actions.ContextClick(openFirstOrder);
            System.Threading.Thread.Sleep(5000);
            actions.Perform();
            System.Threading.Thread.Sleep(5000);

            IWebElement openTask = driver.FindElement(By.Id("contextmenu-label-text6"));
            openTask.Click();
            System.Threading.Thread.Sleep(16000);


            IWebElement unpublishBtn = driver.FindElement(By.XPath("//*[@id=\"flexTaskInPublish\"]/div[1]/div[1]/div[1]/div[2]/div[9]/div/input"));
            unpublishBtn.Click();
            System.Threading.Thread.Sleep(10000);

            IWebElement yesBtn = driver.FindElement(By.XPath("//*[text()='Yes']"));
            yesBtn.Click();
            System.Threading.Thread.Sleep(10000);

            driver.FindElement(By.XPath("/html/body/app-root/div/mat-toolbar/a")).Click();
            System.Threading.Thread.Sleep(600000);

            driver.SwitchTo().Frame(driver.FindElement(By.TagName("iframe")));

            System.Threading.Thread.Sleep(10000);
            String status = driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[5]/div[1]")).Text;

            Console.WriteLine("Status : " + status);
            System.Threading.Thread.Sleep(2000);
            bool checkStatus()
            {
                bool flag = false;


                if (status == "Ready to publish")
                {
                    flag = true;

                    return flag;
                }
                else
                {
                    //Console.WriteLine("Report is published");
                    return flag;
                }
            }

            if (checkStatus())
            {
                Console.WriteLine("Report Not published");
            }
            else
            {
                Console.WriteLine("Report published");
            }

            System.Threading.Thread.Sleep(10000);


        }
        [Test]
        public void verifyReport()
        {
            login.loginFun();
            System.Threading.Thread.Sleep(10000);
            /* RsipTestCase rsip = new RsipTestCase();
             rsip.CreateOrderPatent360PreApproved();
             System.Threading.Thread.Sleep(10000);*/
            driver.SwitchTo().Frame(driver.FindElement(By.TagName("iframe")));
            //driver.FindElement(By.XPath("'//div[text()='orderNumber']'variable")).Click();
            System.Threading.Thread.Sleep(5000);
            Actions action = new Actions(driver);
            IWebElement openFirstOrder = driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[8]/transform/div/div[3]/div/visual-modern/div/div/div[2]/div[1]/div[4]/div/div[1]/div[3]/div[1]"));

            action.MoveToElement(openFirstOrder);
            System.Threading.Thread.Sleep(10000);
            Actions actions = new Actions(driver);
            actions.ContextClick(openFirstOrder);
            System.Threading.Thread.Sleep(5000);
            actions.Perform();


            System.Threading.Thread.Sleep(5000);

            IWebElement openReport = driver.FindElement(By.Id("contextmenu-label-text10"));


            openReport.Click();
            System.Threading.Thread.Sleep(20000);


            //driver.SwitchTo().ParentFrame();
            System.Threading.Thread.Sleep(5000);
            driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[2]/transform/div/div[3]/div/visual-modern/div/svg/g[1]/text/tspan")).Click();

            System.Threading.Thread.Sleep(5000);
            String verifyReport = driver.FindElement(By.XPath("//*[@id=\"pvExplorationHost\"]/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[2]/transform/div/div[3]/div/visual-modern/div/svg/g[1]/text/tspan")).Text;
            System.Threading.Thread.Sleep(5000);

            Console.WriteLine("Report" + verifyReport);
            System.Threading.Thread.Sleep(5000);

            if (verifyReport == "US7353555")
            {
                Console.WriteLine("Report created success");
            }
            else
            {
                Console.WriteLine("Report created fail");

            }

        }
    }
}

