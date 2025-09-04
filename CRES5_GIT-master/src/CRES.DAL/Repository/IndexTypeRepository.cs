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
    public class IndexTypeRepository
    {
        public DataTable getIndextypeByDate(IndexTypeDataContract indexTypeDC)
        {

            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@StartDate", Value = indexTypeDC.StartDate };

                SqlParameter p2 = new SqlParameter { ParameterName = "@EndDate", Value = indexTypeDC.EndDate };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetIndexByDates", sqlparam);
            }
            catch (Exception ex)
            {

            }

            return dt;
        }


        public int AddUpdateIndexes(DataTable dtIndexTypes, string CreatedBy, string UpdatedBy)
        {
            Helper.Helper hp = new Helper.Helper();
            return hp.ExecuteDatatable("dbo.usp_InsertUpdateIndexes", "tblindexes", dtIndexTypes, CreatedBy, UpdatedBy);
        }

        public int AddUpdateIndexList(DataTable dtIndexTypes, string CreatedBy, string UpdatedBy)
        {
            Helper.Helper hp = new Helper.Helper();
            return hp.ExecuteDatatable("dbo.usp_InsertUpdateIndexList", "tblindexes", dtIndexTypes, CreatedBy, UpdatedBy);
        }

        public List<IndexesMasterDataContract> GetIndexesFromIndexesMaster()
        {

            try
            {
                DataTable dt = new DataTable();
                List<IndexesMasterDataContract> lst_index = new List<IndexesMasterDataContract>();
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("dbo.usp_GetIndexesFromIndexesMaster");
                //  var res = _dbContext.usp_GetIndexesFromIndexesMaster();

                foreach (DataRow dr in dt.Rows)
                {
                    IndexesMasterDataContract indexdc = new IndexesMasterDataContract();
                    indexdc.IndexesMasterID = CommonHelper.ToInt32(dr["IndexesMasterID"]);
                    if (Convert.ToString(dr["IndexesMasterGuid"]) != "")
                    {
                        indexdc.IndexesMasterGuid = new Guid(Convert.ToString(dr["IndexesMasterGuid"]));
                    }
                    indexdc.IndexesName = Convert.ToString(dr["IndexesName"]);
                    indexdc.Description = Convert.ToString(dr["Description"]);
                    indexdc.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    indexdc.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    indexdc.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    indexdc.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);

                    lst_index.Add(indexdc);
                }


                return lst_index;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public IndexesMasterDataContract GetIndexesMasterDetailByIndexesMaster(Guid indexesMasterGuid, string UserID)
        {

            try
            {
                DataTable dt = new DataTable();
                IndexesMasterDataContract indexdc = new IndexesMasterDataContract();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@IndexesMasterGuid", Value = indexesMasterGuid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetIndexesMasterDetailByIndexesMaster", sqlparam);
                //var res = _dbContext.usp_GetIndexesMasterDetailByIndexesMaster(indexesMasterGuid, UserID).FirstOrDefault();
                if (dt != null && dt.Rows.Count > 0)
                {
                    indexdc.IndexesMasterID = CommonHelper.ToInt32(dt.Rows[0]["IndexesMasterID"]);
                    if (Convert.ToString(dt.Rows[0]["IndexesMasterGuid"]) != "")
                    {
                        indexdc.IndexesMasterGuid = new Guid(Convert.ToString(dt.Rows[0]["IndexesMasterGuid"]));
                    }
                    indexdc.IndexesName = Convert.ToString(dt.Rows[0]["IndexesName"]);
                    indexdc.Description = Convert.ToString(dt.Rows[0]["Description"]);
                    indexdc.CreatedBy = Convert.ToString(dt.Rows[0]["CreatedBy"]);
                    indexdc.CreatedDate = CommonHelper.ToDateTime(dt.Rows[0]["CreatedDate"]);
                    indexdc.UpdatedBy = Convert.ToString(dt.Rows[0]["UpdatedBy"]);
                    indexdc.UpdatedDate = CommonHelper.ToDateTime(dt.Rows[0]["UpdatedDate"]);
                    indexdc.Status = CommonHelper.ToInt32(dt.Rows[0]["Status"]);
                    indexdc.StatusText = Convert.ToString(dt.Rows[0]["StatusText"]);
                    indexdc.IsAssignedToScenario = CommonHelper.ToBoolean(dt.Rows[0]["IsAssignedToScenario"]);
                    indexdc.ScenarioList = Convert.ToString(dt.Rows[0]["ScenarioList"]);

                }
                return indexdc;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public string InsertUpdateIndexesMasterDetail(IndexesMasterDataContract _indexesMasterDC)
        {
            string NewIndexesMasterGuid;
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@IndexesMasterGuid", Value = _indexesMasterDC.IndexesMasterGuid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@IndexesMasterID", Value = _indexesMasterDC.IndexesMasterID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@IndexesName", Value = _indexesMasterDC.IndexesName };
            SqlParameter p4 = new SqlParameter { ParameterName = "@Description", Value = _indexesMasterDC.Description };
            SqlParameter p5 = new SqlParameter { ParameterName = "@CreatedBy", Value = _indexesMasterDC.CreatedBy };
            SqlParameter p6 = new SqlParameter { ParameterName = "@CreatedDate", Value = _indexesMasterDC.CreatedDate };
            SqlParameter p7 = new SqlParameter { ParameterName = "@UpdatedBy", Value = _indexesMasterDC.UpdatedBy };
            SqlParameter p8 = new SqlParameter { ParameterName = "@UpdatedDate", Value = _indexesMasterDC.UpdatedDate };
            SqlParameter p9 = new SqlParameter { ParameterName = "@newIndexesMasterGuid", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter p10 = new SqlParameter { ParameterName = "@Status", Value = _indexesMasterDC.Status }; 
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10 };
            hp.ExecNonquery("dbo.usp_SaveIndexesMasterDetail", sqlparam);
            //  ObjectParameter newIndexesMasterGuid = new ObjectParameter("newIndexesMasterGuid", typeof(string));

            // var res = _dbContext.usp_SaveIndexesMasterDetail(_indexesMasterDC.@IndexesMasterGuid.ToString(),
            //_indexesMasterDC.IndexesMasterID,
            //_indexesMasterDC.IndexesName,
            //_indexesMasterDC.Description,
            //_indexesMasterDC.CreatedBy,
            //_indexesMasterDC.CreatedDate,
            //_indexesMasterDC.UpdatedBy,
            //_indexesMasterDC.UpdatedDate,
            // newIndexesMasterGuid);

            NewIndexesMasterGuid = Convert.ToString(p9.Value);

            //=================

            //if (res == 1)
            if (!string.IsNullOrEmpty(NewIndexesMasterGuid))
                return NewIndexesMasterGuid;
            else
                return "FALSE";
            //return res;
        }

        public List<IndexesMasterDataContract> GetAllIndexesMaster(Guid? userId, int? PageSize, int? PageIndex, out int? TotalCount)
        {
            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            DataTable dt = new DataTable();
            List<IndexesMasterDataContract> lstIndexMasterDC = new List<IndexesMasterDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PgeIndex", Value = PageIndex };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageSize", Value = PageSize };
            SqlParameter p4 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            dt = hp.ExecDataTable("dbo.usp_GetAllIndexesMaster", sqlparam);

            //var lstIndexMaster = _dbContext.usp_GetAllIndexesMaster(userId, PageIndex, PageSize, totalCount).ToList();
            TotalCount = string.IsNullOrEmpty(Convert.ToString(p4.Value)) ? 0 : Convert.ToInt32(p4.Value);

            foreach (DataRow dr in dt.Rows)
            {
                IndexesMasterDataContract _indexDC = new IndexesMasterDataContract();

                _indexDC.IndexesMasterID = CommonHelper.ToInt32(dr["IndexesMasterID"]);
                if (Convert.ToString(dr["IndexesMasterGuid"]) != "")
                {
                    _indexDC.IndexesMasterGuid = new Guid(Convert.ToString(dr["IndexesMasterGuid"]));
                }
                _indexDC.IndexesName = Convert.ToString(dr["IndexesName"]);
                _indexDC.Description = Convert.ToString(dr["Description"]);
                _indexDC.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                _indexDC.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                _indexDC.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                _indexDC.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                _indexDC.StatusText = Convert.ToString(dr["StatusText"]);

                lstIndexMasterDC.Add(_indexDC);
            }
            return lstIndexMasterDC;
        }

        public bool CheckDuplicateIndexesName(string indexesMasterGuid, string indexesName)
        {
            DataTable dt = new DataTable();
            Guid _indexesMasterGuid = new Guid(indexesMasterGuid);
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@IndexesMasterGuid", Value = indexesMasterGuid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@IndexesName", Value = indexesName };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            //var res = hp.ExecNonquery("dbo.usp_CheckDuplicateIndexesName", sqlparam);
            var res = hp.ExecuteScalar("dbo.usp_CheckDuplicateIndexesName", sqlparam);
            // var res = _dbContext.usp_CheckDuplicateIndexesName(_indexesMasterGuid, indexesName).FirstOrDefault();
            return Convert.ToBoolean(res);
        }


        public DataTable GetIndexesExportDataByIndexesMasterID(IndexesMasterSearchDataContract _indexesMasterDC, string headerUserID, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            DataTable newdt = new DataTable();
            int tcount = 0;
            //  ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(headerUserID) };
                SqlParameter p2 = new SqlParameter { ParameterName = "@IndexesMasterGuid", Value = _indexesMasterDC.IndexesMasterGuid };
                SqlParameter p3 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dt = hp.ExecDataTable("dbo.usp_GetIndexesExportDataByIndexesMasterID", sqlparam);

                tcount = string.IsNullOrEmpty(Convert.ToString(p3.Value)) ? 0 : Convert.ToInt32(p3.Value);
            }
            catch (Exception ex)
            {
            }
            TotalCount = tcount;
            if (dt.Rows.Count == 1)
                return newdt;
            else
                return dt;

        }

        public DataTable GetIndexListByIndexesMasterID(string headerUserID, string indexesMasterGuid, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            int tcount = 0;
            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(headerUserID) };
                SqlParameter p2 = new SqlParameter { ParameterName = "@IndexesMasterGuid", Value = new Guid(indexesMasterGuid) };
                SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
                SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
                SqlParameter p5 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
                dt = hp.ExecDataTable("dbo.usp_GetIndexListByIndexesMasterID", sqlparam);
                if (dt.Rows.Count == 0)
                {
                    dt.Rows.Add();
                    dt.Rows[0][0] = DateTime.Now.ToShortDateString();
                    for (int i = 1; i < dt.Columns.Count; i++)
                    {
                        dt.Rows[0][i] = "";
                    }
                }

                tcount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            }
            catch (Exception ex)
            {
            }
            TotalCount = tcount;
            return dt;
        }

        public DataTable GetIndexListByDates(IndexesMasterSearchDataContract _indexesMasterSearchDC, string headerUserID, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            DataTable newdt = new DataTable();
            int tcount = 0;
            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(headerUserID) };
                SqlParameter p2 = new SqlParameter { ParameterName = "@IndexesMasterGuid", Value = _indexesMasterSearchDC.IndexesMasterGuid };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Fromdate", Value = _indexesMasterSearchDC.Fromdate };
                SqlParameter p4 = new SqlParameter { ParameterName = "@Todate", Value = _indexesMasterSearchDC.Todate };
                SqlParameter p5 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
                dt = hp.ExecDataTable("dbo.usp_GetIndexListByDates", sqlparam);

                tcount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);
            }
            catch (Exception ex)
            {
            }
            TotalCount = tcount;

            //if (dt.Rows.Count == 1)
            //    return newdt;
            //else

            return dt;
        }

        public void ImportIndexes(Guid? userId, IndexesMasterDataContract _indexesDC)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@IndexFrom", Value = _indexesDC.IndewxFromGuid };
            SqlParameter p3 = new SqlParameter { ParameterName = "@IndexTo", Value = _indexesDC.IndewxToGuid };
            SqlParameter p4 = new SqlParameter { ParameterName = "@IndexesName", Value = _indexesDC.IndexesName };
            SqlParameter p5 = new SqlParameter { ParameterName = "@Description", Value = _indexesDC.Description };
            SqlParameter p6 = new SqlParameter { ParameterName = "@ImportType", Value = _indexesDC.ImportType };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };
            hp.ExecNonquery("dbo.usp_ImportIndexes", sqlparam);

            // _dbContext.usp_ImportIndexes(userId, _indexesDC.IndewxFromGuid, _indexesDC.IndewxToGuid, _indexesDC.IndexesName, _indexesDC.Description, _indexesDC.ImportType);
        }
        public int InsertIndexTypeOutputJsonInfo(string IndexName, DataTable dtjsonresult, Guid? UserID)
        {
            dtjsonresult.Columns["Benchmark _Date"].ColumnName = "Date";
            dtjsonresult.Columns["USD_ICE_LIBOR"].ColumnName = "Value";
            dtjsonresult.Columns["Type"].ColumnName = "Name";
            dtjsonresult.AcceptChanges();
            Helper.Helper hp = new Helper.Helper();
            hp.ExecDataTablewithtableforjson("dbo.usp_InsertIndexTypeOutputJsonInfo", "indextypelist", dtjsonresult, IndexName, UserID);

            return 1;
        }

        public DataTable InsertUpdateMissingIndexList(string IndexesMasterGuid, int IndexTypeID, string username)
        {
            try
            {
                DataTable dt = new DataTable();
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@IndexesMasterGuid", Value = new Guid(IndexesMasterGuid) };
                SqlParameter p2 = new SqlParameter { ParameterName = "@IndexTypeID", Value = IndexTypeID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = username };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dt = hp.ExecDataTable("dbo.usp_InsertUpdateMissingIndexList", sqlparam);

                return dt;
            }
            catch (Exception ex)
            {
                throw;
            }

        }
    }
}
