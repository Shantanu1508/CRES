using CRES.DAL.IRepository;
using CRES.DAL.Helper;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DAL.Repository
{
    public class DynamicSizerRepository : IDynamicSizerRepository
    {
        public List<DataDictionaryDataContract> GetDataDictionary()
        {
            List<DataDictionaryDataContract> _dcList = new List<DataDictionaryDataContract>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            dt = hp.ExecDataTable("usp_GetDataDictionary");
            foreach (DataRow dr in dt.Rows)
            {
                DataDictionaryDataContract _ndc = new DataDictionaryDataContract();
                // _ndc.DataDictionaryID = CommonHelper.ToInt32(dr["DataDictionaryID"]);
                _ndc.NamedRange = Convert.ToString(dr["NamedRange"]);
                _ndc.NamedCell = Convert.ToString(dr["NamedCell"]);
                _ndc.DBField = Convert.ToString(dr["DBField"]);
                _ndc.IsDropDown = Convert.ToString(dr["IsDropDown"]);
                _ndc.DataType = Convert.ToString(dr["DataType"]);
                _ndc.Required = Convert.ToString(dr["Required"]);
                _ndc.UsedInSizer = Convert.ToString(dr["UsedInSizer"]);
                _ndc.UsedInBatchUpload = Convert.ToString(dr["UsedInBatchUpload"]);
                _dcList.Add(_ndc);
            }
            return _dcList;
        }

        public List<RefreshLookupDataContract> RefreshLookupList()
        {
            List<RefreshLookupDataContract> _lookuplist = new List<RefreshLookupDataContract>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            dt = hp.ExecDataTable("usp_RefreshLookupList");
            foreach (DataRow dr in dt.Rows)
            {
                RefreshLookupDataContract lookup = new RefreshLookupDataContract();
                lookup.Name = Convert.ToString(dr["Name"]);
                lookup.LookupID = Convert.ToString(dr["LookupID"]);
                lookup.DisplayValues = Convert.ToString(dr["DisplayValues"]);
                lookup.ParentID = Convert.ToInt32(dr["ParentId"]);

                _lookuplist.Add(lookup);
            }
            return _lookuplist;

        }

        public List<RefreshTagXIRRDataContract> RefreshTagXIRR()
        {
            List<RefreshTagXIRRDataContract> _lsttagXIRR = new List<RefreshTagXIRRDataContract>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            dt = hp.ExecDataTable("usp_RefreshTagXIRR");
            foreach (DataRow dr in dt.Rows)
            {
                RefreshTagXIRRDataContract tags = new RefreshTagXIRRDataContract();
                tags.TableName = Convert.ToString(dr["TableName"]);
                tags.TagName = Convert.ToString(dr["TagName"]);
                tags.ObjectID = Convert.ToString(dr["ObjectID"]);
                tags.NoteName = Convert.ToString(dr["NoteName"]);
                tags.CREDealID = Convert.ToString(dr["CREDealID"]);
                tags.DealName = Convert.ToString(dr["DealName"]);
                tags.Location = Convert.ToString(dr["Location"]);
                tags.PropertyType = Convert.ToString(dr["PropertyType"]);
                tags.FinancingSourceType = Convert.ToString(dr["FinancingSourceType"]);

                _lsttagXIRR.Add(tags);
            }
            return _lsttagXIRR;

        }

        public DealDataContract SaveJSONDeal(DealDataContract _dealDC, string UserID)
        {
            try
            {
                DataTable dt = new DataTable();
                DealDataContract _deal = new DealDataContract();
                Helper.Helper hp = new Helper.Helper();
                _dealDC.Listnewnoteids = new List<string>();
                // var arrayList = new ArrayList();
                SqlParameter del1 = new SqlParameter { ParameterName = "@credealid", Value = _dealDC.CREDealID };
                SqlParameter[] sqlparamdel = new SqlParameter[] { del1 };
                dt = hp.ExecDataTable("dbo.usp_DeleteDealDataSizer", sqlparamdel);

                List<string> arrayList = new List<string>();

                SqlParameter p1 = new SqlParameter { ParameterName = "@CREDealID", Value = _dealDC.CREDealID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ClientDealID", Value = _dealDC.ClientDealID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@DealName", Value = _dealDC.DealName };
                SqlParameter p4 = new SqlParameter { ParameterName = "@Status", Value = _dealDC.Statusid };
                SqlParameter p5 = new SqlParameter { ParameterName = "@AssetManager", Value = _dealDC.AssetManager };
                SqlParameter p6 = new SqlParameter { ParameterName = "@DealCity", Value = _dealDC.DealCity };
                SqlParameter p7 = new SqlParameter { ParameterName = "@DealState", Value = _dealDC.DealState };
                SqlParameter p8 = new SqlParameter { ParameterName = "@DealPropertyType", Value = _dealDC.DealPropertyType };
                SqlParameter p9 = new SqlParameter { ParameterName = "@TotalCommitment", Value = _dealDC.TotalCommitment.GetValueOrDefault(0) };
                SqlParameter p10 = new SqlParameter { ParameterName = "@CreatedBy", Value = UserID };
                SqlParameter p12 = new SqlParameter { ParameterName = "@EnableAutoSpread", Value = _dealDC.EnableAutoSpread };

                SqlParameter p11 = new SqlParameter { ParameterName = "@NewDealID", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12 };
                dt = hp.ExecDataTable("dbo.usp_SaveDealSizer", sqlparam);
                var NewDealID = string.IsNullOrEmpty(Convert.ToString(p11.Value)) ? null : Convert.ToString(p11.Value);
                _dealDC.DealID = new Guid(NewDealID);

                foreach (var item in _dealDC.PayruleDealFundingList)
                {
                    SqlParameter b1 = new SqlParameter { ParameterName = "@CREDealID", Value = _dealDC.CREDealID };
                    SqlParameter b2 = new SqlParameter { ParameterName = "@Date", Value = item.Date == null ? (Object)DBNull.Value : item.Date };
                    SqlParameter b3 = new SqlParameter { ParameterName = "@Amount", Value = item.Value.GetValueOrDefault(0) };
                    SqlParameter b4 = new SqlParameter { ParameterName = "@PurposeID", Value = item.PurposeID };
                    SqlParameter b5 = new SqlParameter { ParameterName = "@Comment", Value = item.Comment };
                    SqlParameter b6 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UserID };
                    SqlParameter[] _sqlparam = new SqlParameter[] { b1, b2, b3, b4, b5, b6 };
                    hp.ExecNonquery("dbo.usp_InsertDealFundingScheduleSizer", _sqlparam);
                }

                foreach (var item in _dealDC.notelist)
                {
                    SqlParameter q1 = new SqlParameter { ParameterName = "@CreDealID", Value = _dealDC.CREDealID };
                    SqlParameter q2 = new SqlParameter { ParameterName = "@CRENoteID", Value = item.CRENoteID };
                    SqlParameter q3 = new SqlParameter { ParameterName = "@name", Value = item.Name };
                    SqlParameter q4 = new SqlParameter { ParameterName = "@ClosingDate", Value = item.ClosingDate == null ? (Object)DBNull.Value : item.ClosingDate };
                    SqlParameter q5 = new SqlParameter { ParameterName = "@BaseCurrencyID", Value = item.BaseCurrencyID };
                    SqlParameter q6 = new SqlParameter { ParameterName = "@IsCapitalized", Value = item.IsCapitalized };
                    SqlParameter q7 = new SqlParameter { ParameterName = "@LoanType", Value = item.LoanType };
                    SqlParameter q8 = new SqlParameter { ParameterName = "@PayFrequency", Value = item.PayFrequency };
                    SqlParameter q9 = new SqlParameter { ParameterName = "@InitialMaturityDate", Value = item.InitialMaturityDate == null ? (Object)DBNull.Value : item.InitialMaturityDate };
                    SqlParameter q10 = new SqlParameter { ParameterName = "@FullyExtendedMaturityDate", Value = item.FullyExtendedMaturityDate == null ? (Object)DBNull.Value : item.FullyExtendedMaturityDate };
                    SqlParameter q11 = new SqlParameter { ParameterName = "@ExpectedMaturityDate", Value = item.ExpectedMaturityDate == null ? (Object)DBNull.Value : item.ExpectedMaturityDate };
                    SqlParameter q12 = new SqlParameter { ParameterName = "@OpenPrepaymentDate", Value = item.OpenPrepaymentDate == null ? (Object)DBNull.Value : item.OpenPrepaymentDate };

                    SqlParameter q16 = new SqlParameter { ParameterName = "@ActualPayoffDate", Value = item.ActualPayoffDate == null ? (Object)DBNull.Value : item.ActualPayoffDate };
                    SqlParameter q17 = new SqlParameter { ParameterName = "@InitialInterestAccrualEndDate", Value = item.InitialInterestAccrualEndDate == null ? (Object)DBNull.Value : item.InitialInterestAccrualEndDate };
                    SqlParameter q18 = new SqlParameter { ParameterName = "@AccrualFrequency", Value = item.AccrualFrequency };
                    SqlParameter q19 = new SqlParameter { ParameterName = "@DeterminationDateLeadDays", Value = item.DeterminationDateLeadDays };
                    SqlParameter q20 = new SqlParameter { ParameterName = "@DeterminationDateReferenceDayoftheMonth", Value = item.DeterminationDateReferenceDayoftheMonth };
                    SqlParameter q21 = new SqlParameter { ParameterName = "@DeterminationDateInterestAccrualPeriod", Value = item.DeterminationDateInterestAccrualPeriod };
                    SqlParameter q22 = new SqlParameter { ParameterName = "@FirstPaymentDate", Value = item.FirstPaymentDate == null ? (Object)DBNull.Value : item.FirstPaymentDate };
                    SqlParameter q23 = new SqlParameter { ParameterName = "@InitialMonthEndPMTDateBiWeekly", Value = item.InitialMonthEndPMTDateBiWeekly == null ? (Object)DBNull.Value : item.InitialMonthEndPMTDateBiWeekly };
                    SqlParameter q24 = new SqlParameter { ParameterName = "@PaymentDateBusinessDayLag", Value = item.PaymentDateBusinessDayLag };
                    SqlParameter q25 = new SqlParameter { ParameterName = "@IOTerm", Value = item.IOTerm };
                    SqlParameter q26 = new SqlParameter { ParameterName = "@AmortTerm", Value = item.AmortTerm };
                    SqlParameter q27 = new SqlParameter { ParameterName = "@PIKSeparateCompounding", Value = item.PIKSeparateCompounding };
                    SqlParameter q28 = new SqlParameter { ParameterName = "@MonthlyDSOverridewhenAmortizing", Value = item.MonthlyDSOverridewhenAmortizing };
                    SqlParameter q29 = new SqlParameter { ParameterName = "@AccrualPeriodPaymentDayWhenNotEOMonth", Value = item.AccrualPeriodPaymentDayWhenNotEOMonth };
                    SqlParameter q30 = new SqlParameter { ParameterName = "@FirstPeriodInterestPaymentOverride", Value = item.FirstPeriodInterestPaymentOverride };
                    SqlParameter q31 = new SqlParameter { ParameterName = "@FirstPeriodPrincipalPaymentOverride", Value = item.FirstPeriodPrincipalPaymentOverride };
                    SqlParameter q32 = new SqlParameter { ParameterName = "@FinalInterestAccrualEndDateOverride", Value = item.FinalInterestAccrualEndDateOverride == null ? (Object)DBNull.Value : item.FinalInterestAccrualEndDateOverride };
                    SqlParameter q33 = new SqlParameter { ParameterName = "@AmortType", Value = item.AmortType };
                    SqlParameter q34 = new SqlParameter { ParameterName = "@RateType", Value = item.RateType };
                    SqlParameter q35 = new SqlParameter { ParameterName = "@ReAmortizeMonthly", Value = item.ReAmortizeMonthly };
                    SqlParameter q36 = new SqlParameter { ParameterName = "@ReAmortizeatPMTReset", Value = item.ReAmortizeatPMTReset };
                    SqlParameter q37 = new SqlParameter { ParameterName = "@StubPaidInArrears", Value = item.StubPaidInArrears };
                    SqlParameter q38 = new SqlParameter { ParameterName = "@SettleWithAccrualFlag", Value = item.SettleWithAccrualFlag };
                    SqlParameter q39 = new SqlParameter { ParameterName = "@RateIndexResetFreq", Value = item.RateIndexResetFreq };
                    SqlParameter q40 = new SqlParameter { ParameterName = "@FirstRateIndexResetDate", Value = item.FirstRateIndexResetDate == null ? (Object)DBNull.Value : item.FirstRateIndexResetDate };
                    SqlParameter q41 = new SqlParameter { ParameterName = "@LoanPurchase", Value = item.LoanPurchase };
                    SqlParameter q42 = new SqlParameter { ParameterName = "@AmortIntCalcDayCount", Value = item.AmortIntCalcDayCount };
                    SqlParameter q43 = new SqlParameter { ParameterName = "@StubPaidinAdvanceYN", Value = item.StubPaidinAdvanceYN };
                    SqlParameter q44 = new SqlParameter { ParameterName = "@FullPeriodInterestDueatMaturity", Value = item.FullPeriodInterestDueatMaturity };
                    SqlParameter q45 = new SqlParameter { ParameterName = "@Classification", Value = item.Classification };
                    SqlParameter q46 = new SqlParameter { ParameterName = "@SubClassification", Value = item.SubClassification };
                    SqlParameter q47 = new SqlParameter { ParameterName = "@GAAPDesignation", Value = item.GAAPDesignation };
                    SqlParameter q48 = new SqlParameter { ParameterName = "@PortfolioID", Value = item.PortfolioID };
                    SqlParameter q49 = new SqlParameter { ParameterName = "@GeographicLocation", Value = item.GeographicLocation };
                    SqlParameter q50 = new SqlParameter { ParameterName = "@PropertyType", Value = item.PropertyType };
                    SqlParameter q51 = new SqlParameter { ParameterName = "@RatingAgency", Value = item.RatingAgency };
                    SqlParameter q52 = new SqlParameter { ParameterName = "@RiskRating", Value = item.RiskRating };
                    SqlParameter q53 = new SqlParameter { ParameterName = "@PurchasePrice", Value = item.PurchasePrice };
                    SqlParameter q54 = new SqlParameter { ParameterName = "@FutureFeesUsedforLevelYeild", Value = item.FutureFeesUsedforLevelYeild };
                    SqlParameter q55 = new SqlParameter { ParameterName = "@TotalToBeAmortized", Value = item.TotalToBeAmortized };
                    SqlParameter q56 = new SqlParameter { ParameterName = "@StubPeriodInterest", Value = item.StubPeriodInterest };
                    SqlParameter q57 = new SqlParameter { ParameterName = "@WDPAssetMultiple", Value = item.WDPAssetMultiple };
                    SqlParameter q58 = new SqlParameter { ParameterName = "@WDPEquityMultiple", Value = item.WDPEquityMultiple };
                    SqlParameter q59 = new SqlParameter { ParameterName = "@PurchaseBalance", Value = item.PurchaseBalance };
                    SqlParameter q60 = new SqlParameter { ParameterName = "@DaysofAccrued", Value = item.DaysofAccrued };
                    SqlParameter q61 = new SqlParameter { ParameterName = "@InterestRate", Value = item.InterestRate };
                    SqlParameter q62 = new SqlParameter { ParameterName = "@PurchasedInterestCalc", Value = item.PurchasedInterestCalc };
                    SqlParameter q63 = new SqlParameter { ParameterName = "@InitialFundingAmount", Value = item.InitialFundingAmount };
                    SqlParameter q64 = new SqlParameter { ParameterName = "@Discount", Value = item.Discount };
                    SqlParameter q65 = new SqlParameter { ParameterName = "@OriginationFee", Value = item.OriginationFee };
                    SqlParameter q66 = new SqlParameter { ParameterName = "@CapitalizedClosingCosts", Value = item.CapitalizedClosingCosts };
                    SqlParameter q67 = new SqlParameter { ParameterName = "@PurchaseDate", Value = item.PurchaseDate == null ? (Object)DBNull.Value : item.PurchaseDate };
                    SqlParameter q68 = new SqlParameter { ParameterName = "@PurchaseAccruedFromDate", Value = item.PurchaseAccruedFromDate };
                    SqlParameter q69 = new SqlParameter { ParameterName = "@PurchasedInterestOverride", Value = item.PurchasedInterestOverride };
                    SqlParameter q70 = new SqlParameter { ParameterName = "@DiscountRate", Value = item.DiscountRate };
                    SqlParameter q71 = new SqlParameter { ParameterName = "@ValuationDate", Value = item.ValuationDate == null ? (Object)DBNull.Value : item.ValuationDate };
                    SqlParameter q72 = new SqlParameter { ParameterName = "@FairValue", Value = item.FairValue };
                    SqlParameter q73 = new SqlParameter { ParameterName = "@DiscountRatePlus", Value = item.DiscountRatePlus };
                    SqlParameter q74 = new SqlParameter { ParameterName = "@FairValuePlus", Value = item.FairValuePlus };
                    SqlParameter q75 = new SqlParameter { ParameterName = "@DiscountRateMinus", Value = item.DiscountRateMinus };
                    SqlParameter q76 = new SqlParameter { ParameterName = "@FairValueMinus", Value = item.FairValueMinus };
                    SqlParameter q77 = new SqlParameter { ParameterName = "@InitialIndexValueOverride", Value = item.InitialIndexValueOverride };
                    SqlParameter q78 = new SqlParameter { ParameterName = "@IncludeServicingPaymentOverrideinLevelYield", Value = item.IncludeServicingPaymentOverrideinLevelYield };
                    SqlParameter q79 = new SqlParameter { ParameterName = "@OngoingAnnualizedServicingFee", Value = item.OngoingAnnualizedServicingFee };
                    SqlParameter q80 = new SqlParameter { ParameterName = "@IndexRoundingRule", Value = item.IndexRoundingRule };
                    SqlParameter q81 = new SqlParameter { ParameterName = "@RoundingMethod", Value = item.RoundingMethod };
                    SqlParameter q82 = new SqlParameter { ParameterName = "@StubInterestPaidonFutureAdvances", Value = item.StubInterestPaidonFutureAdvances };
                    SqlParameter q83 = new SqlParameter { ParameterName = "@TaxAmortCheck", Value = item.TaxAmortCheck };
                    SqlParameter q84 = new SqlParameter { ParameterName = "@PIKWoCompCheck", Value = item.PIKWoCompCheck };
                    SqlParameter q85 = new SqlParameter { ParameterName = "@GAAPAmortCheck", Value = item.GAAPAmortCheck };
                    SqlParameter q86 = new SqlParameter { ParameterName = "@StubIntOverride", Value = item.StubIntOverride };
                    SqlParameter q87 = new SqlParameter { ParameterName = "@ExitFeeFreePrepayAmt", Value = item.ExitFeeFreePrepayAmt };
                    SqlParameter q89 = new SqlParameter { ParameterName = "@ExitFeeAmortCheck", Value = item.ExitFeeAmortCheck };
                    SqlParameter q90 = new SqlParameter { ParameterName = "@FixedAmortScheduleCheck", Value = item.FixedAmortSchedule };
                    SqlParameter q91 = new SqlParameter { ParameterName = "@TotalCommitmentExtensionFeeisBasedOn", Value = item.TotalCommitmentExtensionFeeisBasedOn };
                    SqlParameter q92 = new SqlParameter { ParameterName = "@priority", Value = item.Priority };
                    SqlParameter q93 = new SqlParameter { ParameterName = "@TotalCommitment", Value = item.TotalCommitment };
                    SqlParameter q94 = new SqlParameter { ParameterName = "@IndexNameID", Value = item.IndexNameID };
                    SqlParameter q95 = new SqlParameter { ParameterName = "@BillingNotesID", Value = item.BillingNotesID };
                    SqlParameter q96 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UserID };
                    SqlParameter q97 = new SqlParameter { ParameterName = "@FutureFundingBillingCutoffDay", Value = item.FutureFundingBillingCutoffDay };
                    SqlParameter q98 = new SqlParameter { ParameterName = "@CurtailmentBillingCutoffDay", Value = item.CurtailmentBillingCutoffDay };
                    SqlParameter q99 = new SqlParameter { ParameterName = "@InterestCalculationRuleForPaydowns", Value = item.InterestCalculationRuleForPaydowns };
                    SqlParameter q100 = new SqlParameter { ParameterName = "@DebtTypeID", Value = item.DebtTypeID };
                    SqlParameter q101 = new SqlParameter { ParameterName = "@CapStack", Value = item.CapStack };
                    SqlParameter q103 = new SqlParameter { ParameterName = "@LienPosition", Value = item.LienPosition };

                    SqlParameter q104 = new SqlParameter { ParameterName = "@InterestCalculationRuleForPaydownsAmort ", Value = item.InterestCalculationRuleForPaydownsAmort };
                    SqlParameter q105 = new SqlParameter { ParameterName = "@DayoftheMonth  ", Value = item.DayoftheMonth };
                    SqlParameter q106 = new SqlParameter { ParameterName = "@RepaymentDayoftheMonth ", Value = item.RepaymentDayoftheMonth };
                    SqlParameter q107 = new SqlParameter { ParameterName = "@FinancingSourceID ", Value = item.FinancingSourceID };
                    SqlParameter q108 = new SqlParameter { ParameterName = "@ServicerNameID", Value = item.ServicerNameID };

                    SqlParameter q102 = new SqlParameter { ParameterName = "@NoteID", Direction = ParameterDirection.Output, Size = int.MaxValue };
                    SqlParameter[] sqlparam1 = new SqlParameter[] { q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q16,q17,q18,q19,q20,q21,q22,q23,q24,q25,q26,q27,q28,q29,q30,q31,q32
                                                           ,q33,q34,q35,q36,q37,q38,q39,q40,q41,q42,q43,q44,q45,q46,q47,q48,q49,q50,q51,q52,q53,q54,q55,q56,q57,q58,q59,q60,q61,q62
                                                           ,q63,q64,q65,q66,q67,q68,q69,q70,q71,q72,q73,q74,q75,q76,q77,q78,q79,q80,q81,q82,q83,q84,q85,q86,q87,q89,q90,q91,q92
                                                           ,q93,q94,q95,q96,q97,q98,q99,q100,q101, q103, q104, q105, q106,q107,q108,q102 };
                    hp.ExecNonquery("dbo.usp_InsertNoteSizerForVSTO", sqlparam1);
                    var noteid = string.IsNullOrEmpty(Convert.ToString(q102.Value)) ? null : Convert.ToString(q102.Value);
                    arrayList.Add(noteid);
                    item.NoteId = noteid;

                    //Delete NoteData of Sizer
                    SqlParameter r1 = new SqlParameter { ParameterName = "@CRENoteID", Value = item.CRENoteID };
                    SqlParameter[] sqlparam2 = new SqlParameter[] { r1 };
                    hp.ExecNonquery("dbo.usp_DeleteNoteDataSizer", sqlparam2);

                    //Insert NoteData of Sizer - RateSpreadSchedule
                    foreach (var ratespread in item.RateSpreadScheduleList)
                    {
                        SqlParameter s1 = new SqlParameter { ParameterName = "@creNoteID", Value = item.CRENoteID };
                        SqlParameter s2 = new SqlParameter { ParameterName = "@StartDate", Value = ratespread.Date == null ? (Object)DBNull.Value : ratespread.Date };
                        SqlParameter s3 = new SqlParameter { ParameterName = "@ValueTypeID", Value = ratespread.ValueTypeID };
                        SqlParameter s4 = new SqlParameter { ParameterName = "@Value", Value = ratespread.Value };
                        SqlParameter s5 = new SqlParameter { ParameterName = "@IntCalcMethodID", Value = ratespread.IntCalcMethodID };
                        SqlParameter s6 = new SqlParameter { ParameterName = "@RateOrSpreadToBeStripped", Value = ratespread.RateOrSpreadToBeStripped };
                        SqlParameter s7 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UserID };
                        SqlParameter[] sqlparam3 = new SqlParameter[] { s1, s2, s3, s4, s5, s6, s7 };
                        hp.ExecNonquery("dbo.usp_InsertRateSpreadScheduleSizer", sqlparam3);
                    }
                    //Insert NoteData of Sizer - PrepayAndAdditionalFeeSchedule
                    foreach (var prepayandadditionalfeeschedule in item.NotePrepayAndAdditionalFeeScheduleList)
                    {
                        SqlParameter t1 = new SqlParameter { ParameterName = "@creNoteID", Value = item.CRENoteID };
                        SqlParameter t2 = new SqlParameter { ParameterName = "@StartDate", Value = prepayandadditionalfeeschedule.StartDate == null ? (Object)DBNull.Value : prepayandadditionalfeeschedule.StartDate };
                        SqlParameter t3 = new SqlParameter { ParameterName = "@ValueTypeID", Value = prepayandadditionalfeeschedule.ValueTypeID };
                        SqlParameter t4 = new SqlParameter { ParameterName = "@Value", Value = prepayandadditionalfeeschedule.Value };
                        SqlParameter t5 = new SqlParameter { ParameterName = "@IncludedLevelYield", Value = prepayandadditionalfeeschedule.IncludedLevelYield };
                        SqlParameter t6 = new SqlParameter { ParameterName = "@IncludedBasis", Value = prepayandadditionalfeeschedule.IncludedBasis };
                        SqlParameter t7 = new SqlParameter { ParameterName = "@FeeName", Value = prepayandadditionalfeeschedule.FeeName };
                        SqlParameter t8 = new SqlParameter { ParameterName = "@EndDate", Value = prepayandadditionalfeeschedule.ScheduleEndDate == null ? (Object)DBNull.Value : prepayandadditionalfeeschedule.ScheduleEndDate };
                        SqlParameter t9 = new SqlParameter { ParameterName = "@FeeAmountOverride", Value = prepayandadditionalfeeschedule.FeeAmountOverride };
                        SqlParameter t10 = new SqlParameter { ParameterName = "@BaseAmountOverride", Value = prepayandadditionalfeeschedule.BaseAmountOverride };
                        SqlParameter t11 = new SqlParameter { ParameterName = "@ApplyTrueUpFeature", Value = prepayandadditionalfeeschedule.ApplyTrueUpFeatureID };
                        SqlParameter t12 = new SqlParameter { ParameterName = "@FeetobeStripped", Value = prepayandadditionalfeeschedule.PercentageOfFeeToBeStripped };
                        SqlParameter t13 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UserID };
                        SqlParameter[] sqlparam4 = new SqlParameter[] { t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13 };
                        hp.ExecNonquery("dbo.usp_InsertPrepayAndAdditionalFeeScheduleSizer", sqlparam4);
                    }
                    //Insert NoteData of Sizer - AmortSchedule
                    foreach (var amortschedule in item.ListFixedAmortScheduleTab)
                    {
                        SqlParameter u1 = new SqlParameter { ParameterName = "@creNoteID", Value = item.CRENoteID };
                        SqlParameter u2 = new SqlParameter { ParameterName = "@Date", Value = amortschedule.Date == null ? (Object)DBNull.Value : amortschedule.Date };
                        SqlParameter u3 = new SqlParameter { ParameterName = "@Value", Value = amortschedule.Value };
                        SqlParameter u4 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UserID };
                        SqlParameter[] sqlparam5 = new SqlParameter[] { u1, u2, u3, u4 };
                        hp.ExecNonquery("dbo.usp_InsertAmortScheduleSizer", sqlparam5);
                    }
                    //Insert NoteData of Sizer - NoteFundingSchedule
                    foreach (var notefunding in item.ListFutureFundingScheduleTab)
                    {
                        SqlParameter v1 = new SqlParameter { ParameterName = "@creNoteID", Value = item.CRENoteID };
                        SqlParameter v2 = new SqlParameter { ParameterName = "@Date", Value = notefunding.Date == null ? (Object)DBNull.Value : notefunding.Date };
                        SqlParameter v3 = new SqlParameter { ParameterName = "@Amount", Value = notefunding.Value };
                        SqlParameter v4 = new SqlParameter { ParameterName = "@PurposeID ", Value = notefunding.PurposeID };
                        SqlParameter v5 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UserID };
                        SqlParameter[] sqlparam6 = new SqlParameter[] { v1, v2, v3, v4, v5 };
                        hp.ExecNonquery("dbo.usp_InsertNoteFundingScheduleSizer", sqlparam6);
                    }
                    //Insert NoteData of Sizer - FeeCouponStripReceivable
                    foreach (var feecoupon in item.ListFeeCouponStripReceivable)
                    {
                        SqlParameter w1 = new SqlParameter { ParameterName = "@creNoteID", Value = item.CRENoteID };
                        SqlParameter w2 = new SqlParameter { ParameterName = "@Date ", Value = feecoupon.Date == null ? (Object)DBNull.Value : feecoupon.Date };
                        SqlParameter w3 = new SqlParameter { ParameterName = "@Value ", Value = feecoupon.Value };
                        SqlParameter w4 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UserID };
                        SqlParameter[] sqlparam7 = new SqlParameter[] { w1, w2, w3, w4 };
                        hp.ExecNonquery("dbo.usp_InsertFeeCouponStripReceivableSizer", sqlparam7);
                    }
                    //Insert NoteData of Sizer - PIKScheduleDetail
                    foreach (var pikscheduledetail in item.ListPIKfromPIKSourceNoteTab)
                    {
                        SqlParameter x1 = new SqlParameter { ParameterName = "@creNoteID", Value = item.CRENoteID };
                        SqlParameter x2 = new SqlParameter { ParameterName = "@Date ", Value = pikscheduledetail.Date == null ? (Object)DBNull.Value : pikscheduledetail.Date };
                        SqlParameter x3 = new SqlParameter { ParameterName = "@Value ", Value = pikscheduledetail.Value };
                        SqlParameter x4 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UserID };
                        SqlParameter[] sqlparam8 = new SqlParameter[] { x1, x2, x3, x4 };
                        hp.ExecNonquery("dbo.usp_InsertPIKScheduleDetailSizer", sqlparam8);
                    }
                    //Insert NoteData of Sizer - PIKSchedule
                    foreach (var pikschedule in item.NotePIKScheduleList)
                    {
                        SqlParameter y1 = new SqlParameter { ParameterName = "@creNoteID", Value = item.CRENoteID };
                        SqlParameter y2 = new SqlParameter { ParameterName = "@creSourceNoteID", Value = pikschedule.SourceCRENoteId };
                        SqlParameter y3 = new SqlParameter { ParameterName = "@creTargetNoteID", Value = pikschedule.TargetCRENoteId };
                        SqlParameter y4 = new SqlParameter { ParameterName = "@AdditionalIntRate ", Value = pikschedule.AdditionalIntRate };
                        SqlParameter y5 = new SqlParameter { ParameterName = "@AdditionalSpread ", Value = pikschedule.AdditionalSpread };
                        SqlParameter y6 = new SqlParameter { ParameterName = "@IndexFloor ", Value = pikschedule.IndexFloor };
                        SqlParameter y7 = new SqlParameter { ParameterName = "@IntCompoundingRate ", Value = pikschedule.IntCompoundingRate };
                        SqlParameter y8 = new SqlParameter { ParameterName = "@IntCompoundingSpread ", Value = pikschedule.IntCompoundingSpread };
                        SqlParameter y9 = new SqlParameter { ParameterName = "@StartDate ", Value = pikschedule.StartDate == null ? (Object)DBNull.Value : pikschedule.StartDate };
                        SqlParameter y10 = new SqlParameter { ParameterName = "@EndDate ", Value = pikschedule.EndDate == null ? (Object)DBNull.Value : pikschedule.EndDate };
                        SqlParameter y11 = new SqlParameter { ParameterName = "@IntCapAmt ", Value = pikschedule.IntCapAmt };
                        SqlParameter y12 = new SqlParameter { ParameterName = "@PurBal ", Value = pikschedule.PurBal };
                        SqlParameter y13 = new SqlParameter { ParameterName = "@AccCapBal ", Value = pikschedule.AccCapBal };
                        SqlParameter y14 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UserID };
                        SqlParameter[] sqlparam9 = new SqlParameter[] { y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12, y13, y14 };
                        hp.ExecNonquery("dbo.usp_InsertPIKScheduleSizer", sqlparam9);
                    }
                    //Insert NoteData of Sizer - SizerDocuments
                    foreach (var sizerdoc in item.SizerDoc)
                    {
                        SqlParameter z1 = new SqlParameter { ParameterName = "@ObjectID", Value = item.CRENoteID };
                        SqlParameter z2 = new SqlParameter { ParameterName = "@DocLink", Value = sizerdoc.DocLink };
                        SqlParameter z3 = new SqlParameter { ParameterName = "@DocTypeID", Value = sizerdoc.DocTypeID };
                        SqlParameter z4 = new SqlParameter { ParameterName = "@UpdatedBy ", Value = UserID };
                        SqlParameter[] sqlparam10 = new SqlParameter[] { z1, z2, z3, z4 };
                        hp.ExecNonquery("dbo.usp_InsertIntoSizerDocumentsNote", sqlparam10);
                    }
                    //Insert NoteData of Sizer - FundingRepaymentSequence
                    foreach (var fundingrepaymentsequence in item.FundingRepaymentSequence)
                    {
                        fundingrepaymentsequence.NoteID = new Guid(noteid);
                        SqlParameter a1 = new SqlParameter { ParameterName = "@creNoteID", Value = item.CRENoteID };
                        SqlParameter a2 = new SqlParameter { ParameterName = "@SequenceNo", Value = fundingrepaymentsequence.SequenceNo };
                        SqlParameter a3 = new SqlParameter { ParameterName = "@SequenceType", Value = fundingrepaymentsequence.SequenceType };
                        SqlParameter a4 = new SqlParameter { ParameterName = "@Value", Value = fundingrepaymentsequence.Value };
                        SqlParameter a5 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UserID };
                        SqlParameter[] sqlparam11 = new SqlParameter[] { a1, a2, a3, a4, a5 };
                        hp.ExecNonquery("dbo.usp_InsertFundingRepaymentSequenceSizer", sqlparam11);
                    }
                    foreach (var payrulepara in item.NotePayRuleFundingParameters)
                    {
                        payrulepara.NoteId = noteid;
                        payrulepara.TotalCommitment = item.TotalCommitment;
                        SqlParameter a1 = new SqlParameter { ParameterName = "@creNoteID", Value = item.CRENoteID };
                        SqlParameter a2 = new SqlParameter { ParameterName = "@UseRuletoDetermineNoteFundingID", Value = payrulepara.UseRuletoDetermineNoteFunding };
                        SqlParameter a3 = new SqlParameter { ParameterName = "@NoteFundingRuleID", Value = payrulepara.NoteFundingRule };
                        SqlParameter a4 = new SqlParameter { ParameterName = "@FundingPriority", Value = payrulepara.FundingPriority };
                        SqlParameter a5 = new SqlParameter { ParameterName = "@NoteBalanceCap", Value = payrulepara.NoteBalanceCap };
                        SqlParameter a6 = new SqlParameter { ParameterName = "@RepaymentPriorityID", Value = payrulepara.RepaymentPriority };
                        SqlParameter a7 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UserID };
                        SqlParameter[] sqlparam12 = new SqlParameter[] { a1, a2, a3, a4, a5, a6, a7 };
                        hp.ExecNonquery("dbo.usp_InsertDealFundingNoteDataSizer", sqlparam12);
                    }
                }
                _dealDC.Listnewnoteids = arrayList;
                _dealDC.notelist = _dealDC.notelist;
                return _dealDC;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<LiborScheduleTab> GetLiborRateForVSTO(string CRENoteID, string ScenarioText, DateTime closingdate)
        {
            List<LiborScheduleTab> _libortypelist = new List<LiborScheduleTab>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter a1 = new SqlParameter { ParameterName = "@CRENoteID", Value = CRENoteID };
            SqlParameter a2 = new SqlParameter { ParameterName = "@AnalysisName", Value = ScenarioText };
            SqlParameter[] sqlparam = new SqlParameter[] { a1, a2 };
            dt = hp.ExecDataTable("dbo.usp_LCGetLIBORScheduleDetailByCRENoteID", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                LiborScheduleTab libortype = new LiborScheduleTab();
                libortype.EffectiveDate = closingdate;
                libortype.Date = Convert.ToDateTime(dr["Date"]);
                libortype.Value = CommonHelper.ToDecimal(dr["Value"]);

                _libortypelist.Add(libortype);
            }
            return _libortypelist;
        }
        public String CheckPermssionAndDuplicateDeal(string dealID, string dealname, string username, string Password)
        {
            String res = "";
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter a1 = new SqlParameter { ParameterName = "@CREDealID", Value = dealID };
            SqlParameter a2 = new SqlParameter { ParameterName = "@DealName", Value = dealname };
            SqlParameter a3 = new SqlParameter { ParameterName = "@Username", Value = username };
            SqlParameter a4 = new SqlParameter { ParameterName = "@Password", Value = Password };
            SqlParameter[] sqlparam = new SqlParameter[] { a1, a2, a3, a4 };
            dt = hp.ExecDataTable("dbo.usp_CheckDuplicateDealSizer", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                res = dr[0].ToString();
            }
            return res;
        }
        public ScenarioParameterDataContract GetScenarioParameters(string scenariotext)
        {
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter a1 = new SqlParameter { ParameterName = "@Scenariotext", Value = scenariotext };
            SqlParameter[] sqlparam = new SqlParameter[] { a1 };
            dt = hp.ExecDataTable("usp_GetScenarioParameterForVSTO", sqlparam);
            ScenarioParameterDataContract spd = new ScenarioParameterDataContract();
            foreach (DataRow dr in dt.Rows)
            {
                spd.AnalysisParameterID = Convert.ToString(dr["AnalysisParameterID"]);
                spd.AnalysisID = Convert.ToString(dr["AnalysisID"]);
                spd.MaturityScenarioOverrideID = CommonHelper.ToInt32(dr["MaturityScenarioOverrideID"]);
                spd.MaturityScenarioOverrideText = Convert.ToString(dr["MaturityScenarioOverrideText"]);
                spd.MaturityAdjustment = CommonHelper.ToInt32(dr["MaturityAdjustment"]);
                spd.FunctionName = Convert.ToString(dr["FunctionName"]);
                spd.IndexScenarioOverride = CommonHelper.ToInt32(dr["IndexScenarioOverride"]);
                spd.IndexScenarioOverrideText = Convert.ToString(dr["IndexScenarioOverrideText"]);
                spd.CalculationMode = CommonHelper.ToInt32(dr["CalculationMode"]);
                spd.CalculationModeText = Convert.ToString(dr["CalculationModeText"]);
                spd.ExcludedForcastedPrePayment = CommonHelper.ToInt32(dr["ExcludedForcastedPrePayment"]);
                spd.ExcludedForcastedPrePaymentText = Convert.ToString(dr["ExcludedForcastedPrePaymentText"]);
                spd.AutoCalcFreq = CommonHelper.ToInt32(dr["AutoCalculationFrequency"]);
                spd.AutoCalcFreqText = Convert.ToString(dr["AutoCalcFreqText"]);
                spd.StatusID = CommonHelper.ToInt32(dr["StatusID"]);
                spd.StatusIDText = Convert.ToString(dr["StatusText"]);
                spd.UseActuals = CommonHelper.ToInt32(dr["UseActuals"]);
                spd.UseActualsText = Convert.ToString(dr["UseActualsText"]);
                spd.DisableBusinessDayAdjustment = CommonHelper.ToInt32(dr["UseBusinessDayAdjustment"]);
                spd.DisableBusinessDayAdjustmentText = Convert.ToString(dr["UseBusinessDayAdjustmentText"]);


            }
            return spd;
        }

        public void SaveNoteFunding(List<PayruleTargetNoteFundingScheduleDataContract> NotefundingList, string UserID)
        {
            Helper.Helper hp = new Helper.Helper();
            foreach (var notefunding in NotefundingList)
            {
                SqlParameter v1 = new SqlParameter { ParameterName = "@NoteID", Value = notefunding.NoteID };
                SqlParameter v2 = new SqlParameter { ParameterName = "@Date", Value = notefunding.Date == null ? (Object)DBNull.Value : notefunding.Date };
                SqlParameter v3 = new SqlParameter { ParameterName = "@Amount", Value = notefunding.Value };
                SqlParameter v4 = new SqlParameter { ParameterName = "@PurposeID ", Value = notefunding.PurposeID };
                SqlParameter v5 = new SqlParameter { ParameterName = "@RowNo ", Value = notefunding.DealFundingRowno };
                SqlParameter v6 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UserID };
                SqlParameter[] sqlparam1 = new SqlParameter[] { v1, v2, v3, v4, v5, v6 };
                hp.ExecNonquery("dbo.usp_InsertNoteFundingScheduleSizerVSTO", sqlparam1);
            }
        }

        public int? AddGenericEntity(List<GenericEntityDataContract> dcGenericEntity, string UserID)
        {
            int? batchid = 0;

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@XMLGenericEntity", Value = dcGenericEntity.ToXML().Replace(" xsi:nil=\"true\"", "") };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            DataTable dt = hp.ExecDataTable("dbo.usp_InsertIntoM61AddinLanding", sqlparam);

            if (dt != null)
            {
                batchid = CommonHelper.ToInt32(dt.Rows[0].ItemArray[0]);
            }
            return batchid;
        }

        public int? AddTagXIRREntity(List<TagXIRREntityDataContract> dcTagXIRREntity, string UserID)
        {
            int? batchid = 0;

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@XMLGenericEntity", Value = dcTagXIRREntity.ToXML().Replace(" xsi:nil=\"true\"", "") };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            DataTable dt = hp.ExecDataTable("dbo.usp_InsertIntoM61AddinLandingTagXIRR", sqlparam);

            if (dt != null)
            {
                batchid = CommonHelper.ToInt32(dt.Rows[0].ItemArray[0]);
            }
            return batchid;
        }

        public DataTable GetBatchUploadSummary(int? batchid)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@BatchLog", Value = batchid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            DataTable dt = hp.ExecDataTable("dbo.usp_GetBatchUploadSummary", sqlparam);
            return dt;
        }

        public DataTable GetBatchUploadSummaryTagXIRR(int? batchId)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@BatchLog", Value = batchId };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            DataTable dt = hp.ExecDataTable("dbo.usp_GetBatchUploadSummaryTagXIRR", sqlparam);
            return dt;
        }


        public void OpenClosePeriodForManualTransaction(int? batchid, string UserID)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@BatchLogID", Value = batchid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1,p2 };
            hp.ExecNonquery("dbo.usp_OpenClosePeriodForManualTransaction", sqlparam);
            
        }

        public DataTable GetBatchUploadSummaryInvoices(int? batchid)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@BatchLog", Value = batchid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            DataTable dt = hp.ExecDataTable("dbo.usp_GetBatchUploadSummaryInvoices", sqlparam);
            return dt;
        }
        public DataTable GetNotesWithPikData(int? batchid)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@BatchLogID", Value = batchid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            DataTable dt = hp.ExecDataTable("dbo.usp_GetPikNotesInBatchByBatchID", sqlparam);
            return dt;
        }

        public DataTable GetNoteForcalcByBatchID(int? batchid)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@BatchLogID", Value = batchid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            DataTable dt = hp.ExecDataTable("dbo.usp_GetNoteForcalcByBatchID", sqlparam);
            return dt;
        }

        public DataTable GetPikPaidTransactionByCREnoteID(string crenoteid)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@crenoteid", Value = crenoteid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            DataTable dt = hp.ExecDataTable("dbo.usp_GetPikPaidTransactionByCREnoteID", sqlparam);
            return dt;
        }

        //
        public List<string> GetNamedRangeUsedInBatchUpload()
        {
            List<string> rangelist = new List<string>();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = hp.ExecDataTable("usp_GetNamedRangeUsedInBatchUpload");

                foreach (DataRow dr in dt.Rows)
                {
                    rangelist.Add(dr["NamedRange"].ToString());
                }

            }
            catch (Exception ex)
            {
            }
            return rangelist;
        }


        public String CreateNewBatch(string username)
        {
            String res = "";
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter a1 = new SqlParameter { ParameterName = "@UserName", Value = username };
            SqlParameter[] sqlparam = new SqlParameter[] { a1 };
            dt = hp.ExecDataTable("dbo.usp_CreateNewBatchLogIDForVSTOAsyncCalc", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                res = dr[0].ToString();
            }
            return res;
        }


        public int InsertBatchIntoDetail(int batchid, string notid, string SizerScenario)
        {
            try
            {
                // @SizerScenario nvarchar(256)
                int id = 0;
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                SqlParameter a1 = new SqlParameter { ParameterName = "@BatchLogID", Value = batchid };
                SqlParameter a2 = new SqlParameter { ParameterName = "@CRENoteID", Value = notid };
                SqlParameter a3 = new SqlParameter { ParameterName = "@SizerScenario", Value = SizerScenario };

                SqlParameter[] sqlparam = new SqlParameter[] { a1, a2, a3 };
                dt = hp.ExecDataTable("dbo.usp_InsertBatchDetailAsyncCalcVSTO", sqlparam);
                foreach (DataRow dr in dt.Rows)
                {
                    id = Convert.ToInt32(dr[0]);
                }
                return id;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public void UpdateNoteStatusAndTime(int batchid, string notid, int BatchDetailAsyncCalcVSTOID)
        {
            try
            {

                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                SqlParameter a1 = new SqlParameter { ParameterName = "@BatchLogID", Value = batchid };
                SqlParameter a2 = new SqlParameter { ParameterName = "@CRENoteID", Value = notid };
                SqlParameter a3 = new SqlParameter { ParameterName = "@BatchDetailAsyncCalcVSTOID", Value = BatchDetailAsyncCalcVSTOID };
                SqlParameter[] sqlparam = new SqlParameter[] { a1, a2, a3 };
                hp.ExecNonquery("dbo.usp_UpdateNoteStatusAndTimeVSTO", sqlparam);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public void InsertNotePeriodicCalcVSTO(List<NotePeriodicOutputsDataContract> _notePeriodicOutputsDC, string username, string crenoteid, int batchDetailID, string scenario)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable notePeriCalc = new DataTable();
            notePeriCalc.Columns.Add("BatchDetailAsyncCalcVSTOId");
            notePeriCalc.Columns.Add("CRENoteId");
            notePeriCalc.Columns.Add("PeriodEndDate");
            notePeriCalc.Columns.Add("Month");
            notePeriCalc.Columns.Add("ActualCashFlows");
            notePeriCalc.Columns.Add("GAAPCashFlows");
            notePeriCalc.Columns.Add("EndingGAAPBookValue");
            notePeriCalc.Columns.Add("PIKInterestAccrualforthePeriod");
            notePeriCalc.Columns.Add("TotalAmortAccrualForPeriod");
            notePeriCalc.Columns.Add("AccumulatedAmort");
            notePeriCalc.Columns.Add("BeginningBalance");
            notePeriCalc.Columns.Add("TotalFutureAdvancesForThePeriod");
            notePeriCalc.Columns.Add("TotalDiscretionaryCurtailmentsforthePeriod");
            notePeriCalc.Columns.Add("TotalCouponStrippedforthePeriod");
            notePeriCalc.Columns.Add("CouponStrippedonPaymentDate");
            notePeriCalc.Columns.Add("ScheduledPrincipal");
            notePeriCalc.Columns.Add("PrincipalPaid");
            notePeriCalc.Columns.Add("BalloonPayment");
            notePeriCalc.Columns.Add("EndingBalance");
            notePeriCalc.Columns.Add("EndOfPeriodWAL");
            notePeriCalc.Columns.Add("PIKInterestFromPIKSourceNote");
            notePeriCalc.Columns.Add("PIKInterestTransferredToRelatedNote");
            notePeriCalc.Columns.Add("PIKInterestForThePeriod");
            notePeriCalc.Columns.Add("BeginningPIKBalanceNotInsideLoanBalance");
            notePeriCalc.Columns.Add("PIKInterestForPeriodNotInsideLoanBalance");
            notePeriCalc.Columns.Add("PIKBalanceBalloonPayment");
            notePeriCalc.Columns.Add("EndingPIKBalanceNotInsideLoanBalance");
            notePeriCalc.Columns.Add("AmortAccrualLevelYield");
            notePeriCalc.Columns.Add("ScheduledPrincipalShortfall");
            notePeriCalc.Columns.Add("PrincipalShortfall");
            notePeriCalc.Columns.Add("PrincipalLoss");
            notePeriCalc.Columns.Add("InterestForPeriodShortfall");
            notePeriCalc.Columns.Add("InterestPaidOnPMTDateShortfall");
            notePeriCalc.Columns.Add("CumulativeInterestPaidOnPMTDateShortfall");
            notePeriCalc.Columns.Add("InterestShortfallLoss");
            notePeriCalc.Columns.Add("InterestShortfallRecovery");
            notePeriCalc.Columns.Add("BeginningFinancingBalance");
            notePeriCalc.Columns.Add("TotalFinancingDrawsCurtailmentsForPeriod");
            notePeriCalc.Columns.Add("FinancingBalloon");
            notePeriCalc.Columns.Add("EndingFinancingBalance");
            notePeriCalc.Columns.Add("FinancingInterestPaid");
            notePeriCalc.Columns.Add("FinancingFeesPaid");
            notePeriCalc.Columns.Add("PeriodLeveredYield");
            notePeriCalc.Columns.Add("OrigFeeAccrual");
            notePeriCalc.Columns.Add("DiscountPremiumAccrual");
            notePeriCalc.Columns.Add("ExitFeeAccrual");
            notePeriCalc.Columns.Add("AllInCouponRate");
            notePeriCalc.Columns.Add("CreatedBy");
            notePeriCalc.Columns.Add("CreatedDate");
            notePeriCalc.Columns.Add("UpdatedBy");
            notePeriCalc.Columns.Add("UpdatedDate");
            notePeriCalc.Columns.Add("CleanCost");
            notePeriCalc.Columns.Add("GrossDeferredFees");
            notePeriCalc.Columns.Add("DeferredFeesReceivable");
            notePeriCalc.Columns.Add("CleanCostPrice");
            notePeriCalc.Columns.Add("AmortizedCostPrice");
            notePeriCalc.Columns.Add("AdditionalFeeAccrual");
            notePeriCalc.Columns.Add("CapitalizedCostAccrual");
            notePeriCalc.Columns.Add("ReversalofPriorInterestAccrual");
            notePeriCalc.Columns.Add("InterestReceivedinCurrentPeriod");
            notePeriCalc.Columns.Add("CurrentPeriodInterestAccrual");
            notePeriCalc.Columns.Add("TotalGAAPInterestFortheCurrentPeriod");
            notePeriCalc.Columns.Add("InvestmentBasis");
            notePeriCalc.Columns.Add("CurrentPeriodInterestAccrualPeriodEnddate");
            notePeriCalc.Columns.Add("LIBORPercentage");
            notePeriCalc.Columns.Add("SpreadPercentage");
            notePeriCalc.Columns.Add("AnalysisID");
            notePeriCalc.Columns.Add("FeeStrippedforthePeriod");
            notePeriCalc.Columns.Add("PIKInterestPercentage");
            notePeriCalc.Columns.Add("AmortizedCost");
            notePeriCalc.Columns.Add("InterestSuspenseAccountActivityforthePeriod");
            notePeriCalc.Columns.Add("InterestSuspenseAccountBalance");
            notePeriCalc.Columns.Add("AllInBasisValuation");
            notePeriCalc.Columns.Add("AllInPIKRate");
            notePeriCalc.Columns.Add("CurrentPeriodPIKInterestAccrualPeriodEnddate");
            notePeriCalc.Columns.Add("PIKInterestPaidForThePeriod");
            notePeriCalc.Columns.Add("PIKInterestAppliedForThePeriod");
            notePeriCalc.Columns.Add("SizerScenario");

            if (_notePeriodicOutputsDC != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(_notePeriodicOutputsDC);

                foreach (DataRow dr in dt.Rows)
                {
                    dr["CRENoteID"] = crenoteid;
                    dr["UpdatedBy"] = username;
                    dr["CreatedBy"] = username;
                    dr["BatchDetailAsyncCalcVSTOId"] = batchDetailID;
                    dr["SizerScenario"] = scenario;
                    notePeriCalc.ImportRow(dr);
                }
            }

            if (notePeriCalc.Rows.Count > 0)
            {
                hp.ExecDataTablewithtableVSTO("usp_InsertUpdateNotePeriodicCalcByNoteIDVSTO", notePeriCalc, username);
            }
        }

        public void InsertTransactionVSTO(List<TransactionEntry> _lsttransactionEntryDC, string CRENoteId, int batchDetailID, string scenario, string NoteName)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dtTranscation = new DataTable();
            dtTranscation.Columns.Add("BatchDetailAsyncCalcVSTOId");
            dtTranscation.Columns.Add("CRENoteID");
            dtTranscation.Columns.Add("Type");
            dtTranscation.Columns.Add("Date");
            dtTranscation.Columns.Add("Amount");
            dtTranscation.Columns.Add("FeeName");
            dtTranscation.Columns.Add("SizerScenario");
            dtTranscation.Columns.Add("NoteName");


            if (_lsttransactionEntryDC != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(_lsttransactionEntryDC);

                foreach (DataRow dr in dt.Rows)
                {
                    dr["CRENoteID"] = CRENoteId;
                    dr["BatchDetailAsyncCalcVSTOId"] = batchDetailID;
                    dr["SizerScenario"] = scenario;
                    dr["NoteName"] = NoteName;

                    dtTranscation.ImportRow(dr);
                }
            }

            if (dtTranscation.Rows.Count > 0)
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@TableTypeTransactionEntry", Value = dtTranscation };
                SqlParameter p2 = new SqlParameter { ParameterName = "@CRENoteID", Value = CRENoteId };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecDataTablewithparams("dbo.usp_InsertTransactionEntryVSTO", sqlparam);
            }
        }


        public GenericVSTOResult CheckCalculationStatus(int batchid)
        {
            GenericVSTOResult result = new GenericVSTOResult();
            String res = "";
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter a1 = new SqlParameter { ParameterName = "@BatchLogID", Value = batchid };
            SqlParameter[] sqlparam = new SqlParameter[] { a1 };
            dt = hp.ExecDataTable("dbo.usp_CheckBatchStatusBybatchIDVSTO", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                result.Status = dr[0].ToString();
                result.Progress = dr[1].ToString();
            }
            return result;
        }

        //CheckCalculationStatus

        public string CheckDuplicateDealSettlement(String Credealid, string DealName, string Username, string Password)
        {
            
            string res = "";
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter a1 = new SqlParameter { ParameterName = "@CREDealID", Value = Credealid };
            SqlParameter a2 = new SqlParameter { ParameterName = "@DealName", Value = DealName };
            SqlParameter a3 = new SqlParameter { ParameterName = "@Username", Value = Username };
            SqlParameter a4 = new SqlParameter { ParameterName = "@Password", Value = Password };

            SqlParameter[] sqlparam = new SqlParameter[] { a1, a2, a3, a4 };
            dt = hp.ExecDataTable("dbo.usp_CheckDuplicateDealSettlement", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                res = Convert.ToString( dr[0]);                
                           
            }
            return res;
        }

        public string CheckDuplicateNoteSettlement(String Credealid, string CRENoteID)
        {

            string res = "";
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter a1 = new SqlParameter { ParameterName = "@CREDealID", Value = Credealid };
            SqlParameter a2 = new SqlParameter { ParameterName = "@CRENoteID", Value = CRENoteID };
             
            SqlParameter[] sqlparam = new SqlParameter[] { a1, a2 };
            dt = hp.ExecDataTable("dbo.usp_CheckDuplicateNoteSettlement", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                res = Convert.ToString(dr[0]);

            }
            return res;
        }
        public DataTable CalculateXIRRAfterDealSave_FromSizer(String Credealid, string username)
        {

           
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter a1 = new SqlParameter { ParameterName = "@CREDealID", Value = Credealid };
            SqlParameter a2 = new SqlParameter { ParameterName = "@UserId", Value = username };

            SqlParameter[] sqlparam = new SqlParameter[] { a1, a2 };
            dt = hp.ExecDataTable("dbo.usp_CalculateXIRRAfterDealSave_FromSizer", sqlparam);

            
            return dt;
        }

        //

        public List<TransactionEntryVSTO> GetTransactionEntryByBatchID(int batchID)
        {
            DataTable dt = new DataTable();
            List<TransactionEntryVSTO> _transactionEntryDataContractList = new List<TransactionEntryVSTO>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@BatchLogID", Value = batchID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetTransactionEntryVSTOByBatchLogID", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                TransactionEntryVSTO _transactionEntryDataContract = new TransactionEntryVSTO();
                _transactionEntryDataContract.Date = CommonHelper.ToDateTime(dr["Date"]);
                _transactionEntryDataContract.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                _transactionEntryDataContract.Type = Convert.ToString(dr["Type"]);
                _transactionEntryDataContract.FeeName = Convert.ToString(dr["FeeName"]);
                _transactionEntryDataContract.CRENoteID = Convert.ToString(dr["CRENoteID"]);
                _transactionEntryDataContract.SizerScenario = Convert.ToString(dr["SizerScenario"]);

                _transactionEntryDataContractList.Add(_transactionEntryDataContract);
            }
            return _transactionEntryDataContractList;
        }

        public DataTable GetXIRROutputByBatchID(int batchID)
        {
            DataTable dt = new DataTable();
            List<TransactionEntryVSTO> _transactionEntryDataContractList = new List<TransactionEntryVSTO>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@BatchLogAsyncCalcVSTOID", Value = batchID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetXIRROutPut_VSTO", sqlparam);

            return dt;
        }

        public List<PeriodicCashflowVSTO> GetNotePeriodicCalcByNoteId(int batchID)
        {
            try
            {
                DataTable dt = new DataTable();
                List<PeriodicCashflowVSTO> _notePeriodicOutputsDataContractList = new List<PeriodicCashflowVSTO>();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@BatchLogID", Value = batchID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetNotePeriodicCalcVSTOByBatchLogID", sqlparam);


                foreach (DataRow dr in dt.Rows)
                {
                    PeriodicCashflowVSTO _notePeriodicOutputsDataContract = new PeriodicCashflowVSTO();

                    _notePeriodicOutputsDataContract.CRENoteId = Convert.ToString(dr["CRENoteID"]);
                    _notePeriodicOutputsDataContract.PeriodEndDate = CommonHelper.ToDateTime(dr["PeriodEndDate"]);
                    _notePeriodicOutputsDataContract.Month = CommonHelper.ToInt32(dr["Month"]);
                    _notePeriodicOutputsDataContract.ActualCashFlows = CommonHelper.ToDecimal(dr["ActualCashFlows"]);
                    _notePeriodicOutputsDataContract.GAAPCashFlows = CommonHelper.ToDecimal(dr["GAAPCashFlows"]);
                    _notePeriodicOutputsDataContract.EndingGAAPBookValue = CommonHelper.ToDecimal(dr["EndingGAAPBookValue"]);
                    _notePeriodicOutputsDataContract.PIKInterestAccrualforthePeriod = CommonHelper.ToDecimal(dr["PIKInterestAccrualforthePeriod"]);
                    _notePeriodicOutputsDataContract.TotalAmortAccrualForPeriod = CommonHelper.ToDecimal(dr["TotalAmortAccrualForPeriod"]);
                    _notePeriodicOutputsDataContract.AccumulatedAmort = CommonHelper.ToDecimal(dr["AccumulatedAmort"]);
                    _notePeriodicOutputsDataContract.BeginningBalance = CommonHelper.ToDecimal(dr["BeginningBalance"]);
                    _notePeriodicOutputsDataContract.TotalFutureAdvancesForThePeriod = CommonHelper.ToDecimal(dr["TotalFutureAdvancesForThePeriod"]);
                    _notePeriodicOutputsDataContract.TotalDiscretionaryCurtailmentsforthePeriod = CommonHelper.ToDecimal(dr["TotalDiscretionaryCurtailmentsforthePeriod"]);
                    _notePeriodicOutputsDataContract.TotalCouponStrippedforthePeriod = CommonHelper.ToDecimal(dr["TotalCouponStrippedforthePeriod"]);
                    _notePeriodicOutputsDataContract.CouponStrippedonPaymentDate = CommonHelper.ToDecimal(dr["CouponStrippedonPaymentDate"]);
                    _notePeriodicOutputsDataContract.ScheduledPrincipal = CommonHelper.ToDecimal(dr["ScheduledPrincipal"]);
                    _notePeriodicOutputsDataContract.PrincipalPaid = CommonHelper.ToDecimal(dr["PrincipalPaid"]);
                    _notePeriodicOutputsDataContract.BalloonPayment = CommonHelper.ToDecimal(dr["BalloonPayment"]);
                    _notePeriodicOutputsDataContract.EndingBalance = CommonHelper.ToDecimal(dr["EndingBalance"]);
                    _notePeriodicOutputsDataContract.EndOfPeriodWAL = CommonHelper.ToDecimal(dr["EndOfPeriodWAL"]);
                    _notePeriodicOutputsDataContract.PIKInterestFromPIKSourceNote = CommonHelper.ToDecimal(dr["PIKInterestFromPIKSourceNote"]);
                    _notePeriodicOutputsDataContract.PIKInterestTransferredToRelatedNote = CommonHelper.ToDecimal(dr["PIKInterestTransferredToRelatedNote"]);
                    _notePeriodicOutputsDataContract.PIKInterestForThePeriod = CommonHelper.ToDecimal(dr["PIKInterestForThePeriod"]);
                    _notePeriodicOutputsDataContract.BeginningPIKBalanceNotInsideLoanBalance = CommonHelper.ToDecimal(dr["BeginningPIKBalanceNotInsideLoanBalance"]);
                    _notePeriodicOutputsDataContract.PIKInterestForPeriodNotInsideLoanBalance = CommonHelper.ToDecimal(dr["PIKInterestForPeriodNotInsideLoanBalance"]);
                    _notePeriodicOutputsDataContract.PIKBalanceBalloonPayment = CommonHelper.ToDecimal(dr["PIKBalanceBalloonPayment"]);
                    _notePeriodicOutputsDataContract.EndingPIKBalanceNotInsideLoanBalance = CommonHelper.ToDecimal(dr["EndingPIKBalanceNotInsideLoanBalance"]);
                    _notePeriodicOutputsDataContract.AmortAccrualLevelYield = CommonHelper.ToDecimal(dr["AmortAccrualLevelYield"]);
                    _notePeriodicOutputsDataContract.ScheduledPrincipalShortfall = CommonHelper.ToDecimal(dr["ScheduledPrincipalShortfall"]);
                    _notePeriodicOutputsDataContract.PrincipalShortfall = CommonHelper.ToDecimal(dr["PrincipalShortfall"]);
                    _notePeriodicOutputsDataContract.PrincipalLoss = CommonHelper.ToDecimal(dr["PrincipalLoss"]);
                    _notePeriodicOutputsDataContract.InterestForPeriodShortfall = CommonHelper.ToDecimal(dr["InterestForPeriodShortfall"]);
                    _notePeriodicOutputsDataContract.InterestPaidOnPMTDateShortfall = CommonHelper.ToDecimal(dr["InterestPaidOnPMTDateShortfall"]);
                    _notePeriodicOutputsDataContract.CumulativeInterestPaidOnPMTDateShortfall = CommonHelper.ToDecimal(dr["CumulativeInterestPaidOnPMTDateShortfall"]);
                    _notePeriodicOutputsDataContract.InterestShortfallLoss = CommonHelper.ToDecimal(dr["InterestShortfallLoss"]);
                    _notePeriodicOutputsDataContract.InterestShortfallRecovery = CommonHelper.ToDecimal(dr["InterestShortfallRecovery"]);
                    _notePeriodicOutputsDataContract.BeginningFinancingBalance = CommonHelper.ToDecimal(dr["BeginningFinancingBalance"]);
                    _notePeriodicOutputsDataContract.TotalFinancingDrawsCurtailmentsForPeriod = CommonHelper.ToDecimal(dr["TotalFinancingDrawsCurtailmentsForPeriod"]);
                    _notePeriodicOutputsDataContract.FinancingBalloon = CommonHelper.ToDecimal(dr["FinancingBalloon"]);
                    _notePeriodicOutputsDataContract.EndingFinancingBalance = CommonHelper.ToDecimal(dr["EndingFinancingBalance"]);
                    _notePeriodicOutputsDataContract.FinancingInterestPaid = CommonHelper.ToDecimal(dr["FinancingInterestPaid"]);
                    _notePeriodicOutputsDataContract.FinancingFeesPaid = CommonHelper.ToDecimal(dr["FinancingFeesPaid"]);
                    _notePeriodicOutputsDataContract.PeriodLeveredYield = CommonHelper.ToDecimal(dr["PeriodLeveredYield"]);
                    _notePeriodicOutputsDataContract.DiscountPremiumAccrual = CommonHelper.ToDecimal(dr["DiscountPremiumAccrual"]);
                    _notePeriodicOutputsDataContract.CleanCost = CommonHelper.ToDecimal(dr["CleanCost"]);
                    _notePeriodicOutputsDataContract.GrossDeferredFees = CommonHelper.ToDecimal(dr["GrossDeferredFees"]);
                    _notePeriodicOutputsDataContract.DeferredFeesReceivable = CommonHelper.ToDecimal(dr["DeferredFeesReceivable"]);
                    _notePeriodicOutputsDataContract.CleanCostPrice = CommonHelper.ToDecimal(dr["CleanCostPrice"]);
                    _notePeriodicOutputsDataContract.AmortizedCostPrice = CommonHelper.ToDecimal(dr["AmortizedCostPrice"]);
                    _notePeriodicOutputsDataContract.AdditionalFeeAccrual = CommonHelper.ToDecimal(dr["AdditionalFeeAccrual"]);
                    _notePeriodicOutputsDataContract.CapitalizedCostAccrual = CommonHelper.ToDecimal(dr["CapitalizedCostAccrual"]);
                    _notePeriodicOutputsDataContract.AllInCouponRate = CommonHelper.ToDecimal(dr["AllInCouponRate"]);
                    _notePeriodicOutputsDataContract.ReversalofPriorInterestAccrual = CommonHelper.ToDecimal(dr["ReversalofPriorInterestAccrual"]);
                    _notePeriodicOutputsDataContract.InterestReceivedinCurrentPeriod = CommonHelper.ToDecimal(dr["InterestReceivedinCurrentPeriod"]);
                    _notePeriodicOutputsDataContract.CurrentPeriodInterestAccrual = CommonHelper.ToDecimal(dr["CurrentPeriodInterestAccrual"]);
                    _notePeriodicOutputsDataContract.TotalGAAPInterestFortheCurrentPeriod = CommonHelper.ToDecimal(dr["TotalGAAPInterestFortheCurrentPeriod"]);
                    _notePeriodicOutputsDataContract.InvestmentBasis = CommonHelper.ToDecimal(dr["InvestmentBasis"]);
                    _notePeriodicOutputsDataContract.CurrentPeriodInterestAccrualPeriodEnddate = CommonHelper.ToDecimal(dr["CurrentPeriodInterestAccrualPeriodEnddate"]);
                    _notePeriodicOutputsDataContract.AmortizedCost = CommonHelper.ToDecimal(dr["AmortizedCost"]);
                    _notePeriodicOutputsDataContract.FeeStrippedforthePeriod = CommonHelper.ToDecimal(dr["FeeStrippedforthePeriod"]);
                    _notePeriodicOutputsDataContract.InterestSuspenseAccountActivityforthePeriod = CommonHelper.ToDecimal(dr["InterestSuspenseAccountActivityforthePeriod"]);
                    _notePeriodicOutputsDataContract.InterestSuspenseAccountBalance = CommonHelper.ToDecimal(dr["InterestSuspenseAccountBalance"]);
                    _notePeriodicOutputsDataContract.AllInBasisValuation = CommonHelper.ToDecimal(dr["AllInBasisValuation"]);
                    _notePeriodicOutputsDataContract.AllInPIKRate = CommonHelper.ToDecimal(dr["AllInPIKRate"]);
                    _notePeriodicOutputsDataContract.CurrentPeriodPIKInterestAccrualPeriodEnddate = CommonHelper.ToDecimal(dr["CurrentPeriodPIKInterestAccrualPeriodEnddate"]);
                    _notePeriodicOutputsDataContract.PIKInterestPaidForThePeriod = CommonHelper.ToDecimal(dr["PIKInterestPaidForThePeriod"]);
                    _notePeriodicOutputsDataContract.PIKInterestAppliedForThePeriod = CommonHelper.ToDecimal(dr["PIKInterestAppliedForThePeriod"]);
                    _notePeriodicOutputsDataContract.SizerScenario = Convert.ToString(dr["SizerScenario"]);
                    _notePeriodicOutputsDataContractList.Add(_notePeriodicOutputsDataContract);
                }

                return _notePeriodicOutputsDataContractList;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}
