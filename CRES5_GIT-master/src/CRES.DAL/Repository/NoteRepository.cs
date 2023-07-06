using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace CRES.DAL.Repository
{
    public class NoteRepository : INoteRepository
    {
        public List<NoteDataContract> GetNoteFromDealIds(String dealID, Guid? userID, int? pgeIndex, int? pageSize, out int? TotalCount)
        {
            List<NoteDataContract> lstNoteDC = new List<NoteDataContract>();

            DataTable dt = new DataTable();
            //int result = 0;
            TotalCount = 0;


            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealId", Value = dealID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = pgeIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetAllNotesByDealId", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {
                //result = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
                foreach (DataRow dr in dt.Rows)
                {
                    NoteDataContract _notedc = new NoteDataContract();
                    _notedc.NoteId = Convert.ToString(dr["NoteID"]);
                    _notedc.AccountID = Convert.ToString(dr["Account_AccountID"]);
                    _notedc.DealID = Convert.ToString(dr["DealID"]);
                    _notedc.DealName = Convert.ToString(dr["DealName"]);
                    _notedc.CRENoteID = Convert.ToString(dr["CRENoteID"]);
                    _notedc.Comments = Convert.ToString(dr["Comments"]);
                    _notedc.InitialInterestAccrualEndDate = CommonHelper.ToDateTime(dr["InitialInterestAccrualEndDate"]);
                    _notedc.AccrualFrequency = CommonHelper.ToInt32(dr["AccrualFrequency"]);
                    _notedc.DeterminationDateLeadDays = CommonHelper.ToInt32(dr["DeterminationDateLeadDays"]);
                    _notedc.DeterminationDateReferenceDayoftheMonth = CommonHelper.ToInt32(dr["DeterminationDateReferenceDayoftheMonth"]);
                    _notedc.DeterminationDateInterestAccrualPeriod = CommonHelper.ToInt32(dr["DeterminationDateInterestAccrualPeriod"]);
                    _notedc.DeterminationDateHolidayList = CommonHelper.ToInt32(dr["DeterminationDateHolidayList"]);
                    _notedc.FirstPaymentDate = CommonHelper.ToDateTime(dr["FirstPaymentDate"]);
                    _notedc.InitialMonthEndPMTDateBiWeekly = CommonHelper.ToDateTime(dr["InitialMonthEndPMTDateBiWeekly"]);
                    _notedc.PaymentDateBusinessDayLag = CommonHelper.ToInt32(dr["PaymentDateBusinessDayLag"]);
                    _notedc.PayFrequency = CommonHelper.ToInt32(dr["PayFrequency"]);
                    _notedc.IOTerm = CommonHelper.ToInt32(dr["IOTerm"]);
                    _notedc.AmortTerm = CommonHelper.ToInt32(dr["AmortTerm"]);
                    _notedc.PIKSeparateCompounding = CommonHelper.ToInt32(dr["FinancingInterestPaymentDay"]);
                    _notedc.MonthlyDSOverridewhenAmortizing = CommonHelper.ToDecimal(dr["MonthlyDSOverridewhenAmortizing"]);
                    _notedc.AccrualPeriodPaymentDayWhenNotEOMonth = CommonHelper.ToInt32(dr["AccrualPeriodPaymentDayWhenNotEOMonth"]);
                    _notedc.FirstPeriodInterestPaymentOverride = CommonHelper.ToDecimal(dr["FirstPeriodInterestPaymentOverride"]);
                    _notedc.FirstPeriodPrincipalPaymentOverride = CommonHelper.ToDecimal(dr["FirstPeriodPrincipalPaymentOverride"]);
                    _notedc.FinalInterestAccrualEndDateOverride = CommonHelper.ToDateTime(dr["FinalInterestAccrualEndDateOverride"]);
                    _notedc.AmortType = CommonHelper.ToInt32(dr["AmortType"]);
                    _notedc.RateType = CommonHelper.ToInt32(dr["RateType"]);
                    _notedc.RateTypeText = Convert.ToString(dr["RateTypeText"]);
                    _notedc.ReAmortizeMonthly = CommonHelper.ToInt32(dr["ReAmortizeMonthly"]);
                    _notedc.ReAmortizeatPMTReset = CommonHelper.ToInt32(dr["ReAmortizeatPMTReset"]);
                    _notedc.StubPaidInArrears = CommonHelper.ToInt32(dr["StubPaidInArrears"]);
                    _notedc.RelativePaymenttMonth = CommonHelper.ToInt32(dr["RelativePaymentMonth"]);
                    _notedc.SettleWithAccrualFlag = CommonHelper.ToInt32(dr["SettleWithAccrualFlag"]);
                    _notedc.InterestDueAtMaturity = CommonHelper.ToInt32(dr["InterestDueAtMaturity"]);
                    _notedc.RateIndexResetFreq = CommonHelper.ToDecimal(dr["RateIndexResetFreq"]);
                    _notedc.FirstRateIndexResetDate = CommonHelper.ToDateTime(dr["FirstRateIndexResetDate"]);
                    _notedc.LoanPurchase = CommonHelper.ToInt32(dr["LoanPurchase"]);
                    _notedc.AmortIntCalcDayCount = CommonHelper.ToInt32(dr["AmortIntCalcDayCount"]);
                    _notedc.StubPaidinAdvanceYN = CommonHelper.ToInt32(dr["StubPaidinAdvanceYN"]);
                    _notedc.FullPeriodInterestDueatMaturity = CommonHelper.ToInt32(dr["FullPeriodInterestDueatMaturity"]);
                    _notedc.ProspectiveAccountingMode = CommonHelper.ToInt32(dr["ProspectiveAccountingMode"]);
                    _notedc.IsCapitalized = CommonHelper.ToInt32(dr["IsCapitalized"]);
                    _notedc.SelectedMaturityDateScenario = CommonHelper.ToInt32(dr["SelectedMaturityDateScenario"]);
                    _notedc.SelectedMaturityDate = CommonHelper.ToDateTime(dr["SelectedMaturityDate"]);
                    _notedc.InitialMaturityDate = CommonHelper.ToDateTime(dr["InitialMaturityDate"]);
                    _notedc.ExpectedMaturityDate = CommonHelper.ToDateTime(dr["ExpectedMaturityDate"]);
                    _notedc.FullyExtendedMaturityDate = CommonHelper.ToDateTime(dr["FullyExtendedMaturityDate"]);
                    _notedc.OpenPrepaymentDate = CommonHelper.ToDateTime(dr["OpenPrepaymentDate"]);
                    _notedc.CashflowEngineID = CommonHelper.ToInt32(dr["CashflowEngineID"]);
                    _notedc.LoanType = CommonHelper.ToInt32(dr["LoanType"]);
                    _notedc.Classification = CommonHelper.ToInt32(dr["Classification"]);
                    _notedc.SubClassification = CommonHelper.ToInt32(dr["SubClassification"]);
                    _notedc.GAAPDesignation = CommonHelper.ToInt32(dr["GAAPDesignation"]);
                    _notedc.PortfolioID = CommonHelper.ToInt32(dr["PortfolioID"]);
                    _notedc.GeographicLocation = CommonHelper.ToInt32(dr["GeographicLocation"]);
                    _notedc.PropertyType = CommonHelper.ToInt32(dr["PropertyType"]);
                    _notedc.RatingAgency = CommonHelper.ToInt32(dr["RatingAgency"]);
                    _notedc.RiskRating = CommonHelper.ToInt32(dr["RiskRating"]);
                    _notedc.PurchasePrice = CommonHelper.ToDecimal(dr["PurchasePrice"]);
                    _notedc.FutureFeesUsedforLevelYeild = CommonHelper.ToDecimal(dr["FutureFeesUsedforLevelYeild"]);
                    _notedc.TotalToBeAmortized = CommonHelper.ToDecimal(dr["TotalToBeAmortized"]);
                    _notedc.StubPeriodInterest = CommonHelper.ToDecimal(dr["StubPeriodInterest"]);
                    _notedc.WDPAssetMultiple = CommonHelper.ToDecimal(dr["WDPAssetMultiple"]);
                    _notedc.WDPEquityMultiple = CommonHelper.ToDecimal(dr["WDPEquityMultiple"]);
                    _notedc.PurchaseBalance = CommonHelper.ToDecimal(dr["PurchaseBalance"]);
                    _notedc.DaysofAccrued = CommonHelper.ToInt32(dr["DaysofAccrued"]);
                    _notedc.InterestRate = CommonHelper.ToDecimal(dr["InterestRate"]);
                    _notedc.PurchasedInterestCalc = CommonHelper.ToDecimal(dr["PurchasedInterestCalc"]);
                    _notedc.ModelFinancingDrawsForFutureFundings = CommonHelper.ToInt32(dr["ModelFinancingDrawsForFutureFundings"]);
                    _notedc.NumberOfBusinessDaysLagForFinancingDraw = CommonHelper.ToInt32(dr["NumberOfBusinessDaysLagForFinancingDraw"]);
                    if (Convert.ToString(dr["FinancingFacilityID"]) != "")
                    {
                        _notedc.FinancingFacilityID = new Guid(Convert.ToString(dr["FinancingFacilityID"]));
                    }
                    _notedc.FinancingInitialMaturityDate = CommonHelper.ToDateTime(dr["FinancingInitialMaturityDate"]);
                    _notedc.FinancingExtendedMaturityDate = CommonHelper.ToDateTime(dr["FinancingExtendedMaturityDate"]);
                    _notedc.FinancingPayFrequency = CommonHelper.ToInt32(dr["FinancingPayFrequency"]);
                    _notedc.FinancingInterestPaymentDay = CommonHelper.ToInt32(dr["FinancingInterestPaymentDay"]);
                    _notedc.ClosingDate = CommonHelper.ToDateTime(dr["ClosingDate"]);
                    _notedc.InitialFundingAmount = CommonHelper.ToDecimal(dr["InitialFundingAmount"]);
                    _notedc.Discount = CommonHelper.ToDecimal(dr["Discount"]);
                    _notedc.OriginationFee = CommonHelper.ToDecimal(dr["OriginationFee"]);
                    _notedc.CapitalizedClosingCosts = CommonHelper.ToDecimal(dr["CapitalizedClosingCosts"]);
                    _notedc.PurchaseDate = CommonHelper.ToDateTime(dr["PurchaseDate"]);
                    _notedc.PurchaseAccruedFromDate = CommonHelper.ToDecimal(dr["PurchaseAccruedFromDate"]);
                    _notedc.PurchasedInterestOverride = CommonHelper.ToDecimal(dr["PurchasedInterestOverride"]);
                    _notedc.OngoingAnnualizedServicingFee = CommonHelper.ToDecimal(dr["OngoingAnnualizedServicingFee"]);
                    _notedc.DiscountRate = CommonHelper.ToDecimal(dr["DiscountRate"]);
                    _notedc.ValuationDate = CommonHelper.ToDateTime(dr["ValuationDate"]);
                    _notedc.FairValue = CommonHelper.ToDecimal(dr["FairValue"]);
                    _notedc.DiscountRatePlus = CommonHelper.ToDecimal(dr["DiscountRatePlus"]);
                    _notedc.FairValuePlus = CommonHelper.ToDecimal(dr["FairValuePlus"]);
                    _notedc.DiscountRateMinus = CommonHelper.ToDecimal(dr["DiscountRateMinus"]);
                    _notedc.FairValueMinus = CommonHelper.ToDecimal(dr["FairValueMinus"]);
                    _notedc.IncludeServicingPaymentOverrideinLevelYield = CommonHelper.ToInt32(dr["IncludeServicingPaymentOverrideinLevelYield"]);
                    _notedc.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    _notedc.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    _notedc.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    _notedc.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    _notedc.StatusID = CommonHelper.ToInt32(dr["StatusID"]);
                    _notedc.StatusName = Convert.ToString(Convert.ToInt32(dr["StatusID"]) == 1 ? "Active" : "InActive");
                    _notedc.Name = Convert.ToString(dr["Name"]);
                    _notedc.UnusedFeeThresholdBalance = CommonHelper.ToDecimal(dr["UnusedFeeThresholdBalance"]);
                    _notedc.UnusedFeePaymentFrequency = CommonHelper.ToInt16_NotNullable(dr["UnusedFeePaymentFrequency"]);
                    _notedc.ServicerID = Convert.ToString(dr["ServicerID"]);
                    _notedc.TotalCommitment = CommonHelper.ToDecimal(dr["TotalCommitment"]);
                    _notedc.NoofdaysrelPaymentDaterollnextpaymentcycle = CommonHelper.ToInt32(dr["NoofdaysrelPaymentDaterollnextpaymentcycle"]);
                    _notedc.ClientName = Convert.ToString(dr["ClientName"]);
                    _notedc.Portfolio = Convert.ToString(dr["Portfolio"]);
                    _notedc.Tag1 = Convert.ToString(dr["Tag1"]);
                    _notedc.Tag2 = Convert.ToString(dr["Tag2"]);
                    _notedc.Tag3 = Convert.ToString(dr["Tag3"]);
                    _notedc.Tag4 = Convert.ToString(dr["Tag4"]);
                    _notedc.ExtendedMaturityCurrent = CommonHelper.ToDateTime(dr["ExtendedMaturityCurrent"]);
                    _notedc.ImpactCommitmentCalc = CommonHelper.ToInt32(dr["ImpactCommitmentCalc"]);

                    //_notedc.ExtendedMaturityScenario1 = CommonHelper.ToDateTime(dr["ExtendedMaturityScenario1"]);
                    // _notedc.ExtendedMaturityScenario2 = CommonHelper.ToDateTime(dr["ExtendedMaturityScenario2"]);
                    // _notedc.ExtendedMaturityScenario3 = CommonHelper.ToDateTime(dr["ExtendedMaturityScenario3"]);
                    _notedc.ActualPayoffDate = CommonHelper.ToDateTime(dr["ActualPayoffDate"]);
                    _notedc.SelectedMaturityDateScenarioText = Convert.ToString(dr["SelectedMaturityDateScenarioText"]);
                    _notedc.NoteTransferDate = CommonHelper.ToDateTime(dr["NoteTransferDate"]);
                    _notedc.OriginalCRENoteID = Convert.ToString(dr["CRENoteID"]);
                    _notedc.OriginalNoteName = Convert.ToString(dr["Name"]);
                    lstNoteDC.Add(_notedc);

                }

                //lstNoteDC.ForEach(x => x.StatusName = (x.StatusID == 1 ? "Active" : "InActive"));
                TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            }

            return lstNoteDC;
        }

        public List<NoteUsedInDealDataContract> GetNotesFromDealDetailByDealID(String dealID, Guid? userID, int? pgeIndex, int? pageSize, out int? TotalCount)
        {
            List<NoteUsedInDealDataContract> lstNoteDC = new List<NoteUsedInDealDataContract>();
            DataTable dt = new DataTable();
            int result = 0;
            TotalCount = 0;

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealId", Value = dealID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = pgeIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetNotesFromDealDetailByDealID", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {
                result = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);

                foreach (DataRow dr in dt.Rows)
                {

                    NoteUsedInDealDataContract _notedc = new NoteUsedInDealDataContract();
                    _notedc.NoteId = dr["NoteID"].ToString();
                    _notedc.AccountID = Convert.ToString(dr["Account_AccountID"]);
                    _notedc.DealID = Convert.ToString(dr["DealID"]);
                    _notedc.CRENoteID = Convert.ToString(dr["CRENoteID"]);
                    _notedc.ClosingDate = dr["ClosingDate"].ToDateTime();
                    _notedc.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    _notedc.CreatedDate = dr["CreatedDate"].ToDateTime();
                    _notedc.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    _notedc.UpdatedDate = dr["UpdatedDate"].ToDateTime();
                    _notedc.StatusID = dr["StatusID"].ToInt32();
                    _notedc.StatusName = Convert.ToInt32(dr["StatusID"]) == 2 ? "Inactive" : "Active";
                    _notedc.Name = Convert.ToString(dr["Name"]);
                    _notedc.UseRuletoDetermineNoteFunding = dr["UseRuletoDetermineNoteFunding"].ToInt32();
                    _notedc.UseRuletoDetermineNoteFundingText = Convert.ToString(dr["UseRuletoDetermineNoteFundingText"]);
                    _notedc.NoteFundingRule = dr["NoteFundingRule"].ToInt32();
                    _notedc.NoteFundingRuleText = Convert.ToString(dr["NoteFundingRuleText"]);
                    _notedc.NoteBalanceCap = dr["NoteBalanceCap"].ToDecimal();
                    _notedc.FundingPriority = dr["FundingPriority"].ToInt32();
                    _notedc.RepaymentPriority = dr["RepaymentPriority"].ToInt32();
                    _notedc.TotalCommitment = CommonHelper.ToDecimal(dr["TotalCommitment"]);
                    _notedc.ExtendedMaturityCurrent = dr["ExtendedMaturityCurrent"].ToDateTime();
                    _notedc.ExpectedMaturityDate = dr["ExpectedMaturityDate"].ToDateTime();
                    _notedc.ActualPayoffDate = dr["ActualPayoffDate"].ToDateTime();
                    _notedc.FullyExtendedMaturityDate = dr["FullyExtendedMaturityDate"].ToDateTime();
                    _notedc.InitialMaturityDate = dr["InitialMaturityDate"].ToDateTime();
                    _notedc.cntCritialException = Convert.ToInt32(dr["cntCritialException"]);
                    _notedc.LienPositionText = Convert.ToString(dr["lienpositionText"]);
                    _notedc.LienPosition = dr["lienposition"].ToInt32();
                    _notedc.Priority = dr["priority"].ToInt32();
                    _notedc.OldCRENoteID = Convert.ToString(dr["CRENoteID"]);
                    _notedc.NoteRule = Convert.ToString(dr["NoteRule"]);
                    _notedc.OriginalCRENoteID = Convert.ToString(dr["CRENoteID"]);
                    _notedc.OriginalNoteName = Convert.ToString(dr["Name"]);
                    _notedc.OriginalTotalCommitment = CommonHelper.ToDecimal(dr["OriginalTotalCommitment"]);
                    _notedc.AggregatedTotal = CommonHelper.ToDecimal(dr["AggregatedTotal"]);
                    _notedc.AdjustedTotalCommitment = CommonHelper.ToDecimal(dr["AdjustedTotalCommitment"]);
                    _notedc.InitialRequiredEquity = CommonHelper.ToDecimal(dr["InitialRequiredEquity"]);
                    _notedc.InitialAdditionalEquity = CommonHelper.ToDecimal(dr["InitialAdditionalEquity"]);
                    _notedc.MaturityGroupName = Convert.ToString(dr["MaturityGroupName"]);
                    _notedc.MaturityMethodID = CommonHelper.ToInt32(dr["MaturityMethodID"]);
                    _notedc.MaturityMethodIDText = Convert.ToString(dr["MaturityMethodIDText"]);
                    _notedc.NoteSequenceNumber = CommonHelper.ToInt32(dr["NoteSequenceNumber"]);
                    lstNoteDC.Add(_notedc);
                }
                TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            }
            return lstNoteDC;
        }

        public string AddNewNoteFromDealDetail(Guid? userid, List<NoteDataContract> noteDataContract, string createdBy, string UpdatedBy)
        {
            DataTable dt = new DataTable();
            //check GUId null
            foreach (var note in noteDataContract)
            {
                if (string.IsNullOrEmpty(note.NoteId))
                {
                    note.NoteId = default(Guid).ToString();
                    note.AccountID = default(Guid).ToString();
                }
            }

            // bool retValue = false;

            int count = 0;
            string Newnoteid = "";
            foreach (var note in noteDataContract)
            {
                if (note.CRENoteID.Trim() != "" && note.Name.Trim() != "")
                //if (string.IsNullOrEmpty(note.NoteId))
                {
                    Guid uniNoteID = new Guid(note.NoteId);
                    Guid uniAccountID = new Guid(note.AccountID);
                    Guid uniDealID = new Guid(note.DealID);

                    Helper.Helper hp = new Helper.Helper();
                    SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@NoteID", Value = uniNoteID };
                    SqlParameter p3 = new SqlParameter { ParameterName = "@Account_AccountID", Value = uniAccountID };
                    SqlParameter p4 = new SqlParameter { ParameterName = "@DealID", Value = uniDealID };
                    SqlParameter p5 = new SqlParameter { ParameterName = "@CRENoteID", Value = note.CRENoteID };
                    SqlParameter p6 = new SqlParameter { ParameterName = "@ClosingDate", Value = note.ClosingDate };
                    SqlParameter p7 = new SqlParameter { ParameterName = "@UseRuletoDetermineNoteFunding", Value = note.UseRuletoDetermineNoteFunding };
                    SqlParameter p8 = new SqlParameter { ParameterName = "@NoteFundingRule", Value = note.NoteFundingRule };
                    SqlParameter p9 = new SqlParameter { ParameterName = "@FundingPriority", Value = note.FundingPriority };
                    SqlParameter p10 = new SqlParameter { ParameterName = "@NoteBalanceCap", Value = note.NoteBalanceCap };
                    SqlParameter p11 = new SqlParameter { ParameterName = "@RepaymentPriority", Value = note.RepaymentPriority };
                    SqlParameter p12 = new SqlParameter { ParameterName = "@CreatedBy", Value = createdBy };
                    SqlParameter p13 = new SqlParameter { ParameterName = "@CreatedDate", Value = note.CreatedDate };
                    SqlParameter p14 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UpdatedBy };
                    SqlParameter p15 = new SqlParameter { ParameterName = "@UpdatedDate", Value = note.UpdatedDate };
                    SqlParameter p16 = new SqlParameter { ParameterName = "@name", Value = note.Name };
                    //SqlParameter p17 = new SqlParameter { ParameterName = "@PayFrequency", Value = note.PayFrequency };
                    SqlParameter p18 = new SqlParameter { ParameterName = "@TotalCommitment", Value = note.TotalCommitment };
                    //SqlParameter p19 = new SqlParameter { ParameterName = "@ExtendedMaturityScenario1", Value = note.ExtendedMaturityScenario1 };
                    // SqlParameter p20 = new SqlParameter { ParameterName = "@InitialMaturityDate", Value = note.InitialMaturityDate };
                    SqlParameter p21 = new SqlParameter { ParameterName = "@Priority", Value = note.Priority };
                    SqlParameter p22 = new SqlParameter { ParameterName = "@statusID", Value = note.StatusID };
                    SqlParameter p23 = new SqlParameter { ParameterName = "@NoteRule", Value = note.NoteRule };
                    SqlParameter p24 = new SqlParameter { ParameterName = "@AggregatedTotal", Value = note.AggregatedTotal };
                    SqlParameter p25 = new SqlParameter { ParameterName = "@AdjustedTotalCommitment", Value = note.AdjustedTotalCommitment };
                    SqlParameter p26 = new SqlParameter { ParameterName = "@RoundingNote", Value = note.RoundingNote };
                    SqlParameter p27 = new SqlParameter { ParameterName = "@StraightLineAmortOverride", Value = note.StraightLineAmortOverride };
                    SqlParameter p28 = new SqlParameter { ParameterName = "@UseRuletoDetermineAmortization", Value = note.UseRuletoDetermineAmortization };
                    SqlParameter p29 = new SqlParameter { ParameterName = "@OriginalTotalCommitment", Value = note.OriginalTotalCommitment };
                    SqlParameter p30 = new SqlParameter { ParameterName = "@newnoteId", Direction = ParameterDirection.Output, Size = int.MaxValue };

                    SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p18, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30 };
                    var res = hp.ExecNonquery("dbo.usp_AddUpdateNoteFromDealDetail", sqlparam);
                    Newnoteid = Convert.ToString(p30.Value);

                    if (res != 0)
                    {
                        count = count + 1;
                    }
                    else
                    {
                        count = 0;
                    }

                    //id hardcoded for objecttype note
                    int? lookupid = 182;
                    // if (dt != null && dt.Rows.Count > 0)
                    // {
                    // lookupid = CommonHelper.ToInt32(dt.Rows[0]["LookupID"]);
                    //Save in App.Object table
                    Helper.Helper hpl = new Helper.Helper();
                    SqlParameter pr1 = new SqlParameter { ParameterName = "@ObjectID", Value = new Guid(Newnoteid) };
                    SqlParameter pr2 = new SqlParameter { ParameterName = "@ObjectTypeID", Value = lookupid };
                    SqlParameter pr3 = new SqlParameter { ParameterName = "@CreatedBy", Value = note.CreatedBy };
                    SqlParameter pr4 = new SqlParameter { ParameterName = "@UpdatedBy", Value = note.UpdatedBy };
                    SqlParameter[] sqlparam1 = new SqlParameter[] { pr1, pr2, pr3, pr4 };
                    hpl.ExecNonquery("App.usp_AddUpdateObject", sqlparam1);
                    //=================
                    //   }

                }
            }

            if (count == 1)
                return Newnoteid.ToString();
            else
                return count.ToString();
        }

        public string AddNewNote(Guid? userid, List<NoteDataContract> noteDataContract, string createdBy, string UpdatedBy)
        {
            DataTable dt = new DataTable();
            //check GUId null

            foreach (var note in noteDataContract)
            {
                if (string.IsNullOrEmpty(note.NoteId))
                {
                    note.NoteId = default(Guid).ToString();
                    note.AccountID = default(Guid).ToString();
                }
            }

            // bool retValue = false;

#pragma warning disable CS0219 // The variable 'count' is assigned but its value is never used
            int count = 0;
#pragma warning restore CS0219 // The variable 'count' is assigned but its value is never used
            string Newnoteid = "";
            foreach (var note in noteDataContract)
            {
                //if (!string.IsNullOrEmpty(note.NoteId))
                {
                    Guid uniNoteID = new Guid(note.NoteId);
                    Guid uniAccountID = new Guid(note.AccountID);
                    Guid uniDealID = new Guid(note.DealID);

                    Helper.Helper hp = new Helper.Helper();

                    SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid, };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@NoteID", Value = uniNoteID, };
                    SqlParameter p3 = new SqlParameter { ParameterName = "@Account_AccountID", Value = uniAccountID, };
                    SqlParameter p4 = new SqlParameter { ParameterName = "@DealID", Value = uniDealID, };
                    SqlParameter p5 = new SqlParameter { ParameterName = "@CRENoteID", Value = note.CRENoteID };
                    SqlParameter p6 = new SqlParameter { ParameterName = "@ClientNoteID", Value = note.ClientNoteID };
                    SqlParameter p7 = new SqlParameter { ParameterName = "@Comments", Value = note.Comments };
                    SqlParameter p8 = new SqlParameter { ParameterName = "@InitialInterestAccrualEndDate", Value = note.InitialInterestAccrualEndDate };
                    SqlParameter p9 = new SqlParameter { ParameterName = "@AccrualFrequency", Value = note.AccrualFrequency };
                    SqlParameter p10 = new SqlParameter { ParameterName = "@DeterminationDateLeadDays", Value = note.DeterminationDateLeadDays };
                    SqlParameter p11 = new SqlParameter { ParameterName = "@DeterminationDateReferenceDayoftheMonth", Value = note.DeterminationDateReferenceDayoftheMonth };
                    SqlParameter p12 = new SqlParameter { ParameterName = "@DeterminationDateInterestAccrualPeriod", Value = note.DeterminationDateInterestAccrualPeriod };
                    SqlParameter p13 = new SqlParameter { ParameterName = "@DeterminationDateHolidayList", Value = note.DeterminationDateHolidayList };
                    SqlParameter p14 = new SqlParameter { ParameterName = "@FirstPaymentDate", Value = note.FirstPaymentDate };
                    SqlParameter p15 = new SqlParameter { ParameterName = "@InitialMonthEndPMTDateBiWeekly", Value = note.InitialMonthEndPMTDateBiWeekly };
                    SqlParameter p16 = new SqlParameter { ParameterName = "@PaymentDateBusinessDayLag", Value = note.PaymentDateBusinessDayLag };
                    SqlParameter p17 = new SqlParameter { ParameterName = "@IOTerm", Value = note.IOTerm };
                    SqlParameter p18 = new SqlParameter { ParameterName = "@AmortTerm", Value = note.AmortTerm };
                    SqlParameter p19 = new SqlParameter { ParameterName = "@PIKSeparateCompounding", Value = note.PIKSeparateCompounding };
                    SqlParameter p20 = new SqlParameter { ParameterName = "@MonthlyDSOverridewhenAmortizing", Value = note.MonthlyDSOverridewhenAmortizing };
                    SqlParameter p21 = new SqlParameter { ParameterName = "@AccrualPeriodPaymentDayWhenNotEOMonth", Value = note.AccrualPeriodPaymentDayWhenNotEOMonth };
                    SqlParameter p22 = new SqlParameter { ParameterName = "@FirstPeriodInterestPaymentOverride", Value = note.FirstPeriodInterestPaymentOverride };
                    SqlParameter p23 = new SqlParameter { ParameterName = "@FirstPeriodPrincipalPaymentOverride", Value = note.FirstPeriodPrincipalPaymentOverride };
                    SqlParameter p24 = new SqlParameter { ParameterName = "@FinalInterestAccrualEndDateOverride", Value = note.FinalInterestAccrualEndDateOverride };
                    SqlParameter p25 = new SqlParameter { ParameterName = "@AmortType", Value = note.AmortType };
                    SqlParameter p26 = new SqlParameter { ParameterName = "@RateType", Value = note.RateType };
                    SqlParameter p27 = new SqlParameter { ParameterName = "@ReAmortizeMonthly", Value = note.ReAmortizeMonthly };
                    SqlParameter p28 = new SqlParameter { ParameterName = "@ReAmortizeatPMTReset", Value = note.ReAmortizeatPMTReset };
                    SqlParameter p29 = new SqlParameter { ParameterName = "@StubPaidInArrears", Value = note.StubPaidInArrears };
                    SqlParameter p30 = new SqlParameter { ParameterName = "@RelativePaymentMonth", Value = note.RelativePaymentMonth };
                    SqlParameter p31 = new SqlParameter { ParameterName = "@SettleWithAccrualFlag", Value = note.SettleWithAccrualFlag };
                    SqlParameter p32 = new SqlParameter { ParameterName = "@InterestDueAtMaturity", Value = note.InterestDueAtMaturity };
                    SqlParameter p33 = new SqlParameter { ParameterName = "@RateIndexResetFreq", Value = note.RateIndexResetFreq };
                    SqlParameter p34 = new SqlParameter { ParameterName = "@FirstRateIndexResetDate", Value = note.FirstRateIndexResetDate };
                    SqlParameter p35 = new SqlParameter { ParameterName = "@LoanPurchase", Value = note.LoanPurchase };
                    SqlParameter p36 = new SqlParameter { ParameterName = "@AmortIntCalcDayCount", Value = note.AmortIntCalcDayCount };
                    SqlParameter p37 = new SqlParameter { ParameterName = "@StubPaidinAdvanceYN", Value = note.StubPaidinAdvanceYN };
                    SqlParameter p38 = new SqlParameter { ParameterName = "@FullPeriodInterestDueatMaturity", Value = note.FullPeriodInterestDueatMaturity };
                    SqlParameter p39 = new SqlParameter { ParameterName = "@ProspectiveAccountingMode", Value = note.ProspectiveAccountingMode };
                    SqlParameter p40 = new SqlParameter { ParameterName = "@IsCapitalized", Value = note.IsCapitalized };
                    SqlParameter p41 = new SqlParameter { ParameterName = "@SelectedMaturityDateScenario", Value = note.SelectedMaturityDateScenario };
                    //SqlParameter p42 = new SqlParameter { ParameterName = "@SelectedMaturityDate", Value = note.SelectedMaturityDate };
                    // SqlParameter p43 = new SqlParameter { ParameterName = "@InitialMaturityDate", Value = note.InitialMaturityDate };
                    //SqlParameter p44 = new SqlParameter { ParameterName = "@ExpectedMaturityDate", Value = note.ExpectedMaturityDate };
                    // SqlParameter p45 = new SqlParameter { ParameterName = "@FullyExtendedMaturityDate", Value = note.FullyExtendedMaturityDate };
                    // SqlParameter p46 = new SqlParameter { ParameterName = "@OpenPrepaymentDate", Value = note.OpenPrepaymentDate };
                    SqlParameter p47 = new SqlParameter { ParameterName = "@CashflowEngineID", Value = note.CashflowEngineID };
                    SqlParameter p48 = new SqlParameter { ParameterName = "@LoanType", Value = note.LoanType };
                    SqlParameter p49 = new SqlParameter { ParameterName = "@Classification", Value = note.Classification };
                    SqlParameter p50 = new SqlParameter { ParameterName = "@SubClassification", Value = note.SubClassification };
                    SqlParameter p51 = new SqlParameter { ParameterName = "@GAAPDesignation", Value = note.GAAPDesignation };
                    SqlParameter p52 = new SqlParameter { ParameterName = "@PortfolioID", Value = note.PortfolioID };
                    SqlParameter p53 = new SqlParameter { ParameterName = "@GeographicLocation", Value = note.GeographicLocation };
                    SqlParameter p54 = new SqlParameter { ParameterName = "@PropertyType", Value = note.PropertyType };
                    SqlParameter p55 = new SqlParameter { ParameterName = "@RatingAgency", Value = note.RatingAgency };
                    SqlParameter p56 = new SqlParameter { ParameterName = "@RiskRating", Value = note.RiskRating };
                    SqlParameter p57 = new SqlParameter { ParameterName = "@PurchasePrice", Value = note.PurchasePrice };
                    SqlParameter p58 = new SqlParameter { ParameterName = "@FutureFeesUsedforLevelYeild", Value = note.FutureFeesUsedforLevelYeild };
                    SqlParameter p59 = new SqlParameter { ParameterName = "@TotalToBeAmortized", Value = note.TotalToBeAmortized };
                    SqlParameter p60 = new SqlParameter { ParameterName = "@StubPeriodInterest", Value = note.StubPeriodInterest };
                    SqlParameter p61 = new SqlParameter { ParameterName = "@WDPAssetMultiple", Value = note.WDPAssetMultiple };
                    SqlParameter p62 = new SqlParameter { ParameterName = "@WDPEquityMultiple", Value = note.WDPEquityMultiple };
                    SqlParameter p63 = new SqlParameter { ParameterName = "@PurchaseBalance", Value = note.PurchaseBalance };
                    SqlParameter p64 = new SqlParameter { ParameterName = "@DaysofAccrued", Value = note.DaysofAccrued };
                    SqlParameter p65 = new SqlParameter { ParameterName = "@InterestRate", Value = note.InterestRate };
                    SqlParameter p66 = new SqlParameter { ParameterName = "@PurchasedInterestCalc", Value = note.PurchasedInterestCalc };
                    SqlParameter p67 = new SqlParameter { ParameterName = "@ModelFinancingDrawsForFutureFundings", Value = note.ModelFinancingDrawsForFutureFundings };
                    SqlParameter p68 = new SqlParameter { ParameterName = "@NumberOfBusinessDaysLagForFinancingDraw", Value = note.NumberOfBusinessDaysLagForFinancingDraw };
                    SqlParameter p69 = new SqlParameter { ParameterName = "@FinancingFacilityID", Value = note.FinancingFacilityID };
                    SqlParameter p70 = new SqlParameter { ParameterName = "@FinancingInitialMaturityDate", Value = note.FinancingInitialMaturityDate };
                    SqlParameter p71 = new SqlParameter { ParameterName = "@FinancingExtendedMaturityDate", Value = note.FinancingExtendedMaturityDate };
                    SqlParameter p72 = new SqlParameter { ParameterName = "@FinancingPayFrequency", Value = note.FinancingPayFrequency };
                    SqlParameter p73 = new SqlParameter { ParameterName = "@FinancingInterestPaymentDay", Value = note.FinancingInterestPaymentDay };
                    SqlParameter p74 = new SqlParameter { ParameterName = "@ClosingDate", Value = note.ClosingDate };
                    SqlParameter p75 = new SqlParameter { ParameterName = "@InitialFundingAmount", Value = note.InitialFundingAmount };
                    SqlParameter p76 = new SqlParameter { ParameterName = "@Discount", Value = note.Discount };
                    SqlParameter p77 = new SqlParameter { ParameterName = "@OriginationFee", Value = note.OriginationFee };
                    SqlParameter p78 = new SqlParameter { ParameterName = "@CapitalizedClosingCosts", Value = note.CapitalizedClosingCosts };
                    SqlParameter p79 = new SqlParameter { ParameterName = "@PurchaseDate", Value = note.PurchaseDate };
                    SqlParameter p80 = new SqlParameter { ParameterName = "@PurchaseAccruedFromDate", Value = note.PurchaseAccruedFromDate };
                    SqlParameter p81 = new SqlParameter { ParameterName = "@PurchasedInterestOverride", Value = note.PurchasedInterestOverride };
                    SqlParameter p82 = new SqlParameter { ParameterName = "@DiscountRate", Value = note.DiscountRate };
                    SqlParameter p83 = new SqlParameter { ParameterName = "@ValuationDate", Value = note.ValuationDate };
                    SqlParameter p84 = new SqlParameter { ParameterName = "@FairValue", Value = note.FairValue };
                    SqlParameter p85 = new SqlParameter { ParameterName = "@DiscountRatePlus", Value = note.DiscountRatePlus };
                    SqlParameter p86 = new SqlParameter { ParameterName = "@FairValuePlus", Value = note.FairValuePlus };
                    SqlParameter p87 = new SqlParameter { ParameterName = "@DiscountRateMinus", Value = note.DiscountRateMinus };
                    SqlParameter p88 = new SqlParameter { ParameterName = "@FairValueMinus", Value = note.FairValueMinus };
                    SqlParameter p89 = new SqlParameter { ParameterName = "@InitialIndexValueOverride", Value = note.InitialIndexValueOverride };
                    SqlParameter p90 = new SqlParameter { ParameterName = "@IncludeServicingPaymentOverrideinLevelYield", Value = note.IncludeServicingPaymentOverrideinLevelYield };
                    SqlParameter p91 = new SqlParameter { ParameterName = "@OngoingAnnualizedServicingFee", Value = note.OngoingAnnualizedServicingFee };
                    SqlParameter p92 = new SqlParameter { ParameterName = "@IndexRoundingRule", Value = note.IndexRoundingRule };
                    SqlParameter p93 = new SqlParameter { ParameterName = "@RoundingMethod", Value = note.RoundingMethod };
                    SqlParameter p94 = new SqlParameter { ParameterName = "@StubInterestPaidonFutureAdvances", Value = note.StubInterestPaidonFutureAdvances };
                    SqlParameter p95 = new SqlParameter { ParameterName = "@TaxAmortCheck", Value = note.TaxAmortCheck };
                    SqlParameter p96 = new SqlParameter { ParameterName = "@PIKWoCompCheck", Value = note.PIKWoCompCheck };
                    SqlParameter p97 = new SqlParameter { ParameterName = "@GAAPAmortCheck", Value = note.GAAPAmortCheck };
                    SqlParameter p98 = new SqlParameter { ParameterName = "@StubIntOverride", Value = note.StubIntOverride };
                    SqlParameter p99 = new SqlParameter { ParameterName = "@ExitFeeFreePrepayAmt", Value = note.ExitFeeFreePrepayAmt };
                    SqlParameter p100 = new SqlParameter { ParameterName = "@ExitFeeBaseAmountOverride", Value = note.ExitFeeBaseAmountOverride };
                    SqlParameter p101 = new SqlParameter { ParameterName = "@ExitFeeAmortCheck", Value = note.ExitFeeAmortCheck };
                    SqlParameter p102 = new SqlParameter { ParameterName = "@FixedAmortScheduleCheck", Value = note.FixedAmortSchedule };
                    SqlParameter p103 = new SqlParameter { ParameterName = "@NoofdaysrelPaymentDaterollnextpaymentcycle", Value = note.NoofdaysrelPaymentDaterollnextpaymentcycle };
                    SqlParameter p104 = new SqlParameter { ParameterName = "@CreatedBy", Value = createdBy };
                    SqlParameter p105 = new SqlParameter { ParameterName = "@CreatedDate", Value = note.CreatedDate };
                    SqlParameter p106 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UpdatedBy };
                    SqlParameter p107 = new SqlParameter { ParameterName = "@UpdatedDate", Value = note.UpdatedDate };
                    SqlParameter p108 = new SqlParameter { ParameterName = "@name", Value = note.Name };
                    SqlParameter p109 = new SqlParameter { ParameterName = "@statusID", Value = note.StatusID };
                    SqlParameter p110 = new SqlParameter { ParameterName = "@BaseCurrencyID", Value = note.BaseCurrencyID };
                    SqlParameter p111 = new SqlParameter { ParameterName = "@StartDate", Value = note.StartDate };
                    SqlParameter p112 = new SqlParameter { ParameterName = "@EndDate", Value = note.EndDate };
                    SqlParameter p113 = new SqlParameter { ParameterName = "@PayFrequency", Value = note.PayFrequency };
                    SqlParameter p114 = new SqlParameter { ParameterName = "@UseIndexOverrides", Value = note.UseIndexOverrides };
                    SqlParameter p115 = new SqlParameter { ParameterName = "@IndexNameID", Value = note.IndexNameID };
                    SqlParameter p116 = new SqlParameter { ParameterName = "@ServicerID", Value = note.ServicerID };
                    //  SqlParameter p117 = new SqlParameter { ParameterName = "@TotalCommitment", Value = note.TotalCommitment };
                    SqlParameter p118 = new SqlParameter { ParameterName = "@ClientName", Value = note.ClientName };
                    SqlParameter p119 = new SqlParameter { ParameterName = "@Portfolio", Value = note.Portfolio };
                    SqlParameter p120 = new SqlParameter { ParameterName = "@Tag1", Value = note.Tag1 };
                    SqlParameter p121 = new SqlParameter { ParameterName = "@Tag2", Value = note.Tag2 };
                    SqlParameter p122 = new SqlParameter { ParameterName = "@Tag3", Value = note.Tag3 };
                    SqlParameter p123 = new SqlParameter { ParameterName = "@Tag4", Value = note.Tag4 };
                    // SqlParameter p124 = new SqlParameter { ParameterName = "@ExtendedMaturityScenario1", Value = note.ExtendedMaturityScenario1 };
                    // SqlParameter p125 = new SqlParameter { ParameterName = "@ExtendedMaturityScenario2", Value = note.ExtendedMaturityScenario2 };
                    // SqlParameter p126 = new SqlParameter { ParameterName = "@ExtendedMaturityScenario3", Value = note.ExtendedMaturityScenario3 };
                    SqlParameter p127 = new SqlParameter { ParameterName = "@ActualPayoffDate", Value = note.ActualPayoffDate };
                    SqlParameter p128 = new SqlParameter { ParameterName = "@TotalCommitmentExtensionFeeisBasedOn", Value = note.TotalCommitmentExtensionFeeisBasedOn };
                    SqlParameter p129 = new SqlParameter { ParameterName = "@UnusedFeeThresholdBalance", Value = note.UnusedFeeThresholdBalance };
                    SqlParameter p130 = new SqlParameter { ParameterName = "@UnusedFeePaymentFrequency", Value = note.UnusedFeePaymentFrequency };
                    SqlParameter p131 = new SqlParameter { ParameterName = "@Servicer", Value = note.Servicer };
                    SqlParameter p132 = new SqlParameter { ParameterName = "@FullInterestAtPPayoff", Value = note.FullInterestAtPPayoff };
                    SqlParameter p133 = new SqlParameter { ParameterName = "@newnoteId", Direction = ParameterDirection.Output, Size = int.MaxValue };
                    SqlParameter p134 = new SqlParameter { ParameterName = "@ClientID", Value = note.ClientID };
                    SqlParameter p135 = new SqlParameter { ParameterName = "@FundId", Value = note.FundID };
                    SqlParameter p136 = new SqlParameter { ParameterName = "@FinancingSourceID", Value = note.FinancingSourceID };
                    SqlParameter p137 = new SqlParameter { ParameterName = "@DebtTypeID", Value = note.DebtTypeID };
                    SqlParameter p138 = new SqlParameter { ParameterName = "@BillingNotesID", Value = note.BillingNotesID };
                    SqlParameter p139 = new SqlParameter { ParameterName = "@CapStack", Value = note.CapStack };
                    SqlParameter p140 = new SqlParameter { ParameterName = "@PoolID", Value = note.PoolID };
                    SqlParameter p141 = new SqlParameter { ParameterName = "@StubInterestRateOverride", Value = note.StubInterestRateOverride };
                    SqlParameter p142 = new SqlParameter { ParameterName = "@LiborDataAsofDate", Value = note.LiborDataAsofDate };
                    SqlParameter p143 = new SqlParameter { ParameterName = "@ServicerNameID", Value = note.ServicerNameID };
                    SqlParameter p144 = new SqlParameter { ParameterName = "@BusinessdaylafrelativetoPMTDate", Value = note.BusinessdaylafrelativetoPMTDate };
                    SqlParameter p145 = new SqlParameter { ParameterName = "@DayoftheMonth", Value = note.DayoftheMonth };
                    SqlParameter p146 = new SqlParameter { ParameterName = "@InterestCalculationRuleForPaydowns", Value = note.InterestCalculationRuleForPaydowns };
                    SqlParameter p147 = new SqlParameter { ParameterName = "@PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate", Value = note.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate };
                    SqlParameter p148 = new SqlParameter { ParameterName = "@InterestCalculationRuleForPaydownsAmort", Value = note.InterestCalculationRuleForPaydownsAmort };
                    SqlParameter p149 = new SqlParameter { ParameterName = "@RoundingNote", Value = note.RoundingNote };
                    SqlParameter p150 = new SqlParameter { ParameterName = "@StraightLineAmortOverride", Value = note.StraightLineAmortOverride };
                    //SqlParameter p151 = new SqlParameter { ParameterName = "@AdjustedTotalCommitment", Value = note.AdjustedTotalCommitment };
                    // SqlParameter p152 = new SqlParameter { ParameterName = "@AggregatedTotal", Value = note.AggregatedTotal };
                    SqlParameter p151 = new SqlParameter { ParameterName = "@RepaymentDayoftheMonth", Value = note.RepaymentDayoftheMonth };
                    SqlParameter p152 = new SqlParameter { ParameterName = "@MarketPrice", Value = note.MKT_PRICE };
                    SqlParameter p153 = new SqlParameter { ParameterName = "@StrategyCode", Value = note.StrategyCode };
                    //SqlParameter p154 = new SqlParameter { ParameterName = "@OriginalTotalCommitment", Value = note.OriginalTotalCommitment };
                    SqlParameter p155 = new SqlParameter { ParameterName = "@NoteTransferDate", Value = note.NoteTransferDate };
                    SqlParameter p156 = new SqlParameter { ParameterName = "@EnableM61Calculations", Value = note.EnableM61Calculations };
                    SqlParameter p157 = new SqlParameter { ParameterName = "@InitialRequiredEquity", Value = note.InitialRequiredEquity };
                    SqlParameter p158 = new SqlParameter { ParameterName = "@InitialAdditionalEquity", Value = note.InitialAdditionalEquity };
                    SqlParameter p159 = new SqlParameter { ParameterName = "@OriginationFeePercentageRP", Value = note.OriginationFeePercentageRP };
                    SqlParameter p160 = new SqlParameter { ParameterName = "@ImpactCommitmentCalc", Value = note.ImpactCommitmentCalc };

                    SqlParameter[] sqlparam = new SqlParameter[] {
                     p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,p25,p26,p27,p28,p29,p30,
                     p31,p32,p33,p34,p35,p36,p37,p38,p39,p40,p41,p47,p48,p49,p50,p51,p52,p53,p54,p55,p56,p57,p58,p59,p60,
                     p61,p62,p63,p64,p65,p66,p67,p68,p69,p70,p71,p72,p73,p74,p75,p76,p77,p78,p79,p80,p81,p82,p83,p84,p85,p86,p87,p88,p89,p90,
                     p91,p92,p93,p94,p95,p96,p97,p98,p99,p100,p101,p102,p103,p104,p105,p106,p107,p108,p109,p110,p111,p112,p113,p114,p115,p116,
                     p118,p119,p120,p121,p122,p123,p127,p128,p129,p130,p131,p132,p133,p134,p135,p136,p137,p138,p139,p140,
                     p141,p142,p143,p144,p145,p146,p147,p148,p149,p150,p151,p152,p153,p155,p156,p157,p158,p159,p160
                    };

                    hp.ExecNonquery("dbo.usp_AddUpdateNote", sqlparam);
                    Newnoteid = Convert.ToString(p133.Value);
                    //if (string.IsNullOrEmpty(note.AccountID))
                    //    note.AccountID = default(Guid).ToString();

                    if (Newnoteid != "00000000-0000-0000-0000-000000000000")
                    {

                        Helper.Helper hpl1 = new Helper.Helper();
                        SqlParameter hp1 = new SqlParameter { ParameterName = "@Name", Value = "note" };
                        SqlParameter hp2 = new SqlParameter { ParameterName = "@ParentID", Value = 27 };
                        SqlParameter hp3 = new SqlParameter { ParameterName = "@LookupID", Value = null };
                        SqlParameter[] sqlparamhp1 = new SqlParameter[] { hp1, hp2, hp3 };
                        dt = hpl1.ExecDataTable("dbo.usp_GetLookupByNameAndParentID", sqlparamhp1);

                        int? lookupid = null;
                        if (dt != null && dt.Rows.Count > 0)
                        {
                            lookupid = CommonHelper.ToInt32(dt.Rows[0]["LookupID"]);
                            //Save in App.Object table
                            Helper.Helper hpl = new Helper.Helper();
                            SqlParameter pr1 = new SqlParameter { ParameterName = "@ObjectID", Value = new Guid(Newnoteid) };
                            SqlParameter pr2 = new SqlParameter { ParameterName = "@ObjectTypeID", Value = lookupid };
                            SqlParameter pr3 = new SqlParameter { ParameterName = "@CreatedBy", Value = note.CreatedBy };
                            SqlParameter pr4 = new SqlParameter { ParameterName = "@UpdatedBy", Value = note.UpdatedBy };
                            SqlParameter[] sqlparam1 = new SqlParameter[] { pr1, pr2, pr3, pr4 };
                            hpl.ExecNonquery("App.usp_AddUpdateObject", sqlparam1);
                        }

                    }
                }
            }
            return Newnoteid.ToString();
            //if (count == 1)
            //    return Newnoteid.ToString();
            //else
            //    return count.ToString();
        }

        public NoteDataContract GetNoteFromNoteId(String noteID, Guid? userID, Guid? AnalysisID)
        {
            NoteDataContract _notedc = new NoteDataContract();
            List<NoteDataContract> _lstnotedc = new List<NoteDataContract>();
            DataTable dt = new DataTable();
            if (noteID != "00000000-0000-0000-0000-000000000000" || noteID == null)
            {


                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dt = hp.ExecDataTable("dbo.usp_GetNoteByNoteId", sqlparam);
                if (dt == null || dt.Rows.Count == 0)
                {
                    _notedc.StatusCode = 404;
                }

                if (dt != null && dt.Rows.Count > 0)
                {

                    _notedc.NoteId = Convert.ToString(dt.Rows[0]["NoteID"]);
                    _notedc.Name = Convert.ToString(dt.Rows[0]["Name"]);
                    _notedc.AccountID = Convert.ToString(dt.Rows[0]["Account_AccountID"]);
                    _notedc.DealID = Convert.ToString(dt.Rows[0]["DealID"]);
                    _notedc.CRENoteID = Convert.ToString(dt.Rows[0]["CRENoteID"]);
                    _notedc.ClientNoteID = Convert.ToString(dt.Rows[0]["ClientNoteID"]);
                    _notedc.Comments = Convert.ToString(dt.Rows[0]["Comments"]);
                    _notedc.InitialInterestAccrualEndDate = CommonHelper.ToDateTime(dt.Rows[0]["InitialInterestAccrualEndDate"]);
                    _notedc.AccrualFrequency = CommonHelper.ToInt32(dt.Rows[0]["AccrualFrequency"]);
                    _notedc.DeterminationDateLeadDays = CommonHelper.ToInt32(dt.Rows[0]["DeterminationDateLeadDays"]);
                    _notedc.DeterminationDateReferenceDayoftheMonth = CommonHelper.ToInt32(dt.Rows[0]["DeterminationDateReferenceDayoftheMonth"]);
                    _notedc.DeterminationDateInterestAccrualPeriod = CommonHelper.ToInt32(dt.Rows[0]["DeterminationDateInterestAccrualPeriod"]);
                    _notedc.DeterminationDateHolidayList = CommonHelper.ToInt32(dt.Rows[0]["DeterminationDateHolidayList"]);
                    _notedc.FirstPaymentDate = CommonHelper.ToDateTime(dt.Rows[0]["FirstPaymentDate"]);
                    _notedc.InitialMonthEndPMTDateBiWeekly = CommonHelper.ToDateTime(dt.Rows[0]["InitialMonthEndPMTDateBiWeekly"]);
                    _notedc.PaymentDateBusinessDayLag = CommonHelper.ToInt32(dt.Rows[0]["PaymentDateBusinessDayLag"]);
                    _notedc.PayFrequency = CommonHelper.ToInt32(dt.Rows[0]["PayFrequency"]);
                    _notedc.IOTerm = CommonHelper.ToInt32(dt.Rows[0]["IOTerm"]);
                    _notedc.AmortTerm = CommonHelper.ToInt32(dt.Rows[0]["AmortTerm"]);
                    _notedc.PIKSeparateCompounding = CommonHelper.ToInt32(dt.Rows[0]["PIKSeparateCompounding"]);
                    _notedc.MonthlyDSOverridewhenAmortizing = CommonHelper.ToDecimal(dt.Rows[0]["MonthlyDSOverridewhenAmortizing"]);
                    _notedc.AccrualPeriodPaymentDayWhenNotEOMonth = CommonHelper.ToInt32(dt.Rows[0]["AccrualPeriodPaymentDayWhenNotEOMonth"]);
                    _notedc.FirstPeriodInterestPaymentOverride = CommonHelper.ToDecimal(dt.Rows[0]["FirstPeriodInterestPaymentOverride"]);
                    _notedc.FirstPeriodPrincipalPaymentOverride = CommonHelper.ToDecimal(dt.Rows[0]["FirstPeriodPrincipalPaymentOverride"]);
                    _notedc.FinalInterestAccrualEndDateOverride = CommonHelper.ToDateTime(dt.Rows[0]["FinalInterestAccrualEndDateOverride"]);
                    _notedc.AmortType = CommonHelper.ToInt32(dt.Rows[0]["AmortType"]);
                    _notedc.RateType = CommonHelper.ToInt32(dt.Rows[0]["RateType"]);
                    _notedc.RateTypeText = Convert.ToString(dt.Rows[0]["RateTypeText"]);
                    _notedc.ReAmortizeMonthly = CommonHelper.ToInt32(dt.Rows[0]["ReAmortizeMonthly"]);
                    _notedc.ReAmortizeatPMTReset = CommonHelper.ToInt32(dt.Rows[0]["ReAmortizeatPMTReset"]);
                    _notedc.StubPaidInArrears = CommonHelper.ToInt32(dt.Rows[0]["StubPaidInArrears"]);
                    _notedc.RelativePaymentMonth = CommonHelper.ToInt32(dt.Rows[0]["RelativePaymentMonth"]);
                    _notedc.SettleWithAccrualFlag = CommonHelper.ToInt32(dt.Rows[0]["SettleWithAccrualFlag"]);
                    _notedc.InterestDueAtMaturity = CommonHelper.ToInt32(dt.Rows[0]["InterestDueAtMaturity"]);
                    _notedc.RateIndexResetFreq = CommonHelper.ToDecimal(dt.Rows[0]["RateIndexResetFreq"]);
                    _notedc.FirstRateIndexResetDate = CommonHelper.ToDateTime(dt.Rows[0]["FirstRateIndexResetDate"]);
                    _notedc.LoanPurchase = CommonHelper.ToInt32(dt.Rows[0]["LoanPurchase"]);
                    _notedc.LoanPurchaseYNText = Convert.ToString(dt.Rows[0]["LoanPurchaseText"]);
                    _notedc.DeterminationDateHolidayListText = Convert.ToString(dt.Rows[0]["DeterminationDateHolidayListText"]);
                    _notedc.AmortIntCalcDayCount = CommonHelper.ToInt32(dt.Rows[0]["AmortIntCalcDayCount"]);
                    _notedc.StubPaidinAdvanceYN = CommonHelper.ToInt32(dt.Rows[0]["StubPaidinAdvanceYN"]);
                    _notedc.FullPeriodInterestDueatMaturity = CommonHelper.ToInt32(dt.Rows[0]["FullPeriodInterestDueatMaturity"]);
                    _notedc.ProspectiveAccountingMode = CommonHelper.ToInt32(dt.Rows[0]["ProspectiveAccountingMode"]);
                    _notedc.IsCapitalized = CommonHelper.ToInt32(dt.Rows[0]["IsCapitalized"]);
                    _notedc.SelectedMaturityDateScenario = CommonHelper.ToInt32(dt.Rows[0]["SelectedMaturityDateScenario"]);
                    _notedc.SelectedMaturityDate = CommonHelper.ToDateTime(dt.Rows[0]["SelectedMaturityDate"]);
                    _notedc.InitialMaturityDate = CommonHelper.ToDateTime(dt.Rows[0]["InitialMaturityDate"]);
                    _notedc.ExpectedMaturityDate = CommonHelper.ToDateTime(dt.Rows[0]["ExpectedMaturityDate"]);
                    _notedc.FullyExtendedMaturityDate = CommonHelper.ToDateTime(dt.Rows[0]["FullyExtendedMaturityDate"]);
                    _notedc.OpenPrepaymentDate = CommonHelper.ToDateTime(dt.Rows[0]["OpenPrepaymentDate"]);
                    _notedc.CashflowEngineID = CommonHelper.ToInt32(dt.Rows[0]["CashflowEngineID"]);
                    _notedc.LoanType = CommonHelper.ToInt32(dt.Rows[0]["LoanType"]);
                    _notedc.Classification = CommonHelper.ToInt32(dt.Rows[0]["Classification"]);
                    _notedc.SubClassification = CommonHelper.ToInt32(dt.Rows[0]["SubClassification"]);
                    _notedc.GAAPDesignation = CommonHelper.ToInt32(dt.Rows[0]["GAAPDesignation"]);
                    _notedc.PortfolioID = CommonHelper.ToInt32(dt.Rows[0]["PortfolioID"]);
                    _notedc.TaxAmortCheck = Convert.ToString(dt.Rows[0]["TaxAmortCheck"]);
                    _notedc.InitialIndexValueOverride = CommonHelper.ToDecimal(dt.Rows[0]["InitialIndexValueOverride"]);
                    _notedc.PIKWoCompCheck = Convert.ToString(dt.Rows[0]["PIKWoCompCheck"]);
                    _notedc.GeographicLocation = CommonHelper.ToInt32(dt.Rows[0]["GeographicLocation"]);
                    _notedc.PropertyType = CommonHelper.ToInt32(dt.Rows[0]["PropertyType"]);
                    _notedc.RatingAgency = CommonHelper.ToInt32(dt.Rows[0]["RatingAgency"]);
                    _notedc.RiskRating = CommonHelper.ToInt32(dt.Rows[0]["RiskRating"]);
                    _notedc.PurchasePrice = CommonHelper.ToDecimal(dt.Rows[0]["PurchasePrice"]);
                    _notedc.FutureFeesUsedforLevelYeild = CommonHelper.ToDecimal(dt.Rows[0]["FutureFeesUsedforLevelYeild"]);
                    _notedc.TotalToBeAmortized = CommonHelper.ToDecimal(dt.Rows[0]["TotalToBeAmortized"]);
                    _notedc.StubPeriodInterest = CommonHelper.ToDecimal(dt.Rows[0]["StubPeriodInterest"]);
                    _notedc.WDPAssetMultiple = CommonHelper.ToDecimal(dt.Rows[0]["WDPAssetMultiple"]);
                    _notedc.WDPEquityMultiple = CommonHelper.ToDecimal(dt.Rows[0]["WDPEquityMultiple"]);
                    _notedc.PurchaseBalance = CommonHelper.ToDecimal(dt.Rows[0]["PurchaseBalance"]);
                    _notedc.DaysofAccrued = CommonHelper.ToInt32(dt.Rows[0]["DaysofAccrued"]);
                    _notedc.InterestRate = CommonHelper.ToDecimal(dt.Rows[0]["InterestRate"]);
                    _notedc.PurchasedInterestCalc = CommonHelper.ToDecimal(dt.Rows[0]["PurchasedInterestCalc"]);
                    _notedc.ModelFinancingDrawsForFutureFundings = CommonHelper.ToInt32(dt.Rows[0]["ModelFinancingDrawsForFutureFundings"]);
                    _notedc.NumberOfBusinessDaysLagForFinancingDraw = CommonHelper.ToInt32(dt.Rows[0]["NumberOfBusinessDaysLagForFinancingDraw"]);
                    if (Convert.ToString(dt.Rows[0]["FinancingFacilityID"]) != "")
                    {
                        _notedc.FinancingFacilityID = new Guid(Convert.ToString(dt.Rows[0]["FinancingFacilityID"]));
                    }
                    _notedc.FinancingInitialMaturityDate = CommonHelper.ToDateTime(dt.Rows[0]["FinancingInitialMaturityDate"]);
                    _notedc.FinancingExtendedMaturityDate = CommonHelper.ToDateTime(dt.Rows[0]["FinancingExtendedMaturityDate"]);
                    _notedc.FinancingPayFrequency = CommonHelper.ToInt32(dt.Rows[0]["FinancingPayFrequency"]);
                    _notedc.FinancingInterestPaymentDay = CommonHelper.ToInt32(dt.Rows[0]["FinancingInterestPaymentDay"]);
                    _notedc.ClosingDate = CommonHelper.ToDateTime(dt.Rows[0]["ClosingDate"]);
                    _notedc.InitialFundingAmount = CommonHelper.ToDecimal(dt.Rows[0]["InitialFundingAmount"]);
                    _notedc.Discount = CommonHelper.ToDecimal(dt.Rows[0]["Discount"]);
                    _notedc.OriginationFee = CommonHelper.ToDecimal(dt.Rows[0]["OriginationFee"]);
                    _notedc.CapitalizedClosingCosts = CommonHelper.ToDecimal(dt.Rows[0]["CapitalizedClosingCosts"]);
                    _notedc.PurchaseDate = CommonHelper.ToDateTime(dt.Rows[0]["PurchaseDate"]);
                    _notedc.PurchaseAccruedFromDate = CommonHelper.ToDecimal(dt.Rows[0]["PurchaseAccruedFromDate"]);
                    _notedc.PurchasedInterestOverride = CommonHelper.ToDecimal(dt.Rows[0]["PurchasedInterestOverride"]);
                    _notedc.OngoingAnnualizedServicingFee = CommonHelper.ToDecimal(dt.Rows[0]["OngoingAnnualizedServicingFee"]);
                    _notedc.DiscountRate = CommonHelper.ToDecimal(dt.Rows[0]["DiscountRate"]);
                    _notedc.ValuationDate = CommonHelper.ToDateTime(dt.Rows[0]["ValuationDate"]);
                    _notedc.FairValue = CommonHelper.ToDecimal(dt.Rows[0]["FairValue"]);
                    _notedc.DiscountRatePlus = CommonHelper.ToDecimal(dt.Rows[0]["DiscountRatePlus"]);
                    _notedc.FairValuePlus = CommonHelper.ToDecimal(dt.Rows[0]["FairValuePlus"]);
                    _notedc.DiscountRateMinus = CommonHelper.ToDecimal(dt.Rows[0]["DiscountRateMinus"]);
                    _notedc.FairValueMinus = CommonHelper.ToDecimal(dt.Rows[0]["FairValueMinus"]);
                    _notedc.IncludeServicingPaymentOverrideinLevelYield = CommonHelper.ToInt32(dt.Rows[0]["IncludeServicingPaymentOverrideinLevelYield"]);
                    _notedc.CreatedBy = Convert.ToString(dt.Rows[0]["CreatedBy"]);
                    _notedc.CreatedDate = CommonHelper.ToDateTime(dt.Rows[0]["CreatedDate"]);
                    _notedc.UpdatedBy = Convert.ToString(dt.Rows[0]["UpdatedBy"]);
                    _notedc.UpdatedDate = CommonHelper.ToDateTime(dt.Rows[0]["UpdatedDate"]);
                    _notedc.BaseCurrencyID = CommonHelper.ToInt32(dt.Rows[0]["BaseCurrencyID"]);
                    _notedc.StatusID = CommonHelper.ToInt32(dt.Rows[0]["StatusID"]);
                    _notedc.StartDate = CommonHelper.ToDateTime(dt.Rows[0]["StartDate"]);
                    _notedc.EndDate = CommonHelper.ToDateTime(dt.Rows[0]["EndDate"]);
                    _notedc.RoundingMethod = CommonHelper.ToInt32(dt.Rows[0]["RoundingMethod"]);
                    _notedc.RoundingMethodText = Convert.ToString(dt.Rows[0]["RoundingMethodText"]);
                    _notedc.IndexRoundingRule = CommonHelper.ToInt32(dt.Rows[0]["IndexRoundingRule"]);
                    _notedc.StubInterestPaidonFutureAdvances = CommonHelper.ToInt32(dt.Rows[0]["StubInterestPaidonFutureAdvances"]);
                    _notedc.StubIntOverride = CommonHelper.ToDecimal(dt.Rows[0]["StubIntOverride"]);
                    _notedc.PurchasedInterestOverride = CommonHelper.ToDecimal(dt.Rows[0]["PurchasedInterestOverride"]);
                    _notedc.ExitFeeFreePrepayAmt = CommonHelper.ToDecimal(dt.Rows[0]["ExitFeeFreePrepayAmt"]);
                    _notedc.ExitFeeBaseAmountOverride = CommonHelper.ToDecimal(dt.Rows[0]["ExitFeeBaseAmountOverride"]);
                    _notedc.LoanCurrency = Convert.ToString(dt.Rows[0]["LoanCurrency"]);
                    _notedc.PurchasedIntOverride = CommonHelper.ToDecimal(dt.Rows[0]["PurchasedIntOverride"]);
                    _notedc.ExitFeeFreePrepayAmt = CommonHelper.ToDecimal(dt.Rows[0]["ExitFeeFreePrepayAmt"]);
                    _notedc.ExitFeeAmortCheck = CommonHelper.ToInt32(dt.Rows[0]["ExitFeeAmortCheck"]);
                    _notedc.ExitFeeAmortCheckText = Convert.ToString(dt.Rows[0]["ExitFeeAmortCheckText"]);
                    _notedc.FixedAmortSchedule = CommonHelper.ToInt32(dt.Rows[0]["FixedAmortSchedule"]);
                    _notedc.FixedAmortScheduleText = Convert.ToString(dt.Rows[0]["FixedAmortScheduleText"]);
                    _notedc.IncludeServicingPaymentOverrideinLevelYieldText = Convert.ToString(dt.Rows[0]["IncludeServicingPaymentOverrideinLevelYieldText"]);
                    _notedc.PIKSeparateCompoundingText = Convert.ToString(dt.Rows[0]["PIKSeparateCompoundingText"]);
                    _notedc.StubPaidinAdvanceYNText = Convert.ToString(dt.Rows[0]["StubPaidinAdvanceYNText"]);
                    _notedc.ModelFinancingDrawsForFutureFundingsText = Convert.ToString(dt.Rows[0]["ModelFinancingDrawsForFutureFundingsText"]);
                    _notedc.NoofdaysrelPaymentDaterollnextpaymentcycle = CommonHelper.ToInt32(dt.Rows[0]["NoofdaysrelPaymentDaterollnextpaymentcycle"]);
                    _notedc.DealName = Convert.ToString(dt.Rows[0]["DealName"]);
                    _notedc.CREDealID = Convert.ToString(dt.Rows[0]["CREDealID"]);
                    _notedc.IndexNameID = CommonHelper.ToInt32(dt.Rows[0]["IndexNameID"]);
                    _notedc.IndexNameText = Convert.ToString(dt.Rows[0]["IndexNameText"]);
                    _notedc.UseIndexOverrides = CommonHelper.ToBoolean(dt.Rows[0]["UseIndexOverrides"]);
                    _notedc.lastCalcDateTime = CommonHelper.ToDateTime(dt.Rows[0]["lastCalcDateTime"]);
                    _notedc.ServicerID = Convert.ToString(dt.Rows[0]["ServicerID"]);
                    _notedc.TotalCommitment = CommonHelper.ToDecimal(dt.Rows[0]["TotalCommitment"]);
                    _notedc.ClientName = Convert.ToString(dt.Rows[0]["ClientName"]);
                    _notedc.Portfolio = Convert.ToString(dt.Rows[0]["Portfolio"]);
                    _notedc.Tag1 = Convert.ToString(dt.Rows[0]["Tag1"]);
                    _notedc.Tag2 = Convert.ToString(dt.Rows[0]["Tag2"]);
                    _notedc.Tag3 = Convert.ToString(dt.Rows[0]["Tag3"]);
                    _notedc.Tag4 = Convert.ToString(dt.Rows[0]["Tag4"]);
                    _notedc.ExtendedMaturityCurrent = CommonHelper.ToDateTime(dt.Rows[0]["ExtendedMaturityCurrent"]);
                    _notedc.ActualPayoffDate = CommonHelper.ToDateTime(dt.Rows[0]["ActualPayoffDate"]);
                    _notedc.SelectedMaturityDateScenarioText = Convert.ToString(dt.Rows[0]["SelectedMaturityDateScenarioText"]);
                    _notedc.StatusCode = Convert.ToInt32(dt.Rows[0]["StatusCode"]);
                    _notedc.UnusedFeeThresholdBalance = CommonHelper.ToDecimal(dt.Rows[0]["UnusedFeeThresholdBalance"]);
                    _notedc.UnusedFeePaymentFrequency = CommonHelper.ToInt16_NotNullable(dt.Rows[0]["UnusedFeePaymentFrequency"]);
                    _notedc.TotalCommitmentExtensionFeeisBasedOn = CommonHelper.ToDecimal(dt.Rows[0]["TotalCommitmentExtensionFeeisBasedOn"]);
                    _notedc.UseRuletoDetermineNoteFunding = CommonHelper.ToInt32(dt.Rows[0]["UseRuletoDetermineNoteFunding"]);
                    _notedc.UseRuletoDetermineNoteFundingText = Convert.ToString(dt.Rows[0]["UseRuletoDetermineNoteFundingText"]);
                    _notedc.Servicer = CommonHelper.ToInt32(dt.Rows[0]["Servicer"]);
                    _notedc.ServicerText = Convert.ToString(dt.Rows[0]["ServicerText"]);
                    _notedc.FullInterestAtPPayoff = CommonHelper.ToInt32(dt.Rows[0]["FullInterestAtPPayoff"]);
                    _notedc.FullInterestAtPPayoffText = Convert.ToString(dt.Rows[0]["FullInterestAtPPayoffText"]);
                    _notedc.FFLastUpdatedDate_String = Convert.ToString(dt.Rows[0]["FFLastUpdatedDate_String"]);
                    _notedc.UpdatedByFF = Convert.ToString(dt.Rows[0]["UpdatedByFF"]);
                    _notedc.NoteRule = Convert.ToString(dt.Rows[0]["NoteRule"]);
                    _notedc.ClientID = CommonHelper.ToInt32(dt.Rows[0]["ClientID"]);
                    _notedc.FundID = CommonHelper.ToInt32(dt.Rows[0]["FundId"]);
                    _notedc.FinancingSourceID = CommonHelper.ToInt32(dt.Rows[0]["FinancingSourceID"]);
                    _notedc.DebtTypeID = CommonHelper.ToInt32(dt.Rows[0]["DebtTypeID"]);
                    _notedc.BillingNotesID = CommonHelper.ToInt32(dt.Rows[0]["BillingNotesID"]);
                    _notedc.CapStack = CommonHelper.ToInt32(dt.Rows[0]["CapStack"]);
                    _notedc.PoolID = CommonHelper.ToInt32(dt.Rows[0]["PoolID"]);
                    _notedc.MaturityScenarioOverrideText = Convert.ToString(dt.Rows[0]["MaturityScenarioOverrideText"]);
                    _notedc.AcctgCloseDate = CommonHelper.ToDateTime(dt.Rows[0]["AcctgCloseDate"]);
                    if (Convert.ToString(dt.Rows[0]["ScenarioID"]) != "")
                    {
                        _notedc.AnalysisID = new Guid(Convert.ToString(dt.Rows[0]["ScenarioID"]));
                    }
                    _notedc.CalculationModeID = CommonHelper.ToInt32(dt.Rows[0]["CalculationMode"]);
                    _notedc.CalculationModeText = Convert.ToString(dt.Rows[0]["CalculationModeText"]);
                    _notedc.StubInterestRateOverride = CommonHelper.ToDecimal(dt.Rows[0]["StubInterestRateOverride"]);
                    _notedc.LiborDataAsofDate = CommonHelper.ToDateTime(dt.Rows[0]["LiborDataAsofDate"]);
                    _notedc.ServicerNameID = CommonHelper.ToInt32(dt.Rows[0]["ServicerNameID"]);
                    _notedc.ServicerNameText = Convert.ToString(dt.Rows[0]["ServicerNameText"]);
                    _notedc.BusinessdaylafrelativetoPMTDate = CommonHelper.ToInt32(dt.Rows[0]["BusinessdaylafrelativetoPMTDate"]);
                    _notedc.DayoftheMonth = CommonHelper.ToInt32(dt.Rows[0]["DayoftheMonth"]);
                    _notedc.InterestCalculationRuleForPaydowns = CommonHelper.ToInt32(dt.Rows[0]["InterestCalculationRuleForPaydowns"]);
                    _notedc.InterestCalculationRuleForPaydownsText = Convert.ToString(dt.Rows[0]["InterestCalculationRuleForPaydownsText"]);
                    _notedc.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate = CommonHelper.ToInt32(dt.Rows[0]["PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate"]);
                    _notedc.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateText = Convert.ToString(dt.Rows[0]["PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateText"]);
                    _notedc.EnableDebug = Convert.ToBoolean(dt.Rows[0]["isAllowDebugInCalc"]);
                    _notedc.InterestCalculationRuleForPaydownsAmort = CommonHelper.ToInt32(dt.Rows[0]["InterestCalculationRuleForPaydownsAmort"]);
                    _notedc.InterestCalculationRuleForPaydownsAmortText = Convert.ToString(dt.Rows[0]["InterestCalculationRuleForPaydownsAmortText"]);
                    _notedc.RoundingNote = CommonHelper.ToInt32(dt.Rows[0]["RoundingNote"]);
                    _notedc.RoundingNoteText = Convert.ToString(dt.Rows[0]["RoundingNoteText"]);
                    _notedc.StraightLineAmortOverride = CommonHelper.ToDecimal(dt.Rows[0]["StraightLineAmortOverride"]);
                    _notedc.AdjustedTotalCommitment = CommonHelper.ToDecimal(dt.Rows[0]["AdjustedTotalCommitment"]);
                    _notedc.AggregatedTotal = CommonHelper.ToDecimal(dt.Rows[0]["AggregatedTotal"]);
                    _notedc.RepaymentDayoftheMonth = CommonHelper.ToInt32(dt.Rows[0]["RepaymentDayoftheMonth"]);
                    _notedc.CollectCalculatorLogs = CommonHelper.ToBoolean(dt.Rows[0]["CollectCalculatorLogs"]);
                    _notedc.OriginalTotalCommitment = CommonHelper.ToDecimal(dt.Rows[0]["OriginalTotalCommitment"]);
                    _notedc.MKT_PRICE = CommonHelper.ToDecimal(dt.Rows[0]["MKT_PRICE"]);
                    _notedc.StrategyCode = CommonHelper.ToInt32(dt.Rows[0]["StrategyCode"]);
                    _notedc.StrategyName = Convert.ToString(dt.Rows[0]["StrategyName"]);
                    _notedc.NoteTransferDate = CommonHelper.ToDateTime(dt.Rows[0]["NoteTransferDate"]);
                    _notedc.EnableM61Calculations = CommonHelper.ToInt32(dt.Rows[0]["EnableM61Calculations"]);
                    _notedc.InitialRequiredEquity = CommonHelper.ToDecimal(dt.Rows[0]["InitialRequiredEquity"]);
                    _notedc.InitialAdditionalEquity = CommonHelper.ToDecimal(dt.Rows[0]["InitialAdditionalEquity"]);
                    _notedc.OriginalCRENoteID = Convert.ToString(dt.Rows[0]["CRENoteID"]);
                    _notedc.OriginalNoteName = Convert.ToString(dt.Rows[0]["Name"]);
                    _notedc.AllowYieldConfigData = Convert.ToBoolean(dt.Rows[0]["AllowYieldConfigData"]);
                    ////_notedc.BalanceAware = Convert.ToBoolean(dt.Rows[0]["BalanceAware"]);
                    _notedc.OriginationFeePercentageRP = CommonHelper.ToDecimal(dt.Rows[0]["OriginationFeePercentageRP"]);
                    //_notedc.CalcByNewMaturitySetup = CommonHelper.ToBoolean(dt.Rows[0]["CalcByNewMaturitySetup"]);
                    //_notedc.ImpactCommitmentCalc = CommonHelper.ToInt32(dt.Rows[0]["ImpactCommitmentCalc"]);

                }

            }
            //  GetNoteAdditinalList(new Guid(noteID), userID);
            return _notedc;
        }

        public List<ClientDataContract> GetAllClients()
        {
            List<ClientDataContract> ClientDC = new List<ClientDataContract>();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetClient");

            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    ClientDataContract _clientdc = new ClientDataContract();
                    _clientdc.ClientID = Convert.ToInt32(dr["ClientID"]);
                    _clientdc.ClientName = Convert.ToString(dr["ClientName"]);

                    ClientDC.Add(_clientdc);
                }
            }
            return ClientDC;
        }

        public List<FundDataContract> GetAllFund()
        {
            List<FundDataContract> FundDC = new List<FundDataContract>();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetFund");

            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    FundDataContract _FundDC = new FundDataContract();
                    _FundDC.FundID = Convert.ToInt32(dr["FundID"]);
                    _FundDC.FundName = Convert.ToString(dr["FundName"]);
                    FundDC.Add(_FundDC);
                }
            }
            return FundDC;
        }



        public List<MaturityScenariosDataContract> GetMaturityPeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<MaturityScenariosDataContract> _maturityScenariosDataContractList = new List<MaturityScenariosDataContract>();
            List<MaturityDateList> _lstmaturity = new List<MaturityDateList>();
            DataTable dt = new DataTable();
            TotalCount = 0;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageIndex", Value = pageIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetMaturityPeriodicDataByNoteId", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    MaturityDateList maturitydate = new MaturityDateList();
                    maturitydate.MaturityDate = CommonHelper.ToDateTime(dr["MaturityDate"]);
                    maturitydate.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                    maturitydate.Type = Convert.ToString(dr["Type"]);
                    maturitydate.Approved = Convert.ToString(dr["Approved"]);
                    _lstmaturity.Add(maturitydate);
                }

                MaturityScenariosDataContract _maturityscenariodc = new MaturityScenariosDataContract();
                _maturityscenariodc.NoteID = CommonHelper.ToGuid(dt.Rows[0]["NoteID"]);
                _maturityscenariodc.MaturityDateList = _lstmaturity;
                _maturityscenariodc.ExpectedMaturityDate = CommonHelper.ToDateTime(dt.Rows[0]["ExpectedMaturityDate"]);
                _maturityscenariodc.ActualPayoffDate = CommonHelper.ToDateTime(dt.Rows[0]["ActualPayoffDate"]);
                _maturityscenariodc.OpenPrepaymentDate = CommonHelper.ToDateTime(dt.Rows[0]["OpenPrepaymentDate"]);
                _maturityScenariosDataContractList.Add(_maturityscenariodc);
                TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            }
            return _maturityScenariosDataContractList;
        }

        public List<RateSpreadSchedule> GetRateSpreadSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<RateSpreadSchedule> _rateSpreadScheduleList = new List<RateSpreadSchedule>();

            DataTable dt = new DataTable();
            TotalCount = 0;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetRateSpreadSchedulePeriodicDataByNoteId", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {

                foreach (DataRow dr in dt.Rows)
                {
                    _rateSpreadScheduleList.Add(new RateSpreadSchedule
                    {
                        EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveStartDate"]),
                        Date = CommonHelper.ToDateTime(dr["Date"]),
                        ValueTypeText = Convert.ToString(dr["ValueTypeText"]),
                        Value = CommonHelper.ToDecimal(dr["Value"]),
                        IntCalcMethodText = Convert.ToString(dr["IntCalcMethodText"]),
                        RateOrSpreadToBeStripped = CommonHelper.ToDecimal(dr["RateOrSpreadToBeStripped"]),
                        IndexNameText = Convert.ToString(dr["IndexNameText"])

                    });
                }

                TotalCount = Convert.ToInt32(p5.Value);
            }
            return _rateSpreadScheduleList;
        }

        public List<PrepayAndAdditionalFeeScheduleDataContract> GetPrepayAndAdditionalFeeScheduleDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<PrepayAndAdditionalFeeScheduleDataContract> _prepayAndAdditionalFeeScheduleDataContractList = new List<PrepayAndAdditionalFeeScheduleDataContract>();
            DataTable dt = new DataTable();
            TotalCount = 0;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetPrepayAndAdditionalFeeScheduleDataByNoteId", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {

                foreach (DataRow dr in dt.Rows)
                {
                    _prepayAndAdditionalFeeScheduleDataContractList.Add(new PrepayAndAdditionalFeeScheduleDataContract
                    {
                        EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveStartDate"]),
                        ScheduleStartDate = CommonHelper.ToDateTime(dr["StartDate"]),
                        Value = CommonHelper.ToDecimal(dr["Value"]),
                        ValueTypeText = Convert.ToString(dr["ValueTypeText"]),
                        IncludedLevelYield = CommonHelper.ToDecimal(dr["IncludedLevelYield"]),
                        IncludedBasis = CommonHelper.ToDecimal(dr["IncludedBasis"]),
                        ScheduleEndDate = CommonHelper.ToDateTime(dr["EndDate"]),
                        FeeName = Convert.ToString(dr["FeeName"]),
                        FeeAmountOverride = CommonHelper.ToDecimal(dr["FeeAmountOverride"]),
                        BaseAmountOverride = CommonHelper.ToDecimal(dr["BaseAmountOverride"]),
                        ApplyTrueUpFeatureID = CommonHelper.ToInt32(dr["ApplyTrueUpFeature"]),
                        ApplyTrueUpFeatureText = Convert.ToString(dr["ApplyTrueUpFeatureText"]),
                        PercentageOfFeeToBeStripped = CommonHelper.ToDecimal(dr["FeetobeStripped"])
                    });
                }

                TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            }
            return _prepayAndAdditionalFeeScheduleDataContractList;
        }

        public List<StrippingScheduleDataContract> GetStrippingSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<StrippingScheduleDataContract> _strippingScheduleDataContractList = new List<StrippingScheduleDataContract>();
            DataTable dt = new DataTable();
            TotalCount = 0;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetStrippingSchedulePeriodicDataByNoteId", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {

                foreach (DataRow dr in dt.Rows)
                {
                    _strippingScheduleDataContractList.Add(new StrippingScheduleDataContract
                    {
                        EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveStartDate"]),
                        StartDate = CommonHelper.ToDateTime(dr["StartDate"]),
                        Value = CommonHelper.ToDecimal(dr["Value"]),
                        ValueTypeText = Convert.ToString(dr["ValueTypeText"]),
                        IncludedLevelYield = CommonHelper.ToDecimal(dr["IncludedLevelYield"]),
                        IncludedBasis = CommonHelper.ToDecimal(dr["IncludedBasis"])
                    });
                }
                TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            }

            return _strippingScheduleDataContractList;
        }

        public List<FinancingFeeScheduleDataContract> GetFinancingFeeSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {

            List<FinancingFeeScheduleDataContract> _financingFeeScheduleDataContractList = new List<FinancingFeeScheduleDataContract>();
            DataTable dt = new DataTable();
            TotalCount = 0;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetFinancingFeeSchedulePeriodicDataByNoteId", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {

                foreach (DataRow dr in dt.Rows)
                {
                    _financingFeeScheduleDataContractList.Add(new FinancingFeeScheduleDataContract
                    {
                        EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveStartDate"]),
                        Date = CommonHelper.ToDateTime(dr["Date"]),
                        Value = Convert.ToDecimal(dr["Value"]),
                        ValueTypeText = Convert.ToString(dr["ValueTypeText"])
                    });
                }
                TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            }

            return _financingFeeScheduleDataContractList;
        }

        public List<FinancingScheduleDataContract> GetFinancingSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {

            List<FinancingScheduleDataContract> _financingScheduleDataContractList = new List<FinancingScheduleDataContract>();
            DataTable dt = new DataTable();
            TotalCount = 0;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetFinancingSchedulePeriodicDataByNoteId", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {

                foreach (DataRow dr in dt.Rows)
                {
                    _financingScheduleDataContractList.Add(new FinancingScheduleDataContract
                    {
                        EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveStartDate"]),
                        Date = CommonHelper.ToDateTime(dr["Date"]),
                        Value = CommonHelper.ToDecimal(dr["Value"]),
                        ValueTypeText = Convert.ToString(dr["ValueTypeText"]),
                        IndexTypeText = Convert.ToString(dr["IndexTypeText"]),
                        IntCalcMethodText = Convert.ToString(dr["IntCalcMethodText"]),
                        CurrencyCode = CommonHelper.ToInt32(dr["CurrencyCode"])
                    });
                }
                TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            }
            return _financingScheduleDataContractList;
        }

        public List<DefaultScheduleDataContract> GetDefaultSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<DefaultScheduleDataContract> _defaultScheduleDataContractList = new List<DefaultScheduleDataContract>();
            DataTable dt = new DataTable();
            TotalCount = 0;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetDefaultSchedulePeriodicDataByNoteId", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {

                foreach (DataRow dr in dt.Rows)
                {
                    _defaultScheduleDataContractList.Add(new DefaultScheduleDataContract
                    {
                        EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveStartDate"]),
                        StartDate = CommonHelper.ToDateTime(dr["StartDate"]),
                        EndDate = CommonHelper.ToDateTime(dr["EndDate"]),
                        Value = CommonHelper.ToDecimal(dr["Value"]),
                        ValueTypeText = Convert.ToString(dr["ValueTypeText"])
                    });
                }
                TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            }
            return _defaultScheduleDataContractList;
        }

        public List<NoteServicingFeeScheduleDataContract> GetServicingFeeSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {

            List<NoteServicingFeeScheduleDataContract> _noteServicingFeeScheduleDataContractList = new List<NoteServicingFeeScheduleDataContract>();
            DataTable dt = new DataTable();
            TotalCount = 0;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetServicingFeeSchedulePeriodicDataByNoteId", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {

                foreach (DataRow dr in dt.Rows)
                {
                    _noteServicingFeeScheduleDataContractList.Add(new NoteServicingFeeScheduleDataContract
                    {
                        EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveStartDate"]),
                        Date = CommonHelper.ToDateTime(dr["Date"]),
                        IsCapitalized = CommonHelper.ToInt32(dr["IsCapitalized"]),
                        Value = CommonHelper.ToDecimal(dr["Value"])
                    });
                }
                TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            }

            return _noteServicingFeeScheduleDataContractList;
        }

        public List<PIKSchedule> GetPIKSchedulePeriodicDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<PIKSchedule> _pIKScheduleList = new List<PIKSchedule>();
            DataTable dt = new DataTable();
            TotalCount = 0;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetPIKSchedulePeriodicDataByNoteId", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {

                foreach (DataRow dr in dt.Rows)
                {
                    _pIKScheduleList.Add(new PIKSchedule
                    {
                        EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveStartDate"]),

                        PIKScheduleID = CommonHelper.ToGuid(Convert.ToString(dr["PIKScheduleID"])),
                        TargateNoteID = CommonHelper.ToGuid(Convert.ToString(dr["TargateNoteID"])),
                        EventId = CommonHelper.ToGuid(Convert.ToString(dr["EventId"])),
                        NoteID = CommonHelper.ToGuid(Convert.ToString(dr["NoteID"])),
                        SourceAccountID = CommonHelper.ToGuid(Convert.ToString(dr["SourceAccountID"])),
                        TargetAccountID = CommonHelper.ToGuid(Convert.ToString(dr["TargetAccountID"])),

                        AdditionalIntRate = CommonHelper.ToDecimal(dr["AdditionalIntRate"]),
                        AdditionalSpread = CommonHelper.ToDecimal(dr["AdditionalSpread"]),
                        IndexFloor = CommonHelper.ToDecimal(dr["IndexFloor"]),
                        IntCompoundingRate = CommonHelper.ToDecimal(dr["IntCompoundingRate"]),
                        IntCompoundingSpread = CommonHelper.ToDecimal(dr["IntCompoundingSpread"]),
                        StartDate = CommonHelper.ToDateTime(dr["StartDate"]),
                        EndDate = CommonHelper.ToDateTime(dr["EndDate"]),
                        IntCapAmt = CommonHelper.ToDecimal(dr["IntCapAmt"]),
                        PurBal = CommonHelper.ToDecimal(dr["PurBal"]),
                        AccCapBal = CommonHelper.ToDecimal(dr["AccCapBal"]),
                        PIKReasonCodeID = CommonHelper.ToInt32(dr["PIKReasonCodeID"]),
                        PIKReasonCodeIDtext = dr["PIKReasonCodeText"].ToString(),

                        PIKIntCalcMethodID = CommonHelper.ToInt32(dr["PIKIntCalcMethodID"]),
                        PIKIntCalcMethodIDText = dr["PIKIntCalcMethodIDText"].ToString(),

                        PIKComments = dr["PIKComments"].ToString()
                    });
                }
                TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            }
            return _pIKScheduleList;
        }

        public NoteAdditinalListDataContract GetNoteAdditinalList(Guid? noteId, Guid? userID)
        {
            try
            {
                //DefaultSchedule 6
                //FeeCouponSchedule 7
                //FinancingFeeSchedule 8
                //FinancingSchedule 9
                //Maturity 11
                // PIKSchedule 12
                //PrepayAndAdditionalFeeSchedule 13
                //RateSpreadSchedule 14
                //ServicingFeeSchedule 15
                //StrippingSchedule 16
                //PIKScheduleDetail 17
                //LIBORSchedule 18
                NoteAdditinalListDataContract _noteAdd = new NoteAdditinalListDataContract();

                //  List<NotePrepayAndAdditionalFeeSchedule> _NotePrepayAndAdditionalFeeScheduleList = new List<NotePrepayAndAdditionalFeeSchedule>();

                DataTable dt = new DataTable();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = noteId };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetNoteAdditionalRecordbyNoteId", sqlparam);


                //var res = dbContext.usp_GetNoteAdditionalRecordbyNoteId(noteId, userID).ToList();

                var resMat = dt.Select("ModuleId = 11");
                if (resMat.Length > 0)
                {
                    DataTable resMaturity = dt.Select("ModuleId = 11").CopyToDataTable();

                    // var resMaturity = res.Where(x => x.ModuleId == 11).FirstOrDefault();//Maturity

                    if (resMaturity != null && resMaturity.Rows.Count > 0)
                    {
                        List<MaturityScenariosDataContract> lstmat = new List<MaturityScenariosDataContract>();
                        foreach (DataRow dr in resMaturity.Rows)
                        {
                            MaturityScenariosDataContract _maturity = new MaturityScenariosDataContract();
                            _maturity.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                            _maturity.Date = CommonHelper.ToDateTime(dr["Date"]);
                            //   _maturity.MaturityID = resMaturity.ScheduleID.ToString();
                            _maturity.ModuleId = CommonHelper.ToInt32(dr["ModuleId"]);
                            if (Convert.ToString(dr["EventId"]) != "")
                            {
                                _maturity.EventId = new Guid(Convert.ToString(dr["EventId"]));
                            }
                            _maturity.ScheduleID = Convert.ToString(dr["ScheduleID"]);
                            lstmat.Add(_maturity);
                        }
                        _noteAdd.MaturityScenariosList = lstmat;
                    }
                    else
                    {
                        List<MaturityScenariosDataContract> lstmat = new List<MaturityScenariosDataContract>();
                        MaturityScenariosDataContract _maturity = new MaturityScenariosDataContract();
                        _maturity.ModuleId = 11;
                        lstmat.Add(_maturity);
                        _noteAdd.MaturityScenariosList = lstmat;
                    }
                }
                else
                {
                    List<MaturityScenariosDataContract> lstmat = new List<MaturityScenariosDataContract>();
                    MaturityScenariosDataContract _maturity = new MaturityScenariosDataContract();
                    _maturity.ModuleId = 11;
                    lstmat.Add(_maturity);
                    _noteAdd.MaturityScenariosList = lstmat;
                }

                var resRat = dt.Select("ModuleId = 14");
                if (resRat.Length > 0)
                {
                    DataTable resRateSpreadSch = dt.Select("ModuleId = 14").CopyToDataTable();
                    // var resRateSpreadSch = res.Where(x => x.ModuleId == 14);//RateSpreadSchedule
                    //_noteAdd.RateSpreadScheduleList = (from rss in resRateSpreadSch
                    //                                   select new RateSpreadSchedule()
                    //                                   {
                    // RateSpreadScheduleID = rss.ScheduleID,
                    List<RateSpreadSchedule> RateSpl = new List<RateSpreadSchedule>();
                    foreach (DataRow dr in resRateSpreadSch.Rows)
                    {
                        RateSpreadSchedule rss = new RateSpreadSchedule();
                        if (Convert.ToString(dr["EventId"]) != "")
                        {
                            rss.EventId = new Guid(Convert.ToString(dr["EventId"]));
                        }
                        rss.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                        rss.Date = CommonHelper.ToDateTime(dr["Date"]);
                        rss.ValueTypeID = CommonHelper.ToInt32(dr["ValueTypeID"]);
                        rss.ValueTypeText = Convert.ToString(dr["ValueTypeText"]);
                        rss.Value = CommonHelper.ToDecimal(dr["Value"]);
                        rss.IntCalcMethodID = CommonHelper.ToInt32(dr["IntCalcMethodID"]);
                        rss.IntCalcMethodText = Convert.ToString(dr["IntCalcMethodText"]);
                        rss.ModuleId = CommonHelper.ToInt32(dr["ModuleId"]);
                        rss.ScheduleID = Convert.ToString(dr["ScheduleID"]);
                        rss.RateOrSpreadToBeStripped = CommonHelper.ToDecimal(dr["FeetobeStripped"]);
                        rss.IndexNameID = CommonHelper.ToInt32(dr["IndexNameID"]);
                        rss.IndexNameText = Convert.ToString(dr["IndexNameText"]);
                        RateSpl.Add(rss);

                    }
                    _noteAdd.RateSpreadScheduleList = RateSpl;
                }

                var respre = dt.Select("ModuleId = 13");
                if (respre.Length > 0)
                {
                    DataTable resPrepay = dt.Select("ModuleId = 13").CopyToDataTable();
                    // var resPrepay = res.Where(x => x.ModuleId == 13);//PrepayAndAdditionalFeeSchedule
                    //_noteAdd.NotePrepayAndAdditionalFeeScheduleList = (from ppf in resPrepay
                    //                                                   select new PrepayAndAdditionalFeeScheduleDataContract()
                    //                                                   {
                    //   PrepayAndAdditionalFeeScheduleID = ppf.ScheduleID,
                    List<PrepayAndAdditionalFeeScheduleDataContract> NotePrepaylst = new List<PrepayAndAdditionalFeeScheduleDataContract>();
                    foreach (DataRow dr in resPrepay.Rows)
                    {
                        PrepayAndAdditionalFeeScheduleDataContract ppf = new PrepayAndAdditionalFeeScheduleDataContract();
                        if (Convert.ToString(dr["EventId"]) != "")
                        {
                            ppf.EventId = new Guid(Convert.ToString(dr["EventId"]));
                        }
                        ppf.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                        ppf.ScheduleStartDate = CommonHelper.ToDateTime(dr["Date"]);
                        ppf.ValueTypeID = CommonHelper.ToInt32(dr["ValueTypeID"]);
                        ppf.ValueTypeText = Convert.ToString(dr["ValueTypeText"]);
                        ppf.Value = CommonHelper.ToDecimal(dr["Value"]);
                        ppf.IncludedLevelYield = CommonHelper.ToDecimal(dr["IncludedLevelYield"]);
                        ppf.IncludedBasis = CommonHelper.ToDecimal(dr["IncludedBasis"]);
                        ppf.ModuleId = CommonHelper.ToInt32(dr["ModuleId"]);
                        ppf.ScheduleID = Convert.ToString(dr["ScheduleID"]);
                        ppf.StartDate = CommonHelper.ToDateTime(dr["Date"]);
                        ppf.FeeName = Convert.ToString(dr["FeeName"]);
                        ppf.ScheduleEndDate = CommonHelper.ToDateTime(dr["EndDate"]);
                        ppf.FeeAmountOverride = CommonHelper.ToDecimal(dr["FeeAmountOverride"]);
                        ppf.BaseAmountOverride = CommonHelper.ToDecimal(dr["BaseAmountOverride"]);
                        ppf.ApplyTrueUpFeatureID = CommonHelper.ToInt32(dr["ApplyTrueUpFeature"]);
                        ppf.ApplyTrueUpFeatureText = Convert.ToString(dr["ApplyTrueUpFeatureText"]);
                        ppf.PercentageOfFeeToBeStripped = CommonHelper.ToDecimal(dr["FeetobeStripped"]);

                        NotePrepaylst.Add(ppf);

                    }
                    _noteAdd.NotePrepayAndAdditionalFeeScheduleList = NotePrepaylst;
                }

                var resstrp = dt.Select("ModuleId = 16");
                if (resstrp.Length > 0)
                {
                    DataTable resStripping = dt.Select("ModuleId = 16").CopyToDataTable();

                    //  DataTable resStripping = dt.Select("ModuleId = 16").CopyToDataTable();
                    List<StrippingScheduleDataContract> NoteStrip = new List<StrippingScheduleDataContract>();
                    // var resStripping = res.Where(x => x.ModuleId == 16);
                    //_noteAdd.NoteStrippingList = (from stp in resStripping.ToList()
                    //                              select new StrippingScheduleDataContract()
                    //                              {
                    //                                  //StrippingScheduleID = stp.ScheduleID,
                    foreach (DataRow dr in resStripping.Rows)
                    {
                        StrippingScheduleDataContract stp = new StrippingScheduleDataContract();
                        if (Convert.ToString(dr["EventId"]) != "")
                        {
                            stp.EventId = new Guid(Convert.ToString(dr["EventId"]));
                        }
                        stp.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                        stp.StartDate = CommonHelper.ToDateTime(dr["Date"]);
                        stp.ValueTypeID = CommonHelper.ToInt32(dr["ValueTypeID"]);
                        stp.ValueTypeText = Convert.ToString(dr["ValueTypeText"]);
                        stp.Value = CommonHelper.ToDecimal(dr["Value"]);
                        stp.IncludedLevelYield = CommonHelper.ToDecimal(dr["IncludedLevelYield"]);
                        stp.IncludedBasis = CommonHelper.ToDecimal(dr["IncludedBasis"]);
                        stp.ModuleId = CommonHelper.ToInt32(dr["ModuleId"]);
                        stp.ScheduleID = Convert.ToString(dr["ScheduleID"]);

                        NoteStrip.Add(stp);
                    }
                    _noteAdd.NoteStrippingList = NoteStrip;
                }

                var resfin = dt.Select("ModuleId = 8");
                if (resfin.Length > 0)
                {
                    DataTable resFinFeeSch = dt.Select("ModuleId = 8").CopyToDataTable();
                    List<FinancingFeeScheduleDataContract> lstFinancingFee = new List<FinancingFeeScheduleDataContract>();
                    // var resFinFeeSch = res.Where(x => x.ModuleId == 8);//FinancingFeeSchedule
                    //_noteAdd.lstFinancingFeeSchedule = (from ffs in resFinFeeSch
                    //                                    select new FinancingFeeScheduleDataContract()
                    //                                    {
                    foreach (DataRow dr in resFinFeeSch.Rows)
                    {
                        FinancingFeeScheduleDataContract ffs = new FinancingFeeScheduleDataContract();
                        if (Convert.ToString(dr["ScheduleID"]) != "")
                        {
                            ffs.FinancingFeeScheduleID = new Guid(Convert.ToString(dr["ScheduleID"]));
                        }
                        if (Convert.ToString(dr["EventId"]) != "")
                        {
                            ffs.EventId = new Guid(Convert.ToString(dr["EventId"]));
                        }
                        ffs.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                        ffs.Date = CommonHelper.ToDateTime(dr["Date"]);
                        ffs.ValueTypeID = CommonHelper.ToInt32(dr["ValueTypeID"]);
                        ffs.ValueTypeText = Convert.ToString(dr["ValueTypeText"]);
                        ffs.Value = Convert.ToDecimal(dr["Value"]);
                        ffs.ModuleId = CommonHelper.ToInt32(dr["ModuleId"]);
                        ffs.ScheduleID = Convert.ToString(dr["ScheduleID"]);
                        lstFinancingFee.Add(ffs);
                    }
                    _noteAdd.lstFinancingFeeSchedule = lstFinancingFee;
                }
                else
                {
                    List<FinancingFeeScheduleDataContract> _lstfinancingfeeschedule = new List<FinancingFeeScheduleDataContract>();
                    FinancingFeeScheduleDataContract _financingfeeschedule = new FinancingFeeScheduleDataContract();
                    _financingfeeschedule.ModuleId = 8;
                    _lstfinancingfeeschedule.Add(_financingfeeschedule);
                    _noteAdd.lstFinancingFeeSchedule = _lstfinancingfeeschedule;
                }
                var resfun = dt.Select("ModuleId = 9");
                if (resfun.Length > 0)
                {
                    DataTable resFundingSch = dt.Select("ModuleId = 9").CopyToDataTable();
                    List<FinancingScheduleDataContract> NoteFinancing = new List<FinancingScheduleDataContract>();
                    // var resFundingSch = res.Where(x => x.ModuleId == 9);//FundingSchedule
                    //_noteAdd.NoteFinancingScheduleList = (from fsd in resFundingSch
                    //                                      select new FinancingScheduleDataContract()
                    //                                      {
                    foreach (DataRow dr in resFundingSch.Rows)
                    {
                        FinancingScheduleDataContract fsd = new FinancingScheduleDataContract();
                        if (Convert.ToString(dr["ScheduleID"]) != "")
                        {
                            fsd.FinancingScheduleID = new Guid(Convert.ToString(dr["ScheduleID"]));
                        }
                        if (Convert.ToString(dr["EventId"]) != "")
                        {
                            fsd.EventId = new Guid(Convert.ToString(dr["EventId"]));
                        }
                        fsd.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                        fsd.Date = CommonHelper.ToDateTime(dr["Date"]);
                        fsd.ValueTypeID = CommonHelper.ToInt32(dr["ValueTypeID"]);
                        fsd.ValueTypeText = Convert.ToString(dr["ValueTypeText"]);
                        fsd.Value = CommonHelper.ToDecimal(dr["Value"]);
                        fsd.IntCalcMethodID = CommonHelper.ToInt32(dr["IntCalcMethodID"]);
                        fsd.IntCalcMethodText = Convert.ToString(dr["IntCalcMethodText"]);
                        fsd.CurrencyCode = CommonHelper.ToInt32(dr["CurrencyCode"]);
                        fsd.CurrencyCodeText = Convert.ToString(dr["CurrencyCodeText"]);
                        fsd.IndexTypeID = CommonHelper.ToInt32(dr["IndexTypeID"]);
                        fsd.IndexTypeText = Convert.ToString(dr["IndexTypeText"]);
                        fsd.ModuleId = CommonHelper.ToInt32(dr["ModuleId"]);
                        fsd.ScheduleID = Convert.ToString(dr["ScheduleID"]);
                        NoteFinancing.Add(fsd);
                    }
                    _noteAdd.NoteFinancingScheduleList = NoteFinancing;
                }
                else
                {
                    List<FinancingScheduleDataContract> lstfinancingschedule = new List<FinancingScheduleDataContract>();
                    FinancingScheduleDataContract _financingschedule = new FinancingScheduleDataContract();
                    _financingschedule.ModuleId = 9;
                    lstfinancingschedule.Add(_financingschedule);
                    _noteAdd.NoteFinancingScheduleList = lstfinancingschedule;
                }

                var resdef = dt.Select("ModuleId = 6");
                if (resdef.Length > 0)
                {
                    DataTable resDefaultSch = dt.Select("ModuleId = 6").CopyToDataTable();
                    List<DefaultScheduleDataContract> NoteDefault = new List<DefaultScheduleDataContract>();

                    foreach (DataRow dr in resDefaultSch.Rows)
                    {
                        DefaultScheduleDataContract def = new DefaultScheduleDataContract();
                        if (Convert.ToString(dr["EventId"]) != "")
                        {
                            def.EventId = new Guid(Convert.ToString(dr["EventId"]));
                        }
                        def.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                        def.StartDate = CommonHelper.ToDateTime(dr["Date"]);
                        def.EndDate = CommonHelper.ToDateTime(dr["EndDate"]);
                        def.ValueTypeID = CommonHelper.ToInt32(dr["ValueTypeID"]);
                        def.ValueTypeText = Convert.ToString(dr["ValueTypeText"]);
                        def.Value = CommonHelper.ToDecimal(dr["Value"]);
                        def.ModuleId = CommonHelper.ToInt32(dr["ModuleId"]);
                        def.ScheduleID = Convert.ToString(dr["ScheduleID"]);
                        NoteDefault.Add(def);
                    }
                    _noteAdd.NoteDefaultScheduleList = NoteDefault;
                }
                else
                {
                    List<DefaultScheduleDataContract> lstdefault = new List<DefaultScheduleDataContract>();
                    DefaultScheduleDataContract _defaultschedule = new DefaultScheduleDataContract();
                    _defaultschedule.ModuleId = 6;
                    lstdefault.Add(_defaultschedule);
                    _noteAdd.NoteDefaultScheduleList = lstdefault;
                }
                var respik = dt.Select("ModuleId = 12");
                if (respik.Length > 0)
                {
                    DataTable resPIKSchedule = dt.Select("ModuleId = 12").CopyToDataTable();

                    // var resPIKSchedule = res.Where(x => x.ModuleId == 12).FirstOrDefault();//PIKSchedule

                    if (resPIKSchedule != null)
                    {
                        List<PIKSchedule> NotePIKScheduleList = new List<PIKSchedule>();
                        foreach (DataRow dr in resPIKSchedule.Rows)
                        {
                            PIKSchedule _PIKSchedule = new PIKSchedule();
                            _PIKSchedule.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                            _PIKSchedule.StartDate = CommonHelper.ToDateTime(dr["StartDate"]);
                            _PIKSchedule.EndDate = CommonHelper.ToDateTime(dr["EndDate"]);
                            if (Convert.ToString(dr["SourceAccountID"]) != "")
                            {
                                _PIKSchedule.SourceAccountID = new Guid(Convert.ToString(dr["SourceAccountID"]));
                            }

                            _PIKSchedule.SourceAccount = Convert.ToString(dr["SourceAccountText"]);
                            if (Convert.ToString(dr["TargetAccountID"]) != "")
                            {
                                _PIKSchedule.TargetAccountID = new Guid(Convert.ToString(dr["TargetAccountID"]));
                            }
                            _PIKSchedule.TargetAccount = Convert.ToString(dr["TargetAccountText"]);
                            _PIKSchedule.AdditionalIntRate = CommonHelper.ToDecimal(dr["AdditionalIntRate"]);
                            _PIKSchedule.AdditionalSpread = CommonHelper.ToDecimal(dr["AdditionalSpread"]);
                            _PIKSchedule.IndexFloor = CommonHelper.ToDecimal(dr["IndexFloor"]);
                            _PIKSchedule.IntCompoundingRate = CommonHelper.ToDecimal(dr["IntCompoundingRate"]);
                            _PIKSchedule.IntCompoundingSpread = CommonHelper.ToDecimal(dr["IntCompoundingSpread"]);
                            _PIKSchedule.IntCapAmt = CommonHelper.ToDecimal(dr["IntCapAmt"]);
                            _PIKSchedule.PurBal = CommonHelper.ToDecimal(dr["PurBal"]);
                            _PIKSchedule.AccCapBal = CommonHelper.ToDecimal(dr["AccCapBal"]);
                            _PIKSchedule.PIKReasonCodeID = CommonHelper.ToInt32(dr["PIKReasonCodeID"]);

                            _PIKSchedule.PIKIntCalcMethodID = CommonHelper.ToInt32(dr["PIKIntCalcMethodID"]);
                            _PIKSchedule.PIKIntCalcMethodIDText = (dr["PIKIntCalcMethodIDText"]).ToString();
                            _PIKSchedule.PIKComments = dr["PIKComments"].ToString();

                            if (Convert.ToString(dr["EventId"]) != "")
                            {
                                _PIKSchedule.EventId = new Guid(Convert.ToString(dr["EventId"]));
                            }
                            _PIKSchedule.ScheduleID = Convert.ToString(dr["ScheduleID"]);

                            NotePIKScheduleList.Add(_PIKSchedule);
                        }
                        _noteAdd.NotePIKScheduleList = NotePIKScheduleList;
                    }
                    else
                    {
                        List<PIKSchedule> NotePIKScheduleList = new List<PIKSchedule>();
                        PIKSchedule _PIKSchedule = new PIKSchedule();
                        _PIKSchedule.ModuleId = 12;
                        NotePIKScheduleList.Add(_PIKSchedule);
                        _noteAdd.NotePIKScheduleList = NotePIKScheduleList;
                    }
                }
                else
                {
                    List<PIKSchedule> NotePIKScheduleList = new List<PIKSchedule>();
                    PIKSchedule _PIKSchedule = new PIKSchedule();
                    _PIKSchedule.ModuleId = 12;
                    NotePIKScheduleList.Add(_PIKSchedule);
                    _noteAdd.NotePIKScheduleList = NotePIKScheduleList;
                }
                //  NoteServicingFeeScheduleDataContract

                var resservic = dt.Select("ModuleId = 15");
                if (resservic.Length > 0)
                {
                    DataTable resServicingFee = dt.Select("ModuleId = 15").CopyToDataTable();

                    // var resServicingFee = res.Where(x => x.ModuleId == 15).FirstOrDefault();//ServicingFeeSchedule
                    if (resServicingFee != null)
                    {
                        List<NoteServicingFeeScheduleDataContract> lstServicingFeeSch = new List<NoteServicingFeeScheduleDataContract>();
                        foreach (DataRow dr in resServicingFee.Rows)
                        {
                            NoteServicingFeeScheduleDataContract _ServicingFee = new NoteServicingFeeScheduleDataContract();
                            _ServicingFee.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                            _ServicingFee.Date = CommonHelper.ToDateTime(dr["Date"]);
                            _ServicingFee.Value = CommonHelper.ToDecimal(dr["Value"]);
                            _ServicingFee.IsCapitalized = CommonHelper.ToInt32(dr["IsCapitalized"]);
                            if (Convert.ToString(dr["EventId"]) != "")
                            {
                                _ServicingFee.EventId = new Guid(Convert.ToString(dr["EventId"]));
                            }

                            _ServicingFee.ModuleId = CommonHelper.ToInt32(dr["ModuleId"]);
                            _ServicingFee.ScheduleID = Convert.ToString(dr["ScheduleID"]);
                            lstServicingFeeSch.Add(_ServicingFee);
                        }
                        _noteAdd.NoteServicingFeeScheduleList = lstServicingFeeSch;
                    }
                    else
                    {
                        List<NoteServicingFeeScheduleDataContract> lstServicingFeeSch = new List<NoteServicingFeeScheduleDataContract>();
                        NoteServicingFeeScheduleDataContract _ServicingFee = new NoteServicingFeeScheduleDataContract();
                        _ServicingFee.ModuleId = 15;
                        lstServicingFeeSch.Add(_ServicingFee);
                        _noteAdd.NoteServicingFeeScheduleList = lstServicingFeeSch;
                    }
                }
                else
                {
                    List<NoteServicingFeeScheduleDataContract> lstServicingFeeSch = new List<NoteServicingFeeScheduleDataContract>();
                    NoteServicingFeeScheduleDataContract _ServicingFee = new NoteServicingFeeScheduleDataContract();
                    _ServicingFee.ModuleId = 15;
                    lstServicingFeeSch.Add(_ServicingFee);
                    _noteAdd.NoteServicingFeeScheduleList = lstServicingFeeSch;
                }
                // DataTable resServicingFee = dt.Select("ModuleId = 15").CopyToDataTable();

                Helper.Helper hpl1 = new Helper.Helper();
                DataTable dtn = new DataTable();
                SqlParameter hp1 = new SqlParameter { ParameterName = "@NoteID", Value = noteId };
                SqlParameter[] sqlparamhp1 = new SqlParameter[] { hp1 };
                dtn = hpl1.ExecDataTable("dbo.usp_NoteTransactionDetailByNoteId", sqlparamhp1);
                // var lstNoteTransactionDetails = dbContext.NoteTransactionDetails.Where(x => x.NoteID == noteId).ToList();
                _noteAdd.lstNoteServicingLog = new List<NoteServicingLogDataContract>();

                foreach (DataRow dr in dtn.Rows)
                {
                    NoteServicingLogDataContract ServicingLog = new NoteServicingLogDataContract();
                    if (Convert.ToString(dr["NoteID"]) != "")
                    {
                        ServicingLog.NoteId = new Guid(Convert.ToString(dr["NoteID"]));
                    }
                    if (Convert.ToString(dr["NoteTransactionDetailID"]) != "")
                    {
                        ServicingLog.TransactionId = new Guid(Convert.ToString(dr["NoteTransactionDetailID"]));
                    }
                    ServicingLog.row_num = Convert.ToInt32(dr["row_num"]);
                    ServicingLog.TransactionDate = CommonHelper.ToDateTime(dr["TransactionDate"]);
                    ServicingLog.TransactionAmount = CommonHelper.ToDecimal(dr["Amount"]);
                    ServicingLog.TransactionType = CommonHelper.ToInt32(dr["TransactionType"]);
                    ServicingLog.TransactionTypeText = Convert.ToString(dr["TransactionTypeText"]);
                    ServicingLog.RelatedtoModeledPMTDate = CommonHelper.ToDateTime(dr["RelatedtoModeledPMTDate"]);
                    ServicingLog.ModeledPayment = CommonHelper.ToDecimal(dr["ModeledPayment"]);
                    ServicingLog.AmountOutstandingafterCurrentPayment = CommonHelper.ToDecimal(dr["AmountOutstandingafterCurrentPayment"]);
                    ServicingLog.ServicingAmount = CommonHelper.ToDecimal(dr["ServicingAmount"]);
                    ServicingLog.CalculatedAmount = CommonHelper.ToDecimal(dr["CalculatedAmount"]);
                    ServicingLog.Delta = CommonHelper.ToDecimal(dr["Delta"]);
                    ServicingLog.M61Value = CommonHelper.ToBoolean(dr["M61Value"]);
                    ServicingLog.ServicerValue = CommonHelper.ToBoolean(dr["ServicerValue"]);
                    ServicingLog.Ignore = CommonHelper.ToBoolean(dr["Ignore"]);
                    ServicingLog.OverrideValue = CommonHelper.ToDecimal(dr["OverrideValue"]);
                    ServicingLog.comments = Convert.ToString(dr["comments"]);
                    ServicingLog.ServicerMasterID = CommonHelper.ToInt32(dr["ServicerMasterID"]);
                    ServicingLog.SourceType = Convert.ToString(dr["ServicerName"]);
                    ServicingLog.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    ServicingLog.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    ServicingLog.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    ServicingLog.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    ServicingLog.Exception = Convert.ToString(dr["Exception"]);
                    ServicingLog.Adjustment = CommonHelper.ToDecimal(dr["Adjustment"]);
                    ServicingLog.ActualDelta = CommonHelper.ToDecimal(dr["ActualDelta"]);
                    ServicingLog.InterestAdj = CommonHelper.ToDecimal(dr["InterestAdj"]);
                    ServicingLog.AddlInterest = CommonHelper.ToDecimal(dr["AddlInterest"]);
                    ServicingLog.TotalInterest = CommonHelper.ToDecimal(dr["TotalInterest"]);
                    ServicingLog.Status_ValueUsedInCalc = "";
                    if (ServicingLog.OverrideValue != 0) ServicingLog.Status_ValueUsedInCalc = "Override";
                    if (ServicingLog.M61Value == true) ServicingLog.Status_ValueUsedInCalc = "M61";
                    if (ServicingLog.ServicerValue == true) ServicingLog.Status_ValueUsedInCalc = "Servicer";
                    if (ServicingLog.Ignore == true) ServicingLog.Status_ValueUsedInCalc = "Override";

                    if (ServicingLog.OverrideValue == 0 && ServicingLog.M61Value == false && ServicingLog.ServicerValue == false && ServicingLog.Ignore == false) ServicingLog.Status_ValueUsedInCalc = "M61";


                    ServicingLog.RemittanceDate = CommonHelper.ToDateTime(dr["RemittanceDate"]);
                    ServicingLog.OverrideReason = CommonHelper.ToInt32(dr["OverrideReason"]);
                    ServicingLog.OverrideReasonText = Convert.ToString(dr["OverrideReasonText"]);
                    ServicingLog.Calculated = CommonHelper.ToInt32(dr["Calculated"]);
                    ServicingLog.AllowCalculationOverride = CommonHelper.ToInt32(dr["AllowCalculationOverride"]);
                    ServicingLog.TransactionEntryAmount = CommonHelper.ToDecimal(dr["TransactionEntryAmount"]);
                    ServicingLog.Final_ValueUsedInCalc = null;
                    if (ServicingLog.M61Value == false && ServicingLog.ServicerValue == false) ServicingLog.Final_ValueUsedInCalc = ServicingLog.OverrideValue;
                    if (ServicingLog.M61Value == true) ServicingLog.Final_ValueUsedInCalc = ServicingLog.CalculatedAmount;
                    if (ServicingLog.ServicerValue == true) ServicingLog.Final_ValueUsedInCalc = ServicingLog.ServicingAmount;
                    //  if (ServicingLog.Ignore == true) ServicingLog.Final_ValueUsedInCalc = ServicingLog.OverrideValue;
                    // if (ServicingLog.OverrideValue == 0 && ServicingLog.M61Value == false && ServicingLog.ServicerValue == false && ServicingLog.Ignore == false) ServicingLog.Final_ValueUsedInCalc = ServicingLog.CalculatedAmount;

                    _noteAdd.lstNoteServicingLog.Add(ServicingLog);
                }

                if (_noteAdd.lstNoteServicingLog != null)
                    _noteAdd.lstNoteServicingLog = _noteAdd.lstNoteServicingLog.OrderBy(x => x.RelatedtoModeledPMTDate).OrderBy(x => x.TransactionDate).ToList();
                _noteAdd.lstServicerDropDateSetup = GetServicerDropDateSetupByNoteId(noteId, userID.ToString());
                return _noteAdd;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        public List<EffectiveDateList> GetEffectiveDateListDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                List<EffectiveDateList> _effectiveDateDataContractList = new List<EffectiveDateList>();
                DataTable dt = new DataTable();
                TotalCount = 0;
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@PageIndex", Value = pageIndex };
                SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
                SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
                dt = hp.ExecDataTable("dbo.usp_GetEffectiveDateDataByNoteId", sqlparam);
                if (dt != null && dt.Rows.Count > 0)
                {

                    foreach (DataRow dr in dt.Rows)
                    {
                        _effectiveDateDataContractList.Add(new EffectiveDateList
                        {
                            EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]),
                            Type = Convert.ToString(dr["EventTypeText"])

                        });
                    }
                    TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
                }

                return _effectiveDateDataContractList;
            }
            catch (Exception ex)
            {

                throw;
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
        }

        public List<FutureFundingScheduleTab> GetFutureFundingScheduleTabListDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<FutureFundingScheduleTab> _futureFundingScheduleTabList = new List<FutureFundingScheduleTab>();
            try
            {

                DataTable dt = new DataTable();
                TotalCount = 0;
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@PageIndex", Value = pageIndex };
                SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
                SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
                dt = hp.ExecDataTable("dbo.usp_GetFutureFundingScheduleDataByNoteId", sqlparam);
                if (dt != null && dt.Rows.Count > 0)
                {

                    foreach (DataRow dr in dt.Rows)
                    {
                        _futureFundingScheduleTabList.Add(new FutureFundingScheduleTab
                        {
                            EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]),
                            Date = CommonHelper.ToDateTime(dr["Date"]),
                            Value = CommonHelper.ToDecimal(dr["Value"]),
                            PurposeID = CommonHelper.ToInt32(dr["PurposeID"]),
                            PurposeText = Convert.ToString(dr["PurposeText"]),
                        });
                    }
                    TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
                }

                return _futureFundingScheduleTabList;
            }
            catch (Exception ex)
            {
                throw new Exception("error in GetFutureFundingScheduleTabListDataByNoteId-noterepository" + ex.Message);
            }
        }

        //
        public List<PIKfromPIKSourceNoteTab> GetPIKfromPIKSourceNoteTabListDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<PIKfromPIKSourceNoteTab> _pIKfromPIKSourceNoteTabList = new List<PIKfromPIKSourceNoteTab>();
            DataTable dt = new DataTable();
            TotalCount = 0;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageIndex", Value = pageIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetPIKScheduleDetailDataByNoteId", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {

                foreach (DataRow dr in dt.Rows)
                {
                    _pIKfromPIKSourceNoteTabList.Add(new PIKfromPIKSourceNoteTab
                    {
                        EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]),
                        Date = CommonHelper.ToDateTime(dr["Date"]),
                        Value = CommonHelper.ToDecimal(dr["Value"])
                    });
                }
                TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            }

            return _pIKfromPIKSourceNoteTabList;
        }

        //
        public List<FeeCouponStripReceivableTab> GetFeeCouponStripReceivableTabListDataByNoteId(Guid? noteid, Guid? userID, Guid? AnalysisID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<FeeCouponStripReceivableTab> _feeCouponStripReceivableTabList = new List<FeeCouponStripReceivableTab>();
            DataTable dt = new DataTable();
            TotalCount = 0;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageIndex", Value = pageIndex };
            SqlParameter p5 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p6 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };
            dt = hp.ExecDataTable("dbo.usp_GetFeeCouponStripReceivableDataByNoteId", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {

                foreach (DataRow dr in dt.Rows)
                {
                    _feeCouponStripReceivableTabList.Add(new FeeCouponStripReceivableTab
                    {
                        EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]),
                        Date = CommonHelper.ToDateTime(dr["Date"]),
                        Value = CommonHelper.ToDecimal(dr["Value"]),
                        SourceNoteId = Convert.ToString(dr["SourceNoteId"]),
                        StrippedAmount = CommonHelper.ToDecimal(dr["StrippedAmount"]),
                        RuleType = Convert.ToString(dr["RuleType"]),
                        FeeName = Convert.ToString(dr["FeeName"]),
                        FeeCouponReceivable = CommonHelper.ToDecimal(dr["Value"]),
                        TransactionName = Convert.ToString(dr["TransactionName"])
                    });
                }
                TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            }
            return _feeCouponStripReceivableTabList;
        }

        public List<LiborScheduleTab> GetLiborScheduleTabListDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<LiborScheduleTab> _liborScheduleTabList = new List<LiborScheduleTab>();
            DataTable dt = new DataTable();
            TotalCount = 0;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetLiborScheduleDataByNoteId", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {

                foreach (DataRow dr in dt.Rows)
                {
                    _liborScheduleTabList.Add(new LiborScheduleTab
                    {
                        EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]),
                        Date = CommonHelper.ToDateTime(dr["Date"]),
                        Value = CommonHelper.ToDecimal(dr["Value"]),
                        Indexoverrides = CommonHelper.ToDecimal(dr["SourceNoteId"])
                    });
                }
                TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            }

            return _liborScheduleTabList;
        }

        //
        public List<FixedAmortScheduleTab> GetFixedAmortScheduleTabListDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            List<FixedAmortScheduleTab> _fixedAmortScheduleTabList = new List<FixedAmortScheduleTab>();
            DataTable dt = new DataTable();
            TotalCount = 0;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageIndex", Value = pageIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetFixedAmortScheduleDataByNoteId", sqlparam);
            if (dt != null && dt.Rows.Count > 0)
            {

                foreach (DataRow dr in dt.Rows)
                {
                    _fixedAmortScheduleTabList.Add(new FixedAmortScheduleTab
                    {
                        EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]),
                        Date = CommonHelper.ToDateTime(dr["Date"]),
                        Value = CommonHelper.ToDecimal(dr["Value"])
                    });
                }
                TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            }
            return _fixedAmortScheduleTabList;
        }

        public DataTable GetHistoricalDataOfModuleByNoteId(Guid? noteid, Guid? userID, string ModuleName, string AnalysisID)
        {
            DataTable dt = new DataTable();

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@ModuleName", Value = ModuleName };
                SqlParameter p4 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
                dt = hp.ExecDataTable("usp_GetHistoricalDataOfModuleByNoteId", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            return dt;
        }

        public int AddUpdateNoteAdditinalList(Guid? userid, NoteAdditinalListDataContract _noteadditinallistDC, string CreatedBy, string UpdatedBy)
        {

            Helper.Helper hp = new Helper.Helper();
            NoteTransactionDetailRepository _servicelog = new NoteTransactionDetailRepository();


            DataTable noteaddilist = new DataTable("mytable");
            noteaddilist.Columns.Add("AccCapBal").DefaultValue = "";
            noteaddilist.Columns.Add("AccountID").DefaultValue = "";
            noteaddilist.Columns.Add("AdditionalIntRate").DefaultValue = "";
            noteaddilist.Columns.Add("AdditionalSpread").DefaultValue = "";
            noteaddilist.Columns.Add("Comments").DefaultValue = "";
            noteaddilist.Columns.Add("CreatedBy").DefaultValue = "";
            noteaddilist.Columns.Add("Applied").DefaultValue = "";
            noteaddilist.Columns.Add("CreatedDate").DefaultValue = "";
            noteaddilist.Columns.Add("CurrencyCode").DefaultValue = "";
            noteaddilist.Columns.Add("CurrencyCodeText").DefaultValue = "";
            noteaddilist.Columns.Add("Date").DefaultValue = "";
            noteaddilist.Columns.Add("DrawFundingId").DefaultValue = "";
            noteaddilist.Columns.Add("EffectiveDate").DefaultValue = "";
            noteaddilist.Columns.Add("EffectiveEndDate").DefaultValue = "";
            noteaddilist.Columns.Add("EffectiveStartDate").DefaultValue = "";
            noteaddilist.Columns.Add("EndDate").DefaultValue = "";
            noteaddilist.Columns.Add("Event_Date").DefaultValue = "";
            noteaddilist.Columns.Add("EventId").DefaultValue = "";
            noteaddilist.Columns.Add("EventTypeID").DefaultValue = "";
            noteaddilist.Columns.Add("EventTypeText").DefaultValue = "";
            noteaddilist.Columns.Add("FeeCouponReceivable").DefaultValue = "";
            noteaddilist.Columns.Add("FinancingFeeScheduleID").DefaultValue = "";
            noteaddilist.Columns.Add("FinancingScheduleID").DefaultValue = "";
            noteaddilist.Columns.Add("IncludedBasis").DefaultValue = "";
            noteaddilist.Columns.Add("IncludedLevelYield").DefaultValue = "";
            noteaddilist.Columns.Add("IndexFloor").DefaultValue = "";
            noteaddilist.Columns.Add("IndexTypeID").DefaultValue = "";
            noteaddilist.Columns.Add("IndexTypeText").DefaultValue = "";
            noteaddilist.Columns.Add("IntCalcMethodID").DefaultValue = "";
            noteaddilist.Columns.Add("IntCalcMethodText").DefaultValue = "";
            noteaddilist.Columns.Add("IntCapAmt").DefaultValue = "";
            noteaddilist.Columns.Add("IntCompoundingRate").DefaultValue = "";
            noteaddilist.Columns.Add("IntCompoundingSpread").DefaultValue = "";
            noteaddilist.Columns.Add("IsCapitalized").DefaultValue = "";
            noteaddilist.Columns.Add("IsCapitalizedText").DefaultValue = "";
            noteaddilist.Columns.Add("ModuleId").DefaultValue = "";
            noteaddilist.Columns.Add("NoteID").DefaultValue = "";
            noteaddilist.Columns.Add("NotePrepayAndAdditionalFeeScheduleID").DefaultValue = "";
            noteaddilist.Columns.Add("NotePrepayAndAdditionalValue").DefaultValue = "";
            noteaddilist.Columns.Add("NotePrepayAndAdditionalValueType").DefaultValue = "";
            noteaddilist.Columns.Add("PIKScheduleID").DefaultValue = "";
            noteaddilist.Columns.Add("PPIncludeInBasisCalc").DefaultValue = "";
            noteaddilist.Columns.Add("PPIncludeInLevelYieldCalc").DefaultValue = "";
            noteaddilist.Columns.Add("PrepayAndAdditionalFeeScheduleID").DefaultValue = "";
            noteaddilist.Columns.Add("PrepayValueTypeText").DefaultValue = "";
            noteaddilist.Columns.Add("PurBal").DefaultValue = "";
            noteaddilist.Columns.Add("PurposeID").DefaultValue = "";
            noteaddilist.Columns.Add("ScheduleID").DefaultValue = "";
            noteaddilist.Columns.Add("ScheduleStartDate").DefaultValue = "";
            noteaddilist.Columns.Add("SourceAccount").DefaultValue = "";
            noteaddilist.Columns.Add("SourceAccountID").DefaultValue = "";
            noteaddilist.Columns.Add("StartDate").DefaultValue = "";
            noteaddilist.Columns.Add("TargetAccount").DefaultValue = "";
            noteaddilist.Columns.Add("TargetAccountID").DefaultValue = "";
            noteaddilist.Columns.Add("UpdatedBy").DefaultValue = "";
            noteaddilist.Columns.Add("UpdatedDate").DefaultValue = "";
            noteaddilist.Columns.Add("Value").DefaultValue = "";
            noteaddilist.Columns.Add("ValueTypeID").DefaultValue = "";
            noteaddilist.Columns.Add("ValueTypeText").DefaultValue = "";
            noteaddilist.Columns.Add("RequestType").DefaultValue = "";
            noteaddilist.Columns.Add("Indexoverrides").DefaultValue = "";

            noteaddilist.Columns.Add("ScheduleEndDate").DefaultValue = "";
            noteaddilist.Columns.Add("FeeName").DefaultValue = "";
            noteaddilist.Columns.Add("FeeAmountOverride").DefaultValue = "";
            noteaddilist.Columns.Add("BaseAmountOverride").DefaultValue = "";
            noteaddilist.Columns.Add("ApplyTrueUpFeatureID").DefaultValue = "";
            noteaddilist.Columns.Add("PercentageOfFeeToBeStripped").DefaultValue = "";
            noteaddilist.Columns.Add("RateOrSpreadToBeStripped").DefaultValue = "";
            noteaddilist.Columns.Add("PIKReasonCodeID").DefaultValue = "";
            noteaddilist.Columns.Add("PIKComments").DefaultValue = "";
            noteaddilist.Columns.Add("PIKIntCalcMethodID").DefaultValue = "";
            noteaddilist.Columns.Add("IndexNameID").DefaultValue = "";

            DataTable dtChildNoteAddilist = new DataTable("mytable1");
            dtChildNoteAddilist = noteaddilist;

            DataTable dt = hp.ToDataTable(_noteadditinallistDC.RateSpreadScheduleList);
            // noteaddilist.Merge(dt);
            foreach (DataRow dr in dt.Rows)
            {
                noteaddilist.ImportRow(dr);
            }

            dt = hp.ToDataTable(_noteadditinallistDC.NotePrepayAndAdditionalFeeScheduleList);
            //  noteaddilist.Merge(dt);
            foreach (DataRow dr in dt.Rows)
            {
                noteaddilist.ImportRow(dr);
            }

            dt = hp.ToDataTable(_noteadditinallistDC.NoteStrippingList);
            //   noteaddilist.Merge(dt);
            foreach (DataRow dr in dt.Rows)
            {
                noteaddilist.ImportRow(dr);
            }

            dt = hp.ToDataTable(_noteadditinallistDC.lstFinancingFeeSchedule);
            // noteaddilist.Merge(dt);
            foreach (DataRow dr in dt.Rows)
            {
                noteaddilist.ImportRow(dr);
            }

            dt = hp.ToDataTable(_noteadditinallistDC.NoteFinancingScheduleList);
            //  noteaddilist.Merge(dt);
            foreach (DataRow dr in dt.Rows)
            {
                noteaddilist.ImportRow(dr);
            }

            dt = hp.ToDataTable(_noteadditinallistDC.NoteDefaultScheduleList);
            // noteaddilist.Merge(dt);
            foreach (DataRow dr in dt.Rows)
            {
                noteaddilist.ImportRow(dr);
            }

            dt = hp.ToDataTable(_noteadditinallistDC.NotePIKScheduleList);
            //  noteaddilist.Merge(dt);
            foreach (DataRow dr in dt.Rows)
            {
                noteaddilist.ImportRow(dr);
            }

            dt = hp.ToDataTable(_noteadditinallistDC.NoteServicingFeeScheduleList);
            // noteaddilist.Merge(dt);
            foreach (DataRow dr in dt.Rows)
            {
                noteaddilist.ImportRow(dr);
            }

            dt = hp.ToDataTable(_noteadditinallistDC.ListFeeCouponStripReceivable);
            // noteaddilist.Merge(dt);
            foreach (DataRow dr in dt.Rows)
            {
                noteaddilist.ImportRow(dr);
            }


            dt = hp.ToDataTable(_noteadditinallistDC.ListFixedAmortScheduleTab);
            foreach (DataRow dr in dt.Rows)
            {
                noteaddilist.ImportRow(dr);
            }

            if (_noteadditinallistDC.lstNoteServicingLog != null)
            {
                foreach (NoteServicingLogDataContract _ServicingLogdc in _noteadditinallistDC.lstNoteServicingLog)
                {
                    if (_ServicingLogdc != null)
                    {
                        Helper.Helper hpinner = new Helper.Helper();
                        SqlParameter p1 = new SqlParameter { ParameterName = "@NoteTransactionDetailID", Value = _ServicingLogdc.TransactionId };
                        SqlParameter p2 = new SqlParameter { ParameterName = "@NoteID", Value = new Guid(_noteadditinallistDC.NoteId) };
                        SqlParameter p3 = new SqlParameter { ParameterName = "@TransactionDate", Value = _ServicingLogdc.TransactionDate };
                        SqlParameter p4 = new SqlParameter { ParameterName = "@TransactionType", Value = _ServicingLogdc.TransactionType };
                        SqlParameter p5 = new SqlParameter { ParameterName = "@Amount", Value = _ServicingLogdc.TransactionAmount };
                        SqlParameter p6 = new SqlParameter { ParameterName = "@RelatedtoModeledPMTDate", Value = _ServicingLogdc.RelatedtoModeledPMTDate };
                        SqlParameter p7 = new SqlParameter { ParameterName = "@ModeledPayment", Value = _ServicingLogdc.ModeledPayment };
                        SqlParameter p8 = new SqlParameter { ParameterName = "@AmountOutstandingafterCurrentPayment", Value = _ServicingLogdc.AmountOutstandingafterCurrentPayment };
                        SqlParameter p9 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
                        SqlParameter p10 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UpdatedBy };
                        SqlParameter p11 = new SqlParameter { ParameterName = "@ServicingAmount", Value = _ServicingLogdc.ServicingAmount };
                        SqlParameter p12 = new SqlParameter { ParameterName = "@CalculatedAmount", Value = _ServicingLogdc.CalculatedAmount };
                        SqlParameter p13 = new SqlParameter { ParameterName = "@Delta", Value = _ServicingLogdc.Delta };
                        SqlParameter p14 = new SqlParameter { ParameterName = "@M61Value", Value = _ServicingLogdc.M61Value };
                        SqlParameter p15 = new SqlParameter { ParameterName = "@ServicerValue", Value = _ServicingLogdc.ServicerValue };
                        SqlParameter p16 = new SqlParameter { ParameterName = "@Ignore", Value = _ServicingLogdc.Ignore };
                        SqlParameter p17 = new SqlParameter { ParameterName = "@OverrideValue", Value = _ServicingLogdc.OverrideValue };
                        SqlParameter p18 = new SqlParameter { ParameterName = "@TransactionTypeText", Value = _ServicingLogdc.TransactionTypeText };
                        SqlParameter p19 = new SqlParameter { ParameterName = "@RemittanceDate", Value = _ServicingLogdc.RemittanceDate };
                        SqlParameter p20 = new SqlParameter { ParameterName = "@Adjustment", Value = _ServicingLogdc.Adjustment };
                        SqlParameter p21 = new SqlParameter { ParameterName = "@ActualDelta", Value = _ServicingLogdc.ActualDelta };
                        SqlParameter p22 = new SqlParameter { ParameterName = "@Comment", Value = _ServicingLogdc.comments };
                        SqlParameter p23 = new SqlParameter { ParameterName = "@ServicerMasterID", Value = _ServicingLogdc.ServicerMasterID };
                        SqlParameter p24 = new SqlParameter { ParameterName = "@TransactionEntryAmount", Value = _ServicingLogdc.TransactionEntryAmount };
                        SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24 };
                        hpinner.ExecNonquery("dbo.usp_insertupdateServicingLog", sqlparam);
                    }
                }
            }
            //Note Market Price insert update


            //end


            if (_noteadditinallistDC.lstServicerDropDateSetup != null)
            {
                InsertUpdateServicerDropDateSetup(_noteadditinallistDC.lstServicerDropDateSetup, CreatedBy, new Guid(_noteadditinallistDC.NoteId));
            }

            if (noteaddilist.Rows.Count > 0)
            {
                for (int i = 0; i < noteaddilist.Rows.Count; i++)
                {
                    noteaddilist.Rows[i]["NoteID"] = _noteadditinallistDC.NoteId;
                }
            }

            string[] names = new string[noteaddilist.Columns.Count];
            for (int i = 0; i < noteaddilist.Columns.Count; i++)
            {
                names[i] = noteaddilist.Columns[i].ColumnName;
            }
            Array.Sort(names);
            int columnIndex = 0;
            foreach (var name in names)
            {
                noteaddilist.Columns[name].SetOrdinal(columnIndex);
                columnIndex++;
            }

            //    hp.WriteToCsvFile(noteaddilist, "C:\\File.csv");

            // convert table to list
            List<NoteAdditionalList> notelist = noteaddilist.DataTableToList<NoteAdditionalList>();
            dtChildNoteAddilist = noteaddilist;
            dtChildNoteAddilist.Clear();

            dt = hp.ToDataTable(_noteadditinallistDC.ListLiborScheduleTab);
            dtChildNoteAddilist.Merge(dt);

            hp.ExecDataTablewithtable("usp_InsertUpdateNoteAdditinalList", "noteAdditinallistXML", notelist.ToXML(), "TmpnoteAdditinallist", dtChildNoteAddilist, CreatedBy, UpdatedBy, _noteadditinallistDC.noteobj.RequestType, _noteadditinallistDC.noteobj.AnalysisID.ToString());

            return 1;
        }

        public int AddUpdateNoteArchieveAdditinalList(Guid? userid, NoteAdditinalListDataContract _noteadditinalarchievelistDC, string CreatedBy, string UpdatedBy)
        {

            Helper.Helper hp = new Helper.Helper();
            DataTable noteaddilist = new DataTable();
            noteaddilist.Columns.Add("AccCapBal");
            noteaddilist.Columns.Add("AccountID");
            noteaddilist.Columns.Add("AdditionalIntRate");
            noteaddilist.Columns.Add("AdditionalSpread");
            noteaddilist.Columns.Add("Applied");
            noteaddilist.Columns.Add("Comments");
            noteaddilist.Columns.Add("CreatedBy");
            noteaddilist.Columns.Add("CreatedDate");
            noteaddilist.Columns.Add("CurrencyCode");
            noteaddilist.Columns.Add("CurrencyCodeText");
            noteaddilist.Columns.Add("Date");
            noteaddilist.Columns.Add("DrawFundingId");
            noteaddilist.Columns.Add("EffectiveDate");
            noteaddilist.Columns.Add("EffectiveEndDate");
            noteaddilist.Columns.Add("EffectiveStartDate");
            noteaddilist.Columns.Add("EndDate");
            noteaddilist.Columns.Add("Event_Date");
            noteaddilist.Columns.Add("EventId");
            noteaddilist.Columns.Add("EventTypeID");
            noteaddilist.Columns.Add("EventTypeText");
            noteaddilist.Columns.Add("FeeCouponReceivable");
            noteaddilist.Columns.Add("FinancingFeeScheduleID");
            noteaddilist.Columns.Add("FinancingScheduleID");
            noteaddilist.Columns.Add("IncludedBasis");
            noteaddilist.Columns.Add("IncludedLevelYield");
            noteaddilist.Columns.Add("IndexFloor");
            noteaddilist.Columns.Add("IndexTypeID");
            noteaddilist.Columns.Add("IndexTypeText");
            noteaddilist.Columns.Add("IntCalcMethodID");
            noteaddilist.Columns.Add("IntCalcMethodText");
            noteaddilist.Columns.Add("IntCapAmt");
            noteaddilist.Columns.Add("IntCompoundingRate");
            noteaddilist.Columns.Add("IntCompoundingSpread");
            noteaddilist.Columns.Add("IsCapitalized");
            noteaddilist.Columns.Add("IsCapitalizedText");
            noteaddilist.Columns.Add("ModuleId");
            noteaddilist.Columns.Add("NoteID");
            noteaddilist.Columns.Add("NotePrepayAndAdditionalFeeScheduleID");
            noteaddilist.Columns.Add("NotePrepayAndAdditionalValue");
            noteaddilist.Columns.Add("NotePrepayAndAdditionalValueType");
            noteaddilist.Columns.Add("PIKScheduleID");
            noteaddilist.Columns.Add("PPIncludeInBasisCalc");
            noteaddilist.Columns.Add("PPIncludeInLevelYieldCalc");
            noteaddilist.Columns.Add("PrepayAndAdditionalFeeScheduleID");
            noteaddilist.Columns.Add("PrepayValueTypeText");
            noteaddilist.Columns.Add("PurBal");
            noteaddilist.Columns.Add("PurposeID");
            noteaddilist.Columns.Add("ScheduleID");
            noteaddilist.Columns.Add("ScheduleStartDate");
            noteaddilist.Columns.Add("SourceAccount");
            noteaddilist.Columns.Add("SourceAccountID");
            noteaddilist.Columns.Add("StartDate");
            noteaddilist.Columns.Add("TargetAccount");
            noteaddilist.Columns.Add("TargetAccountID");
            noteaddilist.Columns.Add("UpdatedBy");
            noteaddilist.Columns.Add("UpdatedDate");
            noteaddilist.Columns.Add("Value");
            noteaddilist.Columns.Add("ValueTypeID");
            noteaddilist.Columns.Add("ValueTypeText");

            DataTable dt = hp.ToDataTable(_noteadditinalarchievelistDC.RateSpreadScheduleList);
            foreach (DataRow dr in dt.Rows)
            {
                noteaddilist.ImportRow(dr);
            }

            dt = hp.ToDataTable(_noteadditinalarchievelistDC.NoteStrippingList);
            foreach (DataRow dr in dt.Rows)
            {
                noteaddilist.ImportRow(dr);
            }

            dt = hp.ToDataTable(_noteadditinalarchievelistDC.NotePrepayAndAdditionalFeeScheduleList);
            //  noteaddilist.Merge(dt);
            foreach (DataRow dr in dt.Rows)
            {
                noteaddilist.ImportRow(dr);
            }

            //DataTable dt = hp.ToDataTable(_noteadditinalarchievelistDC.ListFutureFundingScheduleTab);

            //foreach (DataRow dr in dt.Rows)
            //{
            //    noteaddilist.ImportRow(dr);
            //}

            if (noteaddilist.Rows.Count > 0)
            {
                for (int i = 0; i < noteaddilist.Rows.Count; i++)
                {
                    noteaddilist.Rows[i]["NoteID"] = _noteadditinalarchievelistDC.NoteId;
                }
            }

            string[] names = new string[noteaddilist.Columns.Count];
            for (int i = 0; i < noteaddilist.Columns.Count; i++)
            {
                names[i] = noteaddilist.Columns[i].ColumnName;
            }
            Array.Sort(names);
            int columnIndex = 0;
            foreach (var name in names)
            {
                noteaddilist.Columns[name].SetOrdinal(columnIndex);
                columnIndex++;
            }
            //    hp.WriteToCsvFile(noteaddilist, "C:\\File.csv");
            hp.ExecDataTablewithtable("usp_InsertUpdateNoteArchieveAdditinalList", noteaddilist, CreatedBy, UpdatedBy);
            return 1;
        }

        public NoteAllScheduleLatestRecordDataContract GetAllScheduleLatestDataByNoteId(Guid? noteid, Guid? userID, Guid? AnalysisID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            //ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            Helper.Helper hp = new Helper.Helper();
            DataTable dtallSchedule = new DataTable();

            //Get All Schedule Latest EffectiveDate
            //  var _allScheduleLatestEffectiveDateList = dbContext.usp_GetAllScheduleLatestEffectiveDateByNoteId(noteid).ToList();

            SqlParameter ap1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter[] asqlparam = new SqlParameter[] { ap1 };
            dtallSchedule = hp.ExecDataTable("dbo.usp_GetAllScheduleLatestEffectiveDateByNoteId", asqlparam);

            List<FutureFundingScheduleTab> _futureFundingScheduleTabList = new List<FutureFundingScheduleTab>();
            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageIndex", Value = pageIndex };
            SqlParameter p5 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p6 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };
            dt = hp.ExecDataTable("dbo.usp_GetAllScheduleLatestDataByNoteId", sqlparam);
            // var _allScheduleList = dbContext.usp_GetAllScheduleLatestDataByNoteId(noteid, userID, AnalysisID, pageIndex, pageSize, totalCount).ToList();
            TotalCount = 0;// Convert.ToInt32(totalCount.Value);

            //=============
            NoteAllScheduleLatestRecordDataContract _noteAllSch = new NoteAllScheduleLatestRecordDataContract();

            //Set Effective dates
            foreach (DataRow dr in dtallSchedule.Rows)
            {
                if (CommonHelper.ToInt32(dr["EventTypeID"]) == 10)
                {
                    _noteAllSch.FutureFundingEffactiveDate = CommonHelper.ToDateTime(dr["EffectiveStartDate"]);
                }
                if (CommonHelper.ToInt32(dr["EventTypeID"]) == 18)
                {
                    _noteAllSch.LiborScheduleEffactiveDate = CommonHelper.ToDateTime(dr["EffectiveStartDate"]);
                }
                if (CommonHelper.ToInt32(dr["EventTypeID"]) == 19)
                {
                    _noteAllSch.FixedAmortScheduleEffactiveDate = CommonHelper.ToDateTime(dr["EffectiveStartDate"]);
                }
                if (CommonHelper.ToInt32(dr["EventTypeID"]) == 17)
                {
                    _noteAllSch.PIKfromPIKSourceNoteEffactiveDate = CommonHelper.ToDateTime(dr["EffectiveStartDate"]);
                }
                if (CommonHelper.ToInt32(dr["EventTypeID"]) == 20)
                {
                    _noteAllSch.FeeCouponStripReceivableEffactiveDate = CommonHelper.ToDateTime(dr["EffectiveStartDate"]);
                }
            }
            //====================

            // var resFutureFunding = _allScheduleList.Where(x => x.EventTypeID == 10).ToList();//FundingSchedule
            //_noteAllSch.ListFutureFundingScheduleTab = (from rss in resFutureFunding
            //                                            select new FutureFundingScheduleTab()
            //                                           {
            var newdtm = dt.Select("EventTypeID = 10");
            if (newdtm.Length > 0)
            {
                DataTable dtm = dt.Select("EventTypeID = 10").CopyToDataTable();
                List<FutureFundingScheduleTab> ListFutureFunding = new List<FutureFundingScheduleTab>();
                foreach (DataRow dr in dtm.Rows)
                {
                    FutureFundingScheduleTab rss = new FutureFundingScheduleTab();
                    if (Convert.ToString(dr["NoteID"]) != "")
                    {
                        rss.NoteID = new Guid(Convert.ToString(dr["NoteID"]));
                    }
                    if (Convert.ToString(dr["AccountID"]) != "")
                    {
                        rss.AccountID = new Guid(Convert.ToString(dr["AccountID"]));
                    }
                    rss.Date = CommonHelper.ToDateTime(dr["Date"]);
                    rss.Value = CommonHelper.ToDecimal(dr["Value"]);
                    rss.Event_Date = CommonHelper.ToDateTime(dr["Event_Date"]);
                    rss.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                    rss.EffectiveEndDate = CommonHelper.ToDateTime(dr["EffectiveEndDate"]);
                    rss.EventTypeID = CommonHelper.ToInt32(dr["EventTypeID"]);
                    rss.EventTypeText = Convert.ToString(dr["EventTypeText"]);
                    if (Convert.ToString(dr["EventID"]) != "")
                    {
                        rss.EventId = new Guid(Convert.ToString(dr["EventID"]));
                    }
                    rss.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    rss.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    rss.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    rss.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    rss.ModuleId = CommonHelper.ToInt32(dr["EventTypeID"]);
                    rss.PurposeID = CommonHelper.ToInt32(dr["PurposeID"]);
                    rss.PurposeText = Convert.ToString(dr["PurposeText"]);
                    rss.Applied = CommonHelper.ToBoolean(dr["Applied"]);
                    rss.Issaved = CommonHelper.ToBoolean(dr["Issaved"]);
                    rss.DrawFundingId = Convert.ToString(dr["DrawFundingId"]);
                    rss.Comments = Convert.ToString(dr["Comments"]);
                    rss.ScheduleID = Convert.ToString(dr["ScheduleID"]);
                    rss.orgDate = CommonHelper.ToDateTime(dr["Date"]);
                    rss.orgValue = CommonHelper.ToDecimal(dr["Value"]);
                    rss.orgPurposeID = CommonHelper.ToInt32(dr["PurposeID"]);
                    rss.OrgPurposeText = Convert.ToString(dr["PurposeText"]);
                    rss.OrgApplied = CommonHelper.ToBoolean(dr["Applied"]);
                    ListFutureFunding.Add(rss);
                }
                _noteAllSch.ListFutureFundingScheduleTab = ListFutureFunding;
            }
            //if (_noteAllSch.ListFutureFundingScheduleTab.Count() > 0)
            //{
            //    _noteAllSch.FutureFundingEffactiveDate = _noteAllSch.ListFutureFundingScheduleTab.Select(x => x.EffectiveDate).ToList().First();
            //}

            //var resLiborScheduleTab = _allScheduleList.Where(x => x.EventTypeID == 18).ToList();//LIBORSchedule
            //_noteAllSch.ListLiborScheduleTab = (from rss in resLiborScheduleTab
            //                                    select new LiborScheduleTab()
            //                                    {
            //                                        NoteID = rss.NoteID,
            //                                        AccountID = rss.AccountID,
            //                                        //LiborScheduleID = rss.ScheduleID,
            //                                        Date = rss.Date,
            //                                        Value = rss.Value,
            //                                        Event_Date = rss.Event_Date,
            //                                        EffectiveDate = rss.EffectiveDate,
            //                                        EffectiveEndDate = rss.EffectiveEndDate,
            //                                        EventTypeID = rss.EventTypeID,
            //                                        EventTypeText = rss.EventTypeText,
            //                                        EventId = rss.EventID,
            //                                        CreatedBy = rss.CreatedBy,
            //                                        CreatedDate = rss.CreatedDate,
            //                                        UpdatedBy = rss.UpdatedBy,
            //                                        Indexoverrides = rss.IndexValue,
            //                                        UpdatedDate = rss.UpdatedDate,
            //                                        ModuleId = rss.EventTypeID,
            //                                        ScheduleID = rss.ScheduleID.ToString()
            //                                    }).ToList();

            //if (_noteAllSch.lstLiborScheduleTab.Count() > 0)
            //{
            //    _noteAllSch.LiborScheduleEffactiveDate = _noteAllSch.lstLiborScheduleTab.Select(x => x.EffectiveDate).ToList().First();
            //}

            // var resAmortSchedule = _allScheduleList.Where(x => x.EventTypeID == 19);//AmortSchedule
            //_noteAllSch.ListFixedAmortScheduleTab = (from rss in resAmortSchedule
            //                                         select new FixedAmortScheduleTab()
            //     

            var newdtmAmort = dt.Select("EventTypeID = 19");
            if (newdtmAmort.Length > 0)
            {
                DataTable dtmAmortSchedule = dt.Select("EventTypeID = 19").CopyToDataTable();
                List<FixedAmortScheduleTab> ListFixedAmort = new List<FixedAmortScheduleTab>();
                foreach (DataRow dr in dtmAmortSchedule.Rows)
                {
                    FixedAmortScheduleTab lsr = new FixedAmortScheduleTab();
                    if (Convert.ToString(dr["NoteID"]) != "")
                    {
                        lsr.NoteID = new Guid(Convert.ToString(dr["NoteID"]));
                    }
                    if (Convert.ToString(dr["AccountID"]) != "")
                    {
                        lsr.AccountID = new Guid(Convert.ToString(dr["AccountID"]));
                    }
                    lsr.Date = CommonHelper.ToDateTime(dr["Date"]);
                    lsr.Value = CommonHelper.ToDecimal(dr["Value"]);
                    lsr.Event_Date = CommonHelper.ToDateTime(dr["Event_Date"]);
                    lsr.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                    lsr.EffectiveEndDate = CommonHelper.ToDateTime(dr["EffectiveEndDate"]);
                    lsr.EventTypeID = CommonHelper.ToInt32(dr["EventTypeID"]);
                    lsr.EventTypeText = Convert.ToString(dr["EventTypeText"]);
                    if (Convert.ToString(dr["EventID"]) != "")
                    {
                        lsr.EventId = new Guid(Convert.ToString(dr["EventID"]));
                    }

                    lsr.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    lsr.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    lsr.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    lsr.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    lsr.ModuleId = CommonHelper.ToInt32(dr["EventTypeID"]);
                    lsr.ScheduleID = Convert.ToString(dr["ScheduleID"]);
                    ListFixedAmort.Add(lsr);
                }
                _noteAllSch.ListFixedAmortScheduleTab = ListFixedAmort;
            }
            else
            {
                List<FixedAmortScheduleTab> lstamortfixed = new List<FixedAmortScheduleTab>();
                FixedAmortScheduleTab amortfixedtab = new FixedAmortScheduleTab();
                amortfixedtab.ModuleId = 19;
                lstamortfixed.Add(amortfixedtab);
                _noteAllSch.ListFixedAmortScheduleTab = lstamortfixed;
            }
            //if (_noteAllSch.ListFixedAmortScheduleTab.Count() > 0)
            //{
            //    _noteAllSch.FixedAmortScheduleEffactiveDate = _noteAllSch.ListFixedAmortScheduleTab.Select(x => x.EffectiveDate).First();
            //}

            // var resPIKScheduleDetail = _allScheduleList.Where(x => x.EventTypeID == 17);//PIKScheduleDetail
            //_noteAllSch.ListPIKfromPIKSourceNoteTab = (from rss in resPIKScheduleDetail
            //                                           select new PIKfromPIKSourceNoteTab()
            //              

            var newdtmpik = dt.Select("EventTypeID = 17");
            if (newdtmpik.Length > 0)
            {
                DataTable dtmPIKSchedule = dt.Select("EventTypeID = 17").CopyToDataTable();
                List<PIKfromPIKSourceNoteTab> ListPIKfromPIKSource = new List<PIKfromPIKSourceNoteTab>();
                foreach (DataRow dr in dtmPIKSchedule.Rows)
                {
                    PIKfromPIKSourceNoteTab rss = new PIKfromPIKSourceNoteTab();
                    if (Convert.ToString(dr["NoteID"]) != "")
                    {
                        rss.NoteID = new Guid(Convert.ToString(dr["NoteID"]));
                    }
                    if (Convert.ToString(dr["AccountID"]) != "")
                    {
                        rss.AccountID = new Guid(Convert.ToString(dr["AccountID"]));
                    }
                    rss.Date = CommonHelper.ToDateTime(dr["Date"]);
                    rss.Value = CommonHelper.ToDecimal(dr["Value"]);
                    rss.Event_Date = CommonHelper.ToDateTime(dr["Event_Date"]);
                    rss.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                    rss.EffectiveEndDate = CommonHelper.ToDateTime(dr["EffectiveEndDate"]);
                    rss.EventTypeID = CommonHelper.ToInt32(dr["EventTypeID"]);
                    rss.EventTypeText = Convert.ToString(dr["EventTypeText"]);
                    if (Convert.ToString(dr["EventID"]) != "")
                    {
                        rss.EventId = new Guid(Convert.ToString(dr["EventID"]));
                    }
                    rss.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    rss.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    rss.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    rss.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    rss.ModuleId = CommonHelper.ToInt32(dr["EventTypeID"]);
                    rss.ScheduleID = Convert.ToString(dr["ScheduleID"]);
                    ListPIKfromPIKSource.Add(rss);
                }

                _noteAllSch.ListPIKfromPIKSourceNoteTab = ListPIKfromPIKSource;
            }


            //if (_noteAllSch.lstPIKfromPIKSourceNoteTab.Count() > 0)
            //{
            //    _noteAllSch.PIKfromPIKSourceNoteEffactiveDate = _noteAllSch.lstPIKfromPIKSourceNoteTab.Select(x => x.EffectiveDate).First();
            //}

            // var resFeeCouponStripReceivable = _allScheduleList.Where(x => x.EventTypeID == 20);//FeeCouponStripReceivable

            var newdtmfee = dt.Select("EventTypeID = 20");
            if (newdtmfee.Length > 0)
            {
                DataTable dtmFeeCoupon = dt.Select("EventTypeID = 20").CopyToDataTable();
                //_noteAllSch.ListFeeCouponStripReceivable = (from rss in resFeeCouponStripReceivable
                //                                            select new FeeCouponStripReceivableTab()
                //                                            {

                List<FeeCouponStripReceivableTab> ListFeeCouponStrip = new List<FeeCouponStripReceivableTab>();
                foreach (DataRow dr in dtmFeeCoupon.Rows)
                {
                    FeeCouponStripReceivableTab rss = new FeeCouponStripReceivableTab();
                    if (Convert.ToString(dr["NoteID"]) != "")
                    {
                        rss.NoteID = new Guid(Convert.ToString(dr["NoteID"]));
                    }
                    if (Convert.ToString(dr["AccountID"]) != "")
                    {
                        rss.AccountID = new Guid(Convert.ToString(dr["AccountID"]));
                    }
                    rss.Date = CommonHelper.ToDateTime(dr["Date"]);
                    rss.Value = CommonHelper.ToDecimal(dr["Value"]);
                    rss.Event_Date = CommonHelper.ToDateTime(dr["Event_Date"]);
                    rss.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                    rss.EffectiveEndDate = CommonHelper.ToDateTime(dr["EffectiveEndDate"]);
                    rss.EventTypeID = CommonHelper.ToInt32(dr["EventTypeID"]);
                    rss.EventTypeText = Convert.ToString(dr["EventTypeText"]);
                    if (Convert.ToString(dr["EventID"]) != "")
                    {
                        rss.EventId = new Guid(Convert.ToString(dr["EventID"]));
                    }
                    rss.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    rss.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    rss.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    rss.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    rss.ModuleId = CommonHelper.ToInt32(dr["EventTypeID"]);
                    rss.ScheduleID = Convert.ToString(dr["ScheduleID"]);
                    rss.FeeCouponReceivable = CommonHelper.ToDecimal(dr["Value"]);
                    rss.SourceNoteId = Convert.ToString(dr["SourceNoteId"]);
                    rss.StrippedAmount = CommonHelper.ToDecimal(dr["StrippedAmount"]);
                    rss.RuleType = Convert.ToString(dr["RuleType"]);
                    rss.FeeName = Convert.ToString(dr["FeeName"]);
                    ListFeeCouponStrip.Add(rss);
                }
                _noteAllSch.ListFeeCouponStripReceivable = ListFeeCouponStrip;
            }
            //if (_noteAllSch.ListFeeCouponStripReceivable.Count() > 0)
            //{
            //    _noteAllSch.FeeCouponStripReceivableEffactiveDate = _noteAllSch.ListFeeCouponStripReceivable.Select(x => x.EffectiveDate).First();
            //}

            return _noteAllSch;
        }

        public void InsertNotePeriodicCalc(List<NotePeriodicOutputsDataContract> _notePeriodicOutputsDC)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable notePeriCalc = new DataTable();
            notePeriCalc.Columns.Add("NoteID");
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
            notePeriCalc.Columns.Add("EndingPreCapPVBasis");
            notePeriCalc.Columns.Add("LevelYieldIncomeForThePeriod");
            notePeriCalc.Columns.Add("PVAmortTotalIncomeMethod");
            notePeriCalc.Columns.Add("EndingCleanCostLY");
            notePeriCalc.Columns.Add("EndingAccumAmort");
            notePeriCalc.Columns.Add("PVAmortForThePeriod");
            notePeriCalc.Columns.Add("EndingSLBasis");
            notePeriCalc.Columns.Add("SLAmortForThePeriod");
            notePeriCalc.Columns.Add("SLAmortOfTotalFeesInclInLY");
            notePeriCalc.Columns.Add("SLAmortOfDiscountPremium");
            notePeriCalc.Columns.Add("SLAmortOfCapCost");
            notePeriCalc.Columns.Add("EndingAccumSLAmort");
            notePeriCalc.Columns.Add("EndingPreCapGAAPBasis");
            notePeriCalc.Columns.Add("PIKPrincipalPaidForThePeriod");


            if (_notePeriodicOutputsDC != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(_notePeriodicOutputsDC);

                foreach (DataRow dr in dt.Rows)
                {
                    notePeriCalc.ImportRow(dr);
                }
            }

            if (notePeriCalc.Rows.Count > 0)
            {
                string CreatedBy = _notePeriodicOutputsDC[0].CreatedBy; ;
                string UpdatedBy = _notePeriodicOutputsDC[0].UpdatedBy;

                hp.ExecDataTablewithtable("usp_InsertUpdateNotePeriodicCalcByNoteID", notePeriCalc, CreatedBy, UpdatedBy);
            }

            #region Do not delete commented section

            //CRESEntities dbContext = new CRESEntities();

            ////dbContext.ins
            ////_notePeriodicOutputsDC = _notePeriodicOutputsDC.RemoveAll(x=>x.n);

            ////Get properties of BillingDetailEntityBulk
            //System.Reflection.PropertyInfo[] properties = typeof(NotePeriodicOutputsDataContract).GetProperties();

            ////Convert Entity Object to DataTable
            //DataTable dt = ToDataTable(_notePeriodicOutputsDC, properties);

            //string conString = System.Configuration.ConfigurationManager.ConnectionStrings["LoggingInDB"].ConnectionString;
            //SqlConnection conn = new SqlConnection(conString);
            //if(conn.State == ConnectionState.Open) { conn.Close(); }
            //conn.Open();

            //string noteid = dt.Rows[0]["NoteID"].ToString();

            //SqlCommand com2 = new SqlCommand("usp_DeleteNotePeriodicCalcByNoteID", conn);
            //com2.CommandType = CommandType.StoredProcedure;
            //com2.Parameters.AddWithValue("@NoteID", noteid);
            //com2.ExecuteNonQuery();

            ////Insert Data into Database
            //string tableName = "CRE.NotePeriodicCalc";
            //BulkInsert(dt, tableName, conString);

            #endregion Do not delete commented section
        }

        public void InsertNotePeriodicCalcFromCalculationManger(List<NotePeriodicOutputsDataContract> _notePeriodicOutputsDC, string username, Guid noteid)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable notePeriCalc = new DataTable();
            notePeriCalc.Columns.Add("NoteID");
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

            notePeriCalc.Columns.Add("EndingPreCapPVBasis");
            notePeriCalc.Columns.Add("LevelYieldIncomeForThePeriod");
            notePeriCalc.Columns.Add("PVAmortTotalIncomeMethod");
            notePeriCalc.Columns.Add("EndingCleanCostLY");
            notePeriCalc.Columns.Add("EndingAccumAmort");
            notePeriCalc.Columns.Add("PVAmortForThePeriod");
            notePeriCalc.Columns.Add("EndingSLBasis");
            notePeriCalc.Columns.Add("SLAmortForThePeriod");
            notePeriCalc.Columns.Add("SLAmortOfTotalFeesInclInLY");
            notePeriCalc.Columns.Add("SLAmortOfDiscountPremium");
            notePeriCalc.Columns.Add("SLAmortOfCapCost");
            notePeriCalc.Columns.Add("EndingAccumSLAmort");
            notePeriCalc.Columns.Add("EndingPreCapGAAPBasis");
            notePeriCalc.Columns.Add("PIKPrincipalPaidForThePeriod");


            if (_notePeriodicOutputsDC != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(_notePeriodicOutputsDC);

                foreach (DataRow dr in dt.Rows)
                {
                    dr["NoteID"] = noteid;
                    dr["UpdatedBy"] = username;
                    dr["CreatedBy"] = username;

                    notePeriCalc.ImportRow(dr);
                }
            }

            if (notePeriCalc.Rows.Count > 0)
            {
                hp.ExecDataTablewithtable("usp_InsertUpdateNotePeriodicCalcByNoteID", notePeriCalc, username, username);
            }
        }

        public void InsertNotePeriodicCalcFromCalculationDaily(List<NotePeriodicOutputsDataContract> _notePeriodicOutputsDC, string username, Guid noteid)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable notePeriCalc = new DataTable();
            notePeriCalc.Columns.Add("NoteID");
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
            notePeriCalc.Columns.Add("EndingPreCapPVBasis");
            notePeriCalc.Columns.Add("LevelYieldIncomeForThePeriod");
            notePeriCalc.Columns.Add("PVAmortTotalIncomeMethod");
            notePeriCalc.Columns.Add("EndingCleanCostLY");
            notePeriCalc.Columns.Add("EndingAccumAmort");
            notePeriCalc.Columns.Add("PVAmortForThePeriod");
            notePeriCalc.Columns.Add("EndingSLBasis");
            notePeriCalc.Columns.Add("SLAmortForThePeriod");
            notePeriCalc.Columns.Add("SLAmortOfTotalFeesInclInLY");
            notePeriCalc.Columns.Add("SLAmortOfDiscountPremium");
            notePeriCalc.Columns.Add("SLAmortOfCapCost");
            notePeriCalc.Columns.Add("EndingAccumSLAmort");
            notePeriCalc.Columns.Add("EndingPreCapGAAPBasis");
            notePeriCalc.Columns.Add("PIKPrincipalPaidForThePeriod");

            if (_notePeriodicOutputsDC != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(_notePeriodicOutputsDC);

                foreach (DataRow dr in dt.Rows)
                {
                    dr["NoteID"] = noteid;
                    dr["UpdatedBy"] = username;
                    dr["CreatedBy"] = username;

                    notePeriCalc.ImportRow(dr);
                }
            }

            if (notePeriCalc.Rows.Count > 0)
            {
                hp.ExecDataTablewithtable("usp_InsertUpdateNotePeriodicCalcByNoteIDDaily", notePeriCalc, username, username);
            }
        }

        public void InsertNotePeriodicCalcFromCalculationPVandGaap(List<NotePeriodicOutputsDataContract> _notePeriodicOutputsDC, string username, Guid noteid)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable notePeriCalc = new DataTable();
            notePeriCalc.Columns.Add("NoteID");
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
            notePeriCalc.Columns.Add("EndingPreCapPVBasis");
            notePeriCalc.Columns.Add("LevelYieldIncomeForThePeriod");
            notePeriCalc.Columns.Add("PVAmortTotalIncomeMethod");
            notePeriCalc.Columns.Add("EndingCleanCostLY");
            notePeriCalc.Columns.Add("EndingAccumAmort");
            notePeriCalc.Columns.Add("PVAmortForThePeriod");
            notePeriCalc.Columns.Add("EndingSLBasis");
            notePeriCalc.Columns.Add("SLAmortForThePeriod");
            notePeriCalc.Columns.Add("SLAmortOfTotalFeesInclInLY");
            notePeriCalc.Columns.Add("SLAmortOfDiscountPremium");
            notePeriCalc.Columns.Add("SLAmortOfCapCost");
            notePeriCalc.Columns.Add("EndingAccumSLAmort");
            notePeriCalc.Columns.Add("EndingPreCapGAAPBasis");
            notePeriCalc.Columns.Add("PIKPrincipalPaidForThePeriod");

            if (_notePeriodicOutputsDC != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(_notePeriodicOutputsDC);

                foreach (DataRow dr in dt.Rows)
                {
                    dr["NoteID"] = noteid;
                    dr["UpdatedBy"] = username;
                    dr["CreatedBy"] = username;

                    notePeriCalc.ImportRow(dr);
                }
            }

            if (notePeriCalc.Rows.Count > 0)
            {
                hp.ExecDataTablewithgaapandlibor("usp_InsertUpdateNotePeriodicCalcByNoteIDUpdateColumn", notePeriCalc, username, "gaap");
            }
        }

        public void InsertNotePeriodicCalcFromCalculationSpreadLibor(List<NotePeriodicOutputsDataContract> _notePeriodicOutputsDC, string username, Guid noteid)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable notePeriCalc = new DataTable();
            notePeriCalc.Columns.Add("NoteID");
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

            notePeriCalc.Columns.Add("EndingPreCapPVBasis");
            notePeriCalc.Columns.Add("LevelYieldIncomeForThePeriod");
            notePeriCalc.Columns.Add("PVAmortTotalIncomeMethod");
            notePeriCalc.Columns.Add("EndingCleanCostLY");
            notePeriCalc.Columns.Add("EndingAccumAmort");
            notePeriCalc.Columns.Add("PVAmortForThePeriod");
            notePeriCalc.Columns.Add("EndingSLBasis");
            notePeriCalc.Columns.Add("SLAmortForThePeriod");
            notePeriCalc.Columns.Add("SLAmortOfTotalFeesInclInLY");
            notePeriCalc.Columns.Add("SLAmortOfDiscountPremium");
            notePeriCalc.Columns.Add("SLAmortOfCapCost");
            notePeriCalc.Columns.Add("EndingAccumSLAmort");
            notePeriCalc.Columns.Add("EndingPreCapGAAPBasis");
            notePeriCalc.Columns.Add("PIKPrincipalPaidForThePeriod");

            if (_notePeriodicOutputsDC != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(_notePeriodicOutputsDC);

                foreach (DataRow dr in dt.Rows)
                {
                    dr["NoteID"] = noteid;
                    dr["UpdatedBy"] = username;
                    dr["CreatedBy"] = username;

                    notePeriCalc.ImportRow(dr);
                }
            }

            if (notePeriCalc.Rows.Count > 0)
            {
                hp.ExecDataTablewithgaapandlibor("usp_InsertUpdateNotePeriodicCalcByNoteIDUpdateColumn", notePeriCalc, username, "libor");
            }
        }

        private DataTable ToDataTable(List<NotePeriodicOutputsDataContract> entities, System.Reflection.PropertyInfo[] properties)
        {
            var table = new DataTable();

            //Adding Column in Datatable
            foreach (var property in properties)
            {
                table.Columns.Add(property.Name, Nullable.GetUnderlyingType(property.PropertyType) ?? property.PropertyType);
            }

            //Assigning Value in DataTable
            foreach (var item in entities)
            {
                table.Rows.Add(properties.Select(p => p.GetValue(item, null)).ToArray());
            }
            return table;
        }

        private void BulkInsert(DataTable dt, string tableName, string conString)
        {
            try
            {
                SqlBulkCopy bulkcopy = new SqlBulkCopy(conString);

                bulkcopy.BulkCopyTimeout = 36000;
                bulkcopy.DestinationTableName = tableName;

                bulkcopy.ColumnMappings.Add("NoteID", "NoteID");
                //bulkcopy.ColumnMappings.Add("NotePeriodicCalcID", "NotePeriodicCalcID");
                bulkcopy.ColumnMappings.Add("PeriodEndDate", "PeriodEndDate");
                bulkcopy.ColumnMappings.Add("Month", "Month");
                bulkcopy.ColumnMappings.Add("ActualCashFlows", "ActualCashFlows");
                bulkcopy.ColumnMappings.Add("GAAPCashFlows", "GAAPCashFlows");
                bulkcopy.ColumnMappings.Add("EndingGAAPBookValue", "EndingGAAPBookValue");
                bulkcopy.ColumnMappings.Add("TotalGAAPIncomeforthePeriod", "TotalGAAPIncomeforthePeriod");
                bulkcopy.ColumnMappings.Add("InterestAccrualforthePeriod", "InterestAccrualforthePeriod");
                bulkcopy.ColumnMappings.Add("PIKInterestAccrualforthePeriod", "PIKInterestAccrualforthePeriod");
                bulkcopy.ColumnMappings.Add("TotalAmortAccrualForPeriod", "TotalAmortAccrualForPeriod");
                bulkcopy.ColumnMappings.Add("AccumulatedAmort", "AccumulatedAmort");
                bulkcopy.ColumnMappings.Add("BeginningBalance", "BeginningBalance");
                bulkcopy.ColumnMappings.Add("TotalFutureAdvancesForThePeriod", "TotalFutureAdvancesForThePeriod");
                bulkcopy.ColumnMappings.Add("TotalDiscretionaryCurtailmentsforthePeriod", "TotalDiscretionaryCurtailmentsforthePeriod");
                bulkcopy.ColumnMappings.Add("InterestPaidOnPaymentDate", "InterestPaidOnPaymentDate");
                bulkcopy.ColumnMappings.Add("TotalCouponStrippedforthePeriod", "TotalCouponStrippedforthePeriod");
                bulkcopy.ColumnMappings.Add("CouponStrippedonPaymentDate", "CouponStrippedonPaymentDate");
                bulkcopy.ColumnMappings.Add("ScheduledPrincipal", "ScheduledPrincipal");
                bulkcopy.ColumnMappings.Add("PrincipalPaid", "PrincipalPaid");
                bulkcopy.ColumnMappings.Add("BalloonPayment", "BalloonPayment");
                bulkcopy.ColumnMappings.Add("EndingBalance", "EndingBalance");

                //bulkcopy.ColumnMappings.Add("ExitFeeIncludedInLevelYield", "ExitFeeIncludedInLevelYield");
                //bulkcopy.ColumnMappings.Add("ExitFeeExcludedFromLevelYield", "ExitFeeExcludedFromLevelYield");
                //bulkcopy.ColumnMappings.Add("AdditionalFeesIncludedInLevelYield", "AdditionalFeesIncludedInLevelYield");
                //bulkcopy.ColumnMappings.Add("AdditionalFeesExcludedFromLevelYield", "AdditionalFeesExcludedFromLevelYield");
                //bulkcopy.ColumnMappings.Add("OriginationFeeStripping", "OriginationFeeStripping");
                //bulkcopy.ColumnMappings.Add("ExitFeeStrippingIncldinLevelYield", "ExitFeeStrippingIncldinLevelYield");
                //bulkcopy.ColumnMappings.Add("ExitFeeStrippingExcldfromLevelYield", "ExitFeeStrippingExcldfromLevelYield");
                //bulkcopy.ColumnMappings.Add("AddlFeesStrippingIncldinLevelYield", "AddlFeesStrippingIncldinLevelYield");
                //bulkcopy.ColumnMappings.Add("AddlFeesStrippingExcldfromLevelYield", "AddlFeesStrippingExcldfromLevelYield");

                bulkcopy.ColumnMappings.Add("EndOfPeriodWAL", "EndOfPeriodWAL");
                bulkcopy.ColumnMappings.Add("PIKInterestFromPIKSourceNote", "PIKInterestFromPIKSourceNote");
                bulkcopy.ColumnMappings.Add("PIKInterestTransferredToRelatedNote", "PIKInterestTransferredToRelatedNote");
                bulkcopy.ColumnMappings.Add("PIKInterestForThePeriod", "PIKInterestForThePeriod");
                bulkcopy.ColumnMappings.Add("BeginningPIKBalanceNotInsideLoanBalance", "BeginningPIKBalanceNotInsideLoanBalance");
                bulkcopy.ColumnMappings.Add("PIKInterestForPeriodNotInsideLoanBalance", "PIKInterestForPeriodNotInsideLoanBalance");
                bulkcopy.ColumnMappings.Add("PIKBalanceBalloonPayment", "PIKBalanceBalloonPayment");
                bulkcopy.ColumnMappings.Add("EndingPIKBalanceNotInsideLoanBalance", "EndingPIKBalanceNotInsideLoanBalance");
                bulkcopy.ColumnMappings.Add("AmortAccrualLevelYield", "AmortAccrualLevelYield");
                bulkcopy.ColumnMappings.Add("ScheduledPrincipalShortfall", "ScheduledPrincipalShortfall");
                bulkcopy.ColumnMappings.Add("PrincipalShortfall", "PrincipalShortfall");
                bulkcopy.ColumnMappings.Add("PrincipalLoss", "PrincipalLoss");
                bulkcopy.ColumnMappings.Add("InterestForPeriodShortfall", "InterestForPeriodShortfall");
                bulkcopy.ColumnMappings.Add("InterestPaidOnPMTDateShortfall", "InterestPaidOnPMTDateShortfall");
                bulkcopy.ColumnMappings.Add("CumulativeInterestPaidOnPMTDateShortfall", "CumulativeInterestPaidOnPMTDateShortfall");
                bulkcopy.ColumnMappings.Add("InterestShortfallLoss", "InterestShortfallLoss");
                bulkcopy.ColumnMappings.Add("InterestShortfallRecovery", "InterestShortfallRecovery");
                bulkcopy.ColumnMappings.Add("BeginningFinancingBalance", "BeginningFinancingBalance");
                bulkcopy.ColumnMappings.Add("TotalFinancingDrawsCurtailmentsForPeriod", "TotalFinancingDrawsCurtailmentsForPeriod");
                bulkcopy.ColumnMappings.Add("FinancingBalloon", "FinancingBalloon");
                bulkcopy.ColumnMappings.Add("EndingFinancingBalance", "EndingFinancingBalance");
                bulkcopy.ColumnMappings.Add("FinancingInterestPaid", "FinancingInterestPaid");
                bulkcopy.ColumnMappings.Add("FinancingFeesPaid", "FinancingFeesPaid");
                bulkcopy.ColumnMappings.Add("PeriodLeveredYield", "PeriodLeveredYield");
                bulkcopy.ColumnMappings.Add("CreatedBy", "CreatedBy");
                bulkcopy.ColumnMappings.Add("CreatedDate", "CreatedDate");
                bulkcopy.ColumnMappings.Add("UpdatedBy", "UpdatedBy");
                bulkcopy.ColumnMappings.Add("UpdatedDate", "UpdatedDate");

                bulkcopy.WriteToServer(dt);

                //NoteCalculator.CalculationMaster a = new NoteCalculator.CalculationMaster();
                //a.CreateCSVFile(ToDataSet(ListRateTab).Tables[0], "Rates");
            }
            catch (Exception ex)
            {
                string a = ex.Message;
            }
        }

        public string AddUpdateNoteFromCalculatorService(Guid? userid, List<NoteDataContract> noteDataContract)
        {
            //check GUId null

            foreach (var note in noteDataContract)
            {
                if (string.IsNullOrEmpty(note.NoteId))
                {
                    note.NoteId = default(Guid).ToString();
                    note.AccountID = default(Guid).ToString();
                }
            }

            // bool retValue = false;


            int count = 0;
            string Newnoteid = "";
            foreach (var note in noteDataContract)
            {
                //  ObjectParameter newnoteId = new ObjectParameter("NewNoteID", typeof(string));
                //  Guid uniNoteID = new Guid(note.NoteId);
                //   Guid uniAccountID = new Guid(note.AccountID);
                //  Guid uniDealID = new Guid(note.DealID);

                //if (string.IsNullOrEmpty(note.AccountID))
                //    note.AccountID = default(Guid).ToString();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@NoteID", Value = new Guid(note.NoteId) };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Account_AccountID", Value = new Guid(note.AccountID) };
                SqlParameter p4 = new SqlParameter { ParameterName = "@DealID", Value = new Guid(note.DealID) };
                SqlParameter p5 = new SqlParameter { ParameterName = "@CRENoteID", Value = note.CRENoteID };
                SqlParameter p6 = new SqlParameter { ParameterName = "@ClientNoteID", Value = note.ClientNoteID };
                SqlParameter p7 = new SqlParameter { ParameterName = "@Comments", Value = note.Comments };
                SqlParameter p8 = new SqlParameter { ParameterName = "@InitialInterestAccrualEndDate", Value = note.InitialInterestAccrualEndDate };
                SqlParameter p9 = new SqlParameter { ParameterName = "@AccrualFrequency", Value = note.AccrualFrequency };
                SqlParameter p10 = new SqlParameter { ParameterName = "@DeterminationDateLeadDays", Value = note.DeterminationDateLeadDays };
                SqlParameter p11 = new SqlParameter { ParameterName = "@DeterminationDateReferenceDayoftheMonth", Value = note.DeterminationDateReferenceDayoftheMonth };
                SqlParameter p12 = new SqlParameter { ParameterName = "@DeterminationDateInterestAccrualPeriod", Value = note.DeterminationDateInterestAccrualPeriod };
                SqlParameter p13 = new SqlParameter { ParameterName = "@DeterminationDateHolidayList", Value = note.DeterminationDateHolidayList };
                SqlParameter p14 = new SqlParameter { ParameterName = "@FirstPaymentDate", Value = note.FirstPaymentDate };
                SqlParameter p15 = new SqlParameter { ParameterName = "@InitialMonthEndPMTDateBiWeekly", Value = note.InitialMonthEndPMTDateBiWeekly };
                SqlParameter p16 = new SqlParameter { ParameterName = "@PaymentDateBusinessDayLag", Value = note.PaymentDateBusinessDayLag };
                SqlParameter p17 = new SqlParameter { ParameterName = "@IOTerm", Value = note.IOTerm };
                SqlParameter p18 = new SqlParameter { ParameterName = "@AmortTerm", Value = note.AmortTerm };
                SqlParameter p19 = new SqlParameter { ParameterName = "@PIKSeparateCompounding", Value = note.PIKSeparateCompounding };
                SqlParameter p20 = new SqlParameter { ParameterName = "@MonthlyDSOverridewhenAmortizing", Value = note.MonthlyDSOverridewhenAmortizing };
                SqlParameter p21 = new SqlParameter { ParameterName = "@AccrualPeriodPaymentDayWhenNotEOMonth", Value = note.AccrualPeriodPaymentDayWhenNotEOMonth };
                SqlParameter p22 = new SqlParameter { ParameterName = "@FirstPeriodInterestPaymentOverride", Value = note.FirstPeriodInterestPaymentOverride };
                SqlParameter p23 = new SqlParameter { ParameterName = "@FirstPeriodPrincipalPaymentOverride", Value = note.FirstPeriodPrincipalPaymentOverride };
                SqlParameter p24 = new SqlParameter { ParameterName = "@FinalInterestAccrualEndDateOverride", Value = note.FinalInterestAccrualEndDateOverride };
                SqlParameter p25 = new SqlParameter { ParameterName = "@AmortType", Value = note.AmortType };
                SqlParameter p26 = new SqlParameter { ParameterName = "@RateType", Value = note.RateType };
                SqlParameter p27 = new SqlParameter { ParameterName = "@ReAmortizeMonthly", Value = note.ReAmortizeMonthly };
                SqlParameter p28 = new SqlParameter { ParameterName = "@ReAmortizeatPMTReset", Value = note.ReAmortizeatPMTReset };
                SqlParameter p29 = new SqlParameter { ParameterName = "@StubPaidInArrears", Value = note.StubPaidInArrears };
                SqlParameter p30 = new SqlParameter { ParameterName = "@RelativePaymentMonth", Value = note.RelativePaymentMonth };
                SqlParameter p31 = new SqlParameter { ParameterName = "@SettleWithAccrualFlag", Value = note.SettleWithAccrualFlag };
                SqlParameter p32 = new SqlParameter { ParameterName = "@InterestDueAtMaturity", Value = note.InterestDueAtMaturity };
                SqlParameter p33 = new SqlParameter { ParameterName = "@RateIndexResetFreq", Value = note.RateIndexResetFreq };
                SqlParameter p34 = new SqlParameter { ParameterName = "@FirstRateIndexResetDate", Value = note.FirstRateIndexResetDate };
                SqlParameter p35 = new SqlParameter { ParameterName = "@LoanPurchase", Value = note.LoanPurchase };
                SqlParameter p36 = new SqlParameter { ParameterName = "@AmortIntCalcDayCount", Value = note.AmortIntCalcDayCount };
                SqlParameter p37 = new SqlParameter { ParameterName = "@StubPaidinAdvanceYN", Value = note.StubPaidinAdvanceYN };
                SqlParameter p38 = new SqlParameter { ParameterName = "@FullPeriodInterestDueatMaturity", Value = note.FullPeriodInterestDueatMaturity };
                SqlParameter p39 = new SqlParameter { ParameterName = "@ProspectiveAccountingMode", Value = note.ProspectiveAccountingMode };
                SqlParameter p40 = new SqlParameter { ParameterName = "@IsCapitalized", Value = note.IsCapitalized };
                SqlParameter p41 = new SqlParameter { ParameterName = "@SelectedMaturityDateScenario", Value = note.SelectedMaturityDateScenario };
                //SqlParameter p42 = new SqlParameter { ParameterName = "@SelectedMaturityDate", Value = note.SelectedMaturityDate };
                // SqlParameter p43 = new SqlParameter { ParameterName = "@InitialMaturityDate", Value = note.InitialMaturityDate };
                // SqlParameter p44 = new SqlParameter { ParameterName = "@ExpectedMaturityDate", Value = note.ExpectedMaturityDate };
                //SqlParameter p45 = new SqlParameter { ParameterName = "@FullyExtendedMaturityDate", Value = note.FullyExtendedMaturityDate };
                // SqlParameter p46 = new SqlParameter { ParameterName = "@OpenPrepaymentDate", Value = note.OpenPrepaymentDate };
                SqlParameter p47 = new SqlParameter { ParameterName = "@CashflowEngineID", Value = note.CashflowEngineID };
                SqlParameter p48 = new SqlParameter { ParameterName = "@LoanType", Value = note.LoanType };
                SqlParameter p49 = new SqlParameter { ParameterName = "@Classification", Value = note.Classification };
                SqlParameter p50 = new SqlParameter { ParameterName = "@SubClassification", Value = note.SubClassification };
                SqlParameter p51 = new SqlParameter { ParameterName = "@GAAPDesignation", Value = note.GAAPDesignation };
                SqlParameter p52 = new SqlParameter { ParameterName = "@PortfolioID", Value = note.PortfolioID };
                SqlParameter p53 = new SqlParameter { ParameterName = "@GeographicLocation", Value = note.GeographicLocation };
                SqlParameter p54 = new SqlParameter { ParameterName = "@PropertyType", Value = note.PropertyType };
                SqlParameter p55 = new SqlParameter { ParameterName = "@RatingAgency", Value = note.RatingAgency };
                SqlParameter p56 = new SqlParameter { ParameterName = "@RiskRating", Value = note.RiskRating };
                SqlParameter p57 = new SqlParameter { ParameterName = "@PurchasePrice", Value = note.PurchasePrice };
                SqlParameter p58 = new SqlParameter { ParameterName = "@FutureFeesUsedforLevelYeild", Value = note.FutureFeesUsedforLevelYeild };
                SqlParameter p59 = new SqlParameter { ParameterName = "@TotalToBeAmortized", Value = note.TotalToBeAmortized };
                SqlParameter p60 = new SqlParameter { ParameterName = "@StubPeriodInterest", Value = note.StubPeriodInterest };
                SqlParameter p61 = new SqlParameter { ParameterName = "@WDPAssetMultiple", Value = note.WDPAssetMultiple };
                SqlParameter p62 = new SqlParameter { ParameterName = "@WDPEquityMultiple", Value = note.WDPEquityMultiple };
                SqlParameter p63 = new SqlParameter { ParameterName = "@PurchaseBalance", Value = note.PurchaseBalance };
                SqlParameter p64 = new SqlParameter { ParameterName = "@DaysofAccrued", Value = note.DaysofAccrued };
                SqlParameter p65 = new SqlParameter { ParameterName = "@InterestRate", Value = note.InterestRate };
                SqlParameter p66 = new SqlParameter { ParameterName = "@PurchasedInterestCalc", Value = note.PurchasedInterestCalc };
                SqlParameter p67 = new SqlParameter { ParameterName = "@ModelFinancingDrawsForFutureFundings", Value = note.ModelFinancingDrawsForFutureFundings };
                SqlParameter p68 = new SqlParameter { ParameterName = "@NumberOfBusinessDaysLagForFinancingDraw", Value = note.NumberOfBusinessDaysLagForFinancingDraw };
                SqlParameter p69 = new SqlParameter { ParameterName = "@FinancingFacilityID", Value = note.FinancingFacilityID };
                SqlParameter p70 = new SqlParameter { ParameterName = "@FinancingInitialMaturityDate", Value = note.FinancingInitialMaturityDate };
                SqlParameter p71 = new SqlParameter { ParameterName = "@FinancingExtendedMaturityDate", Value = note.FinancingExtendedMaturityDate };
                SqlParameter p72 = new SqlParameter { ParameterName = "@FinancingPayFrequency", Value = note.FinancingPayFrequency };
                SqlParameter p73 = new SqlParameter { ParameterName = "@FinancingInterestPaymentDay", Value = note.FinancingInterestPaymentDay };
                SqlParameter p74 = new SqlParameter { ParameterName = "@ClosingDate", Value = note.ClosingDate };
                SqlParameter p75 = new SqlParameter { ParameterName = "@InitialFundingAmount", Value = note.InitialFundingAmount };
                SqlParameter p76 = new SqlParameter { ParameterName = "@Discount", Value = note.Discount };
                SqlParameter p77 = new SqlParameter { ParameterName = "@OriginationFee", Value = note.OriginationFee };
                SqlParameter p78 = new SqlParameter { ParameterName = "@CapitalizedClosingCosts", Value = note.CapitalizedClosingCosts };
                SqlParameter p79 = new SqlParameter { ParameterName = "@PurchaseDate", Value = note.PurchaseDate };
                SqlParameter p80 = new SqlParameter { ParameterName = "@PurchaseAccruedFromDate", Value = note.PurchaseAccruedFromDate };
                SqlParameter p81 = new SqlParameter { ParameterName = "@PurchasedInterestOverride", Value = note.PurchasedInterestOverride };
                SqlParameter p82 = new SqlParameter { ParameterName = "@DiscountRate", Value = note.DiscountRate };
                SqlParameter p83 = new SqlParameter { ParameterName = "@ValuationDate", Value = note.ValuationDate };
                SqlParameter p84 = new SqlParameter { ParameterName = "@FairValue", Value = note.FairValue };
                SqlParameter p85 = new SqlParameter { ParameterName = "@DiscountRatePlus", Value = note.DiscountRatePlus };
                SqlParameter p86 = new SqlParameter { ParameterName = "@FairValuePlus", Value = note.FairValuePlus };
                SqlParameter p87 = new SqlParameter { ParameterName = "@DiscountRateMinus", Value = note.DiscountRateMinus };
                SqlParameter p88 = new SqlParameter { ParameterName = "@FairValueMinus", Value = note.FairValueMinus };
                SqlParameter p89 = new SqlParameter { ParameterName = "@InitialIndexValueOverride", Value = note.InitialIndexValueOverride };
                SqlParameter p90 = new SqlParameter { ParameterName = "@IncludeServicingPaymentOverrideinLevelYield", Value = note.IncludeServicingPaymentOverrideinLevelYield };
                SqlParameter p91 = new SqlParameter { ParameterName = "@OngoingAnnualizedServicingFee", Value = note.OngoingAnnualizedServicingFee };
                SqlParameter p92 = new SqlParameter { ParameterName = "@IndexRoundingRule", Value = note.IndexRoundingRule };
                SqlParameter p93 = new SqlParameter { ParameterName = "@RoundingMethod", Value = note.RoundingMethod };
                SqlParameter p94 = new SqlParameter { ParameterName = "@StubInterestPaidonFutureAdvances", Value = note.StubInterestPaidonFutureAdvances };
                SqlParameter p95 = new SqlParameter { ParameterName = "@TaxAmortCheck", Value = note.TaxAmortCheck };
                SqlParameter p96 = new SqlParameter { ParameterName = "@PIKWoCompCheck", Value = note.PIKWoCompCheck };
                SqlParameter p97 = new SqlParameter { ParameterName = "@GAAPAmortCheck", Value = note.GAAPAmortCheck };
                SqlParameter p98 = new SqlParameter { ParameterName = "@StubIntOverride", Value = note.StubIntOverride };
                SqlParameter p99 = new SqlParameter { ParameterName = "@PurchasedIntOverride", Value = note.PurchasedIntOverride };
                SqlParameter p100 = new SqlParameter { ParameterName = "@ExitFeeFreePrepayAmt", Value = note.ExitFeeFreePrepayAmt };
                SqlParameter p101 = new SqlParameter { ParameterName = "@ExitFeeBaseAmountOverride", Value = note.ExitFeeBaseAmountOverride };
                SqlParameter p102 = new SqlParameter { ParameterName = "@ExitFeeAmortCheck", Value = note.ExitFeeAmortCheck };
                SqlParameter p103 = new SqlParameter { ParameterName = "@FixedAmortScheduleCheck", Value = note.FixedAmortSchedule };
                SqlParameter p104 = new SqlParameter { ParameterName = "@NoofdaysrelPaymentDaterollnextpaymentcycle", Value = note.NoofdaysrelPaymentDaterollnextpaymentcycle };
                SqlParameter p105 = new SqlParameter { ParameterName = "@CreatedBy", Value = note.CreatedBy };
                SqlParameter p106 = new SqlParameter { ParameterName = "@CreatedDate", Value = note.CreatedDate };
                SqlParameter p107 = new SqlParameter { ParameterName = "@UpdatedBy", Value = note.UpdatedBy };
                SqlParameter p108 = new SqlParameter { ParameterName = "@UpdatedDate", Value = note.UpdatedDate };
                SqlParameter p109 = new SqlParameter { ParameterName = "@name", Value = note.Name };
                SqlParameter p110 = new SqlParameter { ParameterName = "@statusID", Value = note.StatusID };
                SqlParameter p111 = new SqlParameter { ParameterName = "@BaseCurrencyID", Value = note.BaseCurrencyID };
                SqlParameter p112 = new SqlParameter { ParameterName = "@StartDate", Value = note.StartDate };
                SqlParameter p113 = new SqlParameter { ParameterName = "@EndDate", Value = note.EndDate };
                SqlParameter p114 = new SqlParameter { ParameterName = "@PayFrequency", Value = note.PayFrequency };
                SqlParameter p115 = new SqlParameter { ParameterName = "@LoanCurrency", Value = note.LoanCurrency };
                SqlParameter p116 = new SqlParameter { ParameterName = "@DeterminationDateHolidayListText", Value = note.DeterminationDateHolidayListText };
                SqlParameter p117 = new SqlParameter { ParameterName = "@PIKSeparateCompoundingText", Value = note.PIKSeparateCompoundingText };
                SqlParameter p118 = new SqlParameter { ParameterName = "@LoanPurchaseYNText", Value = note.LoanPurchaseYNText };
                SqlParameter p119 = new SqlParameter { ParameterName = "@StubPaidinAdvanceYNText", Value = note.StubPaidinAdvanceYNText };
                SqlParameter p120 = new SqlParameter { ParameterName = "@ModelFinancingDrawsForFutureFundingsText", Value = note.ModelFinancingDrawsForFutureFundingsText };
                SqlParameter p121 = new SqlParameter { ParameterName = "@IncludeServicingPaymentOverrideinLevelYieldText", Value = note.IncludeServicingPaymentOverrideinLevelYieldText };
                SqlParameter p122 = new SqlParameter { ParameterName = "@RoundingMethodText", Value = note.RoundingMethodText };
                SqlParameter p123 = new SqlParameter { ParameterName = "@StubOnFFText", Value = note.StubOnFFtext };
                SqlParameter p124 = new SqlParameter { ParameterName = "@ExitFeeAmortCheckText", Value = note.ExitFeeAmortCheckText };
                SqlParameter p125 = new SqlParameter { ParameterName = "@FixedAmortScheduleText", Value = note.FixedAmortScheduleText };
                SqlParameter p126 = new SqlParameter { ParameterName = "@TotalCommitmentExtensionFeeisBasedOn", Value = note.TotalCommitmentExtensionFeeisBasedOn };
                SqlParameter p127 = new SqlParameter { ParameterName = "@newnoteId", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23,
                                                            p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41,p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59,
                                                            p60, p61, p62, p63, p64, p65, p66, p67, p68, p69, p70, p71, p72, p73, p74, p75, p76, p77, p78, p79,
                                                            p80, p81, p82, p83, p84, p85, p86, p87, p88, p89, p90, p91, p92, p93, p94, p95, p96, p97, p98, p99, p100, p101,
                                                            p102, p103, p104, p105, p106, p107, p108, p109, p110, p111, p112, p113, p114, p115, p116, p117, p118, p119, p120,
                                                            p121, p122, p123, p124, p125, p126, p127 };
                var res = hp.ExecuteScalar("dbo.usp_AddUpdateNoteFromCalculatorService", sqlparam);
                Newnoteid = Convert.ToString(p127.Value);

                if (res != 0)
                {
                    count = count + 1;
                }
                else
                { count = 0; }

                DataTable dt = new DataTable();
                Helper.Helper hpl1 = new Helper.Helper();
                SqlParameter hp1 = new SqlParameter { ParameterName = "@Name", Value = "note" };
                SqlParameter hp2 = new SqlParameter { ParameterName = "@ParentID", Value = 27 };
                SqlParameter hp3 = new SqlParameter { ParameterName = "@LookupID", Value = null };
                SqlParameter[] sqlparamhp1 = new SqlParameter[] { hp1, hp2, hp3 };
                dt = hpl1.ExecDataTable("dbo.usp_GetLookupByNameAndParentID", sqlparamhp1);

                int? lookupid = null;
                if (dt != null && dt.Rows.Count > 0)
                {
                    lookupid = Convert.ToInt32(dt.Rows[0]["LookupID"]);
                    //Save in App.Object table
                    Helper.Helper hpl = new Helper.Helper();
                    SqlParameter pr1 = new SqlParameter { ParameterName = "@ObjectID", Value = new Guid(Newnoteid) };
                    SqlParameter pr2 = new SqlParameter { ParameterName = "@ObjectTypeID", Value = lookupid };
                    SqlParameter pr3 = new SqlParameter { ParameterName = "@CreatedBy", Value = note.CreatedBy };
                    SqlParameter pr4 = new SqlParameter { ParameterName = "@UpdatedBy", Value = note.UpdatedBy };
                    SqlParameter[] sqlparam1 = new SqlParameter[] { pr1, pr2, pr3, pr4 };
                    hpl.ExecNonquery("App.usp_AddUpdateObject", sqlparam);
                }

                //=================
            }

            if (count == 1)
                return Newnoteid.ToString();
            else
                return count.ToString();
        }

        public List<NotePeriodicOutputsDataContract> GetNotePeriodicCalcByNoteId(Guid? noteid, Guid? AnalysisID)
        {
            try
            {
                DataTable dt = new DataTable();
                List<NotePeriodicOutputsDataContract> _notePeriodicOutputsDataContractList = new List<NotePeriodicOutputsDataContract>();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ScenarioId", Value = AnalysisID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetNotePeriodicCalcByNoteId", sqlparam);

                // var PeriodicCalcList = dbContext.usp_GetNotePeriodicCalcByNoteId(noteid, AnalysisID);

                foreach (DataRow dr in dt.Rows)
                {
                    NotePeriodicOutputsDataContract _notePeriodicOutputsDataContract = new NotePeriodicOutputsDataContract();

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
                    _notePeriodicOutputsDataContract.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    _notePeriodicOutputsDataContract.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    _notePeriodicOutputsDataContract.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    _notePeriodicOutputsDataContract.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    _notePeriodicOutputsDataContract.OrigFeeAccrual = CommonHelper.ToDecimal(dr["OrigFeeAccrual"]);
                    _notePeriodicOutputsDataContract.DiscountPremiumAccrual = CommonHelper.ToDecimal(dr["DiscountPremiumAccrual"]);
                    _notePeriodicOutputsDataContract.ExitFeeAccrual = CommonHelper.ToDecimal(dr["ExitFeeAccrual"]);
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
                    if (Convert.ToString(dr["AnalysisID"]) != "")
                    {
                        _notePeriodicOutputsDataContract.AnalysisID = new Guid(Convert.ToString(dr["AnalysisID"]));
                    }
                    _notePeriodicOutputsDataContract.FeeStrippedforthePeriod = CommonHelper.ToDecimal(dr["FeeStrippedforthePeriod"]);
                    _notePeriodicOutputsDataContract.PIKInterestPercentage = CommonHelper.ToDecimal(dr["PIKInterestPercentage"]);
                    _notePeriodicOutputsDataContract.InterestSuspenseAccountActivityforthePeriod = CommonHelper.ToDecimal(dr["InterestSuspenseAccountActivityforthePeriod"]);
                    _notePeriodicOutputsDataContract.InterestSuspenseAccountBalance = CommonHelper.ToDecimal(dr["InterestSuspenseAccountBalance"]);
                    _notePeriodicOutputsDataContract.CalculationStatus = Convert.ToString(dr["CalculationStatus"]);
                    _notePeriodicOutputsDataContract.AllInBasisValuation = CommonHelper.ToDecimal(dr["AllInBasisValuation"]);
                    _notePeriodicOutputsDataContract.AllInPIKRate = CommonHelper.ToDecimal(dr["AllInPIKRate"]);
                    _notePeriodicOutputsDataContract.CurrentPeriodPIKInterestAccrualPeriodEnddate = CommonHelper.ToDecimal(dr["CurrentPeriodPIKInterestAccrualPeriodEnddate"]);
                    _notePeriodicOutputsDataContract.PIKInterestPaidForThePeriod = CommonHelper.ToDecimal(dr["PIKInterestPaidForThePeriod"]);
                    _notePeriodicOutputsDataContract.PIKInterestAppliedForThePeriod = CommonHelper.ToDecimal(dr["PIKInterestAppliedForThePeriod"]);

                    _notePeriodicOutputsDataContract.EndingPreCapPVBasis = CommonHelper.ToDecimal(dr["EndingPreCapPVBasis"]);
                    _notePeriodicOutputsDataContract.LevelYieldIncomeForThePeriod = CommonHelper.ToDecimal(dr["LevelYieldIncomeForThePeriod"]);
                    _notePeriodicOutputsDataContract.PVAmortTotalIncomeMethod = CommonHelper.ToDecimal(dr["PVAmortTotalIncomeMethod"]);
                    _notePeriodicOutputsDataContract.EndingCleanCostLY = CommonHelper.ToDecimal(dr["EndingCleanCostLY"]);
                    _notePeriodicOutputsDataContract.EndingAccumAmort = CommonHelper.ToDecimal(dr["EndingAccumAmort"]);
                    _notePeriodicOutputsDataContract.PVAmortForThePeriod = CommonHelper.ToDecimal(dr["PVAmortForThePeriod"]);
                    _notePeriodicOutputsDataContract.EndingSLBasis = CommonHelper.ToDecimal(dr["EndingSLBasis"]);
                    _notePeriodicOutputsDataContract.SLAmortForThePeriod = CommonHelper.ToDecimal(dr["SLAmortForThePeriod"]);
                    _notePeriodicOutputsDataContract.SLAmortOfTotalFeesInclInLY = CommonHelper.ToDecimal(dr["SLAmortOfTotalFeesInclInLY"]);
                    _notePeriodicOutputsDataContract.SLAmortOfDiscountPremium = CommonHelper.ToDecimal(dr["SLAmortOfDiscountPremium"]);
                    _notePeriodicOutputsDataContract.SLAmortOfCapCost = CommonHelper.ToDecimal(dr["SLAmortOfCapCost"]);
                    _notePeriodicOutputsDataContract.EndingAccumSLAmort = CommonHelper.ToDecimal(dr["EndingAccumSLAmort"]);
                    _notePeriodicOutputsDataContract.EndingPreCapGAAPBasis = CommonHelper.ToDecimal(dr["EndingPreCapGAAPBasis"]);
                    _notePeriodicOutputsDataContract.PIKPrincipalPaidForThePeriod = CommonHelper.ToDecimal(dr["PIKPrincipalPaidForThePeriod"]);

                    _notePeriodicOutputsDataContractList.Add(_notePeriodicOutputsDataContract);
                }

                return _notePeriodicOutputsDataContractList;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }



        public List<TransactionEntryDataContract> GetTransactionEntryByNoteId(Guid? noteid, Guid? AnalysisID)
        {
            DataTable dt = new DataTable();
            List<TransactionEntryDataContract> _transactionEntryDataContractList = new List<TransactionEntryDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ScenarioId", Value = AnalysisID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetTransactionEntryByNoteId", sqlparam);
            // var TransactionEntryList = dbContext.usp_GetTransactionEntryByNoteId(noteid, AnalysisID);
            foreach (DataRow dr in dt.Rows)
            {
                TransactionEntryDataContract _transactionEntryDataContract = new TransactionEntryDataContract();

                _transactionEntryDataContract.Date = CommonHelper.ToDateTime(dr["Date"]);
                _transactionEntryDataContract.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                _transactionEntryDataContract.Type = Convert.ToString(dr["Type"]);
                _transactionEntryDataContract.FeeName = Convert.ToString(dr["FeeName"]);
                _transactionEntryDataContract.LIBORPercentage = CommonHelper.ToDecimal(dr["LIBORPercentage"]);
                _transactionEntryDataContract.PIKInterestPercentage = CommonHelper.ToDecimal(dr["PIKInterestPercentage"]);
                _transactionEntryDataContract.SpreadPercentage = CommonHelper.ToDecimal(dr["SpreadPercentage"]);
                _transactionEntryDataContract.TransactionDateByRule = CommonHelper.ToDateTime(dr["TransactionDateByRule"]);
                _transactionEntryDataContract.DueDate = CommonHelper.ToDateTime(dr["DueDate"]);
                _transactionEntryDataContract.RemitDate = CommonHelper.ToDateTime(dr["RemitDate"]);
                _transactionEntryDataContract.TransactionCategory = Convert.ToString(dr["TransactionCategory"]);
                _transactionEntryDataContract.Comment = Convert.ToString(dr["Comment"]);

                _transactionEntryDataContractList.Add(_transactionEntryDataContract);
            }
            return _transactionEntryDataContractList;
        }
        public DataTable GetNotePeriodicCalcDynamicByNoteId(Guid? noteid)
        {
            DataTable dt = new DataTable();

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetNotePeriodicCalcDynamicByNoteId", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            return dt;
        }



        public void InsertNoteFutureFunding(List<PayruleTargetNoteFundingScheduleDataContract> NoteFundings, string username)
        {
#pragma warning disable CS0219 // The variable 'status' is assigned but its value is never used
            string status = "";
#pragma warning restore CS0219 // The variable 'status' is assigned but its value is never used
            Helper.Helper hp = new Helper.Helper();
            DataTable dNoteFundings = new DataTable();

            dNoteFundings.Columns.Add("NoteID");
            dNoteFundings.Columns.Add("Value");
            dNoteFundings.Columns.Add("Date");
            dNoteFundings.Columns.Add("PurposeID");
            dNoteFundings.Columns.Add("AccountId");
            dNoteFundings.Columns.Add("Applied");
            dNoteFundings.Columns.Add("DrawFundingId");
            dNoteFundings.Columns.Add("Comments");
            dNoteFundings.Columns.Add("DealFundingRowno");
            dNoteFundings.Columns.Add("isDeleted");
            dNoteFundings.Columns.Add("WF_CurrentStatus");
            dNoteFundings.Columns.Add("GeneratedBy");
            //dNoteFundings.Columns.Add("EventId");
            //dNoteFundings.Columns.Add("CreatedDate");
            //dNoteFundings.Columns.Add("CreatedBy");
            //dNoteFundings.Columns.Add("UpdatedDate");
            //dNoteFundings.Columns.Add("UpdatedBy");

            if (NoteFundings != null)
            {
                DataTable dt = new DataTable();
                dt = ObjToDataTable.ToDataTable(NoteFundings);

                foreach (DataRow dr in dt.Rows)
                {
                    dNoteFundings.ImportRow(dr);
                }
            }

            if (dNoteFundings.Rows.Count > 0)
            {
                //hp.BatchUpdateOrInsertDealFunding("usp_InsertUpdateFundingSchedule", dNoteFundings, username, "notefunding", true);
                hp.BatchUpdateOrInsertDealFunding("dbo.usp_InsertUpdateFundingSchedule", dNoteFundings, username, "notefunding", true);
            }
        }

        public string ExportFutureFundingFromNote(List<FutureFundingScheduleTab> NoteFundings, string username)
        {
            string status = "success";
            Helper.Helper hp = new Helper.Helper();
            DataTable dNoteFundings = new DataTable();

            dNoteFundings.Columns.Add("NoteID");
            dNoteFundings.Columns.Add("Value");
            dNoteFundings.Columns.Add("Date");
            dNoteFundings.Columns.Add("PurposeID");
            dNoteFundings.Columns.Add("AccountId");
            dNoteFundings.Columns.Add("Applied");
            dNoteFundings.Columns.Add("DrawFundingId");
            dNoteFundings.Columns.Add("Comments");
            dNoteFundings.Columns.Add("DealFundingRowno");
            dNoteFundings.Columns.Add("isDeleted");
            dNoteFundings.Columns.Add("WF_CurrentStatus");
            dNoteFundings.Columns.Add("GeneratedBy");
            //dNoteFundings.Columns.Add("EventId");
            //dNoteFundings.Columns.Add("CreatedDate");
            //dNoteFundings.Columns.Add("CreatedBy");
            //dNoteFundings.Columns.Add("UpdatedDate");
            //dNoteFundings.Columns.Add("UpdatedBy");

            if (NoteFundings != null)
            {
                DataTable dt = new DataTable();
                dt = ObjToDataTable.ToDataTable(NoteFundings);

                foreach (DataRow dr in dt.Rows)
                {
                    dNoteFundings.ImportRow(dr);
                }
            }

            if (dNoteFundings.Rows.Count > 0)
            {
                status = hp.InsertFFBackshop("dbo.usp_ExportFutureFundingFromCRES", dNoteFundings, username, "notefunding", true);
            }

            return status;
        }

        public string ExportFutureFundingFromCRES(List<PayruleTargetNoteFundingScheduleDataContract> NoteFundings, string username)
        {
            string status = "success";
            Helper.Helper hp = new Helper.Helper();
            DataTable dNoteFundings = new DataTable();

            dNoteFundings.Columns.Add("NoteID");
            dNoteFundings.Columns.Add("Value");
            dNoteFundings.Columns.Add("Date");
            dNoteFundings.Columns.Add("PurposeID");
            dNoteFundings.Columns.Add("AccountId");
            dNoteFundings.Columns.Add("Applied");
            dNoteFundings.Columns.Add("DrawFundingId");
            dNoteFundings.Columns.Add("Comments");
            dNoteFundings.Columns.Add("DealFundingRowno");
            dNoteFundings.Columns.Add("isDeleted");
            dNoteFundings.Columns.Add("WF_CurrentStatus");
            dNoteFundings.Columns.Add("GeneratedBy");
            //dNoteFundings.Columns.Add("EventId");
            //dNoteFundings.Columns.Add("CreatedDate");
            //dNoteFundings.Columns.Add("CreatedBy");
            //dNoteFundings.Columns.Add("UpdatedDate");
            //dNoteFundings.Columns.Add("UpdatedBy");

            if (NoteFundings != null)
            {
                DataTable dt = new DataTable();
                dt = ObjToDataTable.ToDataTable(NoteFundings);

                foreach (DataRow dr in dt.Rows)
                {
                    dNoteFundings.ImportRow(dr);
                }
            }

            if (dNoteFundings.Rows.Count > 0)
            {
                status = hp.InsertFFBackshop("dbo.usp_ExportFutureFundingFromCRES", dNoteFundings, username, "notefunding", true);
            }

            return status;
        }

        public string GetOrCreateNoteByCRENoteId(string CRENoteID, Guid? DealID, string UserName)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@CRENoteID", Value = CRENoteID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = UserName };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UserName", Value = DealID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            var res = hp.ExecuteScalar("dbo.usp_GetOrCreateNoteByCRENoteId", sqlparam);
            // var res = dbContext.usp_GetOrCreateNoteByCRENoteId(CRENoteID, DealID, UserName);
            return Convert.ToString(res);
        }

        public bool CheckDuplicateNote(NoteDataContract _noteDC)
        {

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@CRENoteID", Value = _noteDC.CRENoteID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@NoteName", Value = _noteDC.Name };
            SqlParameter p3 = new SqlParameter { ParameterName = "@DealId", Value = _noteDC.DealID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            var res = hp.ExecuteScalar("dbo.usp_CheckDuplicateNote", sqlparam);
            // var res = dbContext.usp_CheckDuplicateNote(_noteDC.CRENoteID, _noteDC.Name, _noteDC.DealID).FirstOrDefault();

            return string.IsNullOrEmpty(Convert.ToString(res)) ? false : Convert.ToBoolean(res);
        }

        public List<LiborScheduleTab> GetLiborScheduleTabListDataForCalcByNoteId(Guid? noteid, int IndexNameID, Guid? userID, Guid? AnalysisID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));

            DataTable dt = new DataTable();
            List<LiborScheduleTab> _liborScheduleTabList = new List<LiborScheduleTab>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@IndexNameID", Value = IndexNameID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter p5 = new SqlParameter { ParameterName = "@PageIndex", Value = pageIndex };
            SqlParameter p6 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p7 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7 };
            dt = hp.ExecDataTable("dbo.usp_GetLiborScheduleDataForCalcByNoteId", sqlparam);
            //var LiborScheduleTab = dbContext.usp_GetLiborScheduleDataForCalcByNoteId(noteid, IndexNameID, userID, AnalysisID, pageIndex, pageSize, totalCount);
            TotalCount = string.IsNullOrEmpty(Convert.ToString(p7.Value)) ? 0 : Convert.ToInt32(p7.Value);

            foreach (DataRow dr in dt.Rows)
            {
                LiborScheduleTab _liborScheduleTab = new DataContract.LiborScheduleTab();

                _liborScheduleTab.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                _liborScheduleTab.Date = CommonHelper.ToDateTime(dr["dates"]);
                _liborScheduleTab.Value = CommonHelper.ToDecimal(dr["Value"]);
                _liborScheduleTab.IndexType = Convert.ToString(dr["IndexType"]);
                _liborScheduleTabList.Add(_liborScheduleTab);
            }
            return _liborScheduleTabList;
        }

        public void InsertCashflowTransaction(List<TransactionEntry> _lsttransactionEntryDC, string NoteId, string CreatedBy)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dtTranscation = new DataTable();
            dtTranscation.Columns.Add("Type");
            dtTranscation.Columns.Add("Date");
            dtTranscation.Columns.Add("Amount");
            dtTranscation.Columns.Add("AnalysisID");
            dtTranscation.Columns.Add("FeeName");
            dtTranscation.Columns.Add("FeeTypeName");
            dtTranscation.Columns.Add("Comment");
            dtTranscation.Columns.Add("PaymentDateNotAdjustedforWorkingDay");
            dtTranscation.Columns.Add("PurposeType");
            dtTranscation.Columns.Add("TransactionDateByRule");
            dtTranscation.Columns.Add("TransactionDateServicingLog");
            dtTranscation.Columns.Add("RemittanceDate");

            if (_lsttransactionEntryDC != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(_lsttransactionEntryDC);

                foreach (DataRow dr in dt.Rows)
                {
                    dtTranscation.ImportRow(dr);
                }
            }

            if (dtTranscation.Rows.Count > 0)
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@TableTypeTransactionEntry", Value = dtTranscation };
                SqlParameter p2 = new SqlParameter { ParameterName = "@NoteId", Value = new Guid(NoteId) };
                SqlParameter p3 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                hp.ExecDataTablewithparams("dbo.usp_InsertTransactionEntry", sqlparam);
            }
        }

        public void InsertPIKDistributions(List<PIKDistributionsDataContract> _listPIKDistributionsDC, string CreatedBy)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dtPikDistribution = new DataTable();
            dtPikDistribution.Columns.Add("SourceNoteID");
            dtPikDistribution.Columns.Add("ReceiverNoteID");
            dtPikDistribution.Columns.Add("TransactionDate");
            dtPikDistribution.Columns.Add("Amount");

            if (_listPIKDistributionsDC != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(_listPIKDistributionsDC);

                foreach (DataRow dr in dt.Rows)
                {
                    dtPikDistribution.ImportRow(dr);
                }
            }

            if (dtPikDistribution.Rows.Count > 0)
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@tblPIKDistributions", Value = dtPikDistribution };
                SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecDataTablewithparams("dbo.usp_InsertPIKDistributions", sqlparam);
            }
        }

        public void importsourcetodw()
        {
            Helper.Helper hp = new Helper.Helper();
            hp.ExecuteScalar("DW.usp_DeltaJob");
        }

        public void refreshentitydatatodw()
        {
            Helper.Helper hp = new Helper.Helper();
            hp.ExecuteScalar("DW.usp_DeltaJobEntity");
        }

        public void GetExecuteProcedureNightly(int? isButtonClick)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@isButtonClick", Value = isButtonClick };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            hp.ExecDataTablewithparams("DW.usp_DeltaJobBS", sqlparam);

        }

        public void ExecuteProcedureOnesInADay()
        {
            Helper.Helper hp = new Helper.Helper();
            hp.ExecuteScalar("DW.usp_Calculations_CalendarBI");
        }

        public DataTable GetNoteCashflowsExportData(Guid? noteid, Guid? dealid, Guid? AnalysisID, string MutipleNote)
        {
            DataTable dt = new DataTable();

            try
            {
                if (MutipleNote != "")
                {
                    MutipleNote = MutipleNote.Remove(MutipleNote.Length - 1, 1);
                }
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@DealId", Value = dealid };
                SqlParameter p3 = new SqlParameter { ParameterName = "@ScenarioId", Value = AnalysisID };
                //   SqlParameter p4 = new SqlParameter { ParameterName = "@PortfolioId", Value = PortfolioId };
                SqlParameter p4 = new SqlParameter { ParameterName = "@MultipleNoteids", Value = MutipleNote };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
                dt = hp.ExecDataTable("dbo.usp_GetNoteCashflowsExportData", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }


        public DataTable GetNoteCashflowsExportData(DownloadCashFlowDataContract downloadCashFlow)
        {
            DataTable dt = new DataTable();

            try
            {
                if (!(downloadCashFlow.MutipleNoteId == "" || downloadCashFlow.MutipleNoteId == null))
                {
                    downloadCashFlow.MutipleNoteId = downloadCashFlow.MutipleNoteId.Remove(downloadCashFlow.MutipleNoteId.Length - 1, 1);
                }
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = downloadCashFlow.NoteId };
                SqlParameter p2 = new SqlParameter { ParameterName = "@DealId", Value = downloadCashFlow.DealID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@ScenarioId", Value = downloadCashFlow.AnalysisID };
                //   SqlParameter p4 = new SqlParameter { ParameterName = "@PortfolioId", Value = PortfolioId };
                SqlParameter p4 = new SqlParameter { ParameterName = "@MultipleNoteids", Value = downloadCashFlow.MutipleNoteId };
                SqlParameter p5 = new SqlParameter { ParameterName = "@PortfolioMasterGuid", Value = downloadCashFlow.PortfolioMasterGuid };
                SqlParameter p6 = new SqlParameter { ParameterName = "@CountOnDropDownFilter", Value = downloadCashFlow.CountOnDropDownFilter };
                SqlParameter p7 = new SqlParameter { ParameterName = "@CountOnGridFilter", Value = downloadCashFlow.CountOnGridFilter };
                SqlParameter p8 = new SqlParameter { ParameterName = "@TransactionCategoryName", Value = downloadCashFlow.TransactionCategoryName };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8 };
                dt = hp.ExecDataTable("usp_GetNoteCashflowsExportData", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return dt;
        }

        public void InsertNoteTransactionDetail(List<ServicingLogTab> _lstCalcValDC, string NoteId, string CreatedBy)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dtntd = new DataTable();
            dtntd.Columns.Add("TransactionTypeText");
            dtntd.Columns.Add("TransactionDate");
            dtntd.Columns.Add("TransactionAmount");
            dtntd.Columns.Add("RelatedtoModeledPMTDate");

            if (_lstCalcValDC != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(_lstCalcValDC);

                foreach (DataRow dr in dt.Rows)
                {
                    dtntd.ImportRow(dr);
                }
            }

            if (dtntd.Rows.Count > 0)
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@TableTypeNoteTransactionDetail", Value = dtntd };
                SqlParameter p2 = new SqlParameter { ParameterName = "@NoteId", Value = new Guid(NoteId) };
                SqlParameter p3 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                hp.ExecDataTablewithparams("dbo.usp_NoteTransactionDetail", sqlparam);
            }
        }

        //applied changes
        public List<ServicingLogTab> GetNoteTransactionDetailByNoteID(string NoteID, Guid? Analysisid)
        {
            try
            {
                //added comment 
                DataTable dt = new DataTable();
                List<ServicingLogTab> lstserviceinglog = new List<ServicingLogTab>();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = NoteID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Analysisid", Value = Analysisid };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetServicingLogByNoteID", sqlparam);
                // var slist = dbContext.usp_GetServicingLogByNoteID(NoteID).ToList();

                foreach (DataRow dr in dt.Rows)
                {
                    ServicingLogTab ServicingLog = new ServicingLogTab();
                    ServicingLog.TransactionAmount = CommonHelper.ToDecimal(dr["Amount"]);
                    ServicingLog.TransactionDate = CommonHelper.ToDateTime(dr["TransactionDate"]);
                    ServicingLog.TransactionTypeText = Convert.ToString(dr["Name"]);
                    ServicingLog.RelatedtoModeledPMTDate = CommonHelper.ToDateTime(dr["RelatedtoModeledPMTDate"]);
                    ServicingLog.Adjustment = CommonHelper.ToDecimal(dr["Adjustment"]);
                    ServicingLog.UsedInFeeRecon = CommonHelper.ToDecimal(dr["UsedInFeeRecon"]);
                    ServicingLog.ActualDelta = CommonHelper.ToDecimal(dr["ActualDelta"]);

                    ServicingLog.TransactionDateByRule = CommonHelper.ToDateTime(dr["TransactionDateByRule"]);
                    ServicingLog.TransactionDateServicingLog = CommonHelper.ToDateTime(dr["TransactionDateServicingLog"]);
                    ServicingLog.RemittanceDate = CommonHelper.ToDateTime(dr["RemittanceDate"]);

                    lstserviceinglog.Add(ServicingLog);
                }
                return lstserviceinglog;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<PayruleNoteDetailFundingDataContract> GetNotesForPayruleCalculationByDealID(String dealID, Guid? userID, int? pgeIndex, int? pageSize, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            List<PayruleNoteDetailFundingDataContract> lstNoteDC = new List<PayruleNoteDetailFundingDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealId", Value = dealID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = pgeIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetNotesFromDealDetailByDealID", sqlparam);

            // var lstNote1 = dbContext.usp_GetNotesFromDealDetailByDealID(dealID, userID, pgeIndex, pageSize, totalCount);
            // var lstNote = lstNote1.ToList();
            TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            foreach (DataRow dr in dt.Rows)
            {
                PayruleNoteDetailFundingDataContract _notedc = new PayruleNoteDetailFundingDataContract();
                if (Convert.ToString(dr["NoteID"]) != "")
                {
                    _notedc.NoteID = new Guid(Convert.ToString(dr["NoteID"]));
                }
                _notedc.CRENoteID = Convert.ToString(dr["CRENoteID"]);
                _notedc.NoteName = Convert.ToString(dr["Name"]);
                _notedc.UseRuletoDetermineNoteFunding = CommonHelper.ToInt32(dr["UseRuletoDetermineNoteFunding"]);
                _notedc.UseRuletoDetermineNoteFundingText = Convert.ToString(dr["UseRuletoDetermineNoteFundingText"]);
                _notedc.NoteFundingRule = CommonHelper.ToInt32(dr["NoteFundingRule"]);
                _notedc.NoteFundingRuleText = Convert.ToString(dr["NoteFundingRuleText"]);
                _notedc.NoteBalanceCap = CommonHelper.ToDecimal(dr["NoteBalanceCap"]);
                _notedc.FundingPriority = CommonHelper.ToInt32(dr["FundingPriority"]);
                _notedc.RepaymentPriority = CommonHelper.ToInt32(dr["RepaymentPriority"]);
                _notedc.TotalCommitment = CommonHelper.ToDecimal(dr["TotalCommitment"]);
                _notedc.CommitmentUsedInFFDistribution = CommonHelper.ToDecimal(dr["CommitmentUsedinFFDistribution"]);
                lstNoteDC.Add(_notedc);
            }

            return lstNoteDC;
        }

        public DataTable DownloadNoteDataTape(int withoutSpread)
        {
            DataTable dt = new DataTable();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@withoutSpread", Value = withoutSpread };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_DownloadNoteDataTape", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return dt;
        }

        public List<NoteDataContract> SearchNoteByCRENoteId(NoteDataContract _noteDC)
        {
            DataTable dt = new DataTable();
            List<NoteDataContract> lstNoteDC = new List<NoteDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@CRENoteId", Value = _noteDC.CRENoteID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_SearchNoteByCRENoteId", sqlparam);
            // var lstNote = GetAll(x => x.DealID);
            //    IEnumerable<usp_GetAllNotesByDealId_Result> lstNote =dbContext.usp_GetAllNotesByDealId(DealId);

            // var lstNote1 = dbContext.usp_SearchNoteByCRENoteId(_noteDC.CRENoteID);
            // var lstNote = lstNote1.ToList();
            foreach (DataRow dr in dt.Rows)
            {
                NoteDataContract _notedc = new NoteDataContract();
                _notedc.NoteId = Convert.ToString(dr["NoteID"]);
                _notedc.Name = Convert.ToString(dr["Name"]);
                _notedc.DealID = Convert.ToString(dr["DealID"]);
                _notedc.DealName = Convert.ToString(dr["DealName"]);
                _notedc.CRENoteID = Convert.ToString(dr["CRENoteID"]);
                _notedc.RateType = CommonHelper.ToInt32(dr["RateType"]);
                _notedc.RateTypeText = Convert.ToString(dr["RateTypeText"]);
                _notedc.ClosingDate = CommonHelper.ToDateTime(dr["ClosingDate"]);
                _notedc.StatusID = CommonHelper.ToInt32(dr["StatusID"]);
                _notedc.StatusName = Convert.ToString(Convert.ToInt32(dr["StatusID"]) == 1 ? "Active" : "InActive");
                lstNoteDC.Add(_notedc);
            }

            return lstNoteDC;
        }

        public List<ActivityLogDataContract> GetActivityLogByModuleId(string userID, ActivityLogDataContract _activityDC, int? pageIndx, int? pageSize, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            List<ActivityLogDataContract> lstActivityDC = new List<ActivityLogDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID.ToString() };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ObjectID", Value = _activityDC.ModuleID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@ObjectTypeID", Value = _activityDC.ModuleTypeID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndx };
            SqlParameter p5 = new SqlParameter { ParameterName = "@pageSize", Value = pageSize };
            SqlParameter p6 = new SqlParameter { ParameterName = "@Currentdate", Value = _activityDC.Currentdate };
            SqlParameter p7 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7 };
            dt = hp.ExecDataTable("dbo.usp_GetActivityLogByObjectID", sqlparam);
            // var lstNote = GetAll(x => x.DealID);
            //    IEnumerable<usp_GetAllNotesByDealId_Result> lstNote =dbContext.usp_GetAllNotesByDealId(DealId);

            //ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            // var lstNote1 = dbContext.usp_GetActivityLogByObjectID(userID.ToString(), _activityDC.ModuleID, _activityDC.ModuleTypeID, pageIndx, pageSize, _activityDC.Currentdate, totalCount).ToList();
            TotalCount = string.IsNullOrEmpty(Convert.ToString(p7.Value)) ? 0 : Convert.ToInt32(p7.Value);
            foreach (DataRow dr in dt.Rows)
            {
                ActivityLogDataContract _activitydc = new ActivityLogDataContract();
                _activitydc.UserName = Convert.ToString(dr["UserName"]);
                _activitydc.ActivityType = Convert.ToString(dr["AcitivityTypeText"]);
                _activitydc.ActivityMessage = Convert.ToString(dr["Message"]);
                _activitydc.DisplayMessage = Convert.ToString(dr["DisplayMessage"]);
                _activitydc.ActivityUserFirstLetter = Convert.ToString(dr["ActivityByFirstLetter"]);
                _activitydc.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                _activitydc.UColor = Convert.ToString(dr["UColor"]);
                _activitydc.Currentdate = Convert.ToString(dr["CurrentDate"]);

                lstActivityDC.Add(_activitydc);
            }
            return lstActivityDC;
        }

        public List<HolidayListDataContract> GetHolidayList()
        {
            DataTable dt = new DataTable();
            List<HolidayListDataContract> lstHoliday = new List<HolidayListDataContract>();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetHolidayList");
            // var res = dbContext.usp_GetHolidayList().ToList();

            foreach (DataRow dr in dt.Rows)
            {
                HolidayListDataContract Holidaydc = new HolidayListDataContract();
                Holidaydc.HolidayDate = CommonHelper.ToDateTime(dr["HoliDayDate"]);
                Holidaydc.HolidayTypeID = Convert.ToInt32(dr["HoliDayTypeID"]);
                Holidaydc.HolidayTypeText = Convert.ToString(dr["HolidayTypeText"]);
                lstHoliday.Add(Holidaydc);
            }
            return lstHoliday;
        }

        public List<HolidayListDataContract> GetHolidayListForCalculator()
        {
            DataTable dt = new DataTable();
            List<HolidayListDataContract> lstHoliday = new List<HolidayListDataContract>();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetHolidayList");
            foreach (DataRow dr in dt.Rows)
            {
                HolidayListDataContract Holidaydc = new HolidayListDataContract();
                Holidaydc.HolidayDate = CommonHelper.ToDateTime(dr["HoliDayDate"]);
                Holidaydc.HolidayTypeID = Convert.ToInt32(dr["HoliDayTypeID"]);

                if (Convert.ToString(dr["HolidayTypeText"]) != "")
                {
                    if (Convert.ToString(dr["HolidayTypeText"]).ToLower() == ("US").ToLower())
                    {
                        Holidaydc.HolidayTypeText = "PMT Date";
                    }
                    else if (Convert.ToString(dr["HolidayTypeText"]).ToLower() == ("UK").ToLower())
                    {
                        Holidaydc.HolidayTypeText = "Index Date";
                    }
                    else
                    {
                        Holidaydc.HolidayTypeText = Convert.ToString(dr["HolidayTypeText"]);
                    }
                }

                lstHoliday.Add(Holidaydc);
            }
            return lstHoliday;
        }

        public NoteAllScheduleLatestRecordDataContract GetLastUpdatedDateAndUpdatedByForSchedule(Guid? noteid, string ModuleName)
        {
            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));

            //  var _allScheduleList = dbContext.usp_GetLastUpdatedDateAndUpdatedByForSchedule(noteid, ModuleName).ToList();
            DataTable dt = new DataTable();
            NoteAllScheduleLatestRecordDataContract _noteAllSch = new NoteAllScheduleLatestRecordDataContract();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectID", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ModuleName", Value = ModuleName };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetLastUpdatedDateAndUpdatedByForSchedule", sqlparam);
            //Set Effective dates
            foreach (DataRow dr in dt.Rows)
            {
                if (Convert.ToString(dr["ScheduleType"]).ToLower() == "fundingschedule")
                {
                    _noteAllSch.LastUpdatedBy_FF = Convert.ToString(dr["LastUpdatedBy"]);
                    _noteAllSch.LastUpdatedDate_FF = CommonHelper.ToDateTime(dr["LastUpdatedDate"]);
                    _noteAllSch.LastUpdatedDate_String_FF = Convert.ToString(dr["LastUpdatedDate_String"]);
                }
            }
            return _noteAllSch;
        }

        public void AddUpdateNoteRuleByNoteId(NoteDataContract _noteDC, Guid? UserID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = _noteDC.NoteId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@NoteRule", Value = _noteDC.NoteRule };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            hp.ExecNonquery("dbo.usp_AddUpdateNoteRuleByNoteId", sqlparam);
            //dbContext.usp_AddUpdateNoteRuleByNoteId(_noteDC.NoteId, UserID, _noteDC.NoteRule);
        }

        public List<FFutureFundingScheduleTab> GetInputFutureFundingScheduleListDataByNoteId(Guid? noteid, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            try
            {
                // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
                DataTable dt = new DataTable();
                List<FFutureFundingScheduleTab> _futureFundingScheduleTabList = new List<FFutureFundingScheduleTab>();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@PageIndex", Value = pageIndex };
                SqlParameter p4 = new SqlParameter { ParameterName = "@ViewName", Value = pageSize };
                SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
                dt = hp.ExecDataTable("dbo.usp_GetFutureFundingScheduleDataByNoteId", sqlparam);
                //var FutureFundingScheduleTab = dbContext.usp_GetFutureFundingScheduleDataByNoteId(noteid, userID, pageIndex, pageSize, totalCount);
                TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
                foreach (DataRow dr in dt.Rows)
                {
                    FFutureFundingScheduleTab _futureFundingScheduleTab = new FFutureFundingScheduleTab();
                    _futureFundingScheduleTab.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                    _futureFundingScheduleTab.Date = CommonHelper.ToDateTime(dr["Date"]);
                    _futureFundingScheduleTab.Value = CommonHelper.ToDecimal(dr["Value"]);
                    _futureFundingScheduleTab.PurposeText = Convert.ToString(dr["PurposeText"]);
                    _futureFundingScheduleTabList.Add(_futureFundingScheduleTab);
                }
                return _futureFundingScheduleTabList;
            }
            catch (Exception ex)
            {
                throw new Exception("error in GetInputFutureFundingScheduleListDataByNoteId-noterepository" + ex.Message);
            }
        }

        public DataTable GetWellsViewsDataByDealID(string dealid, string viewName)
        {
            DataTable dt = new DataTable();

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@CREDealID", Value = dealid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ViewName", Value = viewName };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetWellsViewsDataByDealID", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            return dt;
        }

        public DataSet GetWellsViewsAllDataByDealID(string dealid)
        {
            DataTable dt = new DataTable();
            DataSet ds = new DataSet();

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@CREDealID", Value = dealid };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };

                ds = hp.ExecDataSet("dbo.usp_GetWellsViewsAllDataByDealID", sqlparam);

                //dt = hp.ExecDataTable("usp_GetWellsViewsDataByDealID", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            return ds;
        }

        public List<FLiborScheduleTab> GetLiborScheduleForFast()
        {
            DataTable dt = new DataTable();
            List<FLiborScheduleTab> _liborScheduleTabList = new List<FLiborScheduleTab>();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetLiborScheduleForFast");
            // var LiborScheduleTab = dbContext.usp_GetLiborScheduleForFast();
            foreach (DataRow dr in dt.Rows)
            {
                FLiborScheduleTab _liborScheduleTab = new FLiborScheduleTab();
                _liborScheduleTab.Date = CommonHelper.ToDateTime(dr["Date"]);
                _liborScheduleTab.Value = CommonHelper.ToDecimal(dr["Value"]);
                _liborScheduleTab.Indexoverrides = CommonHelper.ToDecimal(dr["indexoverridevalue"]);
                _liborScheduleTabList.Add(_liborScheduleTab);
            }
            return _liborScheduleTabList;
        }

        public List<NoteDataContract> GetAllNotes()
        {
            DataTable dt = new DataTable();
            List<NoteDataContract> lstNotes = new List<NoteDataContract>();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetAllNotes");
            // var notes = dbContext.usp_GetAllNotes();
            foreach (DataRow dr in dt.Rows)
            {
                NoteDataContract notedc = new NoteDataContract();
                notedc.NoteId = Convert.ToString(dr["NoteID"]);
                notedc.CRENoteID = Convert.ToString(dr["CRENoteID"]);

                lstNotes.Add(notedc);
            }
            return lstNotes;
        }

        public List<FeeSchedulesConfigDataContract> GetAllFeeTypesFromFeeSchedulesConfig()
        {
            DataTable dt = new DataTable();
            List<FeeSchedulesConfigDataContract> _FeeTypeList = new List<FeeSchedulesConfigDataContract>();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetAllFeeTypesFromFeeSchedulesConfig");
            // var feeTypeList = dbContext.usp_GetAllFeeTypesFromFeeSchedulesConfig();

            foreach (DataRow dr in dt.Rows)
            {
                FeeSchedulesConfigDataContract _feetype = new DataContract.FeeSchedulesConfigDataContract();
                _feetype.LookupID = CommonHelper.ToInt32(dr["FeeTypeNameID"]);
                _feetype.Name = Convert.ToString(dr["FeeTypeNameText"]);

                _FeeTypeList.Add(_feetype);
            }
            return _FeeTypeList;
        }

        public List<HistoricalAccrualDataContract> GetAccrualFieldsFromNotePeriodicByNoteID(Guid? NoteId, Guid? UserID, Guid? AnalysisID)
        {
            DataTable dt = new DataTable();
            List<HistoricalAccrualDataContract> _PeriodCloseArchiveList = new List<HistoricalAccrualDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = NoteId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID.ToString() };
            SqlParameter p3 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            dt = hp.ExecDataTable("dbo.usp_GetAccrualFieldsFromNotePeriodicByNoteID", sqlparam);
            // var _PeriodCloseArcList = dbContext.usp_GetAccrualFieldsFromNotePeriodicByNoteID(NoteId, UserID.ToString(), AnalysisID);
            foreach (DataRow dr in dt.Rows)
            {
                HistoricalAccrualDataContract _perClose = new DataContract.HistoricalAccrualDataContract();
                if (Convert.ToInt32(dr["PVBasis"]) + Convert.ToInt32(dr["DeferredFeeAccrual"]) + Convert.ToInt32(dr["DiscountPremiumAccrual"]) + Convert.ToInt32(dr["CapitalizedCostAccrual"]) != 0)


                // if (item.PVBasis.GetValueOrDefault(0) + item.DeferredFeeAccrual.GetValueOrDefault(0) + item.DiscountPremiumAccrual.GetValueOrDefault(0) + item.CapitalizedCostAccrual.GetValueOrDefault(0) != 0)
                {
#pragma warning disable CS0219 // The variable 'sum' is assigned but its value is never used
                    int sum = 0;
#pragma warning restore CS0219 // The variable 'sum' is assigned but its value is never used

                    if (Convert.ToString(dr["NoteID"]) != "")
                    {
                        _perClose.NoteID = new Guid(Convert.ToString("NoteID"));
                    }

                    _perClose.PeriodDate = CommonHelper.ToDateTime(dr["PeriodEndDate"]);
                    _perClose.PVBasis = CommonHelper.ToDecimal(dr["PVBasis"]);
                    _perClose.DeferredFeeAccrual = CommonHelper.ToDecimal(dr["DeferredFeeAccrual"]);
                    _perClose.DiscountPremiumAccrual = CommonHelper.ToDecimal(dr["DiscountPremiumAccrual"]);
                    _perClose.CapitalizedCostAccrual = CommonHelper.ToDecimal(dr["CapitalizedCostAccrual"]);
                    _perClose.AllInBasisValuation = CommonHelper.ToDecimal(dr["AllInBasisValuation"]);
                    _PeriodCloseArchiveList.Add(_perClose);
                }
            }
            return _PeriodCloseArchiveList;
        }

        public List<LookupMasterDataContract> GetLookupForMaster()
        {
            DataTable dt = new DataTable();
            List<LookupMasterDataContract> lookupMasterDC = new List<LookupMasterDataContract>();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetLookupForMaster");

            // var _lookupMasterlist = dbContext.usp_GetLookupForMaster();
            foreach (DataRow dr in dt.Rows)
            {
                LookupMasterDataContract lookupMaster = new LookupMasterDataContract();
                lookupMaster.LookupID = Convert.ToInt32(dr["LookupId"]);
                lookupMaster.Name = Convert.ToString(dr["Name"]);
                lookupMaster.Description = Convert.ToString(dr["Description"]);
                lookupMaster.SortOrder = Convert.ToInt32(dr["SortOrder"]);
                lookupMaster.ddlType = Convert.ToString(dr["ddlType"]);
                lookupMasterDC.Add(lookupMaster);
            }

            return lookupMasterDC;
        }


        public DevDashBoardDataContract GetNoteCalcInfoByNoteId(Guid? NoteId, Guid? AnalysisID, Guid? UserID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            DevDashBoardDataContract ddb = new DevDashBoardDataContract();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = NoteId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ScenarioId", Value = AnalysisID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            dt = hp.ExecDataTable("dbo.usp_GetNoteCalcInfoByNoteId", sqlparam);
            // var result = dbContext.usp_GetNoteCalcInfoByNoteId(NoteId, AnalysisID);
            foreach (DataRow dr in dt.Rows)
            {
                ddb.CalcStatus = Convert.ToString(dr["CalculationStatus"]);
                ddb.LastUpdated = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                ddb.RequestBy = Convert.ToString(dr["UpdatedBy"]);
            }
            return ddb;
        }

        public void InsertUpdateServicerDropDateSetup(List<ServicerDropDateSetup> _noteServicerDropDateSetupDC, string username, Guid noteid)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dtServicerDropDateSetup = new DataTable();
            dtServicerDropDateSetup.Columns.Add("ServicerDropDateSetupID");
            dtServicerDropDateSetup.Columns.Add("NoteID");
            dtServicerDropDateSetup.Columns.Add("ModeledPMTDropDate");
            dtServicerDropDateSetup.Columns.Add("PMTDropDateOverride");

            if (_noteServicerDropDateSetupDC != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(_noteServicerDropDateSetupDC);

                foreach (DataRow dr in dt.Rows)
                {
                    dr["NoteID"] = noteid;
                    dr["UpdatedBy"] = username;
                    dr["CreatedBy"] = username;

                    dtServicerDropDateSetup.ImportRow(dr);
                }
            }

            if (dtServicerDropDateSetup.Rows.Count > 0)
            {
                hp.ExecDataTablewithtable("dbo.usp_InsertUpdateServicerDropDateSetup", dtServicerDropDateSetup, username, username);
            }
        }
        public List<ServicerDropDateSetup> GetServicerDropDateSetupByNoteId(Guid? noteid, string createdBy)
        {
            DataTable dt = new DataTable();
            List<ServicerDropDateSetup> _noteServicerDropDateSetupList = new List<ServicerDropDateSetup>();
            Helper.Helper hp = new Helper.Helper();
            if (createdBy == "")
            {
                createdBy = "B0E6697B-3534-4C09-BE0A-04473401AB93";
            }
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(createdBy) };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetServicerDropDateSetupByNoteId", sqlparam);
            //  var ServicerDropDateSetupList = dbContext.usp_GetServicerDropDateSetupByNoteId(noteid, new Guid(createdBy));

            foreach (DataRow dr in dt.Rows)
            {
                ServicerDropDateSetup _noteServicerDropDateSetup = new ServicerDropDateSetup();
                if (Convert.ToString(dr["ServicerDropDateSetupID"]) != "")
                {
                    _noteServicerDropDateSetup.ServicerDropDateSetupID = new Guid(Convert.ToString(dr["ServicerDropDateSetupID"]));
                }
                if (Convert.ToString(dr["NoteID"]) != "")
                {
                    _noteServicerDropDateSetup.NoteID = new Guid(Convert.ToString(dr["NoteID"]));
                }

                _noteServicerDropDateSetup.ModeledPMTDropDate = CommonHelper.ToDateTime(dr["ModeledPMTDropDate"]);
                _noteServicerDropDateSetup.PMTDropDateOverride = CommonHelper.ToDateTime(dr["PMTDropDateOverride"]);
                _noteServicerDropDateSetup.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                _noteServicerDropDateSetup.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                _noteServicerDropDateSetup.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                _noteServicerDropDateSetup.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);

                _noteServicerDropDateSetupList.Add(_noteServicerDropDateSetup);
            }

            return _noteServicerDropDateSetupList;
        }
        public void InsertInterestCalculator(List<InterestCalculatorDataContract> _lstInterestCalculatorDC, string NoteId, string CreatedBy)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dtInterestCalculator = new DataTable();
            dtInterestCalculator.Columns.Add("NoteID");
            dtInterestCalculator.Columns.Add("AccrualStartDate");
            dtInterestCalculator.Columns.Add("AccrualEndDate");
            dtInterestCalculator.Columns.Add("PaymentDate");
            dtInterestCalculator.Columns.Add("BeginningBalance");
            dtInterestCalculator.Columns.Add("AnalysisID");

            if (_lstInterestCalculatorDC != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(_lstInterestCalculatorDC);

                foreach (DataRow dr in dt.Rows)
                {
                    dtInterestCalculator.ImportRow(dr);
                }
            }

            if (dtInterestCalculator.Rows.Count > 0)
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@TableTypeTransactionEntry", Value = dtInterestCalculator };
                SqlParameter p2 = new SqlParameter { ParameterName = "@NoteId", Value = new Guid(NoteId) };
                SqlParameter p3 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                hp.ExecDataTablewithparams("dbo.usp_InsertInterestCalculator", sqlparam);
            }
        }
        public void InsertDailyInterestAccural(List<DailyInterestAccrualsDataContract> ListDailyInterest, string NoteId, string CreatedBy)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dtInterestCalculator = new DataTable();
            dtInterestCalculator.Columns.Add("NoteID");
            dtInterestCalculator.Columns.Add("Date");
            dtInterestCalculator.Columns.Add("DailyInterestAccrual");
            dtInterestCalculator.Columns.Add("EndingBalance");
            dtInterestCalculator.Columns.Add("AnalysisID");

            if (ListDailyInterest != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(ListDailyInterest);

                foreach (DataRow dr in dt.Rows)
                {
                    dtInterestCalculator.ImportRow(dr);
                }
            }
            if (dtInterestCalculator.Rows.Count > 0)
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@TableTypeDailyInterest", Value = dtInterestCalculator };
                SqlParameter p2 = new SqlParameter { ParameterName = "@NoteId", Value = new Guid(NoteId) };
                SqlParameter p3 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                hp.ExecDataTablewithparams("usp_InsertDailyInterestAccruals", sqlparam);
            }
        }

        public void InsertDailyGAAPBasisComponents(List<DailyGAAPBasisComponentsDataContract> ListDailyGaap, string NoteId, string CreatedBy)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dtDailyGaap = new DataTable();
            dtDailyGaap.Columns.Add("NoteID");
            dtDailyGaap.Columns.Add("Date");
            dtDailyGaap.Columns.Add("AccumAmortofDeferredFees");
            dtDailyGaap.Columns.Add("AccumulatedAmortofDiscountPremium");
            dtDailyGaap.Columns.Add("AccumulatedAmortofCapitalizedCost");
            dtDailyGaap.Columns.Add("EndingBalance");
            dtDailyGaap.Columns.Add("GrossDeferredFees");
            dtDailyGaap.Columns.Add("CleanCost");
            dtDailyGaap.Columns.Add("CurrentPeriodInterestAccrualPeriodEnddate");
            dtDailyGaap.Columns.Add("CurrentPeriodPIKInterestAccrualPeriodEnddate");
            dtDailyGaap.Columns.Add("InterestSuspenseAccountBalance");
            dtDailyGaap.Columns.Add("AnalysisID");

            if (ListDailyGaap != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(ListDailyGaap);

                foreach (DataRow dr in dt.Rows)
                {
                    dtDailyGaap.ImportRow(dr);
                }
            }
            if (dtDailyGaap.Rows.Count > 0)
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@TableTypeDailyGAAPBasisComponents", Value = dtDailyGaap };
                SqlParameter p2 = new SqlParameter { ParameterName = "@NoteId", Value = new Guid(NoteId) };
                SqlParameter p3 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                hp.ExecDataTablewithparams("usp_InsertDailyGAAPBasisComponents", sqlparam);
            }
        }

        public void InsertPeriodicInterestRateUsed(List<PeriodicInterestRateUsed> ListDailyInterest, string NoteId, string CreatedBy)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dtInterestCalculator = new DataTable();
            dtInterestCalculator.Columns.Add("NoteID");
            dtInterestCalculator.Columns.Add("Date");
            dtInterestCalculator.Columns.Add("CouponSpread");
            dtInterestCalculator.Columns.Add("AllInCouponRate");
            dtInterestCalculator.Columns.Add("AllInPikRate");
            dtInterestCalculator.Columns.Add("LiborRate");
            dtInterestCalculator.Columns.Add("IndexFloor");
            dtInterestCalculator.Columns.Add("CouponRate");
            dtInterestCalculator.Columns.Add("AdditionalPIKinterestRatefromPIKTable");
            dtInterestCalculator.Columns.Add("AdditionalPIKSpreadfromPIKTable");
            dtInterestCalculator.Columns.Add("PIKIndexFloorfromPIKTable");
            dtInterestCalculator.Columns.Add("AnalysisID");

            if (ListDailyInterest != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(ListDailyInterest);

                foreach (DataRow dr in dt.Rows)
                {
                    dtInterestCalculator.ImportRow(dr);
                }
            }
            if (dtInterestCalculator.Rows.Count > 0)
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@TableTypeDailyInterest", Value = dtInterestCalculator };
                SqlParameter p2 = new SqlParameter { ParameterName = "@NoteId", Value = new Guid(NoteId) };
                SqlParameter p3 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                hp.ExecDataTablewithparams("usp_InsertPeriodicInterestRateUsed", sqlparam);
            }
        }
        public List<FinancingSourceDataContract> GetFinancingSource(Guid? UserID)
        {
            Helper.Helper hp = new Helper.Helper();
            List<FinancingSourceDataContract> _financingSourceList = new List<FinancingSourceDataContract>();
            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("usp_GetFinancingSource", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                FinancingSourceDataContract financingSource = new FinancingSourceDataContract();
                financingSource.FinancingSourceMasterID = Convert.ToInt32(dr["FinancingSourceMasterID"]);
                financingSource.FinancingSourceName = Convert.ToString(dr["FinancingSourceName"]);
                _financingSourceList.Add(financingSource);
            }
            return _financingSourceList;
        }
        public List<ScheduleEffectiveDateDataContract> GetScheduleEffectiveDateCount(Guid NoteID)
        {
            Helper.Helper hp = new Helper.Helper();
            List<ScheduleEffectiveDateDataContract> _scheduledatecount = new List<ScheduleEffectiveDateDataContract>();
            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = NoteID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("usp_GetScheduleEffectiveDateCountByNoteId", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                ScheduleEffectiveDateDataContract lstschedulecount = new ScheduleEffectiveDateDataContract();
                lstschedulecount.ScheduleName = Convert.ToString(dr["ScheduleType"]);
                lstschedulecount.EffectiveDateCount = Convert.ToInt32(dr["EffectiveStartDateCounts"]);
                lstschedulecount.NoteId = NoteID;
                _scheduledatecount.Add(lstschedulecount);
            }
            return _scheduledatecount;
        }
        public void CopyFundingSchedule(string ParentNoteID, string CopyNoteID, string CreatedBy)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@ParentNoteID", Value = ParentNoteID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@CopyNoteID", Value = CopyNoteID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            hp.ExecDataTablewithparams("usp_CopyFundingSchedule", sqlparam);

        }
        public List<FeeCouponStripReceivableTab> GetFeeCouponStripReceivableDataByNoteIdForCalc(Guid? noteid, Guid? userID, Guid? AnalysisID)
        {

            List<FeeCouponStripReceivableTab> _feeCouponStripReceivableTabList = new List<FeeCouponStripReceivableTab>();


            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            dt = hp.ExecDataTable("usp_GetFeeCouponStripReceivableDataByNoteIdForCalc", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                FeeCouponStripReceivableTab _feeCouponStripReceivableTab = new DataContract.FeeCouponStripReceivableTab();
                _feeCouponStripReceivableTab.EffectiveDate = Convert.ToDateTime(dr["EffectiveDate"]);
                _feeCouponStripReceivableTab.Date = Convert.ToDateTime(dr["Date"]);
                _feeCouponStripReceivableTab.Value = Convert.ToDecimal(dr["Value"]);
                _feeCouponStripReceivableTab.SourceNoteId = Convert.ToString(dr["SourceNoteId"]);
                _feeCouponStripReceivableTab.StrippedAmount = Convert.ToDecimal(dr["StrippedAmount"]);
                _feeCouponStripReceivableTab.RuleType = Convert.ToString(dr["RuleType"]);
                _feeCouponStripReceivableTab.FeeName = Convert.ToString(dr["FeeName"]);
                _feeCouponStripReceivableTab.FeeCouponReceivable = Convert.ToDecimal(dr["Value"]);
                _feeCouponStripReceivableTab.TransactionName = Convert.ToString(dr["TransactionName"]);
                _feeCouponStripReceivableTab.InclInLevelYield = Convert.ToDecimal(dr["InclInLevelYield"]);

                _feeCouponStripReceivableTabList.Add(_feeCouponStripReceivableTab);
            }
            return _feeCouponStripReceivableTabList;
        }

        public List<NoteListDealAmortDataContarct> GetNoteDetailForDealAmortByDealID(Guid? dealID)
        {
            List<NoteListDealAmortDataContarct> _adcList = new List<NoteListDealAmortDataContarct>();

            Helper.Helper hp = new Helper.Helper();

            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = dealID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("usp_GetNoteDetailForDealAmortByDealID", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                NoteListDealAmortDataContarct _adc = new DataContract.NoteListDealAmortDataContarct();

                _adc.NoteId = Convert.ToString(dr["NoteID"]);
                _adc.CRENoteID = Convert.ToString(dr["CRENoteID"]);
                _adc.Name = Convert.ToString(dr["Name"]);
                _adc.MaturityDate = CommonHelper.ToDateTime(dr["Maturity"]);
                _adc.LienPosition = CommonHelper.ToInt32(dr["lienposition"]);
                _adc.LienPositionText = Convert.ToString(dr["LienPositionText"]);
                _adc.Priority = CommonHelper.ToInt32(dr["Priority"]);
                _adc.IOTerm = CommonHelper.ToInt32(dr["IOTerm"]);
                _adc.AmortRate = CommonHelper.ToDecimal(dr["AmortRate"]);
                _adc.TotalCommitment = CommonHelper.ToDecimal(dr["TotalCommitment"]);
                _adc.EstimatedCurrentBalance = CommonHelper.ToDecimal(dr["EstBls"]);
                _adc.AmortTerm = CommonHelper.ToInt32(dr["AmortTerm"]);
                _adc.RoundingNote = CommonHelper.ToInt32(dr["RoundingNote"]);
                _adc.RoundingNoteText = Convert.ToString(dr["RoundingNoteText"]);
                _adc.StraightLineAmortOverride = CommonHelper.ToDecimal(dr["StraightLineAmortOverride"]);
                _adc.UseRuletoDetermineAmortization = CommonHelper.ToInt32(dr["UseRuletoDetermineAmortization"]);
                _adc.UseRuletoDetermineAmortizationText = Convert.ToString(dr["UseRuletoDetermineAmortizationText"]);

                _adc.InitialInterestAccrualEndDate = CommonHelper.ToDateTime(dr["InitialInterestAccrualEndDate"]);
                //_ndc.IOTerm = CommonHelper.ToInt32(dr["IOTerm"]);
                //_ndc.AmortTerm = CommonHelper.ToInt32(dr["AmortTerm"]);

                _adcList.Add(_adc);
            }
            return _adcList;
        }

        public DataTable GetNoteDealAmortByDealID(Guid? dealID)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable dt = new DataTable();
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = dealID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("usp_GetNoteDetailForDealAmortByDealID", sqlparam);

            }
            return dt;
        }
        public DataTable refreshBSUnderwritingStatus(string BatchName, Guid? UserID)
        {
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@BatchName", Value = BatchName };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("usp_RefreshBSUnderwritingStatus", sqlparam);
            }
            return dt;
        }

        public DataTable GetMarketPriceByNoteID(string NoteId, string UserID)
        {
            try
            {
                List<NoteMarketPriceDataContract> lstnotemarketprice = new List<NoteMarketPriceDataContract>();
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                {
                    SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = NoteId };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                    SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                    dt = hp.ExecDataTable("usp_GetMarketPriceByNoteID", sqlparam);
                    return dt;
                }
            }
            catch (Exception ex)
            {
                throw ex;

            }
        }
        //addupdate market price 
        public void InsertUpdateMarketPriceByNoteID(List<NoteMarketPriceDataContract> _notemarketpriceDC, Guid UserID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                int result;
                DataTable dtnotemaretprice = new DataTable();
                dtnotemaretprice.Columns.Add("NoteID");
                dtnotemaretprice.Columns.Add("Date", typeof(DateTime));
                dtnotemaretprice.Columns.Add("Value");

                if (_notemarketpriceDC.Count != 0)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(_notemarketpriceDC);

                    foreach (DataRow dr in dt.Rows)
                    {
                        dtnotemaretprice.ImportRow(dr);
                    }

                    SqlParameter p1 = new SqlParameter { ParameterName = "@Tablenotemarketprice", Value = dtnotemaretprice };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                    SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                    result = hp.ExecDataTablewithparams("dbo.usp_AddUpdateMarketPriceByNoteID", sqlparam);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void DeleteMarketPriceByNoteID(List<NoteMarketPriceDataContract> _notemarketpriceDC, Guid UserID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                int result;
                DataTable dtnotemaretprice = new DataTable();
                dtnotemaretprice.Columns.Add("NoteID");
                dtnotemaretprice.Columns.Add("Date", typeof(System.DateTime));
                dtnotemaretprice.Columns.Add("Value");

                if (_notemarketpriceDC.Count != 0)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(_notemarketpriceDC);

                    foreach (DataRow dr in dt.Rows)
                    {
                        dtnotemaretprice.ImportRow(dr);
                    }

                    SqlParameter p1 = new SqlParameter { ParameterName = "@Tablenotemarketprice", Value = dtnotemaretprice };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                    SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                    result = hp.ExecDataTablewithparams("dbo.usp_DeleteMarketPriceByNoteID", sqlparam);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public int DeleteNoteTransactionDetail(List<NoteServicingLogDataContract> lstNoteTransactionDetail)
        {
            int result = 0;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                if (lstNoteTransactionDetail != null)
                {
                    foreach (NoteServicingLogDataContract ns in lstNoteTransactionDetail)
                    {
                        SqlParameter p1 = new SqlParameter { ParameterName = "@NoteTransactionDetailID", Value = ns.TransactionId };
                        SqlParameter p2 = new SqlParameter { ParameterName = "@NoteID", Value = ns.NoteId };

                        SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                        result = hp.ExecDataTablewithparams("dbo.usp_DeleteNoteTransactionDetail", sqlparam);
                    }
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public DataTable GetNoteCommitmentsByNoteID(string NoteId, string UserID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                {
                    SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = NoteId };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                    SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                    dt = hp.ExecDataTable("usp_GetNoteCommitmentsByNoteID", sqlparam);
                    return dt;
                }
            }
            catch (Exception ex)
            {
                throw ex;

            }
        }

        public List<NoteCommitmentDataContract> GetNoteCommitmentForCalculatorByNoteID(Guid? NoteID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                List<NoteCommitmentDataContract> notecommimtnetlist = new List<NoteCommitmentDataContract>();
                DataTable dt = new DataTable();

                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = NoteID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetNoteCommitmentForCalculatorByNoteID", sqlparam);
                foreach (DataRow dr in dt.Rows)
                {
                    NoteCommitmentDataContract _notecommitment = new NoteCommitmentDataContract();
                    _notecommitment.Date = CommonHelper.ToDateTime(dr["Date"]);
                    _notecommitment.Type = Convert.ToString(dr["Type"]);
                    _notecommitment.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                    _notecommitment.Rownumber = CommonHelper.ToInt32(dr["Rowno"]);
                    _notecommitment.TotalCommitmentAdjustment = CommonHelper.ToDecimal(dr["TotalCommitmentAdjustment"]);
                    _notecommitment.TotalCommitment = CommonHelper.ToDecimal(dr["TotalCommitment"]);
                    notecommimtnetlist.Add(_notecommitment);
                }
                return notecommimtnetlist;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertYieldCalcInput(List<YieldCalcInputDataContract> _yieldcalcinputdc, string CreatedBy)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                int result;
                DataTable dtyieldcalcinput = new DataTable();
                dtyieldcalcinput.Columns.Add("CRENoteID");
                dtyieldcalcinput.Columns.Add("NPVdate", typeof(DateTime));
                dtyieldcalcinput.Columns.Add("Value");
                dtyieldcalcinput.Columns.Add("Effectivedate", typeof(DateTime));
                dtyieldcalcinput.Columns.Add("AnalysisID");
                dtyieldcalcinput.Columns.Add("YieldType");

                if (_yieldcalcinputdc.Count != 0)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(_yieldcalcinputdc);

                    foreach (DataRow dr in dt.Rows)
                    {
                        dtyieldcalcinput.ImportRow(dr);
                    }

                    SqlParameter p1 = new SqlParameter { ParameterName = "@TableTypeYieldCalcInput", Value = dtyieldcalcinput };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };

                    SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                    result = hp.ExecDataTablewithparams("dbo.usp_InsertYieldCalcInput", sqlparam);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public string CopyNote(NoteDataContract notedc, string CreatedBy)
        {
            string Newnoteid = "";
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@CopyDealId", Value = notedc.CopyDealID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@CopyCRENewNoteID", Value = notedc.CopyCRENoteId };
            SqlParameter p3 = new SqlParameter { ParameterName = "@ParentNoteID", Value = notedc.NoteId };
            SqlParameter p4 = new SqlParameter { ParameterName = "@CopyNoteName", Value = notedc.CopyName };
            SqlParameter p5 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
            SqlParameter p6 = new SqlParameter { ParameterName = "@newnoteId", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };
            int result = hp.ExecDataTablewithparams("usp_CopyNote", sqlparam);

            if (result != 0)
            {
                Newnoteid = Convert.ToString(p6.Value);
            }


            return Newnoteid;

        }
        public void UpdateMaturityConfiguration(List<NoteDataContract> notedc, Guid UserId)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dtMaturityConfiguration = new DataTable();
                dtMaturityConfiguration.Columns.Add("DealID");
                dtMaturityConfiguration.Columns.Add("CRENoteID");
                dtMaturityConfiguration.Columns.Add("MaturityMethodID");
                dtMaturityConfiguration.Columns.Add("MaturityGroupName");

                if (notedc.Count != 0)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(notedc);

                    foreach (DataRow dr in dt.Rows)
                    {
                        dtMaturityConfiguration.ImportRow(dr);
                    }

                    SqlParameter p1 = new SqlParameter { ParameterName = "@tblTypeMaturityConfiguration", Value = dtMaturityConfiguration };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserId };

                    SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                    hp.ExecDataTablewithparams("dbo.usp_UpdateMaturityConfigurationForNotes", sqlparam);
                }
            }
            catch (Exception ex)
            {
                var exception = ex.Message;
            }
        }

        public void SaveMaturitybydeal(DataTable dtdealMaturity, Guid UserId)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();


                if (dtdealMaturity.Rows.Count > 0)
                {

                    SqlParameter p1 = new SqlParameter { ParameterName = "@tblTypeMaturityData", Value = dtdealMaturity };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserId };

                    SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                    hp.ExecDataTablewithparams("dbo.usp_InsertMaturityDataFromDeal", sqlparam);
                }
            }
            catch (Exception ex)
            {
                var exception = ex.Message;
            }

        }


        public DataTable GetMaturityHistoricalDataByDealID(Guid? DealID, Guid? userID, string mutipleNoteids)
        {
            DataTable dt = new DataTable();

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@MultipleNoteids", Value = mutipleNoteids };
                SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = userID };


                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dt = hp.ExecDataTable("usp_GetMaturityHistoricalDataByDealID", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            return dt;
        }

        public string AddUpdateNoteRuleTypeSetup(List<ScenarioruletypeDataContract> lstscenarioruletype, string userid)
        {
            string NEWRuleTypeSetupID = "";
            Helper.Helper hp = new Helper.Helper();
            DataTable dtNoteRuleTypeSetup = new DataTable();
            dtNoteRuleTypeSetup.Columns.Add("AnalysisID");
            dtNoteRuleTypeSetup.Columns.Add("NoteID");
            dtNoteRuleTypeSetup.Columns.Add("RuleTypeMasterID");
            dtNoteRuleTypeSetup.Columns.Add("RuleTypeDetailID");

            if (lstscenarioruletype != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(lstscenarioruletype);

                foreach (DataRow dr in dt.Rows)
                {
                    dtNoteRuleTypeSetup.ImportRow(dr);
                }
            }

            SqlParameter p1 = new SqlParameter { ParameterName = "@tblnoteruletypesetup", Value = dtNoteRuleTypeSetup };
            SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy", Value = userid };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, };
            hp.ExecNonquery("dbo.usp_AddUpdateNoteRuleTypeSetup", sqlparam);

            if (!string.IsNullOrEmpty(NEWRuleTypeSetupID))
                return NEWRuleTypeSetupID;
            else
                return "FALSE";
        }
        public DataTable GetNoteCashflowsGAAPBasisExportData(DownloadCashFlowDataContract downloadCashFlow)
        {
            DataTable dt = new DataTable();

            try
            {
                //if (!(downloadCashFlow.MutipleNoteId == "" || downloadCashFlow.MutipleNoteId == null))
                //{
                //    downloadCashFlow.MutipleNoteId = downloadCashFlow.MutipleNoteId.Remove(downloadCashFlow.MutipleNoteId.Length - 1, 1);
                //}
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteId", Value = downloadCashFlow.NoteId };
                SqlParameter p2 = new SqlParameter { ParameterName = "@DealId", Value = downloadCashFlow.DealID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@ScenarioId", Value = downloadCashFlow.AnalysisID };
                //   SqlParameter p4 = new SqlParameter { ParameterName = "@PortfolioId", Value = PortfolioId };
                SqlParameter p4 = new SqlParameter { ParameterName = "@MultipleNoteids", Value = downloadCashFlow.MutipleNoteId };
                SqlParameter p5 = new SqlParameter { ParameterName = "@PortfolioMasterGuid", Value = downloadCashFlow.PortfolioMasterGuid };
                SqlParameter p6 = new SqlParameter { ParameterName = "@CountOnDropDownFilter", Value = downloadCashFlow.CountOnDropDownFilter };
                SqlParameter p7 = new SqlParameter { ParameterName = "@CountOnGridFilter", Value = downloadCashFlow.CountOnGridFilter };
                SqlParameter p8 = new SqlParameter { ParameterName = "@TransactionCategoryName", Value = downloadCashFlow.TransactionCategoryName };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8 };
                dt = hp.ExecDataTable("usp_GetNoteCashflowsExportData_GAAPBasisComponents", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return dt;
        }
        public List<ScenarioruletypeDataContract> GetRuleTypeSetupByNoteId(string NoteID, string AnalysisID)
        {
            DataTable dt = new DataTable();
            List<ScenarioruletypeDataContract> list = new List<ScenarioruletypeDataContract>();
            Helper.Helper hp = new Helper.Helper();

            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = NoteID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetRuleTypeSetupByNoteId", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                ScenarioruletypeDataContract sr = new ScenarioruletypeDataContract();
                sr.AnalysisID = Convert.ToString(dr["AnalysisID"]);
                sr.NoteID = Convert.ToString(dr["NoteID"]);
                sr.RuleTypeMasterID = CommonHelper.ToInt32(dr["RuleTypeMasterID"]);
                sr.RuleTypeName = Convert.ToString(dr["RuleTypeName"]);
                sr.RuleTypeDetailID = CommonHelper.ToInt32(dr["RuleTypeDetailID"]);
                sr.FileName = Convert.ToString(dr["FileName"]);

                list.Add(sr);

            }

            return list;
        }
    }
}