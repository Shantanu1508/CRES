using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace CRES.DAL.IRepository
{
    public interface IValuationModuleRepository
    {
        void InsertUpdateDealList(List<ValuationModuleDealListDataContract> DealList, string createdby);

        void InsertUpdateGobalSetup(ValuationMasterDataContract Gobal); 

        void InsertUpdatedPricingGrid(List<ValuationModuleCurrentGridDataContract> ListCurrentGrid);
     
        void InsertUpdatedFloorValue(List<FloorValueMasterDataContract> ListFloorValueMaster);
        void DeleteFloorValue(DateTime? MarkedDate);

        void InsertUpdatedFloorByTerm(List<FloorValueDetailDataContract> ListFloorValueDetail);

        void InsertUpdatedDealOutput(List<ValuationDealOutputDataContract> ListDealOutputData);

        void InsertUpdatedNoteOutput(List<ValuationNoteOutputDataContract> ListNoteOutputData);

        void QueueDealsForValuationCalculation(List<ValuationModuleDealListDataContract> DealList);

        void InsertSECMastHolding(DateTime MarkedDate, string UserID);

        public void InsertProjectedPayoffCalc(DateTime MarkedDate, string UserID);

        void ArchiveValuationOutputData(DateTime MarkedDate, string UserID);

        void updateCalcStatus(int ValuationRequestsID, string DealID, string StatusText, string ColumnName, string ErrorMessage, string UpdatedBy, DateTime? MarkedDate);

        void InsertUpdatedMarkedDateMaster(DateTime? MarkedDate, string UserID);
        void InsertUpdatedNoteMatrixData(List<ValuationNoteMatrixDataContract> ListNoteMatrix);

        void InsertUpdateNoteCashflowOverride(List<ValuationNoteCashFlowDataContract> ListNoteCashFlow);

        void InsertCashFlowDataIntoValCashflowData(DateTime? MarkedDate, string UserID);

        DataTable GetValuationRequestsCount();
        DataTable GetVMMasterData();
        void UpdatedVMMaster(string VMName, string Status);
        DataTable GetValuationRequestsDataForEmail();
        void UpdateEmailSentToYes();
        DataTable GetIdealVMMachine();
        void InsertUpdateNotesWeight(List<ValuationNotesWeightDataContract> ListNotesWeight);
        void InsertUpdateAdjustedLTVs(List<ValuationAdjustedLTVDataContract> ListAdjustedLTVs);
        void InsertUpdateValueDeclineByPropertyType(List<ValuationValueDeclineDataContract> ListType);

        void InsertUpdatedPricingGridFeeAssumptions(List<ValuationPricingGridFeeAssumptionsListDataContract> ListCurrentGrid);
        void InsertUpdatePricingGridMappingMaster(List<PricingGridMappingMasterListDataContract> ListCurrentGrid);

        string SendValuationDealsForReCalc();
        public void InsertUpdateRateExtension(List<ValuationRateExtensionDataContract> ListType);
    }
}
