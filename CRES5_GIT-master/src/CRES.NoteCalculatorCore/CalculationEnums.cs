using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

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

        public static List<string> ListCoreInterestTransactions = new List<string>()
        {
            "InterestPaid",
            "PurchasedInterest",
            "StubInterest"
        };

        public static List<string> ListLookUpTypes = new List<string>()
        {
            "TransactionDate",
            "PaymentDate",
            "AccrualPeriodEndDate"
        };

        public static List<string> IndexNames = new List<string>()
        {
            "1M LIBOR",
            "1M Term SOFR"
        };

        public static List<string> LiabilityOpModesText = new List<string>()
        {
            "GenTransactionDates",
            "DrawUptoFullFundBalance",
            "MonthsToHold",
            "ScheduledDraws"
        };

        public static List<string> AccountCategoriesText = new List<string>()
        {
            "Fund",
            "Repo",
            "Subline",
            "Note-on-Note",
            "A-Note Buyer"
        };

        public static List<string> FundingSourceText = new List<string>()
        {
            "Fund",
            "Repo",
            "Note-on-Note",
            "A-Note Buyer"
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
        Amort_Rate_Floor,
        Index_Name
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

    public enum ServicingLogLookUpType
    {
        TransactionDate = 0,
        PaymentDate = 1,
        AccrualPeriodEndDate = 2
    }

    public enum EnmIndexName
    {
        Libor1M = 0,
        Sofr1M = 1
    }

    public enum LiabilityOpModes
    {
        GenTransactionDates = 0,
        DrawUptoFullFundBalance = 1,
        MonthsToHold = 2,
        ScheduledDraws = 3
    }
    public enum AccountTypes
    {
        Fund = 0,
        Repo = 1,
        Subline = 2,
        NoteOnNote = 3,
        ANoteBuyer = 4
    }
    public enum FundingSources
    {
        Fund = 0,
        Repo = 1,
        NoteonNote = 2,
        ANoteBuyer = 3
    }
}
