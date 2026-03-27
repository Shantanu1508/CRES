using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;

namespace CRES.DAL
{
   public interface ILookupRepository
    {
        List<LookupDataContract> GetAllLookup(string lookupsIDs);
    }
}
