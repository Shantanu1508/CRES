using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class WFStatusDataContract
    {
       public int? WFStatusMasterID { get; set; }
       public string StatusName { get; set; }
        public string StatusDisplayName { get; set; }
        public int? OrderIndex { get; set; }
        public int? WFTaskDetailID { get; set; }
        public string TaskID { get; set; }
        public int WFStatusPurposeMappingID { get; set; }

    }
}
