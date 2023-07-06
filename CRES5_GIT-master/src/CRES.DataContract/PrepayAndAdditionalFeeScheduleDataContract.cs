using System;

namespace CRES.DataContract
{
    public partial class PrepayAndAdditionalFeeScheduleDataContract
    {
        public PrepayAndAdditionalFeeScheduleDataContract()
        {
        }
        public Guid? NoteID { get; set; }
        public Guid? AccountID { get; set; }
        public DateTime? Event_Date { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public DateTime? EffectiveEndDate { get; set; }
        public int? EventTypeID { get; set; }
        public string EventTypeText { get; set; }
        public Guid? PrepayAndAdditionalFeeScheduleID { get; set; }
        public Guid? EventId { get; set; }
        public DateTime? ScheduleStartDate { get; set; }
        public decimal? Value { get; set; }
        public int? ValueTypeID { get; set; }
        public string ValueTypeText { get; set; }
        public decimal? IncludedLevelYield { get; set; }
        public decimal? IncludedBasis { get; set; }
        public decimal? MaxFeeAmt { get; set; }
        public DateTime? StartDate { get; set; }

        // release 2.3 changes
        public DateTime? ScheduleEndDate { get; set; }
        public string FeeName { get; set; }
        public decimal? FeeAmountOverride { get; set; }
        public decimal? BaseAmountOverride { get; set; }
        public string ApplyTrueUpFeatureText { get; set; }
        public int? ApplyTrueUpFeatureID { get; set; }
        public decimal? PercentageOfFeeToBeStripped { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

        public string ScheduleID { get; set; }

        public int? ModuleId { get; set; }

        public decimal? FeeToBeStripped { get; set; }

    }
}