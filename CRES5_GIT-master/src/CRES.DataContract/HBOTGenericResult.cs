using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class HBOTGenericResult
    {
        public bool Succeeded { get; set; }
        public string Message { get; set; }

        public string SingleResult { get; set; }

        public DataTable Listdt { get; set; }
        public List<SearchDataContract> lstSearch { get; set; }
        public List<lstOfEntity> lstOFEntity { get; set; }
    }

    public class lstOfEntity
    {
        public string entity_type { get; set; }
        public Dictionary<string, ArrayList> entity_names { get; set; }

    }
}
