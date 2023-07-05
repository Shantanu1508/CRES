using System;

namespace CRES.DataContract
{
    public partial class FeeCouponStripReceivableTab
    {
        public FeeCouponStripReceivableTab()
        { }

        //public DateTime? Date { get; set; }
        public Decimal? FeeCouponReceivable { get; set; }


        public Guid? NoteID { get; set; }
        public Guid? AccountID { get; set; }
        //public Guid? FeeCouponStripReceivableID { get; set; }
        public DateTime? Date { get; set; }
        public decimal? Value { get; set; }
        public DateTime? Event_Date { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public DateTime? EffectiveEndDate { get; set; }
        public int? EventTypeID { get; set; }
        public string EventTypeText { get; set; }
        public Guid? EventId { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? ModuleId { get; set; }
        public string ScheduleID { get; set; }
        public string SourceNoteId { get; set; }
        public decimal? StrippedAmount { get; set; }
        public string RuleType { get; set; }
        public string FeeName { get; set; }
        public string TransactionName { get; set; }
        public decimal? InclInLevelYield { get; set; }
    }
}
