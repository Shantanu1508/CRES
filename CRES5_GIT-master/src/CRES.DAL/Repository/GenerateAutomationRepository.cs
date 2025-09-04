using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using static CRES.DataContract.V1CalcDataContract;

namespace CRES.DAL.Repository
{
    public class GenerateAutomationRepository : IGenerateAutomationRepository
    {
        public bool QueueDealForAutomation(List<GenerateAutomationDataContract> list, string username)
        {
            bool status;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dList = new DataTable();
                dList.Columns.Add("DealID");
                dList.Columns.Add("StatusText");
                dList.Columns.Add("AutomationType");
                dList.Columns.Add("BatchType");

                if (list != null)
                {
                    DataTable dt = new DataTable();
                    dt = ObjToDataTable.ToDataTable(list);
                    foreach (DataRow dr in dt.Rows)
                    {
                        dList.ImportRow(dr);
                    }
                }
                if (dList.Rows.Count > 0)
                {
                    hp.QueueDealForAutomationHelper("dbo.usp_QueueDealForAutomation", dList, username);
                }

                status = true;
            }
            catch (Exception ex)
            {
                throw;
                status = false;
            }

            return status;
        }
        public void UpdateCalculationStatusandTime(int calcid, string DealID, string statustext, string columnname, string errmsg, string UpdatedBy, string DealSaveStatus)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@AutomationRequestsID", Value = calcid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = new Guid(DealID) };
            SqlParameter p3 = new SqlParameter { ParameterName = "@StatusText", Value = statustext };
            SqlParameter p4 = new SqlParameter { ParameterName = "@ColumnName", Value = columnname };
            SqlParameter p5 = new SqlParameter { ParameterName = "@ErrorMessage", Value = errmsg };
            SqlParameter p6 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UpdatedBy };
            SqlParameter p7 = new SqlParameter { ParameterName = "@DealSaveStatus", Value = DealSaveStatus };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7 };
            hp.ExecNonquery("dbo.usp_UpdateCalculationStatusAndTime_DealSaveAutomation", sqlparam);

        }
        public List<GenerateAutomationDataContract> GetListOfDealsForAutomation()
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            List<GenerateAutomationDataContract> listofdeals = new List<GenerateAutomationDataContract>();

            dt = hp.ExecDataTable("dbo.usp_GetListOfDealsForAutomation");
            foreach (DataRow dr in dt.Rows)
            {
                GenerateAutomationDataContract gad = new GenerateAutomationDataContract();
                gad.AutomationRequestsID = Convert.ToInt32(dr["AutomationRequestsID"]);
                gad.DealID = Convert.ToString(dr["DealID"]);
                gad.BatchID = Convert.ToInt32(dr["BatchID"]);
                gad.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                gad.AutomationType = Convert.ToInt32(dr["AutomationType"]);

                if (gad.AutomationType == 789)
                {
                    gad.AutomationTypeText = "AutoSpread_UnderwritingDataChanged";
                }
                else if (gad.AutomationType == 799)
                {
                    gad.AutomationTypeText = "All_AutoSpread_Deals";
                }
                else if (gad.AutomationType == 800)
                {
                    gad.AutomationTypeText = "FundingMoveToNextMonth";
                }
                else if (gad.AutomationType == 801)
                {
                    gad.AutomationTypeText = "AmortizationAutoWire";
                }
                else if (gad.AutomationType == 839)
                {
                    gad.AutomationTypeText = "FundingMoveTo15Businessdays";
                }
                else if (gad.AutomationType == 851)
                {
                    gad.AutomationTypeText = "FundingMoveTo1BusinessdaysWF";
                }
                else if (gad.AutomationType == 853)
                {
                    gad.AutomationTypeText = "LiabilityCalculation";
                }
                listofdeals.Add(gad);
            }

            return listofdeals;
        }

        public List<GenerateAutomationDataContract> GetDealListForAutomation(string type)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            List<GenerateAutomationDataContract> listofdeals = new List<GenerateAutomationDataContract>();

            SqlParameter p1 = new SqlParameter { ParameterName = "@type", Value = type };

            dt = hp.ExecDataTable("dbo.usp_GetDealListForAutomation", p1);
            foreach (DataRow dr in dt.Rows)
            {
                GenerateAutomationDataContract gad = new GenerateAutomationDataContract();
                gad.DealID = Convert.ToString(dr["DealID"]);
                gad.StatusText = "Processing";

                if (type == "AutoSpread_UnderwritingDataChanged")
                {
                    gad.AutomationType = 789;
                    gad.BatchType = "AutoSpread_UnderwritingDataChanged";
                }
                else if (type == "All_AutoSpread_Deals")
                {
                    gad.AutomationType = 799;
                    gad.BatchType = "All_AutoSpread_Deals";
                }
                else if (type == "FundingMoveToNextMonth")
                {
                    gad.AutomationType = 800;
                    gad.BatchType = "FundingMoveToNextMonth";
                }
                else if (type == "AmortizationAutoWire")
                {
                    gad.AutomationType = 801;
                    gad.BatchType = "AmortizationAutoWire";
                }
                else if (type == "FundingMoveTo15Businessdays")
                {
                    gad.AutomationType = 839;
                    gad.BatchType = "FundingMoveTo15Businessdays";
                }
                else if (type == "FundingMoveTo1BusinessdaysWF")
                {
                    gad.AutomationType = 851;
                    gad.BatchType = "FundingMoveTo1BusinessdaysWF";
                }
                else if (type == "LiabilityCalculation")
                {
                    gad.AutomationType = 853;
                    gad.BatchType = "LiabilityCalculation";
                }
                listofdeals.Add(gad);
            }

            return listofdeals;

        }

        public DataTable GetAutomationRequestsForEmail(string BatchType)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@BatchType", Value = BatchType };
            dt = hp.ExecDataTable("dbo.usp_GetAutomationRequestsForEmail", p1);

            return dt;

        }
        public DataTable GetAutomationRequestsAutoSpreadDealsForEmail(string BatchType)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@BatchType", Value = BatchType };
            dt = hp.ExecDataTable("dbo.usp_GetAutomationRequestsAutoSpreadDealsForEmail", p1);
            return dt;
        }

        public DataTable GetAutomationRequestsDataForEmailByBatchType(string BatchType)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@BatchType", Value = BatchType };
            dt = hp.ExecDataTable("dbo.usp_GetAutomationRequestsDataForEmailByBatchType", p1);

            return dt;
        }
        public void UpdateAutomationRequestsSentEmailToY(string BatchType)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@BatchType", Value = BatchType };
            hp.ExecNonquery("dbo.usp_UpdateAutomationRequestsSentEmailToY", p1);

        }
        public void InsertIntoAutomationExtension(int? AutomationRequestsID, string DealID, int? BatchID, string ErrorMessage, string Message, string CreatedBy, string DealFundingID, string PurposeType, decimal? Amount, DateTime? Date)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@AutomationRequestsID", Value = AutomationRequestsID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = new Guid(DealID) };
            SqlParameter p3 = new SqlParameter { ParameterName = "@BatchID", Value = BatchID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@ErrorMessage", Value = ErrorMessage };
            SqlParameter p5 = new SqlParameter { ParameterName = "@Message", Value = Message };
            SqlParameter p6 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };

            SqlParameter p7 = new SqlParameter { ParameterName = "@PurposeType", Value = PurposeType };
            SqlParameter p8 = new SqlParameter { ParameterName = "@Amount", Value = Amount };
            SqlParameter p9 = new SqlParameter { ParameterName = "@Date", Value = Date };
            SqlParameter p10 = new SqlParameter { ParameterName = "@DealFundingID", Value = DealFundingID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10 };
            hp.ExecNonquery("dbo.usp_InsertIntoAutomationExtension", sqlparam);

        }

        public DataTable GetDealListForAutomation()
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            try
            {
                dt = hp.ExecDataTable("dbo.usp_GetDealListForAutomation_UI");
                return dt;
            }
            catch (Exception ex)
            {

                throw;
            }

        }
        public int CancelAutomation()
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                return hp.ExecNonquery("dbo.usp_CancelAutomationDeal");
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public DataTable QueueDealForCalcualationAfterDealSaveAutomation()
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                return hp.ExecDataTable("dbo.usp_QueueDealForCalcualationAfterDealSaveAutomation");
            }
            catch (Exception ex)
            {
                throw;
            }

        }
        public void UpdateDealSentForCalculationToYes()
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                hp.ExecNonquery("dbo.usp_UpdateDealSentForCalculationToYes");
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public DataTable GetAutomationAuditLog(int? pageIndex, int? pageSize, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@PgeIndex", Value = pageIndex };
                SqlParameter p2 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
                SqlParameter p3 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };

                dt = hp.ExecDataTable("dbo.usp_GetDealAutomationAuditLog", sqlparam);
                TotalCount = string.IsNullOrEmpty(Convert.ToString(p3.Value)) ? 0 : CommonHelper.ToInt32(p3.Value);
                // dt = hp.ExecDataTable("dbo.usp_GetDealAutomationAuditLog");

            }
            catch (Exception ex)
            {
                throw;
            }
            return dt;
        }
        public DataTable GetDealByBatchIDAutomation(int BatchID)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@BatchID", Value = BatchID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                return hp.ExecDataTable("dbo.usp_GetDealByBatchIDAutomation", sqlparam);

            }
            catch (Exception ex)
            {
                throw;
            }

        }
        public int DeleteAutomationlog(int BatchID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@BatchID", Value = BatchID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                return hp.ExecNonquery("dbo.usp_DeleteAutomationlogByBatchID", sqlparam);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public DataTable GetAutomationRequestsAutoForDownloadExcel(int BatchID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@BatchID", Value = BatchID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                return hp.ExecDataTable("dbo.usp_GetAutomationRequestsAutoForDownloadExcel", sqlparam);
            }
            catch (Exception ex)
            {
                throw;
            }

        }
        public DataTable GetFundingDrawByBusinessday(int NextBDNumber)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NextBDNumber", Value = NextBDNumber };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                return hp.ExecDataTable("dbo.usp_GetFundingDrawByBusinessday", sqlparam);
            }
            catch (Exception ex)
            {
                throw;
            }

        }

        public DataTable GetFundingDrawByOneBusinessdayWF(int NextBDNumber)
        {
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NextBDNumber", Value = NextBDNumber };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                return hp.ExecDataTable("dbo.usp_GetFundingDrawByBusinessdayWF", sqlparam);
            }
            catch (Exception ex)
            {
                throw;
            }

        }

        public DataTable GetFundingDrawByOneBusinessdayBackDate(int NextBDNumber)
        {
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NextBDNumber", Value = NextBDNumber };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                return hp.ExecDataTable("dbo.usp_GetFundingDrawByBusinessdayWF_BackDate", sqlparam);
            }
            catch (Exception ex)
            {
                throw;
            }

        }


        public DataTable GetDiscrepancyForAdjCommitmentM61VsBackshop()
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                return hp.ExecDataTable("dbo.usp_GetDiscrepancyForAdjCommitmentM61VsBackshop_Automation");
            }
            catch (Exception ex)
            {
                throw;
            }

        }
        public DataTable GetDiscrepancyForCommitmentDataByDealID(string DealID)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetDiscrepancyForCommitmentData", sqlparam);
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetDiscrepancyForCommitmentData()
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("dbo.usp_GetDiscrepancyForCommitmentData");
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void QueueSingleDealForAutomation(string DealID, int? AutomationType, string CreatedBy, string BatchType, int? BatchID)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@AutomationType", Value = AutomationType };
            SqlParameter p3 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
            SqlParameter p4 = new SqlParameter { ParameterName = "@BatchType", Value = BatchType };
            SqlParameter p5 = new SqlParameter { ParameterName = "@BatchID", Value = BatchID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, };
            hp.ExecNonquery("dbo.usp_QueueSingleDealForAutomation", sqlparam);

        }

    }
}
