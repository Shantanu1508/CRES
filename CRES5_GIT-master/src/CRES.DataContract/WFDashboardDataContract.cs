using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class WFDashboardDataContract
    {
        public Guid? UserID { get; set; }
        public string TaskID { get; set; }
        public int? TaskTypeID { get; set; }
    }
}
