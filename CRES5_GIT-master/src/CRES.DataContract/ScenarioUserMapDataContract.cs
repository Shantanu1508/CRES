using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class ScenarioUserMapDataContract
    {
        public Guid? ScenarioUserMapID { get; set; }
        public Guid? AnalysisID { get; set; }
        public string UserID { get; set; }

        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string Description { get; set; }
        public string ScenarioName { get; set; }
        public string ScenarioColor { get; set; }
        public string CalculationModeText { get; set; }
        public int? CalculationModeID { get; set; }
        public int? CalcEngineType { get; set; }         
        public bool? AllowDebugInCalc { get; set; }
        public int? ScenarioStatus { get; set; }
        public string ScenarioStatusText { get; set; }
    }
}
