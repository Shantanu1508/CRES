using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class AutoSpreadRuleDataContract
    {
        public Guid? UserID { get; set; }
        public Guid? DealID { get; set; }
        public Guid? AutoSpreadRuleID { get; set; }
        public int? PurposeType { get; set; }
        public string PurposeSubType { get; set; }
        public decimal? DebtAmount { get; set; }
        public decimal? EquityAmount { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? DistributionMethod { get; set; }
        public int? FrequencyFactor { get; set; }
        public string Comment { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string PurposeTypeText { get; set; }
        public string DistributionMethodText { get; set; }

        public decimal? RequiredEquity { get; set; }
        public decimal? AdditionalEquity { get; set; }


    }
}
