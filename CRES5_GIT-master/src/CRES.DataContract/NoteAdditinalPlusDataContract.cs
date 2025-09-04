using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public class NoteAdditinalPlusDataContract
    {
        public string NoteID { get; set; }
        //ServicingLog
        public DateTime? TransactionDate { get; set; }
        public int TransactionType { get; set; }
        public string TransactionTypeText { get; set; }
        public Decimal? TransactionAmount { get; set; }
        public DateTime? RelatedtoModeledPMTDate { get; set; }
        public Decimal? ModeledPayment { get; set; }
        public Decimal? AmountOutstandingafterCurrentPayment { get; set; }

        //PIKSchedule
        public DateTime? PIKSchedule_EffectiveDate { get; set; }
        public List<PIKSchedule> NotePIKScheduleList { get; set; }
        //FeeCouponStrip
        public DateTime? FeeCoupon_EffectiveDate { get; set; }
        public List<FeeCouponStripReceivableTab> ListFeeCouponStripReceivable { get; set; }
        //LiborSchedule
        public DateTime? LiborSchedule_EffectiveDate { get; set; }
        public List<LiborScheduleTab> ListLiborScheduleTab { get; set; }

        //FixedAmort
        public DateTime? FixedAmort_EffectiveDate { get; set; }
        public List<FixedAmortScheduleTab> ListFixedAmortScheduleTab { get; set; }

        //FutureFundingScheduleTab
        public DateTime? FutureFunding_EffectiveDate { get; set; }
        public List<FutureFundingScheduleTab> ListFutureFundingScheduleTab { get; set; }

    }
}
