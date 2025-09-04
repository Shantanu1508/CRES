using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace CRES.DAL.IRepository
{
    public interface ILiabilityNoteRepository
    {
        string InsertUpdateLiabilityNote(LiabilityNoteDataContract lndc, string userid, List<LiabilityNoteAssetMapping> LiabilityAssetMap);
        List<LiabilityNoteDataContract> GetLiabilityNoteByDealAccountID(string DealAccountID);
        public LiabilityNoteDataContract GetLiabilityNoteByLiabilityNoteID(Guid LiabilityNoteGUID);
        List<SearchDataContract> GetAutosuggestDebtAndEquityName(string serchKey);
        List<LiabilityFundingScheduleDataContract> GetLiabilityFundingScheduleByDealAccountID(string DealAccountID);
        List<LiabilityNoteDataContract> GetDebtorEquityNoteByLiabilityTypeID(Guid LiabilityTypeID);
        void InsertUpdatedLiabilityFundingSchedule(List<LiabilityFundingScheduleDataContract> LiabilityFundingSchedule, string userid);
        List<LookupDataContract> GetAssetListByDealAccountID(string DealAccountID);
        DataTable GetDealInfoByDealAccountID(string DealAccountID);
        DataTable GetAccountCategoryList();
        List<LiabilityFundingScheduleDataContract> GetLiabilityFundingScheduleByLiabilityTypeID(string LiabilityTypeID);
        List<LookupDataContract> GetAllLiabilityTypeLookup();

        List<LiabilityRateSpreadDataContract> GetLiabilityRateSpreadScheduleByNoteAccountID(string AccountID, Guid? AdditionalAccountID);
        string InsertUpdateLiabilityRateSpreadSchedule(List<LiabilityRateSpreadDataContract> RateSpreadSchedule, string userid);
        string InsertUpdatedLiabilityFeeSchedule(List<FeeScheduleDataContract> FeeSchedule, string userid);
        public List<ScheduleEffectiveDateLiabilityDataContract> GetScheduleEffectiveDateCountByAccountId(Guid AccountId, Guid? AdditionalAccountId);
        public DataTable GetHistoricalDataOfModuleByAccountId(Guid? AccountId, Guid? userID, string ModuleName, Guid? AdditionalAccountId);
        public void InsertUpdatedLiabilityNoteAssetMapping(List<LiabilityNoteAssetMapping> LiabilityAssetMap, string userid);
        public List<LiabilityNoteAssetMapping> GetLiabilityNoteAssetMappingByDealAccountID(string DealAccountID);
        public string CheckDuplicateforLiabilities(string ID, string TypeName, Guid? Accountid);

        DataTable GeDebtOrEquityTransactionByAccountID(string AccountId, string AnalysisId);

        DataTable GetTransactionEntryLiabilityNoteByDealAccountId(string DealAccountId, string AnalysisId);

        List<LookupDataContract> GetTransactionTypesLookupForJournalEntry();
        public void DeleteLiabilityNote(Guid? liabilityNoteAccountId);

        public void MoveConfirmedToAdditionalTransactionEntry(string DealAccountId, string username);

        public void InsertUpdateLiabilityFundingScheduleAggregate(DataTable FundingScheduleData, string userid);

        public void UploadLiabilityFromFile(DataTable dtCash, DataTable dtDebt, DataTable dtEquityCapitalTransactions, DataTable dtInvestors, DataTable dtEquity, DataTable dtDebtRepoLine, DataTable dtDealLibAdvRate, DataTable dtDealLiability, DataTable dt11Trans);

        void UploadInvestorsData(DataTable dtInvestors, string EquityAccountID);
        DataTable GetDealDatabyCREDealID(string CREDealID);
        void InsertUpdateGeneralSetupLiabilityNote(LiabilityNoteDataContract lndc, string userid);
        void DeleteLiabilityData_ForOneTimeUpload(string AccountID, string Type);

        void InsertLib11Trans(DataTable dt11Trans, string EquityAccountName, DateTime gCutoffdate);
        DataTable GetDebtNameforAssociatedEquityFund(string AccountID, string LiabilityType);
        void InsertUpdateRepoExtDatafromFundLevel(List<DebtDataContract> ddc, string userid);
        List<DebtDataContract> GetRepoExtDatafromFundLevel(Guid DebtAccountID, Guid AdditionalAccountID);
        List<DebtDataContract> GetAllDebtData();

        void InsertUpdateDebtOneTimeUpdate(DebtDataContract ddc, string userid);
        List<LookupDataContract> GetDebtEquityTypeList();
        List<SearchDataContract> GetAutosuggestBankerName(string searchKey);
        List<LiabilityFundingScheduleDataContract> GetDealLevelDataLiabilityFundingScheduleDetail(string LiabilityTypeID);
        void InsertUpdateDealLevelDataLiabilityFundingScheduleDetail(List<LiabilityFundingScheduleDataContract> ddc, string userid);

        void InsertUpdateLiabilityNoteFromExcel(LiabilityNoteDataContract ndc, string userid);
        void DeleteLiability_ScheduleData_Temp();

        List<LookupDataContract> GetAssociatedDealsByLiabilityTypeID(string LiabilityTypeID);
    }
}
