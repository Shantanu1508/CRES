using System;

namespace CRES.DataContract
{
    public class CalculatorOutputJsonInfoDataContract
    {
        public Guid? CalculatorOutputJsonInfoID { get; set; }
        public Guid? CalculationRequestID { get; set; }
        public Guid? NoteId { get; set; }
        public Guid? AnalysisID { get; set; }
        public string FileName { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }


    }
}
