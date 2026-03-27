using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net;
using System.Text;
using CRES.DAL.Repository;
using CRES.DataContract;
using System.Data;
using Syncfusion.DocIO.DLS;

namespace CRES.BusinessLogic
{
    public class ValuationModuleLogic
    {
        ValuationModuleRepository Vmrepo = new ValuationModuleRepository();
        public void SaveDealList(List<ValuationModuleDealListDataContract> list, string createdby)
        {
            Vmrepo.InsertUpdateDealList(list, createdby);
        }
        public void InsertUpdateGobalSetup(ValuationMasterDataContract Gobal)
        {
            Vmrepo.InsertUpdateGobalSetup(Gobal);
        }
        //public void InsertUpdatedPricingGridDetailDealType(List<ValuationModuleDataContract> PricingGridDetailDealType)
        //{
        //    Vmrepo.InsertUpdatedPricingGridDetailDealType(PricingGridDetailDealType);
        //}
        public void InsertUpdatedPricingGrid(List<ValuationModuleCurrentGridDataContract> ListCurrentGrid)
        {
            Vmrepo.InsertUpdatedPricingGrid(ListCurrentGrid);
        }
        //public void InsertUpdatedPricingGridDetailSlice(List<ValuationModuleDataContract> PricingGridDetailSlice)
        //{
        //    Vmrepo.InsertUpdatedPricingGridDetailSlice(PricingGridDetailSlice);
        //}
        public void InsertUpdatedFloorValue(List<FloorValueMasterDataContract> ListFloorValueMaster)
        {
            Vmrepo.InsertUpdatedFloorValue(ListFloorValueMaster);
        }
        public void DeleteFloorValue(DateTime? MarkedDate)
        {
            Vmrepo.DeleteFloorValue(MarkedDate);
        }
        public void InsertUpdatedFloorByTerm(List<FloorValueDetailDataContract> ListFloorValueDetail)
        {
            Vmrepo.InsertUpdatedFloorByTerm(ListFloorValueDetail);
        }
        public void InsertUpdatedDealOutput(List<ValuationDealOutputDataContract> ListDealOutputData)
        {
            Vmrepo.InsertUpdatedDealOutput(ListDealOutputData);
        }
        public void InsertUpdatedNoteOutput(List<ValuationNoteOutputDataContract> ListNoteOutputData)
        {
            Vmrepo.InsertUpdatedNoteOutput(ListNoteOutputData);
        }
        public void QueueDealsForValuationCalculation(List<ValuationModuleDealListDataContract> DealList)
        {
            Vmrepo.QueueDealsForValuationCalculation(DealList);
        }
        public void InsertSECMastHolding(DateTime MarkedDate, string UserID)
        {
            Vmrepo.InsertSECMastHolding(MarkedDate, UserID);
        }
        public void InsertProjectedPayoffCalc(DateTime MarkedDate, string UserID)
        {
            Vmrepo.InsertProjectedPayoffCalc(MarkedDate, UserID);
        }
        public void InsertUpdateNoteCashflowOverride(List<ValuationNoteCashFlowDataContract> ListNoteCashFlow)
        {
            Vmrepo.InsertUpdateNoteCashflowOverride(ListNoteCashFlow);
        }
        public void ArchiveValuationOutputData(DateTime MarkedDate, string UserID)
        {
            Vmrepo.ArchiveValuationOutputData(MarkedDate, UserID);
        }
        public void InsertUpdatedMarkedDateMaster(DateTime? MarkedDate, string UserID)
        {
            Vmrepo.InsertUpdatedMarkedDateMaster(MarkedDate, UserID);
        }
        public void updateCalcStatus(int ValuationRequestsID, string DealID, string StatusText, string ColumnName, string ErrorMessage, string UpdatedBy, DateTime? MarkedDate)
        {
            Vmrepo.updateCalcStatus(ValuationRequestsID, DealID, StatusText, ColumnName, ErrorMessage, UpdatedBy, MarkedDate);
        }
        public void InsertUpdatedNoteMatrixData(List<ValuationNoteMatrixDataContract> ListNoteMatrix)
        {
            Vmrepo.InsertUpdatedNoteMatrixData(ListNoteMatrix);
        }

        public void InsertCashFlowDataIntoValCashflowData(DateTime? MarkedDate, string UserID)
        {
            Vmrepo.InsertCashFlowDataIntoValCashflowData(MarkedDate, UserID);
        }
        public DataTable GetValuationRequestsCount()
        {
            return Vmrepo.GetValuationRequestsCount();
        }
        public DataTable GetVMMasterData()
        {
            return Vmrepo.GetVMMasterData();
        }
        public DataTable GetIdealVMMachine()
        {
            return Vmrepo.GetIdealVMMachine();
        }

        public string StartStopVirtualMachine(string ApiConstantUrl)
        {

            string Outputresponse = "";
            System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;
            using (var client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromMinutes(10);
                var res = client.GetAsync(ApiConstantUrl);
                try
                {
                    HttpResponseMessage response1 = res.Result.EnsureSuccessStatusCode();
                    if (response1.IsSuccessStatusCode)
                    {
                        Outputresponse = response1.Content.ReadAsStringAsync().Result;
                    }
                }
                catch (Exception e)
                {
                    Outputresponse = "AzureError :" + e.Message;
                }
            }
            return Outputresponse;
        }
        public void UpdatedVMMaster(string VMName, string Status)
        {
            Vmrepo.UpdatedVMMaster(VMName, Status);
        }
        public DataTable GetValuationRequestsDataForEmail()
        {
            return Vmrepo.GetValuationRequestsDataForEmail();
        }
        public void UpdateEmailSentToYes()
        {
            Vmrepo.UpdateEmailSentToYes();
        }

        public string SendValuationDealsForReCalc()
        {
            return Vmrepo.SendValuationDealsForReCalc();
        }
        public void InsertUpdateNotesWeight(List<ValuationNotesWeightDataContract> ListNotesWeight)
        {
            Vmrepo.InsertUpdateNotesWeight(ListNotesWeight);
        }
        public void InsertUpdateAdjustedLTVs(List<ValuationAdjustedLTVDataContract> ListAdjustedLTVs)
        {
            Vmrepo.InsertUpdateAdjustedLTVs(ListAdjustedLTVs);
        }
        public void InsertUpdatedNoteList(List<ValuationNoteListDataContract> NoteList)
        {
            Vmrepo.InsertUpdatedNoteList(NoteList);
        }

        public void InsertUpdateValueDeclineByPropertyType(List<ValuationValueDeclineDataContract> ListType)
        {
            Vmrepo.InsertUpdateValueDeclineByPropertyType(ListType);
        }
        public void InsertUpdatedPricingGridFeeAssumptions(List<ValuationPricingGridFeeAssumptionsListDataContract> ListCurrentGrid)
        {
            Vmrepo.InsertUpdatedPricingGridFeeAssumptions(ListCurrentGrid);
        }

        public void InsertUpdatePricingGridMappingMaster(List<PricingGridMappingMasterListDataContract> ListCurrentGrid) 
        {
            Vmrepo.InsertUpdatePricingGridMappingMaster(ListCurrentGrid);
        }
        public void InsertUpdateRateExtension(List<ValuationRateExtensionDataContract> ListType)
        {
            Vmrepo.InsertUpdateRateExtension(ListType);
        }
    }
}
