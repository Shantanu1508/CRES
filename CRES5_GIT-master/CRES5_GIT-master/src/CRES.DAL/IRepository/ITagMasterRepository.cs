using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.DAL.IRepository
{
    public interface ITagMasterRepository
    {

        List<TagMasterDataContract> GetTagMaster(string UserID, Guid? AnalysisId);
        List<TagMasterDataContract> GetTagFileNameForAzureUpload();
        void UpdateTagFileName(List<TagFileDataContract> lstTagFile);
        void ImportIntoTransactionEntryCloseArchive(Guid? TagMasterID, Guid? AnalysisID);
    }
}
