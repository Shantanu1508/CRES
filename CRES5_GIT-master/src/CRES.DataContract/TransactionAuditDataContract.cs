using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
  public class TransactionAuditDataContract
    {
        public string OrigFileName { get; set; }
        public string BlobFileName { get; set; }
        public string UploadedBY { get; set; }
        public int? TotalNumberofRecords { get; set; }
        public int? NumberofRecordsimported { get; set; }
        public int? NumberofRecordsIgnored { get; set; }
        public int? NumberofRecordsPaydownIgnored { get; set; }
        public DateTime? UploadedDate { get; set; }
        public int? BatchLogID { get; set; }

    }


    //public class TransactionAuditDataContract
    //{
    //    public string OrigFileName { get; set; }
    //    public string BlobFileName { get; set; }
    //    public string UploadedBY { get; set; }
    //    public int? TotalNumberofRecords { get; set; }
    //    public int? NumberofRecordsimported { get; set; }
    //    public int? NumberofRecordsIgnored { get; set; }
    //    public DateTime? UploadedDate { get; set; }
    //    public int? BatchLogID { get; set; }

    //}


}
