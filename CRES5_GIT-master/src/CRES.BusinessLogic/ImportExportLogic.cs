using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DAL.Repository;
using CRES.DataContract;

namespace CRES.BusinessLogic
{
    public class ImportExportLogic
    {
        ImportExportRepository _importExportRepository = new ImportExportRepository();

        public void ImportBackShopInUnderwritingtable(string dealID, string username, Guid? BatchLogID)
        {
            _importExportRepository.ImportBackShopInUnderwritingtable(dealID, username, BatchLogID);
        }

        public void ImportLandingtableToMainDB(string dealID, string username, Guid? BatchLogID)
        {
            _importExportRepository.ImportLandingtableToMainDB(dealID, username, BatchLogID);
        }


        public void DeleteINUnderwritingDealDataByDealID(string dealid, Guid? userid)
        {
            _importExportRepository.DeleteINUnderwritingDealDataByDealID(dealid, userid);
        }

        public BackShopImportDataContract GetBackshopDealByDealName(string dealname)
        {
            BackShopImportDataContract _backShopImportDataContract = new BackShopImportDataContract();
            _backShopImportDataContract = _importExportRepository.GetBackshopDealByDealName(dealname);
            return _backShopImportDataContract;
        }



        public List<IN_UnderwritingNoteDataContract> GetInUnderwritingNotesByDealID(string dealName, Guid? userid)
        {
            List<IN_UnderwritingNoteDataContract> _iN_UnderwritingNoteDataContractList = new List<IN_UnderwritingNoteDataContract>();
            _iN_UnderwritingNoteDataContractList = _importExportRepository.GetInUnderwritingNotesByDealID(dealName, userid);
            return _iN_UnderwritingNoteDataContractList;
        }


        public List<IN_UnderwritingRateSpreadScheduleDataContract> GetINUnderwritingRateSpreadScheduleByNoteID(Guid? noteid, Guid? userid)
        {
            List<IN_UnderwritingRateSpreadScheduleDataContract> _in_UnderwritingRateSpreadScheduleDataContractList = new List<IN_UnderwritingRateSpreadScheduleDataContract>();
            _in_UnderwritingRateSpreadScheduleDataContractList = _importExportRepository.GetINUnderwritingRateSpreadScheduleByNoteID(noteid, userid);
            return _in_UnderwritingRateSpreadScheduleDataContractList;
        }

        public List<IN_UnderwritingStrippingScheduleDataContract> GetINUnderwritingStrippingScheduleByNoteID(Guid? noteid, Guid? userid)
        {
            List<IN_UnderwritingStrippingScheduleDataContract> _in_UnderwritingStrippingScheduleDataContractList = new List<IN_UnderwritingStrippingScheduleDataContract>();
            _in_UnderwritingStrippingScheduleDataContractList = _importExportRepository.GetINUnderwritingStrippingScheduleByNoteID(noteid, userid);
            return _in_UnderwritingStrippingScheduleDataContractList;
        }

        public List<IN_UnderwritingPIKScheduleDataContract> GetINUnderwritingPIKScheduleByNoteID(Guid? noteid, Guid? userid)
        {
            List<IN_UnderwritingPIKScheduleDataContract> _in_UnderwritingPIKScheduleDataContractList = new List<IN_UnderwritingPIKScheduleDataContract>();
            _in_UnderwritingPIKScheduleDataContractList = _importExportRepository.GetINUnderwritingPIKScheduleByNoteID(noteid, userid);
            return _in_UnderwritingPIKScheduleDataContractList;
        }

        public List<IN_UnderwritingFundingScheduleDataContract> GetINUnderwritingFundingScheduleByNoteID(Guid? noteid, Guid? userid)
        {
            List<IN_UnderwritingFundingScheduleDataContract> _in_UnderwritingFundingScheduleDataContractList = new List<IN_UnderwritingFundingScheduleDataContract>();
            _in_UnderwritingFundingScheduleDataContractList = _importExportRepository.GetINUnderwritingFundingScheduleByNoteID(noteid, userid);
            return _in_UnderwritingFundingScheduleDataContractList;
        }

        public Guid? InsertBatchLog(BatchLogDataContract _batchLogDataContract, string username)
        {

            Guid? outBatchLogID;
            int cnt = _importExportRepository.InsertBatchLog(_batchLogDataContract, out outBatchLogID, username);
            return outBatchLogID;
        }


        public void DeleteBatchLogByBatchLogID(Guid? BatchLogID)
        {
            _importExportRepository.DeleteBatchLogByBatchLogID(BatchLogID);
        }


        public IN_UnderwritingDealDataContract GetINUnderwritingDealByDealIdorDealName(string dealnameordealid)
        {
            IN_UnderwritingDealDataContract _iN_UnderwritingDealDataContract = new IN_UnderwritingDealDataContract();
            _iN_UnderwritingDealDataContract = _importExportRepository.GetINUnderwritingDealByDealIdorDealName(dealnameordealid);
            return _iN_UnderwritingDealDataContract;
        }
        public List<FileImportMasterDataContract> GetFileImportMaster()
        {
            return _importExportRepository.GetFileImportMaster();
        }

        public List<FileImportColumnMappingDataContract> GetFileImportColumnMappingByID(int FileImportMasterID)
        {
            return _importExportRepository.GetFileImportColumnMappingByID(FileImportMasterID);
        }

        public int InsertBerkadiaDataTap(DataTable dtBerkadia, string CreatedBy)
        {
            return _importExportRepository.InsertBerkadiaDataTap(dtBerkadia, CreatedBy);
        }

        public void ImportServicerBalance()
        {
            _importExportRepository.ImportServicerBalance();
        }


        //public int InsertWellsDataTap(DataTable dtBerkadia, string CreatedBy)
        //{
        //    return _importExportRepository.InsertWellsDataTap(dtBerkadia, CreatedBy);
        //}
    }
}
