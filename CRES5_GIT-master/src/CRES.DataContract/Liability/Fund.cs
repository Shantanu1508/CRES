using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.Liability
{
    public class Fund
    {
        public Guid? EquityAccountID { get; set; }
        public Decimal? PortfolioBalanceAsofCalcDate { get; set; }
        public int? FundDelay { get; set; }
        public int? FundingDay { get; set; }
        public Guid? PortfolioAccountID { get; set; }
        public string PortfolioAccountName { get; set; }
        public string EquityName { get; set; }
        public string EquityType { get; set; }
        public string Currency { get; set; }
        public Decimal? InvestorCapital { get; set; }
        public Decimal? CapitalReserveReq { get; set; }
        public Decimal? ReserveReq { get; set; }
        public int? CapitalCallNoticeBusinessDays { get; set; }
        public DateTime? InceptionDate { get; set; }
        public DateTime? LastDatetoInvest { get; set; }
        public Guid? LinkedShortTermBorrowingFacility { get; set; }
        public Decimal? BalanceAsofCalcDate { get; set; }
        public DateTime? LastLockedTransactionDate { get; set; }
        public List<FundUpdate> FundUpdates { get; set; }

    }
}
