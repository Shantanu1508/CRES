using CRES.DataContract;
using System.Collections.Generic;
using CRES.DAL.Repository;
using System.Data;
using System;

namespace CRES.BusinessLogic
{
    public class ScenarioLogic
    {
        private ScenarioRepository _ScenarioRepository = new ScenarioRepository();

        public List<ScenarioParameterDataContract> GetAllScenario(string userid, int pageIndex, int pageSize, out int? TotalCount)
        {
            List<ScenarioParameterDataContract> list = new List<ScenarioParameterDataContract>();

            list = _ScenarioRepository.GetAllScenario(userid, pageIndex, pageSize, out TotalCount);

            return list;
        }

        public ScenarioParameterDataContract GetScenarioParameterByScenarioID(string scenarioID, Guid userID)
        {
            return _ScenarioRepository.GetScenarioParameterByScenarioID(scenarioID, userID);
        }

        public string InsertUpdateScenario(ScenarioParameterDataContract Scenaridc)
        {
            return _ScenarioRepository.InsertUpdateScenario(Scenaridc);
        }

        public void UpdateScenarioToInactive(string id)
        {
            _ScenarioRepository.UpdateScenarioToInactive(id);
        }
        public DataTable GetIndexByScenarioID(string headerUserID, string scenarioID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            return _ScenarioRepository.GetIndexByScenarioID(headerUserID, scenarioID, pageIndex, pageSize, out TotalCount);
        }


        public DataTable GetIndexesFromDate(ScenariosearchDataContract _ScenariosearchDc, string headerUserID, out int? TotalCount)
        {

            return _ScenarioRepository.GetIndexesFromDate(_ScenariosearchDc, headerUserID, out TotalCount);

        }

        public DataTable GetIndexesExportData(ScenariosearchDataContract _ScenariosearchDc, string headerUserID, out int? TotalCount)
        {
            return _ScenarioRepository.GetIndexesExportData(_ScenariosearchDc, headerUserID, out TotalCount);
        }        

        public bool CheckDuplicateScenarioName(string id, string name)
        {
            return _ScenarioRepository.CheckDuplicateScenarioName(id, name);
        }




        public ScenarioParameterDataContract GetActiveScenarioParameters(System.Guid? AnalysisID)
        {
            return _ScenarioRepository.GetActiveScenarioParameters(AnalysisID);
        }

        public string InsertUpdateScenarioUserMap(ScenarioUserMapDataContract Scenaridc)
        {
            return _ScenarioRepository.InsertUpdateScenarioUserMap(Scenaridc);
        }

        public ScenarioUserMapDataContract GetScenarioUserMapByUserID(string UserID)
        {
            return _ScenarioRepository.GetScenarioUserMapByUserID(UserID);
        }


        public List<ScenarioUserMapDataContract> GetAllScenarioDistinct(string userid)
        {
            List<ScenarioUserMapDataContract> list = new List<ScenarioUserMapDataContract>();

            list = _ScenarioRepository.GetAllScenarioDistinct(userid);

            return list;
        }



        public DataTable GetScenarioDownload(ScenariosearchDataContract _ScenariosearchDc, string headerUserID, out int? TotalCount)
        {
            return _ScenarioRepository.GetScenarioDownload(_ScenariosearchDc, headerUserID, out TotalCount);
        }

        public DataTable DownloadCashFlowByScenarioID(string AnalysisID)
        {
            return _ScenarioRepository.DownloadCashFlowByScenarioID(AnalysisID);
        }


        public List<ScenarioruletypeDataContract> GetAllRuleType(Guid? headerUserID)
        {
            return _ScenarioRepository.GetAllRuleType(headerUserID);
        }

        public List<ScenarioruletypeDataContract> GetAllRuleTypeDetail(Guid? headerUserID)
        {
            return _ScenarioRepository.GetAllRuleTypeDetail(headerUserID);
        }


        public List<ScenarioruletypeDataContract> GetRuleTypeSetupbyObjectId(string Id)
        {
            List<ScenarioruletypeDataContract> _scenarioDC = new List<ScenarioruletypeDataContract>();
            _scenarioDC = _ScenarioRepository.GetRuleTypeSetupbyObjectId(Id);
            return _scenarioDC;
        }

        public String AddUpdateAnalysisRuleTypeSetup(List<ScenarioruletypeDataContract> scenarioDC, string headerUserID)

        {
            return _ScenarioRepository.AddUpdateAnalysisRuleTypeSetup(scenarioDC, headerUserID);
        }

        public string deleteScenariobyAnalysisID(string scenarioID, string headerUserID)
        {
            return _ScenarioRepository.deleteScenariobyAnalysisID(scenarioID, headerUserID);
        }
        public void InsertActivityLogDetail(DataTable ActivityLogDetail)
        {
            _ScenarioRepository.InsertActivityLogDetail(ActivityLogDetail);
        }
    }
}