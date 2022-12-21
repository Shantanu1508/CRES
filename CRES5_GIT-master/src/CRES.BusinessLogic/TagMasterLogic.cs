using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
namespace CRES.BusinessLogic
{
    public class TagMasterLogic
    {
        TagMasterRepository tagrepo = new TagMasterRepository();
        public List<TagMasterDataContract> GetTagMaster(string UserID, Guid? AnalysisId)
        {
            return tagrepo.GetTagMaster(UserID, AnalysisId);
        }

        public string InsertTagMaster(TagMasterDataContract tmdc, string UserID)
        {
            return tagrepo.InsertTagMaster(tmdc, UserID);
        }


        public DataTable GetNoteCashflowsExportDataFromTransactionClose(string AnalysisID, string tagMasterID)
        {
            return tagrepo.GetNoteCashflowsExportDataFromTransactionClose(AnalysisID, tagMasterID);
        }


        public void DeleteTagByTagID(string UserID, Guid? AnalysisID, Guid? tagMasterID)
        {
            tagrepo.DeleteTagByTagID(UserID, AnalysisID, tagMasterID);
        }

        public List<TagMasterDataContract> GetTagFileNameForAzureUpload()
        {
            return tagrepo.GetTagFileNameForAzureUpload();
        }

        public void UpdateTagFileName(List<TagFileDataContract> lstTagFile)
        {
            tagrepo.UpdateTagFileName(lstTagFile);
        }

        public void ImportIntoTransactionEntryCloseArchive(Guid? TagMasterID, Guid? AnalysisID)
        {
            tagrepo.ImportIntoTransactionEntryCloseArchive(TagMasterID, AnalysisID);

        }
    }
}
