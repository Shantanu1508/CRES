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
    public class ExceptionsRespository : IExceptionsRespository
    {


        public void InsertExceptions(List<ExceptionDataContract> exlist, string username)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dNxceptions = new DataTable();
                dNxceptions.Columns.Add("ObjectID");
                dNxceptions.Columns.Add("ObjectTypeText");
                dNxceptions.Columns.Add("FieldName");
                dNxceptions.Columns.Add("Summary");
                dNxceptions.Columns.Add("ActionLevelText");
                if (exlist != null)
                {
                    DataTable dt = new DataTable();
                    dt = ObjToDataTable.ToDataTable(exlist);
                    foreach (DataRow dr in dt.Rows)
                    {
                        dNxceptions.ImportRow(dr);
                    }
                }
                if (dNxceptions.Rows.Count > 0)
                {
                    hp.BatchUpdateOrInsert("dbo.usp_InsertUpdateExceptions", dNxceptions, username, "TableTypeExceptions");
                }
            }
            catch (Exception ex)
            {
                throw new Exception("error in  ExceptionsRespository in InsertExceptions" + ExceptionHelper.GetFullMessage(ex));
            }
        }

        public void InsertExceptionsByFieldName(List<ExceptionDataContract> exlist, string username, string FieldName)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dNxceptions = new DataTable();
                dNxceptions.Columns.Add("ObjectID");
                dNxceptions.Columns.Add("ObjectTypeText");
                dNxceptions.Columns.Add("FieldName");
                dNxceptions.Columns.Add("Summary");
                dNxceptions.Columns.Add("ActionLevelText");
                if (exlist != null)
                {
                    DataTable dt = new DataTable();
                    dt = ObjToDataTable.ToDataTable(exlist);
                    foreach (DataRow dr in dt.Rows)
                    {
                        dNxceptions.ImportRow(dr);
                    }
                }
                if (dNxceptions.Rows.Count > 0)
                {
                    hp.BatchUpdateOrInsertException("dbo.usp_InsertExceptionsByFieldName", dNxceptions, username, "TableTypeExceptions", FieldName);
                }
            }
            catch (Exception ex)
            {
                throw new Exception("error in  ExceptionsRespository in InsertExceptionsByFieldName" + ExceptionHelper.GetFullMessage(ex));
            }
        }

        //

        public List<ExceptionDataContract> GetNoteExceptionsList(string objectid, string name)
        {
            DataTable dt = new DataTable();
            List<ExceptionDataContract> lstExceptions = new List<ExceptionDataContract>();
            Guid id = new Guid(objectid);
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectID", Value = id };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ObjectName", Value = name };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetExceptionsByObjectID", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                ExceptionDataContract _ExceptionDataContract = new ExceptionDataContract();
                if (Convert.ToString(dr["ObjectID"]) != "")
                {
                    _ExceptionDataContract.ObjectID = new Guid(Convert.ToString(dr["ObjectID"]));
                }
                _ExceptionDataContract.Name = Convert.ToString(dr["Name"]);
                _ExceptionDataContract.CREID = Convert.ToString(dr["CRENoteID"]);
                _ExceptionDataContract.ObjectTypeID = Convert.ToInt32(dr["ObjectTypeID"]);
                _ExceptionDataContract.FieldName = Convert.ToString(dr["FieldName"]);
                _ExceptionDataContract.Summary = Convert.ToString(dr["Summary"]);
                _ExceptionDataContract.ActionLevelText = Convert.ToString(dr["ActionLevelText"]);
                _ExceptionDataContract.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                _ExceptionDataContract.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                _ExceptionDataContract.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                _ExceptionDataContract.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);

                lstExceptions.Add(_ExceptionDataContract);
            }
            return lstExceptions;
            ;
        }

        public void DeleteExceptionByobjectByFieldName(string objectid, string objecttype,string fieldname)
        {
            Guid id = new Guid(objectid);
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectID", Value = id };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ObjectName", Value = objecttype };
            SqlParameter p3 = new SqlParameter { ParameterName = "@FieldName", Value = fieldname };            

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3 };
            hp.ExecNonquery("dbo.usp_DeleteExceptionByobjectIDByFieldName", sqlparam);

        }

        
        public void DeleteExceptionByobject(string objectid, string objecttype)
        {
            Guid id = new Guid(objectid);
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectID", Value = id };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ObjectName", Value = objecttype };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecNonquery("dbo.usp_DeleteExceptionByobjectID", sqlparam);
        }

        public List<ExceptionDataContract> GetAllExceptionsList(string name, int? PageSize, int? PageIndex, out int? TotalCount)
        {
            List<ExceptionDataContract> lstExceptions = new List<ExceptionDataContract>();
            //ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            DataTable dt = new DataTable();

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectName", Value = name };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PgeIndex", Value = PageIndex };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageSize", Value = PageSize };
            SqlParameter p4 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            dt = hp.ExecDataTable("dbo.usp_GetAllExceptionsByObjectName", sqlparam);

            TotalCount = string.IsNullOrEmpty(Convert.ToString(p4.Value)) ? 0 : Convert.ToInt32(p4.Value);
            foreach (DataRow dr in dt.Rows)
            {
                ExceptionDataContract _ExceptionDataContract = new ExceptionDataContract();
                if (Convert.ToString(dr["ObjectID"]) != "")
                {
                    _ExceptionDataContract.ObjectID = new Guid(Convert.ToString(dr["ObjectID"]));
                }
                _ExceptionDataContract.Name = Convert.ToString(dr["Name"]);
                _ExceptionDataContract.CREID = Convert.ToString(dr["CRENoteID"]);
                _ExceptionDataContract.Summary = Convert.ToString(dr["Summary"]);
                _ExceptionDataContract.ActionLevelText = Convert.ToString(dr["ActionLevelText"]);
                _ExceptionDataContract.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                _ExceptionDataContract.DealName = Convert.ToString(dr["DealName"]);
                if (Convert.ToString(dr["DealID"]) != "")
                {
                    _ExceptionDataContract.DealID = new Guid(Convert.ToString(dr["DealID"]));
                }
                _ExceptionDataContract.CREDealID = Convert.ToString(dr["CREDealID"]);

                lstExceptions.Add(_ExceptionDataContract);
            }

            return lstExceptions;
        }
    }
}