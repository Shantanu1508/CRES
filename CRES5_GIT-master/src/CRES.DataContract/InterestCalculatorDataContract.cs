using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class InterestCalculatorDataContract
    {
        public InterestCalculatorDataContract()
        {

        }
      
        public Guid? NoteID { get; set; }
        public DateTime? AccrualStartDate { get; set; }
        public DateTime? AccrualEndDate { get; set; }
        public DateTime? PaymentDate { get; set; }
        public decimal? BeginningBalance { get; set; }
        public Guid? AnalysisID { get; set; }
    }
}
