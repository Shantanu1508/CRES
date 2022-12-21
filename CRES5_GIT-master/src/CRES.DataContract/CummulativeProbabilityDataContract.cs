using System;

namespace CRES.DataContract
{
    public class CummulativeProbabilityDataContract
    {
        public DateTime? ProjectedPayoffAsofDate { get; set; }
        public Decimal? CumulativeProbability { get; set; }
        public DateTime? CalculatedStart { get; set; }
        public DateTime? CalculatedEnd { get; set; }
        public Decimal? PeriodicProbability { get; set; }
        public Decimal? CPRProbability { get; set; }
        public Decimal? CPRCummulative { get; set; }
        public Decimal? StraightLineFactor { get; set; }
        public Decimal? CPRFactor { get; set; }



    }

}
