using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class DailyInterestAccrualsDataContract
    {

        public string NoteID { get; set; }
        public DateTime? Date { get; set; }
        public decimal DailyInterestAccrual { get; set; }
        public decimal EndingBalance { get; set; }
        public Guid? AnalysisID { get; set; }

        public decimal SpreadOrRate { get; set; }
        public decimal IndexRate { get; set; }
        public decimal AllInCouponRate { get; set; }
        public decimal AllInPikRate { get; set; }       
        public decimal PikSpreadOrRate { get; set; }
        public decimal PIKIndexRate { get; set; }
      



    }
}
