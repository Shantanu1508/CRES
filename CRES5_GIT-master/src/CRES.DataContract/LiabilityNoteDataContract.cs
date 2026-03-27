using System;
using System.Collections.Generic;

namespace CRES.DataContract
{
    public class LiabilityNoteDataContract
    {
        public Guid? LiabilityNoteGUID { get; set; }
        public int? LiabilityNoteAutoID { get; set; }
        public Guid? LiabilityNoteAccountID { get; set; }
        public string LiabilityNoteID { get; set; }
        public string OriginalLiabilityNoteID { get; set; }
        public string DealAccountID { get; set; }
        public string DealID { get; set; }
        public string LiabilityName { get; set; }
        public string Provider { get; set; }
        public string LiabilityID { get; set; }
        public Guid? LiabilityTypeID { get; set; }
        public int? DebtEquityTypeID { get; set; }
        public string LiabilityTypeText { get; set; }
        public string AssetAccountID { get; set; }
        public string AssetName { get; set; }
        public string StatusText { get; set; }
        public int? Status { get; set; }
        public Decimal? CurrentAdvanceRate { get; set; }
        public decimal? CurrentBalance { get; set; }
        public decimal? UndrawnCapacity { get; set; }
        public DateTime? MaturityDate { get; set; }
        public decimal? PaydownAdvanceRate { get; set; }
        public decimal? FundingAdvanceRate { get; set; }
        public DateTime? PledgeDate { get; set; }
        public string AssociatedLiabilityTypeText { get; set; }
        public string AssociatedLiabilityTypeGuid { get; set; }
        
        public Decimal? TargetAdvanceRate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public string Type { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public List<LiabilityRateSpreadDataContract> ListLiabilityRate { get; set; }
        public List<FeeScheduleDataContract> FeeScheduleList { get; set; }
        public int? pageIndex { get; set; }
        public int? pageSize { get; set; }
        public string modulename { get; set; }
        public int AccountTypeID { get; set; }
        public Boolean IsDeleted { get; set; }
        public decimal? ThirdPartyOwnership { get; set; }
        public int? DefaultIndexName { get; set; }
        public decimal? FinanacingSpreadRate { get; set; }    
        public int? AccrualFrequency { get; set; }    
        public int? AccrualEndDateBusinessDayLag { get; set; }  
        public int? RoundingMethod { get; set; }
        public int? PayFrequency { get; set; }
        public int? IndexRoundingRule { get; set; }
        public int? IntCalcMethod { get; set; }
        public List<LiabilityNoteAssetMapping> LiabilityAssetMap { get; set; }
        public string AccountTypeText { get; set; }
        public DateTime? EffectiveDate { get; set; }      
        public bool? UseNoteLevelOverride { get; set; }
        public string LiabilityType { get; set; }
        public string LiabilityTypeGUID { get; set; }
        public List<InterestExpenseScheduleDataContract> ListInterestExpense { get; set; }
        public int? LiabilitySource { get; set; }
        public string LiabilitySourceText { get; set; }
        public int? ActiveLiabilityNote { get; set; }
        public int? pmtdtaccper { get; set; }
        public int? ResetIndexDaily { get; set; }
        public List<PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract> ListPrepayAndAdditionalFeeScheduleLiabilityDetail { get; set; }
    }

    public class ScheduleEffectiveDateLiabilityDataContract
    {
        public Guid NoteAccountId { get; set; }
        public int EffectiveDateCount { get; set; }
        public string ScheduleName { get; set; }
        public Guid? AdditionalAccountId { get; set; }
    }

}
