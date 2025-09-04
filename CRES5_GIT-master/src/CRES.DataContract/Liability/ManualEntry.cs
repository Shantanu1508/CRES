using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.Liability
{
    public class ManualEntry
    {
        public int ManualEntryID { get; set; }
        public string AccountId { get; set; }
        public string AccountName { get; set; }
        public DateTime TransactionDate { get; set; }
        public string TransactionType { get; set; }
        public decimal? TransactionAmount { get; set; }
        public string Comments { get; set; }
    }

}
