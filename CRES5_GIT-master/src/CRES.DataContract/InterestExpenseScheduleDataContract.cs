using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class InterestExpenseScheduleDataContract
    {
        public Guid DebtAccountID { get; set; }
        public Guid AdditionalAccountID { get; set; }
        public Guid EventID { get; set; }
        public int? InterestExpenseScheduleID { get; set; }
        public DateTime? InitialInterestAccrualEnddate { get; set; }
        public int? PaymentDayOfMonth { get; set; }
        public int? PaymentDateBusinessDayLag { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public int? Determinationdateleaddays { get; set; }
        public int? DeterminationDateReferenceDayOftheMonth { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public decimal? InitialIndexValueOverride { get; set; }
        public decimal? Recourse { get; set; }
        
        public DateTime? FirstRateIndexResetDate { get; set; }
    }
}
