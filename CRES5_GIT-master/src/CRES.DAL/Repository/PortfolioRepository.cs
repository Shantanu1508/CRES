using CRES.DAL.IRepository;
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
    public class PortfolioRepository: IPortfolioRepository
    {
       
        public int AddUpdateFortfolio(PortfolioDataContract portfolio)
        {
            // bool retValue = false;

            int Status = 0;
            //  ObjectParameter StatusOut = new ObjectParameter("Status", typeof(int));

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@PortfolioID", Value = portfolio.PortfolioMasterGuid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PortfoliName", Value = portfolio.PortfolioName };
            SqlParameter p3 = new SqlParameter { ParameterName = "@Description", Value = portfolio.Description };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PoolIDs", Value = portfolio.PoolIDs };
            SqlParameter p5 = new SqlParameter { ParameterName = "@ClientIDs", Value = portfolio.ClientIDs };
            SqlParameter p6 = new SqlParameter { ParameterName = "@FundIDs", Value = portfolio.FundIDs };
            SqlParameter p7 = new SqlParameter { ParameterName = "@UserID", Value = portfolio.CreatedBy };
            SqlParameter p8 = new SqlParameter { ParameterName = "@AllowWholeDeal", Value = portfolio.AllowWholeDeal };
            SqlParameter p9 = new SqlParameter { ParameterName = "@FinancingSourceIDs", Value = portfolio.FinancingSourceIDs };
            SqlParameter p10 = new SqlParameter { ParameterName = "@Status", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10 };
             hp.ExecuteScalar("Core.usp_AddUpdatePortfolio", sqlparam);

            //var res = dbContext.usp_AddUpdatePortfolio(
            //            portfolio.PortfolioMasterGuid,
            //            portfolio.PortfolioName,
            //            portfolio.Description,
            //            portfolio.PoolIDs,
            //            portfolio.ClientIDs,
            //            portfolio.FundIDs,
            //            portfolio.CreatedBy,
            //        StatusOut);
                Status = Convert.ToInt32(p10.Value);
                return Status;
        }

        public PortfolioDataContract GetPortfolioDetailByID(Guid? PortfolioID)
        {
            DataTable dt = new DataTable();
            PortfolioDataContract _portfolioDC = new PortfolioDataContract();

            //  DeailId = "790181DC-147A-4F55-82EB-0039BD0A9208";
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@PortfolioID", Value = PortfolioID };
            // var _portfolio = dbContext.usp_GetPortfolioDetailByID(PortfolioID).FirstOrDefault();
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("Core.usp_GetPortfolioDetailByID", sqlparam);
            if (dt != null && dt.Rows.Count>0)
                {
                if (Convert.ToString(dt.Rows[0]["PortfolioMasterGuid"]) != "")
                {
                    _portfolioDC.PortfolioMasterGuid = new Guid(Convert.ToString(dt.Rows[0]["PortfolioMasterGuid"]));
                }
                _portfolioDC.PortfolioMasterID = Convert.ToInt32(dt.Rows[0]["PortfolioMasterID"]);
                _portfolioDC.PortfolioName =Convert.ToString(dt.Rows[0]["PortfoliName"]);
                _portfolioDC.Description = Convert.ToString(dt.Rows[0]["Description"]);
                _portfolioDC.PoolIDs = Convert.ToString(dt.Rows[0]["PoolIDs"]);
                _portfolioDC.ClientIDs = Convert.ToString(dt.Rows[0]["ClientIDs"]);
                _portfolioDC.FundIDs = Convert.ToString(dt.Rows[0]["FundIDs"]);
                _portfolioDC.CreatedBy = Convert.ToString(dt.Rows[0]["CreatedBy"]);
                _portfolioDC.UpdatedBy = Convert.ToString(dt.Rows[0]["UpdatedBy"]);
                _portfolioDC.AllowWholeDeal = CommonHelper.ToBoolean(dt.Rows[0]["AllowWholeDeal"]);
                _portfolioDC.FinancingSourceIDs = Convert.ToString(dt.Rows[0]["FinancingSourceIDs"]);
            }
            return _portfolioDC;
        }

        public List<PortfolioDataContract> GetAllPortfolio(string userid, int pageIndex, int pageSize, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            List<PortfolioDataContract> list = new List<PortfolioDataContract>();
            Guid userId = new Guid(userid);
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p4 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            dt = hp.ExecDataTable("Core.usp_GetAllPortfolio", sqlparam);

            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
           // var lstportfolio = dbContext.usp_GetAllPortfolio(userId, pageIndex, pageSize, totalCount).ToList();
            
            TotalCount = string.IsNullOrEmpty(Convert.ToString(p4.Value)) ? 0 : Convert.ToInt32(p4.Value);

            foreach (DataRow dr in dt.Rows)
            {
                PortfolioDataContract portfolioDC = new PortfolioDataContract();
                portfolioDC.PortfolioMasterID = Convert.ToInt32(dr["PortfolioMasterID"]);
                    if (Convert.ToString(dr["PortfolioMasterGuid"]) != "")
                {
                    portfolioDC.PortfolioMasterGuid = new Guid(Convert.ToString(dr["PortfolioMasterGuid"]));
                }
                portfolioDC.PortfolioName = Convert.ToString(dr["PortfoliName"]);
                portfolioDC.Description = Convert.ToString(dr["Description"]);
                portfolioDC.AllowWholeDeal = CommonHelper.ToBoolean(dr["AllowWholeDeal"]);
                portfolioDC.AllowWholeDealText = Convert.ToString(dr["AllowWholeDealText"]);
                list.Add(portfolioDC);
            }

            return list;
        }
    }
}
