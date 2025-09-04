using CRES.DAL.IRepository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using CRES.Utilities;

namespace CRES.DAL.Repository
{
    public class ServicingWatchListRepository : IServicingWatchListRepository
    {

        public void InsertUpdatedServicingWatchlistAccounting(List<ServicingWatchlistDataContract> ServicingWatchlistAccounting)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable AccountingData = new DataTable();
                AccountingData.Columns.Add("WLDealAccountingID");
                AccountingData.Columns.Add("DealID");
                AccountingData.Columns.Add("StartDate");
                AccountingData.Columns.Add("EndDate");
                AccountingData.Columns.Add("TypeID");
                AccountingData.Columns.Add("Comment");
                AccountingData.Columns.Add("UserID");
                AccountingData.Columns.Add("IsDeleted");
                

                if (ServicingWatchlistAccounting != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ServicingWatchlistAccounting);

                    foreach (DataRow dr in dt.Rows)
                    {
                        AccountingData.ImportRow(dr);
                    }
                }

                if (AccountingData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtable("usp_InsertUpdatedWLDealAccounting", AccountingData, "tbltype_WLDealAccounting");
                }
            }
            catch (Exception)
            {

                throw;
            }
        }

        public List<ServicingWatchlistDataContract> GetServicingWatchlistDealAccountingByDealID(string DealId)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            List<ServicingWatchlistDataContract> ListDataAccounting = new List<ServicingWatchlistDataContract>();

            SqlParameter p1 = new SqlParameter { ParameterName = "@DealId", Value = DealId };

            dt = hp.ExecDataTable("dbo.usp_GetWLDealAccountingByDealID", p1);
            foreach (DataRow dr in dt.Rows)
            {
                ServicingWatchlistDataContract swd = new ServicingWatchlistDataContract();
                swd.WLDealAccountingID = CommonHelper.ToInt32(dr["WLDealAccountingID"]);
                swd.DealID = Convert.ToString(dr["DealID"]);
                swd.StartDate = CommonHelper.ToDateTime(dr["StartDate"]);
                swd.EndDate = CommonHelper.ToDateTime(dr["EndDate"]);
                swd.TypeID = CommonHelper.ToInt32(dr["TypeID"]);
                swd.TypeText = Convert.ToString(dr["TypeText"]);
                swd.Comment = Convert.ToString(dr["Comment"]);
                swd.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                swd.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                swd.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                swd.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);

                ListDataAccounting.Add(swd);
            }

            return ListDataAccounting;

        }
        public void InsertWLDealLegalStatusFromAPI(List<ServicingWatchlistDataContract> ServicingWatchlistLegalStatus)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable LegalStatusData = new DataTable();
                LegalStatusData.Columns.Add("CREDealID");                 
                LegalStatusData.Columns.Add("StartDate");              
                LegalStatusData.Columns.Add("Type");
                LegalStatusData.Columns.Add("Comment");
                LegalStatusData.Columns.Add("ReasonCode");                
                LegalStatusData.Columns.Add("UserID");               

                if (ServicingWatchlistLegalStatus != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ServicingWatchlistLegalStatus);

                    foreach (DataRow dr in dt.Rows)
                    {
                        LegalStatusData.ImportRow(dr);
                    }
                }

                if (LegalStatusData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtable("usp_InsertWLDealLegalStatus", LegalStatusData, "tbltype_WLDealLegalStatus");
                }
            }
            catch (Exception)
            {

                throw;
            }
        }

        public List<ServicingWatchlistDataContract> GetServicingWatchlistDealLegalStatusByDealID(string DealId)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            List<ServicingWatchlistDataContract> ListDataLegalStatus = new List<ServicingWatchlistDataContract>();

            SqlParameter p1 = new SqlParameter { ParameterName = "@DealId", Value = DealId };

            dt = hp.ExecDataTable("dbo.usp_GetWLDealLegalStatusByDealID", p1);
            foreach (DataRow dr in dt.Rows)
            {
                ServicingWatchlistDataContract swd = new ServicingWatchlistDataContract();
                swd.WLDealLegalStatusID = CommonHelper.ToInt32(dr["WLDealLegalStatusID"]);
                swd.DealID = Convert.ToString(dr["DealID"]);
                swd.StartDate = CommonHelper.ToDateTime(dr["StartDate"]);                          
                swd.TypeText = Convert.ToString(dr["Type"]);
                swd.Comment = Convert.ToString(dr["Comment"]);
                swd.ReasonCode = Convert.ToString(dr["ReasonCode"]);                
                swd.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                swd.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                swd.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                swd.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);

                ListDataLegalStatus.Add(swd);
            }

            return ListDataLegalStatus;

        }
                
        public DataTable InsertUpdatedServicingWatchlistPotentialImpairment(DataTable dtPotentialImpairmentData, string UserID)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@tbltype_WLDealPotentialImpairment", Value = dtPotentialImpairmentData };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_InsertUpdatedWLDealPotentialImpairment", sqlparam);

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }

        public List<ServicingWatchlistDataContract> GetServicingWatchlistDealPotentialImpairmentByDealID(string DealId)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            List<ServicingWatchlistDataContract> ListPotentialImpairment = new List<ServicingWatchlistDataContract>();

            SqlParameter p1 = new SqlParameter { ParameterName = "@DealId", Value = DealId };
            dt = hp.ExecDataTable("dbo.usp_GetWLDealPotentialImpairmentByDealID", p1);
            foreach (DataRow dr in dt.Rows)
            {
                ServicingWatchlistDataContract swd = new ServicingWatchlistDataContract();
                swd.WLDealPotentialImpairmentID = CommonHelper.ToInt32(dr["WLDealPotentialImpairmentID"]);
                swd.DealID = Convert.ToString(dr["DealID"]);
                swd.EffectiveDate = CommonHelper.ToDateTime(dr["EffectiveDate"]);
                swd.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                swd.Comment = Convert.ToString(dr["Comment"]);
                swd.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                swd.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                swd.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                swd.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);

                ListPotentialImpairment.Add(swd);
            }

            return ListPotentialImpairment;

        }


        public DataTable GetDealPotentialImpairmentByDealID(Guid? DealID, Guid? UserID)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("usp_GetWLDealPotentialImpairmentByDealID", sqlparam);

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }

        public void DeleteServicingWatchlistPotentialImpairment(DataTable dtPotentialImpairmentData, string UserID)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@tbltype_WLDealPotentialImpairment", Value = dtPotentialImpairmentData };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_DeleteWLDealPotentialImpairment", sqlparam);

            }
            catch (Exception ex)
            {
                var exception = ex.Message;
            }
        }
    }
}
