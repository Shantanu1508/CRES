using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace CRES.DAL.IRepository
{
    public interface ITagXIRRRepository
    {
        DataTable GetAllNoteTagsXIRR(Guid? UserID);
        void InsertUpdateNoteTagsXIRR(DataTable NoteTagsXIRR, Guid UserID);
        void deleteNoteTagsXIRR(int? TagMasterXIRRID, Guid UserID);
        List<TagMasterXIRRDataContract> GetTagMasterXIRRByAccountID(string NoteAccountID);
        void InsertUpdateTagAccountMappingXIRR(string NoteAccountID, List<TagMasterXIRRDataContract> _tagXIRRDC, string UserID);
        DataTable GetXIRROutputByConfigID(int XIRRConfigID, string UserID);
        List<XIRRCalculationRequestsDataContract> GetProcessingXIRRRequestsFromDB();
        DataTable GetTransactionsForXirrCalculation(int? XIRRConfigID, int? XIRRReturnGroupID, string Type, string DealAccountID, string AnalysisID);
        void UpdateCalcStatus(int? XIRRCalculationRequestsID, string StatusText, string ColumnName, string ErrorMessage, string UpdatedBy);
        void InsertXIRROutput(int? XIRRConfigID, int? XIRRReturnGroupID, string Type, string DealAccountID, decimal XIRRValue, string AnalysisID, string UserID);
        public int InsertUpdateXIRRConfigs(XIRRConfigDataContract xirrConfig, Guid UserID);
        public List<TransactionTypesDataContract> GetAllTransactionTypesforXIRRConfig();
        public DataTable GetXIRRConfig();
        DataTable GetXIRROutputByObjectID(string ObjectType, string AccountID);
        void ArchiveXIRROutput(XIRRConfigParamDataContract XIRRConfigParam, string UserID);
        DataTable GetXIRRViewNotesByObjectID(string ObjectID, int? XIRRConfigID);
        void InsertXIRRCalculationInput(XIRRConfigParamDataContract XIRRConfigParam, string UserID);
        List<XIRRArchiveDataContract> GetAllArchiveXIRROutput(Guid? UserID);
        DataTable GetXIRRCalculationStatusByObjectID(string XIRRCalculationRequestsID, string UserID);
        DataTable GetViewAttachedNotes(int? TagMasterXIRRID);
        List<XIRRFiltersLookupDataContract> GetLookupforXIRRFilters(int XIRRConfigID);
        public List<XIRRConfigFilterDataContract> GetXIRRFilters();
        public List<XIRRConfigFilterDataContract> GetXirrFilterSetupNames();
        XIRRConfigDataContract GetXIRRConfigByID(int XIRRConfigID, string UserID);
        DataTable GetXIRROutputPortfolioLevel(int XIRRConfigID, string UserID);
        DataTable GetXIRROutputDealLevel(int XIRRConfigID, string UserID);
        void UpdateXIRRInputOutputFiles(int XIRRReturnGroupID, string FileNameInput, string UserID);
        void DeleteXIRRInputCashflow(int? XIRRConfigID);
        DataTable GetXIRRFilterExtractData(int? XIRRConfigID);
        DataTable GetXIRRConfigByXIRRConfigGUID(string XIRRConfigGUID);
        List<XIRRConfigFilterDataContract> GetXIRRFiltersByXIRRConfigID(int? XIRRConfigID);
        void InsertUpdateXIRRConfigDetail(List<XIRRConfigDataContract> ListXirrConfig, List<XIRRConfigFilterDataContract> ListXirrConfigFilter, Guid UserID);
        XIRRReturnGroupDataContract GetXIRRReturnGroupByID(int XIRRReturnGroupID, string UserID);
        public string CheckDuplicateXIRRConfig(int XIRRConfigID, string ReturnName);
        XIRRReturnGroupDataContract GetFileNameForCashflow(XIRRReturnGroupDataContract retDC, string UserID);
        void UpdateXIRRInputFiles(int XIRRConfigID, string FileNameInput, string UserID);
        void UpdateXIRRInputOutputArchiveFiles(int XIRRConfigID, string FileNameInput, string FileNameOutput, DateTime ArchiveDate, string Comments, string UserID);
        void InsertXIRRDeleteBlobFiles(string FileName, string Path, string UserID);
        public List<LookupDataContract> GetXIRRReferencingDealLevelReturnLookup();
        public void UpdateReferencingDealLevelReturnforPortfolioType(int? XIRRConfigIdDealCopy, int XIRRConfigIdPortfolio);
        public int? GetReferencingDealLevelReturnWithSameConfig(int XIRRConfigID);
        public void UpdateXIRRDealOutputCalculated(int XIRRConfigID, DateTime CutOffDate, Guid UserID);
        public void CalculateXIRRAfterDealSave(string DealAccountid, string UserId);
        void InsertXIRR_InputCashflow(int XIRRConfigID, Guid UserID);

        DataTable CalculateXIRRAfterDealCalculate(string UserId);
        DataTable CalculateXirrNightlty();
    }
}
