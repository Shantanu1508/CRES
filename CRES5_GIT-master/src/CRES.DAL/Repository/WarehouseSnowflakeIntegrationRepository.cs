using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Text;

namespace CRES.DAL.Repository
{
    public class WarehouseSnowflakeIntegrationRepository
    {
        public List<WarehouseSnowflakeDataContract> GetTableRowCountsforSourceDW(string SchemaNames, string TableNames)
        {
            List<WarehouseSnowflakeDataContract> Listdata = new List<WarehouseSnowflakeDataContract>();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@SchemaNames", Value = SchemaNames };
                SqlParameter p2 = new SqlParameter { ParameterName = "@TableNames", Value = TableNames };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetTableRowCountsforSourceDW", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    WarehouseSnowflakeDataContract data = new WarehouseSnowflakeDataContract();

                    data.TableName = Convert.ToString(dr["TableName"]);
                    data.SourceRowCount = CommonHelper.ToInt32(dr["SourceRowCount"]);
                    Listdata.Add(data);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Listdata;

        }

        public List<WarehouseSnowflakeDataContract> GetTableRowCountsBackshopSourceDW(string SchemaNames, string TableNames)
        {
            List<WarehouseSnowflakeDataContract> Listdata = new List<WarehouseSnowflakeDataContract>();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@SchemaNames", Value = SchemaNames };
                SqlParameter p2 = new SqlParameter { ParameterName = "@TableNames", Value = TableNames };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetTableRowCountsBackshopSourceDW", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    WarehouseSnowflakeDataContract data = new WarehouseSnowflakeDataContract();

                    data.TableName = Convert.ToString(dr["TableName"]);
                    data.SourceRowCount = CommonHelper.ToInt32(dr["SourceRowCount"]);
                    Listdata.Add(data);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Listdata;

        }

        public DataTable GetPrimaryColumnIDFromSource(string SourceName, string SchemaName, string TableName, string PrimaryColumn)
        {
            List<WarehouseSnowflakeDataContract> Listdata = new List<WarehouseSnowflakeDataContract>();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@SourceName", Value = SourceName };
                SqlParameter p2 = new SqlParameter { ParameterName = "@SchemaName", Value = SchemaName };
                SqlParameter p3 = new SqlParameter { ParameterName = "@TableName", Value = TableName };
                SqlParameter p4 = new SqlParameter { ParameterName = "@PrimaryColumn", Value = PrimaryColumn };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
                dt = hp.ExecDataTable("dbo.usp_GetPrimaryColumnIDFromSource", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;

        }

        public DataTable GetPrimaryColumnIDNamesFromSource(string SourceName, string TableName)
        {
            List<WarehouseSnowflakeDataContract> Listdata = new List<WarehouseSnowflakeDataContract>();
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@SourceName", Value = SourceName };
                SqlParameter p2 = new SqlParameter { ParameterName = "@TableName", Value = TableName };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetPrimaryColumnIDNamesFromSource", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;

        }
    }
}
