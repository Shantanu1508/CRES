using System;

namespace CRES.DataContract
{
    public class YieldCalcInputDataContract
    {
        public string CRENoteID { get; set; }
        public DateTime? NPVdate { get; set; }
        public decimal? Value { get; set; }
        public DateTime? Effectivedate { get; set; }
        public Guid? AnalysisID { get; set; }
        public string YieldType { get; set; }
        public string Createdby { get; set; }

    }
}
