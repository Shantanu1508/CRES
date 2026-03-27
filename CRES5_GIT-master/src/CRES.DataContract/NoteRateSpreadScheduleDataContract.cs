using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public partial class NoteRateSpreadScheduleDataContract
    {
        public NoteRateSpreadScheduleDataContract()
        { 
    
        }

    //    public int NoteRateSpreadScheduleID { get; set; }
        public int? NoteID { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public DateTime? RateorSpreadChangeDate { get; set; }
        public Decimal? NoteRateSpreadScheduleValue { get; set; }

        public string IntCalcMethodText { get; set; }

        public int? IntCalcMethod { get; set; }

        public string NoteRateSpreadScheduleValueTypeText { get; set; }
        public int? NoteRateSpreadScheValueType { get; set; }

        public string NoteRateSpreadScheduleIndexTypeText { get; set; }
        public int? NoteRateSpreadScheduleIndexType { get; set; }
        public int? RateIndexResetFreq { get; set; }
        public DateTime? FirstRateIndexResetDate { get; set; }
        public Decimal? InitialIndexValueOverride { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

        public DateTime? FirstIndexDeterminationDateOverride { get; set; }
    }
}
