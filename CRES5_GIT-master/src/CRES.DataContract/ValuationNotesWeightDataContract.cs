using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class ValuationNotesWeightDataContract
    {
        public DateTime MarkedDate { get; set; }
        public string PropertyType { get; set; }
        public string Header { get; set; }
        public int? SortOrder{ get; set; }
        public decimal? Value { get; set; }
        public string UserID { get; set; }
    }
}
