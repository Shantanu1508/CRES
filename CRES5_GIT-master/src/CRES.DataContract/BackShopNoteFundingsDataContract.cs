using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class BackShopNoteFundingsDataContract
    {
        public int? FundingId { get; set; }
        public string GeneratedBy { get; set; }
        public string Noteid_F { get; set; }
        public bool? Applied { get; set; }
        public DateTime? FundingDate { get; set; }
        public decimal? FundingAmount { get; set; }
        public string FundingPurposeCD_F { get; set; }
        public decimal? FundingExpense { get; set; }
        public string Comments { get; set; }
        public string NoteFundingReasonCD_F { get; set; }
        public string Status { get; set; }
        public string AuditUserName { get; set; }
        public bool? WireConfirm { get; set; }
        public string FundingAdjustmentTypeCd_F { get; set; }
        public string AdjustmentType { get; set; }


    }
}
