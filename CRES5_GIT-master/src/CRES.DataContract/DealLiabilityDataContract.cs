using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static CRES.DataContract.V1CalcDataContract;

namespace CRES.DataContract
{
    public class DealLiabilityDataContract
    {
        public int LiabilityNoteAutoID { get; set; }
        public Guid LiabilityNoteAccountID { get; set; }
        public string LiabilityNoteID { get; set; }
        public string LiabilityNoteName { get; set; }
        public string DealAccountID { get; set; }
        public string AssetAccountID { get; set; }
        public DateTime? PledgeDate { get; set; }
        public DateTime? MaturityDate { get; set; }
        public Decimal? PaydownAdvanceRate { get; set; }
        public Decimal? FundingAdvanceRate { get; set; }
        public Decimal? CurrentAdvanceRate { get; set; }
        public Decimal? TargetAdvanceRate { get; set; }
        public decimal? CurrentLiabilityNoteBalance {get; set;}
        public decimal? UndrawnCapacity { get; set;}
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

    }
}
