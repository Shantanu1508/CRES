using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DAL.Repository;
using CRES.DataContract;

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
