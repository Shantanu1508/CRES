using System;


namespace CRES.DataContract
{
    public class NotePeriodicOutputsDataContract
    {
        //public int? NoteID { get; set; }
        //public int NotePeriodicOutputsID { get; set; }
        public string CRENoteId { get; set; }
        public string NoteName { get; set; }
        public Guid? NoteID { get; set; }
        public Guid? NotePeriodicCalcID { get; set; }
        public DateTime? PeriodEndDate { get; set; }
        public int? Month { get; set; }
        public Decimal? ActualCashFlows { get; set; }
        public Decimal? GAAPCashFlows { get; set; }
        public Decimal? EndingGAAPBookValue { get; set; }
        public Decimal? ReversalofPriorInterestAccrual { get; set; }
        public Decimal? InterestReceivedinCurrentPeriod { get; set; }
        public Decimal? CurrentPeriodInterestAccrual { get; set; }
        public Decimal? TotalGAAPInterestFortheCurrentPeriod { get; set; }
        public Decimal? AllInCouponRate { get; set; }
        public Decimal? AllInPIKRate { get; set; }
        public Decimal? PIKInterestAccrualforthePeriod { get; set; }
        public Decimal? AmortizedCost { get; set; }
        public Decimal? DiscountPremiumAccrual { get; set; }
        public Decimal? TotalAmortAccrualForPeriod { get; set; }
        public Decimal? AccumulatedAmort { get; set; }
        public Decimal? BeginningBalance { get; set; }
        public Decimal? TotalFutureAdvancesForThePeriod { get; set; }
        public Decimal? TotalDiscretionaryCurtailmentsforthePeriod { get; set; }
        public Decimal? TotalCouponStrippedforthePeriod { get; set; }
        public Decimal? CouponStrippedonPaymentDate { get; set; }
        public Decimal? ScheduledPrincipal { get; set; }
        public Decimal? PrincipalPaid { get; set; }
        public Decimal? BalloonPayment { get; set; }
        public Decimal? EndingBalance { get; set; }
        public Decimal? FeeStrippedforthePeriod { get; set; }
        public Decimal? EndOfPeriodWAL { get; set; }
        public Decimal? PIKInterestFromPIKSourceNote { get; set; }
        public Decimal? PIKInterestTransferredToRelatedNote { get; set; }
        public Decimal? PIKInterestForThePeriod { get; set; }
        public Decimal? PIKInterestPaidForThePeriod { get; set; }
        public Decimal? PIKInterestAppliedForThePeriod { get; set; }
        public Decimal? BeginningPIKBalanceNotInsideLoanBalance { get; set; }
        public Decimal? PIKInterestForPeriodNotInsideLoanBalance { get; set; }
        public Decimal? PIKBalanceBalloonPayment { get; set; }
        public Decimal? EndingPIKBalanceNotInsideLoanBalance { get; set; }
        public Decimal? CleanCost { get; set; }
        public Decimal? GrossDeferredFees { get; set; }
        public Decimal? DeferredFeesReceivable { get; set; }
        public Decimal? AmortAccrualLevelYield { get; set; }
        public Decimal? ScheduledPrincipalShortfall { get; set; }
        public Decimal? PrincipalShortfall { get; set; }
        public Decimal? PrincipalLoss { get; set; }
        public Decimal? InterestForPeriodShortfall { get; set; }
        public Decimal? InterestPaidOnPMTDateShortfall { get; set; }
        public Decimal? CumulativeInterestPaidOnPMTDateShortfall { get; set; }
        public Decimal? InterestShortfallLoss { get; set; }
        public Decimal? InterestShortfallRecovery { get; set; }
        public Decimal? BeginningFinancingBalance { get; set; }
        public Decimal? TotalFinancingDrawsCurtailmentsForPeriod { get; set; }
        public Decimal? FinancingBalloon { get; set; }
        public Decimal? EndingFinancingBalance { get; set; }
        public Decimal? FinancingInterestPaid { get; set; }
        public Decimal? FinancingFeesPaid { get; set; }
        public Decimal? PeriodLeveredYield { get; set; }
        public Decimal? CleanCostPrice { get; set; }
        public Decimal? AmortizedCostPrice { get; set; }
        public Decimal? AdditionalFeeAccrual { get; set; }
        public Decimal? CapitalizedCostAccrual { get; set; }
        public Decimal? InvestmentBasis { get; set; }
        public Decimal? CurrentPeriodInterestAccrualPeriodEnddate { get; set; }
        public Decimal? CurrentPeriodPIKInterestAccrualPeriodEnddate { get; set; }
        public Decimal? InterestSuspenseAccountActivityforthePeriod { get; set; }
        public Decimal? InterestSuspenseAccountBalance { get; set; }
        public decimal? AllInBasisValuation { get; set; }
        //PV Basis Output
        public decimal? EndingPreCapPVBasis { get; set; }
        public decimal? LevelYieldIncomeForThePeriod { get; set; }
        public decimal? PVAmortTotalIncomeMethod { get; set; }
        public decimal? EndingPreCapGAAPBasis { get; set; }
        public decimal? EndingCleanCostLY { get; set; }
        public decimal? EndingAccumAmort { get; set; }
        public decimal? PVAmortForThePeriod { get; set; }
        //SL Basis Output
        public decimal? EndingSLBasis { get; set; }
        public decimal? SLAmortForThePeriod { get; set; }
        public decimal? SLAmortOfTotalFeesInclInLY { get; set; }
        public decimal? SLAmortOfDiscountPremium { get; set; }
        public decimal? SLAmortOfCapCost { get; set; }
        public decimal? EndingAccumSLAmort { get; set; }

        //Splitting Total Amort into Components using SL 
        public decimal? AmortOfTotalFees { get; set; }
        public decimal? AmortOfFeesInclInLY { get; set; }
        public decimal? AmortOfDiscountPremium { get; set; }
        public decimal? AmortOfCapCost { get; set; }
        public Decimal? LIBORPercentage { get; set; }
        public Decimal? SpreadPercentage { get; set; }
        public Decimal? PIKInterestPercentage { get; set; }
        public Decimal? PIKLiborPercentage { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public Decimal? OrigFeeAccrual { get; set; }
        public Decimal? ExitFeeAccrual { get; set; }
        public Decimal? InterestPaidOnPaymentDate { get; set; }
        public Guid? AnalysisID { get; set; }
        public string CalculationStatus { get; set; }
        public int BatchDetailAsyncCalcVSTOId { get; set; }
        public string SizerScenario { get; set; }
        public Decimal? PIKPrincipalPaidForThePeriod { get; set; }

    }


    public class TransactionEntryDataContract
    {
        public Guid? NoteID { get; set; }
        public DateTime? Date { get; set; }
        public Decimal? Amount { get; set; }
        public string Type { get; set; }
        public string FeeName { get; set; }
        public decimal? LIBORPercentage { get; set; }
        public decimal? PIKInterestPercentage { get; set; }
        public Decimal? PIKLiborPercentage { get; set; }
        public decimal? SpreadPercentage { get; set; }
        public DateTime? TransactionDateByRule { get; set; }
        public DateTime? DueDate { get; set; }
        public DateTime? RemitDate { get; set; }
        public string TransactionCategory { get; set; }
        public string Comment { get; set; }

    }



}
