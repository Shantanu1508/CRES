using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.Liability
{
    public class LiabilityNote
    {
        public string LiabilityNoteID { get; set; }
        public string LiabilityID { get; set; }
        public string AssetID { get; set; }
        public Decimal? BalanceAsofCalcDate { get; set; }
        public DateTime? LastLockedTransactionDate { get; set; }
        public Guid? LiabilityNoteAccountID { get; set; }
        public string Type { get; set; }
        public List<LiabilityNoteUpdate> LiabilityNoteUpdates { get; set; }

    }
}
