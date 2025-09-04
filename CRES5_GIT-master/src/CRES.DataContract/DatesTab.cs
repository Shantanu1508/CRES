using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public partial class DatesTab
    {
        public DatesTab()
        { }
        public DateTime? InterestAccrualPeriodEndDateArray { get; set; }
        public DateTime? InterestAccrualPeriodStartDateArray { get; set; }
        public int? NumberofDaysintheAccrualPeriod { get; set; }
        public DateTime? FloatingRateIndexReferenceDateNotAdjustedforResetFreq { get; set; }
        public int? RateIndexResetTag { get; set; }
        public DateTime? FloatingRateIndexReferenceDateAdjustedforResetFrequency { get; set; }
        public DateTime? PaymentDateusingAccrualFreqNotAdjustedforBusinessDay { get; set; }
        public int? PaymentDateRelativetoAccrualEndDateTag { get; set; }
        public DateTime? PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay { get; set; }
        public DateTime? PaymentDateAdjustedforWorkingDay { get; set; }
        public int? PayAccFreqTag { get; set; }
        public int? RemIoTerm { get; set; }
        public DateTime? ModeledPMTDropDate { get; set; }
        public DateTime? PMTDropDateOverride { get; set; }
        public DateTime? PMTDropDateUsed { get; set; }
        public int? SoftPayOffPeriodTag { get; set; }


    }
}
