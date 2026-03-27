using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class FloorValueDetailDataContract
    {
        public DateTime? MarkedDate { get; set; }
        public string IndexTypeName { get; set; }
        public Decimal? Percentage { get; set; }
        public Decimal? Month { get; set; }
        public Decimal? Value { get; set; }
        public string CreatedBy { get; set; }
        public string UserID { get; set; }
        

    }
}
