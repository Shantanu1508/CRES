using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

using System.Data.SqlClient;
using Microsoft.AspNetCore.Http.Internal;

namespace CRES.DAL.Repository
{
    public class CalculationManagerRespository : ICalculationManagerRespository
    {

        public List<CalculationManagerDataContract> RefreshCalculationStatus(CalculationManagerDataContract DCcalc, Guid? UserID)
        {
            DataTable dt = new DataTable();
            List<CalculationManagerDataContract> noteslist = new List<CalculationManagerDataContract>();

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@PortfolioMasterGuid", Value = DCcalc.PortfolioMasterGuid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = DCcalc.AnalysisID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            dt = hp.ExecDataTable("dbo.usp_RefreshCalculationRequests", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                CalculationManagerDataContract md = new CalculationManagerDataContract();
                md.NoteId = Convert.ToString(dr["NoteId"]);
                md.NoteName = Convert.ToString(dr["Name"]);
                md.RequestTime = CommonHelper.ToDateTime(dr["RequestTime"]);

                md.StatusID = CommonHelper.ToInt32(dr["StatusID"]);
                md.StatusText = Convert.ToString(dr["StatusText"]);

                //900	40	Pause_Dependents
                if (md.StatusText == "Pause_Dependents")
                {
                    md.StatusID = 899;
                    md.StatusText = "Pause";
                }
                md.UserName = Convert.ToString(dr["UserName"]);
                md.ApplicationID = CommonHelper.ToInt32(dr["ApplicationID"]);
                md.ApplicationText = Convert.ToString(dr["ApplicationText"]);
                md.StartTime = CommonHelper.ToDateTime(dr["StartTime"]);
                md.EndTime = CommonHelper.ToDateTime(dr["EndTime"]);
                md.PriorityID = CommonHelper.ToInt32(dr["PriorityID"]);
                md.PriorityText = Convert.ToString(dr["PriorityText"]);
                md.ErrorMessage = Convert.ToString(dr["ErrorMessage"]);
                md.ErrorDetails = Convert.ToString(dr["ErrorDetails"]);
                md.DealName = Convert.ToString(dr["DealName"]);
                md.CRENoteID = Convert.ToString(dr["CRENoteID"]);
                if (Convert.ToString(dr["CalculationRequestID"]) != "")
                {
                    md.CalculationRequestID = new Guid(Convert.ToString(dr["CalculationRequestID"]));
                }
                md.CalcEngineType = CommonHelper.ToInt32(dr["CalcEngineType"]);
                if (md.CalcEngineType == 798)
                {
                    md.FileName = Convert.ToString(dr["FileName_V1"]);

                }
                else
                {
                    md.FileName = Convert.ToString(dr["FileName"]);
                }
                md.CalcEngineTypeText = Convert.ToString(dr["CalcEngineTypeText"]);
                md.EnableM61Calculations = CommonHelper.ToInt32(dr["EnableM61Calculations"]);
                md.EnableM61CalculationsText = Convert.ToString(dr["EnableM61CalculationsText"]);
                md.PayOffDate = CommonHelper.ToDateTime(dr["PayOffDate"]);
                md.IsPaidOffDeal = CommonHelper.ToBoolean(dr["IsPaidOffDeal"]);
                md.AccountingCloseDate = CommonHelper.ToDateTime(dr["AccountingCloseDate"]);

                noteslist.Add(md);
            }


            return noteslist;
        }

        public bool QueueNotesForCalculation(List<CalculationManagerDataContract> noteslist, string username,string RequestFrom="")
        {
            bool status;
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dNote = new DataTable();
                dNote.Columns.Add("NoteId");
                dNote.Columns.Add("StatusText");
                dNote.Columns.Add("UserName");
                dNote.Columns.Add("ApplicationText");
                dNote.Columns.Add("PriorityText");
                dNote.Columns.Add("AnalysisID");
                dNote.Columns.Add("CalculationModeID");
                dNote.Columns.Add("CalcType");
                if (noteslist != null)
                {
                    DataTable dt = new DataTable();
                    dt = ObjToDataTable.ToDataTable(noteslist);
                    foreach (DataRow dr in dt.Rows)
                    {
                        dNote.ImportRow(dr);
                    }
                }
                if (dNote.Rows.Count > 0)
                {
                    hp.QueueLoansHelper("dbo.usp_QueueNotesForCalculation", dNote, username, "CalculationRequest", noteslist[0].BatchType, noteslist[0].PortfolioMasterGuid.ToString(), RequestFrom);
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

        public List<CalculationManagerDataContract> NotesListForCalculation()
        {
            List<CalculationManagerDataContract> noteslist = new List<CalculationManagerDataContract>();

            try
            {
                DataTable dt = new DataTable();
                Helper.Helper hp = new Helper.Helper();
                dt = hp.ExecDataTable("dbo.usp_GetNoteIDForCalcFromCalculationRequests");
                foreach (DataRow dr in dt.Rows)
                {
                    CalculationManagerDataContract cmd = new CalculationManagerDataContract();
                    if (Convert.ToString(dr["CalculationRequestID"]) != "")
                    {
                        cmd.CalculationRequestID = new Guid(Convert.ToString(dr["CalculationRequestID"]));
                    }
                    cmd.NoteId = Convert.ToString(dr["NoteID"]);
                    cmd.UserName = Convert.ToString(dr["UserName"]);
                    if (Convert.ToString(dr["AnalysisID"]) != "")
                    {
                        cmd.AnalysisID = new Guid(Convert.ToString(dr["AnalysisID"]));
                    }
                    cmd.CalculationModeID = CommonHelper.ToInt32(dr["CalculationModeID"]);
                    cmd.CalculationModeText = Convert.ToString(dr["CalculationModeText"]);
                    noteslist.Add(cmd);
                }
            }
            catch (Exception ex)
            {

                throw;
            }



            return noteslist;
        }

        public List<CalculationManagerDataContract> NotesListForCalculationByServerIndex(int ServerIndex)
        {
            List<CalculationManagerDataContract> noteslist = new List<CalculationManagerDataContract>();
            DataTable dt = new DataTable();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@ServerIndex", Value = ServerIndex };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetNoteIDForCalcFromCalculationRequestsByServerIndex", sqlparam);

                foreach (DataRow dr in dt.Rows)
                {
                    CalculationManagerDataContract cmd = new CalculationManagerDataContract();

                    if (Convert.ToString(dr["AnalysisID"]) != "")
                    {
                        cmd.AnalysisID = new Guid(Convert.ToString(dr["AnalysisID"]));
                    }

                    cmd.NoteId = Convert.ToString(dr["NoteID"]);
                    if (Convert.ToString(dr["CalculationRequestID"]) != "")
                    {
                        cmd.CalculationRequestID = new Guid(Convert.ToString(dr["CalculationRequestID"]));
                    }
                    cmd.UserName = Convert.ToString(dr["UserName"]);
                    //CalculationModeID = Convert.ToInt32(dr["CalculationModeID"]),
                    //CalculationModeText = Convert.ToString(dr["CalculationModeText"])
                    noteslist.Add(cmd);

                }


            }
            catch (Exception ex)
            {
            }
            return noteslist;
        }

        public void UpdateCalculationStatusandTime(Guid calcid, string noteid, string statustext, string columnname, string errmsg)

        {
            Guid GuidNote = new Guid(noteid);
            // dbContext.usp_UpdateCalculationStatusAndTime(calcid, GuidNote, statustext, columnname, errmsg);


            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@CalculationRequestID", Value = calcid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@NoteID", Value = GuidNote };
            SqlParameter p3 = new SqlParameter { ParameterName = "@StatusText", Value = statustext };
            SqlParameter p4 = new SqlParameter { ParameterName = "@ColumnName", Value = columnname };
            SqlParameter p5 = new SqlParameter { ParameterName = "@ErrorMessage", Value = errmsg };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            hp.ExecNonquery("dbo.usp_UpdateCalculationStatusAndTime", sqlparam);

        }

        public void UpdateCalculationStatusForDependents(string noteid, Guid? AnalysisID)
        {
            Guid GuidNote = new Guid(noteid);


            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = GuidNote };
            SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecNonquery("dbo.usp_UpdateCalculationStatusForDependents", sqlparam);
        }
        public void UpdateCalculationTimeInMinByNoteID(Guid noteid, int? CalculationTimeInMin)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@CalculationTimeInMin", Value = CalculationTimeInMin };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecNonquery("dbo.usp_UpdateCalculationTimeInMinByNoteID", sqlparam);
        }

        public void InsertIntoCalculatorStatistics(string noteid, decimal? calctime, decimal? dbtime, decimal? totaltime, string analysisid)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = noteid };
            SqlParameter p2 = new SqlParameter { ParameterName = "@CalcProcessTimeInSecs", Value = calctime };
            SqlParameter p3 = new SqlParameter { ParameterName = "@DBProcessTimeInSecs", Value = dbtime };
            SqlParameter p4 = new SqlParameter { ParameterName = "@TotalTimeInSecs", Value = totaltime };
            SqlParameter p5 = new SqlParameter { ParameterName = "@AnalysisID", Value = analysisid };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            hp.ExecNonquery("dbo.usp_InsertIntoCalculatorStatistics", sqlparam);
        }
        ///

        public void UpdateNoteCalculatedWeightedSpread(string NoteID, decimal? WeightedSpread)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = NoteID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@WeightedSpread", Value = WeightedSpread };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            hp.ExecNonquery("CRE.usp_UpdateNoteCalculatedWeightedSpread", sqlparam);
        }
        public void UpdateCalculationStatus(string noteid, string statustext, Guid? AnalysisID)

        {
            Guid GuidNote = new Guid(noteid);
            //  dbContext.usp_UpdateCalculationStatus(GuidNote, statustext, AnalysisID);

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = GuidNote };
            SqlParameter p2 = new SqlParameter { ParameterName = "@StatusText", Value = statustext };
            SqlParameter p3 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
            hp.ExecNonquery("dbo.usp_UpdateCalculationStatus", sqlparam);
        }

        public DataTable GetCalculationStatus(List<CalculationManagerDataContract> lstCalcMgrDC)
        {
            //List<CalculationManagerDataContract> lstcalcmgr = new List<CalculationManagerDataContract>();
            DataTable dtcalcreq = new DataTable();

            Helper.Helper hp = new Helper.Helper();

            DataTable dtreq = new DataTable();
            dtreq.Columns.Add("NoteId");
            dtreq.Columns.Add("StatusID");
            dtreq.Columns.Add("StartTime");
            dtreq.Columns.Add("EndTime");

            dtcalcreq = hp.ToDataTable(lstCalcMgrDC);

            foreach (DataRow dr in dtcalcreq.Rows)
            {
                dtreq.ImportRow(dr);
            }

            return hp.GetDatatable("usp_GetCalculationRequestsStatus", "tblCalcRequest", dtreq);

            // return dtreq;
        }

        public int getCalcStatus()
        {
            Helper.Helper hp = new Helper.Helper();
            int result = 0;

            SqlParameter p1 = new SqlParameter { ParameterName = "@isComplete", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            hp.ExecDataTable("dbo.usp_GetCalculationStatus", sqlparam);

            result = string.IsNullOrEmpty(Convert.ToString(p1.Value)) ? 0 : Convert.ToInt32(p1.Value); ;
            return result;
        }

        public int getCalcStatusByServerIndex(int ServerIndex)
        {
            //ObjectParameter calcstatus = new ObjectParameter("isComplete", typeof(int));
            //dbContext.usp_GetCalculationStatus(calcstatus);

            //return Convert.ToInt16(calcstatus.Value);
            DataTable dt = new DataTable();
            int result = 0;

            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@ServerIndex", Value = ServerIndex };
                SqlParameter p2 = new SqlParameter { ParameterName = "@isComplete", Direction = ParameterDirection.Output, Size = int.MaxValue };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetCalculationStatusByServerIndex", sqlparam);

                result = string.IsNullOrEmpty(Convert.ToString(p2.Value)) ? 0 : Convert.ToInt32(p2.Value);
            }
            catch (Exception ex)
            {
            }

            return result;

        }


        public int GetCalcRequestCount()
        {
            Helper.Helper hp = new Helper.Helper();

            hp.ExecuteScalar("dbo.usp_Inserttbltest");
            return 1;
        }

        public void QueueNotesForCalculationForDuplicateTransaction()
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                hp.ExecDataTable("dbo.usp_QueueNotesForCalculationForDuplicateTransaction");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void QueueNotesForCalculationIfDWoutofSync()
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                hp.ExecDataTable("dbo.usp_QueueNotesForCalculationIfDWoutofSync");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<RequestFailureDataContract> GetCalculationRequestFailureNotes(int moduleId)
        {
            List<RequestFailureDataContract> noteslist = new List<RequestFailureDataContract>();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@ModuleId", Value = moduleId };


            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetCalculationRequestFailureNotes", sqlparam);

            //  var lstnotes = dbContext.usp_GetCalculationRequestFailureNotes(moduleId);
            foreach (DataRow dr in dt.Rows)
            {
                RequestFailureDataContract rfd = new RequestFailureDataContract();
                rfd.Name = Convert.ToString(dr["Name"]);
                if (Convert.ToString(dr["NoteID"]) != "")
                {
                    rfd.NoteID = new Guid(Convert.ToString(dr["NoteID"]));
                }

                rfd.CRENoteID = Convert.ToString(dr["CRENoteID"]);
                rfd.DealName = Convert.ToString(dr["DealName"]);
                if (Convert.ToString(dr["DealID"]) != "")
                {
                    rfd.DealID = new Guid(Convert.ToString(dr["DealID"]));
                }
                rfd.CREDealID = Convert.ToString(dr["CREDealID"]);
                rfd.UserName = Convert.ToString(dr["UserName"]);
                rfd.StartTime = CommonHelper.ToDateTime(dr["StartTime"]);
                rfd.EndTime = CommonHelper.ToDateTime(dr["EndTime"]);
                rfd.ErrorMessage = Convert.ToString(dr["ErrorMessage"]);
                rfd.EmailIds = Convert.ToString(dr["EmailIds"]);
                noteslist.Add(rfd);
            }
            return noteslist;
        }


        public void AddNoteInCalculationRequestsByScenarioID(string AnalysisID, string username, string envname)
        {
            int result = 0;
            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));

            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p0 = new SqlParameter { ParameterName = "@ScenarioID", Value = new Guid(AnalysisID) };
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(username) };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ApplicationText", Value = envname };
                SqlParameter[] sqlparam = new SqlParameter[] { p0, p1, p2 };
                result = hp.ExecNonquery("dbo.usp_AddNoteInCalculationRequestsByScenarioID", sqlparam);
            }
            catch (Exception ex)
            {

            }


        }


        public void ExecuteProcedureInADay()
        {
            Helper.Helper hp = new Helper.Helper();
            hp.ExecuteScalar("dbo.usp_SchedulerJob");
        }

        public void ExecuteProcedureNightly()
        {
            Helper.Helper hp = new Helper.Helper();
            hp.ExecuteScalar("dbo.usp_SchedulerJobNightly");
        }

        public List<BatchCalculationMasterDataContract> GetBatchCalculationLog(CalculationManagerDataContract DCcalc)
        {
            List<BatchCalculationMasterDataContract> batchlog = new List<BatchCalculationMasterDataContract>();
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = DCcalc.AnalysisID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = DCcalc.UserName };

            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetBatchCalculationMasterByAnalysisID", sqlparam);


            //  var lstlog = dbContext.usp_GetBatchCalculationMasterByAnalysisID(DCcalc.AnalysisID, DCcalc.UserName);
            foreach (DataRow dr in dt.Rows)
            {

                BatchCalculationMasterDataContract batchCalc = new BatchCalculationMasterDataContract();
                if (Convert.ToString(dr["AnalysisID"]) != "")
                {
                    batchCalc.AnalysisID = new Guid(Convert.ToString(dr["AnalysisID"]));
                }
                batchCalc.Name = Convert.ToString(dr["Name"]);
                batchCalc.BatchCalculationMasterID = CommonHelper.ToInt32(dr["BatchCalculationMasterID"]);
                if (Convert.ToString(dr["BatchCalculationMasterGUID"]) != "")
                {
                    batchCalc.BatchCalculationMasterGUID = new Guid(Convert.ToString(dr["BatchCalculationMasterGUID"]));
                }
                batchCalc.StartTime = CommonHelper.ToDateTime(dr["StartTime"]);
                batchCalc.EndTime = CommonHelper.ToDateTime(dr["EndTime"]);
                batchCalc.Total = CommonHelper.ToInt32(dr["Total"]);
                batchCalc.TotalCompleted = CommonHelper.ToInt32(dr["TotalCompleted"]);
                batchCalc.TotalFailed = CommonHelper.ToInt32(dr["TotalFailed"]);
                batchCalc.TotalCanceled = CommonHelper.ToInt32(dr["TotalCanceled"]);                
                batchCalc.BatchType = Convert.ToString(dr["BatchType"]);
                if (Convert.ToString(dr["UserID"]) != "")
                {
                    batchCalc.UserID = new Guid(Convert.ToString(dr["UserID"]));
                }
                batchCalc.Status = Convert.ToString(dr["Status"]);
                batchCalc.UserName = Convert.ToString(dr["UserName"]);

                batchlog.Add(batchCalc);
            }
            return batchlog;
        }

        public List<BatchCalculationMasterDataContract> GetBatchCalculationForEmailNotification(string UserID)
        {
            List<BatchCalculationMasterDataContract> batchlist = new List<BatchCalculationMasterDataContract>();

            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetBatchCalculationForEmailNotification", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {

                RequestFailureDataContract rfd = new RequestFailureDataContract();
                BatchCalculationMasterDataContract batchcalc = new BatchCalculationMasterDataContract();
                //batchlist.Add(new BatchCalculationMasterDataContract
                //{

                batchcalc.AnalysisID = new Guid(Convert.ToString(dr["AnalysisID"]));
                batchcalc.Name = Convert.ToString(dr["Name"]);
                batchcalc.BatchCalculationMasterID = CommonHelper.ToInt32(dr["BatchCalculationMasterID"]);
                if (Convert.ToString(dr["DealID"]) != "")
                {
                    rfd.DealID = new Guid(Convert.ToString(dr["DealID"]));
                }
                batchcalc.BatchCalculationMasterGUID = new Guid(Convert.ToString(dr["BatchCalculationMasterGUID"]));
                batchcalc.StartTime = CommonHelper.ToDateTime(dr["StartTime"]);
                batchcalc.EndTime = CommonHelper.ToDateTime(dr["EndTime"]);
                batchcalc.Total = CommonHelper.ToInt32(dr["Total"]);
                batchcalc.TotalCompleted = CommonHelper.ToInt32(dr["TotalCompleted"]);
                batchcalc.TotalFailed = CommonHelper.ToInt32(dr["TotalFailed"]);
                batchcalc.BatchType = Convert.ToString(dr["BatchType"]);

                batchcalc.UserID = new Guid(Convert.ToString(dr["UserID"]));
                batchcalc.Status = Convert.ToString(dr["Status"]);
                batchcalc.Email = Convert.ToString(dr["Email"]);
                batchcalc.UserName = Convert.ToString(dr["UserName"]);
                // });
            }
            return batchlist;
        }
        public void CreateBatchCalculationTag()
        {
            Helper.Helper hp = new Helper.Helper();
            hp.ExecuteScalar("dbo.usp_CreateBatchCalculationTag");
        }
        public CalculatorOutputJsonInfoDataContract GetCalculatorOutputJsonInfo(Guid? CalculationRequestID, Guid? NoteId, Guid? AnalysisID, Guid? UserID)
        {
            CalculatorOutputJsonInfoDataContract calcOutPut = new CalculatorOutputJsonInfoDataContract();

            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@CalculationRequestID", Value = CalculationRequestID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@NoteId", Value = NoteId };
            SqlParameter p3 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
            dt = hp.ExecDataTable("dbo.usp_GetCalculatorOutputJsonInfo", sqlparam);


            //  var lstnotes = dbContext.usp_GetCalculatorOutputJsonInfo(CalculationRequestID, NoteId, AnalysisID, UserID);
            foreach (DataRow dr in dt.Rows)
            {
                if (Convert.ToString(dr["CalculatorOutputJsonInfoID"]) != "")
                {
                    calcOutPut.CalculatorOutputJsonInfoID = new Guid(Convert.ToString(dr["CalculatorOutputJsonInfoID"]));
                }
                if (Convert.ToString(dr["CalculationRequestID"]) != "")
                {
                    calcOutPut.CalculationRequestID = new Guid(Convert.ToString(dr["CalculationRequestID"]));
                }
                if (Convert.ToString(dr["NoteId"]) != "")
                {
                    calcOutPut.NoteId = new Guid(Convert.ToString(dr["NoteId"]));
                }
                if (Convert.ToString(dr["AnalysisID"]) != "")
                {
                    calcOutPut.AnalysisID = new Guid(Convert.ToString(dr["AnalysisID"]));
                }
                calcOutPut.FileName = Convert.ToString(dr["FileName"]);
                calcOutPut.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                calcOutPut.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                calcOutPut.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                calcOutPut.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedBy"]);


            }
            return calcOutPut;
        }


        public int InsertCalculatorOutputJsonInfo(Guid? CalculationRequestID, Guid? NoteId, Guid? AnalysisID, Guid? UserID, String FileName, string FileType)
        {
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@CalculationRequestID", Value = CalculationRequestID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@NoteId", Value = NoteId };
            SqlParameter p3 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
            SqlParameter p4 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
            SqlParameter p5 = new SqlParameter { ParameterName = "@FileName", Value = FileName };
            SqlParameter p6 = new SqlParameter { ParameterName = "@FileType", Value = FileType };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };
            int result = hp.ExecNonquery("dbo.usp_InsertCalculatorOutputJsonInfo", sqlparam);
            //  return dbContext.usp_InsertCalculatorOutputJsonInfo(CalculationRequestID, NoteId, AnalysisID, UserID, FileName);
            return result;
        }

        public string DeleteBatchCalculationRequestByAnalysisID(string AnalysisID)
        {
            string status = "";
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, };
                hp.ExecDataTable("dbo.usp_DeleteBatchRequestByAnalysisID", sqlparam);
                status = "Records deleted";
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return status;
        }

        public void UpdateCalcStatusBYAnalysisIDAndType(string AnalysisID, string Type, Guid? UserID)
        {

            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Type", Value = Type };
                SqlParameter p3 = new SqlParameter { ParameterName = "@CreatedBy", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                hp.ExecDataTable("dbo.usp_UpdateCalcStatusBYAnalysisIDAndType", sqlparam);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable CancelBatchRequestByAnalysisID(string AnalysisID)
        {
            try
            {
                DataTable dt = new DataTable();

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, };
                dt = hp.ExecDataTable("dbo.usp_CancelBatchRequestByAnalysisID", sqlparam);
                return dt;

            }
            catch (Exception ex)
            {
                throw ex;
            }

            //return status;
        }

        public void UpdateBatchDetailWhenCancel(string AnalysisID)
        {            
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, };
                hp.ExecuteScalar("dbo.usp_UpdateBatchDetailWhenCancel", sqlparam);
                 
            }
            catch (Exception ex)
            {
                throw ex;
            }           
        }

        public DataTable GetCurrentoffsetbyuserID(Guid? UserID)
        {
            DataTable dt = new DataTable();
            string result;

            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, };
                dt = hp.ExecDataTable("dbo.usp_GetCurrentOffsetByUserID", sqlparam);
            }
            catch (Exception ex)
            {
            }

            return dt;
        }

        public List<CalculationManagerDataContract> GetAllFailedCalculationNote()
        {
            List<CalculationManagerDataContract> noteslist = new List<CalculationManagerDataContract>();
            //var lstnotes = dbContext.usp_GetAllFailedCalculationNote();

            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            dt = hp.ExecDataTable("dbo.usp_GetAllFailedCalculationNote");


            foreach (DataRow dr in dt.Rows)
            {
                //    foreach (usp_GetAllFailedCalculationNote_Result _calclist in lstnotes)
                //{
                CalculationManagerDataContract md = new CalculationManagerDataContract();
                md.NoteId = Convert.ToString(dr["NoteId"]);
                md.NoteName = Convert.ToString(dr["Name"]);
                md.RequestTime = CommonHelper.ToDateTime(dr["RequestTime"]);
                md.StatusID = CommonHelper.ToInt32(dr["StatusID"]);

                md.UserName = Convert.ToString(dr["UserName"]);
                md.ApplicationID = CommonHelper.ToInt32(dr["ApplicationID"]);
                //     md.ApplicationText = _calclist.ApplicationText;
                md.StartTime = CommonHelper.ToDateTime(dr["StartTime"]);
                md.EndTime = CommonHelper.ToDateTime(dr["EndTime"]);
                md.PriorityID = CommonHelper.ToInt32(dr["PriorityID"]);
                //    md.PriorityText = _calclist.PriorityText;
                md.ErrorMessage = Convert.ToString(dr["ErrorMessage"]);
                md.ErrorDetails = Convert.ToString(dr["ErrorDetails"]);
                //  md.DealName = _calclist.DealName;
                md.CRENoteID = Convert.ToString(dr["CRENoteID"]);
                noteslist.Add(md);
            }
            return noteslist;
        }

        public DataTable GetTransactionCategory(Guid? UserID)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, };
                dt = hp.ExecDataTable("dbo.usp_GetTransactionCategory", sqlparam);
            }
            catch (Exception ex)
            {

            }

            return dt;
        }

        public DataTable GetTransactionGroup(Guid? UserID)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                dt = hp.ExecDataTable("dbo.usp_GetTransactionGroup", sqlparam);
            }
            catch (Exception ex)
            {

            }

            return dt;
        }
        public void InsertUpdatedNoteWiseEndingBalance(Guid NoteID, Guid? UserID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = NoteID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                hp.ExecNonquery("dbo.usp_InsertUpdatedNoteWiseEndingBalance", sqlparam);
            }
            catch (Exception ex)
            {

            }
        }
        public void CalcNetCapitalInvestedbyNoteId(string NoteID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = NoteID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                hp.ExecNonquery("dbo.usp_CalcNetCapitalInvestedbyNoteId", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertExceptionsOfCalculatorComponent(Guid? NoteId, Guid? AnalysisID, string UserID)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteID", Value = NoteId };
                SqlParameter p2 = new SqlParameter { ParameterName = "@AnalysisID", Value = AnalysisID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                hp.ExecNonquery("dbo.usp_InsertExceptionsOfCalculatorComponent", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}