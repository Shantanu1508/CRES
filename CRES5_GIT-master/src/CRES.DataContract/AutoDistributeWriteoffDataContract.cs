using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class AutoDistributeWriteoffDataContract
    {
        public Guid? UserID { get; set; }
        public Guid? DealID { get; set; }
        public Guid? NoteID { get; set; }
        public string CRENoteID { get; set; }
        public string NoteName { get; set; }
        public string LienPosition { get; set; }
        public int? PriorityOverride { get; set; }
        public int? Priority { get; set; }
        public decimal? EstBls { get; set; }
        public int? PriorityUsedInCaculation { get; set; }
        public decimal? Ratio { get; set; }
        public decimal? TotalAmountDistributed { get; set; }

    }
}
