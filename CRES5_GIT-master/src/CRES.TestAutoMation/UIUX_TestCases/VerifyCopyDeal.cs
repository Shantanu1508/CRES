using CRES.DataContract;
using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;
using System;
using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using CRES.TestAutoMation.ExecutionReports;
using System.Data;
using Newtonsoft.Json;
using NPOI.XWPF.UserModel;
using System.Security.Policy;
//using java.nio.file;
using System.IO;
using CRES.BusinessLogic;
//using com.sun.tools.@internal.ws.processor.model;
using System.Net;
using CRES.TestAutoMation.TestCases;

namespace CRES.TestAutoMation.UIUX_TestCases
{
    public class VerifyCopyDeal : BaseClass
    {
        List<PageLoadTest> listPageLoad = new List<PageLoadTest>();

        [Test]
        public void DealDataVerification()
        {
            Actions actions = new Actions(driver);

            CRES_Login loginapp = new CRES_Login();
            Login login = new Login(driver);
            Deal deal = new Deal(driver);
            Util util = new Util(driver);
            string dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
            string username = BaseConfiguration.getusername();
            string password = BaseConfiguration.getpassword();
            string LoginUrl = BaseConfiguration.LoginUrl();


            util.OpenUrl(LoginUrl);


            //System.Threading.Thread.Sleep(10000);
            try
            {
                if (login.LoginWebPage())
                {
                    System.Threading.Thread.Sleep(20000);


                    String BaseUrl = null;
                    String Env = "QA";//"QA","Int","Prod","Stag"
                    switch (Env)
                    {
                        case "QA":
                            BaseUrl = BaseConfiguration.QAUrl();
                            //util.OpenUrl(BaseUrl);



                            break;

                        case "Int":
                            BaseUrl = BaseConfiguration.IntUrl();
                            break;

                        case "Prod":
                            BaseUrl = BaseConfiguration.AcoreUrl();
                            break;

                    }


                    String DealUrl = BaseUrl + "#/dealdetail/FDD8EC03-9D63-4512-9990-89C508983EDC";
                    util.OpenUrl(DealUrl);
                    System.Threading.Thread.Sleep(10000);

                    /*IWebElement intLogin = driver.FindElement(By.Name("login"));
                    intLogin.SendKeys("admin_qa");

                    IWebElement intPass = driver.FindElement(By.Name("password"));
                    intPass.SendKeys("qwert1*");

                    IWebElement loginBtn = driver.FindElement(By.Id("login"));
                    loginBtn.Click();



                    System.Threading.Thread.Sleep(20000);*/
                    //MainTab
                    // Boolean DealId = driver.FindElement(By.Id("CREDealID")).Displayed;
                    Boolean DealID = driver.FindElement(deal.dealID).Displayed;

                    addtolist("deal", "Main", DealID);
                    Console.WriteLine("Deal Id= " + DealID);

                    Boolean DealName = driver.FindElement(deal.dealName).Displayed;
                    Console.WriteLine("Deal Name= " + DealName);
                    addtolist("deal", "Main", DealName);

                    //System.Threading.Thread.Sleep(20000);
                    //FundingTab
                    /*driver.FindElement(deal.fundingTab).Click();

                   System.Threading.Thread.Sleep(10000);


                   Boolean EnableFundingSchedule = driver.FindElement(deal.enableFundingSchedule).Displayed;
                   Console.WriteLine("EnableFundingSchedule=  " + EnableFundingSchedule);
                   addtolist("deal", "funding", EnableFundingSchedule);
                  try
                  {
                      IJavaScriptExecutor js = (IJavaScriptExecutor)driver;
                      js.ExecuteScript("window.scrollBy(2000,0)");
                      System.Threading.Thread.Sleep(10000);
                  }
                  catch (Exception e)
                  {
                      Console.WriteLine(e);

                  }*/
                  //System.Threading.Thread.Sleep(20000);
                    //Boolean TotalCommitementAdjustment = driver.FindElement(By.ClassName("wj-form-control wj-numeric")).Displayed;
                    //Console.WriteLine("Total Commitement Adjustment= " + TotalCommitementAdjustment);
                    //System.Threading.Thread.Sleep(20000);


                    //AmortTab

                    /*driver.FindElement(deal.amortTab).Click();

                     System.Threading.Thread.Sleep(10000);
                     Boolean AmortizationMethod = driver.FindElement(deal.amortizationMethodElement).Displayed;
                     Console.WriteLine("Amortization Method = " + AmortizationMethod);
                     addtolist("deal", "Amort", AmortizationMethod);
                     

                     Boolean ReduceAmortization = driver.FindElement(deal.reduceAmortizationElement).Displayed;
                     Console.WriteLine("Reduce Amortization = " + ReduceAmortization);
                     addtolist("deal", "Amort", ReduceAmortization);*/


                   /* System.Threading.Thread.Sleep(20000);
                    //PayRules
                    driver.FindElement(deal.payRuleTab).Click();

                    System.Threading.Thread.Sleep(10000);
                    Boolean PayruleNoteId = driver.FindElement(deal.payruleNoteID).Displayed;
                    Console.WriteLine("Payrul NoteID  = " + PayruleNoteId);
                    addtolist("deal", "Pay Rules", PayruleNoteId);


                    //TotalCommitement tab
                    driver.FindElement(deal.totalCommitementTab).Click();

                    System.Threading.Thread.Sleep(10000);
                    Boolean TotalCommitmentCheck = driver.FindElement(By.XPath("//*[@id=\"DealAdjustedtotalCommitment\"]/div/h3")).Displayed;
                    Console.WriteLine("Total commitment check  = " + TotalCommitmentCheck);
                    addtolist("deal", "Total commitment ", TotalCommitmentCheck);*/


                    //PayOff
                    /*driver.FindElement(deal.payOffTab).Click();

                    System.Threading.Thread.Sleep(10000);
                    Boolean PayOffCheck = driver.FindElement(deal.payOffCheckElement).Displayed;
                    Console.WriteLine("PayOff check  = " + PayOffCheck);

                    addtolist("deal", "PayOff ", PayOffCheck);


                    System.Threading.Thread.Sleep(10000);*/
                    //Documents
                   /* driver.FindElement(deal.documentsTab).Click();

                    System.Threading.Thread.Sleep(10000);
                    Boolean DocumentsCheck = driver.FindElement(deal.documentCheckElement).Displayed;
                    Console.WriteLine("Documents check  = " + DocumentsCheck);
                    addtolist("deal", "Documents ", DocumentsCheck);


                    System.Threading.Thread.Sleep(10000);
                    //ActivityTab
                    driver.FindElement(deal.activityTab).Click();

                    System.Threading.Thread.Sleep(10000);
                    Boolean ActivityCheck = driver.FindElement(deal.activityCheckElement).Displayed;
                    Console.WriteLine("Activity check  = " + ActivityCheck);
                    addtolist("deal", "Activity ", ActivityCheck);



                    System.Threading.Thread.Sleep(20000);

                    //ButtonVerification
                    Boolean SaveButton = driver.FindElement(deal.btnSaveDeal).Displayed;
                    Console.WriteLine("Save button  check  = " + SaveButton);
                    addtolist("deal", "Save Button ", SaveButton);


                    System.Threading.Thread.Sleep(10000);
                    Boolean CancelButton = driver.FindElement(deal.dealCancelButton).Displayed;
                    Console.WriteLine("Cancel button  check  = " + CancelButton);
                    addtolist("deal", "cancel Button ", CancelButton);


                    System.Threading.Thread.Sleep(10000);
                    Boolean CopyDealButton = driver.FindElement(deal.copyDealBtn).Displayed;
                    Console.WriteLine("Copy Deal  button  check  = " + CopyDealButton);
                    addtolist("deal", "Copy Deal  Button ", CopyDealButton);


                    System.Threading.Thread.Sleep(10000);
                    Boolean DownloadButton = driver.FindElement(deal.downloadButton).Displayed;
                    Console.WriteLine("Download button  check  = " + DownloadButton);
                    addtolist("deal", "Download Button ", DownloadButton);


                    System.Threading.Thread.Sleep(10000);
                    Boolean AdminButton = driver.FindElement(deal.adminButton).Displayed;
                    Console.WriteLine("Admin button  check  = " + AdminButton);
                    addtolist("deal", "Admin Button ", AdminButton);

                    System.Threading.Thread.Sleep(20000);


                    //----------------------Note Details Verification---------------------------

                    string NoteUrl = BaseUrl + "#/notedetail/4bd379aa-162d-45f0-8ca6-22da944c6884";
                    util.OpenUrl(NoteUrl);
                    System.Threading.Thread.Sleep(20000);

                    //Closing Tab
                    driver.FindElement(deal.closingTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean actualFreqElmnt = driver.FindElement(deal.actualFreqElmnt).Displayed;
                    Console.WriteLine("Actual Freq Element   = " + actualFreqElmnt);
                    addtolist("Note ", "Closing Tab ", actualFreqElmnt);

                    System.Threading.Thread.Sleep(10000);

                    //AccountingTab
                    driver.FindElement(deal.accountingTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean clientElement = driver.FindElement(deal.clientElement).Displayed;
                    Console.WriteLine("Client Element    = " + clientElement);
                    addtolist("Note ", "Accounting Tab ", clientElement);


                    //Financing Tab

                    driver.FindElement(deal.financingTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean financingFacElmnt = driver.FindElement(deal.financingFacElmnt).Displayed;
                    Console.WriteLine(" Financing facility element    = " + financingFacElmnt);
                    addtolist("Note ", "Financing Tab ", financingFacElmnt);


                    //SettelementTab

                    driver.FindElement(deal.settlmntTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean closingDateElmnt = driver.FindElement(deal.closingDateElmnt).Displayed;
                    Console.WriteLine(" Closing Date Element   = " + closingDateElmnt);
                    addtolist("Note ", "Settelment Tab ", closingDateElmnt);


                    //Default Tab

                    driver.FindElement(deal.defaultTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean effectiveDteElmnt = driver.FindElement(deal.effectiveDteElmnt).Displayed;
                    Console.WriteLine(" Effective Date Element  = " + effectiveDteElmnt);
                    addtolist("Note ", "Deafult Tab ", effectiveDteElmnt);


                    //Servicing Tab
                    driver.FindElement(deal.servicingTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean servicingNameElmnt = driver.FindElement(deal.servicingNameElmnt).Displayed;
                    Console.WriteLine(" Servicing Name Element   = " + servicingNameElmnt);
                    addtolist("Note ", "Deafult Tab ", servicingNameElmnt);


                    //Actuals Tab
                    driver.FindElement(deal.actualsTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean interestElement = driver.FindElement(deal.interestElement).Displayed;
                    Console.WriteLine(" Interest Element    = " + interestElement);
                    addtolist("Note ", "Actuals Tab ", interestElement);


                    //PIK Tab
                    driver.FindElement(deal.pikTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean pikSourceElement = driver.FindElement(deal.pikSourceElement).Displayed;
                    Console.WriteLine(" PIK source element    = " + pikSourceElement);
                    addtolist("Note ", "PIK Tab ", pikSourceElement);


                    //Coupon Tab

                    driver.FindElement(deal.couponTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean couponElement = driver.FindElement(deal.couponElement).Displayed;
                    Console.WriteLine(" Coupon Element    = " + couponElement);
                    addtolist("Note ", "Coupon Tab ", couponElement);


                    //Note Funding Tab
                    driver.FindElement(deal.noteFundingTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean noteFundingElemnt = driver.FindElement(deal.noteFundingElemnt).Displayed;
                    Console.WriteLine(" Funding Element    = " + noteFundingElemnt);
                    addtolist("Note ", "PIK Tab ", noteFundingElemnt);


                    //Cashflow Tab
                    driver.FindElement(deal.cashflowTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean periodicOtpButton = driver.FindElement(deal.periodicOtpButton).Displayed;
                    Console.WriteLine(" Cashflow Element    = " + periodicOtpButton);
                    addtolist("Note ", "Cashflow Tab ", periodicOtpButton);


                    //Exceptions Tab

                    driver.FindElement(deal.exceptionTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean exceptionElement = driver.FindElement(deal.exceptionElement).Displayed;
                    Console.WriteLine(" Exception Element    = " + exceptionElement);
                    addtolist("Note ", "Exception Tab ", exceptionElement);


                    //Notes Document Tab

                    driver.FindElement(deal.noteDocTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean noteDocTabElmnt = driver.FindElement(deal.noteDocTabElmnt).Displayed;
                    Console.WriteLine(" Note Document Element    = " + noteDocTabElmnt);
                    addtolist("Note ", "Exception Tab ", noteDocTabElmnt);


                    //Activity Tab

                    driver.FindElement(deal.noteActTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean noteActElement = driver.FindElement(deal.noteActElement).Displayed;
                    Console.WriteLine(" Note Activity Element    = " + noteActElement);
                    addtolist("Note ", "Activity Tab ", noteActElement);



                    //---------------------My Account Verification------------------------------
                    String MyAccounturl = BaseConfiguration.MyAccountUrl();
                    String OpenMyAccountUrl = BaseUrl + MyAccounturl;
                    util.OpenUrl(OpenMyAccountUrl);
                    System.Threading.Thread.Sleep(10000);
                    //Accounting Tab

                    driver.FindElement(deal.accountTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean accountTabElmnt = driver.FindElement(deal.accountTabElmnt).Displayed;
                    Console.WriteLine(" Account Tab Element     = " + accountTabElmnt);
                    addtolist("My Account ", "My Account  Tab ", accountTabElmnt);


                    //Preferences Tab

                    driver.FindElement(deal.preferencesTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean preferenceTabElmnt = driver.FindElement(deal.preferenceTabElmnt).Displayed;
                    Console.WriteLine(" Preferences Tab Element     = " + preferenceTabElmnt);
                    addtolist("My Account ", "Preferences  Tab ", preferenceTabElmnt);


                    //Profile Delegation Tab

                    driver.FindElement(deal.profileDelegTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean btnCreateRole = driver.FindElement(deal.btnCreateRole).Displayed;
                    Console.WriteLine(" Profile Delegation Tab Element     = " + btnCreateRole);
                    addtolist("My Account ", " Profile Delegation Tab ", btnCreateRole);


                    //--------------------------User Management verification----------------------------------------------//
                    // User management tab
                    String UserManagementurl = BaseConfiguration.UserManagementUrl();
                    String OpenUserManagementUrl = BaseUrl + UserManagementurl;
                    util.OpenUrl(OpenUserManagementUrl);

                    System.Threading.Thread.Sleep(10000);
                    Boolean userManagementElmnt = driver.FindElement(deal.userManagementElmnt).Displayed;
                    Console.WriteLine(" User Management Element      = " + userManagementElmnt);
                    addtolist("User Management ", " User Management Tab ", userManagementElmnt);
                    System.Threading.Thread.Sleep(10000);
                    // Role Permission Tab

                    driver.FindElement(deal.rolePermissionTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean roleElmnt = driver.FindElement(deal.roleElmnt).Displayed;
                    Console.WriteLine(" Role Permission Element      = " + roleElmnt);
                    addtolist("User Management ", " Role Permission Tab ", roleElmnt);
                    System.Threading.Thread.Sleep(10000);
                    Boolean addNewRoleBtn = driver.FindElement(deal.addNewRoleBtn).Displayed;
                    Console.WriteLine(" Role Permission Element      = " + addNewRoleBtn);
                    addtolist("User Management ", " Role Permission Tab ", addNewRoleBtn);
                    System.Threading.Thread.Sleep(10000);
                    //Manage App settings Tab

                    driver.FindElement(deal.manageAppSettngsTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean managaeAppStngElmnt = driver.FindElement(deal.managaeAppStngElmnt).Displayed;
                    Console.WriteLine(" Manage App settings Element      = " + managaeAppStngElmnt);
                    addtolist("User Management ", " Manage App settings Tab ", managaeAppStngElmnt);
                    System.Threading.Thread.Sleep(10000);

                    //Workflow Approver Tab
                    driver.FindElement(deal.workflowApprovTab).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean workAprvElmnt = driver.FindElement(deal.workAprvElmnt).Displayed;
                    Console.WriteLine(" WorkFlow Approver Element      = " + workAprvElmnt);
                    addtolist("User Management ", " Workflow Approver Tab ", workAprvElmnt);

                    //-----------------------------------------Data Management----------------

                    String DataManagementUrl = BaseUrl + BaseConfiguration.DataManagementUrl();
                    util.OpenUrl(DataManagementUrl);
                    System.Threading.Thread.Sleep(10000);
                    // Delete Deal Tab

                    Boolean deleteDealName = driver.FindElement(deal.deleteDealName).Displayed;
                    Console.WriteLine("Data Management- Delete deal tab     = " + deleteDealName);
                    addtolist("Data Management ", " Delete deal Tab ", deleteDealName);

                    //Delete Note Tab

                    driver.FindElement(deal.deleteNoteTab).Click();
                    System.Threading.Thread.Sleep(8000);

                    Boolean deleteNoteElmnt = driver.FindElement(deal.deleteNoteElmnt).Displayed;
                    Console.WriteLine("Data Management- Delete Note tab     = " + deleteNoteElmnt);
                    addtolist("Data Management ", " Delete note Tab ", deleteNoteElmnt);

                    //Upload file Tab

                    driver.FindElement(deal.uploadFileTab).Click();
                    System.Threading.Thread.Sleep(8000);

                    Boolean dailyExtractBtn = driver.FindElement(deal.dailyExtractBtn).Displayed;
                    Console.WriteLine("Data Management- Upload file tab     = " + dailyExtractBtn);
                    addtolist("Data Management ", " Upload File Tab ", dailyExtractBtn);

                    // Servicer Tab

                    driver.FindElement(deal.servicerTab).Click();
                    System.Threading.Thread.Sleep(8000);

                    Boolean serviceName = driver.FindElement(deal.serviceName).Displayed;
                    Console.WriteLine("Data Management- Servicer tab     = " + serviceName);
                    addtolist("Data Management ", " Servicer Tab ", serviceName);

                    //Transaction type Tab

                    driver.FindElement(deal.transactionTypesTab).Click();
                    System.Threading.Thread.Sleep(8000);

                    Boolean transactionTypeElmnt = driver.FindElement(deal.transactionTypeElmnt).Displayed;
                    Console.WriteLine("Data Management- Transaction Type tab     = " + transactionTypeElmnt);
                    addtolist("Data Management ", " Transaction Type tab ", transactionTypeElmnt);
                    System.Threading.Thread.Sleep(8000);


                    //--------------------------------Notification Subscription-----------------------------------------//

                    String NotifSubUrl = BaseUrl + BaseConfiguration.NotificationSubsUrl();
                    util.OpenUrl(NotifSubUrl);
                    System.Threading.Thread.Sleep(8000);

                    Boolean notifiSubElmnt = driver.FindElement(deal.notifiSubElmnt).Displayed;
                    Console.WriteLine("Notification Subscription     = " + notifiSubElmnt);
                    addtolist("Notification Subscription ", " Notification Subscription ", notifiSubElmnt);


                    //---------------------------------------Scenarios verification-------------------------------//

                    String ScenariosUrl = BaseUrl + BaseConfiguration.ScenarioUrl();
                    util.OpenUrl(ScenariosUrl);
                    System.Threading.Thread.Sleep(10000);
                    Boolean addScenarioBtn = driver.FindElement(deal.addScenarioBtn).Displayed;
                    Console.WriteLine(" Scenario Element      = " + addScenarioBtn);
                    addtolist("Scenario ", " Scenarios ", addScenarioBtn);

                    driver.FindElement(deal.addScenarioBtn).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean scenarioName = driver.FindElement(deal.scenarioName).Displayed;
                    Console.WriteLine(" Add Scenario Element     = " + scenarioName);
                    addtolist("Scenario ", " Add Scenarios ", scenarioName);
                    System.Threading.Thread.Sleep(10000);
                    Boolean calculationMode = driver.FindElement(deal.calculationMode).Displayed;
                    Console.WriteLine(" Add Scenario Element     = " + calculationMode);
                    addtolist("Scenario ", " Add Scenarios ", calculationMode);


                    //------------------------------------Index page Verification---------------------------------------//

                    String IndexPageurl = BaseUrl + BaseConfiguration.IndexPageUrl();
                    util.OpenUrl(IndexPageurl);
                    System.Threading.Thread.Sleep(10000);
                    Boolean addIndexScenarioBtn = driver.FindElement(deal.addIndexScenarioBtn).Displayed;
                    Console.WriteLine(" Index Scenario Element     = " + addIndexScenarioBtn);
                    addtolist("Index Scenario ", " Index Scenarios ", addIndexScenarioBtn);

                    driver.FindElement(deal.addIndexScenarioBtn).Click();
                    System.Threading.Thread.Sleep(10000);
                    Boolean indexName = driver.FindElement(deal.indexName).Displayed;
                    Console.WriteLine(" Add Index Scenario Element     = " + indexName);
                    addtolist("Index Scenario ", " Add Index Scenarios ", indexName);
                    System.Threading.Thread.Sleep(10000);
                    Boolean indexDescription = driver.FindElement(deal.indexDescription).Displayed;
                    Console.WriteLine(" Add Index Scenario Element     = " + indexDescription);
                    addtolist("Index Scenario ", " Add Index Scenarios ", indexDescription);

                    //-------------------------------Fee Configuration----------------------------------------//

                    String FeeConfigurl = BaseUrl + BaseConfiguration.FeeConfigUrl();
                    util.OpenUrl(FeeConfigurl);
                    System.Threading.Thread.Sleep(8000);

                    // Fee Function Definition Tab

                    Boolean feeFuncDefElmnt = driver.FindElement(deal.feeFuncDefElmnt).Displayed;
                    Console.WriteLine(" Fee Function Definition Element     = " + feeFuncDefElmnt);
                    addtolist("Fee Configuration ", " Fee Function Definition ", feeFuncDefElmnt);

                    //Base Amount Determination Tab

                    driver.FindElement(deal.baseAmntDeterm).Click();
                    System.Threading.Thread.Sleep(10000);

                    Boolean baseAmntDetermElmnt = driver.FindElement(deal.baseAmntDetermElmnt).Displayed;
                    Console.WriteLine(" Base Amount Determination Element     = " + baseAmntDetermElmnt);
                    addtolist("Fee Configuration ", " Base Amount Determination ", baseAmntDetermElmnt);



                    // ----------Dynamic Portfolio
                    String DynamicPortfolioUrl = BaseUrl + BaseConfiguration.DynamicPortfolioUrl();
                    util.OpenUrl(DynamicPortfolioUrl);
                    System.Threading.Thread.Sleep(10000);
                    Boolean addPortfolioBtn = driver.FindElement(deal.addPortfolioBtn).Displayed;
                    Console.WriteLine(" Dynamic portfolio Element    = " + addPortfolioBtn);
                    addtolist("Dynamic Portfolio ", " Dynamic Portfolio ", addPortfolioBtn);

                    driver.FindElement(deal.addPortfolioBtn).Click();
                    System.Threading.Thread.Sleep(10000);

                    Boolean portfolioName = driver.FindElement(deal.portfolioName).Displayed;
                    Console.WriteLine(" Dynamic portfolio Element    = " + portfolioName);
                    addtolist("Dynamic Portfolio ", " Add Portfolio ", portfolioName);


                    //----------------------------------Transaction reconsilation----------------------------------------------------//

                    String TranscationReconUrl = BaseUrl + BaseConfiguration.TranscatioReconUrl();
                    util.OpenUrl(TranscationReconUrl);
                    System.Threading.Thread.Sleep(10000);

                    Boolean clearSectionBtn = driver.FindElement(deal.clearSectionBtn).Displayed;
                    Console.WriteLine(" Transaction reconsilationElement    = " + clearSectionBtn);
                    addtolist("Transaction reconsilation ", " Transaction reconsilation ", clearSectionBtn);

                    Boolean downloadTemplateBtn = driver.FindElement(deal.downloadTemplateBtn).Displayed;

                    Console.WriteLine(" Transaction reconsilationElement    = " + downloadTemplateBtn);
                    addtolist("Transaction reconsilation ", " Transaction reconsilation ", downloadTemplateBtn);

                    //Transacaction Audit 

                    String TransacAuditUrl = BaseUrl + BaseConfiguration.TransactionauditURL();
                    util.OpenUrl(TransacAuditUrl);
                    System.Threading.Thread.Sleep(10000);

                    Boolean transcAuditElmnt = driver.FindElement(deal.transcAuditElmnt).Displayed;

                    Console.WriteLine("Transacaction Audit    = " + transcAuditElmnt);
                    addtolist("Transacaction Audit  ", " Transacaction Audit ", transcAuditElmnt);

                    //-------------------------Periodic Close-----------------------------------------//

                    String PeriodicloseUrl = BaseUrl + BaseConfiguration.periodicCloseUrl();
                    util.OpenUrl(PeriodicloseUrl);
                    System.Threading.Thread.Sleep(10000);

                    Boolean closePeriodBtn = driver.FindElement(deal.closePeriodBtn).Displayed;
                    Console.WriteLine("Periodic Close   = " + closePeriodBtn);
                    addtolist("Periodic Close   ", " Periodic Close  ", closePeriodBtn);
                    System.Threading.Thread.Sleep(10000);
                    Boolean periodicEndDate = driver.FindElement(deal.periodicEndDate).Displayed;

                    Console.WriteLine("Periodic Close   = " + periodicEndDate);
                    addtolist("Periodic Close   ", " Periodic Close  ", periodicEndDate);



                    //----------------------------------------Calculation Manager-------------------------------------//

                    //calculation Manager

                    String CalcManagerUrl = BaseUrl + BaseConfiguration.CalculationManagerUrl();
                    util.OpenUrl(CalcManagerUrl);
                    System.Threading.Thread.Sleep(10000);

                    Boolean calculationManagerElmnt = driver.FindElement(deal.calculationManagerElmnt).Displayed;
                    Console.WriteLine("calculation Manager Element   = " + calculationManagerElmnt);
                    addtolist("calculation Manager   ", " calculation Manager  ", calculationManagerElmnt);



                    //Notes With Exception Tab

                    driver.FindElement(deal.notesWthExcepTab).Click();
                    System.Threading.Thread.Sleep(10000);

                    Boolean notesWthExcepElmnt = driver.FindElement(deal.notesWthExcepElmnt).Displayed;
                    Console.WriteLine("Notes With Exception Element   = " + notesWthExcepElmnt);
                    addtolist("calculation Manager   ", " Notes With Exception ", notesWthExcepElmnt);


                    //Batch Log

                    driver.FindElement(deal.batchLogTab).Click();
                    System.Threading.Thread.Sleep(10000);

                    Boolean batchLogElmnt = driver.FindElement(deal.batchLogElmnt).Displayed;
                    Console.WriteLine("Batch Log Element   = " + batchLogElmnt);
                    addtolist("calculation Manager   ", " Batch Log ", batchLogElmnt);


                    //----------------------------------------Reports----------------------------------//
                    // reports 
                    String ReportUrl = BaseUrl + BaseConfiguration.ReportUrl();
                    util.OpenUrl(ReportUrl);
                    System.Threading.Thread.Sleep(8000);
                    Boolean refreshDataWarehouseBtn = driver.FindElement(deal.refreshDataWarehouseBtn).Displayed;
                    Console.WriteLine("Reports   = " + refreshDataWarehouseBtn);
                    addtolist("Reports   ", " Reports ", refreshDataWarehouseBtn);

                    //reports History

                    String ReportHistoryUrl = BaseUrl + BaseConfiguration.ReportHistoryUrl();
                    util.OpenUrl(ReportHistoryUrl);
                    System.Threading.Thread.Sleep(8000);

                    Boolean reportName = driver.FindElement(deal.reportName).Displayed;
                    Console.WriteLine("Reports   = " + reportName);
                    addtolist("Reports   ", " Reports History ", reportName);


                    //----------------------------Tags---------------------------//

                    String TagsUrl = BaseUrl + BaseConfiguration.TagsUrl();
                    util.OpenUrl(TagsUrl);
                    System.Threading.Thread.Sleep(8000);

                    Boolean addNewTagBtn = driver.FindElement(deal.addNewTagBtn).Displayed;
                    Console.WriteLine("Tags   = " + addNewTagBtn);
                    addtolist("Tags   ", " Tags ", addNewTagBtn);


                    //----------------------WorkFlow-----------------------------------//

                    String WorkflowUrl = BaseUrl + BaseConfiguration.WorkFlowUrl();
                    util.OpenUrl(WorkflowUrl);
                    System.Threading.Thread.Sleep(8000);

                    Boolean workflowElmnt = driver.FindElement(deal.workflowElmnt).Displayed;
                    Console.WriteLine("Workflow   = " + workflowElmnt);
                    addtolist("Workflow   ", " Workflow ", workflowElmnt);


                    //----------------Task Management--------

                    String TaskManagementUrl = BaseUrl + BaseConfiguration.TaskUrl();
                    util.OpenUrl(TaskManagementUrl);
                    System.Threading.Thread.Sleep(8000);

                    Boolean addTaskBtn = driver.FindElement(deal.addTaskBtn).Displayed;
                    Console.WriteLine("Task Management  = " + addTaskBtn);
                    addtolist("Task Management   ", " Task Management ", addTaskBtn);

                    driver.FindElement(deal.addTaskBtn).Click();
                    System.Threading.Thread.Sleep(5000);

                    Boolean addTaskElmnt = driver.FindElement(deal.addTaskElmnt).Displayed;
                    Console.WriteLine("Task Management  = " + addTaskElmnt);
                    addtolist("Task Management   ", " Add Task ", addTaskElmnt);

                    Boolean summaryElmnt = driver.FindElement(deal.summaryElmnt).Displayed;
                    Console.WriteLine("Task Management  = " + summaryElmnt);
                    addtolist("Task Management   ", " Add Task ", summaryElmnt);

                    //------------------------------Help----------------------------------------//

                    String HelpUrl = BaseUrl + BaseConfiguration.HelpPageUrl();
                    util.OpenUrl(HelpUrl);
                    System.Threading.Thread.Sleep(8000);

                    Boolean helpBtn = driver.FindElement(deal.helpBtn).Displayed;
                    Console.WriteLine("Help  = " + helpBtn);
                    addtolist("Help  ", " Help ", helpBtn);


                    Boolean contactUsHeading = driver.FindElement(deal.contactUsHeading).Displayed;
                    Console.WriteLine("Help  = " + contactUsHeading);
                    addtolist("Help  ", " Help ", contactUsHeading);


                    GenerateExcelFile.CreateExcelDataTable((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(listPageLoad), (typeof(DataTable))), "PageLoad");*/

                    //----------------------------Logout-----------//


                    driver.FindElement(deal.krishnaDropdown).Click();
                    System.Threading.Thread.Sleep(10000);

                    driver.FindElement(deal.logoutBtn).Click();
                    System.Threading.Thread.Sleep(8000);
                    Boolean logoutElmnt = driver.FindElement(deal.loginPage).Displayed;
                    Console.WriteLine("Logout  = " + logoutElmnt);
                    addtolist("Logout  ", " Logout ", logoutElmnt);
                    System.Threading.Thread.Sleep(8000);

                    
                    GenerateExcelFile.CreateExcelDataTable((DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(listPageLoad), (typeof(DataTable))), "PageLoad");
                    //string path = Directory.GetCurrentDirectory();
                    System.Threading.Thread.Sleep(8000);
                    //string path = Directory.GetCurrentDirectory();
                    //Console.WriteLine("Path of current directory "+ path);
                    System.Threading.Thread.Sleep(8000);

                    EmailDataContract emailDC = new EmailDataContract();
                    emailDC.To = "gthakur@hvantage.com";

                    //optional
                    //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
                    //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
                    emailDC.ReceiverName = "Shahid";
                    emailDC.FileAttachment = new List<FileAttachmentDataContract>();
                    emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = "D:\\PageLoad_10_06_2020_15_29_03.xlsx" });
                    emailDC.Subject = "This is subject";
                    emailDC.Body = "This is body";
                    emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
                    emailDC.EmailSettings.Host = BaseConfiguration.Host;
                    emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
                    emailDC.EmailSettings.Password = BaseConfiguration.Password;
                    emailDC.EmailSettings.Port = BaseConfiguration.Port;
                    //
                    EmailAutomationLogic lg = new EmailAutomationLogic();
                    
                   String response = lg.SendGenericEmail(emailDC);
                    



                    System.Threading.Thread.Sleep(8000);


                   






































                }
                else
                {
                    Console.WriteLine("Login Failed");
                }


                

            }
            catch (Exception e)
            {

            }

            
        }

        public void addtolist(string pagename, string tabname, Boolean res)
        {
            PageLoadTest plt = new PageLoadTest();
            plt.PageName = pagename;
            plt.TabName = tabname;
            if (res == true)
            {
                plt.Status = "Loaded";
            }
            else
            {
                plt.Status = "Error";
            }
            listPageLoad.Add(plt);
        }


       
                    
    }
}
