using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
  public class DealArchieveDataContract
    {
        public Guid? DealFundingID { get; set; }
        public Guid? DealID { get; set; }
        public DateTime? Date { get; set; }
        public Decimal? Value { get; set; }
        public string Comment { get; set; }
        public int? PurposeID { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

    }
}
