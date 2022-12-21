using System.Data;

namespace CRES.DataContract
{
    public class GenericVSTOResult
    {
        public bool Succeeded { get; set; }
        public string Message { get; set; }
        public string CRENoteID { get; set; }
        public string Comment { get; set; }
        public DataTable apiResult { get; set; }
        public string Status { get; set; }
        public string Progress { get; set; }
    }
}
