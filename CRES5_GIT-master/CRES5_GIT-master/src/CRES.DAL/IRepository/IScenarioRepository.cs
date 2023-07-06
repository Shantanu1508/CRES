using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.DAL.IRepository
{
    public interface IScenarioRepository
    {
        List<ScenarioParameterDataContract> GetAllScenario(string userid, int pageIndex, int pageSize, out int? TotalCount);

        ScenarioParameterDataContract GetScenarioParameterByScenarioID(string scenarioID);

        string InsertUpdateScenario(ScenarioParameterDataContract Scenaridc);
        void UpdateScenarioToInactive(string id);
        void ResetDefaultToActiveScenario(string username);
        bool CheckDuplicateScenarioName(string id, string name);
        ScenarioParameterDataContract GetActiveScenarioParameters(Guid? AnalysisID);
    }
}
