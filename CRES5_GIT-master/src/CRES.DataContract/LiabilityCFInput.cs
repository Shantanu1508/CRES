using CRES.DataContract.Liability;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class LiabilityCFInput
    {
        public string Scenario { get; set; }
        public Guid? AnalysisID { get; set; }
        public DateTime? CalcAsOfDate { get; set; }
        public Fund Fund { get; set; }
        public List<AssetNote> AssetNotes { get; set; }
        public List<LiabilityNote> LiabilityNotes { get; set; }
        public List<LiabilityLine> LiabilityLines { get; set; }
    }
}
