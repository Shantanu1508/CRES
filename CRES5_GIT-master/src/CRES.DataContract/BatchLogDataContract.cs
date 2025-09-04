using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class BatchLogDataContract
    {
        public Guid? BatchLogID { get; set; }
        public int? BatchTypeID { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public Guid? StartedByUserID { get; set; }
        public string ErrorMessage { get; set; }

        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

        public Guid? outBatchLogID { get; set; }
        
    }
}
