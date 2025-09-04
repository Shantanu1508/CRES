using CRES.DAL.Helper;
using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace CRES.DAL.Repository
{
    public class EquityRepository
    {
        public EquityDataContract InsertUpdateEquity(Guid? userid, EquityDataContract _equityDC)
        {
            EquityDataContract EquityDebtdata = new EquityDataContract();
            Helper.Helper hp = new Helper.Helper();
            int res = 0;
            try
            {

                if (_equityDC.EquityID == null)
                    _equityDC.EquityID = 0;

                SqlParameter p1 = new SqlParameter { ParameterName = "@EquityID", Value = _equityDC.EquityID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AccountID", Value = _equityDC.EquityAccountID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@EquityName", Value = _equityDC.EquityName };
                SqlParameter p4 = new SqlParameter { ParameterName = "@EquityType", Value = _equityDC.EquityType };
                SqlParameter p5 = new SqlParameter { ParameterName = "@Status", Value = _equityDC.Status };
                SqlParameter p6 = new SqlParameter { ParameterName = "@Currency", Value = _equityDC.Currency };
                SqlParameter p7 = new SqlParameter { ParameterName = "@InvestorCapital", Value = _equityDC.InvestorCapital };
                SqlParameter p8 = new SqlParameter { ParameterName = "@CapitalReserveRequirement", Value = _equityDC.CapitalReserveRequirement };
                SqlParameter p9 = new SqlParameter { ParameterName = "@ReserveRequirement", Value = _equityDC.ReserveRequirement };
                SqlParameter p10 = new SqlParameter { ParameterName = "@CommittedCapital", Value = _equityDC.CommittedCapital };
                SqlParameter p11 = new SqlParameter { ParameterName = "@CapitalReserve", Value = _equityDC.CapitalReserve };
                SqlParameter p12 = new SqlParameter { ParameterName = "@UncommittedCapital", Value = _equityDC.UncommittedCapital };
                SqlParameter p13 = new SqlParameter { ParameterName = "@CapitalCallNoticeBusinessDays", Value = _equityDC.CapitalCallNoticeBusinessDays };
                SqlParameter p14 = new SqlParameter { ParameterName = "@EarliestEquityArrival", Value = _equityDC.EarliestEquityArrival };
                SqlParameter p15 = new SqlParameter { ParameterName = "@InceptionDate", Value = _equityDC.InceptionDate };
                SqlParameter p16 = new SqlParameter { ParameterName = "@LastDatetoInvest", Value = _equityDC.LastDatetoInvest };
                SqlParameter p17 = new SqlParameter { ParameterName = "@FundBalanceexcludingReserves", Value = _equityDC.FundBalanceexcludingReserves };
                SqlParameter p18 = new SqlParameter { ParameterName = "@LinkedShortTermBorrowingFacility", Value = _equityDC.LinkedShortTermBorrowingFacilityID };

                SqlParameter p19 = new SqlParameter { ParameterName = "@EffectiveDate", Value = _equityDC.EffectiveDate };
                SqlParameter p20 = new SqlParameter { ParameterName = "@Commitment", Value = _equityDC.Commitment };
                SqlParameter p21 = new SqlParameter { ParameterName = "@InitialMaturityDate", Value = _equityDC.InitialMaturityDate };
                SqlParameter p22 = new SqlParameter { ParameterName = "@FundDelay", Value = _equityDC.FundDelay };
                SqlParameter p23 = new SqlParameter { ParameterName = "@FundingDay", Value = _equityDC.FundingDay };

                SqlParameter p24 = new SqlParameter { ParameterName = "@UserID", Value = userid };

                SqlParameter p25 = new SqlParameter { ParameterName = "@EquityAccountID", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter p26 = new SqlParameter { ParameterName = "@EquityGUID_Output", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter p27 = new SqlParameter { ParameterName = "@CashAccountID", Value = _equityDC.CashAccountID };
                SqlParameter p28 = new SqlParameter { ParameterName = "@AbbreviationName", Value = _equityDC.AbbreviationName };
                SqlParameter p29 = new SqlParameter { ParameterName = "@StructureID", Value = _equityDC.StructureID };
                


                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27,p28,p29 };
                DataTable dt = hp.ExecDataTable("dbo.usp_InsertUpdateEquity", sqlparam);

                EquityDebtdata.EquityAccountID = Convert.ToString(p25.Value);
                EquityDebtdata.EquityGUID = Convert.ToString(p26.Value);

                return EquityDebtdata;

            }
            catch (Exception ex)
            {
                throw new Exception("error in InsertUpdateEquity-equityrepository" + ex.Message);
            }

        }
        public EquityDataContract GetEquityByEquityID(Guid? EquityGUID)
        {
            EquityDataContract _equityDC = new EquityDataContract();
            try
            {

                DataTable dt = new DataTable();
                //TotalCount = 0;
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@EquityGUID", Value = EquityGUID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetEquityByEquityID", sqlparam);
                if (dt != null && dt.Rows.Count > 0)
                {
                    _equityDC.EquityAccountID = Convert.ToString(dt.Rows[0]["AccountID"]);
                    _equityDC.EquityID = CommonHelper.ToInt32(dt.Rows[0]["EquityID"]);
                    _equityDC.EquityGUID = Convert.ToString(dt.Rows[0]["EquityGUID"]);
                    _equityDC.EquityName = Convert.ToString(dt.Rows[0]["EquityName"]);
                    _equityDC.OriginalEquityName = Convert.ToString(dt.Rows[0]["EquityName"]);
                    _equityDC.Status = CommonHelper.ToInt32(dt.Rows[0]["Status"]);
                    _equityDC.StatusText = Convert.ToString(dt.Rows[0]["StatusText"]);
                    _equityDC.Currency = CommonHelper.ToInt32(dt.Rows[0]["CurrencyID"]);
                    _equityDC.CurrencyText = Convert.ToString(dt.Rows[0]["CurrencyText"]);
                    _equityDC.EquityType = CommonHelper.ToInt32(dt.Rows[0]["EquityType"]);
                    _equityDC.EquityTypeText = Convert.ToString(dt.Rows[0]["EquityTypeText"]);
                    _equityDC.InvestorCapital = CommonHelper.ToDecimal(dt.Rows[0]["InvestorCapital"]);
                    _equityDC.CapitalReserveRequirement = CommonHelper.ToDecimal(dt.Rows[0]["CapitalReserveRequirement"]);
                    _equityDC.ReserveRequirement = CommonHelper.ToDecimal(dt.Rows[0]["ReserveRequirement"]);
                    _equityDC.CommittedCapital = CommonHelper.ToDecimal(dt.Rows[0]["CommittedCapital"]);
                    _equityDC.CapitalReserve = CommonHelper.ToDecimal(dt.Rows[0]["CapitalReserve"]);
                    _equityDC.UncommittedCapital = CommonHelper.ToDecimal(dt.Rows[0]["UncommittedCapital"]);
                    _equityDC.CapitalCallNoticeBusinessDays = CommonHelper.ToInt32(dt.Rows[0]["CapitalCallNoticeBusinessDays"]);
                    _equityDC.EarliestEquityArrival = CommonHelper.ToDateTime(dt.Rows[0]["EarliestEquityArrival"]);
                    _equityDC.InceptionDate = CommonHelper.ToDateTime(dt.Rows[0]["InceptionDate"]);
                    _equityDC.LastDatetoInvest = CommonHelper.ToDateTime(dt.Rows[0]["LastDatetoInvest"]);
                    _equityDC.FundBalanceexcludingReserves = CommonHelper.ToDecimal(dt.Rows[0]["FundBalanceexcludingReserves"]);
                    _equityDC.LinkedShortTermBorrowingFacilityID = CommonHelper.ToGuid(dt.Rows[0]["LinkedShortTermBorrowingFacility"]);
                    _equityDC.LinkedShortTermBorrowingFacilityText = Convert.ToString(dt.Rows[0]["LinkedShortTermBorrowingFacilityText"]);
                    _equityDC.CreatedBy = Convert.ToString(dt.Rows[0]["CreatedBy"]);
                    _equityDC.CreatedDate = CommonHelper.ToDateTime(dt.Rows[0]["CreatedDate"]);
                    _equityDC.UpdatedBy = Convert.ToString(dt.Rows[0]["UpdatedBy"]);
                    _equityDC.UpdatedDate = CommonHelper.ToDateTime(dt.Rows[0]["UpdatedDate"]);
                    _equityDC.EffectiveDate = CommonHelper.ToDateTime(dt.Rows[0]["EffectiveStartDate"]);
                    _equityDC.Commitment = CommonHelper.ToDecimal(dt.Rows[0]["Commitment"]);
                    _equityDC.InitialMaturityDate = CommonHelper.ToDateTime(dt.Rows[0]["InitialMaturityDate"]);
                    _equityDC.FundDelay = CommonHelper.ToInt32(dt.Rows[0]["FundDelay"]);
                    _equityDC.FundingDay = CommonHelper.ToInt32(dt.Rows[0]["FundingDay"]);

                    _equityDC.CalcAsOfDate = CommonHelper.ToDateTime(dt.Rows[0]["CalcAsOfDate"]);
                    _equityDC.CashAccountID = CommonHelper.ToGuid(dt.Rows[0]["CashAccountID"]);
                    _equityDC.CashAccountName = Convert.ToString(dt.Rows[0]["CashAccountName"]);
                    _equityDC.AbbreviationName = Convert.ToString(dt.Rows[0]["AbbreviationName"]);

                    _equityDC.StructureID = CommonHelper.ToInt32(dt.Rows[0]["StructureID"]);
                    _equityDC.StructureText = Convert.ToString(dt.Rows[0]["StructureText"]);
                    
                }
                return _equityDC;
            }
            catch (Exception ex)
            {
                throw new Exception("error in GetEquityByEquityID-equityrepository" + ex.Message);
            }
        }
        public List<SearchDataContract> GetAutosuggestDebtNameSubline(string serchKey)
        {
            DataTable dt = new DataTable();
            List<SearchDataContract> lstSearchDC = new List<SearchDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@SearchKey", Value = serchKey };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetLinkedShortTermBorrowingFacility", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                SearchDataContract _Searchdc = new SearchDataContract();
                _Searchdc.ValueID = Convert.ToString(dr["AccountID"]);
                _Searchdc.Valuekey = Convert.ToString(dr["Text"]);
                lstSearchDC.Add(_Searchdc);
            }

            return lstSearchDC;
        }
        public EquityDataContract GetEquityCalcInfoByEquityAccountID(Guid? EquityAccountID, Guid? UserID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            EquityDataContract equityData = new EquityDataContract();
            SqlParameter p1 = new SqlParameter { ParameterName = "@EquityAccountID", Value = EquityAccountID };
            //SqlParameter p2 = new SqlParameter { ParameterName = "@ScenarioId", Value = AnalysisID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p3 };
            dt = hp.ExecDataTable("dbo.usp_GetEquityCalcInfoByEquityAccountID", sqlparam);
            foreach (DataRow dr in dt.Rows)
            {
                equityData.UpdatedDate = CommonHelper.ToDateTime(dr["DateTime"]);
                equityData.StatusText = Convert.ToString(dr["StatusName"]);
                equityData.ErrorMessage = Convert.ToString(dr["ErrorMessage"]);
            }
            return equityData;
        }
        public DataTable GeDebtOrEquityCashflowExportData(string AccountId, string AnalysisId, string Type)
        {

            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AccountId", Value = AccountId };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisId", Value = AnalysisId };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Type", Value = Type };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dt = hp.ExecDataTable("dbo.usp_GetLiabilityCashflowExportData", sqlparam);

            }
            catch (Exception ex)
            {

                throw ex;
            }
            return dt;
        }

        public DataTable GetEquityCapitalContributionExportExcel(string AccountId)
        {

            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AccountId", Value = AccountId };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetDebtorEquityFundingExportExcel", sqlparam);

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }
        public DataTable GetCashflowExportDataDetail(string AccountId, string AnalysisId, string Type)
        {

            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AccountId", Value = AccountId };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisId", Value = AnalysisId };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Type", Value = Type };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dt = hp.ExecDataTable("dbo.usp_GetLiabilityCashflowExportDataDetail", sqlparam);

            }
            catch (Exception ex)
            {

                throw ex;
            }
            return dt;
        }

        public string GetFileNameforLiabilityCalcExcelBlob(string AccountId)
        {
            EquityDataContract eqDC = new EquityDataContract();

            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@AccountID", Value = AccountId };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetFileNameforLiabilityCalcExcelBlob", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                eqDC.FileName = Convert.ToString(dr["FileName"]);
            }
            return eqDC.FileName;
        }


        public List<CashAccountDataContract> GetCashAccount()
        {

            DataTable dt = new DataTable();
            List<CashAccountDataContract> lstCashAccount = new List<CashAccountDataContract>();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("dbo.usp_GetCashAccount");

                foreach (DataRow dr in dt.Rows)
                {
                    CashAccountDataContract cashDC = new CashAccountDataContract();
                    cashDC.CashAccountID = CommonHelper.ToGuid(dr["CashAccountID"]);
                    cashDC.CashAccountName = Convert.ToString(dr["CashAccountName"]);

                    lstCashAccount.Add(cashDC);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return lstCashAccount;
        }

        public EquityDataContract GetEquityByEquityName(string EquityName)
        {
            EquityDataContract _equityDC = new EquityDataContract();
            try
            {

                DataTable dt = new DataTable();
                //TotalCount = 0;
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@EquityName", Value = EquityName };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetEquityByEquityName", sqlparam);
                if (dt != null && dt.Rows.Count > 0)
                {
                    _equityDC.EquityAccountID = Convert.ToString(dt.Rows[0]["EquityAccountID"]);
                    _equityDC.EquityID = CommonHelper.ToInt32(dt.Rows[0]["EquityID"]);
                    _equityDC.EquityGUID = Convert.ToString(dt.Rows[0]["EquityGUID"]);
                    _equityDC.EquityName = Convert.ToString(dt.Rows[0]["EquityName"]);
                    _equityDC.LinkedShortTermBorrowingFacilityID = CommonHelper.ToGuid(dt.Rows[0]["LinkedShortTermBorrowingFacility"]);
                    _equityDC.LinkedShortTermBorrowingFacilityText = Convert.ToString(dt.Rows[0]["LinkedShortTermBorrowingFacilityText"]);
                    _equityDC.CashAccountID = CommonHelper.ToGuid(dt.Rows[0]["CashAccountID"]);
                }
                return _equityDC;
            }
            catch (Exception ex)
            {
                throw new Exception("error in GetEquityByEquityName-equityrepository" + ex.Message);
            }
        }

        public EquityDataContract InsertUpdateEquity_OnetimefromFile(Guid? userid, EquityDataContract _equityDC)
        {
            EquityDataContract EquityDebtdata = new EquityDataContract();
            Helper.Helper hp = new Helper.Helper();
            try
            {

                if (_equityDC.EquityID == null)
                    _equityDC.EquityID = 0;

                SqlParameter p1 = new SqlParameter { ParameterName = "@EquityID", Value = _equityDC.EquityID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AccountID", Value = _equityDC.EquityAccountID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@EquityName", Value = _equityDC.EquityName };
                SqlParameter p4 = new SqlParameter { ParameterName = "@EquityType", Value = _equityDC.EquityType };
                SqlParameter p5 = new SqlParameter { ParameterName = "@Status", Value = _equityDC.Status };
                SqlParameter p6 = new SqlParameter { ParameterName = "@Currency", Value = _equityDC.Currency };
                SqlParameter p7 = new SqlParameter { ParameterName = "@InvestorCapital", Value = _equityDC.InvestorCapital };
                SqlParameter p8 = new SqlParameter { ParameterName = "@CapitalReserveRequirement", Value = _equityDC.CapitalReserveRequirement };
                SqlParameter p9 = new SqlParameter { ParameterName = "@ReserveRequirement", Value = _equityDC.ReserveRequirement };
                SqlParameter p10 = new SqlParameter { ParameterName = "@CommittedCapital", Value = _equityDC.CommittedCapital };
                SqlParameter p11 = new SqlParameter { ParameterName = "@CapitalReserve", Value = _equityDC.CapitalReserve };
                SqlParameter p12 = new SqlParameter { ParameterName = "@UncommittedCapital", Value = _equityDC.UncommittedCapital };
                SqlParameter p13 = new SqlParameter { ParameterName = "@CapitalCallNoticeBusinessDays", Value = _equityDC.CapitalCallNoticeBusinessDays };
                SqlParameter p14 = new SqlParameter { ParameterName = "@EarliestEquityArrival", Value = _equityDC.EarliestEquityArrival };
                SqlParameter p15 = new SqlParameter { ParameterName = "@FundBalanceexcludingReserves", Value = _equityDC.FundBalanceexcludingReserves };
                SqlParameter p16 = new SqlParameter { ParameterName = "@LinkedShortTermBorrowingFacility", Value = _equityDC.LinkedShortTermBorrowingFacilityID };
                SqlParameter p17 = new SqlParameter { ParameterName = "@UserID", Value = userid };
                SqlParameter p18 = new SqlParameter { ParameterName = "@EquityAccountID", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter p19 = new SqlParameter { ParameterName = "@EquityGUID_Output", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter p20 = new SqlParameter { ParameterName = "@CashAccountID", Value = _equityDC.CashAccountID };
                SqlParameter p21 = new SqlParameter { ParameterName = "@AbbreviationName", Value = _equityDC.AbbreviationName };
                SqlParameter p22 = new SqlParameter { ParameterName = "@StructureID", Value = _equityDC.StructureID };



                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22};
                DataTable dt = hp.ExecDataTable("dbo.usp_InsertUpdateEquity_OnetimefromFile", sqlparam);

                EquityDebtdata.EquityAccountID = Convert.ToString(p18.Value);
                EquityDebtdata.EquityGUID = Convert.ToString(p19.Value);

                return EquityDebtdata;

            }
            catch (Exception ex)
            {
                throw new Exception("error in InsertUpdateEquity-equityrepository" + ex.Message);
            }

        }
    }
}
