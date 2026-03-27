
namespace CRES.DataContract
{
    public class XIRRCalculationRequestsDataContract
    {


        public int? XIRRCalculationRequestsID { get; set; }
        public int? XIRRConfigID { get; set; }
        public int? XIRRReturnGroupID { get; set; }
        public string Type { get; set; }
        public string DealAccountID { get; set; }
        public string AnalysisID { get; set; }
        public string UserID { get; set; }
        public bool IsCreateFile { get; set; }

    }
}
