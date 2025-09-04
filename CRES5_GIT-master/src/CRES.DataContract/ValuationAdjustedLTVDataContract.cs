using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class ValuationAdjustedLTVDataContract
    {
        public DateTime? MarkedDate { get; set; }
        public string CREDealID { get; set; }
        public string CREDealName { get; set; }
        public DateTime? FundedDate { get; set; }
        public decimal? TotalCommitment { get; set; }
        public decimal? AsStabilizedAppraisal { get; set; }
        public string PropertyType { get; set; }
        public decimal? ValueDecline { get; set; }
        public decimal? AdjustedAsStabilizedValue { get; set; }
        public decimal? RecourseCurrent { get; set; }
        public decimal? AdjustedAsStabilizedValuewithRecourse { get; set; }
        public decimal? AdjustedAsStabilizedLTV { get; set; }
        public decimal? UnadjustedAsStabilizedLTV { get; set; }
        public string UserID { get; set; }
    }
}
