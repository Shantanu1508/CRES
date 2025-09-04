using System;
using System.Collections.Generic;

namespace CRES.DataContract
{
    public class ReportDataContract
    {
        public ReportDataContract()
        {
        }

        public string EmbedUrl { get; set; }
        public string Id { get; set; }
        public string Name { get; set; }
        public string WebUrl { get; set; }
        public Guid ReportFileGUID { get; set; }
        public string ReportType { get; set; }
        public bool IsDownloadRequire { get; set; }
        public string DefaultAttributes { get; set; }
        public bool IsAllowInput { get; set; }
        public string TenantId { get; set; }
    }
    public class ReportFileDataContract
    {
        public ReportFileDataContract()
        {
            lstReportFileSheet = new List<DataContract.ReportFileSheetDataContract>();
        }

        public int ReportFileID { get; set; }
        public Guid ReportFileGUID { get; set; }
        public string ReportFileName { get; set; }
        public string NewFileName { get; set; }
        public string ReportFileFormat { get; set; }
        public string ReportFileTemplate { get; set; }
        public string ReportFileJSON { get; set; }
        public int HeaderPosition { get; set; }
        public int SourceStorageTypeID { get; set; }
        public string SourceStorageLocation { get; set; }
        public int DestinationStorageTypeID { get; set; }
        public string DestinationStorageLocation { get; set; }
        public int Status { get; set; }
        public string Frequency { get; set; }
        public int FrequencyStatus { get; set; }
        public string SheetName { get; set; }
        public string DataSourceProcedure { get; set; }
        public string DocumentStorageID { get; set; }
        public bool IsDownloadRequire { get; set; }
        public string DefaultAttributes { get; set; }
        public List<ReportFileSheetDataContract> lstReportFileSheet { get; set; }
        public bool IsAllowInput { get; set; }
        public string Status2 { get; set; }
        public DateTime?  BatchEndTime { get; set; }
        public string BatchName { get; set; }
        public string DownloadFileName { get; set; }
        public string ReportType { get; set; }
        public string TenantId { get; set; }
        public string GroupId { get; set; }

    }

    public class ReportFileSheetDataContract
    {
        public ReportFileSheetDataContract()
        {
        }
        public int ReportFileSheetID { get; set; }
        public int ReportFileID { get; set; }
        public string SheetName { get; set; }
        public string DataSourceProcedure { get; set; }
        public string DefaultAttributes { get; set; }
        public int HeaderPosition { get; set; }
        public Boolean IsIncludeHeader { get; set; }
        public string AdditionalParameters { get; set; }
        public string DBAdditionalParameters { get; set; }

    }
    //===================Added Getwarehouse Class====================================//
    public class DWStatusDataContract
    {
        public string Status2 { get; set; }
        public DateTime? BatchEndTime { get; set; }
        public bool Succeeded { get; set; }
        public string Message { get; set; }

    }
    
}
