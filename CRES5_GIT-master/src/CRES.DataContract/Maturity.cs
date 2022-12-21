using System;

namespace CRES.DataContract
{
    public class Maturity
    {
        public Maturity()
        {
        }

        public DateTime? EffectiveDate { get; set; }
        //  public string MaturityID { get; set; }
        public Guid? EventId { get; set; }
        public DateTime? Date { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string ScheduleID { get; set; }
        public int? ModuleId { get; set; }

    }
}
