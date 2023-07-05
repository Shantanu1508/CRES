using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.BusinessLogic
{
    public class DevDashBoardLogic
    {
        DevDashBoardRepository devdrepo = new DevDashBoardRepository();

        public List<DevDashBoardDataContract> GetCalculationStaus(Guid analysisID)
        {
            return devdrepo.GetCalculationStaus(analysisID);
        }

        public List<DevDashBoardDataContract> GetFailedNotes(string LogType, Guid UserID)
        {
            return devdrepo.GetFailedNotes(LogType, UserID);
        }

        public List<DevDashBoardDataContract> UserRequestCount(Guid analysisID)
        {
            return devdrepo.UserRequestCount(analysisID);
        }

        public List<DevDashBoardDataContract> GetFastestandSlowest(Guid analysisID)
        {
            return devdrepo.GetFastestandSlowest(analysisID);
        }

        public DataTable GetNoteIDAndAnalysisID(string crenoteid)
        {
            return devdrepo.GetNoteIDAndAnalysisID(crenoteid);
        }

        public DataTable GetDatabaseStatus(string currenttime, Guid UserID)
        {
            return devdrepo.GetDatabaseStatus(currenttime, UserID);
        }

        public void CalculateMultipleNotes(string noteids, string ScenarioID)
        {
            devdrepo.CalculateMultipleNotes(noteids, ScenarioID);
        }


        public void CalcAllNotes(string AnalysisID, string username)
        {
            devdrepo.CalcAllNotes(AnalysisID, username);
        }
        public List<DevDashBoardDataContract> GetAIDashBoardData()
        {
            return devdrepo.GetAIDashBoardData();
        }

        public DataTable GetErrorLogs()
        {
            return devdrepo.GetErrorLogs();
        }

        public DataTable ShowUserSummary()
        {
            return devdrepo.ShowUserSummary();
        }

        public List<DevDashBoardDataContract> GetAIUserData(string username)
        {
            return devdrepo.GetAIUserData(username);
        }

        public void ImportStagingData()
        {
            devdrepo.ImportStagingData();
        }
        public string GetImportStagingDataStatus()
        {
            return devdrepo.GetImportStagingDataStatus();
        }

        public DataTable GetStagingDataIntoIntegrationStatus()
        {
            return devdrepo.GetStagingDataIntoIntegrationStatus();
        }
    }
}
