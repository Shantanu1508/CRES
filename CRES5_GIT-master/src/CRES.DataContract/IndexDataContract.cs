using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public  class IndexDataContract
    {
        public List<IndexScheduleDataContract> Libor { get; set; }
        public List<IndexScheduleDataContract> SOFR { get; set; }
    }
}
