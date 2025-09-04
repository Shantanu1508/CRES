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
using CRES.Utilities;
using CRES.DataContract.WorkFlow;
using System.Data;
using static CRES.DataContract.V1CalcDataContract;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Text;
using System.Threading;

namespace CRES.ServiceMVC.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]

    public class DebtController : ControllerBase
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
        private IHostingEnvironment _env;

        private readonly IEmailNotification _iEmailNotification;

        public DebtController(IEmailNotification iemailNotification, IHostingEnvironment env)
        {
            _iEmailNotification = iemailNotification;
            _env = env;
        }

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/debt/getallLookup")]
        public IActionResult GetAllLookup()
        {
            string message = "";
            string getAllLookup = "1,2,29,18,25,142,32,95,51,19,25,154";
            GenericResult _authenticationResult = null;
            List<LookupDataContract> lstlookupDC = new List<LookupDataContract>();
            List<LookupDataContract> ListofFundName = new List<LookupDataContract>();
            List<FeeSchedulesConfigDataContract> lstFeeSchedulesConfigDataContract = new List<FeeSchedulesConfigDataContract>();
            DataTable dt = new DataTable();
            List<LookupDataContract> lstTransTypeLookups = new List<LookupDataContract>();
            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            if (headerUserID != "")
            {
                LookupLogic lookupLogic = new LookupLogic();
                LiabilityNoteLogic LiabilityNoteLogic = new LiabilityNoteLogic();
                NoteLogic _noteLogic = new NoteLogic();
                DebtLogic _dtLogic = new DebtLogic();   

                lstlookupDC = lookupLogic.GetAllLookups(getAllLookup);
                lstlookupDC = lstlookupDC.OrderBy(x => x.SortOrder).ToList();
                dt = LiabilityNoteLogic.GetAccountCategoryList();
                lstFeeSchedulesConfigDataContract = _noteLogic.GetAllFeeTypesFromFeeSchedulesConfigLiability();
                ListofFundName = _dtLogic.GetListofFundNameShortName();
                lstTransTypeLookups = LiabilityNoteLogic.GetTransactionTypesLookupForJournalEntry();
            }
            else
            {
                message = "Authentication failed";
            }

            try
            {
                if (lstlookupDC != null && message == "")
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstLookups = lstlookupDC,
                        dt = dt,
                        lstFeeTypeLookUp = lstFeeSchedulesConfigDataContract,
                        ListofFundName = ListofFundName,
                        lstTransactionType = lstTransTypeLookups
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = message
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
        [Route("api/debt/InsertUpdatedebt")]
        public IActionResult InsertUpdateDebt([FromBody] DebtDataContract debt)
        {
            string noteid = "";
            string analysisID = "";
            string actiontype = "";
            GenericResult _authenticationResult = null;

            var ss = debt.DetailFunding;

            IEnumerable<string> headerValues;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            if (debt.DebtID == null)
            {
                debt.DebtID = 0;
                actiontype = "Insert";
            }
            if (debt.DebtName != debt.OriginalDebtName && actiontype == "")
            {
                actiontype = "Update";
            }
            DebtLogic _DebtLogic = new DebtLogic();
            LiabilityNoteLogic liabilityNoteLogic = new LiabilityNoteLogic();
            DebtDataContract res = _DebtLogic.InsertUpdateDebt(debt, headerUserID);

            string debtAccountID = res.DebtAccountID.ToString();
            string LiabilityTypeID = res.DebtGUID;

            if (debt.DebtExtDataList != null)
            {
                foreach (var item in debt.DebtExtDataList)
                {
                    if (item.DebtExtID == null)
                    {
                        item.DebtExtID = 0;
                    }
                }
            }

            if (debt.ListInterestExpense != null)
            {
                foreach (var item in debt.ListInterestExpense)
                {
                    if (item.InterestExpenseScheduleID == null)
                    {
                        item.InterestExpenseScheduleID = 0;
                    }
                }
            }

            liabilityNoteLogic.InsertUpdatedLiabilityFeeSchedule(debt.FeeScheduleList, headerUserID);
            liabilityNoteLogic.InsertUpdateLiabilityRateSpreadSchedule(debt.ListLiabilityRate, headerUserID);

            liabilityNoteLogic.InsertUpdateRepoExtDatafromFundLevel(debt.DebtExtDataList, headerUserID);
            liabilityNoteLogic.InsertUpdateInterestExpenseSchedule(debt.ListInterestExpense, headerUserID);
            liabilityNoteLogic.InsertPrepayAndAdditionalFeeScheduleLiabilityDetail(debt.ListPrepayAndAdditionalFeeScheduleLiabilityDetail,headerUserID);

            if (debt.liabilityMasterFunding != null)
            {
                DataColumn newColumn = new DataColumn("ParentAccountID", typeof(string));
                debt.liabilityMasterFunding.Columns.Add(newColumn);

                foreach (DataRow row in debt.liabilityMasterFunding.Rows)
                {
                    row["ParentAccountID"] = "00000000-0000-0000-0000-000000000000";
                }

                liabilityNoteLogic.InsertUpdateLiabilityFundingScheduleAggregate(debt.liabilityMasterFunding, headerUserID);
            }

            if (debt.ListLiabilityFundingSchedule != null)
            {
                if (debt.ListLiabilityFundingSchedule.Count > 0)
                {
                    int rowno = 1;
                    foreach (var item in debt.ListLiabilityFundingSchedule)
                    {
                        if (item.AssetAccountID == null || item.AssetAccountID == "")
                        {
                            item.AssetAccountID = "00000000-0000-0000-0000-000000000000";
                        }
                        item.RowNo = rowno;
                        rowno = rowno + 1;

                        if (debt.liabilityMasterFunding.Rows.Count > 0)
                        {
                            foreach (DataRow fundingRow in debt.liabilityMasterFunding.Rows)
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
                    liabilityNoteLogic.InsertUpdatedLiabilityFundingSchedule(debt.ListLiabilityFundingSchedule, headerUserID);

                }
            }
            if (debt.ListDealLevelLiabilityFundingSchedule != null)
            {
                foreach (var item in debt.ListDealLevelLiabilityFundingSchedule)
                {
                    item.AccountID = Convert.ToString(debt.DebtAccountID);
                    item.GeneratedByUserID = headerUserID;

                    if (debt.liabilityMasterFunding.Rows.Count > 0)
                    {
                        foreach (DataRow fundingRow in debt.liabilityMasterFunding.Rows)
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
                liabilityNoteLogic.InsertUpdateDealLevelDataLiabilityFundingScheduleDetail(debt.ListDealLevelLiabilityFundingSchedule, headerUserID);
            }

            if (actiontype != "")
            {
                Thread SecondThread = new Thread(() => InsertUpdateAIEntities(debt.DebtName, headerUserID, actiontype, debt.OriginalDebtName));
                SecondThread.Start();
            }
            if (debt.ListSelectedXIRRTags != null)
            {
                TagXIRRLogic tagXIRRLogic = new TagXIRRLogic();
                tagXIRRLogic.InsertUpdateTagAccountMappingXIRR(debtAccountID, debt.ListSelectedXIRRTags, headerUserID);

            }

            try
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Authentication succeeded",
                    LiabilityTypeID = LiabilityTypeID

                };
            }
            catch (Exception ex)
            {
                string message = ExceptionHelper.GetFullMessage(ex);
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Debt.ToString(), "Error in InsertUpdateDebt :" + message, debt.DebtID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/debt/getDebtNoteByLiabilityTypeID")]
        public IActionResult GetDebtNoteByLiabilityTypeID([FromBody] string LiabilityTypeID)
        {
            GenericResult _authenticationResult = null;
            List<LiabilityNoteDataContract> ListLiabilityNotes = new List<LiabilityNoteDataContract>();

            IEnumerable<string> headerValues;

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
                Log.WriteLogException(CRESEnums.Module.Debt.ToString(), "Error in GetDebtNoteByLiabilityTypeID :" + message, LiabilityTypeID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/debt/GetDebtDataByDebtGUID")]
        public IActionResult GetDebtDataByDebtGUID([FromBody] string DebtGUID)
        {
            GenericResult _authenticationResult = null;
            List<LiabilityNoteDataContract> ListLiabilityNotes = new List<LiabilityNoteDataContract>();
            DebtDataContract debtdc = new DebtDataContract();
            IEnumerable<string> headerValues;

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DebtLogic _DebtLogic = new DebtLogic();
            debtdc = _DebtLogic.GetDebtByDebtID(new Guid(DebtGUID.ToString()));

            TagXIRRLogic tagXIRRLogic = new TagXIRRLogic();
            debtdc.ListSelectedXIRRTags = tagXIRRLogic.GetTagMasterXIRRByAccountID(debtdc.DebtAccountID.ToString());

            //For showing associated Equity on Debt Page
            LiabilityNoteLogic liabilityNoteLogic = new LiabilityNoteLogic();
            DataTable dtAssociatedDebt = liabilityNoteLogic.GetDebtNameforAssociatedEquityFund(Convert.ToString(debtdc.DebtAccountID), "Equity");

            List<FeeScheduleDataContract> FacilityFeeSchedule = new List<FeeScheduleDataContract>();
            List<LiabilityRateSpreadDataContract> FacilityRateSpreadSchedule = new List<LiabilityRateSpreadDataContract>();
            List<ScheduleEffectiveDateLiabilityDataContract> ListFacilityEffectiveDateCounts = new List<ScheduleEffectiveDateLiabilityDataContract>();
            List<DebtDataContract> ListDebtExtInterest = new List<DebtDataContract>();
            List<InterestExpenseScheduleDataContract> ListInterestExpenseSchedule = new List<InterestExpenseScheduleDataContract>();
            List<PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract> ListPrepayAndAdditionalFeeScheduleLiabilityDetail = new List<PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract>();

            if (dtAssociatedDebt != null)
            {
                foreach (DataRow row in dtAssociatedDebt.Rows)
                {
                    var feeSchedule = _DebtLogic.GetDebtFeeScheduleByDebtAccountID(debtdc.DebtAccountID, new Guid(row["EquityAccountID"].ToString()));
                    var rateSchedule = liabilityNoteLogic.GetLiabilityRateSpreadScheduleByNoteAccountID(Convert.ToString(debtdc.DebtAccountID), new Guid(row["EquityAccountID"].ToString()));
                    var effdatescounts = liabilityNoteLogic.GetScheduleEffectiveDateCount(debtdc.DebtAccountID, new Guid(row["EquityAccountID"].ToString()));
                    var listdebtext = liabilityNoteLogic.GetRepoExtDatafromFundLevel(debtdc.DebtAccountID, new Guid(row["EquityAccountID"].ToString()));
                    var listintexp = liabilityNoteLogic.GetInterestExpenseSchedule(debtdc.DebtAccountID, new Guid(row["EquityAccountID"].ToString()));
                    var lstPrepayAndAdditionalFeeScheduleLiabilityDetail = _DebtLogic.GetPrepayAndAdditionalFeeScheduleLiabilityDetailByAccountID(debtdc.DebtAccountID, new Guid(row["EquityAccountID"].ToString()));

                    FacilityFeeSchedule.AddRange(feeSchedule);
                    FacilityRateSpreadSchedule.AddRange(rateSchedule);
                    ListFacilityEffectiveDateCounts.AddRange(effdatescounts);
                    ListDebtExtInterest.AddRange(listdebtext);
                    ListInterestExpenseSchedule.AddRange(listintexp);
                    ListPrepayAndAdditionalFeeScheduleLiabilityDetail.AddRange(lstPrepayAndAdditionalFeeScheduleLiabilityDetail);
                }
            }

            try
            {
                if (ListLiabilityNotes != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        Debtdc = debtdc,
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
                Log.WriteLogException(CRESEnums.Module.Debt.ToString(), "Error in GetDebtDataByDebtGUID :" + message, DebtGUID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/debt/GetDebtTransactionByDebtAccountID")]
        public IActionResult GetDebtTransactionByDebtAccountID([FromBody] string DebtAccountID)
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
            dt = _Logic.GeDebtOrEquityTransactionByAccountID(DebtAccountID, AnalysisId);
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
                string message = ExceptionHelper.GetFullMessage(ex);
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Debt.ToString(), "Error in GetDebtTransactionByDebtAccountID :" + message, DebtAccountID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/debt/GetDebtFeeScheduleByDebtAccountID")]
        public IActionResult GetDebtFeeScheduleByDebtAccountID([FromBody] string DebtAccountID)
        {
            GenericResult _authenticationResult = null;
            List<FeeScheduleDataContract> ListFeeSchedule = new List<FeeScheduleDataContract>();
            List<PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract> ListPrepayAndAdditionalFeeScheduleLiabilityDetail = new List<PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract>();
            IEnumerable<string> headerValues;

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            List<ScheduleEffectiveDateLiabilityDataContract> ListEffectiveDateCount = new List<ScheduleEffectiveDateLiabilityDataContract>();
            DebtLogic _DebtLogic = new DebtLogic();
            LiabilityNoteLogic LiabilityNotelogic = new LiabilityNoteLogic();
            ListFeeSchedule = _DebtLogic.GetDebtFeeScheduleByDebtAccountID(new Guid(DebtAccountID.ToString()),null);
            ListPrepayAndAdditionalFeeScheduleLiabilityDetail = _DebtLogic.GetPrepayAndAdditionalFeeScheduleLiabilityDetailByAccountID(new Guid(DebtAccountID.ToString()), null);

            ListEffectiveDateCount = LiabilityNotelogic.GetScheduleEffectiveDateCount(new Guid(DebtAccountID), null);

            try
            {
                if (ListFeeSchedule != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        ListFeeSchedule = ListFeeSchedule,
                        ListEffectiveDateCount = ListEffectiveDateCount,
                        ListPrepayAndAdditionalFeeScheduleLiabilityDetail = ListPrepayAndAdditionalFeeScheduleLiabilityDetail
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
                Log.WriteLogException(CRESEnums.Module.Debt.ToString(), "Error in GetDebtFeeScheduleByDebtAccountID :" + message, DebtAccountID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/debt/GetDebtJournalLedgerbyJournalEntryMasterID")]
        public IActionResult GetDebtJournalLedgerbyJournalEntryMasterID([FromBody] string DebtEquityAccountID)
        {
            GenericResult _authenticationResult = null;
            List<JournalLedgerDataContract> ListjournalLedger = new List<JournalLedgerDataContract>();
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
                Log.WriteLogException(CRESEnums.Module.Debt.ToString(), "Error in GetJournalEntryByDebtEquityAccountID :" + message, DebtEquityAccountID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/debt/GetHistoricalDataOfModuleByAccountId_Liability")]
        public IActionResult GetHistoricalDataOfModuleByAccountId_Liability([FromBody] DebtDataContract _noteDC, int? pageIndex, int? pageSize)
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
                    case "GeneralSetupDetailsDebt":

                        dtGeneralSetupDetails = LiabilityNotelogic.GetHistoricalDataOfModuleByNoteId(_noteDC.DebtAccountID, headerUserID, modulename, null);
                        if (dtGeneralSetupDetails.Rows.Count > 0) flag = true;

                        break;
                    case "PrepayAndAdditionalFeeScheduleLiability":

                        dtPrepayAndAdditionalFeeScheduleDataContract = LiabilityNotelogic.GetHistoricalDataOfModuleByNoteId(_noteDC.DebtAccountID, headerUserID, modulename, null);
                        if (dtPrepayAndAdditionalFeeScheduleDataContract.Rows.Count > 0) flag = true;

                        break;
                    case "RateSpreadScheduleLiability":

                        dtRateSpreadSchedule = LiabilityNotelogic.GetHistoricalDataOfModuleByNoteId(_noteDC.DebtAccountID, headerUserID, modulename, null);
                        if (dtRateSpreadSchedule.Rows.Count > 0) flag = true;

                        break;
                    case "FacilityPrepayAndAdditionalFeeScheduleLiability":

                        dtPrepayAndAdditionalFeeScheduleFacility = LiabilityNotelogic.GetHistoricalDataOfModuleByNoteId(_noteDC.DebtAccountID, headerUserID, "PrepayAndAdditionalFeeScheduleLiability", _noteDC.AdditionalAccountID);
                        if (dtPrepayAndAdditionalFeeScheduleFacility.Rows.Count > 0) flag = true;

                        break;
                    case "FacilityRateSpreadScheduleLiability":

                        dtRateSpreadScheduleFacility = LiabilityNotelogic.GetHistoricalDataOfModuleByNoteId(_noteDC.DebtAccountID, headerUserID, "RateSpreadScheduleLiability", _noteDC.AdditionalAccountID);
                        if (dtRateSpreadScheduleFacility.Rows.Count > 0) flag = true;

                        break;
                    case "InterestExpenseSchedule":

                        dtInterestExpenseSchedule = LiabilityNotelogic.GetHistoricalDataOfModuleByNoteId(_noteDC.DebtAccountID, headerUserID, "InterestExpenseSchedule", _noteDC.AdditionalAccountID);
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
                Log.WriteLogException(CRESEnums.Module.Debt.ToString(), "Error in GetHistoricalDataOfModuleByNoteId :" + message, _noteDC.DebtAccountID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/debt/checkduplicateforliabilities")]
        public IActionResult CheckDuplicateforLiabilities([FromBody] DebtDataContract _debtDC)
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
            Status = LiabilityNotelogic.CheckDuplicateforLiabilities(_debtDC.DebtName, _debtDC.modulename, _debtDC.DebtAccountID);
            if (Status == "True")
            {
                msg = "Debt " + _debtDC.DebtName + " already exist. Please enter unique Debt Name.";

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

        public void InsertUpdateAIEntities(string entity_names, string userid, string actiontype, string originalname)
        {
            AIDynamicEntityUpdateLogic _dynamicentity = new AIDynamicEntityUpdateLogic();
            _dynamicentity.InsertUpdateAIEntitiesAsync("DebtName", entity_names, userid, actiontype, originalname);

        }

    }
}
