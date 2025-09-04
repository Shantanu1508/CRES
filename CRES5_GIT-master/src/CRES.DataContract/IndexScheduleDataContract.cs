using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class IndexScheduleDataContract
    {
        public DateTime? EffectiveDate { get; set; }
        public DateTime? Date { get; set; }
        public Decimal? Value { get; set; }
        public Guid? NoteID { get; set; }
        public string IndexType { get; set; }

    }
}
