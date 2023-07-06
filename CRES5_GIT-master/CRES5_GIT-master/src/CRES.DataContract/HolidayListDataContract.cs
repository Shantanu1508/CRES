using System;

namespace CRES.DataContract
{
    public class HolidayListDataContract
    {

        public DateTime? HolidayDate { get; set; }
        public int HolidayTypeID { get; set; }
        public string HolidayTypeText { get; set; }

    }
}
