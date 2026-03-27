using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;
using CRES.DAL.IRepository;
using System.Data.SqlClient;
using System.Data;
using CRES.Utilities;

namespace CRES.DAL.Repository
{
   public class AccountingReportRepository: IAccountingReportRepository
   {
	

		public List<ReportFileDataContract> GetAllReportFiles(Guid? userId, int? pageSize, int? pageIndex, out int? TotalCount)
        {
            List<ReportFileDataContract> lstReportFiles = new List<ReportFileDataContract>();

            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p4 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = 10 };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            dt = hp.ExecDataTable("dbo.usp_GetAllReportFile", sqlparam);
            TotalCount = Convert.ToInt32(p4.Value);

            // var deals = dbContext.usp_GetAllDealsForTranscationsFilter();
            foreach (DataRow dr in dt.Rows)
            {
                ReportFileDataContract reportfiledc = new ReportFileDataContract();
                reportfiledc.ReportFileID = Convert.ToInt32(dr["ReportFileID"]);
                reportfiledc.ReportFileGUID = new Guid(dr["ReportFileGUID"].ToString());
                reportfiledc.ReportFileName = Convert.ToString(dr["ReportFileName"]);
                //reportfiledc.SheetName = Convert.ToString(dr["SheetName"]);
                //reportfiledc.DataSourceProcedure = Convert.ToString(dr["DataSourceProcedure"]);
                reportfiledc.ReportFileFormat = Convert.ToString(dr["ReportFileFormat"]);
                reportfiledc.ReportFileTemplate = Convert.ToString(dr["ReportFileTemplate"]);
                reportfiledc.ReportFileJSON = Convert.ToString(dr["ReportFileJSON"]);
                //reportfiledc.HeaderPosition = Convert.ToInt32(dr["HeaderPosition"]);
                reportfiledc.SourceStorageTypeID = Convert.ToInt32(dr["SourceStorageTypeID"]);
                reportfiledc.SourceStorageLocation = Convert.ToString(dr["SourceStorageLocation"]);
                reportfiledc.DestinationStorageTypeID = Convert.ToInt32(dr["DestinationStorageTypeID"]);
                reportfiledc.DestinationStorageLocation = Convert.ToString(dr["DestinationStorageLocation"]);
                reportfiledc.Status = Convert.ToInt32(dr["Status"]);
                reportfiledc.Frequency = Convert.ToString(dr["Frequency"]);
                reportfiledc.FrequencyStatus = Convert.ToInt32(dr["FrequencyStatus"]);
                reportfiledc.DefaultAttributes = Convert.ToString(dr["DefaultAttributes"]);
                reportfiledc.IsAllowInput = Convert.ToBoolean(dr["IsAllowInput"]);
                lstReportFiles.Add(reportfiledc);
            }
            return lstReportFiles;
        }

        public ReportFileDataContract GetReportFileByGUID(Guid? ReportFileGUID, Guid? UserID)
        {
            ReportFileDataContract reportfiledc = new ReportFileDataContract();
            DataSet ds = new DataSet();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@ReportFileGUID", Value = ReportFileGUID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            ds = hp.ExecDataSet("dbo.usp_GetReportFileByGUID", sqlparam);
            // var deals = dbContext.usp_GetAllDealsForTranscationsFilter();
            if (ds != null && ds.Tables.Count > 0)
            {
                if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        reportfiledc.ReportFileID = Convert.ToInt32(dr["ReportFileID"]);
                        reportfiledc.ReportFileGUID = new Guid(dr["ReportFileGUID"].ToString());
                        reportfiledc.ReportFileName = Convert.ToString(dr["ReportFileName"]);
                        //reportfiledc.SheetName = Convert.ToString(dr["SheetName"]);
                        //reportfiledc.DataSourceProcedure = Convert.ToString(dr["DataSourceProcedure"]);
                        reportfiledc.ReportFileFormat = Convert.ToString(dr["ReportFileFormat"]);
                        reportfiledc.ReportFileTemplate = Convert.ToString(dr["ReportFileTemplate"]);
                        reportfiledc.ReportFileJSON = Convert.ToString(dr["ReportFileJSON"]);
                        // reportfiledc.HeaderPosition = Convert.ToInt32(dr["HeaderPosition"]);
                        reportfiledc.SourceStorageTypeID = Convert.ToInt32(dr["SourceStorageTypeID"]);
                        reportfiledc.SourceStorageLocation = Convert.ToString(dr["SourceStorageLocation"]);
                        reportfiledc.DestinationStorageTypeID = Convert.ToInt32(dr["DestinationStorageTypeID"]);
                        reportfiledc.DestinationStorageLocation = Convert.ToString(dr["DestinationStorageLocation"]);
                        reportfiledc.Status = Convert.ToInt32(dr["Status"]);
                        reportfiledc.Frequency = Convert.ToString(dr["Frequency"]);
                        reportfiledc.FrequencyStatus = Convert.ToInt32(dr["FrequencyStatus"]);
                        reportfiledc.DownloadFileName = Convert.ToString(dr["DownloadFileName"]);
                        
                        break;
                    }
                    if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                    {
                        foreach (DataRow dr1 in ds.Tables[1].Rows)
                        {
                            reportfiledc.lstReportFileSheet.Add(new ReportFileSheetDataContract()
                            {
                                ReportFileSheetID = Convert.ToInt32(dr1["ReportFileSheetID"]),
                                ReportFileID = Convert.ToInt32(dr1["ReportFileID"]),
                                SheetName = Convert.ToString(dr1["SheetName"]),
                                DataSourceProcedure = Convert.ToString(dr1["DataSourceProcedure"]),
                                HeaderPosition = Convert.ToInt32(dr1["HeaderPosition"]),
                                IsIncludeHeader = Convert.ToBoolean(dr1["IsIncludeHeader"]),
                                DBAdditionalParameters = Convert.ToString(dr1["AdditionalParameters"])
                            });
                        }
                    }
                }
            }
            return reportfiledc;
        }
        public DataSet GetReportDataFromSource(ReportFileSheetDataContract ReportDc)
        {
            DataTable dt = new DataTable();
            DataSet dsreport = new DataSet();
            Helper.Helper hp = new Helper.Helper();
            ReportFileDataContract reportfiledc = new ReportFileDataContract();
            if (!string.IsNullOrEmpty(ReportDc.DefaultAttributes))
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@JsonReportParamters", Value = ReportDc.DefaultAttributes };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dsreport = hp.ExecDataSet(ReportDc.DataSourceProcedure, sqlparam);
                return dsreport;
            }
            dsreport = hp.ExecDataSet(ReportDc.DataSourceProcedure, null);
            return dsreport;
        }
        

        public string InsertReportFileLog(ReportFileLogDataContract _reportDC)
        {

            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@CreatedBy", Value = _reportDC.CreatedBy };
            SqlParameter p2 = new SqlParameter { ParameterName = "@FileName", Value = _reportDC.FileName };
            SqlParameter p3 = new SqlParameter { ParameterName = "@OriginalFileName", Value = _reportDC.OriginalFileName };
            SqlParameter p4 = new SqlParameter { ParameterName = "@storagetypeid", Value = _reportDC.StorageTypeID };
            SqlParameter p5 = new SqlParameter { ParameterName = "@ObjectGUID", Value = _reportDC.ObjectGUID };
            SqlParameter p6 = new SqlParameter { ParameterName = "@ObjectID", Value = _reportDC.ObjectID };
            SqlParameter p7 = new SqlParameter { ParameterName = "@ObjectTypeID", Value = _reportDC.ObjectTypeID };
            SqlParameter p8 = new SqlParameter { ParameterName = "@Comment", Value = _reportDC.Comment };
            SqlParameter p9 = new SqlParameter { ParameterName = "@DocumentStorageID", Value = _reportDC.DocumentStorageID };
            SqlParameter p10 = new SqlParameter { ParameterName = "@StorageLocation", Value = _reportDC.StorageLocation };
            SqlParameter p11 = new SqlParameter { ParameterName = "@ReportFileAttributes", Value = _reportDC.ReportFileAttributes };
            SqlParameter p12 = new SqlParameter { ParameterName = "@NewUploadedDocumentLogID", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12 };
            int result = hp.ExecNonquery("dbo.usp_InsertReportFileLog", sqlparam);
            string NewUploadedDocumentLogID = Convert.ToString(p12.Value);
            if (result != 0)
                return Convert.ToString(NewUploadedDocumentLogID);
            else
                return "";
        }
        public List<ReportFileLogDataContract> GetAllReportFileLogByObjectId(ReportFileLogDataContract _documentDC, Guid? userID, int? pgeIndex, int? pageSize, out int? TotalCount)
        {
            //
            DataTable dt = new DataTable();
            List<ReportFileLogDataContract> lstDocumentDC = new List<ReportFileLogDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ObjectGUID", Value = _documentDC.ObjectGUID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@ObjectTypeID", Value = _documentDC.ObjectTypeID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@currentTime", Value = _documentDC.CurrentTime };
            SqlParameter p5 = new SqlParameter { ParameterName = "@Status", Value = _documentDC.Status };
            SqlParameter p6 = new SqlParameter { ParameterName = "@StartDate", Value = _documentDC.StartDate };
            SqlParameter p7 = new SqlParameter { ParameterName = "@EndDate", Value = _documentDC.EndDate };
            SqlParameter p8 = new SqlParameter { ParameterName = "@PgeIndex", Value = pgeIndex };
            SqlParameter p9 = new SqlParameter { ParameterName = "@pageSize", Value = pageSize };
            SqlParameter p10 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10 };
            dt = hp.ExecDataTable("dbo.usp_GetAllReportFileLog", sqlparam);

            TotalCount = string.IsNullOrEmpty(Convert.ToString(p10.Value)) ? 0 : Convert.ToInt32(p10.Value);
            foreach (DataRow dr in dt.Rows)
            {
                ReportFileLogDataContract _docdc = new ReportFileLogDataContract();
                _docdc.ReportFileLogID = Convert.ToInt32(dr["ReportFileLogID"]);
                if (Convert.ToString(dr["UploadedDocumentLogID"]) != "")
                {
                    _docdc.UploadedDocumentLogID = new Guid(Convert.ToString(dr["UploadedDocumentLogID"]));
                }
                _docdc.ReportFileName = Convert.ToString(dr["ReportFileName"]);
                _docdc.FileName = Convert.ToString(dr["FileName"]);
                _docdc.OriginalFileName = Convert.ToString(dr["OriginalFileName"]);
                _docdc.UserFullName = Convert.ToString(dr["UserFullName"]);
                _docdc.UploadedTime = Convert.ToString(dr["UploadedTime"]);
                _docdc.FilePath = Convert.ToString(dr["FileName"]);
                _docdc.Comment = Convert.ToString(dr["Comment"]);
                _docdc.ObjectID = Convert.ToInt32(dr["ObjectID"]);
                _docdc.ObjectGUID = Convert.ToString(dr["ObjectGUID"]);
                _docdc.ObjectTypeID = Convert.ToString(dr["ObjectTypeID"]);
                _docdc.ObjectType = Convert.ToString(dr["ObjectType"]);
                _docdc.DocumentStorageID = Convert.ToString(dr["DocumentStorageID"]);
                _docdc.Storagetype = Convert.ToString(dr["Storagetype"]);
                _docdc.StorageTypeID = Convert.ToInt32(dr["StorageTypeID"]);
                _docdc.StorageLocation = Convert.ToString(dr["StorageLocation"]);
                _docdc.ReportFileAttributes = Convert.ToString(dr["ReportFileAttributes"]);

                lstDocumentDC.Add(_docdc);
            }

            return lstDocumentDC;
        }
        public void UpdateReportLogStatus(List<ReportFileLogDataContract> _docDC, Guid? userID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@XMLUploadedDocumentLogID", Value = _docDC.ToXML() };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecNonquery("dbo.usp_UpdateReportLogStatus", sqlparam);
        }

        //==========Added getwarehouseStatus==========//
        public List<DWStatusDataContract> GetwarehouseStatus(string btnname)
        {
           
            DataTable dt = new DataTable();
            List<DWStatusDataContract> lstStatus = new List<DWStatusDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@ButtonName", Value = btnname };
          

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetwarehouseStatus", sqlparam);
          
        
          
            foreach (DataRow dr in dt.Rows)
            {
                DWStatusDataContract rfdc = new DWStatusDataContract();
              
                rfdc.BatchEndTime = CommonHelper.ToDateTime(dr["BatchEndTime"]);
                
                rfdc.Status2= Convert.ToString(dr["Status2"]);
                lstStatus.Add(rfdc);
            }

            return lstStatus;
        }

        public List<ReportFileDataContract> GetAllReportFilesByReportType(Guid? UserID, string ReportType, string TenantId, string GroupId, int? pageSize, int? pageIndex, out int? TotalCount)
        {
            List<ReportFileDataContract> lstReportFiles = new List<ReportFileDataContract>();

            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ReportType", Value = ReportType };
            SqlParameter p3 = new SqlParameter { ParameterName = "@TenantId", Value = TenantId };
            SqlParameter p4 = new SqlParameter { ParameterName = "@GroupId", Value = GroupId };

            SqlParameter p5 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
            SqlParameter p6 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p7 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = 10 };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4,p5,p6,p7 };
            dt = hp.ExecDataTable("dbo.usp_GetAllReportFileByReportType", sqlparam);
            TotalCount = Convert.ToInt32(p7.Value);

            // var deals = dbContext.usp_GetAllDealsForTranscationsFilter();
            foreach (DataRow dr in dt.Rows)
            {
                ReportFileDataContract reportfiledc = new ReportFileDataContract();
                reportfiledc.ReportFileID = Convert.ToInt32(dr["ReportFileID"]);
                reportfiledc.ReportFileGUID = new Guid(dr["ReportFileGUID"].ToString());
                reportfiledc.ReportFileName = Convert.ToString(dr["ReportFileName"]);
                //reportfiledc.SheetName = Convert.ToString(dr["SheetName"]);
                //reportfiledc.DataSourceProcedure = Convert.ToString(dr["DataSourceProcedure"]);
                reportfiledc.ReportFileFormat = Convert.ToString(dr["ReportFileFormat"]);
                reportfiledc.ReportFileTemplate = Convert.ToString(dr["ReportFileTemplate"]);
                reportfiledc.ReportFileJSON = Convert.ToString(dr["ReportFileJSON"]);
                //reportfiledc.HeaderPosition = Convert.ToInt32(dr["HeaderPosition"]);
                if(dr["SourceStorageTypeID"]!= DBNull.Value)
                reportfiledc.SourceStorageTypeID = Convert.ToInt32(dr["SourceStorageTypeID"]);
                reportfiledc.SourceStorageLocation = Convert.ToString(dr["SourceStorageLocation"]);
                if (dr["DestinationStorageTypeID"] != DBNull.Value)
                    reportfiledc.DestinationStorageTypeID = Convert.ToInt32(dr["DestinationStorageTypeID"]);
                reportfiledc.DestinationStorageLocation = Convert.ToString(dr["DestinationStorageLocation"]);
                reportfiledc.Status = Convert.ToInt32(dr["Status"]);
                reportfiledc.Frequency = Convert.ToString(dr["Frequency"]);
                if (dr["FrequencyStatus"] != DBNull.Value)
                    reportfiledc.FrequencyStatus = Convert.ToInt32(dr["FrequencyStatus"]);
                reportfiledc.DefaultAttributes = Convert.ToString(dr["DefaultAttributes"]);
                if (dr["IsAllowInput"] != DBNull.Value)
                    reportfiledc.IsAllowInput = Convert.ToBoolean(dr["IsAllowInput"]);
                reportfiledc.ReportType = Convert.ToString(dr["ReportType"]);
                reportfiledc.TenantId = Convert.ToString(dr["TenantId"]);


                lstReportFiles.Add(reportfiledc);
            }
            return lstReportFiles;
        }


    }
}
//=================================================================================================//