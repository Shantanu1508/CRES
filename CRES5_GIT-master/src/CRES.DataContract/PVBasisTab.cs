using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class PVBasisTab
    {

        // Fields copied from GAAPBasisTab - Aji 1/2020
        public DateTime? Date { get; set; }
        public Decimal? CashFlowusedforLevelYieldPreCap { get; set; }
        public Decimal? PreCapLevelYield { get; set; }
        public Decimal? LockedPreCapBasis { get; set; }
        public Decimal? PeriodLevelYieldIncomePreCap { get; set; }
        public Decimal? PVAmort { get; set; }
        public Decimal? AccumPVAmort { get; set; }
        public Decimal? GAAPBasis { get; set; }
        public Decimal? AccumGAAPAmort { get; set; }
        public Decimal? GAAPAmort { get; set; }
        public Decimal? GAAPAmortPct { get; set; }

        //Cash Flow Level Yield Additional Components
        public Decimal? NetPrincipalInflowOutflow { get; set; }
        public Decimal? AccumDailyInterest { get; set; }
        public Decimal? PVBasisAdj { get; set; }
        public Decimal? PVBasisAdjPct { get; set; }

        //Common Fields
        public Decimal? GrossDeferredFeesLevelYield { get; set; }
        public Decimal? CleanCostLevelYield { get; set; }
        public Decimal? CleanCostAllIn { get; set; }
        public Decimal? DeferredFeeAmountLevelYield { get; set; }
        public Decimal? DeferredFeeAmountAllInYield { get; set; }

        // New Fields added for SL Basis - Aji 1/2020
        public Decimal? SLBasis { get; set; }
        public Decimal? FeeSLAmort { get; set; }
        public Decimal? DiscPremiumSLAmort { get; set; }
        public Decimal? CapCostSLAmort { get; set; }

        // New Fields added for AllIn Basis - Aji 1/2020
        public Decimal? CashFlowForAllInBasis { get; set; }
        public Decimal? AllInYield { get; set; }
        public Decimal? AllInBasis { get; set; }
        
    }


}
