using CRES.BusinessLogic;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Hosting;
using System.IO;
using CRES.BusinessLogic;
using CRES.DataContract;
using System.Collections.Generic;
using System;
using System.Linq;
using System.Data;
using CRES.Utilities;
using Amazon.CodePipeline.Model;
using System.Threading;
using Syncfusion.DocIO.DLS;
using Microsoft.Identity.Client;
using ExcelDataReader;
using Microsoft.WindowsAzure.Storage.Blob;
using Microsoft.WindowsAzure.Storage;
using CRES.DataContract.Liability;
using static CRES.DataContract.V1CalcDataContract;

namespace CRES.ServiceMVC.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class EquityController : ControllerBase
    {
        private string useridforSys_Scheduler = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";
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
        private IHostingEnvironment _env;

        private readonly IEmailNotification _iEmailNotification;
        public EquityController(IEmailNotification iemailNotification, IHostingEnvironment env)
        {
            _iEmailNotification = iemailNotification;
            _env = env;
        }

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/equity/getallLookup")]
        public IActionResult GetAllLookup()
        {

            string getAllLookup = "1,2,29,18,25,142,32,95,51,19,25,154";
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

            LiabilityNoteLogic LiabilityNoteLogic = new LiabilityNoteLogic();
            DataTable dt = LiabilityNoteLogic.GetAccountCategoryList();
            NoteLogic _noteLogic = new NoteLogic();
            lstFeeSchedulesConfigDataContract = _noteLogic.GetAllFeeTypesFromFeeSchedulesConfigLiability();
            List<LookupDataContract> lstTransTypeLookups = LiabilityNoteLogic.GetTransactionTypesLookupForJournalEntry();

            try
            {
                if (lstlookupDC != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstLookups = lstlookupDC,
                        dt = dt,
                        lstFeeTypeLookUp = lstFeeSchedulesConfigDataContract,
                        lstTransactionType = lstTransTypeLookups
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
        [Route("api/equity/addnewequity")]
        [Services.Controllers.DeflateCompression]
        public IActionResult AddNewEquity([FromBody] EquityDataContract _equityDC)
        {
            GenericResult _actionResult = null;
            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            string actiontype = "";

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            EquityLogic _equityLogic = new EquityLogic();
            LiabilityNoteLogic liabilityNoteLogic = new LiabilityNoteLogic();
            if (_equityDC.EquityID == null)
            {
                _equityDC.EquityID = 0;
                actiontype = "Insert";
            }
            if (_equityDC.EquityName != _equityDC.OriginalEquityName && actiontype == "")
            {
                actiontype = "Update";
            }
            EquityDataContract result = _equityLogic.InsertUpdateEquity(new Guid(headerUserID), _equityDC);

            if (_equityDC.DebtExtDataList != null)
            {
                foreach (var item in _equityDC.DebtExtDataList)
                {
                    if (item.DebtExtID == null)
                    {
                        item.DebtExtID = 0;
                    }
                }
            }

            if (_equityDC.ListInterestExpense != null)
            {
                foreach (var item in _equityDC.ListInterestExpense)
                {
                    if (item.InterestExpenseScheduleID == null)
                    {
                        item.InterestExpenseScheduleID = 0;
                    }
                }
            }

            //For associated facility schedules saving for Fund
            liabilityNoteLogic.InsertUpdatedLiabilityFeeSchedule(_equityDC.FacilityFeeScheduleList, headerUserID);
            liabilityNoteLogic.InsertUpdateLiabilityRateSpreadSchedule(_equityDC.FacilityRateSpreadScheduleList, headerUserID);
            liabilityNoteLogic.InsertUpdateRepoExtDatafromFundLevel(_equityDC.DebtExtDataList, headerUserID);
            liabilityNoteLogic.InsertUpdateInterestExpenseSchedule(_equityDC.ListInterestExpense, headerUserID);
            liabilityNoteLogic.InsertPrepayAndAdditionalFeeScheduleLiabilityDetail(_equityDC.ListPrepayAndAdditionalFeeScheduleLiabilityDetail, headerUserID);

            if (_equityDC.liabilityMasterFunding != null)
            {
                DataColumn newColumn = new DataColumn("ParentAccountID", typeof(string));
                _equityDC.liabilityMasterFunding.Columns.Add(newColumn);

                foreach (DataRow row in _equityDC.liabilityMasterFunding.Rows)
                {
                    row["ParentAccountID"] = _equityDC.EquityAccountID;
                }

                liabilityNoteLogic.InsertUpdateLiabilityFundingScheduleAggregate(_equityDC.liabilityMasterFunding, headerUserID);
            }

            if (_equityDC.ListLiabilityFundingSchedule != null)
            {
                if (_equityDC.ListLiabilityFundingSchedule.Count > 0)
                {
                    int rowno = 1;

                    foreach (var item in _equityDC.ListLiabilityFundingSchedule)
                    {
                        if (item.AssetAccountID == null || item.AssetAccountID == "")
                        {
                            item.AssetAccountID = "00000000-0000-0000-0000-000000000000";
                        }
                        item.RowNo = rowno;
                        rowno = rowno + 1;

                        if (_equityDC.liabilityMasterFunding.Rows.Count > 0)
                        {
                            foreach (DataRow fundingRow in _equityDC.liabilityMasterFunding.Rows)
                            {
                                DateTime fundingDate = Convert.ToDateTime(fundingRow["TransactionDate"]);
                                if (item.TransactionDate == fundingDate)
                                {
                                    item.Comments = fundingRow["Comments"].ToString();
                                    item.StatusID = fundingRow["StatusID"].ToInt32();
                                    break;
                                }
                            }
                        }
                    }

                }

                liabilityNoteLogic.InsertUpdatedLiabilityFundingSchedule(_equityDC.ListLiabilityFundingSchedule, headerUserID);

            }

            if (_equityDC.ListDealLevelLiabilityFundingSchedule != null)
            {
                foreach (var item in _equityDC.ListDealLevelLiabilityFundingSchedule)
                {
                    item.AccountID = _equityDC.EquityAccountID;
                    item.GeneratedByUserID = headerUserID;

                    if (_equityDC.liabilityMasterFunding.Rows.Count > 0)
                    {
                        foreach (DataRow fundingRow in _equityDC.liabilityMasterFunding.Rows)
                        {
                            DateTime fundingDate = Convert.ToDateTime(fundingRow["TransactionDate"]);
                            if (item.TransactionDate == fundingDate)
                            {
                                item.Comments = fundingRow["Comments"].ToString();
                                item.StatusID = fundingRow["StatusID"].ToInt32();
                                break;
                            }
                        }
                    }

                }
                liabilityNoteLogic.InsertUpdateDealLevelDataLiabilityFundingScheduleDetail(_equityDC.ListDealLevelLiabilityFundingSchedule, headerUserID);
            }

            string LiabilityTypeID = result.EquityGUID.ToString();
            if (_equityDC.ListSelectedXIRRTags != null)
            {
                TagXIRRLogic tagXIRRLogic = new TagXIRRLogic();
                tagXIRRLogic.InsertUpdateTagAccountMappingXIRR(result.EquityAccountID, _equityDC.ListSelectedXIRRTags, headerUserID);
            }
            if (actiontype != "")
            {
                Thread SecondThread = new Thread(() => InsertUpdateAIEntities(_equityDC.EquityName, headerUserID, actiontype, _equityDC.OriginalEquityName));
                SecondThread.Start();
            }

            try
            {
                if (result != null)
                {
                    _actionResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Changes were saved successfully.",
                        LiabilityTypeID = LiabilityTypeID
                    };
                }
                else
                {
                    _actionResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Updation failed",
                    };
                }
            }
            catch (Exception ex)
            {
                string message = ExceptionHelper.GetFullMessage(ex);
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Equity.ToString(), "Error occurred while saving Equity with : Equity ID " + _equityDC.EquityName + " :" + message, _equityDC.EquityName.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/equity/getequitybyequityId")]
        [Services.Controllers.DeflateCompression]
        public IActionResult GetEquityByEquityId([FromBody] EquityDataContract _equityDC)
        {
            GenericResult _acationResult = null;
            EquityDataContract objEquity = new EquityDataContract();
            EquityLogic _equityLogic = new EquityLogic();
            TagXIRRLogic tagXIRRLogic = new TagXIRRLogic();
            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
            NoteLogic _NoteLogic = new NoteLogic();
            DebtLogic _DebtLogic = new DebtLogic();
            IEnumerable<string> headerValues;

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            if (_equityDC.EquityGUID == null)
                _equityDC.EquityGUID = "00000000-0000-0000-0000-000000000000";

            objEquity = _equityLogic.GetEquityByEquityID(new Guid(_equityDC.EquityGUID));
            List<ScheduleEffectiveDateLiabilityDataContract> ListEffectiveDateCount = new List<ScheduleEffectiveDateLiabilityDataContract>();
            ListEffectiveDateCount = LiabilityNotelogic.GetScheduleEffectiveDateCount(new Guid(objEquity.EquityAccountID), null);

            objEquity.ListSelectedXIRRTags = tagXIRRLogic.GetTagMasterXIRRByAccountID(objEquity.EquityAccountID);

            List<HolidayListDataContract> ListHoliday = new List<HolidayListDataContract>();
          
            if (objEquity.CapitalCallNoticeBusinessDays != null && objEquity.CapitalCallNoticeBusinessDays != null)
            {
                ListHoliday = _NoteLogic.GetHolidayList();
                var todaydate = DateTime.Now.Date;
                objEquity.EarliestEquityArrival = DateExtensions.GetnextWorkingDays(Convert.ToDateTime(todaydate), Convert.ToInt16(objEquity.CapitalCallNoticeBusinessDays), "US", ListHoliday).Date;
            }

            objEquity.FileName = _equityLogic.GetFileNameforLiabilityCalcExcelBlob(objEquity.EquityAccountID);

            try
            {
                if (objEquity != null)
                {
                    _acationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        EquityData = objEquity,
                        ListEffectiveDateCount = ListEffectiveDateCount
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
        [Services.Controllers.IsAuthenticate]
        [Route("api/equity/getassociateddebtdataByEquityId")]
        [Services.Controllers.DeflateCompression]
        public IActionResult GetAssociatedDebtDataByEquityId([FromBody] string EquityAccountID)
        {
            GenericResult _acationResult = null;

            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
            DebtLogic _DebtLogic = new DebtLogic();

            DataTable dtAssociatedDebt = new DataTable();
            List<FeeScheduleDataContract> FacilityFeeSchedule = new List<FeeScheduleDataContract>();
            List<LiabilityRateSpreadDataContract> FacilityRateSpreadSchedule = new List<LiabilityRateSpreadDataContract>();
            List<ScheduleEffectiveDateLiabilityDataContract> ListFacilityEffectiveDateCounts = new List<ScheduleEffectiveDateLiabilityDataContract>();
            List<DebtDataContract> ListDebtExtInterest = new List<DebtDataContract>();
            List<InterestExpenseScheduleDataContract> ListInterestExpenseSchedule = new List<InterestExpenseScheduleDataContract>();
            List<PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract> ListPrepayAndAdditionalFeeScheduleLiabilityDetail = new List<PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract>();

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            if (EquityAccountID != null && EquityAccountID != "")
            {

                //For showing associated Debt on Equity Page
                dtAssociatedDebt = LiabilityNotelogic.GetDebtNameforAssociatedEquityFund(EquityAccountID, "Debt");
                if (dtAssociatedDebt != null)
                {
                    foreach (DataRow row in dtAssociatedDebt.Rows)
                    {
                        var feeSchedule = _DebtLogic.GetDebtFeeScheduleByDebtAccountID(new Guid(row["DebtAccountID"].ToString()), new Guid(EquityAccountID));
                        var rateSchedule = LiabilityNotelogic.GetLiabilityRateSpreadScheduleByNoteAccountID(row["DebtAccountID"].ToString(), new Guid(EquityAccountID));
                        var effdatescounts = LiabilityNotelogic.GetScheduleEffectiveDateCount(new Guid(row["DebtAccountID"].ToString()), new Guid(EquityAccountID));
                        var listdebtext = LiabilityNotelogic.GetRepoExtDatafromFundLevel(new Guid(row["DebtAccountID"].ToString()), new Guid(EquityAccountID));
                        var listintexp = LiabilityNotelogic.GetInterestExpenseSchedule(new Guid(row["DebtAccountID"].ToString()), new Guid(EquityAccountID));
                        var lstPrepayAndAdditionalFeeScheduleLiabilityDetail = _DebtLogic.GetPrepayAndAdditionalFeeScheduleLiabilityDetailByAccountID(new Guid(row["DebtAccountID"].ToString()), new Guid(EquityAccountID));


                        FacilityFeeSchedule.AddRange(feeSchedule);
                        FacilityRateSpreadSchedule.AddRange(rateSchedule);
                        ListFacilityEffectiveDateCounts.AddRange(effdatescounts);
                        ListDebtExtInterest.AddRange(listdebtext);
                        ListInterestExpenseSchedule.AddRange(listintexp);
                        ListPrepayAndAdditionalFeeScheduleLiabilityDetail.AddRange(lstPrepayAndAdditionalFeeScheduleLiabilityDetail);
                    }
                }
            }

            try
            {
                if (FacilityFeeSchedule != null)
                {
                    _acationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        dtAssociatedDebt = dtAssociatedDebt,
                        FacilityFeeSchedule = FacilityFeeSchedule,
                        FacilityRateSpreadSchedule = FacilityRateSpreadSchedule,
                        ListFacilityEffectiveDateCounts = ListFacilityEffectiveDateCounts,
                        ListDebtExtInterest = ListDebtExtInterest,
                        lstInterestExpenseSchedule = ListInterestExpenseSchedule,
                        ListPrepayAndAdditionalFeeScheduleLiabilityDetail = ListPrepayAndAdditionalFeeScheduleLiabilityDetail
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
                Log.WriteLogException(CRESEnums.Module.Equity.ToString(), "Error in GetAssociatedDebtDataByEquityId :" + message, EquityAccountID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _acationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_acationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/equity/getEquityNoteByLiabilityTypeID")]
        public IActionResult GetEquityNoteByLiabilityTypeID([FromBody] string LiabilityTypeID)
        {
            GenericResult _authenticationResult = null;
            List<LiabilityNoteDataContract> ListLiabilityNotes = new List<LiabilityNoteDataContract>();
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            LiabilityNoteLogic _LiabilityLogic = new LiabilityNoteLogic();
            if (LiabilityTypeID != null && LiabilityTypeID != "" && LiabilityTypeID != "00000000-0000-0000-0000-000000000000")
            {
                ListLiabilityNotes = _LiabilityLogic.GetDebtorEquityNoteByLiabilityTypeID(new Guid(LiabilityTypeID.ToString()));
            }

            try
            {
                if (ListLiabilityNotes != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstNote = ListLiabilityNotes,
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
                string message = ExceptionHelper.GetFullMessage(ex);
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Equity.ToString(), "Error in GetEquityNoteByLiabilityTypeID :" + message, LiabilityTypeID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/equity/GetEquityTransactionByEquityAccountID")]
        public IActionResult GetEquityTransactionByEquityAccountID([FromBody] string EquityAccountID)
        {
            GenericResult _authenticationResult = null;
            DataTable dt = new DataTable();
            string AnalysisId = "c10f3372-0fc2-4861-a9f5-148f1f80804f";
            var headerUserID = string.Empty;
            EquityDataContract eq = new EquityDataContract();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            LiabilityNoteLogic _Logic = new LiabilityNoteLogic();
            dt = _Logic.GeDebtOrEquityTransactionByAccountID(EquityAccountID, AnalysisId);

            EquityLogic _equityLogic = new EquityLogic();
            eq = _equityLogic.GetEquityCalcInfoByEquityAccountID(new Guid(EquityAccountID), new Guid(headerUserID));
            try
            {
                if (dt != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        LiabilityCashFlow = dt,
                        eqstatus = eq
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
                string message = ExceptionHelper.GetFullMessage(ex);
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Equity.ToString(), "Error in GeDebtOrEquityTransactionByAccountID :" + message, EquityAccountID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/search/getAutosuggestDebtNameSubline")]
        public IActionResult GetAutosuggestDebtNameSubline([FromBody] string searchkey)
        {
            GenericResult _auctionResult = null;
            List<SearchDataContract> lstSearchResult = new List<SearchDataContract>();
            IEnumerable<string> headerValues;
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            EquityLogic _equityLogic = new EquityLogic();
            lstSearchResult = _equityLogic.GetAutosuggestDebtNameSubline(searchkey);

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
        [Route("api/equity/GetEquityJournalLedgerbyJournalEntryMasterID")]
        public IActionResult GetEquityJournalLedgerbyJournalEntryMasterID([FromBody] string DebtEquityAccountID)
        {
            GenericResult _authenticationResult = null;
            List<JournalLedgerDataContract> ListjournalLedger = new List<JournalLedgerDataContract>();
            IEnumerable<string> headerValues;

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();

            JournalEntryLogic _JournalLogic = new JournalEntryLogic();
            ListjournalLedger = _JournalLogic.GetJournalEntryByDebtEquityAccountID(new Guid(DebtEquityAccountID.ToString()));
            try
            {
                if (ListjournalLedger != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        ListjournalLedger = ListjournalLedger
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
                string message = ExceptionHelper.GetFullMessage(ex);
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Equity.ToString(), "Error in GetJournalEntryByDebtEquityAccountID :" + message, DebtEquityAccountID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);


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
        [Route("api/equity/GetHistoricalDataOfModuleByAccountId_Liability")]
        public IActionResult GetHistoricalDataOfModuleByAccountId_Liability([FromBody] EquityDataContract _noteDC, int? pageIndex, int? pageSize)
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

                DataTable dtGeneralSetupDetails = new DataTable();
                DataTable dtPrepayAndAdditionalFeeScheduleDataContract = new DataTable();
                DataTable dtRateSpreadSchedule = new DataTable();
                DataTable dtPrepayAndAdditionalFeeScheduleFacility = new DataTable();
                DataTable dtRateSpreadScheduleFacility = new DataTable();
                DataTable dtInterestExpenseSchedule = new DataTable();

                switch (modulename)
                {
                    case "GeneralSetupDetailsEquity":

                        dtGeneralSetupDetails = LiabilityNotelogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.EquityAccountID), headerUserID, modulename, null);
                        if (dtGeneralSetupDetails.Rows.Count > 0) flag = true;

                        break;
                    case "PrepayAndAdditionalFeeScheduleLiability":

                        dtPrepayAndAdditionalFeeScheduleDataContract = LiabilityNotelogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.EquityAccountID), headerUserID, modulename, null);
                        if (dtPrepayAndAdditionalFeeScheduleDataContract.Rows.Count > 0) flag = true;

                        break;
                    case "RateSpreadScheduleLiability":

                        dtRateSpreadSchedule = LiabilityNotelogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.EquityAccountID), headerUserID, modulename, null);
                        if (dtRateSpreadSchedule.Rows.Count > 0) flag = true;

                        break;
                    case "FacilityPrepayAndAdditionalFeeScheduleLiability":

                        dtPrepayAndAdditionalFeeScheduleFacility = LiabilityNotelogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.FacilityAccountID), headerUserID, "PrepayAndAdditionalFeeScheduleLiability", new Guid(_noteDC.EquityAccountID));
                        if (dtPrepayAndAdditionalFeeScheduleFacility.Rows.Count > 0) flag = true;

                        break;
                    case "FacilityRateSpreadScheduleLiability":

                        dtRateSpreadScheduleFacility = LiabilityNotelogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.FacilityAccountID), headerUserID, "RateSpreadScheduleLiability", new Guid(_noteDC.EquityAccountID));
                        if (dtRateSpreadScheduleFacility.Rows.Count > 0) flag = true;

                        break;
                    case "InterestExpenseSchedule":

                        dtInterestExpenseSchedule = LiabilityNotelogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.FacilityAccountID), headerUserID, "InterestExpenseSchedule", new Guid(_noteDC.EquityAccountID));
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
                        lstGeneralSetupDetails = dtGeneralSetupDetails,
                        lstPrepayAndAdditionalFeeScheduleDataContract = dtPrepayAndAdditionalFeeScheduleDataContract,
                        lstRateSpreadSchedule = dtRateSpreadSchedule,
                        lstFacilityFeeHistory = dtPrepayAndAdditionalFeeScheduleFacility,
                        lstFacilityRateSpreadHistory = dtRateSpreadScheduleFacility,
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
                string message = ExceptionHelper.GetFullMessage(ex);
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Equity.ToString(), "Error in GetHistoricalDataOfModuleByNoteId :" + message, _noteDC.EquityAccountID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);


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
        [Route("api/equity/checkduplicateforliabilities")]
        public IActionResult CheckDuplicateforLiabilities([FromBody] EquityDataContract _equityDC)
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
            Status = LiabilityNotelogic.CheckDuplicateforLiabilities(_equityDC.EquityName, _equityDC.modulename, new Guid(_equityDC.EquityAccountID));
            if (Status == "True")
            {
                msg = "Equity " + _equityDC.EquityName + " already exist. Please enter unique Equity Name.";

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
        [Route("api/equity/queueEquityForCalculation")]
        public IActionResult QueueEquityForCalculation([FromBody] string EquityAccountID)
        {
            v1GenericResult _authenticationResult = null;
            LoggerLogic Log = new LoggerLogic();

            try
            {

                List<CalculationRequestsLiabilityDataContract> list = new List<CalculationRequestsLiabilityDataContract>();
                LiabilityCalcLogic lbcLogic = new LiabilityCalcLogic();

                //for c#
                list.Add(new CalculationRequestsLiabilityDataContract
                {
                    AccountID = EquityAccountID,
                    CalcEngineType = 797,//c#
                    CalcType = 910,
                    StatusText = "Processing",
                    RequestFrom = "EquityPage"
                });
                //for v1 interest
                list.Add(new CalculationRequestsLiabilityDataContract
                {
                    AccountID = EquityAccountID,
                    CalcEngineType = 798,//v1
                    CalcType = 911,
                    StatusText = "CalcWait",
                    RequestFrom = "EquityPage"
                });
                //for v1 fee
                list.Add(new CalculationRequestsLiabilityDataContract
                {
                    AccountID = EquityAccountID,
                    CalcEngineType = 798,//v1
                    CalcType = 935,
                    StatusText = "CalcWait",
                    RequestFrom = "EquityPage"
                });
                if (list != null && list.Count > 0)
                {

                    //GenerateAutomationLogic.QueueDealForAutomation(list, useridforSys_Scheduler);
                    lbcLogic.QueueLiabilityForCalculation(list, useridforSys_Scheduler);
                    Log.WriteLogInfo(CRESEnums.Module.EquityCalculator.ToString(), "QueueEquityForCalculation ended  ", "", "");
                }
                else
                {
                    Log.WriteLogInfo(CRESEnums.Module.EquityCalculator.ToString(), "QueueEquityForCalculation no record found ", "", "");
                }
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                    Succeeded = true,
                    Message = "Equity Queued for Calculation. ",
                    ErrorDetails = ""
                };
            }
            catch (Exception ex)
            {
                Log.WriteLogExceptionMessage(CRESEnums.Module.EquityCalculator.ToString(), ex.StackTrace, "", "", "QueueEquityForCalculation", "Error occurred " + " " + ex.Message);
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error occurred while Queuing Equity for Calculation. Please contact administrator.",
                    ErrorDetails = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/equity/getEquityCalcInfoByEquityAccountID")]
        public IActionResult GetEquityCalcInfoByEquityAccountID([FromBody] EquityDataContract equityData)
        {
            GenericResult _authenticationResult = null;
            EquityDataContract eq = new EquityDataContract();
            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            EquityLogic _equityLogic = new EquityLogic();
            eq = _equityLogic.GetEquityCalcInfoByEquityAccountID(new Guid(equityData.EquityAccountID), new Guid(headerUserID));

            try
            {
                if (eq != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        eqstatus = eq
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
        [Route("api/equity/getEquityCashflowsExportExcel")]
        public IActionResult GetEquityCashflowsExportExcel([FromBody] string EquityAccountID)
        {
            GenericResult _authenticationResult = null;
            DataTable lstEquityCashflowsExportData = new DataTable();
            DataTable lstEquityCashflowsDetail = new DataTable();
            var headerUserID = new Guid();
            string AnalysisId = "c10f3372-0fc2-4861-a9f5-148f1f80804f";

            try
            {
                if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
                {
                    headerUserID = new Guid(Request.Headers["TokenUId"]);
                };

                EquityLogic _Logic = new EquityLogic();
                string AccountId = EquityAccountID.Split("||")[0];
                string Type = EquityAccountID.Split("||")[1];

                lstEquityCashflowsExportData = _Logic.GeDebtOrEquityCashflowExportData(AccountId, AnalysisId, Type);
                lstEquityCashflowsDetail = _Logic.GetCashflowExportDataDetail(AccountId, AnalysisId, Type);

                foreach (DataColumn column in lstEquityCashflowsExportData.Columns)
                {
                    column.ColumnName = column.ColumnName.Replace("_", " ");
                }

                // Export to excel
                DataSet ds = new DataSet();
                lstEquityCashflowsExportData.TableName = "Cashflow Aggregated";
                ds.Tables.Add(lstEquityCashflowsExportData);

                lstEquityCashflowsDetail.TableName = "Cashflow";
                ds.Tables.Add(lstEquityCashflowsDetail);


                Stream stream = new StreamReader(_env.WebRootPath + "/ExcelTemplate/" + "DebtorEquityCashflow_download.xlsx").BaseStream;
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

        [HttpPost]
        [Route("api/equity/getEquityCapitalContributionExportExcel")]
        public IActionResult GetEquityCapitalContributionExportExcel([FromBody] string EquityAccountID)
        {
            GenericResult _authenticationResult = null;
            DataTable lstEquityCapitalContributionExportData = new DataTable();
            var headerUserID = new Guid();

            try
            {
                if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
                {
                    headerUserID = new Guid(Request.Headers["TokenUId"]);
                };

                EquityLogic _Logic = new EquityLogic();
                lstEquityCapitalContributionExportData = _Logic.GetEquityCapitalContributionExportExcel(EquityAccountID);

                foreach (DataColumn column in lstEquityCapitalContributionExportData.Columns)
                {
                    column.ColumnName = column.ColumnName.Replace("_", " ");
                }

                // Export to excel
                DataSet ds = new DataSet();
                lstEquityCapitalContributionExportData.TableName = "Transactions";
                ds.Tables.Add(lstEquityCapitalContributionExportData);

                Stream stream = new StreamReader(_env.WebRootPath + "/ExcelTemplate/" + "DebtorEquityTransactionsData.xlsx").BaseStream;
                MemoryStream ms = WriteDataToExcel(ds, stream);
                return File(ms, "application/octet-stream");

            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.CashFlowDownload.ToString(), "Error occurred in Capital Contribution download ", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
                return Ok(_authenticationResult);
            }

        }

        [HttpPost]
        [Route("api/equity/getCashflowTabUIDataforonlyEquityExportExcel")]
        public IActionResult GetCashflowTabUIDataforonlyEquityExportExcel([FromBody] string EquityAccountID)
        {
            GenericResult _authenticationResult = null;
            DataTable dt = new DataTable();
            var headerUserID = new Guid();
            string AnalysisId = "c10f3372-0fc2-4861-a9f5-148f1f80804f";

            try
            {
                if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
                {
                    headerUserID = new Guid(Request.Headers["TokenUId"]);
                };

                LiabilityNoteLogic _Logic = new LiabilityNoteLogic();
                dt = _Logic.GeDebtOrEquityTransactionByAccountID(EquityAccountID, AnalysisId);

                dt.Columns.Remove("UpdatedDate"); 
                dt.Columns.Remove("UpdatedBy");
                dt.Columns.Remove("CreatedDate");
                dt.Columns.Remove("CreatedBy");
                dt.Columns.Remove("OriginalIndex");
                dt.Columns.Remove("SpreadValue");

                if (dt.Columns.Contains("Date"))
                {
                    dt.Columns["Date"].ColumnName = "Transaction Date"; 
                }
                if (dt.Columns.Contains("Amount"))
                {
                    dt.Columns["Amount"].ColumnName = "Transaction Amount";
                }
                if (dt.Columns.Contains("Type"))
                {
                    dt.Columns["Type"].ColumnName = "Transaction Type";
                }
                if (dt.Columns.Contains("AllInCouponRate"))
                {
                    dt.Columns["AllInCouponRate"].ColumnName = "Effective Rate";
                }
                if (dt.Columns.Contains("EndingBalance"))
                {
                    dt.Columns["EndingBalance"].ColumnName = "Ending Balance";
                }
                if (dt.Columns.Contains("DealName"))
                {
                    dt.Columns["DealName"].ColumnName = "Deal Name";
                }

                // Export to excel
                DataSet ds = new DataSet();
                dt.TableName = "Cashflow Export";
                ds.Tables.Add(dt);

                Stream stream = new StreamReader(_env.WebRootPath + "/ExcelTemplate/" + "EquityCashflowTabUIDataExportExcel.xlsx").BaseStream;
                MemoryStream ms = WriteDataToExcel(ds, stream);
                return File(ms, "application/octet-stream");

            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.CashFlowDownload.ToString(), "Error occurred in GetCashflowTabUIDataforonlyEquityExportExcel download ", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
                return Ok(_authenticationResult);
            }

        }


        [HttpPost]
        [Route("api/equity/getliabilitycalcExcelBlobData")]
        public IActionResult GetLiabilityCalcExcelBlobData([FromBody] string FileName)
        {
            GenericResult _authenticationResult = null;

            GetConfigSetting();
            var connectionString = Sectionroot.GetSection("storage:container:connectionstring").Value;
            var sourceContainerName = Sectionroot.GetSection("storage:container:name").Value;
            try
            {
                DataSet ds = GetExcelBlobData(FileName, connectionString, sourceContainerName);

                Stream stream = new StreamReader(_env.WebRootPath + "/ExcelTemplate/" + "LiabilityTransactions.xlsx").BaseStream;
                MemoryStream ms = WriteDataToExcel(ds, stream);
                return File(ms, "application/octet-stream");
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

        public static DataSet GetExcelBlobData(string filename, string connectionString, string containerName)
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(connectionString);

            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();

            CloudBlobContainer container = blobClient.GetContainerReference(containerName);

            CloudBlockBlob blockBlobReference = container.GetBlockBlobReference(filename);
            DataSet ds;
            try
            {

                using (var memoryStream = new MemoryStream())
                {
                    blockBlobReference.DownloadToStream(memoryStream);
                    var excelReader = ExcelReaderFactory.CreateOpenXmlReader(memoryStream);

                    var conf = new ExcelDataSetConfiguration
                    {
                        ConfigureDataTable = _ => new ExcelDataTableConfiguration
                        {
                            UseHeaderRow = true
                        }
                    };

                    ds = excelReader.AsDataSet(conf);

                    excelReader.Close();
                }
            }
            catch (Exception ex)
            {
                var error = ex.Message;
                throw;
            }
            return ds;
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

        public void InsertUpdateAIEntities(string entity_names, string userid, string actiontype, string originalname)
        {
            AIDynamicEntityUpdateLogic _dynamicentity = new AIDynamicEntityUpdateLogic();
            _dynamicentity.InsertUpdateAIEntitiesAsync("EquityName", entity_names, userid, actiontype, originalname);

        }

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/equity/getCashAccount")]
        public IActionResult GetCashAccount()
        {

            GenericResult _authenticationResult = null;
            List<CashAccountDataContract> lstCashAccount = new List<CashAccountDataContract>();
            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            EquityLogic _equityLogic = new EquityLogic();

            lstCashAccount = _equityLogic.GetCashAccount();
            try
            {
                if (lstCashAccount != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        _lstCashAccount = lstCashAccount
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
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occured in GetCashAccount", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/equity/getLiabilityCalculationStatus")]
        public IActionResult GetLiabilityCalculationStatus([FromBody] string scenarioID)
        {
            GenericResult _authenticationResult = null;
            List<LiabilityCalcDataContract> lstCalculationStatus = new List<LiabilityCalcDataContract>();
            List<LiabilityCalcDataContract> LiabilityCalculationUpdated = new List<LiabilityCalcDataContract>();

            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            LiabilityCalcLogic devDlogic = new LiabilityCalcLogic();
            lstCalculationStatus = devDlogic.GetCalculationStaus(new Guid(scenarioID));

            if (lstCalculationStatus.Count > 0)
            {
                var disticLiabilityName = lstCalculationStatus.Select(x => x.LiabilityName).Distinct();

                foreach (var item in disticLiabilityName)
                {
                    string currentStatus = "";
                    string LastStatus = "";
                    string errormessage = "";
                    string LiabilityID = "";
                    Guid? AccountID = new Guid();
                    DateTime? startdate = DateTime.MinValue;
                    DateTime? Enddate = DateTime.MinValue;
                    DateTime? RequestTime = DateTime.MinValue;
                    LiabilityCalcDataContract data = new LiabilityCalcDataContract();
                    var funddata = lstCalculationStatus.FindAll(x => x.LiabilityName == item);
                    var disticstatus = funddata.Select(x => x.CalcStatus).Distinct();
                    int disticstatusCount = disticstatus.Count();
                    foreach (var fund in funddata)
                    {
                        string status1 = fund.CalcStatus;
                        AccountID = fund.AccountID;
                        LiabilityID =fund.LiabilityID;
                        if (startdate < fund.StartTime)
                        {
                            startdate = fund.StartTime;
                        }
                        if (Enddate < fund.EndTime)
                        {
                            Enddate = fund.EndTime;
                        }
                        if (RequestTime < fund.RequestTime)
                        {
                            RequestTime = fund.RequestTime;
                        }
                        

                        if (disticstatusCount > 1)
                        {
                            currentStatus = fund.CalcStatus;
                            if (LastStatus == "")
                            {
                                LastStatus = fund.CalcStatus;
                            }
                            if (status1 == "Failed")
                            {
                                currentStatus = "Failed";
                                LastStatus = "Failed";
                                if (fund.ErrorMessage != "")
                                {
                                    errormessage = fund.ErrorMessage;
                                }
                                break;
                            }
                            else
                            {
                                currentStatus = GetStatustext(currentStatus, LastStatus);
                            }
                            LastStatus = fund.CalcStatus;
                        }
                        else
                        {
                            if (status1 == "Failed")
                            {
                                if (fund.ErrorMessage != "")
                                {
                                    errormessage = fund.ErrorMessage;
                                }
                            }
                            else
                            {
                                errormessage = "";
                            }
                            currentStatus = status1;
                        }
                    }

                    data.LiabilityName = item;
                    data.ErrorMessage = errormessage;
                    data.StartTime = startdate;
                    data.EndTime = Enddate;
                    data.RequestTime = RequestTime;                    
                    data.CalcStatus = currentStatus;
                    data.AccountID = AccountID;
                    data.LiabilityID = LiabilityID;

                    LiabilityCalculationUpdated.Add(data);
                }


            }
            try
            {
                if (lstCalculationStatus != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        LiabilityCalculationStatus = LiabilityCalculationUpdated
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

        public string GetStatustext(string currentStatus, string lastStatus)
        {
            string Statustext = "";

            if (lastStatus == "Completed")
            {
                Statustext = "Completed";
                if (currentStatus == "Running" || currentStatus == "Processing")
                {
                    Statustext = "Running";
                }
                else
                {
                    Statustext = "Completed";
                }

            }
            else if (lastStatus == "Processing" && currentStatus == "Processing")
            {
                Statustext = "Processing";
            }
            else if (lastStatus == "Running" && currentStatus == "Running")
            {
                Statustext = "Running";
            }
            else { Statustext = "Processing"; }

            return Statustext;
        }
        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/equity/getLiabilityCalculationStatusForDashBoard")]
        public IActionResult GetLiabilityCalculationStatusForDashBoard([FromBody] string scenarioID)
        {
            GenericResult _authenticationResult = null;
            List<LiabilityCalcDataContract> lstCalculationStatus = new List<LiabilityCalcDataContract>();

            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            LiabilityCalcLogic devDlogic = new LiabilityCalcLogic();
            lstCalculationStatus = devDlogic.GetLiabilityCalculationStatusForDashBoard(new Guid(scenarioID));
            try
            {
                if (lstCalculationStatus != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        LiabilityCalculationStatus = lstCalculationStatus
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
        [Route("api/equity/getLiabilitySummaryDashBoard")]
        public IActionResult GetLiabilitySummaryDashBoard()
        {
            GenericResult _authenticationResult = null;
            DataTable dt = new DataTable();

            LiabilityCalcLogic devDlogic = new LiabilityCalcLogic();
            dt = devDlogic.GetLiabilitySummaryDashBoard();
            foreach (DataColumn column in dt.Columns)
            {
                column.ColumnName = column.ColumnName.Replace("_", "");
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
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Route("api/equity/GetExportExcelLiabilitySummaryDashBoard")]
        public IActionResult GetExportExcelLiabilitySummaryDashBoard([FromBody] dynamic jsonparameters)
        {
            LiabilityCalcLogic devDlogic = new LiabilityCalcLogic();

            GenericResult _authenticationResult = null;
            DataTable dt = new DataTable();

            var headerUserID = new Guid();

            try
            {
                if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
                {
                    headerUserID = new Guid(Request.Headers["TokenUId"]);
                };

                dt = devDlogic.GetLiabilitySummaryDashBoard();

                foreach (DataColumn column in dt.Columns)
                {
                    column.ColumnName = column.ColumnName.Replace("_", " ");
                }

                // Export to excel
                DataSet ds = new DataSet();
                dt.TableName = "Liability_Relationship";
                ds.Tables.Add(dt);


                Stream stream = new StreamReader(_env.WebRootPath + "/ExcelTemplate/" + "GetLiabilityRelationshipTemplate.xlsx").BaseStream;
                MemoryStream ms = WriteDataToExcel(ds, stream);
                return File(ms, "application/octet-stream");

            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.XIRRDownload.ToString(), "Error occurred in cashflow download ", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
                return Ok(_authenticationResult);
            }

        }

        [HttpPost]
        [Route("api/equity/queueEquityListForCalculation")]
        public IActionResult QueueEquityListForCalculation([FromBody] List<string> EquityAccountList)
        {
            v1GenericResult _authenticationResult = null;
            LoggerLogic Log = new LoggerLogic();

            try
            {
                foreach (string EquityAccountID in EquityAccountList)
                {
                    QueueEquityForCalculation(EquityAccountID);
                }

                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status200OK,
                    Succeeded = true,
                    Message = "Equity Queued for Calculation. ",
                    ErrorDetails = ""
                };
            }
            catch (Exception ex)
            {
                Log.WriteLogExceptionMessage(CRESEnums.Module.EquityCalculator.ToString(), ex.StackTrace, "", "", "QueueEquityForCalculation", "Error occurred " + " " + ex.Message);
                _authenticationResult = new v1GenericResult()
                {
                    Status = Microsoft.AspNetCore.Http.StatusCodes.Status500InternalServerError,
                    Succeeded = false,
                    Message = "Error occurred while Queuing Equity for Calculation. Please contact administrator.",
                    ErrorDetails = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }
    }
}
