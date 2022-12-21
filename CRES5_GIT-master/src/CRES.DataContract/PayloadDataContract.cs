using System.Collections.Generic;

namespace CRES.DataContract
{
    public class PayloadDataContract
    {
        public string DealID { get; set; }
        public string CREDealID { get; set; }
        public string DealName { get; set; }
        public string[] prepay_types { get; set; }
        public List<note> notes { get; set; }

    }

    //public class notes
    //{
    //    public string CRENoteID { get; set; }
    //    public string LienPosition { get; set; }
    //    public decimal LoanAmount { get; set; }
    //    public int LoanTerm { get; set; }
    //    public int LoanOpenPeriod { get; set; }
    //    public int YMTerm { get; set; }
    //    public decimal YMBenchmarkYield { get; set; }
    //    public DateTime PrepayDate { get; set; }
    //    public decimal PrepayMinPct { get; set; }
    //    public decimal LoanRate { get; set; }
    //    public List<PayruleDealFundingDataContract> PayruleDeletedDealFundingList { get; set; }

    //}

    public class note
    {
        public string CRENoteID { get; set; }

        public string NoteName { get; set; }
        public string NoteID { get; set; }
        public string LienPosition { get; set; }
        public string TotalCommitment { get; set; }


        public string LoanOriginationDate { get; set; }
        public string InitialMaturityDate { get; set; }
        public string FullExtendedMaturityDate { get; set; }
        public string ActualPayOffDate { get; set; }
        public List<rateSpreadSchedule> RateSpreadSchedule { get; set; }
        public List<notePeriodicOutput> NotePeriodicOutput { get; set; }
    }

    //public class NotePeriodicOutput
    //{
    //    public int Period { get; set; }
    //    public string CRENoteID { get; set; }
    //    public DateTime PeriodEndDate { get; set; }
    //    public int  Month { get; set; }
    //    public decimal AllInCouponRate { get; set; }
    //    public decimal BeginningBalance { get; set; }
    //    public decimal InterestReceivedinCurrentPeriod { get; set; }
    //    public decimal PrincipalPaid { get; set; }
    //    public decimal EndingBalance { get; set; }
    //    public decimal LoanAmount { get; set; }
    //    public int LoanDuration { get; set; } 

    //}
    public class notePeriodicOutput
    {
        public string Period { get; set; }
        public string CRENoteID { get; set; }
        public string PeriodEndDate { get; set; }
        public string Month { get; set; }
        public string AllInCouponRate { get; set; }
        public string BeginningBalance { get; set; }
        public string InterestReceivedinCurrentPeriod { get; set; }
        public string PrincipalPaid { get; set; }
        public string EndingBalance { get; set; }
        // public string TotalCommitment { get; set; }
        //  public string LoanDuration { get; set; }
    }

    public class rateSpreadSchedule
    {
        public string EffectiveStartDate { get; set; }
        public string Date { get; set; }
        public string ValueTypeID { get; set; }
        public string Value { get; set; }
        public string IntCalcMethodID { get; set; }
        public string ValueTypeText { get; set; }
        public string IntCalcMethodText { get; set; }
    }



}
