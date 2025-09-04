using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class ServicingWatchListCalcDataContract
    {
        public String CreNoteID { get; set; }
        public String NoteID { get; set; }
        public DateTime? Date { get; set; }
        public Decimal? Amount { get; set; }
        public DateTime? EffectiveDate { get; set; }
    }
}
