using System;

namespace CRES.DataContract
{
    public class ReportFileLogDataContract
    {
        public int ReportFileLogID { get; set; }
        public System.Guid UploadedDocumentLogID { get; set; }
        public string ReportFileName { get; set; }
        public string FileName { get; set; }
        public string OriginalFileName { get; set; }
        public string CreatedBy { get; set; }
        public string UpdatedBy { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public string DocumentTypeID { get; set; }
        public string DocumentType { get; set; }
        public string Comment { get; set; }
        public string UserFullName { get; set; }
        public string UploadedTime { get; set; }
        public string ObjectGUID { get; set; }
        public int ObjectID { get; set; }
        public string ObjectTypeID { get; set; }
        public string FilePath { get; set; }
        public string CurrentTime { get; set; }
        public string Storagetype { get; set; }
        public string sourceBlobFileName { get; set; }
        public string ObjectType { get; set; }
        public string Name { get; set; }
        public int Status { get; set; }
        public string DocumentStorageID { get; set; }
        public string FolderName { get; set; }
        public string ParentFolderName { get; set; }
        public int StorageTypeID { get; set; }
        public string ReportFileAttributes { get; set; }
        public string StorageLocation { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }

    }
}
