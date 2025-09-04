using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.Liability
{
    public class LiabilityLineTransaction
    {
        public Guid? AnalysisID { get; set; }
        public Guid? LiabilityAccountID { get; set; }
        public string LiabilityID { get; set; }
        public DateTime? Date { get; set; }
        public string TransactionType { get; set; }
        public Decimal? Amount { get; set; }
        public Decimal? EndingBalance { get; set; }
        public String UserID { get; set; }

    }
}
