using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class WFTaskAdditionalDetailDataContract
    {
        public string TaskID { get; set; }
        public int? TaskTypeID { get; set; }
        public decimal? ExitFee { get; set; }
        public decimal? ExitFeePercentage { get; set; }
        public decimal? PrepayPremium { get; set; }
        public string AdditionalEmail { get; set; }

    }
}
