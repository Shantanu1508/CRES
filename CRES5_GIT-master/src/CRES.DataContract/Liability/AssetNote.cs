using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.Liability
{
    public class AssetNote
    {
        public string CreNoteID { get; set; }
        public DateTime? CLosingDate { get; set; }
        public Decimal? AdjCommitment { get; set; }
        public Decimal? BalanceAsofCalcDate { get; set; }
        public DateTime? LastLockedTransactionDate { get; set; }
        public List<Transaction> Transactions { get; set; }
        public Guid? AssetAccountID { get; set; }
    }
}
