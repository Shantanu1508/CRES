using CRES.DataContract;
using System.Collections.Generic;

namespace CRES.DAL
{
    public interface ILookupRepository
    {
        List<LookupDataContract> GetAllLookup(string lookupsIDs);
    }
}
