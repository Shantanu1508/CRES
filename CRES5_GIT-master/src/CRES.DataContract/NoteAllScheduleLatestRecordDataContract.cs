using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public class NoteAllScheduleLatestRecordDataContract
    {

        public DateTime? FutureFundingEffactiveDate { get; set; }
        public DateTime? LiborScheduleEffactiveDate { get; set; }
        public DateTime? FixedAmortScheduleEffactiveDate { get; set; }
        public DateTime? PIKfromPIKSourceNoteEffactiveDate { get; set; }
        public DateTime? FeeCouponStripReceivableEffactiveDate { get; set; }

        public List<FutureFundingScheduleTab> ListFutureFundingScheduleTab { get; set; }
        public List<LiborScheduleTab> ListLiborScheduleTab { get; set; }
        public List<FixedAmortScheduleTab> ListFixedAmortScheduleTab { get; set; }
        public List<PIKfromPIKSourceNoteTab> ListPIKfromPIKSourceNoteTab { get; set; }
        public List<FeeCouponStripReceivableTab> ListFeeCouponStripReceivable { get; set; }


        public DateTime? LastUpdatedDate_FF { get; set; }
        public string LastUpdatedDate_String_FF { get; set; }
        public string LastUpdatedBy_FF { get; set; }

    }
}
