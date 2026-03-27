using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class IN_UnderwritingPIKScheduleDataContract
    {
        public Guid? IN_UnderwritingNoteID { get; set; }
        public Guid? IN_UnderwritingAccountID { get; set; }
        public Guid? IN_UnderwritingPIKScheduleID { get; set; }
        public Guid? IN_UnderwritingEventID { get; set; }
        public decimal? AdditionalIntRate { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }
}
