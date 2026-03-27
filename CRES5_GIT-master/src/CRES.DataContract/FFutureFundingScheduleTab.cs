using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class FFutureFundingScheduleTab
    {
        public Guid? NoteID { get; set; }
        public DateTime? Date { get; set; }
        public decimal? Value { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public string PurposeText { get; set; }

    }
}
