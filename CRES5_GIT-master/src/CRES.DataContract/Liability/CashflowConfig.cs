using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.Liability
{
    public class CashflowConfig
    {
        public string OperationMode { get; set; }
        public int EqDelayMonths { get; set; }
        public int FinDelayMonths { get; set; }
        public decimal? MinEqBalForFinStart { get; set; }
        public int SublineEqApplyMonths { get; set; }
        public int SublineFinApplyMonths { get; set; }
        public int[] DebtCallDaysOfTheMonth { get; set; }
        public int[] CapitalCallDaysOfTheMonth { get; set; }
    }
}
