using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace CRES.DAL.Repository
{
    public class DebtRepository : IDebtRepository
    {
        public DebtDataContract InsertUpdateDebt(DebtDataContract ddc, string userid)
        {
            DebtDataContract newDebtdata = new DebtDataContract();
            string DebtAccountID;
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DebtID", Value = ddc.DebtID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AccountID", Value = ddc.DebtAccountID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@DebtName", Value = ddc.DebtName };
                SqlParameter p4 = new SqlParameter { ParameterName = "@DebtType", Value = ddc.DebtType };
                SqlParameter p5 = new SqlParameter { ParameterName = "@Status", Value = ddc.Status };
                SqlParameter p6 = new SqlParameter { ParameterName = "@Currency", Value = ddc.Currency };
                SqlParameter p7 = new SqlParameter { ParameterName = "@CurrentCommitment", Value = ddc.CurrentCommitment };
                SqlParameter p8 = new SqlParameter { ParameterName = "@MatchTerm", Value = ddc.MatchTerms };
                SqlParameter p9 = new SqlParameter { ParameterName = "@IsRevolving", Value = ddc.IsRevolving };
                SqlParameter p10 = new SqlParameter { ParameterName = "@FundingNoticeBD", Value = ddc.FundingNoticeBusinessDays };
                SqlParameter p11 = new SqlParameter { ParameterName = "@EarliestFinancingArrival", Value = ddc.EarliestFinancingArrival };
                SqlParameter p12 = new SqlParameter { ParameterName = "@OriginationDate", Value = ddc.OriginationDate };
                SqlParameter p13 = new SqlParameter { ParameterName = "@OriginationFees", Value = ddc.OriginationFees };
                SqlParameter p14 = new SqlParameter { ParameterName = "@RateType", Value = ddc.RateType };
                SqlParameter p15 = new SqlParameter { ParameterName = "@DrawLag", Value = ddc.DrawLag };
                SqlParameter p16 = new SqlParameter { ParameterName = "@PaydownDelay", Value = ddc.PaydownDelay };
                SqlParameter p17 = new SqlParameter { ParameterName = "@EffectiveDate", Value = ddc.EffectiveDate };
                SqlParameter p18 = new SqlParameter { ParameterName = "@Commitment", Value = ddc.Commitment };
                SqlParameter p19 = new SqlParameter { ParameterName = "@InitialMaturityDate", Value = ddc.InitialMaturityDate };
                SqlParameter p20 = new SqlParameter { ParameterName = "@ExitFee", Value = ddc.ExitFee };
                SqlParameter p21 = new SqlParameter { ParameterName = "@ExtensionFees", Value = ddc.ExtensionFees };
                SqlParameter p22 = new SqlParameter { ParameterName = "@InitialFundingDelay", Value = ddc.InitialFundingDelay };
                SqlParameter p23 = new SqlParameter { ParameterName = "@MaxAdvanceRate", Value = ddc.MaxAdvanceRate };
                SqlParameter p24 = new SqlParameter { ParameterName = "@TargetAdvanceRate", Value = ddc.TargetAdvanceRate };
                SqlParameter p25 = new SqlParameter { ParameterName = "@FundDelay", Value = ddc.FundDelay };
                SqlParameter p26 = new SqlParameter { ParameterName = "@FundingDay", Value = ddc.FundingDay };
                SqlParameter p27 = new SqlParameter { ParameterName = "@UserID", Value = ddc.DebtID };
                SqlParameter p28 = new SqlParameter { ParameterName = "@DebtAccountID", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter p29 = new SqlParameter { ParameterName = "@DebtGUID_Output", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter p30 = new SqlParameter { ParameterName = "@CashAccountID", Value = ddc.CashAccountID };
                SqlParameter p31 = new SqlParameter { ParameterName = "@LiabilityBankerID", Value = ddc.BankerID };
                SqlParameter p32 = new SqlParameter { ParameterName = "@AbbreviationName", Value = ddc.AbbreviationName };
                SqlParameter p33 = new SqlParameter { ParameterName = "@LinkedFundID", Value = ddc.LinkedFundID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14,p15,
                   p16, p17, p18, p19, p20, p21,p22,p23,p24,p25,p26,p27,p28,p29,p30,p31,p32,p33};
                DataTable dt = hp.ExecDataTable("usp_InsertUpdateDebt", sqlparam);
                newDebtdata.DebtAccountID = new Guid(Convert.ToString(p28.Value));
                newDebtdata.DebtGUID = Convert.ToString(p29.Value);
            }
            catch (Exception ex)
            {

                throw ex;
            }
            //if (!string.IsNullOrEmpty(DebtAccountID))
            //    return DebtAccountID;
            //else
            //    return "FALSE";
            return newDebtdata;
        }
        public DataTable GetDebtNoteByLiabilityTypeID(Guid? LiabilityTypeID)
        {

            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@LiabilityTypeID", Value = LiabilityTypeID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetDebtorEquityNoteByLiabilityTypeID", sqlparam);
            }
            catch (Exception ex)
            {
            }

            return dt;
        }
        public DebtDataContract GetDebtByDebtID(Guid? DebtGUID)
        {
            DebtDataContract debtdc = new DebtDataContract();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DebtGUID", Value = DebtGUID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetDebtByDebtID", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    debtdc.DebtAccountID = new Guid(Convert.ToString(dr["AccountID"]));
                    debtdc.DebtID = CommonHelper.ToInt32(dr["DebtID"]);
                    debtdc.DebtGUID = Convert.ToString(dr["DebtGUID"]);
                    debtdc.DebtName = Convert.ToString(dr["DebtName"]);
                    debtdc.OriginalDebtName = Convert.ToString(dr["DebtName"]);
                    debtdc.Status = CommonHelper.ToInt32(dr["Status"]);
                    debtdc.StatusText = Convert.ToString(dr["StatusText"]);
                    debtdc.Currency = CommonHelper.ToInt32(dr["CurrencyID"]);
                    debtdc.CurrencyText = Convert.ToString(dr["CurrencyText"]);
                    debtdc.DebtType = CommonHelper.ToInt32(dr["DebtType"]);
                    debtdc.DebtTypeText = Convert.ToString(dr["DebtTypeText"]);
                    debtdc.CurrentCommitment = CommonHelper.ToDecimal(dr["CurrentCommitment"]);
                    debtdc.MatchTerms = CommonHelper.ToInt32(dr["MatchTerm"]);
                    debtdc.MatchTermsText = Convert.ToString(dr["MatchTermText"]);
                    debtdc.IsRevolving = CommonHelper.ToInt32(dr["IsRevolving"]);
                    debtdc.IsRevolvingText = Convert.ToString(dr["IsRevolvingText"]);
                    debtdc.FundingNoticeBusinessDays = CommonHelper.ToInt32(dr["FundingNoticeBD"]);
                    debtdc.EarliestFinancingArrival = CommonHelper.ToDateTime(dr["EarliestFinancingArrival"]);
                    debtdc.CurrentBalance = CommonHelper.ToDecimal(dr["CurrentBalance"]);
                    debtdc.OriginationDate = CommonHelper.ToDateTime(dr["OriginationDate"]);
                    debtdc.OriginationFees = CommonHelper.ToDecimal(dr["OriginationFees"]);
                    debtdc.RateType = CommonHelper.ToInt32(dr["RateType"]);
                    debtdc.RateTypeText = Convert.ToString(dr["RateTypeText"]);
                    debtdc.DrawLag = CommonHelper.ToInt32(dr["DrawLag"]);
                    debtdc.PaydownDelay = CommonHelper.ToInt32(dr["PaydownDelay"]);
                    debtdc.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveStartDate"]);
                    debtdc.Commitment = CommonHelper.ToDecimal(dr["Commitment"]);
                    debtdc.InitialMaturityDate = CommonHelper.ToDateTime(dr["InitialMaturityDate"]);
                    debtdc.ExitFee = CommonHelper.ToDecimal(dr["ExitFee"]);
                    debtdc.ExtensionFees = CommonHelper.ToDecimal(dr["ExtensionFees"]);
                    debtdc.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    debtdc.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    debtdc.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    debtdc.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    debtdc.InitialFundingDelay = CommonHelper.ToInt32(dr["InitialFundingDelay"]);
                    debtdc.MaxAdvanceRate = CommonHelper.ToDecimal(dr["MaxAdvanceRate"]);
                    debtdc.TargetAdvanceRate = CommonHelper.ToDecimal(dr["TargetAdvanceRate"]);
                    debtdc.FundDelay = CommonHelper.ToInt32(dr["FundDelay"]);
                    debtdc.FundingDay = CommonHelper.ToInt32(dr["FundingDay"]);
                    debtdc.CashAccountID = CommonHelper.ToGuid(dr["CashAccountID"]);
                    debtdc.CashAccountName = Convert.ToString(dr["CashAccountName"]);
                    debtdc.BankerText = Convert.ToString(dr["BankerText"]);
                    debtdc.AbbreviationName = Convert.ToString(dt.Rows[0]["AbbreviationName"]);
                    debtdc.LinkedFundID = CommonHelper.ToGuid(dt.Rows[0]["LinkedFundID"]);
                }
            }
            catch (Exception ex)
            {
                throw ;
            }
            return debtdc;
        }
        public List<FeeScheduleDataContract> GetDebtFeeScheduleByDebtAccountID(Guid? DebtAccountID, Guid? AdditionalAccountID)
        {
            List<FeeScheduleDataContract> ListFeeScheduledc = new List<FeeScheduleDataContract>();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DebtAccountID", Value = DebtAccountID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AdditionalAccountID", Value = AdditionalAccountID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1,p2 };
                dt = hp.ExecDataTable("dbo.usp_GetLiabilityFeeScheduleByAccountID", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    FeeScheduleDataContract FeeScheduledc = new FeeScheduleDataContract();
                    FeeScheduledc.AccountID = Convert.ToString(dr["AccountID"]);
                    FeeScheduledc.AdditionalAccountID = Convert.ToString(dr["AdditionalAccountID"]);
                    FeeScheduledc.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                    FeeScheduledc.FeeName = Convert.ToString(dr["FeeName"]);
                    FeeScheduledc.StartDate = CommonHelper.ToDateTime(dr["StartDate"]);
                    FeeScheduledc.EndDate = CommonHelper.ToDateTime(dr["EndDate"]);
                    FeeScheduledc.FeeTypeText = Convert.ToString(dr["FeeTypeText"]);
                    FeeScheduledc.Fee = CommonHelper.ToDecimal(dr["Fee"]);
                    FeeScheduledc.FeeAmountOverride = CommonHelper.ToDecimal(dr["FeeAmountOverride"]);
                    FeeScheduledc.BaseAmountOverride = CommonHelper.ToDecimal(dr["BaseAmountOverride"]);
                    FeeScheduledc.ApplyTrueUpFeatureID = CommonHelper.ToInt32(dr["ApplyTrueUpFeatureID"]);
                    FeeScheduledc.ApplyTrueUpFeatureText = Convert.ToString(dr["ApplyTrueUpFeatureText"]);
                    FeeScheduledc.IncludedLevelYield = CommonHelper.ToDecimal(dr["IncludedLevelYield"]);
                    FeeScheduledc.PercentageOfFeeToBeStripped = CommonHelper.ToDecimal(dr["PercentageOfFeeToBeStripped"]);
                    ListFeeScheduledc.Add(FeeScheduledc);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return ListFeeScheduledc;
        }

        public DataTable GetLiabilityFundingScheduleAggregateByLiabilityTypeID(string LiabilityTypeID)
        {

            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@LiabilityTypeID", Value = LiabilityTypeID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetLiabilityFundingScheduleAggregateByLiabilityTypeID", sqlparam);
            }
            catch (Exception ex)
            {

                throw ex;
            }
            return dt;

        }


        public List<LiabilityFundingScheduleDataContract> GetLiabilityFundingScheduleDetailByLiabilityTypeID(string LiabilityTypeID)
        {
            List<LiabilityFundingScheduleDataContract> ListLiabilityFundingSchedule = new List<LiabilityFundingScheduleDataContract>();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@LiabilityTypeID", Value = LiabilityTypeID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetLiabilityFundingScheduleDetailByLiabilityTypeID", sqlparam);


                foreach (DataRow dr in dt.Rows)
                {
                    LiabilityFundingScheduleDataContract LiabilityFundingSchedule = new LiabilityFundingScheduleDataContract();

                    LiabilityFundingSchedule.LiabilityFundingScheduleID = CommonHelper.ToInt32(dr["LiabilityFundingScheduleID"]);
                    LiabilityFundingSchedule.LiabilityNoteAccountID = Convert.ToString(dr["LiabilityNoteAccountID"]);
                    LiabilityFundingSchedule.LiabilityNoteID = Convert.ToString(dr["LiabilityNoteID"]);
                    //  LiabilityFundingSchedule.LiabilityNoteName = Convert.ToString(dr["LiabilityNoteName"]);
                    LiabilityFundingSchedule.TransactionDate = CommonHelper.ToDateTime(dr["TransactionDate"]);
                    LiabilityFundingSchedule.TransactionAmount = CommonHelper.ToDecimal(dr["TransactionAmount"]);
                    LiabilityFundingSchedule.Applied = CommonHelper.ToBoolean(dr["Applied"]) == null ? false : Convert.ToBoolean(dr["Applied"]);
                    LiabilityFundingSchedule.Comments = Convert.ToString(dr["Comments"]);
                    LiabilityFundingSchedule.CRENoteID = Convert.ToString(dr["CRENoteID"]);
                    LiabilityFundingSchedule.AssetAccountID = Convert.ToString(dr["AssetAccountID"]);
                    LiabilityFundingSchedule.AssetName = Convert.ToString(dr["AssetName"]);
                    LiabilityFundingSchedule.AssetTransactionDate = CommonHelper.ToDateTime(dr["AssetTransactionDate"]);
                    LiabilityFundingSchedule.AssetTransactionAmount = CommonHelper.ToDecimal(dr["AssetTransactionAmount"]);
                    LiabilityFundingSchedule.TransactionAdvanceRate = CommonHelper.ToDecimal(dr["TransactionAdvanceRate"]);
                    LiabilityFundingSchedule.CumulativeAdvanceRate = CommonHelper.ToDecimal(dr["CumulativeAdvanceRate"]);
                    LiabilityFundingSchedule.AssetTransactionComment = Convert.ToString(dr["AssetTransactionComment"]);
                    LiabilityFundingSchedule.TransactionTypes = Convert.ToString(dr["TransactionType"]);
                    LiabilityFundingSchedule.AccountID = Convert.ToString(dr["LiabilityAccountID"]);

                    LiabilityFundingSchedule.EndingBalance = CommonHelper.ToDecimal(dr["EndingBalance"]);

                    LiabilityFundingSchedule.DealName = Convert.ToString(dr["DealName"]);
                    LiabilityFundingSchedule.CREDealID = Convert.ToString(dr["CREDealID"]);


                    ListLiabilityFundingSchedule.Add(LiabilityFundingSchedule);
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
            return ListLiabilityFundingSchedule;

        }



        public List<LiabilityFundingScheduleDataContract> GetLiabilityFundingScheduleDetailByFilter(string LiabilityTypeID, string TransDate, string TransactionType)
        {
            List<LiabilityFundingScheduleDataContract> ListLiabilityFundingSchedule = new List<LiabilityFundingScheduleDataContract>();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@LiabilityTypeID", Value = LiabilityTypeID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@TransDate", Value = TransDate };
                SqlParameter p3 = new SqlParameter { ParameterName = "@TransactionType", Value = TransactionType };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dt = hp.ExecDataTable("dbo.usp_GetLiabilityFundingScheduleDetailByFilter", sqlparam);


                foreach (DataRow dr in dt.Rows)
                {
                    LiabilityFundingScheduleDataContract LiabilityFundingSchedule = new LiabilityFundingScheduleDataContract();

                    LiabilityFundingSchedule.LiabilityFundingScheduleID = CommonHelper.ToInt32(dr["LiabilityFundingScheduleID"]);
                    LiabilityFundingSchedule.LiabilityNoteAccountID = Convert.ToString(dr["LiabilityNoteAccountID"]);
                    LiabilityFundingSchedule.LiabilityNoteID = Convert.ToString(dr["LiabilityNoteID"]);
                    //  LiabilityFundingSchedule.LiabilityNoteName = Convert.ToString(dr["LiabilityNoteName"]);
                    LiabilityFundingSchedule.TransactionDate = CommonHelper.ToDateTime(dr["TransactionDate"]);
                    LiabilityFundingSchedule.TransactionAmount = CommonHelper.ToDecimal(dr["TransactionAmount"]);
                    LiabilityFundingSchedule.Applied = CommonHelper.ToBoolean(dr["Applied"]) == null ? false : Convert.ToBoolean(dr["Applied"]);
                    LiabilityFundingSchedule.Comments = Convert.ToString(dr["Comments"]);
                    LiabilityFundingSchedule.CRENoteID = Convert.ToString(dr["CRENoteID"]);
                    LiabilityFundingSchedule.AssetAccountID = Convert.ToString(dr["AssetAccountID"]);
                    LiabilityFundingSchedule.AssetName = Convert.ToString(dr["AssetName"]);
                    LiabilityFundingSchedule.AssetTransactionDate = CommonHelper.ToDateTime(dr["AssetTransactionDate"]);
                    LiabilityFundingSchedule.AssetTransactionAmount = CommonHelper.ToDecimal(dr["AssetTransactionAmount"]);
                    LiabilityFundingSchedule.TransactionAdvanceRate = CommonHelper.ToDecimal(dr["TransactionAdvanceRate"]);
                    LiabilityFundingSchedule.CumulativeAdvanceRate = CommonHelper.ToDecimal(dr["CumulativeAdvanceRate"]);
                    LiabilityFundingSchedule.AssetTransactionComment = Convert.ToString(dr["AssetTransactionComment"]);
                    LiabilityFundingSchedule.TransactionTypes = Convert.ToString(dr["TransactionType"]);
                    LiabilityFundingSchedule.AccountID = Convert.ToString(dr["LiabilityAccountID"]);

                    LiabilityFundingSchedule.EndingBalance = CommonHelper.ToDecimal(dr["EndingBalance"]);

                    LiabilityFundingSchedule.DealName = Convert.ToString(dr["DealName"]);
                    LiabilityFundingSchedule.CREDealID = Convert.ToString(dr["CREDealID"]);


                    ListLiabilityFundingSchedule.Add(LiabilityFundingSchedule);
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
            return ListLiabilityFundingSchedule;

        }


        public DebtDataContract GetDebtByDebtID(string DebtName)
        {
            DebtDataContract debtdc = new DebtDataContract();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DebtName", Value = DebtName };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetDebtByDebtName", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    debtdc.DebtAccountID = new Guid(Convert.ToString(dr["DebtAccountID"]));
                    debtdc.DebtID = CommonHelper.ToInt32(dr["DebtID"]);
                    debtdc.DebtGUID = Convert.ToString(dr["DebtGUID"]);
                    debtdc.DebtName = Convert.ToString(dr["DebtName"]);
                    debtdc.CashAccountID = CommonHelper.ToGuid(dr["CashAccountID"]);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return debtdc;
        }

        public void InsertUpdateGeneralSetupDetailsDebt(DebtDataContract ddc, string userid)
        {
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AccountID", Value = ddc.DebtAccountID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@EffectiveDate", Value = ddc.EffectiveDate };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Commitment", Value = ddc.Commitment };
                SqlParameter p4 = new SqlParameter { ParameterName = "@InitialMaturityDate", Value = ddc.InitialMaturityDate };
                SqlParameter p5 = new SqlParameter { ParameterName = "@ExitFee", Value = ddc.ExitFee };
                SqlParameter p6 = new SqlParameter { ParameterName = "@ExtensionFees", Value = ddc.ExtensionFees };
                SqlParameter p7 = new SqlParameter { ParameterName = "@UserID", Value = userid };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7 };
                DataTable dt = hp.ExecDataTable("usp_InsertUpdateGeneralSetupDetailsDebt", sqlparam);

            }
            catch (Exception ex)
            {

                throw ex;
            }

        }
        public List<LookupDataContract> GetListofFundNameShortName()
        {
            List<LookupDataContract> dc = new List<LookupDataContract>();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("dbo.usp_GetListofFundNameShortName");

                foreach (DataRow dr in dt.Rows)
                {
                    LookupDataContract ldc = new LookupDataContract();
                    ldc.LookupIDGuID = Convert.ToString(dr["AccountID"]);
                    ldc.Name = Convert.ToString(dr["AbbreviationName"]);
                    dc.Add(ldc);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return dc;
        }

        public DebtDataContract InsertUpdateDebt_OnetimeFromFile(DebtDataContract ddc, string userid)
        {
            DebtDataContract newDebtdata = new DebtDataContract();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DebtID", Value = ddc.DebtID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AccountID", Value = ddc.DebtAccountID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@DebtName", Value = ddc.DebtName };
                SqlParameter p4 = new SqlParameter { ParameterName = "@DebtType", Value = ddc.DebtType };
                SqlParameter p5 = new SqlParameter { ParameterName = "@Status", Value = ddc.Status };
                SqlParameter p6 = new SqlParameter { ParameterName = "@Currency", Value = ddc.Currency };
                SqlParameter p7 = new SqlParameter { ParameterName = "@UserID", Value = ddc.DebtID };
                SqlParameter p8 = new SqlParameter { ParameterName = "@DebtAccountID", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter p9 = new SqlParameter { ParameterName = "@DebtGUID_Output", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter p10 = new SqlParameter { ParameterName = "@AbbreviationName", Value = ddc.AbbreviationName };
                SqlParameter p11 = new SqlParameter { ParameterName = "@LinkedFundID", Value = ddc.LinkedFundID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11};
                DataTable dt = hp.ExecDataTable("usp_InsertUpdateDebt_OnetimeFromFile", sqlparam);
                newDebtdata.DebtAccountID = new Guid(Convert.ToString(p8.Value));
                newDebtdata.DebtGUID = Convert.ToString(p9.Value);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return newDebtdata;
        }

        public List<PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract> GetPrepayAndAdditionalFeeScheduleLiabilityDetailByAccountID(Guid? DebtAccountID, Guid? AdditionalAccountID)
        {
            List<PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract> ListFeeScheduledc = new List<PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract>();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DebtAccountID", Value = DebtAccountID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AdditionalAccountID", Value = AdditionalAccountID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetPrepayAndAdditionalFeeScheduleLiabilityDetailByAccountID", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract FeeScheduledc = new PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract();
                    FeeScheduledc.AccountID = Convert.ToString(dr["AccountID"]);
                    FeeScheduledc.AdditionalAccountID = Convert.ToString(dr["AdditionalAccountID"]);
                    FeeScheduledc.EventID = Convert.ToString(dr["EventID"]);
                    FeeScheduledc.ValueTypeID = CommonHelper.ToInt32(dr["ValueTypeID"]);
                    FeeScheduledc.StartDate = CommonHelper.ToDateTime(dr["StartDate"]);
                    FeeScheduledc.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                    FeeScheduledc.From = CommonHelper.ToDecimal(dr["From"]);
                    FeeScheduledc.To = CommonHelper.ToDecimal(dr["To"]);
                    FeeScheduledc.Value = CommonHelper.ToDecimal(dr["Value"]);
                    ListFeeScheduledc.Add(FeeScheduledc);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return ListFeeScheduledc;
        }

    }
}
