using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.NoteCalculator;
using CRES.Utilities;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;


namespace CRES.Services.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class VSTOController : ControllerBase
    {

        private readonly IEmailNotification _iEmailNotification;
        public VSTOController(IEmailNotification iemailNotification)
        {
            _iEmailNotification = iemailNotification;
        }

        //[Services.Controllers.IsAuthenticate]
        [HttpGet]
        [Services.Controllers.DeflateCompression]
        [Route("api/VSTO/ViewDictionary")]
        public List<DataDictionaryDataContract> ViewDictionary()
        {
            SizerGenericResult _authenticationResult = null;
            List<DataDictionaryDataContract> _lstDD = new List<DataDictionaryDataContract>();
            DynamicSizerLogic dySizerLogic = new DynamicSizerLogic();

            try
            {
                _lstDD = dySizerLogic.GetDataDictionary();
                if (_lstDD != null)
                {

                    _authenticationResult = new SizerGenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        DataDictionaryList = _lstDD
                    };
                }
                else
                {
                    _authenticationResult = new SizerGenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.VSTO.ToString(), "Error occurred in vsto ViewDictionary ", "", "", ex.TargetSite.Name.ToString(), "", ex);


                _authenticationResult = new SizerGenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return _lstDD;
        }

        [HttpGet]
        [Services.Controllers.DeflateCompression]
        [Route("api/VSTO/RefreshLookup")]
        public List<RefreshLookupDataContract> RefreshLookup()
        {
            SizerGenericResult authenticationResult = null;
            List<RefreshLookupDataContract> _lstlookup = new List<RefreshLookupDataContract>();

            DynamicSizerLogic dySizerLogic = new DynamicSizerLogic();
            _lstlookup = dySizerLogic.RefreshLookupList();

            try
            {
                if (_lstlookup != null)
                {

                    authenticationResult = new SizerGenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        LookupList = _lstlookup
                    };
                }
                else
                {
                    authenticationResult = new SizerGenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {

                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.VSTO.ToString(), "Error occurred in vsto RefreshLookup ", "", "", ex.TargetSite.Name.ToString(), "", ex);

                authenticationResult = new SizerGenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return _lstlookup;
        }

        [HttpPost]
        [Services.Controllers.DeflateCompression]
        [Route("api/VSTO/RunCalculator")]
        public IActionResult RunCalculator(string CREDealID)
        {
            SizerGenericResult authenticationResult = null;


#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            authenticationResult = new SizerGenericResult()
            {
                Succeeded = true,
                Message = "Deal Calculated Successfully.",

            };
            return Ok(authenticationResult);
        }

        //Read VSTOJson
        public DealDataContract ReadVSTOJSON(string json)
        {
            object jsonresult = new object();
            DealDataContract dealobjDC = new DealDataContract();
            List<PayruleDealFundingDataContract> _dealfundinglist = new List<PayruleDealFundingDataContract>();
            List<SizerScenarioDataContract> Scenariolist = new List<SizerScenarioDataContract>();
            List<NoteDataContract> _notelist = new List<NoteDataContract>();

            dynamic data = JObject.Parse(json);
            dealobjDC.actiontype = data["ActionType"];
            dealobjDC.output = data["CFOutputType"];
            dealobjDC.ScenarioText = "Sizer Only";
            //Deal
            var dealobject = data["M61.Tables.Deal"][0];
            dealobjDC.CREDealID = Convert.ToString(dealobject.CREDealID);
            dealobjDC.BatchID = Convert.ToInt32(dealobject.BatchID);
            dealobjDC.ClientDealID = Convert.ToString(dealobject.ClientDealID);
            dealobjDC.DealName = Convert.ToString(dealobject.DealName);
            dealobjDC.Statusid = CommonHelper.ToInt32(dealobject.Statusid);
            dealobjDC.StatusText = Convert.ToString(dealobject.StatusText);
            dealobjDC.AssetManager = Convert.ToString(dealobject.AssetManager);
            dealobjDC.DealCity = Convert.ToString(dealobject.DealCity);
            dealobjDC.DealState = Convert.ToString(dealobject.DealState);
            dealobjDC.DealPropertyType = Convert.ToString(dealobject.DealPropertyType);
            dealobjDC.TotalCommitment = CommonHelper.ToDecimal(dealobject.DealTotalCommitment);

            //DealFunding
            var dealfunding = data["M61.Tables.Deal"][0]["M61.Tables.DealFunding"];
            if (dealfunding != null)
            {
                var cnt = 1;
                for (var i = 0; i < dealfunding.Count; i++)
                {
                    PayruleDealFundingDataContract _dealfunding = new PayruleDealFundingDataContract();
                    _dealfunding.CREDealID = Convert.ToString(dealfunding[i].CREDealID);
                    _dealfunding.Date = dealfunding[i].Date == null ? null : CommonHelper.ToDateTime(dealfunding[i].Date);
                    _dealfunding.Value = CommonHelper.ToDecimal(dealfunding[i].Value);
                    _dealfunding.Comment = Convert.ToString(dealfunding[i].Comment);
                    _dealfunding.PurposeID = CommonHelper.ToInt32(dealfunding[i].PurposeID);
                    _dealfunding.PurposeText = Convert.ToString(dealfunding[i].PurposeText);
                    _dealfunding.DealFundingRowno = cnt;
                    _dealfundinglist.Add(_dealfunding);
                    cnt++;
                }
            }
            var Scenario = data["M61.Tables.Deal"][0]["M61.Tables.Scenario"];
            if (Scenario != null)
            {
                for (var i = 0; i < Scenario.Count; i++)
                {
                    SizerScenarioDataContract _scenariodc = new SizerScenarioDataContract();
                    _scenariodc.Maturity = CommonHelper.ToInt32(Scenario[i].Maturity);
                    _scenariodc.Spread = CommonHelper.ToDecimal(Scenario[i].Spread);
                    Scenariolist.Add(_scenariodc);
                }
            }
            //Note
            var notesobj = data["M61.Tables.Deal"][0]["M61.Tables.Note"];
            for (var i = 0; i < notesobj.Count; i++)
            {
                List<RateSpreadSchedule> _ratespreadlist = new List<RateSpreadSchedule>();
                List<PrepayAndAdditionalFeeScheduleDataContract> _prepayadditionalfeelist = new List<PrepayAndAdditionalFeeScheduleDataContract>();
                List<PIKSchedule> _pikschedulelist = new List<PIKSchedule>();
                List<FutureFundingScheduleTab> _fundingschedulelist = new List<FutureFundingScheduleTab>();
                List<PIKfromPIKSourceNoteTab> _pikscheduledetaillist = new List<PIKfromPIKSourceNoteTab>();
                List<FeeCouponStripReceivableTab> _feecouponstripreceivablelist = new List<FeeCouponStripReceivableTab>();
                List<FixedAmortScheduleTab> _amortschedulelist = new List<FixedAmortScheduleTab>();
                List<NoteDataContract> notepayulelist = new List<NoteDataContract>();
                List<SizerDocumentsDataContract> _sizerdoclist = new List<SizerDocumentsDataContract>();
                List<PayruleNoteAMSequenceDataContract> _fundingrepaymentsequencelist = new List<PayruleNoteAMSequenceDataContract>();
                List<PayruleSetupDataContract> _payrulelist = new List<PayruleSetupDataContract>();
                NoteDataContract _notes = new NoteDataContract();
                if (notesobj[i].CRENoteID == null)
                {
                    notesobj[i].CRENoteID = Convert.ToString(notesobj[i].ClientNoteID);
                    _notes.CRENoteID = Convert.ToString(notesobj[i].CRENoteID);
                }
                else
                {
                    _notes.CRENoteID = Convert.ToString(notesobj[i].CRENoteID);
                }
                _notes.CREDealID = Convert.ToString(notesobj[i].CREDealID);
                _notes.ClientNoteID = Convert.ToString(notesobj[i].ClientNoteID);
                _notes.Name = Convert.ToString(notesobj[i].Name);
                _notes.BaseCurrencyID = CommonHelper.ToInt32(notesobj[i].BaseCurrencyID);
                _notes.BaseCurrencyText = Convert.ToString(notesobj[i].BaseCurrencyText);
                _notes.IsCapitalized = CommonHelper.ToInt32(notesobj[i].IsCapitalized);
                _notes.IsCapitalizedText = Convert.ToString(notesobj[i].IsCapitalizedText);
                _notes.LoanType = CommonHelper.ToInt32(notesobj[i].LoanType);
                _notes.LoanTypeText = Convert.ToString(notesobj[i].LoanTypeText);
                _notes.PayFrequency = CommonHelper.ToInt32(notesobj[i].PayFrequency);
                // _notes.InitialMaturityDate = notesobj[i].InitialMaturityDate == null ? null : CommonHelper.ToDateTime(notesobj[i].InitialMaturityDate);
                // _notes.FullyExtendedMaturityDate = notesobj[i].FullyExtendedMaturityDate == null ? null : CommonHelper.ToDateTime(notesobj[i].FullyExtendedMaturityDate);
                _notes.ExpectedMaturityDate = notesobj[i].ExpectedMaturityDate == null ? null : CommonHelper.ToDateTime(notesobj[i].ExpectedMaturityDate);
                _notes.OpenPrepaymentDate = notesobj[i].OpenPrepaymentDate == null ? null : CommonHelper.ToDateTime(notesobj[i].OpenPrepaymentDate);
                // _notes.ExtendedMaturityScenario1 = notesobj[i].ExtendedMaturityScenario1 == null ? null : CommonHelper.ToDateTime(notesobj[i].ExtendedMaturityScenario1);
                // _notes.ExtendedMaturityScenario2 = notesobj[i].ExtendedMaturityScenario2 == null ? null : CommonHelper.ToDateTime(notesobj[i].ExtendedMaturityScenario2);
                // _notes.ExtendedMaturityScenario3 = notesobj[i].ExtendedMaturityScenario3 == null ? null : CommonHelper.ToDateTime(notesobj[i].ExtendedMaturityScenario3);
                _notes.ActualPayoffDate = notesobj[i].ActualPayoffDate == null ? null : CommonHelper.ToDateTime(notesobj[i].ActualPayoffDate);
                _notes.InitialInterestAccrualEndDate = notesobj[i].InitialInterestAccrualEndDate == null ? null : CommonHelper.ToDateTime(notesobj[i].InitialInterestAccrualEndDate);
                _notes.AccrualFrequency = CommonHelper.ToInt32(notesobj[i].AccrualFrequency);
                _notes.DeterminationDateLeadDays = CommonHelper.ToInt32(notesobj[i].DeterminationDateLeadDays);
                _notes.DeterminationDateReferenceDayoftheMonth = CommonHelper.ToInt32(notesobj[i].DeterminationDateReferenceDayoftheMonth);
                _notes.DeterminationDateInterestAccrualPeriod = CommonHelper.ToInt32(notesobj[i].DeterminationDateInterestAccrualPeriod);
                _notes.FirstPaymentDate = notesobj[i].FirstPaymentDate == null ? null : CommonHelper.ToDateTime(notesobj[i].FirstPaymentDate);
                _notes.InitialMonthEndPMTDateBiWeekly = notesobj[i].InitialMonthEndPMTDateBiWeekly == null ? null : CommonHelper.ToDateTime(notesobj[i].InitialMonthEndPMTDateBiWeekly);
                _notes.PaymentDateBusinessDayLag = CommonHelper.ToInt32(notesobj[i].PaymentDateBusinessDayLag);
                _notes.IOTerm = CommonHelper.ToInt32(notesobj[i].IOTerm);
                _notes.AmortTerm = CommonHelper.ToInt32(notesobj[i].AmortTerm);
                _notes.PIKSeparateCompounding = CommonHelper.ToInt32(notesobj[i].PIKSeparateCompounding);
                _notes.MonthlyDSOverridewhenAmortizing = CommonHelper.ToDecimal(notesobj[i].MonthlyDSOVerridewhenAmortizing);
                _notes.AccrualPeriodPaymentDayWhenNotEOMonth = CommonHelper.ToInt32(notesobj[i].AccrualPeriodPaymentDayWhenNotEOMonth);
                _notes.FirstPeriodInterestPaymentOverride = CommonHelper.ToDecimal(notesobj[i].FirstPeriodInterestPaymentOVerride);
                _notes.FirstPeriodPrincipalPaymentOverride = CommonHelper.ToDecimal(notesobj[i].FirstPeriodPrincipalPaymentOVerride);
                _notes.FinalInterestAccrualEndDateOverride = notesobj[i].FinalInterestAccrualEndDateOVerride == null ? null : CommonHelper.ToDateTime(notesobj[i].FinalInterestAccrualEndDateOVerride);
                _notes.AmortType = CommonHelper.ToInt32(notesobj[i].AmortType);
                _notes.RateType = CommonHelper.ToInt32(notesobj[i].RateType);
                _notes.RateTypeText = Convert.ToString(notesobj[i].RateTypeText);
                _notes.ReAmortizeMonthly = CommonHelper.ToInt32(notesobj[i].ReAmortizeMonthly);
                _notes.ReAmortizeMonthlyText = Convert.ToString(notesobj[i].ReAmortizeMonthlyText);
                _notes.ReAmortizeatPMTReset = CommonHelper.ToInt32(notesobj[i].ReAmortizeatPMTReset);
                _notes.ReAmortizeatPMTResetText = Convert.ToString(notesobj[i].ReAmortizeatPMTResetText);
                _notes.StubPaidInArrears = CommonHelper.ToInt32(notesobj[i].StubPaidInArrears);
                _notes.StubPaidInArrearsText = Convert.ToString(notesobj[i].StubPaidInArrearsText);
                _notes.SettleWithAccrualFlag = CommonHelper.ToInt32(notesobj[i].SettleWithAccrualFlag);
                _notes.SettleWithAccrualFlagText = Convert.ToString(notesobj[i].SettleWithAccrualFlagText);
                _notes.RateIndexResetFreq = CommonHelper.ToDecimal(notesobj[i].RateIndexResetFreq);
                _notes.FirstRateIndexResetDate = notesobj[i].FirstRateIndexResetDate == null ? null : CommonHelper.ToDateTime(notesobj[i].FirstRateIndexResetDate);
                _notes.LoanPurchase = CommonHelper.ToInt32(notesobj[i].LoanPurchase);
                _notes.LoanPurchaseYNText = Convert.ToString(notesobj[i].LoanPurchaseText);
                _notes.AmortIntCalcDayCount = CommonHelper.ToInt32(notesobj[i].AmortIntCalcDayCount);
                _notes.StubPaidinAdvanceYN = CommonHelper.ToInt32(notesobj[i].StubPaidinAdvanceYN);
                _notes.StubPaidinAdvanceYNText = Convert.ToString(notesobj[i].StubPaidinAdvanceYNText);
                _notes.FullPeriodInterestDueatMaturity = CommonHelper.ToInt32(notesobj[i].FullPeriodInterestDueatMaturity);
                _notes.Classification = CommonHelper.ToInt32(notesobj[i].Classification); //due
                _notes.SubClassification = CommonHelper.ToInt32(notesobj[i].SubClassification);
                _notes.GAAPDesignation = CommonHelper.ToInt32(notesobj[i].GAAPDesignation);
                _notes.PortfolioID = CommonHelper.ToInt32(notesobj[i].PortfolioID);
                _notes.GeographicLocation = CommonHelper.ToInt32(notesobj[i].GeographicLocation);
                _notes.PropertyType = CommonHelper.ToInt32(notesobj[i].PropertyType);
                _notes.RatingAgency = CommonHelper.ToInt32(notesobj[i].RatingAgency);
                _notes.RiskRating = CommonHelper.ToInt32(notesobj[i].RiskRating);
                _notes.PurchasePrice = CommonHelper.ToDecimal(notesobj[i].PurchasePrice);
                _notes.FutureFeesUsedforLevelYeild = CommonHelper.ToDecimal(notesobj[i].FutureFeesUsedforLeVelYeild);
                _notes.TotalToBeAmortized = CommonHelper.ToDecimal(notesobj[i].TotalToBeAmortized);
                _notes.StubPeriodInterest = CommonHelper.ToDecimal(notesobj[i].StubPeriodInterest);
                _notes.WDPAssetMultiple = CommonHelper.ToDecimal(notesobj[i].WDPAssetMultiple);
                _notes.WDPEquityMultiple = CommonHelper.ToDecimal(notesobj[i].WDPEquityMultiple);
                _notes.PurchaseBalance = CommonHelper.ToDecimal(notesobj[i].PurchaseBalance);
                _notes.DaysofAccrued = CommonHelper.ToInt32(notesobj[i].DaysofAccrued);
                _notes.InterestRate = CommonHelper.ToDecimal(notesobj[i].InterestRate);
                _notes.PurchasedInterestCalc = CommonHelper.ToDecimal(notesobj[i].PurchasedInterestCalc);
                _notes.ClosingDate = notesobj[i].ClosingDate == null ? null : CommonHelper.ToDateTime(notesobj[i].ClosingDate);
                _notes.InitialFundingAmount = CommonHelper.ToDecimal(notesobj[i].InitialFundingAmount);
                _notes.Discount = CommonHelper.ToDecimal(notesobj[i].Discount);
                _notes.OriginationFee = CommonHelper.ToDecimal(notesobj[i].OriginationFee);
                _notes.CapitalizedClosingCosts = CommonHelper.ToDecimal(notesobj[i].CapitalizedClosingCosts);
                _notes.PurchaseDate = notesobj[i].PurchaseDate == null ? null : CommonHelper.ToDateTime(notesobj[i].PurchaseDate);
                _notes.PurchaseAccruedFromDate = CommonHelper.ToDecimal(notesobj[i].PurchaseAccruedFromDate);
                _notes.PurchasedInterestOverride = CommonHelper.ToDecimal(notesobj[i].PurchasedInterestOVerride);
                _notes.DiscountRate = CommonHelper.ToDecimal(notesobj[i].DiscountRate);
                _notes.ValuationDate = notesobj[i].ValuationDate == null ? null : CommonHelper.ToDateTime(notesobj[i].ValuationDate);
                _notes.FairValue = CommonHelper.ToDecimal(notesobj[i].FairValue);
                _notes.DiscountRatePlus = CommonHelper.ToDecimal(notesobj[i].DiscountRatePlus);
                _notes.FairValuePlus = CommonHelper.ToDecimal(notesobj[i].FairValuePlus);
                _notes.DiscountRateMinus = CommonHelper.ToDecimal(notesobj[i].DiscountRateMinus);
                _notes.FairValueMinus = CommonHelper.ToDecimal(notesobj[i].FairValueMinus);
                _notes.InitialIndexValueOverride = CommonHelper.ToDecimal(notesobj[i].InitialIndexValueOVerride);
                _notes.IncludeServicingPaymentOverrideinLevelYield = CommonHelper.ToInt32(notesobj[i].IncludeSerVicingPaymentOVerrideinLeVelYield);
                _notes.IncludeServicingPaymentOverrideinLevelYieldText = Convert.ToString(notesobj[i].IncludeSerVicingPaymentOVerrideinLeVelYieldText);
                _notes.OngoingAnnualizedServicingFee = CommonHelper.ToDecimal(notesobj[i].OngoingAnnualizedSerVicingFee);
                _notes.IndexRoundingRule = CommonHelper.ToInt32(notesobj[i].IndexRoundingRule);
                _notes.RoundingMethod = CommonHelper.ToInt32(notesobj[i].RoundingMethod);
                _notes.RoundingMethodText = Convert.ToString(notesobj[i].RoundingMethodText);
                _notes.StubInterestPaidonFutureAdvances = CommonHelper.ToInt32(notesobj[i].StubInterestPaidonFutureAdVances);
                _notes.StubInterestPaidonFutureAdvancesText = Convert.ToString(notesobj[i].StubInterestPaidonFutureAdVancesText);
                _notes.TaxAmortCheck = Convert.ToString(notesobj[i].TaxAmortCheck);
                _notes.PIKWoCompCheck = Convert.ToString(notesobj[i].PIKWoCompCheck);
                _notes.GAAPAmortCheck = Convert.ToString(notesobj[i].GAAPAmortCheck);
                _notes.StubIntOverride = CommonHelper.ToDecimal(notesobj[i].StubIntOVerride);
                _notes.PurchasedInterestOverride = CommonHelper.ToDecimal(notesobj[i].PurchasedInterestOVerride);
                _notes.ExitFeeFreePrepayAmt = CommonHelper.ToDecimal(notesobj[i].ExitFeeFreePrepayAmt);
                // _notes.ExitFeeBaseAmountOverride = CommonHelper.ToDecimal(notesobj[i].ExitFeeBaseAmountOverride);
                _notes.ExitFeeAmortCheck = CommonHelper.ToInt32(notesobj[i].ExitFeeAmortCheck);
                _notes.FixedAmortSchedule = CommonHelper.ToInt32(notesobj[i].FixedAmortSchedule);
                _notes.TotalCommitmentExtensionFeeisBasedOn = CommonHelper.ToDecimal(notesobj[i].TotalCommitmentExtensionFeeisBasedOn);
                _notes.Priority = CommonHelper.ToInt32(notesobj[i].Priority);
                _notes.TotalCommitment = CommonHelper.ToDecimal(notesobj[i].TotalCommitment);
                _notes.IndexNameID = CommonHelper.ToInt32(notesobj[i].IndexNameID);
                _notes.IndexNameText = Convert.ToString(notesobj[i].IndexNameText);
                _notes.FutureFundingBillingCutoffDay = CommonHelper.ToInt32(notesobj[i].FutureFundingBillingCutoffDay);
                _notes.CurtailmentBillingCutoffDay = CommonHelper.ToInt32(notesobj[i].CurtailmentBillingCutoffDay);
                _notes.InterestCalculationRuleForPaydowns = CommonHelper.ToInt32(notesobj[i].InterestCalculationRuleForPaydowns);
                _notes.InterestCalculationRuleForPaydownsText = Convert.ToString(notesobj[i].InterestCalculationRuleForPaydownsText);
                _notes.DebtTypeID = CommonHelper.ToInt32(notesobj[i].DebtType);
                _notes.DebtTypeText = Convert.ToString(notesobj[i].DebtTypeText);
                _notes.BillingNotesID = CommonHelper.ToInt32(notesobj[i].BillingNotes);
                _notes.BillingNotesText = Convert.ToString(notesobj[i].BillingNotesText);
                _notes.CapStack = CommonHelper.ToInt32(notesobj[i].CapStack);
                _notes.CapStackText = Convert.ToString(notesobj[i].CapStackText);

                //RateSpreadSchedule
                if (notesobj[i]["M61.Tables.RateSpreadSchedule"] != null)
                {
                    for (var j = 0; j < notesobj[i]["M61.Tables.RateSpreadSchedule"].Count; j++)
                    {
                        RateSpreadSchedule _ratespread = new RateSpreadSchedule();
                        if (notesobj[i].CRENoteID == notesobj[i]["M61.Tables.RateSpreadSchedule"][j].CRENoteID)
                        {
                            _ratespread.Date = notesobj[i]["M61.Tables.RateSpreadSchedule"][j].Date == null ? null : CommonHelper.ToDateTime(notesobj[i]["M61.Tables.RateSpreadSchedule"][j].Date);
                            _ratespread.ValueTypeID = CommonHelper.ToInt32(notesobj[i]["M61.Tables.RateSpreadSchedule"][j].ValueTypeID);
                            _ratespread.ValueTypeText = Convert.ToString(notesobj[i]["M61.Tables.RateSpreadSchedule"][j].ValueTypeText);
                            _ratespread.Value = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.RateSpreadSchedule"][j].Value);
                            _ratespread.IntCalcMethodID = CommonHelper.ToInt32(notesobj[i]["M61.Tables.RateSpreadSchedule"][j].IntCalcMethodID);
                            _ratespread.IntCalcMethodText = Convert.ToString(notesobj[i]["M61.Tables.RateSpreadSchedule"][j].IntCalcMethodText);
                            _ratespread.RateOrSpreadToBeStripped = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.RateSpreadSchedule"][j].RateOrSpreadToBeStripped);
                            _ratespreadlist.Add(_ratespread);
                        }

                    }
                }
                //PrepayAdditionalFeeSchedule
                if (notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"] != null)
                {
                    for (var k = 0; k < notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"].Count; k++)
                    {
                        PrepayAndAdditionalFeeScheduleDataContract _prepayaddfeesch = new PrepayAndAdditionalFeeScheduleDataContract();
                        if (notesobj[i].CRENoteID == notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].CreNoteID)
                        {
                            _prepayaddfeesch.FeeName = Convert.ToString(notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].FeeName);
                            _prepayaddfeesch.StartDate = notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].StartDate == null ? null : CommonHelper.ToDateTime(notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].StartDate);
                            _prepayaddfeesch.ScheduleStartDate = _prepayaddfeesch.StartDate;
                            _prepayaddfeesch.ScheduleEndDate = notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].EndDate == null ? null : CommonHelper.ToDateTime(notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].EndDate);
                            _prepayaddfeesch.ValueTypeID = CommonHelper.ToInt32(notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].ValueTypeID);
                            _prepayaddfeesch.ValueTypeText = Convert.ToString(notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].ValueTypeText);
                            _prepayaddfeesch.Value = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].Value);
                            _prepayaddfeesch.FeeAmountOverride = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].FeeAmtOVerride);
                            _prepayaddfeesch.BaseAmountOverride = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].BaseAmtoVerride);
                            _prepayaddfeesch.ApplyTrueUpFeatureID = CommonHelper.ToInt32(notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].ApplyTrueUpFeatureID);
                            _prepayaddfeesch.ApplyTrueUpFeatureText = Convert.ToString(notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].ApplyTrueUpFeatureText);
                            _prepayaddfeesch.IncludedLevelYield = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].IncludedLeVelYield);
                            _prepayaddfeesch.IncludedBasis = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].IncludedBasis);
                            _prepayaddfeesch.FeeToBeStripped = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].FeeToStripped);
                            _notes.UnusedFeeThresholdBalance = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].UnusedFeeThresholdBalance);
                            _notes.UnusedFeePaymentFrequency = notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].UnusedFeePaymentFrequency == null ? 0 : Convert.ToInt32(notesobj[i]["M61.Tables.PrepayAndAdditionalFeeSchedule"][k].UnusedFeePaymentFrequency);

                            _prepayadditionalfeelist.Add(_prepayaddfeesch);
                        }
                    }
                }

                //FundingSchedule
                if (notesobj[i]["M61.Tables.FundingSchedule"] != null)
                {
                    for (var l = 0; l < notesobj[i]["M61.Tables.FundingSchedule"].Count; l++)
                    {
                        FutureFundingScheduleTab _futurefundingschedule = new FutureFundingScheduleTab();
                        if (notesobj[i].CRENoteID == notesobj[i]["M61.Tables.FundingSchedule"][l].CRENoteID)
                        {
                            _futurefundingschedule.Date = notesobj[i]["M61.Tables.FundingSchedule"][l].Date == null ? null : CommonHelper.ToDateTime(notesobj[i]["M61.Tables.FundingSchedule"][l].Date);
                            _futurefundingschedule.Value = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.FundingSchedule"][l].Value);
                            _futurefundingschedule.PurposeID = CommonHelper.ToInt32(notesobj[i]["M61.Tables.FundingSchedule"][l].PurposeID);
                            _futurefundingschedule.PurposeText = Convert.ToString(notesobj[i]["M61.Tables.FundingSchedule"][l].PurposeText);
                            _fundingschedulelist.Add(_futurefundingschedule);
                        }
                    }
                }
                //PIKSchedule  
                if (notesobj[i]["M61.Tables.PIKSchedule"] != null)
                {
                    for (var m = 0; m < notesobj[i]["M61.Tables.PIKSchedule"].Count; m++)
                    {
                        PIKSchedule _pikschedule = new PIKSchedule();
                        if (notesobj[i].CRENoteID == notesobj[i]["M61.Tables.PIKSchedule"][m].CRENoteID)
                        {
                            _pikschedule.SourceCRENoteId = notesobj[i]["M61.Tables.PIKSchedule"][m].SourceAccount;
                            _pikschedule.TargetCRENoteId = notesobj[i]["M61.Tables.PIKSchedule"][m].TargetAccount;
                            _pikschedule.AdditionalIntRate = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.PIKSchedule"][m].AdditionalIntRate);
                            _pikschedule.AdditionalSpread = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.PIKSchedule"][m].AdditionalSpread);
                            _pikschedule.IndexFloor = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.PIKSchedule"][m].IndexFloor);
                            _pikschedule.IntCompoundingRate = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.PIKSchedule"][m].CompoundingRate);
                            _pikschedule.IntCompoundingSpread = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.PIKSchedule"][m].CompoundingSpread);
                            _pikschedule.StartDate = notesobj[i]["M61.Tables.PIKSchedule"][m].StartDate == null ? null : CommonHelper.ToDateTime(notesobj[i]["M61.Tables.PIKSchedule"][m].StartDate);
                            _pikschedule.EndDate = notesobj[i]["M61.Tables.PIKSchedule"][m].EndDate == null ? null : CommonHelper.ToDateTime(notesobj[i]["M61.Tables.PIKSchedule"][m].EndDate);
                            _pikschedule.IntCapAmt = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.PIKSchedule"][m].IntCapAmt);
                            _pikschedule.PurBal = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.PIKSchedule"][m].PurBal);
                            _pikschedule.AccCapBal = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.PIKSchedule"][m].AccCapBal);
                            _pikschedulelist.Add(_pikschedule);
                        }
                    }
                }

                //PIKScheduleDetail
                if (notesobj[i]["M61.Tables.PIKScheduleDetail"] != null)
                {
                    for (var n = 0; n < notesobj[i]["M61.Tables.PIKScheduleDetail"].Count; n++)
                    {
                        PIKfromPIKSourceNoteTab _pikscheduledetail = new PIKfromPIKSourceNoteTab();
                        if (notesobj[i].CRENoteID == notesobj[i]["M61.Tables.PIKSchedule"][n].CRENoteID)
                        {
                            _pikscheduledetail.Date = notesobj[i]["M61.Tables.PIKSchedule"][n].Date == null ? null : CommonHelper.ToDateTime(notesobj[i]["M61.Tables.PIKSchedule"][n].Date);
                            _pikscheduledetail.Value = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.PIKSchedule"][n].Value);
                            _pikscheduledetaillist.Add(_pikscheduledetail);
                        }
                    }
                }

                //FeeCouponStripReceivableTab 
                if (notesobj[i]["M61.Tables.FeeCouponStripReceivable"] != null)
                {
                    for (var p = 0; p < notesobj[i]["M61.Tables.FeeCouponStripReceivable"].Count; p++)
                    {
                        FeeCouponStripReceivableTab _feecoupon = new FeeCouponStripReceivableTab();
                        if (notesobj[i].CRENoteID == notesobj[i]["M61.Tables.FeeCouponStripReceivable"][p].CRENoteID)
                        {
                            _feecoupon.Date = notesobj[i]["M61.Tables.FeeCouponStripReceivable"][p].Date == null ? null : CommonHelper.ToDateTime(notesobj[i]["M61.Tables.FeeCouponStripReceivable"][p].Date);
                            _feecoupon.Value = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.FeeCouponStripReceivable"][p].Value);
                            _feecouponstripreceivablelist.Add(_feecoupon);
                        }
                    }
                }

                //AmortFunding
                if (notesobj[i]["M61.Tables.AmortSchedule"] != null)
                {
                    for (var q = 0; q < notesobj[i]["M61.Tables.AmortSchedule"].Count; q++)
                    {
                        FixedAmortScheduleTab _amort = new FixedAmortScheduleTab();
                        if (notesobj[i].CRENoteID == notesobj[i]["M61.Tables.AmortSchedule"][q].CreNoteID)
                        {
                            _amort.Date = notesobj[i]["M61.Tables.AmortSchedule"][q].Date == null ? null : CommonHelper.ToDateTime(notesobj[i]["M61.Tables.AmortSchedule"][q].Date);
                            _amort.Value = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.AmortSchedule"][q].Amount);
                            _amortschedulelist.Add(_amort);
                        }
                    }
                }

                //NoteDocuments
                if (notesobj[i]["M61.Tables.NoteDocuments"] != null)
                {
                    for (var r = 0; r < notesobj[i]["M61.Tables.NoteDocuments"].Count; r++)
                    {
                        SizerDocumentsDataContract _notedoc = new SizerDocumentsDataContract();
                        if (notesobj[i].CRENoteID == notesobj[i]["M61.Tables.NoteDocuments"][r].CRENoteID)
                        {
                            _notedoc.DocLink = Convert.ToString(notesobj[i]["M61.Tables.NoteDocuments"][r].DocLink);
                            _notedoc.DocTypeID = CommonHelper.ToInt32(notesobj[i]["M61.Tables.NoteDocuments"][r].DocType);
                            _sizerdoclist.Add(_notedoc);
                        }
                    }
                }
                //Funding Repayment Sequence
                if (notesobj[i]["M61.Tables.FundingRepaymentSequence"] != null)
                {
                    for (var s = 0; s < notesobj[i]["M61.Tables.FundingRepaymentSequence"].Count; s++)
                    {
                        PayruleNoteAMSequenceDataContract _fundingrepayment = new PayruleNoteAMSequenceDataContract();
                        if (notesobj[i].CRENoteID == notesobj[i]["M61.Tables.FundingRepaymentSequence"][s].CRENoteID)
                        {
                            _fundingrepayment.SequenceNo = CommonHelper.ToInt32(notesobj[i]["M61.Tables.FundingRepaymentSequence"][s].SequenceNo);
                            _fundingrepayment.SequenceType = CommonHelper.ToInt32(notesobj[i]["M61.Tables.FundingRepaymentSequence"][s].SequenceType);
                            _fundingrepayment.Value = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.FundingRepaymentSequence"][s].Value);
                            _fundingrepaymentsequencelist.Add(_fundingrepayment);
                        }
                    }
                }

                //DealStrippingPayrules
                if (notesobj[i]["M61.Tables.DealStrippingPayrules"] != null)
                {
                    for (var t = 0; t < notesobj[i]["M61.Tables.DealStrippingPayrules"].Count; t++)
                    {
                        PayruleSetupDataContract _payrule = new PayruleSetupDataContract();
                        _payrule.StripTransferFrom = Convert.ToString(notesobj[i]["M61.Tables.DealStrippingPayrules"][t].StripTransferFrom);
                        _payrule.StripTransferTo = Convert.ToString(notesobj[i]["M61.Tables.DealStrippingPayrules"][t].StripTransferTo);
                        _payrule.RuleID = CommonHelper.ToInt32(notesobj[i]["M61.Tables.DealStrippingPayrules"][t].FeeName);
                        _payrule.RuleIDText = Convert.ToString(notesobj[i]["M61.Tables.DealStrippingPayrules"][t].RuleText);
                        _payrule.Value = CommonHelper.ToDecimal(notesobj[i]["M61.Tables.DealStrippingPayrules"][t].Value);
                        _payrulelist.Add(_payrule);
                    }
                }

                if (notesobj[i]["M61.Tables.DealFundingPayRules"] != null)
                {
                    for (var q = 0; q < notesobj[i]["M61.Tables.DealFundingPayRules"].Count; q++)
                    {
                        NoteDataContract notepay = new NoteDataContract();
                        if (notesobj[i].CRENoteID == notesobj[i]["M61.Tables.DealFundingPayRules"][q].Crenoteid)
                        {

                            notepay.CRENoteID = Convert.ToString(notesobj[i]["M61.Tables.DealFundingPayRules"][q].Crenoteid);
                            notepay.UseRuletoDetermineNoteFunding = CommonHelper.ToInt32(notesobj[i]["M61.Tables.DealFundingPayRules"][q].UseRuletoDetermineNoteFunding);
                            notepay.NoteFundingRule = CommonHelper.ToInt32(notesobj[i]["M61.Tables.DealFundingPayRules"][q].NoteFundingRule);
                            notepay.FundingPriority = CommonHelper.ToInt32(notesobj[i]["M61.Tables.DealFundingPayRules"][q].FundingPriority);
                            notepay.NoteBalanceCap = CommonHelper.ToInt32(notesobj[i]["M61.Tables.DealFundingPayRules"][q].NoteBalanceCap);
                            notepay.RepaymentPriority = CommonHelper.ToInt32(notesobj[i]["M61.Tables.DealFundingPayRules"][q].RepaymentPriority);
                            notepayulelist.Add(notepay);
                        }
                    }
                }
                _notes.RateSpreadScheduleList = _ratespreadlist;
                _notes.NotePrepayAndAdditionalFeeScheduleList = _prepayadditionalfeelist;
                _notes.ListFutureFundingScheduleTab = _fundingschedulelist;
                _notes.NotePIKScheduleList = _pikschedulelist;
                _notes.ListPIKfromPIKSourceNoteTab = _pikscheduledetaillist;
                _notes.ListFeeCouponStripReceivable = _feecouponstripreceivablelist;
                _notes.ListFixedAmortScheduleTab = _amortschedulelist;
                _notes.SizerDoc = _sizerdoclist;
                _notes.FundingRepaymentSequence = _fundingrepaymentsequencelist;
                _notes.NotePayRuleFundingParameters = notepayulelist;
                _notelist.Add(_notes);
            }
            dealobjDC.notelist = _notelist;
            dealobjDC.PayruleDealFundingList = _dealfundinglist;
            dealobjDC.ScenarioList = Scenariolist;
            return dealobjDC;
        }

        //ValidateData for calculation
        public List<NoteDataContract> Validatedata(List<NoteDataContract> _notedc, string ScenarioText)
        {
            NoteDataContract objNote = new NoteDataContract();
            DynamicSizerLogic _dynamicsizer = new DynamicSizerLogic();
            NoteLogic _notelogic = new NoteLogic();
            List<LiborScheduleTab> ListLiborScheduleTab = new List<LiborScheduleTab>();

            FeeConfigurationLogic _feeconfiglogic = new FeeConfigurationLogic();
            var userid = new Guid("B0E6697B-3534-4C09-BE0A-04473401AB93");

            objNote.DefaultScenarioParameters = _dynamicsizer.GetScenarioParameters(ScenarioText);
            objNote.ListHoliday = _notelogic.GetHolidayListForCalculator();
            //LiborscheduleeffectiveDate
            //_notedc[0].IndexNameText
            if (_notedc != null)
            {
                if (_notedc[0].CRENoteID == null)
                {
                    _notedc[0].CRENoteID = _notedc[0].ClientNoteID;
                }
                ListLiborScheduleTab = _dynamicsizer.GetLiborRateForVSTO(_notedc[0].CRENoteID, ScenarioText, _notedc[0].ClosingDate.Value);

            }
            for (var i = 0; i < _notedc.Count; i++)
            {
                _notedc[i].AnalysisID = new Guid(objNote.DefaultScenarioParameters.AnalysisID);

                if (_notedc[i].CRENoteID == null)
                {
                    _notedc[i].CRENoteID = _notedc[i].ClientNoteID;
                }

                NoteDataContract _objNote = new NoteDataContract();
                List<FeeFunctionsConfigDataContract> _feefunctionlist = new List<FeeFunctionsConfigDataContract>();
                List<FeeSchedulesConfigDataContract> _feeschedulelist = new List<FeeSchedulesConfigDataContract>();
                List<ScenarioParameterDataContract> _analysislist = new List<ScenarioParameterDataContract>();
                List<MaturityScenariosDataContract> MaturityScenariosList = new List<MaturityScenariosDataContract>();
                List<PIKSchedule> NotePIKScheduleList = new List<PIKSchedule>();
                List<RateSpreadSchedule> RateSpreadScheduleList = new List<RateSpreadSchedule>();
                List<StrippingScheduleDataContract> NoteStrippingList = new List<StrippingScheduleDataContract>();
                List<DefaultScheduleDataContract> NoteDefaultScheduleList = new List<DefaultScheduleDataContract>();
                List<PrepayAndAdditionalFeeScheduleDataContract> NotePrepayAndAdditionalFeeScheduleList = new List<PrepayAndAdditionalFeeScheduleDataContract>();
                List<FutureFundingScheduleTab> ListFutureFundingScheduleTab = new List<FutureFundingScheduleTab>();
                ;
                List<FixedAmortScheduleTab> ListFixedAmortScheduleTab = new List<FixedAmortScheduleTab>();
                List<ServicingLogTab> ListServicingLogTab = new List<ServicingLogTab>();
                List<EffectiveDateList> effectiveDateList = new List<EffectiveDateList>();

                //FeeSchedulesConfiguration
                _objNote.ListFeeSchedules = _feeconfiglogic.GetFeeSchedulesConfig(userid);
                //FeeFunctionsConfiguration
                _objNote.ListFeeFunctions = _feeconfiglogic.GetFeeFunctionsConfig(userid);
                //MaturityEffectiveDate
                MaturityScenariosDataContract msd = new MaturityScenariosDataContract();
                // msd.SelectedMaturityDate = _notedc[i].ClosingDate;
                MaturityScenariosList.Add(msd);
                //PIKScheduleeffectiveDate
                foreach (PIKSchedule _piksch in _notedc[i].NotePIKScheduleList)
                {
                    _piksch.EffectiveDate = _notedc[i].ClosingDate;
                    NotePIKScheduleList.Add(_piksch);
                }
                //RateSpreadEffectiveDate
                foreach (RateSpreadSchedule rs in _notedc[i].RateSpreadScheduleList)
                {
                    rs.EffectiveDate = _notedc[i].ClosingDate; ;
                    RateSpreadScheduleList.Add(rs);
                }

                //StrippingScheduleEffectiveDate
                StrippingScheduleDataContract _stripsdc = new StrippingScheduleDataContract();
                _stripsdc.EffectiveDate = _notedc[i].ClosingDate;
                NoteStrippingList.Add(_stripsdc);
                //DeafualtScheduleEffectivedate
                DefaultScheduleDataContract defaultsch = new DefaultScheduleDataContract();
                defaultsch.EffectiveDate = _notedc[i].ClosingDate;
                NoteDefaultScheduleList.Add(defaultsch);
                //PrepayandadditionalEffectiveDate  
                foreach (PrepayAndAdditionalFeeScheduleDataContract prepayadd in _notedc[i].NotePrepayAndAdditionalFeeScheduleList)
                {
                    prepayadd.EffectiveDate = _notedc[i].ClosingDate;
                    NotePrepayAndAdditionalFeeScheduleList.Add(prepayadd);
                }
                //FuturefundingEffectivedate
                foreach (FutureFundingScheduleTab fftab in _notedc[i].ListFutureFundingScheduleTab)
                {
                    fftab.EffectiveDate = _notedc[i].ClosingDate;
                    ListFutureFundingScheduleTab.Add(fftab);
                }
                //AmortScheduleEffectiveDate
                foreach (FixedAmortScheduleTab fixamort in _notedc[i].ListFixedAmortScheduleTab)
                {
                    fixamort.EffectiveDate = _notedc[i].ClosingDate;
                    ListFixedAmortScheduleTab.Add(fixamort);
                }

                ServicingLogTab servlog = new ServicingLogTab();
                servlog.TransactionAmount = 0;
                servlog.TransactionTypeText = null;
                ListServicingLogTab.Add(servlog);

                //Note Effectivedate list
                if (ListLiborScheduleTab != null)
                {
                    EffectiveDateList effdate = new EffectiveDateList();
                    effdate.EffectiveDate = _notedc[i].ClosingDate;
                    effdate.Type = "LIBORScheduleTab";
                    effectiveDateList.Add(effdate);
                }

                if (ListFutureFundingScheduleTab != null)
                {
                    EffectiveDateList effdateff = new EffectiveDateList();
                    effdateff.EffectiveDate = _notedc[i].ClosingDate;
                    effdateff.Type = "FFScheduleTab";
                    effectiveDateList.Add(effdateff);
                }

                _notedc[i].CalculationModeText = objNote.DefaultScenarioParameters.CalculationModeText;

                //Assign all effective date to notedc
                _notedc[i].ListFeeSchedules = _objNote.ListFeeSchedules;
                _notedc[i].ListFeeSchedulesConfiguration = _objNote.ListFeeSchedules;
                _notedc[i].ListFeeFunctions = _objNote.ListFeeFunctions;
                _notedc[i].ListLiborScheduleTab = ListLiborScheduleTab;
                _notedc[i].ListFixedAmortScheduleTab = ListFixedAmortScheduleTab;
                _notedc[i].ListFutureFundingScheduleTab = ListFutureFundingScheduleTab;
                _notedc[i].NotePrepayAndAdditionalFeeScheduleList = NotePrepayAndAdditionalFeeScheduleList;
                _notedc[i].NoteDefaultScheduleList = NoteDefaultScheduleList;
                _notedc[i].NoteStrippingList = NoteStrippingList;
                _notedc[i].RateSpreadScheduleList = RateSpreadScheduleList;
                _notedc[i].NotePIKScheduleList = NotePIKScheduleList;
                _notedc[i].MaturityScenariosList = MaturityScenariosList;
                _notedc[i].DefaultScenarioParameters = objNote.DefaultScenarioParameters;
                _notedc[i].ListHoliday = objNote.ListHoliday;
                _notedc[i].EffectiveDateList = effectiveDateList;
                _notedc[i].ListServicingLogTab = ListServicingLogTab;


                //SelectedMaturity
                // _notedc[i] = ScenarioRules.AssignValuesToSelectedMaturity(_notedc[i]);
            }
            return _notedc;
        }


        //Calculate VSTOJson Notes
        public List<NoteOutputforVSTO> CalculateNote(List<NoteDataContract> _notedc, string ScenarioText, string sizerCalcMode, int batchid, List<SizerScenarioDataContract> ListSizerScenario)
        {
            List<NoteOutputforVSTO> Resultjson = new List<NoteOutputforVSTO>();
            JArray OutputObject = new JArray();
            DynamicSizerLogic _dynamicsizer = new DynamicSizerLogic();
            List<SizerScenarioDataContract> ListBatchDetail = new List<SizerScenarioDataContract>();
            List<NoteDataContract> noteDC = Validatedata(_notedc, ScenarioText);
            // Calc Without Save
            //Calculation
            int batchlogID = batchid;
            for (var j = 0; j < noteDC.Count; j++)
            { // run for all scentio 
                foreach (var item in ListSizerScenario)
                {
                    SizerScenarioDataContract ssdc = new SizerScenarioDataContract();
                    ssdc.CRENoteID = _notedc[j].CRENoteID;
                    ssdc.Maturity = item.Maturity;
                    ssdc.BatchDetailID = _dynamicsizer.InsertBatchIntoDetail(Convert.ToInt32(batchlogID), _notedc[j].CRENoteID, Convert.ToString(item.Maturity));
                    ListBatchDetail.Add(ssdc);
                }
            }

            if (sizerCalcMode == "Calc Without Save")
            {
                Parallel.ForEach(noteDC,
   new ParallelOptions { MaxDegreeOfParallelism = 2 },
                                     (_cmDC) =>
                                     {   //run for all  Scenario
                                         foreach (var item1 in ListSizerScenario)
                                         {
                                             int maturity = Convert.ToInt32(item1.Maturity);
                                             int batchDetailID = GetBatchDetailID(_cmDC.CRENoteID, maturity, ListBatchDetail);
                                             NoteOutputforVSTO _noteoutput = new NoteOutputforVSTO();
                                             CalculationMaster cm = new CalculationMaster();
                                             // _cmDC.SelectedMaturityDate = _cmDC.FirstPaymentDate.Value.AddMonths(maturity - 1);
                                             NoteDataContract outputnote = cm.StartCalculation(_cmDC);

                                             if (outputnote != null && outputnote.CalculatorExceptionMessage == "Succeed")
                                             {
                                                 //_dynamicsizer.InsertNotePeriodicCalcVSTO(outputnote.ListNotePeriodicOutputs, "admin_qa", _cmDC.CRENoteID, batchDetailID, Convert.ToString(item1.Maturity));
                                                 _dynamicsizer.InsertTransactionVSTO(outputnote.ListCashflowTransactionEntry, _cmDC.CRENoteID, batchDetailID, Convert.ToString(item1.Maturity), _cmDC.Name);
                                                 _dynamicsizer.UpdateNoteStatusAndTime(Convert.ToInt32(batchlogID), _cmDC.CRENoteID, batchDetailID);

                                             }
                                             else
                                             {

                                             }
                                         }


                                     });

            }
            else
            {
                for (var i = 0; i < noteDC.Count; i++)
                {

                    NoteOutputforVSTO _noteoutput = new NoteOutputforVSTO();
                    CalculationMaster cm = new CalculationMaster();
                    NoteDataContract outputnote = cm.StartCalculation(noteDC[i]);

                    //outputnote.ListNotePeriodicOutputs.ForEach(x => { x.CRENoteId = _notedc[i].CRENoteID; x.NoteName = _notedc[i].Name; });
                    outputnote.ListCashflowTransactionEntry.ForEach(x => { x.CRENoteID = _notedc[i].CRENoteID; x.NoteName = _notedc[i].Name; });

                    //_noteoutput.ListNotePeriodicOutputs = outputnote.ListNotePeriodicOutputs;
                    _noteoutput.ListCashflowTransactionEntry = outputnote.ListCashflowTransactionEntry;
                    Resultjson.Add(_noteoutput);
                }
            }

            return Resultjson;
        }

        [HttpPost]
        [Route("api/VSTO/CalcandSaveVSTOJson")]
        public string CalcandSaveVSTOJson([FromBody] dynamic json)
        {
            string status = "Not Completed";
            Thread FirstThread = new Thread(() => CalcandSaveSizerData(json));
            FirstThread.Start();
            return status;
        }

        public void CalcandSaveSizerData(dynamic json)
        {
            List<NoteOutputforVSTO> _NoteoutputJson = new List<NoteOutputforVSTO>();
            DealDataContract dealdc = ReadVSTOJSON(json);

            if (dealdc.PayruleDealFundingList != null)
            {
                dealdc.PayruleDealFundingList = dealdc.PayruleDealFundingList.OrderBy(x => x.Date).ToList();
            }

            List<NoteDataContract> _notelist = dealdc.notelist;
            DynamicSizerLogic dynamicSizerLogic = new DynamicSizerLogic();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            List<NoteOutputforVSTO> noteoutput = new List<NoteOutputforVSTO>();
            var headerUserID = new Guid();

            if (dealdc.actiontype == "Save Without Calc")
            {
                dynamicSizerLogic.SaveJSONDeal(dealdc, headerUserID.ToString());
            }
            NoteLogic notelogic = new NoteLogic();

            if (dealdc.actiontype == "Calc Without Save")
            {
                _NoteoutputJson = CalculateNote(_notelist, dealdc.ScenarioText, dealdc.actiontype, dealdc.BatchID, dealdc.ScenarioList);
                // noteoutput = _NoteoutputJson;
            }
            if (dealdc.actiontype == "Calc and Save")
            {
                List<string> newnoteid = new List<string>();

                NoteLogic _notelogic = new NoteLogic();
                dynamicSizerLogic.SaveJSONDeal(dealdc, headerUserID.ToString());

                List<PayruleTargetNoteFundingScheduleDataContract> notefunding = RegenerateNoteFunding(dealdc);
                dynamicSizerLogic.SaveNoteFunding(notefunding, headerUserID.ToString());

                List<FutureFundingScheduleTab> Fundinglist = new List<FutureFundingScheduleTab>();

                foreach (var notes in _notelist)
                {
                    notes.ListFutureFundingScheduleTab = new List<FutureFundingScheduleTab>();
                    foreach (var item in notefunding)
                    {
                        if (notes.NoteId == item.NoteID.ToString() && item.PurposeID != 351)
                        {
                            FutureFundingScheduleTab ff = new FutureFundingScheduleTab();

                            ff.EffectiveDate = notes.ClosingDate.Value.Date;
                            ff.Date = item.Date.Value.Date;
                            ff.Value = item.Value;
                            ff.PurposeID = item.PurposeID;
                            ff.PurposeText = item.Purpose;
                            ff.Value = item.Value;
                            notes.ListFutureFundingScheduleTab.Add(ff);
                        }
                    }
                }

                newnoteid = dealdc.Listnewnoteids;
                noteoutput = CalculateNote(_notelist, dealdc.ScenarioText, dealdc.actiontype, dealdc.BatchID, dealdc.ScenarioList);
                foreach (var item in noteoutput)
                {
                    for (var i = 0; i < newnoteid.Count; i++)
                    {
                        NoteDataContract _note = new NoteDataContract();
                        _notelogic.InsertNotePeriodicCalc(item.ListNotePeriodicOutputs);
                        _notelogic.InsertCashflowTransaction(item.ListCashflowTransactionEntry, newnoteid[i], headerUserID.ToString());
                    }
                }

            }

            // to call for AIEntityApi
            if (dealdc.actiontype != "Calc Without Save")
            {
                AIDynamicEntityUpdateLogic _dynamicentity = new AIDynamicEntityUpdateLogic();
                Thread FirstThread = new Thread(() => _dynamicentity.InsertUpdateAIDealEntitiesAsync(dealdc, headerUserID.ToString()));
                FirstThread.Start();
            }
        }

        [HttpPost]
        [Route("api/VSTO/CheckPermssionAndDuplicateDeal")]
        public string CheckPermssionAndDuplicateDeal([FromBody] dynamic json)
        {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                string result = "";
                string DealID = Convert.ToString(json["CREDealID"]);
                string DealName = Convert.ToString(json["DealName"]);
                string UserName = Convert.ToString(json["UserName"]);
                string PassWord = Convert.ToString(json["PassWord"]);

                //DealDataContract dealdc = ReadVSTOJSON(json);
                DynamicSizerLogic dynamicSizerLogic = new DynamicSizerLogic();
                result = dynamicSizerLogic.CheckPermssionAndDuplicateDeal(DealID, DealName, UserName, PassWord);

                return result;
            }
            catch (Exception ex)
            {

                throw;
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
        }

        [HttpPost]
        [Route("api/vsto/authenticateM61User")]
        public string authenticateM61User([FromBody] dynamic inputjson)
        {
            string Message = "";
            GenericResult _authenticationResult = null;
            UserDataContract _userdatacontract = new UserDataContract();
            UserLogic userlogic = new UserLogic();
            try
            {
                string UserName = Convert.ToString(inputjson["UserName"]);
                string Password = Convert.ToString(inputjson["PassWord"]);
                string EncruptPassword = Encryptor.MD5Hash(Password);

                _userdatacontract = userlogic.ValidateUser(UserName, EncruptPassword);

                if (_userdatacontract != null)
                {
                    Message = "Authentication succeeded";
                }
                else
                {
                    Message = "Username and password don't match to our records.";

                }
            }
            catch (Exception ex)
            {

                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.VSTO.ToString(), "Error occurred in vsto authenticateM61User ", "", "", ex.TargetSite.Name.ToString(), "", ex);


                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }

            return Message;

        }

        public List<PayruleTargetNoteFundingScheduleDataContract> RegenerateNoteFunding(DealDataContract dealdc)
        {
            PayruleNoteFutureFundingHelper pm = new PayruleNoteFutureFundingHelper();
            NoteLogic nl = new NoteLogic();
            DealDataContract dc = new DealDataContract();

            dc.PayruleNoteDetailFundingList = new List<PayruleNoteDetailFundingDataContract>();
            dc.PayruleNoteAMSequenceList = new List<PayruleNoteAMSequenceDataContract>();
            dc.PayruleNoteDetailFundingList = new List<PayruleNoteDetailFundingDataContract>();
            dc.PayruleTargetNoteFundingScheduleList = new List<PayruleTargetNoteFundingScheduleDataContract>();
            foreach (var notes in dealdc.notelist)
            {
                var noteseqlist = notes.FundingRepaymentSequence;
                var notedetailfundparalist = notes.NotePayRuleFundingParameters;
                foreach (var noteseq in noteseqlist)
                {
                    PayruleNoteAMSequenceDataContract _fundingDC = new PayruleNoteAMSequenceDataContract();
                    _fundingDC.NoteID = noteseq.NoteID;
                    _fundingDC.SequenceNo = noteseq.SequenceNo;
                    _fundingDC.SequenceType = noteseq.SequenceType;

                    if (noteseq.SequenceType == 258)
                    {
                        _fundingDC.SequenceTypeText = "Funding Sequence";
                    }
                    else if (noteseq.SequenceType == 259)
                    {
                        _fundingDC.SequenceTypeText = "Repayment Sequence";
                    }
                    _fundingDC.Value = noteseq.Value;

                    dc.PayruleNoteAMSequenceList.Add(_fundingDC);
                }
                foreach (var _note in notedetailfundparalist)
                {
                    PayruleNoteDetailFundingDataContract _notedc = new PayruleNoteDetailFundingDataContract();
                    _notedc.NoteID = new Guid(_note.NoteId);
                    _notedc.CRENoteID = _note.CRENoteID;
                    _notedc.NoteName = _note.Name;
                    _notedc.UseRuletoDetermineNoteFunding = _note.UseRuletoDetermineNoteFunding;

                    if (_notedc.UseRuletoDetermineNoteFunding == 3)
                    {
                        _notedc.UseRuletoDetermineNoteFundingText = "Y";
                    }
                    else if (_notedc.UseRuletoDetermineNoteFunding == 4)
                    {
                        _notedc.UseRuletoDetermineNoteFundingText = "N";
                    }
                    _notedc.NoteFundingRule = _note.NoteFundingRule;

                    if (_notedc.NoteFundingRule == 260)
                    {
                        _notedc.NoteFundingRuleText = "ProRata";
                    }
                    else if
                      (_notedc.NoteFundingRule == 261)
                    {

                        _notedc.NoteFundingRuleText = "Sequential";
                    }
                    _notedc.NoteBalanceCap = _note.NoteBalanceCap;
                    _notedc.FundingPriority = _note.FundingPriority;
                    _notedc.RepaymentPriority = _note.RepaymentPriority;
                    _notedc.TotalCommitment = _note.TotalCommitment;
                    dc.PayruleNoteDetailFundingList.Add(_notedc);
                }
            }

            dc.PayruleDealFundingList = dealdc.PayruleDealFundingList;
            DealDataContract result = new DealDataContract();
            result = pm.StartCalculation(dc);
            return result.PayruleTargetNoteFundingScheduleList;
        }

        [HttpPost]
        [Route("api/VSTO/uploadgenericentity")]
        public GenericVSTOResult UploadGenericEntity([FromBody] dynamic inputjson)
        {

            GenericVSTOResult _GenericVSTOResult = null;
            string Message = "";
            string UserName = "";
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
#pragma warning disable CS0219 // The variable 'uploaddrawfee' is assigned but its value is never used
            bool uploaddrawfee = false;
#pragma warning restore CS0219 // The variable 'uploaddrawfee' is assigned but its value is never used

            DataTable apidata = new DataTable();
            DynamicSizerLogic _dynamicsizer = new DynamicSizerLogic();

            List<string> _tablesList = new List<string>();
            _tablesList = _dynamicsizer.GetNamedRangeUsedInBatchUpload();

            try
            {

                dynamic data = JObject.Parse(inputjson);
                List<GenericEntityDataContract> lstGenericEntity = new List<GenericEntityDataContract>();
                List<DrawFeeInvoiceBatchUploadDataContract> lstInvoices = new List<DrawFeeInvoiceBatchUploadDataContract>();

                foreach (string tablename in _tablesList)
                {
                    var genericEntityobject = data[tablename];

                    if (genericEntityobject != null)
                    {
                        if (genericEntityobject[0].UserName != "")
                        {
                            UserName = genericEntityobject[0].UserName;
                        }
                        if (tablename == "M61.Tables.Invoices")
                        {
                            uploaddrawfee = true;
                            for (var i = 0; i < genericEntityobject.Count; i++)
                            {
                                DrawFeeInvoiceBatchUploadDataContract did = new DrawFeeInvoiceBatchUploadDataContract();
                                if (genericEntityobject[i].CreDealID != null)
                                {
                                    did.CreDealID = Convert.ToString(genericEntityobject[i].CreDealID);
                                }
                                if (genericEntityobject[i].InvoiceDate != null)
                                {
                                    did.InvoiceDate = Convert.ToDateTime(genericEntityobject[i].InvoiceDate);
                                    did.InvoiceDateOriginal = Convert.ToDateTime(genericEntityobject[i].InvoiceDate);
                                }

                                if (genericEntityobject[i].InvoiceNo != null)
                                {
                                    did.InvoiceNo = Convert.ToString(genericEntityobject[i].InvoiceNo);
                                }

                                if (genericEntityobject[i].InvoiceDueDate != null)
                                {
                                    did.InvoiceDueDate = Convert.ToDateTime(genericEntityobject[i].InvoiceDueDate);
                                }
                                if (genericEntityobject[i].Amount != null)
                                {
                                    did.Amount = Convert.ToDecimal(genericEntityobject[i].Amount);
                                }
                                if (genericEntityobject[i].InvoiceTypeID != null)
                                {
                                    did.InvoiceTypeID = Convert.ToInt32(genericEntityobject[i].InvoiceTypeID);
                                }
                                if (genericEntityobject[i].DrawFeeStatus != null)
                                {
                                    did.DrawFeeStatus = Convert.ToInt32(genericEntityobject[i].DrawFeeStatus);
                                }
                                if (genericEntityobject[i].FirstName != null)
                                {
                                    did.FirstName = Convert.ToString(genericEntityobject[i].FirstName);
                                }
                                if (genericEntityobject[i].LastName != null)
                                {
                                    did.LastName = Convert.ToString(genericEntityobject[i].LastName);
                                }
                                if (genericEntityobject[i].Designation != null)
                                {
                                    did.Designation = Convert.ToString(genericEntityobject[i].Designation);
                                }
                                if (genericEntityobject[i].CompanyName != null)
                                {
                                    did.CompanyName = Convert.ToString(genericEntityobject[i].CompanyName);
                                }
                                if (genericEntityobject[i].Address != null)
                                {
                                    did.Address = Convert.ToString(genericEntityobject[i].Address);
                                }
                                if (genericEntityobject[i].City != null)
                                {
                                    did.City = Convert.ToString(genericEntityobject[i].City);
                                }
                                if (genericEntityobject[i].State != null)
                                {
                                    did.State = Convert.ToString(genericEntityobject[i].State);
                                }
                                if (genericEntityobject[i].Zip != null)
                                {
                                    did.Zip = Convert.ToString(genericEntityobject[i].Zip);
                                }
                                if (genericEntityobject[i].Email1 != null)
                                {
                                    did.Email1 = Convert.ToString(genericEntityobject[i].Email1);
                                }
                                if (genericEntityobject[i].Email2 != null)
                                {
                                    did.Email2 = Convert.ToString(genericEntityobject[i].Email2);
                                }
                                if (genericEntityobject[i].PhoneNo != null)
                                {
                                    did.PhoneNo = Convert.ToString(genericEntityobject[i].PhoneNo);
                                }
                                if (genericEntityobject[i].AlternatePhone != null)
                                {
                                    did.AlternatePhone = Convert.ToString(genericEntityobject[i].AlternatePhone);
                                }
                                if (genericEntityobject[i].Comment != null)
                                {
                                    did.Comment = Convert.ToString(genericEntityobject[i].Comment);
                                }

                                lstInvoices.Add(did);
                            }
                        }
                        else
                        {
                            uploaddrawfee = false;

                            for (var i = 0; i < genericEntityobject.Count; i++)
                            {
                                GenericEntityDataContract dcGenericEntity = new GenericEntityDataContract();

                                if (genericEntityobject[i].NoteID != null)
                                {
                                    dcGenericEntity.NoteID = Convert.ToString(genericEntityobject[i].NoteID);
                                }
                                if (genericEntityobject[i].NoteName != null)
                                {
                                    dcGenericEntity.NoteName = Convert.ToString(genericEntityobject[i].NoteName);
                                }
                                if (genericEntityobject[i].DueDate != null)
                                {
                                    dcGenericEntity.DueDate = CommonHelper.ToDateTime(genericEntityobject[i].DueDate);
                                }
                                if (genericEntityobject[i].Value != null)
                                {
                                    dcGenericEntity.Value = CommonHelper.ToDecimal(genericEntityobject[i].Value);
                                }

                                if (genericEntityobject[i].TransactionTypeID != null)
                                {
                                    dcGenericEntity.TransactionTypeID = CommonHelper.ToInt32(genericEntityobject[i].TransactionTypeID);
                                }

                                if (genericEntityobject[i].RemitDate != null)
                                {
                                    dcGenericEntity.RemitDate = CommonHelper.ToDateTime(genericEntityobject[i].RemitDate);
                                }
                                else
                                {
                                    dcGenericEntity.RemitDate = dcGenericEntity.DueDate;
                                }

                                if (genericEntityobject[i].EffectiveDate != null)
                                {
                                    dcGenericEntity.EffectiveDate = CommonHelper.ToDateTime(genericEntityobject[i].EffectiveDate);
                                }
                                if (genericEntityobject[i].CashNonCashText != null)
                                {
                                    dcGenericEntity.Cash_NonCash = genericEntityobject[i].CashNonCashText;
                                }

                                dcGenericEntity.TableName = tablename;
                                lstGenericEntity.Add(dcGenericEntity);
                            }
                        }

                    }
                }

                int ingnoredrecords = 0;
                int totalrecords = 0;
                int? batchid = 0;
                if (lstGenericEntity != null)
                {
                    totalrecords = lstGenericEntity.Count;
                    batchid = _dynamicsizer.AddGenericEntity(lstGenericEntity, UserName);

                    apidata = _dynamicsizer.GetBatchUploadSummary(batchid);
                    ingnoredrecords = apidata.Rows.Count;

                    Thread FirstThread = new Thread(() => CriticalExceptionValidation(batchid, UserName, Message, apidata));
                    FirstThread.Start();
                }
                batchid = 0;
                DataTable datainvoice = new DataTable();

                if (lstInvoices != null)
                {
                    WFLogic wf = new WFLogic();
                    totalrecords = totalrecords + lstInvoices.Count;
                    batchid = wf.InsertInvoiceDetailByBatchUpload(UserName, lstInvoices);
                    datainvoice = _dynamicsizer.GetBatchUploadSummaryInvoices(batchid);
                    ingnoredrecords = ingnoredrecords + datainvoice.Rows.Count;
                    //call method to create invoice in QB
                    WFController sc = new WFController(_iEmailNotification);
                    Thread FirstThread = new Thread(() => sc.ProcessInvoiceUploadedByBatch());
                    FirstThread.Start();
                    //
                }
                if (apidata.Rows.Count > 0)
                {
                    if (datainvoice.Rows.Count > 0)
                    {
                        apidata.Merge(datainvoice);
                    }
                }
                else if (datainvoice.Rows.Count > 0)
                {
                    apidata = datainvoice;
                }
                if (ingnoredrecords > 0)
                {
                    Message = "Out of " + totalrecords + " records " + ingnoredrecords + " records are not updated during upload. Please see Batch Upload Summary tab for ignored record";
                }
                else
                {
                    Message = totalrecords + " " + "records inserted successfully.";
                }
                _GenericVSTOResult = new GenericVSTOResult()
                {
                    Succeeded = true,
                    Message = Message,
                    apiResult = apidata
                };

            }
            catch (Exception ex)
            {
                Message = "Error in Uploading data.";

                _GenericVSTOResult = new GenericVSTOResult()
                {
                    Succeeded = true,
                    Message = Message,
                    apiResult = apidata
                };

                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.VSTO.ToString(), "Error occurred in vsto UploadGenericEntity ", "", "", ex.TargetSite.Name.ToString(), "", ex);
            }

            return _GenericVSTOResult;
        }

        public void CriticalExceptionValidation(int? batchID, string username, string uploadsummary, DataTable apidate)
        {
            DynamicSizerLogic _dynamicsizer = new DynamicSizerLogic();
            DataTable dt = _dynamicsizer.GetNotesWithPikData(batchID);
            Decimal? sumactual = 0, sumCashFlow = 0;
            List<ExceptionDataContract> exceptionlist = new List<ExceptionDataContract>();
            string FieldName = "PIK Balance";
            string noteid = "";
            List<string> noteidlist = new List<string>();
            List<GenericVSTOResult> summarylist = new List<GenericVSTOResult>();
            foreach (DataRow dr in dt.Rows)
            {
                noteid = Convert.ToString(dr["noteid"]);
                DataTable data = _dynamicsizer.GetPikPaidTransactionByCREnoteID(noteid);
                string NoteID = "";
                sumCashFlow = 0;
                sumactual = 0;
                foreach (DataRow row in data.Rows)
                {
                    if (Convert.ToString(row["Tabletype"]) == "Actual")
                    {
                        sumactual = 0;
                        sumactual = CommonHelper.ToDecimal(row["Amount"]);
                    }
                    if (Convert.ToString(row["Tabletype"]) == "CashFlow")
                    {
                        sumCashFlow = 0;
                        sumCashFlow = CommonHelper.ToDecimal(row["Amount"]);
                    }
                    NoteID = Convert.ToString(row["NoteID"]);

                }
                ValidationEngine ve = new ValidationEngine();
                string Validationmessage = ve.ValidatePikBalance(sumactual, sumCashFlow);
                if (Validationmessage != "")
                {
                    GenericVSTOResult gv = new GenericVSTOResult();
                    gv.CRENoteID = noteid;
                    gv.Comment = "Critical Exception : " + Validationmessage;
                    summarylist.Add(gv);

                    ExceptionDataContract edc = new ExceptionDataContract();
                    edc.ObjectID = new Guid(NoteID);
                    edc.ObjectTypeText = "Note";
                    edc.FieldName = FieldName;
                    edc.Summary = Validationmessage;
                    edc.ActionLevelText = "Critical";
                    exceptionlist.Add(edc);
                }
                else
                {
                    noteidlist.Add(NoteID);
                }
            }
            ExceptionsLogic _ExceptionsLogic = new ExceptionsLogic();
            if (exceptionlist.Count > 0)
            {
                _ExceptionsLogic.InsertExceptionsByFieldName(exceptionlist, username, FieldName);
            }
            else
            {
                foreach (var id in noteidlist)
                {
                    //remove old exceptions
                    _ExceptionsLogic.DeleteExceptionByobjectByFieldName(id, "note", FieldName);
                }

            }

            if (apidate.Rows.Count > 0)
            {
                foreach (DataRow dr in apidate.Rows)
                {
                    GenericVSTOResult gv = new GenericVSTOResult();
                    gv.CRENoteID = Convert.ToString(dr["noteid"]);
                    gv.Comment = Convert.ToString(dr["comment"]);
                    summarylist.Add(gv);
                }
            }

            uploadsummary = uploadsummary.Replace("Please see Batch Upload Summary tab for ignored record", "");
            uploadsummary = uploadsummary + "Please see below Batch Upload exception Summary.";

            //send notes for calcuation

            List<CalculationManagerDataContract> nlist = new List<CalculationManagerDataContract>();

            DataTable note = _dynamicsizer.GetNoteForcalcByBatchID(batchID);
            string PriorityText = "Real Time";
            if (note.Rows.Count > 0)
            {
                if (note.Rows.Count > 20)
                {
                    PriorityText = "Batch";
                }
                foreach (DataRow dr1 in note.Rows)
                {
                    CalculationManagerDataContract cdc = new CalculationManagerDataContract();

                    cdc.StatusText = "Processing";
                    cdc.UserName = "B0E6697B-3534-4C09-BE0A-04473401AB93";
                    cdc.ApplicationText = "";
                    cdc.NoteId = Convert.ToString(dr1["noteid"]);
                    cdc.PriorityText = PriorityText;
                    nlist.Add(cdc);
                }
            }
            CalculationManagerLogic calculationlogic = new CalculationManagerLogic();
            calculationlogic.QueueNotesForCalculation(nlist, "B0E6697B-3534-4C09-BE0A-04473401AB93");

            //email send code
            if (summarylist.Count > 0)
            {
                _iEmailNotification.BatchUploadSummaryNotification(summarylist, uploadsummary, username);
            }

        }


        [HttpGet]
        [Services.Controllers.DeflateCompression]
        [Route("api/VSTO/CheckAsynchronous")]
        public string CheckAsynchronous()
        {
            string message = "";
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Thread.Sleep(180000);
                message = "after 3 min";
            }
            catch (Exception ex)
            {


            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            return message;
        }


        [HttpPost]
        [Route("api/vsto/createNewBatch")]
        public string CreateNewBatch([FromBody] dynamic inputjson)
        {
            string batchlogID = "";
            DynamicSizerLogic _dynamicsizer = new DynamicSizerLogic();
            try
            {

                string UserName = Convert.ToString(inputjson["UserName"]);
                batchlogID = _dynamicsizer.CreateNewBatch(UserName);
                // InsertBatchIntoDetail(Convert.ToInt32(batchlogID), "236987");
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.VSTO.ToString(), "Error occurred in vsto authenticateM61User ", "", "", ex.TargetSite.Name.ToString(), "", ex);
            }
            return batchlogID;
        }


        [HttpPost]
        [Route("api/vsto/checkCalculationStatus")]
        public GenericVSTOResult CheckCalculationStatus([FromBody] dynamic inputjson)
        {
            GenericVSTOResult result = new GenericVSTOResult();
#pragma warning disable CS0219 // The variable 'Status' is assigned but its value is never used
            string Status = "";
#pragma warning restore CS0219 // The variable 'Status' is assigned but its value is never used
            DynamicSizerLogic _dynamicsizer = new DynamicSizerLogic();
            try
            {

                int batchid = Convert.ToInt32(inputjson["BatchID"]);
                result = _dynamicsizer.CheckCalculationStatus(batchid);
                result.Succeeded = true;
            }
            catch (Exception ex)
            {
                result.Succeeded = false;
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.VSTO.ToString(), "Error occurred in vsto authenticateM61User ", "", "", ex.TargetSite.Name.ToString(), "", ex);
            }
            return result;
        }


        [HttpPost]
        [Route("api/vsto/getM61CashFlowByBatchID")]
        public List<CalculatorOuputForVSTO> GetM61CashFlowByBatchID([FromBody] dynamic inputjson)
        {
            List<CalculatorOuputForVSTO> Resultjson = new List<CalculatorOuputForVSTO>();
            CalculatorOuputForVSTO cov = new CalculatorOuputForVSTO();
            DynamicSizerLogic _dynamicsizer = new DynamicSizerLogic();
            try
            {
                int batchid = Convert.ToInt32(inputjson["BatchID"]);
                List<TransactionEntryVSTO> ListTransactionEntry = _dynamicsizer.GetTransactionEntryByBatchID(batchid);
                // List<PeriodicCashflowVSTO> ListCashFlow = _dynamicsizer.GetNotePeriodicCalcByNoteId(batchid);

                cov.XIRROutput = _dynamicsizer.GetXIRROutputByBatchID(batchid);
                cov.ListTransactionEntry = ListTransactionEntry;
                //cov.ListNotePeriodicOutputs = ListCashFlow;
                Resultjson.Add(cov);

            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.VSTO.ToString(), "Error occurred in vsto GetM61CashFlowByBatchID ", "", "", ex.TargetSite.Name.ToString(), "", ex);
            }
            return Resultjson;
        }


        public int GetBatchDetailID(string crenoteid, int scenario, List<SizerScenarioDataContract> listitem)
        {
            int batchdetailid = 0;
            foreach (SizerScenarioDataContract ssd in listitem)
            {
                if (ssd.CRENoteID == crenoteid && ssd.Maturity == scenario)
                {
                    batchdetailid = Convert.ToInt32(ssd.BatchDetailID);
                    break;
                }
            }

            return batchdetailid;

        }

        [HttpPost]
        [Route("api/VSTO/InsertUpdateDeal")]
        public string InsertUpdateDeal([FromBody] dynamic json)
        {
            LoggerLogic Log = new LoggerLogic();
            string status = "";
            try
            {
                List<NoteOutputforVSTO> _NoteoutputJson = new List<NoteOutputforVSTO>();
                DealDataContract dealdc = ReadVSTOJSON(json);
                var headerUserID = new Guid();

                DynamicSizerLogic dynamicSizerLogic = new DynamicSizerLogic();
                dynamicSizerLogic.SaveJSONDeal(dealdc, headerUserID.ToString());
                status = "Completed";
            }
            catch (Exception ex)
            {
                status = "Error";
                Log.WriteLogException(CRESEnums.Module.VSTO.ToString(), "Error occurred in vsto InsertUpdateDeal ", "", "", ex.TargetSite.Name.ToString(), "", ex);
            }
            return status;
        }
    }
}