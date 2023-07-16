using CRES.TestAutoMation.Utility;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;

namespace CRES.TestAutoMation.Pages
{
    public class Deal
    {
        private IWebDriver driver = null;
        private Util util = null;
        public Deal(IWebDriver d)
        {
            this.driver = d;
            util = new Util(d);
        }
        public By username = By.Name("login");
        public By password = By.Name("password");
        public By loginBtn = By.Id("login");
        public By tabFunding = By.Id("aFunding");
        public By btnGenerateFunding = By.Id("btnGenerateFutureFunding");
        public By btnRepaymentAutpspread = By.Id("btnAutospreadRepayment");
        public By btnGenerateFundingOK = By.XPath("//*[@id=\"dialogboxfoot\"]/span");
        public By btnSaveDeal = By.Id("btnSaveDeal");
        public By btnCRESvalOk = By.Id("btnCRESvalOk");
        public By successMessage1 = By.XPath("//*[@id=\"form1\"]/div/div[1]/div/strong");
        public By successMessage = By.Id("sucessmessagediv");
        public By validationPopUp = By.Id("dialogbox");
        public By validationMessages = By.XPath("//*[@id=\"dialogboxbody\"]/p");
        public By saveDialogBox = By.Id("savedialogmessage");
        public By saveDialogBoxOkButton = By.XPath("//*[@id=\"myModalgen\"]/div/div[3]/button[2]");
        public By dealSaveValidationPopup = By.Id("dialogbox");
        public By ValidationsList = By.XPath("//*[@id=\"dialogboxbody\"]/p");
        public By overrideNonCommentedRecords = By.Id("dialogboxbodyFF");


        private By tabDealAmorttab = By.Id("aDealAmorttab");
        public By btnoverrideNonCommentedRecordsOk = By.Id("btnCRESfundOkFF");
        private By AmortizationMethod = By.Id("AmortizationMethod");
        private By amortok = By.Id("amortok");
        public By btnGenerateAmortization = By.Id("btnGenerateAmortization");
        public By divShowmessagediv = By.Id("divShowmessagediv");
        private By DivNorecord = By.Id("divamorterrormsg");
        public By copyDealBtn = By.Id("btnCopyDeal");
        public By copyDealID = By.Name("CopyDealID");
        public By copyDealName = By.Name("CopyDealName");
        public By copyAndOpenBtn = By.Id("btndealcopyaandopen");
        public By dealID = By.Id("CREDealID");
        public By dealName = By.Id("DealName");
        public By mainTab = By.Id("aMain");
        public By fundingTab = By.Id("aFunding");  
        public By TotalFundingSequance = By.XPath("//*[@id=\"futureFunding\"]/div/div[4]/div[1]/wj-flex-grid/div[1]/div[5]/div/div[15]");
        public By TotalReqEquityDealFunding = By.XPath("//*[@id=\"dealfunding\"]/div[1]/div[5]/div/div[5]");
        public By ASTotalRequiredEquity = By.XPath("//*[@id=\"flexautospreadrule\"]/div[1]/div[5]/div/div[3]");
        public By AsEndDate = By.XPath("//*[@id=\"flexautospreadrule\"]/div[1]/div[2]/div[1]/div[6]/div/div");
        public By FullyExtMaturityDate = By.XPath("//*[@id=\"flexMaturity\"]/div[1]/div[2]/div[1]/div[13]");
        public By Commitment_EquityTab = By.XPath("//*[@id=\"aAdjustedTotalCommitment\"]");
        public By ExportToExcel = By.XPath("//div//span//button[text()='Export to excel']");
        public By CommitmentRequiredEquity = By.XPath("//*[@id=\"DealAdjustedtotalCommitment\"]/div/div[1]/div[4]/wj-flex-grid/div[1]/div[5]/div/div[8]");
        public By enableFundingSchedule = By.ClassName("customheading");
        public By amortTab = By.Id("aDealAmorttab");
        public By amortizationMethodElement = By.Id("AmortizationMethod");
        public By reduceAmortizationElement = By.Id("ReduceAmortizationForCurtailments");
        public By payRuleTab = By.Id("aNotepayrule");
        public By payruleNoteID = By.XPath("/html/body/app-root/div/div[2]/div/div/div[2]/dealdetail/form/div/div[2]/div/div[3]/div/div/div/wj-flex-grid/div[1]/div[1]/div[1]/div[2]/div[1]");
        public By DealHeading = By.XPath("//div[@Class='head fixheaderdiv']//h1"); // for Integration 
        public By payrulePage = By.Id("notepayrule");
        public By payOffTab = By.Id("aPayOff");
        public By payOffCheckElement = By.ClassName("custombutton");
        public By documentsTab = By.Id("aImport");
        public By documentCheckElement = By.XPath("//*[@id=\"docImport\"]/div[1]/h3");
        public By activityTab = By.Id("aActivitytab");
        public By activityCheckElement = By.XPath("//*[@id=\"Activitytab\"]/div/h3");
        public By workAprvElmnt = By.XPath("//*[@id=\"getwfapprover\"]/div/h3");
        public By dealCancelButton = By.ClassName("custombutton");
        public By downloadButton = By.Id("btnAdmin");
        public By adminButton = By.Id("btnAdmin");
        public By actualFreqElmnt = By.Name("AccrualFrequency");
        public By accountingTab = By.Id("aAccounting");
        public By clientElement = By.Id("Client");
        public By financingTab = By.Id("aFinancing");
        public By financingFacElmnt = By.Id("FinancingFacilityID");
        public By settlmntTab = By.Id("aSettlement");
        public By closingDateElmnt = By.Name("ClosingDate");
        public By defaultTab = By.Id("aServicing");
        public By effectiveDteElmnt = By.ClassName("wj-form-control");
        public By servicingTab = By.Id("aServicingDropDate");
        public By servicingNameElmnt = By.Id("ServicerNameID");
        public By actualsTab = By.Id("aServicingLog");
        public By interestElement = By.ClassName("wj-form-control");
        public By pikTab = By.Id("aPiksource");
        public By pikSourceElement = By.XPath("//*[@id=\"piksource\"]/div/h3");
        public By couponTab = By.Id("aCoupon");
        public By couponElement = By.XPath("//*[@id=\"feecoupon\"]/div/h3");
        public By noteFundingTab = By.Id("aFunding");
        public By noteFundingElemnt = By.XPath("//*[@id=\"futurefunding\"]/div/div/div[2]/button");
        public By cashflowTab = By.Id("aCashflow");
        public By calculationStatus = By.XPath("//span[contains(@class,'badge badge')]");
        public By calculationStatusCompleted = By.XPath("//span[@class='badge badge-success']");
        public By calcButton = By.Id("btnCalcNote");
        public By calculationFullStatus = By.XPath("//*[@id=\"periodicoutput\"]/div/div/div[1]/table/tbody/tr/td[1]/label/span[1]");
        public By periodicOtpButton = By.Id("btnPeriodicOutput");
        public By exceptionTab = By.Id("aExceptions");
        public By exceptionElement = By.XPath("//*[@id=\"Exceptionstab\"]/div/h3");
        public By noteDocTab = By.Id("aImport");
        public By noteDocTabElmnt = By.XPath("//*[@id=\"docImport\"]/div[1]/h3");
        public By noteActTab = By.Id("aActivity");
        public By noteActElement = By.XPath("//*[@id=\"Activitytab\"]/div/h3");
        public By closingTab = By.Id("aClosing");
        public By accountTab = By.XPath("//*[@id=\"myTab\"]/li[1]/a");
        // public By accountTabElmnt = By.Name("FirstName");
        public By accountTabElmnt = By.XPath("//div[@Class='head fixheaderdiv']"); //For Integration
        public By preferencesTab = By.XPath("//*[@id=\"myTab\"]/li[2]/a");
        public By preferenceTabElmnt = By.Id("DefaultNoteTab");
        public By profileDelegTab = By.XPath("//*[@id=\"myTab\"]/li[3]/a");
        public By btnCreateRole = By.Id("btnCreateRole");
        public By userManagementElmnt = By.XPath("//*[@id=\"userpermission\"]/div/h3");
        public By rolePermissionTab = By.XPath("//*[@id=\"myTab\"]/li[2]/a");
        public By roleElmnt = By.Name("RoleID");
        public By addNewRoleBtn = By.Id("btnCreateRole");
        public By manageAppSettngsTab = By.XPath("//*[@id=\"myTab\"]/li[3]/a");
        public By managaeAppStngElmnt = By.XPath("//*[@id=\"allowbasiclogin\"]/div/h3");
        public By workflowApprovTab = By.XPath("//*[@id=\"myTab\"]/li[4]/a");

        //............................Scenario Page........................................................//
        public By addScenarioBtn = By.ClassName("custombutton");
        public By scenarioName = By.Id("ScenarioName");
        public By scenarioPage = By.XPath("//div[@class='head fixheaderdiv']/h1");  // Scenario Page Titile
        public By defaultScenario = By.LinkText("Default");
        public By defaultScenarioDownload = By.XPath("(//div[@class='wj-cell']//div)[3]");
        public By saveButton = By.XPath("(//button[@class='custombutton'])[3]");
        public By UseServicingData = By.XPath("//select[@name='UseActuals']");
        public By CalcEngineType = By.XPath("//select[@name='CalcEngineType']");

        public By calculationMode = By.Name("CalculationMode");
        public By addIndexScenarioBtn = By.ClassName("custombutton");
        public By indexName = By.Id("IndexesName");
        public By indexDescription = By.Id("Description");
        public By feeFuncDefElmnt = By.XPath("//*[@id=\"feefunction\"]/div/h3");
        public By baseAmntDeterm = By.XPath("//*[@id=\"myTab\"]/li[2]/a");
        public By baseAmntDetermElmnt = By.XPath("//*[@id=\"feeamount\"]/div/h3");
        public By addPortfolioBtn = By.ClassName("custombutton");
        public By portfolioName = By.Id("PortfolioName");
        // public By clearSectionBtn = By.ClassName("custombutton");
        public By clearSectionBtn = By.XPath("(//button[@class='custombutton'])[4]"); //For Integration
        // public By downloadTemplateBtn = By.Id("btnAdmin");
        public By downloadTemplateBtn = By.XPath("//button[@class='custombutton dropdown-toggle']"); //For Integration
        public By transReconPage = By.XPath("/html/body/app-root/div/div[2]/div/div/div[2]/ng-component/form/div/div[1]/h1");
        public By InttransReconPage = By.XPath("//div[@class='head fixheaderdiv']"); // For Integration
        public By transcAuditElmnt = By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/ng-component/div/div[2]/div/div/div[2]/wj-flex-grid/div[1]/div[6]/div/div[1]");
        // public By transcAuditPage = By.XPath("/html/body/app-root/div/div[2]/div/div/div[2]/ng-component/div/div[1]/h1");
        public By transcAuditPage = By.XPath("//div[@class='head']"); // Commonfor Integration
        public By closePeriodBtn = By.Id("btnSavePeriodicClose");
        public By periodicEndDate = By.ClassName("wj-form-control");


        //...................................Calculation Manager.......................................................//

        public By calculationManagerElmnt = By.XPath("//*[@id=\"calculationManager\"]/div/h3");
        public By CalcButton = By.XPath("(//button[@class='custombutton'])[2]");
        public By CalcCheckBox = By.XPath("//input[@class='wj-cell-check']");

        public By notesWthExcepTab = By.XPath("//*[@id=\"myTab\"]/li[2]/a");
        public By notesWthExcepElmnt = By.XPath("//*[@id=\"exceptions\"]/div/h3");
        public By batchLogTab = By.XPath("//*[@id=\"myTab\"]/li[3]/a");
        public By totalCommitementTab1 = By.Id("aDealadjustedtotalcommitmenttab");
        public By totalCommitementTab = By.Id("aAdjustedTotalCommitment");
        public By batchLogElmnt = By.XPath("//*[@id=\"batchlog\"]/div/h3");

        public By GenerateAutomationSave = By.XPath("(//button[@class='custombutton'])[2]");        
        public By AutomationLogTab = By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/ng-component/form/div/div[2]/ul/li[2]/a");
        public By AutomationLogText = By.XPath("(//div[@class='box1a']//h3)[2]");

        public By refreshDataWarehouseBtn = By.ClassName("custombutton");
        public By reportName = By.Id("ddlReportName");
        public By addNewTagBtn = By.Id("btnCreateRole");
        //public By workflowElmnt = By.XPath("/html/body/app-root/div/div[2]/div/div/div[2]/workflow/div/div[1]/h1"); //Not working in Integration
        public By workflowElmnt = By.XPath("//div[@class='head']");
        public By addTaskBtn = By.ClassName("custombutton");
        public By addTaskElmnt = By.Id("Priority");
        public By summaryElmnt = By.Id("Summary");
        public By helpBtn = By.ClassName("helpmebutton");
        public By contactUsHeading = By.ClassName("contactusheading");
        public By deleteDealName = By.Id("Name");
        public By deleteNoteTab = By.XPath("//*[@id=\"myTab\"]/li[2]/a");
        public By deleteNoteElmnt = By.Id("txtNoteId");
        public By uploadFileTab = By.XPath("//*[@id=\"myTab\"]/li[3]/a");
        public By dailyExtractBtn = By.XPath("//*[@id=\"upload\"]/div/div/div/ul/li/div[1]/ng2-file-input/div/div[2]/button");
        public By servicerTab = By.XPath("//*[@id=\"myTab\"]/li[4]/a");
        public By serviceName = By.Id("ServicerMasterID");
        public By transactionTypesTab = By.XPath("//*[@id=\"myTab\"]/li[5]/a");
        public By transactionTypeElmnt = By.XPath("//*[@id=\"transactiontypes\"]/div/h3");
        public By notifiSubElmnt = By.XPath("/html/body/app-root/div/div[2]/div/div/div[2]/notificationsubscription/div/div[1]/h1");
        public By IntnotifiSubElmnt = By.XPath("//div[@Class='head fixheaderdiv']"); // For integration
        public By krishnaDropdown = By.ClassName("caret");
        public By logoutBtn = By.XPath("/html/body/div/ng-component/div/div[1]/div/div/div[3]/div/ul/li[3]/ul/li[6]/a/span");
        public By logout = By.XPath("//i[@class='fa fa-sign-out']"); // for logout
        public By loginPage = By.ClassName("main_content");
        public By defaultIndex = By.XPath("//*[@id=\"flexindexes\"]/div[1]/div[2]/div[1]/div[1]/div/div/a");
        public By mLabor = By.XPath("//*[@id=\"flexIndexesDetail\"]/div[1]/div[2]/div[1]/div[14]");
        public By defaultIndexSaveBtn = By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/indexesdetail/form/div/div[1]/span/button[2]");
        //Add user elements
        public By firstName = By.XPath("//*[@id=\"flex\"]/div[1]/div[2]/div[1]/div[121]");
        public By lastName = By.XPath("//*[@id=\"flex\"]/div[1]/div[2]/div[1]/div[122]");
        public By email = By.XPath("//*[@id=\"flex\"]/div[1]/div[2]/div[1]/div[123]");
        public By loginName = By.XPath("//*[@id=\"flex\"]/div[1]/div[2]/div[1]/div[125]");
        public By role = By.XPath("//*[@id=\"flex\"]/div[1]/div[2]/div[1]/div[126]");
        public By dropRole = By.XPath("//*[@id=\"flex\"]/div[1]/div[2]/div[1]/div[126]/div/span");
        public By selectRole = By.XPath("/html/body/div[2]/div[4]");
        public By status = By.XPath("//*[@id=\"flex\"]/div[1]/div[2]/div[1]/div[127]");
        public By dropStatus = By.XPath("//*[@id=\"flex\"]/div[1]/div[2]/div[1]/div[127]/div/span");
        public By statusSelect = By.XPath("/html/body/div[2]/div[1]");
        public By timeZone = By.XPath("//*[@id=\"flex\"]/div[1]/div[2]/div[1]/div[128]");
        public By dropTimeZone = By.XPath("//*[@id=\"flex\"]/div[1]/div[2]/div[1]/div[128]/div/span");
        public By timeZoneSelect = By.XPath("/html/body/div[2]/div[54]");
        public By usersaveBtn = By.ClassName("custombutton");
        public By sucessfullyMsg = By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/userpermission/div/div[1]/div");
        // public By transsRemitt = By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/ng-component/form/div/div[2]/div/div/div/div[1]/div/ul/li[1]/ng2-file-input/div/div[2]/button");
        public By transsRemitt = By.XPath("(//button[@class='custombutton-special'])[1]");
        public By uploadOkBtn = By.XPath("//*[@id=\"myModal\"]/div/div[3]/button[2]");
        // public By uploadSuccessMsg = By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/ng-component/form/div/div[1]/div[2]");
        public By uploadSuccessMsg = By.XPath("//div[@class='alert alert-success fade in']");
        public By noteSaveBtn = By.Id("btnSave");
        public By noteSaveSucessMsg = By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/notedetail/form/div/div[1]/div");
        public By noteAmortTab = By.Id("aAmort");
        public By maturityTab = By.Id("aMaturitytab");
        // public By importManualTrans = By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/ng-component/form/div/div[2]/div/div/div/div[1]/div/ul/li[3]/ng2-file-input/div/div[2]/button");
        public By importManualTrans = By.XPath("(//button[@class='custombutton-special'])[3]");
        // public By importBerkadiaFile = By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/ng-component/form/div/div[2]/div/div/div/div[1]/div/ul/li[4]/ng2-file-input/div/div[2]/button");
        public By importBerkadiaFile = By.XPath("(//button[@class='custombutton-special'])[4]");
        public By loginAlertMsg = By.XPath("/html/body/div/ng-component/div/div/div/div/div/login/div/div[2]/form/div[7]/strong");
        public By indexSuccessMsg = By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/indexes/form/div/div[1]/div");
        public By searchBar = By.ClassName("wj-form-control");
        public By dealSearch = By.XPath("/html/body/div/ng-component/div/div[1]/div[2]/div[1]");
        public By noteSearch = By.XPath("/html/body/div/ng-component/div/div[1]/div[2]/div");
        public By noteID = By.Id("CRENoteID");
        public By addFundingSeqBtn = By.XPath("//*[@id=\"futureFunding\"]/div/div[3]/button[3]");
        public By addRepaySeqBtn = By.XPath("//*[@id=\"futureFunding\"]/div/div[3]/button[2]");
        public By openAllNotesBtn = By.XPath("//*[@id=\"futureFunding\"]/div/div[3]/button[1]");
        public By useRuleY = By.XPath("/html/body/div[2]/div[1]");
        public By useRuleN = By.XPath("/html/body/div[2]/div[2]");
        public By btnRuleOk = By.Id("btnRulevalok");
        public By viewComitDeatilsBtn = By.XPath("//*[@id=\"futureFunding\"]/div/div[1]/div[4]/button");

        public By assetManager = By.Id("AssetManagerID");
        public By amOversight = By.Id("AMTeamLeadUserID");
        public By secondAssetMan = By.Id("AMSecondUserID");
        public By boxDocLink = By.Id("BoxDocumentLink");
        public By underReviewBtn = By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/workflowdetail/form/div[1]/div[1]/span/span[2]/button");
        public By drawFee = By.Name("Amount");
        public By borrowerFirst = By.Name("FirstName");
        public By borrowerLast = By.Name("LastName");
        public By title = By.Name("Designation");
        public By companyName = By.Name("CompanyName");
        public By address = By.Name("Address");
        public By city = By.Name("City");
        public By state = By.Name("StateID");
        public By zip = By.Name("Zip");
        public By email1 = By.Name("Email1");
        public By email2 = By.Name("Email2");
        public By borrowerPhone = By.Name("PhoneNo");
        public By effectiveDate = By.Id("EffectiveDate");
        public By expectedMaturityDate = By.Id("ExpectedMaturityDate");
        public By selectNoteName = By.Id("selectedNoteName");

        public By sendBtn = By.ClassName("custombuttonGreen");

        public By firstAprv = By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/workflowdetail/form/div[1]/div[1]/span/span[3]/button");
        public By finalAprv = By.XPath("/html/body/div/ng-component/div/div[2]/div/div/div[2]/workflowdetail/form/div[1]/div[1]/span/span[3]/button");

        private By txtFixedPeriodicPayment = By.Id("FixedPeriodicPayment");




        public IWebElement btnLogin()
        {
            IWebElement btnLogin = driver.FindElement(By.Id("login"));
            return btnLogin;
        }
        public IWebElement FundingTab()
        {
            IWebElement FundingTab = driver.FindElement(By.Id("aFunding"));
            return FundingTab;
        }

        public IWebElement GenerateFutureFundingButton()
        {
            IWebElement btnGenerateFutureFunding = driver.FindElement(By.Id("btnGenerateFutureFunding"));
            return btnGenerateFutureFunding;
        }

        public IWebElement AutospreadRepaymentButton()
        {
            IWebElement btnAutospreadRepayment = driver.FindElement(By.Id("btnAutospreadRepayment"));
            return btnAutospreadRepayment;
        }

        public void CheckDealPageLoaded()
        {
            util.IsElementVisible(btnSaveDeal);

        }
        public void ClickAmortTab()
        {
            driver.FindElement(tabDealAmorttab).Click();
            util.IsElementVisible(btnSaveDeal);
            util.ImplicitWait(10);
        }

        public string GenerateAmort(string amortisationtype)
        {
            string messgae = "";
            SelectElement oSelect = new SelectElement(driver.FindElement(AmortizationMethod));
            string selectedtext = (oSelect.SelectedOption.Text.ToString()).TrimEnd().TrimStart();

            if ((amortisationtype != selectedtext))
            {
                oSelect.SelectByText(amortisationtype);
                util.WaitForElementVisible(amortok);
                driver.FindElement(amortok).Click();

            }
            util.IsElementVisible(btnGenerateAmortization);

            if (amortisationtype == "Fixed Payment Amortization")
            {
                driver.FindElement(txtFixedPeriodicPayment).SendKeys("500000");
            }
            driver.FindElement(btnGenerateAmortization).Click();
            util.IsElementVisible(btnGenerateAmortization);
            //check if data is generated or not
            if (util.CheckElementVisible(divShowmessagediv))
            {
                messgae = util.GetElementText(divShowmessagediv);

            }
            else if (util.CheckElementVisible(DivNorecord))
            {
                messgae = util.GetElementText(DivNorecord);
            }

            return messgae;
        }

        public void ClickFunding()
        {
            driver.FindElement(tabFunding).Click();
            util.WaitForElementVisible(tabFunding);
        }
        public void clickTotalCommitment()
        {
            util.WaitForElementVisible(totalCommitementTab);
            driver.FindElement(totalCommitementTab).Click();
        }
        public void Username()
        {
            util.IsElementVisible(username);

        }
        public void Password()
        {
            util.IsElementVisible(password);

        }
        public void LoginBtn()
        {
            util.IsElementVisible(loginBtn);

        }

        public void ClickGenerateFunding()
        {
            util.WaitForElementVisible(btnGenerateFunding);
            driver.FindElement(btnGenerateFunding).Click();
        }
        public void ClickCopyDeal()
        {
            util.IsElementVisible(copyDealID);

        }
        public void CopyDealIDElement()
        {
            util.IsElementVisible(copyDealID);

        }
        public void CopyDealNameElement()
        {
            util.IsElementVisible(copyDealName);

        }
        public void CopyAndOpenButton()
        {
            util.IsElementVisible(copyAndOpenBtn);

        }


        public void DealID()
        {
            util.IsElementVisible(dealID);

        }
        public void DealName()
        {
            util.IsElementVisible(dealName);

        }
        public void MainTab()
        {
            util.IsElementVisible(mainTab);

        }
        public void DealFundingTab()
        {
            util.IsElementVisible(fundingTab);

        }
        public void EnableFundingScheduleElement()
        {
            util.IsElementVisible(enableFundingSchedule);

        }

        public void AmortTab()
        {
            util.IsElementVisible(amortTab);

        }
        public void AmortizationMethodElement()
        {
            util.IsElementVisible(amortizationMethodElement);

        }
        public void ReduceAmortizationElement()
        {
            util.IsElementVisible(reduceAmortizationElement);
        }

        public void PayRuleTab()
        {
            util.IsElementVisible(payRuleTab);
        }
        public void PayruleNoteID()
        {
            util.IsElementVisible(payruleNoteID);
        }

        public void TotalCommitementTab()
        {
            util.IsElementVisible(totalCommitementTab);
        }

        public void PayOffTab()
        {
            util.IsElementVisible(payOffTab);
        }

        public void PayOffCheckElement()
        {
            util.IsElementVisible(payOffCheckElement);
        }

        public void Document()
        {
            util.IsElementVisible(documentsTab);
        }



        public void DocumentCheckElement()
        {
            util.IsElementVisible(documentCheckElement);
        }


        public void ActivityTab()
        {
            util.IsElementVisible(activityTab);
        }



        public void ActivityCheckElement()
        {

            util.IsElementVisible(activityCheckElement);
        }




        public void DealCancelButton()
        {
            util.IsElementVisible(dealCancelButton);
        }


        public void DownloadButton()
        {
            util.IsElementVisible(downloadButton);
        }

        public void AdminButton()
        {
            util.IsElementVisible(adminButton);
        }

        public void ActualFreqElement()
        {
            util.IsElementVisible(actualFreqElmnt);
        }


        public void ClientElement()
        {
            util.IsElementVisible(clientElement);
        }







        public void AccountingTab()
        {
            util.IsElementVisible(accountingTab);
        }



        public void FinancingTab()
        {
            util.IsElementVisible(financingTab);
        }

        public void FinancingFacElmnt()
        {
            util.IsElementVisible(financingFacElmnt);
        }


        public void SettlmntTab()
        {
            util.IsElementVisible(settlmntTab);
        }



        public void ClosingDateElmnt()
        {
            util.IsElementVisible(closingDateElmnt);
        }



        public void DefaultTab()
        {
            util.IsElementVisible(defaultTab);
        }



        public void EffectiveDteElmnt()
        {
            util.IsElementVisible(effectiveDteElmnt);
        }


        public void ServicingTab()
        {
            util.IsElementVisible(servicingTab);
        }


        public void ServicingNameElmnt()
        {
            util.IsElementVisible(servicingNameElmnt);
        }


        public void ActualsTab()
        {
            util.IsElementVisible(actualsTab);
        }


        public void InterestElement()
        {
            util.IsElementVisible(interestElement);
        }


        public void PikTab()
        {
            util.IsElementVisible(pikTab);
        }


        public void PikSourceElement()
        {
            util.IsElementVisible(pikSourceElement);
        }


        public void CouponTab()
        {
            util.IsElementVisible(couponTab);
        }

        public void CouponElement()
        {
            util.IsElementVisible(couponElement);
        }

        public void NoteFundingTab()
        {
            util.IsElementVisible(noteFundingTab);
        }


        public void NoteFundingElemnt()
        {
            util.IsElementVisible(noteFundingElemnt);
        }

        public void CashflowTab()
        {
            util.IsElementVisible(cashflowTab);
        }
        public void NoteAmortTab()
        {
            util.IsElementVisible(noteAmortTab);
        }

        public void PeriodicOtpButton()
        {
            util.IsElementVisible(periodicOtpButton);
        }


        public void ExceptionTab()
        {
            util.IsElementVisible(exceptionTab);
        }


        public void ExceptionElement()
        {
            util.IsElementVisible(exceptionElement);
        }


        public void NoteDocTab()
        {
            util.IsElementVisible(noteDocTab);
        }

        public void NoteDocTabElmnt()
        {
            util.IsElementVisible(noteDocTabElmnt);
        }


        public void NoteActTab()
        {
            util.IsElementVisible(noteActTab);
        }

        public void NoteActElement()
        {
            util.IsElementVisible(noteActElement);
        }


        public void ClosingTab()
        {
            util.IsElementVisible(closingTab);
        }


        public void AccountTab()
        {
            util.IsElementVisible(accountTab);
        }

        public void AccountTabElmnt()
        {
            util.IsElementVisible(accountTabElmnt);
        }

        public void PreferencesTab()
        {
            util.IsElementVisible(preferencesTab);
        }

        public void PreferenceTabElmnt()
        {
            util.IsElementVisible(preferenceTabElmnt);
        }


        public void ProfileDelegTab()
        {
            util.IsElementVisible(profileDelegTab);
        }

        public void MyAccountCreateRoleButton()
        {
            util.IsElementVisible(btnCreateRole);
        }

        public void UserManagementElmnt()
        {
            util.IsElementVisible(userManagementElmnt);
        }

        public void RolePermissionTab()
        {
            util.IsElementVisible(rolePermissionTab);
        }

        public void RoleElmnt()
        {
            util.IsElementVisible(roleElmnt);
        }
        public void AddNewRoleBtn()
        {
            util.IsElementVisible(addNewRoleBtn);
        }

        public void ManageAppSettngsTab()
        {
            util.IsElementVisible(manageAppSettngsTab);
        }

        public void ManagaeAppStngElmnt()
        {
            util.IsElementVisible(managaeAppStngElmnt);
        }
        public void WorkflowApprovTab()
        {
            util.IsElementVisible(workflowApprovTab);
        }



        public void AddScenarioBtn()
        {
            util.IsElementVisible(addScenarioBtn);
        }
        public void ScenarioName()
        {
            util.IsElementVisible(scenarioName);
        }

        public string ScenarioPageTitle()
        {
            string Title = util.GetElementText(scenarioPage);
            return Title;
        }

        public void CalculationMode()
        {
            util.IsElementVisible(calculationMode);
        }
        public void WorkAprvElmnt()
        {
            util.IsElementVisible(workAprvElmnt);
        }

        public void AddIndexScenarioBtn()
        {
            util.IsElementVisible(addIndexScenarioBtn);
        }

        public void IndexName()
        {
            util.IsElementVisible(indexName);
        }

        public void IndexDescription()
        {
            util.IsElementVisible(indexDescription);
        }
        public void FeeFuncDefElmnt()
        {
            util.IsElementVisible(feeFuncDefElmnt);
        }

        public void BaseAmntDeterm()
        {
            util.IsElementVisible(baseAmntDeterm);
        }

        public void BaseAmntDetermElmnt()
        {
            util.IsElementVisible(baseAmntDetermElmnt);
        }

        public void AddPortfolioBtn()
        {
            util.IsElementVisible(addPortfolioBtn);
        }

        public void PortfolioName()
        {
            util.IsElementVisible(portfolioName);
        }


        public void ClearSectionBtn()
        {
            util.IsElementVisible(clearSectionBtn);
        }

        public void DownloadTemplateBtn()
        {
            util.IsElementVisible(downloadTemplateBtn);
        }


        public void TransReconPage()
        {
            util.IsElementVisible(transReconPage);
        }

        public void TranscAuditElmnt()
        {
            util.IsElementVisible(transcAuditElmnt);
        }


        public void TranscAuditPage()
        {
            util.IsElementVisible(transcAuditPage);
        }

        public void ClosePeriodBtn()
        {
            util.IsElementVisible(closePeriodBtn);
        }

        public void PeriodicEndDate()
        {
            util.IsElementVisible(periodicEndDate);
        }

        public void CalculationManagerElmnt()
        {
            util.IsElementVisible(calculationManagerElmnt);
        }

        public void NotesWthExcepTab()
        {
            util.IsElementVisible(notesWthExcepTab);
        }

        public void NotesWthExcepElmnt()
        {
            util.IsElementVisible(notesWthExcepElmnt);
        }

        public void BatchLogTab()
        {
            util.IsElementVisible(batchLogTab);
        }

        public void BatchLogElmnt()
        {
            util.IsElementVisible(batchLogElmnt);
        }

        public void RefreshDataWarehouseBtn()
        {
            util.IsElementVisible(refreshDataWarehouseBtn);
        }

        public void ReportName()
        {
            util.IsElementVisible(reportName);
        }

        public void AddNewTagBtn()
        {
            util.IsElementVisible(addNewTagBtn);
        }

        public void WorkflowElmnt()
        {
            util.IsElementVisible(workflowElmnt);
        }

        public void AddTaskBtn()
        {
            util.IsElementVisible(addTaskBtn);
        }
        public void AddTaskElmnt()
        {
            util.IsElementVisible(addTaskElmnt);
        }
        public void SummaryElmnt()
        {
            util.IsElementVisible(summaryElmnt);
        }
        public void HelpBtn()
        {
            util.IsElementVisible(helpBtn);
        }

        public void ContactUsHeading()
        {
            util.IsElementVisible(contactUsHeading);
        }

        public void DeleteDealName()
        {
            util.IsElementVisible(deleteDealName);
        }

        public void DeleteNoteTab()
        {
            util.IsElementVisible(deleteNoteTab);
        }

        public void DeleteNoteElmnt()
        {
            util.IsElementVisible(deleteNoteElmnt);
        }

        public void UploadFileTab()
        {
            util.IsElementVisible(uploadFileTab);
        }

        public void DailyExtractBtn()
        {
            util.IsElementVisible(dailyExtractBtn);
        }

        public void ServicerTab()
        {
            util.IsElementVisible(servicerTab);
        }

        public void ServiceName()
        {
            util.IsElementVisible(serviceName);
        }
        public void TransactionTypesTab()
        {
            util.IsElementVisible(transactionTypesTab);
        }

        public void TransactionTypeElmnt()
        {
            util.IsElementVisible(transactionTypeElmnt);
        }

        public void NotifiSubElmnt()
        {
            util.IsElementVisible(notifiSubElmnt);
        }

        public void KrishnaDropdown()
        {
            util.IsElementVisible(krishnaDropdown);
        }

        public void LogoutBtn()
        {
            util.IsElementVisible(logoutBtn);
        }

        public void LoginPage()
        {
            util.IsElementVisible(loginPage);
        }

        public void DefaultIndex()
        {
            util.IsElementVisible(defaultIndex);
        }

        public void MLabor()
        {
            util.IsElementVisible(mLabor);
        }

        public void DefaultIndexSaveBtn()
        {
            util.IsElementVisible(defaultIndexSaveBtn);
        }




        public void FirstName()
        {
            util.IsElementVisible(firstName);
        }

        public void LastName()
        {
            util.IsElementVisible(lastName);
        }

        public void Email()
        {
            util.IsElementVisible(email);
        }




        public void LoginName()
        {
            util.IsElementVisible(loginName);
        }

        public void Role()
        {
            util.IsElementVisible(role);
        }

        public void SelectRole()
        {
            util.IsElementVisible(selectRole);
        }
        public void Status()
        {
            util.IsElementVisible(status);
        }

        public void StatusSelect()
        {
            util.IsElementVisible(statusSelect);
        }

        public void TimeZone()
        {
            util.IsElementVisible(timeZone);
        }

        public void TimeZoneSelect()
        {
            util.IsElementVisible(timeZoneSelect);
        }


        public void UsersaveBtn()
        {
            util.IsElementVisible(usersaveBtn);
        }

        public void SucessfullyMsg()
        {
            util.IsElementVisible(sucessfullyMsg);
        }

        public void DropRole()
        {
            util.IsElementVisible(dropRole);
        }
        public void DropStatus()
        {
            util.IsElementVisible(dropStatus);
        }
        public void DropTimeZone()
        {
            util.IsElementVisible(dropTimeZone);
        }

        public void TranssRemitt()
        {
            util.IsElementVisible(transsRemitt);
        }

        public void UploadOkBtn()
        {
            util.IsElementVisible(uploadOkBtn);
        }
        public void UploadSuccessMsg()
        {
            util.IsElementVisible(uploadSuccessMsg);
        }

        public void NoteSaveBtn()
        {
            util.IsElementVisible(noteSaveBtn);
        }
        public void NoteSaveSucessMsg()
        {
            util.IsElementVisible(noteSaveSucessMsg);
        }
        public void BtnGenerateFunding()
        {
            util.IsElementVisible(btnGenerateFunding);
        }
        public void ImportBerkadiaFile()
        {
            util.IsElementVisible(importBerkadiaFile);
        }
        public void LoginAlertMsg()
        {
            util.IsElementVisible(loginAlertMsg);
        }
        public void IndexSuccessMsg()
        {
            util.IsElementVisible(indexSuccessMsg);
        }
        public void SearchBar()
        {
            util.IsElementVisible(searchBar);
        }
        public void DealSearch()
        {
            util.IsElementVisible(dealSearch);
        }
        public void NoteSearch()
        {
            util.IsElementVisible(noteSearch);
        }
        public void NoteID()
        {
            util.IsElementVisible(noteID);
        }
        public void AddFundingSeqBtn()
        {
            util.IsElementVisible(addFundingSeqBtn);
        }
        public void AddRepaySeqBtn()
        {
            util.IsElementVisible(addRepaySeqBtn);
        }
        public void OpenAllNotesBtn()
        {
            util.IsElementVisible(openAllNotesBtn);
        }
        public void ViewComitDeatilsBtn()
        {
            util.IsElementVisible(viewComitDeatilsBtn);
        }
        public void UseRuleY()
        {
            util.IsElementVisible(useRuleY);
        }

        public void UnderReviewBtn()
        {
            util.IsElementVisible(underReviewBtn);
        }
        public void SendBtn()
        {
            util.IsElementVisible(sendBtn);
        }

        public void FirstAprv()
        {
            util.IsElementVisible(firstAprv);
        }

        public void FinalAprv()
        {
            util.IsElementVisible(finalAprv);
        }

        public void AssetManager()
        {
            util.IsElementVisible(assetManager);
        }
        public void AmOversight()
        {
            util.IsElementVisible(amOversight);
        }

        public void SecondAssetMan()
        {
            util.IsElementVisible(secondAssetMan);
        }

        public void BoxDocLink()
        {
            util.IsElementVisible(boxDocLink);
        }
        public void DrawFee()
        {
            util.IsElementVisible(drawFee);
        }
        public void BorrowerFirst()
        {
            util.IsElementVisible(borrowerFirst);
        }
        public void Title()
        {
            util.IsElementVisible(title);
        }

        public void CompanyName()
        {
            util.IsElementVisible(companyName);
        }

        public void Address()
        {
            util.IsElementVisible(address);
        }

        public void City()
        {
            util.IsElementVisible(city);
        }

        public void State()
        {
            util.IsElementVisible(state);
        }

        public void Zip()
        {
            util.IsElementVisible(zip);
        }
        public void Email1()
        {
            util.IsElementVisible(email1);
        }

        public void Email2()
        {
            util.IsElementVisible(email2);
        }
        public void BorrowerPhone()
        {
            util.IsElementVisible(borrowerPhone);
        }

        public void UseRuleN()
        {
            util.IsElementVisible(useRuleN);
        }

        public void BtnRuleOk()
        {
            util.IsElementVisible(btnRuleOk);
        }

        public void MaturityTab()
        {
            util.IsElementVisible(maturityTab);
        }

        public void EffectiveDate()
        {
            util.IsElementVisible(effectiveDate);
        }

        public void ExpectedMaturityDate()
        {
            util.IsElementVisible(expectedMaturityDate);
        }

        public void SelectNoteName()
        {
            util.IsElementVisible(selectNoteName);
        }
        public void CalculationStatusWait()
        {
            util.LongWaitForElementVisible(calculationStatusCompleted);

        }
        public bool GenerateAutomationSaveButton()
        {
           return util.IsElementVisible(GenerateAutomationSave);

        }
        public bool AutomationLogTextDisplay()
        {
            return util.IsElementVisible(AutomationLogText);

        }
    }



}