using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class AutoRepaymentNoteBalancesDataContract
    {
        public DateTime? Date { get; set; }
        public string NoteID { get; set; }
        public Decimal? Amount { get; set; }
        public string Type { get; set; }

    }
}
