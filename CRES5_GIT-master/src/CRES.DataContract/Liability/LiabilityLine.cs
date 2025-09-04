using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.Liability
{
    public class LiabilityLine
    {
        public string LiabilityID { get; set; }
        public string Type { get; set; }
        public string MatchTerm { get; set; }
        public string IsRevolving { get; set; }
        public string Currency { get; set; }
        public int? FundingNoticeBusinessDays { get; set; }
        public int? InitialFundingDelay { get; set; }
        public Decimal? MaxAdvanceRate { get; set; }
        public DateTime? OriginationDate { get; set; }
        public int? PaydownDelay { get; set; }
        public Decimal? BalanceAsofCalcDate { get; set; }
        public DateTime? LastLockedTransactionDate { get; set; }
        public Guid? PortfolioAccountID { get; set; }
        public string PortfolioAccountName { get; set; }
        public int? FundDelay { get; set; }
        public int? FundingDay { get; set; }
        public Decimal? PortfolioBalanceAsofCalcDate { get; set; }
        public Guid? DebtAccountID { get; set; }
        public List<LiabilityLineUpdate> LiabilityLineUpdates { get; set; }
    }
}
