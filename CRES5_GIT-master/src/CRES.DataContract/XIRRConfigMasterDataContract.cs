using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class XIRRConfigMasterDataContract
    {
        public List<XIRRConfigDataContract> ListXirrConfig { get; set; }
        public List<XIRRConfigFilterDataContract> ListXirrConfigFilter { get; set;}
        public List<int> deletedXIRRConfig { get; set; }
    }
}
