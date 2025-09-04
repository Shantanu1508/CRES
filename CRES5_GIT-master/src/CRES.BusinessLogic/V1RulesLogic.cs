using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using CRES.DAL.Repository;
using CRES.DataContract;

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
