using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public partial class UniqueDatesForCalcEngine
    {
        public UniqueDatesForCalcEngine()
        {

        }
        public DateTime? UniqueDate { get; set; }
        public DateTime? UniqueDateNotAdj { get; set; }
        public bool? FFScheduleTab { get; set; }
        public bool? PIKScheduleTab { get; set; }
        public bool? LIBORScheduleTab { get; set; }
        public bool? AmortScheduleTab { get; set; }
        public bool? ServicingLogTab { get; set; }
        public bool? RateSpreadSchedule { get; set; }
        public bool? PIK { get; set; }
        public bool? PrepayAdditionalFeesSchedule { get; set; }
        public bool? SelectedMaturityDate { get; set; }
        public bool? FeeCouponStripping { get; set; }
        public bool? ProjectedWritoff { get; set; }

    }
}
