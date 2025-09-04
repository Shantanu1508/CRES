using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.Liability
{
    public class Deposit
    {
        public Deposit() { }

        public Deposit(Guid? guid, string id, string type, Decimal? balance)
        {
            DepositID = guid; LiabilityID = id; this.Type = type; this.BalanceAsofCalcDate = balance;
        }

        public Guid? DepositID { get; set; }
        public string LiabilityID { get; set; }
        public string Type { get; set; }
        public string Currency { get; set; }
        public Decimal? BalanceAsofCalcDate { get; set; }
    }
}
