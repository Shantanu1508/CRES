using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class HolidayListDataContract
    {

        public DateTime? HolidayDate { get; set; }
        public int HolidayTypeID { get; set; }
        public string HolidayTypeText { get; set; }
        public string HolidayType { get; set; }
        public int? IsSoftHoliday { get; set; }
    }
}
