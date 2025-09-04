using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace CRES.DataContract
{
    public class DebtDataContract
    {
 
        public Guid DebtAccountID { get; set; }
        public Guid AdditionalAccountID { get; set; }
        public int? DebtID { get; set; }
        public int? DebtExtID { get; set; }
        public string DebtGUID { get; set; }
        public string LiabilityNoteID { get; set; }
        
        public string DebtName { get; set; }
        public string OriginalDebtName { get; set; }
        public string DebtTypeText { get; set; }
        public int? DebtType { get; set; }
        public string StatusText { get; set; }
        public int? Status { get; set; }
        public string CurrencyText { get; set; }
        public int? Currency { get; set; }
        public decimal? CurrentCommitment { get; set; }
        public int? FundingNoticeBusinessDays { get; set; }
        public DateTime? EarliestFinancingArrival { get; set; }
        public decimal? CurrentBalance { get; set; }
        public Decimal? OriginationFees { get; set; }
        public DateTime? OriginationDate { get; set; }
        public string RateTypeText { get; set; }
        public int? RateType { get; set; }
        public Decimal? Spread { get; set; }
        public Decimal? Index { get; set; }
        public int? IntCalcMethod { get; set; }
        //public string IntCalcMethodText { get; set; }
        public int? PayFrequency { get; set; }
        //public string PaymentFrequencyText { get; set; }
        public int? DrawLag { get; set; }
        public int? PaydownDelay { get; set; }
        public string AccountID { get; set; }
        public string MatchTermsText { get; set; }
        public int? MatchTerms { get; set; }
        public int? IsRevolving { get; set; }
        public string IsRevolvingText { get; set; }
        public decimal? MaxAdvanceRate { get; set; }
        public decimal? TargetAdvanceRate { get; set; }
        public string DefaultIndexNameText { get; set; }
        public int? DefaultIndexName { get; set; }
        public decimal? FinanacingSpreadRate { get; set; } 
        public int? AccrualFrequency { get; set; }
        //public string AccrualFrequencyText { get; set; }       
        public int? AccrualEndDateBusinessDayLag { get; set; }  

        public int? DeterminationDateHolidayList { get; set; }
        public int? RateIndexResetFreq { get; set; }
        public int? RoundingMethod { get; set; }
        //public string RoundingMethodText { get; set; }
        public int? IndexRoundingRule { get; set; }
        public string IndexRoundingRuleText { get; set; }
        public int? ExpenseRateType { get; set; }
        public string ExpenseRateTypeText { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public decimal? Commitment { get; set; }
        public DateTime? InitialMaturityDate { get; set; }
        public decimal? ExitFee { get; set; }
        public decimal? ExtensionFees { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? InitialFundingDelay { get; set; }
        public DateTime? EffectiveDateFeeSchedule { get; set; }
        public int? FundDelay { get; set; }
        public int? FundingDay { get; set; }
        public List<AdditionalTransactionDataContract> AdditionalTransList { get; set; }
        public List<FeeScheduleDataContract> FeeScheduleList { get; set; }
        public List<LiabilityRateSpreadDataContract> ListLiabilityRate { get; set; }
        public List<DebtDataContract> DebtExtDataList { get; set; }
        public int? pageIndex { get; set; }
        public int? pageSize { get; set; }
        public string modulename { get; set; }
        public List<LiabilityFundingScheduleDataContract> ListLiabilityFundingSchedule { get; set; }
        public List<TagMasterXIRRDataContract> ListSelectedXIRRTags { get; set; }
        public List<LiabilityFundingScheduleDataContract> ListDealLevelLiabilityFundingSchedule { get; set; }
        public DataTable liabilityMasterFunding { get; set; }
        public DataTable DetailFunding { get; set; }
        public string CashAccountName { get; set; }
        public Guid? CashAccountID { get; set; }
        public int? BankerID { get; set; }
        public string BankerText { get; set; }
        //public decimal? InitialIndexValueOverride { get; set; }
        //public DateTime? FirstRateIndexResetDate { get; set; }
        public List<InterestExpenseScheduleDataContract> ListInterestExpense { get; set; }
        public string AbbreviationName {  get; set; }
        public int? pmtdtaccper { get; set; }
        public int? ResetIndexDaily { get; set; }
        public Guid? LinkedFundID { get; set; }

        public List<PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract> ListPrepayAndAdditionalFeeScheduleLiabilityDetail { get; set; }
    }


}
