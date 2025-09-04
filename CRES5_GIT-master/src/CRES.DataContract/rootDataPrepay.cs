using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{

    public class rootDataPrepay
    {
        public string period_start_date { get; set; }
        public string[] effective_dates { get; set; }
        public string period_end_date { get; set; }
        public string root_note_id { get; set; } 
        public dynamic notes { get; set; }      
    

    }
}

