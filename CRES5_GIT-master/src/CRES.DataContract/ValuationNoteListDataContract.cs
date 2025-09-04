using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class ValuationNoteListDataContract
    {
        public DateTime? MarkedDate { get; set; }
        public string NoteID { get; set; }
        public string CREDealID { get; set; }
        public string CREDealName { get; set; }
        public Decimal? NoteNominalDMOrPriceForMark { get; set; }
        public string CreatedBy { get; set; }
        public string UserID { get; set; }

    }
}
