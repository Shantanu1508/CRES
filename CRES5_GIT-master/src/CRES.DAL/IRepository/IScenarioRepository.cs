using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DAL.IRepository
{
    public interface IScenarioRepository
    {
        List<ScenarioParameterDataContract> GetAllScenario(string userid, int pageIndex, int pageSize, out int? TotalCount);

        ScenarioParameterDataContract GetScenarioParameterByScenarioID(string scenarioID, Guid userID);

        string InsertUpdateScenario(ScenarioParameterDataContract Scenaridc);
        void UpdateScenarioToInactive(string id);     
        bool CheckDuplicateScenarioName(string id, string name);
        ScenarioParameterDataContract GetActiveScenarioParameters(Guid? AnalysisID);
        void InsertActivityLogDetail(DataTable ActivityLogDetail);
    }
}
