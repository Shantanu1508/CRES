using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.Liability
{
    public class CalculationRequestsLiabilityDataContract
    {
        public string AccountID { get; set; }
        public string AnalysisID { get; set; }
        public string UserID { get; set; }
        public string StatusText { get; set; }
        public int CalcType { get; set; }
        public int CalcEngineType { get; set; }
        public string RequestFrom { get; set; }
    }
}
