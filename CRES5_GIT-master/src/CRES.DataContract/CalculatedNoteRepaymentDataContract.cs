using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public class CalculatedNoteRepaymentDataContract
    {

        public DateTime? Date { get; set; }
        public String NoteID { get; set; }
        public Decimal? Value { get; set; }
        public Decimal? BeginningBalance { get; set; }
        public Decimal? CurrentCPRandSLRFactor { get; set; }
        public Decimal? MonthlyCPRandSLRFactor { get; set; }
        public Decimal? CummulativeRepayments { get; set; }
        public Decimal? EndingBalance { get; set; }
    }
}
