using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using static CRES.DataContract.V1CalcDataContract;

namespace CRES.BusinessLogic
{
    public class DownloadFileCalcOutputHelperLogic
    {

        public DataTable FormatPeriodicOutputData(DataTable dtNotePeriodicOutputsDataContract)
        {
            string[] collist = { "CRENoteId", "NoteName", "NoteID", "NotePeriodicCalcID", "CreatedBy", "CreatedDate", "UpdatedBy", "UpdatedDate", "BatchDetailAsyncCalcVSTOId", "CalculationStatus", "SizerScenario", "AnalysisID" };
            foreach (var item in collist)
            {

                if (dtNotePeriodicOutputsDataContract.Columns.IndexOf(item) != -1)
                {
                    dtNotePeriodicOutputsDataContract.Columns.Remove(item);
                }
            }
            dtNotePeriodicOutputsDataContract.Columns["PeriodEndDate"].ColumnName = "PeriodEndDate_OLD";
            dtNotePeriodicOutputsDataContract.Columns["Month"].ColumnName = "Month_OLD";
            dtNotePeriodicOutputsDataContract.Columns["ActualCashFlows"].ColumnName = "ActualCashFlows_OLD";
            dtNotePeriodicOutputsDataContract.Columns["GAAPCashFlows"].ColumnName = "GAAPCashFlows_OLD";
            dtNotePeriodicOutputsDataContract.Columns["EndingGAAPBookValue"].ColumnName = "EndingGAAPBookValue_OLD";
            dtNotePeriodicOutputsDataContract.Columns["ReversalofPriorInterestAccrual"].ColumnName = "ReversalofPriorInterestAccrual_OLD";
            dtNotePeriodicOutputsDataContract.Columns["InterestReceivedinCurrentPeriod"].ColumnName = "InterestReceivedinCurrentPeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["CurrentPeriodInterestAccrual"].ColumnName = "CurrentPeriodInterestAccrual_OLD";
            dtNotePeriodicOutputsDataContract.Columns["TotalGAAPInterestFortheCurrentPeriod"].ColumnName = "TotalGAAPInterestFortheCurrentPeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["AllInCouponRate"].ColumnName = "AllInCouponRate_OLD";
            dtNotePeriodicOutputsDataContract.Columns["AllInPIKRate"].ColumnName = "AllInPIKRate_OLD";
           // dtNotePeriodicOutputsDataContract.Columns["PIKInterestAccrualforthePeriod"].ColumnName = "PIKInterestAccrualforthePeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["AmortizedCost"].ColumnName = "AmortizedCost_OLD";
            dtNotePeriodicOutputsDataContract.Columns["DiscountPremiumAccrual"].ColumnName = "DiscountPremiumAccrual_OLD";
            dtNotePeriodicOutputsDataContract.Columns["TotalAmortAccrualForPeriod"].ColumnName = "TotalAmortAccrualForPeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["AccumulatedAmort"].ColumnName = "AccumulatedAmort_OLD";
            dtNotePeriodicOutputsDataContract.Columns["BeginningBalance"].ColumnName = "BeginningBalance_OLD";
            dtNotePeriodicOutputsDataContract.Columns["TotalFutureAdvancesForThePeriod"].ColumnName = "TotalFutureAdvancesForThePeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["TotalDiscretionaryCurtailmentsforthePeriod"].ColumnName = "TotalDiscretionaryCurtailmentsforthePeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["TotalCouponStrippedforthePeriod"].ColumnName = "TotalCouponStrippedforthePeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["CouponStrippedonPaymentDate"].ColumnName = "CouponStrippedonPaymentDate_OLD";
            dtNotePeriodicOutputsDataContract.Columns["ScheduledPrincipal"].ColumnName = "ScheduledPrincipal_OLD";
            dtNotePeriodicOutputsDataContract.Columns["PrincipalPaid"].ColumnName = "PrincipalPaid_OLD";
            dtNotePeriodicOutputsDataContract.Columns["BalloonPayment"].ColumnName = "BalloonPayment_OLD";
            dtNotePeriodicOutputsDataContract.Columns["EndingBalance"].ColumnName = "EndingBalance_OLD";
            dtNotePeriodicOutputsDataContract.Columns["FeeStrippedforthePeriod"].ColumnName = "FeeStrippedforthePeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["EndOfPeriodWAL"].ColumnName = "EndOfPeriodWAL_OLD";
            dtNotePeriodicOutputsDataContract.Columns["PIKInterestFromPIKSourceNote"].ColumnName = "PIKInterestFromPIKSourceNote_OLD";
            dtNotePeriodicOutputsDataContract.Columns["PIKInterestTransferredToRelatedNote"].ColumnName = "PIKInterestTransferredToRelatedNote_OLD";
            dtNotePeriodicOutputsDataContract.Columns["PIKInterestForThePeriod"].ColumnName = "PIKInterestForThePeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["PIKInterestPaidForThePeriod"].ColumnName = "PIKInterestPaidForThePeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["PIKInterestAppliedForThePeriod"].ColumnName = "PIKInterestAppliedForThePeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["BeginningPIKBalanceNotInsideLoanBalance"].ColumnName = "BeginningPIKBalanceNotInsideLoanBalance_OLD";
            dtNotePeriodicOutputsDataContract.Columns["PIKInterestForPeriodNotInsideLoanBalance"].ColumnName = "PIKInterestForPeriodNotInsideLoanBalance_OLD";
            dtNotePeriodicOutputsDataContract.Columns["PIKBalanceBalloonPayment"].ColumnName = "PIKBalanceBalloonPayment_OLD";
            dtNotePeriodicOutputsDataContract.Columns["EndingPIKBalanceNotInsideLoanBalance"].ColumnName = "EndingPIKBalanceNotInsideLoanBalance_OLD";
            dtNotePeriodicOutputsDataContract.Columns["CleanCost"].ColumnName = "CleanCost_OLD";
            dtNotePeriodicOutputsDataContract.Columns["GrossDeferredFees"].ColumnName = "GrossDeferredFees_OLD";
            dtNotePeriodicOutputsDataContract.Columns["DeferredFeesReceivable"].ColumnName = "DeferredFeesReceivable_OLD";
            dtNotePeriodicOutputsDataContract.Columns["AmortAccrualLevelYield"].ColumnName = "AmortAccrualLevelYield_OLD";
            dtNotePeriodicOutputsDataContract.Columns["ScheduledPrincipalShortfall"].ColumnName = "ScheduledPrincipalShortfall_OLD";
            dtNotePeriodicOutputsDataContract.Columns["PrincipalShortfall"].ColumnName = "PrincipalShortfall_OLD";
            dtNotePeriodicOutputsDataContract.Columns["PrincipalLoss"].ColumnName = "PrincipalLoss_OLD";
            dtNotePeriodicOutputsDataContract.Columns["InterestForPeriodShortfall"].ColumnName = "InterestForPeriodShortfall_OLD";
            dtNotePeriodicOutputsDataContract.Columns["InterestPaidOnPMTDateShortfall"].ColumnName = "InterestPaidOnPMTDateShortfall_OLD";
            dtNotePeriodicOutputsDataContract.Columns["CumulativeInterestPaidOnPMTDateShortfall"].ColumnName = "CumulativeInterestPaidOnPMTDateShortfall_OLD";
            dtNotePeriodicOutputsDataContract.Columns["InterestShortfallLoss"].ColumnName = "InterestShortfallLoss_OLD";
            dtNotePeriodicOutputsDataContract.Columns["InterestShortfallRecovery"].ColumnName = "InterestShortfallRecovery_OLD";
            dtNotePeriodicOutputsDataContract.Columns["BeginningFinancingBalance"].ColumnName = "BeginningFinancingBalance_OLD";
            dtNotePeriodicOutputsDataContract.Columns["TotalFinancingDrawsCurtailmentsForPeriod"].ColumnName = "TotalFinancingDrawsCurtailmentsForPeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["FinancingBalloon"].ColumnName = "FinancingBalloon_OLD";
            dtNotePeriodicOutputsDataContract.Columns["EndingFinancingBalance"].ColumnName = "EndingFinancingBalance_OLD";
            dtNotePeriodicOutputsDataContract.Columns["FinancingInterestPaid"].ColumnName = "FinancingInterestPaid_OLD";
            dtNotePeriodicOutputsDataContract.Columns["FinancingFeesPaid"].ColumnName = "FinancingFeesPaid_OLD";
            dtNotePeriodicOutputsDataContract.Columns["PeriodLeveredYield"].ColumnName = "PeriodLeveredYield_OLD";
            dtNotePeriodicOutputsDataContract.Columns["CleanCostPrice"].ColumnName = "CleanCostPrice_OLD";
            dtNotePeriodicOutputsDataContract.Columns["AmortizedCostPrice"].ColumnName = "AmortizedCostPrice_OLD";
            dtNotePeriodicOutputsDataContract.Columns["AdditionalFeeAccrual"].ColumnName = "AdditionalFeeAccrual_OLD";
            dtNotePeriodicOutputsDataContract.Columns["CapitalizedCostAccrual"].ColumnName = "CapitalizedCostAccrual_OLD";
            dtNotePeriodicOutputsDataContract.Columns["InvestmentBasis"].ColumnName = "InvestmentBasis_OLD";

            dtNotePeriodicOutputsDataContract.Columns["CurrentPeriodInterestAccrualPeriodEnddate"].ColumnName = "CurrentPeriodInterestAccrualPeriodEnddate_OLD";

            dtNotePeriodicOutputsDataContract.Columns["CurrentPeriodPIKInterestAccrualPeriodEnddate"].ColumnName = "CurrentPeriodPIKInterestAccrualPeriodEnddate_OLD";
            dtNotePeriodicOutputsDataContract.Columns["InterestSuspenseAccountActivityforthePeriod"].ColumnName = "InterestSuspenseAccountActivityforthePeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["InterestSuspenseAccountBalance"].ColumnName = "InterestSuspenseAccountBalance_OLD";
            dtNotePeriodicOutputsDataContract.Columns["AllInBasisValuation"].ColumnName = "AllInBasisValuation_OLD";
            dtNotePeriodicOutputsDataContract.Columns["EndingPreCapPVBasis"].ColumnName = "EndingPreCapPVBasis_OLD";
            dtNotePeriodicOutputsDataContract.Columns["LevelYieldIncomeForThePeriod"].ColumnName = "LevelYieldIncomeForThePeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["PVAmortTotalIncomeMethod"].ColumnName = "PVAmortTotalIncomeMethod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["EndingPreCapGAAPBasis"].ColumnName = "EndingPreCapGAAPBasis_OLD";
            dtNotePeriodicOutputsDataContract.Columns["EndingCleanCostLY"].ColumnName = "EndingCleanCostLY_OLD";
            dtNotePeriodicOutputsDataContract.Columns["EndingAccumAmort"].ColumnName = "EndingAccumAmort_OLD";
            dtNotePeriodicOutputsDataContract.Columns["PVAmortForThePeriod"].ColumnName = "PVAmortForThePeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["EndingSLBasis"].ColumnName = "EndingSLBasis_OLD";
            dtNotePeriodicOutputsDataContract.Columns["SLAmortForThePeriod"].ColumnName = "SLAmortForThePeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["SLAmortOfTotalFeesInclInLY"].ColumnName = "SLAmortOfTotalFeesInclInLY_OLD";
            dtNotePeriodicOutputsDataContract.Columns["SLAmortOfDiscountPremium"].ColumnName = "SLAmortOfDiscountPremium_OLD";
            dtNotePeriodicOutputsDataContract.Columns["SLAmortOfCapCost"].ColumnName = "SLAmortOfCapCost_OLD";
            dtNotePeriodicOutputsDataContract.Columns["EndingAccumSLAmort"].ColumnName = "EndingAccumSLAmort_OLD";
            dtNotePeriodicOutputsDataContract.Columns["AmortOfTotalFees"].ColumnName = "AmortOfTotalFees_OLD";
            dtNotePeriodicOutputsDataContract.Columns["AmortOfFeesInclInLY"].ColumnName = "AmortOfFeesInclInLY_OLD";
            dtNotePeriodicOutputsDataContract.Columns["AmortOfDiscountPremium"].ColumnName = "AmortOfDiscountPremium_OLD";
            dtNotePeriodicOutputsDataContract.Columns["AmortOfCapCost"].ColumnName = "AmortOfCapCost_OLD";
            dtNotePeriodicOutputsDataContract.Columns["LIBORPercentage"].ColumnName = "LIBORPercentage_OLD";
            dtNotePeriodicOutputsDataContract.Columns["SpreadPercentage"].ColumnName = "SpreadPercentage_OLD";
            dtNotePeriodicOutputsDataContract.Columns["PIKInterestPercentage"].ColumnName = "PIKInterestPercentage_OLD";
            dtNotePeriodicOutputsDataContract.Columns["PIKLiborPercentage"].ColumnName = "PIKLiborPercentage_OLD";
            dtNotePeriodicOutputsDataContract.Columns["OrigFeeAccrual"].ColumnName = "OrigFeeAccrual_OLD";
            dtNotePeriodicOutputsDataContract.Columns["ExitFeeAccrual"].ColumnName = "ExitFeeAccrual_OLD";
            dtNotePeriodicOutputsDataContract.Columns["InterestPaidOnPaymentDate"].ColumnName = "InterestPaidOnPaymentDate_OLD";
            dtNotePeriodicOutputsDataContract.Columns["PIKPrincipalPaidForThePeriod"].ColumnName = "PIKPrincipalPaidForThePeriod_OLD";
            dtNotePeriodicOutputsDataContract.Columns["RemainingUnfundedCommitment"].ColumnName = "RemainingUnfundedCommitment_OLD";
            dtNotePeriodicOutputsDataContract.Columns["CurrentPeriodPIKInterestAccrual"].ColumnName = "CurrentPeriodPIKInterestAccrual_OLD";




            //add new columns
            dtNotePeriodicOutputsDataContract.Columns.Add("PeriodEndDate", typeof(DateTime));
            dtNotePeriodicOutputsDataContract.Columns.Add("Month", typeof(int));
            dtNotePeriodicOutputsDataContract.Columns.Add("ActualCashFlows", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("GAAPCashFlows", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("EndingGAAPBookValue", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("ReversalofPriorInterestAccrual", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("InterestReceivedinCurrentPeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("CurrentPeriodInterestAccrual", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("TotalGAAPInterestFortheCurrentPeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("AllInCouponRate", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("AllInPIKRate", typeof(decimal));
            //dtNotePeriodicOutputsDataContract.Columns.Add("PIKInterestAccrualforthePeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("AmortizedCost", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("DiscountPremiumAccrual", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("TotalAmortAccrualForPeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("AccumulatedAmort", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("BeginningBalance", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("TotalFutureAdvancesForThePeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("TotalDiscretionaryCurtailmentsforthePeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("TotalCouponStrippedforthePeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("CouponStrippedonPaymentDate", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("ScheduledPrincipal", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("PrincipalPaid", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("BalloonPayment", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("EndingBalance", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("FeeStrippedforthePeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("EndOfPeriodWAL", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("PIKInterestFromPIKSourceNote", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("PIKInterestTransferredToRelatedNote", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("PIKInterestForThePeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("PIKInterestPaidForThePeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("PIKInterestAppliedForThePeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("BeginningPIKBalanceNotInsideLoanBalance", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("PIKInterestForPeriodNotInsideLoanBalance", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("PIKBalanceBalloonPayment", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("EndingPIKBalanceNotInsideLoanBalance", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("CleanCost", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("GrossDeferredFees", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("DeferredFeesReceivable", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("AmortAccrualLevelYield", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("ScheduledPrincipalShortfall", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("PrincipalShortfall", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("PrincipalLoss", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("InterestForPeriodShortfall", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("InterestPaidOnPMTDateShortfall", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("CumulativeInterestPaidOnPMTDateShortfall", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("InterestShortfallLoss", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("InterestShortfallRecovery", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("BeginningFinancingBalance", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("TotalFinancingDrawsCurtailmentsForPeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("FinancingBalloon", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("EndingFinancingBalance", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("FinancingInterestPaid", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("FinancingFeesPaid", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("PeriodLeveredYield", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("CleanCostPrice", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("AmortizedCostPrice", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("AdditionalFeeAccrual", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("CapitalizedCostAccrual", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("InvestmentBasis", typeof(decimal));

            dtNotePeriodicOutputsDataContract.Columns.Add("CurrentPeriodInterestAccrualPeriodEnddate", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("CurrentPeriodPIKInterestAccrualPeriodEnddate", typeof(decimal));

            dtNotePeriodicOutputsDataContract.Columns.Add("InterestSuspenseAccountActivityforthePeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("InterestSuspenseAccountBalance", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("AllInBasisValuation", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("EndingPreCapPVBasis", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("LevelYieldIncomeForThePeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("PVAmortTotalIncomeMethod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("EndingPreCapGAAPBasis", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("EndingCleanCostLY", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("EndingAccumAmort", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("PVAmortForThePeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("EndingSLBasis", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("SLAmortForThePeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("SLAmortOfTotalFeesInclInLY", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("SLAmortOfDiscountPremium", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("SLAmortOfCapCost", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("EndingAccumSLAmort", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("AmortOfTotalFees", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("AmortOfFeesInclInLY", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("AmortOfDiscountPremium", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("AmortOfCapCost", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("LIBORPercentage", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("SpreadPercentage", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("PIKInterestPercentage", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("PIKLiborPercentage", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("OrigFeeAccrual", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("ExitFeeAccrual", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("InterestPaidOnPaymentDate", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("PIKPrincipalPaidForThePeriod", typeof(decimal));
            dtNotePeriodicOutputsDataContract.Columns.Add("RemainingUnfundedCommitment", typeof(decimal));

            dtNotePeriodicOutputsDataContract.Columns.Add("CurrentPeriodPIKInterestAccrual", typeof(decimal));



            foreach (DataRow row in dtNotePeriodicOutputsDataContract.Rows)
            {
                row["PeriodEndDate"] = CommonHelper.ToDateTime(row["PeriodEndDate_OLD"]);
                row["Month"] = CommonHelper.ToInt32(row["Month_OLD"]);
                row["ActualCashFlows"] = Math.Round(CommonHelper.StringToDecimal(row["ActualCashFlows_OLD"]).GetValueOrDefault(0), 10);
                row["GAAPCashFlows"] = Math.Round(CommonHelper.StringToDecimal(row["GAAPCashFlows_OLD"]).GetValueOrDefault(0), 10);
                row["EndingGAAPBookValue"] = Math.Round(CommonHelper.StringToDecimal(row["EndingGAAPBookValue_OLD"]).GetValueOrDefault(0), 10);
                row["ReversalofPriorInterestAccrual"] = Math.Round(CommonHelper.StringToDecimal(row["ReversalofPriorInterestAccrual_OLD"]).GetValueOrDefault(0), 10);
                row["InterestReceivedinCurrentPeriod"] = Math.Round(CommonHelper.StringToDecimal(row["InterestReceivedinCurrentPeriod_OLD"]).GetValueOrDefault(0), 10);
                row["CurrentPeriodInterestAccrual"] = Math.Round(CommonHelper.StringToDecimal(row["CurrentPeriodInterestAccrual_OLD"]).GetValueOrDefault(0), 10);
                row["TotalGAAPInterestFortheCurrentPeriod"] = Math.Round(CommonHelper.StringToDecimal(row["TotalGAAPInterestFortheCurrentPeriod_OLD"]).GetValueOrDefault(0), 10);
                row["AllInCouponRate"] = Math.Round(CommonHelper.StringToDecimal(row["AllInCouponRate_OLD"]).GetValueOrDefault(0), 10);
                row["AllInPIKRate"] = Math.Round(CommonHelper.StringToDecimal(row["AllInPIKRate_OLD"]).GetValueOrDefault(0), 10);
                //row["PIKInterestAccrualforthePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestAccrualforthePeriod_OLD"]).GetValueOrDefault(0), 10);
                row["AmortizedCost"] = Math.Round(CommonHelper.StringToDecimal(row["AmortizedCost_OLD"]).GetValueOrDefault(0), 10);
                row["DiscountPremiumAccrual"] = Math.Round(CommonHelper.StringToDecimal(row["DiscountPremiumAccrual_OLD"]).GetValueOrDefault(0), 10);
                row["TotalAmortAccrualForPeriod"] = Math.Round(CommonHelper.StringToDecimal(row["TotalAmortAccrualForPeriod_OLD"]).GetValueOrDefault(0), 10);
                row["AccumulatedAmort"] = Math.Round(CommonHelper.StringToDecimal(row["AccumulatedAmort_OLD"]).GetValueOrDefault(0), 10);
                row["BeginningBalance"] = Math.Round(CommonHelper.StringToDecimal(row["BeginningBalance_OLD"]).GetValueOrDefault(0), 10);
                row["TotalFutureAdvancesForThePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["TotalFutureAdvancesForThePeriod_OLD"]).GetValueOrDefault(0), 10);
                row["TotalDiscretionaryCurtailmentsforthePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["TotalDiscretionaryCurtailmentsforthePeriod_OLD"]).GetValueOrDefault(0), 10);
                row["TotalCouponStrippedforthePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["TotalCouponStrippedforthePeriod_OLD"]).GetValueOrDefault(0), 10);
                row["CouponStrippedonPaymentDate"] = Math.Round(CommonHelper.StringToDecimal(row["CouponStrippedonPaymentDate_OLD"]).GetValueOrDefault(0), 10);
                row["ScheduledPrincipal"] = Math.Round(CommonHelper.StringToDecimal(row["ScheduledPrincipal_OLD"]).GetValueOrDefault(0), 10);
                row["PrincipalPaid"] = Math.Round(CommonHelper.StringToDecimal(row["PrincipalPaid_OLD"]).GetValueOrDefault(0), 10);
                row["BalloonPayment"] = Math.Round(CommonHelper.StringToDecimal(row["BalloonPayment_OLD"]).GetValueOrDefault(0), 10);
                row["EndingBalance"] = Math.Round(CommonHelper.StringToDecimal(row["EndingBalance_OLD"]).GetValueOrDefault(0), 10);
                row["FeeStrippedforthePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["FeeStrippedforthePeriod_OLD"]).GetValueOrDefault(0), 10);
                row["EndOfPeriodWAL"] = Math.Round(CommonHelper.StringToDecimal(row["EndOfPeriodWAL_OLD"]).GetValueOrDefault(0), 10);
                row["PIKInterestFromPIKSourceNote"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestFromPIKSourceNote_OLD"]).GetValueOrDefault(0), 10);
                row["PIKInterestTransferredToRelatedNote"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestTransferredToRelatedNote_OLD"]).GetValueOrDefault(0), 10);
                row["PIKInterestForThePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestForThePeriod_OLD"]).GetValueOrDefault(0), 10);
                row["PIKInterestPaidForThePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestPaidForThePeriod_OLD"]).GetValueOrDefault(0), 10);
                row["PIKInterestAppliedForThePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestAppliedForThePeriod_OLD"]).GetValueOrDefault(0), 10);
                row["BeginningPIKBalanceNotInsideLoanBalance"] = Math.Round(CommonHelper.StringToDecimal(row["BeginningPIKBalanceNotInsideLoanBalance_OLD"]).GetValueOrDefault(0), 10);
                row["PIKInterestForPeriodNotInsideLoanBalance"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestForPeriodNotInsideLoanBalance_OLD"]).GetValueOrDefault(0), 10);
                row["PIKBalanceBalloonPayment"] = Math.Round(CommonHelper.StringToDecimal(row["PIKBalanceBalloonPayment_OLD"]).GetValueOrDefault(0), 10);
                row["EndingPIKBalanceNotInsideLoanBalance"] = Math.Round(CommonHelper.StringToDecimal(row["EndingPIKBalanceNotInsideLoanBalance_OLD"]).GetValueOrDefault(0), 10);
                row["CleanCost"] = Math.Round(CommonHelper.StringToDecimal(row["CleanCost_OLD"]).GetValueOrDefault(0), 10);
                row["GrossDeferredFees"] = Math.Round(CommonHelper.StringToDecimal(row["GrossDeferredFees_OLD"]).GetValueOrDefault(0), 10);
                row["DeferredFeesReceivable"] = Math.Round(CommonHelper.StringToDecimal(row["DeferredFeesReceivable_OLD"]).GetValueOrDefault(0), 10);
                row["AmortAccrualLevelYield"] = Math.Round(CommonHelper.StringToDecimal(row["AmortAccrualLevelYield_OLD"]).GetValueOrDefault(0), 10);
                row["ScheduledPrincipalShortfall"] = Math.Round(CommonHelper.StringToDecimal(row["ScheduledPrincipalShortfall_OLD"]).GetValueOrDefault(0), 10);
                row["PrincipalShortfall"] = Math.Round(CommonHelper.StringToDecimal(row["PrincipalShortfall_OLD"]).GetValueOrDefault(0), 10);
                row["PrincipalLoss"] = Math.Round(CommonHelper.StringToDecimal(row["PrincipalLoss_OLD"]).GetValueOrDefault(0), 10);
                row["InterestForPeriodShortfall"] = Math.Round(CommonHelper.StringToDecimal(row["InterestForPeriodShortfall_OLD"]).GetValueOrDefault(0), 10);
                row["InterestPaidOnPMTDateShortfall"] = Math.Round(CommonHelper.StringToDecimal(row["InterestPaidOnPMTDateShortfall_OLD"]).GetValueOrDefault(0), 10);
                row["CumulativeInterestPaidOnPMTDateShortfall"] = Math.Round(CommonHelper.StringToDecimal(row["CumulativeInterestPaidOnPMTDateShortfall_OLD"]).GetValueOrDefault(0), 10);
                row["InterestShortfallLoss"] = Math.Round(CommonHelper.StringToDecimal(row["InterestShortfallLoss_OLD"]).GetValueOrDefault(0), 10);
                row["InterestShortfallRecovery"] = Math.Round(CommonHelper.StringToDecimal(row["InterestShortfallRecovery_OLD"]).GetValueOrDefault(0), 10);
                row["BeginningFinancingBalance"] = Math.Round(CommonHelper.StringToDecimal(row["BeginningFinancingBalance_OLD"]).GetValueOrDefault(0), 10);
                row["TotalFinancingDrawsCurtailmentsForPeriod"] = Math.Round(CommonHelper.StringToDecimal(row["TotalFinancingDrawsCurtailmentsForPeriod_OLD"]).GetValueOrDefault(0), 10);
                row["FinancingBalloon"] = Math.Round(CommonHelper.StringToDecimal(row["FinancingBalloon_OLD"]).GetValueOrDefault(0), 10);
                row["EndingFinancingBalance"] = Math.Round(CommonHelper.StringToDecimal(row["EndingFinancingBalance_OLD"]).GetValueOrDefault(0), 10);
                row["FinancingInterestPaid"] = Math.Round(CommonHelper.StringToDecimal(row["FinancingInterestPaid_OLD"]).GetValueOrDefault(0), 10);
                row["FinancingFeesPaid"] = Math.Round(CommonHelper.StringToDecimal(row["FinancingFeesPaid_OLD"]).GetValueOrDefault(0), 10);
                row["PeriodLeveredYield"] = Math.Round(CommonHelper.StringToDecimal(row["PeriodLeveredYield_OLD"]).GetValueOrDefault(0), 10);
                row["CleanCostPrice"] = Math.Round(CommonHelper.StringToDecimal(row["CleanCostPrice_OLD"]).GetValueOrDefault(0), 10);
                row["AmortizedCostPrice"] = Math.Round(CommonHelper.StringToDecimal(row["AmortizedCostPrice_OLD"]).GetValueOrDefault(0), 10);
                row["AdditionalFeeAccrual"] = Math.Round(CommonHelper.StringToDecimal(row["AdditionalFeeAccrual_OLD"]).GetValueOrDefault(0), 10);
                row["CapitalizedCostAccrual"] = Math.Round(CommonHelper.StringToDecimal(row["CapitalizedCostAccrual_OLD"]).GetValueOrDefault(0), 10);
                row["InvestmentBasis"] = Math.Round(CommonHelper.StringToDecimal(row["InvestmentBasis_OLD"]).GetValueOrDefault(0), 10);
                row["CurrentPeriodInterestAccrualPeriodEnddate"] = Math.Round(CommonHelper.StringToDecimal(row["CurrentPeriodInterestAccrualPeriodEnddate_OLD"]).GetValueOrDefault(0), 10);
                row["CurrentPeriodPIKInterestAccrualPeriodEnddate"] = Math.Round(CommonHelper.StringToDecimal(row["CurrentPeriodPIKInterestAccrualPeriodEnddate_OLD"]).GetValueOrDefault(0), 10);
                row["InterestSuspenseAccountActivityforthePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["InterestSuspenseAccountActivityforthePeriod_OLD"]).GetValueOrDefault(0), 10);
                row["InterestSuspenseAccountBalance"] = Math.Round(CommonHelper.StringToDecimal(row["InterestSuspenseAccountBalance_OLD"]).GetValueOrDefault(0), 10);
                row["AllInBasisValuation"] = Math.Round(CommonHelper.StringToDecimal(row["AllInBasisValuation_OLD"]).GetValueOrDefault(0), 10);
                row["EndingPreCapPVBasis"] = Math.Round(CommonHelper.StringToDecimal(row["EndingPreCapPVBasis_OLD"]).GetValueOrDefault(0), 10);
                row["LevelYieldIncomeForThePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["LevelYieldIncomeForThePeriod_OLD"]).GetValueOrDefault(0), 10);
                row["PVAmortTotalIncomeMethod"] = Math.Round(CommonHelper.StringToDecimal(row["PVAmortTotalIncomeMethod_OLD"]).GetValueOrDefault(0), 10);
                row["EndingPreCapGAAPBasis"] = Math.Round(CommonHelper.StringToDecimal(row["EndingPreCapGAAPBasis_OLD"]).GetValueOrDefault(0), 10);
                row["EndingCleanCostLY"] = Math.Round(CommonHelper.StringToDecimal(row["EndingCleanCostLY_OLD"]).GetValueOrDefault(0), 10);
                row["EndingAccumAmort"] = Math.Round(CommonHelper.StringToDecimal(row["EndingAccumAmort_OLD"]).GetValueOrDefault(0), 10);
                row["PVAmortForThePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["PVAmortForThePeriod_OLD"]).GetValueOrDefault(0), 10);
                row["EndingSLBasis"] = Math.Round(CommonHelper.StringToDecimal(row["EndingSLBasis_OLD"]).GetValueOrDefault(0), 10);
                row["SLAmortForThePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["SLAmortForThePeriod_OLD"]).GetValueOrDefault(0), 10);
                row["SLAmortOfTotalFeesInclInLY"] = Math.Round(CommonHelper.StringToDecimal(row["SLAmortOfTotalFeesInclInLY_OLD"]).GetValueOrDefault(0), 10);
                row["SLAmortOfDiscountPremium"] = Math.Round(CommonHelper.StringToDecimal(row["SLAmortOfDiscountPremium_OLD"]).GetValueOrDefault(0), 10);
                row["SLAmortOfCapCost"] = Math.Round(CommonHelper.StringToDecimal(row["SLAmortOfCapCost_OLD"]).GetValueOrDefault(0), 10);
                row["EndingAccumSLAmort"] = Math.Round(CommonHelper.StringToDecimal(row["EndingAccumSLAmort_OLD"]).GetValueOrDefault(0), 10);
                row["AmortOfTotalFees"] = Math.Round(CommonHelper.StringToDecimal(row["AmortOfTotalFees_OLD"]).GetValueOrDefault(0), 10);
                row["AmortOfFeesInclInLY"] = Math.Round(CommonHelper.StringToDecimal(row["AmortOfFeesInclInLY_OLD"]).GetValueOrDefault(0), 10);
                row["AmortOfDiscountPremium"] = Math.Round(CommonHelper.StringToDecimal(row["AmortOfDiscountPremium_OLD"]).GetValueOrDefault(0), 10);
                row["AmortOfCapCost"] = Math.Round(CommonHelper.StringToDecimal(row["AmortOfCapCost_OLD"]).GetValueOrDefault(0), 10);
                row["LIBORPercentage"] = Math.Round(CommonHelper.StringToDecimal(row["LIBORPercentage_OLD"]).GetValueOrDefault(0), 10);
                row["SpreadPercentage"] = Math.Round(CommonHelper.StringToDecimal(row["SpreadPercentage_OLD"]).GetValueOrDefault(0), 10);
                row["PIKInterestPercentage"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestPercentage_OLD"]).GetValueOrDefault(0), 10);
                row["PIKLiborPercentage"] = Math.Round(CommonHelper.StringToDecimal(row["PIKLiborPercentage_OLD"]).GetValueOrDefault(0), 10);
                row["OrigFeeAccrual"] = Math.Round(CommonHelper.StringToDecimal(row["OrigFeeAccrual_OLD"]).GetValueOrDefault(0), 10);
                row["ExitFeeAccrual"] = Math.Round(CommonHelper.StringToDecimal(row["ExitFeeAccrual_OLD"]).GetValueOrDefault(0), 10);
                row["InterestPaidOnPaymentDate"] = Math.Round(CommonHelper.StringToDecimal(row["InterestPaidOnPaymentDate_OLD"]).GetValueOrDefault(0), 10);
                row["PIKPrincipalPaidForThePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["PIKPrincipalPaidForThePeriod_OLD"]).GetValueOrDefault(0), 10);
                row["RemainingUnfundedCommitment"] = Math.Round(CommonHelper.StringToDecimal(row["RemainingUnfundedCommitment_OLD"]).GetValueOrDefault(0), 10);
                row["CurrentPeriodPIKInterestAccrual"] = Math.Round(CommonHelper.StringToDecimal(row["CurrentPeriodPIKInterestAccrual_OLD"]).GetValueOrDefault(0), 10);


            }
            dtNotePeriodicOutputsDataContract.Columns.Remove("PeriodEndDate_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("Month_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("ActualCashFlows_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("GAAPCashFlows_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("EndingGAAPBookValue_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("ReversalofPriorInterestAccrual_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("InterestReceivedinCurrentPeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("CurrentPeriodInterestAccrual_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("TotalGAAPInterestFortheCurrentPeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("AllInCouponRate_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("AllInPIKRate_OLD");
            //dtNotePeriodicOutputsDataContract.Columns.Remove("PIKInterestAccrualforthePeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("AmortizedCost_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("DiscountPremiumAccrual_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("TotalAmortAccrualForPeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("AccumulatedAmort_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("BeginningBalance_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("TotalFutureAdvancesForThePeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("TotalDiscretionaryCurtailmentsforthePeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("TotalCouponStrippedforthePeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("CouponStrippedonPaymentDate_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("ScheduledPrincipal_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("PrincipalPaid_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("BalloonPayment_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("EndingBalance_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("FeeStrippedforthePeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("EndOfPeriodWAL_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("PIKInterestFromPIKSourceNote_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("PIKInterestTransferredToRelatedNote_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("PIKInterestForThePeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("PIKInterestPaidForThePeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("PIKInterestAppliedForThePeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("BeginningPIKBalanceNotInsideLoanBalance_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("PIKInterestForPeriodNotInsideLoanBalance_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("PIKBalanceBalloonPayment_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("EndingPIKBalanceNotInsideLoanBalance_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("CleanCost_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("GrossDeferredFees_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("DeferredFeesReceivable_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("AmortAccrualLevelYield_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("ScheduledPrincipalShortfall_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("PrincipalShortfall_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("PrincipalLoss_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("InterestForPeriodShortfall_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("InterestPaidOnPMTDateShortfall_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("CumulativeInterestPaidOnPMTDateShortfall_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("InterestShortfallLoss_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("InterestShortfallRecovery_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("BeginningFinancingBalance_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("TotalFinancingDrawsCurtailmentsForPeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("FinancingBalloon_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("EndingFinancingBalance_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("FinancingInterestPaid_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("FinancingFeesPaid_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("PeriodLeveredYield_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("CleanCostPrice_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("AmortizedCostPrice_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("AdditionalFeeAccrual_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("CapitalizedCostAccrual_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("InvestmentBasis_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("CurrentPeriodInterestAccrualPeriodEnddate_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("CurrentPeriodPIKInterestAccrualPeriodEnddate_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("InterestSuspenseAccountActivityforthePeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("InterestSuspenseAccountBalance_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("AllInBasisValuation_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("EndingPreCapPVBasis_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("LevelYieldIncomeForThePeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("PVAmortTotalIncomeMethod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("EndingPreCapGAAPBasis_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("EndingCleanCostLY_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("EndingAccumAmort_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("PVAmortForThePeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("EndingSLBasis_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("SLAmortForThePeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("SLAmortOfTotalFeesInclInLY_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("SLAmortOfDiscountPremium_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("SLAmortOfCapCost_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("EndingAccumSLAmort_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("AmortOfTotalFees_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("AmortOfFeesInclInLY_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("AmortOfDiscountPremium_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("AmortOfCapCost_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("LIBORPercentage_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("SpreadPercentage_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("PIKInterestPercentage_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("PIKLiborPercentage_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("OrigFeeAccrual_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("ExitFeeAccrual_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("InterestPaidOnPaymentDate_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("PIKPrincipalPaidForThePeriod_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("RemainingUnfundedCommitment_OLD");
            dtNotePeriodicOutputsDataContract.Columns.Remove("CurrentPeriodPIKInterestAccrual_OLD");


            return dtNotePeriodicOutputsDataContract;


        }

        public DataTable FormatRatesData(DataTable dtRateTab)
        {

            dtRateTab.Columns["rateDate"].ColumnName = "rateDate_Old";
            dtRateTab.Columns["InterestAccrualPeriodEndDateTag"].ColumnName = "InterestAccrualPeriodEndDateTag_Old";
            dtRateTab.Columns["IndexValueusingFloatingRateIndexReferenceDate"].ColumnName = "IndexValueusingFloatingRateIndexReferenceDate_Old";
            dtRateTab.Columns["DIndexValueusingFloatingRateIndexReferenceDate"].ColumnName = "DIndexValueusingFloatingRateIndexReferenceDate_Old";
            dtRateTab.Columns["IndexFloor"].ColumnName = "IndexFloor_Old";
            dtRateTab.Columns["IndexCap"].ColumnName = "IndexCap_Old";
            dtRateTab.Columns["CouponSpread"].ColumnName = "CouponSpread_Old";
            dtRateTab.Columns["CouponRate"].ColumnName = "CouponRate_Old";
            dtRateTab.Columns["CouponFloor"].ColumnName = "CouponFloor_Old";
            dtRateTab.Columns["CouponCap"].ColumnName = "CouponCap_Old";
            dtRateTab.Columns["CouponDefaultRateStepUp"].ColumnName = "CouponDefaultRateStepUp_Old";
            dtRateTab.Columns["CouponDefaultRateOverride"].ColumnName = "CouponDefaultRateOverride_Old";
            dtRateTab.Columns["AllInCouponRate"].ColumnName = "AllInCouponRate_Old";
            dtRateTab.Columns["CouponStrip"].ColumnName = "CouponStrip_Old";
            dtRateTab.Columns["AmortSpread"].ColumnName = "AmortSpread_Old";
            dtRateTab.Columns["AmortRate"].ColumnName = "AmortRate_Old";
            dtRateTab.Columns["AmortRateFloor"].ColumnName = "AmortRateFloor_Old";
            dtRateTab.Columns["AmortRateCap"].ColumnName = "AmortRateCap_Old";
            dtRateTab.Columns["AmortDefaultRateStepUp"].ColumnName = "AmortDefaultRateStepUp_Old";
            dtRateTab.Columns["AmortDefaultRateOverride"].ColumnName = "AmortDefaultRateOverride_Old";
            dtRateTab.Columns["AllInAmortRate"].ColumnName = "AllInAmortRate_Old";
            dtRateTab.Columns["AdditionalPIKinterestRatefromPIKTable"].ColumnName = "AdditionalPIKinterestRatefromPIKTable_Old";
            dtRateTab.Columns["AdditionalPIKSpreadfromPIKTable"].ColumnName = "AdditionalPIKSpreadfromPIKTable_Old";
            dtRateTab.Columns["PIKIndexFloorfromPIKTable"].ColumnName = "PIKIndexFloorfromPIKTable_Old";
            dtRateTab.Columns["AllInPIKInterest"].ColumnName = "AllInPIKInterest_Old";
            dtRateTab.Columns["PIKInterestCompoundingRatefromPIKTable"].ColumnName = "PIKInterestCompoundingRatefromPIKTable_Old";
            dtRateTab.Columns["PIKInterestCompoundingSpreadfromPIKTable"].ColumnName = "PIKInterestCompoundingSpreadfromPIKTable_Old";
            dtRateTab.Columns["AllInPIKInterestCompoundingRate"].ColumnName = "AllInPIKInterestCompoundingRate_Old";
            dtRateTab.Columns["SeverityatDefault"].ColumnName = "SeverityatDefault_Old";
            dtRateTab.Columns["FinancingRate"].ColumnName = "FinancingRate_Old";
            dtRateTab.Columns["FinancingSpread"].ColumnName = "FinancingSpread_Old";
            dtRateTab.Columns["AllinFinancingCOF"].ColumnName = "AllinFinancingCOF_Old";
            dtRateTab.Columns["FinancingAdvanceRate"].ColumnName = "FinancingAdvanceRate_Old";
            dtRateTab.Columns["RateType"].ColumnName = "RateType_Old";


            //add new columns
            dtRateTab.Columns.Add("Date", typeof(DateTime));
            dtRateTab.Columns.Add("InterestAccrualPeriodEndDateTag", typeof(int));
            dtRateTab.Columns.Add("IndexValueusingFloatingRateIndexReferenceDate", typeof(decimal));
            dtRateTab.Columns.Add("DIndexValueusingFloatingRateIndexReferenceDate", typeof(decimal));
            dtRateTab.Columns.Add("IndexFloor", typeof(decimal));
            dtRateTab.Columns.Add("IndexCap", typeof(decimal));
            dtRateTab.Columns.Add("CouponSpread", typeof(decimal));
            dtRateTab.Columns.Add("CouponRate", typeof(decimal));
            dtRateTab.Columns.Add("CouponFloor", typeof(decimal));
            dtRateTab.Columns.Add("CouponCap", typeof(decimal));
            dtRateTab.Columns.Add("CouponDefaultRateStepUp", typeof(decimal));
            dtRateTab.Columns.Add("CouponDefaultRateOverride", typeof(decimal));
            dtRateTab.Columns.Add("AllInCouponRate", typeof(decimal));
            dtRateTab.Columns.Add("CouponStrip", typeof(decimal));
            dtRateTab.Columns.Add("AmortSpread", typeof(decimal));
            dtRateTab.Columns.Add("AmortRate", typeof(decimal));
            dtRateTab.Columns.Add("AmortRateFloor", typeof(decimal));
            dtRateTab.Columns.Add("AmortRateCap", typeof(decimal));
            dtRateTab.Columns.Add("AmortDefaultRateStepUp", typeof(decimal));
            dtRateTab.Columns.Add("AmortDefaultRateOverride", typeof(decimal));
            dtRateTab.Columns.Add("AllInAmortRate", typeof(decimal));
            dtRateTab.Columns.Add("AdditionalPIKinterestRatefromPIKTable", typeof(decimal));
            dtRateTab.Columns.Add("AdditionalPIKSpreadfromPIKTable", typeof(decimal));
            dtRateTab.Columns.Add("PIKIndexFloorfromPIKTable", typeof(decimal));
            dtRateTab.Columns.Add("AllInPIKInterest", typeof(decimal));
            dtRateTab.Columns.Add("PIKInterestCompoundingRatefromPIKTable", typeof(decimal));
            dtRateTab.Columns.Add("PIKInterestCompoundingSpreadfromPIKTable", typeof(decimal));
            dtRateTab.Columns.Add("AllInPIKInterestCompoundingRate", typeof(decimal));
            dtRateTab.Columns.Add("SeverityatDefault", typeof(decimal));
            dtRateTab.Columns.Add("FinancingRate", typeof(decimal));
            dtRateTab.Columns.Add("FinancingSpread", typeof(decimal));
            dtRateTab.Columns.Add("AllinFinancingCOF", typeof(decimal));
            dtRateTab.Columns.Add("FinancingAdvanceRate", typeof(decimal));
            dtRateTab.Columns.Add("RateType", typeof(string));

            foreach (DataRow row in dtRateTab.Rows)
            {
                row["Date"] = CommonHelper.ToDateTime(row["rateDate_Old"]);
                row["InterestAccrualPeriodEndDateTag"] = Math.Round(CommonHelper.StringToDecimal(row["InterestAccrualPeriodEndDateTag_Old"]).GetValueOrDefault(0), 10);
                row["IndexValueusingFloatingRateIndexReferenceDate"] = Math.Round(CommonHelper.StringToDecimal(row["IndexValueusingFloatingRateIndexReferenceDate_Old"]).GetValueOrDefault(0), 10);
                row["DIndexValueusingFloatingRateIndexReferenceDate"] = Math.Round(CommonHelper.StringToDecimal(row["DIndexValueusingFloatingRateIndexReferenceDate_Old"]).GetValueOrDefault(0), 10);
                row["IndexFloor"] = Math.Round(CommonHelper.StringToDecimal(row["IndexFloor_Old"]).GetValueOrDefault(0), 10);
                row["IndexCap"] = Math.Round(CommonHelper.StringToDecimal(row["IndexCap_Old"]).GetValueOrDefault(0), 10);
                row["CouponSpread"] = Math.Round(CommonHelper.StringToDecimal(row["CouponSpread_Old"]).GetValueOrDefault(0), 10);
                row["CouponRate"] = Math.Round(CommonHelper.StringToDecimal(row["CouponRate_Old"]).GetValueOrDefault(0), 10);
                row["CouponFloor"] = Math.Round(CommonHelper.StringToDecimal(row["CouponFloor_Old"]).GetValueOrDefault(0), 10);
                row["CouponCap"] = Math.Round(CommonHelper.StringToDecimal(row["CouponCap_Old"]).GetValueOrDefault(0), 10);
                row["CouponDefaultRateStepUp"] = Math.Round(CommonHelper.StringToDecimal(row["CouponDefaultRateStepUp_Old"]).GetValueOrDefault(0), 10);
                row["CouponDefaultRateOverride"] = Math.Round(CommonHelper.StringToDecimal(row["CouponDefaultRateOverride_Old"]).GetValueOrDefault(0), 10);
                row["AllInCouponRate"] = Math.Round(CommonHelper.StringToDecimal(row["AllInCouponRate_Old"]).GetValueOrDefault(0), 10);
                row["CouponStrip"] = Math.Round(CommonHelper.StringToDecimal(row["CouponStrip_Old"]).GetValueOrDefault(0), 10);
                row["AmortSpread"] = Math.Round(CommonHelper.StringToDecimal(row["AmortSpread_Old"]).GetValueOrDefault(0), 10);
                row["AmortRate"] = Math.Round(CommonHelper.StringToDecimal(row["AmortRate_Old"]).GetValueOrDefault(0), 10);
                row["AmortRateFloor"] = Math.Round(CommonHelper.StringToDecimal(row["AmortRateFloor_Old"]).GetValueOrDefault(0), 10);
                row["AmortRateCap"] = Math.Round(CommonHelper.StringToDecimal(row["AmortRateCap_Old"]).GetValueOrDefault(0), 10);
                row["AmortDefaultRateStepUp"] = Math.Round(CommonHelper.StringToDecimal(row["AmortDefaultRateStepUp_Old"]).GetValueOrDefault(0), 10);
                row["AmortDefaultRateOverride"] = Math.Round(CommonHelper.StringToDecimal(row["AmortDefaultRateOverride_Old"]).GetValueOrDefault(0), 10);
                row["AllInAmortRate"] = Math.Round(CommonHelper.StringToDecimal(row["AllInAmortRate_Old"]).GetValueOrDefault(0), 10);
                row["AdditionalPIKinterestRatefromPIKTable"] = Math.Round(CommonHelper.StringToDecimal(row["AdditionalPIKinterestRatefromPIKTable_Old"]).GetValueOrDefault(0), 10);
                row["AdditionalPIKSpreadfromPIKTable"] = Math.Round(CommonHelper.StringToDecimal(row["AdditionalPIKSpreadfromPIKTable_Old"]).GetValueOrDefault(0), 10);
                row["PIKIndexFloorfromPIKTable"] = Math.Round(CommonHelper.StringToDecimal(row["PIKIndexFloorfromPIKTable_Old"]).GetValueOrDefault(0), 10);
                row["AllInPIKInterest"] = Math.Round(CommonHelper.StringToDecimal(row["AllInPIKInterest_Old"]).GetValueOrDefault(0), 10);
                row["PIKInterestCompoundingRatefromPIKTable"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestCompoundingRatefromPIKTable_Old"]).GetValueOrDefault(0), 10);
                row["PIKInterestCompoundingSpreadfromPIKTable"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestCompoundingSpreadfromPIKTable_Old"]).GetValueOrDefault(0), 10);
                row["AllInPIKInterestCompoundingRate"] = Math.Round(CommonHelper.StringToDecimal(row["AllInPIKInterestCompoundingRate_Old"]).GetValueOrDefault(0), 10);
                row["SeverityatDefault"] = Math.Round(CommonHelper.StringToDecimal(row["SeverityatDefault_Old"]).GetValueOrDefault(0), 10);
                row["FinancingRate"] = Math.Round(CommonHelper.StringToDecimal(row["FinancingRate_Old"]).GetValueOrDefault(0), 10);
                row["FinancingSpread"] = Math.Round(CommonHelper.StringToDecimal(row["FinancingSpread_Old"]).GetValueOrDefault(0), 10);
                row["AllinFinancingCOF"] = Math.Round(CommonHelper.StringToDecimal(row["AllinFinancingCOF_Old"]).GetValueOrDefault(0), 10);
                row["FinancingAdvanceRate"] = Math.Round(CommonHelper.StringToDecimal(row["FinancingAdvanceRate_Old"]).GetValueOrDefault(0), 10);
                row["RateType"] = (row["RateType_Old"]).ToString();


            }
            dtRateTab.Columns.Remove("rateDate_Old");
            dtRateTab.Columns.Remove("InterestAccrualPeriodEndDateTag_Old");
            dtRateTab.Columns.Remove("IndexValueusingFloatingRateIndexReferenceDate_Old");
            dtRateTab.Columns.Remove("DIndexValueusingFloatingRateIndexReferenceDate_Old");
            dtRateTab.Columns.Remove("IndexFloor_Old");
            dtRateTab.Columns.Remove("IndexCap_Old");
            dtRateTab.Columns.Remove("CouponSpread_Old");
            dtRateTab.Columns.Remove("CouponRate_Old");
            dtRateTab.Columns.Remove("CouponFloor_Old");
            dtRateTab.Columns.Remove("CouponCap_Old");
            dtRateTab.Columns.Remove("CouponDefaultRateStepUp_Old");
            dtRateTab.Columns.Remove("CouponDefaultRateOverride_Old");
            dtRateTab.Columns.Remove("AllInCouponRate_Old");
            dtRateTab.Columns.Remove("CouponStrip_Old");
            dtRateTab.Columns.Remove("AmortSpread_Old");
            dtRateTab.Columns.Remove("AmortRate_Old");
            dtRateTab.Columns.Remove("AmortRateFloor_Old");
            dtRateTab.Columns.Remove("AmortRateCap_Old");
            dtRateTab.Columns.Remove("AmortDefaultRateStepUp_Old");
            dtRateTab.Columns.Remove("AmortDefaultRateOverride_Old");
            dtRateTab.Columns.Remove("AllInAmortRate_Old");
            dtRateTab.Columns.Remove("AdditionalPIKinterestRatefromPIKTable_Old");
            dtRateTab.Columns.Remove("AdditionalPIKSpreadfromPIKTable_Old");
            dtRateTab.Columns.Remove("PIKIndexFloorfromPIKTable_Old");
            dtRateTab.Columns.Remove("AllInPIKInterest_Old");
            dtRateTab.Columns.Remove("PIKInterestCompoundingRatefromPIKTable_Old");
            dtRateTab.Columns.Remove("PIKInterestCompoundingSpreadfromPIKTable_Old");
            dtRateTab.Columns.Remove("AllInPIKInterestCompoundingRate_Old");
            dtRateTab.Columns.Remove("SeverityatDefault_Old");
            dtRateTab.Columns.Remove("FinancingRate_Old");
            dtRateTab.Columns.Remove("FinancingSpread_Old");
            dtRateTab.Columns.Remove("AllinFinancingCOF_Old");
            dtRateTab.Columns.Remove("FinancingAdvanceRate_Old");
            dtRateTab.Columns.Remove("RateType_Old");


            return dtRateTab;


        }

        public DataTable FormatBalanceData(DataTable dtBalance)
        {
            //rename old column to new
            dtBalance.Columns["Date"].ColumnName = "Date_Old";
            dtBalance.Columns["AccrualPeriodEndDateTag"].ColumnName = "AccrualPeriodEndDateTag_Old";
            dtBalance.Columns["RemainingIOTerm"].ColumnName = "RemainingIOTerm_Old";
            dtBalance.Columns["RemainingAmortTermMo"].ColumnName = "RemainingAmortTermMo_Old";
            dtBalance.Columns["BeginningBalance"].ColumnName = "BeginningBalance_Old";
            dtBalance.Columns["FutureAdvancesFromFutureFundingSchedule"].ColumnName = "FutureAdvancesFromFutureFundingSchedule_Old";
            dtBalance.Columns["PIKInterestfromPIKSourceNote"].ColumnName = "PIKInterestfromPIKSourceNote_Old";
            dtBalance.Columns["PMTDateTag"].ColumnName = "PMTDateTag_Old";
            dtBalance.Columns["PMTDateTagWorkingdayAdjusted"].ColumnName = "PMTDateTagWorkingdayAdjusted_Old";
            dtBalance.Columns["AccrualforAmortCalc"].ColumnName = "AccrualforAmortCalc_Old";
            dtBalance.Columns["ScheduledPrincipal"].ColumnName = "ScheduledPrincipal_Old";
            dtBalance.Columns["PMTforAmortCalc"].ColumnName = "PMTforAmortCalc_Old";
            dtBalance.Columns["PrincipalPaid"].ColumnName = "PrincipalPaid_Old";
            dtBalance.Columns["PrincipalReceivedperServicing"].ColumnName = "PrincipalReceivedperServicing_Old";
            dtBalance.Columns["BalloonPayment"].ColumnName = "BalloonPayment_Old";
            dtBalance.Columns["DefaultPeriodTag"].ColumnName = "DefaultPeriodTag_Old";
            dtBalance.Columns["DebtServiceShortfall"].ColumnName = "DebtServiceShortfall_Old";
            dtBalance.Columns["ScheduledPrincipalShortfall"].ColumnName = "ScheduledPrincipalShortfall_Old";
            dtBalance.Columns["PrincipalShortfall"].ColumnName = "PrincipalShortfall_Old";
            dtBalance.Columns["PrincipalLoss"].ColumnName = "PrincipalLoss_Old";
            dtBalance.Columns["EndingBalance"].ColumnName = "EndingBalance_Old";
            dtBalance.Columns["AccumulatedFundingForThePeriod"].ColumnName = "AccumulatedFundingForThePeriod_Old";
            dtBalance.Columns["CumFutureAdvancesForAccrualPeriod"].ColumnName = "CumFutureAdvancesForAccrualPeriod_Old";
            dtBalance.Columns["DiscretionaryCurtailmentsForThePeriod"].ColumnName = "DiscretionaryCurtailmentsForThePeriod_Old";
            dtBalance.Columns["PeriodPMTDropTag"].ColumnName = "PeriodPMTDropTag_Old";
            dtBalance.Columns["PMTDropDateTag"].ColumnName = "PMTDropDateTag_Old";
            dtBalance.Columns["EndingBalanceUsingPMTDropDate"].ColumnName = "EndingBalanceUsingPMTDropDate_Old";
            dtBalance.Columns["DiscretionaryCurtailmentsForThePeriodAdjustedforPMTDropDate"].ColumnName = "DiscretionaryCurtailmentsForThePeriodAdjustedforPMTDropDate_Old";
            dtBalance.Columns["AccumulatedFundingForThePeriodAdjustedforPMTDropDate"].ColumnName = "AccumulatedFundingForThePeriodAdjustedforPMTDropDate_Old";
            dtBalance.Columns["AmortizationPaydownAmount"].ColumnName = "AmortizationPaydownAmount_Old";
            dtBalance.Columns["NonAmortizationPaydownAmount"].ColumnName = "NonAmortizationPaydownAmount_Old";
            dtBalance.Columns["AmortizationEndingBalanceAddon"].ColumnName = "AmortizationEndingBalanceAddon_Old";
            dtBalance.Columns["NonAmortizationEndingBalanceAddon"].ColumnName = "NonAmortizationEndingBalanceAddon_Old";
            dtBalance.Columns["AmortizationEndingBalanceAddonPMTDropDate"].ColumnName = "AmortizationEndingBalanceAddonPMTDropDate_Old";
            dtBalance.Columns["NonAmortizationEndingBalanceAddonPMTDropDate"].ColumnName = "NonAmortizationEndingBalanceAddonPMTDropDate_Old";
            dtBalance.Columns["RemainingUnfundedCommitment"].ColumnName = "RemainingUnfundedCommitment_Old";
            dtBalance.Columns["SoftPayOffFlag"].ColumnName = "SoftPayOffFlag_Old";



            //add new columns

            dtBalance.Columns.Add("Date", typeof(DateTime));
            dtBalance.Columns.Add("AccrualPeriodEndDateTag", typeof(decimal));
            dtBalance.Columns.Add("RemainingIOTerm", typeof(decimal));
            dtBalance.Columns.Add("RemainingAmortTermMo", typeof(decimal));
            dtBalance.Columns.Add("BeginningBalance", typeof(decimal));
            dtBalance.Columns.Add("FutureAdvancesFromFutureFundingSchedule", typeof(decimal));
            dtBalance.Columns.Add("PIKInterestfromPIKSourceNote", typeof(decimal));
            dtBalance.Columns.Add("PMTDateTag", typeof(decimal));
            dtBalance.Columns.Add("PMTDateTagWorkingdayAdjusted", typeof(decimal));
            dtBalance.Columns.Add("AccrualforAmortCalc", typeof(decimal));
            dtBalance.Columns.Add("ScheduledPrincipal", typeof(decimal));
            dtBalance.Columns.Add("PMTforAmortCalc", typeof(decimal));
            dtBalance.Columns.Add("PrincipalPaid", typeof(decimal));
            dtBalance.Columns.Add("PrincipalReceivedperServicing", typeof(decimal));
            dtBalance.Columns.Add("BalloonPayment", typeof(decimal));
            dtBalance.Columns.Add("DefaultPeriodTag", typeof(decimal));
            dtBalance.Columns.Add("DebtServiceShortfall", typeof(decimal));
            dtBalance.Columns.Add("ScheduledPrincipalShortfall", typeof(decimal));
            dtBalance.Columns.Add("PrincipalShortfall", typeof(decimal));
            dtBalance.Columns.Add("PrincipalLoss", typeof(decimal));
            dtBalance.Columns.Add("EndingBalance", typeof(decimal));
            dtBalance.Columns.Add("AccumulatedFundingForThePeriod", typeof(decimal));
            dtBalance.Columns.Add("CumFutureAdvancesForAccrualPeriod", typeof(decimal));
            dtBalance.Columns.Add("DiscretionaryCurtailmentsForThePeriod", typeof(decimal));
            dtBalance.Columns.Add("PeriodPMTDropTag", typeof(decimal));
            dtBalance.Columns.Add("PMTDropDateTag", typeof(decimal));
            dtBalance.Columns.Add("EndingBalanceUsingPMTDropDate", typeof(decimal));
            dtBalance.Columns.Add("DiscretionaryCurtailmentsForThePeriodAdjustedforPMTDropDate", typeof(decimal));
            dtBalance.Columns.Add("AccumulatedFundingForThePeriodAdjustedforPMTDropDate", typeof(decimal));
            dtBalance.Columns.Add("AmortizationPaydownAmount", typeof(decimal));
            dtBalance.Columns.Add("NonAmortizationPaydownAmount", typeof(decimal));
            dtBalance.Columns.Add("AmortizationEndingBalanceAddon", typeof(decimal));
            dtBalance.Columns.Add("NonAmortizationEndingBalanceAddon", typeof(decimal));
            dtBalance.Columns.Add("AmortizationEndingBalanceAddonPMTDropDate", typeof(decimal));
            dtBalance.Columns.Add("NonAmortizationEndingBalanceAddonPMTDropDate", typeof(decimal));
            dtBalance.Columns.Add("RemainingUnfundedCommitment", typeof(decimal));
            dtBalance.Columns.Add("SoftPayOffFlag", typeof(decimal));




            foreach (DataRow row in dtBalance.Rows)
            {
                row["Date"] = CommonHelper.ToDateTime(row["Date_Old"]);
                row["AccrualPeriodEndDateTag"] = Math.Round(CommonHelper.StringToDecimal(row["AccrualPeriodEndDateTag_Old"]).GetValueOrDefault(0), 10);
                row["RemainingIOTerm"] = Math.Round(CommonHelper.StringToDecimal(row["RemainingIOTerm_Old"]).GetValueOrDefault(0), 10);
                row["RemainingAmortTermMo"] = Math.Round(CommonHelper.StringToDecimal(row["RemainingAmortTermMo_Old"]).GetValueOrDefault(0), 10);
                row["BeginningBalance"] = Math.Round(CommonHelper.StringToDecimal(row["BeginningBalance_Old"]).GetValueOrDefault(0), 10);
                row["FutureAdvancesFromFutureFundingSchedule"] = Math.Round(CommonHelper.StringToDecimal(row["FutureAdvancesFromFutureFundingSchedule_Old"]).GetValueOrDefault(0), 10);
                row["PIKInterestfromPIKSourceNote"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestfromPIKSourceNote_Old"]).GetValueOrDefault(0), 10);
                row["PMTDateTag"] = Math.Round(CommonHelper.StringToDecimal(row["PMTDateTag_Old"]).GetValueOrDefault(0), 10);
                row["PMTDateTagWorkingdayAdjusted"] = Math.Round(CommonHelper.StringToDecimal(row["PMTDateTagWorkingdayAdjusted_Old"]).GetValueOrDefault(0), 10);
                row["AccrualforAmortCalc"] = Math.Round(CommonHelper.StringToDecimal(row["AccrualforAmortCalc_Old"]).GetValueOrDefault(0), 10);
                row["ScheduledPrincipal"] = Math.Round(CommonHelper.StringToDecimal(row["ScheduledPrincipal_Old"]).GetValueOrDefault(0), 10);
                row["PMTforAmortCalc"] = Math.Round(CommonHelper.StringToDecimal(row["PMTforAmortCalc_Old"]).GetValueOrDefault(0), 10);
                row["PrincipalPaid"] = Math.Round(CommonHelper.StringToDecimal(row["PrincipalPaid_Old"]).GetValueOrDefault(0), 10);
                row["PrincipalReceivedperServicing"] = Math.Round(CommonHelper.StringToDecimal(row["PrincipalReceivedperServicing_Old"]).GetValueOrDefault(0), 10);
                row["BalloonPayment"] = Math.Round(CommonHelper.StringToDecimal(row["BalloonPayment_Old"]).GetValueOrDefault(0), 10);
                row["DefaultPeriodTag"] = Math.Round(CommonHelper.StringToDecimal(row["DefaultPeriodTag_Old"]).GetValueOrDefault(0), 10);
                row["DebtServiceShortfall"] = Math.Round(CommonHelper.StringToDecimal(row["DebtServiceShortfall_Old"]).GetValueOrDefault(0), 10);
                row["ScheduledPrincipalShortfall"] = Math.Round(CommonHelper.StringToDecimal(row["ScheduledPrincipalShortfall_Old"]).GetValueOrDefault(0), 10);
                row["PrincipalShortfall"] = Math.Round(CommonHelper.StringToDecimal(row["PrincipalShortfall_Old"]).GetValueOrDefault(0), 10);
                row["PrincipalLoss"] = Math.Round(CommonHelper.StringToDecimal(row["PrincipalLoss_Old"]).GetValueOrDefault(0), 10);
                row["EndingBalance"] = Math.Round(CommonHelper.StringToDecimal(row["EndingBalance_Old"]).GetValueOrDefault(0), 10);
                row["AccumulatedFundingForThePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["AccumulatedFundingForThePeriod_Old"]).GetValueOrDefault(0), 10);
                row["CumFutureAdvancesForAccrualPeriod"] = Math.Round(CommonHelper.StringToDecimal(row["CumFutureAdvancesForAccrualPeriod_Old"]).GetValueOrDefault(0), 10);
                row["DiscretionaryCurtailmentsForThePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["DiscretionaryCurtailmentsForThePeriod_Old"]).GetValueOrDefault(0), 10);
                row["PeriodPMTDropTag"] = Math.Round(CommonHelper.StringToDecimal(row["PeriodPMTDropTag_Old"]).GetValueOrDefault(0), 10);
                row["PMTDropDateTag"] = Math.Round(CommonHelper.StringToDecimal(row["PMTDropDateTag_Old"]).GetValueOrDefault(0), 10);
                row["EndingBalanceUsingPMTDropDate"] = Math.Round(CommonHelper.StringToDecimal(row["EndingBalanceUsingPMTDropDate_Old"]).GetValueOrDefault(0), 10);
                row["DiscretionaryCurtailmentsForThePeriodAdjustedforPMTDropDate"] = Math.Round(CommonHelper.StringToDecimal(row["DiscretionaryCurtailmentsForThePeriodAdjustedforPMTDropDate_Old"]).GetValueOrDefault(0), 10);
                row["AccumulatedFundingForThePeriodAdjustedforPMTDropDate"] = Math.Round(CommonHelper.StringToDecimal(row["AccumulatedFundingForThePeriodAdjustedforPMTDropDate_Old"]).GetValueOrDefault(0), 10);
                row["AmortizationPaydownAmount"] = Math.Round(CommonHelper.StringToDecimal(row["AmortizationPaydownAmount_Old"]).GetValueOrDefault(0), 10);
                row["NonAmortizationPaydownAmount"] = Math.Round(CommonHelper.StringToDecimal(row["NonAmortizationPaydownAmount_Old"]).GetValueOrDefault(0), 10);
                row["AmortizationEndingBalanceAddon"] = Math.Round(CommonHelper.StringToDecimal(row["AmortizationEndingBalanceAddon_Old"]).GetValueOrDefault(0), 10);
                row["NonAmortizationEndingBalanceAddon"] = Math.Round(CommonHelper.StringToDecimal(row["NonAmortizationEndingBalanceAddon_Old"]).GetValueOrDefault(0), 10);
                row["AmortizationEndingBalanceAddonPMTDropDate"] = Math.Round(CommonHelper.StringToDecimal(row["AmortizationEndingBalanceAddonPMTDropDate_Old"]).GetValueOrDefault(0), 10);
                row["NonAmortizationEndingBalanceAddonPMTDropDate"] = Math.Round(CommonHelper.StringToDecimal(row["NonAmortizationEndingBalanceAddonPMTDropDate_Old"]).GetValueOrDefault(0), 10);
                row["RemainingUnfundedCommitment"] = Math.Round(CommonHelper.StringToDecimal(row["RemainingUnfundedCommitment_Old"]).GetValueOrDefault(0), 10);
                row["SoftPayOffFlag"] = Math.Round(CommonHelper.StringToDecimal(row["SoftPayOffFlag_Old"]).GetValueOrDefault(0), 10);




            }
            dtBalance.Columns.Remove("Date_Old");
            dtBalance.Columns.Remove("AccrualPeriodEndDateTag_Old");
            dtBalance.Columns.Remove("RemainingIOTerm_Old");
            dtBalance.Columns.Remove("RemainingAmortTermMo_Old");
            dtBalance.Columns.Remove("BeginningBalance_Old");
            dtBalance.Columns.Remove("FutureAdvancesFromFutureFundingSchedule_Old");
            dtBalance.Columns.Remove("PIKInterestfromPIKSourceNote_Old");
            dtBalance.Columns.Remove("PMTDateTag_Old");
            dtBalance.Columns.Remove("PMTDateTagWorkingdayAdjusted_Old");
            dtBalance.Columns.Remove("AccrualforAmortCalc_Old");
            dtBalance.Columns.Remove("ScheduledPrincipal_Old");
            dtBalance.Columns.Remove("PMTforAmortCalc_Old");
            dtBalance.Columns.Remove("PrincipalPaid_Old");
            dtBalance.Columns.Remove("PrincipalReceivedperServicing_Old");
            dtBalance.Columns.Remove("BalloonPayment_Old");
            dtBalance.Columns.Remove("DefaultPeriodTag_Old");
            dtBalance.Columns.Remove("DebtServiceShortfall_Old");
            dtBalance.Columns.Remove("ScheduledPrincipalShortfall_Old");
            dtBalance.Columns.Remove("PrincipalShortfall_Old");
            dtBalance.Columns.Remove("PrincipalLoss_Old");
            dtBalance.Columns.Remove("EndingBalance_Old");
            dtBalance.Columns.Remove("AccumulatedFundingForThePeriod_Old");
            dtBalance.Columns.Remove("CumFutureAdvancesForAccrualPeriod_Old");
            dtBalance.Columns.Remove("DiscretionaryCurtailmentsForThePeriod_Old");
            dtBalance.Columns.Remove("PeriodPMTDropTag_Old");
            dtBalance.Columns.Remove("PMTDropDateTag_Old");
            dtBalance.Columns.Remove("EndingBalanceUsingPMTDropDate_Old");
            dtBalance.Columns.Remove("DiscretionaryCurtailmentsForThePeriodAdjustedforPMTDropDate_Old");
            dtBalance.Columns.Remove("AccumulatedFundingForThePeriodAdjustedforPMTDropDate_Old");
            dtBalance.Columns.Remove("AmortizationPaydownAmount_Old");
            dtBalance.Columns.Remove("NonAmortizationPaydownAmount_Old");
            dtBalance.Columns.Remove("AmortizationEndingBalanceAddon_Old");
            dtBalance.Columns.Remove("NonAmortizationEndingBalanceAddon_Old");
            dtBalance.Columns.Remove("AmortizationEndingBalanceAddonPMTDropDate_Old");
            dtBalance.Columns.Remove("NonAmortizationEndingBalanceAddonPMTDropDate_Old");
            dtBalance.Columns.Remove("RemainingUnfundedCommitment_Old");
            dtBalance.Columns.Remove("SoftPayOffFlag_Old");


            return dtBalance;

        }

        public DataTable FormatDatesData(DataTable dtDatesTab)
        {

            dtDatesTab.Columns["InterestAccrualPeriodEndDateArray"].ColumnName = "InterestAccrualPeriodEndDateArray_Old";
            dtDatesTab.Columns["InterestAccrualPeriodStartDateArray"].ColumnName = "InterestAccrualPeriodStartDateArray_Old";
            dtDatesTab.Columns["NumberofDaysintheAccrualPeriod"].ColumnName = "NumberofDaysintheAccrualPeriod_Old";
            dtDatesTab.Columns["FloatingRateIndexReferenceDateNotAdjustedforResetFreq"].ColumnName = "FloatingRateIndexReferenceDateNotAdjustedforResetFreq_Old";
            dtDatesTab.Columns["RateIndexResetTag"].ColumnName = "RateIndexResetTag_Old";
            dtDatesTab.Columns["FloatingRateIndexReferenceDateAdjustedforResetFrequency"].ColumnName = "FloatingRateIndexReferenceDateAdjustedforResetFrequency_Old";
            dtDatesTab.Columns["PaymentDateusingAccrualFreqNotAdjustedforBusinessDay"].ColumnName = "PaymentDateusingAccrualFreqNotAdjustedforBusinessDay_Old";
            dtDatesTab.Columns["PaymentDateRelativetoAccrualEndDateTag"].ColumnName = "PaymentDateRelativetoAccrualEndDateTag_Old";
            dtDatesTab.Columns["PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay"].ColumnName = "PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay_Old";
            dtDatesTab.Columns["PayAccFreqTag"].ColumnName = "PayAccFreqTag_Old";
            dtDatesTab.Columns["RemIoTerm"].ColumnName = "RemIoTerm_Old";

            //add new columns
            dtDatesTab.Columns.Add("InterestAccrualPeriodEndDateArray", typeof(DateTime));
            dtDatesTab.Columns.Add("InterestAccrualPeriodStartDateArray", typeof(DateTime));
            dtDatesTab.Columns.Add("NumberofDaysintheAccrualPeriod", typeof(int));
            dtDatesTab.Columns.Add("FloatingRateIndexReferenceDateNotAdjustedforResetFreq", typeof(DateTime));
            dtDatesTab.Columns.Add("RateIndexResetTag", typeof(int));
            dtDatesTab.Columns.Add("FloatingRateIndexReferenceDateAdjustedforResetFrequency", typeof(DateTime));
            dtDatesTab.Columns.Add("PaymentDateusingAccrualFreqNotAdjustedforBusinessDay", typeof(DateTime));
            dtDatesTab.Columns.Add("PaymentDateRelativetoAccrualEndDateTag", typeof(int));
            dtDatesTab.Columns.Add("PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay", typeof(DateTime));
            dtDatesTab.Columns.Add("PayAccFreqTag", typeof(int));
            dtDatesTab.Columns.Add("RemIoTerm", typeof(int));



            foreach (DataRow row in dtDatesTab.Rows)
            {
                row["InterestAccrualPeriodEndDateArray"] = CommonHelper.ToDateTime(row["InterestAccrualPeriodEndDateArray_Old"]);
                row["InterestAccrualPeriodStartDateArray"] = CommonHelper.ToDateTime(row["InterestAccrualPeriodStartDateArray_Old"]);
                row["NumberofDaysintheAccrualPeriod"] = CommonHelper.ToInt32(row["NumberofDaysintheAccrualPeriod_Old"]);
                row["FloatingRateIndexReferenceDateNotAdjustedforResetFreq"] = CommonHelper.ToDateTime(row["FloatingRateIndexReferenceDateNotAdjustedforResetFreq_Old"]);
                row["RateIndexResetTag"] = CommonHelper.ToInt32(row["RateIndexResetTag_Old"]);
                row["FloatingRateIndexReferenceDateAdjustedforResetFrequency"] = CommonHelper.ToDateTime(row["FloatingRateIndexReferenceDateAdjustedforResetFrequency_Old"]);
                row["PaymentDateusingAccrualFreqNotAdjustedforBusinessDay"] = CommonHelper.ToDateTime(row["PaymentDateusingAccrualFreqNotAdjustedforBusinessDay_Old"]);
                row["PaymentDateRelativetoAccrualEndDateTag"] = CommonHelper.ToInt32(row["PaymentDateRelativetoAccrualEndDateTag_Old"]);
                row["PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay"] = CommonHelper.ToDateTime(row["PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay_Old"]);
                row["PayAccFreqTag"] = CommonHelper.ToInt32(row["PayAccFreqTag_Old"]);
                row["RemIoTerm"] = CommonHelper.ToInt32(row["RemIoTerm_Old"]);

            }
            dtDatesTab.Columns.Remove("InterestAccrualPeriodEndDateArray_Old");
            dtDatesTab.Columns.Remove("InterestAccrualPeriodStartDateArray_Old");
            dtDatesTab.Columns.Remove("NumberofDaysintheAccrualPeriod_Old");
            dtDatesTab.Columns.Remove("FloatingRateIndexReferenceDateNotAdjustedforResetFreq_Old");
            dtDatesTab.Columns.Remove("RateIndexResetTag_Old");
            dtDatesTab.Columns.Remove("FloatingRateIndexReferenceDateAdjustedforResetFrequency_Old");
            dtDatesTab.Columns.Remove("PaymentDateusingAccrualFreqNotAdjustedforBusinessDay_Old");
            dtDatesTab.Columns.Remove("PaymentDateRelativetoAccrualEndDateTag_Old");
            dtDatesTab.Columns.Remove("PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay_Old");
            dtDatesTab.Columns.Remove("PayAccFreqTag_Old");
            dtDatesTab.Columns.Remove("RemIoTerm_Old");

            return dtDatesTab;


        }

        //public DataTable FormatDatesData(DataTable dtDatesTab)
        //{

        //    dtDatesTab.Columns["InterestAccrualPeriodEndDateArray"].ColumnName = "InterestAccrualPeriodEndDateArray_Old";


        //    //add new columns
        //    dtDatesTab.Columns.Add("InterestAccrualPeriodEndDateArray", typeof(DateTime));




        //    foreach (DataRow row in dtDatesTab.Rows)
        //    {
        //        row["InterestAccrualPeriodEndDateArray"] = CommonHelper.ToDateTime(row["InterestAccrualPeriodEndDateArray_Old"]);


        //    }
        //    dtDatesTab.Columns.Remove("InterestAccrualPeriodEndDateArray_Old");


        //    return dtDatesTab;


        //}

        public DataTable FormatFeesData(DataTable dtFeesTab)
        {

            dtFeesTab.Columns["Date"].ColumnName = "Date_Old";
            dtFeesTab.Columns["FeeAmountIncludedinLevelYield"].ColumnName = "FeeAmountIncludedinLevelYield_Old";
            dtFeesTab.Columns["NewAdditionalFees"].ColumnName = "NewAdditionalFees_Old";
            dtFeesTab.Columns["PrepaymentExitFees"].ColumnName = "PrepaymentExitFees_Old";
            dtFeesTab.Columns["StrippedFeesCouponReceivedfromSourceNote"].ColumnName = "StrippedFeesCouponReceivedfromSourceNote_Old";
            dtFeesTab.Columns["DailyFeeAmount"].ColumnName = "DailyFeeAmount_Old";
            dtFeesTab.Columns["FeeAmountAllIn"].ColumnName = "FeeAmountAllIn_Old";
            dtFeesTab.Columns["StrippedFeeReceivableInclInLY"].ColumnName = "StrippedFeeReceivableInclInLY_Old";
            dtFeesTab.Columns["StrippedFeeReceivableExclFromLY"].ColumnName = "StrippedFeeReceivableExclFromLY_Old";


            //add new columns
            dtFeesTab.Columns.Add("Date", typeof(DateTime));
            dtFeesTab.Columns.Add("FeeAmountIncludedinLevelYield", typeof(decimal));
            dtFeesTab.Columns.Add("NewAdditionalFees", typeof(decimal));
            dtFeesTab.Columns.Add("PrepaymentExitFees", typeof(decimal));
            dtFeesTab.Columns.Add("StrippedFeesCouponReceivedfromSourceNote", typeof(decimal));

            dtFeesTab.Columns.Add("DailyFeeAmount", typeof(decimal));
            dtFeesTab.Columns.Add("FeeAmountAllIn", typeof(decimal));
            dtFeesTab.Columns.Add("StrippedFeeReceivableInclInLY", typeof(decimal));
            dtFeesTab.Columns.Add("StrippedFeeReceivableExclFromLY", typeof(decimal));


            foreach (DataRow row in dtFeesTab.Rows)
            {
                row["Date"] = CommonHelper.ToDateTime(row["Date_Old"]);
                row["FeeAmountIncludedinLevelYield"] = Math.Round(CommonHelper.StringToDecimal(row["FeeAmountIncludedinLevelYield_Old"]).GetValueOrDefault(0), 10);
                row["NewAdditionalFees"] = Math.Round(CommonHelper.StringToDecimal(row["NewAdditionalFees_Old"]).GetValueOrDefault(0), 10);
                row["PrepaymentExitFees"] = Math.Round(CommonHelper.StringToDecimal(row["PrepaymentExitFees_Old"]).GetValueOrDefault(0), 10);
                row["StrippedFeesCouponReceivedfromSourceNote"] = Math.Round(CommonHelper.StringToDecimal(row["StrippedFeesCouponReceivedfromSourceNote_Old"]).GetValueOrDefault(0), 10);

                row["DailyFeeAmount"] = Math.Round(CommonHelper.StringToDecimal(row["DailyFeeAmount_Old"]).GetValueOrDefault(0), 10);
                row["FeeAmountAllIn"] = Math.Round(CommonHelper.StringToDecimal(row["FeeAmountAllIn_Old"]).GetValueOrDefault(0), 10);
                row["StrippedFeeReceivableInclInLY"] = Math.Round(CommonHelper.StringToDecimal(row["StrippedFeeReceivableInclInLY_Old"]).GetValueOrDefault(0), 10);
                row["StrippedFeeReceivableExclFromLY"] = Math.Round(CommonHelper.StringToDecimal(row["StrippedFeeReceivableExclFromLY_Old"]).GetValueOrDefault(0), 10);

            }
            dtFeesTab.Columns.Remove("Date_Old");
            dtFeesTab.Columns.Remove("FeeAmountIncludedinLevelYield_Old");
            dtFeesTab.Columns.Remove("NewAdditionalFees_Old");
            dtFeesTab.Columns.Remove("PrepaymentExitFees_Old");
            dtFeesTab.Columns.Remove("StrippedFeesCouponReceivedfromSourceNote_Old");

            dtFeesTab.Columns.Remove("DailyFeeAmount_Old");
            dtFeesTab.Columns.Remove("FeeAmountAllIn_Old");
            dtFeesTab.Columns.Remove("StrippedFeeReceivableInclInLY_Old");
            dtFeesTab.Columns.Remove("StrippedFeeReceivableExclFromLY_Old");


            return dtFeesTab;


        }

        public DataTable FormatFeeOutputData(DataTable dtFeeOutput)
        {

            dtFeeOutput.Columns["Date"].ColumnName = "Date_Old";
            dtFeeOutput.Columns["FeeAmount"].ColumnName = "FeeAmount_Old";
            dtFeeOutput.Columns["FeeAmountStripped"].ColumnName = "FeeAmountStripped_Old";
            dtFeeOutput.Columns["FeeAmountinclinLY"].ColumnName = "FeeAmountinclinLY_Old";
            dtFeeOutput.Columns["FeeType"].ColumnName = "FeeType_Old";
            dtFeeOutput.Columns["FeeName"].ColumnName = "FeeName_Old";
            dtFeeOutput.Columns["FeeNameTransText"].ColumnName = "FeeNameTransText_Old";

            dtFeeOutput.Columns["EffectiveDate"].ColumnName = "EffectiveDate_Old";
            dtFeeOutput.Columns["FeeCouponReceivable"].ColumnName = "FeeCouponReceivable_Old";


            //add new columns
            dtFeeOutput.Columns.Add("Date", typeof(DateTime));
            dtFeeOutput.Columns.Add("FeeAmount", typeof(decimal));
            dtFeeOutput.Columns.Add("FeeAmountStripped", typeof(decimal));
            dtFeeOutput.Columns.Add("FeeAmountinclinLY", typeof(decimal));
            dtFeeOutput.Columns.Add("FeeType", typeof(string));
            dtFeeOutput.Columns.Add("FeeName", typeof(string));
            dtFeeOutput.Columns.Add("FeeNameTransText", typeof(string));

            dtFeeOutput.Columns.Add("EffectiveDate", typeof(DateTime));
            dtFeeOutput.Columns.Add("FeeCouponReceivable", typeof(decimal));

            foreach (DataRow row in dtFeeOutput.Rows)
            {
                row["Date"] = CommonHelper.ToDateTime(row["Date_Old"]);

                row["FeeAmount"] = Math.Round(CommonHelper.StringToDecimal(row["FeeAmount_Old"]).GetValueOrDefault(0), 10);
                row["FeeAmountStripped"] = Math.Round(CommonHelper.StringToDecimal(row["FeeAmountStripped_Old"]).GetValueOrDefault(0), 10);
                row["FeeAmountinclinLY"] = Math.Round(CommonHelper.StringToDecimal(row["FeeAmountinclinLY_Old"]).GetValueOrDefault(0), 10);

                row["FeeType"] = row["FeeType_Old"].ToString();
                row["FeeName"] = row["FeeName_Old"].ToString();
                row["FeeNameTransText"] = row["FeeNameTransText_Old"].ToString();

                row["EffectiveDate"] = CommonHelper.ToDateTime(row["EffectiveDate_Old"]);
                row["FeeCouponReceivable"] = Math.Round(CommonHelper.StringToDecimal(row["FeeCouponReceivable_Old"]).GetValueOrDefault(0), 10);

            }

            dtFeeOutput.Columns.Remove("Date_Old");
            dtFeeOutput.Columns.Remove("FeeAmount_Old");
            dtFeeOutput.Columns.Remove("FeeAmountStripped_Old");
            dtFeeOutput.Columns.Remove("FeeAmountinclinLY_Old");
            dtFeeOutput.Columns.Remove("FeeType_Old");
            dtFeeOutput.Columns.Remove("FeeName_Old");
            dtFeeOutput.Columns.Remove("FeeNameTransText_Old");

            dtFeeOutput.Columns.Remove("EffectiveDate_Old");
            dtFeeOutput.Columns.Remove("FeeCouponReceivable_Old");

            return dtFeeOutput;


        }

        public DataTable FormatCouponData(DataTable dtCouponTab)
        {

            dtCouponTab.Columns["Date"].ColumnName = "Date_Old";
            dtCouponTab.Columns["InterestCalcMethod"].ColumnName = "InterestCalcMethod_Old";
            dtCouponTab.Columns["NumberofDaysinReferencedAccrualPeriod"].ColumnName = "NumberofDaysinReferencedAccrualPeriod_Old";
            dtCouponTab.Columns["InterestCalcMethodAdjustment30_360vsActual_360"].ColumnName = "InterestCalcMethodAdjustment30_360vsActual_360_Old";
            dtCouponTab.Columns["InterestAccrualPeriodEndDateTag"].ColumnName = "InterestAccrualPeriodEndDateTag_Old";
            dtCouponTab.Columns["DailyAccruedInterestbeforeStrippingRule"].ColumnName = "DailyAccruedInterestbeforeStrippingRule_Old";
            dtCouponTab.Columns["DailyAccruedCouponStripping"].ColumnName = "DailyAccruedCouponStripping_Old";
            dtCouponTab.Columns["DailyAccruedInterest"].ColumnName = "DailyAccruedInterest_Old";
            dtCouponTab.Columns["AccumInterestforCurrentAccrualPeriod"].ColumnName = "AccumInterestforCurrentAccrualPeriod_Old";
            dtCouponTab.Columns["AccumCouponStrippingforCurrentAccrualPeriod"].ColumnName = "AccumCouponStrippingforCurrentAccrualPeriod_Old";
            dtCouponTab.Columns["InterestforthePeriodShortfall"].ColumnName = "InterestforthePeriodShortfall_Old";
            dtCouponTab.Columns["InterestPaidonPMTDateShortfall"].ColumnName = "InterestPaidonPMTDateShortfall_Old";
            dtCouponTab.Columns["CumulativeInterestPaidonPMTDateShortfall"].ColumnName = "CumulativeInterestPaidonPMTDateShortfall_Old";
            dtCouponTab.Columns["InterestShortfallLoss"].ColumnName = "InterestShortfallLoss_Old";
            dtCouponTab.Columns["InterestShortfallRecovery"].ColumnName = "InterestShortfallRecovery_Old";
            dtCouponTab.Columns["InterestforthePeriod"].ColumnName = "InterestforthePeriod_Old";
            dtCouponTab.Columns["InterestPaidonPaymentDate"].ColumnName = "InterestPaidonPaymentDate_Old";
            dtCouponTab.Columns["InterestPaidperServicing"].ColumnName = "InterestPaidperServicing_Old";
            dtCouponTab.Columns["CouponStrippingforthePeriod"].ColumnName = "CouponStrippingforthePeriod_Old";
            dtCouponTab.Columns["CouponStrippedonPaymentDate"].ColumnName = "CouponStrippedonPaymentDate_Old";
            dtCouponTab.Columns["ServicingOverrideTag"].ColumnName = "ServicingOverrideTag_Old";
            dtCouponTab.Columns["CouponbasedonFutureFunding"].ColumnName = "CouponbasedonFutureFunding_Old";
            dtCouponTab.Columns["AccumCouponbasedonFutureFunding"].ColumnName = "AccumCouponbasedonFutureFunding_Old";
            dtCouponTab.Columns["InterestSuspenseAccountActivityforthePeriod"].ColumnName = "InterestSuspenseAccountActivityforthePeriod_Old";
            dtCouponTab.Columns["InterestSuspenseAccountBalance"].ColumnName = "InterestSuspenseAccountBalance_Old";
            dtCouponTab.Columns["DailySpreadInterestbeforeStrippingRule"].ColumnName = "DailySpreadInterestbeforeStrippingRule_Old";
            dtCouponTab.Columns["DailyLiborInterestbeforeStrippingRule"].ColumnName = "DailyLiborInterestbeforeStrippingRule_Old";

            dtCouponTab.Columns["PMTDropDateDailyAccruedInterestbeforeStrippingRule"].ColumnName = "PMTDropDateDailyAccruedInterestbeforeStrippingRule_Old";
            dtCouponTab.Columns["PMTDropDateDailyAccruedCouponStripping"].ColumnName = "PMTDropDateDailyAccruedCouponStripping_Old";
            dtCouponTab.Columns["PMTDropDateDailyAccruedInterest"].ColumnName = "PMTDropDateDailyAccruedInterest_Old";
            dtCouponTab.Columns["PMTDropDateDailyAccruedInterestAddOn"].ColumnName = "PMTDropDateDailyAccruedInterestAddOn_Old";
            dtCouponTab.Columns["PMTDropDateAccumInterestforCurrentAccrualPeriod"].ColumnName = "PMTDropDateAccumInterestforCurrentAccrualPeriod_Old";
            dtCouponTab.Columns["PMTDropDateAccumInterestforCurrentAccrualPeriodAddOn"].ColumnName = "PMTDropDateAccumInterestforCurrentAccrualPeriodAddOn_Old";
            dtCouponTab.Columns["PMTDropDateAccumCouponStrippingforCurrentAccrualPeriod"].ColumnName = "PMTDropDateAccumCouponStrippingforCurrentAccrualPeriod_Old";
            dtCouponTab.Columns["PMTDropDateInterestforthePeriod"].ColumnName = "PMTDropDateInterestforthePeriod_Old";
            dtCouponTab.Columns["PMTDropDateInterestPaidonPaymentDate"].ColumnName = "PMTDropDateInterestPaidonPaymentDate_Old";
            dtCouponTab.Columns["PMTDropDateInterestPaidperServicing"].ColumnName = "PMTDropDateInterestPaidperServicing_Old";
            dtCouponTab.Columns["PMTDropDateCouponStrippingforthePeriod"].ColumnName = "PMTDropDateCouponStrippingforthePeriod_Old";
            dtCouponTab.Columns["PMTDropDateCouponStrippedonPaymentDate"].ColumnName = "PMTDropDateCouponStrippedonPaymentDate_Old";
            dtCouponTab.Columns["InterestPaid"].ColumnName = "InterestPaid_Old";
            dtCouponTab.Columns["InterestPaidDeltaforthePeriod"].ColumnName = "InterestPaidDeltaforthePeriod_Old";
            dtCouponTab.Columns["CoveredDelta"].ColumnName = "CoveredDelta_Old";
            dtCouponTab.Columns["DeltaBalance"].ColumnName = "DeltaBalance_Old";
            dtCouponTab.Columns["InterestPaidServicingWithDropDate"].ColumnName = "InterestPaidServicingWithDropDate_Old";
            dtCouponTab.Columns["CouponStripReceivable"].ColumnName = "CouponStripReceivable_Old";
            dtCouponTab.Columns["UnpaidInterest"].ColumnName = "UnpaidInterest_Old";
            //dtCouponTab.Columns["InterestSuspenseAccountBalanceWithAdj"].ColumnName = "InterestSuspenseAccountBalanceWithAdj_Old";

            //add new columns
            dtCouponTab.Columns.Add("Date", typeof(DateTime));
            dtCouponTab.Columns.Add("InterestCalcMethod", typeof(string));
            dtCouponTab.Columns.Add("NumberofDaysinReferencedAccrualPeriod", typeof(decimal));
            dtCouponTab.Columns.Add("InterestCalcMethodAdjustment30_360vsActual_360", typeof(decimal));
            dtCouponTab.Columns.Add("InterestAccrualPeriodEndDateTag", typeof(decimal));
            dtCouponTab.Columns.Add("DailyAccruedInterestbeforeStrippingRule", typeof(decimal));
            dtCouponTab.Columns.Add("DailyAccruedCouponStripping", typeof(decimal));
            dtCouponTab.Columns.Add("DailyAccruedInterest", typeof(decimal));
            dtCouponTab.Columns.Add("AccumInterestforCurrentAccrualPeriod", typeof(decimal));
            dtCouponTab.Columns.Add("AccumCouponStrippingforCurrentAccrualPeriod", typeof(decimal));
            dtCouponTab.Columns.Add("InterestforthePeriodShortfall", typeof(decimal));
            dtCouponTab.Columns.Add("InterestPaidonPMTDateShortfall", typeof(decimal));
            dtCouponTab.Columns.Add("CumulativeInterestPaidonPMTDateShortfall", typeof(decimal));
            dtCouponTab.Columns.Add("InterestShortfallLoss", typeof(decimal));
            dtCouponTab.Columns.Add("InterestShortfallRecovery", typeof(decimal));
            dtCouponTab.Columns.Add("InterestforthePeriod", typeof(decimal));
            dtCouponTab.Columns.Add("InterestPaidonPaymentDate", typeof(decimal));
            dtCouponTab.Columns.Add("InterestPaidperServicing", typeof(decimal));
            dtCouponTab.Columns.Add("CouponStrippingforthePeriod", typeof(decimal));
            dtCouponTab.Columns.Add("CouponStrippedonPaymentDate", typeof(decimal));
            dtCouponTab.Columns.Add("ServicingOverrideTag", typeof(decimal));
            dtCouponTab.Columns.Add("CouponbasedonFutureFunding", typeof(decimal));
            dtCouponTab.Columns.Add("AccumCouponbasedonFutureFunding", typeof(decimal));
            dtCouponTab.Columns.Add("InterestSuspenseAccountActivityforthePeriod", typeof(decimal));
            dtCouponTab.Columns.Add("InterestSuspenseAccountBalance", typeof(decimal));
            dtCouponTab.Columns.Add("DailySpreadInterestbeforeStrippingRule", typeof(decimal));
            dtCouponTab.Columns.Add("DailyLiborInterestbeforeStrippingRule", typeof(decimal));

            dtCouponTab.Columns.Add("PMTDropDateDailyAccruedInterestbeforeStrippingRule", typeof(decimal));
            dtCouponTab.Columns.Add("PMTDropDateDailyAccruedCouponStripping", typeof(decimal));
            dtCouponTab.Columns.Add("PMTDropDateDailyAccruedInterest", typeof(decimal));
            dtCouponTab.Columns.Add("PMTDropDateDailyAccruedInterestAddOn", typeof(decimal));
            dtCouponTab.Columns.Add("PMTDropDateAccumInterestforCurrentAccrualPeriod", typeof(decimal));
            dtCouponTab.Columns.Add("PMTDropDateAccumInterestforCurrentAccrualPeriodAddOn", typeof(decimal));
            dtCouponTab.Columns.Add("PMTDropDateAccumCouponStrippingforCurrentAccrualPeriod", typeof(decimal));
            dtCouponTab.Columns.Add("PMTDropDateInterestforthePeriod", typeof(decimal));
            dtCouponTab.Columns.Add("PMTDropDateInterestPaidonPaymentDate", typeof(decimal));
            dtCouponTab.Columns.Add("PMTDropDateInterestPaidperServicing", typeof(decimal));
            dtCouponTab.Columns.Add("PMTDropDateCouponStrippingforthePeriod", typeof(decimal));
            dtCouponTab.Columns.Add("PMTDropDateCouponStrippedonPaymentDate", typeof(decimal));
            dtCouponTab.Columns.Add("InterestPaid", typeof(decimal));
            dtCouponTab.Columns.Add("InterestPaidDeltaforthePeriod", typeof(decimal));
            dtCouponTab.Columns.Add("CoveredDelta", typeof(decimal));
            dtCouponTab.Columns.Add("DeltaBalance", typeof(decimal));
            dtCouponTab.Columns.Add("InterestPaidServicingWithDropDate", typeof(decimal));
            dtCouponTab.Columns.Add("CouponStripReceivable", typeof(decimal));
            dtCouponTab.Columns.Add("UnpaidInterest", typeof(decimal));
            //dtCouponTab.Columns.Add("InterestSuspenseAccountBalanceWithAdj", typeof(decimal));


            foreach (DataRow row in dtCouponTab.Rows)
            {
                row["Date"] = CommonHelper.ToDateTime(row["Date_Old"]);
                row["InterestCalcMethod"] = row["InterestCalcMethod_Old"].ToString();
                row["NumberofDaysinReferencedAccrualPeriod"] = Math.Round(CommonHelper.StringToDecimal(row["NumberofDaysinReferencedAccrualPeriod_Old"]).GetValueOrDefault(0), 10);
                row["InterestCalcMethodAdjustment30_360vsActual_360"] = Math.Round(CommonHelper.StringToDecimal(row["InterestCalcMethodAdjustment30_360vsActual_360_Old"]).GetValueOrDefault(0), 10);
                row["InterestAccrualPeriodEndDateTag"] = Math.Round(CommonHelper.StringToDecimal(row["InterestAccrualPeriodEndDateTag_Old"]).GetValueOrDefault(0), 10);
                row["DailyAccruedInterestbeforeStrippingRule"] = Math.Round(CommonHelper.StringToDecimal(row["DailyAccruedInterestbeforeStrippingRule_Old"]).GetValueOrDefault(0), 10);
                row["DailyAccruedCouponStripping"] = Math.Round(CommonHelper.StringToDecimal(row["DailyAccruedCouponStripping_Old"]).GetValueOrDefault(0), 10);
                row["DailyAccruedInterest"] = Math.Round(CommonHelper.StringToDecimal(row["DailyAccruedInterest_Old"]).GetValueOrDefault(0), 10);
                row["AccumInterestforCurrentAccrualPeriod"] = Math.Round(CommonHelper.StringToDecimal(row["AccumInterestforCurrentAccrualPeriod_Old"]).GetValueOrDefault(0), 10);
                row["AccumCouponStrippingforCurrentAccrualPeriod"] = Math.Round(CommonHelper.StringToDecimal(row["AccumCouponStrippingforCurrentAccrualPeriod_Old"]).GetValueOrDefault(0), 10);
                row["InterestforthePeriodShortfall"] = Math.Round(CommonHelper.StringToDecimal(row["InterestforthePeriodShortfall_Old"]).GetValueOrDefault(0), 10);
                row["InterestPaidonPMTDateShortfall"] = Math.Round(CommonHelper.StringToDecimal(row["InterestPaidonPMTDateShortfall_Old"]).GetValueOrDefault(0), 10);
                row["CumulativeInterestPaidonPMTDateShortfall"] = Math.Round(CommonHelper.StringToDecimal(row["CumulativeInterestPaidonPMTDateShortfall_Old"]).GetValueOrDefault(0), 10);
                row["InterestShortfallLoss"] = Math.Round(CommonHelper.StringToDecimal(row["InterestShortfallLoss_Old"]).GetValueOrDefault(0), 10);
                row["InterestShortfallRecovery"] = Math.Round(CommonHelper.StringToDecimal(row["InterestShortfallRecovery_Old"]).GetValueOrDefault(0), 10);
                row["InterestforthePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["InterestforthePeriod_Old"]).GetValueOrDefault(0), 10);
                row["InterestPaidonPaymentDate"] = Math.Round(CommonHelper.StringToDecimal(row["InterestPaidonPaymentDate_Old"]).GetValueOrDefault(0), 10);
                row["InterestPaidperServicing"] = Math.Round(CommonHelper.StringToDecimal(row["InterestPaidperServicing_Old"]).GetValueOrDefault(0), 10);
                row["CouponStrippingforthePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["CouponStrippingforthePeriod_Old"]).GetValueOrDefault(0), 10);
                row["CouponStrippedonPaymentDate"] = Math.Round(CommonHelper.StringToDecimal(row["CouponStrippedonPaymentDate_Old"]).GetValueOrDefault(0), 10);
                row["ServicingOverrideTag"] = Math.Round(CommonHelper.StringToDecimal(row["ServicingOverrideTag_Old"]).GetValueOrDefault(0), 10);
                row["CouponbasedonFutureFunding"] = Math.Round(CommonHelper.StringToDecimal(row["CouponbasedonFutureFunding_Old"]).GetValueOrDefault(0), 10);
                row["AccumCouponbasedonFutureFunding"] = Math.Round(CommonHelper.StringToDecimal(row["AccumCouponbasedonFutureFunding_Old"]).GetValueOrDefault(0), 10);
                row["InterestSuspenseAccountActivityforthePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["InterestSuspenseAccountActivityforthePeriod_Old"]).GetValueOrDefault(0), 10);
                row["InterestSuspenseAccountBalance"] = Math.Round(CommonHelper.StringToDecimal(row["InterestSuspenseAccountBalance_Old"]).GetValueOrDefault(0), 10);
                row["DailySpreadInterestbeforeStrippingRule"] = Math.Round(CommonHelper.StringToDecimal(row["DailySpreadInterestbeforeStrippingRule_Old"]).GetValueOrDefault(0), 10);
                row["DailyLiborInterestbeforeStrippingRule"] = Math.Round(CommonHelper.StringToDecimal(row["DailyLiborInterestbeforeStrippingRule_Old"]).GetValueOrDefault(0), 10);

                row["PMTDropDateDailyAccruedInterestbeforeStrippingRule"] = Math.Round(CommonHelper.StringToDecimal(row["PMTDropDateDailyAccruedInterestbeforeStrippingRule_Old"]).GetValueOrDefault(0), 10);
                row["PMTDropDateDailyAccruedCouponStripping"] = Math.Round(CommonHelper.StringToDecimal(row["PMTDropDateDailyAccruedCouponStripping_Old"]).GetValueOrDefault(0), 10);
                row["PMTDropDateDailyAccruedInterest"] = Math.Round(CommonHelper.StringToDecimal(row["PMTDropDateDailyAccruedInterest_Old"]).GetValueOrDefault(0), 10);
                row["PMTDropDateDailyAccruedInterestAddOn"] = Math.Round(CommonHelper.StringToDecimal(row["PMTDropDateDailyAccruedInterestAddOn_Old"]).GetValueOrDefault(0), 10);
                row["PMTDropDateAccumInterestforCurrentAccrualPeriod"] = Math.Round(CommonHelper.StringToDecimal(row["PMTDropDateAccumInterestforCurrentAccrualPeriod_Old"]).GetValueOrDefault(0), 10);
                row["PMTDropDateAccumInterestforCurrentAccrualPeriodAddOn"] = Math.Round(CommonHelper.StringToDecimal(row["PMTDropDateAccumInterestforCurrentAccrualPeriodAddOn_Old"]).GetValueOrDefault(0), 10);
                row["PMTDropDateAccumCouponStrippingforCurrentAccrualPeriod"] = Math.Round(CommonHelper.StringToDecimal(row["PMTDropDateAccumCouponStrippingforCurrentAccrualPeriod_Old"]).GetValueOrDefault(0), 10);
                row["PMTDropDateInterestforthePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["PMTDropDateInterestforthePeriod_Old"]).GetValueOrDefault(0), 10);
                row["PMTDropDateInterestPaidonPaymentDate"] = Math.Round(CommonHelper.StringToDecimal(row["PMTDropDateInterestPaidonPaymentDate_Old"]).GetValueOrDefault(0), 10);
                row["PMTDropDateInterestPaidperServicing"] = Math.Round(CommonHelper.StringToDecimal(row["PMTDropDateInterestPaidperServicing_Old"]).GetValueOrDefault(0), 10);
                row["PMTDropDateCouponStrippingforthePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["PMTDropDateCouponStrippingforthePeriod_Old"]).GetValueOrDefault(0), 10);
                row["PMTDropDateCouponStrippedonPaymentDate"] = Math.Round(CommonHelper.StringToDecimal(row["PMTDropDateCouponStrippedonPaymentDate_Old"]).GetValueOrDefault(0), 10);
                row["InterestPaid"] = Math.Round(CommonHelper.StringToDecimal(row["InterestPaid_Old"]).GetValueOrDefault(0), 10);
                row["InterestPaidDeltaforthePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["InterestPaidDeltaforthePeriod_Old"]).GetValueOrDefault(0), 10);
                row["CoveredDelta"] = Math.Round(CommonHelper.StringToDecimal(row["CoveredDelta_Old"]).GetValueOrDefault(0), 10);
                row["DeltaBalance"] = Math.Round(CommonHelper.StringToDecimal(row["DeltaBalance_Old"]).GetValueOrDefault(0), 10);
                row["InterestPaidServicingWithDropDate"] = Math.Round(CommonHelper.StringToDecimal(row["InterestPaidServicingWithDropDate_Old"]).GetValueOrDefault(0), 10);
                row["CouponStripReceivable"] = Math.Round(CommonHelper.StringToDecimal(row["CouponStripReceivable_Old"]).GetValueOrDefault(0), 10);
                row["UnpaidInterest"] = Math.Round(CommonHelper.StringToDecimal(row["UnpaidInterest_Old"]).GetValueOrDefault(0), 10);
                //row["InterestSuspenseAccountBalanceWithAdj"] = Math.Round(CommonHelper.StringToDecimal(row["InterestSuspenseAccountBalanceWithAdj_Old"]).GetValueOrDefault(0), 10);

            }
            dtCouponTab.Columns.Remove("Date_Old");
            dtCouponTab.Columns.Remove("InterestCalcMethod_Old");
            dtCouponTab.Columns.Remove("NumberofDaysinReferencedAccrualPeriod_Old");
            dtCouponTab.Columns.Remove("InterestCalcMethodAdjustment30_360vsActual_360_Old");
            dtCouponTab.Columns.Remove("InterestAccrualPeriodEndDateTag_Old");
            dtCouponTab.Columns.Remove("DailyAccruedInterestbeforeStrippingRule_Old");
            dtCouponTab.Columns.Remove("DailyAccruedCouponStripping_Old");
            dtCouponTab.Columns.Remove("DailyAccruedInterest_Old");
            dtCouponTab.Columns.Remove("AccumInterestforCurrentAccrualPeriod_Old");
            dtCouponTab.Columns.Remove("AccumCouponStrippingforCurrentAccrualPeriod_Old");
            dtCouponTab.Columns.Remove("InterestforthePeriodShortfall_Old");
            dtCouponTab.Columns.Remove("InterestPaidonPMTDateShortfall_Old");
            dtCouponTab.Columns.Remove("CumulativeInterestPaidonPMTDateShortfall_Old");
            dtCouponTab.Columns.Remove("InterestShortfallLoss_Old");
            dtCouponTab.Columns.Remove("InterestShortfallRecovery_Old");
            dtCouponTab.Columns.Remove("InterestforthePeriod_Old");
            dtCouponTab.Columns.Remove("InterestPaidonPaymentDate_Old");
            dtCouponTab.Columns.Remove("InterestPaidperServicing_Old");
            dtCouponTab.Columns.Remove("CouponStrippingforthePeriod_Old");
            dtCouponTab.Columns.Remove("CouponStrippedonPaymentDate_Old");
            dtCouponTab.Columns.Remove("ServicingOverrideTag_Old");
            dtCouponTab.Columns.Remove("CouponbasedonFutureFunding_Old");
            dtCouponTab.Columns.Remove("AccumCouponbasedonFutureFunding_Old");
            dtCouponTab.Columns.Remove("InterestSuspenseAccountActivityforthePeriod_Old");
            dtCouponTab.Columns.Remove("InterestSuspenseAccountBalance_Old");
            dtCouponTab.Columns.Remove("DailySpreadInterestbeforeStrippingRule_Old");
            dtCouponTab.Columns.Remove("DailyLiborInterestbeforeStrippingRule_Old");

            dtCouponTab.Columns.Remove("PMTDropDateDailyAccruedInterestbeforeStrippingRule_Old");
            dtCouponTab.Columns.Remove("PMTDropDateDailyAccruedCouponStripping_Old");
            dtCouponTab.Columns.Remove("PMTDropDateDailyAccruedInterest_Old");
            dtCouponTab.Columns.Remove("PMTDropDateDailyAccruedInterestAddOn_Old");
            dtCouponTab.Columns.Remove("PMTDropDateAccumInterestforCurrentAccrualPeriod_Old");
            dtCouponTab.Columns.Remove("PMTDropDateAccumInterestforCurrentAccrualPeriodAddOn_Old");
            dtCouponTab.Columns.Remove("PMTDropDateAccumCouponStrippingforCurrentAccrualPeriod_Old");
            dtCouponTab.Columns.Remove("PMTDropDateInterestforthePeriod_Old");
            dtCouponTab.Columns.Remove("PMTDropDateInterestPaidonPaymentDate_Old");
            dtCouponTab.Columns.Remove("PMTDropDateInterestPaidperServicing_Old");
            dtCouponTab.Columns.Remove("PMTDropDateCouponStrippingforthePeriod_Old");
            dtCouponTab.Columns.Remove("PMTDropDateCouponStrippedonPaymentDate_Old");
            dtCouponTab.Columns.Remove("InterestPaid_Old");
            dtCouponTab.Columns.Remove("InterestPaidDeltaforthePeriod_Old");
            dtCouponTab.Columns.Remove("CoveredDelta_Old");
            dtCouponTab.Columns.Remove("DeltaBalance_Old");
            dtCouponTab.Columns.Remove("InterestPaidServicingWithDropDate_Old");
            dtCouponTab.Columns.Remove("CouponStripReceivable_Old");
            dtCouponTab.Columns.Remove("UnpaidInterest_Old");
            //dtCouponTab.Columns.Remove("InterestSuspenseAccountBalanceWithAdj_Old");

            return dtCouponTab;

        }


        public DataTable FormatPIkData(DataTable dtPIKTab)
        {

            dtPIKTab.Columns["Date"].ColumnName = "Date_Old";
            dtPIKTab.Columns["PIKInterestCapfromPIKTable"].ColumnName = "PIKInterestCapfromPIKTable_Old";
            dtPIKTab.Columns["NotePIKCapBalancefromPIKTable"].ColumnName = "NotePIKCapBalancefromPIKTable_Old";
            dtPIKTab.Columns["DailyAccruedPIKInterest"].ColumnName = "DailyAccruedPIKInterest_Old";
            dtPIKTab.Columns["DailyAccruedPIKInterestAdjustedforPIKInterestCap"].ColumnName = "DailyAccruedPIKInterestAdjustedforPIKInterestCap_Old";
            dtPIKTab.Columns["AccrualPeriodEndDateTag"].ColumnName = "AccrualPeriodEndDateTag_Old";
            dtPIKTab.Columns["AccumPIKInterestforCurrentAccrualPeriod"].ColumnName = "AccumPIKInterestforCurrentAccrualPeriod_Old";
            dtPIKTab.Columns["PIKInterestforthePeriod"].ColumnName = "PIKInterestforthePeriod_Old";
            dtPIKTab.Columns["PIKInterestforthePeriodOnAccrualEndDate"].ColumnName = "PIKInterestforthePeriodOnAccrualEndDate_Old";
            dtPIKTab.Columns["CumPIKInterest"].ColumnName = "CumPIKInterest_Old";
            dtPIKTab.Columns["BeginningPIKBalanceifnotCompoundedinsideLoanBalance"].ColumnName = "BeginningPIKBalanceifnotCompoundedinsideLoanBalance_Old";
            dtPIKTab.Columns["DailyAccruedCompoundedPIKInterest"].ColumnName = "DailyAccruedCompoundedPIKInterest_Old";
            dtPIKTab.Columns["AccumCompoundedPIKInterestforCurrentAccrualPeriod"].ColumnName = "AccumCompoundedPIKInterestforCurrentAccrualPeriod_Old";
            dtPIKTab.Columns["PIKInterestforthePeriodBalloon"].ColumnName = "PIKInterestforthePeriodBalloon_Old";
            dtPIKTab.Columns["PIKBalanceBalloonPayment"].ColumnName = "PIKBalanceBalloonPayment_Old";
            dtPIKTab.Columns["EndingPIKBalanceifnotCompoundedinsideLoanBalance"].ColumnName = "EndingPIKBalanceifnotCompoundedinsideLoanBalance_Old";
            dtPIKTab.Columns["DailyAccruedPIKInteresttobeTransferredtoRelatedNote"].ColumnName = "DailyAccruedPIKInteresttobeTransferredtoRelatedNote_Old";
            dtPIKTab.Columns["AccumPIKInteresttobeTransferredtoRelatedNoteforCurrentAccrualPeriod"].ColumnName = "AccumPIKInteresttobeTransferredtoRelatedNoteforCurrentAccrualPeriod_Old";
            dtPIKTab.Columns["TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod"].ColumnName = "TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod_Old";
            dtPIKTab.Columns["PIKInterestPaidForThePeriod"].ColumnName = "PIKInterestPaidForThePeriod_Old";
            dtPIKTab.Columns["PIKInterestPaidForThePeriodOnAccrualEndDate"].ColumnName = "PIKInterestPaidForThePeriodOnAccrualEndDate_Old";
            dtPIKTab.Columns["PIKInterestPaidForThePeriodOnAccrualEndDateEOD"].ColumnName = "PIKInterestPaidForThePeriodOnAccrualEndDateEOD_Old";
            dtPIKTab.Columns["PIKInterestPaidAppliedForThePeriod"].ColumnName = "PIKInterestPaidAppliedForThePeriod_Old";
            dtPIKTab.Columns["PIKInterestPaidAppliedForThePeriodOnAccrualEndDate"].ColumnName = "PIKInterestPaidAppliedForThePeriodOnAccrualEndDate_Old";
            dtPIKTab.Columns["PIKInterestOnPMTDate"].ColumnName = "PIKInterestOnPMTDate_Old";
            dtPIKTab.Columns["PIKInterestonBusinessAdjInterestAccrualEndDate"].ColumnName = "PIKInterestonBusinessAdjInterestAccrualEndDate_Old";
            dtPIKTab.Columns["PIKBusinessDateAdjcheck"].ColumnName = "PIKBusinessDateAdjcheck_Old";
            dtPIKTab.Columns["PIKPrincipalPaidForThePeriod"].ColumnName = "PIKPrincipalPaidForThePeriod_Old";
            dtPIKTab.Columns["PIKComments"].ColumnName = "PIKComments_Old";
            dtPIKTab.Columns["PIKReasonCodeText"].ColumnName = "PIKReasonCodeText_Old";


            //add new columns

            dtPIKTab.Columns.Add("Date", typeof(DateTime));
            dtPIKTab.Columns.Add("PIKInterestCapfromPIKTable", typeof(decimal));
            dtPIKTab.Columns.Add("NotePIKCapBalancefromPIKTable", typeof(decimal));
            dtPIKTab.Columns.Add("DailyAccruedPIKInterest", typeof(decimal));
            dtPIKTab.Columns.Add("DailyAccruedPIKInterestAdjustedforPIKInterestCap", typeof(decimal));
            dtPIKTab.Columns.Add("AccrualPeriodEndDateTag", typeof(decimal));
            dtPIKTab.Columns.Add("AccumPIKInterestforCurrentAccrualPeriod", typeof(decimal));
            dtPIKTab.Columns.Add("PIKInterestforthePeriod", typeof(decimal));
            dtPIKTab.Columns.Add("PIKInterestforthePeriodOnAccrualEndDate", typeof(decimal));
            dtPIKTab.Columns.Add("CumPIKInterest", typeof(decimal));
            dtPIKTab.Columns.Add("BeginningPIKBalanceifnotCompoundedinsideLoanBalance", typeof(decimal));
            dtPIKTab.Columns.Add("DailyAccruedCompoundedPIKInterest", typeof(decimal));
            dtPIKTab.Columns.Add("AccumCompoundedPIKInterestforCurrentAccrualPeriod", typeof(decimal));
            dtPIKTab.Columns.Add("PIKInterestforthePeriodBalloon", typeof(decimal));
            dtPIKTab.Columns.Add("PIKBalanceBalloonPayment", typeof(decimal));
            dtPIKTab.Columns.Add("EndingPIKBalanceifnotCompoundedinsideLoanBalance", typeof(decimal));
            dtPIKTab.Columns.Add("DailyAccruedPIKInteresttobeTransferredtoRelatedNote", typeof(decimal));
            dtPIKTab.Columns.Add("AccumPIKInteresttobeTransferredtoRelatedNoteforCurrentAccrualPeriod", typeof(decimal));
            dtPIKTab.Columns.Add("TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod", typeof(decimal));
            dtPIKTab.Columns.Add("PIKInterestPaidForThePeriod", typeof(decimal));
            dtPIKTab.Columns.Add("PIKInterestPaidForThePeriodOnAccrualEndDate", typeof(decimal));
            dtPIKTab.Columns.Add("PIKInterestPaidForThePeriodOnAccrualEndDateEOD", typeof(decimal));
            dtPIKTab.Columns.Add("PIKInterestPaidAppliedForThePeriod", typeof(decimal));
            dtPIKTab.Columns.Add("PIKInterestPaidAppliedForThePeriodOnAccrualEndDate", typeof(decimal));
            dtPIKTab.Columns.Add("PIKInterestOnPMTDate", typeof(decimal));
            dtPIKTab.Columns.Add("PIKInterestonBusinessAdjInterestAccrualEndDate", typeof(decimal));
            dtPIKTab.Columns.Add("PIKBusinessDateAdjcheck", typeof(decimal));
            dtPIKTab.Columns.Add("PIKPrincipalPaidForThePeriod", typeof(decimal));
            dtPIKTab.Columns.Add("PIKComments", typeof(string));
            dtPIKTab.Columns.Add("PIKReasonCodeText", typeof(string));


            foreach (DataRow row in dtPIKTab.Rows)
            {
                row["Date"] = CommonHelper.ToDateTime(row["Date_Old"]);
                row["PIKInterestCapfromPIKTable"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestCapfromPIKTable_Old"]).GetValueOrDefault(0), 10);
                row["NotePIKCapBalancefromPIKTable"] = Math.Round(CommonHelper.StringToDecimal(row["NotePIKCapBalancefromPIKTable_Old"]).GetValueOrDefault(0), 10);
                row["DailyAccruedPIKInterest"] = Math.Round(CommonHelper.StringToDecimal(row["DailyAccruedPIKInterest_Old"]).GetValueOrDefault(0), 10);
                row["DailyAccruedPIKInterestAdjustedforPIKInterestCap"] = Math.Round(CommonHelper.StringToDecimal(row["DailyAccruedPIKInterestAdjustedforPIKInterestCap_Old"]).GetValueOrDefault(0), 10);
                row["AccrualPeriodEndDateTag"] = Math.Round(CommonHelper.StringToDecimal(row["AccrualPeriodEndDateTag_Old"]).GetValueOrDefault(0), 10);
                row["AccumPIKInterestforCurrentAccrualPeriod"] = Math.Round(CommonHelper.StringToDecimal(row["AccumPIKInterestforCurrentAccrualPeriod_Old"]).GetValueOrDefault(0), 10);
                row["PIKInterestforthePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestforthePeriod_Old"]).GetValueOrDefault(0), 10);
                row["PIKInterestforthePeriodOnAccrualEndDate"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestforthePeriodOnAccrualEndDate_Old"]).GetValueOrDefault(0), 10);
                row["CumPIKInterest"] = Math.Round(CommonHelper.StringToDecimal(row["CumPIKInterest_Old"]).GetValueOrDefault(0), 10);
                row["BeginningPIKBalanceifnotCompoundedinsideLoanBalance"] = Math.Round(CommonHelper.StringToDecimal(row["BeginningPIKBalanceifnotCompoundedinsideLoanBalance_Old"]).GetValueOrDefault(0), 10);
                row["DailyAccruedCompoundedPIKInterest"] = Math.Round(CommonHelper.StringToDecimal(row["DailyAccruedCompoundedPIKInterest_Old"]).GetValueOrDefault(0), 10);
                row["AccumCompoundedPIKInterestforCurrentAccrualPeriod"] = Math.Round(CommonHelper.StringToDecimal(row["AccumCompoundedPIKInterestforCurrentAccrualPeriod_Old"]).GetValueOrDefault(0), 10);
                row["PIKInterestforthePeriodBalloon"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestforthePeriodBalloon_Old"]).GetValueOrDefault(0), 10);
                row["PIKBalanceBalloonPayment"] = Math.Round(CommonHelper.StringToDecimal(row["PIKBalanceBalloonPayment_Old"]).GetValueOrDefault(0), 10);
                row["EndingPIKBalanceifnotCompoundedinsideLoanBalance"] = Math.Round(CommonHelper.StringToDecimal(row["EndingPIKBalanceifnotCompoundedinsideLoanBalance_Old"]).GetValueOrDefault(0), 10);
                row["DailyAccruedPIKInteresttobeTransferredtoRelatedNote"] = Math.Round(CommonHelper.StringToDecimal(row["DailyAccruedPIKInteresttobeTransferredtoRelatedNote_Old"]).GetValueOrDefault(0), 10);
                row["AccumPIKInteresttobeTransferredtoRelatedNoteforCurrentAccrualPeriod"] = Math.Round(CommonHelper.StringToDecimal(row["AccumPIKInteresttobeTransferredtoRelatedNoteforCurrentAccrualPeriod_Old"]).GetValueOrDefault(0), 10);
                row["TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod_Old"]).GetValueOrDefault(0), 10);
                row["PIKInterestPaidForThePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestPaidForThePeriod_Old"]).GetValueOrDefault(0), 10);
                row["PIKInterestPaidForThePeriodOnAccrualEndDate"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestPaidForThePeriodOnAccrualEndDate_Old"]).GetValueOrDefault(0), 10);
                row["PIKInterestPaidForThePeriodOnAccrualEndDateEOD"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestPaidForThePeriodOnAccrualEndDateEOD_Old"]).GetValueOrDefault(0), 10);
                row["PIKInterestPaidAppliedForThePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestPaidAppliedForThePeriod_Old"]).GetValueOrDefault(0), 10);
                row["PIKInterestPaidAppliedForThePeriodOnAccrualEndDate"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestPaidAppliedForThePeriodOnAccrualEndDate_Old"]).GetValueOrDefault(0), 10);
                row["PIKInterestOnPMTDate"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestOnPMTDate_Old"]).GetValueOrDefault(0), 10);
                row["PIKInterestonBusinessAdjInterestAccrualEndDate"] = Math.Round(CommonHelper.StringToDecimal(row["PIKInterestonBusinessAdjInterestAccrualEndDate_Old"]).GetValueOrDefault(0), 10);
                row["PIKBusinessDateAdjcheck"] = Math.Round(CommonHelper.StringToDecimal(row["PIKBusinessDateAdjcheck_Old"]).GetValueOrDefault(0), 10);
                row["PIKPrincipalPaidForThePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["PIKPrincipalPaidForThePeriod_Old"]).GetValueOrDefault(0), 10);
                row["PIKComments"] = row["PIKComments_Old"].ToString();
                row["PIKReasonCodeText"] = row["PIKReasonCodeText_Old"].ToString();

            }

            dtPIKTab.Columns.Remove("Date_Old");
            dtPIKTab.Columns.Remove("PIKInterestCapfromPIKTable_Old");
            dtPIKTab.Columns.Remove("NotePIKCapBalancefromPIKTable_Old");
            dtPIKTab.Columns.Remove("DailyAccruedPIKInterest_Old");
            dtPIKTab.Columns.Remove("DailyAccruedPIKInterestAdjustedforPIKInterestCap_Old");
            dtPIKTab.Columns.Remove("AccrualPeriodEndDateTag_Old");
            dtPIKTab.Columns.Remove("AccumPIKInterestforCurrentAccrualPeriod_Old");
            dtPIKTab.Columns.Remove("PIKInterestforthePeriod_Old");
            dtPIKTab.Columns.Remove("PIKInterestforthePeriodOnAccrualEndDate_Old");
            dtPIKTab.Columns.Remove("CumPIKInterest_Old");
            dtPIKTab.Columns.Remove("BeginningPIKBalanceifnotCompoundedinsideLoanBalance_Old");
            dtPIKTab.Columns.Remove("DailyAccruedCompoundedPIKInterest_Old");
            dtPIKTab.Columns.Remove("AccumCompoundedPIKInterestforCurrentAccrualPeriod_Old");
            dtPIKTab.Columns.Remove("PIKInterestforthePeriodBalloon_Old");
            dtPIKTab.Columns.Remove("PIKBalanceBalloonPayment_Old");
            dtPIKTab.Columns.Remove("EndingPIKBalanceifnotCompoundedinsideLoanBalance_Old");
            dtPIKTab.Columns.Remove("DailyAccruedPIKInteresttobeTransferredtoRelatedNote_Old");
            dtPIKTab.Columns.Remove("AccumPIKInteresttobeTransferredtoRelatedNoteforCurrentAccrualPeriod_Old");
            dtPIKTab.Columns.Remove("TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod_Old");
            dtPIKTab.Columns.Remove("PIKInterestPaidForThePeriod_Old");
            dtPIKTab.Columns.Remove("PIKInterestPaidForThePeriodOnAccrualEndDate_Old");
            dtPIKTab.Columns.Remove("PIKInterestPaidForThePeriodOnAccrualEndDateEOD_Old");
            dtPIKTab.Columns.Remove("PIKInterestPaidAppliedForThePeriod_Old");
            dtPIKTab.Columns.Remove("PIKInterestPaidAppliedForThePeriodOnAccrualEndDate_Old");
            dtPIKTab.Columns.Remove("PIKInterestOnPMTDate_Old");
            dtPIKTab.Columns.Remove("PIKInterestonBusinessAdjInterestAccrualEndDate_Old");
            dtPIKTab.Columns.Remove("PIKBusinessDateAdjcheck_Old");
            dtPIKTab.Columns.Remove("PIKPrincipalPaidForThePeriod_Old");
            dtPIKTab.Columns.Remove("PIKComments_Old");
            dtPIKTab.Columns.Remove("PIKReasonCodeText_Old");

            return dtPIKTab;

        }
        public DataTable FormatGaapData(DataTable dtGaapTab)
        {

            dtGaapTab.Columns["Date"].ColumnName = "Date_Old";
            dtGaapTab.Columns["CashFlowusedforLevelYieldPreCap"].ColumnName = "CashFlowusedforLevelYieldPreCap_Old";
            dtGaapTab.Columns["PreCapLevelYield"].ColumnName = "PreCapLevelYield_Old";
            dtGaapTab.Columns["LockedPreCapBasis"].ColumnName = "LockedPreCapBasis_Old";
            dtGaapTab.Columns["PeriodLevelYieldIncomePreCap"].ColumnName = "PeriodLevelYieldIncomePreCap_Old";
            dtGaapTab.Columns["Amort"].ColumnName = "Amort_Old";
            dtGaapTab.Columns["GrossDeferredFees"].ColumnName = "GrossDeferredFees_Old";
            dtGaapTab.Columns["CleanCost"].ColumnName = "CleanCost_Old";
            dtGaapTab.Columns["DeferredFeesReceivable"].ColumnName = "DeferredFeesReceivable_Old";
            dtGaapTab.Columns["GAAPIncomeforthePeriod"].ColumnName = "GAAPIncomeforthePeriod_Old";
            dtGaapTab.Columns["AmortofDeferredFees"].ColumnName = "AmortofDeferredFees_Old";
            dtGaapTab.Columns["AmortizedCost"].ColumnName = "AmortizedCost_Old";
            dtGaapTab.Columns["AccumAmortofDeferredFees"].ColumnName = "AccumAmortofDeferredFees_Old";
            dtGaapTab.Columns["EndingGAAPBookValue"].ColumnName = "EndingGAAPBookValue_Old";
            dtGaapTab.Columns["MinPrepaymentAmount"].ColumnName = "MinPrepaymentAmount_Old";
            dtGaapTab.Columns["UnamortizedPortionofOriginationFeePremiumExpenses"].ColumnName = "UnamortizedPortionofOriginationFeePremiumExpenses_Old";
            dtGaapTab.Columns["AdditionalFeesPrepaymentFeesReceived"].ColumnName = "AdditionalFeesPrepaymentFeesReceived_Old";
            dtGaapTab.Columns["CumCouponPIKInterestDailyAccrual"].ColumnName = "CumCouponPIKInterestDailyAccrual_Old";
            dtGaapTab.Columns["ValueCap"].ColumnName = "ValueCap_Old";
            dtGaapTab.Columns["AdjustedBasissubjecttoCap"].ColumnName = "AdjustedBasissubjecttoCap_Old";
            dtGaapTab.Columns["AdjustedLevelYieldIncome"].ColumnName = "AdjustedLevelYieldIncome_Old";
            dtGaapTab.Columns["AdjustedAmort"].ColumnName = "AdjustedAmort_Old";
            dtGaapTab.Columns["AdjustedPeriodicYld"].ColumnName = "AdjustedPeriodicYld_Old";
            dtGaapTab.Columns["CashFlowadjustedforServicingInfo"].ColumnName = "CashFlowadjustedforServicingInfo_Old";
            dtGaapTab.Columns["CostBasis"].ColumnName = "CostBasis_Old";
            dtGaapTab.Columns["TotalPeriodGAAPIncome"].ColumnName = "TotalPeriodGAAPIncome_Old";
            dtGaapTab.Columns["ActualBasis"].ColumnName = "ActualBasis_Old";
            dtGaapTab.Columns["TotalStrippedCashFlow"].ColumnName = "TotalStrippedCashFlow_Old";
            dtGaapTab.Columns["AllInBasis"].ColumnName = "AllInBasis_Old";
            dtGaapTab.Columns["NetPrincipalInflowOutflow"].ColumnName = "NetPrincipalInflowOutflow_Old";
            dtGaapTab.Columns["ParBasis"].ColumnName = "ParBasis_Old";
            dtGaapTab.Columns["DeferredFeeAccrualBasis"].ColumnName = "DeferredFeeAccrualBasis_Old";
            dtGaapTab.Columns["DeferredFeeAccrual"].ColumnName = "DeferredFeeAccrual_Old";
            dtGaapTab.Columns["DiscountPremiumAccrualBasis"].ColumnName = "DiscountPremiumAccrualBasis_Old";
            dtGaapTab.Columns["DiscountPremiumAccrual"].ColumnName = "DiscountPremiumAccrual_Old";
            dtGaapTab.Columns["AccumulatedAmortofDiscountPremium"].ColumnName = "AccumulatedAmortofDiscountPremium_Old";
            dtGaapTab.Columns["CapitalizedCostsAccrualBasis"].ColumnName = "CapitalizedCostsAccrualBasis_Old";
            dtGaapTab.Columns["CapitalizedCostAccrual"].ColumnName = "CapitalizedCostAccrual_Old";
            dtGaapTab.Columns["AccumulatedAmortofCapitalizedCost"].ColumnName = "AccumulatedAmortofCapitalizedCost_Old";
            dtGaapTab.Columns["PVBasis"].ColumnName = "PVBasis_Old";
            dtGaapTab.Columns["CleanCostPrice"].ColumnName = "CleanCostPrice_Old";
            dtGaapTab.Columns["AmortizedCostPrice"].ColumnName = "AmortizedCostPrice_Old";
            dtGaapTab.Columns["ActualYield"].ColumnName = "ActualYield_Old";
            dtGaapTab.Columns["CashFlowusedforLevelYieldAmort"].ColumnName = "CashFlowusedforLevelYieldAmort_Old";

            //add new columns
            dtGaapTab.Columns.Add("Date", typeof(DateTime));
            dtGaapTab.Columns.Add("CashFlowusedforLevelYieldPreCap", typeof(decimal));
            dtGaapTab.Columns.Add("PreCapLevelYield", typeof(decimal));
            dtGaapTab.Columns.Add("LockedPreCapBasis", typeof(decimal));
            dtGaapTab.Columns.Add("PeriodLevelYieldIncomePreCap", typeof(decimal));
            dtGaapTab.Columns.Add("Amort", typeof(decimal));
            dtGaapTab.Columns.Add("GrossDeferredFees", typeof(decimal));
            dtGaapTab.Columns.Add("CleanCost", typeof(decimal));
            dtGaapTab.Columns.Add("DeferredFeesReceivable", typeof(decimal));
            dtGaapTab.Columns.Add("GAAPIncomeforthePeriod", typeof(decimal));
            dtGaapTab.Columns.Add("AmortofDeferredFees", typeof(decimal));
            dtGaapTab.Columns.Add("AmortizedCost", typeof(decimal));
            dtGaapTab.Columns.Add("AccumAmortofDeferredFees", typeof(decimal));
            dtGaapTab.Columns.Add("EndingGAAPBookValue", typeof(decimal));
            dtGaapTab.Columns.Add("MinPrepaymentAmount", typeof(decimal));
            dtGaapTab.Columns.Add("UnamortizedPortionofOriginationFeePremiumExpenses", typeof(decimal));
            dtGaapTab.Columns.Add("AdditionalFeesPrepaymentFeesReceived", typeof(decimal));
            dtGaapTab.Columns.Add("CumCouponPIKInterestDailyAccrual", typeof(decimal));
            dtGaapTab.Columns.Add("ValueCap", typeof(decimal));
            dtGaapTab.Columns.Add("AdjustedBasissubjecttoCap", typeof(decimal));
            dtGaapTab.Columns.Add("AdjustedLevelYieldIncome", typeof(decimal));
            dtGaapTab.Columns.Add("AdjustedAmort", typeof(decimal));
            dtGaapTab.Columns.Add("AdjustedPeriodicYld", typeof(decimal));
            dtGaapTab.Columns.Add("CashFlowadjustedforServicingInfo", typeof(decimal));
            dtGaapTab.Columns.Add("CostBasis", typeof(decimal));
            dtGaapTab.Columns.Add("TotalPeriodGAAPIncome", typeof(decimal));
            dtGaapTab.Columns.Add("ActualBasis", typeof(decimal));
            dtGaapTab.Columns.Add("TotalStrippedCashFlow", typeof(decimal));
            dtGaapTab.Columns.Add("AllInBasis", typeof(decimal));
            dtGaapTab.Columns.Add("NetPrincipalInflowOutflow", typeof(decimal));
            dtGaapTab.Columns.Add("ParBasis", typeof(decimal));
            dtGaapTab.Columns.Add("DeferredFeeAccrualBasis", typeof(decimal));
            dtGaapTab.Columns.Add("DeferredFeeAccrual", typeof(decimal));
            dtGaapTab.Columns.Add("DiscountPremiumAccrualBasis", typeof(decimal));
            dtGaapTab.Columns.Add("DiscountPremiumAccrual", typeof(decimal));
            dtGaapTab.Columns.Add("AccumulatedAmortofDiscountPremium", typeof(decimal));
            dtGaapTab.Columns.Add("CapitalizedCostsAccrualBasis", typeof(decimal));
            dtGaapTab.Columns.Add("CapitalizedCostAccrual", typeof(decimal));
            dtGaapTab.Columns.Add("AccumulatedAmortofCapitalizedCost", typeof(decimal));
            dtGaapTab.Columns.Add("PVBasis", typeof(decimal));
            dtGaapTab.Columns.Add("CleanCostPrice", typeof(decimal));
            dtGaapTab.Columns.Add("AmortizedCostPrice", typeof(decimal));
            dtGaapTab.Columns.Add("ActualYield", typeof(decimal));
            dtGaapTab.Columns.Add("CashFlowusedforLevelYieldAmort", typeof(decimal));

            foreach (DataRow row in dtGaapTab.Rows)
            {
                row["Date"] = CommonHelper.ToDateTime(row["Date_Old"]);
                row["CashFlowusedforLevelYieldPreCap"] = Math.Round(CommonHelper.StringToDecimal(row["CashFlowusedforLevelYieldPreCap_Old"]).GetValueOrDefault(0), 10);
                row["PreCapLevelYield"] = Math.Round(CommonHelper.StringToDecimal(row["PreCapLevelYield_Old"]).GetValueOrDefault(0), 10);
                row["LockedPreCapBasis"] = Math.Round(CommonHelper.StringToDecimal(row["LockedPreCapBasis_Old"]).GetValueOrDefault(0), 10);
                row["PeriodLevelYieldIncomePreCap"] = Math.Round(CommonHelper.StringToDecimal(row["PeriodLevelYieldIncomePreCap_Old"]).GetValueOrDefault(0), 10);
                row["Amort"] = Math.Round(CommonHelper.StringToDecimal(row["Amort_Old"]).GetValueOrDefault(0), 10);
                row["GrossDeferredFees"] = Math.Round(CommonHelper.StringToDecimal(row["GrossDeferredFees_Old"]).GetValueOrDefault(0), 10);
                row["CleanCost"] = Math.Round(CommonHelper.StringToDecimal(row["CleanCost_Old"]).GetValueOrDefault(0), 10);
                row["DeferredFeesReceivable"] = Math.Round(CommonHelper.StringToDecimal(row["DeferredFeesReceivable_Old"]).GetValueOrDefault(0), 10);
                row["GAAPIncomeforthePeriod"] = Math.Round(CommonHelper.StringToDecimal(row["GAAPIncomeforthePeriod_Old"]).GetValueOrDefault(0), 10);
                row["AmortofDeferredFees"] = Math.Round(CommonHelper.StringToDecimal(row["AmortofDeferredFees_Old"]).GetValueOrDefault(0), 10);
                row["AmortizedCost"] = Math.Round(CommonHelper.StringToDecimal(row["AmortizedCost_Old"]).GetValueOrDefault(0), 10);
                row["AccumAmortofDeferredFees"] = Math.Round(CommonHelper.StringToDecimal(row["AccumAmortofDeferredFees_Old"]).GetValueOrDefault(0), 10);
                row["EndingGAAPBookValue"] = Math.Round(CommonHelper.StringToDecimal(row["EndingGAAPBookValue_Old"]).GetValueOrDefault(0), 10);
                row["MinPrepaymentAmount"] = Math.Round(CommonHelper.StringToDecimal(row["MinPrepaymentAmount_Old"]).GetValueOrDefault(0), 10);
                row["UnamortizedPortionofOriginationFeePremiumExpenses"] = Math.Round(CommonHelper.StringToDecimal(row["UnamortizedPortionofOriginationFeePremiumExpenses_Old"]).GetValueOrDefault(0), 10);
                row["AdditionalFeesPrepaymentFeesReceived"] = Math.Round(CommonHelper.StringToDecimal(row["AdditionalFeesPrepaymentFeesReceived_Old"]).GetValueOrDefault(0), 10);
                row["CumCouponPIKInterestDailyAccrual"] = Math.Round(CommonHelper.StringToDecimal(row["CumCouponPIKInterestDailyAccrual_Old"]).GetValueOrDefault(0), 10);
                row["ValueCap"] = Math.Round(CommonHelper.StringToDecimal(row["ValueCap_Old"]).GetValueOrDefault(0), 10);
                row["AdjustedBasissubjecttoCap"] = Math.Round(CommonHelper.StringToDecimal(row["AdjustedBasissubjecttoCap_Old"]).GetValueOrDefault(0), 10);
                row["AdjustedLevelYieldIncome"] = Math.Round(CommonHelper.StringToDecimal(row["AdjustedLevelYieldIncome_Old"]).GetValueOrDefault(0), 10);
                row["AdjustedAmort"] = Math.Round(CommonHelper.StringToDecimal(row["AdjustedAmort_Old"]).GetValueOrDefault(0), 10);
                row["AdjustedPeriodicYld"] = Math.Round(CommonHelper.StringToDecimal(row["AdjustedPeriodicYld_Old"]).GetValueOrDefault(0), 10);
                row["CashFlowadjustedforServicingInfo"] = Math.Round(CommonHelper.StringToDecimal(row["CashFlowadjustedforServicingInfo_Old"]).GetValueOrDefault(0), 10);
                row["CostBasis"] = Math.Round(CommonHelper.StringToDecimal(row["CostBasis_Old"]).GetValueOrDefault(0), 10);
                row["TotalPeriodGAAPIncome"] = Math.Round(CommonHelper.StringToDecimal(row["TotalPeriodGAAPIncome_Old"]).GetValueOrDefault(0), 10);
                row["ActualBasis"] = Math.Round(CommonHelper.StringToDecimal(row["ActualBasis_Old"]).GetValueOrDefault(0), 10);
                row["TotalStrippedCashFlow"] = Math.Round(CommonHelper.StringToDecimal(row["TotalStrippedCashFlow_Old"]).GetValueOrDefault(0), 10);
                row["AllInBasis"] = Math.Round(CommonHelper.StringToDecimal(row["AllInBasis_Old"]).GetValueOrDefault(0), 10);
                row["NetPrincipalInflowOutflow"] = Math.Round(CommonHelper.StringToDecimal(row["NetPrincipalInflowOutflow_Old"]).GetValueOrDefault(0), 10);
                row["ParBasis"] = Math.Round(CommonHelper.StringToDecimal(row["ParBasis_Old"]).GetValueOrDefault(0), 10);
                row["DeferredFeeAccrualBasis"] = Math.Round(CommonHelper.StringToDecimal(row["DeferredFeeAccrualBasis_Old"]).GetValueOrDefault(0), 10);
                row["DeferredFeeAccrual"] = Math.Round(CommonHelper.StringToDecimal(row["DeferredFeeAccrual_Old"]).GetValueOrDefault(0), 10);
                row["DiscountPremiumAccrualBasis"] = Math.Round(CommonHelper.StringToDecimal(row["DiscountPremiumAccrualBasis_Old"]).GetValueOrDefault(0), 10);
                row["DiscountPremiumAccrual"] = Math.Round(CommonHelper.StringToDecimal(row["DiscountPremiumAccrual_Old"]).GetValueOrDefault(0), 10);
                row["AccumulatedAmortofDiscountPremium"] = Math.Round(CommonHelper.StringToDecimal(row["AccumulatedAmortofDiscountPremium_Old"]).GetValueOrDefault(0), 10);
                row["CapitalizedCostsAccrualBasis"] = Math.Round(CommonHelper.StringToDecimal(row["CapitalizedCostsAccrualBasis_Old"]).GetValueOrDefault(0), 10);
                row["CapitalizedCostAccrual"] = Math.Round(CommonHelper.StringToDecimal(row["CapitalizedCostAccrual_Old"]).GetValueOrDefault(0), 10);
                row["AccumulatedAmortofCapitalizedCost"] = Math.Round(CommonHelper.StringToDecimal(row["AccumulatedAmortofCapitalizedCost_Old"]).GetValueOrDefault(0), 10);
                row["PVBasis"] = Math.Round(CommonHelper.StringToDecimal(row["PVBasis_Old"]).GetValueOrDefault(0), 10);
                row["CleanCostPrice"] = Math.Round(CommonHelper.StringToDecimal(row["CleanCostPrice_Old"]).GetValueOrDefault(0), 10);
                row["AmortizedCostPrice"] = Math.Round(CommonHelper.StringToDecimal(row["AmortizedCostPrice_Old"]).GetValueOrDefault(0), 10);
                row["ActualYield"] = Math.Round(CommonHelper.StringToDecimal(row["ActualYield_Old"]).GetValueOrDefault(0), 10);
                row["CashFlowusedforLevelYieldAmort"] = Math.Round(CommonHelper.StringToDecimal(row["CashFlowusedforLevelYieldAmort_Old"]).GetValueOrDefault(0), 10);

            }
            dtGaapTab.Columns.Remove("Date_Old");
            dtGaapTab.Columns.Remove("CashFlowusedforLevelYieldPreCap_Old");
            dtGaapTab.Columns.Remove("PreCapLevelYield_Old");
            dtGaapTab.Columns.Remove("LockedPreCapBasis_Old");
            dtGaapTab.Columns.Remove("PeriodLevelYieldIncomePreCap_Old");
            dtGaapTab.Columns.Remove("Amort_Old");
            dtGaapTab.Columns.Remove("GrossDeferredFees_Old");
            dtGaapTab.Columns.Remove("CleanCost_Old");
            dtGaapTab.Columns.Remove("DeferredFeesReceivable_Old");
            dtGaapTab.Columns.Remove("GAAPIncomeforthePeriod_Old");
            dtGaapTab.Columns.Remove("AmortofDeferredFees_Old");
            dtGaapTab.Columns.Remove("AmortizedCost_Old");
            dtGaapTab.Columns.Remove("AccumAmortofDeferredFees_Old");
            dtGaapTab.Columns.Remove("EndingGAAPBookValue_Old");
            dtGaapTab.Columns.Remove("MinPrepaymentAmount_Old");
            dtGaapTab.Columns.Remove("UnamortizedPortionofOriginationFeePremiumExpenses_Old");
            dtGaapTab.Columns.Remove("AdditionalFeesPrepaymentFeesReceived_Old");
            dtGaapTab.Columns.Remove("CumCouponPIKInterestDailyAccrual_Old");
            dtGaapTab.Columns.Remove("ValueCap_Old");
            dtGaapTab.Columns.Remove("AdjustedBasissubjecttoCap_Old");
            dtGaapTab.Columns.Remove("AdjustedLevelYieldIncome_Old");
            dtGaapTab.Columns.Remove("AdjustedAmort_Old");
            dtGaapTab.Columns.Remove("AdjustedPeriodicYld_Old");
            dtGaapTab.Columns.Remove("CashFlowadjustedforServicingInfo_Old");
            dtGaapTab.Columns.Remove("CostBasis_Old");
            dtGaapTab.Columns.Remove("TotalPeriodGAAPIncome_Old");
            dtGaapTab.Columns.Remove("ActualBasis_Old");
            dtGaapTab.Columns.Remove("TotalStrippedCashFlow_Old");
            dtGaapTab.Columns.Remove("AllInBasis_Old");
            dtGaapTab.Columns.Remove("NetPrincipalInflowOutflow_Old");
            dtGaapTab.Columns.Remove("ParBasis_Old");
            dtGaapTab.Columns.Remove("DeferredFeeAccrualBasis_Old");
            dtGaapTab.Columns.Remove("DeferredFeeAccrual_Old");
            dtGaapTab.Columns.Remove("DiscountPremiumAccrualBasis_Old");
            dtGaapTab.Columns.Remove("DiscountPremiumAccrual_Old");
            dtGaapTab.Columns.Remove("AccumulatedAmortofDiscountPremium_Old");
            dtGaapTab.Columns.Remove("CapitalizedCostsAccrualBasis_Old");
            dtGaapTab.Columns.Remove("CapitalizedCostAccrual_Old");
            dtGaapTab.Columns.Remove("AccumulatedAmortofCapitalizedCost_Old");
            dtGaapTab.Columns.Remove("PVBasis_Old");
            dtGaapTab.Columns.Remove("CleanCostPrice_Old");
            dtGaapTab.Columns.Remove("AmortizedCostPrice_Old");
            dtGaapTab.Columns.Remove("ActualYield_Old");
            dtGaapTab.Columns.Remove("CashFlowusedforLevelYieldAmort_Old");

            return dtGaapTab;
        }
        public DataTable FormatFutureFundingScheduleData(DataTable dtFundingTab)
        {

            dtFundingTab.Columns["NoteID"].ColumnName = "NoteID_Old";
            dtFundingTab.Columns["CRENotedID"].ColumnName = "CRENotedID_Old";
            dtFundingTab.Columns["AccountID"].ColumnName = "AccountID_Old";
            dtFundingTab.Columns["Date"].ColumnName = "Date_Old";
            dtFundingTab.Columns["Value"].ColumnName = "Value_Old";
            dtFundingTab.Columns["Event_Date"].ColumnName = "Event_Date_Old";
            dtFundingTab.Columns["EffectiveDate"].ColumnName = "EffectiveDate_Old";
            dtFundingTab.Columns["EffectiveEndDate"].ColumnName = "EffectiveEndDate_Old";
            dtFundingTab.Columns["EventTypeID"].ColumnName = "EventTypeID_Old";
            dtFundingTab.Columns["EventTypeText"].ColumnName = "EventTypeText_Old";
            dtFundingTab.Columns["EventId"].ColumnName = "EventId_Old";
            dtFundingTab.Columns["CreatedBy"].ColumnName = "CreatedBy_Old";
            dtFundingTab.Columns["CreatedDate"].ColumnName = "CreatedDate_Old";
            dtFundingTab.Columns["UpdatedBy"].ColumnName = "UpdatedBy_Old";
            dtFundingTab.Columns["UpdatedDate"].ColumnName = "UpdatedDate_Old";
            dtFundingTab.Columns["ModuleId"].ColumnName = "ModuleId_Old";
            dtFundingTab.Columns["ScheduleID"].ColumnName = "ScheduleID_Old";
            dtFundingTab.Columns["PurposeID"].ColumnName = "PurposeID_Old";
            dtFundingTab.Columns["PurposeText"].ColumnName = "PurposeText_Old";
            dtFundingTab.Columns["Applied"].ColumnName = "Applied_Old";
            dtFundingTab.Columns["Issaved"].ColumnName = "Issaved_Old";
            dtFundingTab.Columns["DrawFundingId"].ColumnName = "DrawFundingId_Old";
            dtFundingTab.Columns["Comments"].ColumnName = "Comments_Old";
            dtFundingTab.Columns["orgDate"].ColumnName = "orgDate_Old";
            dtFundingTab.Columns["orgValue"].ColumnName = "orgValue_Old";
            dtFundingTab.Columns["orgPurposeID"].ColumnName = "orgPurposeID_Old";
            dtFundingTab.Columns["OrgPurposeText"].ColumnName = "OrgPurposeText_Old";
            dtFundingTab.Columns["OrgApplied"].ColumnName = "OrgApplied_Old";


            //add new columns
            dtFundingTab.Columns.Add("NoteID", typeof(decimal));
            dtFundingTab.Columns.Add("CRENotedID", typeof(decimal));
            dtFundingTab.Columns.Add("AccountID", typeof(decimal));
            dtFundingTab.Columns.Add("EffectiveDate", typeof(DateTime));
            dtFundingTab.Columns.Add("Date", typeof(DateTime));
            dtFundingTab.Columns.Add("Value", typeof(decimal));
            dtFundingTab.Columns.Add("Event_Date", typeof(decimal));
            dtFundingTab.Columns.Add("EffectiveEndDate", typeof(decimal));
            dtFundingTab.Columns.Add("EventTypeID", typeof(decimal));
            dtFundingTab.Columns.Add("EventTypeText", typeof(decimal));
            dtFundingTab.Columns.Add("EventId", typeof(decimal));
            dtFundingTab.Columns.Add("CreatedBy", typeof(decimal));
            dtFundingTab.Columns.Add("CreatedDate", typeof(decimal));
            dtFundingTab.Columns.Add("UpdatedBy", typeof(decimal));
            dtFundingTab.Columns.Add("UpdatedDate", typeof(decimal));
            dtFundingTab.Columns.Add("ModuleId", typeof(decimal));
            dtFundingTab.Columns.Add("ScheduleID", typeof(decimal));
            dtFundingTab.Columns.Add("PurposeID", typeof(decimal));
            dtFundingTab.Columns.Add("PurposeText", typeof(string));
            dtFundingTab.Columns.Add("Applied", typeof(decimal));
            dtFundingTab.Columns.Add("Issaved", typeof(decimal));
            dtFundingTab.Columns.Add("DrawFundingId", typeof(decimal));
            dtFundingTab.Columns.Add("Comments", typeof(string));
            dtFundingTab.Columns.Add("orgDate", typeof(decimal));
            dtFundingTab.Columns.Add("orgValue", typeof(decimal));
            dtFundingTab.Columns.Add("orgPurposeID", typeof(decimal));
            dtFundingTab.Columns.Add("OrgPurposeText", typeof(decimal));
            dtFundingTab.Columns.Add("OrgApplied", typeof(decimal));

            foreach (DataRow row in dtFundingTab.Rows)
            {
                row["Date"] = CommonHelper.ToDateTime(row["Date_Old"]);
                row["Value"] = Math.Round(CommonHelper.StringToDecimal(row["Value_Old"]).GetValueOrDefault(0), 10);

                row["EffectiveDate"] = CommonHelper.ToDateTime(row["EffectiveDate_Old"]);
                row["PurposeText"] = row["PurposeText_Old"].ToString();
                row["Comments"] = row["Comments_Old"].ToString();
            }

            dtFundingTab.Columns.Remove("NoteID_Old");
            dtFundingTab.Columns.Remove("CRENotedID_Old");
            dtFundingTab.Columns.Remove("AccountID_Old");
            dtFundingTab.Columns.Remove("Date_Old");
            dtFundingTab.Columns.Remove("Value_Old");
            dtFundingTab.Columns.Remove("Event_Date_Old");
            dtFundingTab.Columns.Remove("EffectiveDate_Old");
            dtFundingTab.Columns.Remove("EffectiveEndDate_Old");
            dtFundingTab.Columns.Remove("EventTypeID_Old");
            dtFundingTab.Columns.Remove("EventTypeText_Old");
            dtFundingTab.Columns.Remove("EventId_Old");
            dtFundingTab.Columns.Remove("CreatedBy_Old");
            dtFundingTab.Columns.Remove("CreatedDate_Old");
            dtFundingTab.Columns.Remove("UpdatedBy_Old");
            dtFundingTab.Columns.Remove("UpdatedDate_Old");
            dtFundingTab.Columns.Remove("ModuleId_Old");
            dtFundingTab.Columns.Remove("ScheduleID_Old");
            dtFundingTab.Columns.Remove("PurposeID_Old");
            dtFundingTab.Columns.Remove("PurposeText_Old");
            dtFundingTab.Columns.Remove("Applied_Old");
            dtFundingTab.Columns.Remove("Issaved_Old");
            dtFundingTab.Columns.Remove("DrawFundingId_Old");
            dtFundingTab.Columns.Remove("Comments_Old");
            dtFundingTab.Columns.Remove("orgDate_Old");
            dtFundingTab.Columns.Remove("orgValue_Old");
            dtFundingTab.Columns.Remove("orgPurposeID_Old");
            dtFundingTab.Columns.Remove("OrgPurposeText_Old");
            dtFundingTab.Columns.Remove("OrgApplied_Old");

            dtFundingTab.Columns.Remove("NoteID");
            dtFundingTab.Columns.Remove("CRENotedID");
            dtFundingTab.Columns.Remove("AccountID");

            dtFundingTab.Columns.Remove("Event_Date");
            dtFundingTab.Columns.Remove("EffectiveEndDate");
            dtFundingTab.Columns.Remove("EventTypeID");
            dtFundingTab.Columns.Remove("EventTypeText");
            dtFundingTab.Columns.Remove("EventId");
            dtFundingTab.Columns.Remove("CreatedBy");
            dtFundingTab.Columns.Remove("CreatedDate");
            dtFundingTab.Columns.Remove("UpdatedBy");
            dtFundingTab.Columns.Remove("UpdatedDate");
            dtFundingTab.Columns.Remove("ModuleId");
            dtFundingTab.Columns.Remove("ScheduleID");
            dtFundingTab.Columns.Remove("PurposeID");
            dtFundingTab.Columns.Remove("Applied");
            dtFundingTab.Columns.Remove("Issaved");
            dtFundingTab.Columns.Remove("DrawFundingId");
            dtFundingTab.Columns.Remove("orgDate");
            dtFundingTab.Columns.Remove("orgValue");
            dtFundingTab.Columns.Remove("orgPurposeID");
            dtFundingTab.Columns.Remove("OrgPurposeText");
            dtFundingTab.Columns.Remove("OrgApplied");

            return dtFundingTab;

        }

    }
}
