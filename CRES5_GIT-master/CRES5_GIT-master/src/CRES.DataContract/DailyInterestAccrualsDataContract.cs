using System;

namespace CRES.DataContract
{
    public class DailyInterestAccrualsDataContract
    {

        public string NoteID { get; set; }
        public DateTime? Date { get; set; }
        public decimal DailyInterestAccrual { get; set; }
        public decimal EndingBalance { get; set; }
        public Guid? AnalysisID { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedDate { get; set; }

    }
}
