using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class PortfolioDataContract
    {
        public int PortfolioMasterID { get; set; }
        public Guid? PortfolioMasterGuid { get; set; }
        public string PortfolioName { get; set; }
        public string Description { get; set; }
        public string PoolIDs { get; set; }
        public string ClientIDs { get; set; }
        public int? MaturityDateID { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string FundIDs { get; set; }
        public Boolean? AllowWholeDeal { get; set; }
        public string AllowWholeDealText { get; set; }
        public string FinancingSourceIDs { get; set; }

        public int? XIRRConfigID { get; set; }

    }
}
