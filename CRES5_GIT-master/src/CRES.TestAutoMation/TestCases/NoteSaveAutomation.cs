using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System;
using System.Collections.Generic;


namespace CRES.TestAutoMation.TestCases
{
    public class NoteSaveAutomation : BaseClass
    {
        int loop;
        bool FFSuccessMessageVisible;
        List<NoteDataContract> noteList = new List<NoteDataContract>();
        AutomationLogic autologic;
        WebDriverWait wait;
        string dashboard = "https://qacres4.azurewebsites.net/#/dashboard";
        string NoteFunding = BaseConfiguration.GetURL() + BaseConfiguration.NoteFunding();
        [Test]
        public void SaveNotes()
        {

            Login login = new Login(driver);
            Util util = new Util(driver);

            string weburl = BaseConfiguration.GetURL();
            string username = BaseConfiguration.getusername();
            string password = BaseConfiguration.getpassword();
            string LoginUrl = BaseConfiguration.GetURL();
            string runForAllNotes = BaseConfiguration.TestAllNoteForSaving();
            string runForAllDeal = BaseConfiguration.TestAllDealForGenerateFunding();



            var dataTable = InputHelper.GetDataTableFromExcel(ProjectBaseConfiguration.DataDrivenFileXlsx, "Note_List");
            if (dataTable != null)
            {

                for (int i = 0; i < dataTable.Rows.Count; i++)
                {
                    if (i > 0)
                    {
                        NoteDataContract ldc = new NoteDataContract();
                        ldc.CRENoteID = dataTable.Rows[i].ItemArray[0].ToString();
                        ldc.NoteId = dataTable.Rows[i].ItemArray[1].ToString();
                        noteList.Add(ldc);
                    }
                }

            }
            //}

            util.OpenUrl(LoginUrl);
            System.Threading.Thread.Sleep(5000);

            //login in web site
            if (login.LoginWebPage())
            {

                // data = new string[deallist.Count + 1, 10];

                for (loop = 0; loop < noteList.Count; loop++)
                {
                    FFSuccessMessageVisible = false;
                    Console.WriteLine("Remaining Notes: " + (noteList.Count - loop));

                    util.OpenUrl(dashboard);
                    System.Threading.Thread.Sleep(4000);
                    util.OpenUrl(NoteFunding + noteList[loop].NoteId.ToString());
                    System.Threading.Thread.Sleep(15000);
                    util.WaitForPageLoad(driver);
                    IWebElement saveButton = driver.FindElement(By.Id("btnSave"));
                    saveButton.Click();
                    util.WaitForPageLoad(driver);
                    Console.WriteLine("Sr. No. = " + loop + " Saved Noted = " + noteList[loop].NoteId.ToString());
                    System.Threading.Thread.Sleep(10000);

                }
            }
        } // Close SaveNoteDetails
    } // Close Class
}

