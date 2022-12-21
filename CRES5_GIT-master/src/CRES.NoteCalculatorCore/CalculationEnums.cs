using System.Collections.Generic;

namespace CRES.NoteCalculator
{
    class CalculationEnums
    {
        public static string[] TransactionTypeText = new string[] {
        "FloatInterest",
        "InterestPaid",
        "OtherFeeExcludedFromLevelYield",
        "PIKPrincipalFunding",
        "PrepaymentFeeExcludedFromLevelYield",
        "PurchasedInterest",
        "PIKInterestPaid",
        "PIKInterest",
        "PIKPrincipalPaid",
        "StubInterest",
        "UnusedFeeExcludedFromLevelYield"
        };

        public static List<string> ListInterestTransactions = new List<string>()
        {
            "InterestPaid",
            "PIKInterestPaid",
            "PurchasedInterest",
            "StubInterest",
            "FloatInterest"
        };
    }


    public enum EnmFeeType
    {
        Prepayment_Fee,
        Additional_Fee,
        Exit_Fee,
        Unused_Fee
    }

    public enum EnmNoteStrippingType
    {
        Coupon_Strip,
        Exit_Fee_Strip,
        Additional_Fee_Strip,
        Origination_Fee_Strip

    }

    public enum EnmDefaultScheduleType
    {
        Default_Rate_Step_Up,
        Default_Rate_Override,
        Severity,
        Debt_Service_Shortfall
    }
    public enum EnmFinancingRateType
    {
        Financing_Rate,
        Financing_Spread,
        Financing_Advance_Rate
    }

    public enum EnmServicingLogType
    {
        Principal_Received,
        InterestPaid,
        Prepayment_Fee_Received,
        Exit_Fee_Received,
        Extension_Fee_Received
    }
    public enum EnmRateType
    {
        Rate,
        Spread,
        Index_Floor,
        Index_Cap,
        Coupon_Floor,
        Coupon_Cap,
        Amort_Rate,
        Amort_Spread,
        Amort_Rate_Cap,
        Amort_Rate_Floor
    }

    public enum EnmRoundMethodType
    {
        Nearest,
        Up,
        Down
    }
    public enum EnmBusinessDayLookupMethod
    {
        Prior,
        After
    }

    public enum EnmPmtDate
    {
        //Payment Date using Accrual Freq - Not Adjusted for Business Day
        PmtDtNotAdj_3 = -3,
        PmtDtNotAdj_2 = -2,
        PmtDtNotAdj_1 = -1,
        PmtDtNotAdj = 0,
        NotAPmtDt = 1
    }

    public enum TransactionType
    {
        //Payment Date using Accrual Freq - Not Adjusted for Business Day
        FloatInterest = 0,
        InterestPaid = 1,
        OtherFeeExcludedFromLevelYield = 2,
        PIKPrincipalFunding = 3,
        PrepaymentFeeExcludedFromLevelYield = 4,
        PurchasedInterest = 5,
        PIKInterestPaid = 6,
        PIKInterest = 7,
        PIKPrincipalPaid = 8,
        StubInterest = 9,
        UnusedFeeExcludedFromLevelYield = 10
    }

}
