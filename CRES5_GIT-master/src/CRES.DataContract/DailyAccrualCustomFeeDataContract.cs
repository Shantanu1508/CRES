using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class DailyAccrualCustomFeeDataContract
    {
        public string FeeName { get; set; }
        public DateTime AccrualDate { get; set; }
        public decimal? AccrualAmount { get; set; }

    }
}
