using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class SECMastHoldingDataContract
    {
        public DateTime MarkedDate { get; set; }
        public String Ticker { get; set; }
        public String LoanID { get; set; }
        public String Description { get; set; }
        public String FinancingSource { get; set; }
        public String NoteName { get; set; }
        public int? Priority { get; set; }
        public DateTime? OriginationDate { get; set; }
        public DateTime? FullyExtendedMaturityDate { get; set; }
        public String DayCount { get; set; }
        public int? PaymentDay { get; set; }
        public decimal? InterestRate { get; set; }
        public decimal? InitialFunding { get; set; }
        public decimal? OriginalAmountofLoan { get; set; }
        public decimal? AdjustedCommitment { get; set; }
        public decimal? AmountofLoanOutstanding { get; set; }
        public decimal? IndexFloor { get; set; }

        public String UserID { get; set; }

    }
}
