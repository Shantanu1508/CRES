using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace CRES.BusinessLogic
{
    public class TagXIRRLogic
    {
        private TagXIRRRepository _tagXIRRRepository = new TagXIRRRepository();

        public DataTable GetAllNoteTagsXIRR(Guid? UserID)
        {
            return _tagXIRRRepository.GetAllNoteTagsXIRR(UserID);
        }
        public void InsertUpdateNoteTagsXIRR(DataTable NoteTagsXIRR, Guid UserID)
        {
            _tagXIRRRepository.InsertUpdateNoteTagsXIRR(NoteTagsXIRR, UserID);
        }
        public void deleteNoteTagsXIRR(int? TagMasterXIRRID, Guid UserID)
        {
            _tagXIRRRepository.deleteNoteTagsXIRR(TagMasterXIRRID, UserID);
        }
        public List<TagMasterXIRRDataContract> GetTagMasterXIRRByAccountID(string NoteAccountID)
        {
            return _tagXIRRRepository.GetTagMasterXIRRByAccountID(NoteAccountID);
        }
        public void InsertUpdateTagAccountMappingXIRR(string NoteAccountID, List<TagMasterXIRRDataContract> _tagXIRRDC, string UserID)
        {
            _tagXIRRRepository.InsertUpdateTagAccountMappingXIRR(NoteAccountID, _tagXIRRDC, UserID);
        }

        public DataTable GetXIRROutputByConfigID(int XIRRConfigID, string UserID)
        {
            return _tagXIRRRepository.GetXIRROutputByConfigID(XIRRConfigID, UserID);
        }

        public DataTable GetXIRRInputByConfigID(int XIRRConfigID, string UserID)
        {
            return _tagXIRRRepository.GetXIRRInputByConfigID(XIRRConfigID, UserID);
        }



        public List<XIRRCalculationRequestsDataContract> GetProcessingXIRRRequestsFromDB()
        {
            return _tagXIRRRepository.GetProcessingXIRRRequestsFromDB();
        }

        public DataTable GetTransactionsForXirrCalculation(int? XIRRConfigID, int? XIRRReturnGroupID, string Type, string DealAccountID, string AnalysisID)
        {
            return _tagXIRRRepository.GetTransactionsForXirrCalculation(XIRRConfigID, XIRRReturnGroupID, Type, DealAccountID, AnalysisID);
        }
        public void ArchiveXIRROutput(XIRRConfigParamDataContract XIRRConfigParam, string UserID)
        {
            _tagXIRRRepository.ArchiveXIRROutput(XIRRConfigParam, UserID);
        }

        public DataTable GetXIRRCalculationStatusByObjectID(string XIRRCalculationRequestsID, string UserID)
        {
            return _tagXIRRRepository.GetXIRRCalculationStatusByObjectID(XIRRCalculationRequestsID, UserID);
        }
        public void UpdateCalcStatus(int? XIRRCalculationRequestsID, string StatusText, string ColumnName, string ErrorMessage, string UpdatedBy)
        {
            _tagXIRRRepository.UpdateCalcStatus(XIRRCalculationRequestsID, StatusText, ColumnName, ErrorMessage, UpdatedBy);
        }

        public void InsertXIRROutput(int? XIRRConfigID, int? XIRRReturnGroupID, string Type, string DealAccountID, decimal XIRRValue, string AnalysisID, string UserID)
        {
            _tagXIRRRepository.InsertXIRROutput(XIRRConfigID, XIRRReturnGroupID, Type, DealAccountID, XIRRValue, AnalysisID, UserID);
        }
        public DataTable GetXIRROutputByObjectID(string ObjectType, string AccountID)
        {
            return _tagXIRRRepository.GetXIRROutputByObjectID(ObjectType, AccountID);
        }

        public int InsertUpdateXIRRConfigs(XIRRConfigDataContract xirrConfig, Guid UserID)
        {
            return _tagXIRRRepository.InsertUpdateXIRRConfigs(xirrConfig, UserID);
        }
        public List<TransactionTypesDataContract> GetAllTransactionTypesforXIRRConfig()
        {
            return _tagXIRRRepository.GetAllTransactionTypesforXIRRConfig();
        }
        public DataTable GetXIRRConfig()
        {
            return _tagXIRRRepository.GetXIRRConfig();
        }

        public DataTable GetXIRRViewNotesByObjectID(string ObjectID, int? XIRRConfigID)
        {
            return _tagXIRRRepository.GetXIRRViewNotesByObjectID(ObjectID, XIRRConfigID);
        }


        public void InsertXIRRCalculationInput(XIRRConfigParamDataContract XIRRConfigParam, string UserID)
        {
            _tagXIRRRepository.InsertXIRRCalculationInput(XIRRConfigParam, UserID);
        }

        public List<XIRRArchiveDataContract> GetAllArchiveXIRROutput(Guid? UserID)
        {
            return _tagXIRRRepository.GetAllArchiveXIRROutput(UserID);
        }
        public DataTable GetXIRROutputArchive(int XIRRConfigID, DateTime ArchiveDate, string UserID)
        {
            return _tagXIRRRepository.GetXIRROutputArchive(XIRRConfigID, ArchiveDate, UserID);
        }
        public DataTable GetViewAttachedNotes(int? TagMasterXIRRID)
        {
            return _tagXIRRRepository.GetViewAttachedNotes(TagMasterXIRRID);
        }
        public List<XIRRFiltersLookupDataContract> GetLookupforXIRRFilters(int XIRRConfigID)
        {
            return _tagXIRRRepository.GetLookupforXIRRFilters(XIRRConfigID);
        }
        public List<XIRRConfigFilterDataContract> GetXIRRFilters()
        {
            return _tagXIRRRepository.GetXIRRFilters();
        }
        public List<XIRRConfigFilterDataContract> GetXirrFilterSetupNames()
        {
            return _tagXIRRRepository.GetXirrFilterSetupNames();
        }


        public XIRRConfigDataContract GetXIRRConfigByID(int XIRRConfigID, string UserID)
        {
            return _tagXIRRRepository.GetXIRRConfigByID(XIRRConfigID, UserID);
        }


        public DataTable GetXIRROutputPortfolioLevel(int XIRRConfigID, string UserID)
        {
            return _tagXIRRRepository.GetXIRROutputPortfolioLevel(XIRRConfigID, UserID);
        }

        public DataTable GetXIRROutputDealLevel(int XIRRConfigID, string UserID)
        {
            return _tagXIRRRepository.GetXIRROutputDealLevel(XIRRConfigID, UserID);
        }

        public void UpdateXIRRInputOutputFiles(int XIRRReturnGroupID, string FileName, string UserID)
        {
            _tagXIRRRepository.UpdateXIRRInputOutputFiles(XIRRReturnGroupID, FileName, UserID);
        }

        public void UpdateXIRRInputFiles(int XIRRReturnID, string FileName, string UserID)
        {
            _tagXIRRRepository.UpdateXIRRInputFiles(XIRRReturnID, FileName, UserID);
        }
        public DataTable GetXIRROutputDealLevelFromXirrDashBoard(int XIRRConfigID, string group1, string group2, string loanstatus)
        {
            return _tagXIRRRepository.GetXIRROutputDealLevelFromXirrDashBoard(XIRRConfigID, group1, group2, loanstatus);
        }
        public void DeleteXIRRInputCashflow(int? XIRRConfigID)
        {
            _tagXIRRRepository.DeleteXIRRInputCashflow(XIRRConfigID);
        }
        public DataTable GetXIRRFilterExtractData(int? XIRRConfigID)
        {
            return _tagXIRRRepository.GetXIRRFilterExtractData(XIRRConfigID);
        }

        public DataTable GetXIRRConfigByXIRRConfigGUID(string XIRRConfigGUID)
        {
            return _tagXIRRRepository.GetXIRRConfigByXIRRConfigGUID(XIRRConfigGUID);
        }

        public List<XIRRConfigFilterDataContract> GetXIRRFiltersByXIRRConfigID(int? XIRRConfigID)
        {
            return _tagXIRRRepository.GetXIRRFiltersByXIRRConfigID(XIRRConfigID);
        }
        public void InsertUpdateXIRRConfigDetail(List<XIRRConfigDataContract> ListXirrConfig, List<XIRRConfigFilterDataContract> ListXirrConfigFilter, Guid UserID)
        {
            _tagXIRRRepository.InsertUpdateXIRRConfigDetail(ListXirrConfig, ListXirrConfigFilter, UserID);
        }

        public XIRRReturnGroupDataContract GetXIRRReturnGroupByID(int XIRRReturnGroupID, string UserID)
        {
            return _tagXIRRRepository.GetXIRRReturnGroupByID(XIRRReturnGroupID, UserID);
        }

        public void DeleteXIRRByXIRRConfigID(int deletedXIRRConfigID)
        {
            _tagXIRRRepository.DeleteXIRRByXIRRConfigID(deletedXIRRConfigID);
        }

        public XIRRReturnGroupDataContract GetFileNameForCashflow(XIRRReturnGroupDataContract retDC, string UserID)
        {
            return _tagXIRRRepository.GetFileNameForCashflow(retDC, UserID);
        }
        public string CheckDuplicateXIRRConfig(int XIRRConfigID, string ReturnName)
        {
            return _tagXIRRRepository.CheckDuplicateXIRRConfig(XIRRConfigID, ReturnName);
        }

        public void UpdateXIRRInputOutputArchiveFiles(int XIRRConfigID, string FileNameInput, string FileNameOutput, DateTime ArchiveDate, string Comments, string UserID)
        {
            _tagXIRRRepository.UpdateXIRRInputOutputArchiveFiles(XIRRConfigID, FileNameInput, FileNameOutput, ArchiveDate, Comments, UserID);
        }

        public DataTable GetAllFileNameXIRR()
        {
            return _tagXIRRRepository.GetAllFileNameXIRR();
        }

        public void InsertXIRRDeleteBlobFiles(string FileName, string Path, string UserID)
        {
            _tagXIRRRepository.InsertXIRRDeleteBlobFiles(FileName, Path, UserID);
        }
        public List<LookupDataContract> GetXIRRReferencingDealLevelReturnLookup()
        {
            return _tagXIRRRepository.GetXIRRReferencingDealLevelReturnLookup();
        }
        public void UpdateReferencingDealLevelReturnforPortfolioType(int? XIRRConfigIdDealCopy, int XIRRConfigIdPortfolio)
        {
            _tagXIRRRepository.UpdateReferencingDealLevelReturnforPortfolioType(XIRRConfigIdDealCopy, XIRRConfigIdPortfolio);
        }
        public void UpdateXIRRDeleteBlobFiles(int XIRRDeleteBlobFilesID)
        {
            _tagXIRRRepository.UpdateXIRRDeleteBlobFiles(XIRRDeleteBlobFilesID);
        }
        public int? GetReferencingDealLevelReturnWithSameConfig(int XIRRConfigID)
        {
            return _tagXIRRRepository.GetReferencingDealLevelReturnWithSameConfig(XIRRConfigID);
        }
        public void UpdateXIRRDealOutputCalculated(int XIRRConfigID, DateTime CutOffDate, Guid UserID)
        {
            _tagXIRRRepository.UpdateXIRRDealOutputCalculated(XIRRConfigID, CutOffDate, UserID);
        }
        public void CalculateXIRRAfterDealSave(string DealAccountID, string UserID)
        {
            _tagXIRRRepository.CalculateXIRRAfterDealSave(DealAccountID, UserID);
        }
        public void InsertXIRR_InputCashflow(int XIRRConfigID, Guid UserID)
        {
            _tagXIRRRepository.InsertXIRR_InputCashflow(XIRRConfigID, UserID);
        }

        public DataTable CalculateXIRRAfterDealCalculate(string UserID)
        {
            return _tagXIRRRepository.CalculateXIRRAfterDealCalculate(UserID);
        }

        public DataTable CalculateXirrNightlty()
        {
            return _tagXIRRRepository.CalculateXirrNightlty();
        }
    }
}
