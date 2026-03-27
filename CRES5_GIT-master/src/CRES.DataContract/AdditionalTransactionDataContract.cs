using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class AdditionalTransactionDataContract
    {
        public DateTime? TransactionDate { get; set; }
        public decimal? TransactionAmount { get; set; }
        public int? TransactionType { get; set; }
        public string TransactionTypeText { get; set; }
        public Decimal? IncludeLevelYield { get; set; }
        public string Comments { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }
}
