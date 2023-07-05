using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.DataContract.WorkFlow;
using CRES.NoteCalculator;
using CRES.Utilities;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.tool.xml;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading;

namespace CRES.Services.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class DealController : ControllerBase
    {
        Microsoft.Extensions.Configuration.IConfigurationSection Sectionroot = null;
        public void GetConfigSetting()
        {
            if (Sectionroot == null)
            {
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                Sectionroot = root.GetSection("Application");
            }
        }
#pragma warning disable CS0618 // 'IHostingEnvironment' is obsolete: 'This type is obsolete and will be removed in a future version. The recommended alternative is Microsoft.AspNetCore.Hosting.IWebHostEnvironment.'
        private IHostingEnvironment _env;
#pragma warning restore CS0618 // 'IHostingEnvironment' is obsolete: 'This type is obsolete and will be removed in a future version. The recommended alternative is Microsoft.AspNetCore.Hosting.IWebHostEnvironment.'
        //public DealController(IHostingEnvironment env)
        //{

        //    _env = env;
        //}

        private readonly IEmailNotification _iEmailNotification;
#pragma warning disable CS0618 // 'IHostingEnvironment' is obsolete: 'This type is obsolete and will be removed in a future version. The recommended alternative is Microsoft.AspNetCore.Hosting.IWebHostEnvironment.'
        public DealController(IEmailNotification iemailNotification, IHostingEnvironment env)
#pragma warning restore CS0618 // 'IHostingEnvironment' is obsolete: 'This type is obsolete and will be removed in a future version. The recommended alternative is Microsoft.AspNetCore.Hosting.IWebHostEnvironment.'
        {
            _iEmailNotification = iemailNotification;
            _env = env;
        }


        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getalldeals")]
        public IActionResult GetAllDeals(int? pageIndex, int? pageSize)
        {
            GenericResult _authenticationResult = null;
            List<DealDataContract> _lstDeals = new List<DealDataContract>();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            int? totalCount = 0;

            UserPermissionLogic upl = new UserPermissionLogic();
            List<UserPermissionDataContract> permissionlist = upl.GetuserPermissionByUserIDAndPageName(headerUserID.ToString(), "Deallist");

            if (permissionlist.Count > 0)
            {
                _lstDeals = dealLogic.GetAllDealUSP(headerUserID, pageSize, pageIndex, out totalCount);
            }

            try
            {
                if (_lstDeals != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        TotalCount = Convert.ToInt32(totalCount),
                        lstDeals = _lstDeals,
                        UserPermissionList = permissionlist
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in CheckDuplicateCRENote for deal id", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        // [Services.Controllers.DeflateCompression]
        [Route("api/deal/getdealbydealid")]
        //public IActionResult GetDealByDealId([FromBody]UserDataContract DealDC)
        public IActionResult GetDealByDealId([FromBody] DealDataContract DealDC)
        {
            string DealCalcuStatus = "";
            GenericResult _authenticationResult = null;
            DealDataContract _dealDC = new DealDataContract();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            List<IDValueDataContract> ListScheduledPrincipalPaid = new List<IDValueDataContract>();
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            UserPermissionLogic upl = new UserPermissionLogic();
            DealLogic dealLogic = new DealLogic();

            //to get user permission
            List<UserPermissionDataContract> permissionlist = upl.GetuserPermissionByUserIDAndPageName(headerUserID.ToString(), "DealDetail", DealDC.DealID.ToString() == "00000000-0000-0000-0000-000000000000" ? DealDC.CREDealID : DealDC.DealID.ToString(), 283);
            if (permissionlist != null && permissionlist.Count > 0)
            {
                _dealDC = dealLogic.GetDealByDealId(DealDC.DealID.ToString() == "00000000-0000-0000-0000-000000000000" ? DealDC.CREDealID : DealDC.DealID.ToString(), headerUserID);
                ListScheduledPrincipalPaid = dealLogic.GetScheduledPrincipalByDealID(headerUserID, DealDC.DealID.ToString() == "00000000-0000-0000-0000-000000000000" ? DealDC.CREDealID : DealDC.DealID.ToString());
                List<AutoRepaymentBalancesDataContract> autoRepayBalancesDC = new List<AutoRepaymentBalancesDataContract>();
                _dealDC.ListAutoRepaymentBalances = dealLogic.GetAutospreadRepaymentBalancesDealID(_dealDC.DealID);
                if (_dealDC.ListAutoRepaymentBalances != null)
                {
                    if (_dealDC.ListAutoRepaymentBalances.Count > 0)
                    {
                        _dealDC.ListNoteRepaymentBalances = dealLogic.GetNoteAutospreadRepaymentBalancesByDealId(_dealDC.DealID);
                    }
                }

                DealCalcuStatus = dealLogic.GetDealCalculationStatus(DealDC.DealID.ToString());

            }
            try
            {
                if (_dealDC.StatusCode == 200)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        DealDataContract = _dealDC,
                        UserPermissionList = permissionlist,
                        ListScheduledPrincipalPaid = ListScheduledPrincipalPaid,
                        ListPrePaySchedule = _dealDC.PrepaySchedule,
                        StatusCode = 200,
                        DealCalcuStatus = DealCalcuStatus
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Not Exists",
                        StatusCode = 404
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred  in get Deal By DealId deal: Deal ID " + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getallLookup")]
        public IActionResult GetAllLookup()
        {

            string getAllLookup = "1,2,4,5,6,7,8,15,16,38,50,51,21,25,65,77,78,82,83,84,85,86,87,88,89,90,91,92,94,101,103,95,104,106,108,114,118,119,120,121,123,124,125";
            GenericResult _authenticationResult = null;
            List<LookupDataContract> lstlookupDC = new List<LookupDataContract>();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            LookupLogic lookupLogic = new LookupLogic();
            lstlookupDC = lookupLogic.GetAllLookups(getAllLookup);
            lstlookupDC = lstlookupDC.OrderBy(x => x.SortOrder).ToList();
            try
            {
                if (lstlookupDC != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstLookups = lstlookupDC
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in GetAllLookup for deal id", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/SaveDeal")]
        public IActionResult InsertUpdateDeal([FromBody] DealDataContract DealDC)
        {

            LoggerLogic Log = new LoggerLogic();
            GenericResult _authenticationResult = null;
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            var delegateduserid = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            if (!string.IsNullOrEmpty(Request.Headers["DelegatedUser"]))
            {
                delegateduserid = Convert.ToString(Request.Headers["DelegatedUser"]);
            }

            try
            {
                bool collectlogs = Log.GetAllowLoggingValue();

                DealDC.CreatedBy = headerUserID;
                DealDC.UpdatedBy = headerUserID;

                DealLogic dealLogic = new DealLogic();
                PayruleSetupLogic psl = new PayruleSetupLogic();

                CollectCalculatorLogs("0 Deal Saving Starts", DealDC.CREDealID, collectlogs);

                CollectCalculatorLogs("1 InsertUpdateDeal Starts", DealDC.CREDealID, collectlogs);
                string res = dealLogic.InsertUpdateDeal(DealDC);
                CollectCalculatorLogs("2 InsertUpdateDeal Ends", DealDC.CREDealID, collectlogs);
#pragma warning disable CS0219 // The variable 'BackShopStatus' is assigned but its value is never used
                string BackShopStatus = "";
#pragma warning restore CS0219 // The variable 'BackShopStatus' is assigned but its value is never used

                if (res != "FALSE")
                {
                    if (DealDC.PayruleDealFundingList != null)
                    {
                        foreach (PayruleDealFundingDataContract pd in DealDC.PayruleDealFundingList)
                        {
                            pd.CreatedBy = headerUserID;
                            pd.UpdatedBy = headerUserID;
                            if (pd.CreatedDate == null)
                            {
                                pd.CreatedDate = System.DateTime.Now;
                            }
                            else
                            {
                                pd.CreatedDate = pd.CreatedDate;
                            }

                            if (pd.GeneratedBy == 0 || pd.GeneratedBy == null)
                            {
                                //	User Entered
                                pd.GeneratedBy = 746;
                            }

                            pd.UpdatedDate = System.DateTime.Now;
                            pd.DealID = new Guid(res);
                            pd.EquityAmount = pd.EquityAmount.GetValueOrDefault(0);
                            pd.RemainingFFCommitment = pd.RemainingFFCommitment.GetValueOrDefault(0);
                            pd.RemainingEquityCommitment = pd.RemainingEquityCommitment.GetValueOrDefault(0);
                            pd.RequiredEquity = pd.RequiredEquity.GetValueOrDefault(0);
                            pd.AdditionalEquity = pd.AdditionalEquity.GetValueOrDefault(0);
                        }
                        if (DealDC.Flag_DealFundingSave == true)
                        {

                            DealDC.PayruleDealFundingList = DealDC.PayruleDealFundingList.FindAll(y => y.Date != null).ToList();
                            if (DealDC.EnableAutoSpread == true)
                            {
                                foreach (AutoSpreadRuleDataContract asr in DealDC.AutoSpreadRuleList)
                                {
                                    asr.CreatedBy = headerUserID;
                                    asr.UpdatedBy = headerUserID;
                                    asr.CreatedDate = System.DateTime.Now;
                                    asr.UpdatedDate = System.DateTime.Now;
                                    asr.DealID = DealDC.DealID;
                                    asr.EquityAmount = asr.EquityAmount.GetValueOrDefault(0);
                                    asr.RequiredEquity = asr.RequiredEquity.GetValueOrDefault(0);
                                    asr.AdditionalEquity = asr.AdditionalEquity.GetValueOrDefault(0);
                                }
                                CollectCalculatorLogs("3 InsertUpdateAutoSpreadRule Starts", DealDC.CREDealID, collectlogs);
                                dealLogic.InsertUpdateAutoSpreadRule(DealDC.AutoSpreadRuleList);
                                CollectCalculatorLogs("4 InsertUpdateAutoSpreadRule Ends", DealDC.CREDealID, collectlogs);

                            }
                            CollectCalculatorLogs("5 InsertUpdateDealFunding Starts", DealDC.CREDealID, collectlogs);
                            dealLogic.InsertUpdateDealFunding(DealDC.PayruleDealFundingList, delegateduserid);
                            CollectCalculatorLogs("6 InsertUpdateDealFunding Ends", DealDC.CREDealID, collectlogs);

                            CollectCalculatorLogs("7 InsertUpdateFundingRepaymentSequence Starts", DealDC.CREDealID, collectlogs);
                            dealLogic.InsertUpdateFundingRepaymentSequence(DealDC.PayruleNoteAMSequenceList, headerUserID);
                            CollectCalculatorLogs("8 InsertUpdateFundingRepaymentSequence Ends", DealDC.CREDealID, collectlogs);

                            NoteLogic nl = new NoteLogic();

                            foreach (PayruleTargetNoteFundingScheduleDataContract pnf in DealDC.PayruleTargetNoteFundingScheduleList)
                            {
                                if (pnf.Value != null)
                                {
                                    if (pnf.Value == 0)
                                    {
                                        pnf.isDeleted = 1;
                                    }
                                }
                                else
                                {
                                    pnf.isDeleted = 1;
                                }

                                if (pnf.GeneratedBy == 0 || pnf.GeneratedBy == null)
                                {
                                    //	User Entered
                                    pnf.GeneratedBy = 746;
                                }

                            }
                            CollectCalculatorLogs("9 InsertNoteFutureFunding Starts", DealDC.CREDealID, collectlogs);
                            nl.InsertNoteFutureFunding(DealDC.PayruleTargetNoteFundingScheduleList, headerUserID);
                            CollectCalculatorLogs("10 InsertNoteFutureFunding Ends", DealDC.CREDealID, collectlogs);

                            if (DealDC.DeletedDealFundingList.Count > 0)
                            {
                                CollectCalculatorLogs("11 InsertUpdateDealArchieveFunding Starts", DealDC.CREDealID, collectlogs);
                                dealLogic.InsertUpdateDealArchieveFunding(DealDC.DeletedDealFundingList, headerUserID);
                                CollectCalculatorLogs("12 InsertUpdateDealArchieveFunding Ends", DealDC.CREDealID, collectlogs);

                                CollectCalculatorLogs("13 DeleteNoteFundingDataForDealFundingID Starts", DealDC.CREDealID, collectlogs);
                                dealLogic.DeleteNoteFundingDataForDealFundingID(DealDC.DealID);
                                CollectCalculatorLogs("14 DeleteNoteFundingDataForDealFundingID Ends", DealDC.CREDealID, collectlogs);
                            }

                            CollectCalculatorLogs("15 CopyDealFundingFromLegalToPhantom Start", DealDC.CREDealID, collectlogs);
                            dealLogic.CopyDealFundingFromLegalToPhantom(DealDC.CREDealID);
                            CollectCalculatorLogs("16 CopyDealFundingFromLegalToPhantom Ends", DealDC.CREDealID, collectlogs);

                            if (DealDC.ShowUseRuleN == false || DealDC.EnableAutospreadRepayments == true)
                            {
                                CollectCalculatorLogs("17 UpdateNoteFundingLinkedPhantomDeal Start", DealDC.CREDealID, collectlogs);
                                UpdateNoteFundingLinkedPhantomDeal(DealDC.CREDealID, headerUserID, DealDC.AnalysisID, DealDC.ShowUseRuleN, DealDC);
                                CollectCalculatorLogs("18 UpdateNoteFundingLinkedPhantomDeal Ends", DealDC.CREDealID, collectlogs);

                            }
                            CollectCalculatorLogs("19 UpdateWireConfirmedForPhantomDeal Start", DealDC.CREDealID, collectlogs);
                            dealLogic.UpdateWireConfirmedForPhantomDeal(DealDC.CREDealID);
                            CollectCalculatorLogs("20 UpdateWireConfirmedForPhantomDeal Ends", DealDC.CREDealID, collectlogs);
                            //export
                            Thread FirstThread = new Thread(() => ExportFutureFundingFromCRES(DealDC.PayruleTargetNoteFundingScheduleList, headerUserID, DealDC));
                            FirstThread.Start();
                        }
                    }
                    //Save deal amortization schedule   
                    if (DealDC.Flag_DealAmortSave == true)
                    {
                        CollectCalculatorLogs("21 AmortizationSchedule Saving starts", DealDC.CREDealID, collectlogs);
                        if (DealDC.amort.AmortizationMethod == 623 || DealDC.amort.AmortizationMethodText == "IO Only")
                        {

                            dealLogic.DeleteDealAmortizationScheduleDealID(DealDC.DealID);
                        }
                        else
                        {
                            dealLogic.InsertUpdateAmortSequence(DealDC.amort.AmortSequenceList, headerUserID);
                            if (DealDC.amort.DealAmortScheduleList != null)
                            {
                                foreach (DealAmortScheduleDataContract pd in DealDC.amort.DealAmortScheduleList)
                                {
                                    pd.CreatedBy = headerUserID;
                                    pd.DealID = DealDC.DealID;
                                }
                                dealLogic.SaveDealAmortization(DealDC.amort.DealAmortScheduleList, DealDC.amort.AmortizationMethod);
                                dealLogic.SaveNoteAmortization(DealDC.amort.NoteAmortScheduleList, headerUserID);
                            }
                        }

                        CollectCalculatorLogs("22 AmortizationSchedule saving Ends", DealDC.CREDealID, collectlogs);
                    }

                    if (DealDC.IsPayruleClicked == "true" && DealDC.PayruleSetupList != null)
                    {
                        CollectCalculatorLogs("23 InsertIntoPayruleSetup Starts", DealDC.CREDealID, collectlogs);
                        psl.InsertIntoPayruleSetup(DealDC.PayruleSetupList, headerUserID, DealDC.DealID.ToString());
                        CollectCalculatorLogs("24 InsertIntoPayruleSetup Ends", DealDC.CREDealID, collectlogs);
                    }
                    //Delete Total Commitment
                    if (DealDC.DeleteAdjustedTotalCommitment != null)
                    {
                        if (DealDC.DeleteAdjustedTotalCommitment.Count != 0)
                        {
                            CollectCalculatorLogs("25 DeleteAdjustedTotalCommitment Start", DealDC.CREDealID, collectlogs);
                            dealLogic.DeletedAdjustedTotalCommitment(DealDC.DealID, DealDC.DeleteAdjustedTotalCommitment);
                            CollectCalculatorLogs("26 DeleteAdjustedTotalCommitment Ends", DealDC.CREDealID, collectlogs);
                        }
                    }
                    //Delete Total Commitment
                    if (DealDC.Listadjustedtotlacommitment != null)
                    {
                        if (DealDC.Listadjustedtotlacommitment.Count != 0)
                        {
                            CollectCalculatorLogs("27 InsertUpdateAdjustedTotalCommitment Starts", DealDC.CREDealID, collectlogs);
                            dealLogic.InsertUpdateAdjustedTotalCommitment(DealDC.Listadjustedtotlacommitment, new Guid(headerUserID));
                            CollectCalculatorLogs("28 InsertUpdateAdjustedTotalCommitment Ends", DealDC.CREDealID, collectlogs);
                        }
                    }
                    if (DealDC.ListProjectedPayoff != null)
                    {
                        if (DealDC.ListProjectedPayoff.Count != 0)
                        {
                            CollectCalculatorLogs("29 SaveProjectedPayOffDateByDealID Starts", DealDC.CREDealID, collectlogs);
                            dealLogic.SaveProjectedPayOffDateByDealID(DealDC.ListProjectedPayoff, new Guid(headerUserID));
                            CollectCalculatorLogs("30 SaveProjectedPayOffDateByDealID Ends", DealDC.CREDealID, collectlogs);
                        }
                    }

                    if (DealDC.ListFeeInvoice != null)
                    {
                        if (DealDC.ListFeeInvoice.Rows.Count > 0)
                        {
                            WFLogic _wfLogic = new WFLogic();
                            CollectCalculatorLogs("31 SaveFeeInvoices Starts", DealDC.CREDealID, collectlogs);
                            _wfLogic.SaveFeeInvoices(DealDC.ListFeeInvoice, headerUserID.ToString());
                            CollectCalculatorLogs("32 SaveFeeInvoices Ends", DealDC.CREDealID, collectlogs);
                        }
                    }

                    //For ReserveAccount
                    if (DealDC.ReserveAccountList != null)
                    {
                        if (DealDC.ReserveAccountList.Rows.Count > 0)
                        {
                            CollectCalculatorLogs("33 InsertUpdateReserveAccount Starts", DealDC.CREDealID, collectlogs);
                            dealLogic.InsertUpdateReserveAccount(DealDC.ReserveAccountList, headerUserID.ToString());
                            CollectCalculatorLogs("34 InsertUpdateReserveAccount Ends", DealDC.CREDealID, collectlogs);
                        }
                    }

                    //For ReserveAccount
                    if (DealDC.ReserveScheduleList != null)
                    {
                        if (DealDC.ReserveScheduleList.Rows.Count > 0)
                        {
                            CollectCalculatorLogs("35 InsertUpdateReserveSchedule Starts", DealDC.CREDealID, collectlogs);
                            dealLogic.InsertUpdateReserveSchedule(DealDC.ReserveScheduleList, headerUserID.ToString());
                            CollectCalculatorLogs("36 InsertUpdateReserveSchedule Ends", DealDC.CREDealID, collectlogs);
                        }
                    }
                    if (DealDC.RepayExpectedMaturityDate != null)
                    {
                        CollectCalculatorLogs("37 UpdatExpectedMaturityDateByDealID Starts", DealDC.CREDealID, collectlogs);
                        dealLogic.UpdatExpectedMaturityDateByDealID(DealDC.DealID, DealDC.RepayExpectedMaturityDate, new Guid(headerUserID));
                        CollectCalculatorLogs("38 UpdatExpectedMaturityDateByDealID Ends", DealDC.CREDealID, collectlogs);
                    }

                    CollectCalculatorLogs("39 CallDealForCalculation Starts", DealDC.CREDealID, collectlogs);
                    dealLogic.CallDealForCalculation(DealDC.DealID.ToString(), headerUserID, DealDC.AnalysisID, 775);
                    CollectCalculatorLogs("40 CallDealForCalculation Ends", DealDC.CREDealID, collectlogs);
                    Thread CalculateDealThread = new Thread(() => CalculateDeal(DealDC, headerUserID));
                    CalculateDealThread.Start();
                }

                // to call for AIEntityApi
                AIDynamicEntityUpdateLogic _dynamicentity = new AIDynamicEntityUpdateLogic();
                Thread SecondThread = new Thread(() => _dynamicentity.InsertUpdateAIDealEntitiesAsync(DealDC, headerUserID));
                SecondThread.Start();

                CollectCalculatorLogs("41 Deal saved successfully", DealDC.CREDealID, collectlogs);

                string message = "Changes were saved successfully.";
                if (headerUserID != null)
                {
                    _authenticationResult = NewMethod(res, message);
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Changes were not saved successfully."
                    };
                }
            }
            catch (Exception ex)
            {

                //  EmailNotification emailnotify = new EmailNotification();
                string msg = Logger.GetExceptionString(ex);
                msg = msg.Replace("'", "''");

                var newmsg = ExceptionHelper.GetFullMessage(ex);
                Thread FirstThread = new Thread(() => _iEmailNotification.SendEmailDealFailedToSave(DealDC, msg, newmsg));
                FirstThread.Start();


                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred  while saving deal: Deal ID " + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        public void CollectCalculatorLogs(string message, string credealid, Boolean? collectlog)
        {
            if (collectlog == true)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogInfo(CRESEnums.Module.DealSave.ToString(), message + credealid, credealid, "B0E6697B-3534-4C09-BE0A-04473401AB93");
            }
        }


        private void CalculateDeal(DealDataContract DealDC, string userid)
        {
            GetConfigSetting();
            DealLogic dealLogic = new DealLogic();
            //var headerUserID = string.Empty;
            //if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            //{
            //    headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            //}
            //AppConfigLogic appl = new AppConfigLogic();
            ////to get user 
            //List<AppConfigDataContract> SettingKeyslist;
            //var Enablem61Calculation = string.Empty;
            //if (headerUserID == "")
            //    SettingKeyslist = appl.GetAppConfigByKey(null, "EnableM61Calculator");
            //else
            //    SettingKeyslist = appl.GetAppConfigByKey(new Guid(headerUserID), "EnableM61Calculator");

            //if (SettingKeyslist != null)
            //{
            //    var Value = SettingKeyslist.FirstOrDefault().Value;
            //    if (Value == "1")
            //    {
            //        Enablem61Calculation = "true";
            //    }
            //    else
            //    {
            //        Enablem61Calculation = "false";
            //    }
            //}

            // var Enablem61Calculation = Sectionroot.GetSection("Enablem61Calculation").Value;
            if (DealDC.EnableM61Calculator == true)
            {
                V1CalcLogic v1logic = new V1CalcLogic();
                if (DealDC.BalanceAware == true)
                {
                    v1logic.SubmitCalcRequest(DealDC.DealID.ToString(), 283, DealDC.AnalysisID, 775, false);
                }
                else
                {
                    var notelist = dealLogic.GetParnetNotesInaDealForCalculation(DealDC.DealID.ToString());
                    foreach (var item in notelist)
                    {
                        v1logic.SubmitCalcRequest(item.objectID, 182, DealDC.AnalysisID, 775, false);
                    }
                }



            }
        }
        private static GenericResult NewMethod(string res, string message)
        {
            GenericResult _authenticationResult;
            if (res != "FALSE")
            {
                _authenticationResult = new GenericResult()
                {
                    newDeailID = res,
                    Succeeded = true,
                    Message = message
                };
            }
            else
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Some Error Occured."
                };
            }

            return _authenticationResult;
        }

        public void ExportFutureFundingFromCRES(List<PayruleTargetNoteFundingScheduleDataContract> PayruleTargetNoteFundingScheduleDataContract, string headerUserID, DealDataContract DealDC)
        {
            string exceptionMessage = "success";
            string BackShopStatus = "";
            try
            {
                NoteLogic nl = new NoteLogic();


                exceptionMessage = nl.ExportFutureFundingFromCRES(PayruleTargetNoteFundingScheduleDataContract, headerUserID);
                if (exceptionMessage.ToLower() != "success")
                {
                    LoggerLogic Log = new LoggerLogic();
                    Log.WriteLogExceptionMessage(CRESEnums.Module.ExportFutureFunding.ToString(), exceptionMessage, DealDC.DealID.ToString(), "", "ExportFutureFundingFromCRES", "Error occurred  while export FF backshop : Deal ID");

                    if (exceptionMessage.ToLower().Contains("login failed"))
                    {
                        BackShopStatus = "loginfailed";
                    }
                    else
                    {
                        BackShopStatus = "backshopfailed";
                    }

                    if (BackShopStatus.ToLower().Contains("failed"))
                    {
                        // EmailNotification emailnotify = new EmailNotification();
                        _iEmailNotification.SendEmailExportFFBackShopFail(DealDC, BackShopStatus, exceptionMessage);
                    }
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();

                exceptionMessage = ex.StackTrace.ToString();
                if (exceptionMessage.ToLower().Contains("login failed"))
                {
                    BackShopStatus = "loginfailed";
                }
                else
                {
                    BackShopStatus = "backshopfailed";
                }

                if (BackShopStatus.ToLower().Contains("failed"))
                {
                    // EmailNotification emailnotify = new EmailNotification();
                    _iEmailNotification.SendEmailExportFFBackShopFail(DealDC, BackShopStatus, exceptionMessage);
                }

                Log.WriteLogException(CRESEnums.Module.ExportFutureFunding.ToString(), "Error occurred  while export FF backshop : Deal ID " + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

            }
        }

        //[HttpPost]
        //[Services.Controllers.IsAuthenticate]
        //[Services.Controllers.DeflateCompression]
        //[Route("api/deal/SaveDealArchieve")]
        //public IActionResult InsertUpdateDealArchieve([FromBody] DealDataContract DealDC)
        //{
        //    GenericResult _authenticationResult = null;
        //    IEnumerable<string> headerValues;
        //    var headerUserID = string.Empty;

        //    if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
        //    {
        //        headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
        //    }

        //    DealDC.CreatedBy = headerUserID;
        //    DealDC.UpdatedBy = headerUserID;
        //    DealLogic dealLogic = new DealLogic();
        //    //string res = dealLogic.InsertUpdateDeal(DealDC);
        //    string res = null;
        //    dealLogic.InsertUpdateDealArchieveFunding(DealDC.PayruleDealFundingList, headerUserID);
        //    if (DealDC.PayruleDealFundingList.Count > 0)
        //    {
        //        dealLogic.DeleteNoteFundingDataForDealFundingID(DealDC.DealID);
        //    }
        //    try
        //    {
        //        if (headerUserID != null)
        //        {
        //            if (res != "FALSE")
        //            {

        //                _authenticationResult = new GenericResult()
        //                {
        //                    newDeailID = res,
        //                    Succeeded = true,
        //                    Message = "Changes were saved successfully."
        //                };
        //            }
        //            else
        //            {
        //                _authenticationResult = new GenericResult()
        //                {
        //                    Succeeded = true,
        //                    Message = "Some Error Occured."
        //                };
        //            }
        //        }
        //        else
        //        {
        //            _authenticationResult = new GenericResult()
        //            {
        //                Succeeded = false,
        //                Message = "Authentication failed"
        //            };
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        _authenticationResult = new GenericResult()
        //        {
        //            Succeeded = false,
        //            Message = ex.Message
        //        };
        //    }
        //    return Ok(_authenticationResult);
        //}

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetNoteDealFundingByDealID")]
        public IActionResult GetNoteDealFundingByDealIDAPI([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            DataTable dt = new DataTable();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            dt = dealLogic.GetNoteDealFundingScheduleByDealID(new Guid(DealDC.DealID.ToString()), headerUserID, DealDC.ShowUseRuleN);

            ////assign row no after sorting
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    dt.DefaultView.Sort = "Date asc";
                }
            }
            dt = dt.DefaultView.ToTable();
            int i = 1;
            foreach (DataRow row in dt.Rows)
            {
                //Console.WriteLine(row["ImagePath"]);
                row["DealFundingRowno"] = i++;
                //i++;
            }

            WFLogic wflogic = new WFLogic();
            List<WFStatusPurposeMappingDataContract> lstWFStatusPurposeMap = new List<WFStatusPurposeMappingDataContract>();
            lstWFStatusPurposeMap = wflogic.GetWFStatusPurposeMapping(new Guid(headerUserID));
            try
            {
                if (dt != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstNoteDealFunding = dt,
                        lstWFStatusPurposeMapping = lstWFStatusPurposeMap
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred for deal id" + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetWFNoteFunding")]
        public IActionResult GetWFNoteFunding([FromBody] PayruleDealFundingDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            DataTable dt = new DataTable();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }


            DealLogic dealLogic = new DealLogic();
            dt = dealLogic.GetWFNoteFunding(DealDC.DealFundingID, headerUserID);
            //dt.Columns.Remove("DealID");
            //dt.Columns.Remove("Date");
            //dt.Columns.Remove("b_PurposeID");
            //dt.Columns.Remove("b_DealFundingRowno");
            try
            {
                if (dt != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstNoteDealFunding = dt
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred in GetWFNoteFunding for deal id" + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetNoteAllocationPercentage")]
        public IActionResult GetNoteAllocationPercentage([FromBody] PayruleDealFundingDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            DataSet ds = new DataSet();
            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DealLogic dealLogic = new DealLogic();
            ds = dealLogic.GetNoteAllocationPercentage(DealDC.DealFundingID, headerUserID);
            try
            {
                if (ds != null && ds.Tables.Count > 0)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstNoteAllocationPercentage = ds.Tables[0] != null ? ds.Tables[0] : null,
                        lstNoteAllocationAmount = ds.Tables[1] != null ? ds.Tables[1] : null
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }
        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetDealFundingByDealID")]
        public IActionResult GetDealFundingByDealID([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            List<PayruleDealFundingDataContract> dealfunding = new List<PayruleDealFundingDataContract>();
            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            dealfunding = dealLogic.GetDealFundingScheduleByDealID(new Guid(DealDC.DealID.ToString()));

            if (dealfunding.Count == 0)
            {
                PayruleDealFundingDataContract pddc = new PayruleDealFundingDataContract();
                pddc.Value = 0;
                dealfunding.Add(pddc);
            }

            try
            {
                if (dealfunding != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        DealFunding = dealfunding
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetNoteSequenceByDealID")]
        public IActionResult GetNoteScheduleByDealID([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            List<PayruleNoteAMSequenceDataContract> notesequence = new List<PayruleNoteAMSequenceDataContract>();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            notesequence = dealLogic.GetFundingRepaymentSequenceByDealID(new Guid(DealDC.DealID.ToString()));

            try
            {
                if (notesequence != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstSequences = notesequence
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetNoteSequenceHistoryByDealID")]
        public IActionResult GetNoteScheduleHistoryByDealID([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            DataTable dt = new DataTable();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DealLogic dealLogic = new DealLogic();
            dt = dealLogic.GetFundingRepaymentSequenceHistoryByDealID(new Guid(DealDC.DealID.ToString()));
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    //update funding sequence and repayment sequence Null value with 0
                    foreach (DataColumn col in dt.Columns)
                    {
                        // Console.WriteLine(row[col]);

                        if (col.ToString().Trim().ToLower().Contains("funding sequence") || col.ToString().Trim().ToLower().Contains("repayment sequence"))
                        {
                            if (row[col] is System.DBNull)
                            {
                                row[col] = 0;
                            }
                        }
                    }
                }
            }

            try
            {
                if (dt != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstFundingRepaymentSequenceHistory = dt
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred in GetNoteScheduleHistoryByDealID for deal id" + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetNoteFundingByDealID")]
        public IActionResult GetNoteFundingbyDealID([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            List<PayruleTargetNoteFundingScheduleDataContract> notefunding = new List<PayruleTargetNoteFundingScheduleDataContract>();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DealLogic dealLogic = new DealLogic();
            notefunding = dealLogic.GetNoteFundingbyDealID(new Guid(DealDC.DealID.ToString()));
            try
            {
                if (notefunding != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstnoteFundingschedule = notefunding
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred in GetNoteFundingbyDealID for deal id" + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GenerateFutureFunding")]
        public IActionResult GenerateFutureFunding([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            DealDataContract Deal = new DealDataContract();
            LoggerLogic Log = new LoggerLogic();
            Decimal endingbalance = 0;
            var headerUserID = string.Empty;
            DateTime maxDate = DateTime.MinValue;
            DateTime minDate = DateTime.MinValue;
            DateTime minRepayDate = DateTime.MinValue;
            DateTime maxWiredDatecalculated = DateTime.MinValue;


            GetConfigSetting();
            var ApplicationName = Sectionroot.GetSection("ApplicationName").Value;
            string jsonfilename = "FF_" + DealDC.CREDealID + "_" + ApplicationName.Replace("CRES-", "") + "_" + DateTime.Now.ToString("MM_dd_yyyy_HH_mm_ss") + ".json";

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            if (DealDC.ListNoteRepaymentBalances == null)
            {
                DealDC.ListNoteRepaymentBalances = new List<AutoRepaymentNoteBalancesDataContract>();

            }
            PayruleNoteFutureFundingHelper pm = new PayruleNoteFutureFundingHelper();
            DealLogic dealLogic = new DealLogic();
            // code required only autospread repayment 
            if (DealDC.EnableAutospreadRepayments == true || DealDC.EnableAutospreadUseRuleN == true)
            {
                // get ending balance from database           
                foreach (var funding in DealDC.PayruleDealFundingList)
                {
                    if (funding.Applied == true)
                    {
                        if (maxWiredDatecalculated == DateTime.MinValue)
                        {
                            maxWiredDatecalculated = funding.Date.Value.Date;
                        }
                        else if (funding.Date.Value.Date > maxWiredDatecalculated)
                        {
                            maxWiredDatecalculated = funding.Date.Value.Date;
                        }
                        if (funding.Value < 0)
                        {
                            if (minRepayDate == DateTime.MinValue)
                            {
                                minRepayDate = funding.Date.Value.Date;
                            }
                            else if (funding.Date.Value.Date < minRepayDate)
                            {
                                minRepayDate = funding.Date.Value.Date;
                            }
                        }
                    }
                    else
                    {
                        if (funding.Value > 0)
                        {
                            if (minDate == DateTime.MinValue)
                            {
                                minDate = funding.Date.Value.Date;
                            }
                            else if (funding.Date.Value.Date < minDate)
                            {
                                minDate = funding.Date.Value.Date;
                            }
                        }

                    }
                }
                if (DealDC.LastWireConfirmDate_db != null)
                {
                    maxDate = DealDC.LastWireConfirmDate_db.Value.Date;
                }
                DealDC.maxWiredDatecalculated = maxWiredDatecalculated;

                if (maxDate == DateTime.MinValue)
                {
                    if (minDate != DateTime.MinValue)
                    {
                        if (minDate > DateTime.Now.Date)
                        {
                            maxDate = DateTime.Now.Date;
                        }
                        else
                        {
                            maxDate = minDate.Date.AddDays(-1);
                        }

                    }
                    else if (minRepayDate != DateTime.MinValue)
                    {
                        maxDate = minRepayDate.Date.AddDays(-1);
                    }
                    else
                    {
                        maxDate = DateTime.Now.Date;
                    }

                }
                if (maxDate != DateTime.MinValue)
                {
                    DealDC.MaxWireConfirmRecord = maxDate;
                    maxDate = maxDate.AddDays(-1);
                    if (DealDC.EnableAutospreadRepayments == true)
                    {
                        endingbalance = dealLogic.GetEndingBalanceByDate(DealDC.DealID, maxDate);
                    }

                    if (DealDC.EnableAutospreadUseRuleN == true || DealDC.ApplyNoteLevelPaydowns == true)
                    {
                        DealDC.ListNoteEndingBalance = dealLogic.GetNoteEndingBalaceByDate(DealDC.DealID, maxDate);

                    }
                    if (endingbalance == 0)
                    {
                        Log.WriteLogInfo(CRESEnums.Module.Deal.ToString(), "Auto Repayment starting Balances is 0 ", DealDC.DealID.ToString(), headerUserID.ToString());
                    }
                    else
                    {
                        DealDC.Endingbalance = endingbalance;
                    }

                }
                else
                {
                    DealDC.MaxWireConfirmRecord = Convert.ToDateTime(DealDC.EstClosingDate);
                }
            }

            // var json = JsonConvert.SerializeObject(DealDC);
            if (DealDC.AllowFFSaveJsonIntoBlob == true)
            {
                string jsonStr = JsonConvert.SerializeObject(DealDC);
                Thread FirstThread = new Thread(() => UploadDealFundingJson(jsonStr, jsonfilename, DealDC.CREDealID));

                FirstThread.Start();
            }
            //Set order
            var customOrder = DealDC.PayruleNoteDetailFundingList.OrderBy(x => x.Lienposition).ThenBy(x => x.Priority).ThenByDescending(x => x.InitialFundingAmount).ThenBy(x => x.NoteName)
                .Select(y => y.NoteName.Trim().ToLower()).ToArray();

            Deal = pm.StartCalculation(DealDC);


            DealDC.UpdatedBy = headerUserID;
            if (Deal.PayruleGenerationExceptionMessage == "" || Deal.PayruleGenerationExceptionMessage == null)
            {
                foreach (PayruleTargetNoteFundingScheduleDataContract dm in Deal.PayruleTargetNoteFundingScheduleList)
                {
                    PayruleNoteDetailFundingDataContract pma = Deal.PayruleNoteDetailFundingList.Find(x => x.NoteID == dm.NoteID);
                    if (pma != null)
                    {
                        dm.NoteName = pma.NoteName;
                    }
                }
                //For Delete
                Deal.PayruleTargetNoteFundingScheduleList.RemoveAll(x => x.NoteID == null);

                Deal.PayruleTargetNoteFundingScheduleList = Deal.PayruleTargetNoteFundingScheduleList.OrderBy(x => { return Array.IndexOf(customOrder, x.NoteName.Trim().ToLower()); }).ToList();
            }

            try
            {
                if (Deal != null && (Deal.PayruleGenerationExceptionMessage == "" || Deal.PayruleGenerationExceptionMessage == null))
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Funding schedule generated successfully.",
                        DealDataContract = Deal

                    };
                }
                else
                {
                    // EmailNotification emailnotify = new EmailNotification();
                    Exception e = new Exception(Deal.PayruleGenerationExceptionMessage);
                    string msg = Logger.GetExceptionString(e);
                    msg = msg.Replace("'", "''");

                    var newmsg = ExceptionHelper.GetFullMessage(e);
                    Thread FirstThread = new Thread(() => _iEmailNotification.SendEmailDealGenerateFutureFundingFailed(DealDC, msg, newmsg));
                    FirstThread.Start();


                    Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred  while generating future funding for deal id " + DealDC.CREDealID + " json name :" + jsonfilename, DealDC.DealID.ToString(), headerUserID.ToString(), "", "", e);

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Funding schedule generation failed.",
                        PayruleGenerationExceptionMessage = Deal.PayruleGenerationExceptionMessage
                    };
                }
            }
            catch (Exception ex)
            {
                // EmailNotification emailnotify = new EmailNotification();
                string msg = Logger.GetExceptionString(ex);
                msg = msg.Replace("'", "''");

                var newmsg = ExceptionHelper.GetFullMessage(ex);
                Thread FirstThread = new Thread(() => _iEmailNotification.SendEmailDealGenerateFutureFundingFailed(DealDC, msg, newmsg));
                FirstThread.Start();


                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred  while generating future funding for deal id" + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/checkduplicatedeal")]
        public IActionResult CheckDuplicateDeal([FromBody] DealDataContract DealDC)
        {
            string noteids = "";
            GenericResult _authenticationResult = null;
            DealDataContract Deal = new DealDataContract();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            string Status = "";
            string msg = "";
            foreach (var notes in DealDC.notelist)
            {
                if (notes.CRENewNoteID != null)
                {
                    if (notes.CRENewNoteID != "")
                    {
                        noteids = noteids + notes.CRENewNoteID + ",";
                    }
                }
            }
            if (noteids != "")
            {
                noteids = noteids.Remove(noteids.Length - 1);
                noteids = noteids.Replace("\n", "");
                noteids = noteids.Replace("\t", "");
            }
            //[DBO].[usp_CheckDuplicateDeal] '00000000-0000-0000-0000-000000000000',  'NKM15-0006','NewDeal','2230xxxx,2307xxx'      --202  
            //201 : deal duplicate
            //202 : note duplicate
            //203 : note and deal duplicate
            //204 : no duplicate
            DealLogic dealLogic = new DealLogic();
            Status = dealLogic.CheckDuplicateDeal(DealDC.DealID.ToString(), DealDC.CREDealID, DealDC.DealName, noteids);
            if (Status == "201")
            {
                msg = "Deal " + DealDC.DealName + " and deal id " + DealDC.CREDealID + " already exist.Please enter unique Deal Name and Deal Id.";

            }
            else if (Status == "202")
            {
                msg = "Note ID already exits in different deal.Please enter different Note ID";
            }
            else if (Status == "203")
            {
                msg = "Deal and Note id already exits in database.";
            }
            else if (Status == "204")
            {
                msg = "Save";
            }
            try
            {
                if (msg != "")
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = msg
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Error.",
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in CheckDuplicateDeal for deal id" + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/checkduplicateNoteExist")]
        public IActionResult CheckDuplicateCRENote([FromBody] List<NoteDataContract> lstNotes)
        {
            GenericResult _authenticationResult = null;
            NoteDataContract note = new NoteDataContract();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            string isCreNoteexist;
            DealLogic dealLogic = new DealLogic();
            isCreNoteexist = dealLogic.CheckDuplicateCRENote(lstNotes);

            try
            {
                if (isCreNoteexist != "")
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Note " + isCreNoteexist + " already Exist.Please Enter unique Note."

                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in CheckDuplicateCRENote for deal id", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Route("api/deal/checkduplicateCopyNoteExist")]
        public IActionResult CheckDuplicateCopyCRENote([FromBody] List<NoteDataContract> lstNotes)
        {
            GenericResult _authenticationResult = null;
            NoteDataContract note = new NoteDataContract();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            string isCreNoteexist;
            DealLogic dealLogic = new DealLogic();

            isCreNoteexist = dealLogic.CheckDuplicateCopyCRENote(lstNotes);

            try
            {
                if (isCreNoteexist != "")
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Note " + isCreNoteexist + " already Exist.Please Enter unique Note."
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false
                    };
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getpayrulesetupdatabydealid")]
        public IActionResult GetNotePayruleSetupDataByDealID([FromBody] string DealID)
        {
            GenericResult _authenticationResult = null;
            DataTable dt = new DataTable();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            PayruleSetupLogic payruleSetupLogic = new PayruleSetupLogic();
            dt = payruleSetupLogic.GetNotePayruleSetupDataByDealID(new Guid(DealID.ToString()));

            try
            {
                if (dt != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        PayruleSetupData = dt
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred  GetNotePayruleSetupDataByDealID saving deal: Deal ID " + DealID, DealID, headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/copydeal")]
        public IActionResult CopyDeal([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            DealDataContract Deal = new DealDataContract();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;
            var delegateduserid = string.Empty;


            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            if (!string.IsNullOrEmpty(Request.Headers["DelegatedUser"]))
            {
                delegateduserid = Convert.ToString(Request.Headers["DelegatedUser"]);
            }

            bool result = false;
            DealLogic dealLogic = new DealLogic();
            result = dealLogic.CopyDeal(DealDC, headerUserID, delegateduserid);

            // to call AI entity
            AIDynamicEntityUpdateLogic _dynamicentity = new AIDynamicEntityUpdateLogic();
            Thread SecondThread = new Thread(() => _dynamicentity.InsertUpdateAIDealEntitiesAsync(DealDC, headerUserID));
            SecondThread.Start();
            try
            {
                if (result)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Deal copied successfully.",
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Deal copied failed.",
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in CopyDeal for Deal ID: " + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }


        public void UpdateNoteFundingLinkedPhantomDeal(string credealid, string userid, string AnalysisID, bool ShowUseRuleN, DealDataContract legaldeal)
        {
            List<DealDataContract> listDeal = new List<DealDataContract>();
            DealLogic dealLogic = new DealLogic();
            listDeal = dealLogic.GetLinkedPhantomDealID(credealid);
            NoteLogic nl = new NoteLogic();
            PayruleNoteFutureFundingHelper pm = new PayruleNoteFutureFundingHelper();
            Decimal endingbalance = 0;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            var delegateduserid = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["DelegatedUser"]))
            {
                delegateduserid = Convert.ToString(Request.Headers["DelegatedUser"]);
            }
            if (listDeal != null && listDeal.Count > 0)
            {
                LoggerLogic Log = new LoggerLogic();

                foreach (DealDataContract dc in listDeal)
                {
                    DealDataContract deal = new DealDataContract();
                    int? TotalCount;
                    dc.PayruleNoteDetailFundingList = nl.GetNotesForPayruleCalculationByDealID(dc.DealID.ToString(), new Guid(userid), 1, 10, out TotalCount).OrderByDescending(x => x.NoteID).ToList();
                    dc.PayruleNoteAMSequenceList = dealLogic.GetFundingRepaymentSequenceByDealID(new Guid(dc.DealID.ToString())).OrderByDescending(x => x.NoteID).ToList();
                    dc.PayruleDealFundingList = dealLogic.GetDealFundingScheduleByDealID(new Guid(dc.DealID.ToString()));
                    dc.PayruleTargetNoteFundingScheduleList = dealLogic.GetNoteFundingbyDealID(new Guid(dc.DealID.ToString()));
                    //For resolve phtm duplicate record issue
                    //dc.PayruleTargetNoteFundingScheduleList = dc.PayruleTargetNoteFundingScheduleList.FindAll(x => x.Applied == true).ToList();
                    dc.ListHoliday = legaldeal.ListHoliday;
                    //dc.maxMaturityDate = legaldeal.maxMaturityDate;
                    dc.FirstPaymentDate = legaldeal.FirstPaymentDate;
                    // dc.maxMaturityDate = le

                    foreach (PayruleNoteAMSequenceDataContract pdc in dc.PayruleNoteAMSequenceList)
                    {
                        //Funding Sequence

                        if (pdc.SequenceTypeText == "Funding sequence")
                        {
                            pdc.SequenceTypeText = "Funding Sequence";
                        }
                        if (pdc.SequenceTypeText == "Repayment sequence")
                        {
                            pdc.SequenceTypeText = "Repayment Sequence";
                        }
                    }

                    DateTime maxDate = DateTime.MinValue;

                    if (ShowUseRuleN == true)
                    {
                        if (dc.EnableAutospreadRepayments == true)
                        {
                            dc.EnableAutospreadUseRuleN = true;
                        }
                    }
                    else
                    {
                        dc.EnableAutospreadUseRuleN = false;
                    }
                    // code required only autospread repayment 
                    if (dc.EnableAutospreadRepayments == true || dc.EnableAutospreadUseRuleN == true)
                    {

                        DataTable dt = dealLogic.GetProjectedPayOffDBDataByDealID(dc.DealID, headerUserID);
                        List<ProjectedPayoffDataContract> ListProjectedPayoff = new List<ProjectedPayoffDataContract>();
                        foreach (DataRow dr in dt.Rows)
                        {

                            ProjectedPayoffDataContract projectedpayoffdata = new ProjectedPayoffDataContract();
                            projectedpayoffdata.ProjectedPayoffAsofDate = CommonHelper.ToDateTime(dr["ProjectedPayoffAsofDate"]);
                            projectedpayoffdata.CumulativeProbability = CommonHelper.ToDecimal(dr["CumulativeProbability"]);
                            ListProjectedPayoff.Add(projectedpayoffdata);
                        }
                        dc.ListProjectedPayoff = ListProjectedPayoff;

                        dc.ListAutoRepaymentBalances = dealLogic.GetAutospreadRepaymentBalancesDealID(dc.DealID);
                        if (dc.ListAutoRepaymentBalances != null)
                        {
                            if (dc.ListAutoRepaymentBalances.Count > 0)
                            {
                                dc.ListNoteRepaymentBalances = dealLogic.GetNoteAutospreadRepaymentBalancesByDealId(dc.DealID);
                            }
                        }
                        if (dc.ListNoteRepaymentBalances == null)
                        {
                            dc.ListNoteRepaymentBalances = new List<AutoRepaymentNoteBalancesDataContract>();

                        }
                        // get ending balance from database           
                        foreach (var funding in dc.PayruleDealFundingList)
                        {
                            if (funding.Applied == true)
                            {
                                if (funding.Date.Value.Date > maxDate)
                                {
                                    maxDate = funding.Date.Value.Date;
                                }
                            }
                        }

                        if (maxDate == DateTime.MinValue)
                        {
                            maxDate = DateTime.Now.Date;
                        }
                        if (maxDate != DateTime.MinValue)
                        {
                            if (dc.EnableAutospreadRepayments == true)
                            {
                                endingbalance = dealLogic.GetEndingBalanceByDate(dc.DealID, maxDate);
                            }

                            if (dc.EnableAutospreadUseRuleN == true || dc.ApplyNoteLevelPaydowns == true)
                            {
                                dc.ListNoteEndingBalance = dealLogic.GetNoteEndingBalaceByDate(dc.DealID, maxDate);

                            }
                            if (endingbalance == 0)
                            {
                                Log.WriteLogInfo(CRESEnums.Module.Deal.ToString(), "Auto Repayment phantom deal starting Balances is 0 ", dc.DealID.ToString(), headerUserID.ToString());
                            }
                            else
                            {
                                dc.Endingbalance = endingbalance;
                            }
                            dc.MaxWireConfirmRecord = maxDate;
                        }

                        else
                        {
                            dc.MaxWireConfirmRecord = Convert.ToDateTime(dc.EstClosingDate);
                        }
                    }
                    // var json = JsonConvert.SerializeObject(dc);
                    deal = pm.StartCalculation(dc);


                    //update deal funding with proper row number 

                    foreach (PayruleDealFundingDataContract pd in deal.PayruleDealFundingList)
                    {
                        pd.CreatedBy = headerUserID;
                        pd.UpdatedBy = headerUserID;
                        if (pd.CreatedDate == null)
                        {
                            pd.CreatedDate = System.DateTime.Now;
                        }
                        else
                        {
                            pd.CreatedDate = pd.CreatedDate;
                        }
                        pd.UpdatedDate = System.DateTime.Now;
                        pd.DealID = deal.DealID;
                        pd.EquityAmount = pd.EquityAmount.GetValueOrDefault(0);
                        pd.RemainingFFCommitment = pd.RemainingFFCommitment.GetValueOrDefault(0);
                        pd.RemainingEquityCommitment = pd.RemainingEquityCommitment.GetValueOrDefault(0);
                        pd.RequiredEquity = pd.RequiredEquity.GetValueOrDefault(0);
                        pd.AdditionalEquity = pd.AdditionalEquity.GetValueOrDefault(0);
                    }

                    dealLogic.InsertUpdateDealFunding(deal.PayruleDealFundingList, userid);
                    nl.InsertNoteFutureFunding(deal.PayruleTargetNoteFundingScheduleList, userid);

                    if (deal.PayruleDeletedDealFundingList.Count > 0)
                    {
                        dealLogic.InsertUpdateDealArchieveFunding(deal.PayruleDeletedDealFundingList, userid);
                        dealLogic.DeleteNoteFundingDataForDealFundingID(deal.DealID);
                    }
                    //call 
                    dealLogic.CallDealForCalculation(dc.DealID.ToString(), userid, AnalysisID, 775);
                    //Delete FF record if not exists in dealfunding
                    dealLogic.DeleteNoteFundingDataForDealFundingID(dc.DealID);
                }

                //

            }
        }


        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/searchdealbycredealidordealname")]
        public IActionResult SearchDealByCREDealIdOrDealName([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            List<DealDataContract> _lstDeals = new List<DealDataContract>();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            int? totalCount = 0;

            try
            {
                _lstDeals = dealLogic.SearchDealByCREDealIdOrDealName(DealDC);
                if (_lstDeals != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        TotalCount = Convert.ToInt32(totalCount),
                        lstDeals = _lstDeals
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error in searchnig deal: " + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/deletemodulebyid")]
        public IActionResult DeleteModuleByID([FromBody] DeleteModuleDataContract moduleDc)
        {
            GenericResult _authenticationResult = null;
            List<DealDataContract> _lstDeals = new List<DealDataContract>();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();

            bool result = false;

            if (moduleDc.ModuleID != null)
            {

                moduleDc.UserId = headerUserID;
                dealLogic.DeleteModuleByID(moduleDc);
                if (moduleDc.ModuleName.ToLower() == "note")
                {
                    RegenerateNoteFundingByDeaID(moduleDc.DealID.ToString(), headerUserID.ToString());
                }
                result = true;

            }
            else
            {
                result = false;
            }

            // to call for DeleteAIEntityAPI
            AIDynamicEntityUpdateLogic _dynamicentity = new AIDynamicEntityUpdateLogic();
            Thread FirstThread = new Thread(async () => await _dynamicentity.DeleteAIDealEntitiesAsync(moduleDc, headerUserID.ToString()));
            FirstThread.Start();

            try
            {
                if (result)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in DeleteModuleByID for module" + moduleDc.ModuleName, "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        public void RegenerateNoteFundingByDeaID(string DealID, string userid)
        {
            DealLogic dealLogic = new DealLogic();

            NoteLogic nl = new NoteLogic();
            PayruleNoteFutureFundingHelper pm = new PayruleNoteFutureFundingHelper();

            DealDataContract dc = new DealDataContract();
            int? TotalCount;
            dc.PayruleNoteDetailFundingList = nl.GetNotesForPayruleCalculationByDealID(DealID, new Guid(userid), 1, 10, out TotalCount).OrderByDescending(x => x.NoteID).ToList();
            dc.PayruleNoteAMSequenceList = dealLogic.GetFundingRepaymentSequenceByDealID(new Guid(DealID.ToString())).OrderByDescending(x => x.NoteID).ToList();
            dc.PayruleDealFundingList = dealLogic.GetDealFundingScheduleByDealID(new Guid(DealID));

            foreach (PayruleNoteAMSequenceDataContract pdc in dc.PayruleNoteAMSequenceList)
            {
                //Funding Sequence
                if (pdc.SequenceTypeText == "Funding sequence")
                {
                    pdc.SequenceTypeText = "Funding Sequence";
                }
                if (pdc.SequenceTypeText == "Repayment sequence")
                {
                    pdc.SequenceTypeText = "Repayment Sequence";
                }
            }

            DealDataContract result = new DealDataContract();
            result = pm.StartCalculation(dc);
            nl.InsertNoteFutureFunding(result.PayruleTargetNoteFundingScheduleList, userid);
        }


        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/checkconcurrentupdate")]
        public IActionResult CheckConcurrentUpdate([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            DealDataContract Deal = new DealDataContract();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DealLogic dealLogic = new DealLogic();
            DateTime dt = DateTime.ParseExact(DealDC.LastUpdatedFF_String, "MM/dd/yyyy hh:mm:ss tt", CultureInfo.InvariantCulture);
            Deal = dealLogic.CheckConcurrentUpdate(DealDC.DealID, "Deal", dt);

            try
            {
                if (Deal.LastUpdatedFF == null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = ""
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = Deal.LastUpdatedByFF + " has modified the schedule on " + Convert.ToDateTime(Deal.LastUpdatedFF).ToString("M/dd/yyyy h:mm:ss tt") + " please refresh and then save your changes."

                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred in CheckConcurrentUpdate: Deal ID " + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpGet]
        [Route("api/deal/getdealfuncdingpdf")]
        public IActionResult GetDealFuncdingPDF()
        {
            GenericResult _authenticationResult = new GenericResult();
            string htmlContent = string.Empty;
            //using streamreader for reading my htmltemplate   

            using (StreamReader reader = new StreamReader(_env.WebRootPath + "/PDFTemplate/" + "DealFunding.html"))
            {
                htmlContent = reader.ReadToEnd();
            }

            StringBuilder formatTR = new StringBuilder();
            for (int i = 0; i < 10; i++)
            {
                formatTR.Append("<tr>");
                formatTR.Append("<td>");
                formatTR.Append("FundingID-" + i);
                formatTR.Append("</td>");
                formatTR.Append("<td>");
                formatTR.Append("Funding Name -" + i);
                formatTR.Append("</td>");
                formatTR.Append("</tr>");

            }

            if (formatTR.Length > 0)
                htmlContent = htmlContent.Replace("{tabletr}", formatTR.ToString());

            using (MemoryStream stream = new System.IO.MemoryStream())
            {
                StringReader sr = new StringReader(htmlContent);
                Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 100f, 0f);
                PdfWriter writer = PdfWriter.GetInstance(pdfDoc, stream);
                pdfDoc.Open();
                XMLWorkerHelper.GetInstance().ParseXHtml(writer, pdfDoc, sr);
                pdfDoc.Close();

                //File.WriteAllBytes(HostingEnvironment.MapPath("~/PDFTemplate/") + "test.pdf", stream.ToArray());
                EmailSender.SendEmailWithAttachment("sk@test.com", new[] { "shahid@hvantage.com" }, "test subject", "", "John", "DealFundingEmail.html", stream.ToArray(), "test.pdf");
            }
            return Ok(htmlContent);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getfundingdetailbydealid")]
        public IActionResult GetFundingDetailByDealID([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            List<FutureFundingScheduleDetailDataContract> _funding = new List<FutureFundingScheduleDetailDataContract>();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            _funding = dealLogic.GetFundingDetailByDealID(new Guid(DealDC.DealID.ToString()), new Guid(headerUserID));

            try
            {
                if (_funding != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstFundingScheduleDetail = _funding
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred in GetFundingDetailByDealID: Deal ID " + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getfundingdetailbyfundingid")]
        public IActionResult GetFundingDetailByFundingID([FromBody] PayruleDealFundingDataContract DealFundingDC)
        {
            GenericResult _authenticationResult = null;
            List<FutureFundingScheduleDetailDataContract> _funding = new List<FutureFundingScheduleDetailDataContract>();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            _funding = dealLogic.GetFundingDetailByFundingID(new Guid(DealFundingDC.DealFundingID.ToString()), new Guid(headerUserID));


            try
            {
                if (_funding != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstFundingScheduleDetail = _funding
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred in GetFundingDetailByFundingID: Deal ID " + DealFundingDC.DealID, DealFundingDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }


        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetAllDealsForTranscationsFilter")]
        public IActionResult GetAllDealsForTranscationsFilter([FromBody] bool IsReconciled)
        {
            GenericResult _authenticationResult = null;
            DealLogic dealLogic = new DealLogic();
            List<DealDataContract> lstdeals = new List<DealDataContract>();

            lstdeals = dealLogic.GetAllDealsForTranscationsFilter(IsReconciled);

            try
            {
                if (lstdeals != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstDeals = lstdeals
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }



        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetAutoSpreadRuleByDealID")]
        public IActionResult GetAutoSpreadRuleByDealID([FromBody] DealDataContract deal)
        {
            GenericResult _authenticationResult = null;
            List<AutoSpreadRuleDataContract> _autospreadrule = new List<AutoSpreadRuleDataContract>();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used


            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            _autospreadrule = dealLogic.GetAutoSpreadRuleByDealID(new Guid(headerUserID), new Guid(deal.DealID.ToString()));
            try
            {
                if (_autospreadrule != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        _autospreadrule = _autospreadrule
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed",
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in GetAutoSpreadRuleByDealID : Deal ID " + deal.CREDealID, deal.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }


        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/ImportDealByCREDealID")]
        public IActionResult ImportDealByCREDealID([FromBody] DealDataContract deal)
        {
            GenericResult _authenticationResult = null;
            DealDataContract _deal = new DealDataContract();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            int? TotalCount;
            DealLogic dealLogic = new DealLogic();
            var res = dealLogic.ImportDealByCREDealID(deal.CREDealID, deal.envname, deal.CopyDealID, deal.CopyDealName, headerUserID, out TotalCount);
            try
            {

                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Authentication succeeded",
                    TotalCount = Convert.ToInt32(TotalCount)
                };

            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in ImportDealByCREDealID : Deal ID " + deal.CREDealID, deal.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }


        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetNoteDetailForDealAmortByDealID")]
        public IActionResult GetNoteDetailForDealAmortByDealID([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            DataTable dt = new DataTable();
            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            NoteLogic noteLogic = new NoteLogic();
            dt = noteLogic.GetNoteDealAmortByDealID(new Guid(DealDC.DealID.ToString()));

            try
            {
                if (dt.Rows.Count > 0)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        dt = dt
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in GetNoteDetailForDealAmortByDealID : Deal ID " + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }


        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetDealAmortizationByDealIDold")]
        public IActionResult GetDealAmortizationByDealID([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            List<DealAmortScheduleDataContract> _dmlist = new List<DealAmortScheduleDataContract>();
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DealLogic _dealLogic = new DealLogic();
            _dmlist = _dealLogic.GetDealAmortizationByDealID(new Guid(DealDC.DealID.ToString()));

            try
            {
                if (_dmlist.Count > 0)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstDealAmortization = _dmlist
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {

                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in GetDealAmortizationByDealID : Deal ID " + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        //  [System.Web.Http.Route("api/deal/GetAmortScheduleByDealID")]
        [Route("api/deal/GetAmortScheduleByDealID")]
        public IActionResult GetAmortScheduleByDealID([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            List<DealAmortScheduleDataContract> _dmlist = new List<DealAmortScheduleDataContract>();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DealLogic _dealLogic = new DealLogic();
            DealAmortPayRuleHelper pm = new DealAmortPayRuleHelper();
            DataTable dt = new DataTable();
            DataTable StartEndDatedt = new DataTable();
            DataTable amortdt = new DataTable();
            DateTime Amort_StartDate, Amort_EndDate;
#pragma warning disable CS0219 // The variable 'Errormsg' is assigned but its value is never used
            string Errormsg = "";
#pragma warning restore CS0219 // The variable 'Errormsg' is assigned but its value is never used
            StartEndDatedt = pm.GetStartEndDate(DealDC);
            if (StartEndDatedt.Rows.Count > 0)
            {
                Amort_StartDate = Convert.ToDateTime(StartEndDatedt.Rows[0]["StartDate"]);
                Amort_EndDate = Convert.ToDateTime(StartEndDatedt.Rows[0]["EndDate"]);
                dt = _dealLogic.GetAmortScheduleFormStartENDDate(DealDC.DealID.ToString(), DealDC.amort.AmortizationMethod, headerUserID, StartEndDatedt.Rows[0]["FirstStartDate"].ToString(), StartEndDatedt.Rows[0]["LastEndDate"].ToString());

            }
            amortdt = pm.GetAmort(DealDC, dt);
            try
            {
                if (amortdt != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Deal amortization generated successfully.",
                        dt = amortdt
                    };
                }
                else
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "There are no amortization records to show based on current amortization setup ."

                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred  while generating deal amortization : Deal ID " + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };

            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        // [System.Web.Http.Route("api/deal/GenerateDealAmortization")]
        [Route("api/deal/GenerateDealAmortization")]
        public IActionResult GenerateDealAmortization([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;

            DealDataContract Deal = new DealDataContract();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            DateTime Amort_StartDate;
            DateTime? Amort_EndDate;
            string Errormsg = "";
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DealLogic _dealLogic = new DealLogic();
            DealAmortPayRuleHelper pm = new DealAmortPayRuleHelper();
            DataTable dt = new DataTable();
            DataTable StartEndDatedt = new DataTable();
            DataTable amortdt = new DataTable();
            DataTable transamortdt = new DataTable();
            StartEndDatedt = pm.GetStartEndDate(DealDC);
            if (StartEndDatedt.Rows.Count > 0)
            {

                Amort_StartDate = Convert.ToDateTime(StartEndDatedt.Rows[0]["StartDate"]);
                Amort_EndDate = Convert.ToDateTime(StartEndDatedt.Rows[0]["EndDate"]);
                if (Amort_StartDate > Amort_EndDate)
                {
                    Errormsg = "According to current amortization setup Actual payoff Date is smaller than Start Date.";
                }
                else
                {
                    List<NoteAmortFundingDataContract> lstNoteEndingBalance = new List<NoteAmortFundingDataContract>();

                    DealLogic dealLogic = new DealLogic();
                    /*
                    618	-->	Straight Line Amortization
                    619	-->	Fixed Payment Amortization
                    620	-->	Full Amortization by Rate & Term
                    621	-->	Custom Deal Amortization
                    622	-->	Custom Note Amortization
                    623	-->	IO Only
                    */
                    if (DealDC.amort.AmortizationMethod == 618 || DealDC.amort.AmortizationMethod == 619 || DealDC.amort.AmortizationMethod == 621)
                    {
                        lstNoteEndingBalance = dealLogic.GetNoteEndingBalanceByDealID(new Guid(headerUserID), DealDC.DealID, Amort_StartDate, Convert.ToDateTime(Amort_EndDate).AddDays(1));
                    }

                    /*
                    if (DealDC.amort.AmortizationMethodText.ToLower() == "Straight Line Amortization".ToLower())
                    {
                        if (Convert.ToString(DealDC.amort.ReduceAmortizationForCurtailments) != "571") // ReduceAmortizationForCurtailments = N
                        {
                            DealLogic dealLogic = new DealLogic();

                            lstNoteEndingBalance = dealLogic.GetNoteEndingBalanceByDealID(new Guid(headerUserID), DealDC.DealID, Amort_StartDate, Convert.ToDateTime(Amort_EndDate));
                        }
                        else if (Convert.ToString(DealDC.amort.ReduceAmortizationForCurtailments) == "571") // ReduceAmortizationForCurtailments = Y
                        {
                            if (DealDC.amort.PeriodicStraightLineAmortOverride == null || DealDC.amort.PeriodicStraightLineAmortOverride == 0)
                            {
                                DealLogic dealLogic = new DealLogic();
                                lstNoteEndingBalance = dealLogic.GetNoteEndingBalanceByDealID(new Guid(headerUserID), DealDC.DealID, Amort_StartDate.AddDays(-1), null);
                            }
                        }
                    }
                    */


                    if (DealDC.amort.AmortizationMethodText == "Fixed Payment Amortization" || DealDC.amort.AmortizationMethod == 619)
                    {
                        //  StartEndDatedt = pm.GetStartEndDate(DealDC);
                        //if (DealDC.amort.FixedPeriodicPayment > 0)
                        //{
                        //    amortdt = _dealLogic.GetInterestPaidTransactionEntry(new Guid(headerUserID), new Guid(DealDC.DealID.ToString()), DealDC.amort.MutipleNoteIds, Amort_StartDate, Amort_EndDate);
                        //}
                        amortdt = _dealLogic.GetFixedPaymentAmortizationByDealID(DealDC.DealID.ToString(), headerUserID, DealDC.amort.FixedPeriodicPayment, DealDC.amort.MutipleNoteIds, Amort_StartDate.ToString(), Amort_EndDate.ToString());
                        amortdt = pm.CalculationAmort(DealDC, amortdt, lstNoteEndingBalance);
                    }
                    else
                    {
                        amortdt = pm.CalculationAmort(DealDC, DealDC.amort.dt, lstNoteEndingBalance);
                    }


                }

            }
            else
            {
                Errormsg = "No Note is Included.";
            }
            try
            {
                if (Errormsg == "")
                {
                    if (amortdt != null)
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "Amort Schedule generated Successfully.",
                            dt = amortdt
                        };
                    }
                    else
                    {

                        //if (Errormsg == "No Note is Included.")
                        //{
                        //    _authenticationResult = new GenericResult()
                        //    {
                        //        Succeeded = false,
                        //        Message = "No Note is Included for generate amort."
                        //    };
                        //}
                        //else
                        //{
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = false,
                            Message = "There are no amortization records to show based on current amortization setup ."
                        };

                    }
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "According to current amortization setup Actual payoff Date is smaller than Start Date."
                    };
                }

            }
            catch (Exception ex)
            {

                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred  while generating deal amortization : Deal ID " + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Route("api/deal/GetAdjustedtotalCommitmentByDealID")]
        public IActionResult GetAdjustmentTotalCommitmentByDealID([FromBody] string DealID)
        {
            GenericResult _authenticationResult = null;

            DealDataContract Deal = new DealDataContract();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DealLogic _dealLogic = new DealLogic();
            DataTable dt = new DataTable();
            dt = _dealLogic.GetAdjustmentTotalCommitmentByDealID(new Guid(DealID), new Guid(headerUserID));
            try
            {
                if (dt.Rows.Count > 0)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Adjustment Total Commitment fetched successfully.",
                        dt = dt
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Adjustment Total Commitment fetching failed."
                    };
                }
            }
            catch (Exception ex)
            {

                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in Adjustment Total Commitment for deal id : Deal ID " + DealID, DealID, headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }


        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getPayloadData")]
        public IActionResult GetPayloadData([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            PayloadDataContract payload = new PayloadDataContract();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DealLogic dealLogic = new DealLogic();
            payload = dealLogic.GetPayLoad(DealDC.DealID, DealDC.CREDealID, DealDC.DealName);

            try
            {
                if (payload != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        Payload = payload

                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Payload Data Not Exist."

                    };
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }


        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getdealfundingbydealfundingID")]
        public IActionResult GetDealFundingByDealFundingID([FromBody] PayruleDealFundingDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            PayruleDealFundingDataContract _DealFundingDC = new PayruleDealFundingDataContract();

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }


            DealLogic dealLogic = new DealLogic();
            _DealFundingDC = dealLogic.GetDealFundingByDealFundingID(headerUserID, DealDC.DealFundingID);
            //dt.Columns.Remove("DealID");
            //dt.Columns.Remove("Date");
            //dt.Columns.Remove("b_PurposeID");
            //dt.Columns.Remove("b_DealFundingRowno");
            try
            {
                if (_DealFundingDC != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        _dealFunding = _DealFundingDC
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred in GetDealFundingByDealFundingID for DealFundingID " + DealDC.DealFundingID, DealDC.DealFundingID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getprojectedPayOffDateByDealID")]
        public IActionResult GetProjectedPayOffDateByDealID([FromBody] DataTable dtDeal)
        {
            GenericResult _authenticationResult = null;
            List<ProjectedPayoffDataContract> _lstprojectedpayoffdates = new List<ProjectedPayoffDataContract>();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                var DealID = Convert.ToString(dtDeal.Rows[0]["DealID"]);
                int DealStatus = Convert.ToInt32(dtDeal.Rows[0]["DealStatus"]);
                DealLogic dealLogic = new DealLogic();
                _lstprojectedpayoffdates = dealLogic.GetProjectedPayOffDateByDealID(headerUserID.ToString(), new Guid(DealID), DealStatus);

                if (_lstprojectedpayoffdates.Count > 0)
                {
                    if (_lstprojectedpayoffdates[0].Status == "Success")
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "Success",
                            _lstprojectedpayoffdates = _lstprojectedpayoffdates
                        };
                    }
                    else if (_lstprojectedpayoffdates[0].Status == "Error")
                    {
                        LoggerLogic Log = new LoggerLogic();
                        Log.WriteLogExceptionMessage(CRESEnums.Module.Deal.ToString(), _lstprojectedpayoffdates[0].ErrorMsg, "", headerUserID.ToString(), "GetProjectedPayOffDateByDealID", "Error occured in autospread repayment backshop procedure execution for deal id");

                        var newmsg = _lstprojectedpayoffdates[0].ExceptionMsg;
                        Thread FirstThread = new Thread(() => _iEmailNotification.SendEmailBackshopFailed(headerUserID.ToString(), newmsg));
                        FirstThread.Start();

                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "Backshop error.",
                            _lstprojectedpayoffdates = _lstprojectedpayoffdates
                        };
                    }
                    else if (_lstprojectedpayoffdates[0].Status == "No length")
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "No data for the deal in Backshop.",
                            _lstprojectedpayoffdates = _lstprojectedpayoffdates
                        };
                    }
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = "No data for the deal in Backshop.",
                    _lstprojectedpayoffdates = null
                };
                //LoggerLogic Log = new LoggerLogic();
                //Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in autospread repayment backshop procedure execution for deal id", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                //_authenticationResult = new GenericResult()
                //{
                //    Succeeded = false,
                //    Message = "Backshop error.",
                //    _lstprojectedpayoffdates = _lstprojectedpayoffdates
                //};

            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getprojectedPayOffDBDataByDealID")]
        public IActionResult GetProjectedPayOffDBDataByDealID([FromBody] string DealID)
        {
            GenericResult _authenticationResult = null;
            List<ProjectedPayoffDataContract> _lstprojectedpayoffdates = new List<ProjectedPayoffDataContract>();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            DataTable dt = dealLogic.GetProjectedPayOffDBDataByDealID(new Guid(DealID), headerUserID.ToString());
            try
            {
                if (dt.Rows.Count > 0)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Succeeded",
                        dt = dt
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in autospread GetProjectedPayOffDBDataByDealID for deal id", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = "Failed"
                };
            }
            return Ok(_authenticationResult);
        }


        public void UploadDealFundingJson(string jsonStr, string filename, string CREDealID)
        {
            try
            {
                // GetConfigSetting();
                var isJSONSaved = AzureStorageReadFile.SaveFundingJSONIntoBlob(jsonStr, filename);
                if (isJSONSaved == false)
                {
                    LoggerLogic Log = new LoggerLogic();
                    ///Log.WriteLogExceptionMessage(CRESEnums.Module.Deal.ToString(), exceptionMessage, DealDC.DealID.ToString(), "", "ExportFutureFundingFromCRES", "Error occurred  while export FF backshop : Deal ID");
                    Log.WriteLogExceptionMessage(CRESEnums.Module.Deal.ToString(), "Error occured in Upload DealFunding Json for deal id" + CREDealID, CREDealID.ToString(), "", "Error occured in Upload DealFunding Json for deal id" + CREDealID, CREDealID.ToString());
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in Upload DealFunding Json for deal id" + CREDealID, CREDealID.ToString(), "", ex.TargetSite.Name.ToString(), "", ex);
            }

        }


        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getmaturitybydealid")]
        public IActionResult GetMaturityByDealID(string ID)
        {
            GenericResult _authenticationResult = null;

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            NoteLogic _noteLogic = new NoteLogic();
            DataTable dtMaturity = dealLogic.GetMaturityByDealID(headerUserID, ID, null);
            DataTable dtEffectiveDates = dealLogic.GetAllEFfectiveDatesByDealID(new Guid(ID), headerUserID);



            try
            {
                if (dtMaturity != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        dt = dtMaturity,
                        dtEffectiveDates = dtEffectiveDates
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred in GetMaturityByDealID: Deal ID " + ID, ID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }


        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getscheduleeffectivedatecountbydealId")]
        public IActionResult GetScheduleEffectiveDateCountByDealId(string ID)
        {
            GenericResult _authenticationResult = null;

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            DataTable dtschedulecount = dealLogic.GetScheduleEffectiveDateCountByDealId(ID);
            try
            {
                if (dtschedulecount != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        dt = dtschedulecount
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred in GetScheduleEffectiveDateCountByDealId: Deal ID " + ID, ID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);

        }

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getallreserveaccountbydealid")]
        public IActionResult GetAllReserveAccountByDealId(string ID)
        {
            GenericResult _authenticationResult = null;

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Request.Headers["TokenUId"];
            }

            DealLogic dealLogic = new DealLogic();

            DataTable dtReserve = dealLogic.GetAllReserveAccountByDealId(headerUserID, ID);

            try
            {
                if (dtReserve != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        dt = dtReserve
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred in GetAllReserveAccountByDealId: Deal ID " + ID, ID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }



        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getreserveschedulebydealid")]
        public IActionResult GetReserveScheduleByDealId(string ID)
        {
            GenericResult _authenticationResult = null;

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Request.Headers["TokenUId"];
            }

            DealLogic dealLogic = new DealLogic();

            DataTable dtResSch = dealLogic.GetReserveScheduleByDealId(headerUserID, ID);

            try
            {
                if (dtResSch != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        dt = dtResSch
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred in GetReserveScheduleByDealId: Deal ID " + ID, ID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getwfpayoffnotefunding")]
        public IActionResult GetWFPayOffNoteFunding([FromBody] PayruleDealFundingDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            DataSet ds = new DataSet();
            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DealLogic dealLogic = new DealLogic();
            ds = dealLogic.GetWFPayOffNoteFunding(DealDC.DealFundingID, headerUserID);
            try
            {
                if (ds != null && ds.Tables.Count > 0)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        dtNoteAdditionalInfo = ds.Tables[0] != null ? ds.Tables[0] : null,
                        dtInvestors = ds.Tables[1] != null ? ds.Tables[1] : null,
                        dtDelphi = ds.Tables[2] != null ? ds.Tables[2] : null,
                        dtNoteFinancingSources = ds.Tables[3] != null ? ds.Tables[3] : null

                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }


        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/addNewPrepaySchedule")]
        public IActionResult AddNewPrepaySchedule([FromBody] PrepayDataContract _PrepayDC)
        {

            GenericResult _authenticationResult = null;

            var headerUserID = string.Empty;
            var delegateduserid = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            _PrepayDC.CreatedBy = headerUserID;
            _PrepayDC.UpdatedBy = headerUserID;
            DealLogic dealLogic = new DealLogic();
            string res = dealLogic.InsertUpdatePrepaySchedule(_PrepayDC, _PrepayDC.PrepayAdjustmentList, _PrepayDC.SpreadMaintenanceScheduleList, _PrepayDC.MinMultScheduleList, _PrepayDC.FeeCreditsList);
            try
            {
                if (res != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getprepaypremiumDetaildatabydeal")]
        public IActionResult GetPrepayPremiumDetailDataByDealId([FromBody] string DealId)
        {
            GenericResult _authenticationResult = null;
            PrepayDataContract lstprepay = new PrepayDataContract();

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            lstprepay = dealLogic.GetPrepayPremiumDetailDataByDealId(DealId, headerUserID);

            try
            {
                if (lstprepay != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstPrepay = lstprepay.PrepayScheduleId,
                        lstDealPrepay = lstprepay.PrepayAdjustment,
                        lstDealSpreadMaintenance = lstprepay.SpreadMaintenanceSchedule,
                        lstDealMiniSpread = lstprepay.MinMultSchedule,
                        lstDealMiniFee = lstprepay.FeeCredits,
                        lstDealSpreadMaintenanceDeallevel = lstprepay.SpreadMaintenanceScheduleDeallevel

                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }


        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getdealprepayallocationbydealid")]
        public IActionResult GetDealPrepayAllocationsByDealId([FromBody] string DealId)
        {
            GenericResult _authenticationResult = null;

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            DealLogic dealLogic = new DealLogic();
            List<PrepayAllocationsDataContract> lstprepayallo = new List<PrepayAllocationsDataContract>();
            lstprepayallo = dealLogic.GetDealPrepayAllocationsByDealId();

            try
            {
                if (lstprepayallo != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",

                        lstPrepayAllocations = lstprepayallo

                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getdealprepayprojectionbydealid")]
        public IActionResult GetDealPrepayProjectionByDealId([FromBody] string DealId)
        {
            GenericResult _authenticationResult = null;

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            DealLogic dealLogic = new DealLogic();
            List<PrepayProjectionDataContract> lstprepay = new List<PrepayProjectionDataContract>();
            lstprepay = dealLogic.GetDealPrepayProjectionByDealId(DealId, headerUserID);

            try
            {
                if (lstprepay.Count > 0)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        Prepaylastupdated = lstprepay.First().prepaylastUpdatedFF,
                        PrepaylastupdatedBy = lstprepay.First().prepaylastUpdatedByFF,
                        lstPrepayProjection = lstprepay

                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }


        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Route("api/deal/calculaterrepay")]
        [Services.Controllers.DeflateCompression]
        public IActionResult CalculatePrePay([FromBody] DealDataContract dealDataContract)
        {
            GetConfigSetting();
            GenericResult _authenticationResult = null;
            var res = "";
            var headerUserID = string.Empty;
            var delegateduserid = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DealLogic dealLogic = new DealLogic();

            dealLogic.CallDealForPrePayCalculation(dealDataContract.DealID.ToString(), headerUserID, "c10f3372-0fc2-4861-a9f5-148f1f80804f", 776);
            //  var Enablem61Calculation = Sectionroot.GetSection("Enablem61Calculation").Value;
            if (dealDataContract.EnableM61Calculator == true)
            {
                V1CalcLogic v1logic = new V1CalcLogic();
                v1logic.SubmitCalcRequest(dealDataContract.DealID.ToString(), 283, "c10f3372-0fc2-4861-a9f5-148f1f80804f", 776, false);
            }
            try
            {
                if (res != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }



        [HttpPost]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetDealCalculationStatus")]
        public IActionResult GetDealCalculationStatus([FromBody] string DealID)
        {
            string DealCalcuStatus = "";
            GenericResult _authenticationResult = null;
            PrepayDataContract lstprepay = new PrepayDataContract();

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            DealCalcuStatus = dealLogic.GetDealCalculationStatus(DealID);
            try
            {

                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Succeeded",
                    DealCalcuStatus = DealCalcuStatus,

                };

            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/AddUpdateDealRuleTypeSetup")]
        public IActionResult AddUpdateDealRuleTypeSetup([FromBody] List<ScenarioruletypeDataContract> scenarioDC)
        {
            GenericResult _authenticationResult = null;
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
#pragma warning disable CS0219 // The variable 'scenariomsg' is assigned but its value is never used
            string scenariomsg = "";
#pragma warning restore CS0219 // The variable 'scenariomsg' is assigned but its value is never used
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            string res = dealLogic.AddUpdateDealRuleTypeSetup(scenarioDC, headerUserID);

            try
            {
                if (res != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);

        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetRuleTypeSetupByDealId")]
        public IActionResult GetRuleTypeSetupByDealId([FromBody] ScenarioruletypeDataContract scenarioruletypeDataContrac)
        {
            GenericResult _authenticationResult = null;
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            List<ScenarioruletypeDataContract> listscenario = new List<ScenarioruletypeDataContract>();
            DealLogic deallogic = new DealLogic();
            listscenario = deallogic.GetRuleTypeSetupByDealId(scenarioruletypeDataContrac.DealID);

            try
            {
                if (listscenario.Count > 0)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        AnalysisId = listscenario.First().AnalysisID,
                        lstScenariorule = listscenario
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded"
                    };
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }

            return Ok(_authenticationResult);
        }

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetAllPropertyType")]
        public IActionResult GetAllPropertyType()
        {
            GenericResult _authenticationResult = null;
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            List<PropertyTypeDataContract> ptlist = new List<PropertyTypeDataContract>();
            DealLogic dealLogic = new DealLogic();

            ptlist = dealLogic.GetAllPropertyType(headerUserID);

            try
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Authentication succeeded",
                    lstPropertytype = ptlist
                };
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }

            return Ok(_authenticationResult);
        }

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetAllLoanStatus")]
        public IActionResult GetAllLoanStatus()
        {
            GenericResult _authenticationResult = null;

            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            List<LoanStatusDataContract> lslist = new List<LoanStatusDataContract>();
            DealLogic dealLogic = new DealLogic();

            lslist = dealLogic.GetAllLoanStatus(headerUserID);

            try
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Authentication succeeded",
                    lstLoanstatus = lslist
                };
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }

            return Ok(_authenticationResult);
        }

        // Calc Committment
        [HttpGet]
        [Route("api/deal/calcCommitment")]
        public IActionResult calcCommitment(string DealId)
        {
            GenericResult _authenticationResult = null;

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);

            }
            headerUserID = new Guid("b0e6697b-3534-4c09-be0a-04473401ab93");

            CommitmentEquityHelper ce = new CommitmentEquityHelper();
            ce.calcNoteCommitment(DealId, headerUserID);
            try
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Authentication succeeded"

                };
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }

            return Ok(_authenticationResult);
        }


        //public static void getcommitmentdata()
        //{
        //    CommitmentEquityHelper ce = new CommitmentEquityHelper();
        //    string json = System.IO.File.ReadAllText(@"C:\temp\10471notedc.json");

        //    NoteDataContract note = JsonConvert.DeserializeObject<NoteDataContract>(json);
        //    ce.calcNoteCommitment(note);
        //}
        [HttpGet]
        [Route("api/deal/generateFundingUsingAPI")]
        public void GenerateFundingUsingAPI(string DealID)
        {

            string AnalysisID = "c10f3372-0fc2-4861-a9f5-148f1f80804f";

            bool ShowUseRuleN = true;
            DealLogic dealLogic = new DealLogic();
            NoteLogic nl = new NoteLogic();
            LoggerLogic Log = new LoggerLogic();
            DealDataContract dc = new DealDataContract();
            DealDataContract deal = new DealDataContract();

            PayruleNoteFutureFundingHelper pm = new PayruleNoteFutureFundingHelper();
            Decimal endingbalance = 0;
            var headerUserID = string.Empty;
            int? TotalCount;

            NoteLogic _NoteLogic = new NoteLogic();
            List<HolidayListDataContract> ListHoliday = _NoteLogic.GetHolidayList();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            if (headerUserID == null || headerUserID == "")
            {
                headerUserID = "00000000-0000-0000-0000-000000000000";
            }

            dc = dealLogic.GetDealByDealId(DealID, new Guid(headerUserID));

            dc.PayruleNoteDetailFundingList = nl.GetNotesForPayruleCalculationByDealID(DealID, new Guid(headerUserID), 1, 10, out TotalCount).OrderByDescending(x => x.NoteID).ToList();
            dc.PayruleNoteAMSequenceList = dealLogic.GetFundingRepaymentSequenceByDealID(new Guid(DealID)).OrderByDescending(x => x.NoteID).ToList();
            dc.PayruleDealFundingList = dealLogic.GetDealFundingScheduleByDealID(new Guid(DealID.ToString()));
            dc.PayruleTargetNoteFundingScheduleList = dealLogic.GetNoteFundingbyDealID(new Guid(DealID.ToString()));

            dc.ListHoliday = ListHoliday;
            dc.FirstPaymentDate = dc.FirstPaymentDate;

            List<NoteUsedInDealDataContract> notelist = nl.GetNotesFromDealDetailByDealID(DealID, new Guid(headerUserID), 1000, 1, out TotalCount);
            dc.maxMaturityDate = notelist.Max(x => x.FullyExtendedMaturityDate);


            if (dc.EnableAutoSpread == true)
            {
                dc.AutoSpreadRuleList = dealLogic.GetAutoSpreadRuleByDealID(new Guid(headerUserID), new Guid(dc.DealID.ToString()));
            }

            foreach (PayruleNoteAMSequenceDataContract pdc in dc.PayruleNoteAMSequenceList)
            {
                //Funding Sequence
                if (pdc.SequenceTypeText == "Funding sequence")
                {
                    pdc.SequenceTypeText = "Funding Sequence";
                }
                if (pdc.SequenceTypeText == "Repayment sequence")
                {
                    pdc.SequenceTypeText = "Repayment Sequence";
                }
            }

            foreach (var pnd in dc.PayruleNoteDetailFundingList)
            {
                if (pnd.UseRuletoDetermineNoteFunding == 3)
                {
                    ShowUseRuleN = false;
                    break;
                }
            }
            DateTime maxDate = DateTime.MinValue;
            if (ShowUseRuleN == true)
            {
                if (dc.EnableAutospreadRepayments == true)
                {
                    dc.EnableAutospreadUseRuleN = true;
                }
            }
            else
            {
                dc.EnableAutospreadUseRuleN = false;
            }
            // code required only autospread repayment 
            if (dc.EnableAutospreadRepayments == true || dc.EnableAutospreadUseRuleN == true)
            {
                DataTable dt = dealLogic.GetProjectedPayOffDBDataByDealID(dc.DealID, headerUserID);
                List<ProjectedPayoffDataContract> ListProjectedPayoff = new List<ProjectedPayoffDataContract>();
                foreach (DataRow dr in dt.Rows)
                {

                    ProjectedPayoffDataContract projectedpayoffdata = new ProjectedPayoffDataContract();
                    projectedpayoffdata.ProjectedPayoffAsofDate = CommonHelper.ToDateTime(dr["ProjectedPayoffAsofDate"]);
                    projectedpayoffdata.CumulativeProbability = CommonHelper.ToDecimal(dr["CumulativeProbability"]);
                    ListProjectedPayoff.Add(projectedpayoffdata);
                }
                dc.ListProjectedPayoff = ListProjectedPayoff;
                dc.ListAutoRepaymentBalances = dealLogic.GetAutospreadRepaymentBalancesDealID(dc.DealID);
                if (dc.ListAutoRepaymentBalances != null)
                {
                    if (dc.ListAutoRepaymentBalances.Count > 0)
                    {
                        dc.ListNoteRepaymentBalances = dealLogic.GetNoteAutospreadRepaymentBalancesByDealId(dc.DealID);
                    }
                }
                if (dc.ListNoteRepaymentBalances == null)
                {
                    dc.ListNoteRepaymentBalances = new List<AutoRepaymentNoteBalancesDataContract>();
                }
                // get ending balance from database           
                foreach (var funding in dc.PayruleDealFundingList)
                {
                    if (funding.Applied == true)
                    {
                        if (funding.Date.Value.Date > maxDate)
                        {
                            maxDate = funding.Date.Value.Date;
                        }
                    }
                }
                if (maxDate == DateTime.MinValue)
                {
                    maxDate = DateTime.Now.Date;
                }
                if (maxDate != DateTime.MinValue)
                {
                    if (dc.EnableAutospreadRepayments == true)
                    {
                        endingbalance = dealLogic.GetEndingBalanceByDate(dc.DealID, maxDate);
                    }

                    if (dc.EnableAutospreadUseRuleN == true || dc.ApplyNoteLevelPaydowns == true)
                    {
                        dc.ListNoteEndingBalance = dealLogic.GetNoteEndingBalaceByDate(dc.DealID, maxDate);

                    }
                    if (endingbalance == 0)
                    {
                        //Log.WriteLogInfo(CRESEnums.Module.Deal.ToString(), "Auto Repayment phantom deal starting Balances is 0 ", dc.DealID.ToString(), headerUserID.ToString());
                    }
                    else
                    {
                        dc.Endingbalance = endingbalance;
                    }
                    dc.MaxWireConfirmRecord = maxDate;
                }

                else
                {
                    dc.MaxWireConfirmRecord = Convert.ToDateTime(dc.EstClosingDate);
                }
            }
            var json = JsonConvert.SerializeObject(dc);
            deal = pm.StartCalculation(dc);
            if (deal.PayruleGenerationExceptionMessage == "")
            {
                //update deal funding with proper row number
                foreach (PayruleDealFundingDataContract pd in deal.PayruleDealFundingList)
                {
                    pd.CreatedBy = headerUserID;
                    pd.UpdatedBy = headerUserID;
                    if (pd.CreatedDate == null)
                    {
                        pd.CreatedDate = System.DateTime.Now;
                    }
                    else
                    {
                        pd.CreatedDate = pd.CreatedDate;
                    }
                    pd.UpdatedDate = System.DateTime.Now;
                    pd.DealID = deal.DealID;
                    pd.EquityAmount = pd.EquityAmount.GetValueOrDefault(0);
                    pd.RemainingFFCommitment = pd.RemainingFFCommitment.GetValueOrDefault(0);
                    pd.RemainingEquityCommitment = pd.RemainingEquityCommitment.GetValueOrDefault(0);
                    pd.RequiredEquity = pd.RequiredEquity.GetValueOrDefault(0);
                    pd.AdditionalEquity = pd.AdditionalEquity.GetValueOrDefault(0);
                }

                dealLogic.InsertUpdateDealFunding(deal.PayruleDealFundingList, headerUserID);
                nl.InsertNoteFutureFunding(deal.PayruleTargetNoteFundingScheduleList, headerUserID);

                if (deal.PayruleDeletedDealFundingList != null)
                {
                    if (deal.PayruleDeletedDealFundingList.Count > 0)
                    {
                        dealLogic.InsertUpdateDealArchieveFunding(deal.PayruleDeletedDealFundingList, headerUserID);
                        dealLogic.DeleteNoteFundingDataForDealFundingID(deal.DealID);
                    }
                }
                //call 
                dealLogic.CallDealForCalculation(dc.DealID.ToString(), headerUserID, AnalysisID, 775);
                //Delete FF record if not exists in dealfunding
                dealLogic.DeleteNoteFundingDataForDealFundingID(dc.DealID);
            }
            else
            {
                //failed to generate funding                          
                Log.WriteLogExceptionMessage(CRESEnums.Module.Deal.ToString(), deal.PayruleGenerationStackTrace, DealID, "", "GenerateFundingUsingAPI", "Error occurred  while generating future funding for deal id using API" + dc.CREDealID + " " + deal.PayruleGenerationExceptionMessage);

            }

        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetPrepayCalculationStatus")]
        public IActionResult GetPrepayCalculationStatus([FromBody] string DealId)
        {
            GenericResult _authenticationResult = null;

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            DealLogic dealLogic = new DealLogic();
            PrepayCalcStatusDataContract PrepayCalcStatus = new PrepayCalcStatusDataContract();
            PrepayCalcStatus = dealLogic.GetPrepayCalculationStatus(DealId);

            try
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Authentication succeeded",
                    PrepayCalcuStatus = PrepayCalcStatus.Status,
                    CalculationErrorMessage = PrepayCalcStatus.ErrorMessage

                };

            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetPrepayCalcStatusMessage")]
        public IActionResult GetPrepayCalcStatusMessage([FromBody] string DealId)
        {
            GenericResult _authenticationResult = null;
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
#pragma warning disable CS0219 // The variable 'requestid' is assigned but its value is never used
            string requestid = "";
#pragma warning restore CS0219 // The variable 'requestid' is assigned but its value is never used
            DealLogic dealLogic = new DealLogic();
            PrepayCalcStatusDataContract prepayCalc = new PrepayCalcStatusDataContract();
            prepayCalc = dealLogic.GetPrepayCalcStatusMessage(DealId);
            string a = GetLoggedFile(prepayCalc.RequestID);
            List<string> loggedfileresult = convertStringToDataTable(a);
            try
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Authentication succeeded",
                    PrepayCalcFailedStatusData = prepayCalc,
                    loggedfiledata = loggedfileresult

                };

            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        public string GetLoggedFile(string requestid)
        {
#pragma warning disable CS0219 // The variable 'SavingFailedFor' is assigned but its value is never used
            string SavingFailedFor = "";
#pragma warning restore CS0219 // The variable 'SavingFailedFor' is assigned but its value is never used
            string result = "";
            try
            {
                V1CalcLogic _V1CalcLogic = new V1CalcLogic();
                GetConfigSetting();
                string headerkey = Sectionroot.GetSection("Authkeyname").Value;
                string headerValue = Sectionroot.GetSection("Authkeyvalue").Value;
                string strAPI = Sectionroot.GetSection("SubmitRequestConstantUrl").Value;
                //Get logged file 
                SavingFailedFor = "LogFile_Output";
                var strLoggedFileAPI = strAPI + "/" + requestid + "/outputs/logs-" + requestid + ".log";
                HttpClient LoggedFileclient = new HttpClient();
                LoggedFileclient.DefaultRequestHeaders.Add(headerkey, headerValue);
                var apiLoggedFileresult = LoggedFileclient.GetAsync(strLoggedFileAPI).Result;
                if (apiLoggedFileresult.IsSuccessStatusCode == true)
                {
                    var loggedFileresponse = apiLoggedFileresult.Content.ReadAsStringAsync().Result;
                    var LoggedFileoutput = JsonConvert.DeserializeObject<Jsonperiodicresponse>(loggedFileresponse);
                    result = LoggedFileoutput.data;


                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<string> convertStringToDataTable(string data)
        {

            DataTable dtCsv = new DataTable();
            // convert string to stream
            byte[] byteArray = Encoding.UTF8.GetBytes(data);
            MemoryStream Stream = new MemoryStream(byteArray);
            string Fulltext = "";
            List<string> lststring = new List<string>();
            using (StreamReader sr = new StreamReader(Stream))
            {
                while (!sr.EndOfStream)
                {
                    Fulltext = sr.ReadToEnd().ToString(); //read full file text  
                    string[] rows = Fulltext.Split('\n'); //split full file text into rows
                    for (int i = 0; i < rows.Count() - 1; i++)
                    {
                        string row = rows[i];
                        lststring.Add(row);
                    }
                }
            }
            return lststring;
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetEquitySummaryByDealID")]
        public IActionResult GetEquitySummaryByDealID([FromBody] string DealId)
        {
            GenericResult _authenticationResult = null;
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
#pragma warning disable CS0219 // The variable 'requestid' is assigned but its value is never used
            string requestid = "";
#pragma warning restore CS0219 // The variable 'requestid' is assigned but its value is never used
            DealLogic dealLogic = new DealLogic();
            List<EquitySummaryDataContract> equitySummaryData = new List<EquitySummaryDataContract>();
            equitySummaryData = dealLogic.GetEquitySummaryByDealID(DealId);

            try
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Authentication succeeded",
                    equitySummaryDatas = equitySummaryData


                };

            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

    }
}