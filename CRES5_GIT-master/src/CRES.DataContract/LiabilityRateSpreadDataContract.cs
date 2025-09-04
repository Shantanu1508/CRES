using System;
 
namespace CRES.DataContract
{
    public class LiabilityRateSpreadDataContract
    {
        public string LiabilityNoteAccountID { get; set; }
        public string AccountID { get; set; }
        public string AdditionalAccountID { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public DateTime? Date { get; set; }
        public int? ValueTypeID { get; set; }
        public string ValueTypeText { get; set; }
        public Decimal? Value { get; set; }
        public int? IntCalcMethodID { get; set; }
        public string IntCalcMethodText { get; set; }
        public Decimal? RateOrSpreadToBeStripped { get; set; }
        public int? IndexNameID { get; set; }
        public string IndexNameText { get; set; }
        public int? DeterminationDateHolidayList { get; set; }
        public string DeterminationDateHolidayListText { get; set; }
        public Boolean IsDeleted { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }
}
