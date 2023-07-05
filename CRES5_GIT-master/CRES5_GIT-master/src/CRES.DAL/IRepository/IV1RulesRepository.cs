
using System.Data;

namespace CRES.DAL.IRepository
{
    public interface IV1RulesRepository
    {
        void InsertUpdateRuleTypeData(DataTable rulesdata, string CreatedBy);
    }
}
