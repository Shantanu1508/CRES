using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.Liability
{
    public class LiabilityCFOutput
    {
        public List<LiabilityNoteTransaction> LiabilityNoteTransactions{ get; set; }
        public List<LiabilityLineTransaction> LiabilityLineTransactions { get; set; }

        public string CalculatorExceptionMessage { get; set; }
        public string CalculatorStackTrace { get; set; }
    }
}
