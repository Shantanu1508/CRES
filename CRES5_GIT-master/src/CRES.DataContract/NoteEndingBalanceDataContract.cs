using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public class NoteEndingBalanceDataContract
    {
        public DateTime? Date { get; set; }
        public Decimal? EndingBalance { get; set; }
        public string NoteID { get; set; }
        public string NotenName { get; set; }
        public Decimal? RepayToBeAdjustedUseRuleN { get; set; }
        public Decimal? SumRepaymentSequence { get; set; }
        public Boolean isNCANote { get; set; }
    }
}
