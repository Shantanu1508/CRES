using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class SLBasisTab
    {
        public DateTime? Date { get; set; }

        // Straight Line Amort of Fees
        public Decimal? SLAmortOfOrigination_Fee { get; set; }
        public Decimal? SLAmortOfAdditional_Fee { get; set; }
        public Decimal? SLAmortOfExtension_Fee { get; set; }
        public Decimal? SLAmortOfExtension_Fee_1st_Half { get; set; }
        public Decimal? SLAmortOfExtension_Fee_2nd_Half { get; set; }

        public Decimal? SLAmortOfExit_Fee { get; set; }

        public Decimal? SLAmortOfHalf_Mod_Fee { get; set; }
        public Decimal? SLAmortOfInterest_Credit { get; set; }
        public Decimal? SLAmortOfMod_Fee { get; set; }

        public Decimal? SLAmortOfPremium { get; set; }
        public Decimal? SLAmortOfPremium_due_to_Refi { get; set; }
        public Decimal? SLAmortOfPrepayment_Fee_1 { get; set; }
        public Decimal? SLAmortOfRealized_Gain_Loss { get; set; }

        public Decimal? SLAmortOfUnused_Fee { get; set; }

        // Straight Line Amort Other Components
        public Decimal? SLAmortOfDiscountPremium { get; set; }
        public Decimal? SLAmortOfCapCost { get; set; }
        public Decimal? SLAmortOfTotalFees { get; set; }
        public Decimal? SLAmortOfTotalFeesInclInLY { get; set; }

        //SL Amort = Sum of All Amorts
        public Decimal? SLAmort { get; set; }

        // Accumulated Amorts - 
        public Decimal? AccumSLAmortOfDiscountPremium { get; set; }
        public Decimal? AccumSLAmortOfCapCost { get; set; }
        public Decimal? AccumSLAmortOfTotalFees { get; set; }
        public Decimal? AccumSLAmortOfTotalFeesInclInLY { get; set; }
        public Decimal? AccumSLAmort { get; set; }

        // Aggregates
        public Decimal? SLBasis { get; set; }
        public Decimal? SLBasisAdj { get; set; }
        public Decimal? SLBasisAdjPct { get; set; }

        // Total Amort  Split Components
        public Decimal? FeeAmort { get; set; }
        public Decimal? DiscPremAmort { get; set; }
        public Decimal? CapCostAmort { get; set; }

    }
}