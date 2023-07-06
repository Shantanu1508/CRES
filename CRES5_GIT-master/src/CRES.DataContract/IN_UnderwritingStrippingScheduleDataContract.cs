using System;

namespace CRES.DataContract
{
    public class IN_UnderwritingStrippingScheduleDataContract
    {
        public Guid? IN_UnderwritingNoteID { get; set; }
        public Guid? IN_UnderwritingAccountID { get; set; }
        public Guid? IN_UnderwritingStrippingScheduleID { get; set; }
        public Guid? IN_UnderwritingEventID { get; set; }
        public DateTime? StartDate { get; set; }
        public int? ValueTypeID { get; set; }
        public string ValueTypeIDText { get; set; }
        public decimal Value { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

    }
}
