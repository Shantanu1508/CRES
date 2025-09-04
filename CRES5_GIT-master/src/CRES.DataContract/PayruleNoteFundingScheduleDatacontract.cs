using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public class PayruleNoteFundingScheduleDatacontract
    {


        public Guid? NoteID { get; set; }
        public Decimal? Value { get; set; }
        public DateTime Date { get; set; }

        public Guid? DealID { get; set; }
 
    }
}
