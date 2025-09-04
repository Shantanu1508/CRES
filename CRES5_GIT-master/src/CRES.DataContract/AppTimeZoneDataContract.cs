using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public class AppTimeZoneDataContract
    {
        public Guid? UserID { get; set; }
        public int TimeZoneID { get; set; }
        public string Name { get; set; }
        public string current_utc_offset { get; set; }
        public int is_currently_dst { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string search { get; set; }
        public int ValueID { get; set; }
        public string Valuekey { get; set; }
        public string Abbreviation { get; set; }
    }
}
