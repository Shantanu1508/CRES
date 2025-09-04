using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class PayruleNoteAMSequenceDataContract
    {
        public Guid? NoteID { get; set; }
        public int? SequenceNo { get; set; }
        public int? SequenceType { get; set; }
        public string SequenceTypeText { get; set; }
        public Decimal? Value { get; set; }
        public Decimal? Ratio { get; set; }
        
    }
}
