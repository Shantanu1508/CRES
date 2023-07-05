using System;

namespace CRES.DataContract
{
    public class InterestAccrualDates
    {

        public DateTime? InterestAccrualPeriodEndDates { get; set; }
        public DateTime? InterestAccrualPeriodStartDates { get; set; }
        public int? NumofDaysinAccrualPeriod { get; set; }
        public DateTime? IndexReferenceDateNotAdjusted { get; set; }
        public int? RateIndexResetTag { get; set; }
        public DateTime? IndexReferenceDateAdjusted { get; set; }
        public DateTime? PMTDateNotAdjustedBusinessDay { get; set; }
        public int? PMTDateAccrualEndTag { get; set; }
        public int? PayAccFreqTag { get; set; }
        public DateTime? PMTDateAccuralPeriodAdjusted { get; set; }
        public DateTime? PMTDateWorkingDayAdjusted { get; set; }
        public DateTime? ModeledPMTDropDate { get; set; }
        public DateTime? PMTDropDateOverride { get; set; }
        public DateTime? PMTDropDateUsed { get; set; }



    }
}
