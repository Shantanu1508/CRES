using CRES.BusinessLogic;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Hosting;
using System.IO;
using CRES.DataContract;
using System.Collections.Generic;
using System;
using System.Linq;
using CRES.Utilities;
using System.Data;
using System.Threading;
using System.Reflection;


namespace CRES.ServiceMVC.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class LiabilityNoteController : ControllerBase
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

        private readonly IEmailNotification _iEmailNotification;
        private string useridforSys_Scheduler = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";

        public LiabilityNoteController(IEmailNotification iemailNotification, IHostingEnvironment env)
        {
            _iEmailNotification = iemailNotification;
            _env = env;
        }

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/liabilityNote/getallLookup")]
        public IActionResult GetAllLookup()
        {

            string getAllLookup = "1,51,19,25,32,95,151,150";
            GenericResult _authenticationResult = null;
            List<LookupDataContract> lstlookupDC = new List<LookupDataContract>();
            List<FeeSchedulesConfigDataContract> lstFeeSchedulesConfigDataContract = new List<FeeSchedulesConfigDataContract>();
            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            LookupLogic lookupLogic = new LookupLogic();
            lstlookupDC = lookupLogic.GetAllLookups(getAllLookup);
            lstlookupDC = lstlookupDC.OrderBy(x => x.SortOrder).ToList();

            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
            NoteLogic _noteLogic = new NoteLogic();
            lstFeeSchedulesConfigDataContract = _noteLogic.GetAllFeeTypesFromFeeSchedulesConfigLiability();

            try
            {
                if (lstlookupDC != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstLookups = lstlookupDC,
                        lstFeeTypeLookUp = lstFeeSchedulesConfigDataContract
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
        [Route("api/liabilityNote/InsertUpdateLiabilityNote")]
        public IActionResult InsertUpdateLiabilityNote([FromBody] LiabilityNoteDataContract note)
        {
            LoggerLogic Log = new LoggerLogic();
            GenericResult _authenticationResult = null;
            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            string actiontype = "";
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            LiabilityNoteLogic LiabilityNotlogic = new LiabilityNoteLogic();
            if (note.LiabilityTypeID == null)
            {
                note.LiabilityTypeID = new Guid();
            }
            if (note.LiabilityNoteAutoID == null)
            {
                note.LiabilityNoteAutoID = 0;
                actiontype = "Insert";
            }
            if (note.OriginalLiabilityNoteID != note.LiabilityNoteID && actiontype == "")
            {
                actiontype = "Update";
            }

            string res = LiabilityNotlogic.InsertUpdateLiabilityNote(note, headerUserID, note.LiabilityAssetMap);

            string LiabilityNoteAccountID = res;
            if (note.ListLiabilityRate != null)
            {
                foreach (var item in note.ListLiabilityRate)
                {
                    item.LiabilityNoteAccountID = LiabilityNoteAccountID;

                    if (item.AdditionalAccountID == null)
                    {
                        item.AdditionalAccountID = "00000000-0000-0000-0000-000000000000";
                    }
                }
            }
            if (note.FeeScheduleList != null)
            {
                foreach (var item in note.FeeScheduleList)
                {
                    item.AccountID = LiabilityNoteAccountID;

                    if (item.AdditionalAccountID == null)
                    {
                        item.AdditionalAccountID = "00000000-0000-0000-0000-000000000000";
                    }
                }
            }
            if (note.ListInterestExpense != null)
            {
                foreach (var item in note.ListInterestExpense)
                {
                    item.DebtAccountID = new Guid(LiabilityNoteAccountID);

                    if (item.AdditionalAccountID == null)
                    {
                        item.AdditionalAccountID = new Guid("00000000-0000-0000-0000-000000000000");
                    }
                }
            }

            LiabilityNotlogic.InsertUpdateLiabilityRateSpreadSchedule(note.ListLiabilityRate, headerUserID);
            LiabilityNotlogic.InsertUpdatedLiabilityFeeSchedule(note.FeeScheduleList, headerUserID);
            LiabilityNotlogic.InsertUpdateInterestExpenseSchedule(note.ListInterestExpense, headerUserID);
            LiabilityNotlogic.InsertPrepayAndAdditionalFeeScheduleLiabilityDetail(note.ListPrepayAndAdditionalFeeScheduleLiabilityDetail, headerUserID);

            if (actiontype != "")
            {
                Thread SecondThread = new Thread(() => InsertUpdateAIEntities(note.LiabilityNoteID, headerUserID, actiontype, note.OriginalLiabilityNoteID));
                SecondThread.Start();
            }
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
                string message = ExceptionHelper.GetFullMessage(ex);
                Log.WriteLogException(CRESEnums.Module.LiabilityNote.ToString(), "Error in InsertUpdateLiabilityNote: Note ID " + note.LiabilityName, note.LiabilityNoteGUID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);
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
        [Route("api/liabilityNote/getLiabilityNoteByLiabilityNoteID")]
        public IActionResult GetLiabilityNoteByLiabilityNoteID([FromBody] string LiabilityNoteGUID)
        {

            GenericResult _authenticationResult = null;
            LiabilityNoteDataContract LiabilityNote = new LiabilityNoteDataContract();
            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
            LiabilityNote = LiabilityNotelogic.GetLiabilityNoteByLiabilityNoteID(new Guid(LiabilityNoteGUID.ToString()));
            List<LookupDataContract> lstSearch = LiabilityNotelogic.GetAllLiabilityTypeLookup();
            List<LookupDataContract> lstDebtEquityType = LiabilityNotelogic.GetDebtEquityTypeList();

            try
            {
                if (LiabilityNote != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstLiabilityNote = LiabilityNote,
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
                Log.WriteLogException(CRESEnums.Module.LiabilityNote.ToString(), "Error in GetLiabilityNoteByLiabilityNoteID: Note ID " + LiabilityNoteGUID, LiabilityNoteGUID, headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);
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
        [Route("api/search/getAutosuggestDebtAndEquityName")]
        public IActionResult GetAutosuggestDebtAndEquityName([FromBody] string searchkey)
        {
            GenericResult _auctionResult = null;
            List<SearchDataContract> lstSearchResult = new List<SearchDataContract>();
            IEnumerable<string> headerValues;
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
            lstSearchResult = LiabilityNotelogic.GetAutosuggestDebtAndEquityName(searchkey);

            try
            {
                if (lstSearchResult != null)
                {
                    _auctionResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstSearch = lstSearchResult
                    };
                }
                else
                {
                    _auctionResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                _auctionResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_auctionResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/search/GetAutosuggestBankerName")]
        public IActionResult GetAutosuggestBankerName([FromBody] string searchkey)
        {
            GenericResult _actionResult = null;
            List<SearchDataContract> lstSearchResult = new List<SearchDataContract>();
            IEnumerable<string> headerValues;
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
            lstSearchResult = LiabilityNotelogic.GetAutosuggestBankerName(searchkey);

            try
            {
                if (lstSearchResult != null)
                {
                    _actionResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstSearch = lstSearchResult
                    };
                }
                else
                {
                    _actionResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                _actionResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_actionResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/liabilityNote/getLiabilityFundingScheduleByDealAccountID")]
        public IActionResult GetLiabilityFundingScheduleByDealAccountID([FromBody] string DealAccountID)
        {

            GenericResult _authenticationResult = null;
            List<LiabilityFundingScheduleDataContract> ListLiabilityFundingScheduleDataContract = new List<LiabilityFundingScheduleDataContract>();
            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
            ListLiabilityFundingScheduleDataContract = LiabilityNotelogic.GetLiabilityFundingScheduleByDealAccountID(DealAccountID);


            try
            {
                if (ListLiabilityFundingScheduleDataContract != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        ListLiabilityFundingSchedule = ListLiabilityFundingScheduleDataContract
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
        [Route("api/liabilityNote/getAssetListByDealAccountID")]
        public IActionResult GetAssetListByDealAccountID([FromBody] string DealAccountID)
        {

            GenericResult _authenticationResult = null;
            List<LookupDataContract> AssetList = new List<LookupDataContract>();
            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
            AssetList = LiabilityNotelogic.GetAssetListByDealAccountID(DealAccountID.ToString());
            DataTable DealInfo = LiabilityNotelogic.GetDealInfoByDealAccountID(DealAccountID.ToString());

            List<LiabilityNoteAssetMapping> LNoteAssetMap = LiabilityNotelogic.GetLiabilityNoteAssetMappingByDealAccountID(DealAccountID.ToString());

            try
            {
                if (AssetList != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        AssetList = AssetList,
                        LNoteAssetMap = LNoteAssetMap,
                        DealInfo = DealInfo
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
        [Route("api/liabilityNote/getLiabilityFundingScheduleByLiabilityTypeID")]
        public IActionResult GetLiabilityFundingScheduleByLiabilityTypeID([FromBody] string LiabilityTypeID)
        {

            GenericResult _authenticationResult = null;
            List<LiabilityFundingScheduleDataContract> ListLiabilityFundingScheduleDataContract = new List<LiabilityFundingScheduleDataContract>();

            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
            if (LiabilityTypeID != null && LiabilityTypeID != "" && LiabilityTypeID != "00000000-0000-0000-0000-000000000000")
            {
                ListLiabilityFundingScheduleDataContract = LiabilityNotelogic.GetLiabilityFundingScheduleByLiabilityTypeID(LiabilityTypeID);


            }

            try
            {
                if (ListLiabilityFundingScheduleDataContract != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        ListLiabilityFundingSchedule = ListLiabilityFundingScheduleDataContract
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
                Log.WriteLogException(CRESEnums.Module.LiabilityNote.ToString(), "Error in GetLiabilityFundingScheduleByLiabilityTypeID: Note ID " + LiabilityTypeID, LiabilityTypeID, headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);
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
        [Route("api/liabilityNote/GetLiabilityRateSpreadScheduleByNoteAccountID")]
        public IActionResult GetLiabilityRateSpreadScheduleByNoteAccountID([FromBody] string LiabilityAccountID)
        {

            GenericResult _authenticationResult = null;
            List<LiabilityRateSpreadDataContract> LiabilityRate = new List<LiabilityRateSpreadDataContract>();
            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            List<ScheduleEffectiveDateLiabilityDataContract> ListEffectiveDateCount = new List<ScheduleEffectiveDateLiabilityDataContract>();

            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
            LiabilityRate.Add(new LiabilityRateSpreadDataContract());
            LiabilityRate = LiabilityNotelogic.GetLiabilityRateSpreadScheduleByNoteAccountID(LiabilityAccountID.ToString(), null);
            ListEffectiveDateCount = LiabilityNotelogic.GetScheduleEffectiveDateCount(new Guid(LiabilityAccountID), null);

            if (LiabilityRate == null)
            {
                LiabilityRateSpreadDataContract r1 = new LiabilityRateSpreadDataContract();
                r1.Value = 0;
                LiabilityRate.Add(r1);
            }
            try
            {
                if (LiabilityRate != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        ListLiabilityRate = LiabilityRate,
                        ListEffectiveDateCount = ListEffectiveDateCount
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
                Log.WriteLogException(CRESEnums.Module.LiabilityNote.ToString(), "Error in GetLiabilityRateSpreadScheduleByNoteAccountID: Note ID ", LiabilityAccountID, headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/liabilityNote/GetHistoricalDataOfModuleByAccountId_Liability")]
        public IActionResult GetHistoricalDataOfModuleByAccountId_Liability([FromBody] LiabilityNoteDataContract _noteDC, int? pageIndex, int? pageSize)
        {
            GenericResult _authenticationResult = null;

            string modulename = _noteDC.modulename;

            IEnumerable<string> headerValues;
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();

            try
            {
                bool flag = false;
                int? totalCount = 0;

                DataTable dtGeneralSetupDetailsLiabilityNote = new DataTable();
                DataTable dtRateSpreadSchedule = new DataTable();
                DataTable dtPrepayAndAdditionalFeeScheduleDataContract = new DataTable();
                DataTable dtInterestExpenseSchedule = new DataTable();

                switch (modulename)
                {
                    case "GeneralSetupDetailsLiabilityNote":

                        dtGeneralSetupDetailsLiabilityNote = LiabilityNotelogic.GetHistoricalDataOfModuleByNoteId(_noteDC.LiabilityNoteAccountID, headerUserID, modulename, null);
                        if (dtGeneralSetupDetailsLiabilityNote.Rows.Count > 0) flag = true;

                        break;

                    case "RateSpreadScheduleLiability":

                        dtRateSpreadSchedule = LiabilityNotelogic.GetHistoricalDataOfModuleByNoteId(_noteDC.LiabilityNoteAccountID, headerUserID, modulename, null);
                        if (dtRateSpreadSchedule.Rows.Count > 0) flag = true;

                        break;
                    case "PrepayAndAdditionalFeeScheduleLiability":

                        dtPrepayAndAdditionalFeeScheduleDataContract = LiabilityNotelogic.GetHistoricalDataOfModuleByNoteId(_noteDC.LiabilityNoteAccountID, headerUserID, modulename, null);
                        if (dtPrepayAndAdditionalFeeScheduleDataContract.Rows.Count > 0) flag = true;

                        break;
                    case "InterestExpenseSchedule":

                        dtInterestExpenseSchedule = LiabilityNotelogic.GetHistoricalDataOfModuleByNoteId(_noteDC.LiabilityNoteAccountID, headerUserID, modulename, null);
                        if (dtInterestExpenseSchedule.Rows.Count > 0) flag = true;

                        break;

                    default:
                        break;
                }

                if (flag)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        TotalCount = Convert.ToInt32(totalCount),
                        lstGeneralSetupDetailsLiabilityNote = dtGeneralSetupDetailsLiabilityNote,
                        lstRateSpreadSchedule = dtRateSpreadSchedule,
                        lstPrepayAndAdditionalFeeScheduleDataContract = dtPrepayAndAdditionalFeeScheduleDataContract,
                        lstInterestExpenseScheduleHistory = dtInterestExpenseSchedule
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
                Log.WriteLogException(CRESEnums.Module.LiabilityNote.ToString(), "Error in GetHistoricalDataOfModuleByAccountId_Liability: Note ID ", _noteDC.LiabilityNoteAccountID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);
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
        [Route("api/liabilityNote/checkduplicateforliabilities")]
        public IActionResult CheckDuplicateforLiabilities([FromBody] LiabilityNoteDataContract _noteDC)
        {
            GenericResult _authenticationResult = null;
            IEnumerable<string> headerValues;

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            string Status = "";
            string msg = "";

            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
            Status = LiabilityNotelogic.CheckDuplicateforLiabilities(_noteDC.LiabilityNoteID, _noteDC.modulename, _noteDC.LiabilityNoteAccountID);
            if (Status == "True")
            {
                msg = "Liability Note " + _noteDC.LiabilityNoteID + " already exist. Please enter unique Liability Note ID.";

            }
            else if (Status == "False")
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
        [Route("api/liabilityNote/GetTransactionEntryLiabilityNoteByDealAccountId")]
        public IActionResult GetTransactionEntryLiabilityNoteByDealAccountId([FromBody] string DealAccountID)
        {
            GenericResult _authenticationResult = null;
            DataTable dt = new DataTable();
            string AnalysisId = "c10f3372-0fc2-4861-a9f5-148f1f80804f";
            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            LiabilityNoteLogic _Logic = new LiabilityNoteLogic();
            dt = _Logic.GetTransactionEntryLiabilityNoteByDealAccountId(DealAccountID, AnalysisId);
            try
            {


                if (dt != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        LiabilityCashFlow = dt
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
                Log.WriteLogException(CRESEnums.Module.LiabilityNote.ToString(), "Error in GetTransactionEntryLiabilityNoteByDealAccountId: Note ID ", DealAccountID, headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Route("api/liabilityNote/getDealLiabilityCashflowsExportExcel")]
        public IActionResult GetDealLiabilityCashflowsExportExcel([FromBody] string DealAccountID)
        {
            GenericResult _authenticationResult = null;
            DataTable lstCashflowsExportData = new DataTable();
            var headerUserID = new Guid();
            string AnalysisId = "c10f3372-0fc2-4861-a9f5-148f1f80804f";

            try
            {
                if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
                {
                    headerUserID = new Guid(Request.Headers["TokenUId"]);
                }
                ;

                LiabilityNoteLogic _Logic = new LiabilityNoteLogic();
                lstCashflowsExportData = _Logic.GetDealLiabilityCashflowsExportExcel(DealAccountID, AnalysisId);

                foreach (DataColumn column in lstCashflowsExportData.Columns)
                {
                    column.ColumnName = column.ColumnName.Replace("_", " ");
                }

                // Export to excel
                DataSet ds = new DataSet();
                lstCashflowsExportData.TableName = "Cashflow";
                ds.Tables.Add(lstCashflowsExportData);

                Stream stream = new StreamReader(_env.WebRootPath + "/ExcelTemplate/" + "DealLiabilityCashflowDownload.xlsx").BaseStream;
                MemoryStream ms = WriteDataToExcel(ds, stream);
                return File(ms, "application/octet-stream");

            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.CashFlowDownload.ToString(), "Error occurred in cashflow download ", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
                return Ok(_authenticationResult);
            }

        }


        public void InsertUpdateAIEntities(string entity_names, string userid, string actiontype, string originalname)
        {
            AIDynamicEntityUpdateLogic _dynamicentity = new AIDynamicEntityUpdateLogic();
            _dynamicentity.InsertUpdateAIEntitiesAsync("LiabilityNoteID", entity_names, userid, actiontype, originalname);

        }


        public MemoryStream WriteDataToExcel(DataSet dsData, Stream strm)
        {

            DataTable dt = new DataTable();
            Stream TemplateMemoryStream = new MemoryStream();
            List<string> lstTemplateLines = new List<string>();
            try
            {
                using (var package = new OfficeOpenXml.ExcelPackage(strm))
                {

                    int iSheetsCount = 0;
                    try
                    {
                        iSheetsCount = package.Workbook.Worksheets.Count;
                    }
                    catch (Exception)
                    {
                        iSheetsCount = package.Workbook.Worksheets.Count;
                    }
                    if (iSheetsCount > 0)
                    {
                        for (int i = 0; i < iSheetsCount; i++)
                        {
                            OfficeOpenXml.ExcelWorksheet worksheet;
                            try
                            {
                                worksheet = package.Workbook.Worksheets[i];
                            }
                            catch (Exception)
                            {
                                worksheet = package.Workbook.Worksheets[i];
                            }

                            if (dsData.Tables[worksheet.Name] != null)
                            {
                                worksheet.Cells[1, 1].LoadFromDataTable(dsData.Tables[worksheet.Name], true);
                            }

                        }
                        Byte[] fileBytes = package.GetAsByteArray();
                        TemplateMemoryStream = new MemoryStream(fileBytes);
                    }
                }
                return (MemoryStream)TemplateMemoryStream;

            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.CashFlowDownload.ToString(), "Error detail(method: ReadAndUploadTemplateFile) :  ", "", "", ex.TargetSite.Name.ToString(), "", ex);

                throw ex;
            }
        }


        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/liabilityNote/getLiabilityFundingScheduleAggregateByLiabilityTypeID")]
        public IActionResult GetLiabilityFundingScheduleAggregateByLiabilityTypeID([FromBody] string LiabilityTypeID)
        {
            DebtLogic _DebtLogic = new DebtLogic();
            GenericResult _authenticationResult = null;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DataTable dt = _DebtLogic.GetLiabilityFundingScheduleAggregateByLiabilityTypeID(LiabilityTypeID);

            if (dt.Columns.Contains("StatusText"))
            {
                dt.Columns["StatusText"].ColumnName = "StatusName";
            }

            if (dt != null)
            {
                if (dt.Rows.Count == 0)
                {
                    DataRow data = dt.NewRow();
                    data["Applied"] = false;
                    dt.Rows.Add(data);
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
                Log.WriteLogException(CRESEnums.Module.LiabilityNote.ToString(), "Error in GetLiabilityFundingScheduleByLiabilityTypeID: Note ID " + LiabilityTypeID, LiabilityTypeID, headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);
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
        [Route("api/liabilityNote/getLiabilityFundingScheduleDetailByLiabilityID")]
        public IActionResult GetLiabilityFundingScheduleDetailByLiabilityID([FromBody] string LiabilityTypeID)
        {
            DebtLogic _DebtLogic = new DebtLogic();
            GenericResult _authenticationResult = null;

            List<LiabilityFundingScheduleDataContract> ListLiabilityFundingSchedule = new List<LiabilityFundingScheduleDataContract>();
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            ListLiabilityFundingSchedule = _DebtLogic.GetLiabilityFundingScheduleDetailByLiabilityTypeID(LiabilityTypeID);

            try
            {

                if (ListLiabilityFundingSchedule != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        ListLiabilityFundingSchedule = ListLiabilityFundingSchedule

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
                Log.WriteLogException(CRESEnums.Module.LiabilityNote.ToString(), "Error in GetLiabilityFundingScheduleByLiabilityTypeID: Note ID " + LiabilityTypeID, LiabilityTypeID, headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);
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
        [Route("api/liabilityNote/getLiabilityFundingScheduleDetailByLiabilityIDDateAndType")]
        public IActionResult getLiabilityFundingScheduleDetailByLiabilityIDDateAndType([FromBody] string LiabilityTypeID)
        {
            DebtLogic _DebtLogic = new DebtLogic();
            GenericResult _authenticationResult = null;

            var FilterData = LiabilityTypeID.Split("#");



            var TransactionTypes = FilterData[0];
            var Transdate = FilterData[1];
            var LiabilityID = FilterData[2];

            List<LiabilityFundingScheduleDataContract> ListLiabilityFundingSchedule = new List<LiabilityFundingScheduleDataContract>();
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            ListLiabilityFundingSchedule = _DebtLogic.GetLiabilityFundingScheduleDetailByFilter(LiabilityID, Transdate, TransactionTypes);

            try
            {

                if (ListLiabilityFundingSchedule != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        ListLiabilityFundingSchedule = ListLiabilityFundingSchedule

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
                Log.WriteLogException(CRESEnums.Module.LiabilityNote.ToString(), "Error in GetLiabilityFundingScheduleByLiabilityTypeID: Note ID " + LiabilityTypeID, LiabilityTypeID, headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Route("api/liabilityNote/saveLiabilityDataFromFileUpload")]
        public IActionResult saveLiabilityDataFromFileUpload([FromBody] dynamic LiabilityData)
        {
            v1GenericResult _authenticationResult = null;
            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            LiabilityNoteLogic lc = new LiabilityNoteLogic();
            List<LookupDataContract> lstlookupAccountCategory = new List<LookupDataContract>();
            List<LookupDataContract> lstlookupDC = new List<LookupDataContract>();

            string getAllLookup = "1,2,16,33,32,29,151";
            try
            {
                DataTable dtAccountCategory = lc.GetAccountCategoryList();
                foreach (DataRow dr in dtAccountCategory.Rows)
                {

                    LookupDataContract l = new LookupDataContract();
                    l.LookupID = CommonHelper.ToInt32_NotNullable(dr["LookupID"]);
                    l.Name = Convert.ToString(dr["Name"]);
                    l.AccountTypeId = Convert.ToString(dr["LiabilitiesType"]);

                    lstlookupAccountCategory.Add(l);

                }

                LookupLogic lookupLogic = new LookupLogic();
                lstlookupDC = lookupLogic.GetAllLookups(getAllLookup);

                var InvestorsJSON = LiabilityData["Investors"];
                var EquityJSON = LiabilityData["Equity"];
                var DebtRepoLineJSON = LiabilityData["DebtRepoLine"];
                var DealLibAdvRateJSON = LiabilityData["DealLibAdvRate"];
                var DealLiabilityJSON = LiabilityData["DealLiability"];
                var Trans11JSON = LiabilityData["Trans11"];

                DateTime Cutoffdate = CommonHelper.ToDateTime(LiabilityData["Cutoffdate"]);


                List<InvestorsDataContract> lstInvestors = new List<InvestorsDataContract>();

                List<EquityDataContract> lstEquity = new List<EquityDataContract>();
                List<DebtDataContract> lstDebt = new List<DebtDataContract>();
                List<DealLibAdvRateDataContract> lstDealLibAdvRate = new List<DealLibAdvRateDataContract>();
                List<LibDealLiabilityDataContract> lstDealLiability = new List<LibDealLiabilityDataContract>();
                List<Trans11DataContract> lst11Trans = new List<Trans11DataContract>();


                for (var i = 0; i < EquityJSON.Count; i++)
                {
                    EquityDataContract dd = new EquityDataContract();

                    dd.EquityName = EquityJSON[i].EquityName;
                    dd.AbbreviationName = EquityJSON[i].AbbreviationName;
                    dd.EquityType = lstlookupAccountCategory.Find(x => x.Name == Convert.ToString(EquityJSON[i].EquityType) && x.AccountTypeId == "Equity").LookupID;
                    dd.Status = 1;
                    dd.Currency = 187;
                    dd.InvestorCapital = CommonHelper.StringToDecimalWithRound(EquityJSON[i].InvestorCapital);
                    dd.CapitalReserveRequirement = CommonHelper.StringToDecimalWithRound(EquityJSON[i].CapitalReserveRequirement);
                    dd.ReserveRequirement = CommonHelper.StringToDecimalWithRound(EquityJSON[i].ReserveRequirement);
                    dd.CapitalCallNoticeBusinessDays = CommonHelper.ToInt32(EquityJSON[i].CapitalCallNoticeBusinessDays);
                    dd.InceptionDate = CommonHelper.ToDateTime(EquityJSON[i].InceptionDate);
                    dd.LastDatetoInvest = CommonHelper.ToDateTime(EquityJSON[i].LastDatetoInvest);
                    dd.LinkedShortTermBorrowingFacilityText = Convert.ToString(EquityJSON[i].LinkedShortTermBorrowingFacility);
                    dd.Commitment = CommonHelper.StringToDecimalWithRound(EquityJSON[i].Commitment);
                    dd.InitialMaturityDate = CommonHelper.ToDateTime(EquityJSON[i].InitialMaturityDate);

                    lstEquity.Add(dd);
                }

                EquityLogic el = new EquityLogic();
                string EquityAccountID = "";
                string currentEquityName = "";

                DebtLogic dl = new DebtLogic();
                Guid debtaccountid = new Guid();
                string reqtype = "";

                foreach (var item in lstEquity)
                {
                    currentEquityName = "";
                    EquityDataContract edc = el.GetEquityByEquityName(item.EquityName);
                    currentEquityName = item.EquityName;
                    if (edc != null && edc.EquityID != null)
                    {
                        item.EquityID = edc.EquityID;
                        item.EquityGUID = edc.EquityGUID;
                        item.EquityAccountID = edc.EquityAccountID;
                        EquityAccountID = item.EquityAccountID;
                        item.CashAccountID = edc.CashAccountID;
                    }
                    else
                    {
                        item.EquityID = 0;
                    }
                    if (item.LinkedShortTermBorrowingFacilityText != "")
                    {
                        DebtDataContract dc = dl.GetDebtByDebtID(item.LinkedShortTermBorrowingFacilityText);
                        if (dc != null && dc.DebtID != null)
                        {
                            item.LinkedShortTermBorrowingFacilityID = dc.DebtAccountID;
                        }
                    }

                    lc.DeleteLiabilityData_ForOneTimeUpload(Convert.ToString(EquityAccountID), "Equity");

                    el.InsertUpdateEquity_OnetimefromFile(CREConstants.useridforSys_Scheduler_GUID, item);
                }

                for (var i = 0; i < DebtRepoLineJSON.Count; i++)
                {
                    DebtDataContract dd = new DebtDataContract();
                    int? DebtType = null;
                    dd.DebtName = DebtRepoLineJSON[i].DebtName;

                    var res = lstlookupAccountCategory.Find(x => x.Name == Convert.ToString(DebtRepoLineJSON[i].DebtType) && x.AccountTypeId == "Debt");
                    if (res != null)
                    {
                        DebtType = res.LookupID;
                    }
                    else
                    {
                        DebtType = 2;
                    }

                    dd.AbbreviationName = DebtRepoLineJSON[i].DebtShortName;
                    dd.LinkedFundID = CommonHelper.ToGuid(EquityAccountID);
                    dd.DebtType = DebtType;
                    dd.Status = 1;
                    dd.Currency = 187;
                    dd.MatchTerms = GetLookupID(lstlookupDC, 2, Convert.ToString(DebtRepoLineJSON[i].MatchTerm));
                    dd.IsRevolving = GetLookupID(lstlookupDC, 2, Convert.ToString(DebtRepoLineJSON[i].Isrevolving));

                    dd.FundingNoticeBusinessDays = CommonHelper.ToInt32_NotNullable(DebtRepoLineJSON[i].FundingNoticeBusinessDays);
                    dd.InitialFundingDelay = CommonHelper.ToInt32_NotNullable(DebtRepoLineJSON[i].InitialFundingDelay);
                    dd.MaxAdvanceRate = CommonHelper.StringToDecimalWithRound(DebtRepoLineJSON[i].MaxAdvanceRate);
                    dd.TargetAdvanceRate = CommonHelper.StringToDecimalWithRound(DebtRepoLineJSON[i].TargetAdvanceRate);

                    dd.OriginationDate = CommonHelper.ToDateTime(DebtRepoLineJSON[i].OriginationDate);

                    dd.OriginationFees = CommonHelper.StringToDecimalWithRound(CommonHelper.StringToDecimalWithRound(DebtRepoLineJSON[i].OriginationFee));
                    dd.RateType = GetLookupID(lstlookupDC, 16, Convert.ToString(DebtRepoLineJSON[i].RateType));

                    dd.PaydownDelay = CommonHelper.ToInt32_NotNullable(DebtRepoLineJSON[i].PaydownDelay);
                    dd.EffectiveDate = CommonHelper.ToDateTime(DebtRepoLineJSON[i].EffectiveDate);
                    dd.Commitment = CommonHelper.StringToDecimalWithRound(DebtRepoLineJSON[i].Commitment);
                    dd.InitialMaturityDate = CommonHelper.ToDateTime(DebtRepoLineJSON[i].InitialMaturityDate);

                    dd.RoundingMethod = GetLookupID(lstlookupDC, 33, Convert.ToString(DebtRepoLineJSON[i].Roundingmethod));
                    dd.IndexRoundingRule = CommonHelper.ToInt32_NotNullable(DebtRepoLineJSON[i].IndexRoundingRule);
                    dd.PayFrequency = CommonHelper.ToInt32_NotNullable(DebtRepoLineJSON[i].PayFrequency);
                    dd.DefaultIndexName = GetLookupID(lstlookupDC, 32, Convert.ToString(DebtRepoLineJSON[i].DefaultIndexName));

                    lstDebt.Add(dd);
                }

                List<string> DistinctDebtname = lstDebt.Select(o => o.DebtName).Distinct().ToList();

                foreach (var dname in DistinctDebtname)
                {
                    reqtype = "";
                    DebtDataContract ddc = lstDebt.FirstOrDefault(x => x.DebtName == dname);
                    DebtDataContract dc = dl.GetDebtByDebtID(ddc.DebtName);
                    if (dc != null && dc.DebtID != null)
                    {
                        ddc.DebtAccountID = dc.DebtAccountID;
                        ddc.DebtID = dc.DebtID;
                        ddc.DebtGUID = dc.DebtGUID;
                        debtaccountid = ddc.DebtAccountID;
                        ddc.CashAccountID = dc.CashAccountID;
                    }
                    else
                    {
                        ddc.DebtID = 0;
                        reqtype = "new";
                    }

                    lc.DeleteLiabilityData_ForOneTimeUpload(Convert.ToString(debtaccountid), "Debt");

                    dl.InsertUpdateDebt_OnetimeFromFile(ddc, CREConstants.useridforSys_Scheduler);
                    if (reqtype == "new")
                    {
                        DebtDataContract dcnew = dl.GetDebtByDebtID(ddc.DebtName);
                        debtaccountid = dcnew.DebtAccountID;
                    }

                    List<DebtDataContract> setuplist = lstDebt.FindAll(x => x.DebtName == dname);

                    foreach (var item in setuplist)
                    {
                        item.DebtAccountID = debtaccountid;
                        dl.InsertUpdateGeneralSetupDetailsDebt(item, CREConstants.useridforSys_Scheduler);
                    }
                }

                for (var i = 0; i < Trans11JSON.Count; i++)
                {
                    Trans11DataContract dd = new Trans11DataContract();

                    dd.DealID = Trans11JSON[i].DealID;
                    dd.DealName = Trans11JSON[i].DealName;
                    dd.NoteID = Trans11JSON[i].NoteID;
                    dd.NoteName = Trans11JSON[i].NoteName;
                    dd.Description = Trans11JSON[i].Description;
                    dd.Date = CommonHelper.ToDateTime(Trans11JSON[i].Date);
                    dd.Owned = Trans11JSON[i].Owned;
                    dd.TransactionType = Trans11JSON[i].TransactionType;
                    dd.FinancingFacility = Trans11JSON[i].FinancingFacility;
                    dd.Transaction = CommonHelper.StringToDecimalWithRound(Trans11JSON[i].Transaction);
                    dd.UnallocatedSubline = CommonHelper.StringToDecimalWithRound(Trans11JSON[i].UnallocatedSubline);
                    dd.UnallocatedEquity = CommonHelper.StringToDecimalWithRound(Trans11JSON[i].UnallocatedEquity);
                    dd.SublineBalance = CommonHelper.StringToDecimalWithRound(Trans11JSON[i].SublineBalance);
                    dd.EquityBalance = CommonHelper.StringToDecimalWithRound(Trans11JSON[i].EquityBalance);

                    lst11Trans.Add(dd);
                }

                for (var i = 0; i < InvestorsJSON.Count; i++)
                {
                    InvestorsDataContract dd = new InvestorsDataContract();

                    dd.Investor = InvestorsJSON[i].Investor;
                    dd.EqDate = CommonHelper.ToDateTime(InvestorsJSON[i].EqDate);
                    dd.Commitment = CommonHelper.StringToDecimalWithRound(InvestorsJSON[i].Commitment);
                    dd.SLDate = CommonHelper.ToDateTime(InvestorsJSON[i].SLDate);
                    dd.Concentration = CommonHelper.StringToDecimalWithRound(InvestorsJSON[i].Concentration);
                    dd.ConCommit = CommonHelper.StringToDecimalWithRound(InvestorsJSON[i].ConCommit);
                    dd.SLAdvance = CommonHelper.StringToDecimalWithRound(InvestorsJSON[i].SLAdvance);
                    dd.BorrowBase = CommonHelper.StringToDecimalWithRound(InvestorsJSON[i].BorrowBase);

                    lstInvestors.Add(dd);
                }

                //Liability Note Saving 

                EquityLogic eqlogic = new EquityLogic();
                DebtLogic dlLogic = new DebtLogic();

                for (var i = 0; i < DealLiabilityJSON.Count; i++)
                {
                    LibDealLiabilityDataContract dealliab = new LibDealLiabilityDataContract();
                    dealliab.CREDealID = DealLiabilityJSON[i].CREDealID;
                    dealliab.DealName = DealLiabilityJSON[i].DealName;
                    dealliab.CRENoteID = DealLiabilityJSON[i].CRENoteID;
                    dealliab.Name = DealLiabilityJSON[i].Name;
                    dealliab.Structure = DealLiabilityJSON[i].Structure;
                    dealliab.Equity = DealLiabilityJSON[i].Equity;
                    dealliab.Facility = DealLiabilityJSON[i].Facility;

                    lstDealLiability.Add(dealliab);
                }


                EquityDataContract ed = eqlogic.GetEquityByEquityName(currentEquityName);
                string EqAccID = ed.EquityAccountID;
                lc.DeleteLiabilityData_ForOneTimeUpload(EqAccID, "LiabilityNote");


                var distinctDeals = lstDealLiability.Where(d => d.Structure != "3rd Party").GroupBy(d => d.CREDealID).ToList();

                for (var i = 0; i < DealLibAdvRateJSON.Count; i++)
                {
                    DealLibAdvRateDataContract dLAdv = new DealLibAdvRateDataContract();

                    dLAdv.CREDealID = DealLibAdvRateJSON[i].CREDealID;
                    dLAdv.DealName = DealLibAdvRateJSON[i].DealName;
                    dLAdv.Equity = DealLibAdvRateJSON[i].Equity;
                    dLAdv.Facility = DealLibAdvRateJSON[i].Facility;
                    dLAdv.EffDate = CommonHelper.ToDateTime(DealLibAdvRateJSON[i].EffDate);
                    dLAdv.MaturityDate = CommonHelper.ToDateTime(DealLibAdvRateJSON[i].MaturityDate);
                    dLAdv.AdvRateFacility = CommonHelper.StringToDecimalWithRound(DealLibAdvRateJSON[i].AdvRateFacility);
                    dLAdv.AdvRateEquity = CommonHelper.StringToDecimalWithRound(DealLibAdvRateJSON[i].AdvRateEquity);
                    dLAdv.PledgeDate = CommonHelper.ToDateTime(DealLibAdvRateJSON[i].PledgeDate);
                    dLAdv.LiabilitySource = DealLibAdvRateJSON[i].Source;

                    lstDealLibAdvRate.Add(dLAdv);
                }

                foreach (var dealGroup in distinctDeals)
                {
                    var dd = dealGroup.First();

                    var validDealLiabilities = lstDealLiability
                            .Where(d => d.Structure != "3rd Party")
                            .ToList();

                    var generalsetupRows = lstDealLibAdvRate
                            .Where(l => l.CREDealID == dd.CREDealID)
                            .ToList();

                    var distinctFacilities = generalsetupRows.GroupBy(d => d.Facility).ToList();

                    DataTable dt = lc.GetDealDatabyCREDealID(dd.CREDealID);
                    string DealAccountID = Convert.ToString(dt.Rows[0]["DealAccountID"]);
                    string LiabilityNoteID_Facility = string.Empty;
                    string LinkedShortTermText = string.Empty;
                    DateTime? FullyExtendedMaturityDate = CommonHelper.ToDateTime(dt.Rows[0]["MaturityDate"]);

                    // Creating liability note for Equity
                    if (!string.IsNullOrEmpty(dd.Equity))
                    {
                        string LiabilityNoteID_Equity = "LN_Eq_" + dd.Equity.Replace(" ", "") + "_" + dd.CREDealID;
                        string LiabilityNoteID_LinkedShortTerm = "LN_Sub_" + dd.Equity.Replace(" ", "") + "_" + dd.CREDealID;
                        string LiabilityNoteID_Cash = "LN_PE_" + dd.Equity.Replace(" ", "") + "_" + dd.CREDealID;
                        string LiabilityNoteID_SublineCash = "LN_PS_" + dd.Equity.Replace(" ", "") + "_" + dd.CREDealID;

                        EquityDataContract edc = eqlogic.GetEquityByEquityName(currentEquityName);
                        string EqAccountID = edc.EquityAccountID;
                        Guid? LinkedShortTermBorrowingFacilityID = edc.LinkedShortTermBorrowingFacilityID;
                        Guid? CashAccountID = edc.CashAccountID;
                        LinkedShortTermText = edc.LinkedShortTermBorrowingFacilityText;

                        DebtDataContract SubCashdc = dlLogic.GetDebtByDebtID(LinkedShortTermText);
                        Guid? SublineCashAccountId = SubCashdc.CashAccountID;

                        //LN for Equity 
                        LiabilityNoteDataContract LNote_Equity = new LiabilityNoteDataContract
                        {
                            LiabilityNoteAutoID = 0,
                            LiabilityNoteAccountID = new Guid("00000000-0000-0000-0000-000000000000"),
                            DealAccountID = DealAccountID,
                            LiabilityNoteID = LiabilityNoteID_Equity,
                            LiabilityName = LiabilityNoteID_Equity,
                            LiabilityTypeID = new Guid(EqAccountID),
                            AssetAccountID = DealAccountID,
                            Status = 1
                        };

                        //Liability Asset Map for Equity
                        var liabilityAssetMapEquity = new List<LiabilityNoteAssetMapping>();
                        foreach (DataRow row in dt.Rows)
                        {
                            string NoteAccountID = Convert.ToString(row["NoteAccountID"]);
                            string CRENoteID = Convert.ToString(row["CRENoteID"]);

                            var matchingnote = validDealLiabilities
                                .FirstOrDefault(d => d.CRENoteID == CRENoteID);

                            if (matchingnote != null)
                            {
                                var mapEquity = new LiabilityNoteAssetMapping
                                {
                                    LiabilityNoteId = LiabilityNoteID_Equity,
                                    DealAccountId = DealAccountID,
                                    LiabilityNoteAccountId = "00000000-0000-0000-0000-000000000000",
                                    AssetAccountId = NoteAccountID
                                };

                                liabilityAssetMapEquity.Add(mapEquity);
                            }
                        }

                        string LiabilityNoteAccountIDEquity = lc.InsertUpdateLiabilityNote(LNote_Equity, Convert.ToString(CREConstants.useridforSys_Scheduler_GUID), liabilityAssetMapEquity);

                        foreach (var i in generalsetupRows)
                        {
                            LiabilityNoteDataContract LGeneralSetupEQ = new LiabilityNoteDataContract
                            {
                                LiabilityNoteAccountID = new Guid(LiabilityNoteAccountIDEquity),
                                EffectiveDate = i.EffDate,
                                TargetAdvanceRate = i.AdvRateEquity,
                                MaturityDate = i.MaturityDate ?? FullyExtendedMaturityDate,
                                PledgeDate = i.PledgeDate,
                                LiabilitySource = GetLookupID(lstlookupDC, 151, i.LiabilitySource)
                            };

                            lc.InsertUpdateGeneralSetupLiabilityNote(LGeneralSetupEQ, headerUserID);
                        }

                        //LN for Subline 
                        LiabilityNoteDataContract LNote_Subline = new LiabilityNoteDataContract
                        {
                            LiabilityNoteAutoID = 0,
                            LiabilityNoteAccountID = new Guid("00000000-0000-0000-0000-000000000000"),
                            DealAccountID = DealAccountID,
                            LiabilityNoteID = LiabilityNoteID_LinkedShortTerm,
                            LiabilityName = LiabilityNoteID_LinkedShortTerm,
                            LiabilityTypeID = LinkedShortTermBorrowingFacilityID,
                            AssetAccountID = DealAccountID,
                            Status = 1
                        };

                        //Liability Asset Map for Subline
                        var liabilityAssetMapSubline = new List<LiabilityNoteAssetMapping>();
                        foreach (DataRow row in dt.Rows)
                        {
                            string NoteAccountID = Convert.ToString(row["NoteAccountID"]);
                            string CRENoteID = Convert.ToString(row["CRENoteID"]);

                            var matchingnote = validDealLiabilities
                                .FirstOrDefault(d => d.CRENoteID == CRENoteID);

                            if (matchingnote != null)
                            {
                                var mapEquity = new LiabilityNoteAssetMapping
                                {
                                    LiabilityNoteId = LiabilityNoteID_LinkedShortTerm,
                                    DealAccountId = DealAccountID,
                                    LiabilityNoteAccountId = "00000000-0000-0000-0000-000000000000",
                                    AssetAccountId = NoteAccountID
                                };

                                liabilityAssetMapSubline.Add(mapEquity);
                            }
                        }

                        string LiabilityNoteAccountIDSubline = lc.InsertUpdateLiabilityNote(LNote_Subline, Convert.ToString(CREConstants.useridforSys_Scheduler_GUID), liabilityAssetMapSubline);

                        foreach (var i in generalsetupRows)
                        {
                            LiabilityNoteDataContract LGeneralSetupSub = new LiabilityNoteDataContract
                            {
                                LiabilityNoteAccountID = new Guid(LiabilityNoteAccountIDSubline),
                                EffectiveDate = i.EffDate,
                                TargetAdvanceRate = i.AdvRateEquity,
                                MaturityDate = i.MaturityDate ?? FullyExtendedMaturityDate,
                                PledgeDate = i.PledgeDate,
                                LiabilitySource = GetLookupID(lstlookupDC, 151, i.LiabilitySource)
                            };

                            lc.InsertUpdateGeneralSetupLiabilityNote(LGeneralSetupSub, headerUserID);
                        }

                        //LN for Eq Cash Account 
                        LiabilityNoteDataContract LNote_EqCashAccount = new LiabilityNoteDataContract
                        {
                            LiabilityNoteAutoID = 0,
                            LiabilityNoteAccountID = new Guid("00000000-0000-0000-0000-000000000000"),
                            DealAccountID = DealAccountID,
                            LiabilityNoteID = LiabilityNoteID_Cash,
                            LiabilityName = LiabilityNoteID_Cash,
                            LiabilityTypeID = CashAccountID,
                            AssetAccountID = DealAccountID,
                            Status = 1
                        };

                        //Liability Asset Map for Eq Cash Account
                        var liabilityAssetMapEqCashAccount = new List<LiabilityNoteAssetMapping>();
                        foreach (DataRow row in dt.Rows)
                        {
                            string NoteAccountID = Convert.ToString(row["NoteAccountID"]);
                            string CRENoteID = Convert.ToString(row["CRENoteID"]);

                            var matchingnote = validDealLiabilities
                                .FirstOrDefault(d => d.CRENoteID == CRENoteID);

                            if (matchingnote != null)
                            {
                                var mapEquity = new LiabilityNoteAssetMapping
                                {
                                    LiabilityNoteId = LiabilityNoteID_Cash,
                                    DealAccountId = DealAccountID,
                                    LiabilityNoteAccountId = "00000000-0000-0000-0000-000000000000",
                                    AssetAccountId = NoteAccountID
                                };

                                liabilityAssetMapEqCashAccount.Add(mapEquity);
                            }
                        }

                        string LiabilityNoteAccountIDEqCash = lc.InsertUpdateLiabilityNote(LNote_EqCashAccount, Convert.ToString(CREConstants.useridforSys_Scheduler_GUID), liabilityAssetMapEqCashAccount);

                        foreach (var i in generalsetupRows)
                        {
                            LiabilityNoteDataContract LGeneralSetupEqCash = new LiabilityNoteDataContract
                            {
                                LiabilityNoteAccountID = new Guid(LiabilityNoteAccountIDEqCash),
                                EffectiveDate = i.EffDate,
                                TargetAdvanceRate = i.AdvRateEquity,
                                MaturityDate = i.MaturityDate ?? FullyExtendedMaturityDate,
                                PledgeDate = i.PledgeDate,
                                LiabilitySource = GetLookupID(lstlookupDC, 151, i.LiabilitySource)
                            };

                            lc.InsertUpdateGeneralSetupLiabilityNote(LGeneralSetupEqCash, headerUserID);
                        }

                        //LN for Subline Cash Account 
                        LiabilityNoteDataContract LNote_SublCashAccount = new LiabilityNoteDataContract
                        {
                            LiabilityNoteAutoID = 0,
                            LiabilityNoteAccountID = new Guid("00000000-0000-0000-0000-000000000000"),
                            DealAccountID = DealAccountID,
                            LiabilityNoteID = LiabilityNoteID_SublineCash,
                            LiabilityName = LiabilityNoteID_SublineCash,
                            LiabilityTypeID = SublineCashAccountId,
                            AssetAccountID = DealAccountID,
                            Status = 1
                        };

                        //Liability Asset Map for Subline Cash Account
                        var liabilityAssetMapSubCashAccount = new List<LiabilityNoteAssetMapping>();
                        foreach (DataRow row in dt.Rows)
                        {
                            string NoteAccountID = Convert.ToString(row["NoteAccountID"]);
                            string CRENoteID = Convert.ToString(row["CRENoteID"]);

                            var matchingnote = validDealLiabilities
                                .FirstOrDefault(d => d.CRENoteID == CRENoteID);

                            if (matchingnote != null)
                            {
                                var mapEquity = new LiabilityNoteAssetMapping
                                {
                                    LiabilityNoteId = LiabilityNoteID_SublineCash,
                                    DealAccountId = DealAccountID,
                                    LiabilityNoteAccountId = "00000000-0000-0000-0000-000000000000",
                                    AssetAccountId = NoteAccountID
                                };

                                liabilityAssetMapSubCashAccount.Add(mapEquity);
                            }
                        }

                        string LiabilityNoteAccountIDSubCash = lc.InsertUpdateLiabilityNote(LNote_SublCashAccount, Convert.ToString(CREConstants.useridforSys_Scheduler_GUID), liabilityAssetMapSubCashAccount);

                        foreach (var i in generalsetupRows)
                        {
                            LiabilityNoteDataContract LGeneralSetupSubCash = new LiabilityNoteDataContract
                            {
                                LiabilityNoteAccountID = new Guid(LiabilityNoteAccountIDSubCash),
                                EffectiveDate = i.EffDate,
                                TargetAdvanceRate = i.AdvRateEquity,
                                MaturityDate = i.MaturityDate ?? FullyExtendedMaturityDate,
                                PledgeDate = i.PledgeDate,
                                LiabilitySource = GetLookupID(lstlookupDC, 151, i.LiabilitySource)
                            };

                            lc.InsertUpdateGeneralSetupLiabilityNote(LGeneralSetupSubCash, headerUserID);
                        }
                    }

                    // Creating liability note for Facility
                    for (int item = 0; item < distinctFacilities.Count; item++)
                    {
                        var facility = distinctFacilities[item].Key;

                        if (!string.IsNullOrEmpty(facility) && facility != LinkedShortTermText && facility.Trim() != "N/A")
                        {
                            LiabilityNoteID_Facility = "LN_Fin_" + dd.Equity.Replace(" ", "") + "_" + dd.CREDealID + "_" + facility;
                            DebtDataContract dc = dlLogic.GetDebtByDebtID(facility);
                            Guid DtAccountID = dc.DebtAccountID;

                            LiabilityNoteDataContract LNote_Facility = new LiabilityNoteDataContract
                            {
                                LiabilityNoteAutoID = 0,
                                LiabilityNoteAccountID = new Guid("00000000-0000-0000-0000-000000000000"),
                                DealAccountID = DealAccountID,
                                LiabilityNoteID = LiabilityNoteID_Facility,
                                LiabilityName = LiabilityNoteID_Facility,
                                LiabilityTypeID = DtAccountID,
                                AssetAccountID = DealAccountID,
                                Status = 1
                            };

                            // Create the Liability Asset Map for Facility

                            var liabilityAssetMapFacility = new List<LiabilityNoteAssetMapping>();
                            foreach (DataRow row in dt.Rows)
                            {
                                string NoteAccountID = Convert.ToString(row["NoteAccountID"]);
                                string CRENoteID = Convert.ToString(row["CRENoteID"]);

                                var matchingnote = validDealLiabilities
                                    .FirstOrDefault(d => d.CRENoteID == CRENoteID);

                                if (matchingnote != null)
                                {

                                    var mapFacility = new LiabilityNoteAssetMapping
                                    {
                                        LiabilityNoteId = LiabilityNoteID_Facility,
                                        DealAccountId = DealAccountID,
                                        LiabilityNoteAccountId = "00000000-0000-0000-0000-000000000000",
                                        AssetAccountId = NoteAccountID
                                    };

                                    liabilityAssetMapFacility.Add(mapFacility);
                                }
                            }

                            string LiabilityNoteAccountIdDT = lc.InsertUpdateLiabilityNote(LNote_Facility, Convert.ToString(CREConstants.useridforSys_Scheduler_GUID), liabilityAssetMapFacility);

                            foreach (var i in generalsetupRows)
                            {
                                if (facility == i.Facility)
                                {
                                    LiabilityNoteDataContract LGeneralSetupDT = new LiabilityNoteDataContract
                                    {
                                        LiabilityNoteAccountID = new Guid(LiabilityNoteAccountIdDT),
                                        EffectiveDate = i.EffDate,
                                        TargetAdvanceRate = i.AdvRateFacility,
                                        MaturityDate = i.MaturityDate ?? FullyExtendedMaturityDate,
                                        PledgeDate = i.PledgeDate,
                                        LiabilitySource = GetLookupID(lstlookupDC, 151, i.LiabilitySource)
                                    };

                                    lc.InsertUpdateGeneralSetupLiabilityNote(LGeneralSetupDT, headerUserID);
                                }
                            }
                        }
                    }

                }


                EquityDataContract eqDc = el.GetEquityByEquityName(currentEquityName);

                DataTable dtInvestors = ToDataTable<InvestorsDataContract>(lstInvestors);
                lc.UploadInvestorsData(dtInvestors, eqDc.EquityAccountID);


                DataTable dt11Trans = ToDataTable<Trans11DataContract>(lst11Trans);
                lc.InsertLib11Trans(dt11Trans, currentEquityName, Cutoffdate);

                _authenticationResult = new v1GenericResult()
                {
                    Succeeded = true,
                    Message = "Success"
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

        public int? GetLookupID(List<LookupDataContract> lstlookup, int? parentid, string text)
        {
            int? lookupid = null;
            if (text != "")
            {
                lookupid = lstlookup.Find(x => x.Name.ToLower() == text.ToLower() && x.ParentID == parentid).LookupID;
            }
            return lookupid;
        }
        public static DataTable ToDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);

            //Get all the properties
            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in Props)
            {
                //Defining type of data column gives proper data table 
                var type = (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(Nullable<>) ? Nullable.GetUnderlyingType(prop.PropertyType) : prop.PropertyType);
                //Setting column names as Property names
                dataTable.Columns.Add(prop.Name, type);
            }
            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {
                    //inserting property values to datatable rows
                    values[i] = Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }
            //put a breakpoint here and check datatable
            return dataTable;
        }

        [HttpPost]
        [Route("api/liabilityNote/InsertUpdateLiabilityDataFromexcel")]
        public IActionResult InsertUpdateLiabilityDataFromexcel([FromBody] dynamic LiabilityData)
        {

            v1GenericResult _authenticationResult = null;
            LiabilityNoteLogic liabilityNoteLogic = new LiabilityNoteLogic();

            try
            {
                liabilityNoteLogic.DeleteLiability_ScheduleData_Temp();
                List<InterestExpenseScheduleDataContract> ListInterestExpense = new List<InterestExpenseScheduleDataContract>();

                List<DebtDataContract> deblist = liabilityNoteLogic.GetAllDebtData();

                List<DebtDataContract> debtlistext = deblist.FindAll(x => x.DebtTypeText == "DebtExt").ToList();
                List<DebtDataContract> debtdata = deblist.FindAll(x => x.DebtTypeText == "Debt").ToList();
                List<DebtDataContract> notedata = deblist.FindAll(x => x.DebtTypeText == "Note").ToList();


                var ListDebtExt = LiabilityData["ListDebtExt"];
                List<DebtDataContract> DebtExtDataList = new List<DebtDataContract>();

                for (var i = 0; i < ListDebtExt.Count; i++)
                {
                    InterestExpenseScheduleDataContract intexpense = new InterestExpenseScheduleDataContract();
                    DebtDataContract ddc = new DebtDataContract();

                    ddc.DebtAccountID = new Guid(Convert.ToString(ListDebtExt[i].DebtAccountID));
                    ddc.AdditionalAccountID = new Guid(Convert.ToString(ListDebtExt[i].AdditionalAccountID));
                    ddc.DebtExtID = GetDebetExID(ddc.DebtAccountID, ddc.AdditionalAccountID, debtlistext);
                    ddc.PayFrequency = CommonHelper.ToInt32(ListDebtExt[i].PayFrequency);

                    ddc.AccrualEndDateBusinessDayLag = CommonHelper.ToInt32(ListDebtExt[i].AccrualEndDateBusinessDayLag);
                    ddc.AccrualFrequency = CommonHelper.ToInt32(ListDebtExt[i].AccrualFrequency);

                    ddc.DefaultIndexName = CommonHelper.ToInt32(ListDebtExt[i].DefaultIndexName);
                    ddc.FinanacingSpreadRate = CommonHelper.StringToDecimal(ListDebtExt[i].FinanacingSpreadRate);
                    ddc.IntCalcMethod = CommonHelper.ToInt32(ListDebtExt[i].IntCalcMethod);
                    ddc.RoundingMethod = CommonHelper.ToInt32(ListDebtExt[i].RoundingMethod);
                    ddc.IndexRoundingRule = CommonHelper.ToInt32(ListDebtExt[i].IndexRoundingRule);
                    ddc.TargetAdvanceRate = CommonHelper.ToDecimal(ListDebtExt[i].TargetAdvanceRate);

                    ddc.ResetIndexDaily = CommonHelper.ToInt32(ListDebtExt[i].ResetIndexDaily);
                    ddc.DeterminationDateHolidayList = CommonHelper.ToInt32(ListDebtExt[i].DeterminationDateHolidayList);

                    ddc.UpdatedBy = useridforSys_Scheduler;
                    DebtExtDataList.Add(ddc);

                    intexpense.InterestExpenseScheduleID = 0;
                    intexpense.DebtAccountID = ddc.DebtAccountID;
                    intexpense.AdditionalAccountID = ddc.AdditionalAccountID;
                    intexpense.EffectiveDate = CommonHelper.ToDateTime(ListDebtExt[i].EffectiveDate);
                    intexpense.InitialInterestAccrualEnddate = CommonHelper.ToDateTime(ListDebtExt[i].InitialInterestAccrualEndDate); ;
                    intexpense.PaymentDayOfMonth = CommonHelper.ToInt32(ListDebtExt[i].PaymentDayMonth);
                    intexpense.PaymentDateBusinessDayLag = CommonHelper.ToInt32(ListDebtExt[i].PaymentDateBusinessDayLag);
                    intexpense.Determinationdateleaddays = CommonHelper.ToInt32(ListDebtExt[i].DeterminationDateLeadDays);
                    intexpense.DeterminationDateReferenceDayOftheMonth = CommonHelper.ToInt32(ListDebtExt[i].DeterminationDateRefDayMonth);
                    intexpense.FirstRateIndexResetDate = CommonHelper.ToDateTime(ListDebtExt[i].FirstRateIndexResetDate);
                    intexpense.InitialIndexValueOverride = CommonHelper.StringToDecimal(ListDebtExt[i].InitialIndexValueOverride);
                    intexpense.Recourse = CommonHelper.StringToDecimal(ListDebtExt[i].Recourse);
                    intexpense.UpdatedBy = useridforSys_Scheduler;
                    ListInterestExpense.Add(intexpense);
                }

                var ListDebtSchedule = LiabilityData["ListDebtSchedule"];
                List<DebtDataContract> DebtSchedule = new List<DebtDataContract>();

                for (var i = 0; i < ListDebtSchedule.Count; i++)
                {
                    DebtDataContract ddc = new DebtDataContract();

                    ddc.DebtAccountID = new Guid(Convert.ToString(ListDebtSchedule[i].AccountID));
                    ddc.DebtID = GetDebtID(ddc.DebtAccountID, debtdata);
                    ddc.OriginationDate = CommonHelper.ToDateTime(ListDebtSchedule[i].OriginationDate);
                    ddc.EffectiveDate = CommonHelper.ToDateTime(ListDebtSchedule[i].EffectiveDate);
                    ddc.InitialMaturityDate = CommonHelper.ToDateTime(ListDebtSchedule[i].InitialMaturityDate);
                    ddc.Commitment = CommonHelper.StringToDecimalWithNull(ListDebtSchedule[i].Commitment);
                    ddc.ExitFee = CommonHelper.StringToDecimalWithNull(ListDebtSchedule[i].ExitFee);
                    ddc.ExtensionFees = CommonHelper.StringToDecimalWithNull(ListDebtSchedule[i].ExtensionFees);

                    ddc.UpdatedBy = useridforSys_Scheduler;
                    DebtSchedule.Add(ddc);

                }

                List<LiabilityRateSpreadDataContract> ListLiabilityRate = new List<LiabilityRateSpreadDataContract>();
                var ListRateSpreadSchedule = LiabilityData["ListRateSpreadSchedule"];
                for (var i = 0; i < ListRateSpreadSchedule.Count; i++)
                {
                    LiabilityRateSpreadDataContract rsd = new LiabilityRateSpreadDataContract();
                    rsd.AdditionalAccountID = Convert.ToString(ListRateSpreadSchedule[i].AdditionalAccountID);
                    rsd.AccountID = Convert.ToString(ListRateSpreadSchedule[i].AccountID);
                    rsd.EffectiveDate = CommonHelper.ToDateTime(ListRateSpreadSchedule[i].EffectiveDate);
                    rsd.Date = CommonHelper.ToDateTime(ListRateSpreadSchedule[i].Date);
                    rsd.ValueTypeID = CommonHelper.ToInt32(ListRateSpreadSchedule[i].ValueTypeID);
                    rsd.Value = CommonHelper.StringToDecimal(ListRateSpreadSchedule[i].Value);
                    rsd.IntCalcMethodID = CommonHelper.ToInt32(ListRateSpreadSchedule[i].IntCalcMethodID);
                    rsd.RateOrSpreadToBeStripped = CommonHelper.ToInt32(ListRateSpreadSchedule[i].RateOrSpreadToBeStripped);
                    rsd.IndexNameID = CommonHelper.ToInt32(ListRateSpreadSchedule[i].IndexNameID);
                    rsd.DeterminationDateHolidayList = CommonHelper.ToInt32(ListRateSpreadSchedule[i].DeterminationDateHolidayList);
                    rsd.IsDeleted = CommonHelper.ToBoolean(ListRateSpreadSchedule[i].IsDeleted);
                    ListLiabilityRate.Add(rsd);
                }

                List<LiabilityRateSpreadDataContract> ListNoteLiabilityRate = new List<LiabilityRateSpreadDataContract>();
                var ListNoteRateSpreadSchedule = LiabilityData["ListNoteRateSpreadSchedule"];
                for (var i = 0; i < ListNoteRateSpreadSchedule.Count; i++)
                {
                    LiabilityRateSpreadDataContract rsd = new LiabilityRateSpreadDataContract();

                    rsd.AdditionalAccountID = Convert.ToString(ListNoteRateSpreadSchedule[i].AdditionalAccountID);
                    rsd.AccountID = GetNoteAccountID(Convert.ToString(ListNoteRateSpreadSchedule[i].LiabilityNoteID), notedata);

                    if (rsd.AccountID != "00000000-0000-0000-0000-000000000000")
                    {
                        rsd.EffectiveDate = CommonHelper.ToDateTime(ListNoteRateSpreadSchedule[i].EffectiveDate);
                        rsd.Date = CommonHelper.ToDateTime(ListNoteRateSpreadSchedule[i].Date);
                        rsd.ValueTypeID = CommonHelper.ToInt32(ListNoteRateSpreadSchedule[i].ValueTypeID);
                        rsd.Value = CommonHelper.StringToDecimal(ListNoteRateSpreadSchedule[i].Value);
                        rsd.IntCalcMethodID = CommonHelper.ToInt32(ListNoteRateSpreadSchedule[i].IntCalcMethodID);
                        rsd.RateOrSpreadToBeStripped = CommonHelper.ToInt32(ListNoteRateSpreadSchedule[i].RateOrSpreadToBeStripped);
                        rsd.IndexNameID = CommonHelper.ToInt32(ListNoteRateSpreadSchedule[i].IndexNameID);
                        rsd.DeterminationDateHolidayList = CommonHelper.ToInt32(ListNoteRateSpreadSchedule[i].DeterminationDateHolidayList);
                        rsd.IsDeleted = CommonHelper.ToBoolean(ListNoteRateSpreadSchedule[i].IsDeleted);
                        ListNoteLiabilityRate.Add(rsd);
                    }

                }


                List<FeeScheduleDataContract> ListFeeSchedule = new List<FeeScheduleDataContract>();
                var FeeSchedule = LiabilityData["ListFeeSchedule"];
                for (var i = 0; i < FeeSchedule.Count; i++)
                {
                    FeeScheduleDataContract rsd = new FeeScheduleDataContract();
                    rsd.AdditionalAccountID = Convert.ToString(FeeSchedule[i].AdditionalAccountID);
                    rsd.AccountID = Convert.ToString(FeeSchedule[i].AccountID);
                    rsd.EffectiveDate = CommonHelper.ToDateTime(FeeSchedule[i].EffectiveDate);
                    rsd.StartDate = CommonHelper.ToDateTime(FeeSchedule[i].StartDate);
                    rsd.EndDate = CommonHelper.ToDateTime(FeeSchedule[i].EndDate);
                    rsd.ValueTypeID = CommonHelper.ToInt32(FeeSchedule[i].ValueTypeID);
                    rsd.Fee = CommonHelper.StringToDecimal(FeeSchedule[i].Fee);
                    rsd.FeeName = Convert.ToString(FeeSchedule[i].FeeName);
                    rsd.FeeAmountOverride = CommonHelper.StringToDecimalWithNull(FeeSchedule[i].FeeAmountOverride);
                    rsd.BaseAmountOverride = CommonHelper.StringToDecimalWithNull(FeeSchedule[i].BaseAmountOverride);
                    rsd.ApplyTrueUpFeatureID = CommonHelper.ToInt32(FeeSchedule[i].ApplyTrueUpFeatureID);
                    rsd.IncludedLevelYield = CommonHelper.ToInt32(FeeSchedule[i].IncludedLevelYield);
                    rsd.IsDeleted = CommonHelper.ToBoolean(FeeSchedule[i].IsDeleted);
                    rsd.PercentageOfFeeToBeStripped = CommonHelper.StringToDecimalWithNull(FeeSchedule[i].PercentageOfFeeToBeStripped);
                    ListFeeSchedule.Add(rsd);
                }

                liabilityNoteLogic.InsertUpdateInterestExpenseSchedule(ListInterestExpense, useridforSys_Scheduler);
                liabilityNoteLogic.InsertUpdateRepoExtDatafromFundLevel(DebtExtDataList, useridforSys_Scheduler);
                liabilityNoteLogic.InsertUpdateLiabilityRateSpreadSchedule(ListLiabilityRate, useridforSys_Scheduler);
                liabilityNoteLogic.InsertUpdatedLiabilityFeeSchedule(ListFeeSchedule, useridforSys_Scheduler);

                var ListNoteInterestExpense = LiabilityData["ListNoteInterestExpense"];
                List<LiabilityNoteDataContract> LiabiltyNoteInterestExpenseList = new List<LiabilityNoteDataContract>();
                List<InterestExpenseScheduleDataContract> NoteLevelEffectiveDateData = new List<InterestExpenseScheduleDataContract>();

                for (var i = 0; i < ListNoteInterestExpense.Count; i++)
                {
                    Guid DebtAccountID = new Guid();
                    Guid AdditionalAccountID = new Guid();
                    InterestExpenseScheduleDataContract intexpense = new InterestExpenseScheduleDataContract();
                    LiabilityNoteDataContract ddc = new LiabilityNoteDataContract();

                    DebtAccountID = new Guid(GetNoteAccountID(Convert.ToString(ListNoteInterestExpense[i].LiabilityNoteID), notedata));
                    if (DebtAccountID != new Guid("00000000-0000-0000-0000-000000000000"))
                    {
                        AdditionalAccountID = new Guid(Convert.ToString("00000000-0000-0000-0000-000000000000"));

                        ddc.LiabilityNoteAutoID = GetNoteAutoID(Convert.ToString(ListNoteInterestExpense[i].LiabilityNoteID), notedata);
                        ddc.PayFrequency = CommonHelper.ToInt32(ListNoteInterestExpense[i].PayFrequency);

                        ddc.AccrualEndDateBusinessDayLag = CommonHelper.ToInt32(ListNoteInterestExpense[i].AccrualEndDateBusinessDayLag);
                        ddc.AccrualFrequency = CommonHelper.ToInt32(ListNoteInterestExpense[i].AccrualFrequency);


                        ddc.DefaultIndexName = CommonHelper.ToInt32(ListNoteInterestExpense[i].DefaultIndexName);
                        ddc.FinanacingSpreadRate = CommonHelper.StringToDecimal(ListNoteInterestExpense[i].FinanacingSpreadRate);
                        ddc.IntCalcMethod = CommonHelper.ToInt32(ListNoteInterestExpense[i].IntCalcMethod);
                        ddc.RoundingMethod = CommonHelper.ToInt32(ListNoteInterestExpense[i].RoundingMethod);
                        ddc.IndexRoundingRule = CommonHelper.ToInt32(ListNoteInterestExpense[i].IndexRoundingRule);
                        ddc.TargetAdvanceRate = CommonHelper.ToDecimal(ListNoteInterestExpense[i].TargetAdvanceRate);
                        ddc.UpdatedBy = useridforSys_Scheduler;

                        LiabiltyNoteInterestExpenseList.Add(ddc);


                        intexpense.InterestExpenseScheduleID = 0;
                        intexpense.DebtAccountID = DebtAccountID;
                        intexpense.AdditionalAccountID = AdditionalAccountID;
                        intexpense.EffectiveDate = CommonHelper.ToDateTime(ListNoteInterestExpense[i].EffectiveDate);
                        intexpense.InitialInterestAccrualEnddate = CommonHelper.ToDateTime(ListNoteInterestExpense[i].InitialInterestAccrualEndDate);
                        intexpense.PaymentDayOfMonth = CommonHelper.ToInt32(ListNoteInterestExpense[i].PaymentDayMonth);
                        intexpense.PaymentDateBusinessDayLag = CommonHelper.ToInt32(ListNoteInterestExpense[i].PaymentDateBusinessDayLag);
                        intexpense.Determinationdateleaddays = CommonHelper.ToInt32(ListNoteInterestExpense[i].DeterminationDateLeadDays);
                        intexpense.DeterminationDateReferenceDayOftheMonth = CommonHelper.ToInt32(ListNoteInterestExpense[i].DeterminationDateRefDayMonth);
                        intexpense.FirstRateIndexResetDate = CommonHelper.ToDateTime(ListNoteInterestExpense[i].FirstRateIndexResetDate);
                        intexpense.InitialIndexValueOverride = CommonHelper.StringToDecimal(ListNoteInterestExpense[i].InitialIndexValueOverride);
                        intexpense.UpdatedBy = useridforSys_Scheduler;
                        NoteLevelEffectiveDateData.Add(intexpense);
                    }
                }
                //note level data
                liabilityNoteLogic.InsertUpdateLiabilityRateSpreadSchedule(ListNoteLiabilityRate, useridforSys_Scheduler);
                liabilityNoteLogic.InsertUpdateInterestExpenseSchedule(NoteLevelEffectiveDateData, useridforSys_Scheduler);

                foreach (var item in LiabiltyNoteInterestExpenseList)
                {
                    if (item.LiabilityNoteAutoID != 0)
                    {
                        liabilityNoteLogic.InsertUpdateLiabilityNoteFromExcel(item, useridforSys_Scheduler);
                    }
                }

                DebtLogic dl = new DebtLogic();
                foreach (var item in DebtSchedule)
                {
                    liabilityNoteLogic.InsertUpdateDebtOneTimeUpdate(item, useridforSys_Scheduler);
                    dl.InsertUpdateGeneralSetupDetailsDebt(item, useridforSys_Scheduler);
                }

                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = "Data Uploaded.",
                    ErrorDetails = ""
                };
            }
            catch (Exception ex)
            {
                _authenticationResult = new v1GenericResult()
                {
                    Status = 2,
                    Succeeded = false,
                    Message = "Failed",
                    ErrorDetails = ex.Message.ToString()
                };
            }
            return Ok(_authenticationResult);
        }
        public int GetDebetExID(Guid DebtAccountID, Guid AdditionalAccountID, List<DebtDataContract> ddc)
        {
            int DebtExtID = 0;
            try
            {
                foreach (var item in ddc)
                {
                    if (item.DebtAccountID == DebtAccountID && item.AdditionalAccountID == AdditionalAccountID)
                    {
                        DebtExtID = Convert.ToInt16(item.DebtExtID);
                        break;
                    }


                }
            }
            catch (Exception ex)
            {
                DebtExtID = 0;
            }
            return DebtExtID;
        }
        public string GetNoteAccountID(string LiabilityNoteID, List<DebtDataContract> ddc)
        {
            string AccountID = "00000000-0000-0000-0000-000000000000";
            try
            {
                foreach (var item in ddc)
                {
                    if (item.LiabilityNoteID == LiabilityNoteID)
                    {
                        AccountID = item.DebtAccountID.ToString();
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                AccountID = "00000000-0000-0000-0000-000000000000";
            }
            return AccountID;
        }
        public int? GetNoteAutoID(string LiabilityNoteID, List<DebtDataContract> ddc)
        {
            int? ID = 0;
            try
            {
                foreach (var item in ddc)
                {
                    if (item.LiabilityNoteID == LiabilityNoteID)
                    {
                        ID = item.DebtExtID; ;
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                ID = 0;
            }
            return ID;
        }

        public int GetDebtID(Guid DebtAccountID, List<DebtDataContract> ddc)
        {
            int DebtID = 0;
            try
            {
                foreach (var item in ddc)
                {
                    if (item.DebtAccountID == DebtAccountID)
                    {
                        DebtID = Convert.ToInt16(item.DebtExtID);
                        break;
                    }


                }
            }
            catch (Exception ex)
            {
                DebtID = 0;
            }
            return DebtID;
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/liabilityNote/GetInterestExpenseSchedule")]
        public IActionResult GetInterestExpenseSchedule([FromBody] string LiabilityAccountID)
        {

            GenericResult _authenticationResult = null;
            List<InterestExpenseScheduleDataContract> LiabilityInterestExpense = new List<InterestExpenseScheduleDataContract>();
            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }


            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
            LiabilityInterestExpense = LiabilityNotelogic.GetInterestExpenseSchedule(new Guid(LiabilityAccountID), new Guid("00000000-0000-0000-0000-000000000000"));

            try
            {
                if (LiabilityInterestExpense != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstInterestExpenseSchedule = LiabilityInterestExpense
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
                Log.WriteLogException(CRESEnums.Module.LiabilityNote.ToString(), "Error in GetInterestExpenseSchedule: Note ID ", LiabilityAccountID, headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/liabilityNote/DeleteInterestExpenseSchedule")]
        public IActionResult DeleteInterestExpenseSchedule([FromBody] string LiabilityAccountID)
        {

            GenericResult _authenticationResult = null;
            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            try
            {
                LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
                LiabilityNotelogic.DeleteInterestExpenseSchedule(new Guid(LiabilityAccountID), new Guid("00000000-0000-0000-0000-000000000000"));

                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Authentication succeeded"
                };
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.LiabilityNote.ToString(), "Error in DeleteInterestExpenseSchedule: Note ID ", LiabilityAccountID, headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/liabilityNote/getDealLevelLiabilityFundingScheduleTypeID")]
        [Services.Controllers.DeflateCompression]
        public IActionResult GetDealLevelLiabilityFundingScheduleTypeID([FromBody] string LiabilityTypeID)
        {
            GenericResult _acationResult = null;
            EquityDataContract objEquity = new EquityDataContract();
            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
            IEnumerable<string> headerValues;

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            objEquity.ListDealLevelLiabilityFundingSchedule = LiabilityNotelogic.GetDealLevelDataLiabilityFundingScheduleDetail(LiabilityTypeID);

            List<LookupDataContract> listAssociatedDeals = LiabilityNotelogic.GetAssociatedDealsByLiabilityTypeID(LiabilityTypeID);

            try
            {
                if (objEquity != null)
                {
                    _acationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        EquityData = objEquity,
                        listAssociatedDeals = listAssociatedDeals

                    };
                }
                else
                {
                    _acationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Not Exists",
                        StatusCode = 404
                    };
                }
            }
            catch (Exception ex)
            {
                string message = ExceptionHelper.GetFullMessage(ex);
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Equity.ToString(), "Error in GetEquityByEquityId :" + message, objEquity.EquityAccountID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _acationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_acationResult);
        }





        [HttpPost]
        [Route("api/liabilityNote/saveLiabilityDataFromFileUpload_OnlyTransactionTab")]
        public IActionResult saveLiabilityDataFromFileUploadOnlyTransactionTab([FromBody] dynamic LiabilityData)
        {

            v1GenericResult _authenticationResult = null;
            List<Trans11DataContract> lst11Trans = new List<Trans11DataContract>();
            LiabilityNoteLogic lc = new LiabilityNoteLogic();

            try
            {
                var Trans11JSON = LiabilityData["Trans11"];
                string currentEquityName = Convert.ToString(LiabilityData["EquityName"]);
                DateTime Cutoffdate = CommonHelper.ToDateTime(LiabilityData["Cutoffdate"]);


                for (var i = 0; i < Trans11JSON.Count; i++)
                {
                    Trans11DataContract dd = new Trans11DataContract();

                    dd.DealID = Trans11JSON[i].DealID;
                    dd.DealName = Trans11JSON[i].DealName;
                    dd.NoteID = Trans11JSON[i].NoteID;
                    dd.NoteName = Trans11JSON[i].NoteName;
                    dd.Description = Trans11JSON[i].Description;
                    dd.Date = CommonHelper.ToDateTime(Trans11JSON[i].Date);
                    dd.Owned = Trans11JSON[i].Owned;
                    dd.TransactionType = Trans11JSON[i].TransactionType;
                    dd.FinancingFacility = Trans11JSON[i].FinancingFacility;
                    dd.Transaction = CommonHelper.StringToDecimalWithRound(Trans11JSON[i].Transaction);
                    dd.UnallocatedSubline = CommonHelper.StringToDecimalWithRound(Trans11JSON[i].UnallocatedSubline);
                    dd.UnallocatedEquity = CommonHelper.StringToDecimalWithRound(Trans11JSON[i].UnallocatedEquity);
                    dd.SublineBalance = CommonHelper.StringToDecimalWithRound(Trans11JSON[i].SublineBalance);
                    dd.EquityBalance = CommonHelper.StringToDecimalWithRound(Trans11JSON[i].EquityBalance);

                    lst11Trans.Add(dd);
                }

                DataTable dt11Trans = ToDataTable<Trans11DataContract>(lst11Trans);

                lc.InsertLiabilityTransactionTabOnly(dt11Trans, currentEquityName, Cutoffdate);

                _authenticationResult = new v1GenericResult()
                {
                    Succeeded = true,
                    Message = "Success"
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

    }
}
