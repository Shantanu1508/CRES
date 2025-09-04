using CRES.DAL.Helper;
using CRES.DAL.IRepository;
using CRES.DAL.Repository;
using CRES.DataContract;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.Identity.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Text;

namespace CRES.BusinessLogic
{
    public class LiabilityNoteLogic
    {
        LiabilityNoteRepository _LiabilityNoteRepository = new LiabilityNoteRepository();

        public string InsertUpdateLiabilityNote(LiabilityNoteDataContract lndc, string userid, List<LiabilityNoteAssetMapping> AssetMapData)
        {
            return _LiabilityNoteRepository.InsertUpdateLiabilityNote(lndc, userid, AssetMapData);
        }
        public LiabilityNoteDataContract GetLiabilityNoteByLiabilityNoteID(Guid LiabilityNoteGUID)
        {
            return _LiabilityNoteRepository.GetLiabilityNoteByLiabilityNoteID(LiabilityNoteGUID);
        }
        public List<LiabilityRateSpreadDataContract> GetLiabilityRateSpreadScheduleByNoteAccountID(string AccountID, Guid? AdditionalAccountID)
        {
            return _LiabilityNoteRepository.GetLiabilityRateSpreadScheduleByNoteAccountID(AccountID, AdditionalAccountID);
        }
        public string InsertUpdateLiabilityRateSpreadSchedule(List<LiabilityRateSpreadDataContract> RateSpreadSchedule, string userid)
        {
            return _LiabilityNoteRepository.InsertUpdateLiabilityRateSpreadSchedule(RateSpreadSchedule, userid);
        }
        public string InsertUpdatedLiabilityFeeSchedule(List<FeeScheduleDataContract> FeeSchedule, string userid)
        {
            return _LiabilityNoteRepository.InsertUpdatedLiabilityFeeSchedule(FeeSchedule, userid);
        }
        public List<LiabilityNoteDataContract> GetLiabilityNoteByDealAccountID(string DealAccountID)
        {
            return _LiabilityNoteRepository.GetLiabilityNoteByDealAccountID(DealAccountID);
        }
        public List<SearchDataContract> GetAutosuggestDebtAndEquityName(string serchKey)
        {
            return _LiabilityNoteRepository.GetAutosuggestDebtAndEquityName(serchKey);
        }
        public List<LookupDataContract> GetAllLiabilityTypeLookup()
        {
            return _LiabilityNoteRepository.GetAllLiabilityTypeLookup();
        }
        public List<LookupDataContract> GetTransactionTypesLookupForJournalEntry()
        {
            return _LiabilityNoteRepository.GetTransactionTypesLookupForJournalEntry();
        }
        public List<LiabilityFundingScheduleDataContract> GetLiabilityFundingScheduleByDealAccountID(string DealAccountID)
        {
            return _LiabilityNoteRepository.GetLiabilityFundingScheduleByDealAccountID(DealAccountID);
        }
        public List<LiabilityFundingScheduleDataContract> GetLiabilityFundingScheduleByLiabilityTypeID(string LiabilityTypeID)
        {
            return _LiabilityNoteRepository.GetLiabilityFundingScheduleByLiabilityTypeID(LiabilityTypeID);
        }
        public List<LiabilityNoteDataContract> GetDebtorEquityNoteByLiabilityTypeID(Guid LiabilityTypeID)
        {
            return _LiabilityNoteRepository.GetDebtorEquityNoteByLiabilityTypeID(LiabilityTypeID);
        }
        public void InsertUpdatedLiabilityFundingSchedule(List<LiabilityFundingScheduleDataContract> LiabilityFundingSchedule, string userid)
        {
            _LiabilityNoteRepository.InsertUpdatedLiabilityFundingSchedule(LiabilityFundingSchedule, userid);
        }
        public void MoveConfirmedToAdditionalTransactionEntry(string DealAccountId, string username)
        {
            _LiabilityNoteRepository.MoveConfirmedToAdditionalTransactionEntry(DealAccountId, username);
        }
        public void InsertUpdatedLiabilityNoteAssetMapping(List<LiabilityNoteAssetMapping> LiabilityAssetMap, string userid)
        {
            _LiabilityNoteRepository.InsertUpdatedLiabilityNoteAssetMapping(LiabilityAssetMap, userid);
        }
        public List<LookupDataContract> GetAssetListByDealAccountID(string DealAccountID)
        {
            return _LiabilityNoteRepository.GetAssetListByDealAccountID(DealAccountID);
        }
        public List<LiabilityNoteAssetMapping> GetLiabilityNoteAssetMappingByDealAccountID(string DealAccountID)
        {
            return _LiabilityNoteRepository.GetLiabilityNoteAssetMappingByDealAccountID(DealAccountID);
        }
        public DataTable GetDealInfoByDealAccountID(string DealAccountID)
        {
            return _LiabilityNoteRepository.GetDealInfoByDealAccountID(DealAccountID);
        }

        public DataTable GetAccountCategoryList()
        {
            return _LiabilityNoteRepository.GetAccountCategoryList();
        }
        public List<ScheduleEffectiveDateLiabilityDataContract> GetScheduleEffectiveDateCount(Guid AccountId, Guid? AdditionalAccountId)
        {
            return _LiabilityNoteRepository.GetScheduleEffectiveDateCountByAccountId(AccountId, AdditionalAccountId);
        }
        public DataTable GetHistoricalDataOfModuleByNoteId(Guid? AccountId, Guid? userID, string moduleName, Guid? AdditionalAccountId)
        {
            DataTable dt = new DataTable();
            dt = _LiabilityNoteRepository.GetHistoricalDataOfModuleByAccountId(AccountId, userID, moduleName, AdditionalAccountId);
            return dt;
        }
        public string CheckDuplicateforLiabilities(string ID, string TypeName, Guid? Accountid)
        {
            return _LiabilityNoteRepository.CheckDuplicateforLiabilities(ID, TypeName, Accountid);
        }
        public DataTable GeDebtOrEquityTransactionByAccountID(string AccountId, string AnalysisId)
        {
            return _LiabilityNoteRepository.GeDebtOrEquityTransactionByAccountID(AccountId, AnalysisId);
        }

        public DataTable GetTransactionEntryLiabilityNoteByDealAccountId(string DealAccountId, string AnalysisId)
        {
            return _LiabilityNoteRepository.GetTransactionEntryLiabilityNoteByDealAccountId(DealAccountId, AnalysisId);
        }
        public DataTable GetDealLiabilityCashflowsExportExcel(string DealAccountId, string AnalysisId)
        {
            return _LiabilityNoteRepository.GetDealLiabilityCashflowsExportExcel(DealAccountId, AnalysisId);
        }
        public void DeleteLiabilityNote(Guid? liabilityNoteAccountId)
        {
            _LiabilityNoteRepository.DeleteLiabilityNote(liabilityNoteAccountId);
        }
        public void InsertUpdateLiabilityFundingScheduleAggregate(DataTable FundingScheduleData, string userid)
        {
            _LiabilityNoteRepository.InsertUpdateLiabilityFundingScheduleAggregate(FundingScheduleData, userid);
        }

        public void UploadLiabilityFromFile(DataTable dtCash, DataTable dtDebt, DataTable dtEquityCapitalTransactions, DataTable dtInvestors, DataTable dtEquity, DataTable dtDebtRepoLine, DataTable dtDealLibAdvRate, DataTable dtDealLiability, DataTable dt11Trans)
        {
            _LiabilityNoteRepository.UploadLiabilityFromFile(dtCash, dtDebt, dtEquityCapitalTransactions, dtInvestors, dtEquity, dtDebtRepoLine, dtDealLibAdvRate, dtDealLiability, dt11Trans);
        }
        public void UploadInvestorsData(DataTable dtInvestors, string EquityAccountID)
        {
            _LiabilityNoteRepository.UploadInvestorsData(dtInvestors, EquityAccountID);
        }
        public DataTable GetDealDatabyCREDealID(string CREDealID)
        {
            return _LiabilityNoteRepository.GetDealDatabyCREDealID(CREDealID);
        }
        public void InsertUpdateGeneralSetupLiabilityNote(LiabilityNoteDataContract lndc, string userid)
        {
            _LiabilityNoteRepository.InsertUpdateGeneralSetupLiabilityNote(lndc, userid);
        }
        public void DeleteLiabilityData_ForOneTimeUpload(string AccountID, string Type)
        {
            _LiabilityNoteRepository.DeleteLiabilityData_ForOneTimeUpload(AccountID, Type);
        }
        public void InsertLib11Trans(DataTable dt11Trans, string EquityAccountName, DateTime gCutoffdate)
        {
            _LiabilityNoteRepository.InsertLib11Trans(dt11Trans, EquityAccountName, gCutoffdate);
        }
        public DataTable GetDebtNameforAssociatedEquityFund(string AccountID, string LiabilityType)
        {
            return _LiabilityNoteRepository.GetDebtNameforAssociatedEquityFund(AccountID, LiabilityType);
        }
        public void InsertUpdateRepoExtDatafromFundLevel(List<DebtDataContract> ddc, string userid)
        {
            _LiabilityNoteRepository.InsertUpdateRepoExtDatafromFundLevel(ddc, userid);
        }
        public List<DebtDataContract> GetRepoExtDatafromFundLevel(Guid DebtAccountID, Guid AdditionalAccountID)
        {
            return _LiabilityNoteRepository.GetRepoExtDatafromFundLevel(DebtAccountID, AdditionalAccountID);
        }

        public List<DebtDataContract> GetAllDebtData()
        {
            return _LiabilityNoteRepository.GetAllDebtData();
        }
        public void InsertUpdateDebtOneTimeUpdate(DebtDataContract ddc, string userid)
        {

            _LiabilityNoteRepository.InsertUpdateDebtOneTimeUpdate(ddc, userid);
        }
        public List<LookupDataContract> GetDebtEquityTypeList()
        {
            return _LiabilityNoteRepository.GetDebtEquityTypeList();
        }
        public List<SearchDataContract> GetAutosuggestBankerName(string searchKey)
        {
            return _LiabilityNoteRepository.GetAutosuggestBankerName(searchKey);
        }
        public List<LiabilityFundingScheduleDataContract> GetDealLevelDataLiabilityFundingScheduleDetail(string LiabilityTypeID)
        {
            return _LiabilityNoteRepository.GetDealLevelDataLiabilityFundingScheduleDetail(LiabilityTypeID);
        }
        public void InsertUpdateDealLevelDataLiabilityFundingScheduleDetail(List<LiabilityFundingScheduleDataContract> ddc, string userid)
        {
            _LiabilityNoteRepository.InsertUpdateDealLevelDataLiabilityFundingScheduleDetail(ddc, userid);
        }
        public List<InterestExpenseScheduleDataContract> GetInterestExpenseSchedule(Guid DebtAccountID, Guid AdditionalAccountID)
        {
            return _LiabilityNoteRepository.GetInterestExpenseSchedule(DebtAccountID, AdditionalAccountID);
        }

        public void InsertUpdateInterestExpenseSchedule(List<InterestExpenseScheduleDataContract> ddc, string userid)
        {
            _LiabilityNoteRepository.InsertUpdateInterestExpenseSchedule(ddc, userid);
        }
        public void InsertUpdateLiabilityNoteFromExcel(LiabilityNoteDataContract ndc, string userid)
        {
            _LiabilityNoteRepository.InsertUpdateLiabilityNoteFromExcel(ndc, userid);
        }
        public void DeleteLiability_ScheduleData_Temp()
        {
            _LiabilityNoteRepository.DeleteLiability_ScheduleData_Temp();
        }

        public void DeleteInterestExpenseSchedule(Guid DebtAccountID, Guid AdditionalAccountID)
        {
            _LiabilityNoteRepository.DeleteInterestExpenseSchedule(DebtAccountID, AdditionalAccountID);
        }

        public List<LookupDataContract> GetAssociatedDealsByLiabilityTypeID(string LiabilityTypeID)
        {
            return _LiabilityNoteRepository.GetAssociatedDealsByLiabilityTypeID(LiabilityTypeID);
        }
        public void InsertPrepayAndAdditionalFeeScheduleLiabilityDetail(List<PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract> ddc, string userid)
        {
            _LiabilityNoteRepository.InsertPrepayAndAdditionalFeeScheduleLiabilityDetail(ddc, userid);
        }

        public void InsertLiabilityTransactionTabOnly(DataTable dt11Trans, string EquityAccountName, DateTime gCutoffdate)
        {
            _LiabilityNoteRepository.InsertLiabilityTransactionTabOnly(dt11Trans, EquityAccountName, gCutoffdate);
        }
    }
}
