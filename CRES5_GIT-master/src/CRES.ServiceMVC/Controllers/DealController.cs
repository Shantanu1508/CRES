using Amazon.AutoScaling.Model;
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
using Microsoft.Graph;
using Microsoft.WindowsAzure.Storage.Blob;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using OfficeOpenXml.Table;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;


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
                builder.AddJsonFile(Path.Combine(System.IO.Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                Sectionroot = root.GetSection("Application");
            }
        }
        private IHostingEnvironment _env;
        //public DealController(IHostingEnvironment env)
        //{

        //    _env = env;
        //}

        private readonly IEmailNotification _iEmailNotification;
        public DealController(IEmailNotification iemailNotification, IHostingEnvironment env)
        {
            _iEmailNotification = iemailNotification;
            _env = env;
        }

        private string useridforSys_Scheduler = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";
        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getalldeals")]
        public IActionResult GetAllDeals(int? pageIndex, int? pageSize)
        {
            GenericResult _authenticationResult = null;
            List<DealDataContract> _lstDeals = new List<DealDataContract>();

            IEnumerable<string> headerValues;
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
        [Route("api/deal/getdealbydealid")]
        public IActionResult GetDealByDealId([FromBody] DealDataContract DealDC)
        {
            LoggerLogic Log = new LoggerLogic();
            string currentUserName = "";
            string currentUserID = "";

            string DealCalcuStatus = "";
            DateTime? LastAccountingclosedate = null;
            GenericResult _authenticationResult = null;
            DealDataContract _dealDC = new DealDataContract();
            DealDashDataContract _dashDC = new DealDashDataContract();
            DataTable dtLastUpdatedforTabs = new DataTable();

            IEnumerable<string> headerValues;
            List<IDValueDataContract> ListScheduledPrincipalPaid = new List<IDValueDataContract>();
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            UserPermissionLogic upl = new UserPermissionLogic();
            DealLogic dealLogic = new DealLogic();

            UserLogic userlogic = new UserLogic();
            UserDataContract userDC = new UserDataContract();
            userDC = userlogic.GetUserCredentialByUserID(headerUserID, new Guid("00000000-0000-0000-0000-000000000000"));

            if (userDC != null)
            {
                currentUserName = userDC.Login;
                currentUserID = userDC.UserID.ToString();
            }
            TagXIRRLogic tagXIRRLogic = new TagXIRRLogic();
            //to get user permission
            List<UserPermissionDataContract> permissionlist = upl.GetuserPermissionByUserIDAndPageName(headerUserID.ToString(), "DealDetail", DealDC.DealID.ToString() == "00000000-0000-0000-0000-000000000000" ? DealDC.CREDealID : DealDC.DealID.ToString(), 283);
            if (permissionlist != null && permissionlist.Count > 0)
            {
                _dealDC = dealLogic.GetDealByDealId(DealDC.DealID.ToString() == "00000000-0000-0000-0000-000000000000" ? DealDC.CREDealID : DealDC.DealID.ToString(), headerUserID);
                if (_dealDC.StatusCode == 200)
                {
                    _dealDC.ListSelectedXIRRTags = tagXIRRLogic.GetTagMasterXIRRByAccountID(_dealDC.DealAccountID);

                    PeriodicLogic pr = new PeriodicLogic();
                    if (_dealDC.DealID != null || _dealDC.DealID != new Guid("00000000-0000-0000-0000-000000000000"))
                    {

                        LastAccountingclosedate = pr.GetLastAccountingCloseDateByDealIDORNoteID(_dealDC.DealID, null);
                        //LastAccountingclosedate = Convert.ToDateTime("07/30/2023");
                        _dealDC.LastAccountingclosedate = LastAccountingclosedate;

                        _dealDC.currentUserName = currentUserName;
                        _dealDC.currentUserID = currentUserID;
                        if (_dealDC.LastAccountingclosedate != null)
                        {
                            if (_dealDC.LastAccountingclosedate.Value.Year < 1970)
                            {
                                _dealDC.LastAccountingclosedate = null;
                            }
                        }
                        _dashDC = dealLogic.GetDealDashBoardByDealId(_dealDC.DealID);
                    }

                    ListScheduledPrincipalPaid = dealLogic.GetScheduledPrincipalByDealID(headerUserID, DealDC.DealID.ToString() == "00000000-0000-0000-0000-000000000000" ? DealDC.CREDealID : DealDC.DealID.ToString());

                    _dealDC.ListAutoRepaymentBalances = dealLogic.GetAutospreadRepaymentBalancesDealID(_dealDC.DealID);
                    if (_dealDC.ListAutoRepaymentBalances != null)
                    {
                        if (_dealDC.ListAutoRepaymentBalances.Count > 0)
                        {
                            _dealDC.ListNoteRepaymentBalances = dealLogic.GetNoteAutospreadRepaymentBalancesByDealId(_dealDC.DealID);
                        }
                    }
                    DealCalcuStatus = dealLogic.GetDealCalculationStatus(DealDC.DealID.ToString());

                    dtLastUpdatedforTabs = dealLogic.GetLastUpdatedforDealTabs(_dealDC.DealID, headerUserID);
                }

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
                        DealCalcuStatus = DealCalcuStatus,
                        DealDashData = _dashDC,
                        dtLastUpdatedforTabs = dtLastUpdatedforTabs
                    };
                }
                else
                {
                    if (_dealDC.StatusCode == 400)
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "Not Exists",
                            StatusCode = 404
                        };
                    }
                    else if (_dealDC.StatusCode == 500)
                    {
                        Log.WriteLogExceptionMessage (CRESEnums.Module.Deal.ToString(), "Error occurred  in get Deal By DealId deal: Deal ID " + DealDC.CREDealID + " :" + _dealDC.DealStackTrace, _dealDC.DealID.ToString(),  headerUserID.ToString(), "GetDealByDealId", _dealDC.DealErrorMessage);
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = false,
                            Message = "Internal Server Error",
                            StatusCode = 500
                        };
                    }
                    else
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = false,
                            Message = "Authentication failed",
                            StatusCode = 400
                        };
                    }

                }
            }
            catch (Exception ex)
            {
                
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

            string getAllLookup = "1,2,4,5,6,7,8,15,16,38,50,51,52,21,25,65,74,77,78,79,82,83,84,85,86,87,88,89,90,91,92,94,98,101,103,95,104,106,108,114,118,119,120,121,123,124,125,133,134,140,141,142,147,71,148,151,153";
            GenericResult _authenticationResult = null;
            List<LookupDataContract> lstlookupDC = new List<LookupDataContract>();
            IEnumerable<string> headerValues;
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

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getAllLiabilityTypesDetail")]
        public IActionResult GetAllLiabilityTypesDetailLookup()
        {
            GenericResult _authenticationResult = null;
            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
            List<LookupDataContract> lstSearch = LiabilityNotelogic.GetAllLiabilityTypeLookup();
            List<LookupDataContract> lstDebtEquityType = LiabilityNotelogic.GetDebtEquityTypeList();

            try
            {
                if (lstSearch != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        AssetList = lstSearch,
                        lstDebtEquityType = lstDebtEquityType
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
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in GetAllLiabilityTypesDetail for deal id", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
            IEnumerable<string> headerValues;
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
                string BackShopStatus = "";

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
                                //	User Name
                                pd.GeneratedBy = 822;
                                pd.GeneratedByUserID = DealDC.currentUserID;
                            }

                            if (pd.GeneratedBy == 822)
                            {
                                if (pd.GeneratedByUserID == null || pd.GeneratedByUserID == "")
                                {
                                    pd.GeneratedByUserID = DealDC.currentUserID;
                                }
                            }

                            if (pd.AdjustmentType == 836)
                            {
                                pd.AdjustmentType = null;
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
                            if (DealDC.DeletedDealFundingList.Count > 0)
                            {
                                CollectCalculatorLogs("11 InsertUpdateDealArchieveFunding Starts", DealDC.CREDealID, collectlogs);
                                dealLogic.InsertUpdateDealArchieveFunding(DealDC.DeletedDealFundingList, headerUserID);
                                CollectCalculatorLogs("12 InsertUpdateDealArchieveFunding Ends", DealDC.CREDealID, collectlogs);
                            }
                            CollectCalculatorLogs("9 InsertNoteFutureFunding Starts", DealDC.CREDealID, collectlogs);
                            nl.InsertNoteFutureFunding(DealDC.PayruleTargetNoteFundingScheduleList, headerUserID);
                            CollectCalculatorLogs("10 InsertNoteFutureFunding Ends", DealDC.CREDealID, collectlogs);

                            if (DealDC.DeletedDealFundingList.Count > 0)
                            {
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

                            if (DealDC.dtPayoffStatementFees != null)
                            {
                                foreach (DataRow dr in DealDC.dtPayoffStatementFees.Rows)
                                {
                                    dr["DealID"] = DealDC.DealID;
                                    if (dr["PayoffStatementFeesID"] == null || dr["PayoffStatementFeesID"].ToString() == "")
                                    {
                                        dr["PayoffStatementFeesID"] = 0;
                                    }
                                }

                                dealLogic.InsertUpdatePayoffStatementFees(DealDC.dtPayoffStatementFees, headerUserID);
                            }

                            if (DealDC.dtPrepaymentGroup != null)
                            {
                                dealLogic.InsertUpdatePrepaymentGroup(DealDC.dtPrepaymentGroup, headerUserID);
                            }
                            if (DealDC.dtPrepaymentNote != null)
                            {
                                dealLogic.InsertUpdatePrepaymentNote(DealDC.dtPrepaymentNote, headerUserID);
                            }
                            if (DealDC.dtPrepaymentNoteAlloc != null)
                            {
                                dealLogic.InsertUpdatePrepaymentNoteAllocationSetup(DealDC.dtPrepaymentNoteAlloc, headerUserID);
                            }
                            //if (DealDC.ShowUseRuleN == false || DealDC.EnableAutospreadRepayments == true)
                            //{
                            //    CheckAndQueuePhantomDealForAutomation(DealDC.CREDealID);

                            //}
                            ////New
                            ////Export using Backshop API
                            Thread thirdThread = new Thread(() => ExportFutureFundingFromCRES_API(DealDC.PayruleTargetNoteFundingScheduleList, headerUserID, DealDC));
                            thirdThread.Start();

                        }
                    }
                    if (DealDC.IsServicingWatchlisttabClicked == true)
                    {
                        //Delete Potential ImpairmentList 
                        if (DealDC.DeleteServicingPotentialImpairment != null)
                        {
                            if (DealDC.DeleteServicingPotentialImpairment.Rows.Count != 0)
                            {
                                ServicingWatchListLogic SWLogic = new ServicingWatchListLogic();
                                CollectCalculatorLogs("25 DeleteServicingPotentialImpairment Start", DealDC.CREDealID, collectlogs);
                                SWLogic.DeleteServicingWatchlistPotentialImpairment(DealDC.DeleteServicingPotentialImpairment, headerUserID);
                                CollectCalculatorLogs("26 DeleteServicingPotentialImpairment Ends", DealDC.CREDealID, collectlogs);
                            }
                        }
                        SaveServicingWatchListData(DealDC, headerUserID);
                    }
                    if (DealDC.isLiabilityTabCLicked == true)
                    {
                        SaveDealLiability(DealDC, headerUserID);
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

                    //For AutoDistributeWriteOff
                    if (DealDC.AutoDistributeWriteoffList != null)
                    {
                        CollectCalculatorLogs("39 InsertUpdateAutoDistributeWriteoff Starts", DealDC.CREDealID, collectlogs);
                        dealLogic.InsertUpdateAutoDistributeWriteoff(DealDC.AutoDistributeWriteoffList, headerUserID);
                        CollectCalculatorLogs("40 InsertUpdateAutoDistributeWriteoff Ends", DealDC.CREDealID, collectlogs);
                    }

                    //For XIRROverride
                    if (DealDC.XIRROverride != null)
                    {
                        CollectCalculatorLogs("41 InsertUpdateXIRROverride Starts", DealDC.CREDealID, collectlogs);
                        dealLogic.InsertUpdateXIRROverride(DealDC.XIRROverride, headerUserID);
                        CollectCalculatorLogs("42 InsertUpdateXIRROverride Ends", DealDC.CREDealID, collectlogs);
                    }

                    //For DealRelationship
                    if (DealDC.DealRelationshipList != null)
                    {
                        CollectCalculatorLogs("43 SaveDealRelationshipList Starts", DealDC.CREDealID, collectlogs);
                        dealLogic.SaveDealRelationship(DealDC.DealRelationshipList, headerUserID);
                        CollectCalculatorLogs("44 SaveDealRelationshipList Ends", DealDC.CREDealID, collectlogs);
                    }

                    Thread CalculateDealThread = new Thread(() => CalculateDeal(DealDC, headerUserID));
                    CalculateDealThread.Start();
                }

                if (DealDC.DealAccountID != null)
                {
                    TagXIRRLogic tagXIRRLogic = new TagXIRRLogic();
                    tagXIRRLogic.InsertUpdateTagAccountMappingXIRR(DealDC.DealAccountID, DealDC.ListSelectedXIRRTags, headerUserID);

                    tagXIRRLogic.CalculateXIRRAfterDealSave(DealDC.DealAccountID, headerUserID);

                }

                // to call for AIEntityApi
                AIDynamicEntityUpdateLogic _dynamicentity = new AIDynamicEntityUpdateLogic();
                Thread SecondThread = new Thread(() => _dynamicentity.InsertUpdateAIDealEntitiesAsync(DealDC, headerUserID));
                SecondThread.Start();

                CollectCalculatorLogs("45 Deal saved successfully", DealDC.CREDealID, collectlogs);

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
                    dc.PayruleNoteDetailFundingList = nl.GetNotesForPayruleCalculationByDealID(dc.DealID.ToString(), new Guid(userid), 1, 1000, out TotalCount).OrderByDescending(x => x.NoteID).ToList();
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


        private void CalculateDeal(DealDataContract DealDC, string userid)
        {

            GetConfigSetting();
            DealLogic dealLogic = new DealLogic();

            dealLogic.CallDealForCalculation(DealDC.DealID.ToString(), userid, DealDC.AnalysisID, 775);
            if (DealDC.CalcEngineType == 798)
            {
                V1CalcLogic v1logic = new V1CalcLogic();
                if (DealDC.BalanceAware == true)
                {
                    v1logic.SubmitCalcRequest(DealDC.DealID.ToString(), 283, DealDC.AnalysisID, 775, false, "");
                }
                else
                {
                    var notelist = dealLogic.GetParnetNotesInaDealForCalculation(DealDC.DealID.ToString());
                    foreach (var item in notelist)
                    {
                        v1logic.SubmitCalcRequest(item.objectID, 182, DealDC.AnalysisID, 775, false, "");
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
        public void ExportFutureFundingFromCRES_API(List<PayruleTargetNoteFundingScheduleDataContract> PayruleTargetNoteFundingScheduleDataContract, string headerUserID, DealDataContract DealDC)
        {
            string AllowBackshopFF = "";
            try
            {
                AppConfigLogic acl = new AppConfigLogic();

                List<AppConfigDataContract> listappconfig = acl.GetAllAppConfig(new Guid(headerUserID));
                foreach (AppConfigDataContract item in listappconfig)
                {
                    if (item.Key == "AllowBackshopFF")
                    {
                        AllowBackshopFF = item.Value;
                    }
                }
                if (AllowBackshopFF == "1")
                {
                    BackShopExportLogic bsl = new BackShopExportLogic();
                    bsl.ExportFutureFundingFromCRES_API(PayruleTargetNoteFundingScheduleDataContract, headerUserID, DealDC);
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                _iEmailNotification.SendEmailExportFFBackShopFail(DealDC, "", ex.Message);
            }
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetNoteDealFundingByDealID")]
        public IActionResult GetNoteDealFundingByDealIDAPI([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            DataTable dt = new DataTable();
            DataTable dtBlank = new DataTable();
            DataTable dtImpairment = new DataTable();

            IEnumerable<string> headerValues;

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
                    dt.Columns.Add("_isSoftHoliday").SetOrdinal(35);
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

            //get default deal funding structure with dynamic notes
            dtBlank = dealLogic.GetNoteDealFundingScheduleByDealID(new Guid(DealDC.DealID.ToString()), headerUserID, true);
            //
            //get imparent data
            dtImpairment = dealLogic.GetDealFundingWLDealPotentialImpairmentByDealID(new Guid(DealDC.DealID.ToString()), headerUserID);
            //
            //add data to list for ListRevolverDealFunding
            List<PayruleDealFundingDataContract> ListRevolverDealFunding = new List<PayruleDealFundingDataContract>();
            foreach (DataRow dr in dt.Rows)
            {
                int? currentadjtype = CommonHelper.ToInt32(dr["AdjustmentType"]);

                if (currentadjtype == 835)
                {
                    PayruleDealFundingDataContract dealfund = new PayruleDealFundingDataContract();
                    dealfund.DealFundingID = new Guid(dr["DealFundingID"].ToString());
                    dealfund.Value = CommonHelper.ToDecimal(dr["Value"]);

                    dealfund.Date = CommonHelper.ToDateTime(dr["Date"]);
                    dealfund.DealFundingRowno = CommonHelper.ToInt32_NotNullable(dr["DealFundingRowno"]);
                    dealfund.Applied = CommonHelper.ToBoolean(dr["Applied"]);

                    dealfund.Comment = dr["Comment"].ToString();
                    dealfund.PurposeText = dr["PurposeText"].ToString();
                    dealfund.PurposeID = CommonHelper.ToInt32_NotNullable(dr["PurposeID"]);
                    dealfund.RequiredEquity = CommonHelper.ToDecimal(dr["RequiredEquity"]);
                    dealfund.AdditionalEquity = CommonHelper.ToDecimal(dr["AdditionalEquity"]);
                    dealfund.AdditionalEquity = CommonHelper.ToDecimal(dr["AdditionalEquity"]);
                    dealfund.AdjustmentType = currentadjtype;
                    ListRevolverDealFunding.Add(dealfund);
                }
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
                        lstNoteDealFundingBlank = dtBlank,
                        lstWFStatusPurposeMapping = lstWFStatusPurposeMap,
                        lstDealFundingImpairment = dtImpairment,
                        ListRevolverDealFunding = ListRevolverDealFunding
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
            IEnumerable<string> headerValues;

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
            IEnumerable<string> headerValues;

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
            DataTable dtWeightedSpread = new DataTable();
            DataTable dtNetCapitalInvested = new DataTable();
            IEnumerable<string> headerValues;

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DealLogic dealLogic = new DealLogic();
            dt = dealLogic.GetFundingRepaymentSequenceHistoryByDealID(new Guid(DealDC.DealID.ToString()));

            dtWeightedSpread = dealLogic.GetCalculatedWeightedSpreadByDealID(new Guid(DealDC.DealID.ToString()));
            dtNetCapitalInvested = dealLogic.GetFundingNetCapitalInvestedbyDealID(new Guid(DealDC.DealID.ToString()));

            dtWeightedSpread = WeightedSpreadCalcHelperLogic.CaculateWeightedAvg(dtWeightedSpread);
            decimal? CalcWeightedSpread = 0;
            decimal? CalcWeightedEffectiveRate = 0;

            if (dt != null && dtWeightedSpread != null)
            {

                foreach (DataRow row in dt.Rows)
                {
                    string noteId = row["NoteID"].ToString();

                    foreach (DataRow weightedSpreadRow in dtWeightedSpread.Rows)
                    {
                        string weightedSpreadNoteId = weightedSpreadRow["NoteID"].ToString();
                        if (noteId == weightedSpreadNoteId)
                        {
                            CalcWeightedSpread = CalcWeightedSpread.GetValueOrDefault(0) + CommonHelper.StringToDecimal(weightedSpreadRow["SpreadNextPayDtWeightedRate"]);
                            CalcWeightedEffectiveRate = CalcWeightedEffectiveRate.GetValueOrDefault(0) + CommonHelper.StringToDecimal(weightedSpreadRow["CalcWeightedEffectiveRate"]);
                            decimal? WeightedSpread = CommonHelper.StringToDecimal(weightedSpreadRow["SpreadNextPayDt"]);
                            decimal? EffectiveRate = CommonHelper.StringToDecimal(weightedSpreadRow["EffectiveRate"]);
                            row["WeightedSpread"] = WeightedSpread;
                            row["EffectiveRate"] = EffectiveRate;

                            break;
                        }
                    }
                }

                if (CalcWeightedSpread == null)
                {
                    CalcWeightedSpread = 0;
                }
                else
                {
                    CalcWeightedSpread = Math.Round(CalcWeightedSpread.Value, 8) * 100;
                }

                if (CalcWeightedEffectiveRate == null)
                {
                    CalcWeightedEffectiveRate = 0;
                }
                else
                {
                    CalcWeightedEffectiveRate = Math.Round(CalcWeightedEffectiveRate.Value, 8) * 100;
                }
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


            if (dt != null && dtNetCapitalInvested != null)
            {

                foreach (DataRow row in dt.Rows)
                {
                    string noteId = row["NoteID"].ToString();

                    foreach (DataRow dtNetCapitalInvestedrow in dtNetCapitalInvested.Rows)
                    {
                        string dtNetCapitalInvestedNoteId = dtNetCapitalInvestedrow["NoteID"].ToString();
                        if (noteId == dtNetCapitalInvestedNoteId)
                        {
                            decimal? NetCapitalInvested = CommonHelper.StringToDecimalWithNull(dtNetCapitalInvestedrow["NetCapitalInvested"]);

                            row["NetCapitalInvested"] = NetCapitalInvested.HasValue ? (object)NetCapitalInvested.Value : DBNull.Value;


                            break;
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
                        lstFundingRepaymentSequenceHistory = dt,
                        CalcWeightedSpread = CalcWeightedSpread,
                        CalcWeightedEffectiveRate = CalcWeightedEffectiveRate
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
            IEnumerable<string> headerValues;

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DealLogic dealLogic = new DealLogic();
            notefunding = dealLogic.GetNoteFundingbyDealID(new Guid(DealDC.DealID.ToString()));

            List<PayruleTargetNoteFundingScheduleDataContract> ListRevolverNoteFunding = new List<PayruleTargetNoteFundingScheduleDataContract>();
            if (notefunding != null)
            {
                foreach (var item in notefunding)
                {
                    if (item.AdjustmentType == 835)
                    {
                        ListRevolverNoteFunding.Add(item);
                    }
                }
            }
            try
            {
                if (notefunding != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstnoteFundingschedule = notefunding,
                        ListRevolverNoteFunding = ListRevolverNoteFunding
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

            //var json =;
            Utilities.WriteDataToFile.WriteDataToNewFile(DealDC.DealName + "_Autospread_Issue.json", JsonConvert.SerializeObject(DealDC));
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
            IEnumerable<string> headerValues;

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            string Status = "";
            string msg = "";
            string Liabilitymsg = "";
            string LiabilityDuplicatenotes = "";
            foreach (var notes in DealDC.notelist)
            {
                if (notes.CRENewNoteID != null)
                {
                    if (notes.CRENewNoteID != "")
                    {
                        noteids = noteids + notes.CRENewNoteID + ",";
                    }
                }
                else if (notes.CRENoteID != null)
                {
                    if (notes.CRENoteID != "")
                    {
                        noteids = noteids + notes.CRENoteID + ",";
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
            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
            if (DealDC.ListDealLiabilityDupliateCheck != null)
            {
                foreach (var item in DealDC.ListDealLiabilityDupliateCheck)
                {
                    if (item.LiabilityNoteAccountID == null)
                    {
                        item.LiabilityNoteAccountID = new Guid("00000000-0000-0000-0000-000000000000");
                    }
                    if (item.LiabilityNoteID != "")
                    {
                        Status = LiabilityNotelogic.CheckDuplicateforLiabilities(item.LiabilityNoteID, "LiabilityNote", item.LiabilityNoteAccountID);
                        if (Status == "True")
                        {
                            LiabilityDuplicatenotes = LiabilityDuplicatenotes + item.LiabilityNoteID.ToString() + ",";

                        }
                        else if (Status == "False")
                        {

                            Liabilitymsg = "Save";
                        }
                    }

                }
            }

            if (LiabilityDuplicatenotes != "")
            {
                String withoutLast = LiabilityDuplicatenotes.Substring(0, (LiabilityDuplicatenotes.Length - 1));
                withoutLast = "Liability Note " + withoutLast + " already exist. Please enter unique Liability Note ID.";
                if (msg != "Save")
                {
                    msg = msg + " " + withoutLast;
                }
                else
                {
                    msg = withoutLast;
                }
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
            IEnumerable<string> headerValues;

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
            IEnumerable<string> headerValues;

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
            IEnumerable<string> headerValues;

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
            IEnumerable<string> headerValues;

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

            XIRRCalcHelperLogic xirrhelper = new XIRRCalcHelperLogic();
            Thread ThreadXirr = new Thread(() => xirrhelper.CalculateXIRRAfterDealSave(DealDC.CREDealID, headerUserID));
            ThreadXirr.Start();

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
                string formatedstring = Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in CopyDeal for Deal ID: " + DealDC.CREDealID, DealDC.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                string emailextrainfo = "CREDealID :" + DealDC.CREDealID + " DealName :" + DealDC.DealName + " ";
                Thread FirstThread = new Thread(() => _iEmailNotification.SendEmailOnExceptionFailed("CopyDeal", formatedstring, ExceptionHelper.GetFullMessage(ex), headerUserID, emailextrainfo));
                FirstThread.Start();

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        public void CheckAndQueuePhantomDealForAutomation(string credealid)
        {
            try
            {
                List<DealDataContract> listDeal = new List<DealDataContract>();
                DealLogic dealLogic = new DealLogic();
                listDeal = dealLogic.GetLinkedPhantomDealID(credealid);
                var headerUserID = string.Empty;
                if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
                {
                    headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
                }
                if (listDeal != null && listDeal.Count > 0)
                {

                    List<GenerateAutomationDataContract> list = new List<GenerateAutomationDataContract>();
                    foreach (DealDataContract deal in listDeal)
                    {
                        GenerateAutomationDataContract gad = new GenerateAutomationDataContract();
                        gad.DealID = Convert.ToString(deal.DealID);
                        gad.StatusText = "Processing";
                        gad.AutomationType = 807;
                        gad.AutomationTypeText = "Phantom_Deal";
                        gad.BatchType = "Phantom_Deal";
                        list.Add(gad);
                    }
                    GenerateAutomationLogic GenerateAutomationLogic = new GenerateAutomationLogic();
                    GenerateAutomationLogic.QueueDealForAutomation(list, headerUserID);
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogExceptionMessage(CRESEnums.Module.Deal.ToString(), ex.StackTrace, credealid, "", "CheckAndQueuePhantomDealForAutomation", "Error occurred" + credealid + " " + ex.Message);
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

            IEnumerable<string> headerValues;
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

            IEnumerable<string> headerValues;
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
            dc.PayruleNoteDetailFundingList = nl.GetNotesForPayruleCalculationByDealID(DealID, new Guid(userid), 1, 1000, out TotalCount).OrderByDescending(x => x.NoteID).ToList();
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
            IEnumerable<string> headerValues;
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
            IEnumerable<string> headerValues;

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
            IEnumerable<string> headerValues;

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
            IEnumerable<string> headerValues;


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
            IEnumerable<string> headerValues;

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
            IEnumerable<string> headerValues;
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
            IEnumerable<string> headerValues;

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
            string Errormsg = "";
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
            IEnumerable<string> headerValues;
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
            IEnumerable<string> headerValues;
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
            IEnumerable<string> headerValues;
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

            IEnumerable<string> headerValues;
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            try
            {
                var DealID = Convert.ToString(dtDeal.Rows[0]["DealID"]);
                int DealStatus = Convert.ToInt32(dtDeal.Rows[0]["DealStatus"]);
                DealLogic dealLogic = new DealLogic();
                _lstprojectedpayoffdates = dealLogic.GetProjectedPayOffDateByDealID(headerUserID.ToString(), new Guid(DealID), DealStatus);

                if (_lstprojectedpayoffdates != null && _lstprojectedpayoffdates.Count > 0)
                {
                    NoteLogic _NoteLogic = new NoteLogic();
                    List<HolidayListDataContract> ListHoliday = _NoteLogic.GetHolidayList();

                    foreach (ProjectedPayoffDataContract item in _lstprojectedpayoffdates)
                    {
                        if (item.EarliestDate != null)
                        {
                            item.EarliestDate = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(item.EarliestDate.Value), Convert.ToInt16(-1), "US", ListHoliday).Date;
                        }
                        if (item.ExpectedDate != null)
                        {

                            item.ExpectedDate = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(item.ExpectedDate.Value), Convert.ToInt16(-1), "US", ListHoliday).Date;
                        }
                        if (item.LatestDate != null)
                        {
                            item.LatestDate = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(item.LatestDate.Value), Convert.ToInt16(-1), "US", ListHoliday).Date;
                        }
                    }
                }
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
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in autospread repayment backshop procedure execution for deal id", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

            }
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

            IEnumerable<string> headerValues;
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

            IEnumerable<string> headerValues;

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

            IEnumerable<string> headerValues;

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

            IEnumerable<string> headerValues;

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

            IEnumerable<string> headerValues;

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
            DataTable lstCurrentSpread = new DataTable();

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            lstprepay = dealLogic.GetPrepayPremiumDetailDataByDealId(DealId, headerUserID);
            lstCurrentSpread = dealLogic.GetCurrentSpreadfromRateSpreadSchByDealID(DealId);

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
                        lstDealSpreadMaintenanceDeallevel = lstprepay.SpreadMaintenanceScheduleDeallevel,
                        lstCurrentSpread = lstCurrentSpread

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
            int? IsEmailSent = null;
            DealLogic dealLogic = new DealLogic();
            if (dealDataContract.SendEmailAfterCalc == "Y")
            {
                IsEmailSent = 4;
            }

            // Call the deal calculation before prepay calculation
            dealLogic.CallDealForCalculation(dealDataContract.DealID.ToString(), headerUserID, dealDataContract.ScenarioIdPrepay, 775);
            //queue the prepay calculation request
            dealLogic.CallDealForPrePayCalculation(dealDataContract.DealID.ToString(), headerUserID, dealDataContract.ScenarioIdPrepay, 776, "Deal", IsEmailSent);

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
            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            string scenariomsg = "";
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
            IEnumerable<string> headerValues;
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
            CommitmentEquityHelperLogic ce = new CommitmentEquityHelperLogic();
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

        public string GetLoggedFile(string requestid)
        {
            string SavingFailedFor = "";
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
            string requestid = "";
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



        [HttpGet]
        [Route("api/deal/CheckBackShopExport")]
        public IActionResult CheckBackShopExport(string DealID, string noteid, string Type)
        {

            try
            {
                BackShopExportLogic bsl = new BackShopExportLogic();
                string res = bsl.ExportDataToBackShop(DealID, "B0E6697B-3534-4C09-BE0A-04473401AB93", noteid, Type);
                return Ok(res);
            }
            catch (Exception ex)
            {
                return Ok(ex);
            }
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getServicingWatchListDatabyDealid")]
        public IActionResult GetServicingWatchListDatabyDealid([FromBody] string DealID)
        {
            GenericResult _authenticationResult = null;
            List<ServicingWatchlistDataContract> ListServicingWatchlistLegal = new List<ServicingWatchlistDataContract>();
            List<ServicingWatchlistDataContract> ListServicingWatchlistAccounting = new List<ServicingWatchlistDataContract>();
            List<ServicingWatchlistDataContract> ListServicingPotentialImpairment = new List<ServicingWatchlistDataContract>();

            IEnumerable<string> headerValues;
            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            ServicingWatchListLogic swlogic = new ServicingWatchListLogic();

            ListServicingWatchlistAccounting = swlogic.GetServicingWatchlistDealAccountingByDealID(DealID);
            ListServicingWatchlistLegal = swlogic.GetServicingWatchlistDealLegalStatusByDealID(DealID);
            //ListServicingPotentialImpairment = swlogic.GetServicingWatchlistDealPotentialImpairmentByDealID(DealID);
            DataTable dt = new DataTable();
            dt = swlogic.GetDealPotentialImpairmentByDealID(new Guid(DealID), headerUserID);


            try
            {
                //if (dt.Rows.Count > 0)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Succeeded",
                        ListServicingWatchlistLegal = ListServicingWatchlistLegal,
                        ListServicingWatchlistAccounting = ListServicingWatchlistAccounting,
                        ListServicingPotentialImpairment = ListServicingPotentialImpairment,
                        dt = dt
                    };
                }

            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                //Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in autospread GetServicingWatchListDatabyDealid for deal id", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = "Failed"
                };
            }
            return Ok(_authenticationResult);
        }

        public void SaveServicingWatchListData(DealDataContract dealdc, string userid)
        {
            LoggerLogic Log = new LoggerLogic();

            try
            {
                ServicingWatchListLogic SWLogic = new ServicingWatchListLogic();
                foreach (var item in dealdc.ServicingWatchlistAccounting)
                {
                    item.UserID = userid;
                    item.DealID = dealdc.DealID.ToString();
                    if (item.IsDeleted == null)
                    {
                        item.IsDeleted = false;
                    }
                }
                SWLogic.InsertUpdatedServicingWatchlistAccounting(dealdc.ServicingWatchlistAccounting);

                foreach (var item in dealdc.ServicingPotentialImpairment)
                {
                    item.UserID = userid;
                    item.DealID = dealdc.DealID.ToString();
                    if (item.IsDeleted == null)
                    {
                        item.IsDeleted = false;
                    }

                }
                if (dealdc.ServicingPotentialImpairmentList != null && dealdc.ServicingPotentialImpairmentList.Rows.Count > 0)
                {
                    SWLogic.InsertUpdatedServicingWatchlistPotentialImpairment(dealdc.ServicingPotentialImpairmentList, userid);
                }
            }
            catch (Exception ex)
            {
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in SaveServicingWatchListData for deal id" + dealdc.DealID, "", userid, ex.TargetSite.Name.ToString(), "", ex);
                throw ex;
            }

        }

        [HttpPost]
        [Route("api/deal/updatedealdataintoM61")]
        public IActionResult UpdateDealDataIntoM61([FromBody] dynamic root)
        {
            GetConfigSetting();
            string headerkey = Sectionroot.GetSection("m61authKey").Value;
            LoggerLogic log = new LoggerLogic();
            v1GenericResult _authenticationResult = null;
            List<string> ListError = new List<string>();
            string headerValues = "";
            try
            {
                if (!string.IsNullOrEmpty(Request.Headers["m61authKey"]))
                {
                    headerValues = Request.Headers["m61authKey"].ToString();
                }
                if (headerkey == headerValues)
                {
                    List<ServicingWatchlistDataContract> watchList = new List<ServicingWatchlistDataContract>();
                    JObject jsonObject = JObject.FromObject(root);
                    JArray dealsArray = (JArray)jsonObject["Deals"];
                    string currentdealid = "";
                    foreach (var dealToken in dealsArray)
                    {
                        JArray watchListArray = (JArray)dealToken["SpecialServicingStatus"];
                        foreach (var watchListItem in watchListArray)
                        {
                            currentdealid = Convert.ToString(dealToken["DealID"]);
                            if (currentdealid != "" && currentdealid != null)
                            {
                                string Errorkey = "";
                                ServicingWatchlistDataContract leagl = new ServicingWatchlistDataContract();

                                if (CommonHelper.ToDateTime(watchListItem["StartDate"].ToString()) == null)
                                {
                                    Errorkey += "StartDate is not valid,";
                                }
                                if (Convert.ToString(watchListItem["Type"]) == "" || Convert.ToString(watchListItem["Type"]) == null)
                                {
                                    Errorkey += "Type is empty,";
                                }

                                if (Errorkey == "")
                                {
                                    leagl.StartDate = CommonHelper.ToDateTime(watchListItem["StartDate"]);
                                    leagl.Type = Convert.ToString(watchListItem["Type"]);

                                    leagl.CreDealID = Convert.ToString(dealToken["DealID"]);
                                    leagl.Comment = Convert.ToString(watchListItem["Comment"]);
                                    leagl.UserID = Convert.ToString(watchListItem["UserName"]);

                                    string ReasonCodetxt = "";
                                    if (watchListItem["ReasonCodes"] != null)
                                    {
                                        var ReasonCodestArray = watchListItem["ReasonCodes"];
                                        if (ReasonCodestArray != null)
                                        {
                                            foreach (var item in ReasonCodestArray)
                                            {
                                                ReasonCodetxt = ReasonCodetxt + item["ReasonCode"] + " / ";
                                            }
                                        }
                                    }
                                    if (ReasonCodetxt != "")
                                    {
                                        leagl.ReasonCode = ReasonCodetxt.Substring(0, ReasonCodetxt.Length - 3);
                                    }
                                    leagl.UpdatedBy = Convert.ToString(watchListItem["UserName"]);
                                    watchList.Add(leagl);
                                }
                                else
                                {
                                    ListError.Add("For Deal ID " + currentdealid + " " + Errorkey.Trim().Trim(',') + ".");
                                }

                            }
                            else
                            {
                                ListError.Add("Deal ID Cannot be empty");
                                // no deal id
                            }
                        }
                    }
                    ServicingWatchListLogic SWLogic = new ServicingWatchListLogic();
                    SWLogic.InsertWLDealLegalStatusFromAPI(watchList);
                    log.WriteLogInfo(CRESEnums.Module.ServicingWatchlist.ToString(), "UpdateDealDataIntoM61 data saved in database", "", "");
                    _authenticationResult = new v1GenericResult()
                    {
                        Status = 200,
                        Succeeded = true,
                        Message = "Data Saved Successfully.",
                        ErrorDetails = "",
                        Validationarray = ListError
                    };
                }
                else
                {
                    return StatusCode(Microsoft.AspNetCore.Http.StatusCodes.Status401Unauthorized, "Unauthorized access");
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new v1GenericResult()
                {
                    Status = 500,
                    Succeeded = false,
                    Message = "Internal Server Error",
                    ErrorDetails = ex.Message
                };
                log.WriteLogException(CRESEnums.Module.ServicingWatchlist.ToString(), "Error in UpdateDealDataIntoM61 " + Convert.ToString(root), "", useridforSys_Scheduler, "UpdateDealDataIntoM61", "", ex);
            }
            return Ok(_authenticationResult);
        }

        public static bool IsValidDate(string dt)
        {
            DateTime Test;
            if (DateTime.TryParseExact(dt, "MM/dd/yyyy", null, DateTimeStyles.None, out Test) == true)
                return true;
            else
                return false;
        }



        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/getdealliabilitybydealid")]
        public IActionResult GetDealLiabilityByDealID([FromBody] string DealAccountID)
        {
            GenericResult _authenticationResult = null;
            IEnumerable<string> headerValues;

            var headerUserID = string.Empty;
            LiabilityNoteLogic LiabilityNoteLogic = new LiabilityNoteLogic();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            List<LiabilityNoteDataContract> ListLiabilityNotes = new List<LiabilityNoteDataContract>();
            try
            {
                ListLiabilityNotes = LiabilityNoteLogic.GetLiabilityNoteByDealAccountID(DealAccountID);
                List<LiabilityFundingScheduleDataContract> ListLiabilityFundingSchedule = LiabilityNoteLogic.GetLiabilityFundingScheduleByDealAccountID(DealAccountID);

                List<LookupDataContract> AssetList = LiabilityNoteLogic.GetAssetListByDealAccountID(Convert.ToString(DealAccountID));
                List<LiabilityNoteAssetMapping> LNoteAssetMap = LiabilityNoteLogic.GetLiabilityNoteAssetMappingByDealAccountID(Convert.ToString(DealAccountID));

                List<LookupDataContract> lstLookups = LiabilityNoteLogic.GetTransactionTypesLookupForJournalEntry();
                if (ListLiabilityNotes != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        ListDealLiability = ListLiabilityNotes,
                        ListLiabilityFundingSchedule = ListLiabilityFundingSchedule,
                        AssetList = AssetList,
                        LNoteAssetMap = LNoteAssetMap,
                        lstLookups = lstLookups
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
        public void SaveDealLiability(DealDataContract dealdc, string userid)
        {

            try
            {
                LiabilityNoteLogic lnl = new LiabilityNoteLogic();
                //if (dealdc.ListLiabilityFundingSchedule != null)
                //{
                //    if (dealdc.ListLiabilityFundingSchedule.Count > 0)
                //    {
                //        int rowno = 1;
                //        foreach (var item in dealdc.ListLiabilityFundingSchedule)
                //        {
                //            if (item.AssetAccountID == null || item.AssetAccountID == "")
                //            {
                //                item.AssetAccountID = "00000000-0000-0000-0000-000000000000";
                //            }
                //            item.RowNo = rowno;
                //            rowno = rowno + 1;
                //        }
                //        lnl.InsertUpdatedLiabilityFundingSchedule(dealdc.ListLiabilityFundingSchedule, userid);

                //    }
                //}
                // lnl.MoveConfirmedToAdditionalTransactionEntry(dealdc.DealAccountID, userid);

                if (dealdc.ListDealLiability != null)
                {
                    if (dealdc.ListDealLiability.Count > 0)
                    {

                        foreach (LiabilityNoteDataContract note in dealdc.ListDealLiability)
                        {
                            if (note.AssetAccountID == null || note.AssetAccountID == "")
                            {
                                note.AssetAccountID = "00000000-0000-0000-0000-000000000000";
                            }
                            if (note.LiabilityNoteAutoID == null)
                            {
                                note.LiabilityNoteAutoID = 0;
                            }
                            if (note.PledgeDate == null)
                            {
                                note.PledgeDate = DateTime.Now;
                            }
                            if (note.DealAccountID == null)
                            {
                                note.DealAccountID = dealdc.DealAccountID;
                            }

                            //create list of liability note asset mapping
                            List<LiabilityNoteAssetMapping> LiabilityAssetMap = new List<LiabilityNoteAssetMapping>();
                            LiabilityAssetMap = dealdc.ListLiabilityNoteAssetMapping.FindAll(x => x.LiabilityNoteId == note.LiabilityNoteID);

                            if (note.IsDeleted == true)
                            {
                                lnl.DeleteLiabilityNote(note.LiabilityNoteAccountID);
                            }
                            else if (note.IsDeleted == false)
                            {
                                lnl.InsertUpdateLiabilityNote(note, userid, LiabilityAssetMap);
                            }
                            //lnl.InsertUpdatedLiabilityNoteAssetMapping(dealdc.ListLiabilityNoteAssetMapping, userid);
                        }
                    }
                }


            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Route("api/deal/getAllTagNameXIRR")]
        public IActionResult GetAllTagNameXIRR()
        {
            GenericResult _authenticationResult = null;
            TagXIRRLogic tagXIRRLogic = new TagXIRRLogic();
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            DataTable dt = tagXIRRLogic.GetAllNoteTagsXIRR(headerUserID);


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
                Log.WriteLogException(CRESEnums.Module.Account.ToString(), "Error occurred in GetAllTags", "", "", ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/deal/getXIRROutputByObjectID")]
        public IActionResult GetXIRROutputByObjectID([FromBody] string DealAccountID)
        {
            GenericResult _authenticationResult = null;
            IEnumerable<string> headerValues;

            var headerUserID = string.Empty;
            TagXIRRLogic TagXIRRLogic = new TagXIRRLogic();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DataTable dt = new DataTable();
            DataTable dtCalcReq = new DataTable();
            try
            {
                dt = TagXIRRLogic.GetXIRROutputByObjectID("Deal", DealAccountID);
                //  dtCalcReq = TagXIRRLogic.GetXIRRCalculationStatusByObjectID(DealAccountID, headerUserID);
                if (dt.Rows.Count > 0 || dtCalcReq.Rows.Count > 0)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Succeeded",
                        dt = dt,
                        dtCalcReq = dtCalcReq
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "No Data."
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


        //[HttpPost]
        //[Services.Controllers.IsAuthenticate]
        //[Services.Controllers.DeflateCompression]
        //[Route("api/deal/getXIRRViewNotesByObjectID")]
        //public IActionResult GetXIRRViewNotesByObjectID([FromBody] XIRRCalculationRequestsDataContract requestdata)
        //{
        //    GenericResult _authenticationResult = null;
        //    IEnumerable<string> headerValues;

        //    var headerUserID = string.Empty;
        //    TagXIRRLogic TagXIRRLogic = new TagXIRRLogic();
        //    if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
        //    {
        //        headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
        //    }
        //    DataTable dt = new DataTable();
        //    try
        //    {
        //        dt = TagXIRRLogic.GetXIRRViewNotesByObjectID(requestdata.ObjectID, requestdata.XIRRConfigID);
        //        if (dt.Rows.Count > 0)
        //        {
        //            _authenticationResult = new GenericResult()
        //            {
        //                Succeeded = true,
        //                Message = "Succeeded",
        //                dt = dt
        //            };
        //        }
        //        else
        //        {
        //            _authenticationResult = new GenericResult()
        //            {
        //                Succeeded = true,
        //                Message = "No Data."
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
        [Route("api/deal/GetXIRRCalculationStatusByObjectID")]
        public IActionResult GetXIRRCalculationStatusByObjectID([FromBody] string DealAccountID)
        {
            GenericResult _authenticationResult = null;
            IEnumerable<string> headerValues;

            var headerUserID = string.Empty;
            TagXIRRLogic TagXIRRLogic = new TagXIRRLogic();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DataTable dtCalcReq = new DataTable();
            try
            {

                dtCalcReq = TagXIRRLogic.GetXIRRCalculationStatusByObjectID(DealAccountID, headerUserID);
                if (dtCalcReq.Rows.Count > 0)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Succeeded",
                        dtCalcReq = dtCalcReq
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "No Data."
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
        [Route("api/deal/GetAutoDistributeWriteoffByDealID")]
        public IActionResult GetAutoDistributeWriteoffByDealID([FromBody] DealDataContract deal)
        {
            GenericResult _authenticationResult = null;
            List<AutoDistributeWriteoffDataContract> _autodistributewriteoff = new List<AutoDistributeWriteoffDataContract>();
            IEnumerable<string> headerValues;


            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            _autodistributewriteoff = dealLogic.GetAutoDistributeWriteoffByDealID(new Guid(deal.DealID.ToString()));
            try
            {
                if (_autodistributewriteoff != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        _autodistributewriteoff = _autodistributewriteoff
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
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in GetAutoDistributeWriteoffByDealID : Deal ID " + deal.CREDealID, deal.DealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/deal/autodistributePrincipalWriteoff")]
        public IActionResult AutoDistributePrincipalWriteoff([FromBody] PrincipalWriteoffDataContract _principalwriteoff)
        {
            GenericResult _authenticationResult = null;
            var headerUserID = string.Empty;
            LoggerLogic Log = new LoggerLogic();
            PrincipalWriteoffDataContract PrincipalWriteoffData = new PrincipalWriteoffDataContract();
            try
            {
                if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
                {
                    headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
                }
                //var json = JsonConvert.SerializeObject(_principalwriteoff);
                PrincipalWriteoffHelper pw = new PrincipalWriteoffHelper();
                PrincipalWriteoffData = pw.StartCalculation(_principalwriteoff);
                if (PrincipalWriteoffData.GenerationExceptionMessage == "" || PrincipalWriteoffData.GenerationExceptionMessage == null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Principal Write-off auto distributed successfully",
                        PrincipalWriteoffData = PrincipalWriteoffData
                    };
                }
                else
                {
                    Log.WriteLogExceptionMessage(CRESEnums.Module.Deal.ToString(), "Error occured in AutoDistributePrincipalWriteoff : Deal ID " + _principalwriteoff.DealID + PrincipalWriteoffData.GenerationExceptionMessage, _principalwriteoff.DealID, headerUserID.ToString(), "AutoDistributePrincipalWriteoff", PrincipalWriteoffData.GenerationExceptionMessage);
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Principal Write-off auto distribution Failed.",
                    };
                }

            }
            catch (Exception ex)
            {

                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in AutoDistributePrincipalWriteoff : Deal ID " + _principalwriteoff.DealID + PrincipalWriteoffData.GenerationExceptionMessage, _principalwriteoff.DealID, headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = "Principal Write-off auto distribution Failed.",
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/GetDealRelationshipByDealID")]
        public IActionResult GetDealRelationshipByDealID([FromBody] string dealID)
        {
            GenericResult _authenticationResult = null;
            List<DealRelationshipDataContract> _dealRelationship = new List<DealRelationshipDataContract>();
            IEnumerable<string> headerValues;

            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            _dealRelationship = dealLogic.GetDealRelationshipByDealID(new Guid(dealID));
            try
            {
                if (_dealRelationship != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        _dealRelationship = _dealRelationship
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
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in GetAutoDistributeWriteoffByDealID : Deal ID " + dealID, dealID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/deal/PrepaymentNoteSetupByDealID")]
        public IActionResult GetPrepaymentNoteSetupByDealID([FromBody] string DealID)
        {
            GenericResult _authenticationResult = null;
            DealLogic dealLogic = new DealLogic();
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            DataTable dt = dealLogic.GetPrepaymentNoteSetupByDealID(new Guid(DealID));
            if (dt.Rows.Count == 0)
            {
                DataRow dr = dt.NewRow();
                dt.Rows.Add(dr);
            }

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
                Log.WriteLogException(CRESEnums.Module.Account.ToString(), "Error occurred in Get Prepayment NoteSetupByDealID", "", "", ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/deal/PrepaymentGroupByDealID")]
        public IActionResult GetPrepaymentGroupByDealID([FromBody] string DealID)
        {
            GenericResult _authenticationResult = null;
            DealLogic dealLogic = new DealLogic();
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            DataTable dt = dealLogic.GetPrepaymentGroupByDealID(new Guid(DealID));
            if (dt.Rows.Count == 0)
            {
                DataRow dr = dt.NewRow();
                dt.Rows.Add(dr);
            }

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
                Log.WriteLogException(CRESEnums.Module.Account.ToString(), "Error occurred in Get Prepayment Group By DealID", "", "", ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/deal/getPayoffStatementFeesByDealID")]
        public IActionResult GetPayoffStatementFeesByDealID([FromBody] string DealID)
        {
            GenericResult _authenticationResult = null;
            DealLogic dealLogic = new DealLogic();
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            DataTable dt = dealLogic.GetPayoffStatementFeesDetailsByDealID(new Guid(DealID));
            if (dt.Rows.Count == 0)
            {
                PrepayPremiumLogic PrepayPremiumLogic = new PrepayPremiumLogic();
                dt = PrepayPremiumLogic.GetDefeaultDataForPayoffStatementFees(DealID);
            }

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
                Log.WriteLogException(CRESEnums.Module.Account.ToString(), "Error occurred in Get Prepayment Group By DealID", "", "", ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpGet]//http get as it return file 
        [Route("api/deal/downloadPayoffstatementexcel")]
        public async Task<IActionResult> DownloadPayoffStatementExcel(string ID, string ID1, string ID2)
        {

            LoggerLogic Log = new LoggerLogic();

            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            string fileName = "payoff";// + string.Format("{0:ddmmyyyhhmmss}", System.DateTime.Now);
                                       //string currentDirectorypath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot//ExcelTemplate");
            string currentDirectorypath = Path.Combine(System.IO.Directory.GetCurrentDirectory(), "wwwroot//ExcelTemplate/payoff.xlsx");

            DateTime parsedDate = DateTime.Parse(ID1);
            string formattedDate = parsedDate.ToString("MM-dd-yyyy");

            DataTable blobData = await GetCsvFromAzureBlobAsDataTable("PPOutputCF_" + ID + "_" + formattedDate + ".csv");

            if (blobData != null)
            {
                if (blobData.Columns.Contains("Column1"))
                {
                    blobData.Columns.Remove("Column1");
                }

                string dateColumnName = "Date";
                if (blobData.Columns.Contains(dateColumnName))
                {
                    foreach (DataRow row in blobData.Rows)
                    {
                        if (DateTime.TryParse(row[dateColumnName]?.ToString(), out DateTime dateValue))
                        {
                            row[dateColumnName] = dateValue.ToString("MM/dd/yyyy");
                        }
                    }
                }
            }

            string finalFileNameWithPath = string.Empty;
            String[,] tabName = new string[,] { { "Master", "Master" }, { "PrincipalPaydown", "Principal Paydown" }, { "AccruedInterest", "Accrued Interest" }, { "AccruedInterestForward", "Accrued Interest" }, { "ExitFee", "Exit Fee" }, { "UnusedFee", "Unused Fee" }, { "OriginationFee", "Origination Fee" }, { "PrepaymentPremium", "Prepayment Premium" }, { "MiscellaneousFees", "Miscellaneous Fees" }, { "EscrowsReserves", "Netting of Escrows/Reserves" } };
            int startRow = 29, startCol = 6;
            DateTime PayoffDate = Convert.ToDateTime(ID1);  //("06/06/2025");
            DateTime? ActualPayoffDate = null;
            if (ID2 != "null")
            {
                ActualPayoffDate = Convert.ToDateTime(ID2);
            }
            double gridTotal = 0, OverAllTotal = 0;

            try
            {
                PayoffLogic pfLogic = new PayoffLogic();
                string CurrentServicername = "";
                string srvnodename = "";

                var dataToExcel = pfLogic.GetPayoffAnalysisData(ID, PayoffDate, ActualPayoffDate);
                for (int tabIndex = 0; tabIndex < tabName.GetLength(0); tabIndex++)
                {
                    dataToExcel.Tables[tabIndex].TableName = tabName[tabIndex, 0];
                }

                var newFile = new FileInfo(currentDirectorypath);

                Log.WriteLogInfo("DownloadPayoffStatement", finalFileNameWithPath + " " + newFile.Exists, "", "", "DownloadPayoffStatement");

                //Step 1 : Create object of ExcelPackage class and pass file path to constructor.
                using (var package = new OfficeOpenXml.ExcelPackage(newFile))
                {
                    OfficeOpenXml.ExcelWorksheet worksheet = package.Workbook.Worksheets["ACORE Payoff Letter"];

                    DataTable masterdata = dataToExcel.Tables[0];

                    foreach (DataRow masterrow in masterdata.Rows)
                    {
                        worksheet.Cells[17, 6].Value = masterrow["Servicer"].ToString();
                        //worksheet.Cells[21, 6].Value = masterrow["SeniorNote"].ToString();
                        worksheet.Cells[22, 6].Value = masterrow["DealName"].ToString();
                        worksheet.Cells[17, 12].Value = CommonHelper.ToDateTimeStringFormat(masterrow["PayoffDate"]);
                        worksheet.Cells[19, 12].Value = CommonHelper.ToDateTimeStringFormat(masterrow["PayoffDate"]);
                        worksheet.Cells[22, 9].Value = masterrow["InvestorName"].ToString();


                        string vBorrowerName = masterrow["BorrowerName"].ToString();
                        var splitary = vBorrowerName.Split("|");

                        if (splitary != null)
                        {
                            int startindex = 23;
                            foreach (var item in splitary)
                            {
                                worksheet.Cells[startindex, 6].Value = item.ToString();
                                startindex = startindex + 1;
                            }
                        }


                        string vBorrowerAddress = masterrow["BorrowerAddress"].ToString();
                        var splitaryb = vBorrowerAddress.Split("|");

                        if (splitaryb != null)
                        {
                            int startindex = 21;
                            foreach (var item in splitaryb)
                            {
                                worksheet.Cells[startindex, 11].Value = item.ToString();
                                startindex = startindex + 1;
                            }
                        }

                        worksheet.Cells[19, 12].Value = CommonHelper.ToDateTimeStringFormat(masterrow["PayoffDate"]);
                        CurrentServicername = masterrow["ServicerName"].ToString();

                        if (CurrentServicername == "Berkadia Commercial Mortgage")
                        {
                            srvnodename = "Berkadia_Commercial_Mortgage";
                        }
                        else
                        {
                            srvnodename = "Trimont";
                        }

                        string configfilename = "PayOffConfiguration.json";
                        string currentDirectoryPath = Path.Combine(System.IO.Directory.GetCurrentDirectory(), "wwwroot//JSONTemplate//" + configfilename);
                        string jsonRequest = System.IO.File.ReadAllText(currentDirectoryPath);

                        var objJson = JsonConvert.DeserializeObject<dynamic>(jsonRequest);

                        var servicerinfo = objJson[srvnodename];

                        string vLoanServicer = objJson["LoanServicer"];
                        string vAttention = objJson["Attention"];
                        string vFooter = objJson["FooterText"];


                        worksheet.Cells[40, 4].Value = vLoanServicer.Replace("SERVICERINFORMATION", CurrentServicername);

                        worksheet.Cells[41, 5].Value = Convert.ToString(servicerinfo["PrimaryContact"]);
                        worksheet.Cells[42, 5].Value = Convert.ToString(servicerinfo["PrimaryPhone"]);
                        worksheet.Cells[43, 5].Value = Convert.ToString(servicerinfo["PrimaryEmail"]);
                        worksheet.Cells[46, 5].Value = Convert.ToString(servicerinfo["BackupContact"]);
                        worksheet.Cells[47, 5].Value = Convert.ToString(servicerinfo["BackupPhone"]);
                        worksheet.Cells[48, 5].Value = Convert.ToString(servicerinfo["BackupEmail"]);

                        string vWiringInstructions = objJson["WiringInstructions"];
                        worksheet.Cells[39, 8].Value = vWiringInstructions.Replace("SERVICERINFORMATION", CurrentServicername);

                        worksheet.Cells[40, 9].Value = Convert.ToString(servicerinfo["Bank"]);
                        worksheet.Cells[41, 9].Value = Convert.ToString(servicerinfo["Beneficiary"]);
                        worksheet.Cells[42, 9].Value = Convert.ToString(servicerinfo["AcctName"]);
                        worksheet.Cells[43, 9].Value = Convert.ToString(servicerinfo["ABANo"]);
                        worksheet.Cells[44, 9].Value = Convert.ToString(servicerinfo["AcctNo"]);
                        worksheet.Cells[45, 9].Value = vAttention.Replace("SERVICERILoanID", masterrow["ServicerID"].ToString());
                        worksheet.Cells["D36"].Value = vFooter.Replace("SERVICERINFORMATION", CurrentServicername);
                        string Disclaimer = Convert.ToString(servicerinfo["DisclaimerExtra"]) + Convert.ToString(objJson["Disclaimer"]);

                        Disclaimer = Disclaimer.Replace("SERVICERINFORMATION", CurrentServicername);
                        Disclaimer = Disclaimer.Replace("newline", "\r\n");

                        worksheet.Cells["H47"].Value = Disclaimer;
                    }


                    int tabIndex = 0, rowCount = 0, colCount = 0;
                    string excelSheetName, heading;
                    //Step 2 : Add a new worksheet to ExcelPackage object and give a suitable name
                    for (tabIndex = 1; tabIndex < tabName.GetLength(0) - 1; tabIndex++)
                    {
                        excelSheetName = tabName[tabIndex, 0];
                        heading = tabName[tabIndex, 1];
                        rowCount = dataToExcel.Tables[excelSheetName].Rows.Count;
                        colCount = dataToExcel.Tables[excelSheetName].Columns.Count;

                        if (((excelSheetName == "PrincipalPaydown" || excelSheetName == "MiscellaneousFees" || excelSheetName == "UnusedFee" || excelSheetName == "OriginationFee") && rowCount > 0) || ((excelSheetName == "AccruedInterest" || excelSheetName == "AccruedInterestForward" || excelSheetName == "ExitFee" || excelSheetName == "PrepaymentPremium") && rowCount > 1))
                        {

                            worksheet.InsertRow(startRow, rowCount + 3);

                            //set dates with header for Accrued Interest
                            string fullName = "";

                            if (heading == "Accrued Interest")
                            {
                                if (dataToExcel.Tables[excelSheetName].Rows.Count >= 2)
                                {
                                    DataRow secondRow = dataToExcel.Tables[excelSheetName].Rows[1]; // Index 1 = second row (0-based index)
                                    fullName = $"({secondRow["From"]}-{secondRow["Through"]})";
                                }
                            }

                            // Set custom heading (merged cell)
                            worksheet.Cells[startRow, startCol, startRow, startCol + 6].Merge = true;
                            worksheet.Cells[startRow, startCol, startRow, startCol].Value = heading + " " + fullName;
                            worksheet.Cells[startRow, startCol, startRow, startCol].Style.Font.Size = 12;
                            worksheet.Cells[startRow, startCol, startRow, startCol].Style.Font.Bold = true;
                            worksheet.Cells[startRow, startCol, startRow, startCol].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                            worksheet.Cells[startRow, startCol, startRow, startCol].Style.Fill.PatternType = ExcelFillStyle.Solid;
                            worksheet.Cells[startRow, startCol, startRow, startCol].Style.Fill.BackgroundColor.SetColor(Color.LightGray);

                            worksheet.Cells[startRow, startCol, startRow, startCol + 6].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                            worksheet.Cells[startRow, startCol, startRow, startCol + 6].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                            worksheet.Cells[startRow, startCol, startRow, startCol + 6].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                            worksheet.Cells[startRow, startCol, startRow, startCol + 6].Style.Border.Top.Style = ExcelBorderStyle.Thin;

                            worksheet.Cells[startRow + 1, startCol, startRow + 1, startCol].LoadFromDataTable(dataToExcel.Tables[excelSheetName], false, OfficeOpenXml.Table.TableStyles.None);

                            if (excelSheetName != "PrincipalPaydown" && excelSheetName != "MiscellaneousFees")
                            {
                                worksheet.Cells[startRow + 1, startCol, startRow + 1, startCol + colCount].Style.Font.Bold = true;
                                worksheet.Cells[startRow + 1, startCol, startRow + 1, startCol + colCount].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                            }

                            int rowTotal = startRow + rowCount + 1;
                            worksheet.Cells[startRow + 1, startCol + 6, rowTotal, startCol + 6].StyleID = worksheet.Cells["A1"].StyleID;
                            worksheet.Cells[rowTotal, startCol + 5].Value = heading + ":";
                            worksheet.Cells[rowTotal, startCol + 5, rowTotal, startCol + 6].Style.Font.Bold = true;
                            //worksheet.Cells[rowTotal, startCol + 6].Value = dataToExcel.Tables[excelSheetName].AsEnumerable().Sum(r => Double.Parse(r["Amount"].ToString())).Where;
                            gridTotal = dataToExcel.Tables[excelSheetName].AsEnumerable().Where(r => r["Amount"] != DBNull.Value && !string.IsNullOrWhiteSpace(r["Amount"].ToString())).Sum(r => Convert.ToDouble(r["Amount"]));
                            worksheet.Cells[rowTotal, startCol + 6].Value = gridTotal;
                            OverAllTotal = OverAllTotal + gridTotal;

                            worksheet.Cells[rowTotal, startCol].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                            worksheet.Cells[rowTotal, startCol, rowTotal, startCol + 6].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                            worksheet.Cells[rowTotal, startCol + 6].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                            worksheet.Cells[rowTotal, startCol, rowTotal, startCol + 6].Style.Border.Top.Style = ExcelBorderStyle.Thin;

                            worksheet.Cells[startRow, startCol, rowTotal, startCol].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                            worksheet.Cells[startRow, startCol + 6, rowTotal, startCol + 6].Style.Border.Right.Style = ExcelBorderStyle.Thin;

                            worksheet.Cells[startRow, startCol - 2, rowTotal + 1, startCol - 2].Style.Border.Left.Style = ExcelBorderStyle.Medium;
                            worksheet.Cells[startRow, startCol + 7, rowTotal + 1, startCol + 7].Style.Border.Right.Style = ExcelBorderStyle.Medium;

                            startRow = startRow + rowCount + 3;

                            //dataToExcel.Tables[excelSheetName].Rows.Count
                        }
                    }
                    worksheet.Cells[startRow, startCol + 5].Value = "Sub-Total: ";
                    worksheet.Cells[startRow, startCol + 6].Value = OverAllTotal;

                    worksheet.Cells[startRow, startCol + 6].StyleID = worksheet.Cells["A1"].StyleID;
                    worksheet.Cells[startRow, startCol + 5, startRow, startCol + 6].Style.Font.Name = "Arial Black";
                    worksheet.Cells[startRow, startCol + 5, startRow, startCol + 6].Style.Font.Size = 12;
                    worksheet.Cells[startRow, startCol + 5, startRow, startCol + 6].Style.Font.Bold = true;
                    worksheet.Cells[startRow, startCol + 5, startRow, startCol + 6].Style.Fill.PatternType = ExcelFillStyle.Solid;
                    worksheet.Cells[startRow, startCol + 5, startRow, startCol + 6].Style.Fill.BackgroundColor.SetColor(0, 255, 255, 153);

                    startRow = startRow + 2;

                    worksheet.InsertRow(startRow, 2);

                    excelSheetName = tabName[tabIndex, 0];
                    heading = tabName[tabIndex, 1];
                    rowCount = dataToExcel.Tables[excelSheetName].Rows.Count;
                    colCount = dataToExcel.Tables[excelSheetName].Columns.Count;

                    if (rowCount > 0)
                    {

                        worksheet.InsertRow(startRow, rowCount + 3);

                        worksheet.Cells[startRow, startCol, startRow, startCol + 6].Merge = true;
                        worksheet.Cells[startRow, startCol, startRow, startCol].Value = heading;
                        worksheet.Cells[startRow, startCol, startRow, startCol].Style.Font.Size = 12;
                        worksheet.Cells[startRow, startCol, startRow, startCol].Style.Font.Bold = true;
                        worksheet.Cells[startRow, startCol, startRow, startCol].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        worksheet.Cells[startRow, startCol, startRow, startCol].Style.Fill.PatternType = ExcelFillStyle.Solid;
                        worksheet.Cells[startRow, startCol, startRow, startCol].Style.Fill.BackgroundColor.SetColor(Color.LightGray);

                        worksheet.Cells[startRow, startCol, startRow, startCol + 6].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                        worksheet.Cells[startRow, startCol, startRow, startCol + 6].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                        worksheet.Cells[startRow, startCol, startRow, startCol + 6].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        worksheet.Cells[startRow, startCol, startRow, startCol + 6].Style.Border.Top.Style = ExcelBorderStyle.Thin;

                        worksheet.Cells[startRow + 1, startCol, startRow + 1, startCol].LoadFromDataTable(dataToExcel.Tables[excelSheetName], false, OfficeOpenXml.Table.TableStyles.None);

                        int rowTotal = startRow + rowCount + 1;
                        worksheet.Cells[startRow + 1, startCol + 6, rowTotal, startCol + 6].StyleID = worksheet.Cells["A1"].StyleID;
                        worksheet.Cells[rowTotal, startCol + 5].Value = heading + ":";
                        worksheet.Cells[rowTotal, startCol + 5, rowTotal, startCol + 6].Style.Font.Bold = true;
                        //worksheet.Cells[rowTotal, startCol + 6].Value = dataToExcel.Tables[excelSheetName].AsEnumerable().Sum(r => Double.Parse(r["Amount"].ToString())).Where;
                        gridTotal = dataToExcel.Tables[excelSheetName].AsEnumerable().Where(r => r["Amount"] != DBNull.Value && !string.IsNullOrWhiteSpace(r["Amount"].ToString())).Sum(r => Convert.ToDouble(r["Amount"]));
                        worksheet.Cells[rowTotal, startCol + 6].Value = gridTotal;
                        OverAllTotal = OverAllTotal - gridTotal;

                        worksheet.Cells[rowTotal, startCol].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                        worksheet.Cells[rowTotal, startCol, rowTotal, startCol + 6].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                        worksheet.Cells[rowTotal, startCol + 6].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        worksheet.Cells[rowTotal, startCol, rowTotal, startCol + 6].Style.Border.Top.Style = ExcelBorderStyle.Thin;

                        worksheet.Cells[startRow, startCol, rowTotal, startCol].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                        worksheet.Cells[startRow, startCol + 6, rowTotal, startCol + 6].Style.Border.Right.Style = ExcelBorderStyle.Thin;

                        worksheet.Cells[startRow, startCol - 2, rowTotal + 1, startCol - 2].Style.Border.Left.Style = ExcelBorderStyle.Medium;
                        worksheet.Cells[startRow, startCol + 7, rowTotal + 1, startCol + 7].Style.Border.Right.Style = ExcelBorderStyle.Medium;

                        startRow = startRow + rowCount + 3;

                    }

                    worksheet.Cells[startRow, startCol + 6].StyleID = worksheet.Cells["A1"].StyleID;
                    worksheet.Cells[startRow, startCol + 5].Value = "Total Amount Due: ";
                    worksheet.Cells[startRow, startCol + 6].Value = OverAllTotal;

                    worksheet.Cells[startRow, startCol + 5, startRow, startCol + 6].Style.Font.Name = "Arial Black";
                    worksheet.Cells[startRow, startCol + 5, startRow, startCol + 6].Style.Font.Size = 12;
                    worksheet.Cells[startRow, startCol + 5, startRow, startCol + 6].Style.Font.Bold = true;
                    worksheet.Cells[startRow, startCol + 5, startRow, startCol + 6].Style.Fill.PatternType = ExcelFillStyle.Solid;
                    worksheet.Cells[startRow, startCol + 5, startRow, startCol + 6].Style.Fill.BackgroundColor.SetColor(0, 255, 255, 153);

                    worksheet.Cells[startRow, startCol - 2, startRow + 1, startCol - 2].Style.Border.Left.Style = ExcelBorderStyle.Medium;
                    worksheet.Cells[startRow, startCol + 7, startRow + 1, startCol + 7].Style.Border.Right.Style = ExcelBorderStyle.Medium;

                    if (blobData != null)
                    {
                        DataTable dt = new DataTable();
                        dt.Columns.Add("Date", typeof(DateTime));
                        dt.Columns.Add("M61 Amount", typeof(double));
                        dt.Columns.Add("Type", typeof(string));
                        dt.Columns.Add("Fee Name", typeof(string));
                        dt.Columns.Add("Fee Type Name", typeof(string));
                        dt.Columns.Add("Note ID", typeof(string));
                        dt.Columns.Add("Interest Used in Calc", typeof(double));

                        foreach (DataRow row in blobData.Rows)
                        {
                            DateTime date = DateTime.MinValue;
                            double amount = 0.0;
                            string type = string.Empty;
                            string feename = string.Empty;
                            string feetype = string.Empty;
                            string noteid = string.Empty;
                            double InterestCalcAmt = 0.0;

                            if (DateTime.TryParse(row["Date"].ToString(), out DateTime parseDate))
                                date = parseDate;

                            if (double.TryParse(row["Amount"].ToString(), out double parsedAmount))
                                amount = parsedAmount;

                            type = row["Type"]?.ToString() ?? string.Empty;

                            feename = row["FeeName"]?.ToString() ?? string.Empty;

                            feetype = row["FeeTypeName"]?.ToString() ?? string.Empty;

                            noteid = row["noteid"]?.ToString() ?? string.Empty;

                            if (double.TryParse(row["spreadpaid"].ToString(), out double parsedInterest))
                                InterestCalcAmt = parsedInterest;

                            dt.Rows.Add(date, amount, type, feename, feetype, noteid, InterestCalcAmt);

                        }


                        var newWorksheet = package.Workbook.Worksheets["M61 Input"];
                        newWorksheet.Cells["A1"].LoadFromDataTable(dt, true, TableStyles.Medium2);

                    }

                    Byte[] fileBytes = package.GetAsByteArray();
                    MemoryStream ms = new MemoryStream(fileBytes);
                    return File(fileBytes, "application/octet-stream");
                }
            }
            catch (Exception ex)
            {

                Log.WriteLogException("DownloadPayoffStatement", "Error in DownloadPayoffStatement: For Deal ID " + ID, ID, headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                throw ex;
            }
        }


        public async Task<IActionResult> GeneratePayOffStatementandSendEmail()
        {
            GenericResult _authenticationResult = null;
            try
            {
                PrepayPremiumLogic prepayPremiumLogic = new PrepayPremiumLogic();
                DataTable dt = prepayPremiumLogic.GetPayoffEmailData();

                string DealID = "";
                string PrePayDate = "";
                string maturityActualPayoffDate = "null";
                string EmailID = "";
                string CalculationRequestID = "";
                string DealName = "";
                string UserName = "";

                foreach (DataRow row in dt.Rows)
                {
                    CalculationRequestID = row["CalculationRequestID"].ToString();
                    DealID = row["DealID"].ToString();
                    PrePayDate = row["PrepayDate"].ToString();
                    EmailID = row["Email"].ToString();
                    DealName = row["DealName"].ToString();
                    UserName = row["FirstName"].ToString();

                    string Filename = "Payoff Analysis_" + DealName + "_" + DateTime.Now.ToString("mm.dd.yyyy.hhss") + ".xlsx";
                    DateTime dtprepay = Convert.ToDateTime(PrePayDate);
                    string summary = "Please find the attached Payoff Statement for Deal " + DealName + " for Prepay Date " + dtprepay.ToString("MM/dd/yyy");
                    var result = await DownloadPayoffStatementExcel(DealID, PrePayDate, maturityActualPayoffDate);

                    if (result is FileContentResult fileResult)
                    {
                        using (var memoryStream = new MemoryStream(fileResult.FileContents))
                        {
                            _iEmailNotification.SendEmailforPrepayPayOffStatementwithAttachment(EmailID, memoryStream, Filename, DealName, UserName, summary);
                        }

                        prepayPremiumLogic.UpdateCalculationRequestSetIsEmailSentToYes(CalculationRequestID);
                    }
                }

                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Authentication succeeded"

                };
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Account.ToString(), "Error occurred in GeneratePayOffStatementandSendEmail", "", "", ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/deal/UpdateDealForPayoffStatementConfiguration")]
        public IActionResult UpdateDealForPayoffStatementConfiguration([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            DealLogic dealLogic = new DealLogic();

            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }


            dealLogic.UpdateDealForPayoffStatementConfiguration(DealDC);

            if (DealDC.dtPayoffStatementFees != null)
            {
                foreach (DataRow dr in DealDC.dtPayoffStatementFees.Rows)
                {
                    dr["DealID"] = DealDC.DealID;
                    if (dr["PayoffStatementFeesID"] == null || dr["PayoffStatementFeesID"].ToString() == "")
                    {
                        dr["PayoffStatementFeesID"] = 0;
                    }
                }
                dealLogic.InsertUpdatePayoffStatementFees(DealDC.dtPayoffStatementFees, headerUserID);
            }


            try
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Saved"

                };
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Account.ToString(), "Error occurred in UpdateDealForPayoffStatementConfiguration", "", "", ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/deal/PrepaymentNoteAllocationSetup")]
        public IActionResult GetPrepaymentNoteAllocationSetup([FromBody] string DealID)
        {
            GenericResult _authenticationResult = null;
            DealLogic dealLogic = new DealLogic();
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            DataTable dt = dealLogic.GetPrepaymentNoteAllocationSetup(new Guid(DealID));
            if (dt.Rows.Count == 0)
            {
                DataRow dr = dt.NewRow();
                dt.Rows.Add(dr);
            }

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
                Log.WriteLogException(CRESEnums.Module.Account.ToString(), "Error occurred in Get Prepayment Group By DealID", "", "", ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/deal/CalcDealForAnalysisID")]
        public IActionResult CalcDealForAnalysisID([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            try
            {
                var headerUserID = string.Empty;
                if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
                {
                    headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
                }

                GetConfigSetting();
                DealLogic dealLogic = new DealLogic();

                dealLogic.CallDealForCalculation(DealDC.DealID.ToString(), headerUserID, DealDC.AnalysisID, 775);
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Deal submitted for calculation successfully."
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
        [Route("api/deal/CheckAndSendPayoffEmail")]
        public async Task<IActionResult> CheckAndPayoffEmail()
        {
            v1GenericResult _authenticationResult = null;
            PrepayPremiumLogic PrepayPremiumLogic = new PrepayPremiumLogic();
            int count = PrepayPremiumLogic.GetPayoffEmailToSendCount();

            if (count > 0)
            {
                await GeneratePayOffStatementandSendEmail();
            }
            try
            {
                _authenticationResult = new v1GenericResult()
                {
                    Succeeded = true,
                    Message = "Succeeded",

                };
            }
            catch (Exception ex)
            {
                _authenticationResult = new v1GenericResult()
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
        [Route("api/deal/GetAllReserveAccountMaster")]
        public IActionResult GetAllReserveAccountMaster()
        {
            GenericResult _authenticationResult = null;

            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            List<ReserveAccountMasterDataContract> lslist = new List<ReserveAccountMasterDataContract>();
            DealLogic dealLogic = new DealLogic();

            lslist = dealLogic.GetAllReserveAccountMaster(headerUserID);

            try
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Authentication succeeded",
                    lstReserveAccountMaster = lslist
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
        [Route("api/deal/UpdateReserveAccountFromBackshop")]
        public IActionResult UpdateReserveAccountFromBackshop([FromBody] ReserveAccountSyncDataContract DealDC)
        {
            GenericResult _authenticationResult = null;

            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            DealLogic dealLogic = new DealLogic();
            try
            {
                dealLogic.UpdateReserveAccountFromBackshop(DealDC, headerUserID.ToString());
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



        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Route("api/deal/GetAccountingBasisByDealID")]
        public IActionResult GetAccountingBasisByDealID([FromBody] string DealID)
        {
            GenericResult _authenticationResult = null;

            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            DealLogic dealLogic = new DealLogic();
            try
            {
                DataTable dt = dealLogic.GetAccountingBasisByDealID(new Guid(DealID));

                //if (dt != null )
                //{

                //    foreach (DataRow row in dt.Rows)
                //    {
                //        string noteId = row["NoteID"].ToString();

                //        foreach (DataRow dtNetCapitalInvestedrow in dt.Rows)
                //        {
                //            string dtNetCapitalInvestedNoteId = dtNetCapitalInvestedrow["NoteID"].ToString();
                //            if (noteId == dtNetCapitalInvestedNoteId)
                //            {
                //                decimal? NetCapitalInvested = CommonHelper.StringToDecimalWithNull(dtNetCapitalInvestedrow["NetCapitalInvested"]);

                //                row["NetCapitalInvested"] = NetCapitalInvested.HasValue ? (object)NetCapitalInvested.Value : DBNull.Value;


                //                break;
                //            }
                //        }
                //    }

                //}
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Authentication succeeded",
                    dt = dt
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

        private async Task<DataTable> GetCsvFromAzureBlobAsDataTable(string fileName)
        {
            GetConfigSetting();
            var containerName = Sectionroot.GetSection("storage:container:name").Value;
            var blobClient = BlobUtilities.GetBlobClient;
            CloudBlobContainer container = blobClient.GetContainerReference(containerName);

            // Reference the "CalcDebug" folder
            CloudBlobDirectory blobDirectory = container.GetDirectoryReference("CalcDebug");
            CloudBlockBlob blockBlob = blobDirectory.GetBlockBlobReference(fileName);

            bool exists = await blockBlob.ExistsAsync();
            if (!exists)
            {
                return null;
            }

            using (MemoryStream memStream = new MemoryStream())
            {
                await blockBlob.DownloadToStreamAsync(memStream);
                memStream.Position = 0;

                using (StreamReader reader = new StreamReader(memStream))
                {
                    DataTable dt = new DataTable();
                    bool isHeader = true;

                    while (!reader.EndOfStream)
                    {
                        string line = await reader.ReadLineAsync();
                        string[] fields = line.Split(',');

                        if (isHeader)
                        {
                            foreach (var header in fields)
                                dt.Columns.Add(header.Trim());
                            isHeader = false;
                        }
                        else
                        {
                            dt.Rows.Add(fields);
                        }
                    }

                    return dt;
                }
            }
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/deal/ImportDealFromBackshopByCREDealId")]
        public IActionResult ImportDealFromBackshopByCREDealId([FromBody] DealDataContract DealDC)
        {
            GenericResult _authenticationResult = null;
            string creDealID = DealDC.CREDealID;

            DealLogic dealLogic = new DealLogic();

            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            try
            {
                DataTable dt = dealLogic.ImportDealFromBackshopByCREDealId(creDealID, headerUserID.ToString());
                if (dt.Rows.Count > 0)
                {
                    DataRow dr = dt.Rows[0];
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        allowImport = Convert.ToInt32(dr[0]),
                        Validationstring = Convert.ToString(dr[1])
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
        [Route("api/deal/GetFinancingCommitmentByDealID")]
        public IActionResult GetFinancingCommitmentByDealID([FromBody] string DealId)
        {
            GenericResult _authenticationResult = null;
            
            DealLogic dealLogic = new DealLogic();
            DataTable dt = dealLogic.GetFinancingCommitmentByDealID(DealId);

            try
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Authentication succeeded",
                    dt = dt
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