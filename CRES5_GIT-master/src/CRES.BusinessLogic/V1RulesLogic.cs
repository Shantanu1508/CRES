using CRES.DAL.Repository;
using System.Data;

namespace CRES.BusinessLogic
{

    public class V1RulesLogic
    {
        V1RulesRepository rulesrepo = new V1RulesRepository();

        public void InsertUpdateRuleTypeData(DataTable rulesdata, string CreatedBy)
        {
            rulesrepo.InsertUpdateRuleTypeData(rulesdata, CreatedBy);
        }
    }
}
