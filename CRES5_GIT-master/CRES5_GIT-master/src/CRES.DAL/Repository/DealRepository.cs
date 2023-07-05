
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
    public class DealRepository : IDealRepository
    {
        //test1
        public List<DealDataContract> GetAllDealUSP(Guid? userId, int? PageSize, int? PageIndex, out int? TotalCount)
        {
            List<DateTime> lst = new List<DateTime>();
            DateTime dt1 = DateTime.Now;
            lst.Add(dt1);

            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));

            List<DealDataContract> lstDealDC = new List<DealDataContract>();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PgeIndex", Value = PageIndex };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageSize", Value = PageSize };
            SqlParameter p4 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            dt = hp.ExecDataTable("dbo.usp_GetAllDeals", sqlparam);


            //var lstDeal = dbContext.usp_GetAllDeals(userId, PageIndex, PageSize, totalCount).ToList();
            TotalCount = string.IsNullOrEmpty(Convert.ToString(p4.Value)) ? 0 : CommonHelper.ToInt32(p4.Value);

            foreach (DataRow dr in dt.Rows)
            {
                DealDataContract _dealDC = new DealDataContract();
                _dealDC.DealID = new Guid(Convert.ToString(dr["DealID"]));
                _dealDC.DealName = Convert.ToString(dr["DealName"]);
                _dealDC.DealType = CommonHelper.ToInt32(dr["DealType"]);
                _dealDC.DealTypeText = Convert.ToString(dr["DealTypeText"]);
                _dealDC.LoanProgram = CommonHelper.ToInt32(dr["LoanProgram"]);
                _dealDC.LoanProgramText = Convert.ToString(dr["LoanProgramText"]);
                _dealDC.LoanPurpose = CommonHelper.ToInt32(dr["LoanPurpose"]);
                _dealDC.LoanPurposeText = Convert.ToString(dr["LoanPurposeText"]);
                _dealDC.Statusid = CommonHelper.ToInt32(dr["Status"]);
                _dealDC.StatusText = Convert.ToString(dr["StatusText"]);
                _dealDC.AppReceived = CommonHelper.ToDateTime(dr["AppReceived"]);

                if (string.IsNullOrEmpty(Convert.ToString(dr["EstClosingDate"])))
                    _dealDC.EstClosingDate = CommonHelper.ToDateTime(dr["EstClosingDate"]);

                _dealDC.BorrowerRequest = CommonHelper.ToInt32(Convert.ToString(dr["BorrowerRequest"]) == "" ? 0 : CommonHelper.ToInt32(dr["BorrowerRequest"]));
                _dealDC.BorrowerRequestText = Convert.ToString(dr["BorrowerRequestText"]);
                _dealDC.RecommendedLoan = CommonHelper.ToDecimal(dr["RecommendedLoan"]);
                _dealDC.TotalFutureFunding = CommonHelper.ToDecimal(dr["TotalFutureFunding"]);
                _dealDC.Source = CommonHelper.ToInt32(dr["Source"]);
                _dealDC.SourceText = Convert.ToString(dr["SourceText"]);
                _dealDC.BrokerageFirm = Convert.ToString(dr["BrokerageFirm"]);
                _dealDC.BrokerageContact = Convert.ToString(dr["BrokerageContact"]);
                _dealDC.Sponsor = Convert.ToString(dr["Sponsor"]);
                _dealDC.Principal = Convert.ToString(dr["Principal"]);
                _dealDC.NetWorth = CommonHelper.ToDecimal(dr["NetWorth"]);
                _dealDC.Liquidity = CommonHelper.ToDecimal(dr["Liquidity"]);
                _dealDC.ClientDealID = Convert.ToString(dr["ClientDealID"]);
                _dealDC.LinkedDealID = Convert.ToString(dr["LinkedDealID"]);
                _dealDC.CREDealID = Convert.ToString(dr["CREDealID"]);
                _dealDC.TotalCommitment = CommonHelper.ToDecimal(dr["TotalCommitment"]);
                _dealDC.AdjustedTotalCommitment = CommonHelper.ToDecimal(dr["AdjustedTotalCommitment"]);
                _dealDC.AggregatedTotal = CommonHelper.ToDecimal(dr["AggregatedTotal"]);
                _dealDC.AssetManagerComment = Convert.ToString(dr["AssetManagerComment"]);
                _dealDC.AssetManager = Convert.ToString(dr["AssetManager"]);
                _dealDC.DealCity = Convert.ToString(dr["DealCity"]);
                _dealDC.DealState = Convert.ToString(dr["DealState"]);
                _dealDC.DealPropertyType = Convert.ToString(dr["DealPropertyType"]);
                _dealDC.FullyExtMaturityDate = CommonHelper.ToDateTime(dr["FullyExtMaturityDate"]);
                _dealDC.GeoLocation = Convert.ToString(dr["GeoLocation"]);
                _dealDC.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                _dealDC.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                _dealDC.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                _dealDC.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                _dealDC.LastUpdatedFF = CommonHelper.ToDateTime(dr["LastUpdatedFF"]);
                _dealDC.LastUpdatedByFF = Convert.ToString(dr["LastUpdatedByFF"]);
                _dealDC.AllowSizerUpload = CommonHelper.ToInt32(dr["AllowSizerUpload"]);
                _dealDC.AllowSizerUploadText = Convert.ToString(dr["AllowSizerUploadText"]);
                lstDealDC.Add(_dealDC);
            }
            return lstDealDC;
        }

        public DealDataContract GetDealByid(string DeailId, Guid? userId)
        {
            DealDataContract _dealDC = new DealDataContract();
            _dealDC.PrepaySchedule = new PrepayDataContract();
            DataTable dt = new DataTable();
            //  DeailId = "790181DC-147A-4F55-82EB-0039BD0A9208";
            if (DeailId != "00000000-0000-0000-0000-000000000000")
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@Dealid", Value = DeailId };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userId };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetDealByDealId", sqlparam);

                if (dt.Rows.Count > 0)
                {
                    if (CommonHelper.ToInt32(dt.Rows[0]["StatusCode"]) == 404) // HTTP_404_NOT_FOUND
                    {
                        _dealDC.StatusCode = 404;
                    }
                    else
                    {
                        _dealDC.DealID = new Guid(Convert.ToString(dt.Rows[0]["DealID"]));
                        _dealDC.DealName = Convert.ToString(dt.Rows[0]["DealName"]);
                        _dealDC.DealType = CommonHelper.ToInt32(dt.Rows[0]["DealType"]);
                        _dealDC.DealTypeText = Convert.ToString(dt.Rows[0]["DealTypeText"]);
                        _dealDC.LoanProgram = CommonHelper.ToInt32(dt.Rows[0]["LoanProgram"]);
                        _dealDC.LoanProgramText = Convert.ToString(dt.Rows[0]["LoanProgramText"]);
                        _dealDC.LoanPurpose = CommonHelper.ToInt32(dt.Rows[0]["LoanPurpose"]);
                        _dealDC.LoanPurposeText = Convert.ToString(dt.Rows[0]["LoanPurposeText"]);
                        _dealDC.Statusid = CommonHelper.ToInt32(dt.Rows[0]["Status"]);
                        _dealDC.StatusText = Convert.ToString(dt.Rows[0]["StatusText"]);

                        if (Convert.ToString(dt.Rows[0]["AppReceived"]) != "")
                            _dealDC.AppReceived = CommonHelper.ToDateTime(dt.Rows[0]["AppReceived"]);
                        if (Convert.ToString(dt.Rows[0]["StatusCode"]) != "")
                            _dealDC.EstClosingDate = CommonHelper.ToDateTime(dt.Rows[0]["EstClosingDate"]);
                        // _dealDC.BorrowerRequest = CommonHelper.ToInt32(_deal.BorrowerRequest);
                        _dealDC.BorrowerRequest = CommonHelper.ToInt32(dt.Rows[0]["BorrowerRequest"]); CommonHelper.ToInt32(Convert.ToString(dt.Rows[0]["BorrowerRequest"]) == "" ? 0 : CommonHelper.ToInt32(dt.Rows[0]["BorrowerRequest"]));
                        _dealDC.BorrowerRequestText = Convert.ToString(dt.Rows[0]["BorrowerRequestText"]);
                        _dealDC.RecommendedLoan = CommonHelper.ToInt32(dt.Rows[0]["RecommendedLoan"]);
                        _dealDC.TotalFutureFunding = CommonHelper.ToInt32(dt.Rows[0]["TotalFutureFunding"]);
                        _dealDC.Source = CommonHelper.ToInt32(dt.Rows[0]["Source"]);
                        _dealDC.SourceText = Convert.ToString(dt.Rows[0]["SourceText"]);
                        _dealDC.BrokerageFirm = Convert.ToString(dt.Rows[0]["BrokerageFirm"]);
                        _dealDC.BrokerageContact = Convert.ToString(dt.Rows[0]["BrokerageContact"]);
                        _dealDC.Sponsor = Convert.ToString(dt.Rows[0]["Sponsor"]);
                        _dealDC.Principal = Convert.ToString(dt.Rows[0]["Principal"]);
                        _dealDC.NetWorth = CommonHelper.ToDecimal(dt.Rows[0]["NetWorth"]);
                        _dealDC.Liquidity = CommonHelper.ToDecimal(dt.Rows[0]["Liquidity"]);
                        _dealDC.ClientDealID = Convert.ToString(dt.Rows[0]["ClientDealID"]);
                        _dealDC.LinkedDealID = Convert.ToString(dt.Rows[0]["LinkedDealID"]);

                        _dealDC.CREDealID = Convert.ToString(dt.Rows[0]["CREDealID"]);
                        _dealDC.TotalCommitment = CommonHelper.ToDecimal(dt.Rows[0]["TotalCommitment"]);
                        _dealDC.AdjustedTotalCommitment = CommonHelper.ToDecimal(dt.Rows[0]["AdjustedTotalCommitment"]);
                        _dealDC.AggregatedTotal = CommonHelper.ToDecimal(dt.Rows[0]["AggregatedTotal"]);
                        _dealDC.AssetManagerComment = Convert.ToString(dt.Rows[0]["AssetManagerComment"]);
                        _dealDC.DealComment = Convert.ToString(dt.Rows[0]["DealComment"]);

                        _dealDC.CreatedBy = Convert.ToString(dt.Rows[0]["CreatedBy"]);
                        _dealDC.CreatedDate = CommonHelper.ToDateTime(dt.Rows[0]["CreatedDate"]);
                        _dealDC.UpdatedBy = Convert.ToString(dt.Rows[0]["UpdatedBy"]);
                        _dealDC.UpdatedDate = CommonHelper.ToDateTime(dt.Rows[0]["UpdatedDate"]);
                        _dealDC.AssetManager = Convert.ToString(dt.Rows[0]["AssetManager"]);
                        _dealDC.AssetManagerID = dt.Rows[0]["AMUserID"].ToGuid();
                        _dealDC.AMTeamLeadUserID = dt.Rows[0]["AMTeamLeadUserID"].ToGuid();
                        _dealDC.AMSecondUserID = dt.Rows[0]["AMSecondUserID"].ToGuid();
                        _dealDC.DealCity = Convert.ToString(dt.Rows[0]["DealCity"]);
                        _dealDC.DealState = Convert.ToString(dt.Rows[0]["DealState"]);
                        _dealDC.DealPropertyType = Convert.ToString(dt.Rows[0]["DealPropertyType"]);
                        _dealDC.FullyExtMaturityDate = CommonHelper.ToDateTime(dt.Rows[0]["FullyExtMaturityDate"]);
                        _dealDC.UnderwritingStatusid = CommonHelper.ToInt32(dt.Rows[0]["UnderwritingStatus"]);
                        _dealDC.UnderwritingStatusidText = Convert.ToString(dt.Rows[0]["UnderwritingStatusText"]);
                        _dealDC.LastUpdatedFF = CommonHelper.ToDateTime(dt.Rows[0]["lastUpdatedFF"]);
                        _dealDC.LastUpdatedByFF = Convert.ToString(dt.Rows[0]["LastUpdatedByFF"]);
                        _dealDC.AllowSizerUpload = CommonHelper.ToInt32(dt.Rows[0]["AllowSizerUpload"]);
                        _dealDC.AllowSizerUploadText = Convert.ToString(dt.Rows[0]["AllowSizerUploadText"]);

                        _dealDC.StatusCode = 200;

                        _dealDC.LastUpdatedFF_String = Convert.ToString(dt.Rows[0]["LastUpdatedFF_String"]);
                        _dealDC.DealRule = Convert.ToString(dt.Rows[0]["DealRule"]);
                        _dealDC.BoxDocumentLink = Convert.ToString(dt.Rows[0]["BoxDocumentLink"]);
                        _dealDC.DealGroupID = Convert.ToString(dt.Rows[0]["DealGroupID"]);
                        _dealDC.EnableAutoSpread = CommonHelper.ToBoolean(dt.Rows[0]["EnableAutoSpread"]);
                        _dealDC.ServicerDropDate = CommonHelper.ToInt32(dt.Rows[0]["ServicerDropDate"]);
                        _dealDC.ServicereDayAjustement = CommonHelper.ToInt32(dt.Rows[0]["ServicereDayAjustement"]);
                        _dealDC.BaseCurrencyName = Convert.ToString(dt.Rows[0]["BaseCurrencyName"]);
                        if (CommonHelper.ToDateTime(dt.Rows[0]["FirstPaymentDate"]) != null)
                            _dealDC.FirstPaymentDate = CommonHelper.ToDateTime(dt.Rows[0]["FirstPaymentDate"]);

                        _dealDC.amort = new AmortDataContract();
                        _dealDC.amort.AmortizationMethod = CommonHelper.ToInt32(dt.Rows[0]["AmortizationMethod"]);
                        _dealDC.amort.AmortizationMethodText = Convert.ToString(dt.Rows[0]["AmortizationMethodText"]);
                        _dealDC.amort.ReduceAmortizationForCurtailments = CommonHelper.ToInt32(dt.Rows[0]["ReduceAmortizationForCurtailments"]);
                        _dealDC.amort.ReduceAmortizationForCurtailmentsText = Convert.ToString(dt.Rows[0]["ReduceAmortizationForCurtailmentsText"]);
                        _dealDC.amort.BusinessDayAdjustmentForAmort = CommonHelper.ToInt32(dt.Rows[0]["BusinessDayAdjustmentForAmort"]);
                        _dealDC.amort.BusinessDayAdjustmentForAmortText = Convert.ToString(dt.Rows[0]["BusinessDayAdjustmentForAmortText"]);
                        _dealDC.amort.NoteDistributionMethod = CommonHelper.ToInt32(dt.Rows[0]["NoteDistributionMethod"]);
                        _dealDC.amort.NoteDistributionMethodText = Convert.ToString(dt.Rows[0]["NoteDistributionMethodText"]);
                        _dealDC.amort.PeriodicStraightLineAmortOverride = CommonHelper.ToDecimal(dt.Rows[0]["PeriodicStraightLineAmortOverride"]);
                        _dealDC.amort.FixedPeriodicPayment = CommonHelper.ToDecimal(dt.Rows[0]["FixedPeriodicPayment"]);
                        _dealDC.EquityAmount = CommonHelper.ToDecimal(dt.Rows[0]["EquityAmount"]);
                        _dealDC.RemainingAmount = CommonHelper.ToDecimal(dt.Rows[0]["RemainingAmount"]);

                        //to check for AI API calling
                        _dealDC.OriginalCREDealID = Convert.ToString(dt.Rows[0]["CREDealID"]);
                        _dealDC.OriginalDealName = Convert.ToString(dt.Rows[0]["DealName"]);
                        _dealDC.EnableAutospreadRepayments = CommonHelper.ToBoolean(dt.Rows[0]["EnableAutoSpreadRepayments"]);
                        _dealDC.EnableAutospreadRepayments_db = CommonHelper.ToBoolean(dt.Rows[0]["EnableAutoSpreadRepayments"]);
                        _dealDC.AutoUpdateFromUnderwriting = CommonHelper.ToBoolean(dt.Rows[0]["AutoUpdateFromUnderwriting"]);
                        _dealDC.ExpectedFullRepaymentDate = CommonHelper.ToDateTime(dt.Rows[0]["ExpectedFullRepaymentDate"]);
                        _dealDC.RepaymentAutoSpreadMethodID = CommonHelper.ToInt32(dt.Rows[0]["RepaymentAutoSpreadMethodID"]);
                        _dealDC.RepaymentAutoSpreadMethodText = Convert.ToString(dt.Rows[0]["RepaymentAutoSpreadMethodText"]);
                        _dealDC.RepaymentStartDate = CommonHelper.ToDateTime(dt.Rows[0]["RepaymentStartDate"]);
                        _dealDC.EarliestPossibleRepaymentDate = CommonHelper.ToDateTime(dt.Rows[0]["EarliestPossibleRepaymentDate"]);
                        _dealDC.Blockoutperiod = CommonHelper.ToInt32(dt.Rows[0]["Blockoutperiod"]);
                        _dealDC.PossibleRepaymentdayofthemonth = CommonHelper.ToInt32(dt.Rows[0]["PossibleRepaymentdayofthemonth"]);
                        _dealDC.Repaymentallocationfrequency = CommonHelper.ToInt32(dt.Rows[0]["Repaymentallocationfrequency"]);
                        _dealDC.AutoPrepayEffectiveDate = CommonHelper.ToDateTime(dt.Rows[0]["AutoPrepayEffectiveDate"]);
                        _dealDC.LatestPossibleRepaymentDate = CommonHelper.ToDateTime(dt.Rows[0]["LatestPossibleRepaymentDate"]);
                        _dealDC.MinAccrualFrequency = CommonHelper.ToInt32(dt.Rows[0]["MinAccrualFrequency"]);
                        _dealDC.AllowFundingDevDataFlag = CommonHelper.ToBoolean(dt.Rows[0]["AllowFundingFlag"]);
                        _dealDC.AllowFFSaveJsonIntoBlob = CommonHelper.ToBoolean(dt.Rows[0]["AllowFFSaveJsonIntoBlob"]);
                        _dealDC.DealLevelMaturity = CommonHelper.ToBoolean(dt.Rows[0]["DealLevelMaturity"]);
                        _dealDC.ApplyNoteLevelPaydowns = CommonHelper.ToBoolean(dt.Rows[0]["ApplyNoteLevelPaydowns"]);
                        _dealDC.IsREODeal = CommonHelper.ToBoolean(dt.Rows[0]["IsREODeal"]);
                        _dealDC.max_ExtensionMat = CommonHelper.ToDateTime(dt.Rows[0]["max_ExtensionMat"]);
                        _dealDC.BalanceAware = CommonHelper.ToBoolean(dt.Rows[0]["BalanceAware"]);
                        _dealDC.LastWireConfirmDate_db = CommonHelper.ToDateTime(dt.Rows[0]["LastWireConfirmDate_db"]);
                        _dealDC.PrePayDate = CommonHelper.ToDateTime(dt.Rows[0]["PrepayDate"]);
                        _dealDC.PrepaySchedule.EffectiveDate = CommonHelper.ToDateTime(dt.Rows[0]["EffectiveDate_Prepay"]);

                        _dealDC.PrepaySchedule.CalcThru = CommonHelper.ToDateTime(dt.Rows[0]["CalcThru"]);
                        _dealDC.PrepaySchedule.PrepaymentMethod = CommonHelper.ToInt32(dt.Rows[0]["PrepaymentMethod"]);
                        _dealDC.PrepaySchedule.PrepaymentMethodText = Convert.ToString(dt.Rows[0]["PrepaymentMethodText"]);
                        _dealDC.PrepaySchedule.BaseAmountType = CommonHelper.ToInt32(dt.Rows[0]["BaseAmountType"]);
                        _dealDC.PrepaySchedule.BaseAmountTypeText = Convert.ToString(dt.Rows[0]["BaseAmountTypeText"]);
                        _dealDC.PrepaySchedule.SpreadCalcMethod = CommonHelper.ToInt32(dt.Rows[0]["SpreadCalcMethod"]);
                        _dealDC.PrepaySchedule.SpreadCalcMethodText = Convert.ToString(dt.Rows[0]["SpreadCalcMethodtext"]);
                        _dealDC.PrepaySchedule.GreaterOfSMOrBaseAmtTimeSpread = CommonHelper.ToBoolean(dt.Rows[0]["GreaterOfSMOrBaseAmtTimeSpread"]);
                        _dealDC.PrepaySchedule.HasNoteLevelSMSchedule = CommonHelper.ToBoolean(dt.Rows[0]["HasNoteLevelSMSchedule"]);
                        _dealDC.PrepaySchedule.Includefeesincredits = CommonHelper.ToBoolean(dt.Rows[0]["Includefeesincredits"]);

                        _dealDC.PropertyTypeID = CommonHelper.ToInt32(dt.Rows[0]["PropertyTypeMajorID"]);
                        _dealDC.LoanStatusID = CommonHelper.ToInt32(dt.Rows[0]["LoanStatusID"]);
                        _dealDC.ICMFullyFundedEquity = CommonHelper.ToDecimal(dt.Rows[0]["ICMFullyFundedEquity"]);
                        _dealDC.EquityatClosing = CommonHelper.ToDecimal(dt.Rows[0]["EquityatClosing"]);

                    }
                }
                else
                {
                    _dealDC.StatusCode = 404;
                }

            }
            else
            {
                _dealDC.StatusCode = 200;
                _dealDC.amort = new AmortDataContract();
                _dealDC.amort.AmortizationMethodText = "";
                _dealDC.BaseCurrencyName = "USD";
            }
            return _dealDC;
        }

        public string InsertUpdateDeal(DealDataContract _dealDC)
        {
            string NewDeadID;


            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = _dealDC.DealID.ToString() };
            SqlParameter p2 = new SqlParameter { ParameterName = "@DealName", Value = _dealDC.DealName };
            SqlParameter p3 = new SqlParameter { ParameterName = "@DealType", Value = _dealDC.DealType };
            SqlParameter p4 = new SqlParameter { ParameterName = "@LoanProgram", Value = _dealDC.LoanProgram };
            SqlParameter p5 = new SqlParameter { ParameterName = "@LoanPurpose", Value = _dealDC.LoanPurpose };
            SqlParameter p6 = new SqlParameter { ParameterName = "@Status", Value = _dealDC.Statusid };
            SqlParameter p7 = new SqlParameter { ParameterName = "@AppReceived", Value = _dealDC.AppReceived };
            SqlParameter p8 = new SqlParameter { ParameterName = "@EstClosingDate", Value = _dealDC.EstClosingDate };
            SqlParameter p9 = new SqlParameter { ParameterName = "@BorrowerRequest", Value = _dealDC.BorrowerRequest };
            SqlParameter p10 = new SqlParameter { ParameterName = "@RecommendedLoan", Value = _dealDC.RecommendedLoan };
            SqlParameter p11 = new SqlParameter { ParameterName = "@TotalFutureFunding", Value = _dealDC.TotalFutureFunding };
            SqlParameter p12 = new SqlParameter { ParameterName = "@Source", Value = _dealDC.Source };
            SqlParameter p13 = new SqlParameter { ParameterName = "@BrokerageFirm", Value = _dealDC.BrokerageFirm };
            SqlParameter p14 = new SqlParameter { ParameterName = "@BrokerageContact", Value = _dealDC.BrokerageContact };
            SqlParameter p15 = new SqlParameter { ParameterName = "@Sponsor", Value = _dealDC.Sponsor };
            SqlParameter p16 = new SqlParameter { ParameterName = "@Principal", Value = _dealDC.Principal };
            SqlParameter p17 = new SqlParameter { ParameterName = "@NetWorth", Value = _dealDC.NetWorth };
            SqlParameter p18 = new SqlParameter { ParameterName = "@Liquidity", Value = _dealDC.Liquidity };
            SqlParameter p19 = new SqlParameter { ParameterName = "@ClientDealID", Value = _dealDC.ClientDealID };
            SqlParameter p20 = new SqlParameter { ParameterName = "@CREDealID", Value = _dealDC.CREDealID };
            SqlParameter p21 = new SqlParameter { ParameterName = "@TotalCommitment", Value = _dealDC.TotalCommitment };
            SqlParameter p22 = new SqlParameter { ParameterName = "@AdjustedTotalCommitment", Value = _dealDC.AdjustedTotalCommitment };

            SqlParameter p23 = new SqlParameter { ParameterName = "@AggregatedTotal", Value = _dealDC.AggregatedTotal };
            SqlParameter p24 = new SqlParameter { ParameterName = "@AssetManagerComment", Value = _dealDC.AssetManagerComment };
            SqlParameter p25 = new SqlParameter { ParameterName = "@LinkedDealID", Value = _dealDC.LinkedDealID };
            SqlParameter p26 = new SqlParameter { ParameterName = "@AssetManager", Value = _dealDC.AssetManager };
            SqlParameter p27 = new SqlParameter { ParameterName = "@DealCity", Value = _dealDC.DealCity };
            SqlParameter p28 = new SqlParameter { ParameterName = "@DealState", Value = _dealDC.DealState };
            SqlParameter p29 = new SqlParameter { ParameterName = "@DealPropertyType", Value = _dealDC.DealPropertyType };
            SqlParameter p30 = new SqlParameter { ParameterName = "@FullyExtMaturityDate", Value = _dealDC.FullyExtMaturityDate };
            SqlParameter p31 = new SqlParameter { ParameterName = "@UnderwritingStatusid", Value = _dealDC.UnderwritingStatusid };
            SqlParameter p32 = new SqlParameter { ParameterName = "@CreatedBy", Value = _dealDC.CreatedBy };
            SqlParameter p33 = new SqlParameter { ParameterName = "@CreatedDate", Value = _dealDC.CreatedDate };
            SqlParameter p34 = new SqlParameter { ParameterName = "@UpdatedBy", Value = _dealDC.UpdatedBy };
            SqlParameter p35 = new SqlParameter { ParameterName = "@UpdatedDate", Value = _dealDC.UpdatedDate };
            SqlParameter p36 = new SqlParameter { ParameterName = "@DealComment", Value = _dealDC.DealComment };
            SqlParameter p37 = new SqlParameter { ParameterName = "@AllowSizerUpload", Value = _dealDC.AllowSizerUpload };
            SqlParameter p38 = new SqlParameter { ParameterName = "@AssetManagerID", Value = _dealDC.AssetManagerID };
            SqlParameter p39 = new SqlParameter { ParameterName = "@AMTeamLeadUserID", Value = _dealDC.AMTeamLeadUserID };
            SqlParameter p40 = new SqlParameter { ParameterName = "@AMSecondUserID", Value = _dealDC.AMSecondUserID };
            SqlParameter p41 = new SqlParameter { ParameterName = "@DealRule", Value = _dealDC.DealRule };
            SqlParameter p42 = new SqlParameter { ParameterName = "@BoxDocumentLink", Value = _dealDC.BoxDocumentLink };
            SqlParameter p43 = new SqlParameter { ParameterName = "@DealGroupID", Value = _dealDC.DealGroupID };
            SqlParameter p44 = new SqlParameter { ParameterName = "@NewDealID", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter p45 = new SqlParameter { ParameterName = "@EnableAutoSpread", Value = _dealDC.EnableAutoSpread };
            SqlParameter p46 = new SqlParameter { ParameterName = "@AmortizationMethod", Value = _dealDC.amort.AmortizationMethod };
            SqlParameter p47 = new SqlParameter { ParameterName = "@ReduceAmortizationForCurtailments", Value = _dealDC.amort.ReduceAmortizationForCurtailments };
            SqlParameter p48 = new SqlParameter { ParameterName = "@BusinessDayAdjustmentForAmort", Value = _dealDC.amort.BusinessDayAdjustmentForAmort };
            SqlParameter p49 = new SqlParameter { ParameterName = "@NoteDistributionMethod", Value = _dealDC.amort.NoteDistributionMethod };
            SqlParameter p50 = new SqlParameter { ParameterName = "@PeriodicStraightLineAmortOverride", Value = _dealDC.amort.PeriodicStraightLineAmortOverride };
            SqlParameter p51 = new SqlParameter { ParameterName = "@FixedPeriodicPayment", Value = _dealDC.amort.FixedPeriodicPayment };
            SqlParameter p52 = new SqlParameter { ParameterName = "@EquityAmount", Value = _dealDC.EquityAmount };
            SqlParameter p53 = new SqlParameter { ParameterName = "@RemainingAmount", Value = _dealDC.RemainingAmount };
            SqlParameter p54 = new SqlParameter { ParameterName = "@AutoUpdateFromUnderwriting", Value = _dealDC.AutoUpdateFromUnderwriting };
            SqlParameter p55 = new SqlParameter { ParameterName = "@ExpectedFullRepaymentDate", Value = _dealDC.ExpectedFullRepaymentDate };
            SqlParameter p56 = new SqlParameter { ParameterName = "@AutoPrepayEffectiveDate", Value = _dealDC.AutoPrepayEffectiveDate };
            SqlParameter p57 = new SqlParameter { ParameterName = "@RepaymentAutoSpreadMethodID", Value = _dealDC.RepaymentAutoSpreadMethodID };
            SqlParameter p58 = new SqlParameter { ParameterName = "@EarliestPossibleRepaymentDate", Value = _dealDC.EarliestPossibleRepaymentDate };
            SqlParameter p59 = new SqlParameter { ParameterName = "@LatestPossibleRepaymentDate", Value = _dealDC.LatestPossibleRepaymentDate };
            SqlParameter p60 = new SqlParameter { ParameterName = "@Blockoutperiod", Value = _dealDC.Blockoutperiod };
            SqlParameter p61 = new SqlParameter { ParameterName = "@PossibleRepaymentdayofthemonth", Value = _dealDC.PossibleRepaymentdayofthemonth };
            SqlParameter p62 = new SqlParameter { ParameterName = "@Repaymentallocationfrequency", Value = _dealDC.Repaymentallocationfrequency };
            SqlParameter p63 = new SqlParameter { ParameterName = "@EnableAutoSpreadRepayments", Value = _dealDC.EnableAutospreadRepayments };
            SqlParameter p64 = new SqlParameter { ParameterName = "@DealLevelMaturity", Value = _dealDC.DealLevelMaturity };
            SqlParameter p65 = new SqlParameter { ParameterName = "@ApplyNoteLevelPaydowns", Value = _dealDC.ApplyNoteLevelPaydowns };
            SqlParameter p66 = new SqlParameter { ParameterName = "@IsREODeal", Value = _dealDC.IsREODeal };
            SqlParameter p67 = new SqlParameter { ParameterName = "@BalanceAware", Value = _dealDC.BalanceAware };
            SqlParameter p68 = new SqlParameter { ParameterName = "@PropertyTypeMajorID", Value = _dealDC.PropertyTypeID };
            SqlParameter p69 = new SqlParameter { ParameterName = "@LoanStatusID", Value = _dealDC.LoanStatusID };
            SqlParameter p70 = new SqlParameter { ParameterName = "@PrepayDate", Value = _dealDC.PrePayDate };
            SqlParameter p71 = new SqlParameter { ParameterName = "@ICMFullyFundedEquity", Value = _dealDC.ICMFullyFundedEquity };
            SqlParameter p72 = new SqlParameter { ParameterName = "@EquityatClosing", Value = _dealDC.EquityatClosing };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17,
                                                          p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32,p33, p34, p35, p36, p37, p38, p39, p40,
                p41, p42, p43, p44, p45,p46,p47,p48,p49,p50,p51, p52,p53,p54,p55,p56,p57,p58,p59,p60,p61,p62,p63,p64,p65,p66,p67,p68,p69,p70,p71,p72
            };
            hp.ExecNonquery("cre.usp_SaveDeal", sqlparam);

            NewDeadID = Convert.ToString(p44.Value);
            //Save in App.Object table            
            int? lookupid = 283;

            if (NewDeadID != null)
            {
                lookupid = CommonHelper.ToInt32(lookupid);
                SqlParameter po1 = new SqlParameter { ParameterName = "@ObjectID", Value = new Guid(NewDeadID) };
                SqlParameter po2 = new SqlParameter { ParameterName = "@ObjectTypeID", Value = lookupid };
                SqlParameter po3 = new SqlParameter { ParameterName = "@CreatedBy", Value = _dealDC.CreatedBy };
                SqlParameter po4 = new SqlParameter { ParameterName = "@UpdatedBy", Value = _dealDC.UpdatedBy };
                SqlParameter[] sqloparam = new SqlParameter[] { po1, po2, po3, po4 };
                hp.ExecDataTable("App.usp_AddUpdateObject", sqloparam);
            }
            if (!string.IsNullOrEmpty(NewDeadID))
                return NewDeadID;
            else
                return "FALSE";

        }

        public List<FutureFundingScheduleDataContract> GetFundingSchedulePayruleDataByDealID(Guid? dealID, Guid? userId, int? PageSize, int? PageIndex, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            List<DateTime> lst = new List<DateTime>();
            DateTime dt1 = DateTime.Now;
            lst.Add(dt1);
            //   ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            List<FutureFundingScheduleDataContract> lstDealDC = new List<FutureFundingScheduleDataContract>();

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = dealID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetFundingSchedulePayruleDataByDealID", sqlparam);
            TotalCount = 50; //Convert.ToInt32(totalCount.Value);
            foreach (DataRow dr in dt.Rows)
            {
                FutureFundingScheduleDataContract _fundingDC = new FutureFundingScheduleDataContract();
                _fundingDC.NoteID = new Guid(Convert.ToString(dr["NoteID"]));
                _fundingDC.Date = CommonHelper.ToDateTime(dr["Date"]);
                _fundingDC.Value = CommonHelper.ToDecimal(dr["Value"]);
                _fundingDC.PurposeID = Convert.ToInt32(dr["PurposeID"]);
                _fundingDC.PurposeText = Convert.ToString(dr["PurposeText"]);
                lstDealDC.Add(_fundingDC);
            }

            //    var lstFunding = dbContext.usp_GetFundingSchedulePayruleDataByDealID(dealID).ToList();
            //TotalCount = CommonHelper.ToInt32(totalCount.Value);
            //foreach (usp_GetFundingSchedulePayruleDataByDealID_Result _funding in lstFunding)
            //{
            //    FutureFundingScheduleDataContract _fundingDC = new FutureFundingScheduleDataContract();
            //    _fundingDC.NoteID = _fundingDC.NoteID;
            //    _fundingDC.Date = _fundingDC.Date;
            //    _fundingDC.Value = _fundingDC.Value;
            //    _fundingDC.PurposeID = _fundingDC.PurposeID;
            //    _fundingDC.PurposeText = _fundingDC.PurposeText;
            //    lstDealDC.Add(_fundingDC);
            //}
            return lstDealDC;
        }

        public void InsertUpdateDealFunding(List<PayruleDealFundingDataContract> dealfunding, string delegateduserid)
        {
            Helper.Helper hp = new Helper.Helper();

            SqlParameter p1 = new SqlParameter { ParameterName = "@XMLDealFunding", Value = dealfunding.ToXML().Replace(" xsi:nil=\"true\"", "") };
            SqlParameter p2 = new SqlParameter { ParameterName = "@DelegatedUserID", Value = delegateduserid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecDataTable("CRE.usp_SaveDealFunding", sqlparam);


            //  var res = dbContext.usp_SaveDealFunding(dealfunding.ToXML());

            //foreach (PayruleDealFundingDataContract pfdc in dealfunding)
            //{
            //    var res = dbContext.usp_SaveDealFunding(
            //      pfdc.DealFundingID,
            //      pfdc.DealID.ToString(),
            //      pfdc.Date,
            //      pfdc.Value,
            //      pfdc.Comment,
            //      pfdc.PurposeID,
            //      pfdc.Applied,
            //      pfdc.DrawFundingId,
            //      pfdc.DealFundingRowno,
            //      pfdc.CreatedBy,
            //      pfdc.CreatedDate,
            //      pfdc.UpdatedBy,
            //      pfdc.UpdatedDate

            // );

            // }
        }

        public void InsertUpdateDealArchieveFunding(List<PayruleDealFundingDataContract> dealfunding, string username)
        {

            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();

            List<DealArchieveDataContract> lstDealArchieve = new List<DealArchieveDataContract>();


            foreach (PayruleDealFundingDataContract pfdc in dealfunding)
            {
                if (pfdc.DealFundingID != null)
                {
                    DealArchieveDataContract dealarch = new DealArchieveDataContract();
                    dealarch.DealFundingID = pfdc.DealFundingID;
                    dealarch.DealID = pfdc.DealID;
                    dealarch.Date = pfdc.Date;
                    dealarch.Value = pfdc.Value;
                    dealarch.Comment = pfdc.Comment;
                    dealarch.PurposeID = pfdc.PurposeID;
                    dealarch.CreatedBy = username;
                    dealarch.CreatedDate = System.DateTime.Now;
                    dealarch.UpdatedBy = username;
                    dealarch.UpdatedDate = pfdc.UpdatedDate;
                    lstDealArchieve.Add(dealarch);
                }
            }
            dt = hp.ToDataTable(lstDealArchieve);
            SqlParameter p1 = new SqlParameter { ParameterName = "TmpDealArch", Value = dt };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            hp.ExecDataTablewithparams("dbo.usp_InsertUpdateDealArchieveList", sqlparam);
            //var res = dbContext.usp_InsertUpdateDealArchieveList(
            //  pfdc.DealFundingID,
            //  pfdc.DealID.ToString(),
            //  pfdc.Date,
            //  pfdc.Value,
            //  pfdc.Comment,
            //  pfdc.PurposeID,
            //  pfdc.CreatedBy,
            //  pfdc.CreatedDate,
            //  pfdc.UpdatedBy,
            //  pfdc.UpdatedDate

            // );

        }

        public DealDataContract GetDealByCREDealId(string CREDealId)
        {
            DealDataContract _dealDC = new DealDataContract();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            if (CREDealId != "00000000-0000-0000-0000-000000000000")
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealFundingID", Value = CREDealId };


                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetDealByCREDealId", sqlparam);


                // var _deal = dbContext.usp_GetDealByCREDealId(CREDealId).FirstOrDefault();
                if (dt.Rows.Count > 0)
                {

                    _dealDC.DealID = new Guid(Convert.ToString(dt.Rows[0]["DealID"]));// _deal.DealID;
                    _dealDC.DealName = Convert.ToString(dt.Rows[0]["DealName"]);
                    _dealDC.DealType = CommonHelper.ToInt32(dt.Rows[0]["DealType"]);
                    _dealDC.DealTypeText = Convert.ToString(dt.Rows[0]["DealTypeText"]);
                    _dealDC.LoanProgram = CommonHelper.ToInt32(dt.Rows[0]["LoanProgram"]);
                    _dealDC.LoanProgramText = Convert.ToString(dt.Rows[0]["LoanProgramText"]);
                    _dealDC.LoanPurpose = CommonHelper.ToInt32(dt.Rows[0]["LoanPurpose"]);
                    _dealDC.LoanPurposeText = Convert.ToString(dt.Rows[0]["LoanPurposeText"]);
                    _dealDC.Statusid = CommonHelper.ToInt32(dt.Rows[0]["Status"]);
                    _dealDC.StatusText = Convert.ToString(dt.Rows[0]["StatusText"]);
                    _dealDC.AppReceived = CommonHelper.ToDateTime(dt.Rows[0]["AppReceived"]);
                    _dealDC.EstClosingDate = CommonHelper.ToDateTime(dt.Rows[0]["EstClosingDate"]);
                    // _dealDC.BorrowerRequest = CommonHelper.ToInt32(_deal.BorrowerRequest);
                    _dealDC.BorrowerRequest = CommonHelper.ToInt32(Convert.ToString(dt.Rows[0]["DealID"]) == "" ? 0 : CommonHelper.ToInt32(dt.Rows[0]["DealID"])); CommonHelper.ToInt32(dt.Rows[0]["DealID"]);
                    _dealDC.BorrowerRequestText = Convert.ToString(dt.Rows[0]["BorrowerRequestText"]);
                    _dealDC.RecommendedLoan = CommonHelper.ToDecimal(dt.Rows[0]["RecommendedLoan"]);
                    _dealDC.TotalFutureFunding = CommonHelper.ToDecimal(dt.Rows[0]["TotalFutureFunding"]);
                    _dealDC.Source = CommonHelper.ToInt32(dt.Rows[0]["Source"]);
                    _dealDC.SourceText = Convert.ToString(dt.Rows[0]["SourceText"]);
                    _dealDC.BrokerageFirm = Convert.ToString(dt.Rows[0]["BrokerageFirm"]);
                    _dealDC.BrokerageContact = Convert.ToString(dt.Rows[0]["BrokerageContact"]);
                    _dealDC.Sponsor = Convert.ToString(dt.Rows[0]["Sponsor"]);
                    _dealDC.Principal = Convert.ToString(dt.Rows[0]["Principal"]);
                    _dealDC.NetWorth = CommonHelper.ToDecimal(dt.Rows[0]["NetWorth"]);
                    _dealDC.Liquidity = CommonHelper.ToDecimal(dt.Rows[0]["Liquidity"]);
                    _dealDC.ClientDealID = Convert.ToString(dt.Rows[0]["ClientDealID"]);
                    _dealDC.LinkedDealID = Convert.ToString(dt.Rows[0]["LinkedDealID"]);
                    _dealDC.CREDealID = Convert.ToString(dt.Rows[0]["CREDealID"]);
                    _dealDC.TotalCommitment = CommonHelper.ToDecimal(dt.Rows[0]["TotalCommitment"]);
                    _dealDC.AdjustedTotalCommitment = CommonHelper.ToDecimal(dt.Rows[0]["AdjustedTotalCommitment"]);
                    _dealDC.AggregatedTotal = CommonHelper.ToDecimal(dt.Rows[0]["AggregatedTotal"]);
                    _dealDC.AssetManagerComment = Convert.ToString(dt.Rows[0]["AssetManagerComment"]);
                    _dealDC.DealComment = Convert.ToString(dt.Rows[0]["DealComment"]);
                    _dealDC.CreatedBy = Convert.ToString(dt.Rows[0]["CreatedBy"]);
                    _dealDC.CreatedDate = CommonHelper.ToDateTime(dt.Rows[0]["CreatedDate"]);
                    _dealDC.UpdatedBy = Convert.ToString(dt.Rows[0]["UpdatedBy"]);
                    _dealDC.UpdatedDate = CommonHelper.ToDateTime(dt.Rows[0]["UpdatedDate"]);
                    _dealDC.LastUpdatedByFF = Convert.ToString(dt.Rows[0]["LastUpdatedByFF"]);
                    _dealDC.AllowSizerUpload = CommonHelper.ToInt32(dt.Rows[0]["AllowSizerUpload"]);
                    _dealDC.AllowSizerUploadText = Convert.ToString(dt.Rows[0]["AllowSizerUploadText"]);
                    _dealDC.LastUpdatedFF = CommonHelper.ToDateTime(dt.Rows[0]["LastUpdatedFF"]);
                    _dealDC.DealGroupID = Convert.ToString(dt.Rows[0]["DealGroupID"]);
                    _dealDC.EnableAutoSpread = CommonHelper.ToBoolean(dt.Rows[0]["EnableAutoSpread"]);

                    _dealDC.amort.AmortizationMethod = CommonHelper.ToInt32(dt.Rows[0]["AmortizationMethod"]);
                    _dealDC.amort.AmortizationMethodText = Convert.ToString(dt.Rows[0]["AmortizationMethodText"]);
                    _dealDC.amort.ReduceAmortizationForCurtailments = CommonHelper.ToInt32(dt.Rows[0]["ReduceAmortizationForCurtailments"]);
                    _dealDC.amort.ReduceAmortizationForCurtailmentsText = Convert.ToString(dt.Rows[0]["ReduceAmortizationForCurtailmentsText"]);
                    _dealDC.amort.BusinessDayAdjustmentForAmort = CommonHelper.ToInt32(dt.Rows[0]["BusinessDayAdjustmentForAmort"]);
                    _dealDC.amort.BusinessDayAdjustmentForAmortText = Convert.ToString(dt.Rows[0]["BusinessDayAdjustmentForAmortText"]);
                    _dealDC.amort.NoteDistributionMethod = CommonHelper.ToInt32(dt.Rows[0]["NoteDistributionMethod"]);
                    _dealDC.amort.NoteDistributionMethodText = Convert.ToString(dt.Rows[0]["NoteDistributionMethodText"]);
                    _dealDC.amort.PeriodicStraightLineAmortOverride = CommonHelper.ToDecimal(dt.Rows[0]["PeriodicStraightLineAmortOverride"]);
                    _dealDC.amort.FixedPeriodicPayment = CommonHelper.ToDecimal(dt.Rows[0]["FixedPeriodicPayment"]);
                    _dealDC.EquityAmount = CommonHelper.ToDecimal(dt.Rows[0]["EquityAmount"]);
                    _dealDC.RemainingAmount = CommonHelper.ToDecimal(dt.Rows[0]["RemainingAmount"]);

                    _dealDC.EnableAutospreadRepayments = CommonHelper.ToBoolean(dt.Rows[0]["EnableAutoSpreadRepayments"]);
                    _dealDC.AutoUpdateFromUnderwriting = CommonHelper.ToBoolean(dt.Rows[0]["AutoUpdateFromUnderwriting"]);
                    _dealDC.ExpectedFullRepaymentDate = CommonHelper.ToDateTime(dt.Rows[0]["ExpectedFullRepaymentDate"]);
                    _dealDC.RepaymentAutoSpreadMethodID = CommonHelper.ToInt32(dt.Rows[0]["RepaymentAutoSpreadMethodID"]);
                    _dealDC.RepaymentAutoSpreadMethodText = Convert.ToString(dt.Rows[0]["RepaymentAutoSpreadMethodText"]);
                    _dealDC.RepaymentStartDate = CommonHelper.ToDateTime(dt.Rows[0]["RepaymentStartDate"]);
                    _dealDC.EarliestPossibleRepaymentDate = CommonHelper.ToDateTime(dt.Rows[0]["EarliestPossibleRepaymentDate"]);
                    _dealDC.Blockoutperiod = CommonHelper.ToInt32(dt.Rows[0]["Blockoutperiod"]);
                    _dealDC.PossibleRepaymentdayofthemonth = CommonHelper.ToInt32(dt.Rows[0]["PossibleRepaymentdayofthemonth"]);
                    _dealDC.Repaymentallocationfrequency = CommonHelper.ToInt32(dt.Rows[0]["Repaymentallocationfrequency"]);
                    _dealDC.AutoPrepayEffectiveDate = CommonHelper.ToDateTime(dt.Rows[0]["AutoPrepayEffectiveDate"]);
                    _dealDC.LatestPossibleRepaymentDate = CommonHelper.ToDateTime(dt.Rows[0]["LatestPossibleRepaymentDate"]);
                    _dealDC.MinAccrualFrequency = CommonHelper.ToInt32(dt.Rows[0]["MinAccrualFrequency"]);
                    _dealDC.AllowFundingDevDataFlag = CommonHelper.ToBoolean(dt.Rows[0]["AllowFundingFlag"]);
                    _dealDC.AllowFFSaveJsonIntoBlob = CommonHelper.ToBoolean(dt.Rows[0]["AllowFFSaveJsonIntoBlob"]);
                    _dealDC.DealLevelMaturity = CommonHelper.ToBoolean(dt.Rows[0]["DealLevelMaturity"]);
                }
                else
                {
                    _dealDC = null;
                }
            }

            return _dealDC;
        }

        public List<PayruleTargetNoteFundingScheduleDataContract> GetFundingSchedulePayruleDataByDealID(Guid? dealID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            List<DateTime> lst = new List<DateTime>();
            DateTime dt1 = DateTime.Now;
            lst.Add(dt1);
            List<PayruleTargetNoteFundingScheduleDataContract> lstDealDC = new List<PayruleTargetNoteFundingScheduleDataContract>();
            //  var lstFunding = dbContext.usp_GetFundingSchedulePayruleDataByDealID(dealID).ToList();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = dealID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetFundingSchedulePayruleDataByDealID", sqlparam);


            foreach (DataRow dr in dt.Rows)
            {
                PayruleTargetNoteFundingScheduleDataContract _fundingDC = new PayruleTargetNoteFundingScheduleDataContract();
                _fundingDC.NoteID = new Guid(Convert.ToString(dr["NoteID"]));
                _fundingDC.NoteName = Convert.ToString(dr["Name"]);
                _fundingDC.Date = CommonHelper.ToDateTime(dr["Date"]);
                _fundingDC.Value = CommonHelper.ToDecimal(dr["Value"]);
                _fundingDC.PurposeID = CommonHelper.ToInt32(dr["PurposeID"]);
                _fundingDC.Purpose = Convert.ToString(dr["PurposeText"]);
                _fundingDC.Comments = Convert.ToString(dr["Comments"]);
                _fundingDC.DealFundingRowno = CommonHelper.ToInt32(dr["DealFundingRowno"]);
                _fundingDC.Applied = CommonHelper.ToBoolean(dr["Applied"]);
                _fundingDC.DealFundingID = new Guid(Convert.ToString(dr["DealFundingID"]));
                lstDealDC.Add(_fundingDC);
            }
            return lstDealDC;
        }

        public DataTable GetFundingRepaymentSequenceHistoryByDealID(Guid? dealID)
        {


            DataTable dt = new DataTable();

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = dealID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetFundingRepaymentSequenceHistroyByDealID", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            return dt;
        }

        public List<PayruleNoteAMSequenceDataContract> GetFundingRepaymentSequenceByDealID(Guid? dealID)
        {
            List<PayruleNoteAMSequenceDataContract> lstDealDC = new List<PayruleNoteAMSequenceDataContract>();
            //  var lstFunding = dbContext.usp_GetFundingRepaymentSequenceByDealID(dealID).ToList();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = dealID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetFundingRepaymentSequenceByDealID", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                PayruleNoteAMSequenceDataContract _fundingDC = new PayruleNoteAMSequenceDataContract();
                _fundingDC.NoteID = new Guid(Convert.ToString(dr["NoteID"]));
                _fundingDC.SequenceNo = CommonHelper.ToInt32(dr["SequenceNo"]);
                _fundingDC.SequenceType = CommonHelper.ToInt32(dr["SequenceType"]);
                _fundingDC.SequenceTypeText = Convert.ToString(dr["SequenceTypeText"]);
                _fundingDC.Value = CommonHelper.ToDecimal(dr["Value"]);
                lstDealDC.Add(_fundingDC);
            }
            return lstDealDC;
        }

        public void InsertUpdateFundingRepaymentSequence(List<PayruleNoteAMSequenceDataContract> NoteSequence, string username)
        {
            Helper.Helper hp = new Helper.Helper();
            DataTable dNoteSequence = new DataTable();

            dNoteSequence.Columns.Add("NoteID");
            dNoteSequence.Columns.Add("SequenceNo");
            dNoteSequence.Columns.Add("SequenceType");
            dNoteSequence.Columns.Add("Value");

            if (NoteSequence != null)
            {
                DataTable dt = new DataTable();
                dt = ObjToDataTable.ToDataTable(NoteSequence);

                foreach (DataRow dr in dt.Rows)
                {
                    dNoteSequence.ImportRow(dr);
                }
            }

            if (dNoteSequence.Rows.Count > 0)
            {
                hp.BatchUpdateOrInsert("[dbo].usp_InsertUpdateFundingRepaymentSequence", dNoteSequence, username, "noteFundingRepayment");
            }
        }
        public void InsertUpdateAmortSequence(List<AmortSequenceDataContract> AmortSequence, string username)
        {
            Helper.Helper hp = new Helper.Helper();
            DataTable dtAmort = new DataTable();

            dtAmort.Columns.Add("NoteID");
            dtAmort.Columns.Add("SequenceNo");
            dtAmort.Columns.Add("SequenceType");
            dtAmort.Columns.Add("Value");

            if (AmortSequence != null)
            {
                DataTable dt = new DataTable();
                dt = ObjToDataTable.ToDataTable(AmortSequence);

                foreach (DataRow dr in dt.Rows)
                {

                    dtAmort.ImportRow(dr);
                }
            }

            if (dtAmort.Rows.Count > 0)
            {
                hp.BatchUpdateOrInsert("usp_InsertUpdateAmortSequence", dtAmort, username, "AmortSequence");
            }
        }
        public DataTable GetNoteDealFundingByDealID(Guid? dealID, string userID, bool ShowUseRuleN)
        {
            DataTable dt = new DataTable();

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(userID) };
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = dealID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@IsShowUseRuleN", Value = ShowUseRuleN };
                SqlParameter[] sqlparam = new SqlParameter[] { p0, p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetNoteDealFundingScheduleDealID", sqlparam);

                //  RemoveEmptyColumns
                if (ShowUseRuleN == false)
                {
                    for (int i = dt.Columns.Count - 1; i >= 32; i--)
                    {
                        DataColumn col = dt.Columns[i];
                        if (dt.AsEnumerable().All(r => r.IsNull(col) || string.IsNullOrWhiteSpace(r[col].ToString())))
                            dt.Columns.RemoveAt(i);
                    }

                }


            }
            //Creating New copy column of auto generated funding columns
            catch (Exception ex)
            {
                throw;
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            return dt;
        }

        public DataTable GetWFNoteFunding(Guid? DealFundingID, string userID)
        {
            DataTable dt = new DataTable();

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(userID) };
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealFundingID", Value = DealFundingID };
                SqlParameter[] sqlparam = new SqlParameter[] { p0, p1 };
                dt = hp.ExecDataTable("dbo.usp_GetWFNoteFunding", sqlparam);
                //for (int i = dt.Columns.Count - 1; i >= 26; i--)
                //{
                //    DataColumn col = dt.Columns[i];
                //    if (dt.AsEnumerable().All(r => r.IsNull(col) || string.IsNullOrWhiteSpace(r[col].ToString())))
                //        dt.Columns.RemoveAt(i);
                //}

                foreach (var column in dt.Columns.Cast<DataColumn>().ToArray())
                {
                    if (dt.AsEnumerable().All(dr => dr.IsNull(column)))
                        dt.Columns.Remove(column);
                }

            }
            //Creating New copy column of auto generated funding columns
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            return dt;
        }

        public List<PayruleDealFundingDataContract> GetDealFundingScheduleByDealID(Guid? dealID)
        {
            List<PayruleDealFundingDataContract> lstDealDC = new List<PayruleDealFundingDataContract>();

            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter p0 = new SqlParameter { ParameterName = "@DealID", Value = dealID };

            SqlParameter[] sqlparam = new SqlParameter[] { p0 };
            dt = hp.ExecDataTable("dbo.usp_GetDealFundingScheduleByDealID", sqlparam);
            //var lstFunding = dbContext.usp_GetDealFundingScheduleByDealID(dealID).ToList();

            foreach (DataRow dr in dt.Rows)
            {
                PayruleDealFundingDataContract _fundingDC = new PayruleDealFundingDataContract();
                _fundingDC.DealID = new Guid(Convert.ToString(dr["DealID"]));
                _fundingDC.Date = CommonHelper.ToDateTime(dr["Date"]);

                _fundingDC.DealFundingID = new Guid(Convert.ToString(dr["DealFundingID"]));
                _fundingDC.Value = CommonHelper.ToDecimal(dr["Amount"]);
                _fundingDC.Comment = Convert.ToString(dr["Comment"]);
                _fundingDC.PurposeID = CommonHelper.ToInt32(dr["PurposeID"]);
                _fundingDC.PurposeText = Convert.ToString(dr["PurposeText"]);
                _fundingDC.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                _fundingDC.Applied = CommonHelper.ToBoolean(dr["Applied"]); //_funding.Applied==true?"Y":"N";                
                //_fundingDC.DrawFundingId = _funding.DrawFundingId;
                _fundingDC.DealFundingRowno = CommonHelper.ToInt32(dr["DealFundingRowno"]);
                _fundingDC.orgDate = CommonHelper.ToDateTime(dr["Date"]);
                _fundingDC.orgValue = CommonHelper.ToDecimal(dr["Amount"]);
                _fundingDC.OrgApplied = CommonHelper.ToBoolean(dr["Applied"]); //_funding.Applied==true?"Y":"N";
                _fundingDC.orgPurposeID = CommonHelper.ToInt32(dr["PurposeID"]);
                _fundingDC.OrgPurposeText = Convert.ToString(dr["PurposeText"]);
                lstDealDC.Add(_fundingDC);
            }
            return lstDealDC;
        }

        public string CheckDuplicateDeal(string DealID, string CredealID, string dealname, string notelist)
        {
            string isexist = "";
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealId", Value = DealID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@CREDealID", Value = CredealID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@DealName", Value = dealname };
                SqlParameter p4 = new SqlParameter { ParameterName = "@CRENoteID", Value = notelist };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
                dt = hp.ExecDataTable("usp_CheckDuplicateDeal", sqlparam);

                // dt.Rows[0]
                isexist = dt.Rows[0].ItemArray[0].ToString();

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return isexist;
        }

        public void CopyDealFundingFromLegalToPhantom(string crenoteid)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                SqlParameter p0 = new SqlParameter { ParameterName = "@CREDealID", Value = crenoteid };


                SqlParameter[] sqlparam = new SqlParameter[] { p0 };
                var res = hp.ExecNonquery("dbo.usp_CopyDealFundingFromLegalToPhantom", sqlparam);

                //   dbContext.usp_CopyDealFundingFromLegalToPhantom(crenoteid);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public bool CheckDuplicateCRENoteId(NoteDataContract _note)
        {

            Guid note_id;
            if (_note.NoteId != null)
            {
                note_id = new Guid(_note.NoteId);
            }
            else
            {
                note_id = new Guid("00000000-0000-0000-0000-000000000000");
            }

            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter p0 = new SqlParameter { ParameterName = "@CRENoteID", Value = _note.CRENewNoteID };
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = note_id };

            SqlParameter[] sqlparam = new SqlParameter[] { p0, p1 };
            var res = hp.ExecuteScalar("dbo.usp_CheckDuplicateCRENoteId", sqlparam);
            // var res = dbContext.usp_CheckDuplicateCRENoteId(_note.CRENewNoteID, note_id).FirstOrDefault();

            return string.IsNullOrEmpty(Convert.ToString(res)) ? false : Convert.ToBoolean(res);

        }

        public List<DealDataContract> GetLinkedPhantomDealID(string CREDealId)
        {
            List<DealDataContract> lstDealDC = new List<DealDataContract>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter p0 = new SqlParameter { ParameterName = "@CREDealID", Value = CREDealId };


            SqlParameter[] sqlparam = new SqlParameter[] { p0 };
            dt = hp.ExecDataTable("dbo.usp_GetLinkedPhantomDealID", sqlparam);
            // var lstFunding = dbContext.usp_GetLinkedPhantomDealID(CREDealId).ToList();
            foreach (DataRow dr in dt.Rows)
            {
                DealDataContract _dealDC = new DealDataContract();
                _dealDC.DealID = new Guid(Convert.ToString(dr["dealid"]));
                _dealDC.CREDealID = Convert.ToString(dr["CREDealID"]);
                _dealDC.LinkedDealID = Convert.ToString(dr["LinkedDealID"]);
                _dealDC.EnableAutospreadRepayments = CommonHelper.ToBoolean(dr["EnableAutoSpreadRepayments"]);
                _dealDC.ApplyNoteLevelPaydowns = CommonHelper.ToBoolean(dr["ApplyNoteLevelPaydowns"]);
                _dealDC.RepaymentAutoSpreadMethodID = CommonHelper.ToInt32(dr["RepaymentAutoSpreadMethodID"]);
                _dealDC.RepaymentAutoSpreadMethodText = Convert.ToString(dr["RepaymentAutoSpreadMethodIDText"]);
                _dealDC.PossibleRepaymentdayofthemonth = CommonHelper.ToInt32(dr["PossibleRepaymentdayofthemonth"]);
                _dealDC.Repaymentallocationfrequency = CommonHelper.ToInt32(dr["Repaymentallocationfrequency"]);
                _dealDC.Blockoutperiod = CommonHelper.ToInt32(dr["Blockoutperiod"]);
                _dealDC.EarliestPossibleRepaymentDate = CommonHelper.ToDateTime(dr["EarliestPossibleRepaymentDate"]);
                _dealDC.ExpectedFullRepaymentDate = CommonHelper.ToDateTime(dr["ExpectedFullRepaymentDate"]);
                _dealDC.LatestPossibleRepaymentDate = CommonHelper.ToDateTime(dr["LatestPossibleRepaymentDate"]);
                _dealDC.AutoPrepayEffectiveDate = CommonHelper.ToDateTime(dr["AutoPrepayEffectiveDate"]);
                _dealDC.maxMaturityDate = CommonHelper.ToDateTime(dr["FullyExtendedMaturityDate"]);


                lstDealDC.Add(_dealDC);
            }
            return lstDealDC;
        }


        public bool CopyDeal(DealDataContract dealDC, string CreatedBy, string delegateduserid)
        {
            Helper.Helper hp = new Helper.Helper();
            int result;
            DataTable dtNote = new DataTable();
            dtNote.Columns.Add("AccountID");
            dtNote.Columns.Add("NoteId");
            dtNote.Columns.Add("CRENoteID");
            dtNote.Columns.Add("Name");
            dtNote.Columns.Add("DealID");



            if (dealDC.notelist.Count != 0)
            {

                for (var i = 0; i < dealDC.notelist.Count; i++)
                {
                    dealDC.notelist[i].CRENoteID = dealDC.notelist[i].CRENewNoteID;
                }
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(dealDC.notelist);

                foreach (DataRow dr in dt.Rows)
                {
                    dtNote.ImportRow(dr);
                }

                SqlParameter p1 = new SqlParameter { ParameterName = "@Tabletypenote", Value = dtNote };
                SqlParameter p2 = new SqlParameter { ParameterName = "@CREDealID", Value = dealDC.CREDealID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@DealName", Value = dealDC.DealName };
                SqlParameter p4 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
                SqlParameter p5 = new SqlParameter { ParameterName = "@DelegatedUserID", Value = delegateduserid };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
                result = hp.ExecDataTablewithparams("dbo.usp_CopyDeal", sqlparam);
                return true;
            }
            else
            {

                return false;
            }



        }


        public List<DealDataContract> SearchDealByCREDealIdOrDealName(DealDataContract dealDC)
        {
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            List<DateTime> lst = new List<DateTime>();
            DateTime dt1 = DateTime.Now;
            lst.Add(dt1);

            List<DealDataContract> lstDealDC = new List<DealDataContract>();

            SqlParameter p1 = new SqlParameter { ParameterName = "@CREDealId", Value = dealDC.CREDealID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_SearchDeal", sqlparam);

            //  var lstDeal = dbContext.usp_SearchDeal(dealDC.CREDealID).ToList();

            foreach (DataRow dr in dt.Rows)
            {
                DealDataContract _dealDC = new DealDataContract();
                _dealDC.DealID = new Guid(Convert.ToString(dr["DealID"]));
                _dealDC.DealName = Convert.ToString(dr["DealName"]);
                _dealDC.DealType = CommonHelper.ToInt32(dr["DealType"]);
                _dealDC.Statusid = CommonHelper.ToInt32(dr["Status"]);
                _dealDC.StatusText = Convert.ToString(dr["StatusText"]);

                if (Convert.ToString(dr["EstClosingDate"]) != "")
                    _dealDC.EstClosingDate = CommonHelper.ToDateTime(dr["EstClosingDate"]);

                _dealDC.AssetManager = Convert.ToString(dr["AssetManager"]);
                _dealDC.CREDealID = Convert.ToString(dr["CREDealID"]);
                lstDealDC.Add(_dealDC);
            }
            return lstDealDC;
        }

        public void DeleteModuleByID(DeleteModuleDataContract ModuleDC)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserId", Value = ModuleDC.UserId };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ModuleName", Value = ModuleDC.ModuleName };
                SqlParameter p3 = new SqlParameter { ParameterName = "@ModuleID", Value = ModuleDC.ModuleID };
                SqlParameter p4 = new SqlParameter { ParameterName = "@LookupID", Value = ModuleDC.LookupID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
                hp.ExecNonquery("dbo.usp_DeleteModuleByID", sqlparam);
                //  var lstDeal = dbContext.usp_DeleteModuleByID(ModuleDC.UserId, ModuleDC.ModuleName, ModuleDC.ModuleID, ModuleDC.LookupID);
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }

        public int CallDealForCalculation(string Dealdid, string Updatedby, string AnalysisID, int CalcTyep)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = Dealdid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UpdatedBy", Value = Updatedby };
            SqlParameter p3 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@CalcType", Value = CalcTyep };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            var iscal = hp.ExecNonquery("dbo.usp_QueueDealForCalculation", sqlparam);

            // var iscal = dbContext.usp_QueueDealForCalculation(Dealdid, Updatedby, AnalysisID);
            return iscal;
        }

        public int CallDealForPrePayCalculation(string Dealdid, string Updatedby, string AnalysisID, int CalcTyep)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = Dealdid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UpdatedBy", Value = Updatedby };
            SqlParameter p3 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@CalcType", Value = CalcTyep };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            var iscal = hp.ExecNonquery("dbo.usp_QueueDealForCalculation_Prepayment", sqlparam);

            // var iscal = dbContext.usp_QueueDealForCalculation(Dealdid, Updatedby, AnalysisID);
            return iscal;
        }


        public DealDataContract CheckConcurrentUpdate(Guid? DeailId, string ModuleName, DateTime UpdatedDate)
        {
            DealDataContract _dealDC = new DealDataContract();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectID", Value = DeailId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ModuleName", Value = ModuleName };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UpdatedDate", Value = UpdatedDate };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            dt = hp.ExecDataTable("dbo.usp_CheckConcurrentUpdate", sqlparam);


            //  var _deal = dbContext.usp_CheckConcurrentUpdate(DeailId, ModuleName, UpdatedDate).FirstOrDefault();

            _dealDC.LastUpdatedFF = CommonHelper.ToDateTime(dt.Rows[0]["UpdatedDate"]);
            _dealDC.LastUpdatedByFF = Convert.ToString(dt.Rows[0]["UpdatedBy"]);

            return _dealDC;
        }

        public List<FutureFundingScheduleDetailDataContract> GetFundingDetailByDealID(Guid? dealID, Guid? userId)
        {
            List<DateTime> lst = new List<DateTime>();
            DateTime dt1 = DateTime.Now;
            lst.Add(dt1);
            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            List<FutureFundingScheduleDetailDataContract> lstFundingDealDC = new List<FutureFundingScheduleDetailDataContract>();

            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = dealID };


            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetFundingDetailByDealID", sqlparam);

            //  var lstFunding = dbContext.usp_GetFundingDetailByDealID(userId, dealID.ToString()).ToList();

            foreach (DataRow dr in dt.Rows)
            {
                FutureFundingScheduleDetailDataContract _fundingDC = new FutureFundingScheduleDetailDataContract();
                _fundingDC.NoteID = new Guid(Convert.ToString(dr["NoteID"]));
                _fundingDC.NoteName = Convert.ToString(dr["Name"]);
                _fundingDC.FundingAmount = CommonHelper.ToDecimal(dr["Value"]);
                lstFundingDealDC.Add(_fundingDC);
            }
            return lstFundingDealDC;
        }

        public List<FutureFundingScheduleDetailDataContract> GetFundingDetailByFundingID(Guid? fundingID, Guid? userId)
        {

            //  ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            List<FutureFundingScheduleDetailDataContract> lstFundingDealDC = new List<FutureFundingScheduleDetailDataContract>();
            List<DateTime> lst = new List<DateTime>();
            DateTime dt1 = DateTime.Now;
            lst.Add(dt1);
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@DealFundingID", Value = fundingID.ToString() };


            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetFundingDetailByDealFundingID", sqlparam);


            //  var lstFunding = dbContext.usp_GetFundingDetailByDealFundingID(userId, fundingID.ToString()).ToList();

            foreach (DataRow dr in dt.Rows)
            {
                FutureFundingScheduleDetailDataContract _fundingDC = new FutureFundingScheduleDetailDataContract();
                if (Convert.ToString(dr["DealFundingID"]) != "")
                {
                    _fundingDC.DealFundingID = new Guid(Convert.ToString(dr["DealFundingID"]));
                }
                if (Convert.ToString(dr["NoteID"]) != "")
                {
                    _fundingDC.NoteID = new Guid(Convert.ToString(dr["NoteID"]));
                }
                _fundingDC.NoteName = Convert.ToString(dr["Name"]);
                _fundingDC.FundingAmount = CommonHelper.ToDecimal(dr["Value"]);
                lstFundingDealDC.Add(_fundingDC);
            }
            return lstFundingDealDC;
        }


        public List<DealDataContract> GetAllDealsForTranscationsFilter(bool IsReconciled)
        {

            List<DealDataContract> lstDeals = new List<DealDataContract>();
            List<FutureFundingScheduleDetailDataContract> lstFundingDealDC = new List<FutureFundingScheduleDetailDataContract>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();

            SqlParameter p1 = new SqlParameter { ParameterName = "@IsReconciled", Value = IsReconciled };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };

            dt = hp.ExecDataTable("dbo.usp_GetAllDealsForTranscationsFilter", sqlparam);

            // var deals = dbContext.usp_GetAllDealsForTranscationsFilter();
            foreach (DataRow dr in dt.Rows)
            {
                DealDataContract dealdc = new DealDataContract();
                dealdc.DealID = new Guid(Convert.ToString(dr["DealID"]));
                dealdc.CREDealID = Convert.ToString(dr["CREDealId"]);
                dealdc.DealName = Convert.ToString(dr["DealName"]);
                lstDeals.Add(dealdc);
            }
            return lstDeals;

        }

        //public void LogDealFundingActivity(List<PayruleNoteAMSequenceDataContract> NoteSequence, List<PayruleDealFundingDataContract> dealfunding, string userid)
        //{
        //    try
        //    {
        //        //dbContext.usp_InsertDealFundingActivityLog(NoteSequence.ToXML(), dealfunding.ToXML(), userid);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}

        public void InsertUpdateAutoSpreadRule(List<AutoSpreadRuleDataContract> _autospreadruleDC)
        {

            if (_autospreadruleDC != null)
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@XMLAutoSpread", Value = _autospreadruleDC.ToXML().Replace(" xsi:nil=\"true\"", "") };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                hp.ExecNonquery("usp_InsertAutoSpreadRule", sqlparam);
            }
        }

        public List<AutoSpreadRuleDataContract> GetAutoSpreadRuleByDealID(Guid? UserId, Guid? dealID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            List<AutoSpreadRuleDataContract> lstautospreadrule = new List<AutoSpreadRuleDataContract>();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = dealID };
            SqlParameter[] sqlparam11 = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetAutoSpreadRuleByDealID", sqlparam11);

            //  var autospreadrule = dbContext.usp_GetAutoSpreadRuleByDealID(UserId, dealID);
            foreach (DataRow dr in dt.Rows)
            {
                AutoSpreadRuleDataContract _autospreadruleDC = new AutoSpreadRuleDataContract();
                if (Convert.ToString(dr["AutoSpreadRuleID"]) != "")
                {
                    _autospreadruleDC.AutoSpreadRuleID = new Guid(Convert.ToString(dr["AutoSpreadRuleID"]));
                }
                _autospreadruleDC.PurposeType = CommonHelper.ToInt32(dr["PurposeType"]);
                //_autospreadruleDC.PurposeSubType = Convert.ToString(dr["PurposeSubType"]);
                _autospreadruleDC.DebtAmount = CommonHelper.ToDecimal(dr["DebtAmount"]);
                _autospreadruleDC.EquityAmount = CommonHelper.ToDecimal(dr["EquityAmount"]);
                _autospreadruleDC.StartDate = CommonHelper.ToDateTime(dr["StartDate"]);
                _autospreadruleDC.EndDate = CommonHelper.ToDateTime(dr["EndDate"]);
                _autospreadruleDC.DistributionMethod = CommonHelper.ToInt32(dr["DistributionMethod"]);
                _autospreadruleDC.FrequencyFactor = CommonHelper.ToInt32(dr["FrequencyFactor"]);
                _autospreadruleDC.Comment = Convert.ToString(dr["Comment"]);
                _autospreadruleDC.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                _autospreadruleDC.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                _autospreadruleDC.PurposeTypeText = Convert.ToString(dr["PurposeTypeText"]);
                _autospreadruleDC.DistributionMethodText = Convert.ToString(dr["DistributionMethodText"]);
                _autospreadruleDC.RequiredEquity = CommonHelper.ToDecimal(dr["RequiredEquity"]);
                _autospreadruleDC.AdditionalEquity = CommonHelper.ToDecimal(dr["AdditionalEquity"]);

                lstautospreadrule.Add(_autospreadruleDC);
            }
            return lstautospreadrule;

        }
        public int ImportDealByCREDealID(string CREDealID, string envname, string NewCREDealID, string NewDealName, string UserID, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@CREDealID", Value = CREDealID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@Env", Value = envname };
            SqlParameter p3 = new SqlParameter { ParameterName = "@NewCREDealID", Value = NewCREDealID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@NewDealName", Value = NewDealName };
            SqlParameter p5 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UserID };
            SqlParameter p6 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = 10 };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };
            hp.ExecDataTable("dbo.usp_CopyDealFromSource", sqlparam);
            TotalCount = string.IsNullOrEmpty(Convert.ToString(p6.Value)) ? 0 : Convert.ToInt32(p6.Value);
            var dealCount = Convert.ToInt32(TotalCount);
            return dealCount;
        }

        public void DeleteDealByCREDealID(string CREDealID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@CREDealID", Value = CREDealID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            hp.ExecNonquery("dbo.usp_DeleteDealWithNote", sqlparam);
        }
        public void UpdateWireConfirmedForPhantomDeal(string CREDealID)
        {

            DataTable dt = new DataTable();

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@CREDealID", Value = CREDealID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("usp_UpdateWireConfirmedForPhantomDeal", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
        }

        public List<DealAmortScheduleDataContract> GetDealAmortizationByDealID(Guid? dealID)
        {


            List<DealAmortScheduleDataContract> _dmList = new List<DealAmortScheduleDataContract>();

            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = dealID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("usp_GetDealAmortizationByDealID", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                DealAmortScheduleDataContract _ndc = new DealAmortScheduleDataContract();
                // _ndc.DealAmortizationScheduleAutoID = CommonHelper.ToInt32(dr["DealAmortizationScheduleAutoID"]);
                _ndc.DealAmortizationScheduleID = CommonHelper.ToGuid(dr["DealAmortizationScheduleID"]);
                _ndc.DealID = CommonHelper.ToGuid(dr["DealID"]);
                _ndc.Date = CommonHelper.ToDateTime(dr["Date"]);
                _ndc.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                _ndc.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                _ndc.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                _ndc.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                _ndc.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);

                _dmList.Add(_ndc);
            }
            return _dmList;
        }
        public void SaveDealAmortization(List<DealAmortScheduleDataContract> dealAM, int? AmortizationMethod)
        {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@XMLDealAmortization", Value = dealAM.ToXML() };
                SqlParameter p2 = new SqlParameter { ParameterName = "@isDeleteOldAmortSchedule", Value = dealAM[0].IsDelete };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                int res = hp.ExecNonquery("usp_SaveDealAmortization", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

        }
        public int SaveNoteAmortization(List<NoteAmortScheduleDataContract> NoteAM, string createdby)
        {
            int res = 0;
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                if (NoteAM.Count > 0)
                {

                    DataTable dtNoteAmort = new DataTable();

                    dtNoteAmort.Columns.Add("NoteID");
                    dtNoteAmort.Columns.Add("Value");
                    dtNoteAmort.Columns.Add("Date");
                    dtNoteAmort.Columns.Add("AccountId");
                    //  dtNoteAmort.Columns.Add("DealAmortizationScheduleAutoID");
                    dtNoteAmort.Columns.Add("DealAmortScheduleRowno");

                    if (NoteAM != null)
                    {
                        DataTable dt = new DataTable();
                        dt = ObjToDataTable.ToDataTable(NoteAM);

                        foreach (DataRow dr in dt.Rows)
                        {

                            dtNoteAmort.ImportRow(dr);
                        }
                    }

                    Helper.Helper hp = new Helper.Helper();
                    SqlParameter p1 = new SqlParameter { ParameterName = "@notefunding", Value = dtNoteAmort };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy", Value = createdby };
                    SqlParameter p3 = new SqlParameter { ParameterName = "@UpdatedBy", Value = createdby };
                    SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                    res = hp.ExecNonquery("usp_InsertUpdateAmortSchedule", sqlparam);
                }

            }
            catch (Exception ex)
            {

            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            return res;

        }
        public void DeleteNoteFundingDataForDealFundingID(Guid? DealID)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                int res = hp.ExecNonquery("usp_DeleteNoteFundingDataForDealFundingID", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertUpdateDealAmortSchedule(List<DealAmortScheduleDataContract> DealAmortSchedule, string username)
        {
            Helper.Helper hp = new Helper.Helper();
            DataTable dtAmort = new DataTable();

            dtAmort.Columns.Add("NoteID");
            dtAmort.Columns.Add("SequenceNo");
            dtAmort.Columns.Add("SequenceType");
            dtAmort.Columns.Add("Value");

            if (DealAmortSchedule != null)
            {
                DataTable dt = new DataTable();
                dt = ObjToDataTable.ToDataTable(DealAmortSchedule);

                foreach (DataRow dr in dt.Rows)
                {

                    dtAmort.ImportRow(dr);
                }
            }

            if (dtAmort.Rows.Count > 0)
            {
                hp.BatchUpdateOrInsert("usp_InsertUpdateAmortSequence", dtAmort, username, "AmortSequence");
            }
        }



        public DataTable GetAmortScheduleForCustomNoteAmortization(string dealID, int? AmortizationMethod, string UserID)
        {


            DataTable dt = new DataTable();

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = dealID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@AmortizationMethod", Value = AmortizationMethod };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dt = hp.ExecDataTable("usp_GetNoteDealAmortizationScheduleDealID", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            return dt;
        }
        public DataTable GetAmortScheduleFormStartENDDate(string dealID, int? AmortizationMethod, string UserID, string startDate, string EndDate)
        {

            DataTable dt = new DataTable();
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = dealID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@AmortizationMethod", Value = AmortizationMethod };
                SqlParameter p4 = new SqlParameter { ParameterName = "@StartDate", Value = startDate };
                SqlParameter p5 = new SqlParameter { ParameterName = "@EndDate", Value = EndDate };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
                dt = hp.ExecDataTable("usp_GetNoteDealAmortizationScheduleDealIDFromStartEndDate", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            return dt;
        }
        public DataTable GetDealNoteFundingDiscrepancy()
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("dbo.usp_GetDealNoteFundingDiscrepancy");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }


        public DataTable GetFixedPaymentAmortizationByDealID(string dealID, string UserID, decimal? FixedPayment, string MutipleNoteId, string startDate, string EndDate)
        {

            DataTable dt = new DataTable();
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = dealID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@MultipleNoteids ", Value = MutipleNoteId };
                SqlParameter p4 = new SqlParameter { ParameterName = "@StartDate", Value = startDate };
                SqlParameter p5 = new SqlParameter { ParameterName = "@EndDate", Value = EndDate };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
                dt = hp.ExecDataTable("usp_GetFixedPaymentAmortizationByDealID", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            return dt;
        }
        public DataSet GetNoteAllocationPercentage(Guid? DealFundingID, string userID)
        {
            DataSet ds = new DataSet();
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(userID) };
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealFundingID", Value = DealFundingID };
                SqlParameter[] sqlparam = new SqlParameter[] { p0, p1 };
                ds = hp.ExecDataSet("usp_GetNoteAllocationPercentage", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            return ds;
        }

        public DataTable GetAdjustmentTotalCommitmentByDealID(Guid? DealID, Guid? UserID)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                // dt = hp.ExecDataTable("usp_GetAdjustmentCommitmentByDealID_forAPI", sqlparam);
                dt = hp.ExecDataTable("usp_GetAdjustmentCommitmentByDealID", sqlparam);

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }


        public DataTable GetAdjustmentTotalCommitmentByDealIDForAPI(Guid? DealID, Guid? UserID)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("usp_GetAdjustmentCommitmentByDealID_forAPI", sqlparam);
                // dt = hp.ExecDataTable("usp_GetAdjustmentCommitmentByDealID", sqlparam);

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }
        public void InsertUpdateAdjustedTotalCommitment(List<AdjustedTotalCommitmentDataContract> _adjustedtotalcommitmentDC, Guid UserID)
        {
            Helper.Helper hp = new Helper.Helper();
            int result;
            DataTable dtnotecommitment = new DataTable();
            dtnotecommitment.Columns.Add("NoteAdjustedCommitmentMasterID");
            dtnotecommitment.Columns.Add("DealID");
            dtnotecommitment.Columns.Add("Date", typeof(System.DateTime));
            dtnotecommitment.Columns.Add("Type");
            dtnotecommitment.Columns.Add("Rownumber");
            dtnotecommitment.Columns.Add("DealAdjustmentHistory");
            dtnotecommitment.Columns.Add("AdjustedCommitment");
            dtnotecommitment.Columns.Add("TotalCommitment");
            dtnotecommitment.Columns.Add("AggregatedCommitment");
            dtnotecommitment.Columns.Add("Comments");
            dtnotecommitment.Columns.Add("NoteID");
            dtnotecommitment.Columns.Add("Amount");
            dtnotecommitment.Columns.Add("NoteAdjustedTotalCommitment");
            dtnotecommitment.Columns.Add("NoteAggregatedTotalCommitment");
            dtnotecommitment.Columns.Add("NoteTotalCommitment");
            dtnotecommitment.Columns.Add("TotalRequiredEquity");
            dtnotecommitment.Columns.Add("TotalAdditionalEquity");
            dtnotecommitment.Columns.Add("ExcludeFromCommitmentCalculation");
            dtnotecommitment.Columns.Add("TotalEquityatClosing");
            if (_adjustedtotalcommitmentDC.Count != 0)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(_adjustedtotalcommitmentDC);

                foreach (DataRow dr in dt.Rows)
                {
                    dtnotecommitment.ImportRow(dr);
                }

                SqlParameter p1 = new SqlParameter { ParameterName = "@TableAdjustedTotalCommitment", Value = dtnotecommitment };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                result = hp.ExecDataTablewithparams("dbo.usp_InsertUpdateAdjustedTotalCommitment", sqlparam);

            }
        }

        public DataTable GetDiscrepancyForExitAndExtentionStripReceiveable()
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("dbo.usp_GetDiscrepancyForExitAndExtentionStripReceiveable");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }



        public PayloadDataContract GetPayLoad(Guid DealID, string CREDEalID, string DealName)
        {

            PayloadDataContract PayloadDC = new PayloadDataContract();
            List<note> lstnotes = new List<note>();

            //note.notePeriodicOutput = new List<NotePeriodicOutput>();
            DataSet ds = new DataSet();
            DataTable dtnote = new DataTable();
            DataTable dtNotePer = new DataTable();
            DataTable dtRateSpreadSchedule = new DataTable();
            PayloadDC.CREDealID = CREDEalID;
            PayloadDC.DealName = DealName;
            PayloadDC.prepay_types = new string[] { };
            //PayloadDC.prepay_types.Add("yield_maintenance");          
            PayloadDC.DealID = DealID.ToString();
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@CREDealID", Value = CREDEalID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                ds = hp.ExecDataSet("usp_GetNoteByDealID_PrepayLoad", sqlparam);

                dtnote = ds.Tables[0];
                dtRateSpreadSchedule = ds.Tables[1];

                SqlParameter np1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter np2 = new SqlParameter { ParameterName = "@CREDealID", Value = CREDEalID };

                SqlParameter[] sqlparamnp = new SqlParameter[] { np1, np2 };
                dtNotePer = hp.ExecDataTable("usp_GetNotePeriodicCalcByDealID_PrepayLoad", sqlparamnp);


                foreach (DataRow drnote in dtnote.Rows)
                {
                    note note = new note();
                    note.CRENoteID = drnote["CRENoteID"].ToString();
                    note.NoteName = drnote["NoteName"].ToString();
                    note.NoteID = drnote["NoteID"].ToString();
                    note.LienPosition = drnote["LienPosition"].ToString();
                    note.TotalCommitment = drnote["TotalCommitment"].ToString();

                    note.LoanOriginationDate = drnote["ClosingDate"].ToString();
                    note.InitialMaturityDate = drnote["InitialMaturityDate"].ToString();
                    note.FullExtendedMaturityDate = drnote["FullyExtendedMaturityDate"].ToString();
                    note.ActualPayOffDate = drnote["ActualPayOffDate"].ToString();


                    List<notePeriodicOutput> lstNotePeriodicOutput = new List<notePeriodicOutput>();

                    foreach (DataRow drNotePer in dtNotePer.Rows)
                    {
                        if (drNotePer["CRENoteID"].ToString() == note.CRENoteID)
                        {
                            notePeriodicOutput notePeriodicOutput = new notePeriodicOutput();
                            notePeriodicOutput.Period = drNotePer["Period"].ToString();
                            notePeriodicOutput.CRENoteID = drNotePer["CRENoteID"].ToString();
                            notePeriodicOutput.PeriodEndDate = Convert.ToDateTime(drNotePer["PeriodEndDate"]).ToShortDateString().ToString();
                            notePeriodicOutput.Month = drNotePer["Month"].ToString();
                            notePeriodicOutput.AllInCouponRate = drNotePer["AllInCouponRate"].ToString();
                            notePeriodicOutput.BeginningBalance = drNotePer["BeginningBalance"].ToString();
                            notePeriodicOutput.InterestReceivedinCurrentPeriod = drNotePer["InterestReceivedinCurrentPeriod"].ToString();
                            notePeriodicOutput.PrincipalPaid = drNotePer["PrincipalPaid"].ToString();
                            notePeriodicOutput.EndingBalance = drNotePer["EndingBalance"].ToString();
                            // notePeriodicOutput.LoanAmount = drNotePer["LoanAmount"].ToString();
                            //  notePeriodicOutput.LoanDuration = drNotePer["LoanDuration"].ToString();
                            lstNotePeriodicOutput.Add(notePeriodicOutput);
                        }
                    }




                    List<rateSpreadSchedule> lstRateSpreadSchedule = new List<rateSpreadSchedule>();
                    foreach (DataRow drRate in dtRateSpreadSchedule.Rows)
                    {
                        rateSpreadSchedule rateSpreadSch = new rateSpreadSchedule();
                        if (drRate["CRENoteID"].ToString() == note.CRENoteID)
                        {
                            rateSpreadSch.EffectiveStartDate = drRate["EffectiveStartDate"].ToString();
                            rateSpreadSch.Date = drRate["Date"].ToString();
                            rateSpreadSch.ValueTypeID = drRate["ValueTypeID"].ToString();
                            rateSpreadSch.Value = drRate["Value"].ToString();
                            rateSpreadSch.IntCalcMethodID = drRate["IntCalcMethodID"].ToString();
                            rateSpreadSch.ValueTypeText = drRate["ValueTypeText"].ToString();
                            rateSpreadSch.IntCalcMethodText = drRate["IntCalcMethodText"].ToString();
                            lstRateSpreadSchedule.Add(rateSpreadSch);
                        }
                    }
                    note.RateSpreadSchedule = lstRateSpreadSchedule;
                    note.NotePeriodicOutput = lstNotePeriodicOutput;
                    lstnotes.Add(note);
                }

                PayloadDC.notes = lstnotes;
                //  PayloadDC.notes.NotePeriodicOutput = lstNotePeriodicOutput;

            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used



            return PayloadDC;
        }

        public void DeletedAdjustedTotalCommitment(Guid DealID, List<AdjustedTotalCommitmentDataContract> _deleteadjustedcommitment)
        {
            Helper.Helper hp = new Helper.Helper();
            int result;
            DataTable dtnotecommitment = new DataTable();
            dtnotecommitment.Columns.Add("NoteAdjustedCommitmentMasterID");
            dtnotecommitment.Columns.Add("DealID");
            dtnotecommitment.Columns.Add("Date", typeof(System.DateTime));
            dtnotecommitment.Columns.Add("Type");
            dtnotecommitment.Columns.Add("Rownumber");
            dtnotecommitment.Columns.Add("DealAdjustmentHistory");
            dtnotecommitment.Columns.Add("AdjustedCommitment");
            dtnotecommitment.Columns.Add("TotalCommitment");
            dtnotecommitment.Columns.Add("AggregatedCommitment");
            dtnotecommitment.Columns.Add("Comments");
            dtnotecommitment.Columns.Add("NoteID");
            dtnotecommitment.Columns.Add("Amount");
            dtnotecommitment.Columns.Add("NoteAdjustedTotalCommitment");
            dtnotecommitment.Columns.Add("NoteAggregatedTotalCommitment");
            dtnotecommitment.Columns.Add("NoteTotalCommitment");
            dtnotecommitment.Columns.Add("TotalRequiredEquity");
            dtnotecommitment.Columns.Add("TotalAdditionalEquity");
            dtnotecommitment.Columns.Add("ExcludeFromCommitmentCalculation");
            dtnotecommitment.Columns.Add("TotalEquityatClosing");
            if (_deleteadjustedcommitment.Count != 0)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(_deleteadjustedcommitment);

                foreach (DataRow dr in dt.Rows)
                {
                    dtnotecommitment.ImportRow(dr);
                }

                SqlParameter p1 = new SqlParameter { ParameterName = "@TableAdjustedTotalCommitment", Value = dtnotecommitment };
                SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = DealID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                result = hp.ExecDataTablewithparams("dbo.usp_DeleteAdjustedTotalCommitment", sqlparam);
            }
        }

        public List<NoteAmortFundingDataContract> GetNoteEndingBalanceByDealID(Guid? UserId, Guid? DealID, DateTime AmortStartDate, DateTime? AmortEndDate)
        {

            List<NoteAmortFundingDataContract> _noteendingList = new List<NoteAmortFundingDataContract>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            try
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserId };
                SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@AmortStartDate", Value = AmortStartDate };
                SqlParameter p4 = new SqlParameter { ParameterName = "@AmortEndDate", Value = AmortEndDate };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
                dt = hp.ExecDataTable("usp_GetNoteEndingBalanceByDealID", sqlparam);
                foreach (DataRow dr in dt.Rows)
                {
                    NoteAmortFundingDataContract _nadc = new NoteAmortFundingDataContract();
                    _nadc.NoteID = Convert.ToString(dr["NoteID"]);
                    _nadc.EndingBalance = CommonHelper.ToDecimal(dr["EndingBalance"]);
                    _nadc.Date = Convert.ToDateTime(dr["Date"]);
                    _noteendingList.Add(_nadc);
                }
                return _noteendingList;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<IDValueDataContract> GetScheduledPrincipalByDealID(Guid? UserId, string DealID)
        {

            List<IDValueDataContract> _noteendingList = new List<IDValueDataContract>();
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            try
            {

                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserId };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("usp_GetScheduledPrincipalByDealID", sqlparam);
                foreach (DataRow dr in dt.Rows)
                {
                    IDValueDataContract _nadc = new IDValueDataContract();
                    _nadc.NoteID = Convert.ToString(dr["NoteID"]);
                    _nadc.Amount = Convert.ToDecimal(dr["Amount"]);
                    _noteendingList.Add(_nadc);
                }
                return _noteendingList;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetInterestPaidTransactionEntry(Guid? headerUserID, Guid? dealid, string MutipleNoteId, DateTime StartDate, DateTime? EndDate)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserId", Value = headerUserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = dealid };
                SqlParameter p3 = new SqlParameter { ParameterName = "@MultipleNoteids", Value = MutipleNoteId };
                SqlParameter p4 = new SqlParameter { ParameterName = "@StartDate", Value = StartDate };
                SqlParameter p5 = new SqlParameter { ParameterName = "@EndDate", Value = EndDate };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
                dt = hp.ExecDataTable("usp_GetInterestPaidTransactionEntry", sqlparam);
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DataTable GetDiscrepancyForFFBetweenM61andBackshop()
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("dbo.usp_GetDiscrepancyForFFBetweenM61andBackshop");
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteDealAmortizationScheduleDealID(Guid? DealID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                int res = hp.ExecNonquery("usp_DeleteDealAmortizationScheduleDealID", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable DeleteDealandNoteAIEntity(Guid Userid, string Modulename, Guid moduleID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserId", Value = Userid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ModuleName", Value = Modulename };
                SqlParameter p3 = new SqlParameter { ParameterName = "@ModuleID", Value = moduleID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dt = hp.ExecDataTable("usp_GetDealIdandNoteIdforAIdeleteEntity", sqlparam);
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public PayruleDealFundingDataContract GetDealFundingByDealFundingID(string Userid, Guid? dealFundingID)
        {
            PayruleDealFundingDataContract _fundingDC = new PayruleDealFundingDataContract();

            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = Userid };
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealFundingID", Value = dealFundingID };

            SqlParameter[] sqlparam = new SqlParameter[] { p0, p1 };
            dt = hp.ExecDataTable("dbo.usp_GetDealFundingByDealfundingID", sqlparam);
            //var lstFunding = dbContext.usp_GetDealFundingScheduleByDealID(dealID).ToList();

            foreach (DataRow dr in dt.Rows)
            {

                _fundingDC.DealID = new Guid(Convert.ToString(dr["DealID"]));
                _fundingDC.Date = CommonHelper.ToDateTime(dr["Date"]);

                _fundingDC.DealFundingID = new Guid(Convert.ToString(dr["DealFundingID"]));
                _fundingDC.Value = CommonHelper.ToDecimal(dr["Amount"]);
                _fundingDC.Comment = Convert.ToString(dr["Comment"]);
                _fundingDC.PurposeID = CommonHelper.ToInt32(dr["PurposeID"]);
                _fundingDC.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                _fundingDC.Applied = CommonHelper.ToBoolean(dr["Applied"]); //_funding.Applied==true?"Y":"N";                
                //_fundingDC.DrawFundingId = _funding.DrawFundingId;
                _fundingDC.DealFundingRowno = CommonHelper.ToInt32(dr["DealFundingRowno"]);
                break;
            }
            return _fundingDC;
        }

        public List<ProjectedPayoffDataContract> GetProjectedPayOffDateByDealID(string Userid, Guid? DealID, int DealStatus)
        {
            List<ProjectedPayoffDataContract> _lstprojectedPayOffDC = new List<ProjectedPayoffDataContract>();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = Userid };
                SqlParameter p3 = new SqlParameter { ParameterName = "@DealStatus", Value = DealStatus };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dt = hp.ExecDataTable("dbo.usp_GetProjectedPayOffFromBackshopByDealID", sqlparam);
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        ProjectedPayoffDataContract _projectedPayOffDC = new ProjectedPayoffDataContract();
                        _projectedPayOffDC.EarliestDate = CommonHelper.ToDateTime(dr["EarliestDate"]);
                        _projectedPayOffDC.ExpectedDate = CommonHelper.ToDateTime(dr["ExpectedDate"]);
                        _projectedPayOffDC.LatestDate = CommonHelper.ToDateTime(dr["LatestDate"]);
                        _projectedPayOffDC.AuditUpdateDate = CommonHelper.ToDateTime(dr["AuditUpdateDate"]);
                        _projectedPayOffDC.ProjectedPayoffAsofDate = CommonHelper.ToDateTime(dr["AsOfDate"]);
                        _projectedPayOffDC.CumulativeProbability = CommonHelper.ToDecimal(dr["CumulativeProbability"]);
                        _projectedPayOffDC.ErrorMsg = "Success";
                        _projectedPayOffDC.Status = "Success";
                        _projectedPayOffDC.ExceptionMsg = "No Exception";
                        _lstprojectedPayOffDC.Add(_projectedPayOffDC);
                    }
                }
                else
                {
                    ProjectedPayoffDataContract _projectedPayOffDC = new ProjectedPayoffDataContract();
                    _projectedPayOffDC.ErrorMsg = "No data for the deal in Backshop.";
                    _projectedPayOffDC.Status = "No length";
                    _projectedPayOffDC.ExceptionMsg = "No Exception";
                    _lstprojectedPayOffDC.Add(_projectedPayOffDC);
                }
                return _lstprojectedPayOffDC;
            }
            catch (Exception ex)
            {
                ProjectedPayoffDataContract _projectedPayOffDC = new ProjectedPayoffDataContract();
                _projectedPayOffDC.ExceptionMsg = ExceptionHelper.GetFullMessage(ex);
                _projectedPayOffDC.ErrorMsg = "Backshop error.";
                _projectedPayOffDC.Status = "Error";
                _lstprojectedPayOffDC.Add(_projectedPayOffDC);
                return _lstprojectedPayOffDC;

            }
        }
        public void SaveProjectedPayOffDateByDealID(List<ProjectedPayoffDataContract> projectedpayoffdate, Guid? CreatedBy)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dtprojectedpayoffdate = new DataTable();
                dtprojectedpayoffdate.Columns.Add("DealID");
                dtprojectedpayoffdate.Columns.Add("ProjectedPayoffAsofDate", typeof(System.DateTime));
                dtprojectedpayoffdate.Columns.Add("CumulativeProbability");


                if (projectedpayoffdate.Count != 0)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(projectedpayoffdate);

                    foreach (DataRow dr in dt.Rows)
                    {
                        dtprojectedpayoffdate.ImportRow(dr);
                    }

                    SqlParameter p1 = new SqlParameter { ParameterName = "@TableTypeProjectedPayOffDate", Value = dtprojectedpayoffdate };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };

                    SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                    hp.ExecDataTablewithparams("dbo.usp_InsertProjectedPayOffDateByDealID", sqlparam);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<AutoRepaymentBalancesDataContract> GetAutospreadRepaymentBalancesDealID(Guid? DealID)
        {
            try
            {
                List<AutoRepaymentBalancesDataContract> _lstautorepaybalDC = new List<AutoRepaymentBalancesDataContract>();
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetAutospreadRepaymentBalances", sqlparam);


                foreach (DataRow dr in dt.Rows)
                {
                    AutoRepaymentBalancesDataContract _autorepaybalancesDC = new AutoRepaymentBalancesDataContract();
                    _autorepaybalancesDC.DealID = Convert.ToString(dr["DealID"]);
                    _autorepaybalancesDC.Date = CommonHelper.ToDateTime(dr["Date"]);
                    _autorepaybalancesDC.Type = Convert.ToString(dr["Type"]);
                    _autorepaybalancesDC.Amount = CommonHelper.ToDecimal(dr["Amount"]);

                    _lstautorepaybalDC.Add(_autorepaybalancesDC);
                }
                return _lstautorepaybalDC;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public Decimal GetEndingBalanceByDate(Guid? DealID, DateTime BalanceAsofDate)
        {
            try
            {
                Decimal? endingbalance = 0;
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@BalanceAsofDate", Value = BalanceAsofDate };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetEndingBalanceByDate", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    if (dr["EndingBalance"] != null)
                    {
                        endingbalance = CommonHelper.ToDecimal(dr["EndingBalance"]);
                    }


                }
                return endingbalance.GetValueOrDefault(0);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DataTable GetProjectedPayOffDBDataByDealID(Guid? DealID, string UserID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetProjectedPayOffDataByDealID", sqlparam);
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }



        public List<NoteEndingBalanceDataContract> GetNoteEndingBalaceByDate(Guid? DealID, DateTime BalanceAsofDate)
        {
            List<NoteEndingBalanceDataContract> lstNoteEndingBalance = new List<NoteEndingBalanceDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@BalanceAsofDate", Value = BalanceAsofDate };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            DataTable dt = hp.ExecDataTable("dbo.usp_GetNoteEndingBalanceByDate", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                NoteEndingBalanceDataContract NoteEndingDC = new NoteEndingBalanceDataContract();
                NoteEndingDC.Date = Convert.ToDateTime(dr["Date"]);
                NoteEndingDC.EndingBalance = Convert.ToDecimal(dr["EndingBalance"]);
                NoteEndingDC.NoteID = Convert.ToString(dr["NoteID"]);
                NoteEndingDC.NotenName = Convert.ToString(dr["Name"]);
                lstNoteEndingBalance.Add(NoteEndingDC);
            }
            return lstNoteEndingBalance;


        }



        public List<AutoRepaymentNoteBalancesDataContract> GetNoteAutospreadRepaymentBalancesByDealId(Guid? DealID)
        {
            try
            {
                List<AutoRepaymentNoteBalancesDataContract> _lstautorepaybalNoteDC = new List<AutoRepaymentNoteBalancesDataContract>();
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetNoteAutospreadRepaymentBalancesByDealId", sqlparam);


                foreach (DataRow dr in dt.Rows)
                {
                    AutoRepaymentNoteBalancesDataContract _autorepaybalancesnoteDC = new AutoRepaymentNoteBalancesDataContract();
                    _autorepaybalancesnoteDC.NoteID = Convert.ToString(dr["NoteID"]);
                    _autorepaybalancesnoteDC.Date = CommonHelper.ToDateTime(dr["Date"]);
                    _autorepaybalancesnoteDC.Type = Convert.ToString(dr["Type"]);
                    _autorepaybalancesnoteDC.Amount = CommonHelper.ToDecimal(dr["Amount"]);

                    _lstautorepaybalNoteDC.Add(_autorepaybalancesnoteDC);
                }
                return _lstautorepaybalNoteDC;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<V1CalculationStatusDataContract> GetParnetNotesInaDealForCalculation(string DealID)
        {
            try
            {
                List<V1CalculationStatusDataContract> _lstnotes = new List<V1CalculationStatusDataContract>();
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetParnetNotesInaDealForCalculation", sqlparam);
                foreach (DataRow dr in dt.Rows)
                {
                    V1CalculationStatusDataContract sdc = new V1CalculationStatusDataContract();
                    sdc.objectID = Convert.ToString(dr["NoteID"]);
                    _lstnotes.Add(sdc);
                }
                return _lstnotes;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DataTable GetMaturityByDealID(string UserID, string DealId, string NoteId)
        {

            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealId };
                SqlParameter p2 = new SqlParameter { ParameterName = "@NoteID", Value = NoteId };
                SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dt = hp.ExecDataTable("dbo.usp_GetMaturityByDealID", sqlparam);
            }
            catch (Exception ex)
            {
                var exception = ex.Message;
            }
            return dt;

        }

        public DataTable GetScheduleEffectiveDateCountByDealId(string DealID)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                {
                    SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                    //SqlParameter p2 = new SqlParameter { ParameterName = "@MultipleNoteids", Value = MultipleNoteids};
                    SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                    dt = hp.ExecDataTable("usp_GetScheduleEffectiveDateCountByDealId", sqlparam);
                }
            }
            catch (Exception ex)
            {
                var exception = ex.Message;
            }
            return dt;

        }


        public DataTable GetAllReserveAccountByDealId(string UserId, string DealID)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();

                {
                    SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserId };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                    SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                    dt = hp.ExecDataTable("usp_GetAllReserveAccountByDealId", sqlparam);

                }
            }
            catch (Exception ex)
            {
                var exception = ex.Message;
            }
            return dt;
        }


        public DataTable InsertUpdateReserveAccount(DataTable dtReserveAccount, string UserID)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();


                SqlParameter p1 = new SqlParameter { ParameterName = "@tblTypeReserveAccount", Value = dtReserveAccount };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_InsertUpdateReserveAccount", sqlparam);
            }
            catch (Exception ex)
            {
                var exception = ex.Message;
            }
            return dt;
        }

        public DataTable GetReserveScheduleByDealId(string UserId, string DealID)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                {
                    SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserId };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                    SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                    dt = hp.ExecDataTable("usp_GetReserveScheduleByDealId", sqlparam);
                    if (dt.Rows.Count == 0)
                    {
                        DataRow dr = dt.NewRow();
                        dr["Applied"] = false;
                        dr[11] = 0;
                        dt.Rows.InsertAt(dr, 0);
                    }

                }
            }
            catch (Exception ex)
            {
                var exception = ex.Message;
            }
            return dt;
        }

        public DataTable InsertUpdateReserveSchedule(DataTable dtReserveSchedule, string UserID)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@tblTypeReserveSchedule", Value = dtReserveSchedule };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_InsertUpdateDealReserveSchedule", sqlparam);

            }
            catch (Exception ex)
            {
                var exception = ex.Message;
            }
            return dt;
        }

        public void UpdatExpectedMaturityDateByDealID(Guid DealID, DateTime? ExpectedMaturityDate, Guid UserID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ExpectedMaturityDate", Value = ExpectedMaturityDate };
                SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                hp.ExecDataTable("dbo.usp_UpdatExpectedMaturityDateByDealID", sqlparam);

            }
            catch (Exception ex)
            {
                var exception = ex.Message;
            }
        }

        public DataTable GetAllExceptionsByDealID(Guid DealID, string Type, string MultipleNoteID, Guid ScenarioID, Guid NoteID)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Type", Value = Type };
                SqlParameter p3 = new SqlParameter { ParameterName = "@MultipleNoteids", Value = MultipleNoteID };
                SqlParameter p4 = new SqlParameter { ParameterName = "@ScenarioId", Value = ScenarioID };
                SqlParameter p5 = new SqlParameter { ParameterName = "@NoteID", Value = NoteID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
                dt = hp.ExecDataTable("dbo.usp_GetAllExceptionsByObjectIDandObjectName", sqlparam);

            }
            catch (Exception ex)
            {
                var exception = ex.Message;
            }
            return dt;
        }

        public DataTable GetAllEFfectiveDatesByDealID(Guid DealID, string UserId)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserId };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetMaturityEffectiveDateInvalidateValidation", sqlparam);

            }
            catch (Exception ex)
            {
                var exception = ex.Message;
            }
            return dt;
        }
        //GetWFPayOffNoteFunding
        public DataSet GetWFPayOffNoteFunding(Guid? DealFundingID, string userID)
        {
            DataSet ds = new DataSet();
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p0 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(userID) };
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealFundingID", Value = DealFundingID };
                SqlParameter[] sqlparam = new SqlParameter[] { p0, p1 };
                ds = hp.ExecDataSet("usp_GetWFPayOffNoteFunding", sqlparam);
            }
            catch (Exception ex)
            {
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            return ds;
        }


        public DataTable GetDiscrepancyForCommitment()
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("dbo.usp_GetDiscrepancyForCommitment");
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetDiscrepancyForCommitmentData()
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("dbo.usp_GetDiscrepancyForCommitmentData");
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public string InsertUpdatePrepaySchedule(PrepayDataContract prepayDC, List<PrepayAdjustmentDataContract> listPrepayAdjustment, List<SpreadMaintenanceScheduleDataContract> listSpreadMaintenance, List<MinMultScheduleDataContract> listMiniSpreadInterest, List<FeeCreditsDataContract> listMiniFee)
        {
            string NewDeadID = "";
            Helper.Helper hp = new Helper.Helper();

            DataTable dtPrepayAdjustment = new DataTable();
            dtPrepayAdjustment.Columns.Add("PrepayAdjustmentId");
            dtPrepayAdjustment.Columns.Add("Date");
            dtPrepayAdjustment.Columns.Add("PrepayAdjAmt");
            dtPrepayAdjustment.Columns.Add("Comment");
            if (listPrepayAdjustment != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(listPrepayAdjustment);

                foreach (DataRow dr in dt.Rows)
                {
                    if (Convert.ToString(dr["Date"]) != "")
                    {

                        dtPrepayAdjustment.ImportRow(dr);
                    }
                }
            }
            DataTable dtSpreadMaintenance = new DataTable();
            dtSpreadMaintenance.Columns.Add("SpreadMaintenanceScheduleId");
            dtSpreadMaintenance.Columns.Add("NoteId");
            dtSpreadMaintenance.Columns.Add("SpreadDate");
            dtSpreadMaintenance.Columns.Add("Spread");
            dtSpreadMaintenance.Columns.Add("CalcAfterPayoff");
            if (listSpreadMaintenance != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(listSpreadMaintenance);

                foreach (DataRow dr in dt.Rows)
                {
                    if (Convert.ToString(dr["SpreadDate"]) != "")
                    {
                        dtSpreadMaintenance.ImportRow(dr);
                    }
                }
            }

            DataTable dtMiniSpreadInterest = new DataTable();
            dtMiniSpreadInterest.Columns.Add("MinMultScheduleID");
            dtMiniSpreadInterest.Columns.Add("MiniSpreadDate");
            dtMiniSpreadInterest.Columns.Add("MinMultAmount");
            if (listMiniSpreadInterest != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(listMiniSpreadInterest);

                foreach (DataRow dr in dt.Rows)
                {
                    if (Convert.ToString(dr["MiniSpreadDate"]) != "")
                    {
                        dtMiniSpreadInterest.ImportRow(dr);
                    }
                }
            }
            DataTable dtMiniFee = new DataTable();
            dtMiniFee.Columns.Add("FeeCreditsID");
            dtMiniFee.Columns.Add("FeeTypeNameText");
            dtMiniFee.Columns.Add("FeeCreditOverride");
            dtMiniFee.Columns.Add("UseActualFees");
            if (listMiniFee != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(listMiniFee);

                foreach (DataRow dr in dt.Rows)
                {
                    if (Convert.ToString(dr["FeeTypeNameText"]) != "")
                    {
                        dtMiniFee.ImportRow(dr);
                    }
                }
            }

            SqlParameter p1 = new SqlParameter { ParameterName = "@DealId", Value = prepayDC.DealID.ToString() };
            SqlParameter p2 = new SqlParameter { ParameterName = "@EffectiveDate", Value = prepayDC.EffectiveDate };
            SqlParameter p3 = new SqlParameter { ParameterName = "@CalcThru", Value = prepayDC.CalcThru };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PrepaymentMethod", Value = prepayDC.PrepaymentMethod };
            SqlParameter p5 = new SqlParameter { ParameterName = "@BaseAmountType", Value = prepayDC.BaseAmountType };
            SqlParameter p6 = new SqlParameter { ParameterName = "@SpreadCalcMethod", Value = prepayDC.SpreadCalcMethod };
            SqlParameter p7 = new SqlParameter { ParameterName = "@GreaterOfSMOrBaseAmtTimeSpread", Value = prepayDC.GreaterOfSMOrBaseAmtTimeSpread };
            SqlParameter p8 = new SqlParameter { ParameterName = "@HasNoteLevelSMSchedule", Value = prepayDC.HasNoteLevelSMSchedule };
            SqlParameter p9 = new SqlParameter { ParameterName = "@Includefeesincredits", Value = prepayDC.Includefeesincredits };
            SqlParameter p10 = new SqlParameter { ParameterName = "@CreatedBy", Value = prepayDC.CreatedBy };
            SqlParameter p11 = new SqlParameter { ParameterName = "@tblPrepayAdjustment", Value = dtPrepayAdjustment };
            SqlParameter p12 = new SqlParameter { ParameterName = "@tblSpreadMaintenanceSchedule", Value = dtSpreadMaintenance };
            SqlParameter p13 = new SqlParameter { ParameterName = "@tblMinMultSchedule", Value = dtMiniSpreadInterest };
            SqlParameter p14 = new SqlParameter { ParameterName = "@tblFeeCredits", Value = dtMiniFee };
            SqlParameter p15 = new SqlParameter { ParameterName = "@PrepayDate", Value = prepayDC.PrepayDate };
            // SqlParameter p17 = new SqlParameter { ParameterName = "@OpenPaymentDate", Value = prepayDC.OpenPaymentDate };
            // SqlParameter p18 = new SqlParameter { ParameterName = "@NewPrepayID", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, };
            hp.ExecNonquery("dbo.usp_InsertUpdatePrepayPremium", sqlparam);

            // NewDeadID = Convert.ToString(p44.Value);

            if (!string.IsNullOrEmpty(NewDeadID))
                return NewDeadID;
            else
                return "FALSE";

        }

        public List<PrepayProjectionDataContract> GetDealPrepayProjectionByDealId(string DeailId, Guid? userId)
        {
            List<PrepayProjectionDataContract> lstprepayDC = new List<PrepayProjectionDataContract>();

            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@Dealid", Value = DeailId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userId };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetDealPrepayProjectionByDealId", sqlparam);

            if (dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    PrepayProjectionDataContract _prepayproDC = new PrepayProjectionDataContract();

                    _prepayproDC.DealPrepayProjectionID = Convert.ToInt32(dr["DealPrepayProjectionID"]);
                    _prepayproDC.DealID = Convert.ToString(dr["DealID"]);
                    _prepayproDC.PrepayDate = CommonHelper.ToDateTime(dr["PrepayDate"]);
                    _prepayproDC.PrepayPremium_RemainingSpread = CommonHelper.ToDecimal(dr["PrepayPremium_RemainingSpread"]);
                    _prepayproDC.UPB = CommonHelper.ToDecimal(dr["UPB"]);
                    _prepayproDC.OpenPrepaymentDate = CommonHelper.ToDateTime(dr["OpenPrepaymentDate"]);
                    _prepayproDC.TotalPayoff = CommonHelper.ToDecimal(dr["TotalPayoff"]);
                    _prepayproDC.prepaylastUpdatedFF = CommonHelper.ToDateTime(dr["prepaylastUpdatedFF"]);
                    _prepayproDC.prepaylastUpdatedByFF = Convert.ToString(dr["prepaylastUpdatedByFF"]);
                    lstprepayDC.Add(_prepayproDC);


                }


            }

            return lstprepayDC;

        }



        public PrepayDataContract GetPrepayPremiumDetailDataByDealId(string DeailId, Guid? userId)
        {


            List<PrepayDataContract> lstprepayDC = new List<PrepayDataContract>();
            PrepayDataContract _prepayDC = new PrepayDataContract();
            _prepayDC.PrepayAdjustment = new List<PrepayAdjustmentDataContract>();
            _prepayDC.SpreadMaintenanceSchedule = new List<SpreadMaintenanceScheduleDataContract>();
            _prepayDC.SpreadMaintenanceScheduleDeallevel = new List<SpreadMaintenanceScheduleDataContract>();
            _prepayDC.MinMultSchedule = new List<MinMultScheduleDataContract>();
            _prepayDC.FeeCredits = new List<FeeCreditsDataContract>();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@Dealid", Value = DeailId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userId };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetPrepayPremiumDetailDataByDealId", sqlparam);
            //  var newdtPrepayAdjustment = dt.Select(x => x.tablename = "PrepayAdjustment");

            List<PrepayAdjustmentDataContract> ListPrepayAdj = new List<PrepayAdjustmentDataContract>();

            if (dt.Rows.Count > 0)
            {
                _prepayDC.PrepayScheduleId = Convert.ToInt32(dt.Rows[0]["PrepayScheduleID"]);
                foreach (DataRow dr in dt.Rows)
                {
                    if (Convert.ToString(dr["tablename"]) == "PrepayAdjustment")
                    {
                        PrepayAdjustmentDataContract _prepayAdjDC = new PrepayAdjustmentDataContract();

                        _prepayAdjDC.PrepayAdjustmentId = Convert.ToInt32(dr["PrepayAdjustmentID"]);
                        _prepayAdjDC.Date = CommonHelper.ToDateTime(dr["Date"]);
                        _prepayAdjDC.PrepayAdjAmt = CommonHelper.ToDecimal(dr["Amount"]);
                        _prepayAdjDC.Comment = Convert.ToString(dr["Comment"]);
                        ListPrepayAdj.Add(_prepayAdjDC);
                    }
                    _prepayDC.PrepayAdjustment = ListPrepayAdj;
                }

                List<SpreadMaintenanceScheduleDataContract> ListSpreadMain = new List<SpreadMaintenanceScheduleDataContract>();
                foreach (DataRow dr in dt.Rows)
                {
                    if (Convert.ToString(dr["tablename"]) == "SpreadMaintenanceSchedule")
                    {
                        SpreadMaintenanceScheduleDataContract _spreadmain = new SpreadMaintenanceScheduleDataContract();
                        _spreadmain.SpreadMaintenanceScheduleId = Convert.ToInt32(dr["SpreadMaintenanceScheduleId"]);
                        //_spreadmain.NoteId = Convert.ToString(dr["NoteID"]);
                        _spreadmain.CRENoteID = Convert.ToString(dr["NoteID"]);
                        _spreadmain.SpreadDate = CommonHelper.ToDateTime(dr["Date"]);
                        _spreadmain.CalcAfterPayoff = CommonHelper.ToBoolean(dr["CalcAfterPayoff"]);
                        _spreadmain.Spread = CommonHelper.ToDecimal(dr["Spread"]);
                        ListSpreadMain.Add(_spreadmain);
                    }
                }
                _prepayDC.SpreadMaintenanceSchedule = ListSpreadMain;

                List<SpreadMaintenanceScheduleDataContract> ListSpreadMainDeallevel = new List<SpreadMaintenanceScheduleDataContract>();
                foreach (DataRow dr in dt.Rows)
                {
                    if (Convert.ToString(dr["tablename"]) == "SpreadMaintenanceSchedule_DealLevel")
                    {
                        SpreadMaintenanceScheduleDataContract _spreadmaindeallevel = new SpreadMaintenanceScheduleDataContract();
                        // _spreadmaindeallevel.SpreadMaintenanceId = Convert.ToInt32(dr["SpreadMaintenanceID"]);
                        _spreadmaindeallevel.CRENoteID = Convert.ToString(dr["NoteID"]);
                        // _spreadmaindeallevel.CRENoteID = Convert.ToString(dr["CRENoteID"]);
                        _spreadmaindeallevel.SpreadDate = CommonHelper.ToDateTime(dr["Date"]);
                        _spreadmaindeallevel.CalcAfterPayoff = CommonHelper.ToBoolean(dr["CalcAfterPayoff"]);
                        _spreadmaindeallevel.Spread = CommonHelper.ToDecimal(dr["Spread"]);
                        ListSpreadMainDeallevel.Add(_spreadmaindeallevel);
                    }
                }
                _prepayDC.SpreadMaintenanceScheduleDeallevel = ListSpreadMainDeallevel;

                List<MinMultScheduleDataContract> ListMiniSpread = new List<MinMultScheduleDataContract>();
                foreach (DataRow dr in dt.Rows)
                {
                    if (Convert.ToString(dr["tablename"]) == "MinMultSchedule")
                    {
                        MinMultScheduleDataContract _minispread = new MinMultScheduleDataContract();
                        _minispread.MinMultScheduleID = Convert.ToInt32(dr["MinMultScheduleID"]);
                        _minispread.MiniSpreadDate = CommonHelper.ToDateTime(dr["Date"]);
                        _minispread.MinMultAmount = Convert.ToDecimal(dr["Amount"]);
                        ListMiniSpread.Add(_minispread);
                    }
                }
                _prepayDC.MinMultSchedule = ListMiniSpread;

                List<FeeCreditsDataContract> ListMiniFee = new List<FeeCreditsDataContract>();
                foreach (DataRow dr in dt.Rows)
                {
                    if (Convert.ToString(dr["tablename"]) == "FeeCredits")
                    {
                        FeeCreditsDataContract _miniFeeDataContract = new FeeCreditsDataContract();
                        _miniFeeDataContract.FeeCreditsID = Convert.ToInt32(dr["FeeCreditsID"]);
                        _miniFeeDataContract.FeeCreditOverride = CommonHelper.ToDecimal(dr["Amount"]);
                        _miniFeeDataContract.FeeTypeNameText = Convert.ToInt32(dr["FeeType"]);
                        _miniFeeDataContract.UseActualFees = Convert.ToBoolean(dr["UseActualFees"]);
                        ListMiniFee.Add(_miniFeeDataContract);
                    }
                }
                _prepayDC.FeeCredits = ListMiniFee;
            }

            return _prepayDC;

        }

        public string GetDealCalculationStatus(string DealID)
        {
            string status = "";
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                {
                    SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                    SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                    dt = hp.ExecDataTable("usp_GetDealCalculationStatus", sqlparam);

                    if (dt.Rows.Count == 0)
                    {
                        status = "Completed";
                    }
                    else
                    {
                        status = "Running";
                    }

                }
            }
            catch (Exception ex)
            {
                var exception = ex.Message;
            }
            return status;
        }

        public string AddUpdateDealRuleTypeSetup(List<ScenarioruletypeDataContract> lstscenarioruletype, string userid)
        {
            string NEWRuleTypeSetupID = "";
            Helper.Helper hp = new Helper.Helper();
            DataTable dtDealRuleTypeSetup = new DataTable();
            dtDealRuleTypeSetup.Columns.Add("AnalysisID");
            dtDealRuleTypeSetup.Columns.Add("DealID");
            dtDealRuleTypeSetup.Columns.Add("RuleTypeMasterID");
            dtDealRuleTypeSetup.Columns.Add("RuleTypeDetailID");

            if (lstscenarioruletype != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(lstscenarioruletype);

                foreach (DataRow dr in dt.Rows)
                {
                    dtDealRuleTypeSetup.ImportRow(dr);
                }
            }

            SqlParameter p1 = new SqlParameter { ParameterName = "@tbldealruletypesetup", Value = dtDealRuleTypeSetup };
            SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy", Value = userid };


            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, };
            hp.ExecNonquery("dbo.usp_AddUpdateDealRuleTypeSetup", sqlparam);

            if (!string.IsNullOrEmpty(NEWRuleTypeSetupID))
                return NEWRuleTypeSetupID;
            else
                return "FALSE";
        }

        public List<PrepayAllocationsDataContract> GetDealPrepayAllocationsByDealId()
        {
            List<PrepayAllocationsDataContract> lstprepayallDC = new List<PrepayAllocationsDataContract>();

            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetDealPrepayAllocationsByDealId");
            if (dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    PrepayAllocationsDataContract _prepayallDC = new PrepayAllocationsDataContract();

                    _prepayallDC.DealPrepayAllocationsID = Convert.ToInt32(dr["DealPrepayAllocationsID"]);
                    _prepayallDC.DealID = Convert.ToString(dr["DealID"]);
                    _prepayallDC.NoteID = Convert.ToString(dr["NoteID"]);
                    _prepayallDC.CRENoteID = Convert.ToString(dr["CRENoteID"]);
                    _prepayallDC.MinmultDue = CommonHelper.ToDecimal(dr["MinmultDue"]);
                    _prepayallDC.PrepayDate = CommonHelper.ToDateTime(dr["PrepayDate"]);
                    lstprepayallDC.Add(_prepayallDC);
                }
            }
            return lstprepayallDC;

        }
        public List<ScenarioruletypeDataContract> GetRuleTypeSetupByDealId(string DealID)
        {
            DataTable dt = new DataTable();
            List<ScenarioruletypeDataContract> list = new List<ScenarioruletypeDataContract>();
            Helper.Helper hp = new Helper.Helper();

            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
            // SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetRuleTypeSetupByDealId", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                ScenarioruletypeDataContract sr = new ScenarioruletypeDataContract();
                sr.AnalysisID = Convert.ToString(dr["AnalysisID"]);
                sr.DealID = Convert.ToString(dr["DealID"]);
                sr.RuleTypeMasterID = CommonHelper.ToInt32(dr["RuleTypeMasterID"]);
                sr.RuleTypeName = Convert.ToString(dr["RuleTypeName"]);
                sr.RuleTypeDetailID = CommonHelper.ToInt32(dr["RuleTypeDetailID"]);
                sr.FileName = Convert.ToString(dr["FileName"]);
                sr.AnalysisName = Convert.ToString(dr["AnalysisName"]);
                list.Add(sr);

            }

            return list;
        }

        public List<PropertyTypeDataContract> GetAllPropertyType(Guid? userid)
        {
            Helper.Helper hp = new Helper.Helper();
            List<PropertyTypeDataContract> list = new List<PropertyTypeDataContract>();

            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetPropertyTypeMajor", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                PropertyTypeDataContract pt = new PropertyTypeDataContract();
                pt.PropertyTypeID = CommonHelper.ToInt32(dr["PropertyTypeMajorID"]);
                pt.PropertyTypeMajorDesc = Convert.ToString(dr["PropertyTypeMajorDesc"]);
                list.Add(pt);
            }

            return list;
        }

        public List<LoanStatusDataContract> GetAllLoanStatus(Guid? userid)
        {
            Helper.Helper hp = new Helper.Helper();
            List<LoanStatusDataContract> list = new List<LoanStatusDataContract>();

            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetLoanStatus", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                LoanStatusDataContract ls = new LoanStatusDataContract();
                ls.LoanStatusID = CommonHelper.ToInt32(dr["LoanStatusID"]);
                ls.LoanStatusDesc = Convert.ToString(dr["LoanStatusDesc"]);
                list.Add(ls);
            }

            return list;
        }
        public DataTable GetDiscrepancyListOfDealForEnableAutoSpread()
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("dbo.usp_GetDiscrepancyListOfDealForEnableAutoSpread");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }
        public DataTable GetDiscrepancyForExportPaydown()
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("dbo.usp_GetDiscrepancyForExportPaydown");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }

        public PrepayCalcStatusDataContract GetPrepayCalculationStatus(string DealID)
        {

            DataTable dt = new DataTable();
            PrepayCalcStatusDataContract pc = new PrepayCalcStatusDataContract();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                {
                    SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                    SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                    dt = hp.ExecDataTable("usp_GetPrepayCalculationStatus", sqlparam);

                    if (dt.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dt.Rows)
                        {
                            pc.Status = Convert.ToString(dr["CalcStatus"]);
                            pc.ErrorMessage = Convert.ToString(dr["ErrorMessage"]);

                        }
                    }


                }
            }
            catch (Exception ex)
            {
                var exception = ex.Message;
            }
            return pc;
        }

        public PrepayCalcStatusDataContract GetPrepayCalcStatusMessage(string DealID)
        {
            PrepayCalcStatusDataContract pc = new PrepayCalcStatusDataContract();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                {
                    SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                    SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                    dt = hp.ExecDataTable("usp_GetPrepayCalcFailedStatusMessage", sqlparam);
                    if (dt.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dt.Rows)
                        {
                            pc.Message = Convert.ToString(dr["Message"]);
                            pc.Message_StackTrace = Convert.ToString(dr["Message_StackTrace"]);
                            pc.RequestID = Convert.ToString(dr["RequestID"]);
                        }
                    }


                }
            }
            catch (Exception ex)
            {
                var exception = ex.Message;
            }
            return pc;
        }

        public List<EquitySummaryDataContract> GetEquitySummaryByDealID(string DealID)
        {
            Helper.Helper hp = new Helper.Helper();
            List<EquitySummaryDataContract> equitylist = new List<EquitySummaryDataContract>();

            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetEquitySummaryByDealID", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                EquitySummaryDataContract es = new EquitySummaryDataContract();
                es.Dealid = Convert.ToString(dr["Dealid"]);
                es.Type = Convert.ToString(dr["Type"]);
                es.ExpectedEquity = Convert.ToDecimal(dr["ExpectedEquity"]);
                es.EquityContributedToDate = Convert.ToDecimal(dr["EquityContributedToDate"]);
                es.RemainingEquity = Convert.ToDecimal(dr["RemainingEquity"]);
                double Per_ContributedToDate = Convert.ToDouble(dr["Per_ContributedToDate"]);
                es.Per_ContributedToDate = Convert.ToDecimal(Per_ContributedToDate.ToString("N2"));

                equitylist.Add(es);
            }

            return equitylist;
        }

    }
}