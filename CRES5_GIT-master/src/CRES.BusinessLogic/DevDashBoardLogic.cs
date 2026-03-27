using CRES.DAL;
using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
       
        public DataTable GetErrorLogs()
        {
            return devdrepo.GetErrorLogs();
        }

        public DataTable GetLogsForDownloadExcel(string objectID)
        {
            return devdrepo.GetLogsForDownloadExcel(objectID);
        }

        public DataTable GetCalculationSummary()
        {
            return devdrepo.GetCalculationSummary();
        }

        public DataTable ShowUserSummary()
        {
            return devdrepo.ShowUserSummary();
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

        public DataTable GetErrorForEmail() 
        {
            return devdrepo.GetErrorForEmail();
        }
        public List<DevDashBoardDataContract> GetXIRRStatusSummaryfordevdash()
        {
            return devdrepo.GetXIRRStatusSummaryfordevdash();
        }

        public List<DevDashBoardDataContract> GetCalculationStatusForValuationDashBoard() 
        {
            return devdrepo.GetCalculationStatusForValuationDashBoard();
        }

        public List<EnvConfigDataContract> GetEnvConfig()
        {
            return devdrepo.GetEnvConfig();
        }
        public string CheckEnvConnection(EnvConfigDataContract selectedEnvConfig)
        {
            return devdrepo.CheckEnvConnection(selectedEnvConfig);
        }
        public string ImportDealFromOtherSource(EnvConfigDataContract selectedEnvConfig,string UpdatedBy)
        {
            return devdrepo.ImportDealFromOtherSource(selectedEnvConfig, UpdatedBy);
        }

        public DataTable GetValuationLogsForDownloadExcel()
        {
            return devdrepo.GetValuationLogsForDownloadExcel();
        }

        public DataTable GetValuationCalculationSummary()
        {
            return devdrepo.GetValuationCalculationSummary();
        }

        public void CalculateMultipleDeals(string noteids, string ScenarioID)
        {
            devdrepo.CalculateMultipleDeals(noteids, ScenarioID);
        }
    }
}
