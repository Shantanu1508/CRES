using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class BackShopNoteProjectionDataContract
    {
        public string Noteid_F { get; set; }
        public bool? Applied { get; set; }
        public DateTime? PaymentDate { get; set; }
        public decimal? Amount { get; set; }
        public string FundingPurposeCD_F { get; set; }
        public decimal? FundingExpense { get; set; }
        public string Comments { get; set; }
        public string InactiveSw { get; set; }
        public int? SortOrder { get; set; }
        public string AuditUserName { get; set; }
        public string GeneratedBy { get; set; }       
        
    }
}
