using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public class ServicingFeeScheduleDataContract
    {
        public System.Guid NoteID { get; set; }
        public System.Guid AccountID { get; set; }
        public Nullable<System.DateTime> Date { get; set; }
        public Nullable<decimal> Value { get; set; }
        public Nullable<System.DateTime> EffectiveDate { get; set; }
        public Nullable<System.DateTime> EffectiveStartDate { get; set; }
        public Nullable<System.DateTime> EffectiveEndDate { get; set; }
        public Nullable<int> EventTypeID { get; set; }
        public string EventTypeText { get; set; }
        public Nullable<System.Guid> EventId { get; set; }
        public string CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public Nullable<System.DateTime> UpdatedDate { get; set; }
    }
}
