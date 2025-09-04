using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class BatchCalculationMasterDataContract
    {
        public Guid? AnalysisID { get; set; }
        public string Name { get; set; }
        public int? BatchCalculationMasterID { get; set; }
        public Guid? BatchCalculationMasterGUID { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public int? Total { get; set; }
        public int? TotalCompleted { get; set; }
        public int? TotalFailed { get; set; }
        public int? TotalCanceled { get; set; }
        public string BatchType { get; set; }
        public Guid? UserID { get; set; }
        public string Status { get; set; }
        public string Email { get; set; }
        public string UserName { get; set; }
        
    }
}
