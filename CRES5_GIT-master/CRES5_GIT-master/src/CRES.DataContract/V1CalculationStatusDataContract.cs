namespace CRES.DataContract
{
    public class V1CalculationStatusDataContract
    {
        public string DealID { get; set; }
        public string RequestID { get; set; }
        public string AnalysisID { get; set; }
        public string objectID { get; set; }
        public int? objectTypeId { get; set; }
        public int? CalcType { get; set; }

    }
}
