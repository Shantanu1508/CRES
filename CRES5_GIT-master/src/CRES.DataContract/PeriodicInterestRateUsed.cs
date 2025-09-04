using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class PeriodicInterestRateUsed
    {
        public string NoteID { get; set; }
        public DateTime? Date { get; set; }        
        public Decimal CouponSpread { get; set; }
        public Decimal? AllInCouponRate { get; set; }
        public Decimal? AllInPikRate { get; set; }
        public Decimal? LiborRate { get; set; }
        public Decimal? IndexFloor { get; set; }
        public Decimal? CouponRate { get; set; }
        public Decimal? AdditionalPIKinterestRatefromPIKTable { get; set; }
        public Decimal? AdditionalPIKSpreadfromPIKTable { get; set; }
        public Decimal? PIKIndexFloorfromPIKTable { get; set; }
        public Guid? AnalysisID { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedDate { get; set; }
        public int? IsPaymentDate { get; set; }

    }
}
