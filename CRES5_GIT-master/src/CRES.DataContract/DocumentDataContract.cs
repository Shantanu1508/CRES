using System;
using System.Collections.Generic;

namespace CRES.DataContract
{
    public class DocumentDataContract
    {
        public System.Guid UploadedDocumentLogID { get; set; }
        public string FileName { get; set; }
        public string OriginalFileName { get; set; }
        public string CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public string DocumentTypeID { get; set; }
        public string DocumentType { get; set; }
        public string Comment { get; set; }
        public string UserFullName { get; set; }
        public string UploadedTime { get; set; }
        public string ObjectID { get; set; }
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
    }
}