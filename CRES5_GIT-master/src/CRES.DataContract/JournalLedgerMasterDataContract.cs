using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class JournalLedgerMasterDataContract
    {
        public int? JournalEntryMasterID { get; set; }
        public int? TransactionEntryID { get; set; }
        public Guid? JournalEntryMasterGUID { get; set; }
        public DateTime? JournalEntryDate { get; set; }
        public string Comments { get; set; }

        public List<JournalLedgerDataContract> Listjldc { get; set; }
        
    }
}
