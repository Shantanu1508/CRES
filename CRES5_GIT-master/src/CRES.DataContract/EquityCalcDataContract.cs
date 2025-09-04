using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class EquityCalcDataContract
    {
        public string AccountID { get; set; }
        public DateTime? RequestTime { get; set; }        
        public int AutomationRequestsID { get; set; }
        public string UserName { get; set; }
        public string AnalysisID { get; set; }
        public int CalculationModeID { get; set; }
        public string CalculationRequestID { get; set; }
        public int? CalcType { get; set; }

    }
}
