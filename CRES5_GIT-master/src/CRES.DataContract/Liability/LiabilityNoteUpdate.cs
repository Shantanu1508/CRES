using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.Liability
{
    public class LiabilityNoteUpdate
    {
        public DateTime? EffectiveDate { get; set; }
        public DateTime? PledgeDate { get; set; }
        public Decimal? TargetAdvanceRate { get; set; }
        public Decimal? PaydownAdvanceRate { get; set; }
        public Decimal? FundingAdvanceRate { get; set; }
        public DateTime? MaturityDate { get; set; }
    }
}
