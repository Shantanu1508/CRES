using CRES.DAL.IRepository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Text;
using System.Drawing;
using Newtonsoft.Json.Linq;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace CRES.DAL.Repository
{
    public class ValuationModuleRepository : IValuationModuleRepository
    {

        public void InsertUpdateDealList(List<ValuationModuleDealListDataContract> DealList, string createdby)
        {
            Helper.Helper hp = new Helper.Helper();

            DataTable DealListData = new DataTable();
            DealListData.Columns.Add("MarkedDate");
            DealListData.Columns.Add("Calculate");
            DealListData.Columns.Add("DealID");
            DealListData.Columns.Add("Scenario");
            DealListData.Columns.Add("IndexType");
            DealListData.Columns.Add("IndexForecast");
            DealListData.Columns.Add("IndexFloor");
            DealListData.Columns.Add("PORTFOLIO");
            DealListData.Columns.Add("LastIndexReset");
            DealListData.Columns.Add("PaymentDay");
            DealListData.Columns.Add("PriceCaptoThirdParty");
            DealListData.Columns.Add("DealNominalDMOrPriceForMark");
            DealListData.Columns.Add("DMAdjustment");
            DealListData.Columns.Add("StubInterestinAdvancelastaccrualDate");
            DealListData.Columns.Add("IOValuationmo");
            DealListData.Columns.Add("PendingPayoff");
            DealListData.Columns.Add("PpayAdjustedAL");
            DealListData.Columns.Add("MaterialMezz");
            DealListData.Columns.Add("SliverMezz");
            DealListData.Columns.Add("IsCashFlowLive");
            DealListData.Columns.Add("UserID");

            if (DealList != null)
            {
                DataTable dt = new DataTable();
                dt = hp.ToDataTable(DealList);

                foreach (DataRow dr in dt.Rows)
                {
                    dr["UserID"] = createdby;

                    DealListData.ImportRow(dr);
                }
            }

            if (DealListData.Rows.Count > 0)
            {
                hp.ExecDataTablewithtable("val.usp_InsertUpdatedDealList", DealListData, "tbltype_DealList");
            }
        }
        public void InsertUpdateGobalSetup(ValuationMasterDataContract Gobal)
        {

            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            try
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@MarkedDate", Value = Gobal.MarkedDate };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UseDurSpreadVolWt", Value = Gobal.UseDurSpreadVolWt };
                SqlParameter p3 = new SqlParameter { ParameterName = "@GAAPBasisInputsIncludeAccrued", Value = Gobal.GAAPBasisInputsIncludeAccrued };
                SqlParameter p4 = new SqlParameter { ParameterName = "@MinimumExcessIOCredit", Value = Gobal.MinimumExcessIOCredit };
                SqlParameter p5 = new SqlParameter { ParameterName = "@PercentageofFloorValueincludedinMark", Value = Gobal.PercentageofFloorValueincludedinMark };
                SqlParameter p6 = new SqlParameter { ParameterName = "@FloorIndexDate", Value = Gobal.FloorIndexDate };
                SqlParameter p7 = new SqlParameter { ParameterName = "@UserID", Value = Gobal.CreatedBy };
                SqlParameter p8 = new SqlParameter { ParameterName = "@PricingGridKey", Value = Gobal.PricingGridKey };
                SqlParameter p9 = new SqlParameter { ParameterName = "@PricingGridMarketSOFRFloor", Value = Gobal.PricingGridMarketSOFRFloor };
                SqlParameter p10 = new SqlParameter { ParameterName = "@LIBORForecast", Value = Gobal.LIBORForecast };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7 ,p8,p9, p10};
                var res = hp.ExecNonquery("val.usp_InsertUpdatedGlobalSetup", sqlparam);

            }
            catch (Exception ex)
            {

                throw;
            }
        }      

        public void DeleteFloorValue(DateTime? MarkedDate)
        {

            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            try
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@MarkedDate", Value = MarkedDate };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                var res = hp.ExecNonquery("val.usp_DeleteFloorValue", sqlparam);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public void InsertUpdatedFloorValue(List<FloorValueMasterDataContract> ListFloorValueMaster)
        {

            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            try
            {
                foreach (var griddata in ListFloorValueMaster)
                {
                    SqlParameter p6 = new SqlParameter { ParameterName = "@MarkedDate", Value = griddata.MarkedDate };
                    SqlParameter p1 = new SqlParameter { ParameterName = "@IndexTypeName", Value = griddata.IndexTypeName };
                    SqlParameter p2 = new SqlParameter { ParameterName = "@CurrentMarketLoanFloor", Value = griddata.CurrentMarketLoanFloor };
                    SqlParameter p3 = new SqlParameter { ParameterName = "@Term", Value = griddata.Term };
                    SqlParameter p4 = new SqlParameter { ParameterName = "@LoanFloor", Value = griddata.LoanFloor };
                    SqlParameter p5 = new SqlParameter { ParameterName = "@UserID", Value = griddata.CreatedBy };

                    SqlParameter[] sqlparam = new SqlParameter[] { p6, p1, p2, p3, p4, p5 };
                    var res = hp.ExecNonquery("val.usp_InsertUpdatedFloorValue", sqlparam);
                }
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public void InsertUpdatedFloorByTerm(List<FloorValueDetailDataContract> ListFloorValueDetail)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable FloorValueDetailData = new DataTable();
                FloorValueDetailData.Columns.Add("MarkedDate");
                FloorValueDetailData.Columns.Add("IndexTypeName");
                FloorValueDetailData.Columns.Add("Percentage");
                FloorValueDetailData.Columns.Add("Month");
                FloorValueDetailData.Columns.Add("Value");
                FloorValueDetailData.Columns.Add("UserID");

                if (ListFloorValueDetail != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ListFloorValueDetail);

                    foreach (DataRow dr in dt.Rows)
                    {
                        FloorValueDetailData.ImportRow(dr);
                    }
                }

                if (FloorValueDetailData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtable("val.usp_InsertUpdatedFloorByTerm", FloorValueDetailData, "tbltype_FloorByTerm");
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public void InsertUpdatedNoteList(List<ValuationNoteListDataContract> NoteList)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable NoteListData = new DataTable();
                NoteListData.Columns.Add("MarkedDate");
                NoteListData.Columns.Add("CREDealID");
                NoteListData.Columns.Add("CREDealName");
                NoteListData.Columns.Add("NoteID");
                NoteListData.Columns.Add("NoteNominalDMOrPriceForMark");
                NoteListData.Columns.Add("UserID");

                if (NoteList != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(NoteList);

                    foreach (DataRow dr in dt.Rows)
                    {
                        NoteListData.ImportRow(dr);
                    }
                }

                if (NoteListData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtable("val.usp_InsertUpdatedNoteList", NoteListData, "tbltype_NoteList");
                }
            }
            catch (Exception)
            {

                throw;
            }
        }


        public void InsertUpdatedDealOutput(List<ValuationDealOutputDataContract> ListDealOutputData)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable DealOutputData = new DataTable();

                DealOutputData.Columns.Add("MarkedDate");
                DealOutputData.Columns.Add("DealID");
                DealOutputData.Columns.Add("CalculationStatus");
                DealOutputData.Columns.Add("LastCalculatedon");
                DealOutputData.Columns.Add("PayoffExtended");
                DealOutputData.Columns.Add("DealMarkPriceClean");
                DealOutputData.Columns.Add("DealGAAPPriceClean");
                DealOutputData.Columns.Add("DealMarkClean");
                DealOutputData.Columns.Add("DealUPB");
                DealOutputData.Columns.Add("DealCommitment");
                DealOutputData.Columns.Add("DealGAAPBasisDirty");
                DealOutputData.Columns.Add("DealYieldatParClean");
                DealOutputData.Columns.Add("DealYieldatGAAPBasis");
                DealOutputData.Columns.Add("DealMarkYield");
                DealOutputData.Columns.Add("CalculatedDealAccruedRate");
                DealOutputData.Columns.Add("DealGAAPDM_GtrFLR_Index");
                DealOutputData.Columns.Add("DealMarkDM_GtrFLR_Index");
                DealOutputData.Columns.Add("DealDuration_OnCommitment");
                DealOutputData.Columns.Add("GrossFloorValuefromGrid");
                DealOutputData.Columns.Add("GrossValue_UsageScalar");
                DealOutputData.Columns.Add("DollarValueofFloorinMark");
                DealOutputData.Columns.Add("PointvalueofFloorinMark");
                DealOutputData.Columns.Add("Term");
                DealOutputData.Columns.Add("Strike");
                DealOutputData.Columns.Add("MktStrike");
                DealOutputData.Columns.Add("UserID");

                if (ListDealOutputData != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ListDealOutputData);

                    foreach (DataRow dr in dt.Rows)
                    {
                        DealOutputData.ImportRow(dr);
                    }
                }

                if (DealOutputData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtable("val.usp_InsertUpdatedDealOutput", DealOutputData, "tbltype_DealOutput");
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public void InsertUpdatedNoteOutput(List<ValuationNoteOutputDataContract> ListNoteOutputData)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable NoteOutputData = new DataTable();

                NoteOutputData.Columns.Add("MarkedDate");
                NoteOutputData.Columns.Add("NoteID");
                NoteOutputData.Columns.Add("DealID");
                NoteOutputData.Columns.Add("CalculationStatus");
                NoteOutputData.Columns.Add("LastCalculatedOn");
                NoteOutputData.Columns.Add("NoteMarkPriceClean");
                NoteOutputData.Columns.Add("NoteGAAPPriceClean");
                NoteOutputData.Columns.Add("NoteUPB");
                NoteOutputData.Columns.Add("NoteMarkClean");
                NoteOutputData.Columns.Add("NoteCommitment");
                NoteOutputData.Columns.Add("NoteBasisDirty");
                NoteOutputData.Columns.Add("NoteYieldatGAAPBasis");
                NoteOutputData.Columns.Add("CalculatedNoteAccruedRate");
                NoteOutputData.Columns.Add("NoteGAAPDMIndex");
                NoteOutputData.Columns.Add("NoteMarkYield");
                NoteOutputData.Columns.Add("NoteMarkDMgtrFLRIndex");
                NoteOutputData.Columns.Add("NoteDurationonCommitment");

                NoteOutputData.Columns.Add("UserID");

                if (ListNoteOutputData != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ListNoteOutputData);

                    foreach (DataRow dr in dt.Rows)
                    {
                        NoteOutputData.ImportRow(dr);
                    }
                }

                if (NoteOutputData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtable("val.usp_InsertUpdatedNoteOutput", NoteOutputData, "tbltype_NoteOutput");
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public void QueueDealsForValuationCalculation(List<ValuationModuleDealListDataContract> DealList)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable DealListData = new DataTable();
                DealListData.Columns.Add("MarkedDate");
                DealListData.Columns.Add("DealID");
                DealListData.Columns.Add("Scenario");
                DealListData.Columns.Add("UserID");


                if (DealList != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(DealList);

                    foreach (DataRow dr in dt.Rows)
                    {
                        DealListData.ImportRow(dr);
                    }
                }

                if (DealListData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtable("val.usp_QueueDealsForValuation", DealListData, "tbltype_QueueDealsForValuation");
                }
            }
            catch (Exception)
            {

                throw;
            }
        }

        public void InsertSECMastHolding(DateTime MarkedDate, string UserID)
        {
            Helper.Helper hp = new Helper.Helper();
            try
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@MarkedDate", Value = MarkedDate };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                var res = hp.ExecNonquery("val.usp_InsertSECMastHoldingFromLanding", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertProjectedPayoffCalc(DateTime MarkedDate, string UserID)
        {
            Helper.Helper hp = new Helper.Helper();

            try
            {
                SqlParameter p1 = new SqlParameter { ParameterName = "@MarkedDate", Value = MarkedDate };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                var res = hp.ExecNonquery("val.usp_InsertProjectedPayoffCalcFromLanding", sqlparam);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }


        public void ArchiveValuationOutputData(DateTime MarkedDate, string UserID)
        {
            try
            {
                var res = 0;
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@MarkedDate", Value = MarkedDate };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecDataTablewithparams("val.usp_InsertUpdatedArchiveMaster", sqlparam);

            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public void updateCalcStatus(int ValuationRequestsID, string DealID, string StatusText, string ColumnName, string ErrorMessage, string UpdatedBy, DateTime? MarkedDate)
        {
            try
            {
                var res = 0;
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@MarkedDate", Value = MarkedDate };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ValuationRequestsID", Value = ValuationRequestsID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter p4 = new SqlParameter { ParameterName = "@StatusText", Value = StatusText.ToString() };
                SqlParameter p5 = new SqlParameter { ParameterName = "@ColumnName", Value = ColumnName.ToString() };
                SqlParameter p6 = new SqlParameter { ParameterName = "@ErrorMessage", Value = ErrorMessage.ToString() };
                SqlParameter p7 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UpdatedBy.ToString() };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7 };
                hp.ExecDataTablewithparams("VAL.usp_UpdateCalculationStatusAndTime_ValuationRequests", sqlparam);

            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public void InsertUpdatedMarkedDateMaster(DateTime? MarkedDate, string UserID)
        {
            try
            {
                var res = 0;
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@MarkedDate", Value = MarkedDate };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };


                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecDataTablewithparams("val.usp_InsertUpdatedMarkedDateMaster", sqlparam);

            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public void InsertCashFlowDataIntoValCashflowData(DateTime? MarkedDate, string UserID)
        {
            try
            {
                var res = 0;
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@markedDate", Value = MarkedDate };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecDataTablewithparams("val.usp_SaveNoteCashFlow", sqlparam);

            }
            catch (Exception ex)
            {

                throw;
            }
        }
        public void InsertUpdatedNoteMatrixData(List<ValuationNoteMatrixDataContract> ListNoteMatrix)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable NoteMatrixData = new DataTable();
                NoteMatrixData.Columns.Add("MarkedDate");
                NoteMatrixData.Columns.Add("NoteMatrixSheetName");
                NoteMatrixData.Columns.Add("DealID");
                NoteMatrixData.Columns.Add("DealGroupID");
                NoteMatrixData.Columns.Add("NoteID");
                NoteMatrixData.Columns.Add("DealName");
                NoteMatrixData.Columns.Add("NoteName");
                NoteMatrixData.Columns.Add("Commitment");
                NoteMatrixData.Columns.Add("InitialFunding");
                NoteMatrixData.Columns.Add("CurrentMaturity_Date");
                NoteMatrixData.Columns.Add("OriginationFee");
                NoteMatrixData.Columns.Add("ExtensionFee1");
                NoteMatrixData.Columns.Add("ExtensionFee2");
                NoteMatrixData.Columns.Add("ExtensionFee3");
                NoteMatrixData.Columns.Add("ExitFee");
                NoteMatrixData.Columns.Add("ProductType");
                NoteMatrixData.Columns.Add("AcoreOrig");
                NoteMatrixData.Columns.Add("UserID");

                if (ListNoteMatrix != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ListNoteMatrix);

                    foreach (DataRow dr in dt.Rows)
                    {
                        NoteMatrixData.ImportRow(dr);
                    }
                }
                if (NoteMatrixData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtable("val.usp_InsertUpdatedNoteMatrixData", NoteMatrixData, "tbltype_NoteMatrixData");
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        public void InsertUpdateNoteCashflowOverride(List<ValuationNoteCashFlowDataContract> ListNoteCashFlow)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable ProjectedPayoffData = new DataTable();
                ProjectedPayoffData.Columns.Add("NoteCashFlowID");
                ProjectedPayoffData.Columns.Add("MarkedDate");
                ProjectedPayoffData.Columns.Add("ValueOverride");
                ProjectedPayoffData.Columns.Add("UserID");

                if (ListNoteCashFlow != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ListNoteCashFlow);

                    foreach (DataRow dr in dt.Rows)
                    {
                        ProjectedPayoffData.ImportRow(dr);
                    }
                }
                if (ProjectedPayoffData.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtable("val.usp_UpdateNoteCashFlowOverride", ProjectedPayoffData, "tbltype_NoteCashflow");
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        public DataTable GetValuationRequestsCount()
        {

            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            try
            {
                dt = hp.ExecDataTable("val.usp_GetValuationRequestsCount");
            }
            catch (Exception ex)
            {
                throw;
            }
            return dt;
        }
        public DataTable GetVMMasterData()
        {

            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            try
            {
                dt = hp.ExecDataTable("dbo.usp_GetVMMaster");
            }
            catch (Exception ex)
            {
                throw;
            }
            return dt;
        }
        public void UpdatedVMMaster(string VMName, string Status)
        {
            try
            {
                var res = 0;
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@VMName", Value = VMName };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Status", Value = Status };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecDataTablewithparams("usp_UpdateVMMaster", sqlparam);

            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public DataTable GetValuationRequestsDataForEmail()
        {

            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            try
            {
                dt = hp.ExecDataTable("val.usp_GetValuationRequestsDataForEmail");
            }
            catch (Exception ex)
            {
                throw;
            }
            return dt;
        }

        public void UpdateEmailSentToYes()
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                hp.ExecNonquery("val.usp_UpdateEmailSentToYes");
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public string SendValuationDealsForReCalc()
        {
            string message= "";
            try
            {
                Helper.Helper hp = new Helper.Helper();
                hp.ExecNonquery("val.usp_SendValuationDealsForReCalc");
                message = "";

            }
            catch (Exception ex)
            {
                message= ex.Message;
            }

            return message;
        }

        public DataTable GetIdealVMMachine()
        {

            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            try
            {
                dt = hp.ExecDataTable("val.usp_GetIdealVMMachine");
            }
            catch (Exception ex)
            {
                throw;
            }
            return dt;
        }
        public void InsertUpdateNotesWeight(List<ValuationNotesWeightDataContract> ListNotesWeight)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable NotesWeight = new DataTable();
                NotesWeight.Columns.Add("MarkedDate");
                NotesWeight.Columns.Add("PropertyType");
                NotesWeight.Columns.Add("Header");
                NotesWeight.Columns.Add("SortOrder");
                NotesWeight.Columns.Add("Value");
                NotesWeight.Columns.Add("UserID");

                if (ListNotesWeight != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ListNotesWeight);

                    foreach (DataRow dr in dt.Rows)
                    {
                        NotesWeight.ImportRow(dr);
                    }
                }
                if (NotesWeight.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtable("val.usp_InsertUpdateNotesWeight", NotesWeight, "tbltype_NotesWeight");
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public void InsertUpdateAdjustedLTVs(List<ValuationAdjustedLTVDataContract> ListAdjustedLTVs)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable dtadjust = new DataTable();

                dtadjust.Columns.Add("MarkedDate");
                dtadjust.Columns.Add("CREDealID");
                dtadjust.Columns.Add("CREDealName");
                dtadjust.Columns.Add("FundedDate");
                dtadjust.Columns.Add("TotalCommitment");
                dtadjust.Columns.Add("AsStabilizedAppraisal");
                dtadjust.Columns.Add("PropertyType");
                dtadjust.Columns.Add("ValueDecline");
                dtadjust.Columns.Add("AdjustedAsStabilizedValue");
                dtadjust.Columns.Add("RecourseCurrent");
                dtadjust.Columns.Add("AdjustedAsStabilizedValuewithRecourse");
                dtadjust.Columns.Add("AdjustedAsStabilizedLTV");
                dtadjust.Columns.Add("UnadjustedAsStabilizedLTV");
                dtadjust.Columns.Add("UserID");

                if (ListAdjustedLTVs != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ListAdjustedLTVs);

                    foreach (DataRow dr in dt.Rows)
                    {
                        dtadjust.ImportRow(dr);
                    }
                }
                if (dtadjust.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtable("val.usp_InsertUpdateAdjustedLTVs", dtadjust, "tbltype_AdjustedLTVs");
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public void InsertUpdateValueDeclineByPropertyType(List<ValuationValueDeclineDataContract> ListType)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable dtadjust = new DataTable();

                dtadjust.Columns.Add("MarkedDate");
                dtadjust.Columns.Add("PropertyType");
                dtadjust.Columns.Add("ValueDecline");
                dtadjust.Columns.Add("UserID");

                if (ListType != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ListType);

                    foreach (DataRow dr in dt.Rows)
                    {
                        dtadjust.ImportRow(dr);
                    }
                }
                if (dtadjust.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtable("val.usp_InsertUpdateValueDeclineByPropertyType", dtadjust, "tbltype_ValueDeclineByPropertyType");
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public void InsertUpdatedPricingGrid(List<ValuationModuleCurrentGridDataContract> ListCurrentGrid)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable dtgrid = new DataTable();

                dtgrid.Columns.Add("MarkedDate");
                dtgrid.Columns.Add("PropertyType");
                dtgrid.Columns.Add("DealType");
                dtgrid.Columns.Add("AnoteLTV");
                dtgrid.Columns.Add("AnoteSpread");
                dtgrid.Columns.Add("ABwholeLoanLTV");
                dtgrid.Columns.Add("ABwholeLoanSpread");
                dtgrid.Columns.Add("EquityLTV");
                dtgrid.Columns.Add("EquityYield");
                dtgrid.Columns.Add("UserID");

                if (ListCurrentGrid != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ListCurrentGrid);

                    foreach (DataRow dr in dt.Rows)
                    {
                        dtgrid.ImportRow(dr);
                    }
                }
                if (dtgrid.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtable("val.usp_InsertUpdatedPricingGrid", dtgrid, "tbltype_PricingGrid");
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public void InsertUpdatedPricingGridFeeAssumptions(List<ValuationPricingGridFeeAssumptionsListDataContract> ListCurrentGrid)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable dtgrid = new DataTable();

                dtgrid.Columns.Add("MarkedDate");
                dtgrid.Columns.Add("ValueType");
                dtgrid.Columns.Add("Nonconstruction");
                dtgrid.Columns.Add("Construction");
                dtgrid.Columns.Add("UserID");

                if (ListCurrentGrid != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ListCurrentGrid);

                    foreach (DataRow dr in dt.Rows)
                    {
                        dtgrid.ImportRow(dr);
                    }
                }
                if (dtgrid.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtable("val.usp_InsertUpdatedPricingGridFeeAssumptions", dtgrid, "tbltype_PricingGridFeeAssumptions");
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public void InsertUpdatePricingGridMappingMaster(List<PricingGridMappingMasterListDataContract> ListCurrentGrid)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable dtgrid = new DataTable();

                dtgrid.Columns.Add("MarkedDate");
                dtgrid.Columns.Add("DealTypeName");
                dtgrid.Columns.Add("DealTypeMapping");                
                dtgrid.Columns.Add("UserID");

                if (ListCurrentGrid != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ListCurrentGrid);

                    foreach (DataRow dr in dt.Rows)
                    {
                        dtgrid.ImportRow(dr);
                    }
                }
                if (dtgrid.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtable("val.usp_InsertUpdatePricingGridMappingMaster", dtgrid, "tbltype_PricingGridMappingMaster");
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public void InsertUpdateRateExtension(List<ValuationRateExtensionDataContract> ListType)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();

                DataTable dtRateExtension = new DataTable();

                dtRateExtension.Columns.Add("MarkedDate");
                dtRateExtension.Columns.Add("Value");
                dtRateExtension.Columns.Add("UserID");

                if (ListType != null)
                {
                    DataTable dt = new DataTable();
                    dt = hp.ToDataTable(ListType);

                    foreach (DataRow dr in dt.Rows)
                    {
                        dtRateExtension.ImportRow(dr);
                    }
                }
                if (dtRateExtension.Rows.Count > 0)
                {
                    hp.ExecDataTablewithtable("val.usp_InsertUpdateRateExtension", dtRateExtension, "tbltype_RateExtension");
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}
