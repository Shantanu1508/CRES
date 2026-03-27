using CRES.DAL.Helper;
using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using CRES.DAL;

namespace CRES.BusinessLogic
{
    public class DocumentLogic
    {
        private DocumentRepository _documentRepository = new DocumentRepository();

        public List<DocumentDataContract> GetAllDocumentByObjectId(DocumentDataContract _documentDC, Guid? userID, int? pgeIndex, int? pageSize, out int? TotalCount)
        {
            List<DocumentDataContract> lstDocuments = new List<DocumentDataContract>();
            lstDocuments = _documentRepository.GetAllDocumentByObjectId(_documentDC, userID, pgeIndex, pageSize, out TotalCount);
            return lstDocuments;
        }

        public string InsertUploadedDocumentLog(DocumentDataContract _docDC)
        {
            string result;
            result = _documentRepository.InsertUploadedDocumentLog(_docDC);
            return result;
        }

        public void UpdateDocumentStatus(List<DocumentDataContract> _docDC, Guid? userID)
        {
            _documentRepository.UpdateDocumentStatus(_docDC, userID);
        }


        //public void SyncBoxDocument(List<DocumentDataContract> _docDC, Guid? userID,string CREDealID)
        //{
        //    _documentRepository.SyncBoxDocument(_docDC,userID,CREDealID);
        //}

        public string WellsDailyExtractBulkInsert(DataTable dt, string DestTableName)
        {
           return _documentRepository.WellsDailyExtractBulkInsert(dt, DestTableName);
        }
        public string BulkInsertForNoteMatrix(DataTable dt, JsonFileConfiguration fileConf)
        {
            return _documentRepository.BulkInsertForNoteMatrix(dt, fileConf);
        }


        public int InsertIntoNoteMatrix()
        {
            return _documentRepository.InsertIntoNoteMatrix();
        }
        public string BulkInsert(DataTable dt, string DestTableName, List<FileImportColumnMappingDataContract> columnMapping, bool IsTruncateRequired, bool IsExecuteProc, List<string> ProcName)
        {
            return _documentRepository.BulkInsert(dt, DestTableName, columnMapping, IsTruncateRequired, IsExecuteProc, ProcName);
        }
    }
}