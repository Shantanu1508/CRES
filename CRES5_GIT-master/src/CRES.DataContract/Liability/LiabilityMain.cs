using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.Liability
{
    public class LiabilityMain
    {
        public LiabilityMain() { }
        public int? SequenceID { get; set; }
        public DateTime? Date { get; set; }

        //Fund Section
        public DateTime? EffectiveDate { get; set; }
        public Decimal? InvestorCapital { get; set; }
        public Decimal? CapitalReserveReq { get; set; }
        public Decimal? ReserveReq { get; set; }
        public Decimal? CapitalCallNoticeBusinessDays { get; set; }
        public Decimal? FundBalance { get; set; }

        //Subline Line Section
        public Decimal? SublineBalance { get; set; }

        //Liability Line Section
        public string LiabilityID { get; set; }
        public string LiabilityType { get; set; }
        public int? FundingNoticeBusinessDays { get; set; }
        public int? InitialFundingDelay { get; set; }
        public int? PaydownDelay { get; set; }
        public DateTime? OriginationDate { get; set; }
        public Decimal? MaxAdvanceRate { get; set; }
        public Decimal? Commitment { get; set; }
        public DateTime? InitialMaturityDate { get; set; }
        public Decimal? LiabilityBalance { get; set; }

    }
}
