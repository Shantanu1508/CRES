using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CRES.NoteCalculator
{
    public class CalcBasis
    {

        #region Properties

        public List<DateTime> NPVdate = new List<DateTime>();
        public List<Decimal> NPVValues = new List<Decimal>();
        public List<Decimal> NPVActual = new List<Decimal>();
        public List<Decimal> NPVClosingCost = new List<Decimal>();

        public decimal? PrecapYield = 0M;
        public decimal? AllInYield = 0M;
        public CalculationTrace trace = new CalculationTrace();
        #endregion Properties

        public void CalculateCashFlowsPVBasis(int pvindex, NoteDataContract noteDC, List<BalanceTab> ListBalanceTab, List<PIKInterestTab> ListPIKInterestTab, List<CouponTab> ListCouponTab,
            List<FeesTab> ListFeesTab, List<FeeOutputDataContract> ListFeeOutput, List<HistoricalAccrualDataContract> ListHistoricalAccrual, List<PVBasisTab> ListPVBasisTab,
            DateTime? AccrualDate, Decimal? Purchint, Decimal? stubintrest, Decimal? DeferredFeeAmtLY, Decimal? DeferredFeeAmtAllIn, string calculationMode,
            decimal? InterestPaidonPaymentDate)
        {

            Decimal? InitialFunding = noteDC.InitialFundingAmount.GetValueOrDefault(0)
            , CapCosts = noteDC.CapitalizedClosingCosts.GetValueOrDefault(0)
            //, Purchint = PurchasedStubInterest.GetValueOrDefault(0)
            , Premium = noteDC.Discount.GetValueOrDefault(0);
            //, stubintrest = StubInterestAmount.GetValueOrDefault(0)

            foreach (var pv in ListPVBasisTab.Skip(pvindex))
            {
                if (pvindex <= ListPVBasisTab.Count - 1)
                {
                    if (pvindex == 0)
                    {
                        pv.CashFlowusedforLevelYieldPreCap = -InitialFunding + ListFeesTab[pvindex].FeeAmountIncludedinLevelYield.GetValueOrDefault(0) - CapCosts + stubintrest - Purchint - Premium
                       - ListBalanceTab[pvindex].FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0) - ListBalanceTab[pvindex].DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0);

                        pv.CashFlowForAllInBasis = -InitialFunding + ListFeesTab[pvindex].FeeAmountAllIn.GetValueOrDefault(0) - CapCosts + stubintrest - Purchint - Premium
                       - ListBalanceTab[pvindex].FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0) - ListBalanceTab[pvindex].DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0);
                        pv.GrossDeferredFeesLevelYield = ListFeesTab[pvindex].FeeAmountIncludedinLevelYield.GetValueOrDefault(0);
                    }
                    else
                    {
                        pv.GrossDeferredFeesLevelYield = ListPVBasisTab[pvindex - 1].GrossDeferredFeesLevelYield.GetValueOrDefault(0) + ListFeesTab[pvindex].FeeAmountIncludedinLevelYield.GetValueOrDefault(0);
                        pv.NetPrincipalInflowOutflow = CalculateNetInflowOutflow(pvindex, noteDC.IncludeServicingPaymentOverrideinLevelYieldText, ListBalanceTab, ListPIKInterestTab);
                        pv.CashFlowusedforLevelYieldPreCap = CFForLevelYield(pvindex, true, noteDC.SelectedMaturityDate, noteDC.IncludeServicingPaymentOverrideinLevelYieldText,
                            ListBalanceTab, ListPIKInterestTab, ListCouponTab, ListFeesTab, InterestPaidonPaymentDate);
                        //pv.CashFlowForAllInBasis = CFForLevelYield(pvindex, false, noteDC.SelectedMaturityDate, noteDC.IncludeServicingPaymentOverrideinLevelYieldText,
                        //    ListBalanceTab, ListPIKInterestTab, ListCouponTab, ListFeesTab, InterestPaidonPaymentDate);
                    }


                    decimal sum = pv.CashFlowusedforLevelYieldPreCap.GetValueOrDefault(0) + pv.CashFlowForAllInBasis.GetValueOrDefault(0);
                    if (sum != 0 && Math.Abs(sum) > 0.01M)
                    {
                        NPVdate.Add(pv.Date.Value);
                        NPVValues.Add(pv.CashFlowusedforLevelYieldPreCap.GetValueOrDefault(0));
                        NPVActual.Add(pv.CashFlowForAllInBasis.GetValueOrDefault(0));
                    }

                    if (pv.Date < noteDC.SelectedMaturityDate)
                    {
                        pv.CleanCostLevelYield = ListBalanceTab[pvindex].EndingBalance.GetValueOrDefault(0) - pv.GrossDeferredFeesLevelYield + Premium + CapCosts;

                        pv.CleanCostAllIn = pv.Date < noteDC.SelectedMaturityDate ?
                        ListBalanceTab[pvindex].EndingBalance.GetValueOrDefault(0) + Premium - DeferredFeeAmtAllIn + CapCosts : 0;
                    }
                    else
                    {
                        pv.CleanCostLevelYield = ListPVBasisTab[pvindex - 1].CleanCostLevelYield;
                        pv.CleanCostAllIn = ListPVBasisTab[pvindex - 1].CleanCostAllIn;
                    }
                }
                else
                {
                    break;
                }
                pvindex = pvindex + 1;
            }
        }
        public decimal? CalculateLevelYield()
        {
            PrecapYield = cXIRR(NPVValues, NPVdate);
            //AllInYield = Convert.ToDecimal(cXIRR(CalcBasis.NPVActual, CalcBasis.NPVdate));
            return PrecapYield;
        }
        public decimal? CalculateAllInYield()
        {
            AllInYield = cXIRR(NPVActual, NPVdate);
            return AllInYield;
        }
        public void CalculateBasis(int cfindex, List<PVBasisTab> ListPVBasisTab,
            List<DatesTab> ListDatesTab, List<CouponTab> ListCouponTab, List<PIKInterestTab> ListPIKInterestTab, Decimal? PrecapYield, Decimal? AllInYield, DateTime? SelectedMaturityDate,
            decimal? InterestPaidonPaymentDate, string IncludeServicingPaymentOverrideinLevelYieldText, DateTime? stubEndDate, decimal StubInterestAmount, DateTime? InitialInterestAccrualEndDate, decimal PurchInterestAmount)
        {
            Decimal? PrecapBasis = 0, AllInBasis = 0;
            if (cfindex == 0)
            {
                ListPVBasisTab[0].PreCapLevelYield = PrecapYield;
                ListPVBasisTab[0].LockedPreCapBasis = ListPVBasisTab[0].CashFlowusedforLevelYieldPreCap.GetValueOrDefault(0) * -1;
                ListPVBasisTab[0].AllInYield = AllInYield;
                ListPVBasisTab[0].AllInBasis = ListPVBasisTab[0].CashFlowForAllInBasis.GetValueOrDefault(0) * -1;
            }
            Double dateDifference;
            int index = cfindex;
            foreach (var pv in ListPVBasisTab.Skip(cfindex))
            {
                pv.PreCapLevelYield = PrecapYield;
                pv.AllInYield = AllInYield;
                PrecapBasis = 0;
                AllInBasis = 0;
                index = index + 1;
                //List<DateTime> dates = new List<DateTime>();
                //List<Decimal> values = new List<Decimal>();
                foreach (var basis in ListPVBasisTab.Skip(index))
                {
                    decimal sum = basis.CashFlowusedforLevelYieldPreCap.GetValueOrDefault(0) + basis.CashFlowForAllInBasis.GetValueOrDefault(0);
                    if (sum != 0)
                    {
                        dateDifference = Convert.ToDouble(Convert.ToDouble(Convert.ToDateTime(basis.Date).Subtract(Convert.ToDateTime(pv.Date)).Days) / 365);
                        PrecapBasis = PrecapBasis + NumericExtensions.SafeDivision(Convert.ToDecimal(basis.CashFlowusedforLevelYieldPreCap),
                          NumericExtensions.CalcPowAndCheckNaN(Convert.ToDouble(1 + PrecapYield), dateDifference));

                        //AllInBasis = AllInBasis + NumericExtensions.SafeDivision(Convert.ToDecimal(basis.CashFlowForAllInBasis),
                        //NumericExtensions.CalcPowAndCheckNaN(Convert.ToDouble(1 + AllInYield), dateDifference));

                        //dates.Add(basis.Date.Value);
                        //values.Add(PrecapBasis.Value);
                    }
                }
                pv.LockedPreCapBasis = PrecapBasis;
                pv.AllInBasis = AllInBasis;

                //GAAPBasis - Based on Accrual Accounting Principles.
                //1. Adjustment for Payments before Accrual End Date (due to Holidays)
                decimal? CouponPayment = 0, pikPayment = 0, stubinterest = 0, purchinterest = 0;
                if (index < ListCouponTab.Count)
                {
                    int ndx1 = ListDatesTab.FindIndex(x => x.InterestAccrualPeriodStartDateArray <= pv.Date && x.InterestAccrualPeriodEndDateArray >= pv.Date);
                    if (ListDatesTab[ndx1].PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay < ListDatesTab[ndx1].PaymentDateusingAccrualFreqNotAdjustedforBusinessDay)
                    {
                        if (pv.Date >= ListDatesTab[ndx1].PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay.GetValueOrDefault() &&
                            pv.Date <= ListDatesTab[ndx1].InterestAccrualPeriodEndDateArray)
                        {
                            int ndx2 = ListCouponTab.FindIndex(cpn => cpn.Date == ListDatesTab[ndx1].PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay);
                            CouponPayment = IncludeServicingPaymentOverrideinLevelYieldText == "N" ? ListCouponTab[ndx2].InterestPaidonPaymentDate.GetValueOrDefault(0) : ListCouponTab[ndx2].InterestPaidServicingWithDropDate.GetValueOrDefault(0);
                            int ndx3 = ListPIKInterestTab.FindIndex(pik => pik.Date == ListDatesTab[ndx1].PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay);
                            pikPayment = ListPIKInterestTab[ndx3].PIKInterestonBusinessAdjInterestAccrualEndDate.GetValueOrDefault(0);

                        }
                    }
                }
                stubinterest = pv.Date > stubEndDate ? 0 : StubInterestAmount;
                purchinterest = pv.Date > InitialInterestAccrualEndDate ? 0 : PurchInterestAmount;
                pv.GAAPBasis = pv.LockedPreCapBasis + CouponPayment + pikPayment + stubinterest - purchinterest;
                if (pv.Date == SelectedMaturityDate)
                {
                    if (ListCouponTab[index - 2].InterestAccrualPeriodEndDateTag == 1)
                        pv.GAAPBasis = pv.CashFlowusedforLevelYieldPreCap - InterestPaidonPaymentDate;
                    else
                        pv.GAAPBasis = pv.CashFlowusedforLevelYieldPreCap;
                }
                //trace.BasisCF.Add(new ProspectiveCashflow(dates, values, pv.Date, Decimal.ToDouble(PrecapBasis.Value)));
            }
        }

        #region Private Methods

        public decimal? CalcDeferredFees(List<FeeOutputDataContract> ListFeeOutput, DateTime? StartDate, bool LevelYield = true)
        {
            decimal? feeamt = 0;
            if (LevelYield)
                ListFeeOutput.Where(x => x.Date.Value.Date >= StartDate.Value.Date).Sum(y => y.FeeAmountinclinLY);
            else
                ListFeeOutput.Where(x => x.Date.Value.Date >= StartDate.Value.Date).Sum(y => y.FeeAmount);

            return feeamt;
        }
        public decimal? CalculateNetInflowOutflow(int listindex, string IncludeServicingPaymentOverrideinLevelYieldText, List<BalanceTab> ListBalanceTab,
            List<PIKInterestTab> ListPIKInterestTab)
        {
            decimal? NetPrincipalInflowOutflow = 0;
            decimal? evalcommon = ListBalanceTab[listindex].BalloonPayment.GetValueOrDefault(0)
                - ListBalanceTab[listindex].FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0)
                - ListBalanceTab[listindex].DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0)
                + ListPIKInterestTab[listindex].PIKBalanceBalloonPayment.GetValueOrDefault(0)
                - ListPIKInterestTab[listindex].PIKInterestPaidAppliedForThePeriod.GetValueOrDefault(0)
                - ListPIKInterestTab[listindex].PIKInterestforthePeriodBalloon.GetValueOrDefault(0)
                + ListPIKInterestTab[listindex].PIKPrincipalPaidForThePeriod.GetValueOrDefault(0);

            if (IncludeServicingPaymentOverrideinLevelYieldText == "N")
            {
                NetPrincipalInflowOutflow = ListBalanceTab[listindex].PrincipalPaid.GetValueOrDefault(0) + evalcommon;
            }
            else
            {
                NetPrincipalInflowOutflow = ListBalanceTab[listindex].PrincipalReceivedperServicing.GetValueOrDefault(0) + evalcommon;
            }
            return NetPrincipalInflowOutflow;
        }
        public decimal? CFForLevelYield(int index, bool LevelYield, DateTime? SelectedMaturityDate,
            string IncludeServicingPaymentOverrideinLevelYieldText, List<BalanceTab> ListBalanceTab, List<PIKInterestTab> ListPIKInterestTab,
            List<CouponTab> ListCouponTab, List<FeesTab> ListFeesTab, decimal? InterestPaidonPaymentDate)
        {
            decimal? cfamount = 0;
            decimal? feeamount = LevelYield ? ListFeesTab[index].FeeAmountIncludedinLevelYield.GetValueOrDefault(0) : ListFeesTab[index].FeeAmountAllIn.GetValueOrDefault(0);
            decimal? prinamount = IncludeServicingPaymentOverrideinLevelYieldText == "N" ? ListBalanceTab[index].PrincipalPaid.GetValueOrDefault(0) : ListBalanceTab[index].PrincipalReceivedperServicing.GetValueOrDefault(0);
            decimal? intamount = 0, pikonmaturitydate = 0;

            //As per accounting to ensure smooth amortization thru PV Basis all notes will be treated as Exclude Prepay.
            if (ListBalanceTab[index].Date == SelectedMaturityDate)
            {
                intamount = InterestPaidonPaymentDate;
                pikonmaturitydate = ListPIKInterestTab[index].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0);
            }
            else
                intamount = IncludeServicingPaymentOverrideinLevelYieldText == "N" ?
                    ListCouponTab[index].InterestPaidonPaymentDate.GetValueOrDefault(0) :
                    ListCouponTab[index].InterestPaidServicingWithDropDate.GetValueOrDefault(0) + ListCouponTab[index].InterestSuspenseAccountActivityforthePeriod.GetValueOrDefault(0) * -1;

            cfamount = prinamount + ListBalanceTab[index].BalloonPayment.GetValueOrDefault(0) - ListBalanceTab[index].FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0)
                - ListBalanceTab[index].DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0) + intamount + ListCouponTab[index].InterestShortfallRecovery.GetValueOrDefault(0)
                        + ListPIKInterestTab[index].PIKInterestPaidForThePeriod.GetValueOrDefault(0)
                        + ListPIKInterestTab[index].PIKPrincipalPaidForThePeriod.GetValueOrDefault(0)
                        + ListPIKInterestTab[index].PIKBalanceBalloonPayment.GetValueOrDefault(0) + feeamount - pikonmaturitydate;

            return cfamount;
        }

        public void Initialize()
        {
            NPVdate = new List<DateTime>();
            NPVActual = new List<decimal>();
            NPVValues = new List<decimal>();
            NPVClosingCost = new List<decimal>();
        }
        private decimal cXNPV(decimal Rate, List<decimal> Values, List<DateTime> Dates)
        {
            decimal Value = 0, Sum = 0;
            int i = 0;
            foreach (var val in Values)
            {
                Value = NumericExtensions.SafeDivision(Values[i], Convert.ToDecimal(NumericExtensions.CalcPowAndCheckNaNDouble((1 + Convert.ToDouble(Rate)), ((Dates[i] - Dates[0]).TotalDays) / 365)));
                Sum = Sum + Value;
                i = i + 1;
            }
            return Sum;
        }

        private decimal cXIRR(List<Decimal> values, List<DateTime> dates, double guess = 0.1)
        {
            decimal sumpv = 0, rate = 0, raten1 = 0, raten2 = 0, raten1cxnpv = 0, raten2cxnpv = 0;
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {

                rate = Convert.ToDecimal(guess);
                raten1 = Convert.ToDecimal(guess) - 0.001M;
                sumpv = cXNPV(rate, values, dates);
                int i = 0;
                raten1cxnpv = cXNPV(raten1, values, dates);
                if (Math.Abs(sumpv) != 0)
                {
                    while (Math.Abs(sumpv - 0M) > 0.00005M)
                    {
                        raten2 = raten1;
                        raten1 = rate;
                        raten2cxnpv = raten1cxnpv;
                        raten1cxnpv = sumpv;
                        rate = raten1 - raten1cxnpv * (raten1 - raten2) / (raten1cxnpv - raten2cxnpv);
                        sumpv = cXNPV(rate, values, dates);
                        i++;
                    };
                }

            }
            catch (Exception ex)
            {
                if (rate > 0)
                {
                    rate = 1;
                }
                else if (rate < 0)
                {
                    rate = -1;
                }
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used


            return rate;
        }
        #endregion  

        #region Cumulative Amounts on Accrual Date

        public int CalcCumulativeAccruedAmounts(NoteDataContract noteDC, List<BalanceTab> ListBalanceTab, List<HistoricalAccrualDataContract> ListHistoricalAccrual, List<PVBasisTab> ListPVBasisTab,
            DateTime? AccrualDate, string calculationMode, Decimal? DeferredFeeAmtLY, Decimal? DeferredFeeAmtAllIn)
        {
            int accindex = 0;
            decimal? Value1 = 0, Value2 = 0;
            Decimal? vCumAccruedDeferredFee = 0, vCumAccruedCapitalizedCostFee, vCumAccruedDiscountFee;
            Decimal? CapCosts = noteDC.CapitalizedClosingCosts.GetValueOrDefault();
            Decimal? Premium = noteDC.Discount.GetValueOrDefault();

            if (AccrualDate != null && AccrualDate != DateTime.MinValue && calculationMode != "CF + PV Basis (Inception)")
            {
                accindex = 0;

                vCumAccruedDeferredFee = CumAccruedDeferredFee(ListHistoricalAccrual);
                vCumAccruedDiscountFee = CumAccruedDiscountFee(ListHistoricalAccrual);
                vCumAccruedCapitalizedCostFee = CumAccruedCapitalizedCostFee(ListHistoricalAccrual);
                foreach (var pv in ListPVBasisTab)
                {
                    if (pv.Date.Value.Date == AccrualDate.Value.Date)
                    {
                        break;
                    }
                    accindex = accindex + 1;
                }
                NPVdate.Add(AccrualDate.Value);
                Value1 = -ListBalanceTab[accindex].EndingBalance.GetValueOrDefault(0) + (DeferredFeeAmtLY - vCumAccruedDeferredFee) + (CapCosts - vCumAccruedCapitalizedCostFee) - (Premium + vCumAccruedDiscountFee);
                Value2 = -ListBalanceTab[accindex].EndingBalance.GetValueOrDefault(0) + (DeferredFeeAmtAllIn - vCumAccruedDeferredFee) + (CapCosts - vCumAccruedCapitalizedCostFee) - (Premium + vCumAccruedDiscountFee);
                NPVValues.Add(Convert.ToDecimal(Value1));
                NPVActual.Add(Convert.ToDecimal(Value2));
            }
            else
            {
                NPVdate.Add(noteDC.ClosingDate.Value.AddDays(-1));
                NPVValues.Add(-0.00000001m);
                NPVActual.Add(-0.00000001m);
                accindex = 0;
            }

            return accindex;
        }

        public decimal? CumAccruedDeferredFee(List<HistoricalAccrualDataContract> ListHistoricalAccrual)
        {
            decimal? feeamt = 0;
            foreach (HistoricalAccrualDataContract fees in ListHistoricalAccrual)
            {
                feeamt = feeamt + fees.DeferredFeeAccrual.GetValueOrDefault(0);
            }
            return feeamt;
        }

        public decimal? CumAccruedDiscountFee(List<HistoricalAccrualDataContract> ListHistoricalAccrual)
        {
            decimal? feeamt = 0;
            foreach (HistoricalAccrualDataContract fees in ListHistoricalAccrual)
            {
                feeamt = feeamt + fees.DiscountPremiumAccrual.GetValueOrDefault(0);
            }
            return feeamt;
        }

        public decimal? CumAccruedCapitalizedCostFee(List<HistoricalAccrualDataContract> ListHistoricalAccrual)
        {
            decimal? feeamt = 0;
            foreach (HistoricalAccrualDataContract fees in ListHistoricalAccrual)
            {
                feeamt = feeamt + fees.CapitalizedCostAccrual.GetValueOrDefault(0);
            }
            return feeamt;
        }

        #endregion

    }
}
