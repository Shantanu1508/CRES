using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public partial class PIKInterestOverrideDataContract
    {
        public PIKInterestOverrideDataContract(DateTime? DueDate, DateTime? EndDate, Decimal? Amount)
        {
            this.DueDate = DueDate;
            AccrualEndDate = EndDate;
            PIKInterestOverrideAmount = Amount;
        }
        public DateTime? DueDate { get; set; }
        public DateTime? AccrualEndDate { get; set; }
        public Decimal? PIKInterestOverrideAmount { get; set; }
    }
}
