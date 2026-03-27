using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static CRES.DataContract.V1CalcDataContract;
using System.Xml.Linq;
using System.Net.Http;
using System.Data;

namespace CRES.DataContract
{
    public class EquityDataContract
    {
        public string EquityName { get; set; }
        public string OriginalEquityName { get; set; }
        public string EquityAccountID { get; set; }
        public string FacilityAccountID { get; set; }
        public int? EquityID { get; set; }
        public string EquityGUID { get; set; }
        public string EquityTypeText { get; set; }
        public int? EquityType { get; set; }
        public int? Status { get; set; }
        public string StatusText { get; set; }

        public int? StructureID { get; set; }
        public string StructureText { get; set; }
        public string CurrencyText { get; set; }
        public int? Currency { get; set; }
        public Decimal? InvestorCapital { get; set; }
        public Decimal? CapitalReserveRequirement { get; set; }
        public decimal? ReserveRequirement { get; set; }
        public decimal? CommittedCapital { get; set; }
        public decimal? CapitalReserve { get; set; }
        public decimal? UncommittedCapital { get; set; }
        public int? CapitalCallNoticeBusinessDays { get; set; }
        public DateTime? EarliestEquityArrival { get; set; }
        public DateTime? InceptionDate { get; set; }
        public DateTime? LastDatetoInvest { get; set; }
        public decimal? FundBalanceexcludingReserves { get; set; }
        public Guid? LinkedShortTermBorrowingFacilityID { get; set; }
        public string LinkedShortTermBorrowingFacilityText { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public decimal? Commitment { get; set; }
        public DateTime? InitialMaturityDate { get; set; }
        public int? FundDelay { get; set; }
        public int? FundingDay { get; set; }
        List<AdditionalTransactionDataContract> AdditionalTransList { get; set; }
        public int? pageIndex { get; set; }
        public int? pageSize { get; set; }
        public string modulename { get; set; }
        public List<TagMasterXIRRDataContract> ListSelectedXIRRTags { get; set; }
        public string ErrorMessage { get; set; }
        public List<LiabilityFundingScheduleDataContract> ListLiabilityFundingSchedule { get; set; }
        public DataTable liabilityMasterFunding { get; set; }
        public DataTable DetailFunding { get; set; }
        public DateTime? CalcAsOfDate { get; set; }
        public string FileName { get; set; }
        public string CashAccountName { get; set; }
        public Guid? CashAccountID { get; set; }
        public string AbbreviationName { get; set; }
        public List<FeeScheduleDataContract> FeeScheduleList { get; set; }
        public List<LiabilityRateSpreadDataContract> ListLiabilityRate { get; set; }
        public List<FeeScheduleDataContract> FacilityFeeScheduleList { get; set; }
        public List<LiabilityRateSpreadDataContract> FacilityRateSpreadScheduleList { get; set; }
        public List<DebtDataContract> DebtExtDataList { get; set; }
        public List<LiabilityFundingScheduleDataContract> ListDealLevelLiabilityFundingSchedule { get; set; }
        public List<InterestExpenseScheduleDataContract> ListInterestExpense { get; set; }
        public List<PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract> ListPrepayAndAdditionalFeeScheduleLiabilityDetail { get; set; }

    }

    public class EquityAssetsDataContract
    {
        public string EquityNoteID { get; set; }
        public string EquityNoteName { get; set; }
        public string AssetAccountID { get; set; }
        public DateTime? InitialInvestmentDate { get; set; }
        public DateTime? MaturityDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

    }

    public class EquityCapContriDistbDataContract
    {
        public string EquityNoteID { get; set; }
        public string EquityNoteName { get; set; }
        public DateTime? TransactionDate { get; set; }
        public decimal? TransactionAmount { get; set; }
        public int? WorkflowStatus { get; set; }
        public string WorkflowStatusText { get; set; }
        public int? GeneratedBy { get; set; }
        public string GeneratedByText { get; set; }
        public int? Status { get; set; }
        public string StatusText { get; set; }
        public string Comments { get; set; }
        public string AssetAccountID { get; set; }
        public string AssetName { get; set; }
        public DateTime? AssetTransactionDate { get; set; }
        public decimal? AssetTransactionAmount { get; set; }
        public Decimal? TransactionAdvanceRate { get; set; }
        public Decimal? CummlativeAdvanceRate { get; set; }
        public string AssetTransactionComments { get; set; }
      
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

    }


    public class EquityCashflowDataContract
    {
        public string BorrowerNoteID { get; set; }
        public DateTime? TransactionDate { get; set; }
        public decimal? TransactionAmount { get; set; }
        public decimal? EndingBalance { get; set; }
        public string TransactionTypeText { get; set; }
        public int? TransactionType { get; set; }
        public Decimal? SpreadRate { get; set; }
        public Decimal? Index { get; set; }
        public string FeeName { get; set; }
        public DateTime? RemitDate { get; set; }
        public string Comment { get; set; }
        public string EquityNoteID { get; set; }

    }
}
