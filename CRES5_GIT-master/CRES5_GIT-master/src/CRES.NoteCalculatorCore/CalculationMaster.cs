using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;

namespace CRES.NoteCalculator
{
    // This project can output the Class library as a NuGet Package .
    // To enable this option, right-click on the project and select the Properties menu item. In the Build tab select "Produce outputs on build".
    public class CalculationMaster
    {
        #region Property

        private string CalculationTimeLog = "";
#pragma warning disable CS0414 // The field 'CalculationMaster.notetype' is assigned but its value is never used
        private string notetype = "";
#pragma warning restore CS0414 // The field 'CalculationMaster.notetype' is assigned but its value is never used
        private NoteDataContract noteDC = new NoteDataContract();
        private List<DateTime> cDailyDates = new List<DateTime>();
        public List<RateTab> ListRateTab = new List<RateTab>();
        public List<FeesTab> ListFeesTab = new List<FeesTab>();
        public List<DatesTab> ListDatesTab = new List<DatesTab>();
        private List<UniqueDatesForCalcEngine> uniqueDateListFull = new List<UniqueDatesForCalcEngine>();
        private List<UniqueDatesForCalcEngine> uniqueDateList = new List<UniqueDatesForCalcEngine>();
        public List<BalanceTab> ListBalanceTab = new List<BalanceTab>();
        public List<CouponTab> ListCouponTab = new List<CouponTab>();
        public List<PIKInterestTab> ListPIKInterestTab = new List<PIKInterestTab>();
        public List<FinancingTab> ListFinancingTab = new List<FinancingTab>();
        public List<FinancingDrawsTab> ListFinancingDrawsTab = new List<FinancingDrawsTab>();
        private List<FutureFundingScheduleTab> ListFutureFundingScheduleTabLatest = new List<FutureFundingScheduleTab>();
        private List<PIKfromPIKSourceNoteTab> ListPIKfromPIKSourceNoteTabLatest = new List<PIKfromPIKSourceNoteTab>();
        private List<PIKSchedule> ListNotePIKScheduleLatest = new List<PIKSchedule>();
        private List<PrepayAndAdditionalFeeScheduleDataContract> ListNotePrepayAndAdditionalFeeScheduleLatest = new List<PrepayAndAdditionalFeeScheduleDataContract>();
        private List<FeeCouponStripReceivableTab> ListFeeCouponStripReceivableLatest = new List<FeeCouponStripReceivableTab>();
        public List<Transaction> ListTransaction = new List<Transaction>();
        public List<HolidayListDataContract> ListHoliday = new List<HolidayListDataContract>();
        public List<int> ListRemIoTerm = new List<int>();
        private List<LiborScheduleTab> ListLiborScheduleTabLatest = new List<LiborScheduleTab>();
        private List<InterestCalculatorDataContract> ListInterestCalculator = new List<InterestCalculatorDataContract>();
        private List<FixedAmortScheduleTab> ListFixedAmortScheduleTabLatest = new List<FixedAmortScheduleTab>();
        public List<GAAPBasisTab> ListGAAPBasisTab = new List<GAAPBasisTab>();
        public List<PVBasisTab> ListPVBasisTab = new List<PVBasisTab>();
        public List<SLBasisTab> ListSLBasisTab = new List<SLBasisTab>();
        private List<OutputArrayTab> ListOutputArrayTab = new List<OutputArrayTab>();
        private List<NotePeriodicOutputsDataContract> ListNotePeriodicOutputs = new List<NotePeriodicOutputsDataContract>();
        private List<NotePeriodicOutputsDataContract> ListTrailingBalance = new List<NotePeriodicOutputsDataContract>();
        private List<NotePeriodicOutputsDataContract> ListSpreadandLibor = new List<NotePeriodicOutputsDataContract>();
        private List<NotePeriodicOutputsDataContract> Listbalpvgaap = new List<NotePeriodicOutputsDataContract>();
        private List<InterestAccrualDates> ListInterestAccrualDates = new List<InterestAccrualDates>();
        private List<CustomFeeScheduleDataContract> CustomFunctionFees = new List<CustomFeeScheduleDataContract>();
        private List<CustomFeeScheduleDataContract> PaymentDateFees = new List<CustomFeeScheduleDataContract>();
        private List<CustomFeeScheduleDataContract> DateSpecificFees = new List<CustomFeeScheduleDataContract>();
        private List<CustomFeeScheduleDataContract> TransactionBasedFees = new List<CustomFeeScheduleDataContract>();
        private List<DailyAccrualCustomFeeDataContract> DailyAccrualCustomFee = new List<DailyAccrualCustomFeeDataContract>();
        private List<CustomFeeScheduleDataContract> LatestPaymentDateFees = new List<CustomFeeScheduleDataContract>();
        private List<CustomFeeScheduleDataContract> LatestDateSpecificFees = new List<CustomFeeScheduleDataContract>();
        private List<CustomFeeScheduleDataContract> LatestTransactionBasedFees = new List<CustomFeeScheduleDataContract>();
        private List<RateSpreadSchedule> ListRateSpreadScheduleLatest = new List<RateSpreadSchedule>();
        private List<FeeOutputDataContract> ListFeeOutput = new List<FeeOutputDataContract>();
        private List<PIKInterestOverrideDataContract> ListPIKInterestOverride = new List<PIKInterestOverrideDataContract>();
        private List<CalculatorTimeAnalysis> ListCalculatorTime = new List<CalculatorTimeAnalysis>();
        private CalculationTrace trace = new CalculationTrace();
        private CalcBasis calcbasis = new CalcBasis();
        private List<YieldDataContract> ListYields = new List<YieldDataContract>();
        private List<YieldCalcInputDataContract> ListYieldCalcInput = new List<YieldCalcInputDataContract>();

        private List<DailyGAAPBasisComponentsDataContract> ListDailyGAAPBasisComponents = new List<DailyGAAPBasisComponentsDataContract>();


        private List<DateTime> AllNPVdate = new List<DateTime>();
        private List<Decimal> AllNPVvalue = new List<Decimal>();
        private List<Decimal> AllNPVnetFeeValue = new List<Decimal>();
        private List<Decimal> AllNPVactual = new List<Decimal>();

        private Decimal? FinancingPeriodLeveredYield = 0;
        private decimal stubint = 0;
#pragma warning disable CS0414 // The field 'CalculationMaster.StubInterestAmountCalc' is assigned but its value is never used
        private decimal? StubInterestAmount = 0, StubInterestAmountCalc = 0, PurchasedStubInterest = 0, PurchasedStubInterestCalc = 0;
#pragma warning restore CS0414 // The field 'CalculationMaster.StubInterestAmountCalc' is assigned but its value is never used
#pragma warning disable CS0649 // Field 'CalculationMaster.LoanPurchaseAccuralStartDate' is never assigned to, and will always have its default value
#pragma warning disable CS0169 // The field 'CalculationMaster.NonAdjustedSelectedMaturity' is never used
        private DateTime EffectveFirstCouponAccrualStartDate, LoanPurchaseAccuralStartDate, NonAdjustedSelectedMaturity;
#pragma warning restore CS0169 // The field 'CalculationMaster.NonAdjustedSelectedMaturity' is never used
#pragma warning restore CS0649 // Field 'CalculationMaster.LoanPurchaseAccuralStartDate' is never assigned to, and will always have its default value
        private DateTime? AccrualDate = DateTime.MinValue;
        private int FirstAccDayCount = 0, StubDayCount = 0, PurchasedAccDayCount = 0;
        private bool calulateTab = false, checkEffectiveDateCondition = false;
        private DateTime? prevAccEndDate, accEndDate, stubEndDate, firstPeriodStart;
        private decimal? CumCompPik, CumPikInt, CumPikAccrual, CumPikRelated;
        private decimal? initialFullMoInt = 0;
#pragma warning disable CS0414 // The field 'CalculationMaster.pmtdroptag' is assigned but its value is never used
        private int pmtdroptag = 0;
#pragma warning restore CS0414 // The field 'CalculationMaster.pmtdroptag' is assigned but its value is never used
        private int PIKIntCalcMethodOnHolidays = 0;
        string DisableBusinessDayAdjustmentText = "";

        DateTime? SelectedMaturityDateLatest;
        DateTime? SelectedMaturityDateLatestNotBusDayAdjusted;
        #endregion Property

        public NoteDataContract StartCalculation(NoteDataContract noteobject)
        {
            NoteDataContract resultNoteDC = new NoteDataContract();

            try
            {
                noteDC = noteobject;
                noteDC.LiborDataAsofDate = new DateTime(2016, 01, 01);
                //determine  AccrualDate
                if (noteDC.DefaultScenarioParameters.DisableBusinessDayAdjustmentText != null)
                {
                    DisableBusinessDayAdjustmentText = noteDC.DefaultScenarioParameters.DisableBusinessDayAdjustmentText;
                }

                if (noteDC.ListHistoricalAccrual != null)
                {
                    if (noteDC.ListHistoricalAccrual.Count > 0)
                    {
                        AccrualDate = noteDC.ListHistoricalAccrual.Max(x => x.PeriodDate);
                        noteDC.AcctgCloseDate = AccrualDate;
                    }
                    else
                    {
                        AccrualDate = noteDC.AcctgCloseDate;
                    }
                }
                else
                {
                    AccrualDate = noteDC.AcctgCloseDate;
                }

                if (Convert.ToDateTime(noteDC.ClosingDate) != DateTime.MinValue)
                {
                    CashFlowEngineStart();
                    if (checkEffectiveDateCondition == true)
                    {
                        noteDC.ListNotePeriodicOutputs = ListNotePeriodicOutputs;
                        noteDC.ListPIKInterestTab = ListPIKInterestTab;
                        noteDC.ListNotePeriodicOutput_Daily = ListTrailingBalance;
                        noteDC.ListNotePeriodicOutput_PVAndGaap = Listbalpvgaap;
                        noteDC.ListNotePeriodicOutput_SpreadAndLibor = ListSpreadandLibor;
                        noteDC.ListInterestCalculator = ListInterestCalculator;
                        noteDC.ListNotePeriodicOutput_SpreadAndLibor = ListSpreadandLibor;
                        noteDC.ListYieldCalcInput = ListYieldCalcInput;
                        noteDC.ListDailyGAAPBasisComponents = ListDailyGAAPBasisComponents;

                        if (noteDC.EnableDebug == true)
                        {
                            CalculatorDebugData obj = new CalculatorDebugData();
                            noteDC.CalculatorDebugData = obj;
                            noteDC.CalculatorDebugData.AnalysisID = noteDC.AnalysisID;
                            noteDC.CalculatorDebugData.NoteId = noteDC.NoteId;
                            noteDC.CalculatorDebugData.NoteName = noteDC.Name;
                            noteDC.CalculatorDebugData.CRENoteID = noteDC.CRENoteID;
                            noteDC.CalculatorDebugData.ListNotePeriodicOutput = noteDC.ListNotePeriodicOutputs;
                            noteDC.CalculatorDebugData.ListPIKInterestTab = ListPIKInterestTab;
                            noteDC.CalculatorDebugData.ListBalanceTab = ListBalanceTab;
                            noteDC.CalculatorDebugData.ListCouponTab = ListCouponTab;
                            noteDC.CalculatorDebugData.ListFinancingTab = ListFinancingTab;
                            noteDC.CalculatorDebugData.ListRateTab = ListRateTab;
                            noteDC.CalculatorDebugData.ListFeesTab = ListFeesTab;
                            noteDC.CalculatorDebugData.ListDatesTab = ListDatesTab;
                            noteDC.CalculatorDebugData.ListGAAPBasisTab = ListGAAPBasisTab;
                            noteDC.CalculatorDebugData.ListFeeOutput = ListFeeOutput;
                            noteDC.CalculatorDebugData.ListFutureFundingScheduleTab = noteDC.ListFutureFundingScheduleTab;
                            noteDC.CalculatorDebugData.MaturityScenariosList = noteDC.MaturityScenariosList;
                        }

                        resultNoteDC = noteDC;
                        resultNoteDC.CalculatorExceptionMessage = "Succeed";
                    }
                    else
                    {
                        resultNoteDC.CalculatorExceptionMessage = "Cannot calculate note as none of effective date is equal to closing date ";
                    }
                }
                else
                {
                    resultNoteDC.CalculatorExceptionMessage = "Cannot calculate with empty closing date ";
                }
            }
            catch (Exception ex)
            {
                resultNoteDC.CalculatorExceptionMessage = "Calculation failed due to- " + System.Environment.NewLine + "" + ex.Message;
                resultNoteDC.CalculatorstackTrace = "Calculation Error Message:" + ex.Message + ". Stack Trace:" + noteobject.CRENoteID + " : " + ex.StackTrace;
            }
            finally
            {
#if (DEBUG)
                //WriteTestDataToCSV();
#endif
            }
            return resultNoteDC;
        }

        public void CashFlowEngineStart()
        {
            AddTimeToList("CashFlowEngineStart", "Started", DateTime.MinValue);

            foreach (RateSpreadSchedule rss in noteDC.RateSpreadScheduleList)
            {
                if (rss.ValueTypeText == "Rate")
                {
                    notetype = "Flat Rate note";
                    break;
                }
            }
            ListHoliday = noteDC.ListHoliday;
            if (noteDC.MaturityScenariosList != null && noteDC.MaturityScenariosList.Count > 0)
            {
                DateTime? effectDate = noteDC.MaturityScenariosList.Min(mat => mat.EffectiveDate);
                SelectedMaturityDateLatestNotBusDayAdjusted = noteDC.MaturityScenariosList.Where(mat => mat.EffectiveDate == effectDate).ToList()[0].SelectedMaturityDate;
                SelectedMaturityDateLatest = GetWorkingDayUsingOffset(Convert.ToDateTime(SelectedMaturityDateLatestNotBusDayAdjusted.Value.AddDays(1)), Convert.ToInt16(noteDC.PaymentDateBusinessDayLag), "");
            }
            else
                SelectedMaturityDateLatest = GetWorkingDayUsingOffset(Convert.ToDateTime(noteDC.SelectedMaturityDate.Value.AddDays(1)), Convert.ToInt16(noteDC.PaymentDateBusinessDayLag), "");



            PopulateLoanFeeSchedules();
            GetUniqueDates(noteDC);
            CollectPIKInterestOverrides();
            //Check where any schedule equals to closing  or not for avoiding suitation of infinite loop
            if (uniqueDateList[0].UniqueDate == noteDC.ClosingDate)
                checkEffectiveDateCondition = true;
            if (checkEffectiveDateCondition == true)
            {
                RunProspAcctg();
            }
            AddTimeToList("CashFlowEngineStart", "Ended", DateTime.MinValue);
        }

        public void GetUniqueDates(NoteDataContract note)
        {
            AddTimeToList("GetUniqueDates", "Started", DateTime.MinValue);
            CollectDates();
            CalculateDatesTab(noteDC.ClosingDate, SelectedMaturityDateLatest);
            if (note.EffectiveDateList != null)
            {
                //'Future Funding Schedule
                CalculateUniqueDates(note.EffectiveDateList.Where(c => c.Type == "FFScheduleTab"), "EffectiveDate", "FFScheduleTab");
                //'PIKScheduleTab
                CalculateUniqueDates(note.EffectiveDateList.Where(c => c.Type == "PIKScheduleTab"), "EffectiveDate", "PIKScheduleTab");
                //'LIBORScheduleTab
                if (noteDC.CalculationModeText == "CF + PV Basis (Inception)")
                {
                    foreach (DatesTab dt in ListDatesTab)
                    {
                        if (dt.FloatingRateIndexReferenceDateAdjustedforResetFrequency <= noteDC.AcctgCloseDate)
                        {
                            UniqueDatesForCalcEngine uniqueDate = new UniqueDatesForCalcEngine();

                            var index = uniqueDateListFull.FindIndex(item => item.UniqueDate == noteDC.AcctgCloseDate);
                            if (index != -1)
                            {
                                uniqueDateListFull.Where(checkDate => checkDate.UniqueDate == noteDC.AcctgCloseDate).ToList().ForEach(checkValue => checkValue.GetType().GetProperty("LIBORScheduleTab").SetValue(checkValue, true));
                            }
                            else
                            {
                                uniqueDate.UniqueDate = dt.FloatingRateIndexReferenceDateAdjustedforResetFrequency;
                                uniqueDate.LIBORScheduleTab = true;
                                uniqueDateListFull.Add(uniqueDate);
                            }
                        }
                    }
                }
                else
                {
                    CalculateUniqueDates(note.EffectiveDateList.Where(c => c.Type == "LIBORScheduleTab"), "EffectiveDate", "LIBORScheduleTab");
                }
                //CalculateUniqueDates(note.EffectiveDateList.Where(c => c.Type == "LIBORScheduleTab"), "EffectiveDate", "LIBORScheduleTab");
                //'AmortScheduleTab
                CalculateUniqueDates(note.EffectiveDateList.Where(c => c.Type == "AmortScheduleTab"), "EffectiveDate", "AmortScheduleTab");
                //'ServicingLogTab
                CalculateUniqueDates(note.EffectiveDateList.Where(c => c.Type == "ServicingLogTab"), "EffectiveDate", "ServicingLogTab");
            }
            //RateSpreadScheduleList
            CalculateUniqueDates(note.RateSpreadScheduleList, "EffectiveDate", "RateSpreadSchedule");
            //PIK
            CalculateUniqueDates(note.NotePIKScheduleList, "EffectiveDate", "PIK");
            //PrepayAdditionalFeesSchedule
            CalculateUniqueDates(note.NotePrepayAndAdditionalFeeScheduleList, "EffectiveDate", "PrepayAdditionalFeesSchedule");
            //SelectedMaturityDate
            CalculateUniqueDates(note.MaturityScenariosList, "EffectiveDate", "SelectedMaturityDate");
            //FeeCouponStripping
            CalculateUniqueDates(note.NoteStrippingList, "EffectiveDate", "FeeCouponStripping");
            //Modify list as per closing date uiqueDateList
            uniqueDateList = uniqueDateListFull.Where(checkDate => checkDate.UniqueDate >= noteDC.ClosingDate).ToList();

            //remove effective which is greater than the latest Maturity Date in Maturity Scenario List
            var MaxMaturityDate = (from chk in noteDC.MaturityScenariosList
                                   select chk.SelectedMaturityDate).Max();
            uniqueDateList = uniqueDateList.FindAll(x => x.UniqueDate <= MaxMaturityDate || x.SelectedMaturityDate.GetValueOrDefault(false)).ToList();
            //EffDateSort   Equivalent
            uniqueDateList = uniqueDateList.OrderBy(x => x.UniqueDate).ToList();

            AddTimeToList("GetUniqueDates", "Ended", DateTime.MinValue);
        }

        public void RunProspAcctg()
        {
            AddTimeToList("RunProspAcctg", "Started", DateTime.MinValue);

            string calculationMode = "";
            calculationMode = noteDC.CalculationModeText;
            PopulateTabDates();
            //Copy Latest date in schedules
            DateTime? effectDate = Convert.ToDateTime(uniqueDateList[0].UniqueDate);
            // DateTime? effectDate = noteDC.ListFutureFundingScheduleTab.Min(ff => ff.EffectiveDate);
            ListLiborScheduleTabLatest = noteDC.ListLiborScheduleTab.Where(ff => ff.EffectiveDate == effectDate).ToList();
            if (calculationMode == "CF + GAAP Basis (Prospective)" || calculationMode == "Full Mode (Prospective)" || calculationMode == "CF + PV Basis (Prospective)")
            {
                GetProspectiveModeSchedules(effectDate);
            }
            else
            {
                ListFutureFundingScheduleTabLatest = noteDC.ListFutureFundingScheduleTab.Where(ff => ff.EffectiveDate == effectDate).ToList();
                effectDate = noteDC.ListFixedAmortScheduleTab.Min(ff => ff.EffectiveDate);
                ListFixedAmortScheduleTabLatest = noteDC.ListFixedAmortScheduleTab.Where(ff => ff.EffectiveDate == effectDate).ToList();
                effectDate = noteDC.ListPIKfromPIKSourceNoteTab.Min(ff => ff.EffectiveDate);
                ListPIKfromPIKSourceNoteTabLatest = noteDC.ListPIKfromPIKSourceNoteTab.Where(ff => ff.EffectiveDate == effectDate).ToList();
                if (noteDC.RateSpreadScheduleList != null)
                {
                    effectDate = noteDC.RateSpreadScheduleList.Min(ff => ff.EffectiveDate);
                    ListRateSpreadScheduleLatest = noteDC.RateSpreadScheduleList.Where(ff => ff.EffectiveDate == effectDate).ToList();
                }
                if (noteDC.NotePrepayAndAdditionalFeeScheduleList != null)
                {
                    effectDate = noteDC.NotePrepayAndAdditionalFeeScheduleList.Min(ff => ff.EffectiveDate);
                    ListNotePrepayAndAdditionalFeeScheduleLatest = noteDC.NotePrepayAndAdditionalFeeScheduleList.Where(ff => ff.EffectiveDate == effectDate).ToList();
                }
                if (noteDC.ListFeeCouponStripReceivable != null && noteDC.ListFeeCouponStripReceivable.Count > 0)
                {
                    effectDate = noteDC.ListFeeCouponStripReceivable.Min(ff => ff.EffectiveDate);
                    ListFeeCouponStripReceivableLatest = noteDC.ListFeeCouponStripReceivable.Where(ff => ff.EffectiveDate == effectDate).ToList();
                }
                if (noteDC.NotePIKScheduleList != null && noteDC.NotePIKScheduleList.Count > 0)
                {
                    if (noteDC.NotePIKScheduleList.Min(ff => ff.EffectiveDate) == noteDC.ClosingDate)
                        ListNotePIKScheduleLatest = noteDC.NotePIKScheduleList.Where(ff => ff.EffectiveDate == noteDC.ClosingDate).ToList();
                }
            }
            RunNoteCalculation(Convert.ToDateTime(uniqueDateList[0].UniqueDate));
            switch (calculationMode)
            {
                case "Cash Flow Only":
                    CalculateGapBasisTab(calculationMode);
                    break;

                case "CF + GAAP Basis (Prospective)":
                case "CF + GAAP Basis (Inception)":
                    CalculateGapBasisTab(calculationMode);
                    break;

                case "CF + PV Basis (Prospective)":
                case "CF + PV Basis (Inception)":
                    CalculateGapBasisTab(calculationMode);
                    CalculatePVBasis(calculationMode);
                    break;

                case "Full Mode (Prospective)":
                    CalculateGapBasisTab("CF + GAAP Basis (Prospective)");
                    CalculatePVBasis("CF + PV Basis (Prospective)");
                    break;

                case "Full Mode (Inception)":
                    CalculateGapBasisTab("CF + GAAP Basis (Inception)");
                    CalculatePVBasis("CF + PV Basis (Inception)");
                    break;
            }
            AddTimeToList("GeneratePeriodOutput", "Started", DateTime.MinValue);
            GeneratePeriodOutput();
            AddTimeToList("GeneratePeriodOutput", "Ended", DateTime.MinValue);

            CalcPeriodWal();
            AddTimeToList("CaptureBalance", "Started", DateTime.MinValue);
            CaptureBalance();
            AddTimeToList("CaptureBalance", "Ended", DateTime.MinValue);
            //CaptureInterestCalculator();
            AddTimeToList("GenerateCashflowTransaction", "Started", DateTime.MinValue);

            GenerateCashflowTransaction();
            if (noteDC.DefaultScenarioParameters.UseActualsText == "Y")
            {
                OverrideReconValuesInTransactions();
            }
            AddTimeToList("GenerateCashflowTransaction", "Started", DateTime.MinValue);

            AddTimeToList("RunProspAcctg", "Ended", DateTime.MinValue);

            //CODE TO create csv file to test calculator.
            //WriteTestDataToCSV();
        }
        public void WriteTestDataToCSV()
        {
            CreateCSVFile(ToDataSet(DailyAccrualCustomFee).Tables[0], noteDC.CRENoteID + "_DailyAccrualCustomFee");
            CreateCSVFile(ToDataSet(ListFeeOutput).Tables[0], noteDC.CRENoteID + "_ListFeeOutput");
            CreateCSVFile(ToDataSet(ListDatesTab).Tables[0], noteDC.CRENoteID + "_Dates");
            CreateCSVFile(ToDataSet(ListRateTab).Tables[0], noteDC.CRENoteID + "_Rates");
            CreateCSVFile(ToDataSet(ListFeesTab).Tables[0], noteDC.CRENoteID + "_Fees");
            CreateCSVFile(ToDataSet(ListBalanceTab).Tables[0], noteDC.CRENoteID + "_Balance");
            CreateCSVFile(ToDataSet(ListCouponTab).Tables[0], noteDC.CRENoteID + "_Coupon");
            CreateCSVFile(ToDataSet(ListPIKInterestTab).Tables[0], noteDC.CRENoteID + "_PIKInterest");
            CreateCSVFile(ToDataSet(ListGAAPBasisTab).Tables[0], noteDC.CRENoteID + "_GAAPBasisTab");
            CreateCSVFile(ToDataSet(ListPVBasisTab).Tables[0], noteDC.CRENoteID + "_PVBasisTab");
            CreateCSVFile(ToDataSet(ListSLBasisTab).Tables[0], noteDC.CRENoteID + "_SLBasisTab");
            CreateCSVFile(ToDataSet(ListNotePeriodicOutputs).Tables[0], noteDC.CRENoteID + "_PeriodOutput");
            CreateCSVFile(ToDataSet(noteDC.ListCashflowTransactionEntry).Tables[0], noteDC.CRENoteID + "_TransactionOutput");
            CreateCSVFile(ToDataSet(ListSpreadandLibor).Tables[0], noteDC.CRENoteID + "_ListSpreadandLibor");
            CreateCSVFile(ToDataSet(noteDC.ListCashflowTransactionEntry).Tables[0], noteDC.CRENoteID + "_ListCashflowTransactionEntry");
            CreateCSVFile(ToDataSet(noteDC.ListFutureFundingScheduleTab).Tables[0], noteDC.CRENoteID + "_FundingSchedule");

            //CreateCSVFile(CalculationTrace.ToDataSet(ListBalanceTab, trace.BegBalanceCF).Tables[0], noteDC.CRENoteID + "_BegBalanceCF");
            //CreateCSVFile(CalculationTrace.ToDataSet(ListBalanceTab, trace.FutureAdvCF).Tables[0], noteDC.CRENoteID + "_FutureAdv");
            //CreateCSVFile(CalculationTrace.ToDataSet(ListBalanceTab, trace.CurtailmentsCF).Tables[0], noteDC.CRENoteID + "_CurtailmentsCF");
            //CreateCSVFile(CalculationTrace.ToDataSet(ListBalanceTab, trace.BalloonCF).Tables[0], noteDC.CRENoteID + "_BalloonCF");
            //CreateCSVFile(CalculationTrace.ToDataSet(ListBalanceTab, trace.BalanceCF).Tables[0], noteDC.CRENoteID + "_BalanceCF");

            CreateCSVFile(ToDataSet(ListCalculatorTime).Tables[0], noteDC.CRENoteID + "_TimeLog");
            CreateCSVFile(CalculationTrace.ToDataSet(ListBalanceTab, trace.FeeYieldCF).Tables[0], noteDC.CRENoteID + "_FeeYield");
            CreateCSVFile(CalculationTrace.ToDataSet(ListBalanceTab, trace.FeeBasisCF).Tables[0], noteDC.CRENoteID + "_FeeBasis");
            CreateCSVFile(CalculationTrace.ToDataSet(ListBalanceTab, trace.FeeAmort).Tables[0], noteDC.CRENoteID + "_FeeAmort");
            CreateCSVFile(CalculationTrace.ToDataSet(ListBalanceTab, trace.DiscYieldCF).Tables[0], noteDC.CRENoteID + "_DiscYield");
            CreateCSVFile(CalculationTrace.ToDataSet(ListBalanceTab, trace.DiscBasisCF).Tables[0], noteDC.CRENoteID + "_DiscBasis");
            CreateCSVFile(CalculationTrace.ToDataSet(ListBalanceTab, trace.DiscAmort).Tables[0], noteDC.CRENoteID + "_DiscAmort");
            CreateCSVFile(CalculationTrace.ToDataSet(ListBalanceTab, trace.LevelYieldCF).Tables[0], noteDC.CRENoteID + "_TraceLevelYieldCF");
            CreateCSVFile(CalculationTrace.ToDataSet(ListBalanceTab, trace.LYBasisCF).Tables[0], noteDC.CRENoteID + "_TraceLYBasisCF");
            CreateCSVFile(CalculationTrace.ToDataSet(ListBalanceTab, trace.SLTotalFeeCF).Tables[0], noteDC.CRENoteID + "_TraceSLTotalFeeCF");
            CreateCSVFile(CalculationTrace.ToDataSet(ListBalanceTab, trace.SLBasisCF).Tables[0], noteDC.CRENoteID + "_TraceSLBasisCF");
        }

        public void RunNoteCalculation(DateTime effectiveDate) //DateTime uniqueDate
        {
            if (effectiveDate == noteDC.ClosingDate)

            {
                calulateTab = true;
            }
            if (calulateTab == true)
            {
                AddTimeToList("CalculateRatesTab", "Started", effectiveDate);
                CalculateRatesTab(effectiveDate);
                AddTimeToList("CalculateRatesTab", "Ended", effectiveDate);

                AddTimeToList("CalculateBalanceTab", "Started", effectiveDate);
                CalculateBalanceTab(effectiveDate);
#if (DEBUG)
                //trace.BegBalanceCF.Add(new ProspectiveCashflow(ListBalanceTab, effectiveDate, "BeginningBalance"));
                //trace.FutureAdvCF.Add(new ProspectiveCashflow(ListBalanceTab, effectiveDate, "FutureAdvances"));
                //trace.CurtailmentsCF.Add(new ProspectiveCashflow(ListBalanceTab, effectiveDate, "Curtailments"));
                //trace.BalloonCF.Add(new ProspectiveCashflow(ListBalanceTab, effectiveDate,"Balloon"));
                //trace.BalanceCF.Add(new ProspectiveCashflow(ListBalanceTab, effectiveDate));
#endif
                AddTimeToList("CalculateBalanceTab", "Ended", effectiveDate);

                AddTimeToList("CalculatFeesTab", "Started", effectiveDate);
                CalculateFeesTab(effectiveDate);
                AddTimeToList("CalculatFeesTab", "Ended", effectiveDate);

                AddTimeToList("CalculateCouponTab", "Started", effectiveDate);
                CalculateCouponTab(effectiveDate);
                AddTimeToList("CalculateCouponTab", "Ended", effectiveDate);

                UpdateDailyAccInterestWithDropDate(effectiveDate);
            }
            //CalculateFinancingTab();            
        }

        public void CalculatePVBasis(string calculationMode)
        {
            int pvindex = 0, cfindex = 0, StartRow = 0, cpnndx = 0;
#pragma warning disable CS0219 // The variable 'PrecapBasis' is assigned but its value is never used
#pragma warning disable CS0219 // The variable 'AllInBasis' is assigned but its value is never used
            Decimal? PrecapYield = 0, AllInYield = 0, PrecapBasis = 0, AllInBasis = 0,
            DeferredFeeAmtLY = 0, DeferredFeeAmtAllIn = 0;
#pragma warning restore CS0219 // The variable 'AllInBasis' is assigned but its value is never used
#pragma warning restore CS0219 // The variable 'PrecapBasis' is assigned but its value is never used
            Decimal StubInterestCalc = 0, PurchInterestCalc = 0, DeltaBalance = 0;

            //Stub Interest Adjustment - 
            if (noteDC.StubPaidinAdvanceYNText == "Y" && noteDC.StubIntOverride.GetValueOrDefault(0) != 0)
            {
                StubInterestCalc = ListCouponTab.Where(cpn => cpn.Date >= noteDC.ClosingDate && cpn.Date < EffectveFirstCouponAccrualStartDate).Sum(c => c.PMTDropDateDailyAccruedInterest).GetValueOrDefault(0);
                if (StubInterestCalc != noteDC.StubIntOverride.GetValueOrDefault(0))
                {
                    cpnndx = Math.Max(0, ListCouponTab.FindIndex(cpn => cpn.Date == noteDC.ClosingDate));
                    ListCouponTab[cpnndx].UnpaidInterest += noteDC.StubIntOverride - StubInterestCalc;
                }
            }
            else
                StubInterestCalc = StubInterestAmount.GetValueOrDefault(0);
#if (DEBUG)
            //trace.BegBalanceCF.RemoveAll(item => item.EffectiveDate > DateTime.Parse("1/1/2017"));
            //trace.FutureAdvCF.RemoveAll(item => item.EffectiveDate > DateTime.Parse("1/1/2017"));
            //trace.CurtailmentsCF.RemoveAll(item => item.EffectiveDate > DateTime.Parse("1/1/2017"));
            //trace.BalloonCF.RemoveAll(item => item.EffectiveDate > DateTime.Parse("1/1/2017"));
            //trace.BalanceCF.RemoveAll(item=>item.EffectiveDate>DateTime.Parse("1/1/2017"));
#endif
            //Initial Period Interest Adjustment for Purchased Notes - 
            if (noteDC.LoanPurchaseYNText == "Y" && noteDC.PurchasedInterestOverride.GetValueOrDefault(0) != 0 && PurchasedStubInterestCalc != PurchasedStubInterest)
            {
                cpnndx = Math.Max(0, ListCouponTab.FindIndex(cpn => cpn.Date == noteDC.ClosingDate));
                ListCouponTab[cpnndx].UnpaidInterest += PurchasedStubInterest - PurchasedStubInterestCalc;
                PurchInterestCalc = PurchasedStubInterestCalc.GetValueOrDefault(0);
            }
            else
                PurchInterestCalc = PurchasedStubInterest.GetValueOrDefault(0);

            foreach (var unique in uniqueDateList)
            {
                calcbasis.Initialize();
                if (unique.UniqueDate.GetValueOrDefault() == uniqueDateList[0].UniqueDate.GetValueOrDefault())
                {
                    pvindex = calcbasis.CalcCumulativeAccruedAmounts(noteDC, ListBalanceTab, noteDC.ListHistoricalAccrual, ListPVBasisTab, AccrualDate, calculationMode
                        , DeferredFeeAmtLY, DeferredFeeAmtAllIn);
                }
                else
                {
                    //' STEP 1: Repopulate Tabs with new assumptions
                    CalculateLatestSchedules(unique, calculationMode);
                    var minDate = ListPVBasisTab.SkipWhile(min => min.Date < unique.UniqueDate).FirstOrDefault();
                    if (minDate != null)
                    {
                        StartRow = ListPVBasisTab.FindIndex(x => x.Date == minDate.Date) - 1;
                        //STEP 2: Recalculate Rates, Balance, PIK & Coupon based on the new set of assumptions for the Effective Date
                        RunNoteCalculation(Convert.ToDateTime(unique.UniqueDate));


                        calcbasis.NPVdate.Add(Convert.ToDateTime(ListPVBasisTab[StartRow].Date));
                        calcbasis.NPVValues.Add(ListPVBasisTab[StartRow].LockedPreCapBasis.GetValueOrDefault(0) * -1);
                        calcbasis.NPVActual.Add(Convert.ToDecimal(ListPVBasisTab[StartRow].AllInBasis * -1));
                        pvindex = StartRow + 1;
                    }
                }
                cfindex = pvindex;

                DeferredFeeAmtLY = CalcDeferredFees(ListPVBasisTab[0].Date);
                DeferredFeeAmtAllIn = CalcDeferredFees(ListPVBasisTab[0].Date, false);
                int CouponIndex = ListCouponTab.FindIndex(x => x.Date == SelectedMaturityDateLatest);
                var finalperinterest = CalcInterestOnFinalPaymentDate(CouponIndex, "Exclude Prepayment Date");
                decimal? InterestPaidonPaymentDate = finalperinterest.Item1;
                decimal? PMTDropDateInterestPaidonPaymentDate = finalperinterest.Item2;

                //STEP1B: Get the AddOn / Delta Balance for the period before last to add to the final interest payment
                int dtndx = ListDatesTab.FindIndex(dt => dt.PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay == SelectedMaturityDateLatest);
                if (dtndx > 0)
                {
                    cpnndx = ListCouponTab.FindIndex(cpn => cpn.Date == ListDatesTab[dtndx - 1].PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay);
                    DeltaBalance = ListCouponTab[cpnndx].DeltaBalance.GetValueOrDefault(0);
                }
                InterestPaidonPaymentDate = InterestPaidonPaymentDate + DeltaBalance;

                //STEP 3: Aggregate Cash flow Components - Principal I/O, Interest & PIK, Fees into One vector for Yield & Basis Calc.
                // Calculate Cash flows for Level Yield Calculation and All In Yield Calc
                calcbasis.CalculateCashFlowsPVBasis(pvindex, noteDC, ListBalanceTab, ListPIKInterestTab, ListCouponTab,
                            ListFeesTab, ListFeeOutput, noteDC.ListHistoricalAccrual, ListPVBasisTab,
                            AccrualDate, PurchInterestCalc, StubInterestCalc,
                            DeferredFeeAmtLY, DeferredFeeAmtAllIn, calculationMode,
                            InterestPaidonPaymentDate);

                //STEP 4:   Calculating Yield - Level Yield and All In Yield

                PrecapYield = calcbasis.CalculateLevelYield();
                ListYields.Add(new YieldDataContract(unique.UniqueDate, "PrecapLevelYield", PrecapYield));
                AllInYield = calcbasis.CalculateAllInYield();
                ListYields.Add(new YieldDataContract(unique.UniqueDate, "AllInYieldPV", AllInYield));
#if (DEBUG)
                //trace.LevelYieldCF.Add(new ProspectiveCashflow(calcbasis.NPVdate, calcbasis.NPVValues, unique.UniqueDate, Decimal.ToDouble(PrecapYield.GetValueOrDefault())));
                //trace.PVAllInCF.Add(new ProspectiveCashflow(calcbasis.NPVdate, calcbasis.NPVActual, unique.UniqueDate, Decimal.ToDouble(AllInYield.GetValueOrDefault())));
#endif

                //STEP 5:   Calculating Basis  - Level Yield Basis and All In Basis
                if (calculationMode != "Cash Flow Only")
                {
                    calcbasis.CalculateBasis(cfindex, ListPVBasisTab, ListDatesTab, ListCouponTab, ListPIKInterestTab, PrecapYield, AllInYield, SelectedMaturityDateLatest,
                        InterestPaidonPaymentDate, noteDC.IncludeServicingPaymentOverrideinLevelYieldText, this.stubEndDate, StubInterestCalc, noteDC.InitialInterestAccrualEndDate, PurchasedStubInterest.GetValueOrDefault(0));
                    CalculateAmortLYIncome(Convert.ToDateTime(uniqueDateList[0].UniqueDate));
                    CalculateSLBasis(unique.UniqueDate, calculationMode);
                }
#if (DEBUG)
                //trace.LYBasisCF.Add(new ProspectiveCashflow(ListPVBasisTab, unique.UniqueDate, Decimal.ToDouble(PrecapYield.GetValueOrDefault()), "LevelYield"));
                ////trace.PVAllInBasisCF.Add(new ProspectiveCashflow(ListPVBasisTab, unique.UniqueDate, Decimal.ToDouble(AllInYield.GetValueOrDefault()), "AllIn"));
                //trace.SLTotalFeeCF.Add(new ProspectiveCashflow(ListSLBasisTab, unique.UniqueDate, 0, "FeeLY"));
                //trace.SLBasisCF.Add(new ProspectiveCashflow(ListSLBasisTab, unique.UniqueDate, 0, "SLBasis"));
#endif
            }
        }

        public void CalculateSLBasis(DateTime? effectiveDate, string calculationMode)
        {
#pragma warning disable CS0219 // The variable 'ndx' is assigned but its value is never used
            int ndx = 0, ndxAccumFees = 0, pvindex = 0;
#pragma warning restore CS0219 // The variable 'ndx' is assigned but its value is never used
            Decimal? TotalFees = 0, AccumFees = 0, DateDiff = 0, FeeAmortized = 0;
            Decimal? SLAmortDiscount = 0, SLAmortCapCost = 0, SLAmortTotalFees = 0;
#pragma warning disable CS0219 // The variable 'AccumSLAmort' is assigned but its value is never used
            decimal? AccumSLAmort = 0;
#pragma warning restore CS0219 // The variable 'AccumSLAmort' is assigned but its value is never used
            bool includeprepaymentdate = false;

            includeprepaymentdate = noteDC.InterestCalculationRuleForPaydownsText == "Exclude Prepayment Date" ? false : true;
            DateDiff = (SelectedMaturityDateLatest.GetValueOrDefault() - noteDC.ClosingDate.GetValueOrDefault()).Days + (includeprepaymentdate ? 1 : 0);
            SLAmortDiscount = NumericExtensions.SafeDivision(noteDC.Discount.GetValueOrDefault(0), DateDiff.GetValueOrDefault()) * -1;
            SLAmortCapCost = NumericExtensions.SafeDivision(noteDC.CapitalizedClosingCosts.GetValueOrDefault(0), DateDiff.GetValueOrDefault()) * -1;

            TotalFees = ListFeesTab.Where(fee => fee.Date >= noteDC.ClosingDate).Sum(amt => amt.FeeAmountIncludedinLevelYield);
            if (effectiveDate > noteDC.ClosingDate)
            {
                ndxAccumFees = ListSLBasisTab.FindIndex(sl => sl.Date == effectiveDate.GetValueOrDefault().AddDays(-1));
                if (ndxAccumFees >= 0)
                {
                    FeeAmortized = ListSLBasisTab[ndxAccumFees].AccumSLAmortOfTotalFeesInclInLY.GetValueOrDefault(0);
                }
                else
                {
                    FeeAmortized = 0;
                }
                pvindex = ndxAccumFees + 1;
                //AccumSLAmortOfTotalFees - ListGAAPBasisTab.FindIndex(x => x.Date == gaap.Date) + 1;
            }
            DateDiff = (SelectedMaturityDateLatest.GetValueOrDefault() - effectiveDate.GetValueOrDefault()).Days + (includeprepaymentdate ? 1 : 0);
            SLAmortTotalFees = NumericExtensions.SafeDivision(TotalFees.GetValueOrDefault(0) - FeeAmortized.GetValueOrDefault(0), DateDiff.GetValueOrDefault());

            var minDate = ListPVBasisTab.SkipWhile(min => min.Date < effectiveDate).FirstOrDefault();
            int slindex = 0;
            if (minDate != null)
            {
                slindex = ListPVBasisTab.FindIndex(x => x.Date == minDate.Date);
            }

            foreach (SLBasisTab sl in ListSLBasisTab.Skip(slindex))
            {
                sl.SLAmortOfDiscountPremium = includeprepaymentdate ? (sl.Date > SelectedMaturityDateLatest ? 0 : SLAmortDiscount) : (sl.Date >= SelectedMaturityDateLatest ? 0 : SLAmortDiscount);
                sl.AccumSLAmortOfDiscountPremium = pvindex == 0 ? sl.SLAmortOfDiscountPremium : ListSLBasisTab[pvindex - 1].AccumSLAmortOfDiscountPremium + sl.SLAmortOfDiscountPremium;

                sl.SLAmortOfCapCost = includeprepaymentdate ? (sl.Date > SelectedMaturityDateLatest ? 0 : SLAmortCapCost) : (sl.Date >= SelectedMaturityDateLatest ? 0 : SLAmortCapCost);
                sl.AccumSLAmortOfCapCost = pvindex == 0 ? sl.SLAmortOfCapCost : ListSLBasisTab[pvindex - 1].AccumSLAmortOfCapCost + sl.SLAmortOfCapCost;

                sl.SLAmortOfTotalFeesInclInLY = includeprepaymentdate ? (sl.Date > SelectedMaturityDateLatest ? 0 : SLAmortTotalFees) : (sl.Date >= SelectedMaturityDateLatest ? 0 : SLAmortTotalFees);
                sl.AccumSLAmortOfTotalFeesInclInLY = pvindex == 0 ? sl.SLAmortOfTotalFeesInclInLY : ListSLBasisTab[pvindex - 1].AccumSLAmortOfTotalFeesInclInLY + sl.SLAmortOfTotalFeesInclInLY;

                AccumFees = noteDC.IncludeServicingPaymentOverrideinLevelYieldText == "Y" ? ListCouponTab[pvindex].PMTDropDateAccumInterestforCurrentAccrualPeriod.GetValueOrDefault(0) : ListCouponTab[pvindex].AccumInterestforCurrentAccrualPeriod.GetValueOrDefault(0);
                sl.SLAmort = sl.SLAmortOfDiscountPremium.GetValueOrDefault() + sl.SLAmortOfCapCost.GetValueOrDefault() + sl.SLAmortOfTotalFeesInclInLY.GetValueOrDefault();
                sl.AccumSLAmort = pvindex == 0 ? sl.SLAmort.GetValueOrDefault(0) : ListSLBasisTab[pvindex - 1].AccumSLAmort.GetValueOrDefault(0) + sl.SLAmort.GetValueOrDefault(0);
                sl.SLBasis = ListPVBasisTab[pvindex].CleanCostLevelYield.GetValueOrDefault() + sl.AccumSLAmort.GetValueOrDefault()
                    + AccumFees + ListPIKInterestTab[pvindex].AccumPIKInterestforCurrentAccrualPeriod.GetValueOrDefault(0);
                sl.SLBasisAdj = ListPVBasisTab[pvindex].CleanCostLevelYield.GetValueOrDefault() + sl.AccumSLAmort.GetValueOrDefault();
                sl.SLBasisAdjPct = NumericExtensions.SafeDivision(sl.SLBasisAdj.GetValueOrDefault(0), ListBalanceTab[pvindex].EndingBalance.GetValueOrDefault(0));

                //Splitting Total PVAmort into Components
                sl.FeeAmort = NumericExtensions.SafeDivision(ListPVBasisTab[pvindex].PVAmort.GetValueOrDefault(0) * sl.SLAmortOfTotalFeesInclInLY.GetValueOrDefault(0), sl.SLAmort.GetValueOrDefault(0));
                sl.DiscPremAmort = NumericExtensions.SafeDivision(ListPVBasisTab[pvindex].PVAmort.GetValueOrDefault(0) * sl.SLAmortOfDiscountPremium.GetValueOrDefault(0), sl.SLAmort.GetValueOrDefault(0));
                sl.CapCostAmort = NumericExtensions.SafeDivision(ListPVBasisTab[pvindex].PVAmort.GetValueOrDefault(0) * sl.SLAmortOfCapCost.GetValueOrDefault(0), sl.SLAmort.GetValueOrDefault(0));

                pvindex += 1;
            }

        }

        public void CalculateLatestSchedules(UniqueDatesForCalcEngine unique, string calcmode)
        {
            if (calcmode == "Cash Flow Only" || calcmode == "CF + GAAP Basis (Inception)" || calcmode == "Full Mode (Inception)" || calcmode == "CF + PV Basis (Inception)")
            {
                var checkCondition = (from chk in noteDC.ListFutureFundingScheduleTab
                                      where chk.EffectiveDate == unique.UniqueDate
                                      select true).FirstOrDefault();
                if (checkCondition == true)
                    ListFutureFundingScheduleTabLatest = noteDC.ListFutureFundingScheduleTab.Where(ff => ff.EffectiveDate == unique.UniqueDate).ToList();

                checkCondition = (from chk in noteDC.RateSpreadScheduleList
                                  where chk.EffectiveDate == unique.UniqueDate
                                  select true).FirstOrDefault();
                if (checkCondition == true)
                    ListRateSpreadScheduleLatest = noteDC.RateSpreadScheduleList.Where(ff => ff.EffectiveDate == unique.UniqueDate).ToList();

                checkCondition = (from chk in noteDC.ListFixedAmortScheduleTab
                                  where chk.EffectiveDate == unique.UniqueDate
                                  select true).FirstOrDefault();
                if (checkCondition == true)
                    ListFixedAmortScheduleTabLatest = noteDC.ListFixedAmortScheduleTab.Where(ff => ff.EffectiveDate == unique.UniqueDate).ToList();

                checkCondition = (from chk in noteDC.ListPIKfromPIKSourceNoteTab
                                  where chk.EffectiveDate == unique.UniqueDate
                                  select true).FirstOrDefault();
                if (checkCondition == true)
                    ListPIKfromPIKSourceNoteTabLatest = noteDC.ListPIKfromPIKSourceNoteTab.Where(ff => ff.EffectiveDate == unique.UniqueDate).ToList();

                checkCondition = (from chk in noteDC.NotePrepayAndAdditionalFeeScheduleList
                                  where chk.EffectiveDate == unique.UniqueDate
                                  select true).FirstOrDefault();
                if (checkCondition == true)
                    ListNotePrepayAndAdditionalFeeScheduleLatest = noteDC.NotePrepayAndAdditionalFeeScheduleList.Where(ff => ff.EffectiveDate == unique.UniqueDate).ToList();

                checkCondition = (from chk in noteDC.ListFeeCouponStripReceivable
                                  where chk.EffectiveDate == unique.UniqueDate
                                  select true).FirstOrDefault();
                if (checkCondition == true)
                    ListFeeCouponStripReceivableLatest = noteDC.ListFeeCouponStripReceivable.Where(ff => ff.EffectiveDate == unique.UniqueDate).ToList();

                checkCondition = (from chk in noteDC.NotePIKScheduleList
                                  where chk.EffectiveDate == unique.UniqueDate
                                  select true).FirstOrDefault();
                if (checkCondition == true)
                    ListNotePIKScheduleLatest = noteDC.NotePIKScheduleList.Where(ff => ff.EffectiveDate == unique.UniqueDate).ToList();

                //Maturity Date - Use Non Holiday Adjusted date to check against NoteDC Maturity Date List.
                checkCondition = (from chk in noteDC.MaturityScenariosList
                                  where chk.EffectiveDate == unique.UniqueDateNotAdj
                                  select true).FirstOrDefault();
                if (checkCondition == true)
                {
                    DateTime? prevSelectedMaturityDate = SelectedMaturityDateLatest;
                    SelectedMaturityDateLatestNotBusDayAdjusted = noteDC.MaturityScenariosList.Where(mat => mat.EffectiveDate == unique.UniqueDateNotAdj).ToList().FirstOrDefault().SelectedMaturityDate;
                    SelectedMaturityDateLatest = GetWorkingDayUsingOffset(Convert.ToDateTime(SelectedMaturityDateLatestNotBusDayAdjusted.Value.AddDays(1)), Convert.ToInt16(noteDC.PaymentDateBusinessDayLag), "");
                    if (SelectedMaturityDateLatest != prevSelectedMaturityDate)
                    {
                        CollectDates(prevSelectedMaturityDate.Value.Date, SelectedMaturityDateLatest.Value.Date);
                        CalculateDatesTab(unique.UniqueDate, prevSelectedMaturityDate);
                        PopulateTabDates(prevSelectedMaturityDate.Value.Date);
                    }
                }
            }
            else if (calcmode == "CF + GAAP Basis (Prospective)" || calcmode == "Full Mode (Prospective)" || calcmode == "CF + PV Basis (Prospective)")
            {
                GetProspectiveModeSchedules(unique.UniqueDate);
            }

            ResetProspAcctgArrays(unique.UniqueDate.Value);
        }
        public void GetProspectiveModeSchedules(DateTime? currenteffectivedate)
        {
            // ' Get Future Funding Schedule
            var date = (from chk in noteDC.ListFutureFundingScheduleTab
                        select chk.EffectiveDate).Max();
            ListFutureFundingScheduleTabLatest = noteDC.ListFutureFundingScheduleTab.Where(ff => ff.EffectiveDate == date).ToList();

            //' Get Rate & Spread Schedule
            date = (from chk in noteDC.RateSpreadScheduleList
                    select chk.EffectiveDate).Max();
            if (date != null)
            {
                ListRateSpreadScheduleLatest = noteDC.RateSpreadScheduleList.Where(ff => ff.EffectiveDate == date).ToList();
            }
            //' Get Fixed Amort Schedule
            date = (from chk in noteDC.ListFixedAmortScheduleTab
                    select chk.EffectiveDate).Max();
            if (date != null)
            {
                ListFixedAmortScheduleTabLatest = noteDC.ListFixedAmortScheduleTab.Where(ff => ff.EffectiveDate == date).ToList();
            }
            //' Get PIK Schedule
            date = (from chk in noteDC.ListPIKfromPIKSourceNoteTab
                    select chk.EffectiveDate).Max();
            if (date != null)
            {
                ListPIKfromPIKSourceNoteTabLatest = noteDC.ListPIKfromPIKSourceNoteTab.Where(ff => ff.EffectiveDate == date).ToList();
            }

            //' Get Fee Schedule
            date = (from chk in noteDC.NotePrepayAndAdditionalFeeScheduleList
                    select chk.EffectiveDate).Max();
            if (date != null)
            {
                ListNotePrepayAndAdditionalFeeScheduleLatest = noteDC.NotePrepayAndAdditionalFeeScheduleList.Where(ff => ff.EffectiveDate == date).ToList();
            }

            //' Get PIK Schedule
            date = (from chk in noteDC.NotePIKScheduleList
                    select chk.EffectiveDate).Max();
            if (date != null)
            {
                ListNotePIKScheduleLatest = noteDC.NotePIKScheduleList.Where(ff => ff.EffectiveDate == date).ToList();
            }

        }
        public void CalculateGapBasisTab(string calculationMode)
        {
            List<DateTime> NGaapdate = new List<DateTime>();
            List<Decimal> NGaapFee = new List<Decimal>();
            List<Decimal> NGaapDiscount = new List<Decimal>();
            List<Decimal> NGaapClosingCost = new List<Decimal>();
            List<Decimal> NPVDiscount = new List<Decimal>();
            List<Decimal> NGaapPar = new List<Decimal>();
            List<Decimal> NGaapAllIn = new List<Decimal>();
            Double dateDifference;
            int index = 0;
            int temgaapindex = 0;
            int cfcell = 0;
            string ServicingOverride = "";
            int ListIndex = 0, StartRow = 0, cfindex = 0;
            Decimal? InitialFunding = noteDC.InitialFundingAmount.GetValueOrDefault(0),
            CapCosts = noteDC.CapitalizedClosingCosts.GetValueOrDefault(0),
             FeeAmortBasis = 0, DiscountAmortBasis = 0, ClosingAmortBasis = 0, parBasis = 0, InterestPaidperServicing = 0, PIKInterestForThePeriod = 0, AllinBasis = 0, FeeAmountInc = 0
            , Purchint = PurchasedStubInterest.GetValueOrDefault(0), DeferredFeeAmt = 0, OrigDeferredFeeAmt = 0, DeferredFeeamtPa = 0
            , vCumAccruedDeferredFee = 0, vCumAccruedDiscountFee = 0, vCumAccruedCapitalizedCostFee = 0, Premium = noteDC.Discount.GetValueOrDefault(0);
            double FeeAmortYield = 0, DiscountAmortYield = 0, ClosingCostAmortYield = 0, parYield = 0, allinyield = 0;
            DeferredFeeAmt = CalcDeferredFees(ListGAAPBasisTab[0].Date);
            OrigDeferredFeeAmt = DeferredFeeAmt;
            ServicingOverride = noteDC.IncludeServicingPaymentOverrideinLevelYieldText;
            if (AccrualDate != null && AccrualDate != DateTime.MinValue && calculationMode != "CF + GAAP Basis (Inception)")
            {
                ListIndex = 0;
                vCumAccruedDeferredFee = CumAccruedDeferredFee();
                vCumAccruedDiscountFee = CumAccruedDiscountFee();
                vCumAccruedCapitalizedCostFee = CumAccruedCapitalizedCostFee();
                foreach (var gaap in ListGAAPBasisTab)
                {
                    if (gaap.Date.Value.Date == AccrualDate.Value.Date)
                    {
                        break;
                    }
                    ListIndex = ListIndex + 1;
                }
                NGaapdate.Add(AccrualDate.Value);
                NGaapFee.Add(Convert.ToDecimal(-ListBalanceTab[ListIndex].EndingBalance.GetValueOrDefault(0) + (DeferredFeeAmt - vCumAccruedDeferredFee)));
                NGaapDiscount.Add(Convert.ToDecimal(-ListBalanceTab[ListIndex].EndingBalance.GetValueOrDefault(0) - (Premium + vCumAccruedDiscountFee)));
                NGaapClosingCost.Add(Convert.ToDecimal(-ListBalanceTab[ListIndex].EndingBalance.GetValueOrDefault(0) + (CapCosts - vCumAccruedCapitalizedCostFee)));
                NGaapPar.Add(Convert.ToDecimal(CumAccruedPvBasisByDate(AccrualDate.Value) + DeferredFeeAmt - vCumAccruedDeferredFee - (Premium + vCumAccruedDiscountFee) + CapCosts - vCumAccruedCapitalizedCostFee) * -1);
                NGaapAllIn.Add(-CumAccruedAllInBasisByDate(AccrualDate.Value));
            }
            else
            {
                NGaapdate.Add(noteDC.ClosingDate.Value);
                NGaapFee.Add(-0.00000001m);
                NGaapDiscount.Add(-0.00000001m);
                NGaapClosingCost.Add(-0.00000001m);
                NPVDiscount.Add(-0.00000001m);
                NGaapPar.Add(-0.00000001m);
                NGaapAllIn.Add(-0.00000001m);
                ListIndex = 0;
            }
            cfindex = ListIndex;
            foreach (var gaap in ListGAAPBasisTab.Skip(ListIndex))
            {
                if (ListIndex <= ListGAAPBasisTab.Count - 1)
                {
                    //  Net Principal In/Out Flow
                    if (ListIndex == 0)
                    {
                        gaap.NetPrincipalInflowOutflow = -InitialFunding.GetValueOrDefault(0) - ListBalanceTab[ListIndex].FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0)
                          + ListBalanceTab[ListIndex].DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0);
                    }
                    else
                    {
                        gaap.NetPrincipalInflowOutflow = CalculateNetInflowOutflow(ListIndex);
                    }

                    //  Gross Deferred Fees & Clean Cost
                    if (gaap.Date.Value.Date < SelectedMaturityDateLatest.Value.Date)
                    {
                        gaap.GrossDeferredFees = DeferredFeeAmt;
                        gaap.CleanCost = Math.Round(ListBalanceTab[ListIndex].EndingBalance.GetValueOrDefault(0), 8) + Premium - DeferredFeeAmt + CapCosts;
                    }
                    else
                    {
                        gaap.GrossDeferredFees = 0;
                        gaap.CleanCost = 0;
                    }
                    //Deferred Fees Receivable
                    gaap.DeferredFeesReceivable = CalcDeferredFees(gaap.Date);
                    bool bsum = gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0) != 0 || ListFeesTab[ListIndex].FeeAmountIncludedinLevelYield.GetValueOrDefault(0) != 0
                         || ListFeesTab[ListIndex].StrippedFeeReceivableInclInLY.GetValueOrDefault(0) != 0 || ListCouponTab[ListIndex].InterestPaidServicingWithDropDate.GetValueOrDefault(0) != 0;
                    if (bsum)
                    {
                        NGaapdate.Add(Convert.ToDateTime(gaap.Date));
                        if (DeferredFeeAmt != 0 || OrigDeferredFeeAmt != 0)
                        {
                            NGaapFee.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0) + ListFeesTab[ListIndex].FeeAmountIncludedinLevelYield.GetValueOrDefault(0) + ListFeesTab[ListIndex].StrippedFeeReceivableInclInLY.GetValueOrDefault(0));
                        }
                        if (gaap.Date == noteDC.ClosingDate)
                        {
                            if (Premium != 0 && Premium != null)
                            {
                                NGaapDiscount.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0) - Premium.GetValueOrDefault(0));
                            }
                            if (CapCosts != 0 && CapCosts != null)
                            {
                                NGaapClosingCost.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0) - Convert.ToDecimal(CapCosts));
                            }

                            NGaapAllIn.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0) - Premium.GetValueOrDefault(0) - CapCosts.GetValueOrDefault(0) + ListCouponTab[ListIndex].InterestPaidServicingWithDropDate.GetValueOrDefault(0) + FeeReceivedByDate(gaap.Date.Value));
                        }
                        else
                        {
                            if (Premium != 0 && Premium != null)
                            {
                                NGaapDiscount.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0));
                            }
                            if (CapCosts != 0 && CapCosts != null)
                            {
                                NGaapClosingCost.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0));
                            }
                            NGaapAllIn.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0) + ListCouponTab[ListIndex].InterestPaidServicingWithDropDate.GetValueOrDefault(0) + ListPIKInterestTab[ListIndex].PIKInterestforthePeriod.GetValueOrDefault(0) + FeeReceivedByDate(gaap.Date.Value));
                        }
                        if (ServicingOverride == "N")
                        {
                            NGaapPar.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0) + ListCouponTab[ListIndex].InterestforthePeriod.GetValueOrDefault(0) + ListPIKInterestTab[ListIndex].PIKInterestforthePeriod.GetValueOrDefault(0));
                        }
                        else
                        {
                            NGaapPar.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0) + ListCouponTab[ListIndex].InterestPaidServicingWithDropDate.GetValueOrDefault(0) + ListPIKInterestTab[ListIndex].PIKInterestforthePeriod.GetValueOrDefault(0));
                        }
                    }
                }
                else
                {
                    break;
                }
                ListIndex = ListIndex + 1;
            }
            //' Calculating Yield
            if (DeferredFeeAmt != 0 || OrigDeferredFeeAmt != 0)
            {
                AddToListYieldCalcInputList(NGaapFee, NGaapdate, "FeeAmortYield", uniqueDateList[0].UniqueDate);

                FeeAmortYield = cXIRR(NGaapFee, NGaapdate, 0.005);
#if (DEBUG)
                trace.FeeYieldCF.Add(new ProspectiveCashflow(NGaapdate, NGaapFee, noteDC.ClosingDate, FeeAmortYield));
#endif
            }
            if (Premium != 0)
            {
                AddToListYieldCalcInputList(NGaapDiscount, NGaapdate, "DiscountAmortYield", uniqueDateList[0].UniqueDate);
                DiscountAmortYield = cXIRR(NGaapDiscount, NGaapdate, 0.005);
            }
            if (CapCosts != 0)
            {
                AddToListYieldCalcInputList(NGaapClosingCost, NGaapdate, "ClosingCostAmortYield", uniqueDateList[0].UniqueDate);
                ClosingCostAmortYield = cXIRR(NGaapClosingCost, NGaapdate, 0.005);
            }
            AddToListYieldCalcInputList(NGaapPar, NGaapdate, "parYield", uniqueDateList[0].UniqueDate);
            parYield = cXIRR(NGaapPar, NGaapdate, 0.005);
            AddToListYieldCalcInputList(NGaapAllIn, NGaapdate, "allinyield", uniqueDateList[0].UniqueDate);
            allinyield = cXIRR(NGaapAllIn, NGaapdate, 0.01);
            if (calculationMode == "Cash Flow Only")
            {
                ListYields.Add(new YieldDataContract(noteDC.ClosingDate, "DeferredFeeYield", FeeAmortYield));
                ListYields.Add(new YieldDataContract(noteDC.ClosingDate, "DiscountPremiumYield", DiscountAmortYield));
                ListYields.Add(new YieldDataContract(noteDC.ClosingDate, "ClosingCostYield", ClosingCostAmortYield));

            }
            //Calculating Basis           
            if (AccrualDate != null && calculationMode != "CF + GAAP Basis (Inception)")
            {
                if (DeferredFeeAmt != 0 || OrigDeferredFeeAmt != 0)
                {
                    ListGAAPBasisTab[cfindex].DeferredFeeAccrualBasis = ListBalanceTab[cfindex].EndingBalance.GetValueOrDefault(0) - (DeferredFeeAmt - CumAccruedDeferredFee());
                }
                if (Premium != 0 && Premium != null)
                {
                    ListGAAPBasisTab[cfindex].DiscountPremiumAccrualBasis = ListBalanceTab[cfindex].EndingBalance.GetValueOrDefault(0) + (Premium + CumAccruedDiscountFee());
                }
                if (CapCosts != 0 && CapCosts != null)
                {
                    ListGAAPBasisTab[cfindex].CapitalizedCostsAccrualBasis = ListBalanceTab[cfindex].EndingBalance.GetValueOrDefault(0) - (CapCosts - CumAccruedCapitalizedCostFee());
                }
            }
            else
            {
                if (DeferredFeeAmt != 0 || OrigDeferredFeeAmt != 0)
                {
                    ListGAAPBasisTab[0].DeferredFeeAccrualBasis = ListGAAPBasisTab[0].NetPrincipalInflowOutflow.GetValueOrDefault(0) * -1 - DeferredFeeAmt;// + ListGAAPBasisTab[0].CashFlowadjustedforServicingInfo.GetValueOrDefault(0);
                }

                if (Premium != 0 && Premium != null)
                {
                    ListGAAPBasisTab[0].DiscountPremiumAccrualBasis = ListGAAPBasisTab[0].NetPrincipalInflowOutflow.GetValueOrDefault(0) * -1 + Premium.GetValueOrDefault(0);
                }

                if (CapCosts != 0 && CapCosts != null)
                {
                    ListGAAPBasisTab[0].CapitalizedCostsAccrualBasis = ListGAAPBasisTab[0].NetPrincipalInflowOutflow.GetValueOrDefault(0) * -1 + CapCosts.GetValueOrDefault(0);
                }

                ListGAAPBasisTab[0].ParBasis = ListBalanceTab[0].EndingBalance.GetValueOrDefault(0);
                ListGAAPBasisTab[0].AllInBasis = ListBalanceTab[0].EndingBalance.GetValueOrDefault(0) + Premium.GetValueOrDefault(0) + CapCosts.GetValueOrDefault(0) - TotalFeeAmt();
            }
            temgaapindex = cfindex + 1;
            cfcell = cfindex + 1;
            if (cfcell != 0)
            {
                index = cfcell - 1;
            }
            foreach (var gaap in ListGAAPBasisTab.Skip(cfindex))
            {

                //8/31/2015
                FeeAmortBasis = 0;
                DiscountAmortBasis = 0;
                ClosingAmortBasis = 0;
                parBasis = 0;
                index = index + 1;
                cfcell = temgaapindex + 1;
                InterestPaidperServicing = 0;
                FeeAmountInc = 0;
                AllinBasis = 0;
                foreach (var basis in ListGAAPBasisTab.Skip(index))
                {
                    if (cfcell <= ListGAAPBasisTab.Count - 1)
                    {
                        InterestPaidperServicing = ListCouponTab[cfcell].InterestPaidServicingWithDropDate.GetValueOrDefault(0);
                    }
                    else
                    {
                        InterestPaidperServicing = 0;
                    }
                    PIKInterestForThePeriod = cfcell <= ListFeesTab.Count - 1 ? ListPIKInterestTab[cfcell].PIKInterestforthePeriod.GetValueOrDefault() : 0;
                    if (cfcell <= ListFeesTab.Count - 1)
                    {
                        FeeAmountInc = ListFeesTab[cfcell].FeeAmountIncludedinLevelYield.GetValueOrDefault(0) + ListFeesTab[cfcell].StrippedFeeReceivableInclInLY.GetValueOrDefault(0);
                    }
                    else
                    {
                        FeeAmountInc = 0;
                    }

                    if (basis.NetPrincipalInflowOutflow.GetValueOrDefault(0) != 0 || FeeAmountInc != 0 || InterestPaidperServicing != 0)
                    {
                        //XNPV Calculation:
                        dateDifference = Convert.ToDouble(Convert.ToDouble(Convert.ToDateTime(basis.Date).Subtract(Convert.ToDateTime(gaap.Date)).Days) / 365);

                        if (DeferredFeeAmt != 0 && DeferredFeeAmt != null)
                        {
                            FeeAmortBasis = FeeAmortBasis + NumericExtensions.SafeDivision(Convert.ToDecimal(basis.NetPrincipalInflowOutflow + FeeAmountInc),
                                NumericExtensions.CalcPowAndCheckNaN(Convert.ToDouble(1 + FeeAmortYield), dateDifference));
                        }
                        if (Premium != 0 && Premium != null)
                        {
                            DiscountAmortBasis = DiscountAmortBasis + NumericExtensions.SafeDivision(Convert.ToDecimal(basis.NetPrincipalInflowOutflow),
                        NumericExtensions.CalcPowAndCheckNaN(Convert.ToDouble(1 + DiscountAmortYield), dateDifference));
                        }
                        if (CapCosts != 0 && CapCosts != null)
                        {
                            ClosingAmortBasis = ClosingAmortBasis + NumericExtensions.SafeDivision(Convert.ToDecimal(basis.NetPrincipalInflowOutflow),
                        NumericExtensions.CalcPowAndCheckNaN(Convert.ToDouble(1 + ClosingCostAmortYield), dateDifference));
                        }

                        parBasis = parBasis + NumericExtensions.SafeDivision(Convert.ToDecimal(basis.NetPrincipalInflowOutflow + InterestPaidperServicing + PIKInterestForThePeriod),
                                NumericExtensions.CalcPowAndCheckNaN(Convert.ToDouble(1 + parYield), dateDifference));

                        AllinBasis = AllinBasis + NumericExtensions.SafeDivision(Convert.ToDecimal(basis.NetPrincipalInflowOutflow + InterestPaidperServicing + PIKInterestForThePeriod + FeeReceivedByDate(basis.Date.Value)),
                                NumericExtensions.CalcPowAndCheckNaN(Convert.ToDouble(1 + allinyield), dateDifference));
                    }

                    cfcell = cfcell + 1;
                }
                gaap.DeferredFeeAccrualBasis = FeeAmortBasis;
                gaap.DiscountPremiumAccrualBasis = DiscountAmortBasis;
                gaap.CapitalizedCostsAccrualBasis = ClosingAmortBasis;
                gaap.ParBasis = parBasis;
                gaap.AllInBasis = AllinBasis;
                temgaapindex = temgaapindex + 1;
            }
            CalculateAmortLYIncome(Convert.ToDateTime(uniqueDateList[0].UniqueDate));

#if (DEBUG)
            trace.FeeBasisCF.Add(new ProspectiveCashflow(ListGAAPBasisTab, noteDC.ClosingDate, FeeAmortYield, "Fee"));
            trace.DiscBasisCF.Add(new ProspectiveCashflow(ListGAAPBasisTab, noteDC.ClosingDate, DiscountAmortYield, "Discount"));
            trace.FeeAmort.Add(new ProspectiveCashflow(ListGAAPBasisTab, noteDC.ClosingDate, FeeAmortYield, "FeeAmort"));
            trace.DiscAmort.Add(new ProspectiveCashflow(ListGAAPBasisTab, noteDC.ClosingDate, DiscountAmortYield, "DiscAmort"));
#endif
            if (calculationMode == "CF + GAAP Basis (Inception)" || calculationMode == "CF + PV Basis (Inception)" || calculationMode == "Cash Flow Only")
            {
                foreach (var unique in uniqueDateList.Skip(1))
                {
                    // Loop through collection of effective dates uiqueDateList ****Except this rest of are for copy code
                    CalculateLatestSchedules(unique, calculationMode);
                    var minDate = ListGAAPBasisTab.SkipWhile(min => min.Date < unique.UniqueDate).FirstOrDefault();
                    if (minDate != null)
                    {
                        StartRow = ListGAAPBasisTab.FindIndex(x => x.Date == minDate.Date);
                        //' STEP 1: Repopulate Tabs with new assumptions
                        RunNoteCalculation(Convert.ToDateTime(unique.UniqueDate));
                        //STEP 2: Recalculate CFs and Basis based on new
                        NGaapFee = new List<decimal>();
                        NGaapdate = new List<DateTime>();
                        NGaapDiscount = new List<decimal>();
                        NGaapClosingCost = new List<decimal>();
                        NGaapPar = new List<decimal>();
                        NGaapAllIn = new List<decimal>();
                        StartRow = StartRow - 1;
                        if (StartRow == -1)
                        {
                            StartRow = 0;
                        }
                        NGaapdate.Add(Convert.ToDateTime(ListGAAPBasisTab[StartRow].Date));
                        if (ListGAAPBasisTab[StartRow].DeferredFeeAccrualBasis.GetValueOrDefault(0) == 0)
                            NGaapFee.Add(ListBalanceTab[StartRow].EndingBalance.GetValueOrDefault(0) * -1);
                        else
                            NGaapFee.Add(ListGAAPBasisTab[StartRow].DeferredFeeAccrualBasis.GetValueOrDefault(0) * -1);
                        NGaapDiscount.Add(Convert.ToDecimal(ListGAAPBasisTab[StartRow].DiscountPremiumAccrualBasis * -1));
                        NGaapClosingCost.Add(Convert.ToDecimal(ListGAAPBasisTab[StartRow].CapitalizedCostsAccrualBasis * -1));
                        NGaapPar.Add(Convert.ToDecimal(ListGAAPBasisTab[StartRow].ParBasis * -1));
                        NGaapAllIn.Add(Convert.ToDecimal(ListGAAPBasisTab[StartRow].AllInBasis * -1));
                        index = StartRow + 1;
                        foreach (var gaap in ListGAAPBasisTab.Skip(index))
                        {
                            gaap.NetPrincipalInflowOutflow = CalculateNetInflowOutflow(index);
                            DeferredFeeAmt = CalcDeferredFees(noteDC.ClosingDate.Value);
                            DeferredFeeamtPa = CalcDeferredFees(ListFeesTab[index].Date);
                            //Gross Deferred Fees & Clean Cost
                            if (gaap.Date.Value.Date < SelectedMaturityDateLatest.Value.Date)
                            {
                                gaap.GrossDeferredFees = DeferredFeeAmt;
                                gaap.CleanCost = ListBalanceTab[index].EndingBalance.GetValueOrDefault(0) + Premium - DeferredFeeAmt + CapCosts;
                            }
                            else
                            {
                                gaap.GrossDeferredFees = 0;
                                gaap.CleanCost = 0;
                            }
                            //Deferred Fees Receivable
                            gaap.DeferredFeesReceivable = DeferredFeeamtPa;
                            if (gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0) != 0 || ListFeesTab[index].FeeAmountIncludedinLevelYield.GetValueOrDefault(0) != 0
                                || ListCouponTab[index].InterestPaidServicingWithDropDate.GetValueOrDefault(0) != 0 || ListFeesTab[index].StrippedFeeReceivableInclInLY.GetValueOrDefault(0) != 0)
                            {
                                NGaapdate.Add(Convert.ToDateTime(gaap.Date));

                                if (gaap.Date == noteDC.ClosingDate)
                                {
                                    if (DeferredFeeAmt != 0 || OrigDeferredFeeAmt != 0)
                                    {
                                        NGaapFee.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0) + DeferredFeeamtPa.GetValueOrDefault(0) + ListFeesTab[index].FeeAmountIncludedinLevelYield.GetValueOrDefault(0) + ListFeesTab[index].StrippedFeeReceivableInclInLY.GetValueOrDefault(0));
                                    }
                                    if (Premium != 0 && Premium != null)
                                    {
                                        NGaapDiscount.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0) + Premium.GetValueOrDefault(0));
                                    }
                                    if (CapCosts != 0 && CapCosts != null)
                                    {
                                        NGaapClosingCost.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0) - CapCosts.GetValueOrDefault(0));
                                    }
                                    NGaapPar.Add(ListBalanceTab[index].EndingBalance.GetValueOrDefault(0) * -1 + stubint);

                                    NGaapAllIn.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0)
                                        + ListCouponTab[index].InterestPaidServicingWithDropDate.GetValueOrDefault(0)
                                        + Premium.GetValueOrDefault(0)
                                        - CapCosts.GetValueOrDefault(0)
                                        - TotalFeeAmt());
                                }
                                else
                                {
                                    if (DeferredFeeAmt != 0 || OrigDeferredFeeAmt != 0)
                                    {
                                        NGaapFee.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0) + ListFeesTab[index].FeeAmountIncludedinLevelYield.GetValueOrDefault(0) + ListFeesTab[index].StrippedFeeReceivableInclInLY.GetValueOrDefault(0));
                                    }
                                    if (Premium != 0 && Premium != null)
                                    {
                                        NGaapDiscount.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0));
                                    }
                                    if (CapCosts != 0 && CapCosts != null)
                                    {
                                        NGaapClosingCost.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0));
                                    }

                                    if (ServicingOverride == "N")
                                    {
                                        NGaapPar.Add(ListCouponTab[index].InterestforthePeriod.GetValueOrDefault(0) + gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0));
                                    }
                                    else
                                    {
                                        NGaapPar.Add(ListCouponTab[index].InterestPaidServicingWithDropDate.GetValueOrDefault(0) + gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0));
                                    }
                                    NGaapAllIn.Add(gaap.NetPrincipalInflowOutflow.GetValueOrDefault(0) + ListCouponTab[index].InterestPaidServicingWithDropDate.GetValueOrDefault(0) + FeeReceivedByDate(gaap.Date.Value));
                                }
                            }
                            index = index + 1;
                        }
                    }

                    //' Calculating Yield                     
                    AddToListYieldCalcInputList(NGaapFee, NGaapdate, "FeeAmortYield", unique.UniqueDate);
                    FeeAmortYield = cXIRR(NGaapFee, NGaapdate);
                    AddToListYieldCalcInputList(NGaapDiscount, NGaapdate, "DiscountAmortYield", unique.UniqueDate);
                    DiscountAmortYield = cXIRR(NGaapDiscount, NGaapdate);

                    AddToListYieldCalcInputList(NGaapClosingCost, NGaapdate, "ClosingCostAmortYield", unique.UniqueDate);
                    ClosingCostAmortYield = cXIRR(NGaapClosingCost, NGaapdate);

                    AddToListYieldCalcInputList(NGaapPar, NGaapdate, "parYield", unique.UniqueDate);
                    parYield = cXIRR(NGaapPar, NGaapdate);

                    AddToListYieldCalcInputList(NGaapAllIn, NGaapdate, "allinyield", unique.UniqueDate);
                    allinyield = cXIRR(NGaapAllIn, NGaapdate);
                    if (calculationMode == "Cash Flow Only")
                    {
                        ListYields.Add(new YieldDataContract(unique.UniqueDate, "DeferredFeeYield", FeeAmortYield));
                        ListYields.Add(new YieldDataContract(unique.UniqueDate, "DiscountPremiumYield", DiscountAmortYield));
                        ListYields.Add(new YieldDataContract(unique.UniqueDate, "ClosingCostYield", ClosingCostAmortYield));

                    }
#if (DEBUG)
                    trace.FeeYieldCF.Add(new ProspectiveCashflow(NGaapdate, NGaapFee, unique.UniqueDate, FeeAmortYield));
                    trace.DiscYieldCF.Add(new ProspectiveCashflow(NGaapdate, NGaapDiscount, unique.UniqueDate, DiscountAmortYield));
#endif
                    //Calculating Basis
                    index = 1;
                    temgaapindex = 1;
                    foreach (var gaap in ListGAAPBasisTab.Skip(1))
                    {
                        if (gaap.Date >= unique.UniqueDate)
                        {
                            cfcell = temgaapindex + 1;
                            FeeAmortBasis = 0;
                            DiscountAmortBasis = 0;
                            ClosingAmortBasis = 0;
                            AllinBasis = 0;
                            parBasis = 0;
                            InterestPaidperServicing = 0;
                            FeeAmountInc = 0;
                            index = ListGAAPBasisTab.FindIndex(x => x.Date == gaap.Date) + 1;
                            foreach (var basis in ListGAAPBasisTab.Skip(index))
                            {
                                if (cfcell <= ListGAAPBasisTab.Count - 1)
                                {
                                    InterestPaidperServicing = ListCouponTab[cfcell].InterestPaidServicingWithDropDate.GetValueOrDefault(0);
                                }
                                else
                                {
                                    InterestPaidperServicing = 0;
                                }
                                if (cfcell <= ListFeesTab.Count - 1)
                                {
                                    FeeAmountInc = ListFeesTab[cfcell].FeeAmountIncludedinLevelYield.GetValueOrDefault(0) + ListFeesTab[cfcell].StrippedFeeReceivableInclInLY.GetValueOrDefault(0);
                                }
                                else
                                {
                                    FeeAmountInc = 0;
                                }
                                if (basis.NetPrincipalInflowOutflow.GetValueOrDefault(0) != 0 || FeeAmountInc != 0 || InterestPaidperServicing != 0)
                                {
                                    //XNPV Calculation:
                                    dateDifference = Convert.ToDouble(Convert.ToDouble(Convert.ToDateTime(basis.Date).Subtract(Convert.ToDateTime(gaap.Date)).Days) / 365);
                                    if (DeferredFeeAmt != 0 || OrigDeferredFeeAmt != 0)
                                    {
                                        FeeAmortBasis = FeeAmortBasis + NumericExtensions.SafeDivision(Convert.ToDecimal(basis.NetPrincipalInflowOutflow + FeeAmountInc),
                                        NumericExtensions.CalcPowAndCheckNaN(Convert.ToDouble(1 + FeeAmortYield), dateDifference));
                                    }

                                    if (Premium != 0 && Premium != null)
                                    {
                                        DiscountAmortBasis = DiscountAmortBasis + NumericExtensions.SafeDivision(Convert.ToDecimal(basis.NetPrincipalInflowOutflow),
                                    NumericExtensions.CalcPowAndCheckNaN(Convert.ToDouble(1 + DiscountAmortYield), dateDifference));
                                    }

                                    if (CapCosts != 0 && CapCosts != null)
                                    {
                                        ClosingAmortBasis = ClosingAmortBasis + NumericExtensions.SafeDivision(Convert.ToDecimal(basis.NetPrincipalInflowOutflow),
                                    NumericExtensions.CalcPowAndCheckNaN(Convert.ToDouble(1 + ClosingCostAmortYield), dateDifference));
                                    }

                                    parBasis = parBasis + NumericExtensions.SafeDivision(Convert.ToDecimal(basis.NetPrincipalInflowOutflow + InterestPaidperServicing),
                            NumericExtensions.CalcPowAndCheckNaN(Convert.ToDouble(1 + parYield), dateDifference));

                                    AllinBasis = AllinBasis + NumericExtensions.SafeDivision(Convert.ToDecimal(basis.NetPrincipalInflowOutflow + InterestPaidperServicing + FeeReceivedByDate(basis.Date.Value)),
                        NumericExtensions.CalcPowAndCheckNaN(Convert.ToDouble(1 + allinyield), dateDifference));
                                }

                                cfcell = cfcell + 1;
                            }
                            gaap.DeferredFeeAccrualBasis = FeeAmortBasis;
                            gaap.DiscountPremiumAccrualBasis = DiscountAmortBasis;
                            gaap.CapitalizedCostsAccrualBasis = ClosingAmortBasis;
                            gaap.ParBasis = parBasis;
                            gaap.AllInBasis = AllinBasis;
                        }

                        temgaapindex = temgaapindex + 1;
                    }
                    CalculateAmortLYIncome(Convert.ToDateTime(unique.UniqueDate));

#if (DEBUG)
                    trace.FeeBasisCF.Add(new ProspectiveCashflow(this.ListGAAPBasisTab, unique.UniqueDate, FeeAmortYield, "Fee"));
                    trace.DiscBasisCF.Add(new ProspectiveCashflow(this.ListGAAPBasisTab, unique.UniqueDate, DiscountAmortYield, "Discount"));
                    trace.FeeAmort.Add(new ProspectiveCashflow(ListGAAPBasisTab, unique.UniqueDate, FeeAmortYield, "FeeAmort"));
                    trace.DiscAmort.Add(new ProspectiveCashflow(ListGAAPBasisTab, unique.UniqueDate, DiscountAmortYield, "DiscAmort"));
#endif
                }
            }
        }

        public Decimal FeeReceivedByDate(DateTime currentdate)
        {
            Decimal feeamt = 0;

            foreach (FeeOutputDataContract fod in ListFeeOutput)
            {
                if (fod.Date == currentdate)
                {
                    feeamt = feeamt + fod.FeeAmount.GetValueOrDefault(0);
                }
            }
            return feeamt;
        }

        public Decimal TotalFeeAmt()
        {
            Decimal feeamt = 0;

            foreach (FeeOutputDataContract fod in ListFeeOutput)
            {
                feeamt = feeamt + fod.FeeAmount.GetValueOrDefault(0);
            }
            return feeamt;
        }

        public void GenerateInterestAccrualDates(DateTime? effectivedate, DateTime? prevMaturityDate)
        {
            int accYear, accMonth, initialDay, listIndex, accFreq, relativeMo, refday, leaddays, accDay, pmtAccYear, pmtAccMo, payFreq, bdayLag;
            int? pmtDayMo, pmtAccDay;
            DateTime initialDate, finalDate, refDate, firstResetDate, firstPmtDate;
            DateTime? PeriodStartDate;
#pragma warning disable CS0219 // The variable 'dailyStep' is assigned but its value is never used
            decimal dailyStep = 0, indexResetFreq;
#pragma warning restore CS0219 // The variable 'dailyStep' is assigned but its value is never used
            initialDate = Convert.ToDateTime(noteDC.InitialInterestAccrualEndDate);
            int bdaylagpmtdropdate = noteDC.BusinessdaylafrelativetoPMTDate.GetValueOrDefault(0);
            int daymopmtdropdate = noteDC.DayoftheMonth.GetValueOrDefault(0);

            // finalDate = Convert.ToDateTime(noteDC.FinalInterestAccrualEndDateOverride);
            finalDate = accEndDate.Value.Date;
            if (noteDC.AccrualFrequency != null)
            {
                accFreq = Convert.ToInt16(noteDC.AccrualFrequency);
            }
            else
            {
                accFreq = 0;
            }
            relativeMo = Convert.ToInt16(noteDC.DeterminationDateInterestAccrualPeriod);
            refday = Convert.ToInt16(noteDC.DeterminationDateReferenceDayoftheMonth);
            leaddays = Convert.ToInt16(noteDC.DeterminationDateLeadDays);
            firstResetDate = Convert.ToDateTime(BusinessDayAdjustment(Convert.ToDateTime(noteDC.FirstRateIndexResetDate), "Index Date", 0));

            indexResetFreq = noteDC.RateIndexResetFreq.GetValueOrDefault(0);
            pmtDayMo = noteDC.AccrualPeriodPaymentDayWhenNotEOMonth.GetValueOrDefault(0);
            payFreq = Convert.ToInt16(noteDC.PayFrequency);
            firstPmtDate = Convert.ToDateTime(BusinessDayAdjustment(Convert.ToDateTime(noteDC.FirstPaymentDate), "PMT Date", null));
            bdayLag = Convert.ToInt16(noteDC.PaymentDateBusinessDayLag);
            initialDay = initialDate.Day;

            if (effectivedate == noteDC.ClosingDate)
            {
                InterestAccrualDates interestAccrualDates = new InterestAccrualDates();

                if (noteDC.StubPaidinAdvanceYNText == "Y")
                {
                    interestAccrualDates.InterestAccrualPeriodEndDates = CreateNewDate(initialDate.Year, initialDate.Month - accFreq, initialDate.Day);
                }
                else
                {
                    interestAccrualDates.InterestAccrualPeriodEndDates = initialDate;
                }

                interestAccrualDates.InterestAccrualPeriodStartDates = Convert.ToDateTime(noteDC.ClosingDate);
                interestAccrualDates.NumofDaysinAccrualPeriod = (Convert.ToInt32((interestAccrualDates.InterestAccrualPeriodEndDates.Value - interestAccrualDates.InterestAccrualPeriodStartDates.Value).TotalDays) + 1);
                interestAccrualDates.IndexReferenceDateNotAdjusted = Convert.ToDateTime(noteDC.ClosingDate);
                interestAccrualDates.IndexReferenceDateAdjusted = Convert.ToDateTime(noteDC.ClosingDate);
                interestAccrualDates.RateIndexResetTag = 1;
                if (noteDC.IOTerm > 0)
                {
                    ListRemIoTerm.Add(Convert.ToInt32(noteDC.IOTerm) + 1);
                }
                else
                {
                    ListRemIoTerm.Add(0);
                }
                pmtAccYear = interestAccrualDates.InterestAccrualPeriodEndDates.Value.Year;
                pmtAccMo = interestAccrualDates.InterestAccrualPeriodEndDates.Value.Month;

                if (pmtDayMo == null || pmtDayMo == 0)

                    // pmtAccDay = initialDate.AddDays(1).Day;
                    pmtAccDay = interestAccrualDates.InterestAccrualPeriodEndDates.Value.Day + 1;
                else
                    pmtAccDay = pmtDayMo;
                interestAccrualDates.PMTDateNotAdjustedBusinessDay = CreateNewDate(pmtAccYear, pmtAccMo, Convert.ToInt32(pmtAccDay));
                if (daymopmtdropdate != 0)
                {
                    interestAccrualDates.ModeledPMTDropDate = CreateNewDate(pmtAccYear, pmtAccMo - 1, daymopmtdropdate);
                }
                else
                {
                    interestAccrualDates.ModeledPMTDropDate = GetnextWorkingDays(Convert.ToDateTime(interestAccrualDates.PMTDateNotAdjustedBusinessDay), daymopmtdropdate, DisableBusinessDayAdjustmentText);
                }

                if (interestAccrualDates.InterestAccrualPeriodEndDates.Value.AddDays(1) == firstPmtDate)
                    interestAccrualDates.PMTDateAccrualEndTag = 1;
                else
                    interestAccrualDates.PMTDateAccrualEndTag = 0;

                int tempTotaldays = Convert.ToInt32((firstPmtDate - initialDate).TotalDays);

                if (tempTotaldays <= 1)
                    interestAccrualDates.PayAccFreqTag = 0;
                else
                    interestAccrualDates.PayAccFreqTag = Convert.ToInt32(Math.Max(0, firstPmtDate.Month - interestAccrualDates.InterestAccrualPeriodEndDates.Value.Month));
                //Payment Date Referenced for Interest Accrual Period - Adjusted for Business Day
                pmtAccYear = interestAccrualDates.PMTDateNotAdjustedBusinessDay.Value.Year;
                pmtAccMo = interestAccrualDates.PMTDateNotAdjustedBusinessDay.Value.Month + interestAccrualDates.PayAccFreqTag.Value;
                pmtAccDay = interestAccrualDates.PMTDateNotAdjustedBusinessDay.Value.Day;
                interestAccrualDates.PMTDateAccuralPeriodAdjusted = GetnextWorkingDays(CreateNewDate(pmtAccYear, pmtAccMo, Convert.ToInt32(pmtAccDay)).AddDays(1), bdayLag, DisableBusinessDayAdjustmentText);
                //interestAccrualDates.PMTDateWorkingDayAdjusted = GetPrevWorkingDay(new DateTime(pmtAccYear, pmtAccMo, Convert.ToInt32(pmtAccDay)));
                //interestAccrualDates.PMTDateWorkingDayAdjusted = BusinessDayAdjustment(interestAccrualDates.PMTDateNotAdjustedBusinessDay.Value, "PMT Date", null);
                interestAccrualDates.PMTDateWorkingDayAdjusted = GetWorkingDayUsingOffset(Convert.ToDateTime(interestAccrualDates.PMTDateNotAdjustedBusinessDay.Value.AddDays(1)), Convert.ToInt16(bdayLag), "PMT Date");
                ListInterestAccrualDates.Add(interestAccrualDates);
                listIndex = 0;
            }
            else
            {
                if (SelectedMaturityDateLatest >= prevMaturityDate)
                    listIndex = Math.Max(0, ListInterestAccrualDates.FindIndex(acc => acc.InterestAccrualPeriodEndDates == prevAccEndDate) - 1);
                else
                    listIndex = Math.Max(0, ListInterestAccrualDates.FindIndex(acc => acc.InterestAccrualPeriodEndDates == finalDate) - 2);
            }

            while (ListInterestAccrualDates[listIndex].InterestAccrualPeriodEndDates < finalDate)
            {
                InterestAccrualDates NewinterestAccrualDates = new InterestAccrualDates();
                accYear = 0;
                accMonth = 0;
                accDay = 0;

                if (accFreq >= 1)
                {
                    accYear = ListInterestAccrualDates[listIndex].InterestAccrualPeriodEndDates.Value.Year;
                    accMonth = ListInterestAccrualDates[listIndex].InterestAccrualPeriodEndDates.Value.Month + accFreq;
                    pmtAccYear = ListInterestAccrualDates[listIndex].PMTDateNotAdjustedBusinessDay.Value.Year;
                    pmtAccMo = ListInterestAccrualDates[listIndex].PMTDateNotAdjustedBusinessDay.Value.Month + accFreq;

                    if (accMonth > 12)
                    {
                        accYear = accYear + 1;
                        accMonth = accMonth - 12;
                    }

                    if (pmtAccMo > 12)
                    {
                        pmtAccYear = pmtAccYear + 1;
                        pmtAccMo = pmtAccMo - 12;
                    }

                    if (initialDay >= 28)
                    {
                        accDay = LastDateOfMonth(ListInterestAccrualDates[listIndex].InterestAccrualPeriodEndDates.Value.AddMonths(accFreq)).Day;
                    }
                    else
                        accDay = initialDay;

                    if (pmtDayMo == null || pmtDayMo == 0)
                        pmtAccDay = ListInterestAccrualDates[listIndex].PMTDateNotAdjustedBusinessDay.Value.Day;
                    else
                        pmtAccDay = pmtDayMo;
                }
                else
                {
                    pmtAccYear = ListInterestAccrualDates[listIndex].PMTDateNotAdjustedBusinessDay.Value.Year;
                    pmtAccMo = ListInterestAccrualDates[listIndex].PMTDateNotAdjustedBusinessDay.Value.Month + accFreq;
                    pmtAccDay = ListInterestAccrualDates[listIndex].PMTDateNotAdjustedBusinessDay.Value.Day;
                }

                NewinterestAccrualDates.InterestAccrualPeriodEndDates = CreateNewDate(accYear, accMonth, accDay);
                NewinterestAccrualDates.InterestAccrualPeriodStartDates = (ListInterestAccrualDates[listIndex].InterestAccrualPeriodEndDates.Value).AddDays(1);
                NewinterestAccrualDates.NumofDaysinAccrualPeriod = Convert.ToInt32((NewinterestAccrualDates.InterestAccrualPeriodEndDates.Value - NewinterestAccrualDates.InterestAccrualPeriodStartDates.Value).TotalDays) + 1;

                PeriodStartDate = BusinessDayAdjustment(Convert.ToDateTime(NewinterestAccrualDates.InterestAccrualPeriodStartDates), "PMT Date", null);

                if (refday == 0)
                {
                    refDate = CreateNewDate(PeriodStartDate.Value.Year, PeriodStartDate.Value.Month + relativeMo, PeriodStartDate.Value.Day);// + leaddays);
                }
                else
                {
                    refDate = CreateNewDate(PeriodStartDate.Value.Year, PeriodStartDate.Value.Month + relativeMo, refday);
                }

                NewinterestAccrualDates.IndexReferenceDateNotAdjusted = BusinessDayAdjustment(refDate, "Index Date", leaddays);
                if (NewinterestAccrualDates.NumofDaysinAccrualPeriod > 27)
                {
                    ListRemIoTerm.Add(Math.Max(0, ListRemIoTerm[listIndex] - 1));
                }
                else
                {
                    if (listIndex > 0)
                    {
                        ListRemIoTerm.Add(ListRemIoTerm[listIndex]);
                    }
                    else
                    {
                        ListRemIoTerm.Add(ListRemIoTerm[0]);
                    }
                }
                // Index Reset Tag

                if (NewinterestAccrualDates.IndexReferenceDateNotAdjusted == firstResetDate)
                {
                    NewinterestAccrualDates.RateIndexResetTag = 1;
                }
                else if (NewinterestAccrualDates.InterestAccrualPeriodStartDates > firstResetDate)
                {
                    NewinterestAccrualDates.RateIndexResetTag = 1;
                }
                else
                {
                    NewinterestAccrualDates.RateIndexResetTag = 0;
                }
                // Ref Date Adjusted for Reset
                if (NewinterestAccrualDates.RateIndexResetTag == 1)
                {
                    NewinterestAccrualDates.IndexReferenceDateAdjusted = NewinterestAccrualDates.IndexReferenceDateNotAdjusted;
                }
                else
                {
                    NewinterestAccrualDates.IndexReferenceDateAdjusted = ListInterestAccrualDates[listIndex].IndexReferenceDateAdjusted;
                }

                if (accFreq > 1)
                {
                    DateTime? prevdate = ListInterestAccrualDates[listIndex].PMTDateNotAdjustedBusinessDay;
                    NewinterestAccrualDates.PMTDateNotAdjustedBusinessDay = CreateNewDate(prevdate.Value.Year, prevdate.Value.Month + accFreq, prevdate.Value.Day);
                }
                else
                {
                    NewinterestAccrualDates.PMTDateNotAdjustedBusinessDay = CreateNewDate(pmtAccYear, pmtAccMo, Convert.ToInt32(pmtAccDay));
                }

                if (daymopmtdropdate != 0)
                {
                    NewinterestAccrualDates.ModeledPMTDropDate = CreateNewDate(NewinterestAccrualDates.PMTDateNotAdjustedBusinessDay.Value.Year, NewinterestAccrualDates.PMTDateNotAdjustedBusinessDay.Value.Month - 1, daymopmtdropdate);
                }
                else
                {
                    NewinterestAccrualDates.ModeledPMTDropDate = GetnextWorkingDays(Convert.ToDateTime(NewinterestAccrualDates.PMTDateNotAdjustedBusinessDay), daymopmtdropdate, DisableBusinessDayAdjustmentText);
                }

                if (NewinterestAccrualDates.InterestAccrualPeriodEndDates.Value.AddDays(1) == firstPmtDate)
                {
                    NewinterestAccrualDates.PMTDateAccrualEndTag = 1;
                }
                else if (NewinterestAccrualDates.InterestAccrualPeriodEndDates.Value.AddDays(1) > firstPmtDate)
                {
                    if ((NewinterestAccrualDates.InterestAccrualPeriodEndDates.Value.AddMonths(1).Month - firstPmtDate.Month) % payFreq == 0)
                    {
                        NewinterestAccrualDates.PMTDateAccrualEndTag = 1;
                    }
                    else
                    {
                        NewinterestAccrualDates.PMTDateAccrualEndTag = 0;
                    }
                }
                else
                {
                    NewinterestAccrualDates.PMTDateAccrualEndTag = 0;
                }

                if (NewinterestAccrualDates.PMTDateAccrualEndTag == 1)
                    NewinterestAccrualDates.PayAccFreqTag = Math.Max(0, payFreq - accFreq);
                else if (NewinterestAccrualDates.PMTDateAccrualEndTag == 0)
                    NewinterestAccrualDates.PayAccFreqTag = ListInterestAccrualDates[listIndex].PayAccFreqTag - 1;
                else
                    NewinterestAccrualDates.PayAccFreqTag = 0;

                //'Payment Date Referenced for Interest Accrual Period - Adjusted for Business Day
                pmtAccYear = NewinterestAccrualDates.PMTDateNotAdjustedBusinessDay.Value.Year;
                pmtAccMo = NewinterestAccrualDates.PMTDateNotAdjustedBusinessDay.Value.Month + NewinterestAccrualDates.PayAccFreqTag.GetValueOrDefault(0);
                pmtAccDay = NewinterestAccrualDates.PMTDateNotAdjustedBusinessDay.Value.Day;
                NewinterestAccrualDates.PMTDateAccuralPeriodAdjusted = GetMinDate(SelectedMaturityDateLatest.Value, GetnextWorkingDays(CreateNewDate(pmtAccYear, pmtAccMo, Convert.ToInt32(pmtAccDay)).AddDays(1), bdayLag, DisableBusinessDayAdjustmentText));
                NewinterestAccrualDates.PMTDateWorkingDayAdjusted = GetMinDate(SelectedMaturityDateLatest.Value, GetWorkingDayUsingOffset(Convert.ToDateTime(NewinterestAccrualDates.PMTDateNotAdjustedBusinessDay.Value.AddDays(1)), Convert.ToInt16(bdayLag), "PMT Date"));
                InsertUpdateAccrualDate(NewinterestAccrualDates);
                listIndex = listIndex + 1;
            }
        }

        private void InsertUpdateAccrualDate(InterestAccrualDates accrualDates)
        {
            int ndx = 0;
            ndx = ListInterestAccrualDates.FindIndex(acc => acc.InterestAccrualPeriodEndDates == accrualDates.InterestAccrualPeriodEndDates);

            if (ndx >= 0)
                ListInterestAccrualDates[ndx] = accrualDates;
            else
                ListInterestAccrualDates.Add(accrualDates);
        }
        public static DateTime GenerateDate(int year, int month, int days)
        {
            if (days == 0)
                month = month - 1;

            if (month == 0)
            {
                year = year - 1;
                month = 12;
            }

            int lastDayOfMonth = DateTime.DaysInMonth(year, month);
            return new DateTime(year, month, lastDayOfMonth);
        }

        public void CalculateDatesTab(DateTime? effectivedate, DateTime? prevMaturityDate)
        {
            int listIndex = 0;
            GenerateInterestAccrualDates(effectivedate, prevMaturityDate);
            if (effectivedate != noteDC.ClosingDate)
            {
                if (SelectedMaturityDateLatest >= prevMaturityDate) //Extension: Start updating from the final accrual period onwards.
                    listIndex = Math.Max(ListInterestAccrualDates.FindIndex(acc => acc.InterestAccrualPeriodEndDates == this.prevAccEndDate), 0);
                else                                                //Retrogressing: Need to update only the 'New' Final Accrual period.
                    listIndex = Math.Max(ListInterestAccrualDates.FindIndex(acc => acc.InterestAccrualPeriodEndDates == this.accEndDate) - 1, 0);
            }
            //while (listIndex < ListInterestAccrualDates.Count)
            foreach (InterestAccrualDates intAcc in ListInterestAccrualDates.Skip(listIndex))
            {
                DatesTab datesTab = new DatesTab();

                datesTab.InterestAccrualPeriodEndDateArray = ListInterestAccrualDates[listIndex].InterestAccrualPeriodEndDates;
                datesTab.InterestAccrualPeriodStartDateArray = ListInterestAccrualDates[listIndex].InterestAccrualPeriodStartDates;
                datesTab.NumberofDaysintheAccrualPeriod = ListInterestAccrualDates[listIndex].NumofDaysinAccrualPeriod;
                datesTab.FloatingRateIndexReferenceDateNotAdjustedforResetFreq = ListInterestAccrualDates[listIndex].IndexReferenceDateNotAdjusted;
                datesTab.RateIndexResetTag = ListInterestAccrualDates[listIndex].RateIndexResetTag;
                datesTab.FloatingRateIndexReferenceDateAdjustedforResetFrequency = ListInterestAccrualDates[listIndex].IndexReferenceDateAdjusted;
                datesTab.PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay = ListInterestAccrualDates[listIndex].PMTDateAccuralPeriodAdjusted;
                datesTab.PaymentDateAdjustedforWorkingDay = ListInterestAccrualDates[listIndex].PMTDateWorkingDayAdjusted;
                datesTab.PaymentDateRelativetoAccrualEndDateTag = ListInterestAccrualDates[listIndex].PMTDateAccrualEndTag;
                datesTab.PaymentDateusingAccrualFreqNotAdjustedforBusinessDay = ListInterestAccrualDates[listIndex].PMTDateNotAdjustedBusinessDay;
                datesTab.PayAccFreqTag = ListInterestAccrualDates[listIndex].PayAccFreqTag;
                datesTab.ModeledPMTDropDate = ListInterestAccrualDates[listIndex].ModeledPMTDropDate;
                if (noteDC.ListDropDateSetup != null)
                {
                    if (noteDC.ListDropDateSetup.Count > 0)
                    {
                        datesTab.PMTDropDateUsed = GetDropDateOverride(datesTab.PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay);
                        if (datesTab.PMTDropDateUsed == null)
                        {
                            datesTab.PMTDropDateUsed = ListInterestAccrualDates[listIndex].ModeledPMTDropDate;
                        }
                    }
                    else
                    {
                        datesTab.PMTDropDateUsed = ListInterestAccrualDates[listIndex].ModeledPMTDropDate;
                    }
                }
                else
                {
                    datesTab.PMTDropDateUsed = ListInterestAccrualDates[listIndex].ModeledPMTDropDate;
                }
                datesTab.RemIoTerm = ListRemIoTerm[listIndex];
                InsertUpdateDates(datesTab);
                listIndex = listIndex + 1;
            }
        }
        private void InsertUpdateDates(DatesTab dates)
        {
            int ndx = 0;
            ndx = ListDatesTab.FindIndex(dt => dt.InterestAccrualPeriodEndDateArray == dates.InterestAccrualPeriodEndDateArray);
            if (ndx >= 0)
                ListDatesTab[ndx] = dates;
            else
                ListDatesTab.Add(dates);
        }
        public void CalculateRatesTab(DateTime effectiveDate)
        {
            DateTime? RateDate, IntAccStartDate = null;
            DateTime ClosingDate, firstResetDate, IndexLookupDate;
            decimal? mostrecentlibor = 0;
            int listIndex = 0;
            int RoundOff = 12;
            decimal? indexCap = 0, indexFloor = 0;
            ClosingDate = Convert.ToDateTime(noteDC.ClosingDate);
            indexCap = GetValueFromCouponSchedule("Index Cap", ClosingDate);
            indexFloor = GetValueFromCouponSchedule("Index Floor", ClosingDate);
#pragma warning disable CS0219 // The variable 'RateSpreadScheduleList' is assigned but its value is never used
            List<RateSpreadSchedule> RateSpreadScheduleList = null;
#pragma warning restore CS0219 // The variable 'RateSpreadScheduleList' is assigned but its value is never used
            if (indexCap == 0)
            {
                indexCap = 100;
            }

            if (noteDC.IndexRoundingRule != null && noteDC.IndexRoundingRule != 0)
                RoundOff = (noteDC.IndexRoundingRule).ToString().Length - 1 + 2;
            if (ListRateTab.Count > 0)
                RateDate = ListRateTab[0].rateDate;
            else
                RateDate = null;
            firstResetDate = Convert.ToDateTime(noteDC.FirstRateIndexResetDate);
            IndexLookupDate = firstResetDate;
            if (ListInterestAccrualDates.Count > 1)
            {
                IntAccStartDate = ListInterestAccrualDates[1].InterestAccrualPeriodStartDates.Value.Date;
            }
            else
            {
                IntAccStartDate = DateTime.MinValue;
            }
            //Determine LIBOR Value
            foreach (var rate in ListRateTab)
            {
                if (Convert.ToDateTime(rate.rateDate).Date >= effectiveDate.Date)
                {
                    if (noteDC.StubPaidinAdvanceYNText == "N" && noteDC.LoanPurchaseYNText == "N")
                    {
                        IndexLookupDate = ListInterestAccrualDates[1].IndexReferenceDateAdjusted.Value;
                    }

                    if (rate.rateDate == IntAccStartDate)
                    {
                        decimal? LiborValue = 0;

                        foreach (LiborScheduleTab lst in ListLiborScheduleTabLatest)
                        {
                            if (lst.Date == IndexLookupDate)
                            {
                                LiborValue = lst.Value;
                            }
                            else if (lst.Date > IndexLookupDate)
                            {
                                break;
                            }
                        }
                        if (LiborValue == 0)
                        {
                            mostrecentlibor = GetMostRecentLiborValue(rate.rateDate);
                            LiborValue = mostrecentlibor;
                        }
                        else
                        {
                            mostrecentlibor = LiborValue;
                        }
                        if (LiborValue != 0)
                        {
                            string valueType = noteDC.RoundingMethodText; //"Nearest";
                            if (valueType == null)
                                valueType = "";
                            if (valueType != null && valueType != "")
                            {
                                if (Enum.IsDefined(typeof(EnmRoundMethodType), valueType.Replace(' ', '_')))
                                {
                                    EnmRoundMethodType eRateType = ((EnmRoundMethodType)Enum.Parse(typeof(EnmRoundMethodType), valueType.Replace(' ', '_')));
                                    switch (eRateType)
                                    {
                                        case EnmRoundMethodType.Nearest:
                                            rate.IndexValueusingFloatingRateIndexReferenceDate = Math.Round(LiborValue.GetValueOrDefault(0), RoundOff);
                                            break;

                                        case EnmRoundMethodType.Up:
                                            rate.IndexValueusingFloatingRateIndexReferenceDate = Convert.ToDecimal(RoundUp(Convert.ToDouble(LiborValue.GetValueOrDefault(0)), RoundOff));  //LiborValue.GetValueOrDefault(0);
                                            break;

                                        case EnmRoundMethodType.Down:
                                            rate.IndexValueusingFloatingRateIndexReferenceDate = Convert.ToDecimal(RoundDown(Convert.ToDouble(LiborValue.GetValueOrDefault(0)), RoundOff));
                                            break;

                                        default:
                                            rate.IndexValueusingFloatingRateIndexReferenceDate = Math.Round(LiborValue.GetValueOrDefault(0), RoundOff);
                                            break;
                                    }
                                }
                            }
                            else
                            {
                                rate.IndexValueusingFloatingRateIndexReferenceDate = Math.Round(LiborValue.GetValueOrDefault(0), RoundOff);
                            }
                            rate.DIndexValueusingFloatingRateIndexReferenceDate = Math.Max(indexFloor.GetValueOrDefault(0), Math.Min(indexCap.GetValueOrDefault(0), rate.IndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0)));
                        }
                    }
                    else if (noteDC.InitialIndexValueOverride > 0 && rate.rateDate < IntAccStartDate)
                    {
                        rate.IndexValueusingFloatingRateIndexReferenceDate = noteDC.InitialIndexValueOverride;
                        rate.DIndexValueusingFloatingRateIndexReferenceDate = rate.IndexValueusingFloatingRateIndexReferenceDate;
                    }
                    else if (rate.rateDate <= firstResetDate && rate.rateDate <= IntAccStartDate)
                    {
                        decimal? LiborValue;
                        var res = (from Libor in ListLiborScheduleTabLatest
                                   where Libor.Date == ClosingDate
                                   select new { checkResult = true, value = Libor.Value }).FirstOrDefault();

                        #region RoundingChange

                        if (res != null)
                        {
                            if (res.checkResult == true)
                            {
                                LiborValue = res.value;
                                string valueType = noteDC.RoundingMethodText;
                                if (valueType == null)
                                    valueType = "";
                                if (valueType != null && valueType != "")
                                {
                                    if (Enum.IsDefined(typeof(EnmRoundMethodType), valueType.Replace(' ', '_')))
                                    {
                                        EnmRoundMethodType eRateType = ((EnmRoundMethodType)Enum.Parse(typeof(EnmRoundMethodType), valueType.Replace(' ', '_')));
                                        switch (eRateType)
                                        {
                                            case EnmRoundMethodType.Nearest:
                                                rate.IndexValueusingFloatingRateIndexReferenceDate = Math.Round(LiborValue.GetValueOrDefault(0), RoundOff);
                                                break;

                                            case EnmRoundMethodType.Up:
                                                rate.IndexValueusingFloatingRateIndexReferenceDate = Convert.ToDecimal(RoundUp(Convert.ToDouble(LiborValue.GetValueOrDefault(0)), RoundOff));  //LiborValue.GetValueOrDefault(0);
                                                break;

                                            case EnmRoundMethodType.Down:
                                                rate.IndexValueusingFloatingRateIndexReferenceDate = Convert.ToDecimal(RoundDown(Convert.ToDouble(LiborValue.GetValueOrDefault(0)), RoundOff));
                                                break;

                                            default:
                                                rate.IndexValueusingFloatingRateIndexReferenceDate = Math.Round(LiborValue.GetValueOrDefault(0), RoundOff);
                                                break;
                                        }
                                    }
                                }
                                else
                                {
                                    rate.IndexValueusingFloatingRateIndexReferenceDate = Math.Round(LiborValue.GetValueOrDefault(0), RoundOff);
                                }
                                rate.DIndexValueusingFloatingRateIndexReferenceDate = Math.Max(indexFloor.GetValueOrDefault(0), Math.Min(indexCap.GetValueOrDefault(0), rate.IndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0)));
                            }
                            else
                            {
                                if (mostrecentlibor != 0)
                                {
                                    rate.IndexValueusingFloatingRateIndexReferenceDate = Math.Max(indexFloor.GetValueOrDefault(0), Math.Min(indexCap.GetValueOrDefault(0), Math.Round(mostrecentlibor.GetValueOrDefault(0), RoundOff)));
                                }
                            }
                        }
                    }
                    else
                    {
                        if (listIndex > 0)
                        {
                            rate.IndexValueusingFloatingRateIndexReferenceDate = ListRateTab[listIndex - 1].IndexValueusingFloatingRateIndexReferenceDate;
                            rate.DIndexValueusingFloatingRateIndexReferenceDate = Math.Max(indexFloor.GetValueOrDefault(0), Math.Min(indexCap.GetValueOrDefault(0), rate.IndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0)));
                        }
                    }

                    #endregion RoundingChange

                    #region Update Index/Libor - on Interest Accrual Period Start Date
                    foreach (var acc in ListInterestAccrualDates)
                    {
                        if (rate.rateDate > IntAccStartDate)
                        {
                            if (rate.rateDate == acc.InterestAccrualPeriodStartDates)
                            {
                                rate.InterestAccrualPeriodEndDateTag = 1;
                                decimal? LiborValue = 0;

                                var res = (from Libor in ListLiborScheduleTabLatest
                                           where Libor.Date == acc.IndexReferenceDateAdjusted
                                           select new { checkResult = true, value = Libor.Value }).FirstOrDefault();

                                if (res == null)
                                {
                                    mostrecentlibor = GetMostRecentLiborValue(rate.rateDate);
                                    LiborValue = mostrecentlibor;
                                }
                                else
                                {
                                    if (res.checkResult == true)
                                    {
                                        decimal? lvalue = 0;
                                        if (res.value == null || res.value == 0)
                                        {
                                            lvalue = GetMostRecentLiborValue(rate.rateDate);
                                        }
                                        else
                                        {
                                            lvalue = res.value;
                                        }
                                        mostrecentlibor = lvalue;
                                        LiborValue = lvalue;
                                    }
                                }
                                if (LiborValue != 0)
                                {
                                    string valueType = noteDC.RoundingMethodText; //"Nearest";
                                    if (valueType == null)
                                        valueType = "";

                                    if (valueType != null && valueType != "")
                                    {
                                        if (Enum.IsDefined(typeof(EnmRoundMethodType), valueType.Replace(' ', '_')))
                                        {
                                            EnmRoundMethodType eRateType = ((EnmRoundMethodType)Enum.Parse(typeof(EnmRoundMethodType), valueType.Replace(' ', '_')));

                                            switch (eRateType)
                                            {
                                                case EnmRoundMethodType.Nearest:
                                                    rate.IndexValueusingFloatingRateIndexReferenceDate = Math.Round(LiborValue.GetValueOrDefault(0), RoundOff);
                                                    rate.DIndexValueusingFloatingRateIndexReferenceDate = Math.Max(indexFloor.GetValueOrDefault(0), Math.Min(indexCap.GetValueOrDefault(0), rate.IndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0)));
                                                    break;

                                                case EnmRoundMethodType.Up:
                                                    rate.IndexValueusingFloatingRateIndexReferenceDate = Convert.ToDecimal(RoundUp(Convert.ToDouble(LiborValue.GetValueOrDefault(0)), RoundOff));
                                                    rate.DIndexValueusingFloatingRateIndexReferenceDate = Math.Max(indexFloor.GetValueOrDefault(0), Math.Min(indexCap.GetValueOrDefault(0), rate.IndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0)));  //decimal.Round(LiborValue, RoundOff, MidpointRounding);
                                                    break;

                                                case EnmRoundMethodType.Down:
                                                    rate.IndexValueusingFloatingRateIndexReferenceDate = Convert.ToDecimal(RoundDown(Convert.ToDouble(LiborValue.GetValueOrDefault(0)), RoundOff));
                                                    rate.DIndexValueusingFloatingRateIndexReferenceDate = Math.Max(indexFloor.GetValueOrDefault(0), Math.Min(indexCap.GetValueOrDefault(0), rate.IndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0)));
                                                    break;

                                                default:
                                                    rate.IndexValueusingFloatingRateIndexReferenceDate = Math.Round(LiborValue.GetValueOrDefault(0), RoundOff);
                                                    rate.DIndexValueusingFloatingRateIndexReferenceDate = Math.Max(indexFloor.GetValueOrDefault(0), Math.Min(indexCap.GetValueOrDefault(0), rate.IndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0)));
                                                    break;
                                            }
                                        }
                                    }
                                    else
                                    {
                                        rate.IndexValueusingFloatingRateIndexReferenceDate = Math.Round(LiborValue.GetValueOrDefault(0), RoundOff);
                                        rate.DIndexValueusingFloatingRateIndexReferenceDate = Math.Max(indexFloor.GetValueOrDefault(0), Math.Min(indexCap.GetValueOrDefault(0), rate.IndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0)));
                                    }
                                }

                                break;
                            }
                        }
                    }
                    #endregion Update Index/Libor

                    #region Check For Spread & Index Floor change
                    if (noteDC.RateSpreadScheduleList != null)
                    {
                        foreach (var rateSpread in ListRateSpreadScheduleLatest)
                        {
                            //if (rateSpread.EffectiveDate.Value.Date == effectiveDate.Date)
                            {
                                if (rateSpread.Date != null && rate.rateDate >= rateSpread.Date)
                                {
                                    string valueType = rateSpread.ValueTypeText;
                                    if (valueType != null && valueType != "")
                                    {
                                        if (Enum.IsDefined(typeof(EnmRateType), valueType.Replace(' ', '_')))
                                        {
                                            EnmRateType eRateType = ((EnmRateType)Enum.Parse(typeof(EnmRateType), valueType.Replace(' ', '_')));
                                            switch (eRateType)
                                            {
                                                case EnmRateType.Rate:
                                                    rate.CouponRate = rateSpread.Value;
                                                    rate.CouponStrip = rateSpread.RateOrSpreadToBeStripped.GetValueOrDefault(0);
                                                    ListCouponTab[listIndex].InterestCalcMethod = rateSpread.IntCalcMethodText;
                                                    rate.CouponSpread = 0;
                                                    rate.RateType = rateSpread.ValueTypeText;
                                                    break;

                                                case EnmRateType.Spread:
                                                    rate.CouponSpread = rateSpread.Value;
                                                    rate.CouponStrip = rateSpread.RateOrSpreadToBeStripped.GetValueOrDefault(0);
                                                    ListCouponTab[listIndex].InterestCalcMethod = rateSpread.IntCalcMethodText;
                                                    rate.CouponRate = 0;
                                                    rate.RateType = rateSpread.ValueTypeText;
                                                    break;

                                                case EnmRateType.Index_Floor:
                                                    indexFloor = rateSpread.Value;
                                                    rate.IndexFloor = rateSpread.Value;
                                                    rate.RateType = rateSpread.ValueTypeText;
                                                    break;

                                                case EnmRateType.Index_Cap:
                                                    indexCap = rateSpread.Value;
                                                    rate.IndexCap = rateSpread.Value;
                                                    rate.RateType = rateSpread.ValueTypeText;
                                                    break;

                                                case EnmRateType.Coupon_Floor:
                                                    rate.CouponFloor = rateSpread.Value;
                                                    rate.RateType = rateSpread.ValueTypeText;
                                                    break;

                                                case EnmRateType.Coupon_Cap:
                                                    rate.CouponCap = rateSpread.Value;
                                                    rate.RateType = rateSpread.ValueTypeText;
                                                    break;

                                                case EnmRateType.Amort_Rate:
                                                    rate.AmortRate = rateSpread.Value;
                                                    rate.RateType = rateSpread.ValueTypeText;
                                                    break;

                                                case EnmRateType.Amort_Spread:
                                                    rate.AmortSpread = rateSpread.Value;
                                                    rate.RateType = rateSpread.ValueTypeText;
                                                    break;

                                                case EnmRateType.Amort_Rate_Cap:
                                                    rate.AmortRateCap = rateSpread.Value;
                                                    rate.RateType = rateSpread.ValueTypeText;
                                                    break;

                                                case EnmRateType.Amort_Rate_Floor:
                                                    rate.AmortRateFloor = rateSpread.Value;
                                                    rate.RateType = rateSpread.ValueTypeText;
                                                    break;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        rate.IndexCap = (rate.IndexCap == null || rate.IndexCap == 0M) ? 1.0M : rate.IndexCap;
                        rate.DIndexValueusingFloatingRateIndexReferenceDate = Math.Max(rate.IndexFloor.GetValueOrDefault(0), Math.Min(rate.IndexCap.GetValueOrDefault(0), rate.IndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0)));
                    }
                    #endregion Check for Spread & Index Floor change.

                    #region -  Loop through Default Schedule
                    if (noteDC.NoteDefaultScheduleList != null)
                    {
                        foreach (var noteDefaultSchedule in noteDC.NoteDefaultScheduleList)
                        {
                            if (noteDefaultSchedule.StartDate != null && rate.rateDate >= noteDefaultSchedule.StartDate && rate.rateDate < noteDefaultSchedule.EndDate)
                            {
                                // Default Period Tag
                                ListBalanceTab[listIndex].DefaultPeriodTag = 1;

                                string valueType = noteDefaultSchedule.ValueTypeText;
                                if (valueType != null && valueType != "")
                                {
                                    if (Enum.IsDefined(typeof(EnmDefaultScheduleType), valueType.Replace(' ', '_')))
                                    {
                                        EnmDefaultScheduleType eRateType = ((EnmDefaultScheduleType)Enum.Parse(typeof(EnmDefaultScheduleType), valueType.Replace(' ', '_')));
                                        switch (eRateType)
                                        {
                                            case EnmDefaultScheduleType.Default_Rate_Step_Up:
                                                rate.CouponDefaultRateStepUp = noteDefaultSchedule.Value;
                                                rate.AmortDefaultRateStepUp = noteDefaultSchedule.Value;
                                                break;

                                            case EnmDefaultScheduleType.Default_Rate_Override:
                                                rate.CouponDefaultRateOverride = noteDefaultSchedule.Value;
                                                rate.AmortDefaultRateOverride = noteDefaultSchedule.Value;
                                                break;

                                            case EnmDefaultScheduleType.Severity:
                                                rate.SeverityatDefault = noteDefaultSchedule.Value;
                                                break;

                                            case EnmDefaultScheduleType.Debt_Service_Shortfall:
                                                ListBalanceTab.Where(checkDate => checkDate.Date == rate.rateDate).ToList().ForEach(checkValue => checkValue.DebtServiceShortfall = noteDefaultSchedule.Value);
                                                break;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    #endregion Default Schedule

                    //All-In Coupon Rate
                    if (rate.CouponDefaultRateOverride == null)
                    {
                        if (rate.CouponRate == null || rate.CouponRate == 0) //' Floating Rate Loan
                        {
                            rate.AllInCouponRate = Math.Max(rate.CouponSpread.GetValueOrDefault(0) + (rate.CouponSpread.GetValueOrDefault(0) == 0m ? 0 : Math.Max(rate.IndexFloor.GetValueOrDefault(0), rate.DIndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0))), rate.CouponFloor.GetValueOrDefault(0) + rate.CouponDefaultRateStepUp.GetValueOrDefault(0));
                        }
                        else //' Fixed Rate Loan
                        {
                            rate.AllInCouponRate = rate.CouponRate.GetValueOrDefault(0) + rate.CouponDefaultRateStepUp.GetValueOrDefault(0);
                        }
                    }
                    else
                    {
                        rate.AllInCouponRate = rate.CouponDefaultRateOverride;
                    }
                    if (rate.AmortRate == null)
                    {
                        rate.AllInAmortRate = Math.Max(rate.AmortSpread.GetValueOrDefault(0) + Math.Max(rate.IndexFloor.GetValueOrDefault(0), rate.DIndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0)),
                                               rate.AmortRateFloor.GetValueOrDefault(0)) + rate.AmortDefaultRateOverride.GetValueOrDefault(0);
                    }
                    else
                        rate.AllInAmortRate = rate.AmortRate;

                    #region All In PIK Rate -  Loop through PIK Table
                    if (ListNotePIKScheduleLatest != null && ListNotePIKScheduleLatest.Count > 0)
                    {
                        PIKSchedule notePIK = ListNotePIKScheduleLatest.ToArray()[0];
                        if (notePIK.EffectiveDate != null && effectiveDate >= notePIK.EffectiveDate && notePIK.StartDate != null && rate.rateDate >= notePIK.StartDate && rate.rateDate <= notePIK.EndDate)
                        {
                            //Additional PIK interest Rate from PIK Table
                            rate.AdditionalPIKinterestRatefromPIKTable = notePIK.AdditionalIntRate;
                            //Additional PIK Spread from PIK Table
                            rate.AdditionalPIKSpreadfromPIKTable = notePIK.AdditionalSpread;
                            //PIK Index Floor from PIK Table
                            rate.PIKIndexFloorfromPIKTable = notePIK.IndexFloor;

                            if (notePIK.AdditionalIntRate == null)
                            {
                                //rate.AllInPIKInterest = notePIK.AdditionalIntRate + notePIK.IndexFloor;
                                rate.AllInPIKInterest = Math.Max(rate.IndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0), notePIK.IndexFloor.GetValueOrDefault(0)) + notePIK.AdditionalSpread.GetValueOrDefault(0);
                            }
                            else
                                rate.AllInPIKInterest = notePIK.AdditionalIntRate;

                            rate.PIKInterestCompoundingRatefromPIKTable = notePIK.IntCompoundingRate;
                            rate.PIKInterestCompoundingSpreadfromPIKTable = notePIK.IntCompoundingSpread;

                            //All-In PIK Interest Compounding Rate
                            if (notePIK.IntCompoundingRate == null)
                            {
                                //rate.AllInPIKInterestCompoundingRate = notePIK.IntCompoundingRate + notePIK.IndexFloor;
                                rate.AllInPIKInterestCompoundingRate = Math.Max(rate.IndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0), notePIK.IndexFloor.GetValueOrDefault(0)) + notePIK.IntCompoundingSpread.GetValueOrDefault(0);
                            }
                            else
                                rate.AllInPIKInterestCompoundingRate = notePIK.IntCompoundingRate;

                            ListPIKInterestTab[listIndex].PIKInterestCapfromPIKTable = notePIK.IntCapAmt;
                            ListPIKInterestTab[listIndex].NotePIKCapBalancefromPIKTable = notePIK.AccCapBal;

                            if (listIndex == 0)
                            {
                                ListPIKInterestTab[listIndex].BeginningPIKBalanceifnotCompoundedinsideLoanBalance = notePIK.PurBal;
                            }
                        }
                    }
                    #endregion - All In PIK Rate

                    //Loop through Financing Rate Schedule
                    if (noteDC.NoteFinancingScheduleList != null)
                    {
                        foreach (var notefinancingSchedule in noteDC.NoteFinancingScheduleList)
                        {
                            if (notefinancingSchedule.Date != null && RateDate >= notefinancingSchedule.Date)
                            {
                                string valueType = notefinancingSchedule.ValueTypeText;
                                if (valueType != null && valueType != "")
                                {
                                    if (Enum.IsDefined(typeof(EnmFinancingRateType), valueType.Replace(' ', '_')))
                                    {
                                        EnmFinancingRateType eRateType = ((EnmFinancingRateType)Enum.Parse(typeof(EnmFinancingRateType), valueType.Replace(' ', '_')));
                                        switch (eRateType)
                                        {
                                            case EnmFinancingRateType.Financing_Rate:
                                                rate.FinancingRate = notefinancingSchedule.Value;
                                                break;

                                            case EnmFinancingRateType.Financing_Spread:
                                                rate.FinancingSpread = notefinancingSchedule.Value;
                                                break;

                                            case EnmFinancingRateType.Financing_Advance_Rate:
                                                rate.FinancingAdvanceRate = notefinancingSchedule.Value;
                                                break;
                                        }
                                    }
                                }
                            }
                        }
                    }

                    //All-in Financing COF
                    // rate.AllInCouponRate = Math.Max(Math.Max(Math.Max(rate.CouponRate.GetValueOrDefault(0), (rate.CouponSpread.GetValueOrDefault(0) + rate.IndexFloor.GetValueOrDefault(0))), Math.Max(rate.IndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0), rate.CouponFloor.GetValueOrDefault(0))), rate.CouponDefaultRateStepUp.GetValueOrDefault(0));
                    rate.AllinFinancingCOF = Math.Max(rate.FinancingRate.GetValueOrDefault(0),
                     (rate.FinancingSpread.GetValueOrDefault(0) +
                    Math.Max(rate.DIndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0), rate.IndexFloor.GetValueOrDefault(0))));
                }
                listIndex = listIndex + 1;
            }
        }
        private decimal? IndexRoundingBasedOnRule(decimal? LiborValue)
        {
            decimal? LiborValueRounded = 0;
            int RoundOff = 12;
            if (noteDC.IndexRoundingRule != null && noteDC.IndexRoundingRule != 0)
                RoundOff = (noteDC.IndexRoundingRule).ToString().Length - 1 + 2;

            string valueType = noteDC.RoundingMethodText;
            if (valueType == null)
                valueType = "";

            if (valueType != null && valueType != "")
            {
                if (Enum.IsDefined(typeof(EnmRoundMethodType), valueType.Replace(' ', '_')))
                {
                    EnmRoundMethodType eRateType = ((EnmRoundMethodType)Enum.Parse(typeof(EnmRoundMethodType), valueType.Replace(' ', '_')));
                    switch (eRateType)
                    {
                        case EnmRoundMethodType.Nearest:
                            LiborValueRounded = Math.Round(LiborValue.GetValueOrDefault(0), RoundOff);
                            break;

                        case EnmRoundMethodType.Up:
                            LiborValueRounded = Convert.ToDecimal(RoundUp(Convert.ToDouble(LiborValue.GetValueOrDefault(0)), RoundOff));  //LiborValue.GetValueOrDefault(0);
                            break;

                        case EnmRoundMethodType.Down:
                            LiborValueRounded = Convert.ToDecimal(RoundDown(Convert.ToDouble(LiborValue.GetValueOrDefault(0)), RoundOff));
                            break;

                        default:
                            LiborValueRounded = Math.Round(LiborValue.GetValueOrDefault(0), RoundOff);
                            break;
                    }
                }
            }

            return LiborValueRounded;
        }
        public void CalculateFeesTab(DateTime effectiveDate)
        {
            if (noteDC.CalculationModeText == "Cash Flow Only" || noteDC.CalculationModeText == "CF + GAAP Basis (Prospective)" || noteDC.CalculationModeText == "Full Mode (Prospective)" || noteDC.CalculationModeText == "CF + PV Basis (Prospective)")
            {
                effectiveDate = Convert.ToDateTime((from chk in noteDC.NotePrepayAndAdditionalFeeScheduleList
                                                    select chk.EffectiveDate).Max());
            }
            int IndexCalculatefees = 0;
            decimal? feeAmountLY = 0, feeAmount = 0;
            int? CountPaymentFeee = null, CountDateSpecificFees = null, CountTransactionBasedFees = null;

            foreach (FeeOutputDataContract fdc in ListFeeOutput)
            {
                if (fdc.Date >= effectiveDate)
                {
                    fdc.FeeAmount = 0;
                    fdc.FeeAmountinclinLY = 0;
                    fdc.FeeAmountStripped = 0;
                }
            }

            var checkCondition = (from chk in PaymentDateFees
                                  where chk.EffectiveDate == effectiveDate
                                  select true).FirstOrDefault();
            if (checkCondition == true)
            {
                LatestPaymentDateFees = PaymentDateFees.Where(ff => ff.EffectiveDate == effectiveDate).ToList();
                CountPaymentFeee = LatestPaymentDateFees.Count;
            }
            else
            {
                CountPaymentFeee = 0;
            }
            checkCondition = (from chk in DateSpecificFees
                              where chk.EffectiveDate == effectiveDate
                              select true).FirstOrDefault();
            if (checkCondition == true)
            {
                LatestDateSpecificFees = DateSpecificFees.Where(ff => ff.EffectiveDate == effectiveDate).ToList();

                CountDateSpecificFees = LatestDateSpecificFees.Count;
            }
            else
            {
                CountDateSpecificFees = 0;
            }

            checkCondition = (from chk in TransactionBasedFees
                              where chk.EffectiveDate == effectiveDate
                              select true).FirstOrDefault();
            if (checkCondition == true)
            {
                LatestTransactionBasedFees = TransactionBasedFees.Where(ff => ff.EffectiveDate == effectiveDate).ToList();
                CountTransactionBasedFees = LatestTransactionBasedFees.Count;
            }
            else
            {
                CountTransactionBasedFees = LatestTransactionBasedFees.Count;
            }
            //update values which are greater than effectiveDate
            foreach (var Fees in ListFeesTab)
            {
                if (Fees.Date <= SelectedMaturityDateLatest)
                {
                    feeAmount = 0; feeAmountLY = 0;
                    if (Convert.ToDateTime(Fees.Date).Date >= effectiveDate.Date)
                    {
                        //PMT Date Based Fees Trigger check
                        if (PaymentDateFees != null)
                        {
                            if (PaymentDateFees.Count > 0)
                            {
                                if (ListBalanceTab[IndexCalculatefees].PMTDateTag == 1)
                                {
                                    var fees = CalculateFeeAmount("Payment Date Based Fee", Fees.Date, IndexCalculatefees, effectiveDate);
                                    feeAmount = feeAmount + fees.Item1;
                                    feeAmountLY = feeAmountLY + fees.Item2;
                                }
                            }
                        }
                        //Date Specific Fees
                        if (DateSpecificFees != null)
                        {
                            if (DateSpecificFees.Count > 0)
                            {
                                var fees = CalculateFeeAmount("Date Specific Fee", Fees.Date, IndexCalculatefees, effectiveDate);
                                feeAmount = feeAmount + fees.Item1;
                                feeAmountLY = feeAmountLY + fees.Item2;
                            }
                        }
                        //Transaction Based Fees
                        if (TransactionBasedFees != null)
                        {
                            if (TransactionBasedFees.Count > 0)
                            {
                                var fees = CalculateFeeAmount("Transaction Based Fee", Fees.Date, IndexCalculatefees, effectiveDate);
                                feeAmount = feeAmount + fees.Item1;
                                feeAmountLY = feeAmountLY + fees.Item2;
                            }
                        }
                        //Custom Function Fee daily accrual
                        if (CustomFunctionFees != null)
                        {
                            if (CustomFunctionFees.Count > 0)
                            {
                                CalculateCustomFee(Fees.Date.Value.Date, IndexCalculatefees);
                            }
                        }
                        if (CountTransactionBasedFees + CountDateSpecificFees + CountPaymentFeee > 0)
                        {
                            Fees.FeeAmountIncludedinLevelYield = feeAmountLY;
                            Fees.FeeAmountAllIn = feeAmount;
                        }
                    }

                    #region Stripped Fees / Coupon Received from Source Note        

                    if (noteDC.ListFeeCouponStripReceivable != null && noteDC.ListFeeCouponStripReceivable.Count > 0)
                    {
                        if (Convert.ToDateTime(Fees.Date).Date >= effectiveDate.Date)
                        {
                            Fees.StrippedFeesCouponReceivedfromSourceNote = 0;
                            Fees.StrippedFeeReceivableInclInLY = 0;
                            Fees.StrippedFeeReceivableExclFromLY = 0;

                            foreach (FeeCouponStripReceivableTab fstrip in ListFeeCouponStripReceivableLatest.Where(strip => strip.Date == Fees.Date))
                            {
                                if (effectiveDate.Date >= fstrip.EffectiveDate.Value.Date)
                                {
                                    Fees.StrippedFeesCouponReceivedfromSourceNote += fstrip.Value.GetValueOrDefault(0);
                                    Fees.StrippedFeeReceivableInclInLY += fstrip.Value.GetValueOrDefault(0) * fstrip.InclInLevelYield.GetValueOrDefault(0);
                                    Fees.StrippedFeeReceivableExclFromLY = Fees.StrippedFeesCouponReceivedfromSourceNote - Fees.StrippedFeeReceivableInclInLY;

                                    // Add each fee into Output
                                    FeeOutputDataContract fd = new FeeOutputDataContract();
                                    fd.FeeCouponReceivable = fstrip.Value.GetValueOrDefault(0);
                                    fd.FeeAmount = fstrip.Value.GetValueOrDefault(0)
                                    - fstrip.Value.GetValueOrDefault(0) * fstrip.InclInLevelYield.GetValueOrDefault(0);
                                    fd.Date = fstrip.Date.GetValueOrDefault();
                                    fd.FeeAmountinclinLY = fstrip.Value.GetValueOrDefault(0) * fstrip.InclInLevelYield.GetValueOrDefault(0);
                                    fd.FeeName = fstrip.FeeName + "-" + fstrip.SourceNoteId;
                                    fd.FeeType = fstrip.TransactionName;
                                    fd.FeeNameTransText = fstrip.TransactionName;
                                    fd.EffectiveDate = fstrip.EffectiveDate;
                                    InsertUpdateFeeOutput(fd);
                                }
                            }
                        }
                    }
                    #endregion

                    IndexCalculatefees = IndexCalculatefees + 1;
                }
            }
            if (CustomFunctionFees != null)
            {
                if (CustomFunctionFees.Count > 0)
                {
                    CalculateCustomFeeAmountPayable(effectiveDate);
                }
            }
        }

        public void CalculateBalanceTab(DateTime effectiveDate)
        {
            DateTime? selectedMaturityDate = Convert.ToDateTime(SelectedMaturityDateLatest);
            int ListIndex = 0;
            int? ioTerm = noteDC.IOTerm.GetValueOrDefault(0), curIOterm = 0,
            amortTerm = noteDC.AmortTerm.GetValueOrDefault(0),
            remLoanTerm = 0,
            accuralFrequency = noteDC.AccrualFrequency.GetValueOrDefault(0),
            payFrequency = noteDC.PayFrequency.GetValueOrDefault(0),
            prinServicingOverride = 0;
            CumCompPik = 0;
            CumPikInt = 0;
            CumPikAccrual = 0;
            CumPikRelated = 0;
#pragma warning disable CS0219 // The variable 'periodRepay' is assigned but its value is never used
#pragma warning disable CS0219 // The variable 'exitFeeAccrualStrip' is assigned but its value is never used
#pragma warning disable CS0219 // The variable 'cumAmort' is assigned but its value is never used
#pragma warning disable CS0219 // The variable 'exitFeeAccrual' is assigned but its value is never used
            decimal? futureFundingSum = 0, ppSum = 0, pikSum = 0, discRate = 0, prinPMT = 0, intPMT = 0, cumFutureFundingSum = 0, faSum = 0, periodRepay = 0, cumRepay = 0, cumAmort = 0, exitFeeAccrual = 0, exitFeeAccrualStrip = 0;
#pragma warning restore CS0219 // The variable 'exitFeeAccrual' is assigned but its value is never used
#pragma warning restore CS0219 // The variable 'cumAmort' is assigned but its value is never used
#pragma warning restore CS0219 // The variable 'exitFeeAccrualStrip' is assigned but its value is never used
#pragma warning restore CS0219 // The variable 'periodRepay' is assigned but its value is never used
#pragma warning disable CS0219 // The variable 'PrepayFeePmt' is assigned but its value is never used
#pragma warning disable CS0219 // The variable 'ExtenFeePmt' is assigned but its value is never used
#pragma warning disable CS0219 // The variable 'ExitFeePmt' is assigned but its value is never used
            decimal? PrepayFeePmt = 0, ExitFeePmt = 0, ExtenFeePmt = 0;
#pragma warning restore CS0219 // The variable 'ExitFeePmt' is assigned but its value is never used
#pragma warning restore CS0219 // The variable 'ExtenFeePmt' is assigned but its value is never used
#pragma warning restore CS0219 // The variable 'PrepayFeePmt' is assigned but its value is never used
            decimal? PikIntAccrued = 0;

            foreach (var balance in ListBalanceTab)
            {
                if (balance.Date >= effectiveDate)
                {
                    foreach (DatesTab dt in ListDatesTab)
                    {
                        if (dt.InterestAccrualPeriodEndDateArray == balance.Date || balance.Date == selectedMaturityDate)
                        {
                            balance.AccrualPeriodEndDateTag = 1;
                            ListCouponTab[ListIndex].InterestAccrualPeriodEndDateTag = 1;
                            ListPIKInterestTab[ListIndex].AccrualPeriodEndDateTag = 1;
                            break;
                        }
                        else
                        {
                            balance.AccrualPeriodEndDateTag = 0;
                            ListCouponTab[ListIndex].InterestAccrualPeriodEndDateTag = 0;
                            ListPIKInterestTab[ListIndex].AccrualPeriodEndDateTag = 0;
                        }
                        if (balance.Date == dt.PMTDropDateUsed && dt.PMTDropDateUsed != dt.PaymentDateusingAccrualFreqNotAdjustedforBusinessDay)
                        {
                            balance.PMTDropDateTag = 1;
                        }
                        if (dt.InterestAccrualPeriodEndDateArray >= balance.Date && dt.InterestAccrualPeriodStartDateArray <= balance.Date)
                        {
                            ListCouponTab[ListIndex].NumberofDaysinReferencedAccrualPeriod = dt.NumberofDaysintheAccrualPeriod.GetValueOrDefault(0);
                        }
                    }
                    //Remaining IO Term & Amort Term
                    if (ListIndex == 0)
                    {
                        balance.RemainingIOTerm = ioTerm + 1;
                        balance.RemainingAmortTermMo = amortTerm;
                    }
                    else
                    {
                        if (ListBalanceTab[ListIndex - 1].RemainingIOTerm != 0)
                        {
                            if (balance.AccrualPeriodEndDateTag != 0 && balance.Date < noteDC.FinalInterestAccrualEndDateOverride)
                            {
                                balance.RemainingIOTerm = ListBalanceTab[ListIndex - 1].RemainingIOTerm - accuralFrequency;
                            }
                            else
                            {
                                balance.RemainingIOTerm = ListBalanceTab[ListIndex - 1].RemainingIOTerm;
                            }
                        }
                        else
                        {
                            balance.RemainingIOTerm = 0;
                        }

                        if (ListBalanceTab[ListIndex - 1].RemainingAmortTermMo != 0)
                        {
                            if (balance.AccrualPeriodEndDateTag != 0 && balance.RemainingIOTerm == 0)
                                balance.RemainingAmortTermMo = ListBalanceTab[ListIndex - 1].RemainingAmortTermMo - accuralFrequency;
                            else
                                balance.RemainingAmortTermMo = ListBalanceTab[ListIndex - 1].RemainingAmortTermMo;
                        }
                        else
                            balance.RemainingAmortTermMo = 0;
                    }
                    //Beginning Balance
                    futureFundingSum = 0;
                    ppSum = 0;
                    if (ListIndex == 0)
                        balance.BeginningBalance = noteDC.InitialFundingAmount.GetValueOrDefault(0);
                    else
                        balance.BeginningBalance = ListBalanceTab[ListIndex - 1].EndingBalance.GetValueOrDefault(0);

                    //PMT Date Tag
                    foreach (var dates in ListDatesTab)
                    {
                        if (dates.PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay == balance.Date)
                        {
                            balance.PMTDateTag = 1;
                            break;
                        }
                        else if (dates.PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay < balance.Date)
                            balance.PMTDateTag = 0;
                        else
                            break;
                    }
                    //PMT Date Tag - Working Day Adjusted
                    foreach (var dates in ListDatesTab)
                    {
                        if (dates.PaymentDateAdjustedforWorkingDay == balance.Date)
                        {
                            balance.PMTDateTagWorkingdayAdjusted = 1;
                            break;
                        }
                        else if (dates.PaymentDateAdjustedforWorkingDay < balance.Date)
                            balance.PMTDateTagWorkingdayAdjusted = 0;
                        else
                            break;
                    }
                    //Future Advances From Future Funding Schedule
                    decimal? amt = ListFutureFundingScheduleTabLatest.Where(x => x.Date == balance.Date && x.Date <= SelectedMaturityDateLatest && x.Value > 0).Sum(y => y.Value);
                    futureFundingSum = futureFundingSum + amt.GetValueOrDefault(0);
                    amt = ListFutureFundingScheduleTabLatest.Where(x => x.Date == balance.Date && x.Date <= SelectedMaturityDateLatest && x.Value <= 0).Sum(y => y.Value);
                    ppSum = ppSum + amt.GetValueOrDefault(0);

                    balance.FutureAdvancesFromFutureFundingSchedule = futureFundingSum;
                    balance.DiscretionaryCurtailmentsForThePeriod = ppSum;

                    if (ListIndex > 0)
                    {
                        if (ListBalanceTab[ListIndex - 1].AccrualPeriodEndDateTag == 0)
                        {
                            balance.AccumulatedFundingForThePeriod = ListBalanceTab[ListIndex - 1].AccumulatedFundingForThePeriod + futureFundingSum;
                        }
                        else if (balance.PMTDateTag == 1 && ListBalanceTab[ListIndex - 1].AccrualPeriodEndDateTag == 1)
                        {
                            balance.AccumulatedFundingForThePeriod = 0;
                        }
                        else
                        {
                            balance.AccumulatedFundingForThePeriod = futureFundingSum;
                        }
                    }
                    else
                    {
                        balance.AccumulatedFundingForThePeriod = futureFundingSum;
                    }
                    if (ListIndex == 0 && noteDC.StubOnFFtext == "Y")
                    {
                        if (balance.AccrualPeriodEndDateTag == 0)
                            cumFutureFundingSum = cumFutureFundingSum + futureFundingSum;
                        else
                            cumFutureFundingSum = futureFundingSum;
                    }
                    balance.CumFutureAdvancesForAccrualPeriod = cumFutureFundingSum;

                    //PIK Interest from PIK Source Note
                    amt = (from ff in ListPIKfromPIKSourceNoteTabLatest
                           where ff.Date == balance.Date
                           select ff.Value).FirstOrDefault();
                    pikSum = pikSum + amt.GetValueOrDefault(0);
                    balance.PIKInterestfromPIKSourceNote = pikSum;

                    // Accrual for Amort Calc & PMT for Amort Calc
                    // a - check for active IO period
                    if (balance.RemainingIOTerm != 0 && balance.RemainingIOTerm != null)
                    {
                        balance.AccrualforAmortCalc = 0;
                        balance.ScheduledPrincipal = 0;
                        if (balance.RemainingIOTerm == 1 && balance.PMTDateTag == 1)
                        {
                            //' check if pmt date falls into interest accrual period with active IO term
                            curIOterm = LookupIOTerm(Convert.ToDateTime(balance.Date));
                            if (curIOterm == 0)
                            {
                                balance.PMTforAmortCalc = noteDC.MonthlyDSOverridewhenAmortizing.GetValueOrDefault(0) * balance.PMTDateTag.GetValueOrDefault(0);
                            }
                            else
                            {
                                balance.PMTforAmortCalc = 0;
                            }
                            balance.PrincipalPaid = balance.PMTforAmortCalc.GetValueOrDefault(0);
                        }
                        else
                        {
                            balance.PMTforAmortCalc = 0;
                            balance.PrincipalPaid = 0;
                        }

                        if (balance.Date > selectedMaturityDate)
                        {
                            balance.AccrualforAmortCalc = 0;
                            balance.ScheduledPrincipal = 0;
                            balance.PrincipalPaid = 0;
                            balance.PMTforAmortCalc = 0;
                        }
                    }
                    else
                    //b - check if note has MonthlyDSOverridewhenAmortizing
                    {
                        if (noteDC.MonthlyDSOverridewhenAmortizing == null || noteDC.MonthlyDSOverridewhenAmortizing == 0)
                        {
                            // ' Check if note has fixed amort schedule
                            if (noteDC.FixedAmortScheduleText == "Y")
                            {
                                //' Get amort amount for the period from fixed amort schedule
                                faSum = 0;
                                if (ListFixedAmortScheduleTabLatest != null)
                                {
                                    foreach (var amort in ListFixedAmortScheduleTabLatest)
                                    {
                                        if (amort.Date == balance.Date && amort.Date < SelectedMaturityDateLatest)
                                            faSum = faSum + amort.Value;
                                    }
                                }
                                balance.AccrualforAmortCalc = 0;
                                balance.ScheduledPrincipal = faSum;
                                balance.PMTforAmortCalc = 0;
                                balance.PrincipalPaid = faSum;
                            }
                            else
                            {
                                if (balance.RemainingAmortTermMo != null && balance.RemainingAmortTermMo != 0)
                                {
                                    if (balance.Date == accEndDate)
                                    {
                                        balance.AccrualforAmortCalc = 0;
                                        balance.PMTforAmortCalc = 0;
                                    }
                                    else
                                    {
                                        if (balance.BeginningBalance != null && Math.Round(Convert.ToDecimal(balance.BeginningBalance)) > 0)
                                        {
                                            RateTab rt = ListRateTab.Where(t => t.rateDate < balance.Date).OrderByDescending(t => t.rateDate).FirstOrDefault();
                                            decimal? amortRate = rt.AllInAmortRate.GetValueOrDefault(0);
                                            decimal? BeginningBalance = (from b in ListBalanceTab
                                                                         where b.Date == rt.rateDate
                                                                         select b.BeginningBalance).FirstOrDefault();

                                            decimal? CurrBeginningBalance = (from b in ListBalanceTab
                                                                             where b.Date == balance.Date
                                                                             select b.BeginningBalance).FirstOrDefault();

                                            discRate = amortRate.GetValueOrDefault(0) * noteDC.AmortIntCalcDayCount.GetValueOrDefault() / 360;//* ws_balance.Range("I6").Value / 360;

                                            double powa = 1d + Convert.ToDouble(discRate) / (12d / Convert.ToDouble(payFrequency.GetValueOrDefault()));
                                            double powb = ((Convert.ToDouble(amortTerm.GetValueOrDefault()) / Convert.ToDouble(payFrequency.GetValueOrDefault())) * -1d);
                                            double powerans = 1d - Math.Pow(powa, powb);

                                            double tempa = Convert.ToDouble(BeginningBalance.GetValueOrDefault(0) * discRate);
                                            double TempAccrual = Convert.ToDouble(CurrBeginningBalance.GetValueOrDefault(0) * discRate);

                                            double tempb = Convert.ToDouble((12d / Convert.ToDouble(payFrequency.GetValueOrDefault())));
                                            decimal PMTforAmortCalc = Convert.ToDecimal(Math.Round(
                                                Convert.ToDouble(NumericExtensions.SafeDivision(Convert.ToDecimal((tempa / tempb)), Convert.ToDecimal(powerans))
                                                ), 2));

                                            decimal AmortCalc = Convert.ToDecimal(Math.Round(
                                               Convert.ToDouble(NumericExtensions.SafeDivision(Convert.ToDecimal((TempAccrual / tempb)), Convert.ToDecimal(powerans))
                                               ), 2));

                                            balance.AccrualforAmortCalc = AmortCalc * Convert.ToDecimal(balance.AccrualPeriodEndDateTag);

                                            balance.PMTforAmortCalc = PMTforAmortCalc * balance.PMTDateTag;
                                        }
                                        else
                                        {
                                            balance.AccrualforAmortCalc = 0;
                                            balance.PMTforAmortCalc = 0;
                                        }
                                    }

                                    remLoanTerm = YearMonthDiff(noteDC.ClosingDate.Value.AddDays(1), SelectedMaturityDateLatest.Value.Date) - ioTerm;
                                    if (balance.BeginningBalance != null && Math.Round(Convert.ToDecimal(balance.BeginningBalance)) > 0)
                                    {
                                        double disc = (1 + Convert.ToDouble(discRate / 12));
                                        double amortdiff = Convert.ToDouble(-(amortTerm - remLoanTerm));
                                        double scpower1 = 1 - Math.Pow(disc, amortdiff);
                                        double scpower2 = 1 - Math.Pow(disc, Convert.ToDouble(-amortTerm));
                                        decimal ansa = Convert.ToDecimal(1 - NumericExtensions.SafeDivision(scpower1, scpower2));

                                        balance.ScheduledPrincipal = ansa * noteDC.TotalCommitment.GetValueOrDefault(0) / Math.Max(0.0001m, Convert.ToDecimal(remLoanTerm)) * balance.AccrualPeriodEndDateTag;
                                        balance.PrincipalPaid = ansa * noteDC.TotalCommitment.GetValueOrDefault(0) / Math.Max(0.0001m, Convert.ToDecimal(remLoanTerm)) * balance.PMTDateTag;
                                    }
                                    else
                                    {
                                        balance.ScheduledPrincipal = 0;
                                        balance.PrincipalPaid = 0;
                                    }
                                }
                            }
                        }
                        else
                        {
                            balance.AccrualforAmortCalc = noteDC.MonthlyDSOverridewhenAmortizing.GetValueOrDefault(0) * balance.AccrualPeriodEndDateTag.GetValueOrDefault(0);
                            balance.ScheduledPrincipal = balance.AccrualforAmortCalc;
                            //' check if pmt date falls into interest accrual period with active IO term
                            curIOterm = LookupIOTerm(Convert.ToDateTime(balance.Date));
                            if (curIOterm == 0)
                            {
                                if (balance.BeginningBalance > 0)
                                {
                                    balance.PMTforAmortCalc = noteDC.MonthlyDSOverridewhenAmortizing.GetValueOrDefault(0) * balance.PMTDateTag.GetValueOrDefault(0);
                                }
                                else
                                {
                                    balance.PMTforAmortCalc = 0;
                                }
                            }
                            else
                            {
                                balance.PMTforAmortCalc = 0;
                            }
                            balance.PrincipalPaid = balance.PMTforAmortCalc.GetValueOrDefault(0);
                        }
                        if (ListIndex > 0)
                        {
                            if (ListBalanceTab[ListIndex - 1].RemainingIOTerm == 1 && balance.AccrualPeriodEndDateTag == 1 && balance.RemainingIOTerm == 0)
                            {
                                balance.AccrualforAmortCalc = 0;
                                balance.ScheduledPrincipal = 0;
                            }
                        }
                        //' check if pmt date falls into interest accrual period with active IO term
                        curIOterm = LookupIOTerm(Convert.ToDateTime(balance.Date));
                        if (curIOterm > 0)
                        {
                            balance.PMTforAmortCalc = 0;
                            balance.PrincipalPaid = 0;
                        }

                        if (balance.Date == noteDC.FinalInterestAccrualEndDateOverride)
                        {
                            balance.AccrualforAmortCalc = 0;
                            balance.ScheduledPrincipal = 0;
                            balance.PMTforAmortCalc = 0;
                            balance.PrincipalPaid = 0;
                        }
                        else if (balance.Date >= selectedMaturityDate)
                        {
                            balance.AccrualforAmortCalc = 0;
                            balance.ScheduledPrincipal = 0;
                            balance.PrincipalPaid = 0;
                            balance.PMTforAmortCalc = 0;
                        }
                    }

                    //Principal Received per Servicing
                    prinPMT = 0;
                    intPMT = 0;
                    prinServicingOverride = 0;

                    balance.PrincipalReceivedperServicing = prinPMT;
                    if (prinServicingOverride != 1)
                        balance.PrincipalReceivedperServicing = balance.PrincipalPaid;

                    //ListCouponTab.Where(checkDate => checkDate.Date == balance.Date).ToList().ForEach(checkValue => checkValue.InterestPaidperServicing = intPMT);
                    ListCouponTab[ListIndex].InterestPaidperServicing = intPMT;

                    //Scheduled Principal Shortfall
                    if (ListIndex == 0 || balance.BeginningBalance != 0)
                    {
                        balance.ScheduledPrincipalShortfall = (balance.AccrualforAmortCalc - Convert.ToDecimal((from coup in ListCouponTab where coup.Date == balance.Date select coup.InterestforthePeriod).FirstOrDefault())) * balance.DebtServiceShortfall;
                        balance.PrincipalShortfall = (balance.PMTforAmortCalc - Convert.ToDecimal((from coup in ListCouponTab where coup.Date == balance.Date select coup.InterestPaidonPaymentDate).FirstOrDefault())) * balance.DebtServiceShortfall;
                    }
                    else
                    {
                        balance.ScheduledPrincipalShortfall = 0;
                        balance.PrincipalShortfall = 0;
                    }
                    //Principal Loss
                    balance.PrincipalLoss = (balance.BeginningBalance + balance.FutureAdvancesFromFutureFundingSchedule + balance.DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0) + balance.PIKInterestfromPIKSourceNote - balance.ScheduledPrincipal) *
                     Convert.ToDecimal((from rate in ListRateTab where rate.rateDate == balance.Date select rate.SeverityatDefault).FirstOrDefault());

                    //' PIK Interest Calculation:
                    if (ListNotePIKScheduleLatest != null && ListNotePIKScheduleLatest.Count > 0)
                    {
                        decimal AmortizationEndingBalanceAddon = 0, NonAmortizationEndingBalanceAddon = 0, AmortizationPaydownAmount = 0, NonAmortizationPaydownAmount = 0, BalloonPayment = 0;

                        //Balloon PMT
                        if (balance.Date == selectedMaturityDate)
                        {
                            BalloonPayment = (balance.BeginningBalance + balance.FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0) + balance.DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0) + balance.PIKInterestfromPIKSourceNote.GetValueOrDefault(0) - balance.PrincipalPaid.GetValueOrDefault(0)).GetValueOrDefault();
                            //+ ListPIKInterestTab[ListIndex].PIKInterestforthePeriod.GetValueOrDefault(0)
                            //- ListPIKInterestTab[ListIndex].PIKInterestforthePeriodBalloon.GetValueOrDefault(0)
                            //- ListPIKInterestTab[ListIndex].TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod.GetValueOrDefault(0)).GetValueOrDefault(0);
                        }
                        else
                        {
                            BalloonPayment = 0;
                        }
                        //' Paydown Amounts by Type:
                        if (noteDC.FixedAmortScheduleText == "Y")
                        {
                            AmortizationPaydownAmount = balance.PrincipalPaid.GetValueOrDefault(0);//ScheduledAmortAmtforSelectedDate(balance.Date); //+balance.PrincipalReceivedperServicing.GetValueOrDefault(0);
                        }
                        else
                        {
                            AmortizationPaydownAmount = balance.PrincipalReceivedperServicing.GetValueOrDefault(0);
                        }

                        NonAmortizationPaydownAmount = (balance.DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0)) * -1; //+ balance.AmortizationPaydownAmount.GetValueOrDefault(0));

                        if (ListIndex > 0 && balance.Date.Value <= SelectedMaturityDateLatest)
                        {
                            AmortizationEndingBalanceAddon = AddOnAmtInterestAccrualScenario(AmortizationPaydownAmount, "Amortization", ListBalanceTab[ListIndex - 1].AccrualPeriodEndDateTag.GetValueOrDefault(0), ListBalanceTab[ListIndex - 1].AmortizationEndingBalanceAddon.GetValueOrDefault(0));
                            NonAmortizationEndingBalanceAddon = AddOnAmtInterestAccrualScenario((NonAmortizationPaydownAmount + BalloonPayment), "non-Amortization", ListBalanceTab[ListIndex - 1].AccrualPeriodEndDateTag.GetValueOrDefault(0), ListBalanceTab[ListIndex - 1].NonAmortizationEndingBalanceAddon.GetValueOrDefault(0));
                        }

                        decimal periodbal = Math.Max(0, ListBalanceTab[ListIndex].BeginningBalance.GetValueOrDefault(0) + ListBalanceTab[ListIndex].FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0) + ListBalanceTab[ListIndex].DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0)
                                        + AmortizationEndingBalanceAddon + NonAmortizationEndingBalanceAddon
                                        + ListBalanceTab[ListIndex].PIKInterestfromPIKSourceNote.GetValueOrDefault(0) - ListBalanceTab[ListIndex].PrincipalReceivedperServicing.GetValueOrDefault(0) - BalloonPayment
                                        - ListBalanceTab[ListIndex].PrincipalLoss.GetValueOrDefault(0));

                        CalculatePIKTab(ListIndex, periodbal, ListBalanceTab[ListIndex].PMTDateTagWorkingdayAdjusted, effectiveDate);
                    }
                    //PIK Principal Paid Tranaction from Servicing Log
                    ListPIKInterestTab[ListIndex].PIKPrincipalPaidForThePeriod = ServicingTransactionOverride(CalculationEnums.TransactionTypeText[(int)TransactionType.PIKPrincipalPaid], balance.Date);

                    //Balloon PMT On Maturity
                    if (balance.Date == selectedMaturityDate)
                    {
                        balance.BalloonPayment = balance.BeginningBalance + balance.FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0) + balance.DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0) + balance.PIKInterestfromPIKSourceNote.GetValueOrDefault(0) - balance.PrincipalPaid.GetValueOrDefault(0)
                          + ListPIKInterestTab[ListIndex].PIKInterestonBusinessAdjInterestAccrualEndDate.GetValueOrDefault(0)
                          - ListPIKInterestTab[ListIndex].PIKInterestPaidForThePeriod.GetValueOrDefault(0)
                          - ListPIKInterestTab[ListIndex].PIKInterestforthePeriodBalloon.GetValueOrDefault(0)
                          - ListPIKInterestTab[ListIndex].PIKPrincipalPaidForThePeriod.GetValueOrDefault(0)
                          - ListPIKInterestTab[ListIndex].TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod.GetValueOrDefault(0);
                        cumRepay = cumRepay + balance.BalloonPayment;
                    }
                    else
                    {
                        balance.BalloonPayment = 0;
                    }

                    //' Paydown Amounts by Type:
                    if (noteDC.FixedAmortScheduleText == "Y")
                    {
                        balance.AmortizationPaydownAmount = ScheduledAmortAmtforSelectedDate(balance.Date); //+balance.PrincipalReceivedperServicing.GetValueOrDefault(0);
                    }
                    else
                    {
                        balance.AmortizationPaydownAmount = balance.PrincipalReceivedperServicing.GetValueOrDefault(0);
                    }

                    balance.NonAmortizationPaydownAmount = (balance.DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0)) * -1; //+ balance.AmortizationPaydownAmount.GetValueOrDefault(0));

                    if (ListIndex > 0)
                    {
                        balance.AmortizationEndingBalanceAddon = AddOnAmtInterestAccrualScenario(balance.AmortizationPaydownAmount.GetValueOrDefault(0), "Amortization", ListBalanceTab[ListIndex - 1].AccrualPeriodEndDateTag.GetValueOrDefault(0), ListBalanceTab[ListIndex - 1].AmortizationEndingBalanceAddon.GetValueOrDefault(0));
                        balance.NonAmortizationEndingBalanceAddon = AddOnAmtInterestAccrualScenario((balance.NonAmortizationPaydownAmount.GetValueOrDefault(0) + balance.BalloonPayment.GetValueOrDefault(0)), "non-Amortization",
                            ListBalanceTab[ListIndex - 1].AccrualPeriodEndDateTag.GetValueOrDefault(0), ListBalanceTab[ListIndex - 1].NonAmortizationEndingBalanceAddon.GetValueOrDefault(0), ListBalanceTab[ListIndex - 1].Date >= SelectedMaturityDateLatest);
                    }

                    //' Ending Balance
                    if (noteDC.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateText == "Y")
                    {
                        PikIntAccrued = ListPIKInterestTab[ListIndex].PIKInterestonBusinessAdjInterestAccrualEndDate.GetValueOrDefault(0)
                            - ListPIKInterestTab[ListIndex].PIKInterestPaidForThePeriod.GetValueOrDefault(0)
                            - ListPIKInterestTab[ListIndex].PIKInterestforthePeriodBalloon.GetValueOrDefault(0)
                            - ListPIKInterestTab[ListIndex].PIKPrincipalPaidForThePeriod.GetValueOrDefault(0);
                        // - ListPIKInterestTab[ListIndex].TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod.GetValueOrDefault(0);
                    }
                    else
                    {
                        PikIntAccrued = ListPIKInterestTab[ListIndex].PIKInterestforthePeriod.GetValueOrDefault(0)
                            - ListPIKInterestTab[ListIndex].PIKInterestPaidForThePeriod.GetValueOrDefault(0)
                            - ListPIKInterestTab[ListIndex].PIKInterestforthePeriodBalloon.GetValueOrDefault(0)
                            - ListPIKInterestTab[ListIndex].PIKPrincipalPaidForThePeriod.GetValueOrDefault(0);

                        // - ListPIKInterestTab[ListIndex].TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod.GetValueOrDefault(0);
                    }

                    if (noteDC.IncludeServicingPaymentOverrideinLevelYieldText == "Y")
                    {
                        balance.EndingBalance = (
                            balance.BeginningBalance.GetValueOrDefault(0) +
                            balance.FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0) + balance.DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0) +
                            balance.PIKInterestfromPIKSourceNote.GetValueOrDefault(0) -
                            balance.PrincipalReceivedperServicing.GetValueOrDefault(0) -
                            balance.BalloonPayment.GetValueOrDefault(0) -
                            balance.PrincipalLoss.GetValueOrDefault(0)) + PikIntAccrued;
                    }
                    else
                    {
                        balance.EndingBalance = (balance.BeginningBalance.GetValueOrDefault(0) + balance.FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0)
                            + balance.DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0) + balance.PIKInterestfromPIKSourceNote.GetValueOrDefault(0)
                            - balance.PrincipalPaid.GetValueOrDefault(0)
                         - balance.BalloonPayment.GetValueOrDefault(0)
                         - balance.PrincipalLoss.GetValueOrDefault(0))
                         + PikIntAccrued;
                    }
                    SetSoftPayoffFlagForThePeriod(ListIndex);
                    //' Ending Balance adj for PMT Drop Date:                
                    if (ListIndex == 0)
                    {
                        balance.PeriodPMTDropTag = 0;
                    }
                    else
                    {
                        if (balance.PMTDropDateTag == 1)
                        {
                            balance.PeriodPMTDropTag = 1;
                        }
                        else if (ListBalanceTab[ListIndex - 1].AccrualPeriodEndDateTag == 1)
                        {
                            balance.PeriodPMTDropTag = 0;
                        }
                        else
                        {
                            balance.PeriodPMTDropTag = ListBalanceTab[ListIndex - 1].PeriodPMTDropTag;
                        }
                    }
                    if (balance.PeriodPMTDropTag == 1 && balance.SoftPayOffFlag != 1 && CheckForFinalAccrualPeriod(ListIndex) != 1)
                    {
                        if (balance.Date == SelectedMaturityDateLatest || balance.SoftPayOffFlag == 1)
                        {
                            balance.EndingBalanceUsingPMTDropDate = balance.EndingBalance.GetValueOrDefault(0);
                        }
                        else
                        {
                            balance.EndingBalanceUsingPMTDropDate = ListBalanceTab[ListIndex - 1].EndingBalanceUsingPMTDropDate.GetValueOrDefault(0) + PikIntAccrued.GetValueOrDefault(0);
                        }
                        if (balance.Date == SelectedMaturityDateLatest || balance.SoftPayOffFlag == 1)
                        {
                            balance.DiscretionaryCurtailmentsForThePeriodAdjustedforPMTDropDate = balance.DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0);
                        }
                        else
                        {
                            balance.DiscretionaryCurtailmentsForThePeriodAdjustedforPMTDropDate = 0;
                        }
                        if (ListBalanceTab[ListIndex - 1].AccrualPeriodEndDateTag == 1 || balance.Date == SelectedMaturityDateLatest)
                        {
                            balance.AccumulatedFundingForThePeriodAdjustedforPMTDropDate = ListBalanceTab[ListIndex].AccumulatedFundingForThePeriod.GetValueOrDefault(0);
                            balance.AmortizationEndingBalanceAddonPMTDropDate = balance.AmortizationEndingBalanceAddon.GetValueOrDefault(0);
                            balance.NonAmortizationEndingBalanceAddonPMTDropDate = balance.NonAmortizationEndingBalanceAddon.GetValueOrDefault(0);
                        }
                        else
                        {
                            balance.AccumulatedFundingForThePeriodAdjustedforPMTDropDate = ListBalanceTab[ListIndex - 1].AccumulatedFundingForThePeriodAdjustedforPMTDropDate.GetValueOrDefault(0);
                            balance.AmortizationEndingBalanceAddonPMTDropDate = AddOnAmtPMTDropDate(balance.AmortizationPaydownAmount.GetValueOrDefault(0), "Amortization", ListBalanceTab[ListIndex - 1].AmortizationEndingBalanceAddonPMTDropDate.GetValueOrDefault(0)); //ListBalanceTab[ListIndex - 1].AmortizationEndingBalanceAddonPMTDropDate.GetValueOrDefault(0);//+ balance.AmortizationPaydownAmount.GetValueOrDefault(0);
                            balance.NonAmortizationEndingBalanceAddonPMTDropDate = AddOnAmtPMTDropDate(balance.NonAmortizationPaydownAmount.GetValueOrDefault(0), "non-Amortization", ListBalanceTab[ListIndex - 1].NonAmortizationEndingBalanceAddonPMTDropDate.GetValueOrDefault(0)); ; //ListBalanceTab[ListIndex - 1].NonAmortizationEndingBalanceAddonPMTDropDate.GetValueOrDefault(0); //+ balance.NonAmortizationPaydownAmount.GetValueOrDefault(0);
                        }
                    }
                    else
                    {
                        balance.EndingBalanceUsingPMTDropDate = ListBalanceTab[ListIndex].EndingBalance.GetValueOrDefault(0);
                        balance.DiscretionaryCurtailmentsForThePeriodAdjustedforPMTDropDate = balance.DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0);
                        balance.AccumulatedFundingForThePeriodAdjustedforPMTDropDate = balance.AccumulatedFundingForThePeriod.GetValueOrDefault(0);

                        if (ListIndex > 0)
                        {
                            balance.AmortizationEndingBalanceAddonPMTDropDate = balance.AmortizationEndingBalanceAddon.GetValueOrDefault(0);
                            balance.NonAmortizationEndingBalanceAddonPMTDropDate = balance.NonAmortizationEndingBalanceAddon.GetValueOrDefault(0);
                        }
                    }
                }
                ListIndex = ListIndex + 1;
            }
        }
        private int CheckForFinalAccrualPeriod(int ListIndex)
        {
            int inFinalPeriod = 0;
            DateTime dtperiod = ListBalanceTab[ListIndex].Date.Value.Date;

            // Return 1 if the Processing Period is in the final Accrual Period.
            int ndx = ListDatesTab.FindIndex(dt => dtperiod >= dt.InterestAccrualPeriodStartDateArray && dtperiod <= dt.InterestAccrualPeriodEndDateArray);
            if (ndx >= 0 && ListDatesTab[ndx].PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay == SelectedMaturityDateLatest)
            {
                inFinalPeriod = 1;
            }
            return inFinalPeriod;
        }
        private void SetSoftPayoffFlagForThePeriod(int ListIndex)
        {
            if (ListIndex < 2)
                ListBalanceTab[ListIndex].SoftPayOffFlag = 0;
            else
            {
                /*
                 *  Excluded Prepay = Turn SoftPayOffFlag on PayOff Period
                 *  Include Prepay - Turn SoftPayoffFlag On next period
                 *  Full Accrual - No Effect
                 */
                switch (noteDC.InterestCalculationRuleForPaydownsText)
                {
                    case "Exclude Prepayment Date":
                        if (ListBalanceTab[ListIndex - 1].EndingBalance > 0.01M && ListBalanceTab[ListIndex].EndingBalance <= 0.01M)
                        {
                            ListBalanceTab[ListIndex].SoftPayOffFlag = 1;
                            int ndxdt = Math.Min(ListDatesTab.FindIndex(dt => dt.InterestAccrualPeriodStartDateArray <= ListBalanceTab[ListIndex].Date && ListBalanceTab[ListIndex].Date <= dt.InterestAccrualPeriodEndDateArray), ListDatesTab.Count - 1);
                            ListDatesTab[ndxdt].SoftPayOffPeriodTag = 1;
                        }
                        else
                            ListBalanceTab[ListIndex].SoftPayOffFlag = ListBalanceTab[ListIndex - 1].SoftPayOffFlag;
                        break;

                    case "Include Prepayment Date":
                        if (ListBalanceTab[ListIndex - 2].EndingBalance > 0.01M && ListBalanceTab[ListIndex - 1].EndingBalance <= 0.01M)
                        {
                            ListBalanceTab[ListIndex].SoftPayOffFlag = 1;
                            int ndxdt = Math.Min(ListDatesTab.FindIndex(dt => dt.InterestAccrualPeriodStartDateArray <= ListBalanceTab[ListIndex].Date && ListBalanceTab[ListIndex].Date <= dt.InterestAccrualPeriodEndDateArray), ListDatesTab.Count - 1);
                            ListDatesTab[ndxdt].SoftPayOffPeriodTag = 1;
                        }
                        else
                            ListBalanceTab[ListIndex].SoftPayOffFlag = ListBalanceTab[ListIndex - 1].SoftPayOffFlag;
                        break;

                    case "Full Period Accrual":
                        if (ListBalanceTab[ListIndex - 1].EndingBalance > 0.01M && ListBalanceTab[ListIndex].EndingBalance <= 0.01M)
                        {
                            int ndxdt = Math.Min(ListDatesTab.FindIndex(dt => dt.InterestAccrualPeriodStartDateArray <= ListBalanceTab[ListIndex].Date && ListBalanceTab[ListIndex].Date <= dt.InterestAccrualPeriodEndDateArray), ListDatesTab.Count - 1);
                            ListDatesTab[ndxdt].SoftPayOffPeriodTag = 1;
                        }
                        else
                            ListBalanceTab[ListIndex].SoftPayOffFlag = ListBalanceTab[ListIndex - 1].SoftPayOffFlag;
                        break;
                }

                if ((ListBalanceTab[ListIndex - 1].EndingBalance <= 0.01M && ListBalanceTab[ListIndex].EndingBalance > 0.01M) || ListBalanceTab[ListIndex - 1].AccrualPeriodEndDateTag == 1)
                    ListBalanceTab[ListIndex].SoftPayOffFlag = 0;

            }
        }
        public void CalculatePIKTab(int pikindex, decimal PeriodBal, int? pmtdatetag, DateTime effectivedate)
        {
            DateTime? Matdate, Firstpaymentdate, closingdate, PikStartDate, StartDate, EndDate;
            decimal PIKPmtAmount = 0, PIKInterestPaid = 0, PIKPrincipalPaid = 0, PIKPrinFundingOverridePmtDate = 0, PIKPrinFundingOverrideAccEndDate = 0;
            String PikSepComp;
            Decimal? PIKIntBusAdjPmtDate = 0;
            int ndx = 0;
            int DaysPmtDateToIntAccEndDate = 0;

            Matdate = SelectedMaturityDateLatest;
            Firstpaymentdate = noteDC.FirstPaymentDate;
            closingdate = noteDC.ClosingDate;

            PIKSchedule pikscheff = ListNotePIKScheduleLatest.ToArray()[0];
            PikSepComp = noteDC.PIKSeparateCompoundingText;
            PikStartDate = pikscheff.StartDate;

            //Recalculate Balance if there is a PIKInterestPaid or PIKPrincipalPaid Transaction and the Payment Date is not on a Holiday.
            //Find the DateTab Record corresponding to the payment date. There should be only one.
            PIKInterestPaid = ServicingTransactionOverride(CalculationEnums.TransactionTypeText[(int)TransactionType.PIKInterestPaid], ListPIKInterestTab[pikindex].Date);
            PIKPrincipalPaid = ServicingTransactionOverride(CalculationEnums.TransactionTypeText[(int)TransactionType.PIKPrincipalPaid], ListPIKInterestTab[pikindex].Date);
            int ndx1 = ListDatesTab.FindIndex(x => x.InterestAccrualPeriodStartDateArray <= ListPIKInterestTab[pikindex].Date && x.InterestAccrualPeriodEndDateArray >= ListPIKInterestTab[pikindex].Date);
            if (pmtdatetag == 1 && ListPIKInterestTab[pikindex].Date == ListDatesTab[ndx1].InterestAccrualPeriodStartDateArray)
                PeriodBal = PeriodBal - PIKInterestPaid - PIKPrincipalPaid;
            int NumDaysInAccPeriod = ListDatesTab[ndx1].NumberofDaysintheAccrualPeriod.GetValueOrDefault(30);
            CalculatePIKInterest(pikindex, PeriodBal, pmtdatetag, effectivedate, pikscheff.PIKIntCalcMethodIDText, NumDaysInAccPeriod);

            if (pikindex > 0)
                ListPIKInterestTab[pikindex].CumPIKInterest = ListPIKInterestTab[pikindex - 1].CumPIKInterest.GetValueOrDefault() + ListPIKInterestTab[pikindex].DailyAccruedPIKInterest.GetValueOrDefault(0);
            else
                ListPIKInterestTab[pikindex].CumPIKInterest = ListPIKInterestTab[pikindex].DailyAccruedPIKInterest.GetValueOrDefault(0);


            if (ListPIKInterestTab[pikindex].Date.Value.Date == effectivedate && effectivedate != closingdate)
            {
                CumPikInt = ListPIKInterestTab[pikindex - 1].AccumPIKInterestforCurrentAccrualPeriod.GetValueOrDefault(0);
                CumPikInt = CumPikInt + ListPIKInterestTab[pikindex].DailyAccruedPIKInterest.GetValueOrDefault(0);
            }
            else
            {
                CumPikInt = CumPikInt + ListPIKInterestTab[pikindex].DailyAccruedPIKInterest.GetValueOrDefault(0);
            }

            //Daily Accrued PIK Interest Adjusted for PIK Interest Cap
            //TODO: Add check based on Note Balance
            if (ListPIKInterestTab[pikindex].PIKInterestCapfromPIKTable != null && ListPIKInterestTab[pikindex].PIKInterestCapfromPIKTable.GetValueOrDefault(0) > 0)
            {
                if (ListPIKInterestTab[pikindex].CumPIKInterest.GetValueOrDefault() > ListPIKInterestTab[pikindex].PIKInterestCapfromPIKTable.GetValueOrDefault(0))
                {
                    if (ListPIKInterestTab[pikindex].CumPIKInterest.GetValueOrDefault() - ListPIKInterestTab[pikindex].DailyAccruedPIKInterest.GetValueOrDefault(0) < ListPIKInterestTab[pikindex].PIKInterestCapfromPIKTable.GetValueOrDefault(0))
                        ListPIKInterestTab[pikindex].DailyAccruedPIKInterestAdjustedforPIKInterestCap = ListPIKInterestTab[pikindex].PIKInterestCapfromPIKTable.GetValueOrDefault(0) -
                            (ListPIKInterestTab[pikindex].CumPIKInterest.GetValueOrDefault() - ListPIKInterestTab[pikindex].DailyAccruedPIKInterest.GetValueOrDefault(0));
                    else
                        ListPIKInterestTab[pikindex].DailyAccruedPIKInterestAdjustedforPIKInterestCap = 0;
                }
                else
                    ListPIKInterestTab[pikindex].DailyAccruedPIKInterestAdjustedforPIKInterestCap = Math.Max(0, Math.Min(Convert.ToDecimal(ListPIKInterestTab[pikindex].DailyAccruedPIKInterest.GetValueOrDefault(0)), Math.Abs(Convert.ToDecimal(ListPIKInterestTab[pikindex].PIKInterestCapfromPIKTable.GetValueOrDefault(0) - (CumPikInt - ListPIKInterestTab[pikindex].DailyAccruedPIKInterest.GetValueOrDefault(0))))));
            }
            else
            {
                ListPIKInterestTab[pikindex].DailyAccruedPIKInterestAdjustedforPIKInterestCap = ListPIKInterestTab[pikindex].DailyAccruedPIKInterest;
            }
            // ' Daily Accrued PIK Interest to be Transferred to Related Note
            ListPIKInterestTab[pikindex].DailyAccruedPIKInteresttobeTransferredtoRelatedNote = ListPIKInterestTab[pikindex].DailyAccruedPIKInterest.GetValueOrDefault(0)
                - ListPIKInterestTab[pikindex].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0);

            if (pikindex > 0)
            {
                ListPIKInterestTab[pikindex].PIKBusinessDateAdjcheck = ListPIKInterestTab[pikindex - 1].PIKBusinessDateAdjcheck.GetValueOrDefault(0);
            }

            // Calculate Accum PIK Interest on Business Adj Interest Accrual End Date (Payment Date)
            if (pmtdatetag == 1)
            {
                //Check to see if the PIK Interest for the current period (not day) has a User Override. This will affect PIKInterest on  Pmt Date, Accrual End date and Basis Calc.
                ndx = ListPIKInterestOverride.FindIndex(dt => dt.DueDate == ListPIKInterestTab[pikindex].Date);
                PIKPrinFundingOverridePmtDate = ndx < 0 ? 0 : ListPIKInterestOverride[ndx].PIKInterestOverrideAmount.GetValueOrDefault();

                //Find the DateTab Record corresponding to the payment date. There should be only one.
                int ndx2 = ListDatesTab.FindIndex(x => x.PaymentDateAdjustedforWorkingDay == ListPIKInterestTab[pikindex].Date);
                DatesTab date = ListDatesTab[ndx2];

                StartDate = date.InterestAccrualPeriodStartDateArray;
                if (ListPIKInterestTab[pikindex].Date.Value == SelectedMaturityDateLatest)
                {
                    EndDate = ListPIKInterestTab[pikindex].Date;
                    DaysPmtDateToIntAccEndDate = 0;
                }
                else
                {
                    EndDate = date.InterestAccrualPeriodEndDateArray;
                    DaysPmtDateToIntAccEndDate = Math.Max(0, date.InterestAccrualPeriodEndDateArray.Value.Subtract(date.PaymentDateAdjustedforWorkingDay.Value).Days);
                }

                PIKIntBusAdjPmtDate = ListPIKInterestTab.Where(x => x.Date >= StartDate && x.Date <= EndDate).Sum(y => y.DailyAccruedPIKInterestAdjustedforPIKInterestCap);
                PIKPmtAmount = Math.Round(PIKIntBusAdjPmtDate.GetValueOrDefault(0) + ListPIKInterestTab[pikindex].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0) * DaysPmtDateToIntAccEndDate, 2);

                if (PIKPrinFundingOverridePmtDate == 0)
                {
                    ListPIKInterestTab[pikindex].PIKInterestonBusinessAdjInterestAccrualEndDate = PIKPmtAmount;
                }
                else
                {
                    ListPIKInterestTab[pikindex].PIKInterestonBusinessAdjInterestAccrualEndDate = PIKPrinFundingOverridePmtDate;
                    ListPIKInterestTab[pikindex].UnPaidPIK = PIKPmtAmount - PIKPrinFundingOverridePmtDate;
                }

                if (date.PaymentDateAdjustedforWorkingDay < date.InterestAccrualPeriodEndDateArray)
                    ListPIKInterestTab[pikindex].PIKBusinessDateAdjcheck = 1;

                //Lookup the PIK Interest Amount borrower paid against the transaction log and net against the PIK Interest Accrued for the Period / Payment Date
                ListPIKInterestTab[pikindex].PIKInterestPaidForThePeriod = PIKInterestPaid;
                ListPIKInterestTab[pikindex].PIKInterestPaidAppliedForThePeriod =
                    Math.Round(ListPIKInterestTab[pikindex].PIKInterestonBusinessAdjInterestAccrualEndDate.GetValueOrDefault(0) - ListPIKInterestTab[pikindex].PIKInterestPaidForThePeriod.GetValueOrDefault(0), 2);
            }


            if (ListPIKInterestTab[pikindex].Date.Value.Date == effectivedate && effectivedate != closingdate)
            {
                CumPikAccrual = ListPIKInterestTab[pikindex - 1].AccumPIKInterestforCurrentAccrualPeriod.GetValueOrDefault(0);
            }

            if (ListPIKInterestTab[pikindex].AccrualPeriodEndDateTag == 1)
            {
                ndx = ListPIKInterestOverride.FindIndex(dt => dt.AccrualEndDate == ListPIKInterestTab[pikindex].Date);
                PIKPrinFundingOverrideAccEndDate = ndx < 0 ? 0 : ListPIKInterestOverride[ndx].PIKInterestOverrideAmount.GetValueOrDefault();

                if (PIKPrinFundingOverrideAccEndDate > 0)
                    ListPIKInterestTab[pikindex].PIKInterestforthePeriod = PIKPrinFundingOverrideAccEndDate;
                else
                    ListPIKInterestTab[pikindex].PIKInterestforthePeriod = Math.Round(CumPikAccrual.GetValueOrDefault(0) + ListPIKInterestTab[pikindex].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0), 2);

                ListPIKInterestTab[pikindex].TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod = CumPikRelated + ListPIKInterestTab[pikindex].DailyAccruedPIKInteresttobeTransferredtoRelatedNote.GetValueOrDefault(0);
                CumPikAccrual = 0;
                CumPikRelated = 0;
                ListPIKInterestTab[pikindex].PIKBusinessDateAdjcheck = 0;
            }
            else
            {
                CumPikAccrual = CumPikAccrual + ListPIKInterestTab[pikindex].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0);
                CumPikRelated = CumPikRelated + ListPIKInterestTab[pikindex].DailyAccruedPIKInteresttobeTransferredtoRelatedNote.GetValueOrDefault(0);
                ListPIKInterestTab[pikindex].PIKInterestforthePeriod = 0;
                ListPIKInterestTab[pikindex].TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod = 0;
            }
            // ws_pik.Range("G" & pcell).Value = cum_pik_accrual ws_pik.Range("P" & pcell).Value = cum_pik_related
            ListPIKInterestTab[pikindex].AccumPIKInterestforCurrentAccrualPeriod = CumPikAccrual;
            ListPIKInterestTab[pikindex].AccumPIKInteresttobeTransferredtoRelatedNoteforCurrentAccrualPeriod = CumPikRelated;
            if (pikindex > 0)
            {
                ListPIKInterestTab[pikindex].BeginningPIKBalanceifnotCompoundedinsideLoanBalance = ListPIKInterestTab[pikindex - 1].EndingPIKBalanceifnotCompoundedinsideLoanBalance.GetValueOrDefault(0);
            }

            // ' Daily Accrued Compounded PIK Interest
            ListPIKInterestTab[pikindex].DailyAccruedCompoundedPIKInterest = ListPIKInterestTab[pikindex].BeginningPIKBalanceifnotCompoundedinsideLoanBalance.GetValueOrDefault(0) * (ListRateTab[pikindex].AllInPIKInterestCompoundingRate.GetValueOrDefault(0) / 360);
            //' Accum Compounded PIK Interest for Current Accrual Period
            if (ListPIKInterestTab[pikindex].AccrualPeriodEndDateTag == 1)
            {
                ListPIKInterestTab[pikindex].PIKInterestforthePeriodBalloon = CumCompPik + ListPIKInterestTab[pikindex].DailyAccruedCompoundedPIKInterest.GetValueOrDefault(0);
                CumCompPik = 0;
            }
            else
            {
                ListPIKInterestTab[pikindex].PIKInterestforthePeriodBalloon = 0;
                CumCompPik = CumCompPik + ListPIKInterestTab[pikindex].DailyAccruedCompoundedPIKInterest.GetValueOrDefault(0);
            }

            ListPIKInterestTab[pikindex].AccumCompoundedPIKInterestforCurrentAccrualPeriod = CumCompPik;
            //' PIK Balloon Payment
            if (ListPIKInterestTab[pikindex].Date == Matdate)
            {
                ListPIKInterestTab[pikindex].PIKBalanceBalloonPayment = ListPIKInterestTab[pikindex].BeginningPIKBalanceifnotCompoundedinsideLoanBalance.GetValueOrDefault(0) + ListPIKInterestTab[pikindex].PIKInterestforthePeriodBalloon.GetValueOrDefault(0);
            }
            else
            {
                ListPIKInterestTab[pikindex].PIKBalanceBalloonPayment = 0;
            }
            //   ' Ending PIK Balance if not Compounded inside Loan Balance
            if (PikSepComp == "Y")
            {
                ListPIKInterestTab[pikindex].EndingPIKBalanceifnotCompoundedinsideLoanBalance = ListPIKInterestTab[pikindex].BeginningPIKBalanceifnotCompoundedinsideLoanBalance.GetValueOrDefault(0) + ListPIKInterestTab[pikindex].PIKInterestforthePeriodBalloon.GetValueOrDefault(0) - ListPIKInterestTab[pikindex].PIKBalanceBalloonPayment.GetValueOrDefault(0);
            }
        }

        private void CalculatePIKInterest(int pikindex, decimal PeriodBal, int? pmtdatetag, DateTime effectivedate, string PIKIntCalcMethod, int NumDaysInAccPeriod)
        {
            DateTime? PikStartDate, AccrualStartDate, AccrualEndDate;
            PIKSchedule pikscheff = ListNotePIKScheduleLatest.ToArray()[0];
            Decimal? PIKIntBusAdjPmtDate = 0, DailyAccPIKInterest = 0, ratefactor = 0;
            PikStartDate = pikscheff.StartDate;
            int NumofDays = 0;

            if (pmtdatetag == null || pmtdatetag == 0)
            {
                // Regular Day ==> It is not required to calculate the Accum PIKInterest and add to balance before calculating interst.
                CalculateDailyPIKInterest(pikindex, PeriodBal, pmtdatetag, effectivedate, PIKIntCalcMethod, NumDaysInAccPeriod);
            }
            else
            {
                //Payment Day - Check how many days off from Payment Date Not Adjusted for Holidays
                //Find the DateTab Record corresponding to the payment date.
                int dtndx = ListDatesTab.FindIndex(x => x.PaymentDateAdjustedforWorkingDay == ListPIKInterestTab[pikindex].Date);
                DatesTab date = ListDatesTab[dtndx];
                NumofDays = Math.Max(0, ListDatesTab[dtndx].PaymentDateusingAccrualFreqNotAdjustedforBusinessDay.Value.Subtract(ListDatesTab[dtndx].PaymentDateAdjustedforWorkingDay.Value).Days);
                ratefactor = NumericExtensions.SafeDivision(ListRateTab[pikindex].AllInPIKInterest.GetValueOrDefault(0), 360M) / (1 - NumofDays * NumericExtensions.SafeDivision(ListRateTab[pikindex].AllInPIKInterest.GetValueOrDefault(0), 360M));

                //Check to see if the PIK Interest for the current period (not day) has a User Override. This will affect PIKInterest on  Pmt Date, Accrual End date and Basis Calc.
                int ndx = ListPIKInterestOverride.FindIndex(dt => dt.DueDate == ListPIKInterestTab[pikindex].Date);
                Decimal? PIKPrinFundingOverridePmtDate = ndx < 0 ? 0 : ListPIKInterestOverride[ndx].PIKInterestOverrideAmount.GetValueOrDefault();

                AccrualStartDate = date.InterestAccrualPeriodStartDateArray;
                AccrualEndDate = date.InterestAccrualPeriodEndDateArray;

                if (date.PaymentDateAdjustedforWorkingDay.GetValueOrDefault() == date.PaymentDateusingAccrualFreqNotAdjustedforBusinessDay.GetValueOrDefault())
                {
                    if (PIKPrinFundingOverridePmtDate != 0)
                        PIKIntBusAdjPmtDate = PIKPrinFundingOverridePmtDate;
                    else
                        PIKIntBusAdjPmtDate = ListPIKInterestTab.Where(x => x.Date >= AccrualStartDate && x.Date <= AccrualEndDate).Sum(y => y.DailyAccruedPIKInterestAdjustedforPIKInterestCap);
                }
                else
                {
                    //If PIKIntCalcMethodOnHolidays == Project, Backout PIKInterest for this period else use the previous days interest
                    if (PIKIntCalcMethodOnHolidays == 1)
                    {
                        DailyAccPIKInterest = (PeriodBal + ListPIKInterestTab[pikindex - 1].AccumPIKInterestforCurrentAccrualPeriod) * (ratefactor);
                        PIKIntBusAdjPmtDate = ListPIKInterestTab[pikindex - 1].AccumPIKInterestforCurrentAccrualPeriod + DailyAccPIKInterest * NumofDays;
                    }
                }

                if (date.PaymentDateAdjustedforWorkingDay < date.InterestAccrualPeriodEndDateArray)
                    ListPIKInterestTab[pikindex].PIKBusinessDateAdjcheck = 1;

                CalculateDailyPIKInterest(pikindex, PeriodBal + PIKIntBusAdjPmtDate.Value, pmtdatetag, effectivedate, PIKIntCalcMethod, NumDaysInAccPeriod);
            }
        }
        private void CalculateDailyPIKInterest(int pikindex, decimal PeriodBal, int? pmtdatetag, DateTime effectivedate, string PIKIntCalcMethod, int NumDaysInAccPeriod)
        {
            int AddOnDays = 0;
            decimal? Adjustment30_360vsActual_360 = InterestCalcMethod(PIKIntCalcMethod, NumDaysInAccPeriod).Item1;
            int DayCount = InterestCalcMethod(PIKIntCalcMethod, NumDaysInAccPeriod).Item2;
            if (pikindex > 0)
            {
                if (ListPIKInterestTab[pikindex - 1].PIKBusinessDateAdjcheck == 1)
                {
                    ListPIKInterestTab[pikindex].DailyAccruedPIKInterest = ListPIKInterestTab[pikindex - 1].DailyAccruedPIKInterest.GetValueOrDefault(0);
                }
                else
                {
                    ListPIKInterestTab[pikindex].DailyAccruedPIKInterest = PeriodBal * Adjustment30_360vsActual_360 * NumericExtensions.SafeDivision(ListRateTab[pikindex].AllInPIKInterest.GetValueOrDefault(0), DayCount);
                }
                //On Maturity and Payoff - Calculate PIK Interest due for the Note based on Acrrual Convention and add to final PIK Interest
                if (ListPIKInterestTab[pikindex].Date.Value == SelectedMaturityDateLatest)
                {
                    int ndx = ListDatesTab.FindIndex(x => x.InterestAccrualPeriodStartDateArray <= ListPIKInterestTab[pikindex].Date.Value && x.InterestAccrualPeriodEndDateArray >= ListPIKInterestTab[pikindex].Date.Value);
                    DateTime? AccrualEndDate = ListDatesTab[ndx].InterestAccrualPeriodEndDateArray;
                    AddOnDays = AccrualEndDate.GetValueOrDefault().Subtract(ListPIKInterestTab[pikindex].Date.Value).Days + 1;
                    switch (noteDC.InterestCalculationRuleForPaydownsText)
                    {
                        case "Include Prepayment Date":
                            break;

                        case "Exclude Prepayment Date":
                            ListPIKInterestTab[pikindex].DailyAccruedPIKInterest = 0;
                            break;

                        case "Full Period Accrual":
                            ListPIKInterestTab[pikindex].DailyAccruedPIKInterest = ListPIKInterestTab[pikindex].DailyAccruedPIKInterest * AddOnDays;
                            break;
                    }
                }

                if (ListPIKInterestTab[pikindex].Date.Value > SelectedMaturityDateLatest)
                    ListPIKInterestTab[pikindex].DailyAccruedPIKInterest = 0;
            }
            else
            {
                ListPIKInterestTab[pikindex].DailyAccruedPIKInterest = PeriodBal * Adjustment30_360vsActual_360 * NumericExtensions.SafeDivision(ListRateTab[pikindex].AllInPIKInterest.GetValueOrDefault(0), DayCount);
            }
        }

        #region Coupon
        public void CalculateCouponTab(DateTime effectiveDate)
        {
            int CouponIndex = 0, DayCountPurchInt = 360;
            Int32 DayCount, Fyear = 0, Fmo = 0, Fday = 0, pmtyear, pmtmo, pmtday, bdaylag, ffdaycount, tempCellIndex;
#pragma warning disable CS0168 // The variable 'purchint' is declared but never used
#pragma warning disable CS0219 // The variable 'temp1' is assigned but its value is never used
            decimal? CumInt, CumcStrip, temp1, temp2, intpmt, cspmt, purchint, stubintff, cumffint = 0, stubIntOverride, purchIntOverride, initialAmt, indexOverride, index_closingdate = 0, cpn = 0, indexFloor = 0, Pikpmt = 0;
#pragma warning restore CS0219 // The variable 'temp1' is assigned but its value is never used
#pragma warning restore CS0168 // The variable 'purchint' is declared but never used
#pragma warning disable CS0168 // The variable 'time' is declared but never used
            DateTime Firstpmtdate, ClosingDate, ffdate, ffaccend, purchaseAccStartDate, time, InitialAccendDateCalculated, initialAccEndDate;
#pragma warning restore CS0168 // The variable 'time' is declared but never used
            decimal? PeriodBegBal = 0, PeriodBegBaldd = 0;
            CumcStrip = 0;
            CumInt = 0;
            CouponIndex = 0;
            temp1 = 0;
            tempCellIndex = 0;
            decimal? CumIntDrop = 0, CumcStripDrop = 0, IntpmtDrop = 0, cspmtDrop = 0, ServicingAmt = 0, ActualDelta = 0;

            ClosingDate = Convert.ToDateTime(noteDC.ClosingDate);
            stubIntOverride = noteDC.StubIntOverride.GetValueOrDefault(0);
            purchIntOverride = noteDC.PurchasedInterestOverride.GetValueOrDefault(0);
            //  ' Determine First PMT Date
            //'Payment Date Referenced for Interest Accrual Period - Adjusted for Business Day
            pmtyear = Convert.ToDateTime(noteDC.FirstPaymentDate).Year;
            pmtmo = Convert.ToDateTime(noteDC.FirstPaymentDate).Month;
            pmtday = Convert.ToDateTime(noteDC.FirstPaymentDate).Day;
            bdaylag = Convert.ToInt32(noteDC.PaymentDateBusinessDayLag);
            Firstpmtdate = GetnextWorkingDays(CreateNewDate(pmtyear, pmtmo, pmtday).AddDays(-bdaylag), bdaylag, DisableBusinessDayAdjustmentText);
            initialAccEndDate = noteDC.InitialInterestAccrualEndDate.Value.Date;
            InitialAccendDateCalculated = CreateNewDate(initialAccEndDate.Year, initialAccEndDate.Month - 1, initialAccEndDate.Day);

            if (effectiveDate.Equals(ClosingDate))
            {
                // ' ---Purchased / Stub Interest Paid in Advance---
                StubInterestAmount = 0;
                PurchasedStubInterest = 0;
                if (Firstpmtdate.Day != (initialAccEndDate.Day + 1))
                {
                    Fyear = initialAccEndDate.Year;
                    Fday = initialAccEndDate.Day + 1;
                    Fmo = initialAccEndDate.Month;
                }
                else
                {
                    Fyear = Firstpmtdate.Year;
                    Fday = Firstpmtdate.Day;
                    Fmo = Firstpmtdate.Month;
                }

                // ' Loan Purchase Accural Start Date
                DayCountPurchInt = InterestCalcMethod(GetIntCalcMethodFromCouponSchedule(ClosingDate)).Item2;
                initialAmt = noteDC.InitialFundingAmount.GetValueOrDefault(0) + ListBalanceTab[0].FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0);
                indexOverride = noteDC.InitialIndexValueOverride.GetValueOrDefault(0);
                index_closingdate = indexOverride > 0 ? indexOverride : IndexRoundingBasedOnRule(GetMostRecentLiborValue(noteDC.ClosingDate.Value.AddDays(noteDC.DeterminationDateLeadDays.GetValueOrDefault(0))));
                //index_closingdate = indexOverride > 0 ? indexOverride : ListRateTab[0].DIndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0);
                indexFloor = GetValueFromCouponSchedule("Index Floor", ClosingDate);
                if (GetValueFromCouponSchedule("Rate", ClosingDate) > 0)
                    cpn = GetValueFromCouponSchedule("Rate", ClosingDate);
                else
                    cpn = GetValueFromCouponSchedule("Spread", ClosingDate) + Math.Max(Convert.ToDecimal(index_closingdate), Convert.ToDecimal(indexFloor));
                if (noteDC.LoanPurchaseYNText == "Y")
                {
                    purchaseAccStartDate = CreateNewDate(Fyear, Fmo - 1, Convert.ToInt32(Fday));
                    // calculating full amount of interest for the first period (stub period of the purchse date)
                    double datdiff = (Convert.ToDateTime(initialAccEndDate) - purchaseAccStartDate).TotalDays + 1;
                    initialFullMoInt = initialAmt * cpn * Convert.ToDecimal(datdiff) / DayCountPurchInt;
                    PurchasedStubInterestCalc = initialAmt * cpn * Convert.ToDecimal((ClosingDate.Date - purchaseAccStartDate.Date).TotalDays) / DayCountPurchInt;
                    if (purchIntOverride != 0)
                    {
                        PurchasedStubInterest = purchIntOverride;
                    }
                    else
                    {
                        //purchaseAccStartDate = System.DateTime.Now;
                        PurchasedStubInterest = PurchasedStubInterestCalc;
                    }
                }
                //' Effectve First Coupon Accrual Start Date
                if (noteDC.StubPaidinAdvanceYNText == "Y")
                {
                    EffectveFirstCouponAccrualStartDate = stubEndDate.Value.AddDays(1);
                }
                else
                {
                    EffectveFirstCouponAccrualStartDate = ClosingDate;
                }
                //' First Accrual Day Count
                if (LoanPurchaseAccuralStartDate == null) //If ws_coupon.Range("F4").Value = "None" Then
                {
                    FirstAccDayCount = Convert.ToInt32((Firstpmtdate.Date - EffectveFirstCouponAccrualStartDate.Date).TotalDays);
                }
                else
                {
                    FirstAccDayCount = Convert.ToInt32((Firstpmtdate.Date - LoanPurchaseAccuralStartDate.Date).TotalDays);
                }

                //' Purchased Accrued Day Count:
                int temp_diff = 0;
                if (noteDC.StubPaidinAdvanceYNText == "Y")
                {
                    StubDayCount = Convert.ToInt32((Firstpmtdate.Date - ClosingDate.Date).TotalDays) - FirstAccDayCount;
                }
                else
                {
                    StubDayCount = 0;
                }
                PurchasedAccDayCount = Math.Max(temp_diff, 0);
            }
            stubint = 0;
            stubintff = 0;
            foreach (CouponTab coupon in ListCouponTab)
            {
                if (Convert.ToDateTime(coupon.Date).Date >= effectiveDate.Date)
                {
                    if (coupon.Date.Value.Date == effectiveDate.Date && CouponIndex > 0)
                    {
                        CumInt = ListCouponTab[CouponIndex - 1].AccumInterestforCurrentAccrualPeriod.GetValueOrDefault(0);
                        CumIntDrop = ListCouponTab[CouponIndex - 1].PMTDropDateAccumInterestforCurrentAccrualPeriod.GetValueOrDefault(0);
                    }
                    string value = coupon.InterestCalcMethod;
                    switch (value)
                    {
                        case "30/360":
                            coupon.InterestCalcMethodAdjustment30_360vsActual_360 = 30 / coupon.NumberofDaysinReferencedAccrualPeriod;
                            DayCount = 360;
                            break;

                        case "Actual/365":
                            coupon.InterestCalcMethodAdjustment30_360vsActual_360 = 1;
                            DayCount = 365;
                            break;

                        default:
                            coupon.InterestCalcMethodAdjustment30_360vsActual_360 = 1;
                            DayCount = 360;
                            break;
                    }

                    // Stub Interest on Future Funding(if applicable)
                    stubintff = 0;
                    if (noteDC.StubOnFFtext == "Y" && ListBalanceTab[CouponIndex].FutureAdvancesFromFutureFundingSchedule != 0)
                    {
                        ffdate = Convert.ToDateTime(ListBalanceTab[CouponIndex].Date);
                        int index = 0;
                        while (Convert.ToDateTime(ListDatesTab[index].InterestAccrualPeriodEndDateArray).Date >= effectiveDate.Date)
                        {
                            index = index + 1;
                        }
                        ffaccend = Convert.ToDateTime(ListDatesTab[index].InterestAccrualPeriodEndDateArray);
                        ffdaycount = Convert.ToInt32((ffaccend.Date - ffdate.Date).TotalDays) + 1;
                        stubintff = ListBalanceTab[CouponIndex].FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0)
                            * coupon.InterestCalcMethodAdjustment30_360vsActual_360.GetValueOrDefault(0)
                            * ListRateTab[CouponIndex].AllInCouponRate.GetValueOrDefault(0) * NumericExtensions.SafeDivision(ffdaycount, DayCount);
                    }

                    if (coupon.Date <= accEndDate)
                    {
                        if (CouponIndex > 0)
                        {
                            if (coupon.Date == effectiveDate)
                            {
                                PeriodBegBal = ListBalanceTab[CouponIndex - 1].EndingBalance.GetValueOrDefault(0);
                                PeriodBegBaldd = ListBalanceTab[CouponIndex].EndingBalanceUsingPMTDropDate.GetValueOrDefault(0);
                            }

                            if (ListCouponTab[CouponIndex - 1].InterestAccrualPeriodEndDateTag == 1)
                            {
                                PeriodBegBal = ListBalanceTab[CouponIndex - 1].EndingBalance.GetValueOrDefault(0);
                                PeriodBegBaldd = ListBalanceTab[CouponIndex].EndingBalanceUsingPMTDropDate.GetValueOrDefault(0);
                            }
                            if (ListBalanceTab[CouponIndex].PMTDateTag == 1 && ListBalanceTab[CouponIndex].AccrualPeriodEndDateTag == 0 && ListBalanceTab[CouponIndex + 1].AccrualPeriodEndDateTag == 0)
                            {
                                PeriodBegBal = ListBalanceTab[CouponIndex].EndingBalance.GetValueOrDefault(0);
                                PeriodBegBaldd = ListBalanceTab[CouponIndex].EndingBalanceUsingPMTDropDate.GetValueOrDefault(0);
                            }
                        }

                        // Daily Accrued Coupon based on Future Advances
                        coupon.CouponbasedonFutureFunding = ListBalanceTab[CouponIndex].CumFutureAdvancesForAccrualPeriod.GetValueOrDefault(0) * coupon.InterestCalcMethodAdjustment30_360vsActual_360.GetValueOrDefault(0) * ListRateTab[CouponIndex].AllInCouponRate.GetValueOrDefault(0) / DayCount;
                        DailyInterestAccrualCalc(CouponIndex, DayCount, coupon.Date, PeriodBegBal, PeriodBegBaldd);
                    }
                    else
                    {
                        //' Daily Accrued Interest before Stripping Rule
                        coupon.DailyAccruedInterestbeforeStrippingRule = 0;
                        //' Daily Accrued Coupon Stripping
                        coupon.DailyAccruedCouponStripping = 0;
                    }
                    //Stub Interest Amount & Purchased Stub Interest
                    if (effectiveDate == noteDC.ClosingDate)
                    {
                        if (coupon.Date >= ClosingDate && coupon.Date < EffectveFirstCouponAccrualStartDate && stubIntOverride != 0)
                        {
                            stubint = Convert.ToDecimal(stubIntOverride);
                        }
                        else if (coupon.Date >= ClosingDate && coupon.Date < EffectveFirstCouponAccrualStartDate)
                        {
                            stubint = stubint + Convert.ToDecimal(coupon.DailyAccruedInterest);
                        }
                        if (coupon.Date <= EffectveFirstCouponAccrualStartDate)
                        {
                            StubInterestAmount = stubint;
                        }
                    }
                    // Accum Interest for Current Accrual Period
                    if (coupon.InterestAccrualPeriodEndDateTag == 1)
                    {
                        CumInt = 0;
                        CumIntDrop = 0;
                        CumcStrip = 0;
                        CumcStripDrop = 0;
                        cumffint = 0;
                        coupon.InterestforthePeriodShortfall = (coupon.AccumInterestforCurrentAccrualPeriod.GetValueOrDefault(0) +
                         coupon.DailyAccruedInterest.GetValueOrDefault(0))
                         * ListBalanceTab[CouponIndex].DebtServiceShortfall.GetValueOrDefault(0);

                        coupon.CouponStrippingforthePeriod = coupon.AccumCouponStrippingforCurrentAccrualPeriod.GetValueOrDefault(0)
                         + coupon.DailyAccruedCouponStripping.GetValueOrDefault(0);

                        if (CouponIndex > 0 && coupon.Date != SelectedMaturityDateLatest)
                        {
                            coupon.NumberofDaysinReferencedAccrualPeriod = ListCouponTab[CouponIndex - 1].NumberofDaysinReferencedAccrualPeriod.GetValueOrDefault(0);
                        }
                    }
                    else
                    {
                        CumInt = CumInt + coupon.DailyAccruedInterest.GetValueOrDefault(0);
                        CumIntDrop = CumIntDrop + coupon.PMTDropDateDailyAccruedInterest.GetValueOrDefault(0);
                        CumcStrip = CumcStrip + coupon.DailyAccruedCouponStripping.GetValueOrDefault(0);
                        CumcStripDrop = CumcStripDrop + coupon.PMTDropDateDailyAccruedCouponStripping.GetValueOrDefault(0);

                        cumffint = cumffint + coupon.CouponbasedonFutureFunding;
                        coupon.InterestforthePeriodShortfall = 0;
                        coupon.CouponStrippingforthePeriod = 0;
                    }

                    coupon.AccumInterestforCurrentAccrualPeriod = CumInt;
                    coupon.PMTDropDateAccumInterestforCurrentAccrualPeriod = CumIntDrop;
                    coupon.AccumCouponStrippingforCurrentAccrualPeriod = CumcStrip;
                    coupon.PMTDropDateAccumCouponStrippingforCurrentAccrualPeriod = CumcStripDrop;
                    coupon.AccumCouponStrippingforCurrentAccrualPeriod = cumffint;

                    // ' Cumulative Interest Paid on PMT Date Shortfall
                    if (ListRateTab[CouponIndex].SeverityatDefault == null || ListRateTab[CouponIndex].SeverityatDefault == 0)
                    {
                        if (CouponIndex == 0)
                        {
                            coupon.CumulativeInterestPaidonPMTDateShortfall = coupon.InterestPaidonPMTDateShortfall.GetValueOrDefault(0);
                        }
                        else
                        {
                            coupon.CumulativeInterestPaidonPMTDateShortfall = coupon.InterestPaidonPMTDateShortfall.GetValueOrDefault(0) -
                             ListCouponTab[CouponIndex - 1].CumulativeInterestPaidonPMTDateShortfall.GetValueOrDefault(0);
                        }

                        coupon.InterestShortfallLoss = coupon.CumulativeInterestPaidonPMTDateShortfall.GetValueOrDefault(0) *
                                    ListRateTab[CouponIndex].SeverityatDefault.GetValueOrDefault(0);
                        coupon.InterestShortfallRecovery = coupon.CumulativeInterestPaidonPMTDateShortfall.GetValueOrDefault(0) - coupon.InterestShortfallLoss.GetValueOrDefault(0);
                    }
                    else
                    {
                        coupon.CumulativeInterestPaidonPMTDateShortfall = 0;
                        coupon.InterestShortfallLoss = 0;
                        coupon.InterestShortfallRecovery = 0;
                    }
                    //Interest for the Period
                    InterestForThePeriod(CouponIndex, InitialAccendDateCalculated, StubInterestAmount, stubintff);
                }
                CouponIndex = CouponIndex + 1;
            }

            CouponIndex = 0;
            //' Interest Paid on Payment Date
            foreach (CouponTab coupon in ListCouponTab)
            {
                if (Convert.ToDateTime(coupon.Date).Date >= effectiveDate.Date)
                {
                    intpmt = 0;
                    IntpmtDrop = 0;
                    cspmt = 0;
                    cspmtDrop = 0;
                    Pikpmt = 0;
                    foreach (var liad in ListDatesTab)
                    {
                        if (liad.PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay == coupon.Date)
                        {
                            tempCellIndex = 0;
                            foreach (CouponTab ctemp in ListCouponTab)
                            {
                                if (ctemp.Date >= liad.InterestAccrualPeriodStartDateArray && ctemp.Date <= liad.InterestAccrualPeriodEndDateArray)
                                {
                                    if (coupon.Date.Value.Date <= SelectedMaturityDateLatest.Value.Date)
                                    {
                                        intpmt = intpmt + ctemp.DailyAccruedInterest.GetValueOrDefault(0);
                                        cspmt = cspmt + ctemp.DailyAccruedCouponStripping.GetValueOrDefault(0);

                                        IntpmtDrop = IntpmtDrop + ctemp.PMTDropDateDailyAccruedInterest.GetValueOrDefault(0);
                                        cspmtDrop = cspmtDrop + ctemp.PMTDropDateDailyAccruedCouponStripping.GetValueOrDefault(0);
                                        Pikpmt = Pikpmt + ListPIKInterestTab[tempCellIndex].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0);
                                    }
                                }
                                tempCellIndex = tempCellIndex + 1;
                            }
                        }
                    }

                    if (stubEndDate == null)
                    {
                        stubEndDate = DateTime.MinValue;
                    }
                    // ' If arrCoupon(ccell - 12, 1) = ws_assumptions.Range("FirstPMTDate").Value Then
                    if (coupon.Date == CreateNewDate(initialAccEndDate.Year, initialAccEndDate.Month - 1, initialAccEndDate.Day + 1))
                    {
                        temp2 = StubInterestAmount;//+ PurchasedStubInterest;
                    }
                    else
                    {
                        temp2 = 0;
                    }
                    if (Convert.ToDateTime(coupon.Date) == Firstpmtdate && noteDC.LoanPurchaseYNText == "Y")
                    {
                        coupon.InterestPaidonPaymentDate = initialFullMoInt;
                        coupon.PMTDropDateInterestPaidonPaymentDate = initialFullMoInt;
                    }
                    else if ((coupon.Date == CreateNewDate(stubEndDate.Value.Year, stubEndDate.Value.Month, stubEndDate.Value.Day + 1))
                             || (coupon.Date.Value.Date == BusinessDayAdjustment(stubEndDate.Value.Date.AddDays(1), "PMT Date", null))
                             || (coupon.Date == CreateNewDate(Firstpmtdate.Year, Firstpmtdate.Month - 1, Firstpmtdate.Day))
                             && (coupon.NumberofDaysinReferencedAccrualPeriod < 28)
                             && noteDC.StubPaidinAdvanceYNText == "Y")
                    {
                        coupon.InterestPaidonPaymentDate = 0;
                        coupon.PMTDropDateInterestPaidonPaymentDate = 0;
                    }
                    else if (coupon.Date == SelectedMaturityDateLatest)
                    {
                        var finalperinterest = CalcInterestOnFinalPaymentDate(CouponIndex, noteDC.InterestCalculationRuleForPaydownsText);
                        coupon.InterestPaidonPaymentDate = finalperinterest.Item1;
                        coupon.PMTDropDateInterestPaidonPaymentDate = finalperinterest.Item2;
                    }
                    else
                    {
                        coupon.InterestPaidonPaymentDate = Math.Max(0, Convert.ToDecimal(intpmt * (1 - ListBalanceTab[CouponIndex].DebtServiceShortfall.GetValueOrDefault(0)))) + stubintff;
                        coupon.PMTDropDateInterestPaidonPaymentDate = Math.Max(0, Convert.ToDecimal(IntpmtDrop * (1 - ListBalanceTab[CouponIndex].DebtServiceShortfall.GetValueOrDefault(0)))) + stubintff;
                    }

                    coupon.InterestPaidonPMTDateShortfall = intpmt * ListBalanceTab[CouponIndex].DebtServiceShortfall.GetValueOrDefault(0);
                    coupon.CouponStrippedonPaymentDate = cspmt;
                    coupon.PMTDropDateCouponStrippedonPaymentDate = cspmtDrop;
                    ListPIKInterestTab[CouponIndex].PIKInterestOnPMTDate = Pikpmt;
                    //servicing_amt

                    ServicingAmt = ServicingTransactionOverride("InterestPaid", coupon.Date);
                    if (ServicingAmt != 0)
                    {
                        coupon.ServicingOverrideTag = 1;
                    }
                    else if (CouponIndex > 2)
                    {
                        if (ListCouponTab[CouponIndex - 2].InterestAccrualPeriodEndDateTag != 1)
                        {
                            coupon.ServicingOverrideTag = ListCouponTab[CouponIndex - 1].ServicingOverrideTag.GetValueOrDefault(0);
                        }
                    }

                    if (coupon.ServicingOverrideTag != 1)
                    {
                        if (coupon.Date == SelectedMaturityDateLatest)
                        {
                            if (SelectedMaturityDateLatest <= accEndDate)
                            {
                                coupon.InterestPaidperServicing = coupon.InterestPaidonPaymentDate.GetValueOrDefault(0);
                                coupon.PMTDropDateInterestPaidperServicing = coupon.PMTDropDateInterestPaidonPaymentDate.GetValueOrDefault(0);
                            }
                            else
                            {
                                coupon.InterestPaidperServicing = coupon.InterestPaidonPaymentDate.GetValueOrDefault(0) + coupon.DailyAccruedInterest.GetValueOrDefault(0);
                                coupon.PMTDropDateInterestPaidperServicing = coupon.PMTDropDateInterestPaidonPaymentDate.GetValueOrDefault(0) + coupon.PMTDropDateDailyAccruedInterest.GetValueOrDefault(0);
                            }
                        }
                        else
                        {
                            coupon.InterestPaidperServicing = coupon.InterestPaidonPaymentDate.GetValueOrDefault(0);
                            coupon.PMTDropDateInterestPaidperServicing = coupon.PMTDropDateInterestPaidonPaymentDate.GetValueOrDefault(0);
                        }
                    }
                    else
                    {
                        coupon.InterestPaidperServicing = ServicingAmt;
                    }

                    if (coupon.Date == SelectedMaturityDateLatest.Value)
                    {
                        coupon.CoveredDelta = coupon.CoveredDelta.GetValueOrDefault(0) + coupon.InterestPaidDeltaforthePeriod.GetValueOrDefault(0);
                    }
                    ////' Drop date true-up check
                    if (coupon.InterestPaidonPaymentDate > 0 && CouponIndex > 1)
                    {
                        coupon.CoveredDelta = ListCouponTab[CouponIndex - 1].DeltaBalance.GetValueOrDefault(0);
                    }

                    //' Delta between 'Regular' Accrual & 'Drop Date' Accrual Methods:
                    coupon.InterestPaidDeltaforthePeriod = coupon.InterestPaidonPaymentDate.GetValueOrDefault(0) - coupon.PMTDropDateInterestPaidonPaymentDate.GetValueOrDefault(0) - coupon.CoveredDelta.GetValueOrDefault(0);

                    if (CouponIndex == 0)
                    {
                        coupon.DeltaBalance = coupon.InterestPaidonPaymentDate.GetValueOrDefault(0) - coupon.CoveredDelta.GetValueOrDefault(0); ;
                    }
                    else
                    {
                        coupon.DeltaBalance = ListCouponTab[CouponIndex - 1].DeltaBalance + coupon.InterestPaidDeltaforthePeriod.GetValueOrDefault(0);
                    }

                    if (CouponIndex > 0 && ListRateTab[CouponIndex - 1].AllInCouponRate.GetValueOrDefault(0) == 0)
                    {
                        coupon.InterestPaid = 0;
                    }
                    else
                    {
                        coupon.InterestPaid = coupon.PMTDropDateInterestPaidonPaymentDate.GetValueOrDefault(0) + coupon.CoveredDelta.GetValueOrDefault(0);
                    }

                    //Interest Paid / Servicing [with drop date]
                    if (coupon.ServicingOverrideTag != 1)
                    {
                        coupon.InterestPaidServicingWithDropDate = coupon.InterestPaid.GetValueOrDefault(0);
                    }
                    else
                    {
                        coupon.UnpaidInterest = coupon.InterestPaid.GetValueOrDefault(0) - ServicingAmt.GetValueOrDefault(0);
                        coupon.InterestPaidServicingWithDropDate = ServicingAmt.GetValueOrDefault(0);
                    }
                    //' Interest Suspense Account:
                    ActualDelta = GetServicingValue(CalculationEnums.ListInterestTransactions, coupon.Date);
                    if (coupon.ServicingOverrideTag == 1)
                    {
                        coupon.InterestSuspenseAccountActivityforthePeriod = coupon.InterestPaidperServicing.GetValueOrDefault(0) - coupon.InterestPaid.GetValueOrDefault(0);
                    }
                    if (CouponIndex == 0)
                    {
                        coupon.InterestSuspenseAccountBalance = coupon.InterestSuspenseAccountActivityforthePeriod.GetValueOrDefault(0);
                        coupon.InterestSuspenseAccountBalanceWithAdj = ActualDelta;
                    }
                    else
                    {
                        coupon.InterestSuspenseAccountBalance = ListCouponTab[CouponIndex - 1].InterestSuspenseAccountBalance.GetValueOrDefault(0) + coupon.InterestSuspenseAccountActivityforthePeriod.GetValueOrDefault(0);
                        coupon.InterestSuspenseAccountBalanceWithAdj = ListCouponTab[CouponIndex - 1].InterestSuspenseAccountBalanceWithAdj.GetValueOrDefault(0) + ActualDelta;
                    }
                }
                CouponIndex = CouponIndex + 1;
            }
        }
        private Tuple<decimal?, int> InterestCalcMethod(string value, int NumberofDaysinReferencedAccrualPeriod = 30)
        {
            decimal? InterestCalcMethodAdjustment30_360vsActual_360 = 1.0M;
            int DayCount = 360;
            switch (value)
            {
                case "30/360":
                    InterestCalcMethodAdjustment30_360vsActual_360 = 30 / NumberofDaysinReferencedAccrualPeriod;
                    DayCount = 360;
                    break;

                case "Actual/365":
                    InterestCalcMethodAdjustment30_360vsActual_360 = 1;
                    DayCount = 365;
                    break;

                default:
                    InterestCalcMethodAdjustment30_360vsActual_360 = 1;
                    DayCount = 360;
                    break;
            }
            return Tuple.Create(InterestCalcMethodAdjustment30_360vsActual_360, DayCount);
        }
        public void DailyInterestAccrualCalc(int listindex, int daycount, DateTime? currentdate, Decimal? PeriodBegBal, Decimal? PeriodBegBaldd)
        {
            string InterestAccrualRule = noteDC.InterestCalculationRuleForPaydownsText;
            DateTime? MaturityDate = SelectedMaturityDateLatest;
#pragma warning disable CS0219 // The variable 'pdid' is assigned but its value is never used
            int pdid = 0;
#pragma warning restore CS0219 // The variable 'pdid' is assigned but its value is never used
            Decimal PikAmount = 0;
            if (ListCouponTab[listindex].InterestAccrualPeriodEndDateTag == 1 && ReadBalnceValueAtIndex(listindex) != 1 && ReadBalnceValueAtIndex(listindex - 1) != 1 && ReadBalnceValueAtIndex(listindex - 2) != 1 && ReadBalnceValueAtIndex(listindex - 3) != 1)
            {
                PikAmount = ListPIKInterestTab[listindex].PIKInterestonBusinessAdjInterestAccrualEndDate.GetValueOrDefault(0);
            }
            else
            {
                PikAmount = 0;
            }

            if (currentdate > accEndDate)
            {
                ListCouponTab[listindex].DailyAccruedInterestbeforeStrippingRule = ListCouponTab[listindex - 1].DailyAccruedInterestbeforeStrippingRule;
                ListCouponTab[listindex].PMTDropDateDailyAccruedInterestbeforeStrippingRule = ListCouponTab[listindex - 1].PMTDropDateDailyAccruedInterestbeforeStrippingRule;
            }
            else
            {
                if (listindex > 0)
                {
                    if (ListBalanceTab[listindex - 1].AccrualPeriodEndDateTag == 1)
                    {
                        pdid = 0;
                    }
                    else
                    {
                        pdid = 1;
                    }
                }
                else
                {
                    pdid = 1;
                }

                //  Case "regular"
                Decimal balanceportion = ListBalanceTab[listindex].EndingBalance.GetValueOrDefault(0) - PikAmount + ListBalanceTab[listindex].AmortizationEndingBalanceAddon.GetValueOrDefault(0) + ListBalanceTab[listindex].NonAmortizationEndingBalanceAddon.GetValueOrDefault(0);

                ListCouponTab[listindex].DailyAccruedInterestbeforeStrippingRule = balanceportion * ListCouponTab[listindex].InterestCalcMethodAdjustment30_360vsActual_360.GetValueOrDefault(0) * ListRateTab[listindex].AllInCouponRate.GetValueOrDefault(0) / daycount
                     - ListCouponTab[listindex].CouponbasedonFutureFunding.GetValueOrDefault(0);

                ListCouponTab[listindex].DailyAccruedCouponStripping = balanceportion * ListCouponTab[listindex].InterestCalcMethodAdjustment30_360vsActual_360.GetValueOrDefault(0) *
                          ListRateTab[listindex].CouponStrip.GetValueOrDefault(0) / daycount;

                // Case "datedrop"
                Decimal balanceportiondatedrop = ListBalanceTab[listindex].EndingBalanceUsingPMTDropDate.GetValueOrDefault(0) - PikAmount + ListBalanceTab[listindex].AmortizationEndingBalanceAddonPMTDropDate.GetValueOrDefault(0) + ListBalanceTab[listindex].NonAmortizationEndingBalanceAddonPMTDropDate.GetValueOrDefault(0);

                ListCouponTab[listindex].PMTDropDateDailyAccruedInterestbeforeStrippingRule = balanceportiondatedrop * ListCouponTab[listindex].InterestCalcMethodAdjustment30_360vsActual_360
                                                                                              * ListRateTab[listindex].AllInCouponRate.GetValueOrDefault(0) / daycount
                                                                                               - ListCouponTab[listindex].CouponbasedonFutureFunding.GetValueOrDefault(0);

                ListCouponTab[listindex].PMTDropDateDailyAccruedCouponStripping = balanceportiondatedrop * ListCouponTab[listindex].InterestCalcMethodAdjustment30_360vsActual_360.GetValueOrDefault(0) *
                        ListRateTab[listindex].CouponStrip.GetValueOrDefault(0) / daycount;
            }
            if (currentdate > accEndDate)
            {
                ListCouponTab[listindex].DailyAccruedInterest = 0;
                ListCouponTab[listindex].PMTDropDateDailyAccruedInterest = 0;
            }
            else
            {
                ListCouponTab[listindex].DailyAccruedInterest = ListCouponTab[listindex].DailyAccruedInterestbeforeStrippingRule.GetValueOrDefault(0) - ListCouponTab[listindex].DailyAccruedCouponStripping.GetValueOrDefault(0);
                ListCouponTab[listindex].PMTDropDateDailyAccruedInterest = ListCouponTab[listindex].PMTDropDateDailyAccruedInterestbeforeStrippingRule.GetValueOrDefault(0) - ListCouponTab[listindex].PMTDropDateDailyAccruedCouponStripping.GetValueOrDefault(0);
            }
        }
        public int? ReadBalnceValueAtIndex(int listindex)
        {
            int? value = 0;
            if (listindex < 0)
            {
                value = 0;
            }
            else
            {
                value = ListBalanceTab[listindex].PMTDateTag.GetValueOrDefault(0);
            }
            return value;
        }
        public void InterestForThePeriod(int listindex, DateTime InitialAccendDateCalculated, Decimal? StubInterestAmount, Decimal? stubintff)
        {
            Decimal? temp1, temp2, temp1drop;
            if (ListCouponTab[listindex].InterestAccrualPeriodEndDateTag == 1 && listindex > 0)
            {
                temp1 = ListCouponTab[listindex].DailyAccruedInterest.GetValueOrDefault(0) +
                    ListCouponTab[listindex - 1].AccumInterestforCurrentAccrualPeriod.GetValueOrDefault(0);

                temp1drop = ListCouponTab[listindex].PMTDropDateDailyAccruedInterest.GetValueOrDefault(0) +
                 ListCouponTab[listindex - 1].PMTDropDateAccumInterestforCurrentAccrualPeriod.GetValueOrDefault(0);
            }
            else
            { temp1 = 0; temp1drop = 0; }
            if (ListCouponTab[listindex].Date == InitialAccendDateCalculated)
            {
                temp2 = StubInterestAmount;
            }
            else
            {
                temp2 = 0;
            }

            if (ListCouponTab[listindex].Date == noteDC.InitialInterestAccrualEndDate && noteDC.LoanPurchaseYNText == "Y")
            {
                ListCouponTab[listindex].InterestforthePeriod = initialFullMoInt;
                ListCouponTab[listindex].PMTDropDateInterestforthePeriod = initialFullMoInt;
            }
            else if (ListCouponTab[listindex].Date == stubEndDate && noteDC.StubPaidinAdvanceYNText == "Y")
            {
                ListCouponTab[listindex].InterestforthePeriod = 0;
                ListCouponTab[listindex].PMTDropDateInterestforthePeriod = 0;
            }

            else if (ListCouponTab[listindex].Date == SelectedMaturityDateLatest)
            {
                var finalperinterest = CalculateFinalPeriodInterest(listindex, noteDC.InterestCalculationRuleForPaydownsText);
                ListCouponTab[listindex].InterestforthePeriod = finalperinterest.Item1;
                ListCouponTab[listindex].PMTDropDateInterestforthePeriod = finalperinterest.Item2;
            }
            else
            {
                ListCouponTab[listindex].InterestforthePeriod = temp1 - ListCouponTab[listindex].InterestforthePeriodShortfall.GetValueOrDefault(0) + stubintff;
                ListCouponTab[listindex].PMTDropDateInterestforthePeriod = temp1drop - ListCouponTab[listindex].InterestforthePeriodShortfall.GetValueOrDefault(0) + stubintff;
            }
        }
        public Tuple<decimal?, decimal?> CalculateFinalPeriodInterest(int listindex, string InterestCalculationRuleForPaydownsText)
        {
            Tuple<Decimal?, Decimal?> finalperiodInterest;
            decimal? InterestforthePeriod = 0, PMTDropDateInterestforthePeriod = 0;

            if (InterestCalculationRuleForPaydownsText == "Full Period Accrual")
            {
                var matIndex = ListDatesTab.IndexOf((from tb in ListDatesTab
                                                     where Convert.ToDateTime(tb.PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay) == Convert.ToDateTime(SelectedMaturityDateLatest)
                                                     orderby tb.InterestAccrualPeriodEndDateArray
                                                     select tb).First());

                TimeSpan datediff = (Convert.ToDateTime(ListDatesTab[matIndex].InterestAccrualPeriodEndDateArray) - Convert.ToDateTime(ListDatesTab[matIndex].PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay));
                int days = Convert.ToInt32(datediff.TotalDays) + 1;
                if (days != 0)
                {
                    InterestforthePeriod = ListCouponTab[listindex - 1].AccumInterestforCurrentAccrualPeriod + ListCouponTab[listindex].DailyAccruedInterest * days;
                    PMTDropDateInterestforthePeriod = ListCouponTab[listindex - 1].AccumInterestforCurrentAccrualPeriod + ListCouponTab[listindex].PMTDropDateDailyAccruedInterest * days;
                }
                else
                {
                    InterestforthePeriod = ListCouponTab[listindex - 1].AccumInterestforCurrentAccrualPeriod + ListCouponTab[listindex].DailyAccruedInterest;
                    PMTDropDateInterestforthePeriod = ListCouponTab[listindex - 1].AccumInterestforCurrentAccrualPeriod + ListCouponTab[listindex].PMTDropDateDailyAccruedInterest;
                }
            }
            else if (InterestCalculationRuleForPaydownsText == "Exclude Prepayment Date")
            {
                //if (ListCouponTab[listindex - 1].InterestAccrualPeriodEndDateTag == 1)
                //{
                //    ListCouponTab[listindex].InterestforthePeriod = ListCouponTab[listindex - 2].AccumInterestforCurrentAccrualPeriod + ListCouponTab[listindex-1].DailyAccruedInterest; ;
                //    ListCouponTab[listindex].PMTDropDateInterestforthePeriod = ListCouponTab[listindex - 2].AccumInterestforCurrentAccrualPeriod + ListCouponTab[listindex-1].DailyAccruedInterest;
                //}
                //else
                {
                    InterestforthePeriod = ListCouponTab[listindex - 1].AccumInterestforCurrentAccrualPeriod;
                    PMTDropDateInterestforthePeriod = ListCouponTab[listindex - 1].AccumInterestforCurrentAccrualPeriod;
                }
            }

            else if (InterestCalculationRuleForPaydownsText == "Include Prepayment Date")
            {
                //if (ListCouponTab[listindex - 1].InterestAccrualPeriodEndDateTag == 1)
                //{
                //    ListCouponTab[listindex].InterestforthePeriod = ListCouponTab[listindex - 2].AccumInterestforCurrentAccrualPeriod  +ListCouponTab[listindex - 1].DailyAccruedInterest *3;
                //    ListCouponTab[listindex].PMTDropDateInterestforthePeriod = ListCouponTab[listindex - 2].AccumInterestforCurrentAccrualPeriod + ListCouponTab[listindex - 1].DailyAccruedInterest * 3; 
                //}
                //else
                {
                    InterestforthePeriod = ListCouponTab[listindex - 1].AccumInterestforCurrentAccrualPeriod + ListCouponTab[listindex].DailyAccruedInterest;
                    PMTDropDateInterestforthePeriod = ListCouponTab[listindex - 1].AccumInterestforCurrentAccrualPeriod + ListCouponTab[listindex].DailyAccruedInterest;

                }
            }
            finalperiodInterest = Tuple.Create(InterestforthePeriod, PMTDropDateInterestforthePeriod);
            return finalperiodInterest;
        }
        public Tuple<Decimal?, Decimal?> CalcInterestOnFinalPaymentDate(int CouponIndex, string InterestCalculationRuleForPaydownsText)
        {
            Tuple<Decimal?, Decimal?> finalperInterestpmtdate;
            decimal? InterestPaidonPaymentDate = 0, PMTDropDateInterestPaidonPaymentDate = 0;

            var finalperinterest = CalculateFinalPeriodInterest(CouponIndex, InterestCalculationRuleForPaydownsText);
            decimal? InterestforthePeriod = finalperinterest.Item1;
            decimal? PMTDropDateInterestforthePeriod = finalperinterest.Item2;

            if (InterestCalculationRuleForPaydownsText == "Full Period Accrual")
            {
                if (ListCouponTab[CouponIndex - 1].InterestAccrualPeriodEndDateTag == 1)
                {
                    InterestPaidonPaymentDate = ListCouponTab[CouponIndex - 1].InterestforthePeriod;
                    PMTDropDateInterestPaidonPaymentDate = ListCouponTab[CouponIndex - 1].InterestforthePeriod;
                }

                else
                {
                    InterestPaidonPaymentDate = InterestforthePeriod;
                    PMTDropDateInterestPaidonPaymentDate = PMTDropDateInterestforthePeriod;
                }
            }




            else if (InterestCalculationRuleForPaydownsText == "Exclude Prepayment Date" && SelectedMaturityDateLatest > noteDC.FirstPaymentDate)
                if (ListCouponTab[CouponIndex - 1].InterestAccrualPeriodEndDateTag == 1)
                {

                    if (SelectedMaturityDateLatest > noteDC.FirstPaymentDate)
                    {
                        InterestPaidonPaymentDate = ListCouponTab[CouponIndex - 1].InterestforthePeriod;
                        PMTDropDateInterestPaidonPaymentDate = ListCouponTab[CouponIndex - 1].InterestforthePeriod;
                    }

                    if (SelectedMaturityDateLatest < noteDC.FirstPaymentDate)
                    {
                        InterestPaidonPaymentDate = 0;
                        PMTDropDateInterestPaidonPaymentDate = 0;
                    }
                }
                else

                {

                    //InterestPaidonPaymentDate = Math.Max(0, Convert.ToDecimal(intpmt * (1 - ListBalanceTab[CouponIndex].DebtServiceShortfall.GetValueOrDefault(0)))) + stubintff;
                    //PMTDropDateInterestPaidonPaymentDate = Math.Max(0, Convert.ToDecimal(IntpmtDrop * (1 - ListBalanceTab[CouponIndex].DebtServiceShortfall.GetValueOrDefault(0)))) + stubintff;

                    InterestPaidonPaymentDate = InterestforthePeriod;
                    PMTDropDateInterestPaidonPaymentDate = PMTDropDateInterestforthePeriod;
                }

            else if (InterestCalculationRuleForPaydownsText == "Include Prepayment Date")

                if (ListCouponTab[CouponIndex - 1].InterestAccrualPeriodEndDateTag == 1)

                {
                    var pmtDateTag = (from tb in ListDatesTab
                                      where tb.PaymentDateusingAccrualFreqNotAdjustedforBusinessDay == ListCouponTab[CouponIndex].Date
                                      select tb.PaymentDateRelativetoAccrualEndDateTag).First();


                    if (pmtDateTag == 1)
                    {
                        PMTDropDateInterestPaidonPaymentDate = ListCouponTab[CouponIndex - 1].InterestforthePeriod + ListCouponTab[CouponIndex - 1].DailyAccruedInterest;
                        InterestPaidonPaymentDate = ListCouponTab[CouponIndex - 1].InterestforthePeriod + ListCouponTab[CouponIndex - 1].DailyAccruedInterest;
                    }
                    else


                    {
                        InterestPaidonPaymentDate = InterestforthePeriod;
                        PMTDropDateInterestPaidonPaymentDate = InterestforthePeriod;

                    }


                }


                else
                {
                    InterestPaidonPaymentDate = InterestforthePeriod;
                    PMTDropDateInterestPaidonPaymentDate = PMTDropDateInterestforthePeriod;
                }

            finalperInterestpmtdate = Tuple.Create(InterestPaidonPaymentDate, PMTDropDateInterestPaidonPaymentDate);
            return finalperInterestpmtdate;
        }
        public void UpdateDailyAccInterestWithDropDate(DateTime effectivedate)
        {

            int ndx = 0, effndx = 0, dtndx = 0, cpnndx = 0, accrstart = 0, accrend = 0;
            int numdays = 0;
#pragma warning disable CS0219 // The variable 'cumcpndrop' is assigned but its value is never used
            decimal? adjamount = 0, cumcpndrop = 0;
#pragma warning restore CS0219 // The variable 'cumcpndrop' is assigned but its value is never used
            effndx = Math.Max(effectivedate == noteDC.ClosingDate ? 1 : ListDatesTab.FindIndex(dt => effectivedate >= dt.InterestAccrualPeriodStartDateArray && effectivedate <= dt.InterestAccrualPeriodEndDateArray), 1);
            dtndx = effndx - 1;

            foreach (DatesTab cfdate in ListDatesTab.Skip(effndx))
            {
                if (cfdate.PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay.Value.Date <= SelectedMaturityDateLatest.Value.Date)
                {
                    cpnndx = ListCouponTab.FindIndex(cpn => cpn.Date == ListDatesTab[dtndx].PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay);
                    if (cpnndx >= 0)
                    {
                        numdays = cfdate.NumberofDaysintheAccrualPeriod.GetValueOrDefault(0);
                        if (SelectedMaturityDateLatest.Value.Date <= cfdate.InterestAccrualPeriodEndDateArray.Value.Date)
                            numdays = ((TimeSpan)(SelectedMaturityDateLatest - cfdate.InterestAccrualPeriodStartDateArray)).Days;
                        accrstart = ListCouponTab.FindIndex(cpn => cpn.Date == cfdate.InterestAccrualPeriodStartDateArray);
                        accrend = ListCouponTab.FindIndex(cpn => cpn.Date == cfdate.InterestAccrualPeriodEndDateArray);
                        if (ListRateTab[accrstart].AllInCouponRate > 0)
                            adjamount = NumericExtensions.SafeDivision(ListCouponTab[cpnndx].DeltaBalance.GetValueOrDefault(0), Convert.ToDecimal(numdays));
                        else
                            adjamount = 0;
                        if (accrstart >= 0 && accrend >= 0 && adjamount > 0)
                        {
                            for (ndx = accrstart; ndx <= accrend; ndx++)
                            {
                                if (ListCouponTab[ndx].Date >= effectivedate)
                                {
                                    ListCouponTab[ndx].PMTDropDateDailyAccruedInterestAddOn = adjamount;
                                    ListCouponTab[ndx].PMTDropDateAccumInterestforCurrentAccrualPeriodAddOn =
                                        ListCouponTab[ndx - 1].PMTDropDateAccumInterestforCurrentAccrualPeriodAddOn + adjamount;
                                }
                            }
                            ListCouponTab[accrend].PMTDropDateAccumInterestforCurrentAccrualPeriodAddOn = 0;
                        }
                    }
                }
                else
                {
                    break;
                }

                dtndx++;
            }
        }

        #endregion Coupon

        #region Fees
        public void PopulateLoanFeeSchedules()
        {
            string feetype = "";
            // Add Stripped Fees from Source Notes to this Note's Fee Schedule
            if (noteDC.ListFeeCouponStripReceivable != null && noteDC.ListFeeCouponStripReceivable.Count > 0)
                SetIncludeLYFlagforFeeStripsFromSourceNotes();

            if (noteDC.NotePrepayAndAdditionalFeeScheduleList != null)
            {
                foreach (PrepayAndAdditionalFeeScheduleDataContract prePay in noteDC.NotePrepayAndAdditionalFeeScheduleList)
                {
                    feetype = prePay.ValueTypeText;
                    foreach (FeeSchedulesConfigDataContract feeschedule in noteDC.ListFeeSchedulesConfiguration)
                    {
                        if (feeschedule.FeeTypeNameText == feetype)
                        {
                            var FeePaymentFrequencyText = CheckAndConvertToLower(feeschedule.FeePaymentFrequencyText);
                            var FeeCoveragePeriodText = CheckAndConvertToLower(feeschedule.FeeCoveragePeriodText);
                            if (CheckAndConvertToLower(feeschedule.FeeFunctionText) != "default")
                            {
                                LogDataToFeeSchedule("Custom Function Fee", prePay, feeschedule);
                            }
                            else if (FeePaymentFrequencyText == "payment period")
                            {
                                LogDataToFeeSchedule("Payment Date Based Fee", prePay, feeschedule);
                            }
                            else if (FeeCoveragePeriodText == "date specific")
                            {
                                LogDataToFeeSchedule("Date Specific Fee", prePay, feeschedule);
                            }
                            else if (FeePaymentFrequencyText == "transaction based" && FeeCoveragePeriodText == "open period")
                            {
                                LogDataToFeeSchedule("Transaction Based Fee", prePay, feeschedule);
                            }
                        }
                    }
                }
            }
        }
        private void SetIncludeLYFlagforFeeStripsFromSourceNotes()
        {
            PrepayAndAdditionalFeeScheduleDataContract feesch, newfeesch;
            List<PrepayAndAdditionalFeeScheduleDataContract> ListFeeSchedule = new List<PrepayAndAdditionalFeeScheduleDataContract>();

            if (noteDC.ListFeeCouponStripReceivable != null && noteDC.ListFeeCouponStripReceivable.Count > 0)
            {
                foreach (FeeCouponStripReceivableTab rcvbl in noteDC.ListFeeCouponStripReceivable)
                {
                    feesch = null;
                    newfeesch = new PrepayAndAdditionalFeeScheduleDataContract();
                    //Check to see if a Fee with the same Name and Type exists in the Target Note Fee Schedule
                    if (noteDC.NotePrepayAndAdditionalFeeScheduleList != null && noteDC.NotePrepayAndAdditionalFeeScheduleList.Count > 0)
                    {
                        //Locate the same fee type and check attributes - Match using Fee Name
                        ListFeeSchedule = noteDC.NotePrepayAndAdditionalFeeScheduleList.Where(fee => fee.ValueTypeText == rcvbl.TransactionName).ToList();
                        if (ListFeeSchedule != null && ListFeeSchedule.Count > 0)
                        {
                            if (ListFeeSchedule.Count > 1)
                            {
                                feesch = (from ff in ListFeeSchedule
                                          where ff.ScheduleStartDate == rcvbl.Date
                                          select ff).FirstOrDefault();
                                if (feesch != null)
                                    rcvbl.InclInLevelYield = feesch.IncludedLevelYield;
                                else
                                    rcvbl.InclInLevelYield = ListFeeSchedule[0].IncludedLevelYield;
                            }
                            else
                                rcvbl.InclInLevelYield = ListFeeSchedule[0].IncludedLevelYield;
                        }
                        else
                        {
                            rcvbl.InclInLevelYield = 0;
                        }
                    }
                }
            }
        }
        public Tuple<Decimal?, Decimal?> CalculateFeeAmount(string feeType, DateTime? period, int listindex, DateTime effectivedate)
        {
            decimal? feeAmount = 0;
            decimal? baseAmount = 0;
            decimal? feeAmountStrip = 0;
            decimal? feeAmountly = 0;
            decimal? feeamounttotal = 0;
            decimal? feeAmountlyTotal = 0;
            Tuple<Decimal?, Decimal?> fee;

            int paymentindex = 0;
            int datespecificindex = 0;
            int transindex = 0;
            switch (feeType)
            {
                case "Payment Date Based Fee":

                    foreach (CustomFeeScheduleDataContract pd in LatestPaymentDateFees)
                    {
                        feeAmountly = 0;
                        if (period.Value.Date >= pd.ScheduleStartDate.Value.Date && pd.ScheduleEndDate.Value.Date >= period.Value.Date && pd.EffectiveDate.Value.Date <= effectivedate)
                        {
                            //if (effectivedate != noteDC.ClosingDate)
                            //{
                            //    FeeCheckPriorEffectiveDate(pd.FeeName, effectivedate);
                            //}
                            if (pd.FeeAmountOverride != 0)
                            {
                                feeAmount = pd.FeeAmountOverride;
                            }
                            else if (pd.BaseAmountOverride != 0)
                            {
                                feeAmount = pd.Value * pd.BaseAmountOverride;
                            }
                            else
                            {
                                baseAmount = CalculateBaseAmount("Payment Date Based Fee", listindex, paymentindex);
                                feeAmount = baseAmount.GetValueOrDefault(0) * pd.Value;
                            }
                            feeAmountStrip = feeAmount * pd.PercentageOfFeeToBeStripped;
                            feeAmountly = (feeAmount - feeAmountStrip) * pd.IncludedLevelYield;
                            feeAmountlyTotal = feeAmountlyTotal.GetValueOrDefault(0) + feeAmountly.GetValueOrDefault(0);
                            feeamounttotal = feeamounttotal.GetValueOrDefault(0) + feeAmount;

                            FeeOutputDataContract fd = new FeeOutputDataContract();
                            fd.FeeAmountStripped = feeAmountStrip;
                            fd.FeeAmount = (1 - pd.IncludedLevelYield) * feeAmount;
                            fd.Date = period;
                            fd.FeeAmountinclinLY = feeAmountly;
                            fd.FeeName = pd.FeeName;
                            fd.FeeType = pd.ValueTypeText;
                            fd.FeeNameTransText = pd.FeeNameTransText;
                            fd.EffectiveDate = effectivedate;
                            fd.FeeCouponReceivable = 0;
                            InsertUpdateFeeOutput(fd);
                            //ListFeeOutput.Add(fd);
                        }
                        paymentindex = paymentindex + 1;
                    }
                    break;

                case "Date Specific Fee":
                    // Trigger: Date = Start Date from fee schedule
                    foreach (CustomFeeScheduleDataContract dsf in LatestDateSpecificFees)
                    {
                        if (dsf.ScheduleStartDate.Value.Date == period.Value.Date)
                        {
                            //if (effectivedate != noteDC.ClosingDate)
                            //{
                            //    FeeCheckPriorEffectiveDate(dsf.FeeName, effectivedate);
                            //}
                            if (dsf.FeeNameTransText == "Extension Fee" && period == SelectedMaturityDateLatest.Value.Date)
                            {
                                //do nothing : Extension fees is not allowed to generate at maturity 
                            }
                            else
                            {
                                if (dsf.FeeAmountOverride != 0)
                                {
                                    feeAmount = dsf.FeeAmountOverride;
                                }
                                else if (dsf.BaseAmountOverride != 0)
                                {
                                    feeAmount = dsf.Value * dsf.BaseAmountOverride;
                                }
                                else
                                {
                                    if (period.Value.Date == noteDC.ClosingDate.Value.Date)
                                    {
                                        baseAmount = CalculateInitialFundingAmount("Date Specific Fee", datespecificindex);
                                    }
                                    baseAmount = baseAmount.GetValueOrDefault(0) + CalculateBaseAmount("Date Specific Fee", listindex, datespecificindex);

                                    feeAmount = baseAmount.GetValueOrDefault(0) * dsf.Value;
                                }
                                feeAmountStrip = feeAmount * dsf.PercentageOfFeeToBeStripped;
                                feeAmountly = (feeAmount - feeAmountStrip) * dsf.IncludedLevelYield;
                                feeAmountlyTotal = feeAmountlyTotal.GetValueOrDefault(0) + feeAmountly.GetValueOrDefault(0);
                                feeamounttotal = feeamounttotal.GetValueOrDefault(0) + feeAmount;

                                FeeOutputDataContract fd = new FeeOutputDataContract();
                                fd.FeeAmountStripped = feeAmountStrip;
                                fd.Date = period;
                                fd.FeeAmount = (1 - dsf.IncludedLevelYield) * feeAmount;
                                fd.FeeAmountinclinLY = feeAmountly;
                                fd.FeeName = dsf.FeeName;
                                fd.FeeType = dsf.ValueTypeText;
                                fd.FeeNameTransText = dsf.FeeNameTransText;
                                fd.EffectiveDate = effectivedate;
                                fd.FeeCouponReceivable = 0;
                                InsertUpdateFeeOutput(fd);
                                baseAmount = 0;
                            }

                        }

                        datespecificindex = datespecificindex + 1;
                    }
                    break;

                case "Transaction Based Fee":
                    //Trigger: Specific transaction occurs
                    foreach (CustomFeeScheduleDataContract tbf in LatestTransactionBasedFees)
                    {
                        baseAmount = 0;
                        if (tbf.ScheduleStartDate.Value.Date <= period.Value.Date && period.Value.Date <= tbf.ScheduleEndDate.Value.Date)
                        {

                            if (period.Value.Date == noteDC.ClosingDate.Value.Date)
                            {
                                baseAmount = CalculateInitialFundingAmount("Transaction Based Fee", transindex);
                            }

                            baseAmount = baseAmount.GetValueOrDefault(0) + CalculateBaseAmount("Transaction Based Fee", listindex, transindex);
                            if (baseAmount != 0)
                            {
                                //if (effectivedate != noteDC.ClosingDate)
                                //{
                                //    FeeCheckPriorEffectiveDate(tbf.FeeName, effectivedate);
                                //}

                                if (tbf.FeeAmountOverride != 0)
                                {
                                    feeAmount = tbf.FeeAmountOverride.GetValueOrDefault(0);
                                }
                                else if (tbf.BaseAmountOverride != 0 && CheckAndConvertToLower(tbf.ApplyTrueUpFeatureText) == "yes")
                                {
                                    if (period.Value.Date == SelectedMaturityDateLatest.Value.Date)
                                    {
                                        feeAmount = baseAmount * tbf.Value;
                                        decimal? cumpriorpaydown = 0;
                                        cumpriorpaydown = CalcPriorPaydowns(noteDC.ClosingDate.GetValueOrDefault(), tbf.ScheduleEndDate);
                                        feeAmount = feeAmount + (tbf.BaseAmountOverride + cumpriorpaydown - ListBalanceTab[listindex].BalloonPayment.GetValueOrDefault(0)) * tbf.Value;
                                    }
                                    else
                                    {
                                        feeAmount = baseAmount * tbf.Value;
                                    }
                                }
                                else if (tbf.BaseAmountOverride != 0 && CheckAndConvertToLower(tbf.ApplyTrueUpFeatureText) != "yes")
                                {
                                    feeAmount = tbf.BaseAmountOverride * tbf.Value.GetValueOrDefault(0);
                                }
                                else
                                {
                                    feeAmount = baseAmount * tbf.Value.GetValueOrDefault(0);
                                }
                                feeAmountStrip = feeAmount * tbf.PercentageOfFeeToBeStripped;
                                feeAmountly = (feeAmount - feeAmountStrip) * tbf.IncludedLevelYield;
                                feeAmountlyTotal = feeAmountlyTotal.GetValueOrDefault(0) + feeAmountly.GetValueOrDefault(0);
                                feeamounttotal = feeamounttotal.GetValueOrDefault(0) + feeAmount;
                                FeeOutputDataContract fd = new FeeOutputDataContract();
                                fd.FeeAmountStripped = feeAmountStrip;
                                fd.FeeAmount = (1 - tbf.IncludedLevelYield) * feeAmount;
                                fd.Date = period;
                                fd.FeeAmountinclinLY = feeAmountly;
                                fd.FeeName = tbf.FeeName;
                                fd.FeeType = tbf.ValueTypeText;
                                fd.FeeNameTransText = tbf.FeeNameTransText;
                                fd.EffectiveDate = effectivedate;
                                fd.FeeCouponReceivable = 0;
                                InsertUpdateFeeOutput(fd);
                                //ListFeeOutput.Add(fd);
                            }
                        }

                        transindex = transindex + 1;
                    }
                    break;
            }
            fee = Tuple.Create(feeamounttotal, feeAmountlyTotal);
            return fee;
        }

        public void FeeCheckPriorEffectiveDate(string feename, DateTime effectiveDate)
        {
            foreach (FeeOutputDataContract fdc in ListFeeOutput)
            {
                if (fdc.FeeName == feename && fdc.Date >= effectiveDate && fdc.EffectiveDate < effectiveDate)
                {
                    fdc.FeeAmount = 0;
                    fdc.FeeAmountinclinLY = 0;
                    fdc.FeeAmountStripped = 0;
                }
            }
        }

        public decimal? CalcFeePaidUptoDate(string feename, DateTime? period)
        {
            decimal? cumFeeAmt = 0;
            cumFeeAmt = ListFeeOutput.Where(x => x.Date <= period.Value.Date && x.FeeName == feename).Sum(y => y.FeeAmount);
            return cumFeeAmt;
        }

        public decimal? CalcPriorPaydowns(DateTime? startdate, DateTime? enddate)
        {
            decimal? cumPriorPaydowns = 0;
            foreach (BalanceTab bal in ListBalanceTab)
            {
                if (bal.DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0) != 0)
                {
                    if (bal.Date >= startdate && bal.Date <= enddate)
                    {
                        cumPriorPaydowns = cumPriorPaydowns + bal.DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0);
                    }
                }
            }
            return cumPriorPaydowns;
        }
        public Decimal? CalculateBaseAmount(string feeType, int listindex, int feesindex)
        {
            Decimal? baseAmount = 0;
            switch (feeType)
            {
                case "Payment Date Based Fee":
                    baseAmount = LatestPaymentDateFees[feesindex].TotalCommitment * noteDC.TotalCommitment.GetValueOrDefault(0)
                        - LatestPaymentDateFees[feesindex].UnscheduledPaydowns * ListBalanceTab[listindex].DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0)
                        + LatestPaymentDateFees[feesindex].BalloonPayment * ListBalanceTab[listindex].BalloonPayment.GetValueOrDefault(0)
                        + LatestPaymentDateFees[feesindex].LoanFundings * ListBalanceTab[listindex].FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0)
                        + LatestPaymentDateFees[feesindex].ScheduledPrincipalAmortizationPayment * ListBalanceTab[listindex].PrincipalReceivedperServicing.GetValueOrDefault(0)
                        + LatestPaymentDateFees[feesindex].CurrentLoanBalance * ListBalanceTab[listindex].EndingBalance.GetValueOrDefault(0)
                        + LatestPaymentDateFees[feesindex].InterestPayment * ListBalanceTab[listindex].PrincipalShortfall.GetValueOrDefault(0)
                        + LatestPaymentDateFees[feesindex].AdjustedCommitment * GetAdjustedCommitmentByDate(ListFeesTab[listindex].Date);


                    break;

                case "Date Specific Fee":

                    baseAmount = LatestDateSpecificFees[feesindex].TotalCommitment * noteDC.TotalCommitment.GetValueOrDefault(0)
                       - LatestDateSpecificFees[feesindex].UnscheduledPaydowns * ListBalanceTab[listindex].DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0)
                       + LatestDateSpecificFees[feesindex].BalloonPayment * ListBalanceTab[listindex].BalloonPayment.GetValueOrDefault(0)
                       + LatestDateSpecificFees[feesindex].LoanFundings * ListBalanceTab[listindex].FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0)
                       + LatestDateSpecificFees[feesindex].ScheduledPrincipalAmortizationPayment * ListBalanceTab[listindex].PrincipalReceivedperServicing.GetValueOrDefault(0)
                       + LatestDateSpecificFees[feesindex].CurrentLoanBalance * ListBalanceTab[listindex].EndingBalance.GetValueOrDefault(0)
                       + LatestDateSpecificFees[feesindex].InterestPayment * ListBalanceTab[listindex].PrincipalShortfall.GetValueOrDefault(0)
                       + LatestDateSpecificFees[feesindex].AdjustedCommitment * GetAdjustedCommitmentByDate(ListFeesTab[listindex].Date);


                    break;

                case "Transaction Based Fee":
                    baseAmount = LatestTransactionBasedFees[feesindex].TotalCommitment * noteDC.TotalCommitment.GetValueOrDefault(0)
                      - LatestTransactionBasedFees[feesindex].UnscheduledPaydowns * ListBalanceTab[listindex].DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0)
                      + LatestTransactionBasedFees[feesindex].BalloonPayment * ListBalanceTab[listindex].BalloonPayment.GetValueOrDefault(0)
                      + LatestTransactionBasedFees[feesindex].LoanFundings * ListBalanceTab[listindex].FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0)
                      + LatestTransactionBasedFees[feesindex].ScheduledPrincipalAmortizationPayment * ListBalanceTab[listindex].PrincipalReceivedperServicing.GetValueOrDefault(0)
                      + LatestTransactionBasedFees[feesindex].CurrentLoanBalance * ListBalanceTab[listindex].EndingBalance.GetValueOrDefault(0)
                      + LatestTransactionBasedFees[feesindex].InterestPayment * ListBalanceTab[listindex].PrincipalShortfall.GetValueOrDefault(0)
                      + LatestTransactionBasedFees[feesindex].AdjustedCommitment * GetAdjustedCommitmentByDate(ListFeesTab[listindex].Date);

                    break;
            }
            return baseAmount;
        }

        public Decimal? CalculateInitialFundingAmount(string feeType, int feesindex)
        {
            Decimal? InitialFundingAmount = 0;
            switch (feeType)
            {
                case "Payment Date Based Fee":
                    InitialFundingAmount = LatestPaymentDateFees[feesindex].InitialFunding * noteDC.InitialFundingAmount.GetValueOrDefault(0);

                    break;

                case "Date Specific Fee":
                    InitialFundingAmount = LatestDateSpecificFees[feesindex].InitialFunding * noteDC.InitialFundingAmount.GetValueOrDefault(0);
                    break;

                case "Transaction Based Fee":
                    InitialFundingAmount = LatestTransactionBasedFees[feesindex].InitialFunding * noteDC.InitialFundingAmount.GetValueOrDefault(0);
                    break;
            }
            return InitialFundingAmount;
        }

        public void LogDataToFeeSchedule(string feeType, PrepayAndAdditionalFeeScheduleDataContract prepay, FeeSchedulesConfigDataContract feeschedule)
        {
            CustomFeeScheduleDataContract csd = new CustomFeeScheduleDataContract();
            switch (feeType)
            {
                case "Custom Function Fee":
                    csd = ConvertToCustomEntity(prepay, feeschedule);
                    CustomFunctionFees.Add(csd);

                    break;

                case "Payment Date Based Fee":
                    csd = ConvertToCustomEntity(prepay, feeschedule);
                    PaymentDateFees.Add(csd);
                    break;

                case "Date Specific Fee":
                    csd = ConvertToCustomEntity(prepay, feeschedule);
                    DateSpecificFees.Add(csd);
                    break;

                case "Transaction Based Fee":
                    csd = ConvertToCustomEntity(prepay, feeschedule);
                    TransactionBasedFees.Add(csd);
                    break;
            }
        }

        public void CalculateCustomFee(DateTime period, int feeindex)
        {
            decimal? ufThreshold = 0, accrualAmount = 0;
            decimal? TotalCommitment = noteDC.TotalCommitment;
            string functionName = "";
            foreach (CustomFeeScheduleDataContract cff in CustomFunctionFees)
            {
                if (cff.FeeName != "")
                {
                    functionName = cff.FeeFunction;
                    foreach (FeeFunctionsConfigDataContract ffc in noteDC.ListFeeFunctions)
                    {
                        if (ffc.FunctionNameText == functionName)
                        {
                            if (ffc.FunctionTypeText == "Fee on Unfunded Commitment")
                            {
                                if (cff.BaseAmountOverride != 0)
                                {
                                    ufThreshold = cff.BaseAmountOverride;
                                }
                                else
                                {
                                    ufThreshold = TotalCommitment;
                                }
                            }
                            accrualAmount = CalculateUnusedFeeAccrual(ffc, ListBalanceTab[feeindex].EndingBalance, cff, period, ufThreshold);

                            if (accrualAmount != 0)
                            {
                                DailyAccrualCustomFeeDataContract dac = new DailyAccrualCustomFeeDataContract();
                                dac.FeeName = cff.FeeName;
                                dac.AccrualDate = period;
                                dac.AccrualAmount = accrualAmount;
                                DailyAccrualCustomFee.Add(dac);
                            }
                        }
                    }
                }
                else
                {
                    break;
                }
            }
        }

        public void CalculateCustomFeeAmountPayable(DateTime effectiveDate)
        {
            string functionname = "";
            int payFrequncy = 0;
            string paymentFrequency = "";
            int dateindex = 1;
            decimal? feePayable = 0;
            foreach (CustomFeeScheduleDataContract cff in CustomFunctionFees)
            {
                functionname = cff.FeeFunction;
                foreach (FeeFunctionsConfigDataContract fcd in noteDC.ListFeeFunctions)
                {
                    if (fcd.FunctionNameText == functionname)
                    {
                        if (fcd.FunctionTypeText == "Fee on Unfunded Commitment")
                        {
                            paymentFrequency = fcd.PaymentFrequencyText;
                            switch (paymentFrequency)
                            {
                                case "Monthly":
                                    payFrequncy = 1;
                                    break;

                                case "Quarterly":
                                    payFrequncy = 3;
                                    break;

                                case "Semi-Annually":
                                    payFrequncy = 6;
                                    break;

                                case "Annually":
                                    payFrequncy = 12;
                                    break;
                            }

                            if (fcd.AccrualPeriodText == "Interest Period")
                            {
                                foreach (var acc in ListInterestAccrualDates)
                                {
                                    foreach (var da in DailyAccrualCustomFee)
                                    {
                                        if (da.FeeName != "")
                                        {
                                            if (acc.InterestAccrualPeriodEndDates < da.AccrualDate || acc.InterestAccrualPeriodEndDates > SelectedMaturityDateLatest)
                                            {
                                                break;
                                            }
                                            else if (da.AccrualDate >= acc.InterestAccrualPeriodStartDates && da.AccrualDate < acc.InterestAccrualPeriodEndDates)
                                            {
                                                feePayable = feePayable + da.AccrualAmount;
                                            }
                                            else if (da.AccrualDate == acc.InterestAccrualPeriodEndDates)
                                            {
                                                if (dateindex % payFrequncy == 0)
                                                {
                                                    FeeOutputDataContract fd = new FeeOutputDataContract();
                                                    fd.Date = acc.PMTDateAccuralPeriodAdjusted;
                                                    fd.FeeAmount = feePayable;
                                                    fd.FeeAmountStripped = feePayable * cff.PercentageOfFeeToBeStripped;
                                                    fd.FeeAmountinclinLY = (feePayable - feePayable * cff.PercentageOfFeeToBeStripped) * cff.IncludedLevelYield;
                                                    fd.FeeName = cff.FeeName;
                                                    fd.FeeType = cff.ValueTypeText;
                                                    fd.FeeNameTransText = cff.FeeNameTransText;
                                                    fd.FeeCouponReceivable = 0;
                                                    fd.EffectiveDate = effectiveDate;
                                                    InsertUpdateFeeOutput(fd);
                                                    //ListFeeOutput.Add(fd);
                                                    feePayable = 0;
                                                }
                                            }
                                        }
                                    }
                                    dateindex = dateindex + 1;
                                }
                            }
                            else if (fcd.AccrualPeriodText == "Calendar Period")
                            {
                            }
                        }
                    }
                }
            }
        }

        public decimal? CalculateUnusedFeeAccrual(FeeFunctionsConfigDataContract ffdc, decimal? Endingbalance, CustomFeeScheduleDataContract cff, DateTime? period, decimal? ufThreshold)
        {
            string accStartdate = ffdc.AccrualStartDateText;
            int dayCount = 0;
            decimal? ufAmount = 0;
            DateTime? startdate = DateTime.MinValue;
            switch (accStartdate)
            {
                case "Hard Start Date":
                    startdate = cff.ScheduleStartDate;
                    break;

                case "Loan Closing Date":
                    startdate = noteDC.ClosingDate;
                    break;

                case "Date of First Advance":
                    startdate = period;
                    break;

                case "Period Start Date of First Advance":
                    startdate = period;

                    foreach (InterestAccrualDates dates in ListInterestAccrualDates)
                    {
                        if (dates.InterestAccrualPeriodStartDates <= startdate && dates.InterestAccrualPeriodEndDates >= startdate)
                        {
                            startdate = dates.InterestAccrualPeriodStartDates;
                            break;
                        }
                    }
                    break;
            }
            if (ffdc.AccrualBasisText == "Actual/360")
            {
                dayCount = 360;
            }
            else
            {
                dayCount = 365;
            }
            if (period >= startdate)
            {
                ufAmount = Math.Max(0, Convert.ToDecimal(ufThreshold - Endingbalance)) * cff.Value / dayCount;
            }
            return ufAmount;
        }

        public CustomFeeScheduleDataContract ConvertToCustomEntity(PrepayAndAdditionalFeeScheduleDataContract prepay, FeeSchedulesConfigDataContract feeschedule)
        {
            CustomFeeScheduleDataContract csd = new CustomFeeScheduleDataContract();
            csd.FeeName = prepay.FeeName;
            csd.EffectiveDate = prepay.EffectiveDate;
            csd.ScheduleStartDate = prepay.ScheduleStartDate;
            csd.ScheduleEndDate = prepay.ScheduleEndDate;
            csd.ValueTypeText = prepay.ValueTypeText;
            csd.Value = prepay.Value.GetValueOrDefault(0);
            csd.FeeAmountOverride = prepay.FeeAmountOverride.GetValueOrDefault(0);
            csd.BaseAmountOverride = prepay.BaseAmountOverride.GetValueOrDefault(0);
            csd.ApplyTrueUpFeatureText = prepay.ApplyTrueUpFeatureText;
            csd.IncludedLevelYield = prepay.IncludedLevelYield.GetValueOrDefault(0);
            csd.PercentageOfFeeToBeStripped = prepay.PercentageOfFeeToBeStripped.GetValueOrDefault(0);
            if (CheckAndConvertToLower(feeschedule.TotalCommitmentText) == "true") { csd.TotalCommitment = 1; }
            if (CheckAndConvertToLower(feeschedule.UnscheduledPaydownsText) == "true") { csd.UnscheduledPaydowns = 1; }
            if (CheckAndConvertToLower(feeschedule.BalloonPaymentText) == "true") { csd.BalloonPayment = 1; }
            if (CheckAndConvertToLower(feeschedule.LoanFundingsText) == "true") { csd.LoanFundings = 1; }
            if (CheckAndConvertToLower(feeschedule.ScheduledPrincipalAmortizationPaymentText) == "true") { csd.ScheduledPrincipalAmortizationPayment = 1; }
            if (CheckAndConvertToLower(feeschedule.CurrentLoanBalanceText) == "true") { csd.CurrentLoanBalance = 1; }
            if (CheckAndConvertToLower(feeschedule.InterestPaymentText) == "true") { csd.InterestPayment = 1; }
            if (CheckAndConvertToLower(feeschedule.InitialFundingText) == "true") { csd.InitialFunding = 1; }
            if (CheckAndConvertToLower(feeschedule.M61AdjustedCommitmentText) == "true") { csd.AdjustedCommitment = 1; }
            csd.FeeFunction = feeschedule.FeeFunctionText;
            csd.FeeNameTransText = feeschedule.FeeNameTransText;

            return csd;
        }

        public void InsertUpdateFeeOutput(FeeOutputDataContract fo)
        {
            FeeOutputDataContract fd = new FeeOutputDataContract();
            fd = ListFeeOutput.FindAll(x => x.Date == fo.Date && x.FeeName == fo.FeeName && x.FeeType == x.FeeType).FirstOrDefault();
            if (fd != null)
            {
                foreach (var item in ListFeeOutput.Where(x => x.Date == fo.Date && x.FeeName == fo.FeeName && x.FeeType == x.FeeType))
                {
                    item.FeeAmountStripped = fo.FeeAmountStripped;
                    item.FeeAmount = fo.FeeAmount;
                    item.Date = fo.Date;
                    item.FeeAmountinclinLY = fo.FeeAmountinclinLY;
                    item.FeeName = fo.FeeName;
                    item.FeeType = fo.FeeType;
                    item.FeeNameTransText = fo.FeeNameTransText;
                }
            }
            else
            {
                ListFeeOutput.Add(fo);
            }
        }

        private decimal? GetAdjustedCommitmentByDate(DateTime? date, string type = "")
        {
            int MaxRowNum = 0, ndx = 0;
            decimal? AdjCommitment = 0;
            List<NoteCommitmentDataContract> ListComm;
            if (noteDC.ListNoteCommitment != null && noteDC.ListNoteCommitment.Count > 0)
            {
                if (type == "")
                    ListComm = noteDC.ListNoteCommitment.Where(x => x.Date <= date).ToList();
                else
                    ListComm = noteDC.ListNoteCommitment.Where(x => x.Type == type && x.Date <= date).ToList();

                MaxRowNum = ListComm.Max(y => y.Rownumber).GetValueOrDefault(0);
                ndx = ListComm.FindIndex(y => y.Rownumber == MaxRowNum);
                if (ndx >= 0)
                    AdjCommitment = ListComm[ndx].TotalCommitmentAdjustment.GetValueOrDefault(0);
            }
            return AdjCommitment;
        }

        private decimal? GetTotalCommitmentOnClosing()
        {
            int MaxRowNum = 0, ndx = 0;
            decimal? TotalCommitment = 0;
            List<NoteCommitmentDataContract> ListComm;
            if (noteDC.ListNoteCommitment != null && noteDC.ListNoteCommitment.Count > 0)
            {
                ListComm = noteDC.ListNoteCommitment.Where(x => x.Type == "Closing" && x.Date == noteDC.ClosingDate.GetValueOrDefault()).ToList();

                MaxRowNum = ListComm.Max(y => y.Rownumber).GetValueOrDefault(0);
                ndx = ListComm.FindIndex(y => y.Rownumber == MaxRowNum);
                if (ndx >= 0)
                    TotalCommitment = ListComm[ndx].TotalCommitment.GetValueOrDefault(0);
            }
            return TotalCommitment;
        }
        #endregion Fees
        public void CaptureInterestCalculator()
        {
            foreach (DatesTab dt in ListDatesTab)
            {
                InterestCalculatorDataContract lcd = new InterestCalculatorDataContract();
                if (noteDC.NoteId != null)
                {
                    lcd.NoteID = new Guid(noteDC.NoteId);
                }
                else
                {
                    lcd.NoteID = null;
                }
                lcd.AccrualStartDate = dt.InterestAccrualPeriodStartDateArray;
                lcd.AccrualEndDate = dt.InterestAccrualPeriodEndDateArray;
                lcd.PaymentDate = dt.PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay;
                lcd.BeginningBalance = GetBeginningBalanceOnDate(dt.InterestAccrualPeriodStartDateArray);
                lcd.AnalysisID = noteDC.AnalysisID;
                ListInterestCalculator.Add(lcd);
            }
        }

        public Decimal? GetBeginningBalanceOnDate(DateTime? dt)
        {
            return ListBalanceTab.Where(x => x.Date == dt).Select(x => x.BeginningBalance).FirstOrDefault();
        }

        public decimal ScheduledAmortAmtforSelectedDate(DateTime? transactiondate)
        {
            decimal sumamort = 0;
            foreach (FixedAmortScheduleTab amort in ListFixedAmortScheduleTabLatest)
            {
                if (amort.Date == transactiondate)
                {
                    sumamort = sumamort + amort.Value.GetValueOrDefault(0);
                }
            }
            return sumamort;
        }

        public decimal AddOnAmtInterestAccrualScenario(decimal paydown, string paydowntype, int? iastag, decimal prioramt, bool bMaturityDate = false)
        {
            decimal totalamount = 0;
            string type = "";
            if (paydowntype == "non-Amortization")
            {
                if (noteDC.InterestCalculationRuleForPaydownsText != null)
                {
                    type = noteDC.InterestCalculationRuleForPaydownsText;
                    totalamount = CalculatePayDownValue(type, iastag, prioramt, paydown, bMaturityDate);
                }
            }
            if (paydowntype == "Amortization")
            {
                if (noteDC.InterestCalculationRuleForPaydownsAmortText != null)
                {
                    type = noteDC.InterestCalculationRuleForPaydownsAmortText;
                    totalamount = CalculatePayDownValue(type, iastag, prioramt, paydown);
                }
            }
            return totalamount;
        }

        public decimal CalculatePayDownValue(string type, int? iastag, decimal prioramt, decimal paydown, bool bMaturityDate = false)
        {
            decimal totalamount = 0;
            switch (type)
            {
                case "Include Prepayment Date":
                    totalamount = paydown;
                    break;

                case "Exclude Prepayment Date":
                    totalamount = 0;
                    break;

                case "Full Period Accrual":
                    if (iastag == 1 && !bMaturityDate)
                    {
                        totalamount = 0;
                    }
                    else
                    {
                        totalamount = paydown + prioramt;
                    }
                    break;
            }
            return totalamount;
        }

        public decimal ServicingTransactionOverride(string type, DateTime? transactiondate)
        {
            decimal ServicingAmt = 0;
            if (noteDC.ListServicingLogTab != null)
            {
                foreach (var servicing in noteDC.ListServicingLogTab)
                {
                    if (servicing.TransactionTypeText == type)
                    {
                        if (servicing.TransactionDate == transactiondate)
                        {
                            ServicingAmt = ServicingAmt + servicing.TransactionAmount.GetValueOrDefault(0);
                        }
                        if (servicing.RelatedtoModeledPMTDate == transactiondate)
                        {
#pragma warning disable CS1717 // Assignment made to same variable; did you mean to assign something else?
                            ServicingAmt = ServicingAmt;
#pragma warning restore CS1717 // Assignment made to same variable; did you mean to assign something else?
                        }
                    }
                }
            }
            return ServicingAmt;
        }

        public decimal GetServicingValue(List<string> ListTypes, DateTime? LookupDate)
        {
            int ndx = -1;
            decimal ServicingAmt = 0;
            if (noteDC.ListServicingLogTab != null)
            {
                foreach (var servicing in noteDC.ListServicingLogTab)
                {
                    ndx = ListTypes.IndexOf(servicing.TransactionTypeText);
                    if (ndx >= 0)
                    {
                        if (servicing.TransactionDate == LookupDate)
                        {
                            ServicingAmt = ServicingAmt + servicing.ActualDelta.GetValueOrDefault(0);
                        }
                    }
                }
            }
            return ServicingAmt;
        }

        public decimal AddOnAmtPMTDropDate(decimal pdwn, string pdwntype, decimal prioramt)
        {
            decimal totalamount = 0;
            string type = "";
            if (pdwntype == "non-Amortization")
            {
                if (noteDC.InterestCalculationRuleForPaydownsText != null)
                {
                    type = noteDC.InterestCalculationRuleForPaydownsText;
                    totalamount = AddOnAmtPMTDropDateHelper(type, pdwn, prioramt);
                }
            }
            else if (pdwntype == "Amortization")
            {
                if (noteDC.InterestCalculationRuleForPaydownsAmortText != null)
                {
                    type = noteDC.InterestCalculationRuleForPaydownsAmortText;
                    totalamount = AddOnAmtPMTDropDateHelper(type, pdwn, prioramt);
                }
            }
            return totalamount;
        }
        public decimal AddOnAmtPMTDropDateHelper(string type, decimal pdwn, decimal prioramt)
        {
            decimal totalamount = 0;
            switch (type)
            {
                case "Include Prepayment Date":
                    totalamount = 0;
                    break;

                case "Exclude Prepayment Date":
                    totalamount = 0;
                    break;

                case "Full Period Accrual":
                    totalamount = prioramt;

                    break;
            }
            return totalamount;
        }

        public void OverrideReconValuesInTransactions()
        {
            if (noteDC.ListServicingLogTab != null)
            {
                foreach (var servicing in noteDC.ListServicingLogTab)
                {
                    if (servicing.UsedInFeeRecon != 0)
                    {
                        if (servicing.TransactionTypeText == "ExitFeeExcludedFromLevelYield" || servicing.TransactionTypeText == "ExitFeeIncludedInLevelYield" ||
    servicing.TransactionTypeText == "ExitFeeStrippingExcldfromLevelYield" || servicing.TransactionTypeText == "ExitFeeStripReceivable" || servicing.TransactionTypeText == "ExtensionFeeExcludedFromLevelYield" ||
    servicing.TransactionTypeText == "ExtensionFeeIncludedInLevelYield" || servicing.TransactionTypeText == "ExtensionFeeStrippingExcldfromLevelYield" || servicing.TransactionTypeText == "ExtensionFeeStripReceivable" ||
    servicing.TransactionTypeText == "PrepaymentFeeExcludedFromLevelYield" || servicing.TransactionTypeText == "UnusedFeeExcludedFromLevelYield" || servicing.TransactionTypeText == "ScheduledPrincipalPaid")
                        {
                            TransactionEntry te = new TransactionEntry();
                            //manish
                            te = noteDC.ListCashflowTransactionEntry.FindAll(x => x.Date == servicing.TransactionDate.Value.Date && x.Type == servicing.TransactionTypeText).FirstOrDefault();
                            if (te != null)
                            {
                                foreach (var item in noteDC.ListCashflowTransactionEntry.Where(x => x.Date == servicing.TransactionDate && x.Type == servicing.TransactionTypeText))
                                {
                                    item.isdeleted = true;
                                }
                            }

                        }
                    }
                }

                noteDC.ListCashflowTransactionEntry.RemoveAll(x => x.isdeleted == true);
                foreach (var servicing in noteDC.ListServicingLogTab)
                {
                    if (servicing.UsedInFeeRecon != 0)
                    {
                        if (servicing.TransactionTypeText == "ExitFeeExcludedFromLevelYield" || servicing.TransactionTypeText == "ExitFeeIncludedInLevelYield" ||
    servicing.TransactionTypeText == "ExitFeeStrippingExcldfromLevelYield" || servicing.TransactionTypeText == "ExitFeeStripReceivable" || servicing.TransactionTypeText == "ExtensionFeeExcludedFromLevelYield" ||
    servicing.TransactionTypeText == "ExtensionFeeIncludedInLevelYield" || servicing.TransactionTypeText == "ExtensionFeeStrippingExcldfromLevelYield" || servicing.TransactionTypeText == "ExtensionFeeStripReceivable" ||
    servicing.TransactionTypeText == "PrepaymentFeeExcludedFromLevelYield" || servicing.TransactionTypeText == "UnusedFeeExcludedFromLevelYield" || servicing.TransactionTypeText == "ScheduledPrincipalPaid")
                        {
                            TransactionEntry transaction = new TransactionEntry();
                            transaction.Date = servicing.TransactionDate;
                            transaction.AnalysisID = noteDC.AnalysisID;
                            transaction.Amount = servicing.UsedInFeeRecon.GetValueOrDefault(0);
                            transaction.Type = servicing.TransactionTypeText;
                            transaction.FeeName = "";
                            transaction.TransactionDateByRule = servicing.TransactionDateByRule;
                            transaction.TransactionDateServicingLog = servicing.TransactionDateServicingLog;
                            transaction.RemittanceDate = servicing.RemittanceDate;

                            noteDC.ListCashflowTransactionEntry.Add(transaction);
                        }
                    }
                }
            }
        }


        #region Common

        public DateTime BusinessDayAdjustment(DateTime refDate, string DateType, int? bdaylog)
        {
            if (refDate != null)
            {
                //BusinessDayAdjustmentIndexType
                if (DateType == "Index Date")
                {
                    refDate = GetWorkingDayUsingOffset(refDate, Convert.ToInt16(bdaylog), "Index Date");
                }
                else
                {
                    if (bdaylog == null)
                    {
                        bdaylog = -1;
                    }
                    bool holidayCheck;
                    string lookupmethod;
                    int bday;
                    bday = Math.Abs(Convert.ToInt16(bdaylog));
                    if (bday >= 0)
                    {
                        lookupmethod = "Prior";
                    }
                    else
                    {
                        lookupmethod = "After";
                    }

                    if (Enum.IsDefined(typeof(EnmBusinessDayLookupMethod), lookupmethod.Replace(' ', '_')))
                    {
                        EnmBusinessDayLookupMethod elookupmethod = ((EnmBusinessDayLookupMethod)Enum.Parse(typeof(EnmBusinessDayLookupMethod), lookupmethod.Replace(' ', '_')));
                        switch (elookupmethod)
                        {
                            case EnmBusinessDayLookupMethod.Prior:
                                refDate = refDate.AddDays(-1);
                                break;

                            case EnmBusinessDayLookupMethod.After:
                                refDate = refDate.AddDays(1);
                                break;
                        }
                    }
                    holidayCheck = CheckForHoliday(refDate, DateType);
                    if (holidayCheck == true)
                    {
                        refDate = GetnextWorkingDays(refDate, -1, DisableBusinessDayAdjustmentText);
                    }

                    refDate = DayAdjustmentCalc(refDate, lookupmethod, bday - 1);
                    holidayCheck = CheckForHoliday(refDate, DateType);
                    if (holidayCheck == true)
                    {
                        refDate = GetnextWorkingDays(refDate, -1, DisableBusinessDayAdjustmentText);
                    }
                    while (holidayCheck == true)
                    {
                        if (Enum.IsDefined(typeof(EnmBusinessDayLookupMethod), lookupmethod.Replace(' ', '_')))
                        {
                            EnmBusinessDayLookupMethod elookupmethod = ((EnmBusinessDayLookupMethod)Enum.Parse(typeof(EnmBusinessDayLookupMethod), lookupmethod.Replace(' ', '_')));
                            switch (elookupmethod)
                            {
                                case EnmBusinessDayLookupMethod.Prior:
                                    refDate = refDate.AddDays(-1);
                                    break;

                                case EnmBusinessDayLookupMethod.After:
                                    refDate = refDate.AddDays(1);
                                    break;
                            }
                        }
                        refDate = DayAdjustmentCalc(refDate, lookupmethod, bday - 1);
                        holidayCheck = CheckForHoliday(refDate, DateType);
                    }

                    if (Enum.IsDefined(typeof(EnmBusinessDayLookupMethod), lookupmethod.Replace(' ', '_')))
                    {
                        EnmBusinessDayLookupMethod elookupmethod = ((EnmBusinessDayLookupMethod)Enum.Parse(typeof(EnmBusinessDayLookupMethod), lookupmethod.Replace(' ', '_')));
                        switch (elookupmethod)
                        {
                            case EnmBusinessDayLookupMethod.Prior:
                                refDate = refDate.AddDays(-bday + 1);
                                break;

                            case EnmBusinessDayLookupMethod.After:
                                refDate = refDate.AddDays(bday - 1);
                                break;
                        }
                    }
                    refDate = DayAdjustmentCalc(refDate, lookupmethod, bday);
                    holidayCheck = CheckForHoliday(refDate, DateType);
                    while (holidayCheck == true)
                    {
                        if (Enum.IsDefined(typeof(EnmBusinessDayLookupMethod), lookupmethod.Replace(' ', '_')))
                        {
                            EnmBusinessDayLookupMethod elookupmethod = ((EnmBusinessDayLookupMethod)Enum.Parse(typeof(EnmBusinessDayLookupMethod), lookupmethod.Replace(' ', '_')));
                            switch (elookupmethod)
                            {
                                case EnmBusinessDayLookupMethod.Prior:
                                    refDate = refDate.AddDays(-1);
                                    break;

                                case EnmBusinessDayLookupMethod.After:
                                    refDate = refDate.AddDays(1);
                                    break;
                            }
                        }

                        refDate = DayAdjustmentCalc(refDate, lookupmethod, bday);
                        holidayCheck = CheckForHoliday(refDate, DateType);
                    }
                }
            }
            return refDate;
        }

        public int SetMondayAsStartofWeek(DateTime date)
        {
            int d = (int)date.DayOfWeek;
            if (d == 0)
            {
                d = 7;
            }

            return d;
        }

        public DateTime GetWorkingDayUsingOffset(DateTime date, int offset, string datetype)
        {
            DateTime workingDay = date;
            if (noteDC.PaymentDateBusinessDayLag == 0 && offset == 0)
            {
                workingDay = date.AddDays(-1);
            }
            else
            {
                if (noteDC.DefaultScenarioParameters.DisableBusinessDayAdjustmentText != "Y")
                {
                    workingDay = GetnextWorkingDaysNew(workingDay, offset, datetype);
                }
                else
                {
                    workingDay = date.AddDays(-1);
                }
            }

            return workingDay;
        }


        public DateTime DayAdjustmentCalc(DateTime refDate, string lookupMethod, int? bday)
        {
            if (lookupMethod == null || lookupMethod == "")
            {
                lookupMethod = "Prior";
            }
            if (bday == null)
            {
                bday = 2;
            }
            if (SetMondayAsStartofWeek(refDate) >= 5)
            {
                if (Enum.IsDefined(typeof(EnmBusinessDayLookupMethod), lookupMethod.Replace(' ', '_')))
                {
                    EnmBusinessDayLookupMethod elookupmethod = ((EnmBusinessDayLookupMethod)Enum.Parse(typeof(EnmBusinessDayLookupMethod), lookupMethod.Replace(' ', '_')));
                    switch (elookupmethod)
                    {
                        case EnmBusinessDayLookupMethod.Prior:
                            if (SetMondayAsStartofWeek(refDate) > 5 && bday != 0)
                            {
                                refDate = refDate.AddDays(-Math.Min(Convert.ToInt32(bday), (SetMondayAsStartofWeek(refDate) - 4)));
                            }
                            break;

                        case EnmBusinessDayLookupMethod.After:
                            if (SetMondayAsStartofWeek(refDate) > 5)
                            {
                                refDate = refDate.AddDays(8 - SetMondayAsStartofWeek(refDate));
                            }

                            break;
                    }
                }
            }
            return refDate;
        }

        public bool CheckForHoliday(DateTime refDate, string DateType)
        {
            bool holidayCheck = false;
            foreach (var holiday in ListHoliday)
            {
                if (holiday.HolidayTypeText == DateType && holiday.HolidayDate == refDate)
                {
                    holidayCheck = true;
                    break;
                }
            }
            return holidayCheck;
        }

        public string CheckAndConvertToLower(string text)
        {
            string value = "";

            if (text != null)
            {
                if (text.Length > 0)
                {
                    value = text.ToLower().Trim();
                }
            }
            return value;
        }

        public void CollectDates()
        {
            DateTime ClosingDate = Convert.ToDateTime(noteDC.ClosingDate);
            DateTime MaxDate = Convert.ToDateTime(DateTime.MinValue);
            int payfreq = noteDC.AccrualFrequency.GetValueOrDefault(1);
            int StubPeriodLengthMo;

            //  StubPeriodLengthMo  =
            DateTime? initialAccEndDate = noteDC.InitialInterestAccrualEndDate;
            int loanterm = YearMonthDiff(Convert.ToDateTime(initialAccEndDate), Convert.ToDateTime(SelectedMaturityDateLatest));
            //stub_period_length_mo = VBA.DateDiff("m", closingdate, initial_acc_end_date)
            StubPeriodLengthMo = YearMonthDiff(ClosingDate, Convert.ToDateTime(initialAccEndDate));
            accEndDate = Convert.ToDateTime(initialAccEndDate).AddMonths(loanterm + 1);

            if (Convert.ToDateTime(SelectedMaturityDateLatest).Subtract(Convert.ToDateTime(accEndDate)).Days > 1)
            {
                accEndDate = Convert.ToDateTime(accEndDate).AddMonths(1);
            }

            //Determine first interest period start date
            DateTime firstPeriodStarttemp = CreateNewDate(initialAccEndDate.Value.Year, initialAccEndDate.Value.Month - 1, initialAccEndDate.Value.Day + 1);
            if (firstPeriodStarttemp < ClosingDate.Date)
            {
                firstPeriodStart = CreateNewDate(initialAccEndDate.Value.Year, initialAccEndDate.Value.Month, initialAccEndDate.Value.Day + 1); ;
            }
            else
            {
                firstPeriodStart = firstPeriodStarttemp;
            }

            if (noteDC.StubPaidinAdvanceYNText == "Y")
            {
                if (CreateNewDate(initialAccEndDate.Value.Year, initialAccEndDate.Value.Month - payfreq, initialAccEndDate.Value.Day) < noteDC.ClosingDate)
                {
                    stubEndDate = noteDC.InitialInterestAccrualEndDate;
                }
                else
                {
                    stubEndDate = CreateNewDate(initialAccEndDate.Value.Year, initialAccEndDate.Value.Month - payfreq, initialAccEndDate.Value.Day);
                }
            }
            if (ClosingDate != null)
            {
                if (SelectedMaturityDateLatest != null)
                {
                    if (SelectedMaturityDateLatest > MaxDate)
                    {
                        MaxDate = CreateNewDate(SelectedMaturityDateLatest.Value.Date.Year, SelectedMaturityDateLatest.Value.Date.Month, 1).AddMonths(1).AddDays(-1);
                    }
                }
            }

            ClosingDate = Convert.ToDateTime(noteDC.ClosingDate);
            if (MaxDate < accEndDate)
                MaxDate = Convert.ToDateTime(accEndDate);

            if (MaxDate != null)
            {
                for (DateTime i = ClosingDate; i <= MaxDate; i = i.AddDays(1))
                {
                    cDailyDates.Add(i);
                }
            }
        }

        public void CollectDates(DateTime prevMaturityDate, DateTime SelectedMaturityDate)
        {
            prevAccEndDate = accEndDate;
            DateTime? initialAccEndDate = noteDC.InitialInterestAccrualEndDate;
            int loanterm = YearMonthDiff(Convert.ToDateTime(initialAccEndDate), Convert.ToDateTime(SelectedMaturityDate));
            accEndDate = Convert.ToDateTime(initialAccEndDate).AddMonths(loanterm + 1);
            DateTime MaxDate = CreateNewDate(SelectedMaturityDate.Year, SelectedMaturityDate.Month, 1).AddMonths(1).AddDays(-1);
            DateTime arrMaxDate = cDailyDates.Max();
            if (MaxDate < accEndDate)
                MaxDate = Convert.ToDateTime(accEndDate);

            if (MaxDate != null)
            {
                for (DateTime i = arrMaxDate.AddDays(1); i <= MaxDate; i = i.AddDays(1))
                {
                    cDailyDates.Add(i);
                }
            }
        }
        public void CalculateUniqueDates<T>(IEnumerable<T> NoteObject, string ObjectDate, string PropertyName)
        {
            DateTime? Date;
            if (NoteObject != null)
            {
                foreach (var value in NoteObject)
                {
                    UniqueDatesForCalcEngine uniqueDate = new UniqueDatesForCalcEngine();
                    //get property value by name
                    var property = value.GetType().GetProperty(ObjectDate);
                    var objDate = property.GetValue(value, null);

                    Date = Convert.ToDateTime(objDate);
                    if (Date != null)
                    {
                        var index = uniqueDateListFull.FindIndex(item => item.UniqueDate == Date);
                        if (index != -1)
                        {
                            uniqueDateListFull.Where(checkDate => checkDate.UniqueDate == Date).ToList().ForEach(checkValue => checkValue.GetType().GetProperty(PropertyName).SetValue(checkValue, true));
                        }
                        else
                        {
                            if (PropertyName == "SelectedMaturityDate")
                            {
                                uniqueDate.UniqueDate = GetWorkingDayUsingOffset(Convert.ToDateTime(Date.Value.AddDays(1)), Convert.ToInt16(-1), "");
                            }
                            else
                                uniqueDate.UniqueDate = Date;
                            uniqueDate.UniqueDateNotAdj = Date;

                            //get and set property value by name
                            PropertyInfo propertyInfo = uniqueDate.GetType().GetProperty(PropertyName);
                            propertyInfo.SetValue(uniqueDate, true, null);

                            uniqueDateListFull.Add(uniqueDate);
                        }
                    }
                }
            }
        }

        public void PopulateTabDates()
        {
            cDailyDates.OrderBy(x => x.Date).ToList().ForEach(value =>
            {
                ListRateTab.Add(new RateTab() { rateDate = value });
                ListCouponTab.Add(new CouponTab() { Date = value });
                ListFeesTab.Add(new FeesTab() { Date = value });
                ListBalanceTab.Add(new BalanceTab() { Date = value });
                ListPIKInterestTab.Add(new PIKInterestTab() { Date = value });
                ListGAAPBasisTab.Add(new GAAPBasisTab() { Date = value });
                ListPVBasisTab.Add(new PVBasisTab() { Date = value });
                ListSLBasisTab.Add(new SLBasisTab() { Date = value });
                ListFinancingTab.Add(new FinancingTab() { Date = value });
                ListFinancingDrawsTab.Add(new FinancingDrawsTab() { Date = value });
            });
        }

        public void PopulateTabDates(DateTime prevSelectedMaturityDate)
        {
            int ListIndex = ListRateTab.Count;
            if (SelectedMaturityDateLatest > prevSelectedMaturityDate)
                foreach (DateTime value in cDailyDates.Skip(ListIndex))
                {
                    ListRateTab.Add(new RateTab() { rateDate = value });
                    ListCouponTab.Add(new CouponTab() { Date = value });
                    ListFeesTab.Add(new FeesTab() { Date = value });
                    ListBalanceTab.Add(new BalanceTab() { Date = value });
                    ListPIKInterestTab.Add(new PIKInterestTab() { Date = value });
                    ListGAAPBasisTab.Add(new GAAPBasisTab() { Date = value });
                    ListPVBasisTab.Add(new PVBasisTab() { Date = value });
                    ListSLBasisTab.Add(new SLBasisTab() { Date = value });
                    ListFinancingTab.Add(new FinancingTab() { Date = value });
                    ListFinancingDrawsTab.Add(new FinancingDrawsTab() { Date = value });
                };
        }
        public double cXNPV(double Rate, List<decimal> Values, List<DateTime> Dates)
        {
            double Value = 0, Sum = 0;
            int i = 0;
            foreach (var val in Values)
            {
                Value = NumericExtensions.SafeDivision(Convert.ToDouble(Values[i]), NumericExtensions.CalcPowAndCheckNaNDouble((1 + Convert.ToDouble(Rate)), ((Dates[i] - Dates[0]).TotalDays) / 365));
                Sum = Sum + Value;
                i = i + 1;
            }
            return Sum;
        }

        public double cXIRR(List<Decimal> values, List<DateTime> dates, double guess = 0.1)
        {
            double sumpv = 0, rate = 0, raten1 = 0, raten2 = 0, raten1cxnpv = 0, raten2cxnpv = 0;
            rate = guess;
            raten1 = guess - 0.001;
            sumpv = cXNPV(rate, values, dates);
            int i = 0;
            raten1cxnpv = cXNPV(raten1, values, dates);
            if (Math.Abs(sumpv) != 0)
            {
                while (Math.Abs(sumpv - 0) > 0.00005)
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
            return rate;
        }

        public void CreatePVXIRRcsv(List<DateTime> dates, List<decimal> values, List<decimal> Actuals, string filename)
        {
            List<OutputNPVdata> list = new List<OutputNPVdata>();
            for (int i = 0; i < dates.Count; i++)
            {
                OutputNPVdata rt = new OutputNPVdata();
                rt.NPVdate = dates[i];
                rt.CashFlowUsedForLevelYieldPrecap = values[i];
                rt.Actualbasis = Actuals[i];
                list.Add(rt);
            }
            CreateCSVFile(ToDataSet(list).Tables[0], filename);
        }

        public void CreateGaapXIRRcsv(List<DateTime> dates, List<decimal> Value, string filename)
        {
            List<OutputNPVdata> list = new List<OutputNPVdata>();
            for (int i = 0; i < dates.Count; i++)
            {
                OutputNPVdata rt = new OutputNPVdata();
                rt.NPVdate = dates[i];
                rt.Value = Value[i];
                list.Add(rt);
            }
            CreateCSVFile(ToDataSet(list).Tables[0], filename);
        }

        public decimal? CFForLevelYield(int index, bool LevelYield = true)
        {
            decimal? cfamount = 0;
            decimal? feeamount = LevelYield ? ListFeesTab[index].FeeAmountIncludedinLevelYield.GetValueOrDefault(0) : ListFeesTab[index].FeeAmountAllIn.GetValueOrDefault(0);
            decimal? prinamount = noteDC.IncludeServicingPaymentOverrideinLevelYieldText == "Y" ? ListBalanceTab[index].PrincipalReceivedperServicing.GetValueOrDefault(0) : ListBalanceTab[index].PrincipalPaid.GetValueOrDefault(0);
            decimal? intamount = noteDC.IncludeServicingPaymentOverrideinLevelYieldText == "Y" ? ListCouponTab[index].InterestPaidServicingWithDropDate.GetValueOrDefault(0) : ListCouponTab[index].InterestPaidonPaymentDate.GetValueOrDefault(0);

            cfamount = prinamount + ListBalanceTab[index].BalloonPayment.GetValueOrDefault(0) - ListBalanceTab[index].FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0)
                - ListBalanceTab[index].DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0) + intamount + ListCouponTab[index].InterestShortfallRecovery.GetValueOrDefault(0)
                        + ListPIKInterestTab[index].PIKBalanceBalloonPayment.GetValueOrDefault(0) + feeamount;

            return cfamount;
        }

        public decimal? CFServicerAdjusted(int index)
        {
            decimal? cfamount = 0;
            cfamount = ListBalanceTab[index].PrincipalReceivedperServicing.GetValueOrDefault(0) + ListBalanceTab[index].BalloonPayment.GetValueOrDefault(0) - ListBalanceTab[index].FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0) - ListBalanceTab[index].DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0)
                   + ListCouponTab[index].InterestPaidServicingWithDropDate.GetValueOrDefault(0) + ListCouponTab[index].InterestShortfallRecovery.GetValueOrDefault(0)
                   + ListPIKInterestTab[index].PIKBalanceBalloonPayment.GetValueOrDefault(0) + ListFeesTab[index].FeeAmountIncludedinLevelYield.GetValueOrDefault(0);
            return cfamount;
        }

        public decimal? CalculateNetInflowOutflow(int listindex)
        {
            decimal? NetPrincipalInflowOutflow = 0;
            decimal? evalcommon = ListBalanceTab[listindex].BalloonPayment.GetValueOrDefault(0)
                    - ListBalanceTab[listindex].FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0)
                    - ListBalanceTab[listindex].DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0)
                + ListPIKInterestTab[listindex].PIKBalanceBalloonPayment.GetValueOrDefault(0)
                - ListPIKInterestTab[listindex].PIKInterestPaidAppliedForThePeriod.GetValueOrDefault(0)
                - ListPIKInterestTab[listindex].PIKInterestforthePeriodBalloon.GetValueOrDefault(0)
                + ListPIKInterestTab[listindex].PIKPrincipalPaidForThePeriod.GetValueOrDefault(0);

            if (noteDC.IncludeServicingPaymentOverrideinLevelYieldText == "Y")
            {
                NetPrincipalInflowOutflow = ListBalanceTab[listindex].PrincipalReceivedperServicing.GetValueOrDefault(0) + evalcommon;
            }
            else
            {
                NetPrincipalInflowOutflow = ListBalanceTab[listindex].PrincipalPaid.GetValueOrDefault(0) + evalcommon;
            }

            return NetPrincipalInflowOutflow;
        }

        public DateTime LastDateOfMonth(DateTime anyDt)
        {
            return new DateTime(anyDt.Year, anyDt.Month, DateTime.DaysInMonth(anyDt.Year, anyDt.Month));
        }

        public DateTime FirstDayOfMonth(DateTime dateTime)
        {
            return new DateTime(dateTime.Year, dateTime.Month, 1);
        }

        public static DateTime GetnextWorkingDays(DateTime date, int days, string DisableBusinessDayAdjustment)
        {
            if (days == 0)
            {
                return date.AddDays(-1);
            }
            else
            {
                if (DisableBusinessDayAdjustment != "Y")
                {
                    if (days == 0) return date;
                    if (days > 0)
                    {
                        if (date.DayOfWeek == DayOfWeek.Saturday)
                            date = date.AddDays(1);
                        int i = 1;
                        while (i <= days)
                        {
                            date = date.AddDays(1);
                            if (date.DayOfWeek == DayOfWeek.Saturday)
                                date = date.AddDays(2);
                            if (date.DayOfWeek == DayOfWeek.Sunday)
                                date = date.AddDays(1);
                            i = i + 1;
                        }

                        return date;
                    }
                    else
                    {
                        if (date.DayOfWeek == DayOfWeek.Sunday)
                            date = date.AddDays(-1);
                        int i = 1;
                        while (i <= -days)
                        {
                            date = date.AddDays(-1);
                            if (date.DayOfWeek == DayOfWeek.Sunday)
                                date = date.AddDays(-2);
                            if (date.DayOfWeek == DayOfWeek.Saturday)
                                date = date.AddDays(-1);
                            i = i + 1;
                        }
                        return date;
                    }
                }
                else
                {
                    date = date.AddDays(days);
                    return date;
                }
            }



        }

        public DateTime GetnextWorkingDaysNew(DateTime date, int days, string datetype = null)
        {
            if (days == 0) return date;
            if (days > 0)
            {
                if (date.DayOfWeek == DayOfWeek.Saturday)
                    date = date.AddDays(1);
                int i = 1;
                while (i <= days)
                {
                    date = date.AddDays(1);
                    if (date.DayOfWeek == DayOfWeek.Saturday)
                        date = date.AddDays(2);
                    if (date.DayOfWeek == DayOfWeek.Sunday)
                        date = date.AddDays(1);

                    if (datetype != null)
                    {
                        if (CheckForHoliday(date, datetype))
                        {
                            date = date.AddDays(1);
                            i = i - 1;
                        }
                    }
                    i = i + 1;
                }

                return date;
            }
            else
            {
                if (date.DayOfWeek == DayOfWeek.Sunday)
                    date = date.AddDays(-1);
                int i = 1;
                while (i <= -days)
                {
                    date = date.AddDays(-1);
                    if (date.DayOfWeek == DayOfWeek.Sunday)
                        date = date.AddDays(-2);
                    if (date.DayOfWeek == DayOfWeek.Saturday)
                        date = date.AddDays(-1);
                    if (datetype != null)
                    {
                        if (CheckForHoliday(date, datetype))
                        {
                            date = date.AddDays(-1);
                            i = i - 1;
                        }
                    }
                    i = i + 1;
                }
                return date;
            }
        }

        public static DateTime CreateNewDate(int year, int months, int days)
        {
            DateTime date = new DateTime(0001, 1, 1).AddYears(year - 1).AddMonths(months - 1).AddDays(days - 1);
            return date;
        }

        public static DataSet ToDataSet<T>(IEnumerable<T> list)
        {
            Type elementType = typeof(T);
            DataSet ds = new DataSet();
            System.Data.DataTable t = new System.Data.DataTable();
            ds.Tables.Add(t);

            //add a column to table for each public property on T
            foreach (var propInfo in elementType.GetProperties())
            {
                t.Columns.Add(propInfo.Name);
            }

            if (list != null)
            {
                //go through each property on T and add each value to the table
                foreach (T item in list)
                {
                    DataRow row = t.NewRow();
                    foreach (var propInfo in elementType.GetProperties())
                    {
                        row[propInfo.Name] = propInfo.GetValue(item, null);
                    }

                    //This line was missing:
                    t.Rows.Add(row);
                }
            }
            return ds;
        }

        public void CreateCSVFile(System.Data.DataTable dt, string csvname)
        {
            try
            {
                string path = @"C:\temp";
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }

                string strFilePath = "C:\\temp\\" + csvname + ".csv";

                StreamWriter sw = new StreamWriter(strFilePath, false);
                int columnCount = dt.Columns.Count;

                for (int i = 0; i < columnCount; i++)
                {
                    sw.Write(dt.Columns[i]);

                    if (i < columnCount - 1)
                    {
                        sw.Write(",");
                    }
                }

                sw.Write(sw.NewLine);

                foreach (DataRow dr in dt.Rows)
                {
                    for (int i = 0; i < columnCount; i++)
                    {
                        if (!Convert.IsDBNull(dr[i]))
                        {
                            sw.Write(dr[i].ToString());
                        }

                        if (i < columnCount - 1)
                        {
                            sw.Write(",");
                        }
                    }

                    sw.Write(sw.NewLine);
                }

                sw.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static DateTime GetMinDate(DateTime t1, DateTime t2)

        {
            if (DateTime.Compare(t1, t2) > 0)

            {
                return t2;
            }

            return t1;
        }

        public static DateTime GetMaxDate(DateTime t1, DateTime t2)

        {
            if (DateTime.Compare(t1, t2) > 0)
            {
                return t1;
            }

            return t2;
        }

        public void WriteLogFile(string message)
        {
            string path = @"C:\temp";
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }

            System.IO.File.WriteAllText(path + "\\CalculatorLog.txt", message);
        }

        public void AppendString(string methodname, string timetaken)
        {
            CalculationTimeLog = CalculationTimeLog + "\t" + "Calculation of " + methodname + System.DateTime.Now.ToString("HH:mm:ss") + "\t\t\t----\t\t\tTime taken :" + timetaken + Environment.NewLine;
        }

        public void CalcPeriodWal()
        {
            decimal sum1 = 0, sum2 = 0, EndOfPeriodWAL = 0;
            int i = 0;
            foreach (var periodic in ListNotePeriodicOutputs)
            {
                sum1 = 0; sum2 = 0;
                foreach (var output in ListNotePeriodicOutputs.Skip(i))
                {
                    sum1 = sum1 - output.Month.GetValueOrDefault(0) * output.TotalFutureAdvancesForThePeriod.GetValueOrDefault(0)
                        - output.Month.GetValueOrDefault(0) * output.TotalDiscretionaryCurtailmentsforthePeriod.GetValueOrDefault(0)
                        + output.Month.GetValueOrDefault(0) * output.PrincipalPaid.GetValueOrDefault(0)
                        + output.Month.GetValueOrDefault(0) * output.BalloonPayment.GetValueOrDefault(0)
                        + output.Month.GetValueOrDefault(0) * output.PIKBalanceBalloonPayment.GetValueOrDefault(0);

                    sum2 = sum2 - output.TotalFutureAdvancesForThePeriod.GetValueOrDefault(0)
                        - output.TotalDiscretionaryCurtailmentsforthePeriod.GetValueOrDefault(0)
                        + output.BalloonPayment.GetValueOrDefault(0)
                        + output.PIKBalanceBalloonPayment.GetValueOrDefault(0);
                }
                EndOfPeriodWAL = (NumericExtensions.SafeDivision(sum1, sum2) - periodic.Month.GetValueOrDefault(0)) / 12;
                periodic.EndOfPeriodWAL = EndOfPeriodWAL;
                i = i + 1;
            }
        }

        public double RoundDown(double number, int decimalPlaces)
        {
            return Math.Floor(number * Math.Pow(10, decimalPlaces)) / Math.Pow(10, decimalPlaces);
        }

        public double RoundUp(double number, int decimalPlaces)
        {
            return Math.Ceiling(number * Math.Pow(10, decimalPlaces)) / Math.Pow(10, decimalPlaces);
        }

        public decimal vRoundUp(decimal number, int places)
        {
            decimal factor = RoundFactor(places);
            number *= factor;
            number = Math.Ceiling(number);
            number /= factor;
            return number;
        }

        public decimal vRoundDown(decimal number, int places)
        {
            decimal factor = RoundFactor(places);
            number *= factor;
            number = Math.Floor(number);
            number /= factor;
            return number;
        }

        internal decimal RoundFactor(int places)
        {
            decimal factor = 1m;

            if (places < 0)
            {
                places = -places;
                for (int i = 0; i < places; i++)
                    factor /= 10m;
            }
            else
            {
                for (int i = 0; i < places; i++)
                    factor *= 10m;
            }

            return factor;
        }

        public void GenerateCashflowTransaction()
        {
            List<TransactionEntry> lstTransaction = new List<TransactionEntry>();
            List<DailyInterestAccrualsDataContract> listdailint = new List<DailyInterestAccrualsDataContract>();
            List<PeriodicInterestRateUsed> listrateused = new List<PeriodicInterestRateUsed>();

            DateTime startdate = DateTime.Now.Date.AddDays(-noteDC.NumberofDaysinPast);
            DateTime enddate = DateTime.Now.Date.AddDays(noteDC.NumberofDaysinFuture);
            int PaymentDayOfMonth = GetPaymentDayOfMonth();

            //FundingOrRepayment
            DateTime Todaysdate = DateTime.Now;
            DateTime ballondate = DateTime.MinValue;
            DateTime suspensedate = DateTime.MinValue;
            bool isMaturityDate = false;
            decimal? stripedamount = 0;

            foreach (FutureFundingScheduleTab ffs in ListFutureFundingScheduleTabLatest)
            {
                if (ffs.Value != 0 && ffs.Value != null && ffs.Date <= SelectedMaturityDateLatest)
                {
                    TransactionEntry transaction = new TransactionEntry();
                    transaction.Date = ffs.Date;
                    transaction.Amount = ffs.Value * -1;
                    transaction.Type = "FundingOrRepayment";
                    transaction.AnalysisID = noteDC.AnalysisID;
                    transaction.PurposeType = ffs.PurposeText;
                    lstTransaction.Add(transaction);
                }
            }

            //InitialFunding
            if (noteDC.InitialFundingAmount != null && noteDC.InitialFundingAmount != 0 && noteDC.ClosingDate <= SelectedMaturityDateLatest)
            {
                TransactionEntry transaction = new TransactionEntry();
                transaction.Date = noteDC.ClosingDate;
                transaction.Amount = Convert.ToDecimal(noteDC.InitialFundingAmount) * -1;
                transaction.Type = "InitialFunding";
                transaction.AnalysisID = noteDC.AnalysisID;
                lstTransaction.Add(transaction);
            }
            //Discount/Premium
            if (noteDC.Discount != null && noteDC.Discount != 0 && noteDC.ClosingDate <= SelectedMaturityDateLatest)
            {
                TransactionEntry transaction = new TransactionEntry();
                transaction.Date = noteDC.ClosingDate;
                transaction.Amount = Convert.ToDecimal(noteDC.Discount) * -1;
                transaction.Type = "Discount/Premium";
                transaction.AnalysisID = noteDC.AnalysisID;
                lstTransaction.Add(transaction);
            }
            //StubInterest
            if (noteDC.StubIntOverride != null && noteDC.StubIntOverride != 0 && noteDC.ClosingDate <= SelectedMaturityDateLatest)
            {
                TransactionEntry transaction = new TransactionEntry();
                DateTime txnDate = noteDC.StubPaidinAdvanceYNText == "Y" ? noteDC.ClosingDate.Value.Date : noteDC.FirstPaymentDate.Value.Date;
                transaction.Date = noteDC.ClosingDate;
                transaction.Amount = Convert.ToDecimal(noteDC.StubIntOverride);
                transaction.Type = "StubInterest";
                transaction.AnalysisID = noteDC.AnalysisID;
                lstTransaction.Add(transaction);
                var temp = GenerateLiborandSpreadTransaction(txnDate);
                if (temp != null)
                {
                    if (temp.Count > 0)
                    {
                        lstTransaction.AddRange(temp);
                    }
                }
            }

            //Purchased Interest - Calculated
            if (noteDC.LoanPurchaseYNText == "Y" && noteDC.ClosingDate <= SelectedMaturityDateLatest)
            {
                TransactionEntry transaction = new TransactionEntry();
                transaction.Date = noteDC.ClosingDate;
                transaction.Amount = Math.Round(PurchasedStubInterest.GetValueOrDefault(0), 2) * -1;
                transaction.Type = "PurchasedInterest";
                transaction.AnalysisID = noteDC.AnalysisID;
                lstTransaction.Add(transaction);
            }

            //ScheduledPrincipalPaid + Balloon
            foreach (BalanceTab bal in ListBalanceTab)
            {
                if (bal.BalloonPayment.GetValueOrDefault(0) != 0 && bal.Date <= SelectedMaturityDateLatest)
                {
                    TransactionEntry transaction = new TransactionEntry();
                    transaction.Date = bal.Date;
                    transaction.Amount = Convert.ToDecimal(bal.BalloonPayment);
                    transaction.Type = "Balloon";
                    transaction.AnalysisID = noteDC.AnalysisID;
                    lstTransaction.Add(transaction);
                }
                if (bal.PrincipalPaid.GetValueOrDefault(0) != 0 && bal.Date <= SelectedMaturityDateLatest)
                {
                    TransactionEntry transaction = new TransactionEntry();
                    transaction.Date = bal.Date;
                    transaction.Amount = Convert.ToDecimal(bal.PrincipalPaid);
                    transaction.Type = "ScheduledPrincipalPaid";
                    transaction.AnalysisID = noteDC.AnalysisID;
                    lstTransaction.Add(transaction);
                }
            }
            int listindex = 0;

            //InterestPaid
            foreach (CouponTab coup in ListCouponTab)
            {
                DailyGAAPBasisComponentsDataContract basis = new DailyGAAPBasisComponentsDataContract();
                basis.NoteID = noteDC.NoteId;
                basis.Date = ListGAAPBasisTab[listindex].Date;
                basis.AccumAmortofDeferredFees = ListGAAPBasisTab[listindex].AccumAmortofDeferredFees;
                basis.AccumulatedAmortofDiscountPremium = ListGAAPBasisTab[listindex].AccumulatedAmortofDiscountPremium;
                basis.AccumulatedAmortofCapitalizedCost = ListGAAPBasisTab[listindex].AccumulatedAmortofCapitalizedCost;
                basis.EndingBalance = ListBalanceTab[listindex].EndingBalance.GetValueOrDefault(0);
                basis.CurrentPeriodInterestAccrualPeriodEnddate = ListCouponTab[listindex].AccumInterestforCurrentAccrualPeriod.GetValueOrDefault(0) + ListCouponTab[listindex].DeltaBalance.GetValueOrDefault(0);
                basis.CurrentPeriodPIKInterestAccrualPeriodEnddate = ListPIKInterestTab[listindex].AccumPIKInterestforCurrentAccrualPeriod.GetValueOrDefault(0);
                basis.InterestSuspenseAccountBalance = ListCouponTab[listindex].InterestSuspenseAccountBalanceWithAdj.GetValueOrDefault(0);
                basis.CleanCost = ListGAAPBasisTab[listindex].CleanCost.GetValueOrDefault(0);
                basis.GrossDeferredFees = ListGAAPBasisTab[listindex].GrossDeferredFees.GetValueOrDefault(0);
                basis.AnalysisID = noteDC.AnalysisID;

                ListDailyGAAPBasisComponents.Add(basis);

                if (coup.Date <= SelectedMaturityDateLatest)
                {
                    DailyInterestAccrualsDataContract dia = new DailyInterestAccrualsDataContract();
                    dia.Date = coup.Date;
                    dia.DailyInterestAccrual = coup.DailyAccruedInterestbeforeStrippingRule.GetValueOrDefault(0);
                    dia.EndingBalance = ListBalanceTab[listindex].EndingBalance.GetValueOrDefault(0);
                    dia.AnalysisID = noteDC.AnalysisID;
                    listdailint.Add(dia);
                }
                if (coup.Date <= SelectedMaturityDateLatest)
                {
                    if (coup.InterestPaidServicingWithDropDate.GetValueOrDefault(0) != 0)
                    {
                        TransactionEntry transaction = new TransactionEntry();
                        transaction.PaymentDateNotAdjustedforWorkingDay = GetPMTDateNotAdjustedforBusinessDay(Convert.ToDateTime(coup.Date), PaymentDayOfMonth);
                        transaction.Date = GetWorkingDayUsingOffset(Convert.ToDateTime(coup.Date.Value.AddDays(1)), Convert.ToInt32(noteDC.PaymentDateBusinessDayLag), "PMT Date");
                        transaction.Amount = Convert.ToDecimal(coup.InterestPaidServicingWithDropDate);
                        transaction.Type = "InterestPaid";
                        transaction.AnalysisID = noteDC.AnalysisID;
                        lstTransaction.Add(transaction);
                    }
                    if (coup.Date >= startdate && coup.Date <= enddate)
                    {
                        PeriodicInterestRateUsed pir = new PeriodicInterestRateUsed();
                        pir.Date = coup.Date;
                        pir.CouponSpread = ListRateTab[listindex].CouponSpread.GetValueOrDefault(0);
                        pir.AllInCouponRate = ListRateTab[listindex].AllInCouponRate.GetValueOrDefault(0);
                        pir.AllInPikRate = ListRateTab[listindex].AllInPIKInterestCompoundingRate.GetValueOrDefault(0);
                        pir.LiborRate = ListRateTab[listindex].DIndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0);
                        pir.IndexFloor = ListRateTab[listindex].IndexFloor.GetValueOrDefault(0);
                        pir.CouponRate = ListRateTab[listindex].CouponRate.GetValueOrDefault(0);
                        pir.AdditionalPIKinterestRatefromPIKTable = ListRateTab[listindex].AdditionalPIKinterestRatefromPIKTable.GetValueOrDefault(0);
                        pir.AdditionalPIKSpreadfromPIKTable = ListRateTab[listindex].AdditionalPIKSpreadfromPIKTable.GetValueOrDefault(0);
                        pir.PIKIndexFloorfromPIKTable = ListRateTab[listindex].PIKIndexFloorfromPIKTable.GetValueOrDefault(0);
                        pir.AnalysisID = noteDC.AnalysisID;
                        listrateused.Add(pir);
                    }

                }
                listindex = listindex + 1;
            }

            //ScheduledPrincipalPaid
            if (noteDC.ListServicingLogTab != null)
            {
                var servicing = noteDC.ListServicingLogTab.Where(i => i.TransactionAmount.GetValueOrDefault(0) != 0 && i.TransactionTypeText == "Principal Received");
                foreach (var ser in servicing)
                {
                    if (ser.TransactionAmount.GetValueOrDefault(0) != 0 && ser.TransactionDate <= SelectedMaturityDateLatest)
                    {
                        TransactionEntry transaction = new TransactionEntry();
                        transaction.Date = ser.TransactionDate;
                        transaction.Amount = Convert.ToDecimal(ser.TransactionAmount) * -1;
                        transaction.Type = "ScheduledPrincipalPaid";
                        transaction.AnalysisID = noteDC.AnalysisID;
                        lstTransaction.Add(transaction);
                    }
                }
            }
            //EndingGaapBookValue
            foreach (NotePeriodicOutputsDataContract npdc in ListNotePeriodicOutputs)
            {
                if (npdc.EndingGAAPBookValue != 0)
                {
                    TransactionEntry transaction = new TransactionEntry();
                    transaction.Date = npdc.PeriodEndDate;
                    transaction.Amount = npdc.EndingGAAPBookValue.GetValueOrDefault();
                    transaction.Type = "EndingGAAPBookValue";
                    transaction.AnalysisID = noteDC.AnalysisID;
                    lstTransaction.Add(transaction);
                }
                if (npdc.InvestmentBasis != 0)
                {
                    TransactionEntry transactionpv = new TransactionEntry();
                    transactionpv.Date = npdc.PeriodEndDate;
                    transactionpv.Amount = Convert.ToDecimal(npdc.InvestmentBasis.GetValueOrDefault(0));
                    transactionpv.Type = "EndingPVGAAPBookValue";
                    transactionpv.AnalysisID = noteDC.AnalysisID;
                    lstTransaction.Add(transactionpv);
                }
            }

            //CapitalizedClosingCost
            if (noteDC.CapitalizedClosingCosts != null && noteDC.CapitalizedClosingCosts != 0 && noteDC.ClosingDate <= SelectedMaturityDateLatest)
            {
                TransactionEntry transaction = new TransactionEntry();
                transaction.Date = noteDC.ClosingDate;
                transaction.Amount = Convert.ToDecimal(noteDC.CapitalizedClosingCosts) * -1;
                transaction.Type = "CapitalizedClosingCost";
                transaction.AnalysisID = noteDC.AnalysisID;
                lstTransaction.Add(transaction);
            }


            foreach (PIKInterestTab pik in ListPIKInterestTab)
            {
                if (pik.PIKInterestonBusinessAdjInterestAccrualEndDate != null && pik.PIKInterestonBusinessAdjInterestAccrualEndDate != 0)
                {
                    TransactionEntry pikprifund = new TransactionEntry();
                    TransactionEntry pikinte = new TransactionEntry();
                    TransactionEntry pikintpaid = new TransactionEntry();
                    TransactionEntry pikprinpaid = new TransactionEntry();
                    TransactionEntry pikintcalc = new TransactionEntry();
                    DateTime? paydate = DateTime.MinValue;
                    if (pik.Date == SelectedMaturityDateLatest.Value)
                    {
                        paydate = SelectedMaturityDateLatest.Value;
                    }
                    else
                    {
                        //paydate = GetPaymentdateByDateForPikTransactions(pik.Date);
                        paydate = pik.Date;
                    }
                    pikprifund.Date = paydate;
                    pikprifund.Amount = pik.PIKInterestPaidAppliedForThePeriod * -1;
                    pikprifund.Type = "PIKPrincipalFunding";
                    pikprifund.FeeName = pik.PIKReasonCodeText;
                    pikprifund.Comment = pik.PIKComments;
                    pikprifund.AnalysisID = noteDC.AnalysisID;
                    lstTransaction.Add(pikprifund);

                    pikinte.Date = paydate;
                    pikinte.PaymentDateNotAdjustedforWorkingDay = GetPMTDateNotAdjustedforBusinessDay(Convert.ToDateTime(paydate), PaymentDayOfMonth);
                    pikinte.Amount = pik.PIKInterestPaidAppliedForThePeriod;
                    pikinte.Type = "PIKInterest";
                    pikinte.FeeName = pik.PIKReasonCodeText;
                    pikinte.Comment = pik.PIKComments;
                    pikinte.AnalysisID = noteDC.AnalysisID;
                    lstTransaction.Add(pikinte);

                    if (pik.PIKInterestPaidForThePeriod != null && pik.PIKInterestPaidForThePeriod != 0)
                    {
                        pikintpaid.Date = paydate;
                        pikintpaid.PaymentDateNotAdjustedforWorkingDay = GetPMTDateNotAdjustedforBusinessDay(Convert.ToDateTime(paydate), PaymentDayOfMonth);
                        pikintpaid.Amount = pik.PIKInterestPaidForThePeriod;
                        pikintpaid.Type = "PIKInterestPaid";
                        pikintpaid.FeeName = pik.PIKReasonCodeText;
                        pikintpaid.Comment = pik.PIKComments;
                        pikintpaid.AnalysisID = noteDC.AnalysisID;
                        lstTransaction.Add(pikintpaid);
                    }

                    if (pik.PIKPrincipalPaidForThePeriod != null && pik.PIKPrincipalPaidForThePeriod != 0)
                    {
                        pikprinpaid.Date = paydate;
                        pikprinpaid.Amount = pik.PIKPrincipalPaidForThePeriod;
                        pikprinpaid.PaymentDateNotAdjustedforWorkingDay = GetPMTDateNotAdjustedforBusinessDay(Convert.ToDateTime(paydate), PaymentDayOfMonth);
                        pikprinpaid.Type = "PIKPrincipalPaid";
                        pikprinpaid.FeeName = pik.PIKReasonCodeText;
                        pikprinpaid.Comment = pik.PIKComments;
                        pikprinpaid.AnalysisID = noteDC.AnalysisID;
                        lstTransaction.Add(pikprinpaid);
                    }
                }
            }

            foreach (FeeOutputDataContract fodc in ListFeeOutput)
            {
                stripedamount = 0;
                if (fodc.FeeNameTransText != "")
                {
                    string feetype = GetFeeName(fodc.FeeNameTransText);
                    if (fodc.FeeAmount != null && fodc.FeeAmount != 0 && fodc.FeeCouponReceivable == 0)
                    {
                        TransactionEntry transaction = new TransactionEntry();
                        transaction.Date = fodc.Date;
                        transaction.Amount = fodc.FeeAmount;
                        if (feetype != "OriginationFee")
                        {
                            transaction.Type = feetype + "ExcludedFromLevelYield";
                        }
                        else
                        {
                            transaction.Type = feetype;
                        }
                        transaction.FeeName = fodc.FeeName;
                        transaction.FeeTypeName = fodc.FeeType;
                        transaction.AnalysisID = noteDC.AnalysisID;
                        lstTransaction.Add(transaction);
                    }

                    if (fodc.FeeAmountStripped != 0 && fodc.FeeAmountStripped != null)
                    {
                        TransactionEntry transaction = new TransactionEntry();
                        transaction.Date = fodc.Date;
                        transaction.Amount = fodc.FeeAmountStripped * -1;
                        stripedamount = fodc.FeeAmountStripped;

                        if (feetype != "OriginationFee")
                        {
                            if (feetype == "AdditionalFees")
                            {
                                transaction.Type = "AddlFeesStrippingExcldfromLevelYield";
                            }
                            else
                            {
                                transaction.Type = feetype + "StrippingExcldfromLevelYield";
                            }
                        }
                        else
                        {
                            transaction.Type = feetype + "Stripping";
                        }
                        transaction.AnalysisID = noteDC.AnalysisID;
                        transaction.FeeTypeName = fodc.FeeType;
                        transaction.FeeName = fodc.FeeName;
                        lstTransaction.Add(transaction);
                    }

                    if (fodc.FeeAmountinclinLY != 0 && fodc.FeeAmountinclinLY != null && fodc.FeeCouponReceivable == 0)
                    {
                        TransactionEntry transaction = new TransactionEntry();
                        transaction.Date = fodc.Date;
                        transaction.Amount = fodc.FeeAmountinclinLY + stripedamount.GetValueOrDefault(0);
                        transaction.Type = feetype + "IncludedInLevelYield";
                        transaction.AnalysisID = noteDC.AnalysisID;
                        transaction.FeeTypeName = fodc.FeeType;
                        transaction.FeeName = fodc.FeeName;
                        lstTransaction.Add(transaction);
                    }
                }
            }

            foreach (NotePeriodicOutputsDataContract npdc in ListSpreadandLibor)
            {
                if (npdc.PeriodEndDate != null)
                {
                    if (npdc.LIBORPercentage != 0 && npdc.LIBORPercentage != null && npdc.PeriodEndDate.Value.Date == SelectedMaturityDateLatest.Value.Date)
                    {
                        isMaturityDate = true;
                    }
                }

                if (npdc.LIBORPercentage != null)
                {
                    TransactionEntry transaction = new TransactionEntry();
                    transaction.Date = npdc.PeriodEndDate;
                    transaction.Amount = npdc.LIBORPercentage.GetValueOrDefault(0);
                    transaction.Type = "LIBORPercentage";
                    transaction.AnalysisID = noteDC.AnalysisID;
                    lstTransaction.Add(transaction);
                }

                if (npdc.SpreadPercentage != 0 && npdc.SpreadPercentage != null)
                {
                    TransactionEntry transaction = new TransactionEntry();
                    transaction.Date = npdc.PeriodEndDate;
                    transaction.Amount = npdc.SpreadPercentage;
                    transaction.Type = "SpreadPercentage";
                    transaction.AnalysisID = noteDC.AnalysisID;
                    lstTransaction.Add(transaction);
                }
                if (npdc.PIKInterestPercentage != 0 && npdc.PIKInterestPercentage != null)
                {
                    TransactionEntry transaction = new TransactionEntry();
                    transaction.Date = npdc.PeriodEndDate;
                    transaction.Amount = npdc.PIKInterestPercentage;
                    transaction.Type = "PIKInterestPercentage";
                    transaction.AnalysisID = noteDC.AnalysisID;
                    lstTransaction.Add(transaction);
                }
                if (npdc.PIKLiborPercentage != 0 && npdc.PIKLiborPercentage != null)
                {
                    TransactionEntry transaction = new TransactionEntry();
                    transaction.Date = npdc.PeriodEndDate;
                    transaction.Amount = npdc.PIKLiborPercentage;
                    transaction.Type = "PIKLiborPercentage";
                    transaction.AnalysisID = noteDC.AnalysisID;
                    lstTransaction.Add(transaction);
                }
            }

            if (noteDC.ListFeeCouponStripReceivable != null)
            {
                if (noteDC.ListFeeCouponStripReceivable.Count > 0)
                {
                    foreach (FeeCouponStripReceivableTab csr in noteDC.ListFeeCouponStripReceivable)
                    {
                        if (csr.TransactionName != "" && csr.TransactionName != null)
                        {
                            string feetype = csr.TransactionName.Replace(" ", string.Empty);
                            TransactionEntry transaction = new TransactionEntry();
                            transaction.Date = csr.Date;
                            transaction.Amount = csr.Value;
                            transaction.Type = feetype + "StripReceivable";
                            transaction.AnalysisID = noteDC.AnalysisID;
                            transaction.FeeName = csr.FeeName;
                            lstTransaction.Add(transaction);
                        }
                    }
                }
            }

            //Yields
            if (noteDC.CalculationModeText == "Cash Flow Only" && noteDC.ClosingDate <= SelectedMaturityDateLatest && ListYields.Count > 0)
            {
                foreach (YieldDataContract yld in ListYields)
                {
                    TransactionEntry transaction = new TransactionEntry();
                    transaction.Date = yld.EffectiveDate;
                    transaction.Amount = Convert.ToDecimal(yld.Yield);
                    transaction.Type = yld.YieldType;
                    transaction.AnalysisID = noteDC.AnalysisID;
                    lstTransaction.Add(transaction);
                }
            }

            if (!isMaturityDate)
            {
                if (noteDC.RateType != 139)
                {                    // libor and spread at  Maturity Date
                    lstTransaction.AddRange(GenerateLiborandSpreadTransaction(SelectedMaturityDateLatest.Value.Date));
                }
            }
            isMaturityDate = false;
            //AccruedInterestSuspense
            if (Todaysdate <= SelectedMaturityDateLatest)
            {
                suspensedate = Todaysdate.Date;
            }
            else
            {
                suspensedate = SelectedMaturityDateLatest.Value.Date;
                isMaturityDate = true;
            }

            decimal? exitamount = 0;
            decimal? extensionamount = 0;
            decimal? Preamount = 0;
            decimal? unusedamount = 0;
            decimal? schpri = 0;
            DateTime usedsuspensedate = DateTime.MinValue;
            if (noteDC.ListServicingLogTab != null)
            {
                decimal? amount = 0;

                TransactionEntry transaction = new TransactionEntry();
                if (isMaturityDate)
                {
                    transaction.Date = suspensedate;
                }
                else
                {
                    transaction.Date = GetAccruedInterestSuspenseDate(suspensedate);
                }
                usedsuspensedate = transaction.Date.Value.Date;
                transaction.Type = "AccruedInterestSuspense";
                transaction.AnalysisID = noteDC.AnalysisID;
                foreach (ServicingLogTab sld in noteDC.ListServicingLogTab)
                {
                    if (sld.TransactionDate <= suspensedate)
                    {
                        if (sld.TransactionTypeText == "InterestPaid" || sld.TransactionTypeText == "StubInterest" || sld.TransactionTypeText == "FloatInterest"
                            || sld.TransactionTypeText == "PIKInterestPaid" || sld.TransactionTypeText == "PurchasedInterest")
                        {
                            if (sld.ActualDelta != 0 && sld.ActualDelta != null)
                            {
                                amount = amount + sld.ActualDelta.GetValueOrDefault(0);
                            }
                        }
                        else if (sld.TransactionTypeText == "ExitFeeExcludedFromLevelYield" || sld.TransactionTypeText == "ExitFeeIncludedInLevelYield" ||
                                   sld.TransactionTypeText == "ExitFeeStrippingExcldfromLevelYield" || sld.TransactionTypeText == "ExitFeeStripReceivable")
                        {
                            exitamount = exitamount + sld.ActualDelta.GetValueOrDefault(0);
                        }
                        else if (sld.TransactionTypeText == "ExtensionFeeExcludedFromLevelYield" || sld.TransactionTypeText == "ExtensionFeeIncludedInLevelYield"
                            || sld.TransactionTypeText == "ExtensionFeeStrippingExcldfromLevelYield" || sld.TransactionTypeText == "ExtensionFeeStripReceivable")
                        {
                            extensionamount = extensionamount + sld.ActualDelta.GetValueOrDefault(0);
                        }
                        else if (sld.TransactionTypeText == "PrepaymentFeeExcludedFromLevelYield")
                        {
                            Preamount = Preamount + sld.ActualDelta.GetValueOrDefault(0);
                        }
                        else if (sld.TransactionTypeText == "UnusedFeeExcludedFromLevelYield")
                        {
                            unusedamount = unusedamount + sld.ActualDelta.GetValueOrDefault(0);
                        }
                        else if (sld.TransactionTypeText == "ScheduledPrincipalPaid")
                        {
                            schpri = schpri + sld.ActualDelta.GetValueOrDefault(0);
                        }
                    }
                }
                if (amount != 0)
                {
                    transaction.Amount = amount.GetValueOrDefault(0) * -1;
                    lstTransaction.Add(transaction);
                }

            }
            lstTransaction = lstTransaction.OrderBy(x => x.Type).ToList();
            noteDC.ListCashflowTransactionEntry = lstTransaction;
            // add supense account for others
            AddTotransactionentryList(usedsuspensedate, exitamount * -1, "AccruedExitFeeSuspense");
            AddTotransactionentryList(usedsuspensedate, extensionamount * -1, "AccruedExtensionFeeSuspense");
            AddTotransactionentryList(usedsuspensedate, Preamount * -1, "AccruedPrepaymentFeeSuspense");
            AddTotransactionentryList(usedsuspensedate, unusedamount * -1, "AccruedUnusedFeeSuspense");
            AddTotransactionentryList(usedsuspensedate, schpri * -1, "AccruedScheduledPrincipalPaidSuspense");

            noteDC.ListDailyInterestAccruals = listdailint;
            noteDC.ListPeriodicInterestRateUsed = listrateused;

        }

        public void AddTotransactionentryList(DateTime transdt, decimal? amt, string trnstype)
        {
            if (amt != 0)
            {
                TransactionEntry transaction = new TransactionEntry();
                transaction.Date = transdt;
                transaction.Amount = amt;
                transaction.Type = trnstype;
                transaction.AnalysisID = noteDC.AnalysisID;
                noteDC.ListCashflowTransactionEntry.Add(transaction);
            }
        }
        public DateTime GetPMTDateNotAdjustedforBusinessDay(DateTime currentdate, int PaymentDayOfMonth)
        {
            int DayOfMonth = 0;
            if (PaymentDayOfMonth != 0)
            {
                DayOfMonth = PaymentDayOfMonth;
            }
            else
            {
                if (noteDC.FirstPaymentDate != null)
                {
                    if (noteDC.FirstPaymentDate != DateTime.MinValue)
                    {
                        DayOfMonth = noteDC.FirstPaymentDate.Value.Day;
                    }
                }
            }
            currentdate = CreateNewDate(currentdate.Year, currentdate.Month, DayOfMonth);
            return currentdate;
        }

        public int GetPaymentDayOfMonth()
        {
            int PaymentDayOfMonth = 0;
            if (ListDatesTab != null)
            {
                PaymentDayOfMonth = ListDatesTab[0].PaymentDateusingAccrualFreqNotAdjustedforBusinessDay.Value.Day;
            }
            return PaymentDayOfMonth;
        }

        public List<TransactionEntry> GenerateLiborandSpreadTransaction(DateTime date)
        {
            List<TransactionEntry> lstTransaction = new List<TransactionEntry>();
            bool datefound = false;
            foreach (var item in ListSpreadandLibor)
            {
                if (item.PeriodEndDate.Value.Date == date)
                {
                    datefound = true;
                    break;
                }
            }
            if (datefound == false)
            {
                decimal spreadper = 0;
                decimal liborper = 0;

                var liborlist = ListRateTab.FindAll(x => x.rateDate == date.Date).First();

                if (liborlist != null)
                {
                    if (liborlist.RateType == "Rate")
                    {
                        if (liborlist.CouponRate.GetValueOrDefault(0) != 0)
                        {
                            spreadper = spreadper + liborlist.CouponRate.GetValueOrDefault(0);

                        }
                        else
                        {
                            spreadper = spreadper + liborlist.CouponSpread.GetValueOrDefault(0);
                        }

                    }
                    else
                    {
                        liborper = liborlist.DIndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0);
                        spreadper = liborlist.CouponSpread.GetValueOrDefault(0);
                    }
                    TransactionEntry transactionl = new TransactionEntry();
                    transactionl.Date = date;
                    transactionl.Amount = liborper;
                    transactionl.Type = "LIBORPercentage";
                    transactionl.AnalysisID = noteDC.AnalysisID;
                    lstTransaction.Add(transactionl);

                    TransactionEntry transactions = new TransactionEntry();
                    transactions.Date = date;
                    transactions.Amount = spreadper;
                    transactions.Type = "SpreadPercentage";
                    transactions.AnalysisID = noteDC.AnalysisID;
                    lstTransaction.Add(transactions);

                    if (liborlist.AllInPIKInterest != null && liborlist.AllInPIKInterest != 0)
                    {
                        TransactionEntry transactionp = new TransactionEntry();
                        transactionp.Date = date;
                        transactionp.Amount = liborlist.AllInPIKInterest.GetValueOrDefault(0);
                        transactionp.Type = "PIKInterestPercentage";
                        transactionp.AnalysisID = noteDC.AnalysisID;
                        lstTransaction.Add(transactionp);
                    }
                }
            }
            return lstTransaction;
        }

        public string GetFeeName(string feename)
        {
            string feetype = feename;
            feetype = feename.Replace(" ", string.Empty);

            if (feetype.Contains("Additional"))
            {
                feetype = "AdditionalFees";
            }
            if (feetype.Contains("ExitFee"))
            {
                feetype = "ExitFee";
            }
            return feetype;
        }

        public decimal GetValueFromCouponSchedule(string ttype, DateTime effectivedate)
        {
            decimal value = 0;

            foreach (RateSpreadSchedule rsp in noteDC.RateSpreadScheduleList)
            {
                if (rsp.EffectiveDate == effectivedate && rsp.Date == effectivedate && rsp.ValueTypeText == ttype)
                {
                    value = Convert.ToDecimal(rsp.Value);
                }
            }

            return value;
        }

        public string GetIntCalcMethodFromCouponSchedule(DateTime effectivedate)
        {
            string value = "Actual/360";

            foreach (RateSpreadSchedule rsp in noteDC.RateSpreadScheduleList)
            {
                if (rsp.EffectiveDate == effectivedate && rsp.Date == effectivedate && (rsp.ValueTypeText == "Rate" || rsp.ValueTypeText == "Spread"))
                {
                    value = rsp.IntCalcMethodText;
                    break;
                }
            }

            return value;
        }

        public DateTime? BusinessDayAdjustmentExcludeHoliday(DateTime? refdate)
        {
            if (refdate != null)
            {
                if (refdate.Value.DayOfWeek == DayOfWeek.Saturday)
                    refdate = refdate.Value.AddDays(-1);
                if (refdate.Value.DayOfWeek == DayOfWeek.Sunday)
                    refdate = refdate.Value.AddDays(-2);
            }

            return refdate;
        }

        #endregion Common

        public void CalculateFinancingTab(DateTime effectiveDate)
        {
            int? fdaylag = 0;

            int? fyear = 0;
            int? fmo = 0;
            int? fday = 0;

            decimal? findraw = 0;
            decimal? cumfinint = 0;

            List<DateTime> FinDates = new List<DateTime>();
            List<decimal> FinCFs = new List<decimal>();

            fdaylag = noteDC.NumberOfBusinessDaysLagForFinancingDraw.GetValueOrDefault(0);

            FinDates.Add(Convert.ToDateTime(noteDC.ClosingDate));
            FinCFs.Add(-0.000001m);

            //foreach (var Financing in ListFinancingTab)
            for (int i = 0; i < ListFinancingTab.Count; i++)
            {
                //Beginning Financing Balance
                if (i == 0)
                {
                    ListFinancingTab[i].BeginningFinancingBalance = 0;
                }
                else
                {
                    ListFinancingTab[i].BeginningFinancingBalance = ListFinancingTab[i - 1].EndingFinancingBalance;
                }

                //Financing Draws / Curtailments from Financing Draws Schedule
                findraw = 0;
                findraw = ListFinancingDrawsTab.Where(x => x.Date == ListFinancingTab[i].Date).Sum(c => c.FinancingDrawsCurtailments.GetValueOrDefault(0));
                ListFinancingTab[i].FinancingDrawsCurtailmentsfromFinancingDrawsSchedule = findraw;

                //Financing Draws / Curtailments associated with Future Funding Schedule
                findraw = 0;
                if (noteDC.ModelFinancingDrawsForFutureFundingsText == "Y")
                {
                    findraw = noteDC.ListFutureFundingScheduleTab.Where(x => Convert.ToDateTime(x.Date).AddDays(Convert.ToDouble(fdaylag.GetValueOrDefault(0))) == ListFinancingTab[i].Date && x.EffectiveDate == effectiveDate)
                       .Select((v, currindex) => new { ffvalue = v.Value, ffDate = v.Date, currindex = i })
                       .Sum(
                       c => c.ffvalue.GetValueOrDefault(0) * ListRateTab.Where(y => y.rateDate == c.ffDate).Select(u => u.FinancingAdvanceRate.GetValueOrDefault(0)).FirstOrDefault()
                       );
                }
                ListFinancingTab[i].FinancingDrawsCurtailmentsassociatedwithFutureFundingSchedule = findraw;
                //Financing Balloon
                decimal? BalloonPayment = 0;
                BalloonPayment = ListBalanceTab.Where(y => y.Date == ListFinancingTab[i].Date).Select(u => u.BalloonPayment.GetValueOrDefault(0)).FirstOrDefault();
                if (BalloonPayment != 0)
                {
                    ListFinancingTab[i].FinancingBalloon = -(ListFinancingTab[i].BeginningFinancingBalance.GetValueOrDefault(0) + ListFinancingTab[i].FinancingDrawsCurtailmentsfromFinancingDrawsSchedule.GetValueOrDefault(0) + ListFinancingTab[i].FinancingDrawsCurtailmentsassociatedwithFutureFundingSchedule.GetValueOrDefault(0));
                }

                //Ending Financing Balance
                ListFinancingTab[i].EndingFinancingBalance =
                    ListFinancingTab[i].BeginningFinancingBalance.GetValueOrDefault(0) + ListFinancingTab[i].FinancingDrawsCurtailmentsfromFinancingDrawsSchedule.GetValueOrDefault(0) +
                    ListFinancingTab[i].FinancingDrawsCurtailmentsassociatedwithFutureFundingSchedule.GetValueOrDefault(0) +
                    ListFinancingTab[i].FinancingBalloon.GetValueOrDefault(0);

                //Financing Interest Expense
                decimal? AllinFinancingCOF = 0;
                AllinFinancingCOF = ListRateTab.Where(y => y.rateDate == ListFinancingTab[i].Date).Select(u => u.AllinFinancingCOF.GetValueOrDefault(0)).FirstOrDefault();
                ListFinancingTab[i].FinancingInterestExpense = ListFinancingTab[i].EndingFinancingBalance.GetValueOrDefault(0) * AllinFinancingCOF / 360;
                //Cum Financing Interest
                //Financing Interest Payment Date
                fyear = Convert.ToDateTime(ListFinancingTab[i].Date).Year;
                fmo = Convert.ToDateTime(ListFinancingTab[i].Date).Month;
                //issue (ws_assumptions.Range("B108").Value) financing table
                int financingDay = 0; //temp variable
                fday = financingDay + 1;
                DateTime WorkDay = GetnextWorkingDays(CreateNewDate(Convert.ToInt32(fyear), Convert.ToInt32(fmo), Convert.ToInt32(fday)), -1, DisableBusinessDayAdjustmentText);
                if (ListFinancingTab[i].Date == WorkDay)
                {
                    ListFinancingTab[i].FinancingInterestPaymentDate = 1;
                    //Fin Interest Paid
                    ListFinancingTab[i].FinancingInterestPaid = cumfinint + ListFinancingTab[i].FinancingInterestExpense.GetValueOrDefault(0);
                    cumfinint = 0;
                }
                else
                {
                    ListFinancingTab[i].FinancingInterestPaymentDate = 0;
                    ListFinancingTab[i].FinancingInterestPaid = 0;
                    cumfinint = cumfinint + ListFinancingTab[i].FinancingInterestExpense;
                }

                //Cum Financing Interest
                ListFinancingTab[i].CumFinancingInterest = cumfinint;

                //Financing Fees Paid
                decimal? feesTab_NewAdditionalFees = 0;
                decimal? feesTab_PrepaymentExitFees = 0;

                var ws_fees = ListFeesTab.Where(y => y.Date == ListFinancingTab[i].Date).Select(u => new { NewAdditionalFees = u.NewAdditionalFees.GetValueOrDefault(0), PrepaymentExitFees = u.PrepaymentExitFees.GetValueOrDefault(0) });
                feesTab_NewAdditionalFees = ws_fees.Select(x => x.NewAdditionalFees).FirstOrDefault();
                feesTab_PrepaymentExitFees = ws_fees.Select(x => x.PrepaymentExitFees).FirstOrDefault();

                ListFinancingTab[i].FinancingFeesPaid = -ListFinancingTab[i].EndingFinancingBalance * (feesTab_NewAdditionalFees) + ListFinancingTab[i].FinancingBalloon * (feesTab_PrepaymentExitFees);

                //Total Levered Cash Flows
                decimal? GAAPBasisTab_CashFlowusedforLevelYieldAmort = 0;

                GAAPBasisTab_CashFlowusedforLevelYieldAmort = ListGAAPBasisTab.Where(y => y.Date == ListFinancingTab[i].Date).Select(u => u.CashFlowusedforLevelYieldAmort.GetValueOrDefault(0)).FirstOrDefault();

                ListFinancingTab[i].TotalLeveredCashFlows = GAAPBasisTab_CashFlowusedforLevelYieldAmort + ListFinancingTab[i].FinancingDrawsCurtailmentsfromFinancingDrawsSchedule.GetValueOrDefault(0) +
                 ListFinancingTab[i].FinancingDrawsCurtailmentsassociatedwithFutureFundingSchedule.GetValueOrDefault(0) + ListFinancingTab[i].FinancingBalloon.GetValueOrDefault(0) -
                 ListFinancingTab[i].FinancingInterestPaid.GetValueOrDefault(0) + ListFinancingTab[i].FinancingFeesPaid.GetValueOrDefault(0);

                FinDates.Add(Convert.ToDateTime(ListFinancingTab[i].Date));
                FinCFs.Add(Convert.ToDecimal(ListFinancingTab[i].TotalLeveredCashFlows));

                //Yield --ws_financing.Range("L5")
                FinancingPeriodLeveredYield = Convert.ToDecimal(cXIRR(FinCFs, FinDates));
            }
        }

        public DateTime? GetDropDateOverride(DateTime? paymentdateadj)
        {
            DateTime? overridedate = null;
            foreach (var dt in noteDC.ListDropDateSetup)
            {
                if (dt.ModeledPMTDropDate != null)
                {
                    if (dt.ModeledPMTDropDate.Value.Date == paymentdateadj.Value.Date)
                    {
                        overridedate = dt.PMTDropDateOverride;
                        break;
                    }
                }
            }

            return overridedate;
        }

        public void CalculateAmortLYIncome(DateTime effectiveDate)
        {
            decimal? premium = 0, capcosts = 0;
            decimal? deferredFees = 0, AccumInterest = 0;
#pragma warning disable CS0219 // The variable 'OrigDferredFees' is assigned but its value is never used
            decimal? OrigDferredFees = 0;
#pragma warning restore CS0219 // The variable 'OrigDferredFees' is assigned but its value is never used
            premium = noteDC.Discount.GetValueOrDefault(0);
            deferredFees = CalcDeferredFees(noteDC.ClosingDate);
            capcosts = noteDC.CapitalizedClosingCosts.GetValueOrDefault(0);
            DateTime matdate = SelectedMaturityDateLatest.Value.Date;

            int i = 1;
            decimal? vCumAccruedCDeferredFeeByDate = 0, vCumAccruedDDiscountFeeByDate = 0, vCumAccruedGCapitalizedCostAccrual = 0;
            if (Convert.ToDateTime(ListGAAPBasisTab[0].Date).Equals(effectiveDate.Date))
            {
                if (noteDC.StubPaidinAdvanceYNText == "Y")
                {
                    ListGAAPBasisTab[0].GAAPIncomeforthePeriod = StubInterestAmount;
                }
                else
                {
                    ListGAAPBasisTab[0].GAAPIncomeforthePeriod = ListCouponTab[0].DailyAccruedInterest.GetValueOrDefault(0);
                }

                ListGAAPBasisTab[0].AmortizedCost = ListGAAPBasisTab[0].CleanCost.GetValueOrDefault(0) + ListGAAPBasisTab[0].AccumAmortofDeferredFees.GetValueOrDefault(0);
                //' GAAP Book Value
                ListGAAPBasisTab[0].EndingGAAPBookValue = ListGAAPBasisTab[0].AmortizedCost.GetValueOrDefault(0) + ListCouponTab[0].AccumInterestforCurrentAccrualPeriod.GetValueOrDefault(0) + ListPIKInterestTab[0].AccumPIKInterestforCurrentAccrualPeriod.GetValueOrDefault();

                ListGAAPBasisTab[0].PVBasis = ListGAAPBasisTab[0].ParBasis - deferredFees + ListGAAPBasisTab[0].AccumAmortofDeferredFees.GetValueOrDefault(0) + premium + capcosts;

                //PV Basis - Period Income & Amort
                ListPVBasisTab[0].PeriodLevelYieldIncomePreCap = ListPVBasisTab[1].CashFlowusedforLevelYieldPreCap.GetValueOrDefault(0) + ListPVBasisTab[1].LockedPreCapBasis.GetValueOrDefault(0) - ListPVBasisTab[0].LockedPreCapBasis.GetValueOrDefault(0);
                //ListPVBasisTab[0].PVAmort = ListPVBasisTab[0].PeriodLevelYieldIncomePreCap.GetValueOrDefault(0) - ListCouponTab[0].DailyAccruedInterest.GetValueOrDefault(0);
                ListPVBasisTab[0].PVAmort = noteDC.IncludeServicingPaymentOverrideinLevelYieldText == "N" ?
                    ListPVBasisTab[0].PeriodLevelYieldIncomePreCap.GetValueOrDefault(0) - ListCouponTab[0].DailyAccruedInterest.GetValueOrDefault(0) - ListPIKInterestTab[0].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0) :
                    ListPVBasisTab[0].PeriodLevelYieldIncomePreCap.GetValueOrDefault(0) - ListCouponTab[0].PMTDropDateDailyAccruedInterest.GetValueOrDefault(0) - ListCouponTab[0].PMTDropDateDailyAccruedInterestAddOn.GetValueOrDefault(0) - ListPIKInterestTab[0].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0);
                ListPVBasisTab[0].AccumPVAmort = ListPVBasisTab[0].PVAmort.GetValueOrDefault(0);

                ListPVBasisTab[0].AccumGAAPAmort = ListPVBasisTab[1].GAAPBasis.GetValueOrDefault(0) - ListPVBasisTab[1].CleanCostLevelYield.GetValueOrDefault(0)
                    - ListCouponTab[0].AccumInterestforCurrentAccrualPeriod.GetValueOrDefault(0) - ListCouponTab[0].PMTDropDateAccumInterestforCurrentAccrualPeriodAddOn.GetValueOrDefault(0) - ListPIKInterestTab[0].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0);
                ListPVBasisTab[0].GAAPAmort = ListPVBasisTab[0].AccumGAAPAmort;
                ListGAAPBasisTab[0].CumCouponPIKInterestDailyAccrual = ListCouponTab[0].AccumInterestforCurrentAccrualPeriod.GetValueOrDefault(0) + ListPIKInterestTab[0].AccumPIKInterestforCurrentAccrualPeriod.GetValueOrDefault(0);
                //' Value Cap
                ListGAAPBasisTab[0].ValueCap = ListGAAPBasisTab[0].AmortizedCost.GetValueOrDefault(0) + ListGAAPBasisTab[0].CumCouponPIKInterestDailyAccrual.GetValueOrDefault(0);

                ListGAAPBasisTab[0].AdjustedBasissubjecttoCap = ListGAAPBasisTab[0].LockedPreCapBasis.GetValueOrDefault(0);
            }

            while (i < ListGAAPBasisTab.Count)
            {
                if (ListGAAPBasisTab[i].Date > DateTime.MinValue && Convert.ToDateTime(ListGAAPBasisTab[i].Date).Date >= effectiveDate)
                {
                    //' Deferred Fee Amort
                    if (ListGAAPBasisTab[i].Date.Value <= AccrualDate)
                    {
                        // ' PV Basis:
                        //ListGAAPBasisTab[i].LockedPreCapBasis = CumAccruedBDeferredFeeByDate(ListGAAPBasisTab[i].Date.Value);
                        ListGAAPBasisTab[i].PVBasis = CumAccruedBDeferredFeeByDate(ListGAAPBasisTab[i].Date.Value);
                        ListGAAPBasisTab[i].AllInBasis = CumAccruedAllInBasisByDate(ListGAAPBasisTab[i].Date.Value);
                        vCumAccruedCDeferredFeeByDate = CumAccruedCDeferredFeeByDate(ListGAAPBasisTab[i].Date.Value);
                        vCumAccruedDDiscountFeeByDate = CumAccruedDDiscountFeeByDate(ListGAAPBasisTab[i].Date.Value);
                        vCumAccruedGCapitalizedCostAccrual = CumAccruedGCapitalizedCostAccrualByDate(ListGAAPBasisTab[i].Date.Value);

                        ListGAAPBasisTab[i].Amort = vCumAccruedCDeferredFeeByDate + vCumAccruedDDiscountFeeByDate;
                        ListGAAPBasisTab[i].PeriodLevelYieldIncomePreCap = ListGAAPBasisTab[i].Amort.GetValueOrDefault(0) + ListCouponTab[i - 1].DailyAccruedInterest.GetValueOrDefault(0) + ListPIKInterestTab[i - 1].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0);

                        ListGAAPBasisTab[i].AmortofDeferredFees = vCumAccruedCDeferredFeeByDate;
                        ListGAAPBasisTab[i].AccumAmortofDeferredFees = ListGAAPBasisTab[i].AmortofDeferredFees.GetValueOrDefault(0) + ListGAAPBasisTab[i - 1].AccumAmortofDeferredFees.GetValueOrDefault(0);

                        ListGAAPBasisTab[i].DiscountPremiumAccrual = vCumAccruedDDiscountFeeByDate;
                        ListGAAPBasisTab[i].AccumulatedAmortofDiscountPremium = ListGAAPBasisTab[i].DiscountPremiumAccrual.GetValueOrDefault(0) + ListGAAPBasisTab[i - 1].AccumulatedAmortofDiscountPremium.GetValueOrDefault(0);
                        //' Capitalized Costs Amort
                        ListGAAPBasisTab[i].CapitalizedCostAccrual = vCumAccruedGCapitalizedCostAccrual;

                        //Accumulated Amort of CapitalizedCost
                        ListGAAPBasisTab[i].AccumulatedAmortofCapitalizedCost = ListGAAPBasisTab[i].CapitalizedCostAccrual.GetValueOrDefault(0) + ListGAAPBasisTab[i - 1].AccumulatedAmortofCapitalizedCost.GetValueOrDefault(0);
                        //' Clean Cost + Accum Deferred Fee Accrual

                        if (ListGAAPBasisTab[i].Date.Value < matdate)
                        {
                            ListGAAPBasisTab[i].AmortizedCost = ListBalanceTab[i].EndingBalance.GetValueOrDefault(0) + premium - deferredFees
                                + ListGAAPBasisTab[i].AccumAmortofDeferredFees.GetValueOrDefault(0) + ListGAAPBasisTab[i].AccumulatedAmortofDiscountPremium.GetValueOrDefault(0)
                                + ListGAAPBasisTab[i].AccumulatedAmortofCapitalizedCost.GetValueOrDefault(0);
                        }
                        else
                        {
                            ListGAAPBasisTab[i].AmortizedCost = 0;
                        }
                    }
                    else
                    {
                        #region PV Basis
                        //PV Basis - Period Income & Amort
                        ListPVBasisTab[i].PeriodLevelYieldIncomePreCap = i + 1 >= ListPVBasisTab.Count ? 0 :
                            ListPVBasisTab[i + 1].CashFlowusedforLevelYieldPreCap.GetValueOrDefault(0) + ListPVBasisTab[i + 1].LockedPreCapBasis.GetValueOrDefault(0) - ListPVBasisTab[i].LockedPreCapBasis.GetValueOrDefault(0);
                        //ListPVBasisTab[i].AmortIncomeMethod = ListPVBasisTab[i].PeriodLevelYieldIncomePreCap.GetValueOrDefault(0) - ListCouponTab[i].DailyAccruedInterest.GetValueOrDefault(0) - ListPIKInterestTab[i].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0);
                        if (noteDC.IncludeServicingPaymentOverrideinLevelYieldText == "Y")
                            ListPVBasisTab[i].PVAmort = ListPVBasisTab[i].Date < matdate ?
                                ListPVBasisTab[i].PeriodLevelYieldIncomePreCap.GetValueOrDefault(0) - ListCouponTab[i].PMTDropDateDailyAccruedInterest.GetValueOrDefault(0) - ListCouponTab[i].PMTDropDateDailyAccruedInterestAddOn.GetValueOrDefault(0) - ListPIKInterestTab[i].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0) : 0;
                        else
                            ListPVBasisTab[i].PVAmort = ListPVBasisTab[i].Date < matdate ?
                                ListPVBasisTab[i].PeriodLevelYieldIncomePreCap.GetValueOrDefault(0) - ListCouponTab[i].DailyAccruedInterest.GetValueOrDefault(0) - ListPIKInterestTab[i].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0) : 0;

                        ListPVBasisTab[i].AccumPVAmort = ListPVBasisTab[i].Date < matdate ? ListPVBasisTab[i].Date >= matdate ? 0 : ListPVBasisTab[i - 1].AccumPVAmort.GetValueOrDefault(0) + ListPVBasisTab[i].PVAmort.GetValueOrDefault(0) : 0;

                        //PV Basis - Back Out Accum Amort and Calculate PV Amort
                        //decimal? CouponPayment = 0;
                        AccumInterest = noteDC.IncludeServicingPaymentOverrideinLevelYieldText == "N" ?
                            ListCouponTab[i].AccumInterestforCurrentAccrualPeriod.GetValueOrDefault(0) :
                            ListCouponTab[i].PMTDropDateAccumInterestforCurrentAccrualPeriod.GetValueOrDefault(0) + ListCouponTab[i].PMTDropDateAccumInterestforCurrentAccrualPeriodAddOn.GetValueOrDefault(0);

                        ListPVBasisTab[i].AccumGAAPAmort = ListPVBasisTab[i].Date >= matdate ? 0 :
                            ListPVBasisTab[i + 1].GAAPBasis - ListPVBasisTab[i + 1].CleanCostLevelYield.GetValueOrDefault(0)
                            //- ListCouponTab[i].AccumInterestforCurrentAccrualPeriod.GetValueOrDefault(0)
                            - AccumInterest
                            - ListPIKInterestTab[i].AccumPIKInterestforCurrentAccrualPeriod.GetValueOrDefault(0);
                        //+ (ListPVBasisTab[i].Date >= this.stubEndDate ? 0 : this.StubInterestAmount);

                        ListPVBasisTab[i].GAAPAmort = ListPVBasisTab[i].Date >= matdate ? 0 : ListPVBasisTab[i].AccumGAAPAmort.GetValueOrDefault(0) - ListPVBasisTab[i - 1].AccumGAAPAmort.GetValueOrDefault(0);

                        #endregion PV Basis

                        //GAAP Basis - Deferred Fee Amort
                        if ((deferredFees != 0 || ListGAAPBasisTab[0].GrossDeferredFees.GetValueOrDefault(0) != 0) && ListGAAPBasisTab[i - 1].DeferredFeeAccrualBasis.GetValueOrDefault(0) != 0 && Math.Round(ListGAAPBasisTab[i].DeferredFeeAccrualBasis.GetValueOrDefault(0) - ListGAAPBasisTab[i - 1].DeferredFeeAccrualBasis.GetValueOrDefault(0), 2) != 0)
                        {
                            ListGAAPBasisTab[i].AmortofDeferredFees = ListGAAPBasisTab[i].NetPrincipalInflowOutflow.GetValueOrDefault(0) +
                                ListGAAPBasisTab[i].DeferredFeeAccrualBasis.GetValueOrDefault(0) -
                                ListGAAPBasisTab[i - 1].DeferredFeeAccrualBasis.GetValueOrDefault(0)
                                + ListFeesTab[i].FeeAmountIncludedinLevelYield.GetValueOrDefault(0)
                                + ListFeesTab[i].StrippedFeeReceivableInclInLY.GetValueOrDefault(0);
                        }
                        else
                        {
                            ListGAAPBasisTab[i].AmortofDeferredFees = 0;
                        }
                        //GAAP Basis - Discount Amort
                        if (ListGAAPBasisTab[i - 1].DiscountPremiumAccrualBasis != 0 && ListGAAPBasisTab[i - 1].DiscountPremiumAccrualBasis != null)
                        {
                            ListGAAPBasisTab[i].DiscountPremiumAccrual = ListGAAPBasisTab[i].NetPrincipalInflowOutflow.GetValueOrDefault(0) + ListGAAPBasisTab[i].DiscountPremiumAccrualBasis.GetValueOrDefault(0) - ListGAAPBasisTab[i - 1].DiscountPremiumAccrualBasis.GetValueOrDefault(0);
                        }
                        else
                        {
                            ListGAAPBasisTab[i].DiscountPremiumAccrual = 0.0M;
                        }
                        //GAAP Basis - Capitalized Costs Amort
                        if (ListGAAPBasisTab[i - 1].CapitalizedCostsAccrualBasis != 0 && ListGAAPBasisTab[i - 1].CapitalizedCostsAccrualBasis != null)
                        {
                            ListGAAPBasisTab[i].CapitalizedCostAccrual = ListGAAPBasisTab[i].NetPrincipalInflowOutflow.GetValueOrDefault(0) + ListGAAPBasisTab[i].CapitalizedCostsAccrualBasis.GetValueOrDefault(0) - ListGAAPBasisTab[i - 1].CapitalizedCostsAccrualBasis.GetValueOrDefault(0);
                        }
                        else
                        {
                            ListGAAPBasisTab[i].CapitalizedCostAccrual = 0.0M;
                        }

                        //GAAP Basis -  Accum Amort of Deferred Fees
                        if (i == 0)
                        {
                            ListGAAPBasisTab[i].AccumAmortofDeferredFees = ListGAAPBasisTab[i].AmortofDeferredFees.GetValueOrDefault(0);
                            ListGAAPBasisTab[i].AccumulatedAmortofDiscountPremium = ListGAAPBasisTab[i].DiscountPremiumAccrual.GetValueOrDefault(0);
                            ListGAAPBasisTab[i].AccumulatedAmortofCapitalizedCost = ListGAAPBasisTab[i].CapitalizedCostAccrual.GetValueOrDefault(0);
                        }
                        else
                        {
                            ListGAAPBasisTab[i].AccumAmortofDeferredFees = ListGAAPBasisTab[i].AmortofDeferredFees.GetValueOrDefault(0) + ListGAAPBasisTab[i - 1].AccumAmortofDeferredFees.GetValueOrDefault(0);
                            ListGAAPBasisTab[i].AccumulatedAmortofDiscountPremium = ListGAAPBasisTab[i].DiscountPremiumAccrual.GetValueOrDefault(0) + ListGAAPBasisTab[i - 1].AccumulatedAmortofDiscountPremium.GetValueOrDefault(0);
                            ListGAAPBasisTab[i].AccumulatedAmortofCapitalizedCost = ListGAAPBasisTab[i].CapitalizedCostAccrual.GetValueOrDefault(0) + ListGAAPBasisTab[i - 1].AccumulatedAmortofCapitalizedCost.GetValueOrDefault(0);
                        }

                        //Applying true-up on Amort
                        if (ListGAAPBasisTab[i].Date.Value == matdate && i > 0)
                        {
                            ListGAAPBasisTab[i].AmortofDeferredFees += deferredFees - ListGAAPBasisTab[i].AccumAmortofDeferredFees;
                            ListGAAPBasisTab[i].DiscountPremiumAccrual += premium * -1.0M - ListGAAPBasisTab[i].AccumulatedAmortofDiscountPremium.GetValueOrDefault(0);
                            ListGAAPBasisTab[i].CapitalizedCostAccrual += capcosts * -1.0M - ListGAAPBasisTab[i].AccumulatedAmortofCapitalizedCost.GetValueOrDefault(0);

                            ListGAAPBasisTab[i].AccumAmortofDeferredFees = deferredFees;
                            ListGAAPBasisTab[i].AccumulatedAmortofDiscountPremium = premium * -1.0M;
                            ListGAAPBasisTab[i].AccumulatedAmortofCapitalizedCost = capcosts * -1.0M;
                        }

                        if (ListGAAPBasisTab[i].Date.Value < matdate)
                        {
                            ListGAAPBasisTab[i].AmortizedCost = ListGAAPBasisTab[i].CleanCost.GetValueOrDefault(0) + ListGAAPBasisTab[i].AccumAmortofDeferredFees.GetValueOrDefault(0) + ListGAAPBasisTab[i].AccumulatedAmortofDiscountPremium.GetValueOrDefault(0) + ListGAAPBasisTab[i].AccumulatedAmortofCapitalizedCost.GetValueOrDefault(0);

                            if (noteDC.IncludeServicingPaymentOverrideinLevelYieldText == "Y")
                            {
                                ListGAAPBasisTab[i].CumCouponPIKInterestDailyAccrual = ListGAAPBasisTab[i - 1].CumCouponPIKInterestDailyAccrual.GetValueOrDefault(0) + ListCouponTab[i].DailyAccruedInterest.GetValueOrDefault(0) - ListCouponTab[i].InterestPaidperServicing.GetValueOrDefault(0) + ListCouponTab[i].CouponbasedonFutureFunding.GetValueOrDefault(0)
                                              + ListPIKInterestTab[i].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0)
                                              - ListPIKInterestTab[i].PIKInterestforthePeriod.GetValueOrDefault(0);
                            }
                            else
                            {
                                ListGAAPBasisTab[i].CumCouponPIKInterestDailyAccrual = ListGAAPBasisTab[i - 1].CumCouponPIKInterestDailyAccrual.GetValueOrDefault(0) + ListCouponTab[i].DailyAccruedInterest.GetValueOrDefault(0)
                                    - ListCouponTab[i].InterestforthePeriod.GetValueOrDefault(0) + ListCouponTab[i].CouponbasedonFutureFunding.GetValueOrDefault(0)
                                    + ListPIKInterestTab[i].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0) - ListPIKInterestTab[i].PIKInterestforthePeriod.GetValueOrDefault(0);
                            }

                            // ' Value Cap
                            ListGAAPBasisTab[i].ValueCap = Convert.ToDecimal(Math.Max((ListGAAPBasisTab[i].AmortizedCost.GetValueOrDefault(0) + ListGAAPBasisTab[i].CumCouponPIKInterestDailyAccrual.GetValueOrDefault(0)), 0));
                            //' PV Basis
                            ListGAAPBasisTab[i].PVBasis = ListGAAPBasisTab[i].ParBasis.GetValueOrDefault(0)
                                - ListGAAPBasisTab[i].GrossDeferredFees.GetValueOrDefault(0)
                                + ListGAAPBasisTab[i].AccumAmortofDeferredFees.GetValueOrDefault(0)
                                + premium.GetValueOrDefault(0) - ListGAAPBasisTab[i].AccumulatedAmortofDiscountPremium.GetValueOrDefault(0)
                                + capcosts.GetValueOrDefault(0) + ListGAAPBasisTab[i].AccumulatedAmortofCapitalizedCost.GetValueOrDefault(0);
                        }
                        else
                        {
                            ListGAAPBasisTab[i].AmortizedCost = 0;
                            ListGAAPBasisTab[i].PVBasis = 0;
                        }
                    }

                    //' Adjusted Basis subject to Cap
                    if (ListGAAPBasisTab[i].Date == CreateNewDate(ListGAAPBasisTab[i].Date.Value.Year, ListGAAPBasisTab[i].Date.Value.Month, DateTime.DaysInMonth(ListGAAPBasisTab[i].Date.Value.Year, ListGAAPBasisTab[i].Date.Value.Month)))
                    {
                        ListGAAPBasisTab[i].AdjustedBasissubjecttoCap = Math.Min(ListGAAPBasisTab[i].ValueCap.GetValueOrDefault(0), ListGAAPBasisTab[i].LockedPreCapBasis.GetValueOrDefault(0));
                    }
                    else
                    {
                        ListGAAPBasisTab[i].AdjustedBasissubjecttoCap = ListGAAPBasisTab[i].LockedPreCapBasis.GetValueOrDefault(0);
                    }

                    if (ListGAAPBasisTab[i].Date.Value <= AccrualDate)
                    {
                        //' Post-Cap: Adjusted Amort
                        ListGAAPBasisTab[i].AdjustedAmort = CumAccruedCDeferredFeeByDate(ListGAAPBasisTab[i].Date.Value) + CumAccruedDDiscountFeeByDate(ListGAAPBasisTab[i].Date.Value);
                        //' Post-Cap: Adjusted Level Yield Income
                        ListGAAPBasisTab[i].AdjustedLevelYieldIncome = ListGAAPBasisTab[i].AdjustedAmort.GetValueOrDefault(0) + ListCouponTab[i - 1].DailyAccruedInterest.GetValueOrDefault(0) + ListPIKInterestTab[i - 1].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0);
                    }
                    else
                    {
                        //' Post-Cap: Adjusted Level Yield Income
                        ListGAAPBasisTab[i].AdjustedLevelYieldIncome = ListGAAPBasisTab[i].CashFlowusedforLevelYieldPreCap.GetValueOrDefault(0) + ListGAAPBasisTab[i].AdjustedBasissubjecttoCap.GetValueOrDefault(0) - ListGAAPBasisTab[i - 1].AdjustedBasissubjecttoCap.GetValueOrDefault(0);
                        //' Post-Cap: Adjusted Amort
                        ListGAAPBasisTab[i].AdjustedAmort = ListGAAPBasisTab[i].AdjustedLevelYieldIncome - ListCouponTab[i - 1].DailyAccruedInterest.GetValueOrDefault(0) - ListCouponTab[i - 1].CouponbasedonFutureFunding.GetValueOrDefault(0) - ListPIKInterestTab[i - 1].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0);
                    }

                    if (ListGAAPBasisTab[i - 1].AdjustedBasissubjecttoCap != 0)
                    {
                        ListGAAPBasisTab[i].AdjustedPeriodicYld = 365.25m * (NumericExtensions.SafeDivision(Convert.ToDecimal(ListGAAPBasisTab[i].AdjustedLevelYieldIncome), Convert.ToDecimal(ListGAAPBasisTab[i - 1].AdjustedBasissubjecttoCap)));
                    }

                    //' Actual Level Yield Income
                    ListGAAPBasisTab[i].TotalPeriodGAAPIncome = ListGAAPBasisTab[i].CashFlowadjustedforServicingInfo.GetValueOrDefault(0) + ListGAAPBasisTab[i].ActualBasis.GetValueOrDefault(0) - ListGAAPBasisTab[i - 1].ActualBasis.GetValueOrDefault(0);

                    // ' Total Stripped Cash Flows
                    ListGAAPBasisTab[i].TotalStrippedCashFlow = CalcStrippedFee(ListGAAPBasisTab[i].Date.Value);

                    // GAAP Book Value
                    if (ListGAAPBasisTab[i].Date.Value < matdate)
                    {
                        ListGAAPBasisTab[i].EndingGAAPBookValue = ListGAAPBasisTab[i].AmortizedCost.GetValueOrDefault(0)
                            + ListCouponTab[i].AccumInterestforCurrentAccrualPeriod.GetValueOrDefault(0)
                            + ListPIKInterestTab[i].AccumPIKInterestforCurrentAccrualPeriod.GetValueOrDefault()
                            + ListCouponTab[i].DeltaBalance.GetValueOrDefault(0)
                            - ListCouponTab[i].InterestSuspenseAccountBalanceWithAdj.GetValueOrDefault(0);
                    }
                    else
                    {
                        ListGAAPBasisTab[i].EndingGAAPBookValue = 0;
                    }

                    //' Clean Cost Price ' Amortized Cost Price
                    if (ListBalanceTab[i].EndingBalance != null && ListBalanceTab[i].EndingBalance != 0)
                    {
                        ListGAAPBasisTab[i].CleanCostPrice = NumericExtensions.SafeDivision(ListGAAPBasisTab[i].CleanCost.GetValueOrDefault(0), Math.Round(ListBalanceTab[i].EndingBalance.GetValueOrDefault(0), 8));
                        ListGAAPBasisTab[i].AmortizedCostPrice = NumericExtensions.SafeDivision(ListGAAPBasisTab[i].AmortizedCost.GetValueOrDefault(0), Math.Round(ListBalanceTab[i].EndingBalance.GetValueOrDefault(0), 8));
                    }
                    else
                    {
                        ListGAAPBasisTab[i].CleanCostPrice = 0;
                        ListGAAPBasisTab[i].AmortizedCostPrice = 0;
                    }
                    //' GAAP Income for the Period
                    if (noteDC.StubPaidinAdvanceYNText == "Y" && ListGAAPBasisTab[i].Date.Value.Date < EffectveFirstCouponAccrualStartDate)
                    {
                        ListGAAPBasisTab[i].GAAPIncomeforthePeriod = ListGAAPBasisTab[i].AmortofDeferredFees.GetValueOrDefault(0);
                    }
                    else if (ListGAAPBasisTab[i].Date.Value < matdate)
                    {
                        ListGAAPBasisTab[i].GAAPIncomeforthePeriod = ListGAAPBasisTab[i].AmortofDeferredFees.GetValueOrDefault(0) + ListCouponTab[i].DailyAccruedInterest.GetValueOrDefault(0);
                    }
                    else if (ListGAAPBasisTab[i].Date.Value == matdate)
                    {
                        ListGAAPBasisTab[i].GAAPIncomeforthePeriod = ListGAAPBasisTab[i].AmortofDeferredFees.GetValueOrDefault(0) + CalculateInterestAccrualatMaturity(matdate);
                    }
                    else
                    {
                        ListGAAPBasisTab[i].GAAPIncomeforthePeriod = 0;
                    }
                }
                i++;
            }
        }

        public decimal? CalculateInterestAccrualatMaturity(DateTime matdate)
        {
            decimal? inttoal = 0;
            inttoal = ListCouponTab.Where(x => x.Date >= matdate).Sum(y => y.DailyAccruedInterestbeforeStrippingRule);
            return inttoal;
        }

        public void GeneratePeriodOutput()
        {
            decimal cumffamt, balloonpmt, schedprincipal, principalpaid, intaccrual, pikaccrual, amortaccrual, dpaccrual;
            decimal pikamtsource, pikamtrelated, pikint, pikballoon, piknotcomp, pikintpaid, pikprinpaid, pikapplied;
            decimal pmtint, cstripperiod, cstrippmt, intshortfall, intpmtshortfall, cumintpmtshortfall;
            decimal spshortfall, pshortfall, ploss, intloss, intrecovery, intsuspense;
            decimal finffamt, finballoon, finint, finfees;
            decimal AddfeeAccrual, CapcostsAccrual;
            decimal? cumamort, actualcf, gaapcf, gaapincome, cumcurt, FeeStrip;
            decimal? lyincome, pvamort, gaapamort, slamort, slfee, sldisc, slcapcost;
#pragma warning disable CS0219 // The variable 'feetotalamort' is assigned but its value is never used
            decimal? feetotalamort, feelyamort, discamort, capcostamort;
#pragma warning restore CS0219 // The variable 'feetotalamort' is assigned but its value is never used

            actualcf = 0;
            gaapcf = 0;
            gaapincome = 0;
            intaccrual = 0;
            cumamort = 0;
            cumffamt = 0;
            cumcurt = 0;
            amortaccrual = 0;

            DateTime Closingdate, Matdate, Perioddate, EOMSelectedMaturityDate;
            Closingdate = Convert.ToDateTime(noteDC.ClosingDate);

            Matdate = Convert.ToDateTime(SelectedMaturityDateLatest);
            EOMSelectedMaturityDate = LastDateOfMonth(Matdate);
            Perioddate = LastDateOfMonth(Closingdate);

            //ListNotePeriodicOutputs
            int OutputIndex = 0;
            int OutputIndexinner = 0;
            while (Perioddate <= EOMSelectedMaturityDate)
            {
                NotePeriodicOutputsDataContract periodic = new NotePeriodicOutputsDataContract();
                periodic.PeriodEndDate = Perioddate;
                periodic.Month = OutputIndex + 1;

                OutputIndexinner = 0;
                actualcf = 0;
                gaapcf = 0;
                gaapincome = 0;
                cumffamt = 0;
                cumcurt = 0;
                balloonpmt = 0;
                FeeStrip = 0;
                schedprincipal = 0;
                principalpaid = 0;
                pmtint = 0;
                cstripperiod = 0;
                cstrippmt = 0;
                intaccrual = 0;
                pikaccrual = 0;
                amortaccrual = 0;
                AddfeeAccrual = 0;
                CapcostsAccrual = 0;
                pikamtsource = 0;
                pikamtrelated = 0;
                pikint = 0;
                pikballoon = 0;
                piknotcomp = 0;
                pikintpaid = 0;
                pikapplied = 0;
                pikprinpaid = 0;
                spshortfall = 0;
                pshortfall = 0;
                ploss = 0;
                intshortfall = 0;
                intpmtshortfall = 0;
                cumintpmtshortfall = 0;
                intloss = 0;
                intrecovery = 0;
                finffamt = 0;
                finballoon = 0;
                finint = 0;
                finfees = 0;
                dpaccrual = 0;
                intsuspense = 0;
                lyincome = 0; pvamort = 0; gaapamort = 0;
                slamort = 0; slfee = 0; sldisc = 0; slcapcost = 0;
                feetotalamort = 0; feelyamort = 0; discamort = 0; capcostamort = 0;

                foreach (BalanceTab bt in ListBalanceTab)
                {
                    //' Beginning Balance
                    if (bt.Date == FirstDayOfMonth(Perioddate))
                    {
                        periodic.BeginningBalance = Convert.ToDecimal(bt.BeginningBalance.GetValueOrDefault(0));
                    }
                    //else
                    //periodic.BeginningBalance = 0;
                    if (bt.Date <= Perioddate && bt.Date > LastDateOfMonth(Perioddate.AddMonths(-1)))
                    {
                        // PV Basis Cashflows
                        actualcf = actualcf + ListPVBasisTab[OutputIndexinner].CashFlowForAllInBasis.GetValueOrDefault(0);
                        gaapcf = gaapcf + ListPVBasisTab[OutputIndexinner].CashFlowusedforLevelYieldPreCap.GetValueOrDefault(0);
                        gaapincome = gaapincome + ListGAAPBasisTab[OutputIndexinner].GAAPIncomeforthePeriod.GetValueOrDefault(0);

                        //---------------------- Data From Balance Tab ------------------------------------------
                        cumffamt = cumffamt + bt.FutureAdvancesFromFutureFundingSchedule.GetValueOrDefault(0);
                        cumcurt = cumcurt + bt.DiscretionaryCurtailmentsForThePeriod.GetValueOrDefault(0);
                        balloonpmt = balloonpmt + bt.BalloonPayment.GetValueOrDefault(0);
                        schedprincipal = schedprincipal + bt.ScheduledPrincipal.GetValueOrDefault(0);
                        principalpaid = principalpaid + bt.PrincipalPaid.GetValueOrDefault(0);  // bt.PrincipalPaid.GetValueOrDefault(0) issue [AC-8]
                        pikamtsource = pikamtsource + Convert.ToDecimal(bt.PIKInterestfromPIKSourceNote.GetValueOrDefault(0));
                        spshortfall = spshortfall + bt.ScheduledPrincipalShortfall.GetValueOrDefault(0);
                        pshortfall = pshortfall + bt.PrincipalShortfall.GetValueOrDefault(0);
                        ploss = ploss + bt.PrincipalLoss.GetValueOrDefault(0);

                        //---------------------- Data From Coupon Tab ------------------------------------------
                        pmtint = pmtint + ListCouponTab[OutputIndexinner].InterestPaidServicingWithDropDate.GetValueOrDefault(0); //.InterestPaidonPaymentDate.GetValueOrDefault(0) issue [AC-8]
                        cstripperiod = cstripperiod + ListCouponTab[OutputIndexinner].CouponStrippingforthePeriod.GetValueOrDefault(0);
                        cstrippmt = cstrippmt + ListCouponTab[OutputIndexinner].CouponStrippedonPaymentDate.GetValueOrDefault(0);
                        intaccrual = intaccrual + Convert.ToDecimal(ListCouponTab[OutputIndexinner].DailyAccruedInterest);
                        intshortfall = intshortfall + ListCouponTab[OutputIndexinner].InterestforthePeriodShortfall.GetValueOrDefault(0);//K
                        intpmtshortfall = intpmtshortfall + ListCouponTab[OutputIndexinner].InterestPaidonPMTDateShortfall.GetValueOrDefault(0);//L
                        cumintpmtshortfall = cumintpmtshortfall + ListCouponTab[OutputIndexinner].CumulativeInterestPaidonPMTDateShortfall.GetValueOrDefault(0);//M
                        intloss = intloss + ListCouponTab[OutputIndexinner].InterestShortfallLoss.GetValueOrDefault(0);//N
                        intrecovery = intrecovery + ListCouponTab[OutputIndexinner].InterestShortfallRecovery.GetValueOrDefault(0);//O
                        intsuspense = intsuspense + ListCouponTab[OutputIndexinner].InterestSuspenseAccountActivityforthePeriod.GetValueOrDefault(0);//O
                        FeeStrip = FeeStrip + CalcStrippedFee(bt.Date);
                        // ' --- Data from PIK_Interest Tab ---
                        pikaccrual = pikaccrual + Convert.ToDecimal(ListPIKInterestTab[OutputIndexinner].DailyAccruedPIKInterestAdjustedforPIKInterestCap.GetValueOrDefault(0));//E
                        pikint = pikint + ListPIKInterestTab[OutputIndexinner].PIKInterestforthePeriod.GetValueOrDefault(0);//H
                        pikintpaid = pikintpaid + ListPIKInterestTab[OutputIndexinner].PIKInterestPaidForThePeriod.GetValueOrDefault(0);
                        pikapplied = pikapplied + ListPIKInterestTab[OutputIndexinner].PIKInterestPaidAppliedForThePeriod.GetValueOrDefault(0);
                        pikprinpaid = pikprinpaid + ListPIKInterestTab[OutputIndexinner].PIKPrincipalPaidForThePeriod.GetValueOrDefault(0);
                        pikamtrelated = pikamtrelated + ListPIKInterestTab[OutputIndexinner].TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod.GetValueOrDefault(0);//Q
                        pikballoon = pikballoon + ListPIKInterestTab[OutputIndexinner].PIKBalanceBalloonPayment.GetValueOrDefault(0);//M
                        piknotcomp = piknotcomp + ListPIKInterestTab[OutputIndexinner].PIKInterestforthePeriodBalloon.GetValueOrDefault(0);//L

                        // ' --- Data from GAAP_Basis Tab ---
                        dpaccrual = dpaccrual + ListGAAPBasisTab[OutputIndexinner].DiscountPremiumAccrual.GetValueOrDefault(0);
                        amortaccrual = amortaccrual + ListGAAPBasisTab[OutputIndexinner].AmortofDeferredFees.GetValueOrDefault(0);
                        CapcostsAccrual = CapcostsAccrual + ListGAAPBasisTab[OutputIndexinner].CapitalizedCostAccrual.GetValueOrDefault(0);
                        //' --- Data from Financing Tab ---	;
                        finffamt = finffamt + ListFinancingTab[OutputIndexinner].FinancingDrawsCurtailmentsfromFinancingDrawsSchedule.GetValueOrDefault(0) + ListFinancingTab[OutputIndexinner].FinancingDrawsCurtailmentsassociatedwithFutureFundingSchedule.GetValueOrDefault(0);//C and D
                        finballoon = finballoon + ListFinancingTab[OutputIndexinner].FinancingBalloon.GetValueOrDefault(0);//E
                        finint = finint + ListFinancingTab[OutputIndexinner].FinancingInterestPaid.GetValueOrDefault(0);//J
                        finfees = finfees + ListFinancingTab[OutputIndexinner].FinancingFeesPaid.GetValueOrDefault(0);//K

                        //PV Basis & SL Basis 
                        lyincome = lyincome + ListPVBasisTab[OutputIndexinner].PeriodLevelYieldIncomePreCap.GetValueOrDefault(0);
                        pvamort = pvamort + ListPVBasisTab[OutputIndexinner].PVAmort.GetValueOrDefault(0);
                        gaapamort = gaapamort + ListPVBasisTab[OutputIndexinner].GAAPAmort.GetValueOrDefault(0);
                        slamort = slamort + ListSLBasisTab[OutputIndexinner].SLAmort.GetValueOrDefault(0);
                        slfee = slfee + ListSLBasisTab[OutputIndexinner].SLAmortOfTotalFeesInclInLY.GetValueOrDefault(0);
                        sldisc = sldisc + ListSLBasisTab[OutputIndexinner].SLAmortOfDiscountPremium.GetValueOrDefault(0);
                        slcapcost = slcapcost + ListSLBasisTab[OutputIndexinner].SLAmortOfCapCost.GetValueOrDefault(0);

                        //PV Basis & SL Basis  - Total Amort split 
                        feelyamort = feelyamort + ListSLBasisTab[OutputIndexinner].FeeAmort.GetValueOrDefault(0);
                        discamort = discamort + ListSLBasisTab[OutputIndexinner].DiscPremAmort.GetValueOrDefault(0);
                        capcostamort = capcostamort + ListSLBasisTab[OutputIndexinner].CapCostAmort.GetValueOrDefault(0);

                    }

                    if (bt.Date == Perioddate)
                    {
                        // ' Ending Balance
                        periodic.EndingBalance = ListBalanceTab[OutputIndexinner].EndingBalance.GetValueOrDefault(0);//U
                                                                                                                     //' Clean Cost
                        periodic.CleanCost = ListGAAPBasisTab[OutputIndexinner].CleanCost.GetValueOrDefault(0);
                        periodic.GrossDeferredFees = ListGAAPBasisTab[OutputIndexinner].GrossDeferredFees.GetValueOrDefault(0);
                        periodic.DeferredFeesReceivable = ListGAAPBasisTab[OutputIndexinner].DeferredFeesReceivable.GetValueOrDefault(0);
                        periodic.EndingGAAPBookValue = ListGAAPBasisTab[OutputIndexinner].EndingGAAPBookValue.GetValueOrDefault(0);
                        periodic.AmortizedCost = ListGAAPBasisTab[OutputIndexinner].AmortizedCost.GetValueOrDefault(0);
                        //PV Basis - PreCap Level Yield
                        Double apow = (1 / 12D);
                        double anum = 0;
                        anum = Convert.ToDouble(1 + ListPVBasisTab[OutputIndexinner].PreCapLevelYield.GetValueOrDefault(0));
                        periodic.AmortAccrualLevelYield = (NumericExtensions.CalcPowAndCheckNaN(anum, apow) - 1) * 12;
                        // ' --- Data from PIK_Interest Tab ---
                        // ' Beginning PIK Balance if not Compounded inside Loan Balance

                        periodic.BeginningPIKBalanceNotInsideLoanBalance = ListPIKInterestTab[OutputIndexinner].BeginningPIKBalanceifnotCompoundedinsideLoanBalance.GetValueOrDefault(0);//I
                                                                                                                                                                                         //' Ending PIK Balance if not Compounded inside Loan Balance
                        periodic.EndingPIKBalanceNotInsideLoanBalance = ListPIKInterestTab[OutputIndexinner].EndingPIKBalanceifnotCompoundedinsideLoanBalance.GetValueOrDefault(0);//N
                                                                                                                                                                                   //' Beginning Financing Balance
                        periodic.BeginningFinancingBalance = ListFinancingTab[OutputIndexinner].BeginningFinancingBalance.GetValueOrDefault(0);
                        //' Ending Financing Balance
                        periodic.EndingFinancingBalance = ListFinancingTab[OutputIndexinner].EndingFinancingBalance.GetValueOrDefault(0);

                        Double pow = (1 / 12D);
                        double num = 0;
                        if (FinancingPeriodLeveredYield != null && FinancingPeriodLeveredYield != 0)
                        {
                            num = Convert.ToDouble(1 + FinancingPeriodLeveredYield);
                            periodic.PeriodLeveredYield = Convert.ToDecimal((NumericExtensions.CalcPowAndCheckNaN(num, pow) - 1) * 12);
                        }
                        else
                        {
                            num = Convert.ToDouble(1 + ListGAAPBasisTab[0].PreCapLevelYield.GetValueOrDefault(0));
                            periodic.PeriodLeveredYield = Convert.ToDecimal((NumericExtensions.CalcPowAndCheckNaN(num, pow) - 1) * 12);
                        }
                        periodic.AllInCouponRate = ListRateTab[OutputIndexinner].AllInCouponRate.GetValueOrDefault(0);
                        periodic.AllInPIKRate = ListRateTab[OutputIndexinner].AllInPIKInterest.GetValueOrDefault(0);
                        periodic.CleanCostPrice = ListGAAPBasisTab[OutputIndexinner].CleanCostPrice.GetValueOrDefault(0);
                        periodic.AmortizedCostPrice = ListGAAPBasisTab[OutputIndexinner].AmortizedCostPrice.GetValueOrDefault(0);

                        // ' Investment Basis
                        if (noteDC.CalculationModeText == "CF + PV Basis (Prospective)" || noteDC.CalculationModeText == "CF + PV Basis (Inception)")
                        {
                            periodic.InvestmentBasis = ListGAAPBasisTab[OutputIndexinner].AdjustedBasissubjecttoCap.GetValueOrDefault(0);
                        }
                        else
                        {
                            periodic.InvestmentBasis = ListGAAPBasisTab[OutputIndexinner].PVBasis.GetValueOrDefault(0);
                        }
                        //Current Period Interest Accrual
                        periodic.CurrentPeriodInterestAccrualPeriodEnddate = ListCouponTab[OutputIndexinner].AccumInterestforCurrentAccrualPeriod.GetValueOrDefault(0) + ListCouponTab[OutputIndexinner].DeltaBalance.GetValueOrDefault(0);
                        periodic.CurrentPeriodPIKInterestAccrualPeriodEnddate = ListPIKInterestTab[OutputIndexinner].AccumPIKInterestforCurrentAccrualPeriod.GetValueOrDefault(0);
                        periodic.InterestSuspenseAccountBalance = ListCouponTab[OutputIndexinner].InterestSuspenseAccountBalanceWithAdj.GetValueOrDefault(0);
                        periodic.AllInBasisValuation = ListGAAPBasisTab[OutputIndexinner].AllInBasis.GetValueOrDefault(0);

                        //PV Basis and SL Basis
                        periodic.EndingPreCapPVBasis = ListPVBasisTab[OutputIndexinner].LockedPreCapBasis.GetValueOrDefault(0);
                        periodic.EndingPreCapGAAPBasis = ListPVBasisTab[OutputIndexinner].GAAPBasis.GetValueOrDefault(0);
                        periodic.EndingCleanCostLY = ListPVBasisTab[OutputIndexinner].CleanCostLevelYield.GetValueOrDefault(0);
                        periodic.EndingAccumAmort = ListPVBasisTab[OutputIndexinner].AccumGAAPAmort.GetValueOrDefault(0);
                        periodic.EndingSLBasis = ListSLBasisTab[OutputIndexinner].SLBasis.GetValueOrDefault(0);
                        periodic.EndingAccumSLAmort = ListSLBasisTab[OutputIndexinner].AccumSLAmort.GetValueOrDefault(0);

                    }

                    OutputIndexinner = OutputIndexinner + 1;
                }

                cumamort = cumamort + amortaccrual;
                periodic.ActualCashFlows = actualcf.GetValueOrDefault(0);
                periodic.GAAPCashFlows = gaapcf.GetValueOrDefault(0);
                periodic.CurrentPeriodInterestAccrual = intaccrual;

                if (OutputIndex == 0 && noteDC.StubPaidinAdvanceYNText == "Y")
                {
                    periodic.InterestReceivedinCurrentPeriod = StubInterestAmount + pikint;
                }
                else if (OutputIndex == 0 && noteDC.LoanPurchaseYNText == "Y")
                {
                    periodic.InterestReceivedinCurrentPeriod = pikint;
                }
                else
                {
                    periodic.InterestReceivedinCurrentPeriod = pmtint + pikint;
                }
                if (OutputIndex == 0)
                {
                    periodic.ReversalofPriorInterestAccrual = 0;
                }
                else
                {
                    periodic.ReversalofPriorInterestAccrual = -(ListNotePeriodicOutputs[OutputIndex - 1].CurrentPeriodInterestAccrual.GetValueOrDefault(0)
                        + ListNotePeriodicOutputs[OutputIndex - 1].PIKInterestAccrualforthePeriod.GetValueOrDefault(0));
                }

                //Total GAAP Interest for the current period = "Reversal of Prior Interest Accrual" + "Interest Received in Current Period" + "Current Period Interest Accrual Monthly" + "PIK Interest accrual for the Period"
                periodic.TotalGAAPInterestFortheCurrentPeriod = periodic.CurrentPeriodInterestAccrual.GetValueOrDefault(0) + periodic.ReversalofPriorInterestAccrual.GetValueOrDefault(0)
                    + periodic.InterestReceivedinCurrentPeriod.GetValueOrDefault(0) + pikaccrual;

                periodic.PIKInterestAccrualforthePeriod = pikaccrual;
                periodic.TotalAmortAccrualForPeriod = amortaccrual;
                periodic.DiscountPremiumAccrual = dpaccrual;
                periodic.AccumulatedAmort = cumamort.GetValueOrDefault(0);
                periodic.TotalFutureAdvancesForThePeriod = cumffamt;
                periodic.TotalDiscretionaryCurtailmentsforthePeriod = cumcurt.GetValueOrDefault(0);
                periodic.TotalCouponStrippedforthePeriod = cstripperiod;
                periodic.CouponStrippedonPaymentDate = cstrippmt;
                periodic.ScheduledPrincipal = schedprincipal;
                periodic.PrincipalPaid = principalpaid;
                periodic.BalloonPayment = balloonpmt;
                periodic.PIKInterestFromPIKSourceNote = pikamtsource;
                periodic.PIKInterestTransferredToRelatedNote = pikamtrelated;
                periodic.PIKInterestForThePeriod = pikint;
                periodic.PIKInterestPaidForThePeriod = pikintpaid;
                periodic.PIKInterestAppliedForThePeriod = pikapplied;
                periodic.PIKPrincipalPaidForThePeriod = pikprinpaid;
                periodic.PIKInterestForPeriodNotInsideLoanBalance = piknotcomp;
                periodic.PIKBalanceBalloonPayment = pikballoon;
                periodic.ScheduledPrincipalShortfall = Convert.ToDecimal(spshortfall);
                periodic.PrincipalShortfall = Convert.ToDecimal(pshortfall);
                periodic.PrincipalLoss = Convert.ToDecimal(ploss);
                periodic.InterestForPeriodShortfall = Convert.ToDecimal(intshortfall);
                periodic.InterestPaidOnPMTDateShortfall = Convert.ToDecimal(intpmtshortfall);
                periodic.CumulativeInterestPaidOnPMTDateShortfall = Convert.ToDecimal(cumintpmtshortfall);
                periodic.InterestShortfallLoss = Convert.ToDecimal(intloss);
                periodic.InterestShortfallRecovery = Convert.ToDecimal(intrecovery);
                periodic.TotalFinancingDrawsCurtailmentsForPeriod = Convert.ToDecimal(finffamt);
                periodic.FinancingBalloon = Convert.ToDecimal(finballoon);
                periodic.FinancingInterestPaid = Convert.ToDecimal(finint);
                periodic.FinancingFeesPaid = Convert.ToDecimal(finfees);
                periodic.FeeStrippedforthePeriod = FeeStrip;
                periodic.AdditionalFeeAccrual = Convert.ToDecimal(AddfeeAccrual);
                periodic.CapitalizedCostAccrual = Convert.ToDecimal(CapcostsAccrual);
                periodic.AnalysisID = noteDC.AnalysisID;
                //periodic.CurrentPeriodPIKInterestAccrualPeriodEnddate = OutputIndex;
                periodic.InterestSuspenseAccountActivityforthePeriod = intsuspense;

                periodic.LevelYieldIncomeForThePeriod = Convert.ToDecimal(lyincome);
                periodic.PVAmortTotalIncomeMethod = Convert.ToDecimal(pvamort);
                periodic.PVAmortForThePeriod = Convert.ToDecimal(gaapamort);
                periodic.SLAmortForThePeriod = Convert.ToDecimal(slamort);
                periodic.SLAmortOfTotalFeesInclInLY = Convert.ToDecimal(slfee);
                periodic.SLAmortOfDiscountPremium = Convert.ToDecimal(sldisc);
                periodic.SLAmortOfCapCost = Convert.ToDecimal(slcapcost);
                periodic.AmortOfFeesInclInLY = Convert.ToDecimal(feelyamort);
                periodic.AmortOfDiscountPremium = Convert.ToDecimal(discamort);
                periodic.AmortOfCapCost = Convert.ToDecimal(capcostamort);

                ListNotePeriodicOutputs.Add(periodic);
                Perioddate = LastDateOfMonth(Closingdate.AddMonths(OutputIndex + 1));
                OutputIndex = OutputIndex + 1;
            }
        }

        public int LookupIOTerm(DateTime pmtdate)
        {
            int ioterm = 0;
            int loopindex = 0;
            foreach (DatesTab date in ListDatesTab)
            {
                if (date.PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay.Value.Date == pmtdate.Date)
                {
                    ioterm = ListRemIoTerm[loopindex];
                }
                loopindex = loopindex + 1;
            }

            return ioterm;
        }

        public decimal GetMostRecentLiborValue(DateTime? date)
        {
            decimal lastvalue = 0;
            List<LiborScheduleTab> listlibor = ListLiborScheduleTabLatest.FindAll(x => x.Value != 0 && x.Date <= date && x.Value != null).ToList();

            if (listlibor.Count > 0)
            {
                var last = listlibor.Last();
                lastvalue = Convert.ToDecimal(last.Value);
            }

            return lastvalue;
        }

        public decimal? CalcDeferredFees(DateTime? StartDate, bool LevelYield = true)
        {
            decimal? feeamt = 0;
            if (LevelYield)
                feeamt = ListFeeOutput.Where(fop => fop.Date >= StartDate).Sum(fee => fee.FeeAmountinclinLY);
            else
                feeamt = ListFeeOutput.Where(fop => fop.Date >= StartDate).Sum(fee => fee.FeeAmount);
            return feeamt;
        }


        public decimal? CumAccruedDeferredFee()
        {
            decimal? feeamt = 0;
            foreach (HistoricalAccrualDataContract fees in noteDC.ListHistoricalAccrual)
            {
                feeamt = feeamt + fees.DeferredFeeAccrual.GetValueOrDefault(0);
            }
            return feeamt;
        }

        public decimal CumAccruedAllInBasisByDate(DateTime vDate)
        {
            decimal feeamt = 0;
            foreach (HistoricalAccrualDataContract fees in noteDC.ListHistoricalAccrual)
            {
                if (fees.PeriodDate == vDate)
                {
                    feeamt = feeamt + fees.AllInBasisValuation.GetValueOrDefault(0);
                }
            }
            return feeamt;
        }
        public decimal CumAccruedPvBasisByDate(DateTime vDate)
        {
            decimal feeamt = 0;
            foreach (HistoricalAccrualDataContract fees in noteDC.ListHistoricalAccrual)
            {
                if (fees.PeriodDate == vDate)
                {
                    feeamt = feeamt + fees.PVBasis.GetValueOrDefault(0);
                }
            }
            return feeamt;
        }
        public decimal? CumAccruedDiscountFee()
        {
            decimal? feeamt = 0;
            foreach (HistoricalAccrualDataContract fees in noteDC.ListHistoricalAccrual)
            {
                feeamt = feeamt + fees.DiscountPremiumAccrual.GetValueOrDefault(0);
            }
            return feeamt;
        }

        public decimal? CumAccruedCapitalizedCostFee()
        {
            decimal? feeamt = 0;
            foreach (HistoricalAccrualDataContract fees in noteDC.ListHistoricalAccrual)
            {
                feeamt = feeamt + fees.CapitalizedCostAccrual.GetValueOrDefault(0);
            }
            return feeamt;
        }

        public decimal? CumAccruedCDeferredFeeByDate(DateTime? period)
        {
            decimal? feeamt = 0;
            foreach (HistoricalAccrualDataContract fees in noteDC.ListHistoricalAccrual)
            {
                if (fees.PeriodDate == period)
                {
                    feeamt = feeamt + fees.DeferredFeeAccrual.GetValueOrDefault(0);
                }
            }
            return feeamt;
        }

        public decimal? CumAccruedBDeferredFeeByDate(DateTime? period)
        {
            decimal? feeamt = 0;
            foreach (HistoricalAccrualDataContract fees in noteDC.ListHistoricalAccrual)
            {
                if (fees.PeriodDate == period)
                {
                    feeamt = feeamt + fees.PVBasis.GetValueOrDefault(0);
                }
            }
            return feeamt;
        }

        public decimal? CalcStrippedFee(DateTime? period)
        {
            decimal? feeamt = 0;
            foreach (FeeOutputDataContract fees in ListFeeOutput)
            {
                if (fees.Date == period)
                {
                    feeamt = feeamt + fees.FeeAmountStripped.GetValueOrDefault(0);
                }
            }
            return feeamt;
        }

        public decimal? CumAccruedDDiscountFeeByDate(DateTime? period)
        {
            decimal? feeamt = 0;
            foreach (HistoricalAccrualDataContract fees in noteDC.ListHistoricalAccrual)
            {
                if (fees.PeriodDate == period)
                {
                    feeamt = feeamt + fees.DiscountPremiumAccrual.GetValueOrDefault(0);
                }
            }
            return feeamt;
        }

        public decimal? CumAccruedGCapitalizedCostAccrualByDate(DateTime? period)
        {
            decimal? feeamt = 0;
            foreach (HistoricalAccrualDataContract fees in noteDC.ListHistoricalAccrual)
            {
                if (fees.PeriodDate == period)
                {
                    feeamt = feeamt + fees.CapitalizedCostAccrual.GetValueOrDefault(0);
                }
            }
            return feeamt;
        }

        public decimal? CumAccruedGCapitalizedCostFeeByDate(DateTime? period)
        {
            decimal? feeamt = 0;
            foreach (HistoricalAccrualDataContract fees in noteDC.ListHistoricalAccrual)
            {
                if (fees.PeriodDate == period)
                {
                    feeamt = feeamt + fees.CapitalizedCostAccrual.GetValueOrDefault(0);
                }
            }
            return feeamt;
        }

        public decimal? CalcFutureFeeAmt(DateTime? StartDate)
        {
            decimal? feeamt = 0;
            foreach (FeesTab fees in ListFeesTab)
            {
                if (fees.Date.Value.Date >= StartDate.Value.Date)
                {
                    feeamt = feeamt + fees.FeeAmountIncludedinLevelYield.GetValueOrDefault(0);
                }
            }
            return feeamt;
        }

        public static int YearMonthDiff(DateTime startDate, DateTime endDate)
        {
            int monthDiff = ((endDate.Year * 12) + endDate.Month) - ((startDate.Year * 12) + startDate.Month);
            return monthDiff;
        }

        public DateTime? GetLastPaymentDate(DateTime? dt)
        {
            DateTime? pmtdate = DateTime.MinValue;
            pmtdate = ListBalanceTab.FindAll(x => x.Date >= dt && x.PMTDateTag == 1).ToList().Select(y => y.Date).Min();
            return pmtdate;
        }

        public DateTime? GetPaymentDateNotAdjustedForBusinessDay(DateTime? dt)
        {
            DateTime? pmtdate = DateTime.MinValue;
            pmtdate = ListRateTab.FindAll(x => x.rateDate >= dt && x.InterestAccrualPeriodEndDateTag == 1).ToList().Select(y => y.rateDate).Min();
            return pmtdate;
        }

        public void CaptureBalance()
        {
            DateTime startdate = DateTime.Now.Date.AddDays(-noteDC.NumberofDaysinPast);
            DateTime enddate = DateTime.Now.Date.AddDays(noteDC.NumberofDaysinFuture);
            var res = ListBalanceTab.FindAll(x => x.Date >= startdate.Date && x.Date < enddate.Date).ToList();
            int diffdate = 0;
            int index = 0;
            DateTime? intsatrtdate = DateTime.MinValue;
            DateTime? intenddate = DateTime.MinValue;
            DateTime? lastpaymentdate = DateTime.MinValue;
            DateTime? paymentdatebasedon = DateTime.MinValue;
            decimal liborper = 0, indexper = 0;
            decimal Pikliborper = 0, pikindexper = 0;
            decimal spreadper = 0;
#pragma warning disable CS0219 // The variable 'pikper' is assigned but its value is never used
            decimal pikper = 0;
#pragma warning restore CS0219 // The variable 'pikper' is assigned but its value is never used

            foreach (var t in res)
            {
                NotePeriodicOutputsDataContract npdc = new NotePeriodicOutputsDataContract();
                npdc.PeriodEndDate = t.Date;
                npdc.EndingBalance = t.EndingBalance;
                npdc.AnalysisID = noteDC.AnalysisID;
                ListTrailingBalance.Add(npdc);
            }
            foreach (BalanceTab balance in ListBalanceTab)
            {
                if (balance.PMTDateTag == 1)
                {
                    diffdate = 0;
                    NotePeriodicOutputsDataContract npdc = new NotePeriodicOutputsDataContract();
                    if (noteDC.IncludeServicingPaymentOverrideinLevelYieldText == "N")
                    {
                        npdc.PeriodEndDate = GetPaymentDateNotAdjustedForBusinessDay(balance.Date);

                        if (npdc.PeriodEndDate == null)
                        {
                            npdc.PeriodEndDate = balance.Date;
                        }

                        diffdate = Convert.ToInt32(npdc.PeriodEndDate.Value.Subtract(balance.Date.Value.Date).TotalDays);
                    }
                    else
                    {
                        npdc.PeriodEndDate = balance.Date;
                    }

                    npdc.EndingGAAPBookValue = ListGAAPBasisTab[index + diffdate].EndingGAAPBookValue;

                    if (noteDC.CalculationModeText == "CF + PV Basis (Prospective)" || noteDC.CalculationModeText == "CF + PV Basis (Inception)")
                    {
                        npdc.InvestmentBasis = ListGAAPBasisTab[index + diffdate].AdjustedBasissubjecttoCap.GetValueOrDefault(0);
                    }
                    else
                    {
                        npdc.InvestmentBasis = ListGAAPBasisTab[index + diffdate].PVBasis.GetValueOrDefault(0);
                    }
                    // npdc.InvestmentBasis = ListGAAPBasisTab[index + diffdate].AdjustedBasissubjecttoCap;
                    npdc.AnalysisID = noteDC.AnalysisID;
                    Listbalpvgaap.Add(npdc);
                }

                index = index + 1;
            }

            foreach (DatesTab dt in ListDatesTab.Where(dt => dt.PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay <= SelectedMaturityDateLatest))
            {
                //-------------------- ListInterestCalculator start--------------------------
                InterestCalculatorDataContract lcd = new InterestCalculatorDataContract();
                if (noteDC.NoteId != null)
                {
                    lcd.NoteID = new Guid(noteDC.NoteId);
                }
                else
                {
                    lcd.NoteID = null;
                }
                lcd.AccrualStartDate = dt.InterestAccrualPeriodStartDateArray;
                lcd.AccrualEndDate = dt.InterestAccrualPeriodEndDateArray;
                lcd.PaymentDate = dt.PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay;
                lcd.BeginningBalance = GetBeginningBalanceOnDate(dt.InterestAccrualPeriodStartDateArray);
                lcd.AnalysisID = noteDC.AnalysisID;
                ListInterestCalculator.Add(lcd);

                //-------------------- ListInterestCalculator End--------------------------

                intsatrtdate = dt.InterestAccrualPeriodStartDateArray.Value;
                intenddate = dt.InterestAccrualPeriodEndDateArray.Value;
                var restemp = ListRateTab.FindAll(x => x.rateDate >= intsatrtdate && x.rateDate <= intenddate).ToList();
                foreach (var t in restemp)
                {

                    if (t.AllInPIKInterest.GetValueOrDefault(0) != 0)
                    {
                        if (t.AdditionalPIKinterestRatefromPIKTable == null)
                        {
                            pikindexper = pikindexper + t.AdditionalPIKSpreadfromPIKTable.GetValueOrDefault(0);
                            Pikliborper = Pikliborper + Math.Max(t.PIKIndexFloorfromPIKTable.GetValueOrDefault(), t.DIndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0));

                        }
                        else
                        {
                            pikindexper = pikindexper + t.AdditionalPIKinterestRatefromPIKTable.GetValueOrDefault(0);
                            Pikliborper = 0;
                        }
                    }
                    if (t.RateType == "Rate")
                    {
                        if (t.CouponRate.GetValueOrDefault(0) != 0)
                        {
                            spreadper = spreadper + t.CouponRate.GetValueOrDefault(0);

                        }
                        else
                        {
                            spreadper = spreadper + t.CouponSpread.GetValueOrDefault(0);
                        }

                    }
                    else
                    {
                        //liborper = liborper + t.DIndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0);
                        if (t.CouponSpread.GetValueOrDefault(0) > 0)
                            indexper = Math.Max(t.IndexFloor.GetValueOrDefault(), t.DIndexValueusingFloatingRateIndexReferenceDate.GetValueOrDefault(0));
                        else
                            indexper = 0;

                        liborper = liborper + indexper;
                        spreadper = spreadper + t.CouponSpread.GetValueOrDefault(0);
                    }

                }

                NotePeriodicOutputsDataContract npdc = new NotePeriodicOutputsDataContract();
                npdc.PeriodEndDate = GetWorkingDayUsingOffset(Convert.ToDateTime(dt.PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay.Value.AddDays(1)), Convert.ToInt16(noteDC.PaymentDateBusinessDayLag), "PMT Date");
                npdc.LIBORPercentage = RoundValuesUsingRoundingRule(NumericExtensions.SafeDivision(liborper, restemp.Count()));
                npdc.SpreadPercentage = NumericExtensions.SafeDivision(spreadper, restemp.Count());

                npdc.PIKInterestPercentage = NumericExtensions.SafeDivision(pikindexper, restemp.Count());
                npdc.PIKLiborPercentage = NumericExtensions.SafeDivision(Pikliborper, restemp.Count());

                npdc.AnalysisID = noteDC.AnalysisID;
                liborper = 0;
                spreadper = 0;
                Pikliborper = 0;
                pikindexper = 0;
                pikper = 0;
                ListSpreadandLibor.Add(npdc);
            }
            var filteredlist = ListSpreadandLibor.GroupBy(x => x.PeriodEndDate).Select(y => y.First()).ToList();
            ListSpreadandLibor.Clear();
            ListSpreadandLibor.AddRange(filteredlist);
        }

        public DateTime? GetPaymentdateByDateForPikTransactions(DateTime? dt)
        {
            DateTime? pmtdate = DateTime.MinValue;

            foreach (var item in ListDatesTab)
            {
                if (item.InterestAccrualPeriodEndDateArray == dt)
                {
                    pmtdate = item.PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay.Value;

                    break;
                }
            }
            return pmtdate;
        }

        public DateTime? GetAccruedInterestSuspenseDate(DateTime? date)
        {
            DateTime? pmtdate = DateTime.MinValue;
            DateTime? vdate = date;
            pmtdate = ListDatesTab.FindAll(x => x.PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay >= vdate).First().PaymentDateReferencedforInterestAccrualPeriodAdjustedforBusinessDay.Value;
            pmtdate = GetMinDate(SelectedMaturityDateLatest.Value.Date, pmtdate.Value.Date);
            return pmtdate;
        }

        public DateTime? GetCurrentPaymentdateByDate(DateTime? date)
        {
            DateTime? pmtdate = DateTime.MinValue;
            pmtdate = ListBalanceTab.FindAll(x => x.Date <= date.Value.Date && x.PMTDateTag == 1).ToList().Select(y => y.Date).Max();
            return pmtdate;
        }

        public decimal RoundValuesUsingRoundingRule(decimal value)
        {
            decimal roundedrate = value;
            int RoundOff = 12;
            if (noteDC.IndexRoundingRule != null && noteDC.IndexRoundingRule != 0)
                RoundOff = (noteDC.IndexRoundingRule).ToString().Length - 1 + 2;
            string valueType = noteDC.RoundingMethodText;
            if (valueType == null)
                valueType = "";
            if (valueType != null && valueType != "")
            {
                if (Enum.IsDefined(typeof(EnmRoundMethodType), valueType.Replace(' ', '_')))
                {
                    EnmRoundMethodType eRateType = ((EnmRoundMethodType)Enum.Parse(typeof(EnmRoundMethodType), valueType.Replace(' ', '_')));
                    switch (eRateType)
                    {
                        case EnmRoundMethodType.Nearest:
                            roundedrate = Math.Round(value, RoundOff);
                            break;

                        case EnmRoundMethodType.Up:
                            roundedrate = Convert.ToDecimal(vRoundUp(value, RoundOff));  //LiborValue.GetValueOrDefault(0);
                            break;

                        case EnmRoundMethodType.Down:
                            roundedrate = Convert.ToDecimal(vRoundDown(value, RoundOff));
                            break;

                        default:
                            roundedrate = value;
                            break;
                    }
                }
            }

            return roundedrate;
        }

        public void CollectPIKInterestOverrides()
        {
            int ndx = 0;
            DateTime? AccEndDate;
            if (noteDC.ListServicingLogTab != null)
            {
                List<ServicingLogTab> ListPIKFundings =
                noteDC.ListServicingLogTab.Where(x => x.TransactionTypeText == CalculationEnums.TransactionTypeText[(int)TransactionType.PIKInterest]).ToList();

                foreach (ServicingLogTab svc in ListPIKFundings)
                {
                    //Find Accrual Period End Date for each Due Date in the Log
                    ndx = ListDatesTab.FindIndex(date => date.PaymentDateAdjustedforWorkingDay == svc.TransactionDate);
                    AccEndDate = ListDatesTab[ndx].InterestAccrualPeriodEndDateArray;
                    ListPIKInterestOverride.Add(new PIKInterestOverrideDataContract(svc.TransactionDate, AccEndDate, svc.TransactionAmount));
                }
            }
        }

        private void ResetProspAcctgArrays(DateTime effDate)
        {
            //ListPIKInterestTab.SkipWhile(pik => pik.Date < effDate);
            //index = StartRow + 1;
            //foreach (var gaap in ListGAAPBasisTab.Skip(index))

            int ndx = ListBalanceTab.FindIndex(x => x.Date == effDate);
            foreach (BalanceTab bal in ListBalanceTab.Skip(ndx))
            {
                bal.ScheduledPrincipal = 0M;
                bal.PrincipalPaid = 0M;
                bal.PrincipalReceivedperServicing = 0M;
                bal.BeginningBalance = 0M;
                bal.EndingBalance = 0M;
                bal.EndingBalanceUsingPMTDropDate = 0M;
                bal.AmortizationEndingBalanceAddon = 0M;
                bal.NonAmortizationEndingBalanceAddon = 0M;
            }

            ndx = ListPIKInterestTab.FindIndex(x => x.Date == effDate);
            foreach (PIKInterestTab pikrow in ListPIKInterestTab.Skip(ndx))
            {
                pikrow.DailyAccruedPIKInterestAdjustedforPIKInterestCap = 0M;
                pikrow.DailyAccruedPIKInterest = 0M;
                pikrow.AccumPIKInterestforCurrentAccrualPeriod = 0M;
            }
            ndx = ListCouponTab.FindIndex(x => x.Date == effDate);
            foreach (CouponTab cpnrow in ListCouponTab.Skip(ndx))
            {
                cpnrow.DailyAccruedInterestbeforeStrippingRule = 0M;
                cpnrow.DailyAccruedInterest = 0M;
                cpnrow.PMTDropDateDailyAccruedInterestbeforeStrippingRule = 0M;
                cpnrow.PMTDropDateDailyAccruedInterest = 0M;
                cpnrow.InterestPaidDeltaforthePeriod = 0M;
                cpnrow.CoveredDelta = 0M;
                cpnrow.DeltaBalance = 0M;
            }
        }

        public void AddTimeToList(string method, string message, DateTime EffectiveDate)
        {
            CalculatorTimeAnalysis cta = new CalculatorTimeAnalysis();
            cta.LogTime = DateTime.Now;
            cta.Method = method;
            cta.Message = message;
            cta.EffectiveDate = EffectiveDate;
            ListCalculatorTime.Add(cta);
        }
        public void AddToListYieldCalcInputList(List<decimal> values, List<DateTime> dates, string YieldType, DateTime? EffectiveDate)
        {
            try
            {
                for (int i = 0; i < dates.Count; i++)
                {
                    YieldCalcInputDataContract rt = new YieldCalcInputDataContract();
                    rt.NPVdate = dates[i];
                    rt.Value = values[i];
                    rt.CRENoteID = noteDC.CRENoteID;
                    rt.Effectivedate = EffectiveDate;
                    rt.AnalysisID = noteDC.AnalysisID;
                    rt.YieldType = YieldType;
                    ListYieldCalcInput.Add(rt);
                }
            }
            catch (Exception)
            {


            }
            finally
            {

            }
        }
        public void WriteJsonToFile(NoteDataContract ndc)
        {
            string crenoteid = ndc.CRENoteID;
            string maturity = ndc.SelectedMaturityDate.ToString();
            string filename = ndc.CRENoteID + "_" + ndc.SelectedMaturityDate.Value.ToString("yyyy/MM/dd").Replace("/", "") + ".json";
            string sjson = Newtonsoft.Json.JsonConvert.SerializeObject(ndc);
            File.WriteAllText(@"C:\Temp\" + filename, sjson);
        }
    }

    //Code for handling divide by zero exception
    public static class NumericExtensions
    {
        static public decimal SafeDivision(this decimal Numerator, decimal Denominator)
        {
            return (Denominator == 0) ? 0 : Numerator / Denominator;
        }

        static public double SafeDivision(this double Numerator, double Denominator)
        {
            return (Denominator == 0 || Double.IsNaN(Denominator)) ? 0 : Numerator / Denominator;
        }

        static public decimal SafeDivision(this int Numerator, int Denominator)
        {
            return (Denominator == 0) ? 0 : Numerator / Denominator;
        }

        static public decimal CalcPowAndCheckNaN(double x, double y)
        {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                if (double.IsNaN(x) || double.IsNaN(y))
                {
                    return 0;
                }
                else
                {
                    return Convert.ToDecimal(Math.Pow(x, y));
                }
            }
            catch (Exception ex)
            {

                return 0;
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
        }

        static public double CalcPowAndCheckNaNDouble(double x, double y)
        {
            try
            {
                if (double.IsNaN(x) || double.IsNaN(y))
                {
                    return 0;
                }
                else
                {
                    return Convert.ToDouble(Math.Pow(x, y));
                }
            }
            catch (Exception)
            {

                return 0;
            }
        }

        static public Double CalcPowAndCheckNaN_V1(double x, double y)
        {
            if (double.IsNaN(Math.Pow(x, y)) || double.IsInfinity(Math.Pow(x, y)))
                return 1;
            else
            {
                return (Math.Pow(x, y));
            }
        }
    }
}