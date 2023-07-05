using System;

namespace CRES.DataContract
{
    public class FileBatchDetailDataContract
    {
        public int BatchLogID { get; set; }
        public string ProcessName { get; set; }
        public string ErrorMsg { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }
}
