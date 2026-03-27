using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public partial class ServicingLogTab
    {
        public ServicingLogTab()
        { }
        //added comment 
        public DateTime? TransactionDate { get; set; }
        public int TransactionType { get; set; }
        public string TransactionTypeText { get; set; }
        public Decimal? TransactionAmount { get; set; }
        public DateTime? RelatedtoModeledPMTDate { get; set; }
        public Decimal? ModeledPayment { get; set; }
        public Decimal? AmountOutstandingafterCurrentPayment { get; set; }
        public Decimal? Adjustment { get; set; }
        public Decimal? ActualDelta { get; set; }
        public Decimal? UsedInFeeRecon { get; set; }

        public DateTime? TransactionDateByRule { get; set; }
        public DateTime? TransactionDateServicingLog { get; set; }
        public DateTime? RemittanceDate { get; set; }
        //public Decimal? UsedInFeeRecon { get; set; }

        public DateTime? InitialInterestAccrualEndDate { get; set; }
        public Decimal? WriteOffAmount { get; set; }
        public Decimal? CashInterest { get; set; }
        public Decimal? CapitalizedInterest { get; set; }

    }
}
