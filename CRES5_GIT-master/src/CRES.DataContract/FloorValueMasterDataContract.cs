using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class FloorValueMasterDataContract
    {
        public DateTime? MarkedDate { get; set; }
        public string IndexTypeName { get; set; }
        public Decimal? CurrentMarketLoanFloor { get; set; }
        public Decimal? Term { get; set; }
        public Decimal? LoanFloor { get; set; }
        public string CreatedBy { get; set; }

    }
}
