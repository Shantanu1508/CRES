using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class IndexConfiguration
    {

        public IndexConfiguration()
        {

        }
        public void SetIndexConfiguration(DateTime effdt, DateTime startdt, string strIndexName, string strHolidayCalendar)
        {
            this.EffectiveDate = effdt;
            this.StartDate = startdt;
            this.IndexName = strIndexName;
            this.HolidayCalendar = strHolidayCalendar;
        }
        public DateTime? EffectiveDate { get; set; }
        public DateTime? StartDate { get; set; }
        public string IndexName { get; set; }
        public string HolidayCalendar { get; set; }
    }
}
