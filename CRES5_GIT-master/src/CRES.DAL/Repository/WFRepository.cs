
using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using CRES.DataContract.WorkFlow;
using Microsoft.Extensions.Configuration;
using System.IO;

namespace CRES.DAL.Repository
{
    public class WFRepository 
    {
       

        SqlConnection connection = new SqlConnection();
        public WFDetailDataContract GetWorkflowDetailByTaskId(WFDetailDataContract wfDetailDataContract, string UserID)
        {


            DataTable dt = new DataTable();
            WFDetailDataContract _wfDetailDataContract = new WFDetailDataContract();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@TaskTypeID", Value = wfDetailDataContract.TaskTypeID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@TaskID", Value = wfDetailDataContract.TaskID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3};
            dt = hp.ExecDataTable("dbo.usp_GetWorkflowDetailByTaskId", sqlparam);

            // var wfList = dbContext.usp_GetWorkflowDetailByTaskId(TaskID, UserID);

            foreach (DataRow dr in dt.Rows)
            {
                _wfDetailDataContract.WFTaskDetailId = CommonHelper.ToInt32(dr["WFTaskDetailID"]);
                _wfDetailDataContract.TaskID = Convert.ToString(dr["TaskID"]);
                _wfDetailDataContract.TaskTypeID = CommonHelper.ToInt32(dr["TaskTypeID"]); 
                _wfDetailDataContract.SubmitType = CommonHelper.ToInt32(dr["SubmitType"]); 
                _wfDetailDataContract.Comment = Convert.ToString(dr["Comment"]); 
                _wfDetailDataContract.WFStatusPurposeMappingID = CommonHelper.ToInt32(dr["WFStatusPurposeMappingID"]); 

                _wfDetailDataContract.PurposeTypeId = CommonHelper.ToInt32(dr["PurposeTypeId"]); 
                _wfDetailDataContract.OrderIndex = CommonHelper.ToInt32(dr["OrderIndex"]); 
                _wfDetailDataContract.WFStatusMasterID = CommonHelper.ToInt32(dr["WFStatusMasterID"]); 
                _wfDetailDataContract.StatusName = Convert.ToString(dr["StatusName"]); 
				_wfDetailDataContract.StatusDisplayName =Convert.ToString(dr["StatusDisplayName"]);
                _wfDetailDataContract.TaskTypeIDText = Convert.ToString(dr["TaskTypeIDText"]); 
                _wfDetailDataContract.SubmitTypeText = Convert.ToString(dr["SubmitTypeText"]); 
                _wfDetailDataContract.NextWFStatusPurposeMappingID = CommonHelper.ToInt32(dr["NextWFStatusPurposeMappingID"]);
                _wfDetailDataContract.NextWFStatusMasterID = CommonHelper.ToInt32(dr["NextWFStatusMasterID"]);
                _wfDetailDataContract.NextStatusName = Convert.ToString(dr["NextStatusName"]); 
                _wfDetailDataContract.NextOrderIndex = CommonHelper.ToInt32(dr["NextOrderIndex"]); 
                _wfDetailDataContract.wfFlag = Convert.ToString(dr["wfFlag"]); 
                _wfDetailDataContract.wf_isAllow = Convert.ToInt32(dr["wf_isAllow"]);
                _wfDetailDataContract.NextStatusDisplayName = Convert.ToString(dr["NextStatusDisplayName"]);
                _wfDetailDataContract.wf_isAllowReject = Convert.ToInt32(dr["wf_isAllowReject"]);
                _wfDetailDataContract.WorkFlowType = Convert.ToString(dr["WorkFlowType"]);
                _wfDetailDataContract.IsDisableFundingTeamApproval = Convert.ToInt32(dr["IsDisableFundingTeamApproval"]);
                _wfDetailDataContract.IsOnlyPrimaryUser = Convert.ToInt32(dr["IsOnlyPrimaryUser"]);
                _wfDetailDataContract.DealID = Convert.ToString(dr["DealID"]);
                _wfDetailDataContract.OriginalWFStatusPurposeMappingID = CommonHelper.ToInt32(dr["OriginalWFStatusPurposeMappingID"]);
                _wfDetailDataContract.AmOversightMsg = Convert.ToString(dr["AmOversightMsg"]);
            }

            if (_wfDetailDataContract.TaskID == null)
            {
                _wfDetailDataContract = null;
            }

            return _wfDetailDataContract;
        }


        public WFAdditionalDataContarct GetWorkflowAdditionalDetailByTaskId(WFDetailDataContract wfDetailDataContract, string UserID)
        {

            DataTable dt = new DataTable();
            WFAdditionalDataContarct _wfAdditionalDataContarct = new WFAdditionalDataContarct();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@TaskTypeID", Value = wfDetailDataContract.TaskTypeID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@TaskID", Value = wfDetailDataContract.TaskID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3 };
            dt = hp.ExecDataTable("dbo.usp_GetWorkflowAdditionalDetailByTaskId", sqlparam);
           // var wfList = dbContext.usp_GetWorkflowAdditionalDetailByTaskId(TaskID, UserID);
            foreach (DataRow dr in dt.Rows)
            {
                _wfAdditionalDataContarct.WFTaskDetailID = CommonHelper.ToInt32(dr["WFTaskDetailID"]);
                _wfAdditionalDataContarct.TaskID = Convert.ToString(dr["TaskID"]);
                _wfAdditionalDataContarct.Date = CommonHelper.ToDateTime(dr["Date"]);
                _wfAdditionalDataContarct.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                _wfAdditionalDataContarct.PurposeID = CommonHelper.ToInt32(dr["PurposeID"]); 
                _wfAdditionalDataContarct.PurposeIDText = Convert.ToString(dr["PurposeIDText"]); 
                _wfAdditionalDataContarct.Applied = CommonHelper.ToBoolean(dr["Applied"]);
                _wfAdditionalDataContarct.Comment = Convert.ToString(dr["Comment"]); 
                _wfAdditionalDataContarct.DrawFundingID = Convert.ToString(dr["DrawFundingID"]); 
                _wfAdditionalDataContarct.DealName = Convert.ToString(dr["dealname"]); 
                _wfAdditionalDataContarct.CREDealID = Convert.ToString(dr["CREDealID"]); 
                _wfAdditionalDataContarct.BoxDocumentLink = Convert.ToString(dr["BoxDocumentLink"]); 
                _wfAdditionalDataContarct.DeadLineDate = CommonHelper.ToDateTime(dr["DeadLineDate"]); 
                _wfAdditionalDataContarct.IsPreliminaryNotification = Convert.ToBoolean(dr["IsPreliminaryNotification"]);
                _wfAdditionalDataContarct.IsRevisedPreliminaryNotification = Convert.ToBoolean(dr["IsRevisedPreliminaryNotification"]);
                _wfAdditionalDataContarct.IsFinalNotification = Convert.ToBoolean(dr["IsFinalNotification"]);
                _wfAdditionalDataContarct.IsRevisedFinalNotification = Convert.ToBoolean(dr["IsRevisedFinalNotification"]);
                _wfAdditionalDataContarct.IsServicerNotification = Convert.ToBoolean(dr["IsServicerNotification"]);
                _wfAdditionalDataContarct.IsRevisedServicerNotification = Convert.ToBoolean(dr["IsRevisedServicerNotification"]);
                _wfAdditionalDataContarct.CreatedByName = Convert.ToString(dr["CreatedByName"]); 
                _wfAdditionalDataContarct.AMEmails = Convert.ToString(dr["AMEmails"]).Trim().Trim(',');
                _wfAdditionalDataContarct.AdditionalComments = Convert.ToString(dr["AdditionalComment"]);
                _wfAdditionalDataContarct.SpecialInstructions = Convert.ToString(dr["SpecialInstruction"]);
                _wfAdditionalDataContarct.SeniorCreNoteID = Convert.ToString(dr["SeniorCreNoteID"]);
                _wfAdditionalDataContarct.SeniorServicerName = Convert.ToString(dr["SeniorServicerName"]);
                _wfAdditionalDataContarct.RequiredEquity = Convert.ToDecimal(dr["RequiredEquity"]);
                _wfAdditionalDataContarct.AdditionalEquity = Convert.ToDecimal(dr["AdditionalEquity"]);
                _wfAdditionalDataContarct.AssetManager = Convert.ToString(dr["AssetManager"]);
                _wfAdditionalDataContarct.AMTeamLeadUser = Convert.ToString(dr["AMTeamLeadUser"]);
                _wfAdditionalDataContarct.AMSecondUser = Convert.ToString(dr["AMSecondUser"]);
                _wfAdditionalDataContarct.BaseCurrencyName = Convert.ToString(dt.Rows[0]["BaseCurrencyName"]);
                _wfAdditionalDataContarct.ServicerName = Convert.ToString(dt.Rows[0]["ServicerName"]);
                _wfAdditionalDataContarct.IsREODeal = dr["IsREODeal"] == DBNull.Value?false:Convert.ToBoolean(dr["IsREODeal"]);
                _wfAdditionalDataContarct.IsFinalNotificationPayOff = Convert.ToBoolean(dr["IsFinalNotificationPayOff"]);
                _wfAdditionalDataContarct.IsRevisedFinalNotificationPayOff = Convert.ToBoolean(dr["IsRevisedFinalNotificationPayOff"]);
                _wfAdditionalDataContarct.ExitFee = CommonHelper.ToDecimal(dr["ExitFee"]);
                _wfAdditionalDataContarct.ExitFeePercentage = CommonHelper.ToDecimal(dr["ExitFeePercentage"]);
                _wfAdditionalDataContarct.PrepayPremium = CommonHelper.ToDecimal(dr["PrepayPremium"]);
                _wfAdditionalDataContarct.PropertyManagerEmail = Convert.ToString(dr["PropertyManagerEmail"]);
                _wfAdditionalDataContarct.AccountingEmail = Convert.ToString(dr["AccountingEmail"]);
                _wfAdditionalDataContarct.LastPrelimSentDate = CommonHelper.ToDateTime(dr["LastPrelimSentDate"]);
                _wfAdditionalDataContarct.IsCancelFinalSent = Convert.ToBoolean(dr["IsCancelFinalSent"]);
                _wfAdditionalDataContarct.AdditionalGroupEmail = Convert.ToString(dr["AdditionalGroupEmail"]);
                _wfAdditionalDataContarct.RevisedMessage = Convert.ToString(dr["RevisedMessage"]);
                _wfAdditionalDataContarct.AdditionalEmail = Convert.ToString(dr["AdditionalEmail"]);
                _wfAdditionalDataContarct.NotesWithFinancingSourceNone = Convert.ToString(dr["NotesWithFinancingSourceNone"]);
                _wfAdditionalDataContarct.AMEmailsWithoutWellsBerkadia = Convert.ToString(dr["AMEmailsWithoutWellsBerkadia"]);
                _wfAdditionalDataContarct.WatchlistStatus = Convert.ToString(dr["WatchlistStatus"]);
                _wfAdditionalDataContarct.TotalPendingInvoice = Convert.ToInt32(dr["TotalPendingInvoice"]);
                _wfAdditionalDataContarct.TotalPendingInvoiceAmt = Convert.ToDecimal(dr["TotalPendingInvoiceAmt"]);
                _wfAdditionalDataContarct.IsPrelimDisabled = Convert.ToBoolean(dr["IsPrelimDisabled"]);
                _wfAdditionalDataContarct.CREDealIDWithREO = Convert.ToString(dr["CREDealIDWithREO"]);
            }

            if (_wfAdditionalDataContarct.TaskID == null)
            {
                _wfAdditionalDataContarct = null;
            }

            return _wfAdditionalDataContarct;
        }


        public List<WFStatusDataContract> GetStatusMasterByTaskId(WFDetailDataContract wfDetailDataContract, string UserID)
        {

            DataTable dt = new DataTable();
            List<WFStatusDataContract> _lstwfStatus = new List<WFStatusDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@TaskTypeID", Value = wfDetailDataContract.TaskTypeID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@TaskID", Value = wfDetailDataContract.TaskID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3 };
            dt = hp.ExecDataTable("dbo.usp_GetStatusMasterByTaskId", sqlparam);
            //var wfList = dbContext.usp_GetStatusMasterByTaskId(TaskID, UserID);

            foreach (DataRow dr in dt.Rows)
            {
                WFStatusDataContract _wfStatus = new WFStatusDataContract();
                _wfStatus.TaskID = Convert.ToString(dr["TaskID"]);
                _wfStatus.OrderIndex = CommonHelper.ToInt32(dr["OrderIndex"]);
                _wfStatus.WFStatusMasterID = CommonHelper.ToInt32(dr["WFStatusMasterID"]);
                _wfStatus.StatusName = Convert.ToString(dr["StatusName"]); 
                _wfStatus.StatusDisplayName = Convert.ToString(dr["StatusDisplayName"]); 
                _wfStatus.WFStatusPurposeMappingID = Convert.ToInt32(dr["WFStatusPurposeMappingID"]);
                _lstwfStatus.Add(_wfStatus);
            }

            if (_lstwfStatus.Count == 0)
            {
                _lstwfStatus = null;
            }

            return _lstwfStatus;
        }


        public List<WFCheckListDataContract> GetCheckListByTaskId(WFDetailDataContract wfDetailDataContract, string UserID)
        {

            DataTable dt = new DataTable();
            List<WFCheckListDataContract> _lstwfCheckListDataContract = new List<WFCheckListDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@TaskTypeID", Value = wfDetailDataContract.TaskTypeID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@TaskID", Value = wfDetailDataContract.TaskID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3 };
            dt = hp.ExecDataTable("dbo.usp_GetCheckListByTaskId", sqlparam);
            //var wfList = dbContext.usp_GetCheckListByTaskId(TaskID, UserID);

            foreach (DataRow dr in dt.Rows)
            {
                WFCheckListDataContract _wfCheckListDataContract = new WFCheckListDataContract();
                _wfCheckListDataContract.WFTaskDetailID = Convert.ToInt32(dr["WFTaskDetailID"]);
                _wfCheckListDataContract.TaskID = Convert.ToString(dr["TaskID"]);
                _wfCheckListDataContract.WFCheckListDetailID = dr["WFCheckListDetailID"];
                _wfCheckListDataContract.CheckListMasterId = CommonHelper.ToInt32(dr["WFCheckListMasterID"]); 
                _wfCheckListDataContract.CheckListName = Convert.ToString(dr["CheckListName"]); 
                _wfCheckListDataContract.CheckListStatus = CommonHelper.ToInt32(dr["CheckListStatus"]); 
                _wfCheckListDataContract.CheckListStatusText = Convert.ToString(dr["CheckListStatusText"]); 
                _wfCheckListDataContract.Comment = Convert.ToString(dr["Comment"]);
                _wfCheckListDataContract.IsMandatory = CommonHelper.ToBoolean(dr["IsMandatory"]) ;
                if (_wfCheckListDataContract.CheckListMasterId == 6 || _wfCheckListDataContract.CheckListMasterId == 9 
                    || _wfCheckListDataContract.CheckListMasterId == 18 || _wfCheckListDataContract.CheckListMasterId == 15
                    || _wfCheckListDataContract.CheckListMasterId == 16 || _wfCheckListDataContract.CheckListMasterId == 17
                    )
                {
                    _wfCheckListDataContract.RowId = 2;
                }
                else if (_wfCheckListDataContract.CheckListMasterId == 19)
                {
                    _wfCheckListDataContract.RowId = 3;
                }
                else if (_wfCheckListDataContract.CheckListMasterId == 21)
                {
                    _wfCheckListDataContract.RowId = 4;
                }

                else
                {
                    _wfCheckListDataContract.RowId = 1;
                }

                _lstwfCheckListDataContract.Add(_wfCheckListDataContract);
            }

            if (_lstwfCheckListDataContract.Count == 0)
            {
                _lstwfCheckListDataContract = null;
            }

            return _lstwfCheckListDataContract;
        }

        public string InsertWorkflowDetailForTaskId(WFDetailDataContract _wfDetailDataContract)
        {
            string result = "success";
            try
            {
                DataTable dtCheckList = new DataTable();
                dtCheckList.Columns.Add("WFCheckListDetailID");
                dtCheckList.Columns.Add("TaskId");
                dtCheckList.Columns.Add("WFCheckListMasterID");
                dtCheckList.Columns.Add("CheckListName");
                dtCheckList.Columns.Add("CheckListStatus");
                dtCheckList.Columns.Add("Comment");

                if (_wfDetailDataContract.WFCheckList != null)
                {
                    DataTable dt = new DataTable();
                    dt = ObjToDataTable.ToDataTable(_wfDetailDataContract.WFCheckList);

                    foreach (DataRow dr in dt.Rows)
                    {
                        dtCheckList.ImportRow(dr);
                    }
                }

                if (dtCheckList.Rows.Count > 0)
                {

                    connection.ConnectionString = GetConnectionString();

                    DataTable resultDT = new DataTable();
                    SqlCommand dbCmd = new SqlCommand("usp_InsertWorkflowDetailForTaskId", connection);
                    dbCmd.CommandType = CommandType.StoredProcedure;

                    dbCmd.Parameters.AddWithValue("TaskID", _wfDetailDataContract.TaskID);
                    dbCmd.Parameters.AddWithValue("WFStatusPurposeMappingID", _wfDetailDataContract.WFStatusPurposeMappingID);
                    dbCmd.Parameters.AddWithValue("TaskTypeID", _wfDetailDataContract.TaskTypeID);
                    dbCmd.Parameters.AddWithValue("Comment", _wfDetailDataContract.Comment);
                    dbCmd.Parameters.AddWithValue("SubmitType", _wfDetailDataContract.SubmitType);
                    dbCmd.Parameters.AddWithValue("CreatedBy", _wfDetailDataContract.CreatedBy);
                    //dbCmd.Parameters.AddWithValue("CreatedDate", _wfDetailDataContract.CreatedDate);
                    dbCmd.Parameters.AddWithValue("AdditionalComments", _wfDetailDataContract.AdditionalComments);
                    dbCmd.Parameters.AddWithValue("SpecialInstructions", _wfDetailDataContract.SpecialInstructions);
                    dbCmd.Parameters.AddWithValue("DelegatedUserID", _wfDetailDataContract.DelegatedUserID);
                    dbCmd.Parameters.AddWithValue("CheckListDetail", dtCheckList);

                    connection.Open();
                    dbCmd.ExecuteNonQuery();
                    connection.Close();

                }
            }
            catch (Exception ex)
            {
                connection.Close();
                result = ex.Message;
            }
            return result;

        }

        public List<WorkflowListDataContract> GetAllWorkflow(Guid? userId, int? PageSize, int? PageIndex, out int? TotalCount)
        {
            List<DateTime> lst = new List<DateTime>();
            DateTime dt1 = DateTime.Now;
            lst.Add(dt1);
            DataTable dt = new DataTable();

            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
           
            List<WorkflowListDataContract> lstWFDC = new List<WorkflowListDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@PgeIndex", Value = PageIndex };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageSize", Value = PageSize };
            SqlParameter p4 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            dt = hp.ExecDataTable("dbo.usp_GetAllWorkflowDetail", sqlparam);

            // var lstWorkflow = dbContext.usp_GetAllWorkflowDetail(userId, PageIndex, PageSize, totalCount).ToList();
             TotalCount = Convert.ToInt32(p4.Value.ToString() == "" ? 0 : p4.Value);

            foreach (DataRow dr in dt.Rows)
            {
                WorkflowListDataContract _wfDC = new WorkflowListDataContract();


                _wfDC.WFTaskDetailID =Convert.ToInt32(dr["WFTaskDetailID"]);
                _wfDC.TaskID = Convert.ToString(dr["TaskID"]);
                _wfDC.TaskTypeID = CommonHelper.ToInt32(dr["TaskTypeID"]); 
                _wfDC.SubmitType = CommonHelper.ToInt32(dr["SubmitType"]); 
                _wfDC.WorkFlowComment = Convert.ToString(dr["WorkFlowComment"]); 
                _wfDC.StatusName = Convert.ToString(dr["StatusName"]); 


                _wfDC.CREDealID = Convert.ToString(dr["CREDealID"]); 
                _wfDC.DealName = Convert.ToString(dr["DealName"]); 

                _wfDC.Deadline = CommonHelper.ToDateTime(dr["Deadline"]);
                _wfDC.Fundingdate = CommonHelper.ToDateTime(dr["Fundingdate"]);

                _wfDC.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                _wfDC.Username = Convert.ToString(dr["Username"]); 

                lstWFDC.Add(_wfDC);
            }
            return lstWFDC;
        }

        public List<WorkflowListDataContract> GetAllWorkflowByFiltertype(Guid? userId, string filterType, string CREDealID, int? PageSize, int? PageIndex, out int? TotalCount)
        {
            List<DateTime> lst = new List<DateTime>();
            DateTime dt1 = DateTime.Now;
            lst.Add(dt1);
            DataTable dt = new DataTable();
            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));

            List<WorkflowListDataContract> lstWFDC = new List<WorkflowListDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@FilterType", Value = filterType };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = PageIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = PageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter p6 = new SqlParameter { ParameterName = "@CREDealID", Value = CREDealID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };
            dt = hp.ExecDataTable("dbo.usp_GetAllWorkflowDetailByFiltertype", sqlparam);

            // var lstWorkflow = dbContext.usp_GetAllWorkflowDetailByFiltertype(userId, filterType, PageIndex, PageSize, totalCount).ToList();
            // TotalCount = Convert.ToInt32(p5.Value.ToString() == "" ? 0 : p5.Value);
            // TotalCount = lstWorkflow.Count();
            // foreach (usp_GetAllWorkflowDetailByFiltertype_Result _workflow in lstWorkflow)
            TotalCount = dt.Rows.Count;
            foreach (DataRow dr in dt.Rows)
            {
                WorkflowListDataContract _wfDC = new WorkflowListDataContract();


                _wfDC.WFTaskDetailID = Convert.ToInt32(dr["WFTaskDetailID"]);
                _wfDC.TaskID = Convert.ToString(dr["TaskID"]);
                _wfDC.TaskTypeID = CommonHelper.ToInt32(dr["TaskTypeID"]);
                _wfDC.SubmitType = CommonHelper.ToInt32(dr["SubmitType"]);
                _wfDC.WorkFlowComment = Convert.ToString(dr["WorkFlowComment"]);
                _wfDC.StatusName = Convert.ToString(dr["StatusName"]);


                _wfDC.CREDealID = Convert.ToString(dr["CREDealID"]);
                _wfDC.DealName = Convert.ToString(dr["DealName"]);

                _wfDC.Deadline = CommonHelper.ToDateTime(dr["Deadline"]);
                _wfDC.Fundingdate = CommonHelper.ToDateTime(dr["Fundingdate"]);

                _wfDC.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                _wfDC.Username = Convert.ToString(dr["Username"]);

                _wfDC.PurposeID = CommonHelper.ToInt32(dr["PurposeID"]);
                _wfDC.PurposeIDText = Convert.ToString(dr["PurposeIDText"]);
                _wfDC.FundingApprovalRequired = Convert.ToString(dr["FundingApprovalRequired"]);
                _wfDC.PAMUsername = Convert.ToString(dr["PAMUsername"]);
                _wfDC.AMOUsername = Convert.ToString(dr["AMOUsername"]);
                _wfDC.UserID = CommonHelper.ToGuid(dr["UserID"]);
                lstWFDC.Add(_wfDC);
            }
            return lstWFDC;
        }


        public List<WFNotificationDataContract> GetWorkflowNotificationDetailByTaskId(string ObjectID, int ObjectTypeId, string UserID)
        {

            List<WFNotificationDataContract> lstWorkflowNotification = new List<WFNotificationDataContract>();
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectID", Value = ObjectID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ObjectTypeId", Value = ObjectTypeId };
                SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                DataTable dt = hp.ExecDataTable("dbo.usp_GetWorkflowNotificationDetailByTaskId", sqlparam);

                lstWorkflowNotification = dt.DataTableToList<WFNotificationDataContract>();

                return lstWorkflowNotification;


            }
            catch (Exception ex)
            {

            }
            return lstWorkflowNotification;
        }


        public List<WFDetailDataContract> GetWFCommentsByTaskId(WFDetailDataContract wfDetailDataContract, string UserID)
        {

            DataTable dt = new DataTable();
            List<WFDetailDataContract> _wfDetailDataContract = new List<WFDetailDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@TaskID", Value = wfDetailDataContract.TaskID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@TaskTypeID", Value = wfDetailDataContract.TaskTypeID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3 };
            dt = hp.ExecDataTable("dbo.usp_GetWFCommentsByTaskId", sqlparam);

            //var wfList = dbContext.usp_GetWFCommentsByTaskId(TaskID, UserID);
            
            foreach (DataRow dr in dt.Rows)
            {
                WFDetailDataContract _wfDC = new WFDetailDataContract();

                _wfDC.WFTaskDetailId = CommonHelper.ToInt32(dr["WFTaskDetailID"]);
                _wfDC.TaskID = Convert.ToString(dr["TaskID"]);
                _wfDC.Login = Convert.ToString(dr["Login"]);
                _wfDC.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                _wfDC.StatusName = Convert.ToString(dr["StatusName"]);
                _wfDC.Comment = Convert.ToString(dr["Comment"]);

                _wfDC.WFStatusPurposeMappingID = CommonHelper.ToInt32(dr["WFStatusPurposeMappingID"]);
                _wfDC.PurposeTypeId = CommonHelper.ToInt32(dr["PurposeTypeId"]);
                _wfDC.OrderIndex = CommonHelper.ToInt32(dr["OrderIndex"]);
                _wfDC.WFStatusMasterID = CommonHelper.ToInt32(dr["WFStatusMasterID"]);
                _wfDC.SubmitType = CommonHelper.ToInt32(dr["SubmitType"]);
                _wfDC.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                _wfDC.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                _wfDC.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);

                _wfDC.UColor = Convert.ToString(dr["UColor"]);
                _wfDC.CommentedByFirstLetter = Convert.ToString(dr["CommentedByFirstLetter"]);
                _wfDC.DelegatedUserName = Convert.ToString(dr["DelegatedUserName"]);
                _wfDC.Abbreviation = Convert.ToString(dr["Abbreviation"]);


                _wfDetailDataContract.Add(_wfDC);
            }

            if (_wfDetailDataContract.Count == 0)
            {
                _wfDetailDataContract = null;
            }

            return _wfDetailDataContract;
        }

        public List<WFNotificationConfigDataContract> GetWFNotificationConfigByNotificationType(WFNotificationMasterDataContract DCNotificationMaster)
        {

            DataTable dt = new DataTable();
            List<WFNotificationConfigDataContract> _wfNotificationDataContract = new List<WFNotificationConfigDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@WFNotificationMasterID", Value = DCNotificationMaster.WFNotificationMasterID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(DCNotificationMaster.CreatedBy) };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("CRE.usp_GetWFNotificationConfigByNotificationType", sqlparam);

           // var wfList = dbContext.usp_GetWFNotificationConfigByNotificationType(DCNotificationMaster.WFNotificationMasterID, new Guid(DCNotificationMaster.CreatedBy));

            foreach (DataRow dr in dt.Rows)
            {
                WFNotificationConfigDataContract _wfNDC = new WFNotificationConfigDataContract();


                _wfNDC.WFNotificationConfigID = Convert.ToInt32(dr["WFNotificationConfigID"]);
                    if (Convert.ToString(dr["WFNotificationConfigGuID"]) != "")
                     {
                    _wfNDC.WFNotificationConfigGuID = new Guid(Convert.ToString(dr["WFNotificationConfigGuID"]));
                     }

                _wfNDC.Name = Convert.ToString(dr["Name"]);
                _wfNDC.WFNotificationMasterID = Convert.ToInt32(dr["WFNotificationMasterID"]);
                _wfNDC.TemplateID = CommonHelper.ToInt32(dr["TemplateID"]);
                _wfNDC.TemplateFileName = Convert.ToString(dr["TemplateFileName"]);
                _wfNDC.CanChangeBody = CommonHelper.ToBoolean(dr["CanChangeBody"]);
                _wfNDC.CanChangeFooter = CommonHelper.ToBoolean(dr["CanChangeFooter"]);
                _wfNDC.CanChangeHeader = CommonHelper.ToBoolean(dr["CanChangeHeader"]);
                _wfNDC.CanChangeRecipientList = CommonHelper.ToBoolean(dr["CanChangeRecipientList"]);
                _wfNDC.CanChangeReplyTo = CommonHelper.ToBoolean(dr["CanChangeReplyTo"]);
                _wfNDC.CanChangeSchedule = CommonHelper.ToBoolean(dr["CanChangeSchedule"]);
                _wfNDC.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                _wfNDC.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                _wfNDC.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                _wfNDC.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);



            _wfNotificationDataContract.Add(_wfNDC);
        }

            if (_wfNotificationDataContract.Count == 0)
            {
                _wfNotificationDataContract = null;
            }

            return _wfNotificationDataContract;
        }

        public string InsertUpdateWFNotification(WFNotificationDetailDataContract _wfDetailDataContract, string UserID)
        {
            string result = "success";
            try
            {
                DataTable dtCheckList = new DataTable();
                dtCheckList.Columns.Add("WFCheckListDetailID");
                dtCheckList.Columns.Add("TaskId");
                dtCheckList.Columns.Add("WFCheckListMasterID");
                dtCheckList.Columns.Add("CheckListName");
                dtCheckList.Columns.Add("CheckListStatus");

                dtCheckList.Columns.Add("Comment");


                if (_wfDetailDataContract.WFCheckList != null)
                {
                    DataTable dt = new DataTable();
                    dt = ObjToDataTable.ToDataTable(_wfDetailDataContract.WFCheckList);

                    foreach (DataRow dr in dt.Rows)
                    {
                        dtCheckList.ImportRow(dr);
                    }
                }

                if (dtCheckList.Rows.Count > 0)
                {

                    connection.ConnectionString = GetConnectionString();

                    DataTable resultDT = new DataTable();
                    SqlCommand dbCmd = new SqlCommand("CRE.usp_InsertUpdateWFNotification", connection);
                    dbCmd.CommandType = CommandType.StoredProcedure;
                    dbCmd.Parameters.AddWithValue("WFNotificationMasterID", _wfDetailDataContract.WFNotificationMasterID);
                    dbCmd.Parameters.AddWithValue("TaskTypeID", _wfDetailDataContract.TaskTypeID);
                    dbCmd.Parameters.AddWithValue("TaskID", _wfDetailDataContract.TaskID);
                    dbCmd.Parameters.AddWithValue("MessageHTML", _wfDetailDataContract.MessageHTML.CheckDBNull());
                    dbCmd.Parameters.AddWithValue("AdditionalText", _wfDetailDataContract.AdditionalText.CheckDBNull());
                    dbCmd.Parameters.AddWithValue("ScheduledDateTime", _wfDetailDataContract.ScheduledDateTime.CheckDBNull());
                    dbCmd.Parameters.AddWithValue("ActionType", _wfDetailDataContract.ActionType);
                    dbCmd.Parameters.AddWithValue("UserID", UserID);
                    //dbCmd.Parameters.AddWithValue("CreatedDate", _wfDetailDataContract.CreatedDate);
                    dbCmd.Parameters.AddWithValue("EmailTo", _wfDetailDataContract.EmailToIds);
                    dbCmd.Parameters.AddWithValue("EmailCC", _wfDetailDataContract.EmailCCIds);
                    dbCmd.Parameters.AddWithValue("AdditionalComments", _wfDetailDataContract.AdditionalComments.CheckDBNull());
                    dbCmd.Parameters.AddWithValue("SpecialInstructions", _wfDetailDataContract.SpecialInstructions.CheckDBNull());
                    dbCmd.Parameters.AddWithValue("DelegatedUserID", _wfDetailDataContract.DelegatedUserID.CheckDBNull());
                    dbCmd.Parameters.AddWithValue("CheckListDetail", dtCheckList);
                    connection.Open();
                    dbCmd.ExecuteNonQuery();
                    connection.Close();

                }
            }
            catch (Exception ex)
            {
                connection.Close();
                result = ex.Message;
            }
            return result;
        }


        public List<WFTemplateRecipientDataContract> GetTemplateRecipientEmailIDs(WFNotificationMasterDataContract DCNotificationMaster)
        {

            DataTable dt = new DataTable();
            List<WFTemplateRecipientDataContract> _wfNotificationDataContract = new List<WFTemplateRecipientDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@WFNotificationMasterID", Value = DCNotificationMaster.WFNotificationMasterID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("CRE.usp_GetWFTemplateRecipientEmailIDs", sqlparam);
            //var wfList = dbContext.usp_GetWFTemplateRecipientEmailIDs(DCNotificationMaster.WFNotificationMasterID);
            foreach (DataRow dr in dt.Rows)
            {

                _wfNotificationDataContract.Add(new WFTemplateRecipientDataContract
                {
                    TO = Convert.ToString(dr["To"]),
                    CC = Convert.ToString(dr["CC"]),
                    WFTemplateID = CommonHelper.ToInt32(dr["WFTemplateID"]),
                    ReplyTo = Convert.ToString(dr["ReplyTo"]),
                    WFNotificationMasterID = Convert.ToInt32(dr["WFNotificationMasterID"])
                });

            }
            return _wfNotificationDataContract;
        }

        public List<ClientDataContract> GetClientByDealFundingID(Guid DealFundingID, string UserID)
        {

            DataTable dt = new DataTable();
            List<ClientDataContract> _lstClient = new List<ClientDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealFundingID", Value = DealFundingID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetClientByDealFundingID", sqlparam);
            //var wfList = dbContext.usp_GetClientByDealFundingID(DealFundingID, UserID);

            foreach (DataRow dr in dt.Rows)
            {
                _lstClient.Add(new ClientDataContract
                {
                    ClientID = Convert.ToInt32(dr["ClientID"]),
                    ClientName = Convert.ToString(dr["ClientName"]),
                    ClientsName = Convert.ToString(dr["ClientsName"]),
                    EmailID = Convert.ToString(dr["EmailID"]),
                    EmailIDs = Convert.ToString(dr["EmailIDs"])
                });
            }

            if (_lstClient.Count == 0)
            {
                _lstClient = null;
            }

            return _lstClient;
        }

        public List<ClientDataContract> GetWFNotificationMasterEmail(WFDetailDataContract wfDetailDataContract, string UserID)
        {
            DataTable dt = new DataTable();
            List<ClientDataContract> _lstClient = new List<ClientDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@TaskTypeID", Value = wfDetailDataContract.TaskTypeID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@DealFundingID", Value = new Guid(wfDetailDataContract.TaskID) };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3 };
            dt = hp.ExecDataTable("CRE.usp_GetWFNotificationMasterEmail", sqlparam);
            // var wfList = dbContext.usp_GetWFNotificationMasterEmail(DealFundingID, UserID);

            foreach (DataRow dr in dt.Rows)
            {
                _lstClient.Add(new ClientDataContract
                {
                    ClientID = Convert.ToInt32(dr["ClientID"]),
                    ClientName = Convert.ToString(dr["ClientName"]),
                    ClientsName = Convert.ToString(dr["ClientsName"]),
                    EmailID = Convert.ToString(dr["EmailID"]),
                    EmailIDs = Convert.ToString(dr["EmailIDs"]),
                    LookupID = CommonHelper.ToInt32(dr["lookupID"]),
                    ClientFunding = Convert.ToString(dr["ClientFunding"]),
                    DealClients = Convert.ToString(dr["DealClients"])
                });
            }

            if (_lstClient.Count == 0)
            {
                _lstClient = null;
            }

            return _lstClient;
        }


        public DataTable GetConsolidatWFEmailNotification()
        {
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = hp.ExecDataTable("dbo.usp_GetConsolidatWFEmailNotification");
            return dt;
        }

        public List<WFRejectListDataContract> GetWFRejectStatusByTaskId(WFDetailDataContract wfDetailDataContract, string UserID)
        {

            List<WFRejectListDataContract> _lstwfStatus = new List<WFRejectListDataContract>();


            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@TaskID", Value = wfDetailDataContract.TaskID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@TaskTypeID", Value = wfDetailDataContract.TaskTypeID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3 };
                dt = hp.ExecDataTable("usp_GetWFRejectStatusByTaskId", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        WFRejectListDataContract _wfStatus = new WFRejectListDataContract();
                        _wfStatus.StatusName = Convert.ToString(dr["StatusName"]);
                        _wfStatus.StatusDisplayName = Convert.ToString(dr["StatusDisplayName"]);
                        _wfStatus.WFStatusPurposeMappingID = Convert.ToInt32(dr["WFStatusPurposeMappingID"]);
                        _lstwfStatus.Add(_wfStatus);
                    }
                }
                if (_lstwfStatus.Count == 0)
                {
                    _lstwfStatus = null;
                }
            }
            catch (Exception ex)
            {

            }

            return _lstwfStatus;
        }
        public WFDetailDataContract CheckWFConcurrentUpdate(Guid? TaskID, DateTime dtWFUpdateDate, DateTime dtWFAdditionalUpdateDate)
        {

            DataTable dt = new DataTable();
            WFDetailDataContract wfdt = new WFDetailDataContract();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@TaskID", Value = TaskID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@WFUpdatedDate", Value = dtWFUpdateDate };
                SqlParameter p3 = new SqlParameter { ParameterName = "@WFAdditionalUpdatedDate", Value = dtWFAdditionalUpdateDate };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dt = hp.ExecDataTable("usp_CheckWFConcurrentUpdate", sqlparam);


                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        wfdt.LastUpdated = Convert.ToDateTime(dr["UpdatedDate"]);
                        wfdt.LastUpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return wfdt;
        }

        public int ValidateWireConfirmByTaskId(WFDetailDataContract _wfDetailDataContract, string UserID)
        {
            DataTable dt = new DataTable();
            int StatusCode = 0;
            WFDetailDataContract wfdt = new WFDetailDataContract();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@TaskID", Value = _wfDetailDataContract.TaskID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };

                dt = hp.ExecDataTable("usp_ValidateWireConfirmByTaskId", sqlparam);

                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                        StatusCode = Convert.ToInt32(dt.Rows[0]["StatusCode"]);
                }

            }
            catch (Exception ex)
            {

            }

            return StatusCode;
        }
        public List<WFStatusPurposeMappingDataContract> GetWFStatusPurposeMapping(Guid? userid)
        {
            DataTable dt = new DataTable();
            List<WFStatusPurposeMappingDataContract> statuspurposemapping = new List<WFStatusPurposeMappingDataContract>();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("usp_GetWFStatusPurposeMapping", sqlparam);
                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        WFStatusPurposeMappingDataContract _statuspurmap = new WFStatusPurposeMappingDataContract();
                        _statuspurmap.WFStatusPurposeMappingID = Convert.ToInt32(dr["WFStatusPurposeMappingID"]);
                        _statuspurmap.WFStatusMasterID = CommonHelper.ToInt32(dr["WFStatusMasterID"]);
                        _statuspurmap.PurposeTypeId = CommonHelper.ToInt32(dr["PurposeTypeId"]);
                        _statuspurmap.OrderIndex = CommonHelper.ToInt32(dr["OrderIndex"]);
                        _statuspurmap.IsEnable = CommonHelper.ToBoolean(dr["IsEnable"]);
                        _statuspurmap.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        _statuspurmap.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                        _statuspurmap.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        _statuspurmap.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                        _statuspurmap.PurposeTypeText = Convert.ToString(dr["PurposeTypeText"]);
                        _statuspurmap.AutospreadValueText = Convert.ToString(dr["AutospreadValueText"]);
                        _statuspurmap.WFValueText = Convert.ToString(dr["WFValueText"]);

                        statuspurposemapping.Add(_statuspurmap);
                    }

                }
            }
            catch (Exception ex)
            {

            }

            return statuspurposemapping;

        }


        public DataTable GetAllForceFunding()
        {
            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();
            dt = hp.ExecDataTable("dbo.usp_GetAllForceFunding");
            return dt;
        }



        public List<WFNotificationDataContract> GetForceFundingNotificationByTaskID(string Taskid)
        {

            List<WFNotificationDataContract> lstWorkflowNotification = new List<WFNotificationDataContract>();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@TaskID", Value = Taskid };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                DataTable dt = hp.ExecDataTable("dbo.usp_GetForceFundingNotificationByTaskID", sqlparam);

                lstWorkflowNotification = dt.DataTableToList<WFNotificationDataContract>();

                return lstWorkflowNotification;


            }
            catch (Exception ex)
            {

            }
            return lstWorkflowNotification;

        }

            public string GetConnectionString()
        {

            IConfigurationBuilder builder = new ConfigurationBuilder();
            builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
            var root = builder.Build();
            return root.GetSection("Application").GetSection("ConnectionStrings").Value;
                //connstring = "Data Source = 192.168.1.250; Initial Catalog = CRES4_QA; user id=admin;password=admin1*";
        }

        public DrawFeeInvoiceDataContract GetDrawFeeInvoiceDetailByTaskID(string TaskID, string UserID)
        {

            DataTable dt = new DataTable();
            DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@TaskID", Value = TaskID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("usp_GetInvoiceDetailByTaskID", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt.DrawFeeInvoiceDetailID = Convert.ToInt32(dr["InvoiceDetailID"]);
                        drawdt.TaskID = new Guid(dr["TaskID"].ToString());
                        drawdt.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                        drawdt.FirstName = Convert.ToString(dr["FirstName"]);
                        drawdt.LastName = Convert.ToString(dr["LastName"]);
                        drawdt.Designation = Convert.ToString(dr["Designation"]);
                        drawdt.CompanyName = Convert.ToString(dr["CompanyName"]);
                        drawdt.Address = Convert.ToString(dr["Address"]);
                        drawdt.City = Convert.ToString(dr["City"]);
                        drawdt.State = Convert.ToString(dr["State"]);
                        drawdt.Zip = Convert.ToString(dr["Zip"]);
                        drawdt.Email1 = Convert.ToString(dr["Email1"]);
                        drawdt.Email2 = Convert.ToString(dr["Email2"]);
                        drawdt.PhoneNo = Convert.ToString(dr["PhoneNo"]);
                        drawdt.AlternatePhone = Convert.ToString(dr["AlternatePhone"]);
                        drawdt.Comment = Convert.ToString(dr["Comment"]);
                        drawdt.AutoSendInvoice = Convert.ToInt32(dr["AutoSendInvoice"]);
                        drawdt.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        drawdt.CreatedDate = Convert.ToDateTime(dr["CreatedDate"]);
                        drawdt.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        drawdt.UpdatedDate = Convert.ToDateTime(dr["UpdatedDate"]);
                        drawdt.FileName = Convert.ToString(dr["FileName"]);
                        drawdt.InvoiceNo = Convert.ToString(dr["InvoiceNo"]);
                        drawdt.DrawFeeStatus = Convert.ToInt32(dr["DrawFeeStatus"]);
                        drawdt.DrawFeeStatusText = Convert.ToString(dr["DrawFeeStatusText"]);
                        drawdt.StateID = Convert.ToInt32(dr["StateID"]);
                        drawdt.InvoiceNoUI = Convert.ToString(dr["SystemInvoiceNo"]);
                        drawdt.AMEmails = Convert.ToString(dr["AMEmails"]);
                        drawdt.SenderFirstName = Convert.ToString(dr["SenderFirstName"]);
                        drawdt.SenderLastName = Convert.ToString(dr["SenderLastName"]);
                        drawdt.SenderEmail = Convert.ToString(dr["SenderEmail"]);
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return drawdt;
        }

        public string InsertUpdateDrawFeeInvoiceDetail(string UserID, DrawFeeInvoiceDataContract drawFeeDC)
        {
            string result = "success";
            DataTable dt = new DataTable();
            DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@XMLDrawFeeInvoice", Value = drawFeeDC.ToXML().Replace(" xsi:nil=\"true\"", "") };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("usp_InsertUpdateInvoiceDetail", sqlparam);

            }
            catch (Exception ex)
            {
                result = ex.Message;
            }

            return result;
        }
        public int InsertUpdateInvoice(string UserID, DrawFeeInvoiceDataContract drawFeeDC)
        {
            int ID = 0;
            DataTable dt = new DataTable();
            DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@XMLDrawFeeInvoice", Value = drawFeeDC.ToXML().Replace(" xsi:nil=\"true\"", "") };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("usp_InsertUpdateInvoice", sqlparam);
                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        ID = Convert.ToInt32(dr["InvoiceDetailID"]);
                    }
                }
            }
            catch (Exception ex)
            {
                ID = 0;
            }

            return ID;
        }
        public DataTable GetWorkFlowStatus()
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("usp_GetWorkFlowStatus");
            return dt;
        }
        

        

        public string UpdateDrawFeeInvoiceDetailStatus(string UserID, DrawFeeInvoiceDataContract drawFeeDC)
        {
            string result = "success";
            DataTable dt = new DataTable();
            DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@InvoiceDetailID", Value = drawFeeDC.DrawFeeInvoiceDetailID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@DrawFeeStatus", Value = drawFeeDC.DrawFeeStatus };
                SqlParameter p4 = new SqlParameter { ParameterName = "@FileName", Value = drawFeeDC.FileName };
                SqlParameter p5 = new SqlParameter { ParameterName = "@InvoiceNumber", Value = drawFeeDC.InvoiceNo };
                SqlParameter p6 = new SqlParameter { ParameterName = "@AmountPaid", Value = drawFeeDC.AmountPaid };
                SqlParameter p7 = new SqlParameter { ParameterName = "@PaymentDate", Value = drawFeeDC.PaymentDate==DateTime.MinValue? null: drawFeeDC.PaymentDate };
                SqlParameter p8 = new SqlParameter { ParameterName = "@InvoiceGuid", Value = drawFeeDC.InvoiceGuid };
                SqlParameter p9 = new SqlParameter { ParameterName = "@PreAssignedInvoiceNo", Value = drawFeeDC.PreAssignedInvoiceNo };
                SqlParameter p10 = new SqlParameter { ParameterName = "@IsLogActivity", Value = drawFeeDC.IsLogActivity };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3,p4,p5,p6,p7,p8,p9,p10};
                //SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3,p4,p5,p6,p7,p8};
                dt = hp.ExecDataTable("usp_UpdateInvoiceDetailStatus", sqlparam);
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }

            return result;
        }

        public List<DrawFeeInvoiceDataContract> GetAllPendingInvoice(string UserID)
        {

            DataTable dt = new DataTable();
            List<DrawFeeInvoiceDataContract> lstdraw = new List<DrawFeeInvoiceDataContract>();
            DrawFeeInvoiceDataContract drawdt = null;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1};
                dt = hp.ExecDataTable("usp_GetAllPendingInvoice", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt = new DrawFeeInvoiceDataContract();
                        drawdt.DrawFeeInvoiceDetailID = Convert.ToInt32(dr["InvoiceDetailID"]);
                        drawdt.InvoiceNo = Convert.ToString(dr["InvoiceNo"]);
                        drawdt.TaskID = new Guid(dr["TaskID"].ToString());
                        drawdt.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                        drawdt.FirstName = Convert.ToString(dr["FirstName"]);
                        drawdt.LastName = Convert.ToString(dr["LastName"]);
                        drawdt.Designation = Convert.ToString(dr["Designation"]);
                        drawdt.CompanyName = Convert.ToString(dr["CompanyName"]);
                        drawdt.Address = Convert.ToString(dr["Address"]);
                        drawdt.City = Convert.ToString(dr["City"]);
                        drawdt.State = Convert.ToString(dr["State"]);
                        drawdt.Zip = Convert.ToString(dr["Zip"]);
                        drawdt.Email1 = Convert.ToString(dr["Email1"]);
                        drawdt.Email2 = Convert.ToString(dr["Email2"]);
                        drawdt.PhoneNo = Convert.ToString(dr["PhoneNo"]);
                        drawdt.AlternatePhone = Convert.ToString(dr["AlternatePhone"]);
                        drawdt.Comment = Convert.ToString(dr["Comment"]);
                        drawdt.AutoSendInvoice = Convert.ToInt32(dr["AutoSendInvoice"]);
                        drawdt.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        drawdt.CreatedDate = Convert.ToDateTime(dr["CreatedDate"]);
                        drawdt.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        drawdt.UpdatedDate = Convert.ToDateTime(dr["UpdatedDate"]);
                        drawdt.DrawFeeStatus = Convert.ToInt32(dr["DrawFeeStatus"]);
                        drawdt.PreAssignedInvoiceNo = Convert.ToString(dr["PreAssignedInvoiceNo"]);
                        drawdt.InvoiceGuid = Convert.ToString(dr["InvoiceGuid"]);
                        lstdraw.Add(drawdt);
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return lstdraw;
        }

        public List<DrawFeeInvoiceDataContract> UpdateAndGetAllInvoiceQueued(string UserID)
        {

            DataTable dt = new DataTable();
            List<DrawFeeInvoiceDataContract> lstdraw = new List<DrawFeeInvoiceDataContract>();
            DrawFeeInvoiceDataContract drawdt = null;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("usp_UpdateAndGetAllInvoiceQueued", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt = new DrawFeeInvoiceDataContract();
                        drawdt.DrawFeeInvoiceDetailID = Convert.ToInt32(dr["InvoiceDetailID"]);
                        drawdt.InvoiceNo = Convert.ToString(dr["InvoiceNo"]);
                        drawdt.TaskID = new Guid(dr["TaskID"].ToString());
                        drawdt.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                        drawdt.FirstName = Convert.ToString(dr["FirstName"]);
                        drawdt.LastName = Convert.ToString(dr["LastName"]);
                        drawdt.Designation = Convert.ToString(dr["Designation"]);
                        drawdt.CompanyName = Convert.ToString(dr["CompanyName"]);
                        drawdt.Address = Convert.ToString(dr["Address"]);
                        drawdt.City = Convert.ToString(dr["City"]);
                        drawdt.State = Convert.ToString(dr["State"]);
                        drawdt.Zip = Convert.ToString(dr["Zip"]);
                        drawdt.Email1 = Convert.ToString(dr["Email1"]);
                        drawdt.Email2 = Convert.ToString(dr["Email2"]);
                        drawdt.PhoneNo = Convert.ToString(dr["PhoneNo"]);
                        drawdt.AlternatePhone = Convert.ToString(dr["AlternatePhone"]);
                        drawdt.Comment = Convert.ToString(dr["Comment"]);
                        drawdt.AutoSendInvoice = Convert.ToInt32(dr["AutoSendInvoice"]);
                        drawdt.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        drawdt.CreatedDate = Convert.ToDateTime(dr["CreatedDate"]);
                        drawdt.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        drawdt.UpdatedDate = Convert.ToDateTime(dr["UpdatedDate"]);
                        drawdt.FileName = Convert.ToString(dr["FileName"]);
                        drawdt.FundingDate = Convert.ToDateTime(dr["Date"]);
                        drawdt.InvoiceNoUI = Convert.ToString(dr["InvoiceNoUI"]);
                        drawdt.CreDealID = Convert.ToString(dr["CreDealID"]);
                        drawdt.DealName = Convert.ToString(dr["DealName"]);
                        drawdt.InvoiceCode = Convert.ToString(dr["InvoiceCode"]);
                        drawdt.DrawNo = Convert.ToString(dr["DrawNo"]);
                        drawdt.TemplateName = Convert.ToString(dr["TemplateName"]);
                        drawdt.AMEmails = Convert.ToString(dr["AMEmails"]);
                        drawdt.SenderFirstName = Convert.ToString(dr["SenderFirstName"]);
                        drawdt.SenderLastName = Convert.ToString(dr["SenderLastName"]);
                        drawdt.SenderEmail = Convert.ToString(dr["SenderEmail"]);
                        drawdt.FundingAmount= CommonHelper.ToDecimal(dr["FundingAmount"]);
                        drawdt.InvoiceTypeID= Convert.ToInt32(dr["InvoiceTypeID"]);
                        drawdt.IsManualInvoice= Convert.ToBoolean(dr["IsManualInvoice"]);
                        lstdraw.Add(drawdt);
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return lstdraw;
        }

      
        public DataTable GetAllFeeInvoice(Guid? userId, string DealID, int? PageSize, int? PageIndex, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = PageIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = PageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@totalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4,p5 };
            dt = hp.ExecDataTable("dbo.usp_GetAllFeeInvoice", sqlparam);

            // var lstWorkflow = dbContext.usp_GetAllWorkflowDetail(userId, PageIndex, PageSize, totalCount).ToList();
            TotalCount = Convert.ToInt32(p5.Value.ToString() == "" ? 0 : p4.Value);
            return dt;
        }


        

       public DrawFeeInvoiceDataContract CheckQBDCompanyCustomer(DrawFeeInvoiceDataContract drawFeeDC)
        { //
            DataTable dt = new DataTable();
            DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();
           
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@CustomerAccountName", Value = drawFeeDC.DealName };
                SqlParameter p2 = new SqlParameter { ParameterName = "@CompanyName", Value = drawFeeDC.CompanyName };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2};
                dt = hp.ExecDataTable("usp_CheckQBDCompanyCustomer", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt.IsExistCustomer = Convert.ToInt32(dr["IsExistCustomer"])==1;
                        drawdt.IsExistCompany = Convert.ToInt32(dr["IsExistCompany"])==1;
                        drawdt.ID = Convert.ToString(dr["ID"]);
                }
                }
            return drawdt;
        }


        public string AddUpdateQBDCustomer(string UserID,QBDCustomerInputDataContract QbdCustomer)
        {
            string result = "success";
            try
            {
                DataTable dt = new DataTable();
                DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ID", Value = QbdCustomer.ID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@CustomerAccountName", Value = QbdCustomer.FullName };
                SqlParameter p4 = new SqlParameter { ParameterName = "@CustomerNo", Value = QbdCustomer.CustomerNo };
                SqlParameter p5 = new SqlParameter { ParameterName = "@ContactID", Value = QbdCustomer.ContactID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3,p4,p5};
                hp.ExecNonquery("usp_InsertUpdateQBDCustomer", sqlparam);
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }
            return result;
        }

        public QBDCompanyDataContract GetQuickBookCompany(string UserID,QBDCompanyDataContract qbdCompany)
        {
            DataTable dt = new DataTable();
            QBDCompanyDataContract comp = new QBDCompanyDataContract();

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@QuickBookCompanyID", Value = qbdCompany.QuickBookCompanyID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@Name", Value = qbdCompany.Name };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            dt = hp.ExecDataTable("usp_GetQuickBookCompany", sqlparam);

            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    comp.QuickBookCompanyID = Convert.ToInt32(dr["IsExistCustomer"]);
                    comp.Name = Convert.ToString(dr["Name"]);
                    comp.EndPointID = Convert.ToString(dr["EndPointID"]);
                    comp.AutofyCompanyID = Convert.ToString(dr["AutofyCompanyID"]);
                    comp.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                    comp.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                    comp.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                    comp.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
                }
            }
            //
            return comp;
        }

        public DataTable GetAllStatesMaster(string UserID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();
               
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetAllStatesMaster", sqlparam);
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable SaveFeeInvoices(DataTable dtFeeInvoice,string UserID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();

                SqlParameter p1 = new SqlParameter { ParameterName = "@TableTypeFeeInvoice", Value = dtFeeInvoice };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1,p2 };
                dt = hp.ExecDataTable("dbo.usp_SaveFeeInvoice", sqlparam);
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public List<DrawFeeInvoiceDataContract> GetMissingQBDCustomer()
        {

            DataTable dt = new DataTable();
            List<DrawFeeInvoiceDataContract> lstDrawDc = new List<DrawFeeInvoiceDataContract>();
            DrawFeeInvoiceDataContract drawdt = null;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter[] sqlparam = new SqlParameter[] {};
                dt = hp.ExecDataTable("usp_GetMissingQBDCustomer", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt = new DrawFeeInvoiceDataContract();
                        drawdt.DrawFeeInvoiceDetailID = Convert.ToInt32(dr["InvoiceDetailID"]);
                        drawdt.TaskID = new Guid(dr["TaskID"].ToString());
                        drawdt.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                        drawdt.FirstName = Convert.ToString(dr["FirstName"]);
                        drawdt.LastName = Convert.ToString(dr["LastName"]);
                        drawdt.Designation = Convert.ToString(dr["Designation"]);
                        drawdt.CompanyName = Convert.ToString(dr["CompanyName"]);
                        drawdt.Address = Convert.ToString(dr["Address"]);
                        drawdt.City = Convert.ToString(dr["City"]);
                        drawdt.State = Convert.ToString(dr["State"]);
                        drawdt.Zip = Convert.ToString(dr["Zip"]);
                        drawdt.Email1 = Convert.ToString(dr["Email1"]);
                        drawdt.Email2 = Convert.ToString(dr["Email2"]);
                        drawdt.PhoneNo = Convert.ToString(dr["PhoneNo"]);
                        drawdt.AlternatePhone = Convert.ToString(dr["AlternatePhone"]);
                        drawdt.Comment = Convert.ToString(dr["Comment"]);
                        drawdt.AutoSendInvoice = Convert.ToInt32(dr["AutoSendInvoice"]);
                        drawdt.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        drawdt.CreatedDate = Convert.ToDateTime(dr["CreatedDate"]);
                        drawdt.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        drawdt.UpdatedDate = Convert.ToDateTime(dr["UpdatedDate"]);
                        drawdt.FileName = Convert.ToString(dr["FileName"]);
                        drawdt.InvoiceNo = Convert.ToString(dr["InvoiceNo"]);
                        drawdt.DrawFeeStatus = Convert.ToInt32(dr["DrawFeeStatus"]);
                        drawdt.StateID = Convert.ToInt32(dr["StateID"]);
                        drawdt.InvoiceNoUI = Convert.ToString(dr["SystemInvoiceNo"]);
                        drawdt.DealName = Convert.ToString(dr["DealName"]);
                        drawdt.CreDealID = Convert.ToString(dr["CreDealID"]);
                        lstDrawDc.Add(drawdt);
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return lstDrawDc;
        }

        public List<DrawFeeInvoiceDataContract> GeAllInvoicedMissingPDF(string UserID)
        {

            DataTable dt = new DataTable();
            List<DrawFeeInvoiceDataContract> lstdraw = new List<DrawFeeInvoiceDataContract>();
            DrawFeeInvoiceDataContract drawdt = null;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("usp_GeAllInvoicedMissingPDF", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt = new DrawFeeInvoiceDataContract();
                        drawdt.DrawFeeInvoiceDetailID = Convert.ToInt32(dr["InvoiceDetailID"]);
                        drawdt.InvoiceNo = Convert.ToString(dr["InvoiceNo"]);
                        drawdt.TaskID = new Guid(dr["TaskID"].ToString());
                        drawdt.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                        drawdt.FirstName = Convert.ToString(dr["FirstName"]);
                        drawdt.LastName = Convert.ToString(dr["LastName"]);
                        drawdt.Designation = Convert.ToString(dr["Designation"]);
                        drawdt.CompanyName = Convert.ToString(dr["CompanyName"]);
                        drawdt.Address = Convert.ToString(dr["Address"]);
                        drawdt.City = Convert.ToString(dr["City"]);
                        drawdt.State = Convert.ToString(dr["State"]);
                        drawdt.Zip = Convert.ToString(dr["Zip"]);
                        drawdt.Email1 = Convert.ToString(dr["Email1"]);
                        drawdt.Email2 = Convert.ToString(dr["Email2"]);
                        drawdt.PhoneNo = Convert.ToString(dr["PhoneNo"]);
                        drawdt.AlternatePhone = Convert.ToString(dr["AlternatePhone"]);
                        drawdt.Comment = Convert.ToString(dr["Comment"]);
                        drawdt.AutoSendInvoice = Convert.ToInt32(dr["AutoSendInvoice"]);
                        drawdt.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        drawdt.CreatedDate = Convert.ToDateTime(dr["CreatedDate"]);
                        drawdt.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        drawdt.UpdatedDate = Convert.ToDateTime(dr["UpdatedDate"]);
                        drawdt.FileName = Convert.ToString(dr["FileName"]);
                        drawdt.FundingDate = Convert.ToDateTime(dr["Date"]);
                        drawdt.InvoiceNoUI = Convert.ToString(dr["InvoiceNoUI"]);
                        drawdt.CreDealID = Convert.ToString(dr["CreDealID"]);
                        drawdt.DealName = Convert.ToString(dr["DealName"]);
                        drawdt.InvoiceCode = Convert.ToString(dr["InvoiceCode"]);
                        drawdt.DrawNo = Convert.ToString(dr["DrawNo"]);
                        drawdt.TemplateName = Convert.ToString(dr["TemplateName"]);
                        drawdt.AMEmails = Convert.ToString(dr["AMEmails"]);
                        drawdt.SenderFirstName = Convert.ToString(dr["SenderFirstName"]);
                        drawdt.SenderLastName = Convert.ToString(dr["SenderLastName"]);
                        drawdt.SenderEmail = Convert.ToString(dr["SenderEmail"]);
                        drawdt.FundingAmount = CommonHelper.ToDecimal(dr["FundingAmount"]);

                        lstdraw.Add(drawdt);
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return lstdraw;
        }


        public DrawFeeInvoiceDataContract GetDealPrimaryAM(int InvoiceDetailID, string UserID)
        {
            DataTable dt = new DataTable();
            DrawFeeInvoiceDataContract drawDC = new DrawFeeInvoiceDataContract();

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@InvoiceDetailID", Value = InvoiceDetailID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2};
            dt = hp.ExecDataTable("usp_GetDealPrimaryAM", sqlparam);
            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    drawDC.SenderFirstName = Convert.ToString(dr["SenderFirstName"]);
                    drawDC.SenderLastName = Convert.ToString(dr["SenderLastName"]);
                    drawDC.SenderEmail = Convert.ToString(dr["SenderEmail"]);
                }
            }
            //
            return drawDC;
        }

        public InvoiceConfigDataContract GetInvoiceConfigByInvoiceType(int InvoiceTypeID, string UserID)
        {
            DataTable dt = new DataTable();
            InvoiceConfigDataContract invoiceDC = new InvoiceConfigDataContract();

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@InvoiceTypeID", Value = InvoiceTypeID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("usp_GetInvoiceConfigByInvoiceType", sqlparam);
            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    invoiceDC.InvoiceConfigID= Convert.ToInt32(dr["InvoiceConfigID"]);
                    invoiceDC.InvoiceTypeID = Convert.ToInt32(dr["InvoiceTypeID"]);
                    invoiceDC.InvoiceCode = Convert.ToString(dr["InvoiceCode"]);
                    invoiceDC.Template = Convert.ToString(dr["Template"]);
                    invoiceDC.IsApplySplit = Convert.ToBoolean(dr["IsApplySplit"]);
                    invoiceDC.InvoiceAccountNo = Convert.ToString(dr["InvoiceAccountNo"]);
                }
            }
            //
            return invoiceDC;
        }

        public List<ReserveAccountDataContract> GetReserveScheduleBreakDown(WFDetailDataContract wfDetailDataContract, string UserID)
        {

            DataTable dt = new DataTable();
            List<ReserveAccountDataContract> _wfDetailDataContract = new List<ReserveAccountDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@DealReserveScheduleGUID", Value = wfDetailDataContract.TaskID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetReserveScheduleBreakDown", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                ReserveAccountDataContract _wfDC = new ReserveAccountDataContract();

                _wfDC.ReserveAccountName = Convert.ToString(dr["ReserveAccountName"]);
                _wfDC.CurrentBalance = Convert.ToDecimal(dr["CurrentBalance"]);
                _wfDC.RequestAmount = Convert.ToDecimal(dr["RequestAmount"]);
                _wfDC.NewBalance = Convert.ToDecimal(dr["NewBalance"]);
                _wfDetailDataContract.Add(_wfDC);
            }

            if (_wfDetailDataContract.Count == 0)
            {
                _wfDetailDataContract = null;
            }

            return _wfDetailDataContract;
        }

        public int? InsertInvoiceDetailByBatchUpload(string UserID, List<DrawFeeInvoiceBatchUploadDataContract> drawFeeDC)
        {
            string result = "success";
            DataTable dt = new DataTable();
            int? batchid = 0;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@XMLDrawFeeInvoice", Value = drawFeeDC.ToXML().Replace(" xsi:nil=\"true\"", "") };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("usp_InsertInvoiceDetailByBatchUploadInLanding", sqlparam);

                if (dt != null)
                {
                    batchid = CommonHelper.ToInt32(dt.Rows[0].ItemArray[0]);
                }

            }
            catch (Exception ex)
            {
                result = ex.Message;
            }

            return batchid;
        }
        public List<DrawFeeInvoiceDataContract> GetAllBatchInvoice(string UserID)
        {

            DataTable dt = new DataTable();
            List<DrawFeeInvoiceDataContract> lstdraw = new List<DrawFeeInvoiceDataContract>();
            DrawFeeInvoiceDataContract drawdt = null;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("usp_GetAllBatchInvoice", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt = new DrawFeeInvoiceDataContract();
                        drawdt.DrawFeeInvoiceDetailID = Convert.ToInt32(dr["InvoiceDetailID"]);
                        drawdt.InvoiceNo = Convert.ToString(dr["InvoiceNo"]);
                        drawdt.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                        drawdt.FirstName = Convert.ToString(dr["FirstName"]);
                        drawdt.LastName = Convert.ToString(dr["LastName"]);
                        drawdt.Designation = Convert.ToString(dr["Designation"]);
                        drawdt.CompanyName = Convert.ToString(dr["CompanyName"]);
                        drawdt.Address = Convert.ToString(dr["Address"]);
                        drawdt.City = Convert.ToString(dr["City"]);
                        drawdt.State = Convert.ToString(dr["State"]);
                        drawdt.Zip = Convert.ToString(dr["Zip"]);
                        drawdt.Email1 = Convert.ToString(dr["Email1"]);
                        drawdt.Email2 = Convert.ToString(dr["Email2"]);
                        drawdt.PhoneNo = Convert.ToString(dr["PhoneNo"]);
                        drawdt.AlternatePhone = Convert.ToString(dr["AlternatePhone"]);
                        drawdt.Comment = Convert.ToString(dr["Comment"]);
                        drawdt.AutoSendInvoice = Convert.ToInt32(dr["AutoSendInvoice"]);
                        drawdt.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        drawdt.CreatedDate = Convert.ToDateTime(dr["CreatedDate"]);
                        drawdt.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        drawdt.UpdatedDate = Convert.ToDateTime(dr["UpdatedDate"]);
                        drawdt.FileName = Convert.ToString(dr["FileName"]);
                        drawdt.InvoiceNoUI = Convert.ToString(dr["InvoiceNoUI"]);
                        drawdt.CreDealID = Convert.ToString(dr["CreDealID"]);
                        drawdt.DealName = Convert.ToString(dr["DealName"]);
                        drawdt.InvoiceCode = Convert.ToString(dr["InvoiceCode"]);
                        drawdt.DrawNo = Convert.ToString(dr["DrawNo"]);
                        drawdt.TemplateName = Convert.ToString(dr["TemplateName"]);
                        drawdt.AMEmails = Convert.ToString(dr["AMEmails"]);
                        drawdt.SenderFirstName = Convert.ToString(dr["SenderFirstName"]);
                        drawdt.SenderLastName = Convert.ToString(dr["SenderLastName"]);
                        drawdt.SenderEmail = Convert.ToString(dr["SenderEmail"]);
                        drawdt.FundingAmount = CommonHelper.ToDecimal(dr["FundingAmount"]);
                        drawdt.InvoiceDate = Convert.ToDateTime(dr["InvoiceDate"]);
                        drawdt.InvoiceDateOriginal = Convert.ToDateTime(dr["InvoiceDateOriginal"]);
                        drawdt.InvoiceDueDate = Convert.ToDateTime(dr["InvoiceDueDate"]);
                        drawdt.CurrentDate = Convert.ToDateTime(dr["CurrentDate"]);
                        drawdt.InvoiceTypeID = Convert.ToInt32(dr["InvoiceTypeID"]);
                        drawdt.InvoiceTypeName = Convert.ToString(dr["InvoiceTypeName"]);
                        lstdraw.Add(drawdt);
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return lstdraw;
        }
        public DrawFeeInvoiceDataContract GetInvoiceDetailByObjectTypeID(int ObjectTypeID, string @ObjectID,string UserID)
        {

            DataTable dt = new DataTable();
            DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectTypeID", Value = ObjectTypeID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ObjectID", Value = @ObjectID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dt = hp.ExecDataTable("usp_GetInvoiceDetailByObjectTypeID", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt.DrawFeeInvoiceDetailID = Convert.ToInt32(dr["InvoiceDetailID"]);
                        drawdt.TaskID = new Guid(dr["TaskID"].ToString());
                        drawdt.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                        drawdt.FirstName = Convert.ToString(dr["FirstName"]);
                        drawdt.LastName = Convert.ToString(dr["LastName"]);
                        drawdt.Designation = Convert.ToString(dr["Designation"]);
                        drawdt.CompanyName = Convert.ToString(dr["CompanyName"]);
                        drawdt.Address = Convert.ToString(dr["Address"]);
                        drawdt.City = Convert.ToString(dr["City"]);
                        drawdt.State = Convert.ToString(dr["State"]);
                        drawdt.Zip = Convert.ToString(dr["Zip"]);
                        drawdt.Email1 = Convert.ToString(dr["Email1"]);
                        drawdt.Email2 = Convert.ToString(dr["Email2"]);
                        drawdt.PhoneNo = Convert.ToString(dr["PhoneNo"]);
                        drawdt.AlternatePhone = Convert.ToString(dr["AlternatePhone"]);
                        drawdt.Comment = Convert.ToString(dr["Comment"]);
                        drawdt.AutoSendInvoice = Convert.ToInt32(dr["AutoSendInvoice"]);
                        drawdt.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        drawdt.CreatedDate = Convert.ToDateTime(dr["CreatedDate"]);
                        drawdt.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        drawdt.UpdatedDate = Convert.ToDateTime(dr["UpdatedDate"]);
                        drawdt.FileName = Convert.ToString(dr["FileName"]);
                        drawdt.InvoiceNo = Convert.ToString(dr["InvoiceNo"]);
                        drawdt.DrawFeeStatus = Convert.ToInt32(dr["DrawFeeStatus"]);
                        drawdt.DrawFeeStatusText = Convert.ToString(dr["DrawFeeStatusText"]);
                        drawdt.StateID = Convert.ToInt32(dr["StateID"]);
                        drawdt.InvoiceNoUI = Convert.ToString(dr["SystemInvoiceNo"]);
                        drawdt.AMEmails = Convert.ToString(dr["AMEmails"]);
                        drawdt.SenderFirstName = Convert.ToString(dr["SenderFirstName"]);
                        drawdt.SenderLastName = Convert.ToString(dr["SenderLastName"]);
                        drawdt.SenderEmail = Convert.ToString(dr["SenderEmail"]);
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return drawdt;
        }
        public List<DrawFeeInvoiceDataContract> GeAllInvoiceQueued(string UserID)
        {

            DataTable dt = new DataTable();
            List<DrawFeeInvoiceDataContract> lstdraw = new List<DrawFeeInvoiceDataContract>();
            DrawFeeInvoiceDataContract drawdt = null;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("usp_GeAllInvoiceQueued", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt = new DrawFeeInvoiceDataContract();
                        drawdt.DrawFeeInvoiceDetailID = Convert.ToInt32(dr["InvoiceDetailID"]);
                        drawdt.InvoiceNo = Convert.ToString(dr["InvoiceNo"]);
                        drawdt.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                        drawdt.FirstName = Convert.ToString(dr["FirstName"]);
                        drawdt.LastName = Convert.ToString(dr["LastName"]);
                        drawdt.Designation = Convert.ToString(dr["Designation"]);
                        drawdt.CompanyName = Convert.ToString(dr["CompanyName"]);
                        drawdt.Address = Convert.ToString(dr["Address"]);
                        drawdt.City = Convert.ToString(dr["City"]);
                        drawdt.State = Convert.ToString(dr["State"]);
                        drawdt.Zip = Convert.ToString(dr["Zip"]);
                        drawdt.Email1 = Convert.ToString(dr["Email1"]);
                        drawdt.Email2 = Convert.ToString(dr["Email2"]);
                        drawdt.PhoneNo = Convert.ToString(dr["PhoneNo"]);
                        drawdt.AlternatePhone = Convert.ToString(dr["AlternatePhone"]);
                        drawdt.Comment = Convert.ToString(dr["Comment"]);
                        drawdt.AutoSendInvoice = Convert.ToInt32(dr["AutoSendInvoice"]);
                        drawdt.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        drawdt.CreatedDate = Convert.ToDateTime(dr["CreatedDate"]);
                        drawdt.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        drawdt.UpdatedDate = Convert.ToDateTime(dr["UpdatedDate"]);
                        drawdt.FileName = Convert.ToString(dr["FileName"]);
                        drawdt.InvoiceNoUI = Convert.ToString(dr["InvoiceNoUI"]);
                        drawdt.CreDealID = Convert.ToString(dr["CreDealID"]);
                        drawdt.DealName = Convert.ToString(dr["DealName"]);
                        drawdt.InvoiceCode = Convert.ToString(dr["InvoiceCode"]);
                        drawdt.DrawNo = Convert.ToString(dr["DrawNo"]);
                        drawdt.TemplateName = Convert.ToString(dr["TemplateName"]);
                        drawdt.AMEmails = Convert.ToString(dr["AMEmails"]);
                        drawdt.SenderFirstName = Convert.ToString(dr["SenderFirstName"]);
                        drawdt.SenderLastName = Convert.ToString(dr["SenderLastName"]);
                        drawdt.SenderEmail = Convert.ToString(dr["SenderEmail"]);
                        drawdt.InvoiceTypeID = Convert.ToInt32(dr["InvoiceTypeID"]);
                        drawdt.InvoiceTypeName = Convert.ToString(dr["InvoiceTypeName"]);
                        drawdt.InvoiceDate = Convert.ToDateTime(dr["InvoiceDate"]);
                        drawdt.InvoiceDateOriginal = Convert.ToDateTime(dr["InvoiceDateOriginal"]);
                        drawdt.InvoiceDueDate = Convert.ToDateTime(dr["InvoiceDueDate"]);

                        lstdraw.Add(drawdt);
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return lstdraw;
        }
        //GetMissingQBDCustomerFromBatch
        public List<DrawFeeInvoiceDataContract> GetMissingQBDCustomerFromBatch()
        {

            DataTable dt = new DataTable();
            List<DrawFeeInvoiceDataContract> lstDrawDc = new List<DrawFeeInvoiceDataContract>();
            DrawFeeInvoiceDataContract drawdt = null;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter[] sqlparam = new SqlParameter[] { };
                dt = hp.ExecDataTable("usp_GetMissingQBDCustomerFromBatch", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt = new DrawFeeInvoiceDataContract();
                        drawdt.DrawFeeInvoiceDetailID = Convert.ToInt32(dr["InvoiceDetailID"]);
                        drawdt.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                        drawdt.FirstName = Convert.ToString(dr["FirstName"]);
                        drawdt.LastName = Convert.ToString(dr["LastName"]);
                        drawdt.Designation = Convert.ToString(dr["Designation"]);
                        drawdt.CompanyName = Convert.ToString(dr["CompanyName"]);
                        drawdt.Address = Convert.ToString(dr["Address"]);
                        drawdt.City = Convert.ToString(dr["City"]);
                        drawdt.State = Convert.ToString(dr["State"]);
                        drawdt.Zip = Convert.ToString(dr["Zip"]);
                        drawdt.Email1 = Convert.ToString(dr["Email1"]);
                        drawdt.Email2 = Convert.ToString(dr["Email2"]);
                        drawdt.PhoneNo = Convert.ToString(dr["PhoneNo"]);
                        drawdt.AlternatePhone = Convert.ToString(dr["AlternatePhone"]);
                        drawdt.Comment = Convert.ToString(dr["Comment"]);
                        drawdt.AutoSendInvoice = Convert.ToInt32(dr["AutoSendInvoice"]);
                        drawdt.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        drawdt.CreatedDate = Convert.ToDateTime(dr["CreatedDate"]);
                        drawdt.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        drawdt.UpdatedDate = Convert.ToDateTime(dr["UpdatedDate"]);
                        drawdt.FileName = Convert.ToString(dr["FileName"]);
                        drawdt.InvoiceNo = Convert.ToString(dr["InvoiceNo"]);
                        drawdt.DrawFeeStatus = Convert.ToInt32(dr["DrawFeeStatus"]);
                        drawdt.StateID = Convert.ToInt32(dr["StateID"]);
                        drawdt.InvoiceNoUI = Convert.ToString(dr["SystemInvoiceNo"]);
                        drawdt.DealName = Convert.ToString(dr["DealName"]);
                        drawdt.CreDealID = Convert.ToString(dr["CreDealID"]);
                        lstDrawDc.Add(drawdt);
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return lstDrawDc;
        }
        public string InsertUpdateWFTaskAdditionalDetail(WFTaskAdditionalDetailDataContract _wfDetailDataContract, string UserID)
        {
            string result = "success";
            DataTable dt = new DataTable();
            DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();
            try
            { 
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@XMLAdditionalInfo", Value = _wfDetailDataContract.ToXML().Replace(" xsi:nil=\"true\"", "") };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("usp_InsertUpdateWFTaskAdditionalDetail", sqlparam);

            }
            catch (Exception ex)
            {
                result = ex.Message;
            }

            return result;
        }
        //CompleteWorkflowViaScript
        public string CompleteWorkflowViaScript(WFDetailDataContract _wfDetailDataContract, string UserID)
        {
            string result = "success";
            DataTable dtmain = new DataTable();
            DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();
            try
            {
                DataTable dtCheckList = new DataTable();
                dtCheckList.Columns.Add("WFCheckListDetailID");
                dtCheckList.Columns.Add("TaskId");
                dtCheckList.Columns.Add("WFCheckListMasterID");
                dtCheckList.Columns.Add("CheckListName");
                dtCheckList.Columns.Add("CheckListStatus");
                dtCheckList.Columns.Add("Comment");


                if (_wfDetailDataContract.WFCheckList != null)
                {
                    DataTable dt = new DataTable();
                    dt = ObjToDataTable.ToDataTable(_wfDetailDataContract.WFCheckList);

                    foreach (DataRow dr in dt.Rows)
                    {
                        dtCheckList.ImportRow(dr);
                    }
                }

                if (dtCheckList.Rows.Count > 0)
                {

                    connection.ConnectionString = GetConnectionString();

                    DataTable resultDT = new DataTable();
                    SqlCommand dbCmd = new SqlCommand("usp_UpdateWorkflowStatusForAFunding", connection);
                    dbCmd.CommandType = CommandType.StoredProcedure;

                    dbCmd.Parameters.AddWithValue("DealFundingID", _wfDetailDataContract.TaskID);
                    dbCmd.Parameters.AddWithValue("TaskTypeID", _wfDetailDataContract.TaskTypeID);
                    dbCmd.Parameters.AddWithValue("UserID", string.IsNullOrEmpty(_wfDetailDataContract.CreatedBy)?"": _wfDetailDataContract.CreatedBy);
                    dbCmd.Parameters.AddWithValue("CheckListDetail", dtCheckList);
                    connection.Open();
                    dbCmd.ExecuteNonQuery();
                    connection.Close();

                    //Helper.Helper hp = new Helper.Helper();
                    //SqlParameter p1 = new SqlParameter { ParameterName = "@DealFundingID", Value = _wfDetailDataContract.TaskID };
                    //SqlParameter p2 = new SqlParameter { ParameterName = "@TaskTypeID", Value = _wfDetailDataContract.TaskID };
                    //SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                    //SqlParameter p4 = new SqlParameter { ParameterName = "@CheckListDetail", Value = dtCheckList };
                    //SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3, p4 };
                    //dtmain = hp.ExecDataTable("usp_UpdateWorkflowStatusForAFunding", sqlparam);
                }

            }
            catch (Exception ex)
            {
                result = ex.Message;
            }

            return result;

        }

        public List<InvoiceSplitOutputDataContract> GetInvoiceSplit(InvoiceSplitParamDataContract _param, string UserID)
        {

            DataTable dt = new DataTable();
            List<InvoiceSplitOutputDataContract> lstDrawDc = new List<InvoiceSplitOutputDataContract>();
            InvoiceSplitOutputDataContract drawdt = null;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealIDOrCREDealID", Value = _param.DealID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@InvoiceTypeID", Value = _param.InvoiceTypeID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@FeeAmount", Value = _param.FeeAmount };
                SqlParameter p4 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3,p4 };
                dt = hp.ExecDataTable("dbo.usp_GetInvoiceSplit", sqlparam);
                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt = new InvoiceSplitOutputDataContract();
                        drawdt.DealName = Convert.ToString(dr["DealName"]);
                        drawdt.SplitAmount = Convert.ToDecimal(dr["SplitAmount"]);
                        drawdt.QBAccountNo = Convert.ToString(dr["QBAccountNo"]);
                        drawdt.QBItemName = Convert.ToString(dr["QBItemName"]);
                        lstDrawDc.Add(drawdt);
                    }
                }
            }
            catch (Exception ex)
            {
            }
            return lstDrawDc;
        }

        public InvoiceAPIDataContract ValidateInvoiceAPIParams(DrawFeeInvoiceDataContract _DrawFeeInvoice, string UserID)
        {
            DataTable dt = new DataTable();
            InvoiceAPIDataContract drawDC = new InvoiceAPIDataContract();

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@CREDealID", Value = _DrawFeeInvoice.CreDealID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@SystemInvoiceNo", Value = _DrawFeeInvoice.InvoiceNoUI };
            SqlParameter p4 = new SqlParameter { ParameterName = "@StateAbbr", Value = _DrawFeeInvoice.State };
            SqlParameter p5 = new SqlParameter { ParameterName = "@InvoiceType", Value = _DrawFeeInvoice.InvoiceTypeName };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3,p4,p5 };
            dt = hp.ExecDataTable("usp_ValidateInvoiceAPIParams", sqlparam);
            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    drawDC.IsDuplicateInvoice = Convert.ToBoolean(dr["IsDuplicateInvoice"]);
                    drawDC.StateID = Convert.ToInt32(dr["StateID"]);
                    drawDC.InvoiceTypeID = Convert.ToInt32(dr["InvoiceTypeID"]);
                    drawDC.DealName = Convert.ToString(dr["DealName"]);
                    drawDC.AMEmails = Convert.ToString(dr["AMEmails"]);

                }
            }
            //
            return drawDC;
        }

        public DrawFeeInvoiceDataContract GetInvoiceDetailByID(string UserID,int InvoiceDetailID)
        {

            DataTable dt = new DataTable();
            DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@InvoiceDetailID", Value = InvoiceDetailID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1,p2 };
                dt = hp.ExecDataTable("usp_GetInvoiceDetailByID", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt.DrawFeeInvoiceDetailID = Convert.ToInt32(dr["InvoiceDetailID"]);
                        drawdt.InvoiceNo = Convert.ToString(dr["InvoiceNo"]);
                        drawdt.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                        drawdt.FirstName = Convert.ToString(dr["FirstName"]);
                        drawdt.LastName = Convert.ToString(dr["LastName"]);
                        drawdt.Designation = Convert.ToString(dr["Designation"]);
                        drawdt.CompanyName = Convert.ToString(dr["CompanyName"]);
                        drawdt.Address = Convert.ToString(dr["Address"]);
                        drawdt.City = Convert.ToString(dr["City"]);
                        drawdt.State = Convert.ToString(dr["State"]);
                        drawdt.Zip = Convert.ToString(dr["Zip"]);
                        drawdt.Email1 = Convert.ToString(dr["Email1"]);
                        drawdt.Email2 = Convert.ToString(dr["Email2"]);
                        drawdt.PhoneNo = Convert.ToString(dr["PhoneNo"]);
                        drawdt.AlternatePhone = Convert.ToString(dr["AlternatePhone"]);
                        drawdt.Comment = Convert.ToString(dr["Comment"]);
                        drawdt.AutoSendInvoice = Convert.ToInt32(dr["AutoSendInvoice"]);
                        drawdt.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        drawdt.CreatedDate = Convert.ToDateTime(dr["CreatedDate"]);
                        drawdt.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        drawdt.UpdatedDate = Convert.ToDateTime(dr["UpdatedDate"]);
                        drawdt.FileName = Convert.ToString(dr["FileName"]);
                        drawdt.InvoiceNoUI = Convert.ToString(dr["InvoiceNoUI"]);
                        drawdt.CreDealID = Convert.ToString(dr["CreDealID"]);
                        drawdt.DealName = Convert.ToString(dr["DealName"]);
                        drawdt.AMEmails = Convert.ToString(dr["AMEmails"]);
                        drawdt.SenderFirstName = Convert.ToString(dr["SenderFirstName"]);
                        drawdt.SenderLastName = Convert.ToString(dr["SenderLastName"]);
                        drawdt.SenderEmail = Convert.ToString(dr["SenderEmail"]);
                        //drawdt.FundingAmount = CommonHelper.ToDecimal(dr["FundingAmount"]);
                        drawdt.InvoiceDate = Convert.ToDateTime(dr["InvoiceDate"]);
                        drawdt.InvoiceDateOriginal = Convert.ToDateTime(dr["InvoiceDateOriginal"]);
                        drawdt.InvoiceDueDate = Convert.ToDateTime(dr["InvoiceDueDate"]);
                        drawdt.CurrentDate = Convert.ToDateTime(dr["CurrentDate"]);
                        drawdt.InvoiceTypeID = Convert.ToInt32(dr["InvoiceTypeID"]);
                        drawdt.InvoiceTypeName = Convert.ToString(dr["InvoiceTypeName"]);
                        drawdt.ObjectID = Convert.ToString(dr["ObjectID"]);
                        drawdt.ObjectTypeID = Convert.ToInt32(dr["ObjectTypeID"]);
                        drawdt.EmailCC = Convert.ToString(dr["EmailCC"]);
                        drawdt.UploadedFrom = Convert.ToString(dr["UploadedFrom"]);
                        drawdt.InvoiceComment = Convert.ToString(dr["InvoiceComment"]);
                        break;
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return drawdt;
        }

        public DynamicsCustomer GetCustomerByAccountName(string AccountName)
        {
            DataTable dt = new DataTable();
            DynamicsCustomer drawDC = new DynamicsCustomer();

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@AccountName", Value = AccountName };
            SqlParameter[] sqlparam = new SqlParameter[] { p1};
            dt = hp.ExecDataTable("usp_GetCustomerByAccountName", sqlparam);
            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {


                    drawDC.ID = Convert.ToString(dr["ID"]);
                    drawDC.Name = Convert.ToString(dr["Name"]);
                    drawDC.FullName = Convert.ToString(dr["FullName"]);
                    drawDC.FirstName = Convert.ToString(dr["FirstName"]);
                    drawDC.LastName = Convert.ToString(dr["LastName"]);
                    drawDC.CompanyName = Convert.ToString(dr["CompanyName"]);
                    drawDC.IsActive = Convert.ToBoolean(dr["IsActive"]);
                    drawDC.CustomerNo = Convert.ToString(dr["CustomerNo"]);
                    drawDC.ContactID = Convert.ToString(dr["ContactID"]);
                }
            }
            //
            return drawDC;
        }

        public string UpdatePropertyManagerEmail(WFDetailDataContract _wfDetailDataContract)
        {
            string result = "success";
            try
            {
                DataTable dt = new DataTable();
                DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = _wfDetailDataContract.CreatedBy };
                SqlParameter p2 = new SqlParameter { ParameterName = "@CREDealIDOrDealID", Value = _wfDetailDataContract.CREDealID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@PropertyManagerEmail", Value = _wfDetailDataContract.PropertyManagerEmail };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3 };
                hp.ExecNonquery("usp_UpdatePropertyManagerEmail", sqlparam);
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }
            return result;

        }

        public List<DrawFeeInvoiceDataContract> GetAllInvoicedInvoice(string UserID)
        {

            DataTable dt = new DataTable();
            List<DrawFeeInvoiceDataContract> lstdraw = new List<DrawFeeInvoiceDataContract>();
            DrawFeeInvoiceDataContract drawdt = null;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("usp_GetAllInvoicedInvoice", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt = new DrawFeeInvoiceDataContract();
                        drawdt.DrawFeeInvoiceDetailID = Convert.ToInt32(dr["InvoiceDetailID"]);
                        drawdt.InvoiceNo = Convert.ToString(dr["InvoiceNo"]);
                        drawdt.TaskID = new Guid(dr["TaskID"].ToString());
                        drawdt.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                        drawdt.FirstName = Convert.ToString(dr["FirstName"]);
                        drawdt.LastName = Convert.ToString(dr["LastName"]);
                        drawdt.Designation = Convert.ToString(dr["Designation"]);
                        drawdt.CompanyName = Convert.ToString(dr["CompanyName"]);
                        drawdt.Address = Convert.ToString(dr["Address"]);
                        drawdt.City = Convert.ToString(dr["City"]);
                        drawdt.State = Convert.ToString(dr["State"]);
                        drawdt.Zip = Convert.ToString(dr["Zip"]);
                        drawdt.Email1 = Convert.ToString(dr["Email1"]);
                        drawdt.Email2 = Convert.ToString(dr["Email2"]);
                        drawdt.PhoneNo = Convert.ToString(dr["PhoneNo"]);
                        drawdt.AlternatePhone = Convert.ToString(dr["AlternatePhone"]);
                        drawdt.Comment = Convert.ToString(dr["Comment"]);
                        drawdt.AutoSendInvoice = Convert.ToInt32(dr["AutoSendInvoice"]);
                        drawdt.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        drawdt.CreatedDate = Convert.ToDateTime(dr["CreatedDate"]);
                        drawdt.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        drawdt.UpdatedDate = Convert.ToDateTime(dr["UpdatedDate"]);
                        drawdt.FileName = Convert.ToString(dr["FileName"]);
                        drawdt.FundingDate = Convert.ToDateTime(dr["Date"]);
                        drawdt.InvoiceNoUI = Convert.ToString(dr["InvoiceNoUI"]);
                        drawdt.CreDealID = Convert.ToString(dr["CreDealID"]);
                        drawdt.DealName = Convert.ToString(dr["DealName"]);
                        drawdt.InvoiceCode = Convert.ToString(dr["InvoiceCode"]);
                        drawdt.DrawNo = Convert.ToString(dr["DrawNo"]);
                        drawdt.TemplateName = Convert.ToString(dr["TemplateName"]);
                        drawdt.AMEmails = Convert.ToString(dr["AMEmails"]);
                        drawdt.SenderFirstName = Convert.ToString(dr["SenderFirstName"]);
                        drawdt.SenderLastName = Convert.ToString(dr["SenderLastName"]);
                        drawdt.SenderEmail = Convert.ToString(dr["SenderEmail"]);
                        drawdt.FundingAmount = CommonHelper.ToDecimal(dr["FundingAmount"]);
                        drawdt.InvoiceTypeID = Convert.ToInt32(dr["InvoiceTypeID"]);
                        lstdraw.Add(drawdt);
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return lstdraw;
        }

        public UserDataContract GetDealPrimaryAMByDealOrTaskType(string DealID, int TaskTypeID, string TaskID, string UserID)
        {
            DataTable dt = new DataTable();
            UserDataContract uDC = new UserDataContract();

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@TaskTypeID", Value = TaskTypeID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@TaskID", Value = TaskID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3,p4 };
            dt = hp.ExecDataTable("usp_GetDealPrimaryAMByDealOrTaskType", sqlparam);
            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    uDC.FirstName = Convert.ToString(dr["SenderFirstName"]);
                    uDC.LastName = Convert.ToString(dr["SenderLastName"]);
                    uDC.Email = Convert.ToString(dr["SenderEmail"]);
                    uDC.ContactNo1 = Convert.ToString(dr["ContactNo1"]);
                }
            }
            //
            return uDC;
        }

        public WFNotificationDetailDataContract GetEmailsForCancelFinalNotifiction(string ObjectID, int ObjectTypeId, string UserID)
        {

            WFNotificationDetailDataContract wDC = new WFNotificationDetailDataContract();
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectID", Value = ObjectID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ObjectTypeId", Value = ObjectTypeId };
                SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                DataTable dt = hp.ExecDataTable("dbo.usp_GetEmailsForCancelFinalNotifiction", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        wDC.EmailToIds = Convert.ToString(dr["EmailToIds"]);
                        wDC.EmailCCIds = Convert.ToString(dr["EmailCCIds"]);
                       
                    }
                }
                //
                return wDC;
            }
            catch (Exception ex)
            {

            }
            return wDC;
        }

        public DataTable GetParentClientMissingEmail()
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("dbo.usp_GetParentClientMissingEmail");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dt;
        }


        public string SaveWFDashboard(List<WFDashboardDataContract> lstWorkflow, string UserID)
        {
            string result = "success";
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@XMLWFList", Value = lstWorkflow.ToXML().Replace(" xsi:nil=\"true\"", "") };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecNonquery("usp_SaveWFDashboard", sqlparam);
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }

            return result;
        }

        public List<DrawFeeInvoiceDataContract> GetAllInvoiceQueuedForSandbox(string UserID)
        {

            DataTable dt = new DataTable();
            List<DrawFeeInvoiceDataContract> lstdraw = new List<DrawFeeInvoiceDataContract>();
            DrawFeeInvoiceDataContract drawdt = null;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("usp_GetAllInvoiceQueued_forSandbox", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt = new DrawFeeInvoiceDataContract();
                        drawdt.DrawFeeInvoiceDetailID = Convert.ToInt32(dr["InvoiceDetailID"]);
                        drawdt.InvoiceNo = Convert.ToString(dr["InvoiceNo"]);
                        drawdt.TaskID = new Guid(dr["TaskID"].ToString());
                        drawdt.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                        drawdt.FirstName = Convert.ToString(dr["FirstName"]);
                        drawdt.LastName = Convert.ToString(dr["LastName"]);
                        drawdt.Designation = Convert.ToString(dr["Designation"]);
                        drawdt.CompanyName = Convert.ToString(dr["CompanyName"]);
                        drawdt.Address = Convert.ToString(dr["Address"]);
                        drawdt.City = Convert.ToString(dr["City"]);
                        drawdt.State = Convert.ToString(dr["State"]);
                        drawdt.Zip = Convert.ToString(dr["Zip"]);
                        drawdt.Email1 = Convert.ToString(dr["Email1"]);
                        drawdt.Email2 = Convert.ToString(dr["Email2"]);
                        drawdt.PhoneNo = Convert.ToString(dr["PhoneNo"]);
                        drawdt.AlternatePhone = Convert.ToString(dr["AlternatePhone"]);
                        drawdt.Comment = Convert.ToString(dr["Comment"]);
                        drawdt.AutoSendInvoice = Convert.ToInt32(dr["AutoSendInvoice"]);
                        drawdt.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        drawdt.CreatedDate = Convert.ToDateTime(dr["CreatedDate"]);
                        drawdt.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        drawdt.UpdatedDate = Convert.ToDateTime(dr["UpdatedDate"]);
                        drawdt.FileName = Convert.ToString(dr["FileName"]);
                        drawdt.FundingDate = Convert.ToDateTime(dr["Date"]);
                        drawdt.InvoiceNoUI = Convert.ToString(dr["InvoiceNoUI"]);
                        drawdt.CreDealID = Convert.ToString(dr["CreDealID"]);
                        drawdt.DealName = Convert.ToString(dr["DealName"]);
                        drawdt.InvoiceCode = Convert.ToString(dr["InvoiceCode"]);
                        drawdt.DrawNo = Convert.ToString(dr["DrawNo"]);
                        drawdt.TemplateName = Convert.ToString(dr["TemplateName"]);
                        drawdt.AMEmails = Convert.ToString(dr["AMEmails"]);
                        drawdt.SenderFirstName = Convert.ToString(dr["SenderFirstName"]);
                        drawdt.SenderLastName = Convert.ToString(dr["SenderLastName"]);
                        drawdt.SenderEmail = Convert.ToString(dr["SenderEmail"]);
                        drawdt.FundingAmount = CommonHelper.ToDecimal(dr["FundingAmount"]);
                        drawdt.InvoiceTypeID = Convert.ToInt32(dr["InvoiceTypeID"]);
                        drawdt.IsManualInvoice = Convert.ToBoolean(dr["IsManualInvoice"]);
                        lstdraw.Add(drawdt);
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return lstdraw;
        }

        public string UpdateDrawFeeInvoiceDetailStatusForSandbox(string UserID, DrawFeeInvoiceDataContract drawFeeDC)
        {
            string result = "success";
            DataTable dt = new DataTable();
            DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@TaskID", Value = drawFeeDC.TaskID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@InvoiceNumber", Value = drawFeeDC.InvoiceNo };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3};
                //SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3,p4,p5,p6,p7,p8};
                dt = hp.ExecDataTable("usp_UpdateInvoiceDetailStatusForSandbox", sqlparam);
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }

            return result;
        }

        public List<DrawFeeInvoiceDataContract> GetMissingQBDCustomerInSandbox()
        {

            DataTable dt = new DataTable();
            List<DrawFeeInvoiceDataContract> lstDrawDc = new List<DrawFeeInvoiceDataContract>();
            DrawFeeInvoiceDataContract drawdt = null;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter[] sqlparam = new SqlParameter[] { };
                dt = hp.ExecDataTable("usp_GetMissingQBDCustomerInSandbox", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt = new DrawFeeInvoiceDataContract();
                        drawdt.DrawFeeInvoiceDetailID = Convert.ToInt32(dr["InvoiceDetailID"]);
                        drawdt.TaskID = new Guid(dr["TaskID"].ToString());
                        drawdt.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                        drawdt.FirstName = Convert.ToString(dr["FirstName"]);
                        drawdt.LastName = Convert.ToString(dr["LastName"]);
                        drawdt.Designation = Convert.ToString(dr["Designation"]);
                        drawdt.CompanyName = Convert.ToString(dr["CompanyName"]);
                        drawdt.Address = Convert.ToString(dr["Address"]);
                        drawdt.City = Convert.ToString(dr["City"]);
                        drawdt.State = Convert.ToString(dr["State"]);
                        drawdt.Zip = Convert.ToString(dr["Zip"]);
                        drawdt.Email1 = Convert.ToString(dr["Email1"]);
                        drawdt.Email2 = Convert.ToString(dr["Email2"]);
                        drawdt.PhoneNo = Convert.ToString(dr["PhoneNo"]);
                        drawdt.AlternatePhone = Convert.ToString(dr["AlternatePhone"]);
                        drawdt.Comment = Convert.ToString(dr["Comment"]);
                        drawdt.AutoSendInvoice = Convert.ToInt32(dr["AutoSendInvoice"]);
                        drawdt.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        drawdt.CreatedDate = Convert.ToDateTime(dr["CreatedDate"]);
                        drawdt.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        drawdt.UpdatedDate = Convert.ToDateTime(dr["UpdatedDate"]);
                        drawdt.FileName = Convert.ToString(dr["FileName"]);
                        drawdt.InvoiceNo = Convert.ToString(dr["InvoiceNo"]);
                        drawdt.DrawFeeStatus = Convert.ToInt32(dr["DrawFeeStatus"]);
                        drawdt.StateID = Convert.ToInt32(dr["StateID"]);
                        drawdt.InvoiceNoUI = Convert.ToString(dr["SystemInvoiceNo"]);
                        drawdt.DealName = Convert.ToString(dr["DealName"]);
                        drawdt.CreDealID = Convert.ToString(dr["CreDealID"]);
                        lstDrawDc.Add(drawdt);
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return lstDrawDc;
        }

        public string AddUpdateQBDCustomerForSandbox(string UserID, QBDCustomerInputDataContract QbdCustomer)
        {
            string result = "success";
            try
            {
                DataTable dt = new DataTable();
                DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@CustomerAccountName", Value = QbdCustomer.FullName };
                SqlParameter p3 = new SqlParameter { ParameterName = "@CustomerNo", Value = QbdCustomer.CustomerNo };
                SqlParameter p4 = new SqlParameter { ParameterName = "@ContactID", Value = QbdCustomer.ContactID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
                hp.ExecNonquery("usp_InsertUpdateQBDCustomerForSandbox", sqlparam);
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }
            return result;
        }

        public DrawFeeInvoiceDataContract GetInvoiceDetailByInvoiceNo(string UserID, string InvoiceNo)
        {

            DataTable dt = new DataTable();
            DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@InvoiceNo", Value = InvoiceNo };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("usp_GetInvoiceDetailByInvoiceNo", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt.DrawFeeInvoiceDetailID = Convert.ToInt32(dr["InvoiceDetailID"]);
                        drawdt.InvoiceNo = Convert.ToString(dr["InvoiceNo"]);
                        drawdt.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                        drawdt.FirstName = Convert.ToString(dr["FirstName"]);
                        drawdt.LastName = Convert.ToString(dr["LastName"]);
                        drawdt.Designation = Convert.ToString(dr["Designation"]);
                        drawdt.CompanyName = Convert.ToString(dr["CompanyName"]);
                        drawdt.Address = Convert.ToString(dr["Address"]);
                        drawdt.City = Convert.ToString(dr["City"]);
                        drawdt.State = Convert.ToString(dr["State"]);
                        drawdt.Zip = Convert.ToString(dr["Zip"]);
                        drawdt.Email1 = Convert.ToString(dr["Email1"]);
                        drawdt.Email2 = Convert.ToString(dr["Email2"]);
                        drawdt.PhoneNo = Convert.ToString(dr["PhoneNo"]);
                        drawdt.AlternatePhone = Convert.ToString(dr["AlternatePhone"]);
                        drawdt.Comment = Convert.ToString(dr["Comment"]);
                        drawdt.AutoSendInvoice = Convert.ToInt32(dr["AutoSendInvoice"]);
                        drawdt.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        drawdt.CreatedDate = Convert.ToDateTime(dr["CreatedDate"]);
                        drawdt.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        drawdt.UpdatedDate = Convert.ToDateTime(dr["UpdatedDate"]);
                        drawdt.FileName = Convert.ToString(dr["FileName"]);
                        drawdt.InvoiceNoUI = Convert.ToString(dr["InvoiceNoUI"]);
                        drawdt.CreDealID = Convert.ToString(dr["CreDealID"]);
                        drawdt.DealName = Convert.ToString(dr["DealName"]);
                        drawdt.AMEmails = Convert.ToString(dr["AMEmails"]);
                        drawdt.SenderFirstName = Convert.ToString(dr["SenderFirstName"]);
                        drawdt.SenderLastName = Convert.ToString(dr["SenderLastName"]);
                        drawdt.SenderEmail = Convert.ToString(dr["SenderEmail"]);
                        //drawdt.FundingAmount = CommonHelper.ToDecimal(dr["FundingAmount"]);
                        drawdt.InvoiceDate = Convert.ToDateTime(dr["InvoiceDate"]);
                        drawdt.InvoiceDateOriginal = Convert.ToDateTime(dr["InvoiceDateOriginal"]);
                        drawdt.InvoiceDueDate = Convert.ToDateTime(dr["InvoiceDueDate"]);
                        drawdt.CurrentDate = Convert.ToDateTime(dr["CurrentDate"]);
                        drawdt.InvoiceTypeID = Convert.ToInt32(dr["InvoiceTypeID"]);
                        drawdt.InvoiceTypeName = Convert.ToString(dr["InvoiceTypeName"]);
                        drawdt.ObjectID = Convert.ToString(dr["ObjectID"]);
                        drawdt.ObjectTypeID = Convert.ToInt32(dr["ObjectTypeID"]);
                        drawdt.EmailCC = Convert.ToString(dr["EmailCC"]);
                        drawdt.UploadedFrom = Convert.ToString(dr["UploadedFrom"]);
                        drawdt.InvoiceComment = Convert.ToString(dr["InvoiceComment"]);
                        break;
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return drawdt;
        }

        public int CheckWFConcurrency(string UserID, WFConcurrencyParams prms)
        {
            DataTable dt = new DataTable();
            int Status = 0;
            WFDetailDataContract wfdt = new WFDetailDataContract();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@xmlWorkflow", Value = prms.ToXML() };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };

                dt = hp.ExecDataTable("usp_CheckWorkflowConcurrency", sqlparam);

                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                        Status = Convert.ToInt32(dt.Rows[0]["Status"]);
                }

            }
            catch (Exception ex)
            {
                Status = 2;
            }

            return Status;
        }

        public string UpdateSponsorDetailFromBackshop(string DealID, string UserID)
        {
            string result = "success";
            try
            {
                DataTable dt = new DataTable();
                DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();

                Helper.Helper hp = new Helper.Helper();
                //SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1};
                hp.ExecNonquery("usp_UpdateSponsorDetailFromBackshop", sqlparam);
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }
            return result;
        }

        public DrawFeeInvoiceDataContract GetFormatedSponsorDetailFromBackshop(string DealID, string UserID)
        {

            DataTable dt = new DataTable();
            DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1};
                dt = hp.ExecDataTable("usp_getFormatedSponsorDetailFromBackshop", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt.FirstName = Convert.ToString(dr["Sponsor"]);
                        drawdt.Email1 = Convert.ToString(dr["EmailIDs"]);
                        break;
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return drawdt;
        }

        public void saveInvoicesLanding(DataTable dtInvoices)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                if (dtInvoices.Rows.Count > 0)
                    hp.ExecDataTablewithtable("usp_InsertInvoicesLanding", dtInvoices, "tbltype_Invoices");
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<DrawFeeInvoiceDataContract> GetAllInvoicesFromInvoiceLanding(string UserID)
        {

            DataTable dt = new DataTable();
            List<DrawFeeInvoiceDataContract> lstdraw = new List<DrawFeeInvoiceDataContract>();
            DrawFeeInvoiceDataContract drawdt = null;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("usp_GetAllInvoicesFromInvoiceLanding", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt = new DrawFeeInvoiceDataContract();
                        drawdt.DrawFeeInvoiceDetailID = Convert.ToInt32(dr["InvoiceDetailID"]);
                        drawdt.InvoiceNo = Convert.ToString(dr["InvoiceNo"]);
                        drawdt.TaskID = new Guid(dr["TaskID"].ToString());
                        drawdt.Amount = CommonHelper.ToDecimal(dr["Amount"]);
                        drawdt.FirstName = Convert.ToString(dr["FirstName"]);
                        drawdt.LastName = Convert.ToString(dr["LastName"]);
                        drawdt.Designation = Convert.ToString(dr["Designation"]);
                        drawdt.CompanyName = Convert.ToString(dr["CompanyName"]);
                        drawdt.Address = Convert.ToString(dr["Address"]);
                        drawdt.City = Convert.ToString(dr["City"]);
                        drawdt.State = Convert.ToString(dr["State"]);
                        drawdt.Zip = Convert.ToString(dr["Zip"]);
                        drawdt.Email1 = Convert.ToString(dr["Email1"]);
                        drawdt.Email2 = Convert.ToString(dr["Email2"]);
                        drawdt.PhoneNo = Convert.ToString(dr["PhoneNo"]);
                        drawdt.AlternatePhone = Convert.ToString(dr["AlternatePhone"]);
                        drawdt.Comment = Convert.ToString(dr["Comment"]);
                        drawdt.AutoSendInvoice = Convert.ToInt32(dr["AutoSendInvoice"]);
                        drawdt.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                        drawdt.CreatedDate = Convert.ToDateTime(dr["CreatedDate"]);
                        drawdt.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                        drawdt.UpdatedDate = Convert.ToDateTime(dr["UpdatedDate"]);
                        drawdt.FileName = Convert.ToString(dr["FileName"]);
                        drawdt.FundingDate = Convert.ToDateTime(dr["Date"]);
                        drawdt.InvoiceNoUI = Convert.ToString(dr["InvoiceNoUI"]);
                        drawdt.CreDealID = Convert.ToString(dr["CreDealID"]);
                        drawdt.DealName = Convert.ToString(dr["DealName"]);
                        drawdt.InvoiceCode = Convert.ToString(dr["InvoiceCode"]);
                        drawdt.DrawNo = Convert.ToString(dr["DrawNo"]);
                        drawdt.TemplateName = Convert.ToString(dr["TemplateName"]);
                        drawdt.AMEmails = Convert.ToString(dr["AMEmails"]);
                        drawdt.SenderFirstName = Convert.ToString(dr["SenderFirstName"]);
                        drawdt.SenderLastName = Convert.ToString(dr["SenderLastName"]);
                        drawdt.SenderEmail = Convert.ToString(dr["SenderEmail"]);
                        drawdt.FundingAmount = CommonHelper.ToDecimal(dr["FundingAmount"]);
                        drawdt.InvoiceTypeID = Convert.ToInt32(dr["InvoiceTypeID"]);
                        drawdt.IsManualInvoice = Convert.ToBoolean(dr["IsManualInvoice"]);
                        lstdraw.Add(drawdt);
                    }
                }

            }
            catch (Exception ex)
            {

            }

            return lstdraw;
        }

        public List<InvoicesLandingDataContract> GetAllReadyToPayInvoicesFromLanding(string UserID)
        {

            DataTable dt = new DataTable();
            List<InvoicesLandingDataContract> lstdraw = new List<InvoicesLandingDataContract>();
            InvoicesLandingDataContract drawdt = null;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("usp_GetAllReadyToPayInvoicesFromLanding", sqlparam);

                if (dt != null)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        drawdt = new InvoicesLandingDataContract();
                        drawdt.InvoiceDetailID = Convert.ToInt32(dr["InvoiceDetailID"]);
                        //drawdt.InvoiceNo = Convert.ToString(dr["InvoiceNo"]);
                        drawdt.AmountPaid = CommonHelper.ToDecimal(dr["AmountPaid"]);
                        drawdt.PaymentDate = Convert.ToDateTime(dr["PaymentDate"]);
                        lstdraw.Add(drawdt);
                    }
                }
            }
            catch (Exception ex)
            {

            }

            return lstdraw;
        }

        public string UpdateInvoiceDetailLandingStatus(string UserID, int InvoiceDetailID,string Status)
        {
            string result = "success";
            DataTable dt = new DataTable();
            DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@InvoiceDetailID", Value = InvoiceDetailID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Status", Value = Status };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3};
                //SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3,p4,p5,p6,p7,p8};
                dt = hp.ExecDataTable("usp_UpdateInvoiceDetailLandingStatus", sqlparam);
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }

            return result;
        }

        public string DeleteInvoiceDetailLanding(string UserID, int InvoiceDetailID)
        {
            string result = "success";
            DataTable dt = new DataTable();
            DrawFeeInvoiceDataContract drawdt = new DrawFeeInvoiceDataContract();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@InvoiceDetailID", Value = InvoiceDetailID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, };
                //SqlParameter[] sqlparam = new SqlParameter[] { p1, p2,p3,p4,p5,p6,p7,p8};
                dt = hp.ExecDataTable("usp_DeleteInvoiceDetailLanding", sqlparam);
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }

            return result;
        }

        public void updateInvoicesLanding(DataTable dtInvoices)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                if (dtInvoices.Rows.Count > 0)
                    hp.ExecDataTablewithtable("usp_UpdateInvoicesLanding", dtInvoices, "tbltype_Invoices");
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void updateInvoice(string UserID, DrawFeeInvoiceDataContract drawFeeDC)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@InvoiceDetailID", Value = drawFeeDC.DrawFeeInvoiceDetailID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@InvoiceTypeFreeText", Value = drawFeeDC.InvoiceTypeFreeText };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                hp.ExecDataTable("usp_UpdateInvoice", sqlparam);
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
