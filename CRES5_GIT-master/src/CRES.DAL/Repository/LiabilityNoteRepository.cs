using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;

namespace CRES.DAL.Repository
{
    public class LiabilityNoteRepository : ILiabilityNoteRepository
    {

        public string InsertUpdateLiabilityNote(LiabilityNoteDataContract lndc, string userid, List<LiabilityNoteAssetMapping> LiabilityAssetMap)
        {
            string LiabilityNoteAccountID;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable AssetMapData = new DataTable();
                AssetMapData.Columns.Add("LiabilityNoteId");
                AssetMapData.Columns.Add("DealAccountId");
                AssetMapData.Columns.Add("LiabilityNoteAccountId");
                AssetMapData.Columns.Add("AssetAccountId");

                if (LiabilityAssetMap != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(LiabilityAssetMap);

                    foreach (DataRow dr in dt.Rows)
                    {
                        AssetMapData.ImportRow(dr);
                    }
                }



                //Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@LiabilityNoteAutoID", Value = lndc.LiabilityNoteAutoID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AccountID", Value = lndc.LiabilityNoteAccountID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@DealAccountID", Value = lndc.DealAccountID };
                SqlParameter p4 = new SqlParameter { ParameterName = "@LiabilityNoteID", Value = lndc.LiabilityNoteID };
                SqlParameter p5 = new SqlParameter { ParameterName = "@LiailityNoteName", Value = lndc.LiabilityName };
                SqlParameter p6 = new SqlParameter { ParameterName = "@LiabilityTypeID", Value = lndc.LiabilityTypeID };
                SqlParameter p7 = new SqlParameter { ParameterName = "@AssetAccountID", Value = lndc.AssetAccountID };

                SqlParameter p8 = new SqlParameter { ParameterName = "@Status", Value = lndc.Status };
                SqlParameter p9 = new SqlParameter { ParameterName = "@CurrentAdvanceRate", Value = lndc.CurrentAdvanceRate };

                SqlParameter p10 = new SqlParameter { ParameterName = "@CurrentBalance", Value = lndc.CurrentBalance };
                SqlParameter p11 = new SqlParameter { ParameterName = "@UndrawnCapacity", Value = lndc.UndrawnCapacity };

                SqlParameter p12 = new SqlParameter { ParameterName = "@PledgeDate", Value = lndc.PledgeDate };
                SqlParameter p13 = new SqlParameter { ParameterName = "@PaydownAdvanceRate", Value = lndc.PaydownAdvanceRate };
                SqlParameter p14 = new SqlParameter { ParameterName = "@FundingAdvanceRate", Value = lndc.FundingAdvanceRate };
                SqlParameter p15 = new SqlParameter { ParameterName = "@TargetAdvanceRate", Value = lndc.TargetAdvanceRate };
                SqlParameter p16 = new SqlParameter { ParameterName = "@MaturityDate", Value = lndc.MaturityDate };
                SqlParameter p17 = new SqlParameter { ParameterName = "@tblNoteAssetMap", Value = AssetMapData };
                SqlParameter p18 = new SqlParameter { ParameterName = "@UserID", Value = userid };
                SqlParameter p19 = new SqlParameter { ParameterName = "@LiabilityNoteAccountID", Direction = ParameterDirection.Output, Size = int.MaxValue };

                SqlParameter p20 = new SqlParameter { ParameterName = "@ThirdPartyOwnership", Value = lndc.ThirdPartyOwnership };
                SqlParameter p21 = new SqlParameter { ParameterName = "@PaymentFrequency", Value = lndc.PayFrequency };
                SqlParameter p22 = new SqlParameter { ParameterName = "@AccrualEndDateBusinessDayLag", Value = lndc.AccrualEndDateBusinessDayLag };
                SqlParameter p23 = new SqlParameter { ParameterName = "@AccrualFrequency", Value = lndc.AccrualFrequency };
                SqlParameter p24 = new SqlParameter { ParameterName = "@Roundingmethod", Value = lndc.RoundingMethod };
                SqlParameter p25 = new SqlParameter { ParameterName = "@IndexRoundingRule", Value = lndc.IndexRoundingRule };
                SqlParameter p26 = new SqlParameter { ParameterName = "@FinanacingSpreadRate", Value = lndc.FinanacingSpreadRate };
                SqlParameter p27 = new SqlParameter { ParameterName = "@IntActMethod", Value = lndc.IntCalcMethod };
                SqlParameter p28 = new SqlParameter { ParameterName = "@DefaultIndexName", Value = lndc.DefaultIndexName };
                SqlParameter p29 = new SqlParameter { ParameterName = "@EffectiveDate", Value = lndc.EffectiveDate };
                SqlParameter p30 = new SqlParameter { ParameterName = "@UseNoteLevelOverride", Value = lndc.UseNoteLevelOverride };
                SqlParameter p31 = new SqlParameter { ParameterName = "@DebtEquityTypeID", Value = lndc.DebtEquityTypeID };

                SqlParameter p32 = new SqlParameter { ParameterName = "@LiabilitySource", Value = lndc.LiabilitySource };
                SqlParameter p33 = new SqlParameter { ParameterName = "@pmtdtaccper", Value = lndc.pmtdtaccper };
                SqlParameter p34 = new SqlParameter { ParameterName = "@ResetIndexDaily", Value = lndc.ResetIndexDaily };
                SqlParameter p35 = new SqlParameter { ParameterName = "@ActiveLiabilityNote", Value = lndc.ActiveLiabilityNote };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19
                    , p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31,p32,p33,p34,p35};
                hp.ExecNonquery("usp_InsertUpdateLiabilityNote", sqlparam);
                LiabilityNoteAccountID = Convert.ToString(p19.Value);
            }
            catch (Exception ex)
            {

                throw ex;
            }
            if (!string.IsNullOrEmpty(LiabilityNoteAccountID))
                return LiabilityNoteAccountID;
            else
                return "FALSE";
        }
        public LiabilityNoteDataContract GetLiabilityNoteByLiabilityNoteID(Guid LiabilityNoteGUID)
        {
            LiabilityNoteDataContract _liabilityNoteDC = new LiabilityNoteDataContract();
            DataTable dt = new DataTable();
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@LiabilityNoteGUID", Value = LiabilityNoteGUID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetLiabilityNoteByLiabilityNoteID", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {

                    _liabilityNoteDC.LiabilityNoteAccountID = new Guid(Convert.ToString(dr["AccountID"]));
                    _liabilityNoteDC.DealAccountID = Convert.ToString(dr["DealAccountID"]);
                    _liabilityNoteDC.LiabilityNoteID = Convert.ToString(dr["LiabilityNoteID"]);
                    _liabilityNoteDC.LiabilityName = Convert.ToString(dr["LiabilityNoteName"]);
                    _liabilityNoteDC.OriginalLiabilityNoteID = Convert.ToString(dr["LiabilityNoteID"]);
                    _liabilityNoteDC.Status = CommonHelper.ToInt32(dr["Status"]);
                    _liabilityNoteDC.StatusText = Convert.ToString(dr["StatusText"]);
                    _liabilityNoteDC.LiabilityTypeID = CommonHelper.ToGuid(dr["LiabilityTypeID"]);
                    _liabilityNoteDC.LiabilityTypeText = Convert.ToString(dr["LiabilityTypeText"]);
                    _liabilityNoteDC.LiabilityNoteAutoID = CommonHelper.ToInt32(dr["LiabilityNoteAutoID"]);
                    _liabilityNoteDC.AssetAccountID = Convert.ToString(dr["AssetAccountID"]);

                    _liabilityNoteDC.PledgeDate = CommonHelper.ToDateTime(dr["PledgeDate"]);
                    _liabilityNoteDC.CurrentAdvanceRate = CommonHelper.ToDecimal(dr["CurrentAdvanceRate"]);
                    _liabilityNoteDC.TargetAdvanceRate = CommonHelper.ToDecimal(dr["TargetAdvanceRate"]);
                    _liabilityNoteDC.CurrentBalance = CommonHelper.ToDecimal(dr["CurrentBalance"]);
                    _liabilityNoteDC.UndrawnCapacity = CommonHelper.ToDecimal(dr["UndrawnCapacity"]);
                    _liabilityNoteDC.PaydownAdvanceRate = CommonHelper.ToDecimal(dr["PaydownAdvanceRate"]);
                    _liabilityNoteDC.FundingAdvanceRate = CommonHelper.ToDecimal(dr["FundingAdvanceRate"]);
                    _liabilityNoteDC.MaturityDate = CommonHelper.ToDateTime(dr["MaturityDate"]);
                    _liabilityNoteDC.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    _liabilityNoteDC.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    _liabilityNoteDC.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    _liabilityNoteDC.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    _liabilityNoteDC.LiabilityNoteGUID = new Guid(Convert.ToString(dr["LiabilityNoteGUID"]));

                    _liabilityNoteDC.Type = Convert.ToString(dr["Type"]);

                    _liabilityNoteDC.ThirdPartyOwnership = CommonHelper.ToDecimal(dr["ThirdPartyOwnership"]);
                    _liabilityNoteDC.PayFrequency = CommonHelper.ToInt32(dr["PaymentFrequency"]);
                    _liabilityNoteDC.AccrualEndDateBusinessDayLag = CommonHelper.ToInt32(dr["AccrualEndDateBusinessDayLag"]);
                    _liabilityNoteDC.AccrualFrequency = CommonHelper.ToInt32(dr["AccrualFrequency"]);
                    _liabilityNoteDC.RoundingMethod = CommonHelper.ToInt32(dr["Roundingmethod"]);
                    _liabilityNoteDC.IndexRoundingRule = CommonHelper.ToInt32(dr["IndexRoundingRule"]);
                    _liabilityNoteDC.FinanacingSpreadRate = CommonHelper.ToDecimal(dr["FinanacingSpreadRate"]);
                    _liabilityNoteDC.IntCalcMethod = CommonHelper.ToInt32(dr["IntActMethod"]);
                    _liabilityNoteDC.DefaultIndexName = CommonHelper.ToInt32(dr["DefaultIndexName"]);
                    _liabilityNoteDC.AccountTypeText = Convert.ToString(dr["Debt_EquityType"]);

                    _liabilityNoteDC.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                    _liabilityNoteDC.UseNoteLevelOverride = CommonHelper.ToBoolean(dr["UseNoteLevelOverride"]);
                    _liabilityNoteDC.DebtEquityTypeID = CommonHelper.ToInt32(dr["DebtEquityTypeID"]);
                    _liabilityNoteDC.LiabilityTypeGUID = Convert.ToString(dr["LiabilityTypeGUID"]);

                    _liabilityNoteDC.LiabilitySource = CommonHelper.ToInt32(dr["LiabilitySource"]);
                    _liabilityNoteDC.pmtdtaccper = CommonHelper.ToInt32(dr["pmtdtaccper"]);
                    _liabilityNoteDC.ResetIndexDaily = CommonHelper.ToInt32(dr["ResetIndexDaily"]);


                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
            return _liabilityNoteDC;

        }

        public List<LiabilityNoteDataContract> GetLiabilityNoteByDealAccountID(string DealAccountID)
        {
            List<LiabilityNoteDataContract> lstLiabilityNoteDC = new List<LiabilityNoteDataContract>();
            DataTable dt = new DataTable();
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealAccountID", Value = DealAccountID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetLiabilityNoteByDealAccountID", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    LiabilityNoteDataContract _liabilityNoteDC = new LiabilityNoteDataContract();
                    _liabilityNoteDC.LiabilityNoteAccountID = new Guid(Convert.ToString(dr["LiabilityNoteAccountID"]));
                    _liabilityNoteDC.LiabilityNoteGUID = new Guid(Convert.ToString(dr["LiabilityNoteGUID"]));
                    _liabilityNoteDC.DealAccountID = Convert.ToString(dr["DealAccountID"]);
                    _liabilityNoteDC.LiabilityNoteID = Convert.ToString(dr["LiabilityNoteID"]);
                    _liabilityNoteDC.LiabilityName = Convert.ToString(dr["LiabilityNoteName"]);
                    _liabilityNoteDC.OriginalLiabilityNoteID = Convert.ToString(dr["LiabilityNoteID"]);

                    _liabilityNoteDC.Status = CommonHelper.ToInt32(dr["Status"]);
                    _liabilityNoteDC.StatusText = Convert.ToString(dr["StatusText"]);
                    _liabilityNoteDC.LiabilityNoteAutoID = CommonHelper.ToInt32(dr["LiabilityNoteAutoID"]);


                    _liabilityNoteDC.LiabilityTypeID = CommonHelper.ToGuid(dr["LiabilityTypeID"]);
                    _liabilityNoteDC.LiabilityTypeText = Convert.ToString(dr["LiabilityTypeText"]);
                    _liabilityNoteDC.AssetAccountID = Convert.ToString(dr["AssetAccountID"]);
                    _liabilityNoteDC.AssetName = Convert.ToString(dr["AssetName"]);
                    _liabilityNoteDC.AccountTypeID = CommonHelper.ToInt32_NotNullable(dr["AccountTypeID"]);
                    _liabilityNoteDC.PledgeDate = CommonHelper.ToDateTime(dr["PledgeDate"]);
                    _liabilityNoteDC.CurrentAdvanceRate = CommonHelper.ToDecimal(dr["CurrentAdvanceRate"]);
                    _liabilityNoteDC.TargetAdvanceRate = CommonHelper.ToDecimal(dr["TargetAdvanceRate"]);
                    _liabilityNoteDC.CurrentBalance = CommonHelper.ToDecimal(dr["CurrentBalance"]);
                    _liabilityNoteDC.UndrawnCapacity = CommonHelper.ToDecimal(dr["UndrawnCapacity"]);
                    _liabilityNoteDC.PaydownAdvanceRate = CommonHelper.ToDecimal(dr["PaydownAdvanceRate"]);
                    _liabilityNoteDC.FundingAdvanceRate = CommonHelper.ToDecimal(dr["FundingAdvanceRate"]);
                    _liabilityNoteDC.MaturityDate = CommonHelper.ToDateTime(dr["MaturityDate"]);

                    _liabilityNoteDC.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    _liabilityNoteDC.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    _liabilityNoteDC.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    _liabilityNoteDC.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    _liabilityNoteDC.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);

                    _liabilityNoteDC.ThirdPartyOwnership = CommonHelper.ToDecimal(dr["ThirdPartyOwnership"]);
                    _liabilityNoteDC.LiabilityType = Convert.ToString(dr["LiabilityType"]);
                    _liabilityNoteDC.LiabilityTypeGUID = Convert.ToString(dr["LiabilityTypeGUID"]);
                    _liabilityNoteDC.DebtEquityTypeID = CommonHelper.ToInt32(dr["DebtEquityTypeID"]);
                    _liabilityNoteDC.Provider = Convert.ToString(dr["BankerText"]);

                    _liabilityNoteDC.LiabilitySource = CommonHelper.ToInt32(dr["LiabilitySource"]);
                    _liabilityNoteDC.LiabilitySourceText = Convert.ToString(dr["LiabilitySourceText"]);
                    _liabilityNoteDC.ActiveLiabilityNote = CommonHelper.ToInt32(dr["ActiveLiabilityNote"]);

                    lstLiabilityNoteDC.Add(_liabilityNoteDC);
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
            return lstLiabilityNoteDC;

        }

        public List<SearchDataContract> GetAutosuggestDebtAndEquityName(string serchKey)
        {

            DataTable dt = new DataTable();
            List<SearchDataContract> lstSearchDC = new List<SearchDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@SearchKey", Value = serchKey };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetLiabilityTypeLookup", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                SearchDataContract _Searchdc = new SearchDataContract();
                _Searchdc.ValueID = Convert.ToString(dr["AccountID"]);
                _Searchdc.Valuekey = Convert.ToString(dr["Text"]);
                lstSearchDC.Add(_Searchdc);
            }

            return lstSearchDC;
        }

        public List<SearchDataContract> GetAutosuggestBankerName(string searchKey)
        {

            DataTable dt = new DataTable();
            List<SearchDataContract> lstSearchDC = new List<SearchDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@SearchKey", Value = searchKey };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_getAutoSuggestBankerName", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                SearchDataContract _Searchdc = new SearchDataContract();
                _Searchdc.ValueID = Convert.ToString(dr["LiabilityBankerID"]);
                _Searchdc.Valuekey = Convert.ToString(dr["BankerName"]);
                lstSearchDC.Add(_Searchdc);
            }

            return lstSearchDC;
        }

        public List<LookupDataContract> GetAllLiabilityTypeLookup()
        {

            DataTable dt = new DataTable();
            List<LookupDataContract> lstDC = new List<LookupDataContract>();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetAllLiabilityTypeLookup");

            foreach (DataRow dr in dt.Rows)
            {
                LookupDataContract L = new LookupDataContract();
                L.Name = Convert.ToString(dr["Text"]);
                L.LookupIDGuID = Convert.ToString(dr["AccountID"]);
                L.AssetOrLiability = Convert.ToInt32(dr["AssetOrLiability"]);
                L.Type = Convert.ToString(dr["Type"]);
                L.DebtEquityType = Convert.ToString(dr["DebtEquityType"]);
                L.TableGUID = Convert.ToString(dr["LiabilityGUID"]);
                L.Value = Convert.ToString(dr["BankerName"]);  

                lstDC.Add(L);
            }

            return lstDC;
        }

        public List<LookupDataContract> GetDebtEquityTypeList()
        {
            DataTable dt = new DataTable();
            List<LookupDataContract> lstDC = new List<LookupDataContract>();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetDebtEquityTypeList");

            foreach (DataRow dr in dt.Rows)
            {
                LookupDataContract L = new LookupDataContract();
                L.Name = Convert.ToString(dr["Name"]);
                L.LookupID = Convert.ToInt32(dr["AccountCategoryID"]);
                lstDC.Add(L);
            }
            return lstDC;
        }

        public List<LookupDataContract> GetTransactionTypesLookupForJournalEntry()
        {

            DataTable dt = new DataTable();
            List<LookupDataContract> lstDC = new List<LookupDataContract>();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetTransactionTypesLookupForJournalEntry");

            foreach (DataRow dr in dt.Rows)
            {
                LookupDataContract L = new LookupDataContract();
                L.Name = Convert.ToString(dr["TransactionName"]);
                L.LookupID = Convert.ToInt32(dr["TransactionTypesID"]);
                lstDC.Add(L);
            }

            return lstDC;
        }
        public List<LiabilityFundingScheduleDataContract> GetLiabilityFundingScheduleByDealAccountID(string DealAccountID)
        {
            List<LiabilityFundingScheduleDataContract> ListLiabilityFundingSchedule = new List<LiabilityFundingScheduleDataContract>();
            DataTable dt = new DataTable();
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealAccountID", Value = DealAccountID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetLiabilityFundingScheduleByDealAccountID", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    LiabilityFundingScheduleDataContract LiabilityFundingSchedule = new LiabilityFundingScheduleDataContract();

                    LiabilityFundingSchedule.LiabilityFundingScheduleID = CommonHelper.ToInt32(dr["LiabilityFundingScheduleID"]);
                    LiabilityFundingSchedule.LiabilityNoteAccountID = Convert.ToString(dr["LiabilityNoteAccountID"]);
                    LiabilityFundingSchedule.LiabilityNoteID = Convert.ToString(dr["LiabilityNoteID"]);
                    LiabilityFundingSchedule.LiabilityNoteName = Convert.ToString(dr["LiabilityNoteName"]);
                    LiabilityFundingSchedule.TransactionDate = CommonHelper.ToDateTime(dr["TransactionDate"]);
                    LiabilityFundingSchedule.TransactionAmount = CommonHelper.ToDecimal(dr["TransactionAmount"]);
                    LiabilityFundingSchedule.WorkflowStatus = CommonHelper.ToInt32(dr["WorkFlowStatus"]);
                    //LiabilityFundingSchedule.WorkflowStatusText = Convert.ToString(dr["StatusText"]);
                    LiabilityFundingSchedule.GeneratedBy = CommonHelper.ToInt32(dr["GeneratedBy"]);
                    LiabilityFundingSchedule.GeneratedByText = Convert.ToString(dr["GeneratedByText"]);


                    LiabilityFundingSchedule.Applied = CommonHelper.ToBoolean(dr["Applied"]) == null ? false : Convert.ToBoolean(dr["Applied"]);
                    LiabilityFundingSchedule.Comments = Convert.ToString(dr["Comments"]);
                    LiabilityFundingSchedule.AssetAccountID = Convert.ToString(dr["AssetAccountID"]);
                    LiabilityFundingSchedule.AssetName = Convert.ToString(dr["AssetName"]);
                    LiabilityFundingSchedule.AssetID = Convert.ToString(dr["crenoteid"]);
                    LiabilityFundingSchedule.AssetTransactionDate = CommonHelper.ToDateTime(dr["AssetTransactionDate"]);
                    LiabilityFundingSchedule.AssetTransactionAmount = CommonHelper.ToDecimal(dr["AssetTransactionAmount"]);
                    LiabilityFundingSchedule.TransactionAdvanceRate = CommonHelper.ToDecimal(dr["TransactionAdvanceRate"]);
                    LiabilityFundingSchedule.CumulativeAdvanceRate = CommonHelper.ToDecimal(dr["CumulativeAdvanceRate"]);
                    LiabilityFundingSchedule.AssetTransactionComment = Convert.ToString(dr["AssetTransactionComment"]);
                    LiabilityFundingSchedule.RowNo = CommonHelper.ToInt32(dr["RowNo"]);
                    LiabilityFundingSchedule.GeneratedByUserID = Convert.ToString(dr["GeneratedByUserID"]);
                    LiabilityFundingSchedule.TransactionTypes = Convert.ToString(dr["TransactionTypes"]);




                    ListLiabilityFundingSchedule.Add(LiabilityFundingSchedule);
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
            return ListLiabilityFundingSchedule;

        }

        public List<LiabilityNoteDataContract> GetDebtorEquityNoteByLiabilityTypeID(Guid LiabilityTypeID)
        {
            List<LiabilityNoteDataContract> lstNoteDC = new List<LiabilityNoteDataContract>();
            DataTable dt = new DataTable();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@LiabilityTypeID", Value = LiabilityTypeID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetDebtorEquityNoteByLiabilityTypeID", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    LiabilityNoteDataContract _liabilityNoteDC = new LiabilityNoteDataContract();
                    _liabilityNoteDC.LiabilityNoteAccountID = new Guid(Convert.ToString(dr["AccountID"]));
                    _liabilityNoteDC.DealAccountID = Convert.ToString(dr["DealAccountID"]);
                    _liabilityNoteDC.LiabilityNoteID = Convert.ToString(dr["LiabilityNoteID"]);

                    _liabilityNoteDC.LiabilityName = Convert.ToString(dr["LiabilityNoteName"]);
                    _liabilityNoteDC.OriginalLiabilityNoteID = Convert.ToString(dr["LiabilityNoteID"]);
                    _liabilityNoteDC.Status = CommonHelper.ToInt32(dr["Status"]);
                    _liabilityNoteDC.LiabilityNoteAutoID = CommonHelper.ToInt32(dr["LiabilityNoteAutoID"]);
                    _liabilityNoteDC.LiabilityNoteGUID = new Guid(Convert.ToString(dr["LiabilityNoteGUID"]));
                    _liabilityNoteDC.StatusText = Convert.ToString(dr["StatusText"]);
                    _liabilityNoteDC.LiabilityTypeID = CommonHelper.ToGuid(dr["LiabilityTypeID"]);
                    _liabilityNoteDC.LiabilityTypeText = Convert.ToString(dr["LiabilityTypeText"]);
                    _liabilityNoteDC.AssetAccountID = Convert.ToString(dr["AssetAccountID"]);
                    _liabilityNoteDC.AssetName = Convert.ToString(dr["AssetName"]);
                    _liabilityNoteDC.PledgeDate = CommonHelper.ToDateTime(dr["PledgeDate"]);
                    _liabilityNoteDC.CurrentAdvanceRate = CommonHelper.ToDecimal(dr["CurrentAdvanceRate"]);
                    _liabilityNoteDC.TargetAdvanceRate = CommonHelper.ToDecimal(dr["TargetAdvanceRate"]);
                    _liabilityNoteDC.CurrentBalance = CommonHelper.ToDecimal(dr["CurrentBalance"]);
                    _liabilityNoteDC.UndrawnCapacity = CommonHelper.ToInt32(dr["UndrawnCapacity"]);
                    _liabilityNoteDC.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    _liabilityNoteDC.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    _liabilityNoteDC.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    _liabilityNoteDC.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    _liabilityNoteDC.DealID = Convert.ToString(dr["DealID"]);
                    _liabilityNoteDC.MaturityDate = CommonHelper.ToDateTime(dr["MaturityDate"]);
                    _liabilityNoteDC.FundingAdvanceRate = CommonHelper.ToDecimal(dr["FundingAdvanceRate"]);
                    _liabilityNoteDC.PaydownAdvanceRate = CommonHelper.ToDecimal(dr["PaydownAdvanceRate"]);
                    _liabilityNoteDC.AssociatedLiabilityTypeText = Convert.ToString(dr["AssociatedLiabilityTypeText"]);
                    _liabilityNoteDC.AssociatedLiabilityTypeGuid = Convert.ToString(dr["LiabilityNoteAssetMappingGuid"]);
                    
                    lstNoteDC.Add(_liabilityNoteDC);
                }
            }
            catch (Exception ex)
            {
            }

            return lstNoteDC;
        }
        public void InsertUpdatedLiabilityFundingSchedule(List<LiabilityFundingScheduleDataContract> LiabilityFundingSchedule, string userid)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable FundingScheduleData = new DataTable();
                FundingScheduleData.Columns.Add("LiabilityFundingScheduleID");
                FundingScheduleData.Columns.Add("LiabilityNoteAccountID");
                FundingScheduleData.Columns.Add("TransactionDate");
                FundingScheduleData.Columns.Add("TransactionAmount");
                FundingScheduleData.Columns.Add("GeneratedBy");
                FundingScheduleData.Columns.Add("Applied");
                FundingScheduleData.Columns.Add("Comments");
                FundingScheduleData.Columns.Add("AssetAccountID");
                FundingScheduleData.Columns.Add("AssetTransactionDate");
                FundingScheduleData.Columns.Add("AssetTransactionAmount");
                FundingScheduleData.Columns.Add("TransactionAdvanceRate");
                FundingScheduleData.Columns.Add("CumulativeAdvanceRate");
                FundingScheduleData.Columns.Add("AssetTransactionComment");
                FundingScheduleData.Columns.Add("RowNo");
                FundingScheduleData.Columns.Add("GeneratedByUserID");
                FundingScheduleData.Columns.Add("TransactionTypes");
                FundingScheduleData.Columns.Add("AccountID");
                FundingScheduleData.Columns.Add("EndingBalance");
                FundingScheduleData.Columns.Add("CalcType");
                FundingScheduleData.Columns.Add("IsDeleted");
                FundingScheduleData.Columns.Add("StatusID");


                if (LiabilityFundingSchedule != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(LiabilityFundingSchedule);

                    foreach (DataRow dr in dt.Rows)
                    {
                        FundingScheduleData.ImportRow(dr);
                    }
                }

                if (FundingScheduleData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtableWithUserName("usp_InsertUpdateLiabilityFundingSchedule", FundingScheduleData, "tbltype_LiabilityFundingSchedule", userid);
                }
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public List<LookupDataContract> GetAssetListByDealAccountID(string DealAccountID)
        {
            List<LookupDataContract> LookupList = new List<LookupDataContract>();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealAccountID", Value = DealAccountID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetAssetListByDealAccountID", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    LookupDataContract L = new LookupDataContract();

                    L.Name = Convert.ToString(dr["AssetName"]);
                    L.LookupIDGuID = Convert.ToString(dr["AssetAccountID"]);
                    L.AccountTypeId = Convert.ToString(dr["AccountTypeId"]);
                    L.AssetIdName = Convert.ToString(dr["AssetIdName"]);


                    LookupList.Add(L);
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
            return LookupList;
        }

        public DataTable GetAccountCategoryList()
        {

            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("dbo.usp_GetAccountCategoryList");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }
        public DataTable GetDealInfoByDealAccountID(string DealAccountID)
        {

            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealAccountID", Value = DealAccountID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetDealInfoByDealAccountID", sqlparam);


            }
            catch (Exception ex)
            {

                throw ex;
            }
            return dt;
        }

        public List<LiabilityFundingScheduleDataContract> GetLiabilityFundingScheduleByLiabilityTypeID(string LiabilityTypeID)
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
                    LiabilityFundingSchedule.TransactionDate = CommonHelper.ToDateTime(dr["TransactionDate"]);
                    LiabilityFundingSchedule.TransactionAmount = CommonHelper.ToDecimal(dr["TransactionAmount"]);
                    LiabilityFundingSchedule.EndingBalance = CommonHelper.ToDecimal(dr["EndingBalance"]);
                    LiabilityFundingSchedule.Applied = CommonHelper.ToBoolean(dr["Applied"]) == null ? false : Convert.ToBoolean(dr["Applied"]);
                    LiabilityFundingSchedule.Comments = Convert.ToString(dr["Comments"]);
                    LiabilityFundingSchedule.AssetAccountID = Convert.ToString(dr["AssetAccountID"]);
                    LiabilityFundingSchedule.AssetName = Convert.ToString(dr["AssetName"]);
                    LiabilityFundingSchedule.AssetTransactionDate = CommonHelper.ToDateTime(dr["AssetTransactionDate"]);
                    LiabilityFundingSchedule.AssetTransactionAmount = CommonHelper.ToDecimal(dr["AssetTransactionAmount"]);
                    LiabilityFundingSchedule.TransactionAdvanceRate = CommonHelper.ToDecimal(dr["TransactionAdvanceRate"]);
                    LiabilityFundingSchedule.CumulativeAdvanceRate = CommonHelper.ToDecimal(dr["CumulativeAdvanceRate"]);
                    LiabilityFundingSchedule.AssetTransactionComment = Convert.ToString(dr["AssetTransactionComment"]);
                    LiabilityFundingSchedule.TransactionTypes = Convert.ToString(dr["TransactionType"]);
                    LiabilityFundingSchedule.AccountID = Convert.ToString(dr["LiabilityAccountID"]);
                    LiabilityFundingSchedule.DealAccountID = Convert.ToString(dr["DealAccountID"]);
                    LiabilityFundingSchedule.DealName = Convert.ToString(dr["DealName"]);
                    LiabilityFundingSchedule.CREDealID = Convert.ToString(dr["CREDealID"]);
                    LiabilityFundingSchedule.CRENoteID = Convert.ToString(dr["CRENoteID"]);
                    LiabilityFundingSchedule.OriginalTotalCommitment = CommonHelper.ToDecimal(dr["OriginalTotalCommitment"]);
                    LiabilityFundingSchedule.StatusID = CommonHelper.ToInt32(dr["Status"]);
                    LiabilityFundingSchedule.StatusName = Convert.ToString(dr["StatusText"]);
                    ListLiabilityFundingSchedule.Add(LiabilityFundingSchedule);
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
            return ListLiabilityFundingSchedule;

        }

        public List<LiabilityRateSpreadDataContract> GetLiabilityRateSpreadScheduleByNoteAccountID(string AccountID, Guid? AdditionalAccountID)
        {
            List<LiabilityRateSpreadDataContract> ratelist = new List<LiabilityRateSpreadDataContract>();
            DataTable dt = new DataTable();
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteAccountID", Value = AccountID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AdditionalAccountID", Value = AdditionalAccountID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetLiabilityRateSpreadScheduleByNoteAccountID", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    LiabilityRateSpreadDataContract rate = new LiabilityRateSpreadDataContract();
                    rate.LiabilityNoteAccountID = Convert.ToString(dr["AccountID"]);
                    rate.AccountID = Convert.ToString(dr["AccountID"]);
                    rate.AdditionalAccountID = Convert.ToString(dr["AdditionalAccountID"]);
                    rate.Date = CommonHelper.ToDateTime(dr["Date"]);

                    rate.ValueTypeID = CommonHelper.ToInt32(dr["ValueTypeID"]);
                    rate.ValueTypeText = Convert.ToString(dr["ValueTypeText"]);

                    rate.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);

                    rate.IntCalcMethodID = CommonHelper.ToInt32(dr["IntCalcMethodID"]);
                    rate.IntCalcMethodText = Convert.ToString(dr["IntCalcMethodText"]);
                    rate.Value = CommonHelper.ToDecimal(dr["Value"]);
                    rate.RateOrSpreadToBeStripped = CommonHelper.ToDecimal(dr["RateOrSpreadToBeStripped"]);
                    rate.IndexNameID = CommonHelper.ToInt32(dr["IndexNameID"]);
                    rate.IndexNameText = Convert.ToString(dr["IndexNameText"]);
                    rate.DeterminationDateHolidayList = CommonHelper.ToInt32(dr["DeterminationDateHolidayList"]);
                    rate.DeterminationDateHolidayListText = Convert.ToString(dr["DeterminationDateHolidayListText"]);
                    rate.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    rate.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    rate.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    rate.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    ratelist.Add(rate);
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
            return ratelist;

        }

        public string InsertUpdateLiabilityRateSpreadSchedule(List<LiabilityRateSpreadDataContract> RateSpreadSchedule, string userid)
        {
            string status = "";
            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable RateScheduleData = new DataTable();
                RateScheduleData.Columns.Add("AccountID");
                RateScheduleData.Columns.Add("AdditionalAccountID");
                RateScheduleData.Columns.Add("EffectiveDate");
                RateScheduleData.Columns.Add("Date");
                RateScheduleData.Columns.Add("ValueTypeID");
                RateScheduleData.Columns.Add("Value");
                RateScheduleData.Columns.Add("IntCalcMethodID");
                RateScheduleData.Columns.Add("RateOrSpreadToBeStripped");
                RateScheduleData.Columns.Add("IndexNameID");
                RateScheduleData.Columns.Add("DeterminationDateHolidayList");
                RateScheduleData.Columns.Add("IsDeleted");

                if (RateSpreadSchedule != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(RateSpreadSchedule);

                    foreach (DataRow dr in dt.Rows)
                    {
                        RateScheduleData.ImportRow(dr);
                    }
                }

                if (RateScheduleData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtableWithUserName("usp_InsertUpdateLiabilityRateSpreadSchedule", RateScheduleData, "tbltype_LiabilityRateSpreadSchedule", userid);
                    status = "Saved";
                }
            }
            catch (Exception)
            {

                throw;
            }
            return status;
        }

        public string InsertUpdatedLiabilityFeeSchedule(List<FeeScheduleDataContract> FeeSchedule, string userid)
        {
            string status = "";
            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable FeeScheduleData = new DataTable();
                FeeScheduleData.Columns.Add("AccountID");
                FeeScheduleData.Columns.Add("AdditionalAccountID");
                FeeScheduleData.Columns.Add("EffectiveDate");
                FeeScheduleData.Columns.Add("FeeName");
                FeeScheduleData.Columns.Add("StartDate");
                FeeScheduleData.Columns.Add("EndDate");
                FeeScheduleData.Columns.Add("ValueTypeID");
                FeeScheduleData.Columns.Add("Fee");
                FeeScheduleData.Columns.Add("FeeAmountOverride");
                FeeScheduleData.Columns.Add("BaseAmountOverride");
                FeeScheduleData.Columns.Add("ApplyTrueUpFeatureID");
                FeeScheduleData.Columns.Add("IncludedLevelYield");
                FeeScheduleData.Columns.Add("PercentageOfFeeToBeStripped");
                FeeScheduleData.Columns.Add("IsDeleted");
                if (FeeSchedule != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(FeeSchedule);

                    foreach (DataRow dr in dt.Rows)
                    {
                        FeeScheduleData.ImportRow(dr);
                    }
                }

                if (FeeScheduleData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtableWithUserName("usp_InsertUpdateLiabilityFeeSchedule", FeeScheduleData, "tbltype_DebtFeeSchedule", userid);
                    status = "Saved";
                }
            }
            catch (Exception)
            {
                throw;
            }
            return status;
        }

        public List<ScheduleEffectiveDateLiabilityDataContract> GetScheduleEffectiveDateCountByAccountId(Guid AccountId, Guid? AdditionalAccountId)
        {
            Helper.Helper hp = new Helper.Helper();
            List<ScheduleEffectiveDateLiabilityDataContract> _scheduledatecount = new List<ScheduleEffectiveDateLiabilityDataContract>();
            DataTable dt = new DataTable();
            SqlParameter p1 = new SqlParameter { ParameterName = "@AccountId", Value = AccountId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@AdditionalAccountId", Value = AdditionalAccountId };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("usp_GetScheduleEffectiveDateCountByAccountId_Liability", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                ScheduleEffectiveDateLiabilityDataContract lstschedulecount = new ScheduleEffectiveDateLiabilityDataContract();
                lstschedulecount.ScheduleName = Convert.ToString(dr["ScheduleType"]);
                lstschedulecount.EffectiveDateCount = Convert.ToInt32(dr["EffectiveStartDateCounts"]);
                lstschedulecount.NoteAccountId = AccountId;
                lstschedulecount.AdditionalAccountId = AdditionalAccountId;
                _scheduledatecount.Add(lstschedulecount);
            }
            return _scheduledatecount;
        }

        public DataTable GetHistoricalDataOfModuleByAccountId(Guid? AccountId, Guid? userID, string ModuleName, Guid? AdditionalAccountId)
        {
            DataTable dt = new DataTable();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AccountId", Value = AccountId };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@ModuleName", Value = ModuleName };
                SqlParameter p4 = new SqlParameter { ParameterName = "@AdditionalAccountId", Value = AdditionalAccountId };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
                dt = hp.ExecDataTable("usp_GetHistoricalDataOfModuleByAccountId_Liability", sqlparam);
            }
            catch (Exception ex)
            {
            }
            return dt;
        }

        public void InsertUpdatedLiabilityNoteAssetMapping(List<LiabilityNoteAssetMapping> LiabilityAssetMap, string userid)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable AssetMapData = new DataTable();
                AssetMapData.Columns.Add("DealAccountId");
                AssetMapData.Columns.Add("LiabilityNoteAccountId");
                AssetMapData.Columns.Add("AssetAccountId");

                if (LiabilityAssetMap != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(LiabilityAssetMap);

                    foreach (DataRow dr in dt.Rows)
                    {
                        AssetMapData.ImportRow(dr);
                    }
                }

                if (AssetMapData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtableWithUserName("usp_InsertUpdateLiabilityNoteAssetMapping", AssetMapData, "tblNoteAssetMap", userid);
                }
            }
            catch (Exception)
            {

                throw;
            }
        }

        public List<LiabilityNoteAssetMapping> GetLiabilityNoteAssetMappingByDealAccountID(string DealAccountID)
        {
            List<LiabilityNoteAssetMapping> List = new List<LiabilityNoteAssetMapping>();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealAccountID", Value = DealAccountID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetLiabilityNoteAssetMapping", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    LiabilityNoteAssetMapping L = new LiabilityNoteAssetMapping();
                    L.LiabilityNoteId = Convert.ToString(dr["LiabilityNoteID"]);
                    L.DealAccountId = Convert.ToString(dr["DealAccountId"]);
                    L.LiabilityNoteAccountId = Convert.ToString(dr["LiabilityNoteAccountId"]);
                    L.AssetAccountId = Convert.ToString(dr["AssetAccountId"]);
                    List.Add(L);
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
            return List;
        }

        public string CheckDuplicateforLiabilities(string ID, string TypeName, Guid? Accountid)
        {
            string isexist = "";
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AccountID", Value = Accountid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ID", Value = ID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Type", Value = TypeName };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dt = hp.ExecDataTable("usp_CheckDuplicateforLiabilities", sqlparam);

                isexist = dt.Rows[0].ItemArray[0].ToString();

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return isexist;
        }

        public DataTable GeDebtOrEquityTransactionByAccountID(string AccountId, string AnalysisId)
        {

            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AccountId", Value = AccountId };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisId", Value = AnalysisId };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetTransactionEntryLiabilityLineByAccountId", sqlparam);

            }
            catch (Exception ex)
            {

                throw ex;
            }
            return dt;
        }

        public DataTable GetTransactionEntryLiabilityNoteByDealAccountId(string DealAccountId, string AnalysisId)
        {

            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealAccountId", Value = DealAccountId };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisId", Value = AnalysisId };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetTransactionEntryLiabilityNoteByDealAccountId", sqlparam);

            }
            catch (Exception ex)
            {

                throw ex;
            }
            return dt;
        }

        public void DeleteLiabilityNote(Guid? liabilityNoteAccountId)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@liabilityNoteAccountId", Value = liabilityNoteAccountId };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            var count = hp.ExecNonquery("dbo.usp_DeleteLiabilityNote", sqlparam);
        }

        public void MoveConfirmedToAdditionalTransactionEntry(string DealAccountId, string username)
        {


            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealAccountId", Value = DealAccountId };
                SqlParameter p2 = new SqlParameter { ParameterName = "@CreatedBy ", Value = username };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecDataTable("dbo.usp_InsertAdditionalTransactionEntry", sqlparam);

            }
            catch (Exception ex)
            {

                throw ex;
            }

        }

        public DataTable GetDealLiabilityCashflowsExportExcel(string DealAccountId, string AnalysisId)
        {

            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealAccountId", Value = DealAccountId };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisId", Value = AnalysisId };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetDealLiabilityCashflowExportExcel", sqlparam);

            }
            catch (Exception ex)
            {

                throw ex;
            }
            return dt;
        }

        public void InsertUpdateLiabilityFundingScheduleAggregate(DataTable FundingScheduleData, string userid)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable FundingData = new DataTable();
                FundingData.Columns.Add("LiabilityFundingScheduleAggregateID");
                FundingData.Columns.Add("AccountID");
                FundingData.Columns.Add("TransactionDate");
                FundingData.Columns.Add("TransactionAmount");
                FundingData.Columns.Add("TransactionTypes");
                FundingData.Columns.Add("Applied");
                FundingData.Columns.Add("Comments");
                FundingData.Columns.Add("EndingBalance");
                FundingData.Columns.Add("CalcType");
                FundingData.Columns.Add("ParentAccountID");
                FundingData.Columns.Add("IsDeleted");
                FundingData.Columns.Add("StatusID");

                if (FundingScheduleData != null)
                {

                    foreach (DataRow dr in FundingScheduleData.Rows)
                    {
                        FundingData.ImportRow(dr);
                    }
                }
                if (FundingData.Rows.Count > 0)
                {

                    hp.ExecDataTablewithtableWithUserName("usp_InsertUpdateLiabilityFundingScheduleAggregate", FundingData, "tbltype_LiabilityFundingScheduleAggregate", userid);
                }


            }
            catch (Exception)
            {

                throw;
            }
        }

        public void UploadLiabilityFromFile(DataTable dtCash, DataTable dtDebt, DataTable dtEquityCapitalTransactions, DataTable dtInvestors, DataTable dtEquity, DataTable dtDebtRepoLine, DataTable dtDealLibAdvRate, DataTable dtDealLiability, DataTable dt11Trans)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();

                if (dtCash.Rows.Count > 0)
                    hp.ExecDataTablewithtable("usp_InsertCashTransactions", dtCash, "tbltype_CashTransactions");
                if (dtDebt.Rows.Count > 0)
                    hp.ExecDataTablewithtable("usp_InsertDebtDrawsPaydowns", dtDebt, "tbltype_DebtDrawsPaydowns");
                if (dtEquityCapitalTransactions.Rows.Count > 0)
                    hp.ExecDataTablewithtable("usp_InsertEquityCapitalTransactions", dtEquityCapitalTransactions, "tbltype_EquityCapitalTransactions");
                if (dtInvestors.Rows.Count > 0)
                    hp.ExecDataTablewithtable("usp_InsertInvestors", dtInvestors, "tbltype_Investors");

                if (dtEquity.Rows.Count > 0)
                    hp.ExecDataTablewithtable("usp_InsertLib_Equity", dtEquity, "tbltype_Lib");
                if (dtDebtRepoLine.Rows.Count > 0)
                    hp.ExecDataTablewithtable("usp_InsertLib_DebtRepoLine", dtDebtRepoLine, "tbltype_Lib");
                if (dtDealLibAdvRate.Rows.Count > 0)
                    hp.ExecDataTablewithtable("usp_InsertLib_DealLibAdvRate", dtDealLibAdvRate, "tbltype_Lib");
                if (dtDealLiability.Rows.Count > 0)
                    hp.ExecDataTablewithtable("usp_InsertLib_DealLiability", dtDealLiability, "tbltype_Lib");
                if (dt11Trans.Rows.Count > 0)
                    hp.ExecDataTablewithtable("usp_InsertLib_11Trans", dt11Trans, "tbltype_Lib");

                hp.ExecNonquery("dbo.usp_InsertLiabilityFundingSchedule_FromFile");
            }
            catch (Exception)
            {

                throw;
            }
        }

        public void UploadInvestorsData(DataTable dtInvestors, string EquityAccountID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                if (dtInvestors.Rows.Count > 0)
                    hp.ExecDataTablewithtableAccountID("usp_InsertInvestors", dtInvestors, "tbltype_Investors", CommonHelper.ToGuid(EquityAccountID));
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void InsertLib11Trans(DataTable dt11Trans, string EquityAccountName, DateTime gCutoffdate)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                if (dt11Trans.Rows.Count > 0)
                    hp.ExecDataTablewithtableAccountname("usp_InsertLib_11Trans", dt11Trans, "tbltype_Lib", EquityAccountName);

                SqlParameter p1 = new SqlParameter { ParameterName = "@gCutoffdate", Value = gCutoffdate };
                SqlParameter[] sqlparam1 = new SqlParameter[] { p1 };
                hp.ExecNonquery("dbo.usp_Liability_Onetime_TransactionEntryLiability", sqlparam1);

                if (EquityAccountName == "ACORE Credit Partners I")
                {
                    SqlParameter p2 = new SqlParameter { ParameterName = "@gCutoffdate", Value = gCutoffdate };
                    SqlParameter[] sqlparam2 = new SqlParameter[] { p2 };
                    hp.ExecNonquery("dbo.usp_Liability_Onetime_TransactionEntry_ACPI", sqlparam2);
                }
                else
                {
                    SqlParameter p2 = new SqlParameter { ParameterName = "@gCutoffdate", Value = gCutoffdate };
                    SqlParameter[] sqlparam2 = new SqlParameter[] { p2 };
                    hp.ExecNonquery("dbo.usp_Liability_Onetime_TransactionEntry", sqlparam2);
                }

                SqlParameter p3 = new SqlParameter { ParameterName = "@gCutoffdate", Value = gCutoffdate };
                SqlParameter[] sqlparam3 = new SqlParameter[] { p3 };
                hp.ExecNonquery("dbo.usp_Liability_Onetime_LiabilityFundingSchedule", sqlparam3);
            }
            catch (Exception ex)
            {

                throw;
            }

        }

        public DataTable GetDealDatabyCREDealID(string CREDealID)
        {

            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@CREDealID", Value = CREDealID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_getDealDatabyCREDealID", sqlparam);

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }

        public void InsertUpdateGeneralSetupLiabilityNote(LiabilityNoteDataContract lndc, string userid)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@AccountID", Value = lndc.LiabilityNoteAccountID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@EffectiveDate", Value = lndc.EffectiveDate };
                SqlParameter p3 = new SqlParameter { ParameterName = "@PaydownAdvanceRate", Value = lndc.PaydownAdvanceRate };
                SqlParameter p4 = new SqlParameter { ParameterName = "@FundingAdvanceRate", Value = lndc.FundingAdvanceRate };
                SqlParameter p5 = new SqlParameter { ParameterName = "@TargetAdvanceRate", Value = lndc.TargetAdvanceRate };
                SqlParameter p6 = new SqlParameter { ParameterName = "@MaturityDate", Value = lndc.MaturityDate };
                SqlParameter p7 = new SqlParameter { ParameterName = "@UserID", Value = userid };
                SqlParameter p8 = new SqlParameter { ParameterName = "@PledgeDate", Value = lndc.PledgeDate };
                SqlParameter p9 = new SqlParameter { ParameterName = "@LiabilitySourceID", Value = lndc.LiabilitySource };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9 };
                hp.ExecNonquery("usp_InsertUpdateGeneralSetupDetailsLiabilityNote", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void DeleteLiabilityData_ForOneTimeUpload(string AccountID, string Type)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@AccountID", Value = CommonHelper.ToGuid(AccountID) };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Type", Value = Type };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecNonquery("usp_DeleteLiabilityData_ForOneTimeUpload", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetDebtNameforAssociatedEquityFund(string AccountID, string LiabilityType)
        {

            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AccountID", Value = AccountID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@LiabilityType", Value = LiabilityType };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetDebtNameforAssociatedEquityFund", sqlparam);

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }

        public void InsertUpdateRepoExtDatafromFundLevel(List<DebtDataContract> ddc, string userid)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable DebtExtData = new DataTable();
                DebtExtData.Columns.Add("DebtExtID");
                DebtExtData.Columns.Add("DebtAccountID");
                DebtExtData.Columns.Add("AdditionalAccountID");
                DebtExtData.Columns.Add("PayFrequency");              
                DebtExtData.Columns.Add("AccrualEndDateBusinessDayLag");
                DebtExtData.Columns.Add("AccrualFrequency");           
                DebtExtData.Columns.Add("DefaultIndexName");
                DebtExtData.Columns.Add("FinanacingSpreadRate");
                DebtExtData.Columns.Add("IntCalcMethod");
                DebtExtData.Columns.Add("RoundingMethod");
                DebtExtData.Columns.Add("IndexRoundingRule");
                DebtExtData.Columns.Add("TargetAdvanceRate");
                DebtExtData.Columns.Add("pmtdtaccper");
                DebtExtData.Columns.Add("ResetIndexDaily");
                DebtExtData.Columns.Add("DeterminationDateHolidayList");
                

                if (ddc != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ddc);

                    foreach (DataRow dr in dt.Rows)
                    {
                        DebtExtData.ImportRow(dr);
                    }
                }

                if (DebtExtData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtableWithUserName("usp_InsertUpdateDebtExt", DebtExtData, "tbltype_DebtExt", userid);

                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public List<DebtDataContract> GetRepoExtDatafromFundLevel(Guid DebtAccountID, Guid AdditionalAccountID)
        {
            List<DebtDataContract> dtlist = new List<DebtDataContract>();
            DataTable dt = new DataTable();
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DebtAccountID", Value = DebtAccountID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AdditionalAccountID", Value = AdditionalAccountID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetDebtExtData", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    DebtDataContract debtExt = new DebtDataContract();
                    debtExt.DebtExtID = CommonHelper.ToInt32(dr["DebtExtID"]);
                    debtExt.DebtAccountID = new Guid(Convert.ToString(dr["DebtAccountID"]));
                    debtExt.AdditionalAccountID = new Guid(Convert.ToString(dr["AdditionalAccountID"]));
                    debtExt.PayFrequency = CommonHelper.ToInt32(dr["PaymentFrequency"]);
                     
                    debtExt.AccrualEndDateBusinessDayLag = CommonHelper.ToInt32(dr["AccrualEndDateBusinessDayLag"]);
                    debtExt.AccrualFrequency = CommonHelper.ToInt32(dr["AccrualFrequency"]);
                    debtExt.DeterminationDateHolidayList = CommonHelper.ToInt32(dr["DeterminationDateHolidayList"]);
                    debtExt.RoundingMethod = CommonHelper.ToInt32(dr["Roundingmethod"]);
                    debtExt.IndexRoundingRule = CommonHelper.ToInt32(dr["IndexRoundingRule"]);
                    debtExt.FinanacingSpreadRate = CommonHelper.ToDecimal(dr["FinanacingSpreadRate"]);
                    debtExt.IntCalcMethod = CommonHelper.ToInt32(dr["IntActMethod"]);
                    debtExt.DefaultIndexName = CommonHelper.ToInt32(dr["DefaultIndexName"]);
                    debtExt.TargetAdvanceRate = CommonHelper.ToDecimal(dr["TargetAdvanceRate"]);                   

                    debtExt.pmtdtaccper = CommonHelper.ToInt32(dr["pmtdtaccper"]);
                    debtExt.ResetIndexDaily = CommonHelper.ToInt32(dr["ResetIndexDaily"]);

                    dtlist.Add(debtExt);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dtlist;

        }

        public List<DebtDataContract> GetAllDebtData()
        {
            List<DebtDataContract> dtlist = new List<DebtDataContract>();
            DataTable dt = new DataTable();
            try
            {

                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("dbo.usp_GetAllDebtExt");

                foreach (DataRow dr in dt.Rows)
                {
                    DebtDataContract debtExt = new DebtDataContract();
                    debtExt.DebtExtID = CommonHelper.ToInt32(dr["DebtExtID"]);
                    debtExt.DebtAccountID = new Guid(Convert.ToString(dr["DebtAccountID"]));
                    debtExt.AdditionalAccountID = new Guid(Convert.ToString(dr["AdditionalAccountID"]));
                    debtExt.DebtTypeText = Convert.ToString(dr["TableName"]);
                    debtExt.LiabilityNoteID = Convert.ToString(dr["LiabilityNoteID"]);

                    dtlist.Add(debtExt);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dtlist;
        }


        public void InsertUpdateDebtOneTimeUpdate(DebtDataContract ddc, string userid)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@DebtID", Value = ddc.DebtID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AccountID", Value = ddc.DebtAccountID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@OriginationDate", Value = ddc.OriginationDate };
                SqlParameter p4 = new SqlParameter { ParameterName = "@UserID", Value = userid };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
                hp.ExecNonquery("usp_InsertUpdateDebtOneTimeUpdate", sqlparam);

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        public void InsertUpdateLiabilityNoteFromExcel(LiabilityNoteDataContract ndc, string userid)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@LiabilityNoteAutoID", Value = ndc.LiabilityNoteAutoID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@PaymentFrequency", Value = ndc.PayFrequency };
                SqlParameter p3 = new SqlParameter { ParameterName = "@AccrualEndDateBusinessDayLag", Value = ndc.AccrualEndDateBusinessDayLag };
                SqlParameter p4 = new SqlParameter { ParameterName = "@AccrualFrequency", Value = ndc.AccrualFrequency };
                SqlParameter p5 = new SqlParameter { ParameterName = "@Roundingmethod", Value = ndc.RoundingMethod };
                SqlParameter p6 = new SqlParameter { ParameterName = "@IndexRoundingRule", Value = ndc.IndexRoundingRule };
                SqlParameter p7 = new SqlParameter { ParameterName = "@UseNoteLevelOverride", Value = ndc.UseNoteLevelOverride };
                SqlParameter p8 = new SqlParameter { ParameterName = "@UserID", Value = userid };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8 };
                hp.ExecNonquery("usp_InsertUpdateLiabilityNoteFromExcel", sqlparam);

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public void DeleteLiability_ScheduleData_Temp()
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                hp.ExecNonquery("usp_DeleteLiability_ScheduleData_Temp");

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }



        public List<LiabilityFundingScheduleDataContract> GetDealLevelDataLiabilityFundingScheduleDetail(string LiabilityTypeID)
        {
            List<LiabilityFundingScheduleDataContract> ListLiabilityFundingSchedule = new List<LiabilityFundingScheduleDataContract>();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@LiabilityTypeID", Value = LiabilityTypeID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetDealLevelDataLiabilityFundingScheduleDetail", sqlparam);


                foreach (DataRow dr in dt.Rows)
                {
                    LiabilityFundingScheduleDataContract LiabilityFundingSchedule = new LiabilityFundingScheduleDataContract();

                    LiabilityFundingSchedule.TransactionDate = CommonHelper.ToDateTime(dr["TransactionDate"]);
                    LiabilityFundingSchedule.TransactionAmount = CommonHelper.ToDecimal(dr["TotalTransactionAmount"]);
                    LiabilityFundingSchedule.Applied = CommonHelper.ToBoolean(dr["Applied"]) == null ? false : Convert.ToBoolean(dr["Applied"]);
                    LiabilityFundingSchedule.Comments = Convert.ToString(dr["Comments"]);
                    LiabilityFundingSchedule.TransactionTypes = Convert.ToString(dr["TransactionType"]);
                    LiabilityFundingSchedule.EndingBalance = CommonHelper.ToDecimal(dr["EndingBalance"]);
                    LiabilityFundingSchedule.DealName = Convert.ToString(dr["DealName"]);
                    LiabilityFundingSchedule.CREDealID = Convert.ToString(dr["CREDealID"]);
                    LiabilityFundingSchedule.DealAccountID = Convert.ToString(dr["DealAccountID"]);
                    LiabilityFundingSchedule.LiabilityFundingScheduleDealID = Convert.ToInt32(dr["LiabilityFundingScheduleDealID"]);
                    LiabilityFundingSchedule.AccountID = Convert.ToString(dr["AccountID"]);
                    LiabilityFundingSchedule.StatusID = CommonHelper.ToInt32(dr["Status"]);
                    LiabilityFundingSchedule.StatusName = Convert.ToString(dr["StatusText"]);

                    ListLiabilityFundingSchedule.Add(LiabilityFundingSchedule);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return ListLiabilityFundingSchedule;
        }
        public List<LookupDataContract> GetAssociatedDealsByLiabilityTypeID(string LiabilityTypeID)
        {
            List<LookupDataContract> ListssociatedDeals = new List<LookupDataContract>();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@LiabilityTypeID", Value = LiabilityTypeID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetAssociatedDealsByLiabilityTypeID", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    LookupDataContract lookitem = new LookupDataContract();
                    lookitem.LookupIDGuID = Convert.ToString(dr["AssetAccountID"]);
                    lookitem.Name = Convert.ToString(dr["AssetName"]);
                    ListssociatedDeals.Add(lookitem);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return ListssociatedDeals;
        }

        public void InsertUpdateDealLevelDataLiabilityFundingScheduleDetail(List<LiabilityFundingScheduleDataContract> ddc, string userid)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable DealLevelFundingScheduleData = new DataTable();
                DealLevelFundingScheduleData.Columns.Add("LiabilityFundingScheduleDealID");
                DealLevelFundingScheduleData.Columns.Add("AccountID");
                DealLevelFundingScheduleData.Columns.Add("DealAccountID");
                DealLevelFundingScheduleData.Columns.Add("TransactionDate");
                DealLevelFundingScheduleData.Columns.Add("TransactionAmount");
                DealLevelFundingScheduleData.Columns.Add("Applied");
                DealLevelFundingScheduleData.Columns.Add("Comments");
                DealLevelFundingScheduleData.Columns.Add("GeneratedByUserID");
                DealLevelFundingScheduleData.Columns.Add("TransactionTypes");
                DealLevelFundingScheduleData.Columns.Add("EndingBalance");
                DealLevelFundingScheduleData.Columns.Add("IsDeleted");
                DealLevelFundingScheduleData.Columns.Add("StatusID");

                if (ddc != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ddc);

                    foreach (DataRow dr in dt.Rows)
                    {
                        DealLevelFundingScheduleData.ImportRow(dr);
                    }
                }

                if (DealLevelFundingScheduleData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtableWithUserName("usp_InsertUpdateDealLevelLiabilityFunding", DealLevelFundingScheduleData, "tbltype_DealLevelLiabilityFunding", userid);
                }
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public List<InterestExpenseScheduleDataContract> GetInterestExpenseSchedule(Guid DebtAccountID, Guid AdditionalAccountID)
        {
            List<InterestExpenseScheduleDataContract> dtlist = new List<InterestExpenseScheduleDataContract>();
            DataTable dt = new DataTable();
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DebtAccountID", Value = DebtAccountID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AdditionalAccountID", Value = AdditionalAccountID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetInterestExpenseSchedule", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    InterestExpenseScheduleDataContract intExp = new InterestExpenseScheduleDataContract();
                    intExp.InterestExpenseScheduleID = CommonHelper.ToInt32(dr["InterestExpenseScheduleID"]);
                    intExp.DebtAccountID = new Guid(Convert.ToString(dr["DebtAccountID"]));
                    intExp.AdditionalAccountID = new Guid(Convert.ToString(dr["AdditionalAccountID"]));
                    intExp.EventID = new Guid(Convert.ToString(dr["EventID"]));
                    intExp.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                    intExp.InitialInterestAccrualEnddate = CommonHelper.ToDateTime(dr["InitialInterestAccrualEndDate"]);
                    intExp.PaymentDayOfMonth = CommonHelper.ToInt32(dr["PaymentDayOfMonth"]);
                    intExp.PaymentDateBusinessDayLag = CommonHelper.ToInt32(dr["PaymentDateBusinessDayLag"]);
                    intExp.Determinationdateleaddays = CommonHelper.ToInt32(dr["DeterminationDateLeadDays"]);
                    intExp.DeterminationDateReferenceDayOftheMonth = CommonHelper.ToInt32(dr["DeterminationDateReferenceDayOftheMonth"]);
                    intExp.InitialIndexValueOverride = CommonHelper.ToDecimal(dr["InitialIndexValueOverride"]);
                    intExp.FirstRateIndexResetDate = CommonHelper.ToDateTime(dr["FirstRateIndexResetDate"]);
                    intExp.Recourse = CommonHelper.ToDecimal(dr["Recourse"]);
                    dtlist.Add(intExp);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dtlist;

        }

        public void InsertUpdateInterestExpenseSchedule(List<InterestExpenseScheduleDataContract> ddc, string userid)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable IntExpData = new DataTable();
                IntExpData.Columns.Add("InterestExpenseScheduleID");
                IntExpData.Columns.Add("EventID");
                IntExpData.Columns.Add("DebtAccountID");
                IntExpData.Columns.Add("AdditionalAccountID");
                IntExpData.Columns.Add("EffectiveDate");
                IntExpData.Columns.Add("InitialInterestAccrualEndDate");
                IntExpData.Columns.Add("PaymentDayOfMonth");
                IntExpData.Columns.Add("PaymentDateBusinessDayLag");
                IntExpData.Columns.Add("DeterminationDateLeadDays");
                IntExpData.Columns.Add("DeterminationDateReferenceDayOftheMonth");
                IntExpData.Columns.Add("FirstRateIndexResetDate");
                IntExpData.Columns.Add("InitialIndexValueOverride");
                IntExpData.Columns.Add("Recourse");                

                if (ddc != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ddc);

                    foreach (DataRow dr in dt.Rows)
                    {
                        IntExpData.ImportRow(dr);
                    }
                }

                if (IntExpData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtableWithUserName("usp_InsertUpdateInterestExpenseSchedule", IntExpData, "tbltype_InterestExpenseSchedule", userid);
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public void DeleteInterestExpenseSchedule(Guid DebtAccountID, Guid AdditionalAccountID)
        {
            List<InterestExpenseScheduleDataContract> dtlist = new List<InterestExpenseScheduleDataContract>();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DebtAccountID", Value = DebtAccountID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AdditionalAccountID", Value = AdditionalAccountID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecDataTable("dbo.usp_DeleteInterestExpenseSchedule", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertPrepayAndAdditionalFeeScheduleLiabilityDetail(List<PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract> ddc, string userid)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable PrepayDetailData = new DataTable();
                PrepayDetailData.Columns.Add("AccountID");
                PrepayDetailData.Columns.Add("AdditionalAccountID");
                PrepayDetailData.Columns.Add("EventID");
                PrepayDetailData.Columns.Add("EffectiveDate");
                PrepayDetailData.Columns.Add("ValueTypeID");
                PrepayDetailData.Columns.Add("StartDate");
                PrepayDetailData.Columns.Add("From");
                PrepayDetailData.Columns.Add("To");
                PrepayDetailData.Columns.Add("Value");

                if (ddc != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ddc);

                    foreach (DataRow dr in dt.Rows)
                    {
                        PrepayDetailData.ImportRow(dr);
                    }
                }

                if (PrepayDetailData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtableWithUserName("usp_InsertPrepayAndAdditionalFeeScheduleLiabilityDetail", PrepayDetailData, "tbltype_PrepayAndAdditionalFeeScheduleLiabilityDetail", userid);
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public void InsertLiabilityTransactionTabOnly(DataTable dt11Trans, string EquityAccountName, DateTime gCutoffdate)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                if (dt11Trans.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtableAccountname("usp_InsertLib_11Trans", dt11Trans, "tbltype_Lib", EquityAccountName);

                    SqlParameter p1 = new SqlParameter { ParameterName = "@gCutoffdate", Value = gCutoffdate };
                    SqlParameter[] sqlparam1 = new SqlParameter[] { p1 };
                    
                    hp.ExecNonquery("dbo.usp_Liability_Onetime_TransactionEntryLiability_UploadTransactionTabOnly", sqlparam1);

                    hp.ExecNonquery("dbo.usp_Liability_Onetime_TransactionEntry_UploadTransactionTabOnly", sqlparam1);

                    hp.ExecNonquery("dbo.usp_Liability_Onetime_LiabilityFundingSchedule_UploadTransactionTabOnly");
                }
            }
            catch (Exception ex)
            {
                throw;
            }

        }
    }
}
