using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class LookupMasterDataContract
    {
        public int LookupID { get; set; }        
        public string Name { get; set; }
        public string Description { get; set; }
        public int SortOrder { get; set; }
        public string ddlType { get; set; }
    }
}
