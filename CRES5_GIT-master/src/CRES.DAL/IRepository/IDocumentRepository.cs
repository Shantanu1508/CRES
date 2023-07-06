using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.DAL.IRepository
{
    interface IDocumentRepository
    {
        List<DocumentDataContract> GetAllDocumentByObjectId(DocumentDataContract _documentDC, Guid? userID, int? pgeIndex, int? pageSize, out int? TotalCount);
        string InsertUploadedDocumentLog(DocumentDataContract _docDC);
        void UpdateDocumentStatus(List<DocumentDataContract> _docDC, Guid? userID);
        //void SyncBoxDocument(List<DocumentDataContract> _docDC, Guid? userID, string CREDealID);
        string BulkInsert(DataTable dt, string DestTableName, List<FileImportColumnMappingDataContract> columnMapping, bool IsTruncateRequired);
    }
}
