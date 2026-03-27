using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static CRES.DataContract.V1CalcDataContract;

namespace CRES.DataContract
{
    public class LiabilityFileUploadDataContract
    {

    }

    public class CashTransactionsDataContract
    {
        public DateTime? date { get; set; }
        public string TransactionType { get; set; }
        public decimal? Transaction { get; set; }

    }

    public class DebtDrawsPaydownsDataContract
    {
        public string LiabilityName { get; set; }
        public string Description { get; set; }
        public string CRENoteID { get; set; }
        public DateTime? TransactionDate { get; set; }
        public decimal? TransactionAmount { get; set; }
        public string Confirmed { get; set; }
        public string Comments { get; set; }
        public string AssetIDDealorNoteID { get; set; }
    }
    public class EquityCapitalTransactionsDataContract
    {
        public string EquityName { get; set; }
        public string Description { get; set; }
        public string CRENoteID { get; set; }
        public DateTime? TransactionDate { get; set; }
        public decimal? TransactionAmount { get; set; }
        public string Confirmed { get; set; }
        public string Comments { get; set; }
        public string AssetIDDealorNoteID { get; set; }
        public string Source { get; set; }
        public decimal? EndingBalance { get; set; }
    }
    public class InvestorsDataContract
    {
        public string Investor { get; set; }
        public DateTime? EqDate { get; set; }
        public decimal? Commitment { get; set; }
        public DateTime? SLDate { get; set; }
        public decimal? Concentration { get; set; }
        public decimal? ConCommit { get; set; }
        public decimal? SLAdvance { get; set; }
        public decimal? BorrowBase { get; set; }
    }

    public class LibEquityDataContract
    {
        public string EquityName { get; set; }
        public string EquityType { get; set; }
        public string Status { get; set; }
        public string Currency { get; set; }
        public decimal? InvestorCapital { get; set; }
        public decimal? CapitalReserveRequirement { get; set; }
        public decimal? ReserveRequirement { get; set; }
        public int? CapitalCallNoticeBusinessDays { get; set; }
        public string InceptionDate { get; set; }
        public string LastDatetoInvest { get; set; }
        public string LinkedShortTermBorrowingFacility { get; set; }
        public string Commitment { get; set; }
        public string InitialMaturityDate { get; set; }
    }

    public class DebtRepoLineDataContract
    {
        public string DebtName { get; set; }
        public string DescriptiveName { get; set; }
        public string DebtType { get; set; }
        public string Status { get; set; }
        public string Currency { get; set; }
        public string MatchTerm { get; set; }
        public string Isrevolving { get; set; }
        public decimal? FundingNoticeBusinessDays { get; set; }
        public decimal? InitialFundingDelay { get; set; }
        public decimal? MaxAdvanceRate { get; set; }
        public string TargetAdvanceRate { get; set; }
        public DateTime? OriginationDate { get; set; }
        public decimal? OriginationFee { get; set; }
        public string RateType { get; set; }
        public string PaydownDelay { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public decimal? Commitment { get; set; }
        public DateTime? InitialMaturityDate { get; set; }
        public string InitialInterestAccrualEndDate { get; set; }
        public string AccrualFrequency { get; set; }
        public string PaymentDayofMonth { get; set; }
        public string PaymentDateBusinessDayLag { get; set; }
        public string DeterminationDateLeadDays { get; set; }
        public string DeterminationDateReferenceDayofthemonth { get; set; }
        public string Roundingmethod { get; set; }
        public string IndexRoundingRule { get; set; }
        public string PayFrequency { get; set; }
        public string DefaultIndexName { get; set; }
    }
    public class DealLibAdvRateDataContract
    {

        public string CREDealID { get; set; }
        public string DealName { get; set; }
        public string Equity { get; set; }
        public string Facility { get; set; }
        public DateTime? EffDate { get; set; }
        public DateTime? MaturityDate { get; set; }
        public decimal? AdvRateFacility { get; set; }
        public decimal? AdvRateEquity { get; set; }
        public DateTime? PledgeDate { get; set; }
        public string LiabilitySource { get; set; }
    }
    public class LibDealLiabilityDataContract
    {
        public string CREDealID { get; set; }
        public string DealName { get; set; }
        public string CRENoteID { get; set; }
        public string Name { get; set; }
        public string Structure { get; set; }
        public string Equity { get; set; }
        public string Facility { get; set; }
    }
    public class Trans11DataContract
    {
        public string DealID { get; set; }
        public string DealName { get; set; }
        public string NoteID { get; set; }
        public string NoteName { get; set; }
        public string Description { get; set; }
        public DateTime? Date { get; set; }
        public string Owned { get; set; }
        public string TransactionType { get; set; }
        public string FinancingFacility { get; set; }
        public decimal? Transaction { get; set; }
        public decimal? UnallocatedSubline { get; set; }
        public decimal? UnallocatedEquity { get; set; }
        public decimal? SublineBalance { get; set; }
        public decimal? EquityBalance { get; set; }
    }
}
