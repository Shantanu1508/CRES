using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace CRES.BusinessLogic
{
    public class DealLogic
    {
        private DealRepository _dealRepository = new DealRepository();

        //public List<DealDataContract> GetAllDeal()
        //{
        //    List<DealDataContract> lstDeals = new List<DealDataContract>();
        //    lstDeals = _dealRepository.GetAllDeal().ToList();
        //    return lstDeals;
        //}

        public List<DealDataContract> GetAllDealUSP(Guid? userId, int? pageSize, int? pageIndex, out int? TotalCount)
        {
            List<DealDataContract> lstDeals = new List<DealDataContract>();
            lstDeals = _dealRepository.GetAllDealUSP(userId, pageSize, pageIndex, out TotalCount).ToList();
            return lstDeals;
        }

        public DealDataContract GetDealByDealId(string DealId, Guid? userId)
        {
            DealDataContract _dealDC = new DealDataContract();
            _dealDC = _dealRepository.GetDealByid(DealId, userId);
            return _dealDC;
        }

        public String InsertUpdateDeal(DealDataContract dealDC)
        {
            return _dealRepository.InsertUpdateDeal(dealDC);
        }


        public void CopyDealFundingFromLegalToPhantom(string crenoteid)
        {
            _dealRepository.CopyDealFundingFromLegalToPhantom(crenoteid);
        }


        public List<PayruleDealFundingDataContract> GetDealFundingScheduleByDealID(Guid? dealID)
        {
            List<PayruleDealFundingDataContract> lstDealDC = new List<PayruleDealFundingDataContract>();
            lstDealDC = _dealRepository.GetDealFundingScheduleByDealID(dealID).ToList();
            return lstDealDC;
        }
        public DataTable GetNoteDealFundingScheduleByDealID(Guid? dealID, string userID, bool ShowUseRuleN)
        {
            DataTable dt = new DataTable();
            dt = _dealRepository.GetNoteDealFundingByDealID(dealID, userID, ShowUseRuleN);
            return dt;
        }
        public DataTable GetWFNoteFunding(Guid? DealFundingID, string userID)
        {
            DataTable dt = new DataTable();
            dt = _dealRepository.GetWFNoteFunding(DealFundingID, userID);
            return dt;
        }


        public List<PayruleNoteAMSequenceDataContract> GetFundingRepaymentSequenceByDealID(Guid? dealID)
        {
            List<PayruleNoteAMSequenceDataContract> lstDealDC = new List<PayruleNoteAMSequenceDataContract>();
            lstDealDC = _dealRepository.GetFundingRepaymentSequenceByDealID(dealID).ToList();
            return lstDealDC;
        }
        public DataTable GetFundingRepaymentSequenceHistoryByDealID(Guid? dealID)
        {
            DataTable dt = new DataTable();
            dt = _dealRepository.GetFundingRepaymentSequenceHistoryByDealID(dealID);
            return dt;
        }
        public void InsertUpdateFundingRepaymentSequence(List<PayruleNoteAMSequenceDataContract> NoteSequence, string username)
        {
            _dealRepository.InsertUpdateFundingRepaymentSequence(NoteSequence, username);
        }


        public void InsertUpdateAmortSequence(List<AmortSequenceDataContract> AmortSequence, string username)
        {
            _dealRepository.InsertUpdateAmortSequence(AmortSequence, username);

        }

        public List<PayruleTargetNoteFundingScheduleDataContract> GetNoteFundingbyDealID(Guid? dealID)
        {
            List<PayruleTargetNoteFundingScheduleDataContract> lstDealDC = new List<PayruleTargetNoteFundingScheduleDataContract>();
            lstDealDC = _dealRepository.GetFundingSchedulePayruleDataByDealID(dealID).ToList();
            return lstDealDC;
        }

        public void InsertUpdateDealFunding(List<PayruleDealFundingDataContract> dealfunding, string delegateduserid)
        {
            _dealRepository.InsertUpdateDealFunding(dealfunding, delegateduserid);
        }

        public void InsertUpdateDealArchieveFunding(List<PayruleDealFundingDataContract> dealfunding, string username)
        {
            _dealRepository.InsertUpdateDealArchieveFunding(dealfunding, username);
        }

        public DealDataContract GetDealByCREDealId(string CREDealId)
        {
            DealDataContract _dealDC = new DealDataContract();
            _dealDC = _dealRepository.GetDealByCREDealId(CREDealId);
            return _dealDC;
        }


        public string CheckDuplicateDeal(string DealID, string CredealID, string dealname, string notelist)
        {
            string isexist = "";
            isexist = _dealRepository.CheckDuplicateDeal(DealID, CredealID, dealname, notelist);
            return isexist;
        }


        public string CheckDuplicateCRENote(List<NoteDataContract> lstNotes)
        {
            NoteRepository _noterep = new NoteRepository();
            bool isexist = false, noteexist = false;
            string CRENoteId = "";
            foreach (NoteDataContract _noteDc in lstNotes)
            {
                //if (_noteDc.NoteId == null)
                //{ 
                //    noteexist = _noterep.CheckDuplicateNote(_noteDc);
                noteexist = _dealRepository.CheckDuplicateCRENoteId(_noteDc);
                if (noteexist == true)
                {
                    isexist = true;
                    if (CRENoteId != "")
                    {
                        CRENoteId = _noteDc.CRENoteID + " , " + CRENoteId;
                    }
                    else
                    {
                        CRENoteId = _noteDc.CRENoteID;
                    }
                }
                //}
            }

            if (isexist == true)
            {
                return CRENoteId;
            }
            else
                return "";
        }



        public string CheckDuplicateCopyCRENote(List<NoteDataContract> lstNotes)
        {
            bool isexist = false, noteexist = false;
            string CRENoteId = "";
            foreach (NoteDataContract _noteDc in lstNotes)
            {

                noteexist = _dealRepository.CheckDuplicateCRENoteId(_noteDc);
                if (noteexist == true)
                {
                    isexist = true;
                    if (CRENoteId != "")
                    {
                        CRENoteId = _noteDc.CRENewNoteID + " , " + CRENoteId;
                    }
                    else
                    {
                        CRENoteId = _noteDc.CRENewNoteID;
                    }
                }

            }

            if (isexist == true)
            {
                return CRENoteId;
            }
            else
                return "";
        }

        public bool CopyDeal(DealDataContract dealDC, string CreatedBy, string delegateduserid)
        {
            return _dealRepository.CopyDeal(dealDC, CreatedBy, delegateduserid);
        }


        public List<DealDataContract> GetLinkedPhantomDealID(string CREDealId)
        {
            return _dealRepository.GetLinkedPhantomDealID(CREDealId);
        }

        public List<DealDataContract> SearchDealByCREDealIdOrDealName(DealDataContract dealDC)
        {
            List<DealDataContract> lstDeals = new List<DealDataContract>();
            lstDeals = _dealRepository.SearchDealByCREDealIdOrDealName(dealDC).ToList();
            return lstDeals;
        }

        public void DeleteModuleByID(DeleteModuleDataContract ModuleDC)
        {
            _dealRepository.DeleteModuleByID(ModuleDC);
        }


        public int CallDealForCalculation(string Dealdid, string Updatedby, string AnalysisID, int CalcTyep)
        {
            return _dealRepository.CallDealForCalculation(Dealdid, Updatedby, AnalysisID, CalcTyep);
        }

        public int CallDealForPrePayCalculation(string Dealdid, string Updatedby, string AnalysisID, int CalcTyep)
        {
            return _dealRepository.CallDealForPrePayCalculation(Dealdid, Updatedby, AnalysisID, CalcTyep);
        }
        public DealDataContract CheckConcurrentUpdate(Guid? DeailId, string ModuleName, DateTime UpdatedDate)
        {
            return _dealRepository.CheckConcurrentUpdate(DeailId, ModuleName, UpdatedDate);
        }

        public List<FutureFundingScheduleDetailDataContract> GetFundingDetailByDealID(Guid? dealID, Guid? userId)
        {
            List<FutureFundingScheduleDetailDataContract> lstFundingDealDC = new List<FutureFundingScheduleDetailDataContract>();
            lstFundingDealDC = _dealRepository.GetFundingDetailByDealID(dealID, userId).ToList();
            return lstFundingDealDC;
        }

        public List<FutureFundingScheduleDetailDataContract> GetFundingDetailByFundingID(Guid? fundingID, Guid? userId)
        {
            List<FutureFundingScheduleDetailDataContract> lstFundingDealDC = new List<FutureFundingScheduleDetailDataContract>();
            lstFundingDealDC = _dealRepository.GetFundingDetailByFundingID(fundingID, userId).ToList();
            return lstFundingDealDC;
        }

        //public void LogDealFundingActivity(List<PayruleNoteAMSequenceDataContract> NoteSequence, List<PayruleDealFundingDataContract> dealfunding, string username)
        //{
        //    _dealRepository.InsertDealFundingActivity(NoteSequence, dealfunding, username);
        //}


        public List<DealDataContract> GetAllDealsForTranscationsFilter(bool IsReconciled)
        {
            return _dealRepository.GetAllDealsForTranscationsFilter(IsReconciled);
        }


        public void InsertUpdateAutoSpreadRule(List<AutoSpreadRuleDataContract> _autospreadruleDC)
        {
            _dealRepository.InsertUpdateAutoSpreadRule(_autospreadruleDC);
        }

        public List<AutoSpreadRuleDataContract> GetAutoSpreadRuleByDealID(Guid? UserId, Guid? dealID)
        {
            List<AutoSpreadRuleDataContract> lstautospreadrule = new List<AutoSpreadRuleDataContract>();
            lstautospreadrule = _dealRepository.GetAutoSpreadRuleByDealID(UserId, dealID).ToList();
            return lstautospreadrule;
        }

        public int ImportDealByCREDealID(string CREDealID, string envname, string NewCREDealID, string NewDealName, string UserID, out int? TotalCount)
        {
            var dealcount = _dealRepository.ImportDealByCREDealID(CREDealID, envname, NewCREDealID, NewDealName, UserID, out TotalCount);
            return dealcount;
        }

        public void DeleteDealByCREDealID(string CREDealID)
        {

            _dealRepository.DeleteDealByCREDealID(CREDealID);
        }

        public void UpdateWireConfirmedForPhantomDeal(string CREDealID)
        {

            _dealRepository.UpdateWireConfirmedForPhantomDeal(CREDealID);
        }

        public List<DealAmortScheduleDataContract> GetDealAmortizationByDealID(Guid? dealID)
        {
            List<DealAmortScheduleDataContract> lstdas = new List<DealAmortScheduleDataContract>();
            lstdas = _dealRepository.GetDealAmortizationByDealID(dealID).ToList();
            return lstdas;
        }


        public void SaveDealAmortization(List<DealAmortScheduleDataContract> dealAM, int? AmortizationMethod)
        {
            _dealRepository.SaveDealAmortization(dealAM, AmortizationMethod);
        }


        public void DeleteNoteFundingDataForDealFundingID(Guid? DealID)
        {
            _dealRepository.DeleteNoteFundingDataForDealFundingID(DealID);
        }



        public int SaveNoteAmortization(List<NoteAmortScheduleDataContract> NoteAM, string createdby)
        {
            return _dealRepository.SaveNoteAmortization(NoteAM, createdby);
        }


        public DataTable GetAmortScheduleForCustomNoteAmortization(string dealID, int? AmortizationMethod, string UserID)
        {
            return _dealRepository.GetAmortScheduleForCustomNoteAmortization(dealID, AmortizationMethod, UserID);
        }

        public DataTable GetAmortScheduleFormStartENDDate(string dealID, int? AmortizationMethod, string UserID, string startDate, string EndDate)
        {
            return _dealRepository.GetAmortScheduleFormStartENDDate(dealID, AmortizationMethod, UserID, startDate, EndDate);
        }

        public DataTable GetFixedPaymentAmortizationByDealID(string dealID, string UserID, decimal? FixedPayment, string MutipleNoteId, string startDate, string EndDate)
        {
            return _dealRepository.GetFixedPaymentAmortizationByDealID(dealID, UserID, FixedPayment, MutipleNoteId, startDate, EndDate);
        }
        public DataTable GetDealNoteFundingDiscrepancy()
        {
            return _dealRepository.GetDealNoteFundingDiscrepancy();
        }

        public DataSet GetNoteAllocationPercentage(Guid? DealFundingID, string userID)
        {
            return _dealRepository.GetNoteAllocationPercentage(DealFundingID, userID);
        }

        public DataTable GetAdjustmentTotalCommitmentByDealID(Guid? DealID, Guid? UserID)
        {
            return _dealRepository.GetAdjustmentTotalCommitmentByDealID(DealID, UserID);
        }

        public void InsertUpdateAdjustedTotalCommitment(List<AdjustedTotalCommitmentDataContract> _adjustedtotalcommitmentDC, Guid UserID)
        {
            _dealRepository.InsertUpdateAdjustedTotalCommitment(_adjustedtotalcommitmentDC, UserID);
        }
        public DataTable GetDiscrepancyForExitAndExtentionStripReceiveable()
        {
            return _dealRepository.GetDiscrepancyForExitAndExtentionStripReceiveable();
        }

        public PayloadDataContract GetPayLoad(Guid DealID, string CREDEalID, string DealName)
        {
            return _dealRepository.GetPayLoad(DealID, CREDEalID, DealName);
        }
        public void DeletedAdjustedTotalCommitment(Guid DealID, List<AdjustedTotalCommitmentDataContract> _deleteadjustedcommitment)
        {
            _dealRepository.DeletedAdjustedTotalCommitment(DealID, _deleteadjustedcommitment);
        }
        public List<NoteAmortFundingDataContract> GetNoteEndingBalanceByDealID(Guid? UserId, Guid? DealID, DateTime AmortStartDate, DateTime? AmortEndDate)
        {
            return _dealRepository.GetNoteEndingBalanceByDealID(UserId, DealID, AmortStartDate, AmortEndDate);
        }

        public DataTable GetInterestPaidTransactionEntry(Guid? headerUserID, Guid? dealid, string MutipleNoteId, DateTime StartDate, DateTime? EndDate)
        {
            return _dealRepository.GetInterestPaidTransactionEntry(headerUserID, dealid, MutipleNoteId, StartDate, EndDate);
        }

        public DataTable GetDiscrepancyForFFBetweenM61andBackshop()
        {
            return _dealRepository.GetDiscrepancyForFFBetweenM61andBackshop();
        }

        public void DeleteDealAmortizationScheduleDealID(Guid DealID)
        {
            _dealRepository.DeleteDealAmortizationScheduleDealID(DealID);
        }

        public DataTable DeleteDealandNoteAIEntity(Guid Userid, string Modulename, Guid moduleID)
        {
            return _dealRepository.DeleteDealandNoteAIEntity(Userid, Modulename, moduleID);
        }

        public List<IDValueDataContract> GetScheduledPrincipalByDealID(Guid? UserId, string DealID)
        {
            return _dealRepository.GetScheduledPrincipalByDealID(UserId, DealID);
        }

        public PayruleDealFundingDataContract GetDealFundingByDealFundingID(string Userid, Guid? dealFundingID)
        {
            return _dealRepository.GetDealFundingByDealFundingID(Userid, dealFundingID);
        }

        public List<ProjectedPayoffDataContract> GetProjectedPayOffDateByDealID(string Userid, Guid? DealID, int DealStatus)
        {
            return _dealRepository.GetProjectedPayOffDateByDealID(Userid, DealID, DealStatus);
        }
        public void SaveProjectedPayOffDateByDealID(List<ProjectedPayoffDataContract> projectedpayoffdate, Guid? CreatedBy)
        {
            _dealRepository.SaveProjectedPayOffDateByDealID(projectedpayoffdate, CreatedBy);
        }
        public List<AutoRepaymentBalancesDataContract> GetAutospreadRepaymentBalancesDealID(Guid? DealID)
        {
            return _dealRepository.GetAutospreadRepaymentBalancesDealID(DealID);
        }
        public DataTable GetProjectedPayOffDBDataByDealID(Guid? DealID, string UserID)
        {
            return _dealRepository.GetProjectedPayOffDBDataByDealID(DealID, UserID);
        }
        public Decimal GetEndingBalanceByDate(Guid? DealID, DateTime BalanceAsofDate)
        {
            return _dealRepository.GetEndingBalanceByDate(DealID, BalanceAsofDate);
        }
        public List<NoteEndingBalanceDataContract> GetNoteEndingBalaceByDate(Guid? Dealid, DateTime BalanceAsofDate)
        {
            return _dealRepository.GetNoteEndingBalaceByDate(Dealid, BalanceAsofDate);
        }

        public List<AutoRepaymentNoteBalancesDataContract> GetNoteAutospreadRepaymentBalancesByDealId(Guid? DealID)
        {
            return _dealRepository.GetNoteAutospreadRepaymentBalancesByDealId(DealID);
        }

        public DataTable GetMaturityByDealID(string UserID, string DealID, string NoteId)
        {
            return _dealRepository.GetMaturityByDealID(UserID, DealID, NoteId);
        }



        public DataTable GetScheduleEffectiveDateCountByDealId(string DealID)
        {
            return _dealRepository.GetScheduleEffectiveDateCountByDealId(DealID);
        }

        public DataTable GetAllReserveAccountByDealId(string UserId, string DealID)
        {
            return _dealRepository.GetAllReserveAccountByDealId(UserId, DealID);
        }


        public DataTable InsertUpdateReserveAccount(DataTable dtReserveAccount, string UserID)
        {
            return _dealRepository.InsertUpdateReserveAccount(dtReserveAccount, UserID);
        }


        public DataTable GetReserveScheduleByDealId(string UserId, string DealID)
        {
            return _dealRepository.GetReserveScheduleByDealId(UserId, DealID);
        }

        public DataTable InsertUpdateReserveSchedule(DataTable dtReserveSchedule, string UserID)
        {
            return _dealRepository.InsertUpdateReserveSchedule(dtReserveSchedule, UserID);
        }
        public void UpdatExpectedMaturityDateByDealID(Guid DealID, DateTime? ExpectedMaturityDate, Guid UserID)
        {
            _dealRepository.UpdatExpectedMaturityDateByDealID(DealID, ExpectedMaturityDate, UserID);
        }

        public DataTable GetAllExceptionsByDealID(Guid DealID, string Type, string MultipleNoteID, Guid ScenarioID, Guid NoteID)
        {
            return _dealRepository.GetAllExceptionsByDealID(DealID, Type, MultipleNoteID, ScenarioID, NoteID);
        }

        public DataTable GetAllEFfectiveDatesByDealID(Guid DealID, string UserId)
        {
            return _dealRepository.GetAllEFfectiveDatesByDealID(DealID, UserId);
        }
        //GetWFPayOffNoteFunding
        public DataSet GetWFPayOffNoteFunding(Guid? DealFundingID, string userID)
        {
            return _dealRepository.GetWFPayOffNoteFunding(DealFundingID, userID);
        }

        public List<V1CalculationStatusDataContract> GetParnetNotesInaDealForCalculation(string DealID)
        {
            return _dealRepository.GetParnetNotesInaDealForCalculation(DealID);
        }

        public DataTable GetDiscrepancyForCommitment()
        {
            return _dealRepository.GetDiscrepancyForCommitment();
        }
        //public List<PrepayAdjustmentDataContract> GetPrepayAdjustmentByPrepayScheduleId(int PrepayScheduleId)
        //{
        //    List<PrepayAdjustmentDataContract> lstprepay = new List<PrepayAdjustmentDataContract>();
        //    lstprepay = _dealRepository.GetPrepayAdjustmentByPrepayScheduleId(PrepayScheduleId);
        //    return lstprepay;
        //}

        //public List<SpreadMaintenanceDataContract> GetSpreadMaintenanceByPrepayScheduleID(int PrepayScheduleId)
        //{
        //    List<SpreadMaintenanceDataContract> lstSpread = new List<SpreadMaintenanceDataContract>();
        //    lstSpread = _dealRepository.GetSpreadMaintenanceByPrepayScheduleID(PrepayScheduleId);
        //    return lstSpread;
        //}

        //public List<MiniSpreadInterestDataContract> GetMiniSpreadInterestByPrepayScheduleId(int PrepayScheduleId)
        //{
        //    List<MiniSpreadInterestDataContract> lstMini = new List<MiniSpreadInterestDataContract>();
        //    lstMini = _dealRepository.GetMiniSpreadInterestByPrepayScheduleId(PrepayScheduleId);
        //    return lstMini;
        //}

        //public List<MiniFeeDataContract> GetMiniFeeByPrepayScheduleId(int PrepayScheduleId)
        //{
        //    List<MiniFeeDataContract> lstMiniFee = new List<MiniFeeDataContract>();
        //    lstMiniFee = _dealRepository.GetMiniFeeByPrepayScheduleId(PrepayScheduleId);
        //    return lstMiniFee;
        //}

        public String InsertUpdatePrepaySchedule(PrepayDataContract prepayDC, List<PrepayAdjustmentDataContract> dtPrepayAdjustment, List<SpreadMaintenanceScheduleDataContract> dtSpreadMaintenance, List<MinMultScheduleDataContract> dtMiniSpreadInterest, List<FeeCreditsDataContract> dtMiniFee)
        {
            return _dealRepository.InsertUpdatePrepaySchedule(prepayDC, dtPrepayAdjustment, dtSpreadMaintenance, dtMiniSpreadInterest, dtMiniFee);
        }

        public List<PrepayProjectionDataContract> GetDealPrepayProjectionByDealId(string DealId, Guid? userId)
        {
            return _dealRepository.GetDealPrepayProjectionByDealId(DealId, userId); ;
        }

        public List<PrepayAllocationsDataContract> GetDealPrepayAllocationsByDealId()
        {
            return _dealRepository.GetDealPrepayAllocationsByDealId(); ;
        }

        public PrepayDataContract GetPrepayPremiumDetailDataByDealId(string DealId, Guid? userId)
        {
            return _dealRepository.GetPrepayPremiumDetailDataByDealId(DealId, userId); ;
        }

        public string GetDealCalculationStatus(string DealID)
        {
            return _dealRepository.GetDealCalculationStatus(DealID);
        }

        public DataTable GetDiscrepancyForCommitmentData()
        {
            return _dealRepository.GetDiscrepancyForCommitmentData();
        }
        public String AddUpdateDealRuleTypeSetup(List<ScenarioruletypeDataContract> scenarioDC, string headerUserID)

        {
            return _dealRepository.AddUpdateDealRuleTypeSetup(scenarioDC, headerUserID);
        }

        public List<ScenarioruletypeDataContract> GetRuleTypeSetupByDealId(string DealID)
        {
            List<ScenarioruletypeDataContract> _scenarioDC = new List<ScenarioruletypeDataContract>();
            _scenarioDC = _dealRepository.GetRuleTypeSetupByDealId(DealID);
            return _scenarioDC;
        }

        public List<PropertyTypeDataContract> GetAllPropertyType(Guid? headerUserID)
        {
            return _dealRepository.GetAllPropertyType(headerUserID);
        }

        public List<LoanStatusDataContract> GetAllLoanStatus(Guid? headerUserID)
        {
            return _dealRepository.GetAllLoanStatus(headerUserID);
        }

        public DataTable GetDiscrepancyListOfDealForEnableAutoSpread()
        {
            return _dealRepository.GetDiscrepancyListOfDealForEnableAutoSpread();
        }

        public DataTable GetDiscrepancyForExportPaydown()
        {
            return _dealRepository.GetDiscrepancyForExportPaydown();
        }

        public PrepayCalcStatusDataContract GetPrepayCalculationStatus(string DealID)
        {
            return _dealRepository.GetPrepayCalculationStatus(DealID);
        }

        public PrepayCalcStatusDataContract GetPrepayCalcStatusMessage(string DealID)
        {
            return _dealRepository.GetPrepayCalcStatusMessage(DealID);
        }


        public List<EquitySummaryDataContract> GetEquitySummaryByDealID(string DealID)
        {
            return _dealRepository.GetEquitySummaryByDealID(DealID);
        }
    }
}
