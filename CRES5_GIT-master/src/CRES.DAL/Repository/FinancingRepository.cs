using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CRES.DataContract;
using CRES.DAL.IRepository;
using System.Data;
using System.Data.SqlClient;
using CRES.Utilities;

namespace CRES.DAL.Repository
{
    public class FinancingRepository : IFinancingRepository
    {


        public List<FinancingWarehouseDataContract> GetFinancingWarehouse(Guid? userid, int? PageSize, int? PageIndex, out int? TotalCount)
        {
            //  ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            List<FinancingWarehouseDataContract> lstFinancingWarehouseDC = new List<FinancingWarehouseDataContract>();

            DataTable dt = new DataTable();
            
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PageIndex", Value = PageIndex };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageSize", Value = PageSize };
            SqlParameter p4 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = 20 };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            dt = hp.ExecDataTable("dbo.usp_GetAllFinancingWarehouse", sqlparam);

            //var lstFinancingResult = _dbContext.usp_GetAllFinancingWarehouse(userid, PageIndex, PageSize, totalCount);
            //var lstFinancing = lstFinancingResult.ToList();
            TotalCount = string.IsNullOrEmpty(Convert.ToString(p4.Value)) ? 0 : Convert.ToInt32(p4.Value);
            foreach (DataRow dr in dt.Rows)
            {
                FinancingWarehouseDataContract _FinancingWarehouseDC = new FinancingWarehouseDataContract();
                if (Convert.ToString(dr["FinancingWarehouseID"]) != "")
                {
                    _FinancingWarehouseDC.FinancingWarehouseID = new Guid(Convert.ToString(dr["FinancingWarehouseID"]));
                }
                if (Convert.ToString(dr["Account_AccountID"]) != "")
                {
                    _FinancingWarehouseDC.AccountID = new Guid(Convert.ToString(dr["Account_AccountID"]));
                }
                _FinancingWarehouseDC.Name = Convert.ToString(dr["Name"]);
                _FinancingWarehouseDC.StatusID = CommonHelper.ToInt32(dr["StatusID"]);
                _FinancingWarehouseDC.StatusIDText = Convert.ToString(dr["StatusIDText"]);
                _FinancingWarehouseDC.IsRevolving = CommonHelper.ToInt32(dr["IsRevolving"]);
                _FinancingWarehouseDC.IsRevolvingText = Convert.ToString(dr["IsRevolvingText"]);
                _FinancingWarehouseDC.BaseCurrencyID = CommonHelper.ToInt32(dr["BaseCurrencyID"]);
                _FinancingWarehouseDC.BaseCurrencyIDText = Convert.ToString(dr["BaseCurrencyIDText"]);
                _FinancingWarehouseDC.OriginationFee = CommonHelper.ToDecimal(dr["OriginationFee"]);
                _FinancingWarehouseDC.TotalConstraint = CommonHelper.ToDecimal(dr["TotalConstraint"]);
                _FinancingWarehouseDC.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                _FinancingWarehouseDC.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                _FinancingWarehouseDC.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                _FinancingWarehouseDC.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);

                lstFinancingWarehouseDC.Add(_FinancingWarehouseDC);
            }

            return lstFinancingWarehouseDC;
        }

        public string AddUpdateFinancingWarehouse(FinancingWarehouseDataContract _financingWarehouseDc)
        {
            int result = 0;
            string NewFinancingWhouseid = "";
            //   ObjectParameter NewFinancingWarehouseid = new ObjectParameter("NewFinancingWarehouseid", typeof(string));
            if (_financingWarehouseDc.FinancingWarehouseID == null)
            {
                _financingWarehouseDc.FinancingWarehouseID = new Guid("00000000-0000-0000-0000-000000000000");
                _financingWarehouseDc.AccountID = new Guid("00000000-0000-0000-0000-000000000000");
            }


            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@FinancingWarehouseid", Value = _financingWarehouseDc.FinancingWarehouseID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@AccountId", Value = _financingWarehouseDc.AccountID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@Name", Value = _financingWarehouseDc.Name };
            SqlParameter p4 = new SqlParameter { ParameterName = "@StatusId", Value = _financingWarehouseDc.StatusID };
            SqlParameter p5 = new SqlParameter { ParameterName = "@BaseCurrency", Value = _financingWarehouseDc.BaseCurrencyID };
            SqlParameter p6 = new SqlParameter { ParameterName = "@PayFrequency", Value = _financingWarehouseDc.PayFrequency };
            SqlParameter p7 = new SqlParameter { ParameterName = "@IsRevolvingId", Value = _financingWarehouseDc.IsRevolving };
            SqlParameter p8 = new SqlParameter { ParameterName = "@OriginationFee", Value = _financingWarehouseDc.OriginationFee };
            SqlParameter p9 = new SqlParameter { ParameterName = "@TotalConstraint", Value = _financingWarehouseDc.TotalConstraint };
            SqlParameter p10 = new SqlParameter { ParameterName = "@CreatedBy", Value = _financingWarehouseDc.CreatedBy };
            SqlParameter p11 = new SqlParameter { ParameterName = "@CreatedDate", Value = _financingWarehouseDc.CreatedDate };
            SqlParameter p12 = new SqlParameter { ParameterName = "@UpdatedBy", Value = _financingWarehouseDc.UpdatedBy };
            SqlParameter p13 = new SqlParameter { ParameterName = "@UpdatedDate", Value = _financingWarehouseDc.UpdatedDate };
            SqlParameter p14 = new SqlParameter { ParameterName = "@NewFinancingWarehouseid", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14 };
            hp.ExecNonquery("dbo.usp_InsertUpdateFinancingWarehouse", sqlparam);


            //result = _dbContext.usp_InsertUpdateFinancingWarehouse(_financingWarehouseDc.FinancingWarehouseID,
            //    _financingWarehouseDc.AccountID,
            //    _financingWarehouseDc.Name,
            //    _financingWarehouseDc.StatusID,
            //     _financingWarehouseDc.BaseCurrencyID,
            //    _financingWarehouseDc.PayFrequency,
            //    _financingWarehouseDc.IsRevolving,
            //    _financingWarehouseDc.OriginationFee,
            //    _financingWarehouseDc.TotalConstraint,
            //    _financingWarehouseDc.CreatedBy,
            //    _financingWarehouseDc.CreatedDate,
            //    _financingWarehouseDc.UpdatedBy,
            //    _financingWarehouseDc.UpdatedDate,
            //    NewFinancingWarehouseid);
            NewFinancingWhouseid = Convert.ToString(p14.Value);
           // AddUpdateFinancingWarehouseDetails(_financingWarehouseDc.lstFinancingWarehouseDetail, NewFinancingWhouseid);
            return NewFinancingWhouseid;
        }


        public int AddUpdateFinancingWarehouseDetails(List<FinancingWarehouseDetailDataContract> lstfinancingWarehousedetailsDc,string headerUserID)
        {
            int result = 0;
            foreach (FinancingWarehouseDetailDataContract financingWarehousedetailsDc in lstfinancingWarehousedetailsDc)
            {

                if (financingWarehousedetailsDc.FinancingWarehouseID == null)
                    financingWarehousedetailsDc.FinancingWarehouseID = new Guid("00000000-0000-0000-0000-000000000000");
                
                if (financingWarehousedetailsDc.FinancingWarehouseDetailID == null)
                    financingWarehousedetailsDc.FinancingWarehouseDetailID = new Guid("00000000-0000-0000-0000-000000000000");


                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@FinancingWarehouseDetailID", Value = financingWarehousedetailsDc.FinancingWarehouseDetailID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@FinancingWarehouseID", Value = financingWarehousedetailsDc.FinancingWarehouseID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@StartDate", Value = financingWarehousedetailsDc.StartDate };
                SqlParameter p4 = new SqlParameter { ParameterName = "@EndDate", Value = financingWarehousedetailsDc.EndDate };
                SqlParameter p5 = new SqlParameter { ParameterName = "@Value", Value = financingWarehousedetailsDc.Value };
                SqlParameter p6 = new SqlParameter { ParameterName = "@CreatedBy", Value = headerUserID };
                SqlParameter p7 = new SqlParameter { ParameterName = "@CreatedDate", Value = financingWarehousedetailsDc.CreatedDate };
                SqlParameter p8 = new SqlParameter { ParameterName = "@UpdatedBy", Value = headerUserID };
                SqlParameter p9 = new SqlParameter { ParameterName = "@UpdatedDate", Value = financingWarehousedetailsDc.UpdatedDate };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9 };
                result = hp.ExecNonquery("dbo.usp_InsertUpdateFinancingWarehouseDetails", sqlparam);

                //     result = _dbContext.usp_InsertUpdateFinancingWarehouseDetails(
                //         financingWarehousedetailsDc.FinancingWarehouseDetailID,
                // financingWarehousedetailsDc.FinancingWarehouseID
                //, financingWarehousedetailsDc.StartDate
                //, financingWarehousedetailsDc.EndDate
                //, financingWarehousedetailsDc.Value
                //, financingWarehousedetailsDc.CreatedBy
                //, financingWarehousedetailsDc.CreatedDate
                //, financingWarehousedetailsDc.UpdatedBy
                //, financingWarehousedetailsDc.UpdatedDate);
                // }
            }
            return result;
        }


        public FinancingWarehouseDataContract GetFinancingWarehouseByid(string financingWarehouseID)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@FinancingWarehouseID", Value = financingWarehouseID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };

            dt = hp.ExecDataTable("dbo.usp_GetFinancingWarehouseById", sqlparam);
            // var resFinWhouse = _dbContext.usp_GetFinancingWarehouseById(financingWarehouseID).FirstOrDefault();
            FinancingWarehouseDataContract FinancingWarehousedc = new FinancingWarehouseDataContract();
            FinancingWarehousedc.lstFinancingWarehouseDetail = new List<FinancingWarehouseDetailDataContract>();
            List<FinancingWarehouseDetailDataContract> lstfinancingWarehouseDetails = new List<FinancingWarehouseDetailDataContract>();
            if (dt.Rows.Count > 0)
            {
                if (Convert.ToString(dt.Rows[0]["FinancingWarehouseID"]) != "")
                {
                    FinancingWarehousedc.FinancingWarehouseID = new Guid(Convert.ToString(dt.Rows[0]["FinancingWarehouseID"]));
                }
                if (Convert.ToString(dt.Rows[0]["Account_AccountID"]) != "")
                {
                    FinancingWarehousedc.AccountID = new Guid(Convert.ToString(dt.Rows[0]["Account_AccountID"]));
                }
                FinancingWarehousedc.Name = Convert.ToString(dt.Rows[0]["Name"]);
                FinancingWarehousedc.StatusID = CommonHelper.ToInt32(dt.Rows[0]["StatusID"]);
                FinancingWarehousedc.PayFrequency = CommonHelper.ToInt32(dt.Rows[0]["payfrequency"]);
                FinancingWarehousedc.StatusIDText = Convert.ToString(dt.Rows[0]["StatusIDText"]);
                FinancingWarehousedc.IsRevolving = CommonHelper.ToInt32(dt.Rows[0]["IsRevolving"]);
                FinancingWarehousedc.IsRevolvingText = Convert.ToString(dt.Rows[0]["IsRevolvingText"]);
                FinancingWarehousedc.BaseCurrencyID = CommonHelper.ToInt32(dt.Rows[0]["BaseCurrencyID"]);
                FinancingWarehousedc.BaseCurrencyIDText = Convert.ToString(dt.Rows[0]["BaseCurrencyIDText"]);
                FinancingWarehousedc.OriginationFee = CommonHelper.ToDecimal(dt.Rows[0]["OriginationFee"]);
                FinancingWarehousedc.TotalConstraint = CommonHelper.ToDecimal(dt.Rows[0]["TotalConstraint"]);
                FinancingWarehousedc.CreatedBy = Convert.ToString(dt.Rows[0]["CreatedBy"]);
                FinancingWarehousedc.UpdatedBy = Convert.ToString(dt.Rows[0]["UpdatedBy"]);
                FinancingWarehousedc.UpdatedDate = CommonHelper.ToDateTime(dt.Rows[0]["UpdatedDate"]);
            }

            DataTable dtFin = new DataTable();

            SqlParameter pf1 = new SqlParameter { ParameterName = "@FinancingWarehouseID", Value = financingWarehouseID };
            SqlParameter[] sqlparamf = new SqlParameter[] { pf1 };

            dtFin = hp.ExecDataTable("dbo.usp_GetFinancingWarehouseDetailById", sqlparamf);

            // var resFinWhouseDetails = _dbContext.usp_GetFinancingWarehouseDetailById(financingWarehouseID);
            if (dtFin.Rows.Count > 0)
            {
                foreach (DataRow dr in dtFin.Rows)
                {
                    FinancingWarehouseDetailDataContract finwhouDetail = new FinancingWarehouseDetailDataContract();
                    finwhouDetail.FinancingWarehouseDetailID =new Guid(Convert.ToString(dr["FinancingWarehouseDetailID"]));
                    finwhouDetail.FinancingWarehouseID = new Guid(Convert.ToString(dr["FinancingWarehouse_FinancingWarehouseID"]));
                    finwhouDetail.StartDate = CommonHelper.ToDateTime(dr["StartDate"]);
                    finwhouDetail.EndDate = CommonHelper.ToDateTime(dr["EndDate"]);
                    finwhouDetail.Value = CommonHelper.ToDecimal(dr["Value"]);
                    finwhouDetail.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    finwhouDetail.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    finwhouDetail.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    finwhouDetail.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                    lstfinancingWarehouseDetails.Add(finwhouDetail);
                    //FinancingWarehousedc.lstFinancingWarehouseDetail.Add(finwhouDetail);
                }
                FinancingWarehousedc.lstFinancingWarehouseDetail = lstfinancingWarehouseDetails;
            }
            return FinancingWarehousedc;
        }
    }
}
