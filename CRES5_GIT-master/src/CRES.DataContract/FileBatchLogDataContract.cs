using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public class FileBatchLogDataContract
    {
        public int ServcerMasterID { get; set; }
        public string OrigFileName { get; set; }
        public string BlobFileName { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int BatchLogID { get; set; }

    }
}
