using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class CalculatedAutoRepaymentDataContract
    {
        public DateTime? Date { get; set; }
        public Decimal? Value { get; set; }
        public Decimal? BeginningBalance { get; set; }
        public Decimal? Funding { get; set; }
        public Decimal? Repayment { get; set; }
        public Decimal? PIKPrincipalFunding { get; set; }
        public Decimal? PIKPrincipalPaid { get; set; }
        public Decimal? ScheduledPrincipalPaid { get; set; }
        public Decimal? NonCommitmentAdjTotal { get; set; }
        public Decimal? RevolverTotal { get; set; }
        public Decimal? EndingBalance { get; set; }
        public Decimal? CurrentCPRandSLRFactor { get; set; }
        public Decimal? MonthlyCPRandSLRFactor { get; set; }
        public Decimal? CummulativeRepayments { get; set; }

    }
}
