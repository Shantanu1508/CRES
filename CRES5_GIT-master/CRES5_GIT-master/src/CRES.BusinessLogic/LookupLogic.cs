using CRES.DAL.Repository;
using CRES.DataContract;
using System.Collections.Generic;

namespace CRES.BusinessLogic
{
    public class LookupLogic
    {
        public List<LookupDataContract> GetAllLookups(string lookupsID)
        {
            LookupRepository _lookupRepository = new LookupRepository();
            return _lookupRepository.GetAllLookup(lookupsID);
        }
    }
}
