using System;

namespace CRES.DataContract
{
    public class DailyAccrualCustomFeeDataContract
    {
        public string FeeName { get; set; }
        public DateTime AccrualDate { get; set; }
        public decimal? AccrualAmount { get; set; }

    }
}
