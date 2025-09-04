using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.DAL.IRepository
{
    public interface IDevDashBoardRepository
    {
        List<DevDashBoardDataContract> GetCalculationStaus(Guid analysisID);
        List<DevDashBoardDataContract> GetFailedNotes(string logtype, Guid UserID);
        List<DevDashBoardDataContract> UserRequestCount(Guid analysisID); 
        DataTable GetNoteIDAndAnalysisID(string crenoteid);

      //  DataTable GetDatabaseStatus(string currenttime,Guid UserID);
        void CalculateMultipleNotes(string multuplenotes, string AnalysisID);
        void CalcAllNotes(string AnalysisID, string username);
      //  List<DevDashBoardDataContract> CheckWorkflowStatus(string workflowtext);
        DataTable GetErrorLogs();
        DataTable ShowUserSummary();
        DataTable GetErrorForEmail();
        List<DevDashBoardDataContract> GetXIRRStatusSummaryfordevdash();
        List<DevDashBoardDataContract> GetCalculationStatusForValuationDashBoard();
        List<EnvConfigDataContract> GetEnvConfig();
        string CheckEnvConnection(EnvConfigDataContract selectedEnvConfig);
        string ImportDealFromOtherSource(EnvConfigDataContract selectedEnvConfig, string UpdatedBy);

        public void CalculateMultipleDeals(string multupledeals, string AnalysisID);
    }
}