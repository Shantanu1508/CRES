using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class PIKDistributionsDataContract
    {

        public Guid? SourceNoteID { get; set; }
        public Guid? ReceiverNoteID { get; set; }
        public DateTime? TransactionDate { get; set; }
        public Decimal? Amount { get; set; }
    }
}
