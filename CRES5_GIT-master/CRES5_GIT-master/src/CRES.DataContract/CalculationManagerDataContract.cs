using System;

namespace CRES.DataContract
{
    public class CalculationManagerDataContract
    {
        public Guid CalculationRequestID { get; set; }
        public string NoteId { get; set; }
        public string NoteName { get; set; }
        public DateTime? RequestTime { get; set; }
        public int? StatusID { get; set; }
        public string StatusText { get; set; }
        public string UserName { get; set; }
        public int? ApplicationID { get; set; }
        public string ApplicationText { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public int? PriorityID { get; set; }
        public string PriorityText { get; set; }
        public string ErrorMessage { get; set; }
        public string ErrorDetails { get; set; }
        public bool Active { get; set; }
        public string DealName { get; set; }

        public string CRENoteID { get; set; }

        public Guid? AnalysisID { get; set; }
        public Guid PortfolioMasterGuid { get; set; }

        public int? CalculationModeID { get; set; }
        public object CalculationModeText { get; set; }
        public string BatchType { get; set; }
        public string FileName { get; set; }
        public int? CollectCalculatorLog { get; set; }

        public int? EnableM61Calculations { get; set; }
        public string EnableM61CalculationsText { get; set; }

        public bool downloadnote { get; set; }
        public DateTime? PayOffDate { get; set; }
        public Boolean? IsPaidOffDeal { get; set; }
        public int? CalcType { get; set; }

    }
}