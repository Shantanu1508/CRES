using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class JournalLedgerDataContract
    {
        public int? JournalEntryMasterID { get; set; }
        public int? TransactionEntryID { get; set; }
        public Guid? JournalEntryMasterGUID { get; set; }
        public DateTime? JournalEntryDate { get; set; }
        public string Comments { get; set; }
        public Guid? DebtEquityAccountID { get; set; }
        public DateTime? TransactionDate { get; set; }
        public int? TransactionType { get; set; }
        public string TransactionTypeText { get; set; }
        public decimal? TransactionAmount { get; set; }
        public string CommentsDetail { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedByText { get; set; }
        public DateTime? UpdatedDate { get; set; }

       

    }
}
